# Apendice B

> Fuente: Sistemas Operativos. Una vision aplicada (Javier) — páginas 636–647 (numeración del PDF)

<!-- pág. 636 -->

                                            Entorno de programación
                                                                                        B
                                              de sistemas operativos



La programación de aplicaciones sobre sistemas operativos supone conocer y usar las bibliotecas
con las llamadas al sistema operativo. Para hacer una aplicación con llamadas al sistema operativo
es necesario indicar en los programas los archivos con:

    •   La definición de prototipos y tipos de datos, por ejemplo <windows.h>, para que puedan
        compilarse los módulos del programa, así como el directorio, o directorios, en que se
        encuentran
    •   Los archivos de bibliotecas del sistema que deben enlazarse con la aplicación para crear
        un archivo ejecutable, incluyendo el camino donde localizar dichas bibliotecas.
    •   Las opciones de compilación que deben activarse para compilar y enlazar la aplicación.

    Cada compilador proporciona un entorno de programación, más o menos integrado, para
simplificar el proceso de construcción del software. Dentro de este entorno existe habitual mente un
proyecto, o makefile, que almacena la información que específica cómo compilar y enlazar una
aplicación.
    En este apéndice se muestra brevemente el entorno de programación en el sistema operativo
Windows y en UNIX/LINUX. Ambos incluyen herramientas para desarrollar programas, pero el nivel
de integración de las mismas suele ser muy distinto. Los entornos que se estudian en este
apéndice corresponden al compilador de Visual C++, de Microsoft, y al compilador gcc del lenguaje
C para UNIX/LINUX. Como ejemplo de trabajo se utilizará una versión simplificada del programa
Reloj, correspondiente a un trabajo práctico de Sistemas Operativos expuesto en el Apéndice C.


B.1. MAKEFILES DE UNIX
El archivo makefile describe, en UNIX y LINUX, cómo construir una aplicación, incluyendo las
dependencias de bibliotecas y archivos. El programa make utiliza esta información para determinar
qué archivos deben compilarse y enlazarse para producir una unidad ejecutable de la aplicación,
de forma que sólo se compilen aquellos que han cambiado o que dependen de un archivo que ha
cambiado.




Digitalización Realizada con propósito académico. Sistemas Operativos                       657

<!-- pág. 637 -->

658     Sistemas Operativos. Una visión aplicada


B.1.1. Estructura de un archivo makefile

El Listado B.1 contiene el makefile del programa Reloj, que específica cómo construir el ejecutable
reloj. Por convención, una especificación de makefile se almacena típicamente en un archivo
llamado Makefile o makefile. Para ejecutar el programa make y construir una aplicación, sólo
hay que teclear el mandato make dentro de un intérprete de mandatos (shell). El programa make
busca en el directorio actual un archivo llamado Makefile o makefile y lo procesa.


Listado B.1. Makefile de Reloj.

#
# Las siguientes líneas especifican que los archivos de C
# tendrán una extensión c.

.SUFFIXES:
.SUFFIXES:.c $(SUFFIXES)

# Asignar a CC el nombre del compilador de C usado.

CC = gcc
# Asignar a DIR_APOYO la ruta del directorio que contiene
# los directorios del material de apoyo.
# Las bibliotecas del sistema se incluyen por defecto.

DIR_APOYO = ./apoyo

#
# La variable CFLAGS especifica dónde encontrar
# los archivos a incluir desde el material de apoyo.

CFLAGS = -I$ (DIR_APOYO)/include -g

# La siguiente regla le indica a make cómo procesar los
# archivos con extensión c. Normalmente esto no es necesario
# porque la extensión .c está definida para make.

.c.o:
        $(CC) $(CFLAGS -c $<

# La variable LDFLAGS especifica dónde encontrar
# los archivos de las bibliotecas. Las bibliotecas del
# sistema se incluyen por defecto.

LDFLAGS = L$ d){DIR_APOYO)/lib

#
# La variable LIBS especifico al compilador qué bibliotecas
# de archivos objeto se deben usar para construir la aplicación, además
# de las del sistema.
#




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 638 -->

                        Apéndice B. Entorno de programación de sistemas operativos           659

LIBS = -lapoyo

#
# La variable OBJS específica al compilador qué archivos
# objeto se deben crear para construir la aplicación

