# Sistemas Operativos — Facultad de Ingeniería, UNAM

Repositorio de tareas y proyectos del curso. Cada entregable es un documento LaTeX —trabajo de investigación o manual— redactado a partir de fuentes confiables, con citas rastreables y compilado localmente.

## Identidad del curso

Estos datos alimentan la portada de todo entregable:

| Campo | Valor |
| --- | --- |
| Institución | Universidad Nacional Autónoma de México |
| Facultad | Facultad de Ingeniería |
| Asignatura | Sistemas Operativos |
| Grupo | 1 |
| Profesor | Ing. Angel Isidro Mercado |
| Alumno | 320304435 — Cabrera Rojas Oscar |
| Sede | Ciudad Universitaria, CDMX |

## Estructura

```
.
├── CLAUDE.md
├── media-manifest.md            # trazabilidad global de imágenes
├── config/
│   └── preamble.tex             # INMUTABLE
├── bibliography/
│   ├── 00_educafi.bib           # una .bib por entregable
│   └── sample.bib               # placeholder de template.tex
├── media/
│   ├── titlepage/               # escudos institucionales
│   └── t00/                     # convención: media/[t|p]<NN>/<tag>.<ext>
├── TAREAS/
│   ├── template.tex             # plantilla base
│   └── <NN>_<Titulo>.tex        # un archivo por tarea
├── PROYECTOS/                   # <NN>_<Titulo>.tex, se crea al llegar el primero
├── build/                       # salida de compilación, no versionada
└── .claude/
    ├── skills/                  # procedimientos de trabajo
    └── sources/
        ├── libros/              # 6 libros troceados en .md — fuente confiable
        └── libros-pdf/          # originales
```

Los libros de `.claude/sources/libros/` son **fuente confiable directa**: no requieren verificación adicional. Se leen bajo demanda; su contenido nunca se asume en contexto.

## Flujo de trabajo

Cada paso tiene una skill. No improvises el procedimiento: invócala.

| # | Paso | Skill |
| --- | --- | --- |
| 1 | El usuario envía el **disparador**: fecha de entrega, título, número, tipo (tarea/proyecto) e indicaciones completas del profesor. Sin este insumo no empieza nada. | — |
| 2 | Esqueleto del entregable y **propuesta de índice**. Se detiene a esperar aprobación explícita. | `entregable-nuevo` |
| 3 | Investigación en libros del repositorio y en web confiable. | `consulta-fuentes` |
| 4 | Redacción **sección por sección**, con checkpoint del usuario al cierre de cada una. | `redactar-seccion` |
| 5 | Alta de fuentes y de figuras conforme van apareciendo. | `registrar-fuente`, `registrar-media` |
| 6 | Compilación y conteo real de páginas al cierre de cada sección. | `compilar-entregable` |
| 7 | Auditoría normativa y de trazabilidad antes de entregar. | `revision-normativa` |

**Propagación de cambios.** Cualquier modificación que afecte contenido ya elaborado (índice, secciones previas, `.bib`, `media-manifest.md`) se refleja de inmediato en todos los archivos afectados y se le explica al usuario en el mismo turno.

## Restricciones duras

- **Extensión:** mínimo 18 páginas, máximo 40, objetivo 27. Se verifica compilando y contando las páginas del PDF, nunca por estimación.
- **LaTeX:** todo entregable nace de `TAREAS/template.tex`. Citación APA 7 (`style=apa`, `backend=biber`), ya configurada en el preámbulo.
- **No se modifica** `config/preamble.tex` ni el comando de compilación.
- **No se instala nada.** Si falta un paquete LaTeX, una distribución o cualquier dependencia, se reporta el comando de instalación y se detiene. Jamás se ejecuta.
- **No se toca el sistema** ni su configuración fuera del directorio del proyecto.
- **No se generan ni se descargan imágenes.** Se identifican en las fuentes, se registran y se referencian; colocar el archivo físico es responsabilidad exclusiva del usuario.
- **Normativa RAE** en ortografía, acentuación y puntuación de todo el texto redactado.
- **Trazabilidad:** todo contenido no original lleva cita con ubicación exacta.
- Los artefactos intermedios de compilación (`.aux`, `.bbl`, `.bcf`, `.log`, `.out`, `.run.xml`, `.fdb_latexmk`, `.fls`, `.toc`) no se versionan ni se le muestran al usuario.

## Cierre de turno

Toda respuesta termina con un resumen breve de las acciones realizadas en ese turno.
