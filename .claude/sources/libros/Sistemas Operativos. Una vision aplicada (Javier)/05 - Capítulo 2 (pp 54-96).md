# Capítulo 2

> Fuente: Sistemas Operativos. Una vision aplicada (Javier) — páginas 54–96 (numeración del PDF)

<!-- pág. 54 -->



<!-- pág. 55 -->

2.1.   ¿QUÉ ES UN SISTEMA OPERATIVO?

         En esta sección se plantea en primer lugar el concepto de maquina desnuda para pasar
         acto seguido a introducir el concepto de sistema operativo y sus principales funciones.

         2.1.1. Maquina desnuda

         El término de maquina desnuda se aplica a una computadora carente de sistema
         operativo. El término es interesante porque resalta el hecho de que una computadora en
         sí misma no hace nada. Como se vio en el capítulo anterior, una computadora solamente
         es capaz de repetir a alta velocidad la secuencia de: lectura de instrucción máquina,
         incremento del PC y ejecución de la instrucción leída.
               Para que la computadora realice un función determinada ha de tener en memoria
         principal un programa maquina específico p a realizar dicha función y ha de conseguirse
         que el registro PC contenga la dirección de comienzo del programa.
               La misión del sistema operativo, como se verá en la sección siguiente, es completar
         (vestir) a la máquina mediante una serie de programas que permitan su cómodo manejo y
         utilización.



         2.1.2.   Funciones del sistema operativo

         Un sistema operativo (SO) es un programa que tiene encomendadas una serie de
         funciones diferentes cuyo objetivo es simplificar el manejo y la utilización de la
         computadora, haciéndolo seguro y eficiente. Históricamente se han ido completando las
         misiones encomendadas al sistema operativo, por lo que lo. productos comerciales
         actuales incluyen una gran cantidad de funciones, como son interfaces gráficas,
         protocolos de comunicación, etc. (Recordatorio 2.1).




              Las funciones clásica, del sistema operativo se pueden agrupar en las tres
         categorías siguientes:


              • Gestión de os recursos de la computadora.
              • Ejecución de servicios para lo: programas.
              • Ejecución de los mandato: de los usuarios.

              Como muestra la Figura 2.1, el sistema operativo esta formado conceptualmente por
         tres capas principales. La capa m : cercana al hardware se denomina núcleo (kernel) y
         es la que gestiona los recursos hardware del sistema y la que suministra otra la
         funcionalidad básica del sistema operativo. Esta capa ha de ejecutar en nivel núcleo,
         mientras que las otras pueden ejecutar en niveles menos permisivos.

<!-- pág. 56 -->

Figura 2.1. Niveles del sistema operativo.

      La capa de servicios o llamadas al sistema ofrece a los programas unos servicios
en forma de una interfaz de programación o API (application programming interface).
Desde el punto de vista de los programas, esta capa extiende la funcionalidad de la
computadora, por lo que se suele decir que el sistema operativo ofrece una máquina
virtual extendida a los programas. De esta forma se facilita la elaboración de éstos,
puesto que se apoyan en las funciones que le suministra el sistema operativo.
      La capa de intérprete de mandatos o shell suministra una interfaz a través de la
cual el usuario puede dialogar de forma interactiva con la computadora. El shell recibe
los mandatos u órdenes del usuario, los interpreta y, si puede, los ejecuta. Dado que el
shell suele ejecutar en nivel de usuario, algunos autores consideran que no forma p te
del sistema operativo. En opinión de los autores es uno mas de los elementos del mismo.
     Seguidamente, se analizarán cada una de estas tres facetas del sistema operativo.

El sistema operativo como gestor de recursos

En una computadora actual suelen coexistir varios programas, del mismo o de varios
usuarios, ejecutándose simultáneamente. Estos programas compiten por los recursos de
la computadora, siendo el sistema operativo el encargado de arbitrar su asignación y
uso. Como complemento a la gestión de recursos, el sistema operativo ha de garantizar
la protección de unos programas frente a otros y ha de suministrar información sobre el
uso que se hace de los recursos.


a) Asignación de recursos

El sistema operativo se encarga de asignar los recursos a los programas en ejecución.
Para ello, ha de mantener unas estructuras que le permitan saber que recursos están
libres y cuáles están asignados a cada programa. La asignación de recursos se realiza
según la disponibilidad de lo. mismos y la prioridad de los programas, debiéndose
resolver los conflictos que aparecen por las peticiones simultáneas.
      Especial mención reviste la recuperación de los recursos cuando los programas ya
no los necesitan. Una mala recuperación de recursos puede hacer que el sistema
operativo considere, por ejemplo, que ya no le queda memoria disponible cuando, en
realidad, sí la tiene. La recuperación se puede hacer porque el programa que tiene
asignado el recurso le comunica al sistema operativo que ya no lo necesita o bien porque
el programa haya terminado.
      Los recursos manejados por el sistema operativo son físicos y lógicos. Entre los
físicos se encuentra el procesador, la memoria principal y los periféricos. Entre los
lógicos se pueden citar los archivos y los puertos de comunicación.


b) Protección

<!-- pág. 57 -->

          El sistema operativo ha de garantizar la protección entre los usuarios del sistema. Ha de
          asegurar la confidencialidad de la información y que unos trabajos no interfieran con
          otros. Para conseguir este
36   Sistemas operativos. Una visión aplicada


         objetivo ha de impedir que unos programas puedan acceder a los recursos asignados a
         otros programas.

         c) Contabilidad

         La contabilidad permite medir la cantidad de recursos que, a lo largo de su ejecución,
         utiliza cada programa. De esta f6rma se puede conocer la carga de utilización que tiene
         cada recurso y se puede imputar a cada usuario los recursos que ha utilizado. Cuando la
         contabilidad se emplea meramente para conocer la carga de los componentes del sistema
         se suele denominar monitorización.

         El sistema operativo como máquina extendida

         El sistema operativo ofrece a los programas un conjunto de servicios, o llamadas al
         sistema, que pueden solicitar cuando lo necesiten, proporcionando a los programas una
         visión de máquina extendida. El modelo de programación que ofrece el hardware e se
         complementa con estos servicios software, que permiten ejecutar de forma cómoda y
         protegida ciertas operaciones. La alternativa consistiría en complicar los programas de
         usuario y en no tener protección frente a o os usuarios.
              Los servicios se pueden agrupar en las cuatro clases siguientes: ejecución de
         programas, operaciones de E/S, operaciones sobre archivos y detección y tratamiento de
         errores. Gran parte e de este texto se dedicará a explicar los servicios ofrecidos por los
         sistemas operativos, por lo que aquí nos limitaremos a hacer unos simples comentarios
         sobre cada una de sus cuatro clases.

         d)   Ejecución de programas

         El sistema operativo incluye servicios para lanzar la ejecución de un programa, así como
         para pararla o abortarla. También existen servicios p a conocer y modificar las
         condiciones de ejecución de los programa, para comunicar y sincronizar unos programas
         con otros.
               La ejecución de programas da lugar al concepto de proceso. Un proceso se puede
         definir como un programa en ejecución. El proceso es un concepto fundamental en los
         sistemas operativos, puesto que el objetivo ultimo de éstos es crear, ejecutar y destruir
         procesos, de acuerdo a las órdenes de los usuarios.
              Para que un programa pueda convertirse en un proceso ha de estar traducido a
         código máquina y almacenado en un dispositivo de almacenamiento como el disco. Bajo
         la petición de un usuario, el sistema operativo creará un proceso para ejecutar el
         programa. Observe que varios procesos pueden estar ejecutando el mismo programa. Por
         ejemplo, varios usuarios pueden haber pedido al operativo la ejecución del mismo
         programa editor.

         b)   Órdenes de E/S

         Los servicios de E/S ofrecen una gran comodidad y protección al proveer a los programas
         de operaciones de lectura, escritura y modificación del estado de los periféricos. En
         efecto, la programación de las operaciones de E/S es muy compleja y dependiente del
         hardware específico de cada periférico. Los servicios del si tema operativo ofrecen un alto
         nivel de abstracción de forma que el programador de aplicaciones no tenga que
         preocuparse de esos detalles.

<!-- pág. 58 -->

e)     Operaciones sobre archivos

Los archivos ofrecen un nivel de abstracción mayor que el de las órdenes de E/S,
permitiendo operaciones tales como creación, borrado, renombrado, apertura, escritura y
lectura de chivos.

                                              Introducción a los sistemas operativos     37

Observe que muchos de los servicios son parecidos a las operaciones de E/S y terminan
concretándose en este tipo de operaciones.


d)    Detección y tratamiento de errores

Además de analizar detalladamente todas las ordenes que recibe, para comprobar que se
pueden realizar , el sistema operativo se encarga de tratar todas las condiciones de error
que detecte el hardware.
     Entre las condiciones de error que pueden aparecer destacaremos las siguientes:
errores en las operaciones de E/S, errores de paridad en los accesos a memoria o en los
buses y errores de ejecución en los programas, como desbordamientos, violaciones de
memoria, códigos de instrucción prohibidos, etc.


El sistema operativo como interfaz de usuario

El módulo del sistema operativo que permite que los usuarios dialoguen de forma
interactiva con el sistema es el intérprete de mandatos o shell.
     El shell se comporta como un bucle infinito que está repitiendo constantemente la
siguiente secuencia:

     • Espera una orden del usuario. En el caso de interfaz textual, el shell está pendiente
     de lo que escribe el usuario en la línea de mandatos. En las interfaces gráficas está
     pendiente de los eventos del apuntador (ratón) que manipula el usuario, además, de los
     del teclado.
     • Analiza la orden y, en caso de ser correcta, la ejecuta, para lo cual emplea los
     servicios del sistema operativo.
     • Concluida la orden vuelve a la espera.

      El dialogo mediante interfaz textual exige que el usuario memorice la sintaxis de los
mandatos, con la agravante de que son distintos para cada sistema operativo (p. ej.: para
listar el contenido de un chivo en MS-DOS e emplea el mandato type, pero en UNIX se
usa el mandato cat ). Por esta razón cada vez son más populares los intérpretes de
mandatos con interfaz gráfica, como el de Windows NT.


Archivos de mandatos

Casi todos los intérpretes de mandatos pueden ejecutar archivos de mandatos, llamados
shell scripts. Estos chivos incluyen varios mandatos totalmente equivalentes a los
mandatos que se introducen en el terminal. Además, para realizar funciones complejas,
pueden incluir mandatos especiales de control del flujo de ejecución, como puede ser el
goto, el for o el if, así como etiquetas para identificar líneas de mandatos,
     Para ejecutar un archivo de mandatos basta con invocarlo de igual forma que un
mandato estándar del intérprete de mandatos.



2.1.3.   Concepto de usuario y de grupo de usuarios

<!-- pág. 59 -->

          Un usuario es una persona autorizada para utilizar un sistema informático. El usuario se
          autentica mediante su nombre de cuenta y su contraseña o password.




38     Sistemas operativos. Una visión aplicada

                 En realidad, el sistema operativo no asocia el concepto de usuario con el de persona
           física sino con un nombre de cuenta. Una persona puede tener más de una cuenta y una
           cuenta puede ser utilizada por más de una persona. Internamente, el sistema operativo
           asigna a cada usuario (cuenta)un identificador «uid» (user identifier) y un perfil.
                 El sistema de seguridad de los sistemas operativos está basado en la entidad
           usuario. Cada usuario tiene asociados unos derechos, que definen las operaciones que le
           son permitidas.
                 Existe un usuario privilegiado, denominado súperusuario o administrador, que no
           tiene ninguna restricción, es decir, que puede hacer todas las operaciones sin ninguna
           traba. La figura súperusuario es necesaria para poder administrar el sistema
           (Recomendación 2.1),




                Los usuarios se organizan en grupos (p. ej.: en una universidad se puede crear un
           grupo para los alumnos de cada curso y otro para los profesores). Todo usuario debe
           pertenecer a un grupo. Los grupos también se emplean en la protección del sistema,
           puesto que los derechos de un usuario son los suyos propios más los del grupo al que
           pertenezca. Por ejemplo, UNIX asigna un identificador «gid» (group identtfier) a cada
           grupo.



2.2.    ARRANQUE DE LA COMPUTADORA

           El arranque de una computadora actual tiene dos fases: la fase de arranque hardware y la
           fase arranque del sistema operativo. La Figura 2.2 resume las actividades más
           importantes que se realizan en el arranque de la computadora.

<!-- pág. 60 -->

Figura 2.2. Operaciones realizadas en el arranque de la computadora.

                                                Introducción a los sistemas operativos 39

Arranque hardware

Como se ha indicado con anterioridad, la computadora solamente es capaz de realizar
actividades útiles si cuenta con el correspondiente programa cargado en memoria
principal. Ahora bien, la memoria principal de las computadoras es volátil, lo que significa
que, cuando se enciende la máquina, no contiene ninguna información válida, Por tanto, al
arrancar la computadora no es capaz de realizar nada,
     Para resolver esta situación, las computadoras antiguas tenían una serie de
conmutadores que permitían introducir una a una palabras en la memoria principal y en los
registros. El usuario debía introducir a mano, y en binario, un primer programa que
permitiese cargar otros programas almacenados en algún soporte, como la cinta de papel.
     En la actualidad, la solución empleada es mucho más cómoda puesto que se basa en
