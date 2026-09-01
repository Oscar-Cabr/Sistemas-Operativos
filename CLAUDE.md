# Contexto del proyecto — Tareas y proyectos sobre Sistemas Operativos

## Objetivo
Automatizar la creación y escritura de múltiples trabajos de investigación exhaustiva y elaboración de manuales de alta calidad. Todo relacionado bajo el mismo contexto, línea de trabajo, indicaciones generales, formatos y requisitos.

## Alcance

Para cada **entregable** (proyecto y tarea) a realizar:

### Incluye

- Creación de un **índice de contenidos** para el entregable, según las **indicaciones iniciales** y un análisis de relevancia.
- Identificación de **sitios de internet confiables**: institucionales, gubernamentales, documentación oficial mediante búsqueda y evaluación de confiabilidad en tiempo real.
- Análisis y procesamiento exhaustivo de los **libros disponibles como archivo** en el directorio `libros/` del repositorio, tratados como fuente confiable sin necesidad de verificación adicional.
- Contraste de contenido entre fuentes (libros del repositorio y sitios web confiables identificados), y redacción de los contenidos descritos en el índice de contenidos.
- Recuperación de fuentes de información utilizadas como elementos referenciales `.bib`.
- Identificación de imágenes/diagramas relevantes existentes en las fuentes confiables con referencia a su ubicación exacta (fuente, página o URL). Deberán registrarse en `media-manifest.md`.
- Referencia de dichas imágenes en el entregable mediante `\includegraphics{}` sobre la ruta convenida, quede o no el archivo físico ya colocado en el repositorio.
- Identificación y almacenamiento de citas explícitas de las fuentes confiables dentro del entregable. Todo contenido no original debe ser rastreable.
- Compilación local del entregable para verificar que el documento construye sin errores y para medir su extensión real en páginas.

### No incluye

- Generación original de imágenes y diagramas (vía modelos de generación de imágenes).
- Descarga automática de imágenes desde fuentes web. La obtención y colocación física del archivo en la ruta convenida es responsabilidad exclusiva del usuario.
- Instalación de paquetes LaTeX, distribuciones, dependencias del sistema o cualquier otro software. Si la compilación falla por una dependencia ausente, Claude lo reporta e indica el comando de instalación, pero no lo ejecuta.
- Ejecución de cualquier comando que modifique la configuración del sistema o software del dispositivo fuera del directorio del proyecto.
- Modificación del preámbulo de `template.tex` ni de la configuración de compilación.

## Nivel de asistencia esperado

- Automatización de escritura de entregables.
- Explotación en la capacidad de enormes volúmenes de información, para extraer únicamente lo relevante al tema de interés.

## Flujo de trabajo por entregable

1. **Disparador.** El usuario inicia cada entregable con un mensaje que contiene: fecha de entrega, título, número de trabajo, tipo de entregable (tarea/proyecto) y las indicaciones completas del profesor. Ningún paso posterior comienza sin este insumo.
2. **Propuesta de índice.** Claude presenta el índice de contenidos (según Alcance) y espera aprobación explícita del usuario, o su modificación, antes de redactar cualquier contenido.
3. **Redacción por sección.** Una vez aprobado el índice, la redacción procede sección por sección, con un punto de revisión del usuario al cierre de cada sección antes de continuar con la siguiente.
4. **Propagación de cambios.** Cualquier cambio que afecte contenido ya elaborado (índice, secciones previas, `references.bib`, `media-manifest.md`) debe reflejarse de inmediato en todos los archivos afectados y ser explicado detalladamente al usuario.
5. **Verificación de compilación.** Al cierre de cada sección, Claude compila el entregable y reporta errores, advertencias relevantes y el número de páginas alcanzado.
6. **Resumen por turno.** Al final de cada respuesta, Claude presenta un resumen breve de las acciones realizadas en ese turno.

## Estructura del repositorio

