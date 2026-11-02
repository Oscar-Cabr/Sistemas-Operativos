# Sistemas Operativos — Facultad de Ingeniería, UNAM

Repositorio de tareas y proyectos del curso. Cada entregable es un documento LaTeX —trabajo de investigación exhaustiva o manual— redactado a partir de fuentes confiables, con citas rastreables y compilado localmente. Todos comparten contexto, línea de trabajo, formatos y requisitos.

**Nivel de asistencia esperado:** automatización de la escritura de entregables y explotación de grandes volúmenes de información para extraer únicamente lo relevante al tema.

**Precedencia:** este archivo prevalece sobre cualquier skill de `.claude/skills/` que lo contradiga. Todas las indicaciones del usuario sobre investigación y escritura siguen lo aquí dispuesto.

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
├── Makefile                     # compilación desde la raíz; solo variables de cabecera
├── media-manifest.md            # trazabilidad global de imágenes
├── config/                      # preámbulo modularizado; inmutable salvo orden explícita
│   ├── preamble.tex             # destino por defecto de un estilo nuevo
│   └── <feature>.tex            # módulo propio si el añadido es grande y reutilizable
├── bibliography/                # un .bib por entregable + acervo de consulta
│   ├── tsample.bib              # placeholder de TAREAS/template.tex. NO TOCAR
│   └── psample.bib              # placeholder de PROYECTOS/template.tex. NO TOCAR
├── media/
│   ├── titlepage/               # escudos institucionales. NO TOCAR
│   ├── example_figure.png       # placeholder de plantillas e imágenes pendientes. NO TOCAR
│   ├── t<NN>/                   # media de la tarea NN
│   └── p<NN>/                   # media del proyecto NN
├── TAREAS/
│   ├── template.tex             # generadora de tareas. INMUTABLE
│   └── <NN>_<Titulo_Snake>.tex
├── PROYECTOS/
│   ├── template.tex             # generadora de proyectos. INMUTABLE
│   └── <NN>_<Titulo_Snake>.tex
├── build/                       # salida intermedia de TeX. Generado
├── ENTREGABLES/                 # PDF compilados. Generado
│   ├── TAREAS/
│   └── PROYECTOS/
└── .claude/
    ├── skills/                  # procedimientos de trabajo
    └── sources/
        ├── libros/              # 6 libros troceados en .md — fuente confiable
        └── libros-pdf/          # originales
```

Los libros de `.claude/sources/libros/` son **fuente confiable directa**: no requieren verificación adicional. Se leen bajo demanda; su contenido nunca se asume en contexto.

### Convención de nombres por entregable

| Artefacto | Tarea | Proyecto |
| --- | --- | --- |
| Fuente LaTeX | `TAREAS/<NN>_<Titulo_Snake>.tex` | `PROYECTOS/<NN>_<Titulo_Snake>.tex` |
| Bibliografía | `bibliography/t<NN>.bib` | `bibliography/p<NN>.bib` |
| Media | `media/t<NN>/<tag>.<ext>` | `media/p<NN>/<tag>.<ext>` |
| PDF compilado | `ENTREGABLES/TAREAS/T<NN>_<Titulo_Snake>_CabreraRojasOscar.pdf` | `ENTREGABLES/PROYECTOS/P<NN>_<Titulo_Snake>_CabreraRojasOscar.pdf` |

- `<NN>`: número de trabajo a dos dígitos, con cero a la izquierda si aplica.
- `<Titulo_Snake>`: iniciales mayúsculas y guiones bajos como separador, sin acentos ni signos, conforme a los existentes (`00_Registro_EDUCAFI`).
- Formato reglamentario del entregable: `<T/P><#>_<NombreEntregable>_CabreraRojasOscar.pdf`, donde `<T/P>` es `T` para tareas y `P` para proyectos, y el sufijo fijo de autoría es `_CabreraRojasOscar.pdf`.
- El prefijo `t`/`p` del `.bib` es obligatorio: sin él, una tarea y un proyecto con el mismo número colisionarían en `bibliography/`.
- Esta convención es independiente del camelCase de los `tags` de media.

### Derivación de un entregable nuevo

1. Copiar el `template.tex` del tipo correspondiente al archivo con su nombre definitivo. La plantilla nunca se edita en su lugar.
2. Sustituir en la copia la referencia a `bibliography/[t|p]sample.bib` por el `.bib` propio del entregable.
3. Eliminar el contenido de ejemplo (sección y figura con `media/example_figure.png`); la figura de ejemplo es el modelo de formato para toda figura real.
4. Crear el `.bib` del entregable y el directorio `media/[t|p]<NN>/` si aún no existen.

## Flujo de trabajo

Cada paso tiene una skill. No improvises el procedimiento: invócala, respetando lo que este archivo establece. Todo el flujo se ejecuta en la sesión principal, sin subagentes.

