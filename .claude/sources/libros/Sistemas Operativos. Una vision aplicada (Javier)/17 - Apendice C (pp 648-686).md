# Apendice C

> Fuente: Sistemas Operativos. Una vision aplicada (Javier) — páginas 648–686 (numeración del PDF)

<!-- pág. 648 -->

                                                     Trabajos prácticos
                                                                                      C
                                                de sistemas operativos




Las prácticas que se presentan en este apéndice fueron diseñadas como trabajos de laboratorio
para estudiantes de las asignaturas de Sistemas Operativos de la Universidad Politécnica de
Madrid y de la Universidad Carlos III de Madrid. Todas las prácticas se han desarrollado en uno u
otro entorno y fueron pensadas para ellos, por lo que es posible que existan todavía en los
enunciados dependencias o referencias cercanas o derivadas de dichos en tornos. No obstante, se
ha hecho un importante esfuerzo para generalizar dichos enunciados. De forma que puedan
desarrollarse fácilmente sobre sistemas operativos de amplia difusión como Linux, UNIX o
Windows NT. De cualquier forma, es importante que los profesores que pretendan usar estos
trabajos de laboratorio revisen cuidadosamente cada uno de ellos y lleven a cabo una etapa previa
de adaptación a sus entornos de prácticas. Esto evitará errores y confusión a los alumnos.
        En casi todos los trabajos prácticos expuestos se hace referencia al material de apoyo
existente para las prácticas. Este material se puede conseguir en las páginas WWW del libro, cuya
referencia es: http://datsi.fi.upm.es/~ssoo-va y http://arcos.inf.uc3m.es/~ssoo-va
        Los trabajos prácticos que se proponen en este apéndice se describen brevemente a
continuación:

   1. Programación de scripts. El objetivo de esta práctica es familiarizarse con el intérprete de
      mandatos de UNIX que. Además de ser la interfaz de usuario del sistema. Ofrece una
      poderosa herramienta de programación que permite a los usuarios, tanto ordinarios como
      administradores, construir nuevos mandatos (shell scripts) sin tener que utilizar
      directamente los servicios proporcionados por el sistema operativo.
   2. Llamadas al sistema para la gestión de procesos. Esta práctica permite al alumno
      familiarizarse con los servicios para la gestión de procesos que proporciona POSIX.
      Asimismo, se pretende que conozca cómo es el funcionamiento interno de un intérprete de
      mandatos en UNIX/Linux. El alumno deberá diseñar y codificar, en lenguaje C y sobre
      sistema operativo UNIX/Linux, un programa que actúe como intérprete de mandatos.




Digitalización Realizada con propósito académico. Sistemas Operativos                     669

<!-- pág. 649 -->

670       Sistemas Operativos. Una visión aplicada




      3. Llamadas al sistema para la gestión de archivos. Esta práctica permite al alumno
         familiarizarse con los servicios para la gestión de archivos que proporciona POSIX. El
         alumno deberá diseñar y codificar, en lenguaje C y sobre un sistema operativo UNIX/Linux,
         dos programas: uno que permita copiar un archivo sobre otro y otro que permita lisiar el
         contenido de un directorio.
      4. Gestión de interrupciones de un reloj. En esta práctica se pretende que el alumno se
         familiarice con los mecanismos de gestión de interrupciones. Para ello se propone que el
         alumno desarrolle un manejador muy simplificado de un reloj, que se simula con un
         pseudodispositivo disponible en el material de apoyo.
      5. Comunicación de procesos con sockets. En esta práctica se pretende que el alumno se
         familiarice con los mecanismos de comunicación entre procesos, usando sockets como
         mecanismo de comunicación. Además, el alumno tendrá ocasión de experimentar con un
         sistema cliente-servidor.
      6. Diseño de un sistema multiprogramado. El objetivo de esta práctica es llegar a conocer
         los principales conceptos relacionados con la gestión de procesos y la multiprogramación.
         El trabajo va a Consistir básicamente en convertir un sistema con monoprogramación en
         uno multiprogramado.
      7. Diseño de un sistema de archivos con bandas. Esta práctica tiene tres objetivos
         principales: que el alumno entienda que se puede optimizar el almacenamiento en archivos
         haciendo uso de la concurrencia y del paralelismo, enseñar al alumno a diseñar las
         estructuras que representan un archivo y familiarizar al alumno con los mecanismos de
         programación de sistemas de archivos.

      Los trabajos prácticos descritos se pueden dividir en dos grupos:

      •   Prácticas generalistas de sistemas operativos. Prácticas 1 a la 5. Son adecuadas para
          cualquier curso de Sistemas Operativos. Para desarrollarlas es necesario haber seguido en
          clase de teoría las secciones del libro que, en cada capítulo, muestran los aspectos de
          introducción a los Sistemas Operativos.
      •   Prácticas de diseño de sistemas operativos. Prácticas 6 y 7. Estas prácticas se han
          pensado específicamente para un curso de Diseño de Sistemas Operativos. Para
          desarrollarlas es necesario haber seguido en clase de teoría las secciones del libro que, en
          cada capítulo, muestran los aspectos de diseño de Sistemas Operativos.

    En cuanto al lenguaje de programación a utilizar para llevar a cabo los trabajos prácticos,
aunque se recomiendan los lenguajes C y C++, () es estrictamente necesario, ya que las prácticas
se pueden desarrollar en cualquier otro lenguaje. Es importante tener en cuenta que los materiales
de apoyo sólo están disponibles en lenguaje C.


PRÁCTICA C.1. PROGRAMACIÓN DE SCRIPTS

C.1.1. Objetivo de la práctica

El objetivo de esta práctica es familiarizarse con el intérprete de mandatos de UNIX que, además
de ser la interfaz de usuario del sistema, ofrece una poderosa herramienta de programación que
permite a los usuarios, tanto ordinarios como administradores, construir nuevos mandatos (shell-
scripts) sin tener que utilizar directamente los servicios proporcionados por el sistema operativo.
         Un aspecto que conviene resaltar desde el principio es la dificultad de programación en
este entorno. La sintaxis y el modelo de programación son bastante inusuales, lo que hace un poco




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 650 -->

                                  Apéndice C. Trabajos prácticos de sistemas operativos             671




difícil escribir los primeros programas. Sin embargo. El esfuerzo merece la pena puesto que
permite llegar a conocer mejor cómo funciona el sistema.


C.1.2. Descripción de la funcionalidad a desarrollar por el alumno

La práctica consiste en desarrollar un script denominado dirmix que lleve a cabo la unión del
contenido de un conjunto de directorios. El script recibirá como argumentos:

    •   Un criterio de selección, cuyo objetivo se explicará un poco más adelante.
    •   Un directorio destino.
    •   Un conjunto de directorios origen.

     Después de la ejecución de dirmix. En el directorio destino habrá una copia de todos los
