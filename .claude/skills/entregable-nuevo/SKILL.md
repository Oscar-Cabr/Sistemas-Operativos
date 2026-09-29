---
name: entregable-nuevo
description: Arranca un entregable nuevo del curso de Sistemas Operativos a partir del mensaje disparador del usuario (fecha de entrega, título, número, tipo tarea/proyecto e indicaciones del profesor). Reconoce el entorno, crea el esqueleto .tex desde la plantilla de su tipo, su .bib y su carpeta de media, y propone el índice de contenidos para aprobación. Úsala cuando el usuario anuncie una tarea o un proyecto nuevo, o pida replantear el índice de uno existente.
---

# Arranque de entregable

Esta skill llega hasta la **propuesta de índice** y se detiene. No redacta contenido. Convenciones de nombres y rutas: `CLAUDE.md`.

## Paso 0 — Validar el disparador

El disparador debe traer los cinco campos. Si falta alguno, pídelo y no avances:

1. Fecha de entrega
2. Título del entregable
3. Número de trabajo
4. Tipo: tarea o proyecto
5. Indicaciones completas del profesor (literales)

Nunca inventes ni infieras un campo ausente, en especial el número y la fecha.

## Paso 1 — Reconocer el entorno

Lee el `Makefile`, el contenido de `config/` y el `template.tex` del tipo (`TAREAS/` o `PROYECTOS/`). Anota los targets disponibles y los paquetes, comandos y entornos utilizables: solo esos se usarán al redactar.

## Paso 2 — Derivar identificadores

| Elemento | Tarea | Proyecto | Ejemplo (tarea 3) |
| --- | --- | --- | --- |
| Archivo maestro | `TAREAS/<NN>_<Titulo_Snake>.tex` | `PROYECTOS/<NN>_<Titulo_Snake>.tex` | `TAREAS/03_Gestion_De_Procesos.tex` |
| Bibliografía | `bibliography/t<NN>.bib` | `bibliography/p<NN>.bib` | `bibliography/t03.bib` |
| Media | `media/t<NN>/` | `media/p<NN>/` | `media/t03/` |

Antes de crear nada, verifica que el número no esté ya en uso para ese tipo (archivo maestro, `.bib` y carpeta de media). Si colisiona, detente y pregunta.

## Paso 3 — Crear el esqueleto

Copia el `template.tex` del tipo al archivo maestro. La plantilla no se toca. En la copia, estas sustituciones y **nada más**:

- `\addbibresource{bibliography/[t|p]sample.bib}` → la `.bib` del entregable.
- Tras `\addbibresource`, un bloque `\begin{comment} ... \end{comment}` con las indicaciones **literales** del profesor y el rango de páginas exigido.
- `\textbf{Tarea N. Nombre}` / `\textbf{Proyecto N. Nombre}` → `\textbf{Tarea <N>. <Título>}` (o `Proyecto <N>. <Título>`).
- `Ciudad Universitaria, CDMX a DD de month del 2026` → la fecha de entrega en español, mes en minúscula: `26 de agosto del 2026`.
- Elimina el contenido de ejemplo: la `\section` de ejemplo con su párrafo, su figura sobre `media/example_figure.png` y su `\subsection`. Deja el documento sin secciones de contenido.

Crea también la `.bib` vacía y el directorio de media. El resto de la portada (institución, grupo, profesor, alumno) ya es correcto: no lo toques.

## Paso 4 — Barrido de relevancia

Invoca `consulta-fuentes` en modo exploratorio para saber qué cubren realmente los libros del repositorio sobre el tema y con qué profundidad. Es un sondeo para dimensionar el índice, no la investigación completa.

## Paso 5 — Proponer el índice

Criterios:

- **Cobertura total.** Cada punto de las indicaciones del profesor mapea a al menos una sección. Si algo del índice no responde a una indicación, justifícalo o quítalo.
- **Presupuesto de páginas.** Asigna un estimado por sección y verifica que la suma caiga en el rango de `CLAUDE.md`, cerca del objetivo. Una sección de segundo nivel rinde entre 1 y 3 páginas.
- **Profundidad de licenciatura en ingeniería.** Los conceptos complejos o no explorados en clase requieren extensión propia, no una mención.
- **Cierre obligatorio.** Toda entrega lleva una sección final de **Conclusiones personales** (requisito del profesor) y las Referencias, que la plantilla ya imprime.
- **Respaldo real.** No propongas una sección que las fuentes disponibles no puedan sostener con citas.

Presenta el índice como lista jerárquica, con el estimado de páginas por sección y el total.

## Paso 6 — Detenerse

Espera **aprobación explícita** del usuario, o sus modificaciones, antes de escribir una sola línea de contenido. Si el usuario modifica el índice, actualiza la propuesta y vuelve a esperar.

Una vez aprobado, agrega el índice con sus estimados de páginas al bloque `\begin{comment}` del archivo maestro, a continuación de las indicaciones del profesor. Es el estado que permite retomar el entregable en otra sesión.

No invoques `redactar-seccion` en este turno.
