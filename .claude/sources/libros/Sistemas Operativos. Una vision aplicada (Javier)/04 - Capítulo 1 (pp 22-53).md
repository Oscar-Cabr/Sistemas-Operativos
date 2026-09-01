# Capítulo 1

> Fuente: Sistemas Operativos. Una vision aplicada (Javier) — páginas 22–53 (numeración del PDF)

<!-- pág. 22 -->

                                    Conceptos arquitectónicos
                                                                                    1
                                           de la computadora




En este capítulo se presentan los conceptos de arquitectura de computadoras más relevantes
desde el punto de vista de los sistemas operativos. El capítulo no pretende convertirse en un
tratado de arquitectura, puesto que su objetivo es el de recordar y destacar los aspectos
arquitectónicos que afectan de forma directa al sistema operativo.
Para alcanzar este objetivo, el capítulo se estructura en los siguientes grandes temas:

        * Funcionamiento básico de las computadoras y estructura de las mismas.
       * Modelo de programación, con énfasis en su secuencia de ejecución.
       * Concepto de interrupción.
       * Diversas acepciones de reloj.
       * Aspectos más relevantes de la jerarquía de memoria y, en especial, de la memoria .
.        virtual .
       * Concurrencia de la LIS con el procesador.
       * Mecanismos de protección.




Digitalización realizada con propósito académico                                           1

<!-- pág. 23 -->

2      Sistemas operativos. Una visión aplicada




1.1.     ESTRUCTURA Y FUNCIONAMIENTO DE LA COMPUTADORA

La computadora es una máquina destinada a procesar datos. En una visión esquemática, como
la que muestra la Figura 1.1, este procesamiento involucra dos flujos de información: el de
datos y el de instrucciones. Se parte del flujo de datos que han de ser procesados. Este flujo de
datos es tratado mediante un flujo de instrucciones de maquina, generado por la ejecución de
un programa, y produce el flujo de datos resultado.




Figura 1.1. Esquema de funcionamiento de la computadora.



       Para llevar a cabo la función de procesamiento, una computadora con arquitectura von
Neuman está compuesta por los cuatro componentes básicos representados en la Figura 1.2.
       La memoria principal se construye con memoria RAM y memoria ROM. En ella han de
residir los datos a procesar, el programa máquina (Aclaración 1.1) a ejecutar y los resultados.
       La memoria está formada por un conjunto de celdas idénticas. Mediante la información
de dirección se selecciona de forma única la celda sobre la que se quiere realizar el acceso,
pudiendo ser éste de lectura o de escritura. En las computadoras actuales es muy frecuente
que el direccionamiento se realice a nivel de byte, es decir, que las direcciones 0, 1, 2,...
identifiquen los bytes 0, 1, 2,... Sin embargo, el acceso se realiza sobre una palabra de varios
bytes (típi ente de 4 o de 8 bytes) cuyo primer byte se sitúa en la dirección utilizada.




Figura1.2. Componentes básicos de la computadora




Digitalización realizada con propósito académico

<!-- pág. 24 -->

                                             Conceptos arquitectónicos de la computadora          3




ACLARACIÓN 1.1

Se denomina programa máquina (o código) al conjunto de instrucciones máquina que tiene por
objeto que la computadora realice una determinada función. Los programas escritos en
cualesquiera de los lenguajes de programación han de convertirse en programas máquina para
poder ser ejecutados por la computadora



       La unidad aritmética permite realizar una serie de operaciones aritméticas y lógicas
sobre uno o dos operandos. Los datos sobre los que opera esta unidad están almacenados en
un conjunto de registros, o bien provienen directamente de memoria principal. Por su lado, los
resultados también se almacenan en registros o en memoria principal.
La unidad de control es la que se encarga de hacer funcionar al conjunto, para lo cual realiza
las siguientes funciones:

       •   Lee de memoria las instrucciones máquina que forman el programa.
       •   Interpreta cada instrucción leída.
       •   Lee los datos de memoria referenciados por cada instrucción.
       •   Ejecuta cada instrucción.
       •   Almacena el resultado de cada instrucción.

       La unidad de control tiene asociados una serie de registros, entre los que cabe destacar:
el contador de programa (PC, program counter), que indica la dirección de la siguiente
instrucción de máquina a ejecutar, el puntero de pila (SP, snack pointer), que sirve para
manejar cómodamente una pila en memoria principal, el registro de instrucción (RL), que
permite almacenar la instrucción de maquina a ejecutar, y el registro de estado (RE), que
almacena diversa información producida por la ejecución de alguna de las últimas instrucciones
del programa (bits de estado aritméticos) e información sobre la forma en que ha de
comportarse la computadora (bits de interrupción, nivel de ejecución, etc.).
       Finalmente, la unidad de entrada/salida (E/S) se encarga de hacer la transferencia de
información entre la memoria principal (o los registros) y los periféricos. La entrad salida se
puede hacer bajo el gobierno de la unidad de control (E/S programada) o de forma
independiente (DMA), como se verá en la Sección 1.7.
       Se denomina procesador, o unidad central de proceso (UCP), al conjunto de la unidad
aritmética y de control. Actualmente, el procesador suele construirse en un único circuito
integrado.
Desde el punto de vista de los sistemas operativos, nos interesa más profundizar en el funcio-
namiento interno de la computadora que en los componentes físicos que la constituyen.



1.2.       MODELO DE PROGRAMACIÓN DE LA COMPUTADORA

El modelo de programación a bajo nivel de una computadora se caracteriza por los siguientes
aspectos, que se muestran gráficamente en la Figura 1.3:

       •   Elementos de almacenamiento. En esta sección se consideran aquellos elementos
           de almacenamiento de la computadora que son visibles a las instrucciones maquina.
           En esta categoría están incluidos los registros generales, el contador de programa, el
           puntero de pila, el registro de estado, la memoria principal y el mapa de E/S (Aclaración
           1.2).




Digitalización realizada con propósito académico

<!-- pág. 25 -->

4    Sistemas operativos. Una visión aplicada




Figura 1.3. Modelo de programación de una computadora.

    •    Juego de instrucciones con sus correspondientes modos de direccionamiento. El
         juego de instrucciones máquina define las operaciones que es capaz de hacer la
         computadora. Los modos de direccionamiento determinan la forma en que se
         especifica la identidad de los elementos de almacenamiento que intervienen en las
         instrucciones máquina.
    •    Secuencia de funcionamiento, Define el modo en que se van ejecutando las
         instrucciones máquina.
    •    Un aspecto crucial de las computadoras, que está presente en todas ellas menos en
         los modelos más simples, e. que disponen de más de un nivel de ejecución, concepto
         que se analiza en la sección siguiente.


ACLARACIÓN 1.2

Es muy frecuente que las computadoras incluyan el mapa de E/S dentro del mapa de memoria.
En este caso, se reserva una parte del mapa de memoria para realizar la E/S.



1.2.1.      Niveles de ejecución

La mayoría de las computadoras actuales presentan dos o más niveles de ejecución. En el
nivel menos permisivo, generalmente llamado nivel de usuario, la computadora ejecuta
solamente un subconjunto de las instrucciones máquina, quedando prohibidas las demás.
Además, el acceso a determinados registros, o a partes de esos registros, y a determinadas
zonas del mapa de memoria y de E/S t bien queda prohibido. En el nivel más permisivo,
denominado nivel de núcleo, la computadora ejecuta todas sus instrucciones sin ninguna
restricción y permite el acceso a todos los registros y mapas de direcciones.




Digitalización realizada con propósito académico

<!-- pág. 26 -->

                                         Conceptos arquitectónicos de la computadora         5




Figura 1.4. Modelos de programación de usuario y de núcleo.

    Se puede decir que la computadora presenta mas de un modelo de programación. Uno más
restrictivo, que permite realizar un conjunto limitado de acciones, y otros más permisivos que
permiten realizar un mayor conjunto de acciones. Uno o varios bits del registro de estado
establecen el nivel en el que está ejecutando la máquina. Modificando esto. bits se cambia de
nivel de ejecución.
    Como veremos más adelante, los niveles de ejecución se incluyen en las computadoras
