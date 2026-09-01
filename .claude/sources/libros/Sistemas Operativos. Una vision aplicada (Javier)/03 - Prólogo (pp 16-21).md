# Prólogo

> Fuente: Sistemas Operativos. Una vision aplicada (Javier) — páginas 16–21 (numeración del PDF)

<!-- pág. 16 -->

                                                                                     Prólogo




Los sistemas operativos son una parte esencial de cualquier sistema de computación, por lo que
todos los planes de estudio de informática incluyen uno o más cursos sobre sistemas operativos.
La mayoría de libros de sistemas operativos usados en estos cursos incluyen gran cantidad de
teoría general y aspectos de diseño, pero no muestran claramente cómo se usan.
        Este libro está pensado como un texto general de sistemas operativos, pudiendo cubrir
tanto la parte introductoria como los aspectos de diseño de los mismos. En él se tratan todos los
aspectos fundamentales de los sistemas operativos, tales como procesos, gestión de memoria,
comunicación y sincronización de procesos, entrada/salida, sistemas de archivos y seguridad y
protección. Además, en cada tema, se muestra la interfaz de programación de los sistemas
operativos POSIX y Win32, con ejemplos de uso de las mismas. Esta solución permite que el lector
no sólo conozca los principios teóricos, sino cómo se aplican en sistemas operativos reales.


CONTEXTO DE DESARROLLO DEL LIBRO

A principios de los noventa, los profesores del Departamento de Arquitectura y Tecnología de la
Facultad de Informática de la Universidad de Politécnica de Madrid comenzaron a elaborar apuntes
que incluían teoría y problemas de Sistemas Operativos, con vistas a desarrollar un nuevo plan de
estudios de informática. Se revisaron cuidadosamente los planes de estudio existentes en dicha
universidad, así como los de varias otras escuelas similares. Además, se llevó a cabo una revisión
exhaustiva de bibliografía relacionada con los sistemas operativos.
        La motivación para llevar a cabo este trabajo surgió de la insatisfacción con los libros de
texto existentes en su momento, que, en líneas generales, se caracterizaban por enfatizar en los
siguientes aspectos:

    •   Teoría general sobre sistemas operativos.
    •   Aspectos de diseño detallado, generalmente específicos de un sistema operativo.
    •   Desarrollo en un ambiente de sistemas operativos clásicos.

Comparando esta situación con la del mundo real se observaban considerables diferencias:

    •   Demanda de los estudiantes para tener apoyo en las cuestiones teóricas con ejemplos
        prácticos.
    •   Necesidad de conocer los sistemas operativos desde el punto de vista de programación de
        sistemas.
    •   Visión generalista del diseño de los sistemas operativos, estudiando distintos sistemas.




Digitalización realizada con propósito académico                                                xv

<!-- pág. 17 -->

xvi    Prólogo


    Esta situación obligaba a los autores a mezclar textos generales sobre sistemas operativos con
otros libros que estudiaban sistemas operativos concretos y la forma de programarlos. Por esta
razón, entre- otras, el cuerpo de los apuntes, mencionado anteriormente, fue creciendo y
modernizándose hasta llegar a este libro.


ORGANIZACIÓN DEL LIBRO

El libro está organizado en doce temas, cuyo índice se muestra a continuación. Su contenido cubre
todos los aspectos de gestión de una computadora, desde la plataforma hardware hasta los
sistemas distribuidos. Además, se incluyen tres apéndices.
         Los temas son los siguientes:

Conceptos arquitectónicos de la computadora

En este tema se hace una somera descripción de la estructura y funcionamiento de una
computadora, desde el punto de vista de la plataforma hardware. La motivación para incluir este
capítulo es evitar la necesidad de que el lector posea conocimientos previos de estructura de
computadoras. En él se tratan aspectos tales como el modelo de programación de la computadora,
tratamiento de interrupciones, jerarquía de memoria, entrada/salida y concurrencia. Además, se
comentan breve mente los mecanismos de protección hardware.


Introducción a los sistemas operativos

En este tema se explica qué es un sistema operativo, cuáles son sus funciones principales, los
tipos de sistemas operativos existentes actualmente y cómo se activa un sistema operativo.
También se introduce brevemente la estructura del sistema operativo y de sus componentes
principales (procesos, memoria, archivos, comunicación, etc.), que se describen en detalle en
capítulos posteriores. Además, se ponen dos ejemplos concretos, como son LINUX y Windows NT.
Para terminar, se muestra la interfaz de usuario y de programador del sistema operativo.


Procesos

El proceso es la entidad más importante de un sistema operativo moderno. En este tema se
estudia en detalle el concepto de proceso, la información asociada al mismo, sus posibles estados
y las señales y temporizadores que pueden ser asociadas a un proceso. Un sistema operativo
gestiona una colección de procesos que se ejecutan de forma concurrente. La planificación de
dichos procesos es crucial para la gestión de una computadora. Es esencial explotar los recursos
de forma eficiente, equitativa y evitar bloqueos entre procesos. Además, se estudia en este
capítulo el concepto de proceso ligero (thread) y su influencia sobre los aspectos anteriores del
sistema. Todo ello se complementa con ejemplos de uso en POSIX y Windows NT