un programa permanente grabado en una memoria ROM. En efecto, como muestra la
Figura 2.3, una parte del mapa de memoria está construido con memoria ROM no volátil.
En esta memoria ROM se encuentra a un programa de arranque, que esta siempre
disponible, puesto que la ROM no pierde su contenido. Llamemos iniciador ROM a este
programa.
     Cuando se arranca la computadora, o cuando se pulsa el botón de RESET, se genera
una señal eléctrica que carga uno. valores predefinidos en los registros. En especial, esta
señal carga en el contador de programa la dirección de comienzo del iniciador ROM. De
esta forma se cumplen todas las condiciones para que la computadora ejecute un
programa y realice funciones útiles.
     El iniciador ROM realiza tres funciones, Primero hace una comprobación del sistema,
que para sirve para detectar sus características (p. ej.; la cantidad de memoria principal
disponible o los periféricos instalados) y comprobar si el conjunto funciona correctamente,
Una vez pasada la como son probación, entra en la fase de lectura y almacenamiento en
memoria del programa cargador del sistema operativo (Ablación 2.1). Finalmente da
control a este programa, bifurcando a la dirección de memoria en la que l ha almacenado,
Para tener una mayor flexibilidad se hace que el programa iniciador ROM sea
independiente del sistema operativo.

<!-- pág. 61 -->

                Figura 2.3. Una parte del mapa de memoria está construido con memoria



40   Sistemas operativos. Una visión aplicada

              En el caso de una computadora de tipo PC, la memoria ROM contiene, además del
         programa iniciador, software de E/S denominado BIOS (basic input-output system). La
         BIOS de una computadora la proporciona el fabricante y suele contener procedimientos
         para leer y escribir de leer caracteres del teclado y escribir en la pantalla.


         Ubicación del sistema operativo

         El sistema operativo se encuentra almacenado en una unidad de disco, tal y como
         muestra Figura 2.4. Hay una parte del mismo en la que estamos especialmente
         interesados ahora: se trata del programa cargador del sistema operativo o boot del
         sistema operativo. Este programa está almacenado en una zona predefinida del disco (p.
         ej.: los cuatro primeros sectores del disco) y tamaño prefijado.
                Como se indicó anteriormente, el iniciador ROM trae a memoria principal el programa
         cargado del sistema operativo. El programa iniciador ROM y el sistema operativo tienen un
         convenio sobre la ubicación, dirección de arranque y tamaño del cargador del sistema
         operativo. Obsérvese que el iniciador ROM es independiente del sistema operativo
         siempre que este cumpla con el convenio anterior, por lo que la máquina podrá soportar
         diversos sistemas operativos.
                Para una mayor seguridad, el programa cargador del sistema operativo incluye, en
         una posición prefijada por el iniciador ROM, una contraseña (palabra mágica). De esta
         forma, el iniciador ROM puede verificar que la información contenida en la zona prefijada
         contiene efectivamente programa cargador de un sistema operativo.


         Arranque del sistema operativo

         El programa cargador del sistema operativo tiene por misión traer a memoria principal
         algunos los componentes del sistema operativo. Una vez cargados estos componentes, se
         pasa a la fase iniciación, que incluye las siguientes operaciones:

             • Comprobación del sistema. Se completan las pruebas del hardware realizadas por
               dar ROM y se comprueba que el sistema de archivos tiene un estado coherente.
               Esta operación exige revisar todos los directorios, lo que supone un largo tiempo de
               procesamiento.
             • Se establecen las estructuras de información propias del sistema operativo, tales
               como tabla de procesos, las tablas de memoria y las de E/S. El contenido de estas
               tablas se describirá a lo largo del libro,
             • Se carga en memoria principal aquella parte del sistema operativo que ha de estar
               siempre memoria, parte que se denomina sistema operativo residente.
             • Se crea un proceso de inicio o login por cada terminal definido en el sistema, así
               como una serie de procesos auxiliares y de demonios (p. ej.; el demonio de
               impresión o el demonio comunicaciones).

<!-- pág. 62 -->

         Figura 2.4. El sistema operativo se encuentra almacenado en una unidad de disco.
                                                     Introducción a los sistemas operativos      41


               Los procesos de inicio presentan en su terminal el mensaje de bienvenida y se
         quedan a la espera de que un usuario a arranque una sesión, para lo cual ha de teclear el
         nombre de su cuenta y su contraseña o password. El proceso de inicio autentica al
         usuario, comprobando que los datos introducidos son correctos y lanza un proceso shell
         (Aclaración 2.2). El proceso shell primero ejecuta uno o varios archivos de mandatos,
         como es el «autoexec.bat» en MS-DOS o los «.login» y «.cshrc» en UNIX. A
         continuación, el shell se queda esperando órdenes de los usuarios, ya sean textuales o
         como acciones sobre un menú o un icono. Para llevar a cabo las operaciones solicitadas
         por el usuario, el shell genera uno o varios procesos.




2.3.   COMPONENTES Y ESTRUCTURA DEL SISTEMA OPERATIVO

          El sistema operativo está formado por una serie de componentes especializados en
          determinadas funciones. Cada sistema operativo estructura estos componentes de forma
          distinta. En esta sección se describen en primer lugar los distintos componentes que
          conforman un sistema operativo, para pasar a continuación a ver las distintas formas que
          tienen los sistemas operativos de estructurar estos componentes.


          2.3.1. Componentes del sistema operativo

          Como se comentó previamente y se muestra en la Figura 2.5, se suele considerar que un
          sistema operativo está formado por tres capas: el núcleo, los servicios y el intérprete de
          mandatos o shell.
               El núcleo es la parte del sistema operativo que interacciona directamente con el
          hardware de la máquina. Las funciones del núcleo se centran en la gestión de recursos,
          como el procesador, tratamiento de interrupciones y las funciones básicas de
          manipulación de memoria,

<!-- pág. 63 -->

          Figura 2.5. Componentes del sistema operativo.
42   Sistemas operativos. Una visión aplicada

             Los servicios se suelen agruparse según su funcionalidad en varios componentes,
         cada uno de cuales se ocupa de las siguientes funciones:

               • Gestión de procesos. Encargada de la creación, planificación y destrucción de
                 procesos.
               • Gestión de memoria. Componente encargada de saber qué partes de memoria
                 están libres y cuáles ocupadas, así como de la asignación y liberación de memoria
                 según la necesiten los procesos.
               •Gestión de la EIS. Se ocupa de facilitar el manejo de los dispositivos periféricos.
              • Gestión de archivos y directorios. Se encarga del manejo de archivos y directorios
                 y de 1a administración del almacenamiento secundario,
              • Comunicación y sincronización en e procesos. Encargada de ofrecer mecanismos
                 los procesos puedan comunicase y sincronizarse.
              • Seguridad y protección. Este componente debe encargarse de garantizar la
                  usuarios y de definir lo que pueden hacer cada uno de ellos con los recursos del
                  sistema.

              Todos estos componentes ofrecen una serie de servicios a través de una interfaz de
         llamadas sistema. Como se muestra en la Figura 2.5, un sistema operativo puede incluir
         más de una interfaz de servicios (en la figura se han considerado las interfaces Win32 y
         POSIX, interfaces que ser
         descritas a lo largo del presente libro). En este caso, los programas podrán elegir sobre
         qué interfaz quieren ejecutar, pero no podrán mezclar servicios de varias interfaces. Se
         dice, en este caso, que sistema operativo presenta al usuario varias máquinas virtuales.
               De igual forma, el sistema operativo puede incluir varios intérpretes de mandatos,
         unos textuales y otros gráficos, pudiendo el usuario elegir el que mas le interese. Sin
         embargo, hay que observar que no se podrán mezclar mandatos de varios intérpretes.
              En las secciones siguientes de este capitulo se van a describir, de forma muy breve,
         cada uno de los componentes anteriores, pero antes se van a describir las distintas
         formas que tienen los sistemas operativos de estructurar dichos componente.



         2.3.2.   Estructura del sistema operativo

         Un sistema operativo es un programa grande y complejo que está compuesto, como se
         ha visto en la sección anterior, por una serie de componentes con funciones bien
         definidas. Cada sistema operativo estructura estos componentes de distinta forma. En
         función de esta estructura se pueden agrupar los sistemas operativos en dos grandes
         grupos: sistemas operativos monolíticos y sistemas operativos estructurados.


         Sistemas operativos monolíticos

         Un sistema operativo de este tipo no tiene una estructura clara y bien definida. Todos sus
         componentes se encuentran integrados en un único programa (el sistema operativo) que
         ejecuta en un único espacio de direcciones. En este tipo de sistemas todas las funciones
         que ofrece el sistema operativo se ejecuta en un modo núcleo.
              Estos sistemas operativos han surgido, normalmente, de sistemas operativos
         sencillos y pequeños a los que se les ha ido añadiendo un número mayor de
         funcionalidades. Esto les ha hecho evolucionar y crece hasta convertirlos en programas
         grandes y complejos formados por muchas funciones situadas todas ellas en un mismo
         nivel. Ejemplos claros de este tipo de sistemas son MS-DOS y UNIX. Ambos comenzaron
         siendo pequeños sistemas operativos, que fueron haciéndose cada vez mas grandes
         debido a la gran popularidad que adquirieron.

<!-- pág. 64 -->

                                                          Introducción a los sistemas operativos 43




              El problema que plantean este tipo de sistemas radica en lo complicado que es
          modificar el sistema operativo para añadir nuevas funcionalidades y servicios. En efecto,
          añadir una nueva característica al sistema operativo implica la modificación de un gran
          programa, compuesto por miles de líneas de código fuente y funciones, cada una de las
          cuales puede invocar a otras cuando así lo requiera. Además, en este tipo de sistemas
          no se sigue el principio de ocultación de la información. Para solucionar este problema es
          necesario dotar de cierta estructura al sistema operativo.


          Sistemas operativos estructurados

          Cuando se quiere dotar de estructura a un sistema operativo, normalmente se recurre a
          dos tipos de soluciones: sistemas por capas y sistemas cliente-servidor.

          a) Sistemas por capa.

          En un sistema por capas, el sistema operativo se organiza como una jerarquía de capas,
          donde cada capa ofrece una interfaz clara y bien definida a la capa superior y solamente
          utiliza los servicios que le ofrece la capa inferior.
                La principal ventaja que ofrece este tipo de estructuras es la modularidad y la
          ocultación de la información. Una capa no necesita conocer como se ha implementado
          la capa sobre la que se construye, únicamente necesita conocer la interfaz que ofrece.
          Esto facilita enormemente la depuración y verificación del sistema, puesto que las capas
          se pueden ir construyendo y depurando por separado.
                Este enfoque lo utilizo por primera vez el sistema operativo THE [Dijkstra, 1968], un
          sistema operativo sencillo que estaba formado por seis capas, como se muestra en la
          Figura 2.6. Otro ejemplo de sistema operativo diseñado por capas es el OS/2 [Deitel,
          1994], descendiente de MS-DOS.


          b) Modelo cliente-servidor

          En este tipo de modelo, el enfoque consiste en implementar la mayor parte de los
          servicios y funciones del sistema operativo en procesos de usuario, dejando solo una
          pequeña parte del sistema operativo ejecutando en modo núcleo. A esta parte se le
          denomina micronúcleo y a los procesos que          ejecutan el resto de funciones se les
          denomina servidores. La Figura 2.7 presenta la estructura de un sistema operativo con
          estructura cliente-servidor, Como puede apreciarse en la figura, el sistema operativo está
          formado por diversas partes, cada una de las cuales puede desarrollarse por separado.




           Figura 2.6. Estructura por capa. del sistema operativo THE,
44   Sistemas operativos. Una visión aplicada

<!-- pág. 65 -->

         Figura 2.7. Estructura cliente-servidor en un sistema operativo.


              No hay una definición clara de las funciones que debe llevar a cabo un micronúcleo.
         La mayoría incluyen la gestión de interrupciones, gestión básica de procesos y de
         memoria y servicios básicos de comunicación entre procesos. Para solicitar un servicio en
         este tipo de sistemas, como por ejemplo crear un proceso, el proceso de usuario (proceso
         denominado cliente) solicita el servicio al servidor del sistema operativo correspondiente,
         en este caso al servidor de procesos. A su vez, el proceso servidor puede requerir los
         servicios de otros servidores, como es el caso del servidor de memoria. En este caso, el
         servidor de procesos se convierte en cliente del servidor de memoria.
              La ventaja de este modelo es la gran flexibilidad que presenta. Cada proceso
         servidor sólo ocupa de una funcionalidad concreta, lo que hace que cada parte pueda ser
         pequeña y
         Esto a su vez facilita el desarrollo y depuración de cada uno de los procesos servidores.
              En cuanto a las desventajas, citar que estos sistemas presentan una mayor
         sobrecarga en el tratamiento de los servicios que los sistemas monolíticos. Esto se debe
         a que los distintos componentes de un sistema operativo de este tipo ejecutan en
         espacios de direcciones distintos, lo que hace que su activación requiera más tiempo.
              Minix [Tanenbaum, 1998], Mach [Accetta, 1986] y Amoeba [Mullender, 1990] son
         ejemplos de sistemas operativos que siguen este modelo. Windows NT también sigue
         esta filosofía de diseño, aunque muchos de los servidores (el gestor de procesos, gestor
         de E/S, gestor de memoria, etc.) se ejecutan en modo núcleo por razones de eficiencia.