para dar soporte al sistema operativo. Los programas de usuario, por razones de seguridad, no
podrán realizar determinadas acciones al ejecutar en nivel de usuario. Por su lado, el sistema
operativo, que ejecuta en nivel de núcleo, puede ejecutar todo tipo de acciones.
   Típicamente, en el nivel de usuario la computadora no permite operaciones de E/S, ni modifi-
car una gran parte del registro de estado, ni modificar los registros de soporte de gestión de
memoria. La Figura 1.4 muestra un ejemplo de dos modelos de programación de una
computadora.

1.2.2.      Secuencia de funcionamiento de la computadora

La unidad de control de la computadora es la que establece el funcionamiento del mismo. Este
funcionamiento está basado en una secuencia sencilla, que se repite a alta velocidad (cientos
de millones de veces por segundo). Como muestra la Figura 1.5, esta secuencia consiste en
tres pasos:
a) lectura de memoria principal de la instrucción máquina apuntada por el contador de
programa, b) incremento del contador de programa —para que apunte a la siguiente instrucción
máquina— y c) ejecución de la instrucción.
      Esta secuencia tiene dos propiedades fundamentales: es lineal, es decir, ejecuta de forma
consecutiva las instrucciones que están en direcciones consecutivas, y forma un bucle infinito,
Esto significa que la unidad de control de la computadora está continua e ininterrumpidamente
realizando esta secuencia (Advertencia 1.1).




Digitalización realizada con propósito académico

<!-- pág. 27 -->

6    Sistemas operativos. Una visión aplicada




Figura 1.5. Secuencia de ejecución de la computadora.



ADVERTENCIA 1.1

Algunas computadoras tienen una instrucción «HALT» que hace que la unidad de control se
detenga hasta que llega una interrupción. Sin embargo, esta instrucción es muy poco utilizada,
por lo que a efectos prácticos podemos considerar que la unidad de control no para nunca de
realizar la secuencia de lectura de instrucción, incremento de PC y ejecución de la instrucción.


         Podemos decir, por tanto, que lo único que sabe hacer la computadora es repetir a
gran veloci- dad esta secuencia. Esto quiere decir que, para que realice algo útil, se ha de tener
adecuadamente cargados en memoria un programa máquina con sus datos y hemos de
conseguir que el contador de programa apunte a la instrucción máquina inicial del programa.
El esquema de ejecución lineal es muy limitado, por lo que se añaden unos mecanismos que
permiten alterar esta ejecución lineal. En esencia todos ellos se basan en algo muy simple:
modifi- can el contenido del contador de programa, con lo que se consigue que se salte o
bifurque a otro segmento del programa o a otro programa (que, lógicamente, también ha de
residir en memoria).

         Los tres mecanismos básicos de ruptura de secuencia son los siguientes:
    •    Las instrucciones máquina de salto o bifurcación, que permiten que el programa rompa
         su secuencia lineal de ejecución pasando a otro segmento de si mismo.
    •    Las interrupciones externas o internas, que hacen que la unidad de control modifique
         valor el del contador de programa saltando a otro programa.
    •    La instrucción de máquina «TRAP», que produce un efecto similar a la interrupción,
         haciendo que se salte a otro programa.

            Si desde el punto de vista de la programación son especialmente interesantes las
instrucciones de salto, desde el punto de vista de los sistemas operativos son mucho más
importantes las interrupciones y las instrucciones de TRAP. Por tanto, centraremos nuestro
interés en resaltar los aspectos fundamentales de estos dos mecanismos.


1.2.3.       Registros de control y estado

Como se ha indicado anteriormente, la unidad de control tiene asociada una serie de registros
denominamos de control y estado. Estos registros dependen de la arquitectura de la
computadora muchos de ellos se refieren a aspectos que se analizarán a lo largo del texto, por
lo que no se intentará explicar aquí su función. Entre los más importantes se pueden encontrar
los siguientes:

         •   Contador de programa PC. Contiene la dirección de la siguiente instrucción de
             máquina.
         •   Puntero de pila SP. Contiene la dirección de la cabecera de la pila.



Digitalización realizada con propósito académico

<!-- pág. 28 -->

                                            Conceptos arquitectónicos de la computadora            7




        •     Registro de instrucción RI. Contiene la instrucción en curso de ejecución.
        •     Registro de estado, que contiene, entre otros, los bits siguientes:

              −   Bits de estado aritméticos:

            Signo. Contiene el signo de la ultima operación aritmética realizada.
            Acarreo. Contiene el acarreo de la ultima suma o resta realizada,
            Cero. Se activa si el resultado de la ultima operación aritmética o lógica fue cero.
            Desbordamiento. Indica si la última operación aritmética produjo desbordamiento.

              −   Bits de nivel de ejecución. Indican el nivel en el que ejecuta el procesador.
              −   Bits de control de interrupciones. Establecen las interrupciones que se pueden
                  aceptar.

        • Registro identificador de espacio de direccionamiento RIED (Sección 1.8.2). Identifica
           el espacio del mapa de memoria que puede utilizar el programa en ejecución.
        • Otros registros de gestión de memoria, como pueden ser los registros de protección
           de memoria (Sección 1.8.2).

          Algunos de estos registros son visibles en el nivel de ejecución de usuario, como el
PC, el SP y parte del estado, pero otros no lo son, como el registro identificador de espacio de
direccionamiento.


1.3. INTERRUPCIONES

A nivel físico, una interrupción se solicita activando una señal que llega a la unidad de control.
El agente generador o solicitante de la interrupción ha de activar la mencionada señal cuando
necesite que se le atienda, es decir, que se ejecute un programa que le atienda.
Ante la solicitud de una interrupción, siempre y cuando esté habilitado ese tipo de interrupción,
la unidad de control realiza un ciclo de aceptación de interrupción. Este ciclo se lleva a cabo
en cuanto termina la ejecución de la instrucción maquina que se esté ejecutando y consiste en
las siguiente. operaciones:

        • Salva algunos registros del procesador, como son el de estado y el contador de
            programa.
        • Eleva el nivel de ejecución del procesador, pasándolo a núcleo.
        • Carga un nuevo valor en el contador de programa, por lo que pasa a ejecutar otro
            programa.

          La Figura 1.6 muestra la solución más usualmente utilizada para determinar la
dirección de salto. Se puede observar que el agente que interrumpe ha de suministrar un
vector, que especifica la dirección de comienzo del programa que desea que le atienda
(programa que se suele denominar de tratamiento de interrupción). La unidad de control,
utilizando un direccionamiento indirecto, toma la mencionada dirección de una tabla de
interrupciones y la carga en el contador de programa. El resultado de esta carga es que la
siguiente instrucción maquina ejecutada es la primera del mencionado programa de tratamiento
de interrupción.
           Obsérvese que tanto la tabla de interrupciones como la rutina de tratamiento de la
interrupción se han considerado parte del sistema operativo. Esto suele ser así por razones de
seguridad; en concreto, para evitar que los programas que ejecuta un usuario puedan
perjudicar a los datos o programas de otros usuarios. Como se verá en el Capítulo 2, la
seguridad es una de las funciones primordiales del sistema operativo.




Digitalización realizada con propósito académico

<!-- pág. 29 -->

8   Sistemas operativos. Una visión aplicada




Figura 1.6. Acceso a la rutina de tratamiento de la interrupción


        Las interrupciones se pueden generar por diversas causas, que se pueden clasificar de la
siguiente forma:

        •   Excepciones de programa. Hay determinadas causas que hacen que un programa
            presente un problema en su ejecución, por lo que deberá generarse una
            interrupción, de forma que el sistema operativo trate dicha causa. Ejemplos son el
            desbordamiento en las operaciones aritméticas, la división por cero, el intento de
            ejecutar una instrucción con código operación incorrecto o de direccionar una
            posición de memoria prohibida (Advertencia 1.2).
        •   Interrupciones de reloj, que se analizarán en la sección siguiente.
        •   Interrupciones de E/S. Los controladores de los dispositivos de E/S necesitan
            interrumpir para indicar que han terminado una operación o conjunto de ellas.
        •   Excepciones del hardware. La detección de un error de paridad en la memoria o un
            corriente se avisan mediante la correspondiente interrupción.
        •   Instrucciones de TRAP. Estas instrucciones permiten que un programa genere una
            interrupción. Como veremos más adelante, estas instrucciones se emplean
            fundamentalmente solicitar los servicios del sistema operativo.


