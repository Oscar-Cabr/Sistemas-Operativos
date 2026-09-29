---
name: compilar-entregable
description: Compila un entregable LaTeX del curso mediante el Makefile de la raíz, filtra el log a los errores y advertencias relevantes, y cuenta las páginas reales del PDF depositado en ENTREGABLES/ para verificarlas contra el rango exigido. Úsala al cierre de cada sección, cuando el usuario pida verificar el documento, y siempre antes de dar por terminado un entregable.
---

# Compilación y verificación de extensión

Las reglas de compilación (solo Makefile, solo variables de cabecera, nada escrito a mano en `build/` ni en `ENTREGABLES/`) están en `CLAUDE.md`. Esta skill es el procedimiento.

## 1. Apuntar el Makefile al entregable

Lee el `Makefile` vigente y ajusta **solo** sus dos primeras variables:

| Variable | Tarea | Proyecto |
| --- | --- | --- |
| `FILE` | `<NN>_<Titulo_Snake>` (sin ruta ni extensión) | `<NN>_<Titulo_Snake>` |
| `OUTPUT` | `ENTREGABLES/TAREAS/$(FILE)` | `ENTREGABLES/PROYECTOS/$(FILE)` |

Verifica que ambas apuntan al entregable en curso y al directorio de su tipo. El Makefile deduce de `OUTPUT` si el fuente está en `TAREAS/` o `PROYECTOS/`, y su target `check` rechaza una salida mal formada o un `.tex` inexistente. Si falla por otra causa, **detente y avísale al usuario**: adaptar el Makefile no es tarea de Claude.

## 2. Compilar

Usa el target que compila sin abrir el visor (hoy, `make pdf`). Nunca el target por defecto si lanza un visor, y nunca `latexmk`, `pdflatex` ni `biber` a mano: el Makefile ya encadena las pasadas necesarias.

## 3. Conteo de páginas

```bash
pdfinfo ENTREGABLES/<TAREAS|PROYECTOS>/<NN>_<Titulo_Snake>.pdf | grep Pages
```

Compara contra el rango de extensión de `CLAUDE.md`. Reporta siempre el número y su posición en el rango. Si está fuera:

- Por debajo del mínimo: identifica qué secciones del índice aprobado admiten mayor profundidad. No rellenes con paja.
- Por encima del máximo: propone qué condensar. No cortes contenido sin consultarlo.

Si el PDF no llegó a `ENTREGABLES/`, no lo copies a mano: repórtalo con la causa.

## 4. Lectura del log

Parte del resumen que genera el Makefile (`compile-report.txt`) y, si hace falta detalle, del log completo en `build/<FILE>.log`. Reporta solo esto:

| Señal | Qué significa | Acción |
| --- | --- | --- |
| `! LaTeX Error` / `! Undefined control sequence` | Error real | Corregir |
| `Citation ... undefined` | Clave citada que no está en la `.bib` | Invocar `registrar-fuente` |
| `File ... not found` sobre `media/` | Ruta de imagen inexistente: una pendiente sin placeholder, o una `colocada` que no está en disco | Corregir: placeholder y `% PENDIENTE` (ver `registrar-media`), o estado del manifiesto |
| `Empty bibliography` / avisos de `biber` | `.bib` malformada o vacía | Corregir |
| `Reference ... undefined` | `\ref` a una etiqueta inexistente | Corregir |
| `Overfull \hbox` > 20pt | Desborde visible de margen | Reportar; corregir si afecta la presentación |

Ignora y **no le muestres al usuario**: `Overfull` menores, avisos de fuentes sustituidas, `Package hyperref Warning` y avisos de `pdfTeX` rutinarios, y todo el ruido de `latexmk`.

Las imágenes pendientes no aparecen en el log: cuéntalas en el fuente con `grep -n "% PENDIENTE" <fuente>.tex` y repórtalas con su ruta destino.

## Dependencias faltantes

Si la compilación falla porque falta un paquete LaTeX o cualquier otra dependencia:

1. Identifica el paquete.
2. **Reporta el comando de instalación** (`tlmgr install <paquete>` o el que corresponda).
3. **Detente.** Nunca lo ejecutes.

## Estado sucio

Si una compilación queda a medias (típicamente un `.bcf-SAVE-ERROR`), limpia con el target de limpieza del Makefile (hoy, `make clean`). Antes de invocarlo, lee qué borra: si alcanza a `ENTREGABLES/`, no lo ejecutes y avísale al usuario.

## Reporte

Formato compacto:

```
Compilación: OK
Páginas: 24 / 40  (mínimo 18, objetivo 27)
Pendientes de imagen: 2  →  media/t03/diagramaPlanificador.png, media/t03/jerarquiaMemoria.png
Advertencias: ninguna relevante
```
