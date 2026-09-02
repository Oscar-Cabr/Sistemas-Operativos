---
name: entregable-nuevo
description: Arranca un entregable nuevo del curso de Sistemas Operativos a partir del mensaje disparador del usuario (fecha de entrega, título, número, tipo tarea/proyecto e indicaciones del profesor). Crea el esqueleto .tex, su .bib y su carpeta de media, y propone el índice de contenidos para aprobación. Úsala cuando el usuario anuncie una tarea o un proyecto nuevo, o pida replantear el índice de uno existente.
---

# Arranque de entregable

Esta skill llega hasta la **propuesta de índice** y se detiene. No redacta contenido.

## Paso 0 — Validar el disparador

El disparador debe traer los cinco campos. Si falta alguno, pídelo y no avances:

1. Fecha de entrega
2. Título del entregable
3. Número de trabajo
4. Tipo: tarea o proyecto
5. Indicaciones completas del profesor (literales)

Nunca inventes ni infieras un campo ausente, en especial el número y la fecha.

## Paso 1 — Derivar identificadores

| Elemento | Regla | Ejemplo |
| --- | --- | --- |
| `<NN>` | Número a dos dígitos, cero a la izquierda | `03` |
| `<Titulo>` | Título en `Snake_Case`, sin acentos ni signos | `Gestion_De_Procesos` |
| Archivo maestro | Tarea: `TAREAS/<NN>_<Titulo>.tex` · Proyecto: `PROYECTOS/<NN>_<Titulo>.tex` | `TAREAS/03_Gestion_De_Procesos.tex` |
| Bibliografía | `bibliography/<NN>_<titulo_minusculas>.bib` | `bibliography/03_gestion_de_procesos.bib` |
| Media | Tarea: `media/t<NN>/` · Proyecto: `media/p<NN>/` | `media/t03/` |

Antes de crear nada, verifica que el número no esté ya en uso (`ls TAREAS/ PROYECTOS/`). Si colisiona, detente y pregunta.

## Paso 2 — Crear el esqueleto

Lee `TAREAS/template.tex` y crea el archivo maestro a partir de él, con estas sustituciones y **nada más**:

- `\addbibresource{bibliography/sample.bib}` → la `.bib` del entregable.
- El bloque `\begin{comment} ... \end{comment}` → las indicaciones **literales** del profesor, más el rango de páginas exigido.
- `\textbf{Tarea N. Nombre}` → `\textbf{Tarea <N>. <Título>}` (o `Proyecto <N>. <Título>`).
- `Ciudad Universitaria, CDMX a DD de month del 2026` → la fecha de entrega en español, mes en minúscula: `26 de agosto del 2026`.
- Elimina la sección de ejemplo (`\section{Fundamentos para el diseño de software}` y su párrafo). Deja el documento sin secciones de contenido.

Crea también la `.bib` vacía y el directorio de media. El resto de la portada (institución, grupo, profesor, alumno) ya es correcto: no lo toques.

## Paso 3 — Barrido de relevancia

Invoca `consulta-fuentes` en modo exploratorio para saber qué cubren realmente los libros del repositorio sobre el tema y con qué profundidad. Es un sondeo, no la investigación completa: sirve para dimensionar el índice, no para redactar.

## Paso 4 — Proponer el índice

Criterios:

- **Cobertura total.** Cada punto de las indicaciones del profesor debe mapear a al menos una sección. Si algo del índice no responde a una indicación, justifícalo o quítalo.
- **Presupuesto de páginas.** El objetivo es 27 páginas (mínimo 18, máximo 40). Asigna un estimado por sección y verifica que la suma caiga en rango. Una sección de segundo nivel rinde entre 1 y 3 páginas.
- **Profundidad de licenciatura en ingeniería.** Los conceptos complejos o no explorados en clase requieren extensión propia, no una mención.
- **Cierre obligatorio.** Toda entrega lleva una sección final de **Conclusiones personales** (requisito del profesor) y las Referencias, que el template ya imprime.
- **Respaldo real.** No propongas una sección que las fuentes disponibles no puedan sostener con citas.

Presenta el índice como lista jerárquica, con el estimado de páginas por sección y el total.

## Paso 5 — Detenerse

Espera **aprobación explícita** del usuario, o sus modificaciones, antes de escribir una sola línea de contenido. Si el usuario modifica el índice, actualiza la propuesta y vuelve a esperar.

No invoques `redactar-seccion` en este turno.