| # | Paso | Skill |
| --- | --- | --- |
| 1 | El usuario envía el **disparador**: fecha de entrega, título, número, tipo (tarea/proyecto) e indicaciones completas del profesor. Sin este insumo no empieza nada. | — |
| 2 | **Reconocimiento del entorno**: leer el `Makefile`, el contenido de `config/` y el `template.tex` del tipo, para saber qué targets, paquetes, comandos y entornos están disponibles. | `entregable-nuevo` |
| 3 | Esqueleto del entregable y **propuesta de índice**. Se detiene a esperar aprobación explícita o modificación. | `entregable-nuevo` |
| 4 | Investigación en libros del repositorio y en web confiable, con contraste entre fuentes. | `consulta-fuentes` |
| 5 | Redacción **sección por sección**, con checkpoint del usuario al cierre de cada una antes de seguir. | `redactar-seccion` |
| 6 | Alta de fuentes y de figuras conforme van apareciendo. | `registrar-fuente`, `registrar-media` |
| 7 | Compilación mediante el Makefile al cierre de cada sección: errores, advertencias relevantes y páginas reales. | `compilar-entregable` |
| 8 | Auditoría normativa y de trazabilidad antes de entregar. | `revision-normativa` |

**Propagación de cambios.** Cualquier modificación que afecte contenido ya elaborado (índice —también el guardado en el `.tex`—, secciones previas, `.bib` del entregable, `media-manifest.md`) se refleja de inmediato en todos los archivos afectados y se le explica detalladamente al usuario en el mismo turno.

**Continuidad entre sesiones.** El índice aprobado, con sus estimados de páginas, vive en el bloque `\begin{comment}` del archivo maestro, junto a las indicaciones del profesor. Para retomar un entregable: leer ese bloque, las `\section` ya redactadas y la sección del entregable en `media-manifest.md`, y continuar con la primera sección pendiente.

## Restricciones técnicas

### LaTeX y `config/`

- Todo entregable se produce en LaTeX sobre una instalación local, operada mediante Claude Code, y nace del `template.tex` de su tipo: `TAREAS/template.tex` o `PROYECTOS/template.tex`.
- `config/` es inmutable durante el flujo normal: se redacta únicamente con los paquetes, comandos y entornos que ahí se definen. Si hace falta uno que no existe, se le señala al usuario en lugar de agregarlo.
- **Excepción por orden explícita.** Cuando el usuario indique expresamente que se trabajará en un estilo o configuración nuevos, sí se modifica `config/`: un añadido pequeño o puntual va a `config/preamble.tex`; uno grande y reutilizable (una caja personalizada, un entorno propio, un conjunto de comandos) va a un archivo nuevo `config/<feature>.tex`, enlazado desde el preámbulo. Concluida la indicación, `config/` vuelve a ser inmutable.
- Citación APA 7 (`style=apa`, `backend=biber`), configurada en `config/`. No se altera.

### Compilación

- **Solo mediante el Makefile de la raíz.** No se invoca `latexmk`, `pdflatex` ni `biber` directamente, ni se inventan comandos de compilación.
- **Variables de cabecera.** Se modifican únicamente las dos primeras variables del Makefile, para dirigir qué entregable se compila y dónde queda el PDF:
  - `FILE`: nombre del entregable sin extensión ni ruta (p. ej., `00_Registro_EDUCAFI`, `01_Sistemas_Operativos`).
  - `OUTPUT`: `ENTREGABLES/TAREAS/T$(FILE)_CabreraRojasOscar` para una tarea, `ENTREGABLES/PROYECTOS/P$(FILE)_CabreraRojasOscar` para un proyecto.

  Ninguna otra línea del Makefile se modifica. Antes de cada compilación se verifica que ambas variables apuntan al entregable en curso y al directorio de salida de su tipo.
- La salida intermedia va a `build/` y los PDF finales a `ENTREGABLES/TAREAS/` o `ENTREGABLES/PROYECTOS/`. En ninguno se escribe manualmente; se consultan para leer el log y contar páginas.
- Los artefactos intermedios (`.aux`, `.bbl`, `.bcf`, `.log`, `.out`, `.run.xml`, `.fdb_latexmk`, `.fls`, `.toc`) no se versionan ni se le muestran al usuario.

### Bibliografía

- Cada entregable tiene su propio `.bib`. La plantilla imprime con `\nocite{*}`, así que **todas** las entradas aparecen en Referencias, se citen o no. Por tanto, el `.bib` contiene exclusivamente las fuentes efectivamente usadas, y si una fuente deja de citarse tras una edición, su entrada se elimina en el mismo turno.
- `bibliography/` es también **acervo de consulta**: al registrar una fuente, se revisan los `.bib` de entregables anteriores y, si ya existe, se copia su entrada con la misma clave y campos al `.bib` actual. Claves estables entre trabajos, sin mezclar bibliografías.

### Media

