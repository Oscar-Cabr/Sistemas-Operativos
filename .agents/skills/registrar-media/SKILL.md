---
name: registrar-media
description: >-
  Registra en media-manifest.md una imagen, diagrama o tabla identificada en una fuente confiable, le asigna etiqueta y ruta de destino, descarga y coloca la imagen cuando es accesible en la web, y genera el \includegraphics correspondiente. Úsala cada vez que se localice material gráfico aprovechable para un entregable, y para reportarle al usuario qué se descargó y qué archivos debe colocar él.
---

# Registro de material gráfico

La política de obtención (web: se descarga; libros o PDF: pendiente para el usuario; nunca se genera) está en `GEMINI.md`. Esta skill es el procedimiento.

## Etiqueta y ruta

| Elemento | Regla |
| --- | --- |
| `<tag>` | `camelCase`, alusivo al **contenido**, nunca al origen, autor o número de figura de la fuente |
| Ruta | `media/[t\|p]<NN>/<tag>.<ext>` |

`<tag>` no incluye extensión; esta se añade según el formato real del archivo. Ejemplos: `media/t03/diagramaPlanificador.png`, `media/p01/jerarquiaMemoria.pdf`.

Correcto: `transicionesEstadoProceso`. Incorrecto: `figura34`, `imagenStallings`, `diagrama_1`.

## Obtención

**Fuente web accesible → descargar.**

Ejecuta con `run_command`:
```bash
curl -fsSL -o media/<t|p><NN>/<tag>.<ext> "<URL directa de la imagen>"
file media/<t|p><NN>/<tag>.<ext>
python3 .agents/skills/registrar-media/scripts/clean_image.py media/<t|p><NN>/<tag>.<ext>
```

- Usa la URL directa del recurso, no la de la página que lo contiene.
- Comprueba con `file` que lo descargado es una imagen y que la extensión coincide con su formato real; si no, corrígela o descarta la descarga.
- Ejecuta inmediatamente `clean_image.py` para purgar bordes negros, grises o marcos de captura y asegurar fondo blanco uniforme.
- Si la descarga falla o exige autenticación, trátala como `pendiente`.

**Libro o PDF del repositorio → `pendiente`.** No se extrae: la extracción queda a cargo del usuario.

## Limpieza obligatoria de bordes de captura

Las capturas tomadas de libros, visores de PDF o navegadores suelen arrastrar bordes perimétricos oscuros (#000000, #2f2f2f). Antes de dar por buena cualquier imagen (descargada o colocada por el usuario), es obligatorio ejecutar el script de limpieza:

```bash
python3 .agents/skills/registrar-media/scripts/clean_image.py media/<t|p><NN>/<tag>.<ext>
```

El script inspecciona las cuatro orillas periféricas y recorta automáticamente los píxeles no blancos periféricos hasta alcanzar el fondo blanco uniforme, sin tocar el contenido interior de la figura.

## Registro en `media-manifest.md`

`media-manifest.md` es **global y acumulativo**: persiste entre entregables. Léelo con `read_file` antes de escribir, agrega una fila por imagen bajo la sección del entregable con `edit_file`, y créala si no existe.

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

La figura se redacta siempre completa, replicando el formato de la figura de ejemplo de la plantilla:

- **Ancho máximo estándar:** Toda imagen debe utilizar **SIEMPRE** `width=\columnwidth` (en entregables a una columna equivale a `\textwidth`) como valor inicial, garantizando que los diagramas se muestren lo más grandes y legibles posible.
- **`colocada`:** `\includegraphics[width=\columnwidth]{ruta destino}`.
- **`pendiente`:** `\includegraphics[width=\columnwidth]{media/example_figure.png}`, precedido de `% PENDIENTE: <ruta destino>`. Caption, etiqueta y mención en el texto son ya los definitivos.

```latex
\begin{figure}[htbp]
    \centering
    % PENDIENTE: media/t03/diagramaPlanificador.png
    \includegraphics[width=\columnwidth]{media/example_figure.png}
    \caption{Transiciones de estado de un proceso \parencite[\S 3.2, p.\ 128]{stallings2018operating}.}
    \label{fig:diagramaPlanificador}
\end{figure}
```

Toda figura tomada de una fuente lleva la cita en su `\caption` y se menciona en el cuerpo con `Img.~\ref{fig:<tag>}`. Una figura que el texto nunca menciona sobra.

## Colocación posterior y ciclo de verificación

Cuando el usuario avise que colocó imágenes, o antes de la auditoría final, recorre las filas `pendiente` del entregable:

1. `ls` sobre la ruta destino mediante `run_command`. Si no existe, sigue `pendiente`.
2. Si existe, comprueba con `file` que el formato coincide con la extensión.
3. **Depuración de bordes:** Ejecuta `python3 .agents/skills/registrar-media/scripts/clean_image.py media/[t|p]<NN>/<tag>.<ext>` para garantizar que no tenga marcos oscuros o bordes de captura.
4. En el `.tex`, localiza `% PENDIENTE: <ruta destino>`, sustituye `media/example_figure.png` por la ruta destino con `width=\columnwidth` y elimina el comentario mediante `edit_file`.
5. Marca la fila como `colocada` en `media-manifest.md`.
6. **Compilación y ajuste adaptativo de desborde:** Compila con `compilar-entregable`.
   - Si la imagen a ancho completo desborda verticalmente la página o genera una página flotante aislada indeseada por exceder `\topfraction`, calcula y ajusta el tamaño al máximo posible antes del desborde a lo alto, usando `height=0.7\textheight, width=\columnwidth, keepaspectratio` o una escala proporcional en ancho (`width=0.85\columnwidth`, `width=0.75\columnwidth`).
7. **Verificación de visualización en el PDF:**
   Ejecuta:
   ```bash
   pdfimages -list ENTREGABLES/<TIPO>/<nombre_pdf>.pdf
   ```
   Comprueba que cada imagen:
   - Aparece listada en la página correspondiente.
   - Posee una resolución normal (`x-ppi` y `y-ppi` entre 72 y 400 ppi). Si `x-ppi > 1000`, alerta de inmediato: la escala se renderizó microscópica por un error tipográfico en el comando LaTeX.
   - El texto adyacente (`caption` y etiquetas) no se solapa.

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