OBJS = reloj.o clock_task.o hardware.o

# La siguiente regla específica cómo construir
# el ejecutable del programa, así como las dependencias
# de archivos #include (.h)
#

reloj: $(OBJS)
         $(CC) $(OBJS) $[LDFLAGS) $[LIBS) -o reloj

reloj.o: reloj.h
clock_task.o: reloj.h
hardware.o: reloj.h

# Regla clean. La ejecución de ‘make clean’ borra todos los archivos
# objeto y el ejecutable
 clean:
 rm -f *.o reloj



         Para compilar en UNIX O LINUX hay que ir aI directorio donde se encuentra el makefile de
la aplicación y ejecutar el mandato make, como se muestra en la Figura 13.1.




Figura B.1. Compilando con make en UNIX.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 639 -->

660       Sistemas Operativos. Una visión aplicada

En un makefile, un comentario comienza con el carácter #. La especificación de un, makefile puede
ser muy oscura, y difícil de mantener, si no se comenta adecuadamente.
        Las líneas siguientes del, makefile especifican al programa make las extensiones de los
archivos que se van a compilar. En este caso se indica que los archivos de C tienen la extensión
.c.


      •   SUFFIXES:
      •   SUFFIXES: .c $(SUFFIXES)

     Algunos lenguajes, por ejemplo C++, esperan archivos que tengan la extensión .cpp o .cc. Si
esto es lo que sucede, se debería cambiar el .c de la segunda línea a .cpp o .cc, o añadir dichos
sufijos a la línea de definición. Todos los archivos de C proporcionados en este libro tienen la
extensión .c.
     La siguiente línea define el compilador que se debe usar para compilar los programas:


      CC = gcc

   En este ejemplo se asigna a la variable CC el nombre del mandato que corresponde con el
compilador de C que traduce el código fuente. En este fragmento se le da el valor gcc que es el
compilador de GNU para el lenguaje C en UNIX y LINUX.
   La línea:


      DIR APOYO = ./apoyo

asigna la ruta que se corresponde con los directorios de inclusión y de la biblioteca del material de
apoyo para la construcción del programa reloj. Es siempre mejor usar variables relativas a la
situación del programa a construir, porque así se puede instalar la aplicación en distintos
directorios cada vez sin que haya que modificar el archivo makefile.
         La línea:


          CFLAGS= -I $(DIR_APOYO)

establece una variable que informa al compilador de C dónde debe buscar los archivos de inclusión
del material de apoyo del usuario y los del sistema. Además de buscar en este directorio, el
compilador siempre busca en los directorios del sistema, que suelen ser /usr/include y sus
subdirectorios.
        De manera similar la asignación siguiente:


          LDFLAGS= - L $ (DIR APOYO)/lib

define una variable que informa al cargador de UNIX, ld, dónde debe buscar los archivos de
biblioteca. Además de buscar en este directorio, el compilador siempre busca en los directorios del
sistema, que suelen ser /usr/lib y sus subdirectorios.
         La variable LIBS especifica al compilador qué bibliotecas de archivos objeto se deben usar
para construir la aplicación.


LIBS= -lapoyo




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 640 -->

                         Apéndice B. Entorno de programación de sistemas operativos               661



Las líneas siguientes:

.c.o:
        $(CC) $ (CFLAGS) –c $<

son una regla de dependencia implícita que especifica que un tipo de archivo se construye a partir
de otro y describe cómo rechazar su construcción. En este ejemplo, las líneas anteriores
especifican que los archivos .o se construyen a partir de los archivos .c mediante el compilador de
C.
        La asignación siguiente:

OBJS=reloj.o clock_task.o hardware.o

da valor a la variable OBJS con los nombres de los archivos objeto que forman la aplicación. La
aplicación reloj tiene tres módulos objeto de aplicación: reloj.o, clock_task.o y hardware.o. Para
una aplicación diferente habría que modificar esta línea para asignar a OBJS los módulos objeto de
dicha aplicación.
        El siguiente conjunto de líneas es el corazón del ,makefile. Estas líneas son reglas de
dependencia que especifican Cómo construir la aplicación. Por ejemplo, las siguientes líneas:

        reloj: $(OBJS)
                 $(CC) $(OBJS) $(LDFLAGS) $(LIBS) -o reloj