```
.
├── CLAUDE.md                    # Este archivo
├── template.tex                 # Plantilla base; preámbulo inmutable
├── references.bib               # Bibliografía acumulada de todos los entregables
├── media-manifest.md            # Registro y trazabilidad de imágenes/diagramas
├── libros/                      # Fuentes confiables en archivo (PDF, EPUB)
├── elementos/                   # Elementos personalizados LaTeX (ELEM-*.tex)
├── media/
│   ├── t01/
│   └── p01/
└── entregables/
    ├── t01/
    │   └── main.tex
    └── p01/
        └── main.tex
```

- `references.bib` y `media-manifest.md` son **globales y acumulativos**: persisten entre entregables y se enriquecen con cada trabajo nuevo. Una fuente ya registrada no se duplica; se reutiliza su clave existente.
- Cada entregable vive en su propio directorio bajo `entregables/`, con `main.tex` como archivo maestro.
- Los libros del directorio `libros/` son fuente confiable directa. Claude los lee bajo demanda; no se asume que su contenido esté en contexto.

## Restricciones técnicas

- Todos los entregables serán producidos siguiendo el compositor de textos LaTeX.
- El entorno de trabajo es una instalación local de LaTeX, operada mediante Claude Code.
- Todos los entregables se deben crear a partir de `template.tex`.
- El estilo de citación y referencias es APA 7 (`style=apa`, `backend=biber`), ya configurado en `template.tex`. Este archivo no debe alterar dicha configuración, conforme a la restricción de "No incluye" sobre modificación de preámbulo.
- La compilación se realiza con `latexmk -pdf` desde el directorio del entregable, lo cual encadena automáticamente las pasadas de compilador y `biber` necesarias para resolver citas y referencias cruzadas.
- Los artefactos intermedios de compilación (`.aux`, `.bbl`, `.bcf`, `.log`, `.out`, `.run.xml`, `.fdb_latexmk`, `.fls`) no se versionan ni se presentan al usuario.
- `media-manifest.md` registra cada imagen/diagrama identificado con los siguientes campos: entregable, fuente, ubicación exacta (página o URL), descripción breve, la etiqueta (`tag`) mediante la cual se identifica el contenido dentro del documento, la ruta de destino según la convención de rutas de media, y su estado (`pendiente` / `colocada`). Este archivo no almacena binarios, solo su referencia y trazabilidad.
- `references.bib` mantiene actualizada la información sobre las fuentes confiables como elementos `.bib`.
- Deberá hacerse uso, cuando sea pertinente o indicación del usuario, de los elementos personalizados LaTeX alojados en `elementos/`. Un elemento personalizado LaTeX es cualquier archivo de la forma `ELEM-*.tex`.
- Para cualquier entregable, la extensión mínima debe ser de 18 páginas.
- Para cualquier entregable, la extensión máxima debe ser de 40 páginas.
- En promedio, las páginas de los entregables debe ser 27.
- La extensión se verifica compilando el documento y contando las páginas del PDF resultante, no por estimación.
- Todos los elementos de redacción deben estar basados y respaldados por reglas explícitas de la RAE.

## Manejo de los archivos del entregable

- **Edición parcial por defecto.** Toda modificación posterior a la redacción inicial de una sección se aplica como reemplazo de la porción afectada, no como reescritura completa del archivo. La reescritura completa se reserva para reestructuraciones que afecten la mayoría del documento.
- **Lectura previa obligatoria.** Claude debe leer el estado vigente de un archivo antes de aplicar cualquier cambio, y nunca escribir sobre una versión anterior en memoria de conversación. Esto aplica siempre, no solo cuando el usuario declara haber editado manualmente.
- **Umbral de fragmentación.** Si el entregable supera un volumen que dificulte su manejo como archivo único, se divide en archivos por capítulo dentro del directorio del entregable, integrados mediante `\input{}` desde `main.tex`.

## Convenciones de estilo

