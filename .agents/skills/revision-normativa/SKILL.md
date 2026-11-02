---
name: revision-normativa
description: >-
  Audita un entregable terminado del curso de Sistemas Operativos antes de la entrega: normativa RAE, convenciones de extranjerismos y siglas, etiquetas, trazabilidad de todas las afirmaciones no originales, integridad de citas y figuras, y extensión. Úsala cuando el usuario dé por concluida la redacción o pida una revisión final.
---

# Auditoría previa a la entrega

Revisión de solo lectura sobre el `.tex` completo y su `.bib`, contra las convenciones de `GEMINI.md`. **No corrijas sobre la marcha**: reporta hallazgos con ubicación y espera instrucción. Solo aplica correcciones si el usuario lo pide.

Si el documento es extenso, audítalo por partes: lee una sección a la vez con `read_file` (`StartLine`/`EndLine`) y usa `grep -n` mediante `run_command` para las verificaciones que abarcan todo el documento (primeras apariciones, siglas, comillas, etiquetas, citas).

## Lista de verificación

### Estilo y normativa

- [ ] Cada **extranjerismo técnico** aparece en `\textit{}` **solo en su primera aparición** en todo el entregable, y en redonda después. Busca el término y comprueba que no haya cursivas repetidas ni una primera aparición sin cursiva.
- [ ] Ningún extranjerismo fue traducido o adaptado gráficamente al español.
- [ ] Cada **sigla** se desarrolla en su primera aparición.
- [ ] Ninguna sigla lleva plural en `-s` (`las CPU`, nunca `las CPUs`). Busca `s}` y patrones `[A-Z]{2,}s`.
- [ ] Todas las comillas usan `\enquote{}`. Ninguna comilla recta `"`, ni `''`, ni `` `` ``.
- [ ] Cada **tecnicismo** se aclara la primera vez que se usa y se reserva para conceptos específicos; el resto del texto usa jerga común y letrada sin rimbombancia ni adornos pomposos.
- [ ] Ortografía, acentuación y puntuación conforme a la RAE.
- [ ] En ningún punto se cita ni se justifica una regla RAE dentro del texto.

### Etiquetas y referencias cruzadas

- [ ] Todas las `\label{}` están en `camelCase`.
- [ ] Ninguna etiqueta alude al origen, autor o número de figura de la fuente.
- [ ] Toda `\ref{}` resuelve a una etiqueta existente.
- [ ] Toda figura con `\label` se menciona en el cuerpo con `Img.~\ref{}`. Ninguna figura huérfana.
- [ ] Toda figura replica el formato de la figura de ejemplo de la plantilla y lleva la cita de su fuente en el `\caption`.
- [ ] No queda contenido de ejemplo de la plantilla (sección de ejemplo).

### Citas y trazabilidad

- [ ] **Toda afirmación no original lleva cita.** Este es el punto central: recorre el documento párrafo a párrafo y marca los que hacen una afirmación factual sin respaldo.
- [ ] Las citas de libro llevan sección y página: `\parencite[\S<sec>, p.\ <pág>]{clave}`.
- [ ] Las páginas citadas son las **impresas**, no las del PDF. Verifica por muestreo contra los chunks de `.agents/sources/libros/`.
- [ ] `[véase]` aparece únicamente en remisiones cruzadas o lecturas complementarias, nunca como respaldo directo.
- [ ] Cero `Citation ... undefined` en el log.
- [ ] La `.bib` del entregable (`bibliography/[t|p]<NN>.bib`) contiene **exclusivamente** fuentes citadas en él: con `\nocite{*}`, cualquier entrada sobrante se imprime sin haber sido citada. Contrasta las claves de la `.bib` con las efectivamente citadas en el `.tex` (procedimiento en `registrar-fuente`).

### Estructura y requisitos del profesor

- [ ] Cada punto de las indicaciones del profesor está cubierto por alguna sección.
- [ ] El documento incluye portada, índice, desarrollo, conclusiones personales y referencias.
- [ ] Las **conclusiones personales** son estrictamente monolíticas: prosa corrida en párrafos continuos, sin subsecciones, listas (`itemize`), viñetas ni títulos intermedios.
- [ ] La extensión de las conclusiones personales cumple la norma: **1 cuartilla por cada 10 páginas de desarrollo**.
- [ ] Los estimados de páginas del índice aprobado se corresponden con el reparto real.

### Media

- [ ] **Ningún placeholder:** `grep -n "example_figure\|% PENDIENTE" <fuente>.tex` no devuelve nada. Cada coincidencia es **bloqueante**: antes de reportarla, aplica la colocación posterior de `registrar-media` por si el usuario ya colocó el archivo.
- [ ] Cada `\includegraphics` del `.tex` tiene su fila en `media-manifest.md`, y ninguna fila del entregable sigue `pendiente`.
- [ ] Los estados `pendiente` / `colocada` reflejan la realidad del disco (verifícalo con `ls`).
- [ ] Ninguna imagen accesible en una fuente web quedó como `pendiente` sin motivo (descarga fallida o con autenticación).
- [ ] Se le entrega al usuario la lista final de imágenes por colocar.

### Compilación

- [ ] Invoca `compilar-entregable` y confirma: compilación limpia, PDF en `ENTREGABLES/` con páginas dentro del rango de `GEMINI.md` (18 a 40 páginas, objetivo 27), sin advertencias relevantes más allá de las imágenes pendientes.

## Reporte

Agrupa por severidad y da ubicación exacta (`archivo:línea`):

```
BLOQUEANTES (impiden entregar)
  TAREAS/03_....tex:142  Cita undefined: \parencite{tanenbaum2015} no está en la .bib
  Extensión: 16 páginas, por debajo del mínimo de 18
  TAREAS/03_....tex:77   Placeholder: fig:diagramaPlanificador sigue sobre media/example_figure.png

NORMATIVOS
  TAREAS/03_....tex:88   «los PCBs» → «los PCB»
  TAREAS/03_....tex:210  \textit{scheduler} en segunda aparición; debe ir en redonda

MENORES
  TAREAS/03_....tex:301  \label{fig:figura7} alude al origen; renombrar a contenido
```