Gestión de memoria

Un proceso en ejecución reside siempre en la memoria de la computadora. Por tanto, gestionar
dicha memoria de forma eficiente es un aspecto fundamental de cualquier sistema operativo. En
este tema se estudian los requisitos de la gestión de memoria, el modelo de memoria de un
proceso,




Digitalización realizada con propósito académico

<!-- pág. 18 -->

                                                                                   Prólogo     xvii

cómo se genera dicho modelo y diversos esquemas de gestión de memoria, incluyendo la memoria
virtual. Este tema está relacionado con el Capítulo 7, debido a que la gestión de la memoria virtual
se apoya en los discos como medio auxiliar de almacenamiento de la imagen de los procesos que
no cabe en memoria principal. Al final del tema se muestran los servicios de gestión de memoria
existentes en POSIX y Win32 y algunos ejemplos de uso de los mismos.


Comunicación y sincronización de procesos

Los procesos no son entidades aisladas, sino que en muchos casos cooperan entre sí y compiten
por los recursos. El sistema operativo debe ofrecer mecanismos de comunicación y sincronización
de procesos concurrentes. En este tema se muestran los principales mecanismos usados en
sistemas operativos, tales como tuberías, semáforos o el paso de mensajes, así como algunos
aspectos de implementación de los mismos. Al final del tema se muestran los servicios de
comunicación y sincronización existentes en POSIX y Win32 y algunos ejemplos de uso de los
mismos.


Interbloqueos

Las comunicaciones, el uso de recursos compartidos y las sincronizaciones son causas de
bloqueos mutuos entre procesos, o interbloqueos. En este capítulo se presenta el concepto de
interbloqueo, así como los principales métodos de modelado de interbloqueos. Además, se
describen los principales algoritmos existentes para gestión de interbloqueos, incluyendo los de
prevención, detección y predicción de interbloqueos.


Entrada/salida

El procesador de una computadora necesita relacionarse con el mundo exterior. Esta relación se
lleva a cabo mediante los dispositivos de entrada/salida (E/S) conectados a la computadora. El
sistema operativo debe ofrecer una interfaz de acceso a dichos dispositivos y gestionar los detalles
de bajo nivel de los mismos. En este tema se muestran aspectos del hardware y el software de
E/S, estudiando una amplia gama de dispositivos, tales como los de almacenamiento secundario y
terciario, los relojes o el terminal. Al final del tema se muestran los servicios de entrada/salida
existentes en POSIX y Win32 y algunos ejemplos de uso de los mismos.


Gestión de archivos y directorios

El sistema operativo debe proporcionar al usuario mecanismos de alto nivel para acceder a la
información existente en los dispositivos de almacenamiento. Para ello, todos los sistemas
operativos incluyen un sistema de gestión de archivos y directorios. El archivo es la unidad
fundamental de almacenamiento que maneja el usuario. El directorio es la unidad de estructuración
del conjunto de archivos. En este tema se muestran los conceptos fundamentales de archivos y
directorios, la estructura de sus gestores y los algoritmos internos usados en los mismos. Al igual
que en otros temas, se muestran los servicios de archivos y directorios existentes en POSIX y
Win32 y algunos ejemplos de uso de los mismos.


Seguridad y protección

Un sistema de computación debe ser seguro. El usuario debe tener la confianza de que las
acciones internas o externas del sistema no van a ser un peligro para sus datos, aplicaciones o
para las actividades de otros usuarios. El sistema operativo debe proporcionar mecanismos de
protección



Digitalización realizada con propósito académico

<!-- pág. 19 -->

xviii    Prólogo



entre los distintos procesos que ejecutan en un sistema y entre los distintos sistemas que estén
conectados entre sí. En este tema se exponen los conceptos de seguridad y protección, posibles
problemas de seguridad, mecanismos de diseño de sistemas seguros, los niveles de seguridad
que puede ofrecer un sistema y los controles existentes para verificar si el estado del sistema es
seguro. Además, se estudian los mecanismos de protección que se pueden usar para controlar el
acceso a los distintos recursos del sistema, Al final del tema se muestran los servicios de
protección existen en POSIX y Win32 y algunos ejemplos de uso de los mismos.


Introducción a los sistemas distribuidos

Los sistemas de computación actuales raramente están aislados. Es habitual que estén
conectados formando conjuntos de máquinas que no comparten la memoria ni el reloj, es decir,
sistemas distribuidos. Este tema presenta una breve introducción a dichos sistemas, estudiando las
características de los sistemas distribuidos, sus problemas de diseño, su estructura y sus distintos
elementos (redes, comunicación, memoria distribuida, sistemas de archivo distribuido, etc.).
También se muestran distintas técnicas de diseño de aplicaciones cliente-servidor en sistemas
distribuidos.


