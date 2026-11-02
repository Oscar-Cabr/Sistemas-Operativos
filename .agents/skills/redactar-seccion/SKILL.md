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

Público: el autor, sus compañeros y sus profesores de ingeniería en computación. Prosa expositiva sin relleno: cada párrafo aporta información nueva y respaldada.

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
- Replica el formato de la figura de ejemplo de la plantilla, con la cita de la fuente en el `\caption`, y menciónala en el texto con `Img.~\ref{fig:<tag>}`:

```latex
Las transiciones posibles se resumen en la Img.~\ref{fig:diagramaPlanificador}.

\begin{figure}[htbp]
    \centering
    \includegraphics[width=0.7\textwidth]{media/t03/diagramaPlanificador.png}
    \caption{Transiciones de estado de un proceso \parencite[\S 3.2, p.\ 128]{stallings2018operating}.}
    \label{fig:diagramaPlanificador}
\end{figure}
```

## Dimensionamiento

Respeta el presupuesto de páginas del índice aprobado. Si una sección se desvía de su estimado, avísalo en el checkpoint: puede exigir reajustar el índice para cumplir con el rango final de 18 a 40 páginas (objetivo 27).

## Propagación de cambios

Si lo que escribes afecta a contenido ya elaborado —cambia el índice, contradice una sección previa, agrega o retira una fuente, mueve una figura— actualiza en el mismo turno todos los archivos afectados (`.tex`, incluido el índice aprobado del bloque `\begin{comment}`; `.bib`; `media-manifest.md`) y explícale al usuario qué cambió y por qué.

## Cierre de sección

1. Invoca `compilar-entregable`.
2. Presenta al usuario: qué se redactó, qué fuentes se registraron o retiraron, qué imágenes se descargaron y cuáles quedaron pendientes, y el conteo de páginas.
3. **Detente.** No pases a la siguiente sección sin visto bueno explícito.