ADVERTENCIA 1.2

En este caso no existe un agente externo que suministre el vector necesario para entrar en la
tabla de interrupciones. Será la propia unidad de control del procesador la que genere este
vector.


         Como complemento al mecanismo de aceptación de interrupción, las computadoras
incluyen una instrucción máquina para retorno de interrupción, llamada RETI. El efecto de esta
instrucción es restituir los registros de estado y PC, desde el lugar en que fueron salvados al
aceptarse interrupción (p. ej.: desde la pila).
         Las computadoras incluyen varias señales de solicitud de interrupción, cada una de las
les tiene una determinada prioridad. En caso de activarse al tiempo varias de estas seña tratará la
de mayor prioridad, quedando las demás a la espera de ser atendidas, Además, la computadora
incluye un mecanismo de inhibición selectiva que permite detener todas o determinas señales
de interrupción. Las señales inhibidas no son atendidas hasta que pasen a estar desinhibidas. La
información de inhibición de las interrupciones suele incluirse en la parte del registro estado que
solamente es modificable en nivel de núcleo, por lo que su modificación queda restringida al
sistema operativo.




Digitalización realizada con propósito académico

<!-- pág. 30 -->

                                          Conceptos arquitectónicos de la computadora           9




1.4.        EL RELOJ

El término reloj se aplica a las computadoras con tres acepciones diferentes, si bien
relacionadas, como se muestra en la Figura 1.7. Estas tres acepciones son las siguientes:

        •   Señal que gobierna el ritmo de ejecución de las instrucciones máquina.
        •   Generador de interrupciones periódicas.
        •   Contador de fecha y hora,

              El oscilador que gobierna las fases de ejecución de las instrucciones máquina se
denomina reloj. Cuando se dice que un microprocesador es de 600 MHz, lo que se está
especificando es que el oscilador que gobierna el ritmo de su funcionamiento interno produce
una onda cuadrada con una frecuencia de 600 MHz.
              La señal producida por el oscilador anterior, o por otro oscilador, se divide
mediante un divisor de frecuencia para generar una interrupción cada cierto intervalo de tiempo.
Estas interrupciones, que se están produciendo constantemente, se denominan interrupciones
de reloj o ticks, dando lugar al segundo concepto de reloj. El objetivo de estas interrupciones
es, como veremos más adelante, hacer que el sistema operativo entre a ejecutar de forma
sistemática cada cierto intervalo de tiempo. De esta manera, el sistema operativo puede evitar
que un programa monopolice el uso de la computadora y puede hacer que entren a ejecutarse
programas en determinados instantes de tiempo. Estas interrupciones se producen cada varios
milisegundos, por ejemplo cada 20 milisegundos.
              La tercera acepción de reloj se aplica a un contador que permite conocer la fecha y
la hora. Este contador se va incrementando con cada interrupción de reloj de forma que,
tomando como referencia un determinado instante (p. ej: O horas del 1 de enero de 1990
(Advertencia 1.3)], se puede calcular la hora y fecha en que estamos. Observe que este concepto
de reloj es similar al del reloj electrónico de pulsera. En las computadoras actuales esta cuenta
se hace mediante un circuito dedicado que, además, está permanentemente alimentado, de forma
que, aunque se apague la computadora, se siga manteniendo el reloj. En sistemas más antiguos,
el sistema operativo se encargaba de hacer esta cuenta, por lo que había que introducir la fecha y
la hora al arrancar la computadora.


ADVERTENCIA 1.3

En el caso de UNIX se cuentan segundos y se toma como referencia las 0 horas del 1 de enero
de 1970. si se utiliza una palabra de 32 bits, el mayor número que se puede almacenar es el
2.147.483.647, que se corresponde a las 3h 14m y 7s de enero de 2038. esto significa que, a
partir de ese instante, el contador tomará el valor de 0 y la fecha volverá a ser el 1 de enero de
1970.




Figura 1.7. Reloj de la computadora.




Digitalización realizada con propósito académico

<!-- pág. 31 -->

10     Sistemas operativos. Una visión aplicada


1.5.    JERARQUÍA DE MEMORIA

Dado que la memoria de alta velocidad tiene un precio elevado y un tamaño reducido, la
memoria de la computadora se organiza en forma de una jerarquía como la mostrada en la
Figura 1.8. En esta jerarquía se utilizan memorias permanentes de alta capacidad y baja
velocidad, como son los cos, para almacenamiento permanente de la información. Mientras
que se emplean memorias semiconductores de un tamaño relativamente reducido, pero de alta
velocidad, para almacenar la información que se está utilizando en un momento determinado.




Figura 1.8. Jerarquía de memoria.

        El funcionamiento de la jerarquía de memoria exige hacer adecuadas copias de
información de los niveles más lentos a los niveles más rápidos, en los cuales son utilizadas (p.
ej.: cuando se ejecutar un programa hay que leer el fichero ejecutable y almacenarlo en
memoria principal). Inversamente, cuando se modifica o crea la información en un nivel rápido,
y se desea su permanencia, hay que enviarla al nivel de disco o cinta.
        Para entender bien el objetivo y funcionamiento de la jerarquía de memoria, es muy
importante tener presente siempre tanto el orden de magnitud de los tiempos de acceso de
cada tecnología de memoria como los tamaños típicos empleados en cada nivel de la jerarquía.
La Tabla 1.1 presenta algunos valor típicos.
        La gestión de la jerarquía de memoria, puesto que a de tener en cuenta las copias de
información que están en cada nivel y a de realizar las trasferencias de información a niveles
mas rápidos, así como las actualizaciones hacia los niveles permanentes. Una parte muy
importante de esta gestión corre a cargo del sistema operativo, aunque, para hacerla
correctamente, requiere de la ayuda de hardware. Por ello, se revisan en esta sección los
conceptos mas importantes de la




Digitalización realizada con propósito académico

<!-- pág. 32 -->

                                        Conceptos arquitectónicos de la computadora          11




jerarquía de memoria, para analizar más adelante su aplicación a la memoria virtual, de
especial interés para nosotros dado que su gestión la realiza el sistema operativo.



1.5.1.       Migración de la información

La explotación correcta de la jerarquía de memoria exige tener, en cada momento, la
información adecuada en el nivel adecuado. Para ello, la información ha de moverse de nivel,
esto es, ha de migrar de un nivel a otro. Esta migración puede ser bajo demanda explícita o
puede ser automática. La primera alternativa exige que el programa solicite explícitamente el
movimiento de la información, como ocurre, por ejemplo, con un pro rama editor, que va
solicitando la parte del archivo que está editando en cada momento el usuario. La segunda
alternativa consiste en hacer la migración transparente al programa, es decir, sin que este
tenga que ser consciente de que se produce. La migración automática se utiliza en las
memorias cache y en la memoria virtual, mientras que la migración bajo demanda se utiliza en
los otros niveles.
       Sean k y k + 1 dos niveles consecutivos de la jerarquía, siendo k el nivel mas rápido. La
existencia de una migración automática de información permite que el programa referencia la
información en el nivel k y que, en el caso de que no exista una copia adecuada de esa
información en dicho nivel k, se traiga esta desde el nivel k + 1 sin que el programa tenga que
hacer nada para ello.
       El funcionamiento correcto de la migración automática exige un mecanismo que consiga
tener en el nivel k aquella información que necesita el programa en ejecución en cada instante.
Idealmente, el mecanismo debería predecir la información que éste necesite para tenerla
disponible en el nivel rápido k. El mecanismo se basa en los siguientes aspectos:

         •   Tamaño de los bloques transferidos.
         •   Política de extracción.
         •   Política de reemplazo.
         •   Política de ubicación.

             Por razones de direccionamiento (Sección 1.5.4), y para aprovechar la proximidad
espacial (Sección 1.5.5), la migración automática se hace en porciones de información de un t
año determinado. En concreto, para la memoria cache se transfieren líneas de unas pocas
palabras, mientras que p a la memoria virtual se transfieren paginas de uno o varios KB. El
tamaño de estas porciones e una característica muy importante de la jerarquía de memoria.
      La política de extracción define qué información se sube del nivel k + 1 al k y cuándo se