2.4.   GESTIÓN DE PROCESOS

         El componente principal de un sistema operativo es el que se encarga de la gestión de
         procesos. El proceso es un elemento central en los sistemas operativos, puesto que su
         función consiste en generar y gestionar los procesos y en atender a sus peticiones. En
         esta sección se introducirán los aspectos más relevantes de los procesos.
                Como se indicó anteriormente, el proceso se puede definir como un programa en
          ejecución. De forma un poco más precisa, se puede definir el proceso como la unidad de
          procesamiento gestionada por el sistema operativo. No hay que confundir el concepto de
          programa con el concepto de proceso. Un programa no es más que un conjunto de
          instrucciones máquina, mientras que el proceso surge cuando un programa se pone en
          ejecución. Esto hace que varios procesos puedan ejecutar el mismo programa a la vez (p.
          Ej.: que varios usuarios estén ejecutando el mismo editor textos).
                En el Capítulo 1 se vio que, para que un programa pueda ser ejecutado, ha de residir
         con sus datos en memoria principal, tal y como muestra la Figura 2.8. Al contenido de los
         segmentos de




                                                        Introducción a los sistemas operativos   45

<!-- pág. 66 -->

         Figura 2.8. Elementos que constituyen un proceso.

         memoria en los que reside el código y los datos del proceso se le denomina imagen de
         memoria. Observe que, durante su ejecución, el proceso va modificando los registros del
         modelo de programación de la computadora, de acuerdo a las instrucciones de maquinas
         involucradas. El contenido de los registros del modelo de programación es lo que se
         conoce como estado del procesador.
              El sistema operativo mantiene por cada proceso una serie de estructuras de
         información que permite identificar las características de éste así como los recursos que
         tiene asignados. Una parte muy importante de esta estructura es el bloque de control del
         proceso (BCP) que, como se verá en el Capítulo 3, incluye, entre otra información, el
         estado de los registros del proceso, cuando éste no está ejecutando. El sistema operativo
         debe encargarse también de ofrecer una serie de servicios para la gestión de procesos y
         de gestionar los posibles interbloqueos que surgen cuando los procesos acceden a
         diferentes recursos.
              Dependiendo del número de procesos y de usuarios que puedan ejecutar
         simultáneamente, un sistema operativo puede ser:

            • Monotarea, también llamado monoproceso. Este tipo de sistemas operativos sólo
              permite que exista un proceso en cada instante.
            • Multitarea o multiproceso. Permite que coexistan varios procesos activos a la vez. El
              sistema operativo se encarga de ir repartiendo el tiempo del procesador entre estos
              procesos.
            • Monousuario. Está previsto para soportar a un solo usuario,
            • Multiusuario. Soporta varios usuarios trabajando simultáneamente desde varios
              terminales. A su ve cada usuario puede tener activo más de un proceso, por lo que el
              sistema, obligatoriamente, ha de ser multitarea. Los sistemas multiusuario reciben
              también el nombre de tiempo compartido, porque el sistema operativo ha de repartir el
              tiempo de la computadora entre los usuarios para que las tareas de todos ellos
              avancen de forma razonable.

              En el Capítulo 3 se estudiarán con detalle la gestión de procesos, los servicios
         ofrecidos para la gestión de procesos y las técnicas básicas de implementación de
         procesos. En el Capítulo 6 se estudiará el concepto de ínterbloqueo y los mecanismos
         para manejarlo.


        2.4.1.   Servicios de procesos

         El sistema operativo ofrece una serie de servicios que permiten definir la vida de un
         proceso. Esta vida está constituida por las siguientes fases; creación, ejecución y muerte
         del proceso.
              En general, los sistemas operativos ofrecen los siguientes servicios para la gestión de
         procesos:
46   Sistemas operativos. Una visión aplicada

<!-- pág. 67 -->

                  • Crear un proceso. El proceso es creado por el sistema operativo cuando así lo
                    solicita otro proceso, que se convierte en el padre del nuevo. Existen dos
                    modalidades básicas para crear un proceso en los sistemas operativos;

                    — Creación a partir de un proceso padre. En este caso, el proceso hijo es una
                      copia exacta del proceso padre. Esta variante es la que utiliza UNIX.
                    — Creación a partir de un archivo ejecutable. Esta modalidad es la que se define
                      en el API Win32 de Windows NT.

                   • Ejecutar un proceso. Los procesos pueden ejecutar de dos formas; batch e
                     interactiva. Un proceso que ejecuta en modo batch, también llamado background,
                     no está asociado a ningún terminal. Deberá tomar sus datos de entrada de un
                     archivo y deberá depositar sus resultados en otro archivo. Un ejemplo típico de un
                     proceso batch es un proceso de nóminas, que parte del archivo de empleados y
                     del chivo de los partes de trabajo y genera un archivo de órdenes básicas para
                     pagar las nóminas.
                          Por el contrario, un proceso que ejecuta en modo interactivo está asociado a
                     un terminal, por el que recibe la información del usuario y por el q e contesta con
                     los resultados. Un ejemplo típico de un proceso interactivo es un proceso de
                     edición.
                  • Terminar la ejecución de un proceso. Un proceso puede finalizar su ejecución
                     por varias causas, entre las que se encuentran las siguientes:

                   — Ha terminado de ejecutar el programa.
                   — Se produce una condición de error en su ejecución (p. ej.; división por O o
                     violación de memoria).
                   — Otro proceso o el usuario deciden que ha de terminar.

                  • Cambiar el programa de un proceso. Algunos sistemas operativos incluyen,
                    además de los anteriores, un servicio que cambia el programa que está ejecutando
                    un proceso por otro programa almacenado en disco, Observe que esta operación
                    no consiste en crear un nuevo proceso que ejecuta ese nuevo programa. Se trata
                    de eliminar el programa que está ejecutando el proceso y d incluir un nuevo
                    programa que se trae del disco.



2.5.    GESTIÓN DE MEMORIA

             El gestor de memoria es uno de los componentes principales del sistema operativo. Su
             actividad se centra fundamentalmente en la categoría de gestión de recursos, puesto que
             tiene por objetivo casi exclusivo la gestión del recurso memoria. En este sentido se
             encarga de:

                  • Asignar memoria a los procesos para crear su imagen de memoria.
                  • Proporcionar memoria a los procesos cuando la soliciten y liberarla cuando así lo
                    requieran.
                  • Tratar los posibles e ores de acceso a memoria, evitando que unos procesos
                    interfieran en la memoria de otros.
                  • Permitir que los procesos puedan compartir memoria entre ellos. De esta forma los
                    procesos podrán comunicarse entre ellos.
                  • Gestiona la jerarquía de memoria y tratar los fallos de página en los sistemas con
                    memoria virtual,

                  Además de estas funciones, el gestor de memoria, en la categoría de servicios a los
             programas, suministra los siguientes servicios: el de solicitar memoria, el de liberarla y el
             de permitir que los

                                                                  Introducción a los sistemas
operativos                                                        47

<!-- pág. 68 -->

         procesos compartan memoria. Los dos primeros servicios son necesarios para los
         programas que requieren asignación dinámica de memoria, puesto que, en este caso, la
         imagen de memoria ha de crecer o decrecer de acuerdo a las necesidades de ejecución.
         El tercer servicio es necesario cuando los procesos desean comp tir segmentos de
         memoria p a intercambi datos entre sí.


         2.5.1.     Servicios

         El gestor de memoria ofrece una serie de servicios a los procesos. Estos son;

            • Solicitar memoria. Este servicio aumenta el espacio de datos de la imagen de
              memoria del proceso. El sistema operativo satisf á la petición siempre y cuando
              cuente con los recursos necesarios para ello. En general, el sistema operativo
              devuelve un apuntador con la dirección de la nueva memoria. El programa utilizara
              este nuevo espacio a través del mencionado apuntador, mediante direccionamientos
              relativos al mismo.
            • Liberar memoria. Este servicio sirve para devolver trozos de la memoria del
              proceso. El sistema operativo recupera el recurso liberado y lo añade a sus listas de
              recursos libres, para su posterior reutilización (Advertencia 2.1),
            • Compartir memoria. Dentro de esta categoría, el gestor de memoria se encarga de
              ofrecer servicios que permiten que los procesos puedan comunicarse utilizando un
              segmento de memoria compartida. Para ello se permite que los procesos creen y
              liberen este tipo de segmentos.




              En el Capítulo 4 se estudiar los conceptos relativos a la gestión de memoria, los
         servicios ofrecidos por el gestor de memoria y las técnicas de gestión de memoria.



2.6. COMUNICACIÓN Y SINCRONIZACIÓN ENTRE PROCESOS

         Los procesos son entes independientes y aislados, puesto que, por razones de
         seguridad, no deben interferir unos con o os. Sin embargo, cuando se divide un trabajo
         complejo e varios procesos que

<!-- pág. 69 -->

48Sistemas operativos. Una visión aplicada




           Figura 2.9. Comunicación entre procesos locales y remoto,


           cooperan entre sí para realizar ese trabajo, es necesario que se comuniquen para
           transmitirse datos y órdenes y se sincronicen en la ejecución de sus acciones. Por tanto,
           el sistema operativo debe incluir servicios de comunicación y sincronización entre
           procesos que, sin romper los esquemas de seguridad, han de permitir la cooperación
           entre ellos.
                El sistema operativo ofrece una serie de mecanismos básicos de comunicación que
           permiten transferir cadenas de bytes, pero han de ser los procesos que se comunican los
           que han de interpretar la cadena de bytes transferida. En este sentido, se han de poner
           de acuerdo en la longitud de la información y en los tipos de datos utilizados.
           Dependiendo del servicio utilizado, la comunicación se limita a los procesos de una
           máquina (procesos locales) o puede involucrar a procesos de máquinas distintas
           (proceso. remotos). La Figura 2.9 muestra ambas situaciones.
                El sistema operativo ofrece también mecanismos que permiten que los procesos
           esperen (se bloqueen) y se despierten (continúen su ejecución) dependiendo de
           determinados eventos.



           2.6.1.   Servicios de comunicación y sincronización

           Como se ha visto anteriormente, existen distintos mecanismos de comunicación y
           sincronización, cada uno de los cuales se puede utilizar a través de un conjunto de
           servicios propios. Estos mecanismos son entidades vivas, cuya vida presenta las
           siguientes fases;

                • Creación del mecanismo.
                • Utilización del mecanismo.
                 • Destrucción del mecanismo,

               De acuerdo con esto, los servicios básicos de comunicación, que incluyen todos los
           mecanismos de comunicación, son los siguientes;

               •Crear. Permite que el proceso solicite la creación del mecanismo.
               • Enviar o escribir. Permite que el proceso emisor envíe información a otro.
               • Recibir o leer. Permite que el proceso receptor reciba información de otro,
               • Destruir. Permite que el proceso solicite la creación o destrucción del mecanismo.

                Por otro lado, la comunicación puede ser síncrona o asíncrona.

<!-- pág. 70 -->

                                                         Introducción a los sistemas operativos       49




         Figura 2.10. Comunicación síncrona entre procesos.


               En la comunicación síncrona los dos procesos han de ejecutar los servicios de
         comunicación al mismo tiempo, es decir, el emisor ha de estar en el servicio de enviar y el
         receptor ha de estar en el servicio de recibir, Normalmente, para que esto ocurra, uno de
         ellos ha de esperar a que el otro llegue a la ejecución del correspondiente servicio (Fig.
         2.10).
               En la comunicación asíncrona el emisor no tiene que esperar a que el receptor
         solicite el servicio recibir, hace el envío y sigue con la ejecución. Esto obliga a que el
         sistema operativo establezca un almacenamiento intermedio para guardar la información
         enviada hasta que el receptor la solicite,
               En cuanto a los mecanismos de sincronización, los mecanismos suelen incluir los
         siguientes servicios:

             •   Crear. Permite que el proceso solicite la creación del mecanismo.
             •   Bloquear. Permite que el proceso se bloquee hasta que ocurra un determinado
                 evento.
             •   Despertar. Permite despertar a un proceso bloqueado.
             •   Destruir. Permite que el proceso solicite la destrucción del mecanismo.

             En el Capítulo 5 se estudiarán en detalle los principales mecanismos de
         comunicación y sincronización que ofrecen los sistemas operativos así como sus servicios.



2.7. ESTIÓN DE LA E/S

         Una de las principales funciones de un sistema operativo es la gestión de los recursos de
         la computadora y, en concreto, de los dispositivos periféricos. El gestor de EIS debe
         controlar el funcionamiento de todos los dispositivos de E/S para alcanzar los siguientes
         objetivos:

             • Facilitar el manejo de los dispositivos periféricos. Para ello debe ofrecer una interfaz
               sencilla, uniforme y fácil de utilizar entre los dispositivos, y gestionar los errores que
               se pueden producir en el acceso a los mismos,
             • Ofrecer mecanismos de protección que impidan a los usuarios acceder sin control a
               los dispositivos periféricos.

               Dentro de la gestión de E/S, el sistema operativo debe encargarse de gestionar los
         distintos dispositivos de E/S; relojes, terminales, dispositivos de almacenamiento
         secundario y terciario, teclado, etc.

<!-- pág. 71 -->

