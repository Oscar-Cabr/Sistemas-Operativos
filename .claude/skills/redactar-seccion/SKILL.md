---
name: redactar-seccion
description: Redacta o reescribe una sección de un entregable del curso de Sistemas Operativos cuyo índice ya fue aprobado, aplicando las convenciones de estilo del proyecto, la normativa RAE y el formato de citas APA 7 en LaTeX. Úsala para escribir cualquier contenido de un .tex bajo TAREAS/ o PROYECTOS/, y para modificar contenido ya redactado.
---

# Redacción de sección

## Precondiciones

1. El índice está **aprobado explícitamente** por el usuario. Si no, invoca `entregable-nuevo`.
2. Tienes material de `consulta-fuentes` para la sección. Si no, consíguelo antes: no se redacta de memoria.

## Manejo del archivo

- **Lectura previa obligatoria.** Lee el estado vigente del `.tex` con `Read` antes de cualquier cambio. Nunca escribas sobre una versión que solo existe en la conversación, aunque tú mismo la hayas escrito hace dos turnos.
- **Edición parcial por defecto.** Usa `Edit` sobre la porción afectada. La reescritura completa con `Write` se reserva a reestructuraciones que afecten a la mayoría del documento.
- **Fragmentación.** Si el archivo crece hasta hacerse incómodo de manejar como unidad, pártelo en `TAREAS/<NN>_<Titulo>/` con un archivo por capítulo, integrados con `\input{}` desde el maestro.

## Registro y nivel

- Público: licenciatura en ingeniería en computación (el autor, sus compañeros y sus profesores).
- Los tecnicismos se permiten, pero se **aclaran en su primera aparición** para poder usarlos después sin glosa.
- Los conceptos complejos o no explorados en clase se abordan con la extensión que merecen, no de pasada.
- Prosa expositiva. Evita el relleno: cada párrafo aporta información nueva y respaldada.

## Convenciones normativas

**Extranjerismos técnicos.** Se conservan siempre en inglés, sin traducir ni adaptar gráficamente. Van en `\textit{}` **solo en su primera aparición dentro del entregable**; de ahí en adelante, en redonda.

```latex
El \textit{scheduler} decide qué proceso ocupa la CPU. ... Más adelante, el scheduler ...
```

**Siglas.** Se desarrollan en su primera aparición y **no admiten plural con -s**.

```latex
la unidad central de procesamiento (CPU) ... las CPU   % nunca «las CPUs»
```

**Comillas.** Siempre `\enquote{}`, que aplica la jerarquía del español (angulares « », luego inglesas “ ”, luego simples ‘ ’). Nunca comillas rectas ni dobles apóstrofos de TeX.

**RAE.** Conformidad en ortografía, acentuación y puntuación. No se cita ni se justifica la regla dentro del texto del entregable.

**Etiquetas.** En `camelCase`, alusivas al **contenido**, nunca al origen o al autor.

```latex
\label{sec:planificacionCpu}     % sí
\label{fig:diagramaPlanificador} % sí
\label{fig:figura4Stallings}     % no: alude al origen
```

## Formato de citas

| Caso | Formato |
| --- | --- |
| Libro, parentética | `\parencite[\S<sección>, p.\ <página>]{<clave>}` |
| Libro, narrativa | `\textcite[\S<sección>, p.\ <página>]{<clave>}` |
| Sitio web, parentética | `\parencite{<clave>}` |
| Sitio web, narrativa | `\textcite{<clave>}` |

- En sitios web se añade `[\S<sección>]` **solo** si la fuente tiene numeración interna verificable (RFC, estándar, documentación técnica).
- La página es la **impresa**, ya corregida por el desfase del PDF (ver `consulta-fuentes`).
- La prenote `[véase]` se reserva a remisiones cruzadas y lecturas complementarias. Jamás para respaldo directo.

```latex
El cambio de contexto obliga a salvar el bloque de control del proceso
\parencite[\S 3.2, p.\ 132]{stallings2018operating}.

\textcite[\S 4.1, p.\ 179]{stallings2018operating} distingue entre ...
```

**Trazabilidad.** Toda afirmación que no sea original del autor lleva cita. Sin excepción. Si no puedes citarla, no la escribas.

## Figuras

- Solo se referencian figuras previamente registradas por `registrar-media`. No inventes rutas ni `\includegraphics` sobre archivos que nadie identificó.
- Se referencian aunque el archivo físico todavía no esté colocado: el documento se compila con el hueco y el usuario coloca la imagen después.
- Entorno `figure` con `[H]` (el preámbulo ya carga `float`), `\caption` descriptivo y `\label{fig:<tag>}`.

```latex
\begin{figure}[H]
    \centering
    \includegraphics[width=0.7\textwidth]{media/t03/diagramaPlanificador.png}
    \caption{Transiciones de estado de un proceso \parencite[\S 3.2, p.\ 128]{stallings2018operating}.}
    \label{fig:diagramaPlanificador}
\end{figure}
```

## Dimensionamiento

Respeta el presupuesto de páginas fijado en el índice. Objetivo global: 27 páginas, mínimo 18, máximo 40. Si una sección se desvía mucho de su estimado, avísalo en el checkpoint: puede exigir reajustar el índice.

## Propagación de cambios

Si lo que escribes afecta a contenido ya elaborado —cambia el índice, contradice una sección previa, agrega una fuente, mueve una figura— actualiza **en el mismo turno** todos los archivos afectados (`.tex`, `.bib`, `media-manifest.md`) y explícale al usuario, con detalle, qué cambió y por qué.

## Cierre de sección

1. Invoca `compilar-entregable`.
2. Presenta al usuario: qué se redactó, qué fuentes nuevas se registraron, qué imágenes quedaron pendientes de colocar, y el conteo de páginas.
3. **Detente.** No pases a la siguiente sección sin visto bueno explícito.