sube. La solución más corriente es la denominada por demanda y consiste en subir aquella
información que referencia el programa, justo cu do la referencia. El éxito de esta política se
basa en la proximidad espacial (Sección 1.5.5), por lo que no se sube exclusivamente la
información referenciada sino una porción mayor (línea o página).
      El nivel k tiene menor capacidad de almacenamiento que el nivel k + 1, por lo que
normalmente está lleno. Por ello, cuando se sube una porción de información hay que eliminar
otra. La política de reemplazo determina qué porción hay que eliminar, atando de seleccionar
una que ya no sea de interés para el programa en ejecución.
      Por razones constructivas pueden existir limitaciones en cuanto al lugar en el que se
pueden almacenar las diversas porciones de información; la política de ubicación determina
dónde almacenar cada porción.




Digitalización realizada con propósito académico

<!-- pág. 33 -->

12       Sistemas operativos. Una visión aplicada




1.5.2.        Parámetros característicos de la jerarquía de memoria

La eficiencia de la jerarquía de memoria se mide mediante los dos parámetros siguientes:

          •   Tasa de aciertos o hit ratio (Hr).
          •   Tiempo medio de acceso efectivo (Tef).

            La tasa dé aciertos (Hrk) del nivel k de la jerarquía se define como la probabilidad
de encontrar en ese nivel la información referenciada. La tasa de fallos Frk es 1 - Hrk. La tasa
de aciertos ha de ser alta para que sea rentable el uso del nivel k de la jerarquía. Los factores
más importantes que determinan Hrk son los siguientes:

          •   Tamaño de la porción de información que se transfiere al nivel k.
          •   Capacidad de almacenamiento del nivel k.
          •   Política de reemplazo.
          •   Política de ubicación.
          •   Programa específico que se esté ejecutando (cada programa tiene un
              comportamiento propio).

            El tiempo de acceso a una información depende de que se produzca o no un fallo
en el nivel k. Denominaremos tiempo de acierto al tiempo de acceso cuando la información se
encuentra en nivel k. mientras que denominaremos penalización de fallo al tiempo que se tarda
en realizar migración de la porción cuando se produce fallo. El tiempo medio de acceso
efectivo (Tef) de un programa se obtiene promediando los tiempos de todos los accesos que
realiza el programa a largo de su ejecución. Tef depende básicamente de los factores
siguientes:

          •   Tiempo de acierto.
          •   Penalización de fallo.
          •   Tasa de aciertos (Hrk) del nivel k.


1.5.3.        Coherencia

Un efecto colateral de la jerarquía de memoria es que existen varias copias de determinadas
porcio- nes de información en distintos niveles. Al escribir sobre la copia del nivel k, se produce
una discrepancia con la copia del nivel k + 1; esta situación se denomina falta de coherencia.
Se dice que una porción de información está sucia si ha sido escrita.
            La coherencia de la jerarquía de memoria exige medidas para eliminar la falta de
coherencia. En concreto, una porción sucia en el nivel k ha de ser escrita en algún momento al
nivel k + 1 para eliminar la falta de coherencia. Con esta operación de escritura se limpia la
porción del nivel k.
             Existen diversas políticas de actualización de la información creada o modificada,
que se caracterizan por el instante en el que se copia la información al nivel permanente.

1.5.4.        Direccionamiento

La jerarquía de memoria presenta un problema de direccionamiento. Supóngase que el
programa en ejecución genera la dirección X del dato A al que quiere acceder. Esta dirección X
está referida al nivel k + 1, pero se desea acceder al dato A en el nivel k, que es más rápido.
Para ello se necesitara conocer la dirección Y que ocupa A en el nivel k, por lo que será
necesario establecer un mecanismo de traducción de direcciones X en sus correspondientes Y.
La Figura 1.9 presenta este problema de direccionamiento.




Digitalización realizada con propósito académico

<!-- pág. 34 -->

                                          Conceptos arquitectónicos de la computadora       13




Figura 1.9. Traducción de direcciones.

      El problema de traducción no es trivial, supóngase que el espacio de nivel k + 1 es de 2
GB, lo que equivale a suponer que n = 31, y que el espacio de nivel k es de 8 MB, lo que
supone que m = 23. El traductor tiene aproximadamente dos mil millones de valores de entrada
distintos y ocho millones de direcciones finales.
      Para simplificar la traducción, y aprovechar la proximidad espacial, se dividen los mapas
de direcciones de los espacios k + 1 y k en porciones de tamaño Y. Estas porciones
constituyen la unidad de información mínima que se transfiere de un nivel al otro. El que la
porción tenga tamaño 2p permite dividir la dirección en dos partes: los m —~ p bits mas
significativos sirven para identificar la porción, mientras que los p bits menos significativos
sirven para especificar el byte dentro de la porción (Fig. 1.10). Por su parte, la Figura 1.11
muestra el caso de la memoria virtual que se divide en páginas.
      Suponiendo, para el ejemplo anterior, que las páginas son de 1 KB (p = 10), el problema
de direccionamiento queda dividido por 1.024, pero si e siendo inviable plantear la traducción
mediante una tabla directa completa, pues sería una tabla de unos dos millones de entradas y
con sólo 8.192 salidas no nulas.

1.5.5. La proximidad referencial

La proximidad referencial es la característica que hace viable la jerarquía de memoria, de ahí
su importancia. En términos globales, la proximidad referencial establece que un programa en
ejecución utiliza en cada momento una pequeña p te de toda la información que usa.
     Para exponer el concepto de proximidad referencial de forma más específica, partimos del
concepto de traza. La traza de un programa en ejecución es la lista ordenada en el tiempo de
las direcciones de memoria que referencia para llevar a cabo su ejecución. Esta traza R estará
compuesta por las direcciones de las instrucciones que se van ejecutando y por las direcciones
de los datos empleados, es decir:

                                  Re = re(l), re(2), re(3), ... re(j)

donde re(i) es la i-ésima dirección generada por la ejecución del programa e.




Figura 1.10. El uso de porciones de 2” facilita la traducción.




Digitalización realizada con propósito académico

<!-- pág. 35 -->

14    Sistemas operativos. Una visión aplicada




Figura 1.11. División en páginas de los espacios de memoria.

     Adicionalmente, se define el concepto de distancia d(u, y) entre dos direcciones u y y como
diferencia en valor absoluto | u — v|. La distancia entre dos elementos j y k de una traza re es,
por tanto, d(re(j), re(k)) = |re(j) — re(k)|.
      También se puede hablar de traza de E/S, refiriéndonos, en este caso, a la secuencia de
la direcciones empleadas en operaciones de E/S.
      La proximidad referencial presenta dos facetas: la proximidad espacial y la proximidad
temporal.
      La proximidad espacial de una traza postula que, dadas dos referencias re(j) y re(i)
próximas en el tiempo (es decir, que i — j sea pequeño), existe una alta probabilidad de que su
distancia d(re(j), re(i)) sea muy pequeña. Además, como muchos trozos de programa y muchas
es estructuras datos se recorren secuencialmenté, existe una gran probabilidad de que la
referencia siguiente re(j) coincida con la dirección de memoria siguiente (Recordatorio 1.1).
Este tipo especial de proximidad espacial recibe el nombre de proximidad secuencial.



RECORDATORIO 1.1

Aquí conviene incluir una aclaración. Dado que las memorias principales se direccional a nivel
de byte pero se acceden a nivel de palabra, la dirección siguiente no es la dirección actual mas
1. Para palabras de 4 bytes la dirección siguiente es la actual mas 4.


      La proximidad espacial se explica si se tienen en cuenta los siguientes argumentos:



        •   Los programas son fundamentalmente secuénciales, a excepción de las
            bifurcaciones, por que su lectura genera referencias consecutivas.
        •   Adicionalmente, la gran mayoría de los bucles son muy pequeños, de unas pocas
            instrucciones máquina, por lo que su ejecución genera referencias con distancias
            pequeñas.




Digitalización realizada con propósito académico

<!-- pág. 36 -->

                                          Conceptos arquitectónicos de la computadora            15




Figura 1.12.   Proximidad referencial.

        •   Las estructuras de datos que se recorren de forma secuencial o con referencias
            muy próximas son muy frecuentes. Ejemplos son los vectores, las listas, las pilas,
            las matrices, etc. Además, las zonas de dato suelen estar agrupadas, de manera
            que las referencias que se generan suelen estar próximas.

         La proximidad temporal postula que un programa en ejecución tiende a referenciar
