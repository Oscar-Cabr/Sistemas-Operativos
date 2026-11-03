---
name: redactar-seccion
description: >-
  Redacta o reescribe una sección de un entregable del curso de Sistemas Operativos cuyo índice ya fue aprobado, aplicando las convenciones de estilo del proyecto, la normativa RAE y el formato de citas APA 7 en LaTeX. Úsala para escribir cualquier contenido de un .tex bajo TAREAS/ o PROYECTOS/, y para modificar contenido ya redactado.
---

# Redacción de sección

Las convenciones de estilo, el formato de citas y las reglas de manejo de archivos están en `GEMINI.md`. Esta skill las aplica.

## Precondiciones

1. El índice está **aprobado explícitamente** por el usuario. Si no, invoca `entregable-nuevo`.
2. Tienes material citable de `consulta-fuentes` para la sección. Si no, consíguelo antes: no se redacta de memoria.

## Manejo del archivo

- `read_file` del `.tex` vigente antes de cualquier cambio, aunque tú mismo lo hayas escrito hace dos turnos.
- `edit_file` sobre la porción afectada como vía ordinaria. `write_file` del archivo completo solo bajo las tres condiciones excepcionales de `GEMINI.md`, con aviso previo al usuario.
- **Fragmentación.** Si el archivo crece hasta hacerse incómodo de manejar como unidad, pártelo en `<TAREAS|PROYECTOS>/<NN>_<Titulo_Snake>/` con un archivo por capítulo, integrados con `\input{}` desde el maestro.

## Registro

Público: el autor, sus compañeros y sus profesores de ingeniería en computación. Prosa expositiva sin relleno ni rimbombancia: cada párrafo aporta información útil y respaldada.

**Tono y lenguaje:** Claro, natural y directo. Evitar la prosa pomposa, rebuscada o con adornos artificiales. Se usan tecnicismos solo para nombrar conceptos técnicos concretos; el resto de la redacción se apoya en jerga común y letrada, propia de un estudiante de ingeniería en computación.

**Sin metarreferencias:** Jamás aludas a indicaciones del profesor, rúbricas, directivas de la tarea o decisiones de maquetación y formato (p. ej., evitar «para cumplir con la indicación», «en apego a la directiva», o justificar elecciones visuales al lector). Toda afirmación se redacta como análisis técnico objetivo autónomo.

**Conclusiones personales:** Naturaleza estrictamente monolítica. Se componen exclusivamente de redacción corrida en prosa (uno o varios párrafos continuos), sin ninguna subsección de por medio, viñetas (`itemize`), listas enumeradas ni títulos intermedios. Su extensión normativa está fijada en **1 cuartilla por cada 10 páginas de desarrollo** del entregable.

## Convenciones aplicadas en LaTeX

```latex
% Extranjerismo: \textit{} solo en la primera aparición del entregable
El \textit{scheduler} decide qué proceso ocupa la CPU. ... Más adelante, el scheduler ...

% Siglas: desarrollo en la primera aparición, sin plural en -s
la unidad central de procesamiento (CPU) ... las CPU   % nunca «las CPUs»

% Comillas: siempre \enquote{}; nunca comillas rectas ni `` ''
\enquote{texto citado}

% Etiquetas: camelCase alusivo al contenido
\label{sec:planificacionCpu}     % sí
\label{fig:diagramaPlanificador} % sí
\label{fig:figura4Stallings}     % no: alude al origen
```

## Citas

```latex
El cambio de contexto obliga a salvar el bloque de control del proceso
\parencite[\S 3.2, p.\ 132]{stallings2018operating}.

\textcite[\S 4.1, p.\ 179]{stallings2018operating} distingue entre ...
```

- La página es la **impresa**, ya corregida por el desfase del PDF (ver `consulta-fuentes`).
- Si no puedes citar una afirmación no original, no la escribas.
- Si una edición deja de citar una clave, retírala de la `.bib` en el mismo turno (ver `registrar-fuente`).

## Figuras