archivos (sólo de los archivos, no de los directorios) de los directorios origen especificados,
teniendo en cuenta también los contenidos inicialmente existentes en el propio directorio destino.
Cada copia debe preservar las características del archivo original, tales como su propietario o las
fechas asociadas al mismo (mandato cp —p). En el caso de que exista un archivo con el mismo
nombre en dos o más de los directorios (incluyendo también el directorio destino), se aplicará el
criterio (le selección, que se recibe como primer argumento, para determinar cuál (le ellos se copia
al directorio destino. De esta forma, el criterio de selección no está incluido en el script, sino que se
trata de un programa que éste recibe como argumento.
Como parte de la práctica se deberá también construir un script. Denominado más nuevo. Que
realice la selección teniendo en cuenta la fecha de última modificación (le los archivos.

Descripción de masnuevo

Este script recibirá como argumentos los archivos a los archivos se pretende aplicar el criterio de
comparación y escribirá por su salida estándar cuál ha sido el archivo elegido al aplicar el criterio
de selección correspondiente. El criterio consistirá en seleccionar el archivo cuya fecha de última
modificación sea más reciente (una posible forma (le hacerlo es usando alguna (le las opciones del
mandato ls).

Descripción de dirmix

El mandato dirmix se usará de la siguiente forma:

dirmix criterio dir_dest dir_org1. . . dir_orgn

Como se explicó antes, después de la ejecución (le este mandato, en el directorio dir_dest deberá
quedar tina copia de todos los archivos que había inicialmente en cada dir_org junto con los que
había en dir_dest habiéndose aplicado el mandato criterio para determinar cuál debe copiarse en
caso de coincidencia de nombres.
   El script dirmix deberá:

    •   Comprobar que el número de argumentos recibidos es mayor o igual que 3 y que el
        segundo es un directorio. Si no se cumple alguna de estas dos condiciones, el programa
        deberá terminar inmediatamente imprimiendo un mensaje (le error por la salida de error
        estándar y devolviendo un valor igual a 1




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 651 -->

672       Sistemas Operativos. Una visión aplicada




      •   Si durante el procesado de un argumento correspondiente a un directorio origen se detecta
          que no es un directorio, se mostrará un mensaje de error por la salida de error estándar y
          se continuara con el procesado de los siguientes. Al final el programa deberá devolver un
          valor igual a 2.
      •   En el caso de que a la hora de copiar un archivo exista un directorio con el mismo nombre
          en el directorio destino, no se realizará la operación, se imprimirá un mensaje de error y se
          continuará tratando el siguiente archivo. En este caso, el programa no devolverá al final
          ningún valor de error (o sea, devolverá un O).
      •   Cuando se precise aplicar el criterio de selección para determinar qué archivo se debe
          copiar, se invocará al programa recibido como primer argumento pasándole como
          argumentos los archivos que se quieren comparar. El programa escribirá por su salida
          estándar el nombre del archivo elegido.

     Hay muchas maneras de estructurar este .script. El esquema más intuitivo, aunque no más
eficiente, sería ir procesando cada directorio origen realizando la copia de los archivos que
cumplan las condiciones. Este esquema puede implicar copiar un archivo que luego es sobrescrito
por otro de un directorio posterior.
Una versión más eficiente que elimina la necesidad de realizar estas operaciones de copia
innecesarias consistiría en. Luego el script sólo copiara un archivo al directorio destino si está
seguro que es el que debe quedar allí al final del proceso. Observe que esta versión sería bastante
más complicada de programar que la anterior.


C.1.3. Recomendaciones generales al alumno

      •   Desarrolle primero el script más nuevo.
      •   Continúe introduciendo la funcionalidad de dirmix en el orden en que se describe en la
          sección anterior.
      •   Nunca ejecute mandatos complejos para probar la primera vez. Pruebe primero copiando
          de un único directorio con criterios bien definidos.


C.1.4. Documentación a entregar

Se recomienda que el alumno entregue los siguientes archivos:
    • autores: archivo con los datos de los autores.
    • memoria.txt: memoria de la práctica.
    • masnuevo y dirmix: códigos fuentes de los scripts con toda la funcionalidad que requieren.


C.1.5. Bibliografía

S. R. Bourne. The UNIX System. Addison-Wesley, 1983
K. Havilland, D. Cray y 13. Salama. UNIX System / Addison—Wesley. 1999.
13. Kernighan y R. Pike. The UNIX Programing Enviromen 2 edición. Prentice-Hall, 1 994
M. J. Rocking. Advanced UNIX Programming Prentice—Hall, 1 9
SUN Microsystems. /‘, Programming Utilizes and Libreries. Sum Microsystems Microsystems, 1990.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 652 -->

                                 Apéndice C. Trabajos prácticos de sistemas operativos            673




PRÁCTICA C.2. LLAMADAS AL SISTEMA PARA LA GESTIÓN DE PROCESOS

C.2. 1. Objetivo de práctica

Esta práctica permite al alumno fan con los servicios para la gestión de procesos que
proporciona POSIX. Asimismo, se pretende que conozca cómo es el funcionamiento interno del un
intérprete de mandatos en UNIX/Linux.
         Esta práctica cubre los objetivos de programación de llamadas al sistema y del capítulo de
procesos.
         El alumno deberá diseñar y codificar, en lenguaje C y sobre sistema operativo UNIX/Linux,
un programa que actúe como intérprete de mandatos. El programa deberá seguir estrictamente las
especificaciones y requisitos contenidos en este documento.
         Con la realización de este programa el alumno adquirirá valiosos conocimientos de
programación en entorno POSIX. Tanto en el uso de las llamadas al sistema operativo (FORK,
EXEC, SIGNAL, PIPE, DUP, etc.), como en el manejo de herramientas como el visualizador de
páginas de manual man, el compilador de C gcc. el regenerador de programas make, etc.
Nota: Durante la lectura de este documento encontrará la notación “man -s# xxxxx”. Que sugiere
usar el mandato man de UNIX/Linux para obtener información sobre la orden xxxxx de la sección #.
Por favor, siga las recomendaciones.


C.2.2. Descripción de la funcionalidad a desarrollar por el alumno

El intérprete de mandatos a desarrollar o, minishell utiliza la entrada estándar (descriptor de archivo
()), para leer las líneas de mandatos que interpreta y ejecuta. Utiliza la salida estándar (descriptor
de archivo 1) para presentar el resultado de las órdenes internas. Y utiliza la salida de error
estándar (descriptor de archivo 2) para mostrar las variables especiales promp y bqpid (véase el
epígrafe Variables especiales), así como para notificar los errores que puedan dar. Si ocurre un
error en alguna llamada al sistema, se utiliza para notificarlo la función de librería perror.
Para el desarrollo de esta práctica se recomienda proporcionar al alumno un parser que le permita
leer los mandatos introducidos por el usuario. Así, el alumno sólo deberá preocuparse de
implementar el intérprete de mandatos.
La sintaxis que se propone para este p es similar a la sintaxis que comprende el parser del
intérprete de mandatos del sistema operativo UNIX:

    •   Blanco: es un carácter tabulador o espacio.
    •   Separador: es un carácter con significado especial (<>&). El fin de línea o el fin de archivo
        (por teclado CTRL-D).
    •   Texto: es cualquier secuencia de caracteres delimitada por blanco o separador.
    •   Mandato: es una secuencia de textos separados por blancos. El primer texto especifica el
        nombre del mandato a ejecutar. Las restantes son los argumentos del mandato invocado.
        El nombre del mandato se pasa como argumento 0 (man execvp) Cada mandato se
        ejecuta como un proceso hijo directo del mininisheil (man Cork). El valor de un mandato es
        su estado de determinación (man —s2 wait). Si la ejecución falla. Se nodifica el error (por
        el estándar error).
    •   Secuencia: es una secuencia de dos o más mandatos separados por ‘1 ‘La salida estándar
        de cada mandato se conecta por una tubería (man pipe) a la entrada estándar del
        siguiente. El, minishell normalmente espera la terminación del último mandato de la
        secuencia antes de solicitar la siguiente línea de entrada. El valor de una secuencia es el
        valor del último man dato de la misma.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 653 -->

674       Sistemas Operativos. Una visión aplicada



      •   Redirección: la entrada o la salida de un mandato o secuencia puede ser redirigida
          añadiendo tras él la siguiente nutación. En caso de cualquier error durante las
          redirecciones, se notifica (por la salida de error estándar) y se suspende la ejecución de la
          línea.
          — < archivo: usa archivo como entrada estándar abriéndolo para lectura (man open).
          — > archivo: usa archivo como salida estándar. Si el archivo no existe se crea, si existe se
          trunca (man creat), modo de creación 0666.
          — >& archivo: usa archivo como estándar error. Si el archivo no existe se crea, si existe se
          trunca (man creat), modo de creación 0666.
      •   Background (&): un mandato o secuencia terminado en ‘& ‘supone la ejecución asíncrona
          del mismo, esto es, el minishell no queda bloqueado esperando su terminación. Ejecuta el
          mandato sin esperar por él imprimiendo por pantalla el identificador del proceso por el que
          habría esperado con el siguiente formato: [ \n”.
      •   Prompt: mensaje de apremio antes de leer cada línea. Por defecto será “msh>”.


Obtención de la línea de mandatos leída

Para obtener la línea de mandatos tecleada por el usuario se recomienda proporcionar al alumno
una función obtain_order cuyo prototipo es el siguiente:


          Int obtain_order (char ***argvv, char **filev, int *bg);

        El código fuente de esta Función puede encontrarse en el material complementario
existente en la página Web del libro. A continuación, describimos su comportamiento. La llamada
devuelve O en caso de teclear Control-D (EOF), —1 si se encontró un error. Si se ejecuta con éxito
la llamada, devuelve el número de mandatos más uno. Así:

      •   Para 1s -1 devuelve 2.
      •   Para 1s | sort devuelve 3.

   El argumento argvv permite tener acceso a todos los mandatos introducidos por el usuario.
Con el argumento f 11ev se pueden obtener los archivos utilizados en la redirección:

      •   Filev [0] apuntará al nombre del archivo a utilizar en la redirección de entrada en caso de
          que exista o NEJLL si no hay ninguno.
      •   Filev [1] apuntará al nombre del archivo a utilizar en la redirección (le salida en caso de que
          exista o N U LL si no hay ninguno.
      •   Filev [2] apuntará al nombre del archivo a utilizar en la redirección (le la salida de error en
          Caso de t exista o NULL S no hay ninguno.

    El argumento bg es 1 si el mandato o secuencia (le mandatos debe ejecutarse en background.
Si el usuario teclea ls —1 sort > archivo, los argumentos anteriores tendrán la disposición que se
muestra en la Figura C. 1


Desarrollo del minishell

Para desarrollar el minishell el alumno debe seguir una serie de pasos de tal forma que se
construyan el, minishell de forma incremental. En cada paso se añadirá nueva funcionalidad sobre
el anterior.
    1. Ejecución de mandatos simples del tipo 1 s — 1, who, etc. Para esta sección deberá usar
         as llamadas al sistema fork, wait y execve.


Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 654 -->

                                 Apéndice C. Trabajos prácticos de sistemas operativos             675




Figura C.1. Disposición de los argumentos en argvv

     2. Ejecución de mandatos simples con redirecciones (entrada, salida y de error). Además de
         las llamadas anteriores deberá usar las llamadas dup o dup2.
     3. Ejecución de mandatos simples en back No se debe usar wait.
     4. Ejecución de secuencias de mandatos conectados por pipe. Usar la llamada pipe.
     5. Tratamiento de señales. Ni el minishell ni las órdenes lanzadas en background deben morir
         por señales generadas desde teclado (SIGINT, SIGQUIT) (man signal), por tanto, éstas
         son ignoradas. Por contra, las órdenes lanzadas en foreground deben morir si le llegan
         estas señales, por tanto, mantienen la acción por defecto.
     6. Ejecución de mandatos internos. Un mandato interno es aquel que bien se corresponde
         directamente con una llamada al sistema o bien es un complemento que ofrece el propio,
         minishell. Para que su efecto sea permanente, ha de ser implementado y ejecutado dentro
         del propio, minishell. Será ejecutado en un, subshell (man fork) sólo si se invoca en
         background o aparece en una secuencia y no es el último.
     Todo mandato interno comprueba el número de argumentos con que se le invoca, y si
encuentra este o cualquier otro error, lo notifica (por la salida de error estándar) y termina con valor
distinto de cero.
     Los mandatos internos del minishell son:

    •   cd [Cambia el directorio por defecto (man s2 chdir). Si aparece Directorio debe cambiar al
        mismo. Si no aparece, cambia al directorio especificado en la variable de entorno HOME.
        Presenta (por la salida estándar) como resultado el camino absoluto al directorio actual de
        trabajo (man getcwd) con el formato: “%s\n”.
    •   umask [Cambia la máscara de creación de archivos (man s2 umask). Presenta (por la
        salida estándar) como resultado el valor de la actual máscara con el formato: “%o \n”.
        Además, si aparece Valor (dado en octal, man strtol), cambia la máscara a dicho valor.


C.2.3. Código fuente de apoyo

Para Facilitar la realización de esta práctica, se recomienda proporcionar a los alumnos un parser
que les evite tener que programar el suyo propio. Esto es importante, porque nuestra experiencia




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 655 -->

676       Sistemas Operativos. Una visión aplicada



nos dice que si no se proporciona dicho parser, los alumnos dedican la mayor parte del tiempo ha
programado y no se centran en los aspectos de sistemas operativos. En concreto, a nuestros
alumnos se les proporciona el siguiente código de apoyo, que puede encontrarse en la página Web
del libro:

      •   Makefile. Archivo fuente para la herramienta make. Con él se consigue la recopilación
          automática sólo de los archivos fuente que se modifiquen.
      •   y. c. Archivo fuente de C. Define funciones básicas para usar la herramienta lex.
      •   Scanner. 1. Archivo fuente para la herramienta lex. Con él se genera automáticamente
          código C que implementa un analizador lexicográfico (scanner) que permite reconocer al
          tokens, considerando los posibles separadores (\t 1
      •   parser.y. Archivo fuente para la herramienta yacc. Con él se genera automáticamente
          código C que implementa un analizador gramatical (parser) que permite reconocer
          sentencias correctas de la gramática de entrada del minishell.
      •   main. c. Este archivo es el que debe modificar el alumno para incluir en él su práctica. Se
          recomienda estudiar detalladamente la función obtain_order para la correcta comprensión
          del uso de la función de interfaz. La versión que se ofrece hace eco de las líneas tecleadas
          que sean sintácticamente correctos. Esta funcionalidad debe ser eliminada y sustituida por
          la ejecución de las líneas tecleadas.


C.2.4. Recomendaciones generales al alumno

      •   Desarrolle el, minishell por etapas, complicándolo progresivamente. Comience
          implementando una versión elemental como la que aparece en el libro de texto.
      •   Continúe introduciendo la funcionalidad en el orden en que se describen en la sección
          Desripción de la práctica.
      •   Lea las páginas de manual a las que se hace referencia.
      •   Cuando tenga una idea clara de cómo implementar lo que se le pide, codifíquelo, compile y
          pruebe su práctica.


C.2.5. Documentación a entregar

Se recomienda que el alumno entregue los siguientes archivos:

      •   autores. Archivo con los datos de los autores.
      •   memoria. txt. Memoria de la práctica.
      •   Main. c. Código fuente del minishell, implementando toda la funcionalidad que se
          requieren.


C.2.6. Bibliografía

S. R. I3ouriie. luí’ (!Nlt’ ,S’v.vte,n. Addison—Wesley, 1953.
M J. Rochkiiid. Ailiíimeí/ UNIX Prot,’,’cuniiiint,’. lkeniice—I-laII, 1955.
SUN Miciosystctiis. P;oi (JtjIjíje.s aiid Librarjc.s. Sun N4icrosysteiiis. 1990.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 656 -->

                                  Apéndice C. Trabajos prácticos de sistemas operativos        677




PRÁCTICA C.3. LLAMADAS AL SISTEMA PARA LA GESTIÓN DE ARCHIVOS

C.3. 1. Objetivo de la práctica


Esta práctica permitirá al alumno familiarizarse con los servicios que ofrece el estándar POSIX para
la gestión (le archivos y directorios.
         Esta práctica cubre los conceptos del Capítulo 8.


C.3.2. Descripción de la funcionalidad a desarrollar por el alumno


Parte obligatoria de la práctica

Se trata de desarrollar dos programas similares a los mandatos cp y 1s de UNIX. El primero se
denominará copy y el segundo mus. A continuación, se describen estos dos programas.


Programa copy

Este programa copiará un archivo a otro. Su sintaxis será la siguiente:

copy archivo_origen archivo_destino

El programa deberá copiar archivo_origen en archivo_destino. Si el archivo destino no existe,
deberá crearse. En caso de existir, deberá crearse su contenido. En este caso se deberán utilizar
las llamadas al sistema POSIX que sean necesarias.


Programa mils

Se trata de desarrollar un programa similar al mandato 1 s de UNIX, aunque con mucha
funcionalidad reducida. El programa se denominará mus y recibirá el nombre de uno o varios
directorios y mostrará el contenido de cada tino de ellos. Si no recibe ningún argumento. listará el
contenido del directorio actual (.). En el caso de que alguno de los argumentos no sea un directorio
sino un archivo ordinario, el programa tratará directamente el archivo imprimiendo una línea que lo
describa.
         Cuando no recibe ninguna opción muestra sólo el nombre de los archivos contenidos en el
directorio restringiéndose a aquellos cuyo nombre no empieza por el carácter . (se podría decir que
en UNIX los archivos cuyo nombre empieza por dicho carácter son ocultos). El programa puede
además recibir dos opciones:

    •   Si recibe la opción —a, mostrará todos los archivos, es decir, los ocultos y no ocultos.
    •   Si se especifica la opción -1, además del nombre de cada archivo se imprimirá en la misma
        línea algunos de sus atributos: su tipo (R para regular. 1) para directorio, C para un
        dispositivo de caracteres, B para un dispositivo de bloques y F para un FIFO), el número
        de enlaces, el tamaño y la fecha del último acceso. Para procesar este último valor se
        recomienda usar las funciones gmtime o localtime (se recomienda consultar el manual
        interactivo del sistema para aclarar su uso: man gmtime o man localtime).




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 657 -->

678       Sistemas Operativos. Una visión aplicada




Un ejemplo de ejecución del mandato mus —la sería el siguiente:
D      2 12456        27/1/98 .
D      6 8978         27/1/98 ..
R      1 9878          27/1/98 f1.o
R      1 1024          27/1/98 f2
R      1 2039          27/1/98 f3.c
R      1 2345          27/1/98 f5.c
R      1 19288        27/1/98 f7.c
R      1 512          27/1/98 f9.c

         La primera columna indica el tipo de cada archivo, la segunda el número de enlaces, la
tercera el tamaño, la cuarta la fecha del último acceso. La última línea contiene el nombre del
archivo.


Parte opcional de la práctica

Se plantea una parte opcional que consiste en modificar el programa mil s anterior para que realice
un listado recursivo (opción —R) de todo el árbol de archivos y directorios que hay por debajo de
cada uno de los directorios que recibe como argumento.
          Uno de los aspectos que hay que tener en cuenta a la hora de realizar el recorrido
recursivo es que se debe evitar atravesar los directorios. y . . presentes en todo directorio ya que
de hacerlo se entraría en un bucle infinito.
          Para emular dentro de lo posible el comportamiento de este mandato en UNIX, el recorrido
del árbol se hará como se describe a continuación. No se realizarán las llamadas recursivas
correspondientes a los subdirectorios encontrados en un determinado directorio hasta que no se
haya tratado dicho directorio. Una posible forma de llevar a cabo este recorrido es utilizar una lista.
Cada vez que el programa encuentre un directorio, insertará su nombre en la lista. Cuando se haya
terminado de recorrer un determinado directorio, se comenzará con los directorios que se han
almacenado en la lista, cada uno de los cuales se recorrerá a su vez de la forma descrita. A
continuación se presenta un posible pseudo código de dicho recorrido. Este pseudocódigo asume
la existencia de dos funciones, insertar y extraer. La primera introduce el nombre de un directorio
en la lista y la segunda lo extrae.

recorrido (root) {
        para cada nodo que cuelgue directamente de roo {
        visitar eL nodo;
        if (nodo es un directorio)
                  insertar (nodo);
        }
        While (lista no sea vacía) {
                  extraer (&next)
                  recorrido(next)
        }
}

          El alumno deberá modificar el programa mi1s siguiendo las siguientes formas:
      •   Se deberá recuperar la opción —R dentro de la función main.
      •   Se deberá incorporar el recorrido descrito anteriormente, para lo cual deberá implementar
          la lista y las funciones insertar y extraer comentadas.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 658 -->

                                 Apéndice C. Trabajos prácticos de sistemas operativos         679




C.3.3. Código fuente de apoyo

Para facilitar la realización de la práctica se recomienda proporcionar a los alumnos un archivo
comprimido que contenga el código fuente de apoyo. Dentro del existente de la página web del
libro. Se han incluido los siguientes archivos:

    •   Make file. Archivo fuente para la herramienta make. Con él Se Consigue la recopilación
        automática de los archivos fuente cuando se modifiquen. Basta con ejecutar el mandato
        make para que el programa se compile de forma automática.
    •   copia. Archivo fuente de C donde se incluirá el programa copy.
    •   mils.c. Archivo fuente de C donde se incluirá el programa mus.


C.3.4. Recomendaciones generales al alumno

Es importante estudiar previamente el funcionamiento del mandato cp y 1s de UNIX.
        A continuación se listan los servicios que se pueden necesitar a la hora de desarrollar la
práctica: open, read, write, close, chdir, closedir, getcwd, opendir, readdiry stat.


C.3.5. Documentación a entregar

Se recomienda que el alumno entregue los Siguientes archivos:
    • autores. Archivo con los datos de los autores.
    • memoria . txt. Memoria de la práctica.
    • copy. c. Código fuente del programa copy.
    • mils.c. Código fuente del programa mus.


C.3.6. Bibliografía

J. L. Antonakos y K. C. Mansfiled ir. Progrwnación Esi,ucuiirada en (7. Pz’cniice—Hall. 997.
B. Kcrnigham y D. Ritchie. TIu’ (7 progralnining Language, 2. edición. Pre,iticc—HaIl. l 9
M. J. Rochkind. Advaneed UNIX Programining. Prentice-Hall. l9


PRÁCTICA C.4. MANEJO DE INTERRUPCIONES


C.4.1. Objetivo de la práctica


En esta práctica se plantea como objetivo el manejo de las interrupciones del reloj de forma similar
a como lo hace un sistema operativo. Para ello se va a implementar un manejador de reloj. La
práctica se va a desarrollar sobre LINUX, lo que impone algunas restricciones, por lo que el
dispositivo reloj se va a simular con un proceso que emite señales periódicas, equivalentes a las
interrupciones del reloj real.
         Sirve como trabajo práctico para el tema de entrada/salida.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 659 -->

680       Sistemas Operativos. Una visión aplicada




C.4.2. Descripción de la funcionalidad a desarrollar por el alumno


La práctica tiene tres partes fundamentales:

      •   Gestionar la interrupción del reloj.
      •   Manejar el tiempo de la aplicación de la práctica en base al reloj virtual de la misma.
      •   Implementar un programa de prueba que permita comprobar la funcionalidad del
          manejador de reloj implementado.

     La pieza esencial es el manejador de reloj que recibe las llamadas del manejador de
interrupción y del programa de usuario, procesando las mismas de forma similar a como lo hace
LINUX. La idea fundamental de la práctica consiste en construir un manejador de reloj que permita
gestionar un reloj virtual en nuestra aplicación y colas de temporizadores y ciclos. Cada
temporizador y ciclo puede tener asociado una función (especificable por el usuario), de forma que
cuando vence alguno de estos elementos se ejecuta la función asociada.


Funcionamiento del manejador

Cada vez q llega una interrupción de reloj, se mira si tenemos un tick (unidad mínima) en el reloj de
nuestra aplicación. En caso positivo, la rutina de tratamiento de interrupción avisa al manejador de
reloj (CLOCK_TASK) y éste hace todo el proceso correspondiente a un tick de reloj.
         La unidad mínima del reloj de la aplicación (tick) no tiene por qué coincidir con la frecuencia
de las interrupciones del reloj hardware (18,7 mt, por segundo = aprox. 58 ms). Puede ser
cualquier múltiplo de ellas (en milisegundos), ajustable por el usuario mediante una operación
(SET_TICK) Dicha unidad debe poder ser cambiada dinámicamente durante la ejecución de la
aplicación.
         Además el manejador de reloj tiene que permitir mantener un reloj virtual de la aplicación.
Dicho reloj virtual se inicializará con el tiempo de la máquina cuando arranque la aplicación y se
mantendrá mediante los ticks del reloj fijado (horas, minutos y segundos). Este reloj permitirá dos
operaciones: GET y SET Estas operaciones permiten cambiar la hora y leerla respectivamente.
         Un aspecto que conviene destacar es que este reloj es relativo a la aplicación y no tiene
por qué coincidir con el de la máquina.
         Por último, el manejador debe permitir poner, dentro de la aplicación, Temporizadores y
ciclos (SET ALARM y SET_LOOP), asociando la ejecución de una función al vencimiento de estos
eventos. El manejador debe mantener dos vectores estáticos, con un máximo de diez elementos
cada uno, para mantener las direcciones de las l’unciones asociadas a estos elementos (utilizar
punteros a funciones). Cuando se ponga un temporizador o ciclo, el manejador lo insertará en la
lista. Cada vez que venza un tick, debe mirar si alguno de estos elementos ha vencido y ejecutar la
función asociada. Además, el manejador debe proporcionar dos funciones para eliminar
temporizadores (RESET_ALARM) y ciclos (RESET_LOOP) fijados anteriormente.


Módulos de la práctica

A continuación, se describen los módulos que componen la práctica, el comportamiento esperado
(le los mismos y una posible interfaz para sus funciones, junto con la funcionalidad que se espera
de cada uno de ellos.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 660 -->

                                Apéndice C. Trabajos prácticos de sistemas operativos              681



Módulo que gestiono la interrupción del reloj (HARDWARE)

La pieza clave de este módulo es la rutina de tratamiento de interrupción del reloj. Dicha rutina se
ejecuta cada vez que llega una interrupción de reloj y debe llevar a cabo las siguientes acciones:

    •   Incrementar una variable temporal y compararla con el período mínimo (tick = n
        interrupciones hardware) del reloj software de la aplicación.
    •   Si hay un tick, llamar al manejador de reloj con la operación CLOCK_TICK.
    •   Ejecutar la rutina de interrupción de reloj del sistema para que se mantenga la hora de la
        máquina.

    Además de esta rutina, éste módulo debe tener varias operaciones que permitan:

    •   Inicializar el tratamiento de interrupción, fijando la rutina definida por el usuario.
    •   Fijar el número de interrupciones que constituyen un tick.
    •   Restaurar los vectores de interrupción iniciales del sistema cuando acabe la aplicación.


Manejador de reloj (CLOCK_TASK)

Este módulo se encarga de hacer las operaciones propias de un manejador de reloj, excluyendo
las de planificación.
        La funcionalidad que debe admitir este módulo es la siguiente:

    •   Inicializar el manejador y el módulo de tratamiento de interrupción (poner un Lick de reloj
        software cada lOO ms).
    •   Poner una alarma           (SET ALARM).
    •   Quitar una alarma          (RESET ALARM).
    •   Poner un ciclo (SET Loop).
    •   Quitar un ciclo (RESET_LOOP)
    •   Preguntar hora del reloj (GET_TIME).
    •   Fijar hora del reloj       (SET_TIME).
    •   Fijar el Lick del reloj software (SET_TIME).
    •   Fijar el vector de tratamiento de la interrupción (SETVECT).
    •   Procesamiento del tick de reloj (CLOCK_TICK).

Este módulo maneja dos tipos de elementos de tiempo distintos:

    •   Alarmas, que producen una única interrupción cuando expiran.
    •   Ciclos, que producen interrupciones periódicamente.

    El manejador debe permitir poner temporizadores (SET_ALARN) y ciclos (SET_LOOP) dentro
de la aplicación, asociando la ejecución de una función al vencimiento de estos elementos. El
manejador debe mantener dos vectores estáticos, con un máximo de diez elementos cada uno,
para mantener las direcciones de las funciones asociadas a estos elementos (utilizar punteros a
funciones). Cuando se ponga un temporizador o ciclo, el manejador lo insertará en la lista, cada
vez que venza un tick, debe mirar si alguno de estos elementos ha vencido y ejecutar la función
asociada. Además, el manejador debe proporcionar dos funciones para eliminar temporizadores
(RESET_ALARM) y ciclos (RE5ET_LOOP) fijados anteriormente. La función do_clock_set_vect
permite cambiar la función que se usa para gestionar la interrupción.
        La única función que exporta permite acceder a toda la funcionalidad del manejador
mediante el código de las operaciones.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 661 -->

682       Sistemas Operativos. Una visión aplicada

          Su Prototipo es similar a:

          void clock task message *msg)

´       Esta función es similar a la principal de un manejador de LINUX, sin embargo, tiene dos
diferencias importantes:

      •   No es un bucle infinito.
      •   Usa paramatros de tipo message.

    Los prototipos de las funciones que llevan a cabo las operaciones del manejador se describen
a continuación:

int init_clock ()
int do_set_alarm      (message            *msg)
int do_reset_alarm    (message            *msg)
int do_set_loop (message    *msg)
int. do_reset_ loop   (message            *msg)
int do_set_time (message    *msg)
int do_get_time (message    *msg)
int do_set_tick (message    *msg)
mt do_clock_set_vect (message             *msg)
int do_clock_tick     (message            *msg)

        A continuación, se describe, como ejemplo, el comportamiento que se espera de una de
estas funciones.

          int do_clock_tick (message *msg)

        Esta función es llamada por el manejador de interrupción cada vez que hay un tick de reloj
software.

      •   Revisa las colas de ciclos y alarmas y ejecuta las funciones de los que hayan vencido,
          pintando los resultados por pantalla.
      •   Reactiva los ciclos vencidos.
      •   Elimina las alarmas vencidas.
      •   Actualiza la hora del reloj de la aplicación (hora:minutos:segundos) y la escribe en la
          esquina superior derecha de la pantalla.


Módulo de prueba (RELOJ)

El módulo de prueba debe permitir acceder a la funcionalidad del manejador de reloj sin perder
precisión en el manejo de las alarmas, ciclos y hora relativa a la aplicación (o la menos posible).
        El esquema del programa de prueba es el siguiente:

Carátula de presentación (nombre,…

init_clock /‘inicializa el manejador */
while (TRUE)
/* Presentar pantalla de operadores posibles*/
1 - Poner alarma
2 - Borrar alarma
3 - Poner ciclo
4 - Borrar ciclo
5 - Leer hora de la aplicación


Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 662 -->

                                    Apéndice C. Trabajos prácticos de sistemas operativos       683

6 - Cambiar hora de la aplicación
7 - Fijar el tick del reloj de la aplicación
8 - Salir
/ * Leer teclado */
/ *Si opción correcta pulsada, ejecutar acción correspondiente*/
clock_task (&msg)
}

       Cuando se pone un ciclo o alarma hay que indicar una función para que se ejecute.
       El alumno debe proporcionar cinco funciones de prueba, todas ellas con el mismo formato,
para que puedan ser ejecutadas en la aplicación.
       El formato de dichas funciones de prueba es el siguiente:

función_i () {
escribe (“soy la función i \n”);
escribe (hora del sistema)
}

        En la Figura C.2 puede verse el flujo de llamadas entre los distintos módulos del sistema.
Estructuras de datos

        struct clock {
                int hora;
                int minutos;
                int segundos;
        }

        struct message {
                int caller;      /* identificador del origen del mensaje*/
                int operation; /* código de operación */
                int duration;    /* duración del ciclo, alarma o tick del reloj */
                void(*function) ( ) /* puntero a función asociada a alarma, ciclo o
                                           interrupción */
                int id;          /* identificador de alarma o ciclo fijado */

                   struct clock time; /* hora a escribir o leer */
                   int result;      /* O = éxito; -l = error */

        }

        Vectores de ciclos y alarma

        struct {
               int free;
               int ticks_left;
               char *function;
        } Temporizadores [MAXIMO_TEMPOLRALIZADORES]

        struct {
                int free;
                int ticks_left;
                char *function;
        } Ciclos [MAXIMO_CICLOS]




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 663 -->

684       Sistemas Operativos. Una visión aplicada




Figura C.2. Esquema de módulos y llamadas de la práctica

      Cada vez que se ejecute do_clock_tick, el manejador de reloj debe recorrer estos vectores
decrementando los ticks restantes de cada elemento (ticks_left). Si alguno llega a cero, el
manejador debe ejecutar su función asociada.


C.4.3. Material de apoyo

Se sugiere proporcionar al alumno el pseudodispositivo que emula el reloj a base de señales. Si se
quiere poca precisión, se puede usar la llamada al sistema alarma para dicha emulación. Si se
necesita más precisión, se puede recurrir al contador de ticks de la UCP.


C.4.4. Recomendaciones generales al alumno

      •   Se recomienda implementar una versión sencilla de la práctica en la que el alumno pueda
          comprobar exclusivamente que funcionan bien las interrupciones.
      •   Se recomienda hacer un programa bien estructurado, evitando la linealidad.
      •   Se debe hacer un control exhaustivo de errores de ejecución en las llamadas al sistema y
          funciones.
      •   La salida de la práctica debe hacerse por la salida estándar. Sin embargo, los errores, y
          sólo los errores, deben escribirse por la salida de error estándar.
      •   Se debe seguir estrictamente las recomendaciones dadas en la sección de descripción.


C.4.5. Documentación a entregar

Se recomienda que el alumno entregue los siguientes archivos como solución a esta práctica:

      •   Memoria descriptiva de la misma, incluyendo: listados, explicación, esquemas de los
          nu5du— los y una traza de ejecución de la práctica como prueba de que funciona. Archivo:
          memoria.txt.
      •   Las fuentes de la aplicación, un ejecutable e indicaciones de cómo compilar los distintos
          módulos de la misma. Archivos:
          — reloj. c. Contendrá el código del módulo user y el programa principal.
          — hardware.c Contendrá el código del módulo hardware.
          — cock_ task.c. Contendrá el código del módulo clock_ task.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 664 -->

                                 Apéndice C. Trabajos prácticos de sistemas operativos             685




        — reloj.exe. Ejecutable de prueba.
        — makefile. Archivo de compilación de los módulos de la práctica.


C.4.6. Bibliografía

A. Silherschatz y P. B. Galvin. Operatin Systems’ Concepis. S. edición. Addison-Wesley. 1999.
D. A. Solomon. Insule Windows NT. Microsoft Press, 1998.
W. R. Stevens. Ad Progrwnming in 11w UNIX Eni’ironmnent. Addison-Wesley. 1992.
A. S. Tancnhauin. Operating Sy.s’t’mns: Desi and Implementation, 2: edición. Prentice—Hall, 1987.
—Modern Operaling Systems. Prentice-Hall, 1991.
P. S. Wang. An Introduction to Berkeley Unix. Wadsworth, lnlcrnational Student Edilion, 1988.


PRÁCTICA C.5. COMUNICACIÓN DE PROCESOS CON SOCKETS

C.5.1. Objetivo de la práctica

En esta práctica se pretende que el alumno se familiarisara con los mecanismos de comunicación
entre procesos, usando sockets como mecanismo de comunicación. Además. El alumno tendrá
ocasión de experimentar con un sistema cliente-servidor.
        Sirve como trabajo práctico para el tema de comunicación y sincronización y í el tema de
sistemas distribuidos.


C.5.2. Descripción de la funcionalidad a desarrollar por el alumno

Esta práctica permitirá al alumno estudiar los mecanismos existentes en UNIX para comunicar
procesos con sockets y el concepto de relación cliente-servidor.
         La práctica consiste en el desarrollo de dos programas C que definen dos procesos
denomina dos csocket y ssocket respectivamente. El resultado de la ejecución conjunta de ambos
procesos será similar al obtenido mediante la ejecución de la orden cat de UNIX, es decir,
visualizar el contenido de un archivo cuyo nombre se indica.
         El proceso csocket lee el nombre del archivo por la (‘mitrada estándar (teclado) y se lo
envía al servidor por un socket de recepción de mensajes del servidor, que se supone creado por
el servidor.
         Si el envío es correcto, crea un socket para recibir y ejecuta un bucle de lectura del socket
y de escritura de lo leído por la salida estándar (pantalla). Cuando el archivo está terminado, el
servidor le envía un código de finalización.
         El proceso ssocket crea un, socket de recepción y recibe del cliente el nombre del archivo
a leer. Si la recepción es correcta, abre el, socket (socket) del cliente y el archivo recibido (open) y
ejecuta un bucle de lectura del archivo (send/write) y envía (recv/read) por el socket del cliente
recibido como parámetro. Una vez leído el archivo completo, cierra todos los archivos y
descriptores (close).
         Para la comunicación se usa una estructura de tipo mensaje. El uso de esta estructura
permite generalizar el modelo de comunicación para su uso en un esquema cliente-servidor (le tipo
general. El servidor debe poder atender a cualquier cliente de forma secuencial. Para ello
supondremos que el servidor tiene una dirección de recepción de mensajes conocida por todos los
clientes.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 665 -->

686    Sistemas Operativos. Una visión aplicada




       Puesto que el servidor debe conocer la identidad de la cola cliente donde debe responder,
usará una estructura mensaje como la siguiente:

typedef struct {
        sockaddrin dirección; / dirección del emisor /
        char     datos datos que ha enviado */
        unsigned mt longdat; /* longitud de datos válidos dentro de datos /
        unsigned mt orden; /* número de orden del mensaje /
      }mensaje;


donde se incluye la dirección del cliente adonde debe enviarse la respuesta del servidor. Esta
modificación permite al servidor atender peticiones de cualquier cliente que conozca su dirección y
a un mismo cliente recibir respuestas a sus mensajes por distintos sockets (uno por cada servicio).
        Aunque existen distintos tipos de sockets (INET, UNIX, SNET,...), esta práctica se limitará
a los sockets de tipo INET y, dentro de ellos, a los sockets de tipo DATAGRAMA y STREAN.
        Todas las llamadas al sistema devuelven un error en caso de ejecución incorrecta. El
alumno debe controlar los posibles errores y mostrarlos por la salida de error.
        Para construir un servidor similar a uno real de UNIX, en esta práctica se desarrollarán
varios apartados.


Parte 1. Servicio secuencial

Similar a lo descrito hasta el momento.


Parte 2. Servicio concurrente basado en procesos

Para cada petición de servicio, el servidor crea un proceso hijo al que le pasa el mensaje recibido
(Fig. C.3). Este es el responsable de ejecutar el servicio completo.


Parte 3. Servicio concurrente basado en procesos ligeros (PL)

Para cada petición de servicio, el servidor crea un PL al que le pasa el mensaje recibido. Este PL
es el responsable de ejecutar el servicio completo. El esquema es similar al de la Figura C.3. pero
en lugar de procesos convencionales se crean procesos ligeros usando threads de POSIX.


C.5.3. Introducción a los sockets

El mecanismo de comunicación a utilizar en esta práctica son los sockets. Un socket (enchufe) es
un punto extremo de comunicación, que permite comunicar dos procesos punto a punto. Estos
procesos pueden ejecutarse en la misma máquina o no. Permiten la utilización de protocolos de
red y de transporte para la comunicación de procesos situados en distintos nodos. Esta
característica hace que sean más potentes que los pipes, y un mecanismo de comunicación a
considerar en sistemas distribuidos.
        Para trabajar con .sockets es siempre necesaria la existencia de extremos con direcciones
conocidas y que estos extremos se sincronicen adecuadamente, si bien la forma de sincronización
depende del tipo de socket.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 666 -->

                               Apéndice C. Trabajos prácticos de sistemas operativos         687




Figura C.3. Esquema Cliente-servidor con sockets y concurrencia

        Existen sockets de distintos tipos en un sistema UNIX, diferenciándose cada tipo por la
semántica que proporcionan en el protocolo de comunicaciones. En esta práctica utilizaremos las
siguientes constantes:

   •   PF INET. Familias de sockets de internet.
   •   SOCKADDR_ANY. Recibir de cualquier dirección, en la estructura sockaddr_in.
   •   UDP. Protocolo de usuario.
   •   IPPORT_USERRESERVED. Numero de socket mínimo que puede utilizar un usuario; el
       socket a utilizar será esa constante más algo.

   En esta práctica se utilizarán dos tipos de sockets de los existentes en UNIX:

   •   Datagramas. Son sockets que se caracterizan porque:

       — No necesitan una operación de conexión explícita antes de enviar.
       — No aseguran el orden de llegada de los datos si éstos se parten en distintos paquetes,
        por lo que no son muy indicados para grandes transferencias.

   •   Streams. Se caracterizan porque:

       -— Necesitan una operación explícita de conexión antes de enviar.
       -— Aseguran el orden de llegada de los datos si éstos se parten en distintos paquetes (son
          aptos para grandes cantidades de datos).


C.5.4. Llamadas al sistema operativo a usar en la práctica

Servicios de archivos

Los sockets se manejan en UNIX como descriptores de archivos, por lo que aceptan muchas llama
das de archivos como read. write, close o ioctl.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 667 -->

688    Sistemas Operativos. Una visión aplicada




Servicios de sockets

Se describe aquí el pequeño subjunto de servicios de sockets a usar en la práctica.

        int socket(int domain, int type, int protocol);

        Crea un punto de comunicación tipo socket y devuelve un descriptor de archivo asociado
con él. Dominios de sockets: PF UNIX, PP INET y PF_IMPLINK. Tipos de sockets: SOCKSTREAN,
SOCK_DGRAM, SOCK_RAW, SOCKSEQPACKET y SOCK Los protocolos son dependientes del
dominio.

        int bind(int s, struct sockaddr *name int namelen);

        Esta llamada asigna un nombre (una dirección) a un socket sin nombre, es decir, a uno
creado con socket. A partir de su ejecución, se puede acceder a la dirección a través del socket sin
especificar nada más que el identificador del socket.

        int. listen(int s, int n)

      Escucha a la espera de conexiones al socket s. Permite n conexiones simultáneas como
máximo. Si se sobrepasa este número, devuelve un error. Sólo válida para sockets tipo
SOCK_STREAM.

        int accept(int s, struct sockaddr *addr mt *addrlen);

        Acepta conexiones sobre un socket que ha sido previamente creado (socket), enlazado
(bind) a una dirección y que está a la escucha (listen). Esta llamada es bloqueante y extrae la
primera conexión que exista. Crea un nuevo socket conectado y devuelve su descriptor de archivo.

        int connect(int s, struct sockaddr *name, int namelen)

        Intenta establecer una conexión con otro socket. Este último debe estar ejecutando una
llama da accept. Generalmente sólo se puede establecer una conexión de ¡ simultánea para SOCK
S’I’REAM y múltiples para SOCK_

        int select (int width, fd_set *readfds, fd_set *writetds
                 fd_set *exceptfds struct tirneval *timeout)

         Examina los descriptores de socket de readfds. writefdsn y exceptfds para ver si alguno
está lisio para leer, recibir o tiene alguna excepción pendiente. El parámetro width es una máscara
de bits que indica los descriptores que deben ser muestreados.

getsockname (int s, struct sockaddr *name, int *namelen

        Devuelve el nombre asociado a un socket.

struct hostent *qerhostbyname(char *name)




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 668 -->

                                    Apéndice C. Trabajos prácticos de sistemas operativos     689



         Devuelve los datos de comunicación asociados a la máquina cuyo nombre es nane.

         int recvfrorn(int s, int len, int flag f ] struct sockdddr *fromm, Int *fromlen)
         int send int s, char *buf, int len, int ilags)

Distintas llamadas de recepción sobre sockets. recv sólo puede usarse para sockets conecta dos.
Se lee sobre buf una longitud máxima len, con la operación modificada por flags. Si to es no nulo,
se introduce en dicho parámetro los datos del origen del mensaje. Obteniendo su longitud en tolen.

int sendio(int s, mt len, int flags, struc sockaddr *io, int *io);
int send(int s, char *buf, int len, int flags)

        Distintas llamadas de envío sobre sockets. send sólo puede usarse para sockets
conectados. Se envía buf con una longitud máxima len, con la operación modificada por flags. Si to
es no nulo, se introduce en dicho parámetro los datos del destino del mensaje, incluyendo su
longitud en iolen.


Llamadas de procesos ligeros (Threads)

Para resolver la sección que usa procesos ligeros, se recomienda al lector acudir al tema de
Procesos, donde se describen las llamadas al sistema para procesos ligeros, tales como
pihread_desiroy, pihread_yield, pthread sleep, etc.


C.5.5. Material de apoyo

Como material de apoyo se sugiere a los profesores proporcionar a los alumnos algún ejemplo de
programación con sockets. Para ello se puede usar el libro de Stevens, Unix Network Programing
donde hay múltiples ejemplos.
         Igualmente, se les puede proporcionar un ejemplo de programa que use las llamadas al
sistema
fork y exec.
         Además, se sugiere que para evitar una explosión de definiciones distintas se proporcione
un archivo, denominado Soc. . h, que, usando el lenguaje C, incluya las definiciones generales
para el desarrollo de la práctica.


C.5.6. Material a entregar
.
Para tratar de que las distintas soluciones se puedan entregar de forma clara y bien separada, se
sugiere pedir a los alumnos los siguientes archivos como resultado de su implementación de la
práctica:
• csockei.c     (común)
• ssockei.c     (Parte 1)
• spsockei. c   (Parte 2)
• sisockei.c    (Parte 3)




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 669 -->

690       Sistemas Operativos. Una visión aplicada



C.5.7. Bibliografía


W. R. Stevens. UNIX Network Programming Addison-Wesley, 1990.
—Advanced Programming in the UNIX Environment Addisson—Wesley, 1992.
P. S. Wang. An Introduction to Berkeley Unix. Wadsworth, International Student Edition, 1988.
A. S. Tanenbaum. Sistemas Operativos Modernos. Prentice—Hall, 1992.


PRÁCTICA C.6. DISEÑO DE UN SISTEMA MULTIPROGRAMADO


C.6.1. Objetivo de la práctica

El objetivo de esta práctica es llegar a conocer los principales conceptos relacionados con la
gestión de procesos y la multiprogramación. El trabajo va a consistir básicamente en convertir un
sistema con monoprogramación en uno multiprogramado.
         La multiprogramación y, en general, la concurrencia son probablemente los temas más
importantes en la enseñanza de los sistemas operativos, aunque también son los más complejos
de entender. Es muy difícil conseguir comprender lo que ocurre cuando se están ejecutando
concurrentemente varias actividades.
         Esta dificultad se acentúa notablemente cuando se está trabajando en el nivel más bajo del
sistema operativo. Por un lado, en este nivel la mayoría de los eventos son asíncronos. Por otro, en
él existe una gran dificultad para la depuración, dado el carácter no determinista del sistema y la
falta de herramientas de depuración adecuadas.
         Todas las consideraciones expuestas hasta ahora explican el motivo de que la
programación de sistemas tenga una productividad tan baja y que los sistemas operativos tengan
«mala fama» debido a sus «caídas» y «cuelgues» imprevistos.
         Por tanto, al enfrentarse con esta problemática, es importante resaltar desde el principio las
dificultades que se encontrará para la realización de este proyecto práctico. Sin embargo, aunque
parezca un poco sorprendente, enfrentarse con esos problemas es a su vez un objetivo del mismo.
         Por último, hay que resaltar que en esta práctica se plasman muchos de los conceptos de
sistemas operativos relacionados con la concurrencia y la gestión de interrupciones tales como:

      •   El arranque del sistema operativo.
      •   El manejo de las interrupciones.
      •   El manejo (le las excepciones.
      •   El manejo de las llamadas al sistema.
      •   La multiprogramación.
      •   El cambio de contexto.
      •   La planificación de procesos.
      •   La sincronización entre procesos.


C.6.2. Entorno de desarrollo de la práctica

Uno de los problemas que surgen cuando se pretende hacer una práctica de este tipo es decidir en
qué entorno se lleva cabo.
        La elección más obvia es utilizar un sistema operativo real del que se dispongan las
fuentes (tales como MINIX o LINUX) y realizar modificaciones en el código del mismo para incluir
nuevas funcionalidades. Este enfoque es el más realista, pero, sin embargo, presenta algunos
problemas que dificultan considerablemente su aplicación práctica.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 670 -->

                               Apéndice C. Trabajos prácticos de sistemas operativos          691


        En el caso de sistemas concebidos para su utilización en la vida real, como LINUX, el
código de los mismos es demasiado complejo debido a las «oscuras» optimizaciones que suelen
estar presentes en este tipo de sistemas.
        En el caso de MINIX, al tratarse de un sistema diseñado con un objetivo pedagógico, su
uso directo es más viable. Sin embargo, la necesidad de recompilar el sistema operativo en cada
modificación de mismo y su dificultad de la depuración hace que sea problemática su utilización
como entorno de prácticas.
        Ante esta situación se han creado algunos entornos que simulan el comportamiento del
sistema operativo en el contexto de uno o varios procesos convencionales. Este enfoque es más
adecuado, aunque, como todo entorno simulado, se pierde parte de la experiencia que podría
obtener trabajan do directamente en un sistema real.
        Uno de los entornos de este tipo más conocidos y utilizados es el sistema NACHOS
desarrollado en la universidad de Berkeley. Aunque este sistema proporciona un entorno con una
serie de características interesantes, presenta algunas deficiencias (como, por ejemplo, la
necesidad de usar un compilador cruzado o su carácter determinista) que hacen que se haya
considerado que era conveniente usar un entorno propio denominado, minikernel. Algunas
características de este entorno son las siguientes:

   •   Tiene un modo de operación que imita el comportamiento de los sistemas operativos
       monolíticos.
   •   Se puede utilizar en diferentes plataformas UNIX (p. ej.: LINUX o Digital UNIX). Para lograr
       esta transportabilidad, todas las operaciones del sistema dependientes de la plataforma
       están «escondidas» en un módulo objeto proporcionado por el entorno. El programador del
       sistema operativo no va a utilizar código en ensamblador.
   •   No requiere el uso de un compilador cruzado. Los programas se compilan usando el
       compilador nativo de la máquina.
   •   Los programas de usuario son programas convencionales, con la única peculiaridad de
       que usan los servicios el, minikernel en vez de los de UNIX.
   •   Tanto los programas de usuario corno el código del sistema operativo ejecutan sobre el
       procesador nativo. A diferencia de otros entornos como NACHOS donde los procesos de
       usuario ejecutan sobre la simulación de un procesador (un MIPS en el caso de NACHOS).
   •   La emulación del hardware se realiza exportando algunas características del hardware real
       subyacente. El sistema incluye mecanismos que emulan las interrupciones, las
       excepciones y las llamadas al sistema.
   •   En la versión actual sólo existe una fuente de interrupciones: el reloj.
   •   La generación de excepciones es realista: Las excepciones reales que produce el
       programa durante su ejecución son propagadas al minikernel como tales.

       Evidentemente, como material de apoyo de la práctica, se debe proporcionar este entorno
de desarrollo denominado minikernel.


C.6.3. Estructura deL entorno de desarrollo

El entorno de desarrollo de la práctica intenta imitar dentro (le lo que cabe el comportamiento y
estructura de un sistema real. En una primera aproximación, en este entorno se pueden diferenciar
(res componentes principales:

   •   El programa cargador del sistema operativo (directorio boot).
   •   El sistema operativo minikernel propiamente dicho (directorio kernel).
   •   Los programas de usuario (directorio usuario).




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 671 -->

692       Sistemas Operativos. Una visión aplicada


   A continuación, se describe cada una de estas parles haciendo especial énfasis en el sistema
operativo.


Carga del sistema operativo

De forma similar a lo que ocurre en un sistema real, en este entorno existe un programa de
arranque que se encarga de cargar el sistema operativo en memoria y pasar el control a su punto
de entrada inicial. Este procedimiento imita el modo de arranque de los sistemas operativos reales
que se realiza desde un programa cargador.
        El programa cargador se encuentra en el subdirectorio boot y. en un alarde de originalidad,
se denomina boot. Para arrancar el sistema operativo, y con ello el entorno de la práctica, se debe
ejecutar dicho programa pasándole como argumento el nombre del archivo que contiene el sistema
operativo. Así, suponiendo que el directorio actual corresponde con el subdirectorio boot y que el
sistema operativo está situado en el directorio kernel y se denomina minikernel, se debería
ejecutar: boot. . /kernel/minikernel. Observe que no es necesario ejecutar el programa de arranque
desde su directorio. Así, si se está situado en el directorio base de la práctica, se podría usar el
siguiente mandato: boot/boot kernel/minikernel.


El minikernel

El código del sistema operativo está organizado como un módulo de apoyo (archivo apoyo o), del
que se proporciona únicamente su interfaz, y el módulo que contiene la funcionalidad principal del
sistema operativo (archivo proc.c).


El módulo de apoyo

El objetivo principal de este módulo es simular el procesador y ofrecer servicios que permitan al
sistema operativo su manejo. Las principales características de este procesador son las siguientes:

      •   Tiene dos niveles de ejecución: usuario y kernel.
      •   El tratamiento de las interrupciones se realiza mediante el uso de una tabla de vectores de
          interrupción.
      •   Hay cuatro vectores disponibles que corresponden con:

          — Vector O: Excepción aritmética.
          — Vector 1: Excepción por acceso a memoria inválido.
          — Vector 2: Interrupción de reloj.
          — Vector 3: Llamada al sistema.

      •   Cuando se produce una interrupción, sea del tipo que sea, el procesador realiza el
          tratamiento habitual, esto es, almacenar el contador de programa y el registro de estado en
          la pila, prohibir las interrupciones, elevar el nivel del procesador y cargar en el contador de
          programa el valor almacenado en el vector correspondiente. Evidentemente, al tratarse de
          operaciones realizadas l) el hardware, todas estas operaciones no son visibles al
          programador del sistema operativo
      •   La ejecución en modo kernel de una instrucción de retorno de interrupción restaurará el
          nivel de procesador y el estado de las interrupciones previo. Observe que, ciado que se
          pretende que el código a desarrollar no incluya ensamblador, la ejecución de esta
          instrucción está incluida en uno de los servicios exportados por este módulo.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 672 -->

                                 Apéndice C. Trabajos prácticos de sistemas operativos           693


     Además de funcionalidad relacionada con la simulación del procesador, este módulo también
incluye otras funciones de más alto nivel que intentan facilitar la labor (le programación del sistema
operativo. Por ejemplo, se ofrecen funciones relacionadas con la creación del mapa de memoria de
cada proceso a partir del ejecutable. Con esto se pretende que el desarrollo se centre en los
aspectos relacionados con la gestión de procesos y no en otros como la gestión de memoria.
     Las funciones ofrecidas por el modulo de apoyo se pueden clasificar en las siguientes
categorías:

    •   Operaciones relacionadas con las interrupciones. En esta categoría se incluyen funciones
        que se pueden subdividir a su vez en los siguientes apartados:

        — Iniciación del controlador de interrupciones (iniciar_cont_int) y del controlador del reloj
            (iniciar_cont_reloj).
        — Instalación de un manejador de interrupciones (instal_man_int)
        — Inhibición y habilitación de tas interrupciones (prohibir_int, permitir_int,
            obtener_estado_int y fijar_estado_int).

    •   Operaciones relacionadas con la salvaguarda y recuperación de información del proceso.
        — activar_pila_kernel. Permite activar la pila del kernel del proceso.
        — salvar_en_pila. Salva en la pila del proceso actual una copia de los registros del
           procesador.
        — recuperar_de_pila. Recupera de la pila del proceso actual la copia de los registros
           cargándola en los registros del procesador y ejecuta la instrucción de retorno de
           interrupción.
        — cambio _ contexto. Salva el contexto de un proceso y restaura el de otro. Si no se
           especifica el proceso cuyo contexto debe salvarse, s6lo realiza la restauracióu.

    •   Operaciones relacionadas con el tratamiento de los argumentos. Estas funciones permiten
        obtener el número de llamada solicitada (obtener_nservicío, el número se recibe en un
        registro), los argumentos de la llamada (obtener _argumento, se reciben en la pila de
        usuario) y almacenar el resultado de la misma (almacenar_resultado. se devuelve en un
        registro).
    •   Funciones relacionadas con el mapa de memoria del proceso. Permiten realizar
        operaciones tales como crear el mapa de memoria del proceso a partir del ejecutable
        (crear_imagen) y liberarla (liberar_imagen), y crear una pila de kernel para el proceso
        (crear_pila_kernel) y liberarla (liberar_pila_kerne]).
    •   Operaciones misceláneas. En este apartado se agrupan una serie de funciones de utilidad
        diversa:

        — obtener_nivel_previo. Devuelve cual era el nivel de ejecución del procesador previo al
           actual.
        — halt. Ejecuta una instrucción HALT para parar el procesador hasta que se active una
           interrupción.
        — panico. Escribe un mensaje por la pantalla y termina la ejecución del sistema operativo.
        — escribir_ker. Escribe en la pantalla.
        — printk. Escritura con formato en la pantalla. Esta función de conveniencia se apoya en la
           anterior (escribír_ker).


El módulo proc

Éste es el módulo que contiene la funcionalidad del sistema operativo. Su nombre viene a indicar
cuál es la labor fundamental de este minisistema operativo: la gestión de procesos. Como parte




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 673 -->

694       Sistemas Operativos. Una visión aplicada

material de apoyo para la realización de la práctica se proporciona una versión de este módulo que
incluye una funcionalidad básica que corresponde con un sistema monoprogramado. Para ser más
precisos, hay que aclarar que en este sistema inicial, aunque se puedan crear y cargar en memoria
múltiples programas, el proceso en ejecución continúa hasta que termina. Este sistema se deberá
convertir en un sistema multiprogramado siguiendo las pautas que se detallan posteriormente.
        Antes de pasar a revisar las características principales de esta versión inicial es
conveniente realizar algunas aclaraciones sobre el mismo:

      •   Como se comentó previamente, una vez que empieza a ejecutar un proceso, éste continúa
          hasta que termina. El estado del proceso será en todo momento en ejecución. No existe
          ningún servicio que cause que el proceso pase a un estado bloqueado. Sólo se invoca a la
          rutina de cambio de contexto cuando el proceso termina, sea voluntaria o
          involuntariamente. Observe que la rutina de interrupción no cambia el estado de los
          procesos.
      •   No van a existir problemas de sincronización dentro del núcleo causados por la ejecución
          concurrente de varias llamadas al sistema ya que se trata de un sistema monoprogramado.
          Según se vaya incluyendo en el sistema la funcionalidad pedida, habrá que analizar si
          puede surgir este tipo de problemas.
      •   Los problemas de sincronización dentro del núcleo entre una llamada al sistema y la rutina
          de tratamiento de interrupción van a ser relativamente simples, ya que en esta versión
          inicial la rutina de interrupción no realiza ninguna labor. Solamente es necesario asegurar
          que mientras se está salvando o recuperando información de la pila, realizando un cambio
          de contexto, o después de liberar la pila del sistema del proceso, no se produzca una
          interrupción Y que la rutina de interrupción también manipula esas estructuras de datos.
          Para ello se prohibirán las interrupciones en la sección de código problemática. Como se
          comentó para el caso anterior, según se incluya nueva funcionalidad en la rutina de
          interrupción será necesario revisar el sistema para comprobar si pueden surgir este tipo de
          problemas.

          A continuación, se describen las principales características del sistema inicial:

      •   Estructuras de datos (contenidas en proc.h). Este módulo utiliza las siguientes variables
          globales:

          — tabla_procs. Tabla de procesos. Cada entrada representa un BCP. Se deberán incluir
              nuevos campos en el BCP cuando se considere oportuno.
          — lista_listos. Cola de procesos listos. Se trata de una lista con enlace simple. El tipo
              lista_BCPs guarda referencias al primer y último elemento de la lista. Este tipo puede
              usarse p otras listas del sistema operativo (p. ej.: en un semáforo).
          — p_proc_actual. Apunta al BCP del proceso en ejecución. Este BCP está incluido en la
              cola de listos.
          — tabla_servicios. Tabla que guarda en cada posición la dirección de la rutina del sistema
              operativo que lleva a cabo la llamada al sistema cuyo código corresponde con dicha
              posición.

      •   Iniciación. Una vez cargado el sistema operativo, el programa cargador pasa control al
          punto de entrada del mismo (en este caso a la función main de este módulo). En este
          momento,- el sistema inicia sus estructuras (le datos, los dispositivos hardware e instala
          sus manejadores en la tabla de vectores. En último lugar, crea el proceso inicial init y lo
          activa pasándole el control. Observe que durante esta l las interrupciones están inhibidas.
          Sin embargo, cuan do se activa el proceso init restaurándose su contexto inicial, se
          habilitan automáticamente las interrupciones puesto que en dicho contexto inicial se ha
          establecido previamente que esto sea así.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 674 -->

                                Apéndice C. Trabajos prácticos de sistemas operativos           695


    •   Tratamiento de interrupciones externas. La única fuente externa de interrupciones es el
        reloj. La rutina de tratamiento instalada únicamente muestra un mensaje por la pantalla
        indicando la ocurrencia del evento. En esta rutina habrá que incluir progresivamente la
        funcionalidad pedida. Observe que esta rutina se ejecuta con las interrupciones externas
        inhibidas. En un sistema con varias fuentes de interrupción lo habitual sería mantener
        inhibidas las interrupciones de este mismo tipo pero habilitar las más prioritarias.
    •   Tratamiento de excepciones. Las dos posibles excepciones presentes en el sistema tienen
        un tratamiento común produciendo la terminación del proceso actual y la liberación de sus
        recursos. La rutina se inicia con las interrupciones inhibidas pero las habilita una vez
        salvada la información en la pila para, por último, volver a inhibirlas cuando es preciso.
    •   Llamadas al sistema. Existe una única rutina de interrupción para todas las llamadas. Esta
        rutina obtiene de un registro el código numérico de la llamada e invoca indirectamente a
        través de la tabla_servicios a la función correspondiente. Esta rutina se inicia con las
        interrupciones inhibidas pero, una vez salvada la información en la pila, las rehabilita. Una
        vez terminada la función específica del servicio, esta rutina inhibe las interrupciones y
        restaura la información de la pila. En la versión inicial sólo hay tres llamadas disponibles.
        La función asociada con cada una de ellas está referenciada desde la posición
        correspondiente de la tabla_servicios. Estas llamadas son las siguientes:

        — crear_proceso. Crea un proceso que ejecuta el programa almacenado en el archivo
           especificado (parámetro prog). Para ello realiza los pasos básicos implicados en la
           crea ción: buscar una entrada libre, leer el ejecutable y crear el mapa de memoria,
           reservar la pila del sistema para el proceso, rellenar el BCP adecuadamente, poner el
           proceso como listo para ejecutar e insertarlo al final de la cola de listos. Esta llamada
           devolverá un —l si hay un error y un o en caso contrario. El prototipo de este llamada
           es: int crear_proceso (char *programa).
        — terminar_proceso. Termina la ejecución de un proceso liberando sus recursos (BCP,
           mapa de memoria, pila del kernel. etc.). El prototipo de esta llamada es: init
           terminar_proceso ().
        — escribir. Escribe un mensaje por la pantalla (parámetro texto) de una determinada
           longitud (parámetro longi) haciendo uso de la función de apoyo escribir_ker. De vuelve
           siempre un O. El prototipo de este llamada es: int escribir (char * texto, unsigned int
           longi).

        En la versión inicial, el código de las tres llamadas ejecuta la mayoría del tiempo con las
interrupciones habilitadas. Al ir añadiendo la funcionalidad pedida puede ser necesario revisar el
código para aumentar la zona de código que ejecuta con las interrupciones inhibidas.

    •   Planificador (función planificador). La versión inicial de este módulo se corresponde con un
        sistema monoprogramado. Por tanto, el planificador no se invoca hasta que termina el
        proceso actual. El algoritmo que sigue el planificador es de tipo FIFO: simplemente
        selecciona el proceso que esté primero en la cola de listos. Observe que, si lodos los
        procesos existentes están bloqueados (situación imposible en la versión inicial), se invoca
        la rutina espera_int de la que no se vuelve hasta que se produzca una interrupción.


Los programas de usuario

En el subdirectorio usuario existe inicialmente un conjunto de programas de ejemplo que usan los
servicios del minikernel. De especial importancia es el programa init puesto que es el primer
programa que arranca el sistema operativo. En un sistema real este programa consulta archivos de




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 675 -->

696       Sistemas Operativos. Una visión aplicada


configuración para arrancar otros programas que, por ejemplo, se encarguen de atender a los
usuarios (procesos de login). De manera relativamente similar, en este sistema este proceso hará
el papel de lanzador de otros procesos, aunque en nuestro caso no se trata de procesos que
atiendan al usuario puesto que el Sistema no proporciona servicios para leer del terminal. Se
tratará simple mente de programas que realizan una determinada labor y terminan.
         Además del programa init, en este directorio existe un conjunto de programas que sirven
(le ejemplo del uso de las llamadas al sistema.
         Como ocurre en un sistema real, los programas tienen acceso a las llamadas al sistema
como rutinas de biblioteca. Para ello, existe una biblioteca estática denominada libserv. a que
contiene las funciones de interfaz para las llamadas. Esta biblioteca almacenada en el subdirectorio
usuario/lib está compuesta de dos módulos:

      •   serv. c. Contiene las rutinas de interfaz para las llamadas. Se apoya en una función de
          nominada hacer_trap que es la que realmente ejecuta la instrucción (le llamada al sistema.
          Para hacer accesible a los programas una nueva llamada, se deberá modificar este archivo
          para incluir la rutina de interfaz correspondiente.
      •   misc.o. Contiene funciones de utilidad comO la definición de la función printf del sistema
          que, evidentemente, se apoya en la llamada al sistema escribir, de la misma manera que el
          printf de UNIX se apoya en la llamada write.

    Todos los programas de usuario utilizan el archivo de cabecera usuario/include/servicios. h que
contiene los prototipos de las funciones de interfaz a las llamadas al sistema.


Inclusión de una nueva llamada al sistema

Dado que parte de la labor de la práctica es incluir nuevas llamadas al sistema, se ha considerado
oportuno incluir en esta sección los pasos típicos que hay que llevar a cabo en este sistema para
hacerlo. Suponiendo que el nuevo servicio se denomina nueva, éstos son los pasos a realizar:

      •   Incluir en kernel /proc. c una rutina (que podría denominarse sis_nueva) con el código de la
          nueva llamada.
      •   Incluir en tabla_servicios (archivo kernel/include/proc.h) la nueva llamada en la última
          posición de la tabla.
      •   Modificar el archivo para incrementar el número de llamadas disponibles y asignar el
          código más alto a la nueva llamada.
      •   Una vez realizados los pasos anteriores, el sistema operativo ya incluiría el nuevo servicio,
          pero sólo sería accesible desde los programas usando código ensamblador. Por tanto, es
          necesario modificar la biblioteca de servicios (archivo usuario/lib/serv.c) para que
          proporcione la interfaz para el nuevo servicio. Se debería también modificar el archivo de
          cabecera que incluyen los programas de usuario (usuario/ include / servicios. h) para que
          dispongan del prototipo de la función de interfaz.
      •   Por último, hay que crear programas de prueba para este nuevo servicio y, evidentemente,
          modificar init para que los invoque. Asimismo, se debería modificar el archivo Makefile para
          facilitar la compilación de este nuevo programa.


C.6.4. Descripción de la funcionalidad a desarrollar por el alumno

Como se comentó previamente, la práctica va a consistir en modificar la versión inicial que se ci1trc
como material de apoyo para incluir nuevas funcionalidades y añadir multiprogramación al mismo.
Se deben realizar tas siguientes modificaciones sobre la versión inicial del sistema:




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 676 -->

                                Apéndice C. Trabajos prácticos de sistemas operativos           697


   •   Incluir una nueva llamada (obtener_id) que devuelva el identificador del proceso que la
       invoca. Corno puede observarse, se trata de un servicio que realiza un trabajo muy
       sencillo. Sin embargo, esta primera tarea servirá para familiarizarse con el mecanismo que
       se usa para incluir una nueva llamada al sistema. El prototipo de la función de interfaz
       sería el siguiente:
       int obtener_id_pr ().
   •   Incluir una nueva llamada (int dormir (unsigned int segundos)) que permita que un proceso
       pueda quedarse bloqueado un plazo de tiempo. El plazo se especifica en segundos corno
       parámetro de la llamada. La inclusión de esta llamada significará que el sistema pasa a ser
       multiprogramado ya que cuando un proceso la invoca pasa al estado bloqueado durante el
       plazo especificado y se deberá asignar el procesador al proceso elegido por el planificador.
       Observe que en el sistema sólo existirán cambios de contexto voluntarios y, por tanto,
       sigue sin ser posible la existencia de llamadas al sistema concurrentes. Sin embargo. dado
       que la rutina de interrupción del reloj va a manipular listas de BCPs. es necesario revisar el
       código del sistema para detectar posibles problemas de sincronización en el manejo de
       estas listas y solventarlos prohibiendo las interrupciones en los fragmentos de código
       correspondientes. Aunque se puede implementar esta llamada corno se considere
       oportuno, a continuación se sugieren algunas pautas:

       — Modificar el BCP para incluir algún campo relacionado con esta llamada.
       — Definir una lista de procesos esperando plazos.
       — Incluir la llamada que, entre otras labores, debe poner al proceso en estado bloqueado,
          reajustar las listas de BCPs correspondientes y realizar el cambio de contexto.
       — Añadir a la rutina de interrupción la detección de si se cumple el plazo de algún proceso
          dormido. Si es así, debe cambiarle de estado (LISTO) y reajustar las listas
          correspondientes.

   •   Ofrecer a las aplicaciones un servicio de sincronización basado en semáforos. Se trata de
       un semáforo algo sui géneris. Aunque su modo de operación no se corresponde
       exactamente con el que típicamente poseen los semáforos proporcionados por los
       sistemas operativos reales y su utilidad práctica sea dudosa, su semántica está ideada
       para permitir practicar con distintas situaciones que aparecen frecuentemente en la
       programación de un sistema operativo. Las principales características de estos semáforos
       son las siguientes:

       — El número de semáforos disponibles es fijo (constante NUM_SEM). Un identificador de
          semáforo será un número que se encuentra en el intervalo de O a NUM_SEM —1.
       — Para usar un semáforo, el programa debe reservarlo y fijar el valor inicial de su contador
          (llamada iniciar_sem (unsigned int semid, unsigned int val_ini)). Con esta llamada, el
          proceso se hace dueño del semáforo hasta que lo libere (llamada liberar_sem
          (unsigned int semid)).
       — Una vez iniciado, cualquier proceso puede realizar las operaciones típicas de los
          semáforos: bajar (unsigned int semid) y subir (unsigned int semid). Estas operaciones
          tienen la semántica convencional ofrecida por los semáforos. Devolverán —l si hay un
          error (p. ej.: el identificador del semáforo no es válido o no ha sido iniciado) y O en
          caso contrario.
       — Si la llamada iniciar_sem encuentra que el semáforo solicitado ha sido reservado por
          otro proceso, bloqueará al proceso solicitante hasta que el actual dueño lo libere. Esta
          llamada devolverá —1 si el identificador del semáforo no es válido o el proceso ya
          tiene reservado el semáforo. Si no hay ningún error, devolverá un O.
       — La llamada liberar_sem debe desbloquear a todos los procesos que estaban bloquea
          dos en una operación bajar sobre el semáforo. Además. si hay Lino O Varios OCCSOS
          esperando reservar este mismo semáforo, se desbloqueará al primero de ellos. Esta




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 677 -->

698       Sistemas Operativos. Una visión aplicada

            función devolverá —1 si el identificador del semáforo no es válido o el proceso no es el
            dueño del semáforo, y O en caso contrario.
          — Cuando el proceso termina voluntaria o involuntariamente, se deberán liberar los
            semáforos que el proceso reservó y no liberó.

      •   Sustituir el algoritmo de planificación FIFO por round-robin (el tamaño de la rodaja es igual
          a la constante TICKS_POR_RODAJA). Con la inclusión de este algoritmo aparecen
          cambios de contexto involuntarios, lo que causa un gran impacto sobre los problemas de
          sincroniza ción dentro del sistema al poderse ejecutar varias llamadas de forma
          concurrente. Para sol ventar estos problemas, en la práctica se va a usar una solución
          similar a la utilizada en muchas implementaciones de UNIX: No permitir los cambios de
          contexto mientras el proceso está ejecutando en modo sistema. A grandes rasgos, la
          solución planteada debe cubrir los siguientes aspectos:

          — Al asignar el procesador a un proceso se le debe conceder una rodaja.
          — Al final de cada interrupción de reloj debe comprobarse si se ha cumplido la rodaja. Si
             es así y el proceso estaba ejecutando en modo usuario, se realiza un cambio de
             contexto pasándolo al final de la cola de listos. Si el proceso estaba en modo sistema,
             simplemente se anota en una variable que hay una replanificación pendiente y que, por
             tanto, el proceso debe abandonar el procesador justo antes de retornar a modo
             usuario.
          — Cada vez que termina el procesamiento de una llamada y antes de retornar al modo
             usuario, se debe comprobar si hay una replanificación pendiente y, si es así, llevarla a
             cabo. Observe que si el proceso que tiene pendiente la replanificación se bloquea
             como parte de la ejecución de una llamada no debe aplicársele la replanificación.


C.6.5. Material de apoyo

En esta sección se describe el árbol de archivos que corresponde con el entorno de desarrollo,
minikernel.

      •   Makefile general del entorno. Invoca a los archivos Makefile de los subdirectorios
          subyacentes.
      •   boot. Este directorio está relacionado con la carga del sistema operativo. Contiene el pro
          grama de arranque del sistema operativo.
      •   kernel. Este directorio contiene todos los archivos necesarios para generar el sistema
          operativo:

          — Makefile. Permite compilar el sistema operativo.
          — minikernel. Archivo que contiene el ejecutable del sistema operativo.
          — apoyo. o. Archivo objeto que contiene las funciones de apoyo para la programación del
             sistema operativo.
          — proc. c. Archivo que contiene la funcionalidad del sistema operativo. En él debe incluirse
             la funcionalidad pedida en el enunciado.
          — include. Subdirectorio que contiene los archivos de cabecera usados por el sistema
             operativo:

      •   apoyo. h. Archivo que contiene los prototipos de las funciones de apoyo.
      •   const. . h. Archivo que contiene algunas constantes útiles.
      •   llamsis. h. Archivo que contiene los códigos numéricos asignados a cada llamada al
          sistema. En él deben incluirse las nuevas llamadas.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 678 -->

                                 Apéndice C. Trabajos prácticos de sistemas operativos           699



    •   proc. h. Contiene definiciones usadas por proc. c Como la del BCP.
    •   usuario. Este directorio contiene diversos programas de usuario:

    — Makefile. Permite compilar los programas (le usuario.
    — init. c. Primer programa que ejecuta el sistema operativo. Se puede modificar para que
       invoque los programas que se consideren oportunos.
    — * . c. Programas de prueba.
    — include. Subdirectorio que contiene los archivos de cabecera usados por los programas de
       usuario:

    •   servicios. h. Archivo que contiene los prototipos de las funciones que sirven (le interfaz a
        las llamadas al sistema. En él se debe incluir la interfaz a las nuevas llamadas.
    •   lib. Este directorio contiene los programas que permite generar la biblioteca que utilizan los
        programas de usuario. Su contenido es:

        — Makefile. Compila la biblioteca.
        — libserv.a. La biblioteca.
        — serv. c. Archivo que contiene la interfaz a los servicios del sistema operativo. En él se
            debe incluir la interfaz a las nuevas llamadas.
        — misc. o. Contiene otras funciones de biblioteca auxiliares.


C.6.6. Bibliografía

M. Beck. et al. Linux Kernel Internals, 2. edición, Addison—Wesley, 1997.
B. Kernighan y R. Pike. The UNIX Programming Environment, 2. edición. Prentice-Hall, 1984.
W. R. Stevens. UNIX Network Programming. Addison-Wesley, 1990.
—Advanced Programming in the UNIX Environment. Addison—Wesley. 1992.
A. S. Tanenbaum. Sistemas Operativos Modernos. Prentice—Hall. 1992.
P. S. Nang. An Introduction ¡o Berkeley Unix. Wadsworth, International Student Edition, 1988.


PRÁCTICA C.7. DISEÑO DE ARCHIVOS CON BANDAS

C.7.1. Objetivo de la práctica

Esta práctica tiene los siguientes objetivos principales:

    •   Permitir que el alumno entienda que se puede optimizar el almacenamiento en archivos
        haciendo uso de la concurrencia y del paralelismo.
    •   Enseñar al alumno a diseñar las estructuras que representan un archivo.
    •   Familiarizar al alumno con los mecanismos de programación de sistemas de archivos.


C.7.2. Entorno de desarrollo de la práctica

La práctica consiste en el diseño e implementación de archivos con bandas sobre el sistema de
archivos de UNIX, siguiendo las directrices de este enunciado.
Para ello se proporciona al alumno una estructura de datos, denominada nodo_sfp, en la que se
describe el archivo con bandas, y una descripción de cuál es la representación de un archivo con
bandas.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 679 -->

700       Sistemas Operativos. Una visión aplicada



Sistemas de archivos con bandas (FB)

Un sistema de archivos con bandas permite crear sistemas de archivos que ocupan varias
particiones. Su estructura distribuye los bloques de datos de forma cíclica por los discos que con
forman la partición lógica, repartiendo la carga de forma equitativa. Para optimizar la eficiencia del
sistema de archivos se puede definir una unidad de almacenamiento en cada banda con un
tamaño mayor que el del bloque del sistema de archivos. Esta unidad, denominada unidad de
distribución (stripe unit), es la unidad de información que se escribe de forma consecutiva en cada
banda. Este valor cambia de un sistema, e incluso archivo, a otro, siendo 64 KB el valor por defecto
en Windows NT.
         La Figura C.4 muestra la estructura de un sistema de archivos de bandas que ocupa cuatro
particiones.
         Además, este tipo de sistemas de archivos permite incrementar la fiabilidad del sistema de
archivos insertando bloques de paridad con información redundante. De esa forma, si falta un
dispositivo, se puede reconstruir la información mediante los bloques de los otros dispositivos y la
información de paridad. Además, se puede hacer que la partición sea más tolerante a fallos
distribuyendo también la información de la partición del sistema.
         Un archivo con bandas queda definido por dos parámetros:

      •   Unidad de distribución. Es la unidad de información que se escribe de forma consecutiva
          en cada banda.
      •   Número de subarchivos. Número de archivos UNIX que componen el archivo con
          bandas.

     En el caso de la práctica, tanto la unidad de distribución como el número de subarchivos son
parámetros que se piden a la hora de crear el archivo con bandas.
     Lógicamente, el archivo con bandas se ve como un único archivo por el usuario. Esto significa
que el puntero de posición es único para el archivo con bandas, independientemente de que
interna mente el sistema mantenga un puntero por cada subarchivo. Igualmente, cuando se pide
informa ción de estado del archivo, o se hace un ls, la información que aparece es global para el
archivo.




Figura C.4. Sistema de archivos con bandas




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 680 -->

                                Apéndice C. Trabajos prácticos de sistemas operativos            701



        La forma de operar sobre un archivo con bandas es la siguiente. Cuando se va a leer del
archivo, se accede al subarchivo donde indica el puntero de posición del FB. Sobre esa subunidad
se lee lo que reste de la unidad de reparto y luego se pasa a los siguientes subarchivos.
Evidentemente, si se leyera de varias subunidades se podría hacer en paralelo, pero teniendo en
cuenta que la modificación del puntero de posición será la del puntero global.


Nodo_sfp de un archivo con bandas (nodo_sfp)

En un objeto archivo se puede almacenar información de tipo muy distinto: código fuente, pro
gramas objeto, bibliotecas, programas ejecutables, texto ASCII, agrupaciones de registros,
imágenes, sonidos, etc. Desde el punto de vista del sistema operativo, un archivo se caracteriza
por tener una serie de atributos. Dichos atributos varían de tinos sistemas operativos a otros, pero
todos ellos tienen una estructura interna que los describen. En nuestro caso, esa estructura se
denominará nodo_sfp y se muestra en la Figura C.5.
        El nodo_sfp usado contiene la siguiente información:

    •   Identificador único: a nivel interno, el sistema operativo no usa el nombre para identificar a
        los archivos, sino un identificador único fijado con criterios internos al sistema operativo.
        Este identificador suele ser un número y habitualmente es desconocido por los usuarios.
        En el caso de la práctica será un número entero que nunca decrece. Por tanto, hay que
        tener un contador para asignar el número de nodo_sfp.
    •   Identificador del proceso propietario y de su grupo. Son el pid y el gid del proceso creador.
    •   Protección: información de control de acceso que define quién puede hacer qué sobre el
        archivo, el dueño del archivo, su creador, etc.
    •   Nombre: identificador del archivo en formato comprensible para el usuario. Definido por su
        creador.
    •   Número de subarchivos que componen el archivo con bandas. Definido por su creador.
    •   Tamaño de la unidad de distribución, en bytes. Este dato indica la cantidad de datos
        consecutiva que se escribe en cada subarchivo.
    •   Tamaño del archivo: número de bytes en el archivo.
    •   Tiempos: de creación y de última actualización. Esta información es muy útil para
        gestionar, monitorizar y proteger los sistemas de archivos.
    •   Número de veces que el archivo ha sido abierto simultáneamente. Es el número de
        sesiones existentes sobre el archivo.




Figura C.5. Nodo_sfp de los archivos con bandas




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 681 -->

702       Sistemas Operativos. Una visión aplicada



         La biblioteca debe mantener en memoria una tabla de nodos_sfp abiertos, denominada
tnodos_sfp. En esa tabla estarán los nodo_sfp con sesiones pendientes, pero cada nodo_sfp
estará únicamente una vez, independientemente de las sesiones que tenga abiertas. Las entradas
de la tabla tendrán un nodo_sfp con un número identificador positivo mayor que cero si están
ocupadas y con identificador — 1 si están libres.
         Cuando se abre un archivo, hay que entrar en la tabla y buscar el primer hueco libre. Esa
entrada es la ocupada y sobre ella se almacena el nodo_sfp leído del archivo de nodos . sfp que
incluye las estructuras nodo_sfp de los archivos con bandas existentes en el sistema. El número de
nodo_sfp no coincide con su posición en las filas de la tabla, por lo que cuando se busque un
nodo_sfp habrá que buscar desde el principio. El valor del nodo_sfp se extrae del archivo de
nodos. sfp. Si el archivo pedido ya estaba abierto, tendrá una entrada en esta tabla. Por tanto, lo
único que se debería hacer es incrementar en 1 el número de veces que está abierto.
         Cuando se cierre un archivo hay que decrementar el contador de sesiones abiertas y, si es
cero, liberar la entrada de la tabla asociada al nodo_sfp. En el archivo nodos. s p también hay que
actualizar el valor del nodo_sfp con el número de sesiones pendientes a cero.
         Todas las modificaciones del nodo_sfp deben reflejarse en el archivo nodos. sfp, es decir,
se debe usar la política de escritura inmediata (write-through).


Tabla de descriptores de archivos (tdf_sfp)

Para desacoplar a los procesos que usen la biblioteca de los descriptores internos de los archivos,
nodo_sfp, y para permitir que un archivo se pueda abrir varias veces sin que haya conflictos con
los accesos, se usará una tabla de descriptores de archivos como la que se muestra en la Figura
C.6.
        La tabla tiene cuatro entradas:

      •   Descriptor de archivo abierto. Es el que obtiene el proceso cuando ejecuta open. Este
          descriptor es un número entero entre 0 y MAX_FD. Teniendo en cuenta que 0, 1 y 2 están
          reservados para la STDIN, STDOUT y STDERR como en UNIX.
      •   Número de nodo sfp. Descriptor interno del archivo. Con este descriptor se pueden buscar
          los metadatos del archivo en la tabla tnodos_sfp.
      •   Puntero de posición del archivo. Para esa sesión del archivo abierto incluye la posición del
          archivo sobre la que se ejecutan las operaciones de E/S.
      •   Bandera de ocupado o libre. Está a O cuando está libre y a 1 cuando está ocupado.




Figura C.6. Tabla de descriptores de archivos.


Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 682 -->

                                 Apéndice C. Trabajos prácticos de sistemas operativos             703



         Cuando se abre un archivo hay que entrar en la tabla y buscar el primer descriptor libre.
Esa entrada es la ocupada y su descriptor de archivo el devuelto. En la práctica, el número de fd
coincidirá con su posición en las filas de la tabla, El valor del puntero de posición del archivo recién
abierto es cero. El valor del nodo_sfp se extrae del archivo de nodos_sfp, denominado nodos.sfp, y
se incluye en la columna correspondiente. Puesto que, como se ve en la figura, varias entradas de
esta tabla pueden apuntar al mismo nodo E p, ya que se puede abrir un archivo repetidamente sin
ningún problema.
         Cuando se cierre un archivo hay que liberar la entrada del descriptor asociado al mismo y
se borran los contenidos de dicha entrada.


Estructuración de la información

Con lo descrito hasta ahora, ya se puede explicar cómo y dónde debe quedar la información
resultante de la ejecución de la práctica. Para simplificar la realización de la práctica, supondremos
que todos los archivos con bandas se crean dentro de un subdirectorio del directorio donde se
ejecuta la práctica, denominado sfp. Por tanto, todos los nombres de archivo con bandas deberían
empezar por /sfp/.
        Dentro del directorio . /sfp estarán:

    •   El archivo nodos. sfp. Todos los accesos a este archivo se hacen usando el tipo nodo_sfp
        definido.
    •   Los subarchivos resultantes de los archivos con bandas creados. Por tanto, cuando se
        ejecute un mandato ls. /sfp de UNIX sobre ese directorio, se verán entradas del tipo
        mi_fbandas_1 a mi_fbandas_n. No existirá ninguna entrada de archivo con bandas, ya que
        esta entelequia existe únicamente a nivel de biblioteca y de metadatos.

   Para saber si las operaciones de archivos con bandas funcionan bien, bastará en muchos
casos con monitorizar el directorio /sfp.


C.7.3. Descripción de la funcionalidad a desarrollar por el alumno

Para construir un servidor de archivos similar a un servidor real, se recomienda desarrollar esta
práctica en varias etapas.


Primera etapa

En esta etapa, el alumno debe desarrollar una biblioteca de funciones para manipular los archivos
con bandas. En esta sección se describe la funcionalidad de esta biblioteca, que debe incluir las
siguientes funciones para manejar este tipo de archivos:

    • crear sfp. Permite crear un archivo con bandas. Su prototipo es:
    int crear_sfp (char * nombre, unsigned int permisos, unsigned int num_bandas, unsigned int
                   u_distribucion);

            Esta función crea el archivo, pero no lo abre. Para abrirlo es necesario hacer la
        llamada que se describe a continuación. El efecto de crear_sfp es la aparición de un
        archivo vacío con el nombre, protecciones, número de bandas y unidad de distribución
        definida en la llamada. Si el archivo ya existe, se trunca. dejándolo vacío de contenido.
        Además se crea el nodo_sfp y se incluye, relleno con los datos del archivo, en el archivo
        nodos. sfp.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 683 -->

704       Sistemas Operativos. Una visión aplicada


              En caso de que ya exista el archivo, se modifica su longitud a cero y se liberan sus
          datos. Si se intenta crear un archivo que está abierto, la llamada debe devolver un error. El
          código de error es -1.
              Cuando se abra un archivo con bandas aparecerán en el subdirectorio. /sfp tantos
          subarchivos (archivos UNIX) como se indique en la creación. El nombre de dichos
          subarchivos se debe construir uniendo al nombre del archivo con bandas un entero
          correspondiente al número de subarchivo. Por ejemplo, para mi_fbandas, los subarchivos
          serían:
              mi_fbandas_1 a mi_fbandas_n. Los permisos de acceso de los subarchivos deberán
          estar en consonancia con los solicitados para el archivo con bandas.
      •   abrir_sfp Permite abrir un archivo con bandas. Su prototipo es:

          int abrir_sfp (char * nombre, unsigned int modo);

               Esta llamada abre el archivo, y sus subarchivos asociados, y devuelve un identificador
          de archivo con el que trabajar. Además, lee el nodo_sfp en el archivo nodos. sfp y lo carga
          en la tabla de nodos_sfp en memoria, dentro de la primera entrada de la tabla que esté
          libre. Los modos de acceso posibles son FD_READ, FDWRITE y FD para lectura, escritura
          y lectura-escritura, respectivamente.
               Si el archivo ya estaba abierto, incrementa el contador de aperturas del nodo Para
          terminar, actualiza la tabla de descriptores de archivos con una nueva entrada para este
          archivo. En caso de que el archivo no exista, el modo de acceso solicitado no sea
          adecuado o no haya espacio en alguna tabla, la llamada devuelve un —1.
      •   cerrar_sfp. Permite cerrar un archivo con bandas. Su prototipo es:

          int cerrar_sfp (int fd);

              Esta llamada cierra el archivo con bandas y sus subarchivos asociados y decrementa
          el contador de aperturas del nodo_sfp. Además se libera su entrada de la tabla de
          descriptores de archivos. Si el contador de aperturas del archivo es igual a cero, se elimina
          el nodo_sfp del archivo de la tabla de nodo_sfp. Si el identificador de archivo pedido no
          existe, debe devolver un error.
      •   borrar_sfp. Borra un archivo con bandas. Su prototipo es:

          int borrar sfp (char * nombre);

              Esta llamada comprueba si el archivo está abierto, devolviendo error en este caso. Si
          el archivo no está abierto por ningún usuario, se borra el archivo con bandas y los
          subarchivos que lo componen y se elimina su nodo_sfp del archivo nodos. sfp.
      •   leer_sfp. Lee de un archivo con bandas a un buffer de memoria. El archivo debe estar
          abierto. Su prototipo es:

          int leer sfp (int fd, char * buffer, int tamanyo)

              Lee del archivo fd a un buffer la cantidad de datos tamanyo. Además adelanta el
          puntero de posición y lo modifica en la tabla de descriptores de archivo y en el nodo_sfp.
          Evidentemente, si el tamaño pedido es mayor que la unidad de distribución, hay que leer
          de los distintos subarchivos que contienen los datos. En caso de que el puntero de
          posición se encuentre en medio de una unidad de distribución, hay que leer en ese
          subarchivo la porción de unidad restante (módulo) y luego seguir a los otros.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 684 -->

                                  Apéndice C. Trabajos prácticos de sistemas operativos         705




           Esta función devuelve la longitud de los datos leídos realmente, que será siempre
       menor o igual al tamaño pedido. Si el archivo no está abierto, debe ciar un error. Si se
       intenta leer más allá del fin de archivo, se deben devolver los datos existentes. l caso de
       que no haya ninguno, se devuelve cero.
   •   escribir_sfp. Escribe un buffer de memoria a un archivo con bandas. El archivo debe estar
       abierto. Su prototipo es:

   int escribir_sfp (int fd, char * buffer, int tamanyo)

            Escribe en el archivo fd desde un buffer la cantidad de datos tamanyo. Además
       adelanta el puntero de posición, lo actualiza en la tabla de descriptores de archivos y
       modifica su hora de última actualización y la de última modificación. Evidentemente, si el
       tamaño pedido es mayor que la unidad de distribución, hay que escribir en los distintos
       subarchivos que contienen los datos. En caso de que el puntero de posición se encuentre
       en medio de una unidad de distribución, hay que escribir en ese subarchivo la porción de
       unidad restante (módulo) y luego seguir a los otros.
            Esta función devuelve la longitud de los datos escritos realmente, que será siempre
       menor o igual al tamaño pedido. Si el archivo no está abierto, debe dar un error. Si se
       intenta escribir más allá del fin de archivo, no hay ningún problema, simplemente se
       añaden los datos al archivo y se modifica su longitud. En caso de que no haya espacio en
       el dispositivo, se devuelve error.
   •   posicionar_sfp. Mueve el puntero de posición de un archivo con bandas. Su prototipo es:

       int posicionar_sfp (int fd, off_t desplazamiento, int desde);

           Esta operación se hace sobre la tabla de descriptores de archivo, donde está su
       puntero de posición. Con ella se puede cambiar dicho puntero mediante un desplazamiento
       con relación a desde. Los puntos que se pueden usar como referencia son el principio del
       archivo (SEEK_SET), el final (SEEK_END) y la posición actual (SEEK_CUR). Si se mueve
       más allá del fin de archivo, la llamada debe devolver un error. El archivo debe estar abierto.
   •   estado_sfp. Permite consultar la información de estado de un archivo. Su prototipo es:

       int estado_sfp (char *nombre, struct nodo_sfp estado); \\

           Se entiende por información de estado la contenida en el nodo_sfp del archivo. El
       archivo no tiene por qué estar abierto. Esta operación se hace sobre el nodo_sfp del
       archivo. Devuelve un —1 en caso de error.


Segunda etapa

Además de la biblioteca anterior, el alumno puede hacer los mandatos sfp_ls y sfp_cat para poder
consultar la información de dichos archivos.

   •   sfp_ls. Permite ver los metadatos de los archivos con bandas que se han creado hasta el
       momento, es decir, todos los existentes en el directorio . /sfp/. La información debe re
       presentar al archivo con bandas y no a sus subarchivos. La información a mostrar por cada




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 685 -->

706       Sistemas Operativos. Una visión aplicada



          archivo es: permisos, gid. uid, longitud, fecha de última escritura y nombre. Similar a un ls
          —1 de UNIX:
                  —rw-r—--r—- 1 jcarrete           937 Sep 23 16:05 Makefile.

          El mandato admite dos formatos:

              — sfp_ls . /sfp/nombre-archivo para ver información de un archivo específico.
              — sfp_ls ./sfp para ver todos los archivos del directorio.

      •   sfp_cat. Permite ver los datos de un archivo con bandas existente en el directorio. /sfp/ por
          la salida estándar. El formato del mandato es sfp_cat - /sfp/nombre-archivo. Es similar al
          mandato cat de UNIX.


Tercera etapa

En esta parte se pide al alumno que modifique la implementación de la biblioteca y de los
programas de prueba anteriores para que se comporten como un sistema cliente-servidor. Para
ello debe existir un proceso servidor de archivos, con el que se comunican los clientes a través de
sockets. El servidor debe ser concurrente.


C.7.4. Llamadas al sistema operativo

Para la realización de esta práctica sólo se deben usar llamadas, al sistema de archivos, tales
como read, write, close, 1seek, o ioctl.
         Para obtener información más detallada de estas llamadas se recomienda mirar la
bibliografía de la práctica y los manuales de la máquina para los mandatos de archivos (p. ej.: man
lseek).


C.7.5. Recomendaciones generales al alumno

      •   Se recomienda hacer un programa bien estructurado, evitando la linealidad. Se puede pro
          gramar mucho código en funciones.
      •   Se debería hacer un control exhaustivo de errores, tanto de ejecución en las llamadas al
          sistema y funciones como de la distribución de datos en los subarchivos.
      •   En caso de que tenga problemas durante el desarrollo de la práctica, intente solventarlos
          antes de hacer pruebas defectuosas. Use el depurador.
      •   Se recomienda programar funciones de utilidad para ver los contenidos de las tablas de
          nodo_sfp, de descriptores de archivos y del archivo de nodos. sfp.
      •   Existen varias pruebas que el alumno puede realizar para ver si la funcionalidad de la
          práctica es correcta. A continuación se sugieren algunas:
          — Después de crear un archivo con bandas se puede verificar que las entradas de los
               subarchivos están en. /sfp con longitud cero. Después de borrarlo, dichas entradas
               deberán haber desaparecido. Igualmente, cuando se cree un archivo, debe aparecer
               un nodo_sfp nuevo en el archivo. /sfp/nodos.sfp. En caso de horrado, la entrada
               deberá desaparecer. Si se crea un archivo que ya existe, compruebe que su longitud
               se trunca a cero.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 686 -->

                               Apéndice C. Trabajos prácticos de sistemas operativos         707



        — Después de abrir un archivo, la entrada de su nodo_sfp deberá estar en la tabla de
          nodos_sfp de memoria. Si ya lo estaba, su contador de aperturas se habrá
          incrementado en 1. después de cerrarlo, la entrada deberá desaparecer. Si el contador
          era mayor que 1 se decrementará en 1
        — Se recomienda al alumno implementar dos rutinas. read-verify y write—verify, para
          comprobar que los datos se leen y escriben bien en los archivos. Como indica su
          nombre, leen y escriben datos y después verifican que los datos manipulados están
          correctos en el archivo con bandas.
        — Se aconseja escribir en medio de la unidad de distribución y ver si los datos se
          distribuyen bien. No se limite a escribir siempre en bloques que coinciden con la unidad
          de distribución.
        — Tras las operaciones de creación y de escritura de un archivo se debe comprobar que
          las fechas correspondientes del nodo-i se habrán modificado.
        — Se recomienda escribir un archivo con longitud y datos conocidos. Hacer una
          operación de posicionar y leer para ver si se está en el lugar adecuado. A continuación
          se debería intentar ir más allá del fin de archivo para ver si se obtiene error.
        — Se aconseja escribir un archivo con longitud y datos conocidos y ejecutar un mandato
          sfp_cat para ver si se obtienen los datos escritos previamente.


C.7.6. Bibliografía

A. Silberschatz y P. B. Galvin. Operating Systems Concepts. 5. edición. Addison-Wesley. 1999.
D. A. Solomon. Inside Windows NT. Microsoft Press, 1998.
W. R. Stevens. Advanced Programming in the UNIX Environment. Addison-Wesley. 1992.
A. S. Tanenbaum. Operating Systems: Design and Implementation. 2. edición. Prentice-Hall, 1987.
—Modern Operating Systems. Prentice-Hall, 1991.
P. S. Wang. An Introduction to Berkeley Unix. Wadsworth. International Student Edition. 1988.




Digitalización Realizada con propósito académico. Sistemas Operativos