direcciones empleadas en un pasado próximo. Esto es, existe una probabilidad muy alta de
que la próxima referencia re( j + 1) este entre las n referencias anteriores re( j — n + 1), re(j —
n + 2),............, re(j -2), re( j — 1), re (j). La proximidad temporal se explica si se tienen en
cuenta los siguientes argumentos:

        •   Los bucles producen proximidad temporal, además de proximidad espacial.
        •   El uso de datos o parámetros de forma repetitiva produce proximidad temporal.
        •   Las llamadas repetidas a subrutinas también son muy frecuentes y producen
            proximidad temporal. Esto es muy          tipico con las funciones o subrutinas
            aritméticas, de conversión de códigos, etc.

         En la práctica, esto significa que las referencias producidas por la ejecución de un
programa están agrupadas en unas pocas zonas, tal y como muestra la Figura 1,12. Puede
observarse también que, a medida que avanza la ejecución del programa, van cambiando las
zonas referenciadas.
El objetivo principal de la gestión de la jerarquía de memoria será conseguir que residan en las
memorias más rápidas aquellas zonas de los programas que están siendo referenciadas en
cada instante.

1.6. MEMORIA VIRTUAL

En un sistema sin memoria virtual, el sistema operativo divide la memoria principal en trozos y
asigna uno a cada uno de los programas que están ejecutando en un instante determinado. La
Figura 1.13 muestra el reparto típico de la memoria para el caso de un solo programa o de
varios programas. Observe que el espacio asignado a un programa consiste en una zona de
memoria principal




Digitalización realizada con propósito académico

<!-- pág. 37 -->

          16    Sistemas operativos. Una visión aplicada




          Figura 1.13. Asignación de memoria en un sistema sin memoria virtual.


          contigua, es decir, no se asignan varios trozos disjuntos de memoria a un mismo programa. Por
          el contrario, como se verá más adelante, en los sistemas con memoria virtual no es necesario
          que los
           espacios de memoria asignados a los programas sean contiguos.



1.6.1.    Concepto de memoria virtual

          La memoria virtual utiliza dos niveles de la jerarquía de memoria: la memoria principal y una
          memoria de respaldo (que suele ser el disco, aunque puede ser una memoria expandida).
          Sobre memoria de respaldo se establece un mapa uniforme de memoria virtual. Las
          direcciones generadas por el procesador se refieren a este mapa virtual, pero, sin embargo, los
          accesos reales se realiza sobre la memoria principal.
               Para su funcionamiento, la memoria virtual exige una gestión automática de la parte de la
          jerarquía de memoria formada por los niveles de memoria principal y de disco.
               Insistimos en que la gestión de la memoria virtual es automática y la realiza el sistema
          operativo con ayuda del hardware de la máquina. Como muestra la Figura 1.14, esta gestión
          incluye toda la memoria principal y una parte del disco, que sirve de respaldo a la memoria
          virtual.
               Los aspectos principales en los que se basa la memoria virtual son los siguientes:

         • Las direcciones generadas por las instrucciones máquina, tanto para referirse a datos como a
           otras instrucciones, están referidas al espacio virtual, es decir, forman parte del mapa de
           memoria virtual. En este sentido se suele decir que el procesador genera direcciones virtuales




          Figura 1.14. Fundamento de la memoria virtual.




          Digitalización realizada con propósito académico

<!-- pág. 38 -->

                                        Conceptos arquitectónicos de la computadora           17



        •   El mapa virtual asociado a un programa en ejecución esta soportado físicamente
            por una zona del disco, denominada de intercambio o swap, y por una zona de la
            memoria principal. Tenga en cuenta que toda la información del programa ha de
            residir obligatoriamente en algún soporte físico, ya sea disco o memoria principal
            (también puede estar duplicada en ambos).
        •   Aunque el programa genera direcciones virtuales, para que éste pueda ejecutarse,
            han de residir en memoria principal las instrucciones y los datos utilizados en cada
            momento. Si, por ejemplo, un dato referenciado por una instrucción máquina no
            reside en la memoria principal es necesario realizar un trasvase de información
            (migración de información) entre el disco y la memoria principal antes de que el
            programa pueda seguir ejecutando.
        •   Los espacios virtual y físico se dividen en páginas, como se mostró en la Figura
            1.11. Se denominan páginas virtuales a las páginas del espacio virtual, paginas
            de intercambio a las páginas residentes en el disco y marcos de página a los
            espacios en los que se divide la memoria principal.
        •   Cada marco de página es capaz de albergar una página virtual cualquiera, sin
            ninguna restricción de direccionamiento.
        •   Existe una unidad hardware, denominada MMU (Memo Management Unit), que
            traduce las direcciones virtuales a direcciones de memoria principal. Aplicando lo
            visto anteriormente, se puede decir que esta traducción se restringe a traducir el
            número de página virtual en el correspondiente número de marco de página.
            Insistimos en que esta traducción hay que hacerla por hardware dada la alta
            velocidad a la que debe hacerse (una fracción del tiempo de acceso de la memoria
            principal).
        •   Dado que en cada instante determinado solamente reside en memoria principal
            una fracción de las páginas del programa, la traducción no siempre es posible. Por
            tanto, la MMU producirá una excepción de fallo de página cuando ésta no esté
            en memoria principal.

               Los fallos de página son atendidos por el sistema operativo (Prestaciones 1.1)
que se encarga de realizar la adecuada migración de páginas, para traer la página requerida
por el programa a un marco de página. Se denomina paginación al proceso de migración
necesario para atender los fallos de pagina.




           Finalmente, conviene resaltar que el tamaño del espacio virtual suele ser muy
grande. En la actualidad se emplean direcciones de 32, 48 o hasta 64 bits, lo que significa
espacios virtuales de 232, 248 y 264 bytes. Dado que los programas requieren en general
mucho menos espacio, una de las funciones que realiza el sistema operativo es la asignación
de espacio virtual a los programas para su ejecución. El programa no podrá utilizar todo el
espacio virtual sino que ha de restringirse a la zona o zonas que le asigne el sistema operativo.
La Figura 1.15 muestra que el espacio virtual reservado al programa A puede estar en una
única zona o puede estar dividido en varias zonas, que se denominan segmentos.
.




Digitalización realizada con propósito académico

<!-- pág. 39 -->

18    Sistemas operativos. Una visión aplicada




Figura 1.15. Asignación de memoria en un sistema con memoria virtual.


      Una de las características importantes de los lenguajes de programación actuales es que
permiten la asignación dinámica de memoria. Esto significa que no se conoce a priori la
cantidad de memoria que necesitará el programa para su ejecución. Por tanto, el sistema
operativo ha de ser capa de aumentar o reducir el espacio asignado a un programa de acuerdo
a las necesidades que vayan surgiendo en su ejecución.


1.6.2. La tabla de paginas

La tabla de páginas es una estructura de información que contiene la información de dónde
residen las páginas de un programa en ejecución. Esta tabla permite, por tanto, saber si una
página esta en memoria principal y, en su caso, en que marco específico reside.
     Según se ha visto anteriormente, dado que el tamaño del espacio virtual suele ser muy
grande, el tamaño de la correspondiente tabla de páginas puede ser muy grande (de millones
de elementos). Sin embargo, como hemos visto, el sistema operativo se encarga de asignar a
cada programa en ejecución un espacio virtual de tamaño ajustado a su: necesidades. De esta
forma, la tabla de páginas queda reducida al valor necesario para que ejecute el programa.
     La Figura 1.16 muestra la solución más sencilla de tabla de páginas de un nivel. En este
caso se supone que toda la memoria asignada al programa es contigua. El número de la
página virtual se utiliza como índice para entrar en la tabla. Cada elemento de la tabla tiene un
bit para indicar si la página está en memoria principal y el número de marco en el que se
encuentra la mencionada página o un valor nulo.




Figura 1.16. Tabla de páginas de un nivel y espacio virtual asignado




Digitalización realizada con propósito académico

<!-- pág. 40 -->

                                        Conceptos arquitectónicos de la computadora           19




Figura 1.17.Ejemplo de traducción mediante tabla de páginas de un nivel

            La Figura 1.17 muestra un ejemplo de traducción para el caso de tabla de paginas
