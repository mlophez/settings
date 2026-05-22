---
name: articulo-semanal-infra
description: >
  Redacta el artículo semanal de visibilidad del equipo de Infraestructura y Sistemas
  de Logalty. Úsala cuando el usuario pida "artículo semanal", "newsletter de infra",
  "resumen semanal del equipo", "qué hemos hecho esta semana" o similar.
---

**Info Atlassian**
```
cloudId:      067e6789-c624-4d93-8e50-fb6f31d8130e
projectKeys:  TIF (Infraestructura), TS (Sistemas)
```

---

## Fase 1 — Confirmar rango

Calcular la semana ISO anterior (lunes a domingo) tomando como referencia la fecha actual del contexto.

Mostrar al usuario:
> "Voy a recoger tickets cerrados del **lunes `<YYYY-MM-DD>` al domingo `<YYYY-MM-DD>`**. ¿Es correcto o prefieres otro rango?"

Esperar confirmación o ajuste antes de continuar.

---

## Fase 2 — Recoger contexto adicional

Hacer las siguientes preguntas, de una en una:

1. "¿Hay algo destacable de esta semana que **no** esté en Jira? (incidentes resueltos sin ticket, mejoras silenciosas, hitos del equipo)"
2. "¿Hay algo que prefieras **no mencionar** esta semana? (trabajo en curso, temas sensibles)"
3. "¿Hay un **mensaje principal** que quieras transmitir esta semana?" *(opcional — el usuario puede saltarla)*

---

## Fase 3 — Consultar Jira

Llamar a `mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql` con:

```json
{
  "cloudId": "067e6789-c624-4d93-8e50-fb6f31d8130e",
  "jql": "project in (TIF, TS) AND status changed to (Done, Resolved, Closed, \"Hecho\", \"Cerrada\", \"Resuelta\") DURING (\"<inicio>\", \"<fin>\") ORDER BY updated DESC",
  "fields": ["summary", "issuetype", "status", "resolution", "components", "labels", "updated", "assignee"],
  "maxResults": 50
}
```

Sustituir `<inicio>` y `<fin>` por las fechas confirmadas en formato `YYYY-MM-DD`.

---

## Fase 4 — Filtrar y agrupar

Descartar:
- Bumps de versión y actualizaciones automáticas de dependencias
- Tareas administrativas sin impacto visible (ajustes de permisos menores, renombrar recursos)
- Tickets duplicados o cerrados por error

Agrupar los items restantes **por tema de negocio**, no por proyecto ni por herramienta. Ejemplos de agrupaciones posibles: seguridad y control de accesos, continuidad y fiabilidad, rendimiento y eficiencia, nuevos servicios o capacidades, ahorro de costes, mejoras para el cliente. Elegir las agrupaciones que mejor se ajusten al material de esa semana.

---

## Fase 5 — Reglas de estilo (obligatorias)

- **Sin jerga sin explicar.** Cada herramienta, plataforma o tecnología que se mencione debe ir acompañada de una glosa breve en la primera aparición: "hemos ajustado nuestro sistema de orquestación de contenedores (la capa que levanta y apaga los servicios automáticamente)...". Si la glosa hace la frase muy larga, omitir el nombre técnico directamente y describir solo la función.
- **Excepción eIDAS/Logalty**: términos como eIDAS, QTSP, QES, firma electrónica cualificada, sello de tiempo pueden aparecer sin glosa porque la empresa los conoce. Aun así, evitar apilarlos sin contexto.
- **Voz activa, primera persona del plural.** "Hemos puesto en marcha…", "Esta semana hemos resuelto…"
- **Frases cortas.** Una idea por frase.
- **Sin emojis.**
- **Sin tablas markdown.**
- **Foco en impacto.** Qué cambia para la empresa, para los usuarios internos o para los clientes. No qué tecnología hemos tocado.
- **Tono cercano pero profesional.** Como un correo de un compañero experto que te resume en claro lo que ha pasado, no un comunicado corporativo ni un changelog.

---

## Fase 6 — Proponer estructura

Evaluar el material de la semana y elegir la estructura que mejor encaje:

- **Titular + highlights** (semana con varios temas independientes): asunto del email + lista de 3-5 highlights, cada uno con 1-2 frases de impacto.
- **Editorial + bullets** (semana con un hilo conductor claro): párrafo de apertura narrativo + bullets de apoyo.
- **Monográfico** (semana dominada por un hito grande: una migración, un incidente relevante, el lanzamiento de un servicio): estructura más desarrollada centrada en ese hito, con contexto, qué hemos hecho y qué cambia para la empresa.

Indicar brevemente al usuario qué estructura has elegido y por qué antes de redactar.

---

## Fase 7 — Redactar el borrador

Entregar en este orden:

**Asunto sugerido:**
Una línea concreta y con gancho. No genérica ("Esta semana en Infra y Sistemas") sino específica del contenido ("Menos caídas, más velocidad: lo que hemos mejorado esta semana").

**Cuerpo:**
Seguir la estructura elegida en Fase 6. Incorporar el contexto adicional aportado por el usuario en Fase 2. Excluir lo que pidió no mencionar.

**Cierre:**
2-3 frases invitando a preguntar o comentar al equipo. Informal y cercano.

---

## Fase 8 — Iterar

Mostrar el borrador completo en el chat y esperar feedback del usuario. Iterar cuantas veces haga falta hasta que el usuario confirme que está listo.

No guardar ningún fichero. El usuario copia/pega desde el chat.
