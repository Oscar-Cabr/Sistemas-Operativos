---
name: consulta-fuentes
description: Investiga un tema de sistemas operativos en las fuentes confiables del proyecto — los seis libros troceados en .claude/sources/libros/ y sitios institucionales, gubernamentales, documentación oficial de software, RFCs y estándares. Devuelve extractos con su ubicación exacta y citable (libro, sección y página impresa; o URL). Úsala antes de redactar cualquier sección, para respaldar una afirmación, o para evaluar si un índice propuesto es sostenible con las fuentes disponibles.
---

# Consulta de fuentes confiables

Devuelve **material citable**, no prosa. Redactar es trabajo de `redactar-seccion`.

## Frente 1 — Libros del repositorio

Los libros de `.claude/sources/libros/` son fuente confiable directa: no requieren verificación externa.

| Libro | Directorio | Idioma |
| --- | --- | --- |
| Stallings, *Operating Systems: Internals and Design Principles*, 9ª ed. | `Operating Systems Internals and Design Principles (William Stallings)/` | inglés |
| Deitel, Deitel y Choffnes, *Operating Systems*, 3ª ed. | `Operating Systems (Harvey M. Deitel, Paul Deitel)/` | inglés |
| Deitel, *An Introduction to Operating Systems*, 2ª ed. | `An introduction to operating systems (Deitel, Harvey M., 1945-)/` | inglés |
| Silberschatz, Galvin y Gagne, *Fundamentos de sistemas operativos*, 7ª ed. | `Fundamentos de Sistemas Operativos 7o Edicion (...)/` | español |
| McHoes y Flynn, *Sistemas operativos*, 6ª ed. | `Sistemas Operativos (Ann Mclver McHoes, Ida M.Flynn)/` | español |
| Carretero et al., *Sistemas operativos: una visión aplicada*, 1ª ed. | `Sistemas Operativos. Una vision aplicada (Javier)/` | español |

Los troceados de Stallings y Deitel/Deitel llevan el capítulo en el nombre del archivo; úsalo para ir directo al material sin buscar a ciegas.

### Procedimiento

Los chunks pesan de 100 a 600 KB: **nunca se leen completos**, y el `_fulltext/*.txt` (de 2 a 5 MB) jamás se lee, solo sirve para un `grep` global cuando no sabes en qué libro buscar.

1. **Localiza los chunks.** `grep -ril "<término>" ".claude/sources/libros/"` — excluye `_fulltext/`.
2. **Localiza las líneas.** `grep -n "<término>" "<chunk>"` da los números de línea de cada aparición.
3. **Lee solo la ventana.** `Read` con `offset` y `limit` (del orden de 60 a 150 líneas) alrededor de la aparición relevante. Amplía la ventana solo si el pasaje lo exige.
4. **Resuelve la página.** Cada chunk lleva marcas `<!-- pág. N -->`. La marca inmediatamente **anterior** al extracto da su página: `grep -n "<!-- pág\." "<chunk>"` y toma la última con número de línea menor al del extracto.
5. **Corrige el desfase.** `N` es la página del **PDF**, no la impresa. Calibra siempre antes de citar: busca en el texto el número de página del encabezado o pie corriente y compáralo con la marca.

   Ejemplo verificado (Stallings): bajo `<!-- pág. 180 -->` el encabezado dice `4.1 / PROCESSES AND THREADS   179`. Desfase = −1, y de paso el encabezado te da la sección `4.1`. Cita `p.\ 179`, no 180.

6. **Contrasta.** Cuando dos libros difieran en definición, taxonomía o cifras, regístralo: es material valioso para la redacción, no un problema a ocultar.

Si hay que barrer varios libros, recórrelos uno tras otro con este mismo procedimiento y conserva de cada uno solo la tabla de salida: extracto, libro, sección y página ya corregida.

## Frente 2 — Web confiable

Evalúa la confiabilidad **en tiempo real**, no por reputación asumida.

**Aceptable**
- Dominios institucionales y gubernamentales verificables (universidades, organismos públicos).
- Documentación oficial del proyecto de software (kernel de Linux, POSIX, documentación de un lenguaje o sistema).
- RFCs de la IETF y estándares de IEEE, ISO o The Open Group.
- Artículos con DOI o publicados en revista o congreso con arbitraje.

**Inaceptable como respaldo**
- Blogs personales, foros, wikis abiertas, agregadores de contenido.
- Páginas sin autoría, sin fecha o sin institución responsable.
- Contenido que a su vez no cite fuente.

Si una fuente dudosa aporta una idea útil, busca el respaldo primario y cita ese.

## Salida

Entrega una tabla, no un ensayo:

| Afirmación | Fuente | Ubicación exacta | Tipo | ¿En .bib? |
| --- | --- | --- | --- | --- |
| El cambio de contexto exige salvar el PCB | Stallings, 9ª ed. | §3.2, p. 132 | libro | sí (`stallings2018operating`) |

Incluye el extracto textual de las afirmaciones que vayan a citarse literalmente.

## Encadenamiento

- Fuente nueva no registrada → invoca `registrar-fuente`.
- Figura, diagrama o tabla aprovechable localizada en una fuente → invoca `registrar-media`. Anota su ubicación exacta aunque el archivo no se vaya a colocar todavía.
