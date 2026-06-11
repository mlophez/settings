---
name: list-jira-ticket
description: >
  Lista los tickets no finalizados del proyecto Jira del equipo del usuario usando el MCP de Atlassian. Úsala cuando el usuario pida ver tickets pendientes, abiertos, en curso, o "qué tickets hay" / "lista de tickets" sin especificar uno concreto.
---

**Info**
```
cloudId: 067e6789-c624-4d93-8e50-fb6f31d8130e
```

## 0. Resolver equipo

Leer el equipo del usuario de su contexto personal (`~/.claude/CLAUDE.md`).

| Equipo              | projectKey |
|---------------------|------------|
| Infraestructura     | `TIF`      |
| Sistemas            | `TS`       |

Si no está definido, preguntar una vez: "¿Eres de Infraestructura (TIF) o de Sistemas (TS)?"

## 1. Buscar issues

Llamar a `mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql` con el `projectKey` resuelto:

```json
{
  "cloudId": "067e6789-c624-4d93-8e50-fb6f31d8130e",
  "jql": "project = <projectKey> AND statusCategory != Done ORDER BY updated DESC",
  "fields": ["summary", "status", "assignee", "updated"],
  "maxResults": 50
}
```

## 2. Mostrar al usuario

Una línea por ticket con: Key, Estado, Asignado, Título.

Ordenado por `updated` desc dentro de cada sección.
Si una sección está vacía, indicarlo.
No traducir estados.

Dos secciones, siempre en este orden:

### Mis tickets
Tickets cuyo `assignee` coincide con el usuario actual.

### Resto
El resto de tickets devueltos.
