---
name: read-jira-ticket
description: >
  Obtiene la información completa de un ticket de Jira (descripción, estado, asignado, comentarios y enlaces) usando el MCP de Atlassian. Úsala siempre que el usuario indique que va a trabajar en un ticket concreto (ej. "estoy trabajando en TIF-47", "voy a por el TS-11") o pida leer/consultar un ticket de Jira.
---

**Info**
```
cloudId: 067e6789-c624-4d93-8e50-fb6f31d8130e
```

## 0. Resolver equipo

Leer el equipo del usuario de su contexto personal (`~/.claude/CLAUDE.md`).

| Equipo              | projectKey por defecto |
|---------------------|------------------------|
| Infraestructura     | `TIF`                  |
| Sistemas            | `TS`                   |

Si no está definido, preguntar una vez: "¿Eres de Infraestructura (TIF) o de Sistemas (TS)?"

## 1. Identificar el ticket

Extraer la clave del ticket del mensaje del usuario (formato `<PROJ>-<n>`).
Si el usuario solo da número sin prefijo, asumir `<projectKey>-<n>` según su equipo y confirmar brevemente.
Si da el prefijo explícito (ej. `TIF-47`), usarlo tal cual independientemente del equipo.

## 2. Obtener el issue

Llamar a `mcp__claude_ai_Atlassian__getJiraIssue` restringiendo campos para no inflar contexto:

```json
{
  "cloudId": "067e6789-c624-4d93-8e50-fb6f31d8130e",
  "issueIdOrKey": "<TIF-XXX o TS-XXX>",
  "fields": ["summary", "description", "comment"],
  "responseContentFormat": "markdown"
}
```

## 3. Resumen al usuario

Mostrar:

- **Key (id)** — **Título**
- **Descripción**
- **Comentarios** en orden cronológico: `autor (fecha): texto`

No traducir terminología técnica. No omitir comentarios salvo ruido automático evidente.