- La redacción debe ser apropiada para nivel licenciatura en ingeniería.
- Los tecnicismos están permitidos, pero deben aclararse la primera vez que aparecen en el texto para poder ser utilizados después.
- Conceptos no explorados y complejos deberán ser abordados con la extensión pertinente.
- **Extranjerismos técnicos.** Los términos técnicos se conservan siempre en inglés, sin traducción ni adaptación gráfica al español. Se escriben en *cursiva* únicamente en su primera aparición dentro del entregable; a partir de entonces, en redonda. Esta convención se justifica por tratarse de terminología de uso común en ingeniería en computación para el público lector del documento (autor, compañeros y profesores).
- **Siglas.** Se desarrollan en su primera aparición ("unidad central de procesamiento, CPU") y no admiten plural con -s ("las CPU", nunca "las CPUs").
- **Comillas.** Se emplea `\enquote{}` (csquotes), que aplica la jerarquía normativa del español: angulares «…» en primer nivel, inglesas "…" en el segundo, simples '…' en el tercero.
- **Ámbito de la regla RAE.** La conformidad normativa se aplica a ortografía, acentuación, puntuación y los casos anteriores. No se requiere citar ni justificar la regla RAE aplicable dentro del texto del entregable.
- Todas las etiquetas (`tags`) deberán estar escritas en camelCase. Nombradas de forma alusiva a su contenido, no a su origen, procedencia o autor.
- La ruta a información media tiene la siguiente estructura: `media/[t|p]<NN>/<tag>.<ext>`, donde `<NN>` es el número de trabajo con dos dígitos (con cero a la izquierda si aplica) y `<tag>` no incluye la extensión de archivo, que se añade por separado según el formato real de la imagen. Ejemplo: `media/t02/diagramaPlanificador.png`.

## Convenciones de estilo — formato de citas

- Libro, cita parentética: `\parencite[\S<sección>, p.\ <página>]{<clave>}`
- Libro, cita narrativa: `\textcite[\S<sección>, p.\ <página>]{<clave>}`
- Sitio web, cita parentética: `\parencite{<clave>}`. Se agrega `[\S<sección>]` únicamente si la fuente tiene numeración interna verificable (por ejemplo, RFCs o documentación técnica).
- Sitio web, cita narrativa: `\textcite{<clave>}`
- La prenote `[véase]` se reserva exclusivamente para remisiones cruzadas o lecturas complementarias; no se usa en citas de respaldo directo.

## Convenciones de estilo — tipos de fuente bibliográfica

### Libro
`@book` — autor, título, año, edición, editorial.

### Sitio web institucional/gubernamental
`@online` — autor (persona o institución entre llaves dobles `{{...}}`), título, año (o `n.d.` si no hay fecha), url, urldate.

### Artículo académico (revista o conferencia)
`@article` (revista) o `@inproceedings` (conferencia) — autor, título, año, nombre de la revista/conferencia (`journaltitle`/`booktitle`), volumen y páginas si aplica, DOI si está disponible.

### Estándar o RFC
`@techreport` — autor (organismo emisor: IETF, IEEE, ISO), título, año, número de informe (`number`), institución (`institution`). Para RFCs, el `number` corresponde al número de RFC (ej. `number = {RFC 9293}`).

### Documentación oficial de software
`@online` con convención de autor especial: el campo `author` toma el nombre del proyecto de software entre llaves dobles (ej. `{{The Linux Kernel Documentation}}`, `{{Rust Project}}`), nunca una persona individual salvo que la documentación cite un autor específico. Incluir `version` si la documentación corresponde a una versión concreta del software y esta es relevante para el contenido citado.

### Orden de decisión al clasificar una fuente

1. ¿Tiene DOI o fue publicada en una revista/conferencia con proceso de arbitraje?
   → `@article` / `@inproceedings`.
2. ¿Es un estándar formal o RFC con número de documento oficial?
   → `@techreport`.
3. ¿Es un libro con ISBN o editorial identificable?
   → `@book`.
4. Cualquier otro caso (documentación web, institucional o de software)
   → `@online`.

## Notas adicionales

Todas las indicaciones del usuario sobre investigación y escritura de documentos deberán seguir las indicaciones de este archivo.
