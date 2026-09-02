---
name: registrar-fuente
description: Da de alta una fuente en el archivo .bib del entregable con el tipo de entrada correcto para APA 7 con biblatex. Úsala cada vez que se vaya a citar un libro, sitio institucional o gubernamental, artículo académico, RFC, estándar o documentación oficial de software que aún no esté registrado en la bibliografía de ese entregable.
---

# Alta de fuente bibliográfica

## Regla crítica: una `.bib` por entregable, con `\nocite{*}`

Cada entregable tiene su propia `bibliography/<NN>_<titulo>.bib` y el template usa `\nocite{*}`, que **imprime todas las entradas del archivo, se citen o no**.

Consecuencia: la `.bib` de un entregable debe contener **exclusivamente** las fuentes usadas en ese entregable. Una entrada de más aparece en las Referencias sin respaldo en el texto. Nunca copies una `.bib` completa de otro trabajo.

## Antes de agregar

1. `grep -i "<título o autor>" bibliography/*.bib`
2. Si la fuente **ya existe en otro entregable**, copia esa entrada tal cual, con **la misma clave**. La consistencia de claves entre trabajos es deliberada.
3. Si ya existe en la `.bib` de este entregable, no hagas nada: reutiliza la clave.

## Claves

Minúsculas, sin acentos: `<apellido><año><palabraTítulo>` para personas, `<siglaInstitución><año>` para organismos. Si dos entradas colisionan, sufija `a`, `b`.

## Árbol de decisión

Aplícalo en orden y detente en la primera coincidencia:

1. ¿Tiene DOI o se publicó en revista o congreso con arbitraje? → `@article` / `@inproceedings`
2. ¿Es un estándar formal o RFC con número de documento oficial? → `@techreport`
3. ¿Es un libro con ISBN o editorial identificable? → `@book`
4. Cualquier otro caso (documentación web, institucional o de software) → `@online`

## Plantillas

```bibtex
@article{<clave>,
  author      = {Apellido, Nombre and Apellido, Nombre},
  title       = {Título del artículo},
  journaltitle= {Nombre de la revista},
  year        = {AAAA},
  volume      = {N},
  pages       = {N--N},
  doi         = {10.xxxx/xxxxx}
}

@techreport{<clave>,
  author      = {{Internet Engineering Task Force}},
  title       = {Transmission Control Protocol (TCP)},
  year        = {2022},
  number      = {RFC 9293},
  institution = {IETF},
  url         = {https://www.rfc-editor.org/rfc/rfc9293},
  urldate     = {AAAA-MM-DD}
}

@online{<clave>,
  author   = {{Nombre de la institución o del proyecto de software}},
  title    = {Título de la página o del documento},
  year     = {AAAA},        % o {n.d.} si no hay fecha
  version  = {6.12},        % solo si la versión es relevante para lo citado
  url      = {https://...},
  urldate  = {AAAA-MM-DD},
  langid   = {spanish}
}
```

En `@online`, el `author` va **entre llaves dobles**: institución (`{{Universidad Nacional Autónoma de México}}`) o nombre del proyecto de software (`{{The Linux Kernel Documentation}}`, `{{Rust Project}}`). Nunca una persona, salvo que la documentación acredite a un autor concreto.

## Libros del repositorio — entradas verificadas

Copia y pega. Los datos están tomados de las páginas de créditos de los propios PDF; no los rehagas.

```bibtex
@book{stallings2018operating,
  author    = {Stallings, William},
  title     = {Operating Systems: Internals and Design Principles},
  edition   = {9},
  year      = {2018},
  publisher = {Pearson Education Limited},
  location  = {Harlow},
  isbn      = {978-0-13-467095-9},
  note      = {Global Edition},
  langid    = {english}
}

@book{deitel2004operating,
  author    = {Deitel, Harvey M. and Deitel, Paul J. and Choffnes, David R.},
  title     = {Operating Systems},
  edition   = {3},
  year      = {2004},
  publisher = {Pearson Prentice Hall},
  location  = {Upper Saddle River, New Jersey},
  isbn      = {0-13-124696-8},
  langid    = {english}
}

@book{deitel1990introduction,
  author    = {Deitel, Harvey M.},
  title     = {An Introduction to Operating Systems},
  edition   = {2},
  year      = {1990},
  publisher = {Addison-Wesley},
  location  = {Reading, Massachusetts},
  isbn      = {0-201-50939-3},
  langid    = {english}
}

@book{silberschatz2006fundamentos,
  author    = {Silberschatz, Abraham and Galvin, Peter Baer and Gagne, Greg},
  title     = {Fundamentos de sistemas operativos},
  edition   = {7},
  year      = {2006},
  publisher = {McGraw-Hill/Interamericana de España},
  location  = {Madrid},
  langid    = {spanish}
}

@book{mchoes2011sistemas,
  author    = {McHoes, Ann McIver and Flynn, Ida M.},
  title     = {Sistemas operativos},
  edition   = {6},
  year      = {2011},
  publisher = {Cengage Learning Editores},
  location  = {México},
  isbn      = {978-607-481-485-9},
  langid    = {spanish}
}

@book{carretero2001sistemas,
  author    = {Carretero Pérez, Jesús and García Carballeira, Félix and
               Miguel Anasagasti, Pedro de and Pérez Costoya, Fernando},
  title     = {Sistemas operativos: una visión aplicada},
  edition   = {1},
  year      = {2001},
  publisher = {McGraw-Hill/Interamericana de España},
  location  = {Madrid},
  isbn      = {84-481-3001-4},
  langid    = {spanish}
}
```

## Después de agregar

Invoca `compilar-entregable`. Un `.bib` malformado o una clave duplicada solo se detectan al correr `biber`; revisa que no aparezcan avisos de entrada repetida ni de campo desconocido.
