---
name: registrar-media
description: Registra en media-manifest.md una imagen, diagrama o tabla identificada en una fuente confiable, le asigna etiqueta y ruta de destino, y genera el \includegraphics correspondiente. Úsala cada vez que se localice material gráfico aprovechable para un entregable, y para reportarle al usuario qué archivos debe colocar físicamente.
---

# Registro de material gráfico

## Qué no se hace

- **No se generan imágenes** con modelos de generación.
- **No se descargan** imágenes de fuentes web ni se extraen de los PDF.
- La obtención y colocación física del archivo es responsabilidad **exclusiva del usuario**.

Esta skill produce trazabilidad y referencias LaTeX. Nada más.

## Etiqueta y ruta

| Elemento | Regla |
| --- | --- |
| `<tag>` | `camelCase`, alusivo al **contenido**, nunca al origen, autor o número de figura de la fuente |
| Ruta | `media/[t\|p]<NN>/<tag>.<ext>` |

`<tag>` no incluye extensión; esta se añade según el formato real del archivo. Ejemplos: `media/t03/diagramaPlanificador.png`, `media/p01/jerarquiaMemoria.pdf`.

Correcto: `transicionesEstadoProceso`. Incorrecto: `figura34`, `imagenStallings`, `diagrama_1`.

## Registro en `media-manifest.md`

`media-manifest.md` es **global y acumulativo**: persiste entre entregables. Nunca almacena binarios, solo referencias. Léelo antes de escribir, agrega una fila por imagen bajo la sección del entregable, y créala si no existe.

Campos:

| Campo | Contenido |
| --- | --- |
| Entregable | `t03`, `p01` |
| Tag | La etiqueta en camelCase |
| Fuente | Libro o sitio, con la clave `.bib` si ya está registrada |
| Ubicación exacta | Página impresa y sección del libro, o URL completa |
| Descripción | Una línea sobre qué muestra |
| Ruta destino | `media/[t\|p]<NN>/<tag>.<ext>` |
| Estado | `pendiente` o `colocada` |

Verifica el estado real con `ls` sobre la ruta antes de marcar `colocada`. No lo asumas.

## Referencia en el entregable

Se escribe el `\includegraphics` **aunque el archivo aún no exista**. El documento compila con el hueco y `latexmk` avisa del archivo faltante; eso es esperado y se reporta como pendiente, no como error a corregir.

```latex
\begin{figure}[H]
    \centering
    \includegraphics[width=0.7\textwidth]{media/t03/diagramaPlanificador.png}
    \caption{Transiciones de estado de un proceso \parencite[\S 3.2, p.\ 128]{stallings2018operating}.}
    \label{fig:diagramaPlanificador}
\end{figure}
```

Toda figura tomada de una fuente lleva la cita en su `\caption` y se referencia en el cuerpo del texto con `\ref{fig:<tag>}`. Una figura que el texto nunca menciona sobra.

## Reporte al usuario

Al cierre del turno, entrega la lista de pendientes en forma accionable: qué imagen, de qué fuente, en qué página exacta, y en qué ruta debe guardarla.

```
Pendientes de colocar (t03):
  media/t03/diagramaPlanificador.png
    ← Stallings 9ª ed., §3.2, p. 128 (figura de transiciones de estado)
```
