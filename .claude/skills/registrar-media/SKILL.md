---
name: registrar-media
description: Registra en media-manifest.md una imagen, diagrama o tabla identificada en una fuente confiable, le asigna etiqueta y ruta de destino, descarga y coloca la imagen cuando es accesible en la web, y genera el \includegraphics correspondiente. Úsala cada vez que se localice material gráfico aprovechable para un entregable, y para reportarle al usuario qué se descargó y qué archivos debe colocar él.
---

# Registro de material gráfico

La política de obtención (web: se descarga; libros o PDF: pendiente para el usuario; nunca se genera) está en `CLAUDE.md`. Esta skill es el procedimiento.

## Etiqueta y ruta

| Elemento | Regla |
| --- | --- |
| `<tag>` | `camelCase`, alusivo al **contenido**, nunca al origen, autor o número de figura de la fuente |
| Ruta | `media/[t\|p]<NN>/<tag>.<ext>` |

`<tag>` no incluye extensión; esta se añade según el formato real del archivo. Ejemplos: `media/t03/diagramaPlanificador.png`, `media/p01/jerarquiaMemoria.pdf`.

Correcto: `transicionesEstadoProceso`. Incorrecto: `figura34`, `imagenStallings`, `diagrama_1`.

## Obtención

**Fuente web accesible → descargar.**

```bash
curl -fsSL -o media/<t|p><NN>/<tag>.<ext> "<URL directa de la imagen>"
file media/<t|p><NN>/<tag>.<ext>
```

- Usa la URL directa del recurso, no la de la página que lo contiene.
- Comprueba con `file` que lo descargado es una imagen y que la extensión coincide con su formato real; si no, corrígela o descarta la descarga.
- Si la descarga falla o exige autenticación, trátala como `pendiente`.

**Libro o PDF del repositorio → `pendiente`.** No se extrae: la extracción queda a cargo del usuario.

## Registro en `media-manifest.md`

`media-manifest.md` es **global y acumulativo**: persiste entre entregables. Léelo antes de escribir, agrega una fila por imagen bajo la sección del entregable, y créala si no existe.

| Campo | Contenido |
| --- | --- |
| Tag | La etiqueta en camelCase |
| Fuente | Libro o sitio, con la clave `.bib` si ya está registrada |
| Ubicación exacta | Página impresa y sección del libro, o URL completa de la imagen |
| Descripción | Una línea sobre qué muestra |
| Ruta destino | `media/[t\|p]<NN>/<tag>.<ext>` |
| Estado | `pendiente` o `colocada` |

La sección del manifiesto identifica el entregable (`t03`, `p01`). Verifica el estado real con `ls` sobre la ruta antes de marcar `colocada`. No lo asumas.

## Referencia en el entregable

La figura se redacta siempre completa, replicando el formato de la figura de ejemplo de la plantilla (ver `redactar-seccion`):

- **`colocada`:** `\includegraphics` sobre la ruta destino.
- **`pendiente`:** `\includegraphics` sobre `media/example_figure.png`, precedido de `% PENDIENTE: <ruta destino>`. Caption, etiqueta y mención en el texto son ya los definitivos.

```latex
\begin{figure}[htbp]
    \centering
    % PENDIENTE: media/t03/diagramaPlanificador.png
    \includegraphics[width=0.7\textwidth]{media/example_figure.png}
    \caption{Transiciones de estado de un proceso \parencite[\S 3.2, p.\ 128]{stallings2018operating}.}
    \label{fig:diagramaPlanificador}
\end{figure}
```

Toda figura tomada de una fuente lleva la cita en su `\caption` y se menciona en el cuerpo con `Img.~\ref{fig:<tag>}`. Una figura que el texto nunca menciona sobra.

## Colocación posterior

Cuando el usuario avise que colocó imágenes, o antes de la auditoría final, recorre las filas `pendiente` del entregable:

1. `ls` sobre la ruta destino. Si no existe, sigue `pendiente`.
2. Si existe, comprueba con `file` que el formato coincide con la extensión.
3. En el `.tex`, localiza `% PENDIENTE: <ruta destino>`, sustituye `media/example_figure.png` por la ruta destino en el `\includegraphics` siguiente y elimina el comentario.
4. Marca la fila como `colocada` y compila con `compilar-entregable`.

## Reporte al usuario

Al cierre del turno, en forma accionable:

```
Descargadas (t03):
  media/t03/estadosProcesoLinux.png
    ← https://docs.kernel.org/.../states.png

Pendientes de colocar (t03):
  media/t03/diagramaPlanificador.png
    ← Stallings 9ª ed., §3.2, p. 128 (figura de transiciones de estado)
```
