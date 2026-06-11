---
name: ticket
description: >
  Crea en Jira el ticket asociado al cambio en curso usando el MCP de
  Atlassian. Úsala cuando el usuario diga "/ticket", "abre el ticket de esto",
  "crea el ticket de este cambio" o quiera abrir un ticket nuevo. Deriva el
  contenido del contexto de la sesión y de los cambios pendientes, y solo
  pregunta lo que no pueda deducir.
---

**Info**
```
cloudId: 067e6789-c624-4d93-8e50-fb6f31d8130e
```

## 0. Resolver equipo

Leer el equipo del usuario de su contexto personal (`~/.claude/CLAUDE.md`):
- Infraestructura → projectKey `TIF`, projectId `13761`
- Sistemas → projectKey `TS`, projectId `13530`

Si no está definido, preguntar una vez: "¿Eres de Infraestructura (TIF) o de Sistemas (TS)?"

## 1. Reunir contexto del cambio

El ticket describe el cambio en el que se está trabajando. Antes de preguntar nada, deducir todo lo posible de estas fuentes, por orden:

1. La conversación actual: qué se está haciendo y por qué.
2. El plan de la tarea si existe (el plan aprobado en la sesión o el más reciente de `docs/plans/`).
3. Los cambios pendientes: `git diff` del working tree y `git diff <default-branch>...HEAD`, más `git log` de la rama si ya hay commits.

Con eso, construir un borrador con estas secciones:
- **Contexto**: problema, razón o motivación del cambio.
- **Alcance**: qué incluye y, si aplica, qué excluye.
- **Plan de implementación**: cómo se lleva a cabo (redactado como plan ejecutable por una IA).

Solo preguntar al usuario (en un único batch con `AskUserQuestion`) lo que no se pueda deducir de las fuentes anteriores: típicamente la motivación de negocio, el tipo de incidencia si es ambiguo, el `parent` si parece una subtarea, o la fecha límite. No preguntar lo que el diff o la conversación ya responden.

Si no hay ningún cambio en curso (sesión recién abierta, sin diff ni plan), hacer la entrevista clásica, una pregunta por vez: qué se va a hacer, por qué, y cómo.

## 2. Confirmar antes de crear

Mostrar al usuario el ticket propuesto (tipo, título y descripción completa) y pedir confirmación antes de llamar al MCP. El título debe ser corto y accionable, en castellano, sin prefijos tipo "feat:".

## 3. Crear la incidencia

Tipos de incidencia válidos (usar exactamente este nombre):
- `Tarea` — trabajo planificado independiente.
- `Epic` — colección de tareas/historias.
- `Subtarea` — trabajo pequeño dentro de una tarea.
- `Cambio` — cambio en infraestructura o servicio.
- `Incidencia` — incidente o problema en producción.
- `Solicitud` — petición de recurso o acceso.

Llamar a `mcp__claude_ai_Atlassian__createJiraIssue` con:

```json
{
  "cloudId": "067e6789-c624-4d93-8e50-fb6f31d8130e",
  "projectKey": "<projectKey>",
  "issueTypeName": "<tipo>",
  "summary": "<titulo>",
  "description": "<descripcion con secciones Contexto / Alcance / Plan de implementación>",
  "additional_fields": {
    "duedate": "<YYYY-MM-DD>",
    "parent": {"key": "<PROJ-XXX>"}
  }
}
```

Omitir los `additional_fields` que no apliquen.

## 4. Devolver resultado

Tras crearlo, devolver la clave del ticket (ej. `TIF-123`) con su enlace, y sugerir referenciarla en la rama o en el commit del cambio.