del ,makefile de Reloj especifican que reloj depende de OBJS, que tiene el valor reloj.o,
clock_task.o y hardware.o. Además depende de LIBS, que tiene el valor libapoyo.a. Si
cualquiera de estos archivos objeto es más reciente que reloj, make ejecuta la línea de mandato
que produce una nueva versión de reloj más reciente que los archivos objeto. Si lodos los archivos
objeto son más antiguos que reloj, significa que reloj está actualizado y, por lo tanto, no se necesita
realizar ninguna acción.
         Después de que se hayan construido todos los archivos objeto necesarios, su fecha de
actualización será más reciente que la de reloj, por lo que se ejecuta el mandato que construye
reloj.
         La lista completa de opciones del programa make se puede obtener mediante el siguiente
mandato:

man make

Para ejecutar una aplicación en UNIX basta con teclear el nombre de la aplicación en el prompt del
intérprete de mandatos (Fig. B.2).


B.1.2. Gestor de bibliotecas

Existe en UNIX y LINUX una utilidad para la creación y mantenimiento de bibliotecas de archivos.
Su principal uso es crear bibliotecas de objetos, es decir, agrupar un conjunto de objetos
relacionados dentro una entidad lógica que se puede usar como un elemento de compilación.
         En la línea de compilación se especifica la biblioteca (por convención libnombre.a) en vez
de los objetos que hay dentro de ella. El enlazador extraerá de la biblioteca los objetos que
contienen las variables y funciones requeridas y los insertará dentro del programa ejecutable o
incluirá referencias dinámicas a dichos objetos.
         Formato del mandato:

ar opciones biblioteca archivos…



Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 641 -->

662       Sistemas Operativos. Una visión aplicada




Figura B.2. Ejecución de reloj en UNIX.

         Algunas opciones de este mandato son:
      •   -d. Elimina de la biblioteca los archivos especificados.
      •   -r. Añade (o reemplaza si ya existe) a la biblioteca los archivos especificados. Si no existe
          la biblioteca, se crea.
       • -ru. Igual que -r pero sólo reemplaza si el archivo es más nuevo.
       • -t. Muestra una lista de los archivos contenidos en la biblioteca.
          -v. Verbose.
      • -x. Extrae de la biblioteca los archivos especificados.

A continuación, se muestran algunos ejemplos de aplicación de este mandato:
    • Obtención de la lista de objetos contenidos en la biblioteca estándar de C.

                  ar -tv /usr/lib/libc.a

      •   Creación de una biblioteca con objetos que manejan distintas estructuras de datos.

                  ar -rv $HOME/lib/libest.a pila.o lista.o
                  ar –rv $HOME/lib/libest.a arbol.o hash.o

      •   Creación de la biblioteca con material de apoyo que incluye el objeto del programa que
          simula el dispositivo reloj.

                  ar -rv $HOME/apoyo/libapoyo.a dispositivo.o

Hay dos formas posibles de compilar un programa que use una biblioteca: con nombre absoluto y
con nombre relativo. En este último caso es necesario tener una variable de entorno para indicar
dónde está la biblioteca, como se ha hecho en el makefile anterior. A continuación, se muestran
ejemplos de uso de ambas formas:




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 642 -->

                         Apéndice B. Entorno de programación de sistemas operativos            663




gcc -o reloj reloj.c clock_task.c hardware.c
        $HOME/apoyo/libapoyo.a
gcc –o reloj reloj.c clock_task.c hardware.c
        -L$HOME/apoyo -lapoyo


        Observe que la forma de especificar la biblioteca es distinta en ambos casos. Cuando se
especifica el nombre absoluto, se indica el nombre completo del archivo donde está la biblioteca.
Cuando se especifica un nombre relativo, sólo se indica una porción de dicho nombre: se asume
una extensión válida y se elimina el prefijo lib.


B.1.3. Depuración de una aplicación en UNIX o LINUX

En todas las versiones del sistema operativo UNIX, incluyendo LINUX, existe un programa de
depuración de programas. En el caso de LINUX existe un depurador denominado gdb. El
depurador permite que el usuario pueda controlar la ejecución de un programa y observar su
comporta miento interno mientras ejecuta. Estos programas son muy útiles cuando se programa o
prueban aplicaciones, como las prácticas de alumnos. Su uso puede ahorrar mucho tiempo de
desarrollo y facilitar la tarea de los programadores.
        Para poder depurar un programa, el compilador debe incluir información especial dentro del