Estudio de casos: LINUX

Este capítulo muestra en detalle los aspectos de LINUX desarrollados a lo largo del libro. Para ello
se describe, tema por tema, cómo es la arquitectura del sistema operativo LINUX, cómo son los
procesos de LINUX, sus mecanismos de comunicación y seguridad, etc.


Estudio de casos: Windows NT

Este capítulo muestra en detalle los aspectos de Windows NT desarrollados a lo largo del libro.
Para ello se describe, tema por tema, cómo es la arquitectura del sistema operativo Windows NT,
cómo son los procesos de Windows NT, su sistema de E/S, sus mecanismos de comunicación y
seguridad, etcétera.


Apéndice A. Comparación de los servicios POSIX y Win32

Tabla de llamadas al sistema de POSIX y Win32. Para cada función del sistema se muestra la
llamada POSIX y la de Win32 que lleva a cabo dicha función, junto a un breve comentario de la
misma.


Apéndice B. Entorno de programación de sistemas operativos

En este apéndice se describe cómo editar, compilar y ejecutar un programa C en UNIX/LINUX y
Windows NT. Para el caso de LINUX se usa el compilador gcc. Para el caso de Windows NT, el
Visual C++.


Apéndice C. Trabajos prácticos de sistemas operativos

En este apéndice se describen varios proyectos de prácticas de sistemas operativos desarrollados
por los autores durante varios años. Todos ellos se han llevado a efecto, por lo que se incluyen
también comentarios acerca de la realización de los mismos por los alumnos.



Digitalización realizada con propósito académico

<!-- pág. 20 -->

                                                                                    Prólogo    xix


Materiales suplementarios

Existe una página Web con materiales suplementarios para el libro, situada en la dirección:
http: //arcos.inf.uc3m.es/’ La misma información se encuentra duplicada en:
http://datsi.fi. upm. es/ ssoo-va.
          En esta página Web se puede encontrar el siguiente material:

    •   Información sobre el libro, como el prólogo, tabla de contenidos, capítulos de ejemplo en
        PDF, erratas, etc.
    •   Información de los autores y dirección de contacto.
    •   Material para el profesor, como figuras del libro, transparencias, soluciones de ejercicios
        y problemas propuestos y material de prácticas. Las prácticas que se presentan han sido
        diseñadas como trabajos de laboratorio para estudiantes de las asignaturas de Sistemas
        Operativos de la Universidad Politécnica de Madrid y de la Universidad Carlos III de
        Madrid. Se ha hecho un importante esfuerzo para generalizar sus enunciados, de forma
        que puedan desarrollarse fácilmente sobre sistemas operativos de amplia difusión como
        Linux, UNIX o Windows. En casi todos los trabajos prácticos expuestos se hace referencia
        al material de apoyo existente para las prácticas, que también se puede conseguir en las
        páginas Web anteriores.
    •   Material para el estudiante, como código fuente de los programas, figuras en PowerPoint,
        problemas propuestos de sistemas operativos, etc.


Comentario de los autores

Es un placer para nosotros poder presentar este texto a las personas interesadas en los sistemas
operativos, su diseño y su programación. La elaboración de este texto ha supuesto un arduo
trabajo para nosotros, tanto por la extensión de la obra como por los ejemplos prácticos incluidos
en la misma. Además, se ha hecho un esfuerzo importante para tratar de unificar la terminología
usada en distintos países de habla hispana. Con todo, creemos que el resultado final hace que el
esfuerzo realizado haya merecido la pena.
        El esfuerzo realizado por mostrar los dos sistemas operativos más actuales, LINUX y
Windows NT, ha dado como resultado final un texto didáctico y aplicado, que puede ser usado
tanto en cursos de introducción como de diseño de sistemas operativos. En el libro se incluyen
ejemplos que muestran el uso de las llamadas al sistema de POSIX y Win32. Dichos ejemplos han
sido cuidadosamente compilados y enlazados en los dos entornos en que estaban disponibles:
Visual C y gcc.
        Nos gustaría mostrar nuestro agradecimiento a todas las personas que han colaborado en
este texto con su ayuda y sus comentarios. Este agradecimiento se dirige especialmente a
Francisco Rosales García, Alejandro Calderón Mateos y José María Pérez Menor por su ayuda en
la compilación de los programas de ejemplo y en algunos proyectos de sistemas operativos.


Jesús Carretero Pérez                                Pedro de Miguel Anasagasti
Félix García Caballeira                              Fernando Pérez Costoya
Departamento de Informática                          Departamento de Arquitectura y Tecnología
Escuela Politécnica Superior                         de Sistemas Informáticos
Universidad Carlos III de Madrid                     Facultad de Informática
Madrid, España                                       Universidad Politécnica de Madrid
                                                     Madrid, España




Digitalización realizada con propósito académico

<!-- pág. 21 -->

Digitalización realizada con propósito académico

