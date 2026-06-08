---
name: open-jira-ticket
description: >
  Crea incidencias en el proyecto Jira del equipo del usuario usando el MCP de Atlassian. Úsala cuando el usuario quiera abrir un ticket nuevo.
---

**Info**
```
cloudId: 067e6789-c624-4d93-8e50-fb6f31d8130e
```

## 0. Resolver equipo

Leer el equipo del usuario de su contexto personal (`~/.claude/CLAUDE.md`).

| Equipo              | projectKey | projectId |
|---------------------|------------|-----------|
| Infraestructura     | `TIF`      | `13761`   |
| Sistemas            | `TS`       | `13530`   |

Si no está definido, preguntar una vez: "¿Eres de Infraestructura (TIF) o de Sistemas (TS)?"

## 1. Obtener información del usuario

**Preguntar siempre, una por una (obligatorio):**
- ¿Qué se va a hacer?
- ¿Por qué motivo o qué motiva el cambio?
- ¿Cómo se va a hacer?

La descripción debe tener estas secciones:
- **Contexto**: problema, razón o motivación
- **Alcance**: qué incluye y, si aplica, qué excluye
- **Plan de implementacion**: Como se llevara acabo (plan para la ia)

## 2. Crear la incidencia

Tipos de incidencia válidos (usar exactamente este nombre):

| Nombre       | Uso                                  |
|--------------|--------------------------------------|
| `Tarea`      | Trabajo planificado independiente    |
| `Epic`       | Colección de tareas/historias        |
| `Subtarea`   | Trabajo pequeño dentro de una tarea  |
| `Cambio`     | Cambio en infraestructura o servicio |
| `Incidencia` | Incidente o problema en producción   |
| `Solicitud`  | Petición de recurso o acceso         |

Llamar a `mcp__claude_ai_Atlassian__createJiraIssue` con:

```json
{
  "cloudId": "067e6789-c624-4d93-8e50-fb6f31d8130e",
  "projectKey": "<projectKey>",
  "issueTypeName": "<tipo>",
  "summary": "<titulo>",
  "description": "<descripcion>",
  "additional_fields": {
    "duedate": "<YYYY-MM-DD>",
    "parent": {"key": "<PROJ-XXX>"}
  }
}
```