de un nivel. Se supone que las página son de 2 KB, por lo que los 11 bits inferiores de la
dirección virtual sirven para especificar el byte dentro de la pagina, mientras que el resto
especifican la página virtual, que en este caso es la 5. Entrando en la posición N0 5 de la tabla
observamos que la página está en memoria principal y que esta en el marco numero 6.738.
Concatenando el número de marco con los 11 bits inferiores de la dirección virtual se obtiene la
dirección de memoria principal donde reside la información buscada.
El mayor inconveniente de la tabla de un nivel es su falta de flexibilidad. Toda la memoria
virtual asignada ha de ser contigua (Advertencia 1.4) y la ampliación de memoria asignada
solamente puede hacerse final de la existente.




           Sin embargo, los programas están compuestos por varios elementos, como son el
propio programa objeto, la pila y los bloques de datos. Además, tanto la pila como los bloques
de datos han de poder crecer. Por ello, un esquema de tabla de un nivel obliga a dejar grandes
huecos de memoria virtual sin utilizar , pero que están presentes en la tabla con el consiguiente
desperdicio de espacio.
           Por ello se emplean esquemas de tablas de páginas de más de un nivel. La Figura
1.18 muestra el caso de tabla de páginas de dos niveles. Con este tipo de tabla, la memoria
asignada esta compuesta por una serie de bloques de memoria virtual, es decir, por unos
segmentos. Cada segmento está formado por una serie contigua de byte. que puede variar su
tamaño, siempre y cuando no choque con otro segmento. La dirección se divide en tres pres.
La primera identifica el segmento de memoria donde esta la información que se desea acceder.
Con este valor se entra en una subtabla de segmentos, que contiene un puntero por segmento,
puntero que indica el comienzo de la subtabla de paginas del segmento. Con la segunda parte
de la dirección se entra en la subtabla de páginas seleccionada. Esta subtabla es similar a la
tabla mostrada en la Figura 1.18, lo que permite obtener el marco en el que está la información
deseada.




Digitalización realizada con propósito académico

<!-- pág. 41 -->

20    Sistemas operativos. Una visión aplicada




Figura 1.18. Tabla de páginas de dos niveles.

Obsérvese que se ha añadido a cada subtabla su tamaño. De esta forma se detectan las llama-
das violaciones de memoria, producidas cuando el programa en ejecución intenta acceder
una dirección que no pertenezca a los espacios asignados por el sistema operativo.
La ventaja del diseño con varios niveles es que permite una asignación de memoria más
flexible que con un solo nivel, puesto que se pueden asignar bloques de memoria virtual
disjuntos, por lo que pueden crecer de forma a independiente. Además, la tabla de páginas no
tiene espacios vacíos, por lo que ocupa solamente el espacio imprescindible.
Las computadoras actuales suelen proporcionar tablas de varios niveles, algunos llegan asta
cuatro, con lo que se consigue una mayor flexibilidad en la asignación de espacio de memoria.
La Figura 1.19 muestra un ejemplo de traducción mediante tabla de páginas de dos niveles. El
segmento direccionado es el 5, por lo que hay que leer la entrada 5 de la tabla de segmentos.
Con ello se obtiene la dirección donde comienza la tabla de páginas de este segmento. La
página direccionada es la 3, por lo que entramos en el elemento 3 de la tabla anterior. En esta
tabla encontramos que el marco es el Hex4A24 (Advertencia 1.5), por lo que se puede formar
la dirección física en la que se encuentra la información buscada.




Digitalización realizada con propósito académico

<!-- pág. 42 -->

                                        Conceptos arquitectónicos de la computadora          21




Figura 1.19, Tabla de páginas de dos niveles.
Por el contrario, las direcciones de la Figura 1.20 son incorrectas, puesto que el segmento 5
(101) no tiene la página 7 (111) y no existe el segmento 21(10101).


Traducción de direcciones

La asignación de memoria y, por tanto, la construcción de la tabla de páginas es misión del
sistema operativo. Sin embargo, es la MMU la que se encarga de realizar la traducción de las
direcciones. Esta división de trabajo es necesaria puesto que la traducción de direcciones hay
que hacerla de forma muy rápida para que no afecte negativamente al tiempo de acceso a la
memoria.
            Para que una computadora con memoria virtual pueda competir con una sin
memoria virtual, la traducción ha de tardar una fracción del tiempo de acceso a memoria. En
caso contrario, sería mucho más rápido y por ende mas económico el sistema sin memoria
virtual. Suponiendo una memoria principal de 100 ns y un traductor de 5 ns, el tiempo de
acceso para el caso de memoria virtual es de 105 ns, es decir, un 5 por 100 más lento que en
el caso de no tener memoria virtual. Sin embargo, si la traducción tardase 100 ns, la
computadora con memoria virtual sería la mitad de rápida, algo que la haría imposible de
competir.
            La tabla de páginas es una estructura que mantiene el sistema operativo y que
reside en memoria principal (a veces, hay una parte en la propia MMU y otra en memoria
principal). Observe que esto parece un contrasentido, puesto que para acceder a memoria hay
que traducir la dirección virtual, lo que supone realizar un acceso a memoria por cada nivel que
tenga la tabla de páginas. Según se ha visto, esto suponía un retardo inadmisible en los
accesos a memoria. Para resolver este problema se dota a la MMU de una memoria muy
rápida que permite hacer la traducción para la mayoría de los casos en una fracción del tiempo
que se tarda en acceder a la memoria principal (Prestaciones 1.2).




Figura 1.20. Ejemplo de direcciones incorrectas.



Digitalización realizada con propósito académico

<!-- pág. 43 -->

22   Sistemas operativos. Una visión aplicada




     Finalmente, hay que destacar que la encargada de mantener la información de que página
están sucias es la MMU. En efecto, al mismo tiempo que hace la traducción, en caso de que
acceso sea de escritura marca a esa pagina como sucia (Advertencia 1.6).




1.6.3. Caso de varios programas activos

Como se verá en el Capítulo 2, los sistemas operativos permiten que existan varios programa
activos al tiempo. De estos programas solamente puede haber uno en ejecución en cada
instante, encargándose el sistema operativo de ir poniendo en ejecución uno detrás de otro de
forma ordenada. Sin embargo, cada uno de los programas ha de tener asignado un espacio de
memoria, por lo que ha de tener su propia tabla de páginas.
     La MMU ha de utilizar la tabla de paginas correspondiente al programa que está en
ejecución. Para ello, como muestra la Figura 1.21, el procesador tiene un registro
identificador de espacio de direccionamiento (RIED). Este registro contiene la dirección en
la cual está almacenada la tabla de índices o segmentos del programa. Cuando el sistema
operativo pone en ejecución un programa ha de actualizar el valor del RIED para que apunte a
la tabla de páginas adecuada.


1.6.4. Asignación de memoria principal y memoria virtual

En un sistema con memoria virtual, un programa en ejecución tiene asignado un espacio
virtual, parte del cual reside en unos marcos de pagina de la memoria principal.
     El objetivo de la políticas de extracción y de reemplazo que utilice el sistema operativo
para hacer la migración de información entre el intercambio y la memoria principal tiene como
objetivo conseguir, con el mínimo trabajo posible, que e estén en cada momento en memoria
principal las páginas que necesitan los programas en ejecución.
     Se denomina conjunto de trabajo (working set) W(k,q) de un programa en ejecución en el
intervalo [k;q] al conjunto de páginas referenciadas entre el elemento k y el q de su traza.
     Por otro lado, se denomina conjunto residente R(t) a la parte del proceso que está
realmente almacenada u memoria principal en el instante t.




Digitalización realizada con propósito académico

<!-- pág. 44 -->

                                         Conceptos arquitectónicos de la computadora            23




Figura 1.21 El registro RIED permite determinar la tabla de páginas en uso.

         Supóngase que en el instante t el programa está por su referencia k y que el conjunto
residente R(t) coincide con el conjunto de trabajo W(k,q). Esto significaría que ese programa
tiene la garantía de que sus próximas q — k referencias se refieren a pagina: que están en
memoria principal, por lo que no se generaría ningún fallo de página.
Dado que el sistema operativo no conoce de antemano cuales van a ser las referencias que
generará un programa, ha de basan e en la trayectoria pasada de la ejecución del mismo para
mantener un conjunto reciente que sea lo más parecido posible a su futuro conjunto de trabajo,
para así minimizar la paginación.


