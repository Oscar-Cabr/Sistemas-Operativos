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

1. **Localiza los chunks.** `grep -ril "<término>" ".claude/sources/libros/"` — excluye `_fulltext/`.
2. **Lee solo el chunk relevante**, nunca el `_fulltext/*.txt` completo (son de 2 a 5 MB cada uno). `_fulltext/` sirve únicamente para un `grep` global rápido cuando no sabes en qué libro buscar.
3. **Resuelve la página.** Cada chunk lleva marcas `<!-- pág. N -->`. La marca inmediatamente **anterior** al extracto da su página.
4. **Corrige el desfase.** `N` es la página del **PDF**, no la impresa. Calibra siempre antes de citar: busca en el texto el número de página del encabezado o pie corriente y compáralo con la marca.

   Ejemplo verificado (Stallings): bajo `<!-- pág. 180 -->` el encabezado dice `4.1 / PROCESSES AND THREADS   179`. Desfase = −1, y de paso el encabezado te da la sección `4.1`. Cita `p.\ 179`, no 180.

5. **Contrasta.** Cuando dos libros difieran en definición, taxonomía o cifras, regístralo: es material valioso para la redacción, no un problema a ocultar.

### Delegación a subagentes

Si hay que barrer **tres o más libros**, lanza un subagente `Explore` por libro, en paralelo, cada uno con el término de búsqueda y la instrucción de devolver solo: extracto textual, libro, sección y página ya corregida. Así los megabytes de texto no entran al contexto principal.

Para una consulta puntual en un capítulo que ya tienes localizado, hazla directamente.

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