mismo. Por ello, para poder depurar un programa compilado con el gcc, se debe compilar con la
opción -g.
        A continuación se describen algunas de las Funciones de un depurador genérico:

    •   Establecer puntos de parada en la ejecución del programa (breakpoints).
    •   Examinar el valor de variables.
    •   Ejecutar el programa línea a línea.

    El formato del mandato para ejecutar el depurador en LINUX es:

gdb programa_ejecutable

       En el caso del makefile del ejemplo se ha creado un ejecutable denominado reloj. Para
depurarlo habría que ejecutar el mandato:

gdb reloj

Algunos mandatos internos del gdb son:

    •   run. Arranca la ejecución del programa.
    •   break. Establece un breakpoint (un número de línea o el nombre de una Función).
    •   list. Imprime las líneas de código especificadas.
    •   print. Imprime el valor de una variable.
    •   continue. Continúa la ejecución del programa después de un breakpoint.
    •   next. Ejecuta la siguiente línea. Si se trata de una llamada a función, la ejecuta completa.
    •   stop. Ejecuta la siguiente línea. Si se trata de una llamada a función. ejecuta sólo la
        llamada y se para al principio de la misma.
    •   quit. Termina la ejecución del depurador.




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 643 -->

664    Sistemas Operativos. Una visión aplicada



B.2. ENTORNO DE PROGRAMACIÓN DEL VISUAL C++ DE MICROSOFT

Este compilador proporciona un entorno de programación y desarrollo totalmente integrado. A
través del mismo se puede acceder a todas las utilidades necesarias para escribir, compilar y
probar un programa. En la Figura B.3 se muestra la ventana principal del compilador Visual C++ de
Microsoft. En la parte superior de la ventana hay un menú con mandatos tales como File, Edit,
View y Help. Debajo de los elementos del menó hay una barra de herramientas con varios
botones, que proporcionan acceso rápido a muchos de los mandatos usados frecuentemente:
open, close, help, etc. Se puede obtener ayuda de cualquiera de las características del entorno,
ejecutando el mandato Help.


B.2.1. Creación de un espacio de trabajo

El primer paso para crear un archivo de proyecto para una aplicación de Sistemas Operativos es
crear un espacio de trabajo y un proyecto, mediante el menú: File ->New. Dentro de la caja de
diálogo New debe especificarse el tipo de aplicación que se está construyendo. La elección
correcta depende de que la aplicación requiera una consola. Cualquier aplicación de Sistemas
Operativos c acepte entrada de teclado del usuario mediante el objeto de iostream cin o escriba
en la pantalla mediante el objeto de iostream cout requiere una consola. Para este tipo de
aplicación de Sistemas Operativos la selección apropiada es Win32 Console Application. Si la
aplicación no utiliza la biblioteca iostream, la selección apropiada es win32 Application.
         El paso final es especificar la posición del proyecto. En el ejemplo se quiere que el
proyecto resida en c:\jesus\docencia\sos2\apendice2\reloj, por lo que habrá que navegar
hasta c:\jesus\docencia\sos2\apendice2\reloj y teclear reloj en el campo Project name:. Para
crear el proyecto se debe pulsar el botón OK.
         Para compilar el archivo reloj.c sólo hay que indicarlo en la opción Build, que se muestra
en la Figura B.4.




Figura B.3. Ventana principal de Visual C++ de Microsoft




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 644 -->

                        Apéndice B. Entorno de programación de sistemas operativos              665




Figura B.4. Compilación de reloj en Visual C++ de Microsoft

El compilador de Visual C++ de Microsoft almacena la información de cómo construir una
aplicación en un archivo de proyecto. Los archivos de proyecto tienen la extensión .dsp. En el caso
del ejemplo habría un nuevo archivo denominado reloj.dsp. Para salvar un archivo de proyecto se
usa el menú: File—>Sabe Works pace.
        Después de crear el archivo de proyecto, inicialmente, el proyecto está vacío y habrá que
añadirle los archivos fuente del proyecto. El programa de ejemplo, Reloj, consta de varios módulos
fuente: reloj.c, clock_task.c y hardware.c. Además, como material de apoyo a los alumnos se
proporciona una biblioteca y un archivo de definición de estructuras de datos (*.h). La Figura B.5
muestra un diagrama simplificado de la estructura de módulos de Reloj.
        Para activar la caja de diálogo para añadir archivos al proyecto se ejecuta el mandato:
Project->Ad Lo Project->Files. Este paso activa la caja de diálogo que se muestra en la Figura B.6.
        Para poder compilar y enlazar el proyecto es necesario definir correctamente las opciones
del proyecto para poder encontrar los archivos a incluir y las bibliotecas que se van a usar. Esto se




Figura B.5. Estructura de módulos del programa reloj




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 645 -->

666    Sistemas Operativos. Una visión aplicada




Figura B.6. Caja de diálogo «Insert Files into Project» del Visual C++ de Microsoft


consigue mediante el mandato: Tools ->Options. Para ello se ejecuta el menú Show directories
for-> Include files, y se teclea la ruta en la ventana Directories. En el ejemplo del reloj, esta ruta
es c:\jesus\docencia\sos2\apendice2\reloj.apoyo. El valor por defecto del campo Directorias indica
la posición de los archivos de inclusión del sistema. La Figura B.7 muestra la caja de di Options
después de que se ha añadido la entrada del directorio de inclusión del programa reloj. De igual
manera se puede definir el directorio para la biblioteca de apoyo, pero usando el menú Show
directories for -> Libraries.
         Para compilar y enlazar la aplicación se usa el menú: Build -> BuiId reloj.exe. Este




Figura B.7. Caja de diálogo «Options» del Visual C++ de Microsoft




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 646 -->

                        Apéndice B. Entorno de programación de sistemas operativos              667



mandato hace que se compilen todos los módulos que han cambiado desde la última compilación y
que después se enlacen todos los archivos objeto y las bibliotecas pedidas en una unidad
ejecutable. El ejecutable se escribe en el archivo reloj .exe puesto que ése es el nombre del
proyecto.


8.2.2. Ejecución de una aplicación en Visual C++

Para ejecutar una aplicación utilizando el C++ de Microsoft existen dos opciones:

    •   Ejecución desde el entorno de Visual C++.
    •   Ejecución desde una consola de MS-DOS.

     Para ejecutar desde el entorno de Visual C++, lo único que hay que hacer es ejecutar la
opción: Build ->Execute reloj.exe Este mandato solicita al entorno que ejecute el archivo
reloj.exe usando para ello todos los recursos que sean necesarios. Si se usa entrada/salida por
consola, se abre una ventana consola. La Figura B.8 muestra la ventana Build y la opción a usar
para ejecutar el archivo reloj .exe.
     La otra opción es ejecutar el programa desde una ventana consola o de MS-DOS, que se
puede crear activando el icono de MS-DOS en el menú Inicio. Una vez en la ventana consola, se
debe cambiar el directorio a la posición del ejecutable de la aplicación y a continuación ejecutar la
aplicación tecleando su nombre.


B.2.3. Depuración de una aplicación en Visual C++

Depurar una aplicación utilizando el C++ de Microsoft, usando el entorno de Visual C++, es real
mente fácil. Hay dos opciones básicas:




Figura B.8. Ejecución de relo.exe en el Visual C++ de Microsoft




Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 647 -->

668       Sistemas Operativos. Una visión aplicada




Figura B.9. Depuración de reloj.exe en el Visual C++ de Microsoft

      •   Depurar una vez enlazada la aplicación.
      •   Enlazar y depurar al mismo tiempo.

    La primera es más aconsejable, porque en este caso se puede estar seguro de que no hay
errores de en lazado.
Para ejecutar desde el entorno de Visual C++, lo único que hay que hacer es ejecutar la opción:
Build -> Start Debug. Este mandato solicita al entorno que ejecute el archivo reloj .exe de forma
controlada por el depurador (Fig. B.9). Cuando se ejecuta esta opción, aparece una nueva ventana
que permite ejecutar el programa de forma continua (Go), ejecutar hasta donde está el cursor (Run
to cursor) o pararse en una llamada a función y saltar dentro del código fuente de la misma (Step
into). Con estas tres llamadas básicas se puede controlar la ejecución del programa.- Los errores
salen en la pantalla de debajo del código fuente, mientras que el flujo de ejecución se controla en
esta ventana.




Digitalización Realizada con propósito académico. Sistemas Operativos

