---
name: apply
description: >
  Aplica los cambios en curso de un proyecto con el comando correcto según la tecnología
  (kubectl apply, terraform/terragrunt apply, helm, kustomize, docker compose). Úsala
  cuando el usuario invoque `/apply`. Detecta la tecnología desde los cambios pendientes
  (git status/diff) y la carpeta actual, aplica solo lo modificado, y siempre muestra
  plan/diff y pide confirmación antes de mutar.
disable-model-invocation: true
---

# `/apply` — aplica los cambios en curso

Esta skill aplica lo que tienes pendiente de aplicar en el proyecto actual. No aplica el
directorio entero: aplica **solo lo que has modificado**, con el comando correcto para
cada tecnología.

El patrón es siempre el mismo: inspeccionar el cambio → mostrar plan o diff → pedir
confirmación → aplicar.

---

## 0. Qué se va a aplicar

Antes de hacer nada, lee el estado del repositorio:

```bash
git status --short      # qué ficheros han cambiado
git diff                # qué ha cambiado exactamente
git diff --staged       # cambios ya en el stage
```

El alcance del apply es **solo lo que aparece en ese diff**. Nunca apliques el directorio
entero por defecto; si el usuario quiere aplicar todo, que lo diga explícitamente.

Si no hay cambios pendientes, dilo y para. No hay nada que aplicar.

---

## 1. Detección de tecnología

Detecta la tecnología combinando los ficheros marcador de la carpeta actual (y niveles
superiores si no encuentras nada) con los ficheros que han cambiado en el diff. Usa este
orden de prioridad; la **primera regla que case gana**:

1. `terragrunt.hcl` presente en el cwd o en algún directorio padre → **Terragrunt (flujo de empresa)**.
2. Ficheros `*.tf` cambiados sin `terragrunt.hcl` → **Terraform genérico**.
3. `Chart.yaml` presente en el cwd → **Helm**.
4. `kustomization.yaml` o `kustomization.yml` presente en el cwd → **Kustomize**.
5. `docker-compose.yml`, `docker-compose.yaml`, `compose.yaml` o `compose.yml` → **Docker Compose**.
6. Ficheros `*.yaml`/`*.yml` cambiados que contienen `apiVersion:` y `kind:` → **Kubernetes (kubectl)**.

Si ninguna regla casa, o si casarían varias de forma ambigua, di qué has detectado y
pregunta una vez al usuario antes de continuar.

Di siempre qué tecnología has detectado al inicio de la respuesta.

---

## 2. Flujo por tecnología

### Kubernetes (`kubectl`)

1. Determina el contexto kubectl consultando la skill `how-connect-to-kubernetes`. Nunca
   uses el contexto implícito ni asumas uno.

2. Lista los manifiestos (`*.yaml`/`*.yml`) que han cambiado en el diff.

3. Muestra el diff antes de aplicar:
   ```bash
   kubectl --context <ctx> diff -f <manifest1> [-f <manifest2> ...]
   ```

4. Pide confirmación. Si el contexto es `prod` o `secure`, indica explícitamente que es
   producción y pide una confirmación adicional.

5. Tras confirmar:
   ```bash
   kubectl --context <ctx> apply -f <manifest1> [-f <manifest2> ...]
   ```

---

### Terragrunt (flujo de empresa)

Este flujo tiene una configuración específica de empresa que se aparta de la regla global
de ignorar `AWS_PROFILE=tools`. Aquí ese profile **es el correcto y debe usarse**.

1. Sitúate en la carpeta del módulo que contiene el `terragrunt.hcl`:
   ```bash
   cd <carpeta-del-módulo>
   export AWS_PROFILE=tools
   ```

2. Deriva los `-target` desde el diff (ver sección "Derivar `-target`" más abajo).

3. Muestra el plan antes de aplicar:
   ```bash
   terragrunt plan -target=<addr> [-target=<addr> ...]
   ```

4. Pide confirmación.

5. Tras confirmar:
   ```bash
   terragrunt apply -target=<addr> [-target=<addr> ...]
   ```

Si no puedes derivar los `-target` con fiabilidad, pregunta al usuario los addresses
antes de continuar (ver casos problemáticos en la sección siguiente).

#### Derivar `-target` desde el diff

Lista los `.tf` que han cambiado (staged y unstaged):
```bash
git diff --name-only -- '*.tf'
git diff --staged --name-only -- '*.tf'
```

Para cada fichero cambiado, lee el hunk del diff (`git diff -- <file>`) e identifica
los bloques `resource` y `module` cuyas líneas aparecen dentro del hunk:

- `resource "aws_s3_bucket" "logs" { ... }` → `-target=aws_s3_bucket.logs`
- `module "network" { ... }` → `-target=module.network`

Elimina duplicados y construye un `-target` por cada address encontrado.

**Casos en los que NO se puede derivar con fiabilidad — pregunta al usuario:**

- El cambio solo toca bloques `variable`, `locals`, `output` o `provider` (no hay
  address de recurso o módulo).
- El cambio afecta a tantos recursos que aplicar con `-target` sería incompleto o
  engañoso.
- Las líneas modificadas están dentro de un bloque que no reconoces como `resource` o
  `module`.

---

### Terraform genérico

1. Muestra el plan:
   ```bash
   terraform plan
   ```

2. Pide confirmación.

3. Tras confirmar:
   ```bash
   terraform apply
   ```

No fuerces `-target` en este flujo salvo que el usuario lo pida explícitamente.

---

### Helm

Necesitas saber el nombre del release, el chart y el namespace. Si no están claros por
el contexto, pregunta antes de continuar.

1. Previsualiza con dry-run:
   ```bash
   helm upgrade --install <release> <chart> -n <namespace> --kube-context <ctx> --dry-run
   ```

2. Pide confirmación.

3. Tras confirmar:
   ```bash
   helm upgrade --install <release> <chart> -n <namespace> --kube-context <ctx>
   ```

---

### Kustomize

1. Muestra el diff:
   ```bash
   kubectl --context <ctx> diff -k <directorio>
   ```

2. Pide confirmación.

3. Tras confirmar:
   ```bash
   kubectl --context <ctx> apply -k <directorio>
   ```

---

### Docker Compose

1. Valida la configuración:
   ```bash
   docker compose config
   ```

2. Pide confirmación.

3. Tras confirmar:
   ```bash
   docker compose up -d
   ```

---

## 3. Seguridad

- **Muestra siempre el plan o diff antes de aplicar.** Sin excepción.
- **Pide confirmación antes de cualquier operación mutante.** Sin excepción.
- Los clusters `prod` y `secure` requieren una confirmación explícita adicional (indica
  claramente que es producción antes de pedirla).
- Aplica solo lo que está en el diff. Nunca el directorio entero sin que el usuario lo
  haya pedido expresamente.
- Si un comando falla, para y reporta el error completo. No reintentes a ciegas ni
  cambies de tecnología por tu cuenta.