- Solo se referencian figuras registradas por `registrar-media`. No inventes rutas.
- Una figura `pendiente` se redacta completa sobre el placeholder `media/example_figure.png`, con `% PENDIENTE: <ruta destino>` antes de su `\includegraphics` (ver `registrar-media`).
- **Ancho máximo por defecto:** Toda figura se inicializa con `width=\columnwidth` (en documentos a una columna equivale a `\textwidth`) para mostrar los diagramas lo más grandes y claros posibles. Si tras compilar la figura desborda verticalmente la página o genera un float indeseado, se ajusta al máximo ancho posible que preserve la proporción sin desbordar verticalmente (`height=0.7\textheight, width=\columnwidth, keepaspectratio` o escala proporcional del ancho).
- Replica el formato de la figura de ejemplo de la plantilla, con la cita de la fuente en el `\caption`, y menciónala en el texto con `Img.~\ref{fig:<tag>}`:

```latex
Las transiciones posibles se resumen en la Img.~\ref{fig:diagramaPlanificador}.

\begin{figure}[htbp]
    \centering
    \includegraphics[width=\columnwidth]{media/t03/diagramaPlanificador.png}
    \caption{Transiciones de estado de un proceso \parencite[\S 3.2, p.\ 128]{stallings2018operating}.}
    \label{fig:diagramaPlanificador}
\end{figure}
```

## Tablas

Toda tabla comparativa o matriz técnica se construye en `tabularx` sobre `\textwidth`, aplicando la convención normativa:
- **Primera columna centrada a lo horizontal y a lo vertical:** `>{\centering\arraybackslash}m{<ancho>}`.
- **Columnas interiores justificadas a lo horizontal y centradas a lo vertical:** `X` acompañado de `\renewcommand{\tabularxcolumn}[1]{m{#1}}`.
- **Estructura base:**
```latex
\begin{table}[htbp]
\centering
\small
\renewcommand{\arraystretch}{1.15}
\renewcommand{\tabularxcolumn}[1]{m{#1}}
\setlength{\emergencystretch}{1.5em}
\caption{Comparativa técnica de subsistemas del sistema operativo.}
\label{tab:comparativaSubsistemas}
\begin{tabularx}{\textwidth}{>{\centering\arraybackslash}m{2.5cm} X X}
\toprule
\textbf{Elemento} & \textbf{Mecanismo del núcleo} & \textbf{Impacto funcional} \\
\midrule
... & ... & ... \\
\bottomrule
\end{tabularx}
\end{table}
```

## Dimensionamiento y densidad técnica

Respeta el presupuesto de páginas del índice aprobado. Aplica estrictamente los principios de densidad técnica fijados en `GEMINI.md`:
- **Pacing objetivo:** 1.5 a 2.0 páginas reales de desarrollo por sección temática ordinaria; 2.5 a 3.0 páginas para pruebas prácticas o análisis comparativos complejos; y 1 cuartilla de conclusiones monolíticas por cada 10 páginas de desarrollo.
- **Núcleo sobre interfaz:** Priorizar llamadas al sistema, estructuras del kernel, descriptores, protocolos y criptografía; omitir la narrativa de clics, botones y menús.
- **Densidad sin redundancia:** Párrafos de 4 a 6 líneas con alta carga conceptual y citas exactas, sin reformulaciones.
- Si una sección se desvía de su estimado, avísalo en el checkpoint: puede exigir reajustar el índice para cumplir con el rango final de 18 a 40 páginas (objetivo 27).

## Propagación de cambios

Si lo que escribes afecta a contenido ya elaborado —cambia el índice, contradice una sección previa, agrega o retira una fuente, mueve una figura— actualiza en el mismo turno todos los archivos afectados (`.tex`, incluido el índice aprobado del bloque `\begin{comment}`; `.bib`; `media-manifest.md`) y explícale al usuario qué cambió y por qué.

## Cierre de sección

1. Invoca `compilar-entregable`.
2. Presenta al usuario: qué se redactó, qué fuentes se registraron o retiraron, qué imágenes se descargaron y cuáles quedaron pendientes, y el conteo de páginas.
3. **Detente.** No pases a la siguiente sección sin visto bueno explícito.