50     Sistemas operativos. Una visión aplicada

        2.7.1. Servicios

           El sistema operativo ofrece a los usuarios una serie de servicio, de E/S independiente de
           los dispositivos, Esta independencia implica que deben emplearse los mismos servicios y
           operaciones de E/S para leer, por ejemplo, datos de un disquete, de un disco duro, de un
           CD-ROM o de un teclado, Los servicios de E/S están dirigidos básicamente a la lectura y
           escritura de datos. Estos servicios pueden estar orientados a caracteres, como ocurre
           con las impresoras o los terminales, o pueden estar orientados a bloques, como ocurre
           con las unidades de disco. El segundo caso se diferencia del primero en que la operación
           elemental de E/S se hace sobre un bloque de información de un número fijo de caracteres
           (p. ej.: sobre un bloque de 1 KB).
                 En general, los sistemas operativos consiguen la independencia en el acceso a los
           dispositivos modelándolos como archivos especiales. La gestión de chivos y sus servicios
           se describen en la siguiente sección.
                  En el Capítulo 7 se estudiará el software de E/S del sistema operativo, la gestión del
            almacenamiento secundario y terciario, de los relojes y terminales. También se
            presentarán los servicios de EIS que ofrecen los sistemas operativos.

2.8.   GESTIÓN DE ARCHIVOS Y DIRECTORIOS

           El servidor de archivos es la parte del sistema operativo que cubre una de las cuatro
           clases de funciones que tiene éste en su faceta de máquina extendida. Los objetivos
           fundamentales del servidor de archivos son los dos siguientes:

                • Facilitar el manejo de los dispositivos periféricos. Para ello ofrece una visión lógica
                   simplificada de los mismos en forma de chivos.
                 • Proteger a los usuarios, poniendo limitaciones a los chivos que es capaz de
                   manipular cada usuario.

                 Los servicios que se engloban en el servidor de archivos son de dos tipos: los
           servicios dirigidos al manejo de datos, o archivos, y los dirigidos al manejo de los
           nombres, o directorios.
                El servidor de archivos ofrece al usuario (Fig. 2.11) una visión lógica compuesta por
           una serie de objetos ( chivos y directorios) identificables por un nombre lógico sobre los
           que puede realiza una serie de operaciones. La visión física ha de incluir los detalles de
           cómo están almacenados estos objetos en los periféricos correspondientes (p. ej.: en los
           discos).

           2.8.1.    Servicio de archivos

           Un archivo es una unidad de almacenamiento lógico no volátil que agrupa un conjunto de
           información relacionada entre sí bajo un mismo nombre, Cada archivo tiene una
           información asociada que




           Figura 2.11. Visión lógica y física del sistema de archivos.

<!-- pág. 72 -->

                                                                Introducción a los sistemas operativos 51
             utilizan tanto los usuarios como e! propio servidor de archivos. Entre las informaciones
             más usuales se pueden destacar las siguientes.
         • Tipo de archivo (p, ej., archivo de datos, ejecutable, elc.).
         • Propietario del archivo (identificador de usuario que creó el archivo y del grupo de dicho
             usuario).
         • Tamaño del archivo. Este tamaño suele ser menor que el espacio de disco asignado al
           archivo, puesto que es muy raro que el último bloque se llene completamente. Por término
           medio queda sin usarse 1/2 bloque.
         • Instantes (fecha y hora) importantes de la v.ida del archivo, como son los siguientes:
             — Instante en que se creó.
             —   Instante de la última modificación.
             —   Instante del último acceso.
                Derechos de acceso al archivo (sólo lectura, lectura-escritura, sólo escritura,
                 ejecución,...).
Las operaciones sobre archivos que ofrece el servidor de chivos están referidas a la visión lógica de
los archivos, La solución más común es que el archivo se visualice como un vector de bytes o
caracteres, tal y como indica la Figura 2.12. Algunos sistemas de archivos ofrecen visiones lógicas
más elaboradas, orientadas a re que pueden ser de longitud fija o variable. La ventaja de la sencilla
visión de vector de caracteres es su flexibilidad, puesto que no presupone ninguna estructura
específica interna en el archivo.
La visión lógica del archivo incluye normalmente un puntero de posición Este puntero permite hacer
operaciones de lectura y escritura consecutivas sin tener que indicar la posición de la operación.
inicialmente el puntero indica la posición 0, pero después de hacer, por ejemplo, una operación de
lectura de 7.845 bytes señalará a la posición 7.845. Otra lectura posterior se referirá a los bytes
7.845, 7.846, etc,
La visión física está formada por los elementos físicos del periférico que soportan al archivo. En el
caso más usual de tratarse de discos, la visión física consiste en la enumeración ordenada de los
bloques de disco en los que reside el archivo (Aclaración 2.3). La Figura 2.13 muestra un ejemplo en
el que el archivo A está formado, en ese orden, por los bloques 12, 20, 1, 8, 3, 16 y 19.




Figura 2.12. Visión lógica del archivo.

<!-- pág. 73 -->

52 Sistemas operativos. Una visión aplicada




           Figura 213. Visión física del archivo.
                  Observe que debe existir una estructura de información que recoja la composición
           física cada archivo, que se denominará de forma genérica descripción física del archivo.
           Esta estructura es la FAT en MS-DOS y el nodo-i en UNIX Finalmente, es de destacar que
           estas estructuras de información han de residir en e propio periférico (p. ej.: disco), para
           que éste sea autocontenido y se pueda transportar de un sistema a otro.
                 El servidor de archivos es capaz de encontrar e interpretar estas estructuras de
           información liberando a los programas de usuario de esta tediosa labor
           Servicios de archivos
           Un archivo es una entidad viva, que va evolucionando de acuerdo a los servicios que se
           solicitan d sistema operativo. La Figura 2.14 resume las fases de esta vida.
           Los servicios que ofrece el servidor de archivos son los siguientes:
            Crear un archivo. Este servicio cerca un archivo vacío. La creación de un archivo
             exige una interpretación dcl nombre, puesto que el servidor de archivos ha de
             comprobar que el nombre es correcto y que el usuario puede hacer la operación
             solicitada. La creación de un archivo deja abierto a éste devolviendo al usuario un
             identificador, descriptor o manejador de archivo de carácter temporal para su
             manipulación.
            Abrir un archivo. Un archivo debe ser abierto antes de ser utilizado. Este servicio
             comprueba que el archivo existe, que el usuario tiene derechos de acceso y trae a
             memoria información del objeto para optimizar el acceso al mismo Además devuelve al
             usuario un identificador, descriptor o manejador de archivo de carácter temporal para
             su manipulación Normalmente, todos los sistemas operativos tienen un límite máximo
             para el número archivos que puede tener abierto un usuario.


                                Se crea el archivo
                                   Se abre: se genera un descriptor de archivo
                                   Se escribe y lee (el archivo puede crecer)
                        • Se cierra Se borra




Figura 2.14. Servicios y vida del archivo.

<!-- pág. 74 -->

                                                   Introducción a los sistemas operativos 53


   Escribir y leer. Estos servicios se realizan utilizando el identificador, descriptor o
    manejador de archivo (devuelto en las operaciones de creación y apertura), en vez del
    nombre lógico del mismo.
           Una operación de lectura permite traer datos del archivo a memoria. Para ello se
    especifica el identificador, descriptor o manejador obtenido en la apertura, la posición
    de memoria y la cantidad de información a leer. Normalmente, se lee a partir de la
    posición que indica el puntero de posición del archivo, Las operaciones de escritura
    permiten llevar datos situados en memoria al archivo. Para ello, y al igual que en las
    operaciones de lectura, se debe especificar el identificador obtenido en la creación o
    apertura, la posición de memoria y la cantidad de información a escribir, Normalmente
    se escribe a partir de La posición que indica el puntero de posición del archivo. Si está
    en medio, se sobrescribirán los datos, Si está al final del archivo, su tamaño crece. En
    este caso, el sistema operativo se encarga de hacer crecer el espacio físico del archivo
    añadiendo bloques libres.
    En algunos sistemas operativos se puede especificar la posición del archivo en la que
    se realizará la siguiente lectura o escritura.
    • Cerrar un archivo. Terminada la utilización del archivo se debe cerrar, con lo que se
    elimina el identificador temporal obtenido en la apertura o creación y se liberan los
    recursos de memoria que ocupa el archivo,
    • Borrar un archivo. El archivo se puede borrar, lo que supone que se borra su
    nombre del correspondiente directorio y que el sistema de archivos ha de recuperar los
    bloques de datos y el espacio de metainformación que tenía asignado (Aclaración 2.4).




2.8.2. Servicio de directorios
Un directorio es un objeto que relaciona de forma unívoca un nombre con un archivo. El
servicio de directorios sirve para identificar a los archivos (objetos), por tanto ha de
garantizar que la relación [nombre — > archivo] sea unívoca. Es decir, un mismo nombre
no puede identificar a dos archivos. Observe, por el contrario, que el que vados nombres
se refieran al mismo archivo no presenta ningún problema, son simples sinónimos.
       El servicio de directorios también presenta una visión lógica y una visión física. La
visión lógica consiste en el bien conocido esquema jerárquico de nombres mostrado en la
Figura 2.15.
       Se denomina directorio raíz al primer directorio de la jerarquía, recibiendo los