1.7. ENTRADA-SALIDA

Los mecanismo: de E/S de la computadora tienen por objetivo el intercambio de información
entre los periféricos y la memoria o los registros del procesador. En este capítulo se presentan
los dos aspectos de la E/S que revisten mayor relevancia de cara al sistema operativo: la
concurrencia de la E/S con el procesador y el impacto de la memoria virtual.


1.7.1. Periféricos

La Figura 1.22 muestra el esquema general de un periférico, compuesto por el dispositivo y su
controlador. Este último tiene una serie de registros incluidos en el mapa de E/S de la
computadora, por lo que ‘e pueden acceder mediante instrucciones de maquina de entrad
salida.
         El registro de datos sirve para el intercambio de datos. En él ira cargando el controlador
los datos leídos y de él ira extrayendo lo datos para su escritura en el periférico.
Un bit del registro de estado sirve para indicar que el controlador puede transferir una palabra.
En las operaciones de lectura esto significa que ha cargado en el registro de datos un nuevo
valor, mientras que en las de escritura significa que necesita un nuevo dato. Otro: bits de este
registro sirven para que el controlador indique los problemas que ha encontrado en la ejecución
de la última operación de entrada/salida.




Digitalización realizada con propósito académico

<!-- pág. 45 -->

24    Sistemas operativos. Una visión aplicada




Figura 1.22 Modelo de Periférico

El registro de control sirve para indicarle al controlador las operaciones que ha de realizar.
Los distintos bits de este registro indican distintas accione que ha de realizar el periférico.


El disco magnético

El disco magnético es, para el sistema operativo, el periférico más importante, puesto que sirve
de espacio de intercambio a la memoria virtual y sirve de almacenamiento permanente para
los programa y los datos, encargándose el sistema operativo de la gestión de este tipo de
dispositivo.
      Para entender la forma en que el sistema operativo trata a los discos magnéticos es
necesario conocer las características de los mismos, entre las que destacaremos tres:
organización de la información, tiempo de acceso y velocidad de transferencia.
     La organización de la información del disco se realiza en contenedores de tamaño fijos
denominados sectores (tamaños típicos del sector son 256, 512 o 1.024 bytes). Como muestra
Figura 1.23, el disco se divide en pistas que, a su vez, se dividen en sectores.
     Las operaciones se realizan a nivel de sector, es decir, no se puede escribir o leer una
palabra o byte individual: hay que escribir o leer de golpe uno o varios sectores.
     El tiempo de acceso de estos dispositivos viene dado por el tiempo que tardan en
Posicionar el brazo en la pista deseada, esto es, por el tiempo de búsqueda, más el tiempo
que tarda la información de la pista en pasar delante de la cabeza por efecto de la rotación del
disco, esto es, mas la




Figura 1.23. Organización del disco.




Digitalización realizada con propósito académico

<!-- pág. 46 -->

                                        Conceptos arquitectónicos de la computadora         25




latencia. Obsérvese que estos tiempos dependen de la posición de partida y de la posición
deseada. No se tarda lo mismo en mover el brazo de la pista 1 a la 2 que de la 1 a la 1.385.
Por ello, los fabricantes suelen dar los valores medios y los peores.
              Un sistema de cabeza fija presenta solamente latencia sin tiempo de
sincronización. por tanto, suponiendo que gira a 10.000 rpm, tendrá un tiempo medio de
acceso de 3 ms (1/2 revolución).


Dispositivos de bloques y caracteres

El disco magnético requiere que se lea o escriba un bloque de información (uno o varios
sectores), por lo que se denomina dispositivo de bloques. Existen otros dispositivos de bloques
como las cintas magnéticas, los DVD, los CD y los controladores de red. Todos ellos se
caracterizan por tener un tiempo de acceso importante comparado con el tiempo de
transferencia de una palabra, por lo que interesa amortizar este tiempo de acceso transfiriendo
bastantes palabras.
Otros dispositivos como el teclado se denominan de caracteres. puesto que la operación básica
de acceso es de un carácter. Estos dispositivos se cauterizan por ser lentos y por no tener un
tiempo de acceso apreciablemente mayor que el tiempo de transferencia de una palabra.


1.7.2.   E/S y concurrencia

Los periféricos son sensiblemente más lentos que el procesador, por ejemplo, durante el
tiempo que se tarda en acceder a una información almacenada en un disco, un procesador
moderno es capaz de ejecutar varios millones de instrucciones de máquina (Prestaciones 1.3).
Es, por tanto, muy conveniente que mientras se está esperando a que se complete una
operación de E/S el procesador esté ejecutando un programa útil y no un bucle de espera.




            Las computadoras presentan tres modos básicos de realizar operaciones de E/S:
E/S programada, E/S por interrupciones y E/S por DMA (direct memory access). La E/S
programada exige que el procesador esté ejecutando un programa de E/S, por lo que no existe
ninguna concurrencia entre el procesador y la E/S. Sin embargo, en los otros dos modos de
E/S el procesador no tiene que estar tendiendo directamente a la E/S, por lo que puede estar
ejecutando otro programa. Se dice, entonces, que existe concurrencia entre la E/S y el
procesador. Esta concurrencia permite optimizar el uso del procesador, pero exige que las
unidades de control de los periféricos sean más inteligentes, lo que supone que sean más
complejas y más caras.
             En términos generales, una operación de E/S se compone de tres fases, envío de
la orden al periférico, lectura o escritura de los datos y fin de la operación.
             La fase de envío de la orden consiste en escribir la orden en los registros del



Digitalización realizada con propósito académico

<!-- pág. 47 -->

26    Sistemas operativos. Una visión aplicada

controlador del periférico, operación que puede hacerse mediante unas cuantas instrucciones
de salida, Dado que el controlador es un dispositivo electrónico, estas escrituras se pueden
hacer a la velocidad de procesador, sin esperas intermedias.




     En la fase de transferencia de los datos interviene el periférico, típicamente mucho más
lento que el procesador. Imaginemos una lectura a disco. En caso de realizar esta operación
con E/S programada debemos ejecutar un bucle que lea el registro de estado del controlador,
observe si esta activo el bit de dato disponible y, en caso positivo, lo lea. El bucle podría tener
la estructura que se muestra en el Programa 1.1.



Programa 1.1. Bucle de E/S programada.

n= O
while n < m
read registro_control
                         if (registro_control = datoAisponible)
                        read registro_datos
                             store en memoria principal
                        n=n+ 1
                          endi f
endwhile



Observe que, hasta que se disponga del primer dato, el bucle puede ejecutarse cerca del millón
de veces y que, entre dato y dato, se repetirá varias decenas de veces. Al llegar a completar
número m de datos a leer, se termina la operación de E/S.
Se denomina espera activa cuando un programa queda en un bucle hasta que ocurra un
evento. La espera activa consume tiempo del procesador, por lo que es muy poco
recomendable cuando el tiempo de espera es grande en comparación con el tiempo de
ejecución de una instrucción
En caso de utilizar E/S con interrupciones, el procesador, tras enviar la orden al controlador del
periférico, puede dedicarse a ejecutar otro programa. Cuando el controlador disponga de un
dato generará una interrupción. La rutina de interrupción deberá hacer la lectura del dato y su
almacenamiento en memoria principal, lo cual conlleva un cierto tiempo del procesador. En
este caso se dice que se hace espera pasiva, puesto que el programa que espera el evento no
esta ejecutándose la interrupción se encarga de <<despertar >> al programa cuando ocurre el
evento.
Finalmente, en caso de utilizar E/S por DMA, el controlador se encarga directa de ir
transfiriendo los datos del periférico a memoria sin molestar al procesador. Una vez terminada
la transferencia de todos los datos, genera una interrupción de forma que se sepa que ha
terminado (Recordatorio 1.2).




            La Tabla 1.2 presenta la ocupación del procesador en la realización de las distintas
actividades de una operación de E/S según el modelo de FIS utilizado.



Digitalización realizada con propósito académico

<!-- pág. 48 -->

                                        Conceptos arquitectónicos de la computadora          27




Tabla 1.2. Ocupación del procesador en operaciones de entrada/salida

      Puede observarse que la solución que presenta la máxima concurrencia y que descarga al
