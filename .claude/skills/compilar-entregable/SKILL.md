---
name: compilar-entregable
description: Compila un entregable LaTeX del curso con latexmk hacia build/, filtra el log a los errores y advertencias relevantes, y cuenta las páginas reales del PDF para verificarlas contra el rango exigido. Úsala al cierre de cada sección, cuando el usuario pida verificar el documento, y siempre antes de dar por terminado un entregable.
---

# Compilación y verificación de extensión

## Comando

Desde la raíz del proyecto, **siempre**:

```bash
latexmk -pdf -interaction=nonstopmode -output-directory=build TAREAS/<NN>_<Titulo>.tex
```

`latexmk` encadena por su cuenta las pasadas de compilador y de `biber` necesarias para resolver citas y referencias cruzadas. No lo invoques a mano ni cambies las banderas: la configuración de compilación es inmutable.

## Conteo de páginas

```bash
pdfinfo build/<NN>_<Titulo>.pdf | grep Pages
```

Rango exigido: **mínimo 18, máximo 40, objetivo 27**. La extensión se verifica así, contando el PDF, **nunca por estimación**.

Reporta siempre el número y su posición en el rango. Si está fuera:

- Por debajo de 18: identifica qué secciones del índice aprobado admiten mayor profundidad. No rellenes con paja.
- Por encima de 40: propone qué condensar. No cortes contenido sin consultarlo.

## Lectura del log

`build/<NN>_<Titulo>.log`. Reporta solo esto:

| Señal | Qué significa | Acción |
| --- | --- | --- |
| `! LaTeX Error` / `! Undefined control sequence` | Error real | Corregir |
| `Citation ... undefined` | Clave citada que no está en la `.bib` | Invocar `registrar-fuente` |
| `File ... not found` sobre `media/` | Imagen registrada aún no colocada | **Esperado.** Reportar como pendiente, no como error |
| `Empty bibliography` / avisos de `biber` | `.bib` malformada o vacía | Corregir |
| `Reference ... undefined` | `\ref` a una etiqueta inexistente | Corregir |
| `Overfull \hbox` > 20pt | Desborde visible de margen | Reportar; corregir si afecta la presentación |

Ignora y **no le muestres al usuario**: `Overfull` menores, avisos de fuentes sustituidas, `Package hyperref Warning` rutinarios, y todo el ruido de `latexmk`.

## Dependencias faltantes

Si la compilación falla porque falta un paquete LaTeX o cualquier otra dependencia del sistema:

1. Identifica el paquete.
2. **Reporta el comando de instalación** (`tlmgr install <paquete>` o el que corresponda).
3. **Detente.** Nunca lo ejecutes. Instalar software queda fuera del alcance del proyecto.

## Artefactos

`build/` está en `.gitignore`. Los archivos `.aux`, `.bbl`, `.bcf`, `.log`, `.out`, `.run.xml`, `.fdb_latexmk`, `.fls` y `.toc` no se versionan ni se le presentan al usuario. Solo el PDF importa.

Si una compilación queda a medias y el estado se ensucia (típicamente un `.bcf-SAVE-ERROR`), limpia con:

```bash
latexmk -C -output-directory=build TAREAS/<NN>_<Titulo>.tex
```

## Reporte

Formato compacto:

```
Compilación: OK
Páginas: 24 / 40  (mínimo 18, objetivo 27)
Pendientes de imagen: 2  →  media/t03/diagramaPlanificador.png, media/t03/jerarquiaMemoria.png
Advertencias: ninguna relevante
```