demás el nombre de subdirectorios. El directorio raíz se representa por el carácter (“/ ” o “
”,dependiendo del sistema operativo. En la Figura 2.15, el directorio raíz incluye los
 siguientes nombres de subdirectorios: Textos, Div11 y Div2,
       Se diferencia el nombre relativo o local, que es el nombre asignando al archivo
dentro del subdirectorio en el que está el archivo, del nombre o camino absoluto, que
incluye todos los nombres de todos los subdirectorios que hay que recorrer desde el
directorio raíz hasta el objeto considerado, concatenados por el símbolo “/” o ““.Un ejemplo
del nombre relativo es “Ap11 “, mientras que su nombre absoluto es
“/Textos/Tipo/Sec1/Ap11”.

<!-- pág. 75 -->

54   Sistemas operativos. Una visión aplicada




     Figura2.15. Esquema jerárquico de directorios


            La ventaja del esquema jerárquico es que permite una gestión distribuida de los
     nombres, garantizar de forma sencilla que no exista nombres repetidos. En efecto, hasta
     con que los nombres relativos de cada. subdirectorio sean distintos, aunque los nombres
     relativos de subdirectorios distintos sean iguales, para que no exista duplicación de
     nombres, puesto que quedarán diferencia dos por el camino hasta llegar al
     correspondiente subdirectorio.
            La visión física del sistema de directorios consiste en unas estructuras de
     información que permiten relacionar cada nombre lógico con la descripción física del
     correspondiente archivo. En esencia, se trata de una tabla NOMBRE- IDENTIFICADOR
     por cada subdirectorio. El NOMBRE no es mas que el nombre relativo del archivo,
     mientras que el.DIENTIFICADOR es una información que permite localizar la descripción
     física del archivo.
     Servicios de directorios
     Un objeto directorio es básicamente un conjunto de entradas que relacionan nombres y
     archivos El servidor de archivos incluye una serie de servicios que permiten manipular
     directorios. Estos son.:
           Crear un directorio. Crea un objeto directorio y lo sitúa en el árbol de directorios
            donde se especifique en el nombre, absoluto o relativo, del nuevo directorio.
           Borrar un directorio. Elimina un objeto directorio de forma que nunca más pueda
            accesible y borra su entrada del árbol de directorios. Normalmente, sólo se puede
            borrar directorio vacío, es decir, un directorio sin entradas.
           Abrir un directorio. Abre un directorio para leer los datos del mismo. Al igual que
            un chivo, un directorio debe ser abierto para poder acceder a. su contenido. Esta
            operación vuelve al usuario un identificador, descriptor o manejador de directorio
            de carácter temporal que permite su manipulación.
           Leer un directorio. Extrae la siguiente entrada de un directorio, abierto
            previamente. Devuelve una estructura de datos como la que define la entrada de
            directorios
           Cerrar un directorio. Cierra un directorio, liberando el identificador devuelto en la
            operación de apertura, así como los recursos de memoria y del sistema operativo
            relativos al mismo.

<!-- pág. 76 -->

                                                        Introducción a los sistemas operativos   55
        2.8.3. Sistema de archivos
        Se denomina sistema de archivos al conjunto de archivos incluidos en una unidad de
        disco. El sistema de archivos está compuesto por los datos de los archivos, así como por
        toda la información auxiliar que se requiere.
              Se denomina rnetainformación a toda la información auxiliar que es necesario
        mantener en un volumen. Resumiendo y completando lo visto en las secciones anteriores,
        la metainformación está compuesta por los siguientes elementos:
            • Estructura física de los archivos (nodos-i de UNIX o FAT de MS-DOS)
            • Directorios (archivos que contienen las tablas nombre-puntero).
            • Estructura física del sistema de archivos (superbloque en UNIX).
             Estructura de información de bloques y nodos-i libres (mapas de bits).
               Cada sistema operativo organiza las particiones de disco de una determinada forma,
        repartiendo el espacio disponible entre: el programa de carga (boot) del sistema operativo,
        la metainforinación y los datos. Normalmente, las tablas de los subdirectorios se
        almacenan como archivos, por lo que compiten por los bloques de datos con los archivos
        de datos.
              En el Capítulo 8 se estudiará en detalle la gestión de archivos y directorios,
        presentando los conceptos, los servicios y los principales aspectos de implementación.


2.9. SEGURIDAD Y PROTECCIÓN
.
        La seguridad, reviste dos aspectos, uno es garantizar la identidad de los usuarios y otro es
        definir lo que puede hacer cada uno de ellos, El primer aspecto se trata bajo el término de
        autenticación, mientras que el segundo se hace mediante los privilegios. La seguridad es
        una de las funciones del sistema operativo que, para llevarla a cabo, se ha de basar en los
        mecanismos de protección que le proporciona e hardware.
        Autenticación
        El objetivo de la autenticación es determinar que un usuario (persona, servicio o
        computadora) es quien dice ser. El sistema operativo dispone de un módulo de
        autenticación que se encarga de decidir la identidad de los usuarios. En la actualidad, las
        contraseñas (passwords) son el método más utilizado como mecanismo de autenticación.
        En el Capítulo 9 se verán otras formas de autenticación.
        Privilegios
        Los privilegios especifican los recursos que puede acceder cada usuario. Para simplificar
        la información de privilegios es corriente organizar a los usuarios en grupos, asignando
        determinados privilegios a cada grupo.
        La información de los privilegios se puede asociar a los recursos o a los usuarios.
              • Información por recurso. En este caso se asocia la denominada lista de control
                de acceso (ACL, access control list) a cada recurso. Esta lista especifica los
                grupos y usuarios que pueden acceder al recurso.
              • Información por usuario. Se asocia a cada usuario o grupo la lisia de recursos
                que puede acceder, lista que se llama de capacidades (capabilities).

<!-- pág. 77 -->

   56 Sistemas operativos, Una visión aplicada


                Dado que hay muchas formas de utilizar un recurso, la lista de control de acceso, o
         la de capacidades, han de incluir el modo en que se puede utilizar el recurso Ejemplos de
         modos de utilización son los siguientes: leer, escribir, ejecutar, eliminar, test, control y
         administrar.
               Los servicios relacionados con la seguridad y la protección se centran en la
         capacidad para asignar atributos de seguridad a los usuarios y a los recursos.
               En el Capítulo 9 se describirán todos los aspectos relacionados con la seguridad y la
         protección y se presentarán los principales servicios.


2.10. ACTIVACIÓN DEL SISTEMA OPERATIVO
         Una vez presentadas las funciones y principales componentes del sistema operativo, es
         importante describir cuáles son las acciones que activan la ejecución del mismo,
                El sistema operativo es un servidor que está a la espera de que se le encargue
         trabajo. La secuencia normal es la mostrada en la Figura 2,16. Está ejecutando un proceso
         Ay, en un instante determinado, se solicita la atención del sistema operativo. Éste entra en
         ejecución y salva el estado en el bloque de control del proceso A. Seguidamente realiza la
         tarea solicitada. Una vez finalizada esta tarea, entra en acción el planificador, módulo del
         sistema operativo que selecciona un proceso B para ejecutar. La actuación del sistema
         operativo finaliza con el activador, módulo que se encarga de restituir los registros con los
         valores almacenados en el bloque de control dc proceso 13. instante en el que se restituye
         el contador de programa marca la transición del sistema operativo. ejecución del proceso
         B.
                El trabajo del sistema operativo puede provenir de las siguientes fuentes:
                • Llamadas al sistema emitidas por los programas.
                 Interrupción producida por los periféricos.
                • Condiciones de excepción o error del hardware.
               En todos estos casos se deja de ejecutar el proceso en ejecución y se entra a
         ejecutar el sistema operativo se vio en el Capítulo 1, los mecanismos para romper la
         sentencia lineal de ejecución son dos: las instrucciones de bifurcación y las interrupciones.
                El primero de estos dos mecanismos no sirve para invocar al sistema operativo,
         puesto que el proceso ejecuta en nivel de usuario y el sistema operativo ha de ejecutar en
         nivel de núcleo y espacios de direcciones distintos. Esto significa que los servicios del
         sistema operativo no se pueden solicitar mediante una instrucción máquina CALL, o lo que
         es lo mismo, mediante una llamada a procedimiento o función.




         Figura 2.16. Fases en la activación del sistema operativo.

<!-- pág. 78 -->

                                                 Introducción a los sistemas operativos    57
       Por tanto, la activación del sistema operativo solamente se realiza mediante el
mecanismo de las interrupciones. Cuando es un proceso en ejecución el que desea un
servicio del sistema operativo ha de utilizar una instrucción TRAP, que genera la
interrupción pertinente. En los demás casos será una interrupción, interna o externa, la
que reclame la atención del sistema operativo.
       Cuando se programa en un lenguaje de alto nivel, como C, la solicitud de un servicio
del sistema operativo se hace mediante una llamada a una función (p. ej.: u = fork ())
(Aclaración 2.5). No hay que confundir esta llamada con el servicio del sistema operativo.
La función fork del lenguaje C no realiza el servicio fork, simplemente se limita a solicitar
este servicio del sistema operativo. En general estas función solicitan los servicios del
sistema operativo se componen de:
   • Una parte inicial que prepara los parámetros del servicio de acuerdo con la forma en
     que los espera el sistema operativo.
   • La instrucción TRAP que realiza el paso al sistema operativo.
   • Una parte final que recupera los parámetros de contestación del sistema operativo,
     para devolverlos al programa que le llamó.




      Todo este conjunto de funciones se encuentran en una biblioteca del sistema y se
incluyen en el código en el momento de su carga en memoria.
      Para completar la imagen de que se está llamando a una función, el sistema
operativo devuelve un valor, como una función real. Al programador le parece, por tanto,
que invoca al sistema operativo como a una función. Sin embargo, esto no es así, puesto
que lo que hace es invocar una función que realiza la solicitud al sistema operativo. El
siguiente código muestra una hipotética implementación de la llamada al sistema fork.
       int fork() {
          int r;
          LOAD R8, FORK_SYSTEM_CALL
          TRAP
          LOAD r, R9
          return(r);
   }
       El código anterior carga en uno de los registros de la computadora (el registro RS
por ejemplo) el número que identifica la llamada al sistema (en este caso
FORK_SYSTEM_CALL). En el caso de que la llamada incluyera parámetros, éstos se
pasarían en otros registros o en la. pila. A continuación, la función de biblioteca ejecuta la
instrucción TPAP, con lo que se transfiere el control al sistema operativo, que accede al
contenido del registro R8 para identificar la llamada a ejecutar y realizar el trabajo. Cuando
el control se transfiere de nuevo al proceso que invocó la llamada fork, se accede al
registro R9 para obtener el valor devuelto por la llamada y éste se retorna, finalizando así
la ejecución de la función de biblioteca.
      La Figura 2.17 muestra todos los pasos involucrados en una llamada fork() al
sistema operativo, indicando el código que interviene en cada uno de ellos.

<!-- pág. 79 -->

58 Sistemas operativos. Una visión aplicada




          Figura 2.17. Pasos de la llamada al sistema operativo.


                 Por ejemplo, si el programa quiere escribir datos en un archivo, el código del
          programa usuario hace un CALL a la rutina en código máquina write, con código similar al
          mostrado anteriormente para la llamada. fork, Esta rutina prepara los parámetros de la
          operación de escritura C ejecuta la instrucción TRAP. El sistema operativo trata la
          interrupción, identifica que se trata de una solicitud de servicio y que el servicio solicitado
          es la escritura en un archivo. Seguidamente ejecutan, la rutina que lanza la pertinente
          operación de E/S. Finalmente, ejecuta e planificador y el activador para dar paso a la
          ejecución de otro proceso.
                 Cuando el periférico termina la operación, su controlador genera una solicitud de
          interrupción que es tratada por el sistema operativo. Como resultado de la misma, el
          proceso anterior pasará a estar listo para ejecución. En su momento, se seleccionará este
          proceso para que ejecute En su momento la rutina en código máquina write recibe los
          parámetros que ha devuelto el sistema operativo y ejecuta un RET para volver al programa
          de usuario que la llamó.
                 En este libro emplearemos el lenguaje C para ilustrar los ejemplos de invocación de
          servicios del sistema operativo. Aunque desde el C se estará llamando a funciones, no hay
          que olvidar que lo único que hace la función invocada es llamar al sistema operativo, que...
          es quien hace el trabajo.

<!-- pág. 80 -->

                                                 Introducción a los sistemas operativos           59
2.11.   INTERFAZ DEL PROGRAMADOR
          La interfaz del sistema operativo con el programador es la que recupera los servicios y
          llamadas al sistema que los usuarios pueden utilizar directamente desde sus programas.
          Esta es, quizá, una de las partes más importantes de un sistema operativo, ya que
          recupera la visión que corno máquina extendida tiene el usuario de sistema operativo. En
          este libro se van a estudiar dos de las interfaces más utilizadas en la actualidad: POSIX y
          los servicios de Win32.
          2.11. POSIX
          POSIX [IEEE96] es el estándar de interfaz de sistemas operativos potables de 1EEE
          basado en el sistema operativo UNIX. Aunque UNIX era prácticamente un estándar
          industrial, había bastantes, diferencias entre las distintas implementaciones de UNIX, lo
          que provocaba que las aplicaciones no se pudieran transportar fácilmente entre distintas
          plataformas UNIX. Este problema motivó a los implementadores y usuarios a desarrollar
          un estándar internacional con el propósito de conseguir la portabilidad de las aplicaciones
          en cuanto a código fuente.
          POSIX se ha desarrollado dentro de IEEE con la. referencia 1003 y también está siendo
          desarrollado corno estándar internacional con la referencia 1SO/ 9945.
          POSIX es una familia de estándares (Aclaración 2.6) en evolución, cada uno de tos cuales
          cubre diferentes aspectos de los sistemas operativos. Algunos de estos estándares ya han
          sido aprobados, mientras que otros están todavía en 6ise de desarrollo. POSIX incluye
          servicios de sistema operativo para muchos entornas de aplicación. La Tabla 2.1 lista
          algunos de los estándares básicos de POSIX.
          POSIX es una interfaz ampliamente utilizada. Se encuentra disponible en todas las
          versiones de Unix y Linux. También Windows NT ofrece un subsistema que permite
          programar aplicaciones POSIX

<!-- pág. 81 -->

60   Sistemas operativos. Una visión aplicada
       Algunas de las características de POSIX son:
        Algunos tipos de datos utilizados por las funciones no se definen como parle del
         estándar, pero se definen como parte de la implementación. Estos tipos se encuentran
         definidos en el archivo de cabecera. <sys/tipes-i>. Estos tipos acaban con el sufijo_t.
         Por ejemplo uid_t es el tipo que se emplea para almacenar un identificador de usuario.
        Los nombres de las funciones en POSIX son en general cortos y con todos sus letras
         en minúsculas Ejemplos de funciones en POSIX son:
        Las funciones, normalmente, devuelven cero si se ejecutaron con éxito 0-l en caso de
         error; Cuando una función devuelve -1, se almacena en una variable global,
         denominada errno,. el código de error. Este código de error es un valor entero. La
         variable errno se encuentra definida en el archivo de cabecera <errno . h>.
        La mayoría de los recursos gestionados por el sistema operativo se reverencian
         mediante descriptores. Un descriptor es un número entero mayor o igual que cero.
       2.1l . Win32
       Win32 define los servicios ofrecidos por los sistemas Windows 95/98, Windows NT y
       Windows 2000. En este caso no se trata de un estándar genérico, sino de los servicios
       establecido por una casa comercial determinada (Microsoft).
              El API de Win32 es totalmente diferente al estándar POSIX. A continuación, se
       citan ah de las principales características de Win32 [Hart, 1998]:
        Prácticamente todos los recursos gestionados por el sistema operativo se tratan como
         objetos, que se reverencian por medio de manejadores. Estos manejadores son
         similares a los descriptores de archivos de POSIX. Aunque sigue los principios de la
         programación orienta da a objetos, Win32 no es orientado a objetos.
        Los nombres de las funciones en Win32 son largos y descriptivos, a diferencia de
         ocurre en POSIX Ejemplos de funciones en Win32 son
            —- GetFileAttributes, para obtener los atributos de un archivo.
            — CreateNarnedpipe, para crear una tubería con nombre.
        Win32 tiene una, se de tipos de datos predefinidos, por ejemplo:
                  — Bool, objeto de 32 bits que almacena un valor lógico.
                   — DWCRD, entejo sin signo de 32 bits.
                   — TCHAP, tipo carácter de dos bytes. LPSTR, puntero a una cadena de
                 caracteres.
         Los tipos predefinidos en Win32 evitan el uso del operador de indirección de C (*), Así,
           ejemplo, LPSTR está definido corno *TCHAR
            Los nombres de las variables, al menos en los prototipos de las funciones, también
             siguen una serie de convenciones. Por ejemplo, lpszFileName representa un puntero
             largo a cadena de caracteres terminada por el carácter nulo.

<!-- pág. 82 -->

                                                         Introducción a los sistemas operativos   61
          En Win32, las funciones devuelven, en general, true si la llamada se ejecutó con éxito
           o false en caso contrario.
               Aunque Win32 incluye muchas funciones, las cuales tienen en muchos casos
        numerosos parámetros (muchos de los cuales normalmente no se utilizan), este libro se va
        a centrar en las funciones más importantes del API. Además, Win32 define funciones y
        servicios gráficos que no serán trata dos en este libro,
2.12. INTERFAZ DE USUARIO DEL SISTEMA OPERATIVO
        Cuando un usuario trabaja con una computadora necesita poder interactuar con el sistema
        operativo para poder llevar a cabo operaciones tales como ejecutar un programa o borrar
        un archivo, sin necesidad de escribir un programa que realice dicha operación utilizando
        los servicios del sistema operativo.
        El sistema operativo, por tanto, además de dotar de servicios (llamadas al sistema) a las
        aplicaciones, debe proporcionar una interfaz de usuario que permita dar instrucciones al
        sistema para realizar diversas operaciones. Sin esta interfaz, aunque el sistema operativo
        estuviese listo para dar servicio a las aplicaciones, el usuario no podría. arrancar ninguna.
              Hay que tener en cuenta que la mayoría de la gente que trabaja con un sistema
        informático no pretende realizar ninguna tarea de programación, sino que, simplemente,
        quiere trabajar en modo interactivo con el mismo. Por tanto, no tendría sentido que los
        usuarios tuvieran que realizar un programa para poder sacar partido de los servicios del
        sistema operativo a la hora de realizar una determinada labor (como, por ejemplo, borrar
        un archivo). El sistema operativo ofrece, a través de su interfaz de usuario, un conjunto de
        operaciones típicas, que son las que necesitan llevar a cabo los usuarios con más
        frecuencia, Así, para borrar un archivo, en vez de tener que realizar un programa, el
        usuario sólo tendrá que teclear un mandato (rm en UNIX o del en MS-DOS) o, en el caso
        de una interfaz gráfica, manipular un icono que representa al archivo.
                La interfaz de usuario de tos sistemas operativos, al igual que la de cualquier otro
        tipo de aplicación, ha sufrido una gran. evolución. Esta evolución ha venido condicionada,
        en gran parte, por la enorme difusión del uso de las computadoras, que ha tenido como
        consecuencia que un gran número de usuarios sin conocimientos informáticos trabajen
        cotidianamente con ellas. Se ha pasado de interfaces alfanuméricas, que requerían un
        conocimiento bastante profundo del funcionamiento de la computadora a interfaces
        gráficas, que ocultan al usuario la complejidad del sistema. proporcionándole una visión
        intuitiva del mismo.
               Ha existido también una evolución en la integración de la interfaz de usuario con el
        resto del sistema operativo. Se ha. pasado de sistemas en los que el módulo que maneja
        la interfaz de usuario estaba dentro del núcleo del sistema operativo (la parte del mismo
        que ejecuta en modo privilegiado) a sistemas en los que esta función es realizada por un
        conjunto de programas externos al núcleo que ejecutan en modo no privilegiado y usan los
        servicios del sistema operativo como cualquier otro programa. Esta estrategia de diseño
        proporciona una gran flexibilidad, pudiendo permitir que cada usuario utilice un programa
        de interfaz que se ajuste a sus preferencias o que, incluso, cree uno propio. EL sistema
        operativo, por tanto, se caracteriza principalmente por los servicios que proporciona y no
        por su interfaz que, al fin y al cabo, puede ser diferente para los distintos usuarios,
             Dado que no se va a estudiar este aspecto en el resto del libro, a continuación se
        comenta las principales funciones de la interfaz de usuario de un sistema operativo.

<!-- pág. 83 -->

62 Sistemas operativos. Una visión aplicada
            2.12.1 Funciones de la interfaz de usuario
            La principal misión de la interfaz, sea del tipo que sea, es permitir al usuario acceder y
            manipular Y los objetos y recursos del sistema En esta sección se presentaran de forma
            genérica cuáles son las operaciones que típicamente ofrece el sistema operativo a sus
            usuarios, con independencia de cómo Y lleven éstos a c’abo el diálogo con el mismo.
                  A la hora de realizar esta enumeración, surge una cuestión sobre la que no hay un
            acuerdo Y. general: ¿cuáles de los programas que hay en un determinado sistema se
            consideran parte de la interfaz del sistema y cuáles no? ¿Un compilador es parte de la
            interfaz de usuario del sistema operativo? ¿Y un navegador Web?
                 Una alternativa sería considerar que forman parte de la interfaz del sistema todos
            los programas que se incluyen durante la instalación del sistema operativo y dejar fuera
            de dicha categoría a los programas que se instalan posteriormente. Sin embargo, no hay
            un criterio único ya que diferentes fabricantes siguen políticas distintas. Por ejemplo,
            algunos sistemas incluyen uno o más compiladores de lenguajes de alto nivel, mientras
            que otros no lo hacen. Prueba de esta confusión es el Y contencioso legal al que se
            enfrenta Microsoft sobre si el navegador Web debe formar parte de su Y sistema
            operativo o no.
                 En. la clasificación que se plantea a continuación se han seleccionado aquellas
            funciones sobre las que parece que hay un consenso general en cuanto a que forman
            parte de la interfaz del sistema. Se han distinguido las siguientes categorías:
               • Manipulación de archivos y directorios. La interfaz debe proporcionar operaciones
                 para crear, borrar, renombrar y, en general, procesar archivos y directorios.
               • Ejecución de programas. El usuario tiene que poder ejecutar programas y controlar
                 la ejecución de Los mismos (p, ej.: parar temporalmente su ejecución o terminarla
                 incondicional mente).
               • Herramientas para el desarrollo de las aplicaciones. El usuario debe disponer de
                 utilidades, tales como ensambladores, enlazadores y depuradores, para construir
                 sus propias aplicaciones. Observe que se han dejado fuera de esta categoría a los
                 compiladores, por los motivos antes expuestos.
               • Comunicación con otros sistemas. Existirán herramientas para acceder a recursos
                 localizados en. otros sistemas accesibles a través de una red. de conexión. En esta
                 categoría se consideran herramientas básicas, tales como ftp y telnet (Aclaración
                 2.7), dejando fuera aplicaciones de más alto nivel como un navegador Web.
               • Información de estado del sistema. El usuario dispondrá de utilidades para obtener
                 informaciones tales como la fecha, la hora, el numero de usuarios que están
                 trabajando en el sistema o la cantidad de memoria disponible.
               • Configuración de la propia interfaz y del entorno. Cada usuario tiene que poder
                 configurar el modo de operación de la interfaz (le acuerdo a sus preferencias. Un
                 ejemplo sería la configuración de los aspectos relacionados con las características
                 específicas del entorno geográfico Y del usuario (lenguaje, formato de fechas y de
                 cantidades de dinero, etc.). La flexibilidad de Y configuración de la interfaz será una
                 de las medidas que exprese su calidad.
               • Intercambio de datos entre aplicaciones. El usuario va a disponer de mecanismos
                 que le permitan especificar que, por ejemplo, una aplicación utilice los datos que
                 genera otra.
               • Control de acceso. En sistemas multiusuario, la interfaz debe encargarse de
                  controlar el acceso de los usuarios al sistema para mantener la seguridad del.
                  mismo.

<!-- pág. 84 -->

                                                Introducción a los sistemas operativos 63


    • Normalmente, el mecanismo de control estará basado en que cada usuario
      autorizado tenga una contraseña que deba introducir para acceder al sistema.
    • Otras utilidades y herramientas. Para no extender innecesariamente la
     clasificación, se han agrupado en esta sección utilidades misceláneas tales corno
     calculadoras o agendas.
    • Sistema de ayuda interactivo, La interfaz debe incluir un completo entono de ayuda
      que ponga a disposición de usuario toda la documentación del sistema.




      Para concluir esta sección, es importante resaltar que en un sistema, además de las
interfaces disponibles para los usuarios normales, pueden existir otras específicas
destinadas a los administradores del sistema. Más aún, el propio programa (residente
normalmente en ROM) que se encarga de la carga del sistema operativo proporciona
generalmente una interfaz de usuario muy simplificada y rígida que permite al
administrador realizar operaciones tales como pruebas y diagnósticos del hardware o la
modificación de los parámetros almacenados en la memoria RAM no volátil de la
máquina que controlan características de bajo nivel del sistema.
2.12.2. interfaces alfanuméricas
     La característica principal de este tipo de interfaces es su modo de trabajo basado
en líneas de texto. El usuario, par dar instrucciones al sistema, escribe en su terminal un
mandato terminado con un carácter de final de línea. Cada mandato está normalmente
estructurado corno un nombre de mandato (p. ej.: borrar) y unos argumentos (p. ej.: el.
nombre del archivo que se quiere borrar). Observe que en algunos sistemas se permite
que se introduzcan varios mandatos en una línea. El intérprete de mandatos, que es
como se denomina típicamente al módulo encargado de la interfaz, lee la línea escrita
por el usuario y lleva a cabo las acciones especificadas por la misma. Una vez
realizadas, el intérprete escribe una indicación (prompt) en el terminal para notificar al
usuario que está listo para recibir otro mandato. Este ciclo repetitivo define el modo de
operación de este tipo de interfaces, El usuario tendrá disponibles un conjunto de
mandatos que le permitirán realizar actividades tales como manipular archivos y
directorios, controlar la ejecución de los programas, desarrollar aplicaciones,
comunicarse con otros sistemas, obtener información del estado del sistema o acceder al
sistema. de ayuda interactivo.
     Esta forma de operar, basada en líneas de texto, viene condicionada en parte por el
tipo de dispositivo que se usaba como terminal en los primeros sistemas de tiempo
compartido. Se trataba de teletipos que imprimían la salida en papel y que, por tanto,
tenían intrínsecamente UI) funciona miento basado en líneas. La disponibilidad posterior
de terminales más sofisticados que, aunque seguían siendo de carácter alfanumérico,
usaban una pantalla para mostrar la información y ofrecían, por tanto, la posibilidad de
trabajar con toda la. pantalla no cambió, sin embargo, la forma de trabajo de la interfaz
que continuó siendo en modo línea, Como reflejo de esta herencia, obsérvese que en el
mundo UNIX se usa el término tty (abreviatura de teletype) para referirse a un terminal,
aunque no tenga nada que ver con los primitivos teletipos. Observe que, sin embargo,
muchas aplicaciones sí que se aprovecharon del. modo de trabajo en modo pantalla.
Como ejemplo, se puede

<!-- pág. 85 -->

64 Sistemas operativos. Una visión aplicada
            observar la evolución de los editores en UNIX: se pasó de editores en modo línea como
            el ed a editores orientados a pantalla como el vi y el emars.
                  A pesar de que el modo de operación básico apenas ha cambiado, Su estructura e
            implementación han evolucionado notablemente desde la aparición de los primeros
            sistemas de tiempo compartido hasta la actualidad. Como ya se ha comentado
            anteriormente, se pasó de tener el intérprete incluido en el sistema operativo a su un
            módulo externo que usa los servicios del mismo, lo proporciona una mayor flexibilidad
            facilitando su modificación o incluso su reemplazo. Dentro esta opción existen
            básicamente dos formas de esturar el módulo que maneja la interfaz de usuario
            intérprete con mandatos internos e interprete con mandatos externos
            Intérprete con mandatos internos
            El intérprete de mandatos es un único programa que contiene el código para e todos los
            mandatos. El intérprete, después de leer la línea tecleada por el usuario, determina de
            qué mandato se trata y salta a la parle (le su código que lleva a cabo la acción
            especificada por el mandato. Si no se trata de ningún mandato, se interpreta que el
            usuario quiere arrancar una determinada aplicación, en cuyo caso el intérprete iniciará la
            ejecución del programa correspondiente en el contexto de un nuevo proceso y esperará
            hasta que termine. Con esta estrategia, mostrada en el Programa 21, los mandatos son
            internos al intérprete. Obsérvese que en esta sección se está suponiendo que hay un
            único mandato en cada línea.
            _______________________________________________________________________
            _
            Programa 2.1. Esquema de un intérprete con mandatos internos.
                 Repetir Bucle
                    Escribir indicación de preparado
                    Leer e interpretar línea -> Obtiene operación y argumentos
                    Caso operación
                        Si “ fin”
                            Terminar ejecución de intérprete /
                        Si “renombrar”
                            Renombrar archivos según especifican argumentos
                        Si “borrar”
                            Borrar archivos especificados por argumentos
                        Si no (No se trata de un mandato)
                            Arrancar programa “operación” pasándole “argumentos”
                            Esperar a que termine el programa
                 Fin Bucle
                 ___________________________________________________________________
                 _
            Intérprete con mandatos externos
            Existe un programa por cada mandato. El intérprete de mandatos no analiza la línea
            tecleada por el usuario, sino que directamente inicia la ejecución del programa
            correspondiente en el contexto de un nuevo proceso y espera que éste termine. Se
            realiza un mismo tratamiento ya se trate de un mandato o de cualquier otra aplicación.
            Con esta estrategia, mostrada en el Programa 2.2, los mandatos son externos al
            intérprete y la interfaz de usuario está compuesta por un conjunto de programas del
            sistema: un programa por cada mandato más el propio intérprete.

<!-- pág. 86 -->

                                                             Introducción a os sistemas operativos 65
 _________________________________________________________________________________
                                                                                                    _
           Programa 22, Esquema de un intérprete con mandatos externos.
              Repetir Bucle
                   Escribir indicación de preparado
                   Leer e interpretar línea —> Obtiene operación y argumentos
                        Si operación = “fin”
                              Terminar ejecución de intérprete
                        Si no
                            Arrancar programa “operación” pasándole“argumentos”
                            Esperar a que termine el programa
              Fin Bucle
_________________________________________________________________________________
_
                  La principal ventaja de la primera estrategia es la eficiencia, ya que los mandatos los
           lleva a cabo el propio intérprete sin necesidad de ejecutar programas adicionales. Sin.
           embargo, el intérprete puede llegar a ser muy grande y la inclusión de un nuevo mandato,
           o la modificación de uno existente, exige cambiar el código del intérprete y recompilarlo. La
           segunda solución es más recomendable ya que proporciona un tratamiento y visión
           uniforme de los mandatos del sistema y las restantes aplicaciones. El intérprete no se ve
           afectado por la inclusión o la modificación de un mandato.
                  En los sistemas reales puede existir tina mezcla de las dos estrategias. El intérprete
           de manda tos de MS-DOS (COMMAND. COM )se enmarca dentro de la primera categoría,
           esto es, intérprete con mandatos internos. El motivo de esta estrategia se debe a que este
           sistema operativo se diseñó para poder usarse en computadoras sin disco duro y, en este
           tipo de sistemas, el uso de un intérprete con mandatos externos exigiría que el disquete
           correspondiente estuviese insertado para ejecutar un determinado mandato. Sin embargo,
           dadas las limitaciones de memoria de MS-DOS, para mantener el tamaño del intérprete
           dentro de un valor razonable, algunos mandatos de uso poco frecuente, como por ejemplo
           DISKCOPY, están implementados como externos.
                  Los intérpretes de mandatos de UNIX, denominados shells, se engloban en la
           categoría de intérpretes con mandatos externos. Sin embargo, algunos mandatos se
           tienen que implementar como internos debido a que su efecto sólo puede lograrse si es el
           propio intérprete el que ejecuta el mandato. Así, por ejemplo, el mandato cd, que cambia el
           directorio actual de trabajo del usuario usando la llamada chdir, requiere cambiar a su vez
           el directorio actual de trabajo del proceso que ejecuta el intérprete, lo cual sólo puede
           conseguirse si el mandato lo ejecuta directamente el intérprete.
           2.12.3. Interfaces gráficas
           El auge de las interfaces gráficas de usuario (GUI, Graphical UserInterface) se debe
           principalmente a la necesidad de proporcionar a los usuarios no especializados una visión
           sencilla e intuitiva del sistema que oculte toda su complejidad. Esta necesidad ha surgido
           por la enorme difusión de las computadoras en todos los ámbitos de la vida cotidiana Sin
           embargo, el desarrollo de este tipo de interfaces más amigables ha requerido un avance
           considerable en la potencia y capacidad gráfica de las computadoras dada la gran
           cantidad de recursos que consumen durante su operación.
                 Las primer experiencias con este tipo de interfaces se remontan a Los primeros
           años de la década de los setenta. En Xerox PARC (un centro de investigación de Xerox)
           se desarrolló lo que actualmente se considera la primera estación de trabajo a. la que se
           denominó Alto. Además de otros muchos avances, esta investigación estableció los
           primeros pasos en el campo de los GUI.

<!-- pág. 87 -->

66     Sistemas operativos. Una visión aplicada
                 Con la aparición, a principios de los ochenta, de las computadoras personales
           dirigidas a usuarios no especializados se acentuó la necesidad de proporcionar este tipo
           de interfaces. Así la compañía Apple adopto muchas de las ideas de la investigación de
           Xerox PARC para lanzar su computadora personal [Macintosh, 1984] con una interfaz
           gráfica que simplificaba enormemente el manejo de la computadora. El otro gran
           competidor en este campo, el sistema operativo MS tardó bastante más en dar este
           paso. En sus primeras versiones proporcionaba una. interfaz alfanumérica similar a la de
           UNIX pero muy simplificada. Como paso intermedio, hacia 1988, incluyo una interfaz
           denominada. DOS-SHELL que, aunque seguía siendo alfanumérica, no estaba basada
           en líneas sino que estaba orientada al uso de toda la. pantalla y permitía realizar
           operaciones mediante menús. Por fin, ya en los noventa, lanzó una interfaz. gráfica,
           denominada. Windows, que tomaba prestadas muchas de las ideas del Macintosh.
                En el mundo UNIX. se produjo una evolución similar. Cada fabricante incluía en su
           sistema. una interfaz gráfica además de la convencional. La. aparición del sistema de
           ventanas X a mediados de los ochenta y su aceptación generalizada, que le ha
           convertido en un estándar de facto, ha permitido que la mayoría de los sistemas UNIX
           incluyan una interfaz gráfica común. Como resultado de este proceso, prácticamente
           todas las computadoras de propósito general existentes actualmente poseen una interfaz
           de usuario gráfica
                Hoy en día, este tipo de interfaces tiene su mayor representante en los sistemas
           operativo Windows de Microsoft. En la Figura 2.18 se muestra uno de los elementos
           clave de la interfaz gráfica de este tipo de sistemas, el explorador de Windows.
                A continuación, se revisan las características comunes de este tipo de interfaces. En
           primer lugar, todos ellos están basados en ventanas que permiten al usuario trabajar
           simultáneamente en distintas actividades. Asimismo, se utilizan iconos y menús para
           representar los recursos del sistema y poder realizar operaciones sobre los mismos,
           respectivamente. El usuario utiliza. un ratón (o dispositivo equivalente) para interaccionar
           con estos elementos. Así, por ejemplo, para arrancar una:




Figura 2.18. Explorador de Windows

<!-- pág. 88 -->

                                                         Introducción a los sistemas operativos   67
        aplicación el usuario podría tener que apuntar a un icono con el ratón y apretar un botón
        del mismo, para copiar un archivo señalar al icono que lo representa y, manteniendo el
        botón del ratón apretado, moverlo hasta ponerlo encima de un icono que representa el
        directorio destino. Generalmente, para agilizar el trabajo de los usuarios más avanzados,
        estas interfaces proporcionan la posibilidad de realizar estas mismas operaciones
        utilizando ciertas combinaciones de teclas. Dado el carácter intuitivo de estas interfaces, y
        el amplio conocimiento que posee de ellas todo el inundo, no parece necesario entrar en
        más detalles sobre su forma de trabajo,
               En cuanto a su estructura interna, las interfaces gráficas normalmente están
        formadas por un conjunto de programas que, usando los servicios del sistema, trabajan
        conjuntamente para llevar a cabo las peticiones del usuario. Así, por ejemplo, existirá un
        gestor de ventanas para mantener el. estado de las mismas y permitir su manipulación, un
        administrador de programas que permita al usuario arrancar aplicaciones, un gestor de
        archivos que permita manipular archivos y directorios, o una herramienta de configuración
        de la propia interfaz y del entorno. Observe la diferencia con las interfaces alfanuméricas,
        en las que existía un programa por cada mandato, Además de la funcionalidad comentada,
        otros aspectos que conviene resaltar son los siguientes:
                • Intercambio de datos entre aplicaciones. Generalmente se le proporciona al
                  usuario un mecanismo del tipo copiar y pegar (copy-and-paste) para poder
                  transferir información entre dos aplicaciones.
                • Sistema de ayuda interactivo, Los sistemas de ayuda suelen ser muy
                  sofisticados basándose muchos de ellos en hipertexto.
                • Oferta de servicios a las aplicaciones (API gráfico). Además de encargarse de
                  atender al usuario, estos entornos gráficos proporcionan a las aplicaciones una
                  biblioteca de primitivas gráficas que permiten que los programas creen y
                  manipulen objetos gráficos.
                • Posibilidad de acceso a la interfaz alfanumérica. Muchos usuarios se sienten
                  encorsetados dentro de la interfaz gráfica y prefieren usar una interfaz
                  alfanumérica para realizar ciertas operaciones. La posibilidad de acceso a dicha
                  interfaz desde el entorno gráfico ofrece al usuario un sistema con lo mejor de los
                  dos mundos.
2.13. HISTORIA DE LOS SISTEMAS OPERATIVOS
        Como se decía al comienzo del capítulo, el sistema operativo lo forman un conjunto de
        programas que ayudan a los usuarios en la explotación de una computadora,
        simplificando, por un lado, su uso, y permitiendo, por otro, obtener un buen rendimiento de
        la máquina. Es difícil tratar de dar una definición precisa de sistema operativo, puesto que
        existen muchos tipos, según sea la aplicación deseada, el tamaño de la computadora
        usada y el énfasis que se dé a su explotación. Por ello se va a realizar un bosquejo de la
        evolución histórica de los sistemas operativos, ya que así quedará plasmada la finalidad
        que se les ha ido atribuyendo.
              Se pueden encontrar las siguientes etapas en el desarrollo de los sistemas
        operativos, que coinciden con las cuatro generaciones de las computadoras.
        Prehistoria
        Durante esta etapa, que cubre los años cuarenta, se construyen las primeras
        computadoras. Como ejemplo de computadoras de esta época se pueden citar el ENJAC
        (Electronic Numerical Integrator Analyzer and computer), financiado por el. Laboratorio de
        Investigación Balística de los Estados Unidos. El ENIAC era una máquina enorme con un
        peso de 30 toneladas, que era capaz de realizar 5,000 sumas por segundo, 457

<!-- pág. 89 -->

68   Sistemas operativos. Una visión aplicada
       multiplicaciones por segundo y 38 divisiones por segundo. Otra computadora de esta
       época fue el EDVAC (Electronic Discrete Variable Automatic Computer).
             En esta etapa no existían sistemas operativos. El usuario debía codificar su
       programa a mano y en instrucciones máquina, y debía introducirlo personalmente en la
       computadora, mediante conmutadores o tarjetas perforadas, Las salidas se imprimían o se
       perforaban en cinta de papel para su posterior impresión. En caso de errores en la
       ejecución de Los programas, el usuario tenía que depurarlos examinando el contenido de
       la memoria y los registros de la computadora.
             En esta primera etapa todos los trabajos se realizaban en serie Se introducía un
       programa en la computadora, se ejecutaba y se imprimían los resultados y se repetía este
       proceso con otros programas. Otro aspecto importante de esta época es que se requería
       mucho tiempo para preparar y ejecutar un programa, ya que el programador debía
       encargarse de codificar todo el programa e introducirlo en la computadora de forma
       manual.
       Primera generación (años cincuenta)
       Con la aparición de la primera generación de computadoras (años cincuenta) se hace
       necesario racionalizar su explotación, puesto que ya empieza a haber una base mayor de
       usuarios. El tipo de operación seguía siendo serie como en el caso anterior, esto es, se
       trataba un trabajo detrás de otro teniendo cada trabajo las fases siguientes:
            • Instalación de cintas o fichas perforadas en los dispositivos periférico En su caso,
              instalación del papel en la impresora.
            • Lectura mediante un programa cargador del programa a ejecutar y de sus datos.
            • Ejecución del programa.
            • Impresión o grabación de los resultados.
            • Retirada de cintas, fichas y papel.
              La realización de la primera fase se denominaba montar el trabajo.
              El problema básico que abordaban estos sistemas operativos primitivos era
       optimizar el flujo de trabajos, minimizando el tiempo empleado en retirar un trabajo y
       montar el siguiente. También empezaron a abordar el problema de la. E/S, facilitando al
       usuario paquetes de rutinas de BIS, para simplificar la programación de estas operaciones,
       apareciendo así los primeros manejadores de dispositivos. Se introdujo también el
       concepto de system file name, que empleaba un nombre o número simbólico para referirse
       a los periféricos, haciendo que su manipulación fuera mucho mas flexible que mediante las
       direcciones físicas.
              Para minimizar el tiempo de montaje de los trabajos, éstos se agrupaban en lotes
       (batch) del mismo tipo (p. ej programas Fortran, programas Cobol, etc), lo que evitaba
       tener que montar y desmontar las cintas de los compiladores y montadores, aumentando
       el rendimiento.
              En las grandes instalaciones se utilizaban computadoras auxiliares, o satélites, para
       realizar las funciones de montar y retirar los trabajos. Así se mejoraba el rendimiento de la
       computadora principal, puesto que se le suministraban los trabajos montados en cinta
       magnética y éste se limitaba a procesarlos y a grabar los resultados también en cinta
       magnética. En este caso se decía que la E/S se hacía fuera de línea (off-line).
       Los sistemas operativos de las grandes instalaciones tenían las siguientes características:

<!-- pág. 90 -->

                                                Introducción a os sistemas operativos    69


         • Procesaban un único flujo de trabajos en lotes.
         • Disponían de un conjunto de rutinas de E/S.
         • Usaban mecanismos rápidos para pasar de un trabajo al siguiente.
         • Permitían la recuperación del sistema si un trabajo acababa en error.
         • Tenían un lenguaje de control (le trabajos que permitía especificar los recursos
           a utilizar las operaciones a realizar por cada trabajo.
       Como ejemplos (le sistemas operativos de esta época se pueden citar el FMS
(Fortran System) e IBYSS, el sistema opera de la IBM 7094.
Segunda generación (años sesenta)
Con la aparición de La segunda generación de computadoras (principios de los sesenta)
se hizo más necesario, dada la mayor competencia entre los fabricantes, mejorar la
explotación de estas maquinas de altos precios. La multiprogramación se impuso en
sistemas de lotes como una forma de aprovechar el tiempo empleado en las operaciones
de E/S. La base de estos sistemas reside en la gran diferencia. que existe, como se vio en
el Capitulo 1, entre las velocidades de los periféricos y de la UCP, por lo que esta última,
en las operaciones de E/S, se pasa mucho tiempo esperando a los periféricos. Una forma
de aprovechar ese tiempo consiste en mantener varios trabajos simultáneamente en
memoria principal (técnica llamada de multiprogramación), y en realizar las operaciones de
E/S por acceso directo a. memoria. (Cuando un trabajo necesita una operación de E/S la
solicita al sistema operativo que se encarga de:
         • Congelar el trabajo solicitante.
         • Iniciar la mencionada operación de E/S por DMA.
         • Pasar a realizar otro trabajo residente en memoria. Estas operaciones las
           realiza el. sistema operativo multiprogramado de forma transparente al usuario.
         También en esta época aparecen otros modos de funcionamiento muy
         importantes:
         • Se construyen los primeros multiprocesadores, en los que varios procesadores
           forman una sola máquina de mayores prestaciones
         • Se introduce el concepto de independencia de dispositivo. El usuario ya no
           tiene que referirse en sus programas a una unidad de cinta magnética o a una
           impresora en concreto. Se limita a especificar que quiere grabar un archivo
           determinado o imprimir unos resultados. El sistema operativo se encarga de
           asignarle, de forma dinámica, una unidad disponible, y de indicar al operador
           del sistema la unidad seleccionada, para que éste monte la cinta o el papel
           correspondiente.
         • Comienzan los sistemas de tiempo compartido o timesharing. Estos
           sistemas, a los que 4 estamos muy acostumbrados en la actualidad, permiten
           que varios usuarios trabajen de forma interactiva o conversacional con la
           computadora desde terminales, que en aquellos días eran teletipos
           electromecánicos. El sistema operativo se encarga de repartir el tiempo de la
           UCP entre los distintos usuarios, asignando de forma rotativa pequeños
           intervalos de tiempo de UCP denominadas rodajas (time slice). En sistemas
           bien dimensionados, cada usuario tiene la impresión. de que la computadora le
           atiende exclusivamente a él, respondiendo rápidamente a sus órdenes.
           Aparecen así los primeros planificadores.

<!-- pág. 91 -->

70   Sistemas operativos. Una visión aplicada
                 • Aparecen, en esta época, los primeros sistemas de tiempo real. Se trata de
                   aplicaciones militares, en concreto para detección de ataques aéreos. En este
                   caso, la computadora están conectadas a un sistema externo y debe responder
                   velozmente a las necesidades de ese sistema externo. En este tipo de sistemas
                   las respuestas deben producirse en períodos de tiempo previamente
                   especificados, que en la mayoría de los casos son pequeños. Los primeros
                   sistemas de este tipo se construían en ensamblador y ejecutaban sobre
                   maquina desnuda (Sección 2.1.1), lo que hacía de estas aplicaciones sistemas
                   muy complejos
             Finalmente, cabe mencionar que Burroughs introduce, en 1963, el «Master Control
         Program», que además de ser multiprograma y multiprocesador incluía memoria virtual y
         ayudas para depuración en lenguaje fuente.
         Durante esta época se desarrollaron, entre otros, los siguientes sistemas operativos: el.
         CTSS [CORBATO 1962], desarrollado en el MIT y que fue el primer sistema de tiempo
         compartido. Este sistema operativo se utilizó en un IBM 7090 y llegó a manejar hasta 32
         usuarios interactivos. El OS/360 [Mealy, 1966], sistema operativo utilizado en las
         máquinas de la línea 360 de IBM y el sistema MULTICS [ Organick, 1972], desarrollado
         en el MIT con participación de los laboratorios Bell y que evolucionó posteriormente para
         convertirse en el sistema operativo UNIX MULTICS fue diseñado para dar soporte a
         cientos de usuarios; sin embargo, aunque una versión primitiva de este sistema operativo
         ejecutó en 1969 una computadora GE 645, no proporcionó los servicios para los que fue
         diseñada y los laboratorios Bell finalizaron su participación en el proyecto.
         Tercera generación (años setenta)
         La tercera generación es la época de los sistemas de propósito general y se Caracteriza
         por los sistemas operativos multimodo de operación, esto es, capaces de operar en
         lotes, en multiprogramación, en tiempo real, en tiempo compartido y en modo
         multiprocesador. Estos sistemas operativos fueron costosísimos de realizar e
         interpusieron entre el usuario y el hardware una gruesa capa de software, de forma que
         éste sólo veía esta capa, sin tenerse que preocupar de los detalles de la circuitería.
              Uno de los inconvenientes de estos sistemas operativos era su complejo lenguaje
         de control, que debían aprenderse los usuarios para preparar sus trabajos, puesto que
         era necesario especificar multitud de detalles y opciones. Otro de los inconvenientes era
         el gran consumo de recursos que ocasionaban, esto es, los grandes espacios de
         memoria principal y secundaria ocupados, así corno el tiempo de UCP consumido, que
         en algunos casos superaba el 50 por 100 del tiempo total.
              Esta década fue importante por la aparición de dos sistemas que tuvieron una gran
         difusión, UNIX [ Bach, 1986] y MVS [ Samson,1990] de IBM De especial importancia fue
         UNIX, desarrollado en los laboratorios Bell para una PDP-7 en 1970. Pronto se
         transportó a una PDP- 11, para lo cual se rescribió utilizando el lenguaje de
         programación C. Esto fue algo muy importante en la historia de los sistemas operativos,
         ya que hasta la fecha ninguno se había escrito utilizando un lenguaje de alto nivel,
         recurriendo para ello a los lenguajes ensambladores propios de cada arquitectura. Sólo
         una pequeña parte de UNIX, aquella que accedía de forma directa al hardware, siguió
         escribiéndose en ensamblador. La programación de un sistema operativo utilizando un
         lenguaje de alto nivel como es C hace que un sistema operativo sea fácilmente
         transportable a una. Amplia gama de computadoras. En la actualidad, prácticamente
         todos los sistemas operativos se escriben en lenguajes de alto nivel, fundamentalmente
         en C.
              La primera versión ampliamente disponible de UNIX fue la versión 6 de los
         laboratorios Be1l,. que apareció en 1976. A ésta le siguió la versión 7 distribuida en
         1978, antecesora de prácticamente de todas las versiones modernas de UNIX. En 1982
         aparece

<!-- pág. 92 -->

                                              Introducción a los sistemas operativos   71
una versión de UNIX desarrollada por la Universidad de California en Berkeley, la cual se
distribuyó como la versión BSD (Berkeley Software .Distribution) de UNIX Esta versión
de UNIX introdujo mejoras importantes como la inclusión de memoria virtual y la interfaz
de sockets para la programación de aplicaciones sobre protocolos TCP/IP.
    Más tarde, AT&T (propietario de los laboratorios Beill) distribuyó la versión de UNIX
conocida como Systern V o RVS4. Desde entonces muchos han sido los fabricantes de
computadoras que has adoptado a UNIX como sistema operativo de sus máquinas.
Ejemplos de estas versiones son: Solaris de SUN, HP UNIX, IRIX de SGI y AIX de IBM.
Cuarta generación (años ochenta hasta la actualidad)
La cuarta generación se caracteriza por una evolución de los sistemas operativos de
propósito general de la tercera generación, tendente a su especialización, a su
simplificación y a dar más importancia a la productividad de usuario que al rendimiento
de la máquina.
Adquiere cada vez más importancia el tema de las redes de computadoras, tanto redes
de largo alcance como locales. En concreto, la disminución del coste del hardware hace
que se difunda el proceso distribuido, en contra, de la tendencia centralizadora
anterior. El proceso distribuido consiste en disponer de varias computadoras, cada una
situada en el lugar de trabajo de las personas que la emplean, en lugar de una única
central. Estas computadoras suelen estar unidas mediante una red, de forma que
puedan compartir información y periféricos.
     Se difunde el concepto d máquina virtual, consistente en que una computadora X,
incluyen do su sistema operativo, sea simulada por otra computadora Y. Su ventaja es
que permite ejecutar. en la computadora Y, programas preparados para la computadora
X, lo que posibilita el empleo de .software elaborado para la computadora X, sin
necesidad de disponer de dicha. computadora.
     Durante esta época, los sistemas de bases de datos sustituyen a los archivos en
multitud de aplicaciones. Estos sistemas se diferencian de un conjunto de archivos en
que sus datos están estructurados de tal forma que permiten acceder a la información de
diversas maneras, evitar datos redundantes y mantener su integridad y coherencia.
     La difusión de las computadoras personales ha traído una humanización en los
sistemas informáticos. Aparecen los sistemas «amistosos» o ergonómicos, en los que se
evita que el usuario tenga que aprenderse complejos lenguajes de control,
sustituyéndose éstos por los sistemas dirigidos por menú, en los que la selección puede
incluso hacerse mediante un manejador de cursor. En estos sistemas, de orientación
monousuario, el objetivo primario del sistema operativo ya no es aumentar el rendimiento
del sistema, sino la productividad del usuario En este sentido, la tendencia actual
consiste en utilizar sistemas operativos multiprogramados sobre los que se añade un
gestor de ventanas, lo que permite que el usuario tenga activas, en cada momento,
tantas tareas como desee y que las distribuya a su antojo sobre la superficie del terminal
     Los sistemas operativos que dominaron el campo de las computadoras personales
fueron UNIX, MS-DOS y los sucesores de Microsoft para este sistema: Windows 95/98,
Windows NT y Windows 2000. La primera, versión de Windows NT (versión 3.1) apareció
en 1993 e incluía la misma interfaz de usuario que Windows 3.1, En 1996 aparece la
versión 4.0, que se caracterizó por la inclusión dentro del ejecutivo de Windows NT de
diversos componentes gráficos que ejecutaban anteriormente modo usuario. Durante el
año 2000, Microsoft distribuye la versión denominada Windows 2000.

<!-- pág. 93 -->

72 Sistemas operativos. Una visión aplicada

                  También ha tenido importancia durante esta época eL desarrollo de Linux. Linux es un
             sistema operativo similar a UNIX, desarrollado de forma desinteresada durante la década de los
             noventa por miles de voluntarios conectados a Internet. Linux está creciendo fuertemente
             debido sobre todo a su bajo coste y a su gran estabilidad, comparable a cualquier otro sistema
             UNIX. Una de las principales características de Linux es que su código fuente esta disponible,
             lo que le hace especialmente atractivo para el estudio de la estructura interna de sistema
             operativo. Su aparición ha tenido también mucha importancia en el mercado del software ya
             que ha hecho que se difunda el concepto de software libre.
                   Durante esta etapa se desarrollan también los sistemas operativos de tiempo real,
             encargados de ofrecer servicios especializados para el desarrollo de aplicaciones de tiempo
             real. Algunos ejemplos son: QNX [QNX, 1997], RTEMS y VRTX [ Ready, 1986].




            Figura 2.19 Estructura de un sistema distribuido que utiliza un sistema operativo distribuido




             Figura 2.20. Estructura de un sistema distribuido que emplea un middleware.

                  A mediados de los ochenta aparecen los sistemas operativos distribuidos. Un sistema
            operativo distribuido es un sistema operativo (Fig. 2.19) común utilizado en una serie de
            computadoras conectadas por una red, Este tipo de sistemas aparece al usuario como un único
            sistema operativo centralizado, haciendo por tanto más fácil el uso de una red de computadoras.
            Un sistema operativo de este tipo sigue teniendo las mismas características que un sistema
            operativo convencional pero aplicadas a un sistema distribuido. Como ejemplo de sistemas
            operativos distribuidos se puede citar:
            Mach [Accetta, 1986], Chorus [Roizer, 1988] y Amoeba [Mullender, 1990],
                  Los sistemas operativos distribuidos han dejado de tener importancia y han evolucionado
            durante la década de los noventa a lo que se conoce como middleware. Un middleware (Fig.
            2.20) es una capa de software que se ejecuta sobre un sistema operativo ya existente y que se
            encarga de gestión un sistema distribuido. En este sentido, presenta las mismas funciones que un
            sistema operativo distribuido. La diferencia es que ejecuta sobre sistemas operativos ya
            existentes que pueden ser además distintos, lo que hace más atractiva su utilización. Dos de los
            middleware más importantes de esta década han sido

<!-- pág. 94 -->

      DCE [Rosenberry, 1992] y CORBA [Otte, 1996]. Microsoft también ofrece su propio
middleware conocido como DCOM [Rubin, 1999].
      En cuanto a las interfaces de programación, durante esta etapa tiene importancia el
desarrollo del estándar POSIX. Este estándar persigue que las distintas aplicaciones que hagan
uso de los servicios de un sistema operativo sean potables sin ninguna dificultad a distintas
plataformas con sistemas operativos diferentes. Cada vez es mayor el número de sistemas
operativos que ofrecen esta interfaz. Otra de las interfaces de programación mas utilizada es la
interfaz Win32, interfaz de los sistemas operativos Windows 95/98, Windows NT y Windows
2000.

      En el futuro próximo, la evolución de los sistemas operativos se va a orientar hacia las
plataformas distribuidas y la computación móvil. Gran importancia tendrá la construcción de
sistemas operativos y entornos que permitan utilizar estaciones de trabajo heterogéneas
(computadoras de diferentes fabricantes con sistemas operativos distintos) conectadas por redes
de interconexión, como una gran máquina centralizada, lo que permitirá disponer de una mayor
capacidad de cómputo y facilitará el trabajo cooperativo.

<!-- pág. 95 -->



<!-- pág. 96 -->



