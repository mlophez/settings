---
name: open-infra-ticket
description: >
  Crea o actualiza incidencias en el proyecto TECH-INFRAESTRUCTURAS (`TIF`) de Jira usando el MCP de Atlassian.
---

**Info**
```
cloudId:    067e6789-c624-4d93-8e50-fb6f31d8130e
projectKey: TIF
projectId:  13761
```

## 1. Obtain information from user

- **¡Ask user for motive or context for change always! (mandatory)**

Description must have this sections:
- Contexto (Explain the problem, reason, or motivation for this PR)
- Alcance (Define what is included and, when relevant, what is excluded)


## 2. Crear la incidencia

Llamar a `mcp__claude_ai_Atlassian__createJiraIssue` con:

```json
{
  "cloudId": "067e6789-c624-4d93-8e50-fb6f31d8130e",
  "projectKey": "TIF",
  "issueTypeName": "<tipo>",
  "summary": "<titulo>",
  "description": "<descripcion>",
  "additional_fields": {
    "duedate": "<YYYY-MM-DD>",
    "parent": {"key": "<TIF-XXX>"}
  }
}
```

