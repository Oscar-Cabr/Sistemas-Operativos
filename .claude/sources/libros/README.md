# Libros pre-procesados para el contexto del proyecto (claude.ai)

Cada PDF se convirtió a texto (`pdftotext -layout`; OCR con `tesseract -l spa` para el
Silberschatz, que era un escaneo) y se unificó en **un solo `.md` por libro** en
`_libros_unificados/`. Los marcadores `<!-- pág. N -->` indican la página del PDF para citar.

## Qué subir a claude.ai
Sube los 6 archivos de **`_libros_unificados/`** (uno por libro, sin carpetas):

- `An introduction to operating systems (Deitel, Harvey M., 1945-).md` — 2.46 MB
- `Fundamentos de Sistemas Operativos 7o Edicion (Abraham Silberschatz, Peter Galvin etc.).md` — 2.88 MB
- `Operating Systems (Harvey M. Deitel, Paul Deitel).md` — 4.85 MB
- `Operating Systems Internals and Design Principles (William Stallings).md` — 4.26 MB
- `Sistemas Operativos (Ann Mclver McHoes, Ida M.Flynn).md` — 2.39 MB
- `Sistemas Operativos. Una vision aplicada (Javier).md` — 1.87 MB

**Total: 18.72 MB de texto** (PDF originales ~220 MB). Todos < 30 MB/archivo.
El Silberschatz proviene de OCR: revisa citas literales contra el PDF antes de usarlas.

## Otras carpetas (no hace falta subir)
- `_fulltext/` — texto crudo, 1 `.txt` por libro, sin encabezados de sección.
- `<Nombre del libro>/` — versión troceada por capítulo / por bloques de 60 págs.
- `silberschatz_ocr.pdf` (en scratchpad) — el PDF con capa de texto, 121 MB, no subible.