- Toda imagen o diagrama identificado se registra en `media-manifest.md` (campos y procedimiento: `registrar-media`). No almacena binarios, solo referencia y trazabilidad.
- **Imágenes web: se descargan y colocan.** Si una imagen o diagrama relevante está accesible en una fuente web, Claude la descarga a su ruta convenida con el `tag` como nombre de archivo, la marca `colocada` y reporta qué descargó, desde dónde y en qué ruta quedó.
- **Imágenes de libros o PDF del repositorio: `pendiente`.** Su extracción queda a cargo del usuario.
- **Imagen pendiente = placeholder.** Mientras el archivo real no esté colocado, la figura se redacta completa (`\caption`, `\label`, mención en el texto) pero su `\includegraphics{}` apunta a `media/example_figure.png`, con el comentario `% PENDIENTE: <ruta destino>` en la línea anterior. Así el documento siempre compila y el conteo de páginas es real. Cuando el usuario coloca el archivo, se sustituye la ruta, se retira el comentario y se marca `colocada`.
- **Un entregable no está terminado** mientras quede en su `.tex` alguna referencia a `media/example_figure.png` o algún `% PENDIENTE`.

### Extensión

- Mínimo 18 páginas, máximo 40, objetivo 27.
- Se verifica contando las páginas del PDF generado en `ENTREGABLES/`, nunca por estimación.

### Fuera de alcance

- **Generar imágenes** con modelos de generación.
- **Instalar** paquetes LaTeX, distribuciones, dependencias o cualquier software. Si falta algo, se reporta el comando de instalación y se detiene. Jamás se ejecuta.
- **Tocar el sistema** o su configuración fuera del directorio del proyecto.
- Modificar el `Makefile` más allá de sus dos variables de cabecera.
- Modificar `config/` sin orden explícita.
- Modificar `TAREAS/template.tex`, `PROYECTOS/template.tex`, `bibliography/tsample.bib` o `bibliography/psample.bib`.
- Modificar o crear contenido en `media/titlepage/` o `media/example_figure.png`.
- Escribir manualmente en `build/` o `ENTREGABLES/`: su contenido lo produce exclusivamente el Makefile.

## Manejo de los archivos del entregable

- **El disco es la única fuente de verdad.** Antes de cualquier modificación se lee el estado vigente del archivo. Lo recordado de turnos anteriores es referencia caduca: el usuario pudo editarlo por fuera sin anunciarlo.
- **Edición por reemplazo exacto como vía ordinaria.** Toda modificación posterior a la redacción inicial de una sección se aplica como reemplazo acotado de la porción afectada: correcciones, reescrituras de párrafo, inserción de citas, ajustes de una sección completa.
- **Sobrescritura completa como excepción justificada.** Solo en reestructuraciones que afecten a la mayoría del documento, y con tres condiciones simultáneas: lectura íntegra e inmediatamente previa del archivo, contenido leído no truncado, y aviso al usuario —antes de ejecutarla— de que se va a sobrescribir y por qué.
- **Ante la duda, edición parcial.** Un conjunto de ediciones acotadas nunca es peor que una sobrescritura innecesaria.

## Convenciones de estilo

- Redacción de nivel licenciatura en ingeniería. Los tecnicismos se permiten, pero se aclaran en su primera aparición. Los conceptos complejos o no explorados se abordan con la extensión pertinente.
- **Normativa RAE** en ortografía, acentuación y puntuación de todo el texto, más los casos siguientes. No se cita ni se justifica la regla dentro del entregable.
- **Extranjerismos técnicos.** Siempre en inglés, sin traducción ni adaptación gráfica. En *cursiva* solo en su primera aparición en el entregable; después, en redonda.
- **Siglas.** Se desarrollan en su primera aparición («unidad central de procesamiento, CPU») y no admiten plural con -s («las CPU», nunca «las CPUs»).
- **Comillas.** `\enquote{}` (csquotes): angulares «…» en primer nivel, inglesas "…" en el segundo, simples '…' en el tercero.
- **Etiquetas (`tags`)** en camelCase, alusivas al contenido, nunca al origen, procedencia o autor.
- **Trazabilidad:** todo contenido no original lleva cita con ubicación exacta.
- **Conclusiones personales:** Naturaleza estrictamente monolítica. Consisten únicamente en redacción corrida en prosa (párrafos continuos), sin viñetas (`itemize`), listas, subsecciones ni títulos intermedios. Su extensión normativa es de exactamente **1 cuartilla por cada 10 páginas de desarrollo** del entregable.

### Formato de citas

| Caso | Formato |
| --- | --- |
| Libro, parentética | `\parencite[\S<sección>, p.\ <página>]{<clave>}` |
| Libro, narrativa | `\textcite[\S<sección>, p.\ <página>]{<clave>}` |
| Sitio web, parentética | `\parencite{<clave>}` |
| Sitio web, narrativa | `\textcite{<clave>}` |

- En sitios web se agrega `[\S<sección>]` solo si la fuente tiene numeración interna verificable (RFC, documentación técnica).
- La prenote `[véase]` se reserva a remisiones cruzadas o lecturas complementarias; nunca en citas de respaldo directo.

### Tipos de fuente bibliográfica

El tipo de entrada `.bib` de cada fuente (libro, sitio institucional, artículo, estándar o RFC, documentación de software) y su orden de decisión los fija `registrar-fuente`.

## Cierre de turno

Toda respuesta termina con un resumen breve de las acciones realizadas en ese turno.