máximo al procesador es la de E/S por DMA. Por otro lado, es la que exige una mayor
inteligencia por parte del controlador.
     Un aspecto fundamental de esta concurrencia es su explotación. En efecto, de nada sirve
descargar al procesador del trabajo de E/S si durante ese tiempo no tiene nada útil que hacer.
Será una función importante del sistema operativo el explotar esta concurrencia la E/S y el
procesador, haciendo que este ultimo tenga trabajo útil el mayor tiempo posible.

1.7.3. E/S y memoria virtual

La memoria virtual presenta un problema importante frente a la entrada/salida. En efecto, el
programa que solicita una operación de E/S especifica una variable que determina un buffer de
memoria sobre el que se hace la operación. Para que el controlador del periférico que realiza la
operación pueda operar por DMA, el buffer ha de residir en memoria principal. En caso
contrario, se intentaría hacer, por ejemplo, una lectura de unos datos de disco para escribir en
una página, que también está en disco. El hardware no es capaz de hacer este tipo de
operación.
    El sistema operativo ha de garantizar que los buffers de usuario sobre los que se hacen
operaciones de entrada/salida estén en memoria principal durante toda la duración de la
operación. En especial los marcos afectados no podrán ser objeto de paginación.

1.8. PROTECCIÓN

Como veremos mas adelante, una de las funciones del sistema operativo es la protección de
unos usuarios contra otros: ni por malicia ni por descuido un usuario deberá acceder a la
información de otro.
     La protección hay que comprobarla en tiempo de ejecución, por lo que se ha de basar en
mecanismos hardware. En esta sección se analizaran estos mecanismos para estudiar más
adelante cómo los aplica el sistema operativo. Se analizara en primer lugar los mecanismos de
protección que ofrece el procesador para pasar seguidamente a los mecanismos de protección
de memoria.


1,8.1. Mecanismos de protección del procesador

Los mecanismos de protección del procesador se basan en los niveles de ejecución del mismo.
En nivel de ejecución de núcleo se pueden ejecutar todas las instrucciones de maquina y se
pueden acceder a todos los registros y a la totalidad de los mapas de memoria y de E/S. Sin
embargo, en modo usuario se ejecuta un subconjunto de las instrucciones y se limitan los
registros y los mapas accesibles.
Uno de los objetivos prioritarios de protección son los periféricos. En efecto, prohibiendo el
acceso directo de los usuarios a los periféricos se impide que puedan acceder a la información




Digitalización realizada con propósito académico

<!-- pág. 49 -->

         28    Sistemas operativos. Una visión aplicada




         almacenada por otros usuarios en esos periféricos. Por esta razón, toda la E/S es accesible
         solamente en nivel de núcleo, nivel que debe estar reservado al sistema operativo.
                Para evitar que un programa de usuario pueda poner el procesador en nivel de núcleo,
         no existe ninguna instrucción máquina que realice este cambio (Advertencia 1.7). Sin embargo,
         existe la instrucción máquina inversa, que cambia de nivel de núcleo a nivel de usuario. Esta
         instrucción es utilizada por el sistema operativo antes de dejar que ejecute un programa de
         usuario.




              El mecanismo suministrado por el hardware para que el procesador pase a nivel de
         núcleo es la interrupción. En efecto, toda interrupción, ya sea interna o externa, tiene como
         efecto poner al procesador en nivel de núcleo. Siempre y cuando el sistema operativo se
         encargue de atender todas las interrupciones y de poner en nivel de usuario procesador antes
         de lanzar la ejecución de los programas de usuario, se garantiza que solamente sea el sistema
         operativo el que ejecute en nivel de núcleo.


1.8.2.   Mecanismos de protección de memoria

         Los mecanismos de protección de memoria deben evitar que un programa en ejecución
         direccione posiciones de memoria que no le hayan sido asignadas por el sistema operativo.
               Una solución empleada en algunas máquinas que no tienen memoria virtual consiste en
         incluir una pareja de registros valla (limite y base), como los mostrados en la Figura 1.24. En
         esta solución se le asigna al programa una zona de memoria contigua. Todos los
         direccionamientos se calculan sumando el contenido del registro base, de forma que para el
         programa es como si estuviese cargado a partir de la posición «0» de memoria. Además, en
         cada acceso un circuito comparador comparara la dirección generada con el valor del registro
         limite. En caso de desbordamiento, el comparador genera una excepción de violación de
         memoria, para que el sistema operativo trate el tema, lo en la práctica, supone que parará el
         programa produciendo un volcado de memoria (core dump (Consejo de programación 1.1).




         Figura 1.24. Uso de registros vallo.




         Digitalización realizada con propósito académico

<!-- pág. 50 -->

                                       Conceptos arquitectónicos de la computadora         29




Figura 1,25. División del mapa de memoria.




         En los sistemas con memoria virtual existen dos mecanismos de protección de
memoria. Por un lado, en nivel de usuario el procesador no permite acceder más que a una
parte del mapa de memoria. Como muestra la Figura 1.25, una solución es que en nivel de
núcleo se pueda direccional todo el mapa de memoria virtual, mientras que en nivel de usuario
solamente se pueda direccional una parte del mapa (por. ej.: las direcciones que empiezan por
«0»). La MMU generará una excepción de violación de memoria en caso de que en nivel de
usuario se genere una dirección no permitida (por. ej.: que empiece por «1»).
       Además, una solución bastante frecuente consiste en dotar al procesador de un registro
RIED (registro de identificador de espacio de direccionamiento). De esta forma se consigue que
cada programa ejecución disponga de su propio espacio virtual, por lo que no puede acceder a
tos clon espacios de memoria de los otros procesos.
      El otro mecanismo se basa en la tabla de páginas y viene representado en la Figura 1.26.
La tabla de páginas de cada programa en ejecución se selecciona mediante el RIED y
especifica los




Figura 1.26. La tabla de páginas como mecanismo de protección de memoria.



Digitalización realizada con propósito académico

<!-- pág. 51 -->

30     Sistemas operativos. Una visión aplicada




espacio. de memoria asignados por el sistema operativo a ese programa. La MMU, al mismo
tiempo que realiza la traducción de cada dirección, comprueba que no se sobrepase el límite
de ninguna de las tablas involucradas. En caso de sobrepasarse, generara una excepción de
violación de memoria, para que el sistema operativo realice la acción correctora oportuna.



1.9.    MULTJPROCESADOR Y MULTICOMPUTADORA

Dada la insaciable apetencia por máquinas de mayor potencia de proceso, cada vez es mas
corriente encontrarse con computadoras que incluyen más de un procesador. Esta situación
tiene una repercusión inmediata en el sistema operativo, que ha de ser capaz de explotar
adecuadamente todos estos procesadores.
Las dos arquitecturas para estas computadoras son la de multiprocesador y la de
multicomputadora, que se analizan seguidamente.


Multiprocesador

Como muestra la Figura 1.27, un multiprocesador es una máquina formada por un conjunto
procesadores que comparten el acceso a una memoria principal común.
Cada procesador ejecuta su propio programa, debiendo todos ellos compartir la memoria
principal común.
Una ventaja importante de esta solución es que el acceso a datos comunes por parte de varios
programas es muy sencillo, puesto que utilizan la misma memoria principal. El mayor
inconveniente es el limitado número de procesadores que se pueden incluir sin incurrir en el
problema de saturar el ancho de banda de la memoria común (un límite típico es el de 16
procesadores).


Multicomputadora

La multicomputadora es una máquina compuesta por varios nodos, estando cada nodo
formado un procesador, su memoria principal y, en su caso, elementos de E/S. La Figura 1.28
muestra esquema global de estas computadoras.
Al contrario que en los multiprocesadores, en estas máquinas los programas de do:
procesadores no pueden compartir datos en memoria principal. Sin embargo, no existe la
limitación anterior en cuanto al número de procesadores que e pueden incluir, Buena prueba de
ello es que existen máquinas con varios miles de procesadores.




Figura 1.27. Estructura de un multiprocesador.




Digitalización realizada con propósito académico

<!-- pág. 52 -->

                                    Conceptos arquitectónicos de la computadora   31




Digitalización realizada con propósito académico

<!-- pág. 53 -->

32   Sistemas operativos. Una visión aplicada




Digitalización realizada con propósito académico

