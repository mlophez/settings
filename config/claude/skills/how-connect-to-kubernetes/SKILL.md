---
name: how-connect-to-kubernetes
description: Mapeo de contextos kubectl a clusters de Logalty y reglas de uso. Úsala siempre que vayas a ejecutar un comando kubectl o necesites saber qué cluster está detrás de un contexto.
user-invocable: false
---

Para conectarse a los clusters de Kubernetes de Logalty usar `kubectl --context <ctx>` explícitamente.

## Clusters disponibles

- `dev` → cluster `development` — Entorno de desarrollo.
- `test` / `testing` → cluster `development` — Entorno de QA (mismo cluster que dev).
- `demo` → cluster `demo` — Demo general para el equipo de sistemas.
- `demosign` → cluster `demo` — Demo de variantes de PostgreSQL (mismo cluster que demo).
- `prod` → cluster `production` — Producción — España.
- `secure` → cluster `secure` — Producción — Irlanda.
- `tools` → cluster `tools` — Herramientas internas de la compañía.
- `cet` / `cetelem` → cluster `cetelem` — Entorno dedicado para el cliente Cetelem.

## Reglas de uso

- Siempre `kubectl --context <ctx>` explícito. Nunca el contexto actual implícito ni `$KUBECTL_CONTEXT`.
- `prod` y `secure` requieren confirmación explícita del usuario para cualquier operación mutante (`apply`, `delete`, `edit`, `scale`, `rollout restart`).
- Si se detecta un contexto no listado aquí, preguntar a Miguel para que lo describa y añadirlo a este archivo.
