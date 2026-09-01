# Capítulo 3

> Fuente: Sistemas Operativos. Una vision aplicada (Javier) — páginas 97–200 (numeración del PDF)

<!-- pág. 97 -->



<!-- pág. 98 -->

  78 Sistemas operativos una visión aplicada

3.1CONCEPTO DE PROCESO

             Todos los programas, cuya ejecución solicitan los usuarios, se ejecutan en forma de
             procesos, de ahí la importancia para el informático de conocerlos en detalle. Como ya se
             vio en el Capítulo 2, el proceso se puede definir como un programa en ejecución y, de
             una forma un poco más precisa, como la unidad de procesamiento gestionada por el
             sistema operativo.
                     En el Capítulo 1 se vio que para que un programa pueda ser ejecutado ha de
             residir con sus datos en memoria principal. Observe que durante su ejecución el proceso
             va modificando los registros del modelo de programación de la computadora, de acuerdo
             a las instrucciones de máquina involucradas (Fig. 1.3).
                    El sistema operativo mantiene por cada proceso una serie de estructuras de
             información que permiten identificar las características de éste, así como los recursos
             que tiene asignados. En esta última categoría entran los descriptores de los segmentos de
             memoria asignados, los descriptores de los archivos abiertos, los descriptores de los
             puertos de comunicaciones, etc.
                    Una parte muy importante de estas informaciones se encuentra en el llamado
             bloque de control del proceso (BCP). El sistema operativo mantiene una tabla de
             procesos con todos los BCP de los procesos. Por razones de eficiencia, la tabla de
             procesos se construye normalmente como una estructura estática, que tiene un
             determinado número de BCP, todos ellos del mismo tamaño. El contenido del BCP se
             analizará con más detalle en secciones posteriores; sin embargo, de manera introductoria
             se puede decir que la información que compone un proceso es la siguiente:

                 • Contenido de los segmentos de memoria en los que residen el código y los datos
                 del proceso. A esta información se le denomina imagen de memoria o core image.
                 • Contenido de los registros del modelo de programación.
                 • Contenido del BCP.

                   Es de destacar que el proceso no incluye información de E/S, puesto que ésta suele
               estar reservada al sistema operativo.


             Jerarquía de procesos

             La secuencia de creación de procesos vista en la Sección 2.2 genera un árbol de procesos
             como el incluido en la Figura 3.1.
                    Para referirse a las relaciones entre los procesos de la jerarquía se emplean los
             términos de padre, hijo. hermano o abuelo. Cuando el proceso A solicita al sistema
             operativo que cree el proceso B. se dice que A es padre de B y que B es hijo de A. Bajo
             esta óptica, la jerarquía de procesos puede considerarse como un árbol genealógico.
                    Algunos sistemas operativos, como UNIX, mantienen de forma explícita esta
             estructura jerárquica de procesos —un proceso sabe quién es su padre—, mientras que
             otros sistemas operativos como el Windows NT no la mantienen.

<!-- pág. 99 -->

     Entorno del proceso

     El entorno del proceso consiste en un conjunto de variables que se le pasan al proceso en
     el momento de su creación.
           El entorno está formado por una tabla NOMBRE-VALOR que se incluye en la pila
     del proceso. El NOMBRE especifica el nombre de la variable y el VALOR su valor. Un
     ejemplo de entorno en UNIX es el siguiente:
                                                                              Procesos      79




Figura 3.1 Jerarquía de proceso

           PATH=/ USR/ bin: / home / pepe / bin
           TERM= vt 100
           HOME= /home/pepe
           PWD= / home /pepe /libros / primero

           En este ejemplo, PATH indica la lista de directorios en los que el sistema
     operativo busca los programas ejecutables, TERM el tipo de terminal, HOME el
     directorio inicial asociado al usuario y PWD cl directorio de trabajo actual.
           Los procesos pueden utilizar las variables del entorno para definir su
     comportamiento. Por ejemplo, un programa de edición responderá a las teclas de acuerdo
     al tipo de terminal que esté utilizando el usuario, que viene definido en la variable
     TERM.


     Grupos de procesos

     Los procesos forman grupos que tienen diversas propiedades. El conjunto de procesos
     creados a partir de un shell puede formar un grupo de procesos. También pueden formar
     un grupo los procesos dependientes de un terminal.
           El interés del concepto de grupo de procesos es que hay determinadas operaciones
     que se pueden hacer sobre todos los procesos de un determinado grupo, como se verá al
     estudiar algunos de los servicios. Un ejemplo es la posibilidad de matar a todos los
     procesos pertenecientes a un mismo grupo.

<!-- pág. 100 -->

3.2. MULTITAREA

              Como ya se vio en el capítulo anterior, dependiendo del número de procesos y de
              usuarios que puedan ejecutar simultáneamente, un sistema operativo puede ser:

                  • Monotarea o monoproceso.
                  • Multitarea o multiproceso.



  80 Sistemas operativos. Una visión aplicada

                  • Monousuario.
                  • Multiusuario (tiempo compartido).

                     Un sistema operativo monotarea, también llamado monoproceso, solamente
              permite que exista un proceso en cada instante. Si se quieren ejecutar varios procesos, o
              tareas, hay que lanzar la ejecución de la primera y esperar a que termine antes de poder
              lanzar la siguiente. El ejemplo típico de sistema operativo monoproceso es el MS-DOS.
              La ventaja de estos sistemas operativos es que son muy sencillos.
                     Por el contrario, un sistema operativo multitarea o multiproceso (Recordatorio 3.
              1) permite que coexistan varios procesos activos a la vez. El sistema operativo se
              encarga de ir repartiendo el tiempo del procesador entre estos procesos, para que todos
              ellos vayan avanzando en su ejecución.




                     Un sistema monousuario está previsto para dar soporte a un solo usuario. Estos
              sistemas pueden ser monoproceso o multiproceso. En este último caso el usuario puede
              solicitar varias tareas al mismo tiempo, por ejemplo, puede estar editando un archivo y,
              simultáneamente, puede estar accediendo a una página Web de la red.
                     El sistema operativo multiusuario da soporte a varios usuarios que trabajan
              simultáneamente desde varios terminales. A su vez, cada usuario puede tener activos
              más de un proceso, por lo que el sistema, obligatoriamente, ha de ser multitarea. Los
              sistemas multiusuario reciben también el nombre de tiempo compartido, puesto que el
              sistema operativo ha de repartir el tiempo de la computa-. dora entre los usuarios, para
              que las tareas de todos ellos avancen de forma razonable.

              La Figura 3.2 recoge estas alternativas.


     3.2.1.     Base de la multitarea

              La multitarea se basa en las tres características siguientes:

<!-- pág. 101 -->

                     • Paralelismo real entre E/S y procesador.
                     • Alternancia en los procesos de fases de E/S y de procesamiento.
                     • Memoria principal capaz de almacenar varios procesos.




Figura 3.2. Tipos de sistemas operativos en función del numero de procesos y usuarios
                                                                                   Procesos       81




           Figura 3.3. Un proceso Alterna entre fases de procesamiento y de E/S.


                  Como se vio en el Capítulo 1, existe concurrencia real entre el procesador y las
           funciones de F/S realizadas por los controladores de los periféricos. Esto significa que,
           mientras se están realizando una operación de FIS de un proceso, se puede estar
           ejecutando otro proceso.
                  Como se muestra en la Figura 3.3, la ejecución de un proceso alterna, típicamente,
           fases de procesamiento con fases de FIS, puesto que, cada cierto tiempo, necesita leer o
           escribir datos en un periférico. En un sistema monotarea el procesador no tiene nada que
           hacer durante las fases de entrada/salida, por lo que desperdicia su potencia de
           procesamiento. En un sistema multitarea se aprovechan las fases de entrada/salida de
           unos procesos para realizar las fases de procesamiento de otros.
                  La Figura 3.4 presenta un ejemplo de ejecución multitarea con tres procesos
           activos. Observe que, al finalizar la primera fase de procesamiento del proceso A, hay un
           intervalo de tiempo en el que no hay trabajo para el procesador.
                  Como muestra la figura, el sistema operativo entra a ejecutar al final de las fases
           de procesamiento y al final de las fases de entrada/salida. Esto es así puesto que las
           operaciones de F/S no las gobiernan directamente los procesos, sino que se limitan a
           pedirle al sistema operativo que las realice. Del mismo modo, el sistema operativo trata
           las interrupciones que generan los controladores para avisar que han completado una
           operación.
                  Finalmente es importante destacar que la multitarea exige tener más de un proceso
           activo y cargado en memoria principal. Por tanto, hay que disponer de suficiente
           memoria principal para albergar a estos procesos.

<!-- pág. 102 -->

           Proceso nulo

           Como se indicó en el Capítulo 1, el procesador no para de ejecutar nunca. Esto parece
           que contradice a la Figura 3.4, puesto que muestra un intervalo en el que el procesador
           no tiene nada que hacer. Para evitar esta contradicción, los sistemas operativos incluyen
           el denominado proceso nulo.




Figura 3.4 Ejemplo de ejecución en un sistema multitarea
82 Sistemas operativos. Una visión aplicada

           Este proceso consiste en un bucle infinito que no realiza ninguna operación útil. El
           objetivo de este proceso es «entretener» al procesador cuando no hay ninguna otra tarea.

           Estados de los procesos

           De acuerdo con la Figura 3.4, un proceso puede estar en varias situaciones
           (procesamiento, listo para ejecutar y espera), que denominaremos estados. A lo largo de
           su vida, el proceso va cambiando de estado según evolucionan sus necesidades. En la
           Sección 3.5 se describirán con mayor detalle los estados de un proceso.

           Planificador y activador

           El planificador (scheduler) forma parte del núcleo del sistema operativo. Entra en
           ejecución cada vez que se activa el sistema operativo y su misión es seleccionar el
           proceso que se ha de ejecutar a continuación.
           El activador (dispatcher) también forma parte del sistema operativo y su función es
           poner en ejecución el proceso seleccionado por el planificador.

           3.2.2.        Ventajas de la multitarea

           La multiprogramación presenta varias ventajas, entre las que se pueden resaltar las
           siguientes:

                    • Facilita la programación. Permite dividir las aplicaciones en varios procesos, lo
                      que beneficia a su modularidad.
                    • Permite prestar un buen servicio, puesto que se puede atender a varios usuarios
                      dc forma eficiente, interactiva y simultánea.
                    • Aprovecha los tiempos muertos que los procesos pasan esperando a que se
                      completen sus operaciones de E/S.

<!-- pág. 103 -->

                    • Aumenta el uso de la UCP, al aprovechar los espacios de tiempo que los
                      procesos están bloqueados.

           Todas estas ventajas hacen que, salvo para situaciones muy especiales, no se conciba
           actualmente un sistema operativo que no soporte multitarea.


           3.2.3.       Grado de multiprogramación y necesidades de memoria principal

           Se denomina grado de multiprogramación al número de procesos activos que mantiene
           un sistema. El grado de multiprogramación es un factor que afecta de forma importante
           el rendimiento que se obtiene de una computadora. Mientras más procesos activos haya
           en un sistema, mayor es la probabilidad de encontrar siempre un proceso en estado de
           listo para ejecutar, por lo que entrará a ejecutar menos veces el proceso nulo. Sin
           embargo, se tiene el inconveniente de que, a mayor grado de multiprogramación, se
           tienen mayores necesidades de memoria. Veamos este fenómeno con mas detalle para
           los dos casos de tener o no tener memoria virtual.
                 En un sistema sin memoria virtual los procesos activos han de residir totalmente
           en memoria principal. Por tanto, el grado de multiprogramación viene limitado por el
           tamaño de los procesos y por la memoria disponible. Además, en un sistema de estas
           características, como se indica en la Figura 3.5, el rendimiento de la utilización del
           procesador aumenta siempre con el grado de multiprogramación. Esto es así ya que los
           procesos siempre residen en memoria principal.

                                                                                   Procesos    83




Figura 3.5. Grado de multiprogramación y utilización del procesador.


                 En los sistemas con memoria virtual la situación es más compleja, puesto que los
           procesos sólo tienen en memoria principal su conjunto residente (Recordatorio 32), lo
           que hace que quepan mas procesos. Sin embargo, al aumentar el número de procesos
           disminuye el conjunto residente de cada uno, situación que se muestra en la Figura 3.6.
                 Cuando el conjunto residente de un proceso se hace menor de un determinado
           valor ya no representa adecuadamente al futuro conjunto de trabajo (Recordatorio 3.2)
           del proceso, lo que tiene como consecuencia que se produzcan muchos fallos de página.

<!-- pág. 104 -->

           Cada fallo de página consume tiempo de procesador, porque el sistema operativo ha de
           tratar el fallo, y tiempo de FIS, puesto que hay que hacer una migración de páginas.
           Todo ello hace que, al crecer los fallos de páginas, el sistema dedique cada vez más
           tiempo al improductivo trabajo de resolver estos fallos de página.
                  La Figura 3.7 muestra que, en un sistema con memoria virtual, el aumento del
           grado de multiprogramación conlleva primero un aumento del rendimiento del
           procesador. Sin embargo, superado un determinado valor de grado de multiprogramación
           los conjuntos residentes de los procesos empiezan a ser demasiado pequeños, por lo que
           el sistema baja su rendimiento al perder el tiempo paginando.




           Figura 3.6. El conjunto residente medio decrece con el grado de multiprogramación

84      Sistemas operativos. Una visión aplicada




Figura 3.7. Rendimiento del procesador y grado de multiprogramación.


            Se denomina hiperpaginación (trashing) a la situación de alta paginación producida
           cuando los conjuntos residentes de los procesos son demasiado pequeños.

<!-- pág. 105 -->

      Cuando la memoria principal disponible es pequeña, se llega a la situación de
hiperpaginación antes de alcanzar una cota alta de utilización del procesador. Para
aumentar el rendimiento de un sistema que esté en esta situación es necesario añadir más
memoria principal. Cuando la memoria es grande se llega a saturar el procesador con
menos procesos de los que caben en memoria. En este caso se puede aumentar el
rendimiento del sistema manteniendo la memoria pero aumentando la potencia del
procesador o añadiendo otro procesador.


3.3.     INFORMACIÓN DEL PROCESO

Como se indicó anteriormente, el proceso es la unidad de procesamiento gestionada por
el sistema operativo. Para poder realizar este cometido, el proceso tiene asociado una
serie de elementos de información, que se resumen en la Figura 3.8, que se analizan
seguidamente. Estos elementos se organizan en tres grupos: estado del procesador,
imagen de memoria y tablas del sistema operativo.

3.3.1. Estado del procesador

El estado del procesador (Aclaración 3.1) está formado por el contenido de todos sus
registros, que se enumeran seguidamente:

     Registros generales. De existir registros específicos de coma flotante también se
      incluyen aquí.
     Contador de programa.
                                                                      Procesos       85




Figura 3.8. Información de un proceso.


•      Puntero de pila.

<!-- pág. 106 -->

           • Registro o registros de estado.
           • Registros especiales. Como puede ser el RIED (registro identificador de espacio de
           direccionamiento).




                   El estado del procesador de un proceso reside en los registros del procesador,
           cuando el proceso está en ejecución, o en el bloque de control de proceso (BCP), cuando
           el proceso no está en ejecución.
                  Cuando el proceso está ejecutando, el estado del procesador varía de acuerdo al
           flujo de instrucciones maquina ejecutado. En este caso, la copia del estado del
           procesador que reside en el BCP no está actualizada. Téngase en cuenta que los registros
           de la máquina se utilizan para no tener que acceder a la información de memoria, dado
           que es mucho más lenta. Por tanto, no tiene sentido plantear que, en cada modificación
           de un registro, se actualice su valor en el BCP, puesto que está en memoria.
                  Sin embargo, cuando se detiene la ejecución de un proceso, como consecuencia de
           la ejecución dc una interrupción, es muy importante que el sistema operativo actualice la
           copia del estado del procesador en su BCP. En términos concretos, la rutina del sistema
           operativo que trata las interrupciones lo primero que ha de hacer es salvar el estado del
           procesador en el BCP del proceso interrumpido.


           3.3.2. Imagen de memoria del proceso

           La imagen de memoria del proceso está formada por los espacios de memoria que está
           autorizado a utilizar. Las principales características de la imagen de memoria son las
           siguientes:




86 Sistemas operativos. Una visión aplicada

             • El proceso solamente puede tener información en su imagen de memoria y no fuera
               de ella. Si genera una dirección que esté fuera de ese espacio, el hardware de
               protección deberá detectarlo y levantar una excepción. Esta excepción activará la
               ejecución del sistema operativo que se encargará de tomar las acciones oportunas,
               que por lo general consistirán en abortar ¡a ejecución del proceso.
             • Dependiendo de la computadora, la imagen de memoria estará referida a memoria
               virtual o a memoria física. Observe que esto es transparente (irrelevante) para el
               proceso, puesto que él genera direcciones que serán virtuales o físicas según el caso.
             • Los procesos suelen necesitar asignación dinámica de memoria. Por tanto, la imagen
               de memoria de los mismos se deberá adaptar a estas necesidades, creciendo o
               decreciendo adecuadamente.

<!-- pág. 107 -->

 • No hay que confundir la asignación de memoria con la asignación de marcos de
   memoria. El primer término contempla la modificación de la imagen de memoria y
   se refiere a espacio virtual en los sistemas con este tipo de espacio. El segundo sólo
   es de aplicación en los ¡sistemas con memoria virtual y se refiere a la modificación
   del conjunto residente del proceso.

       El sistema operativo asigna la memoria al proceso, para lo cual puede emplear
distintos modelos de imagen de memoria, que se analizan seguidamente.

Imagen de memoria con un único segmento de tamaño fijo

Este es el modelo más sencillo de imagen de memoria y su uso se suele restringir a los
sistemas sin memoria virtual. El proceso recibe un único espacio de memoria que,
además, no puede variar de tamaño.

Proceso con un único segmento de tamaño variable

Se puede decir que esta solución no se emplea. En sistemas sin memoria virtual los
segmentos no pueden crecer a menos que se deje espacio de memoria principal de
reserva; se chocaría con otro proceso. Ahora bien, la memoria principal es muy cara
como para dejarla de reserva. En sistemas Con memoria virtual sí se podría emplear,
pero es más conveniente usar un modelo de varios segmentos, pues es mucho más
flexible y se adapta mejor a las necesidades reales de los procesos.

Proceso con un número fijo de segmentos de tamaño variable

Un proceso contiene varios tipos de información, cuyas características se analizan
seguidamente:

   • Texto o código. Bajo este nombre se considera el programa máquina que ha dc
     ejecutar el proceso. Aunque el programa podría automodificarse. no es esta una
     práctica recomendada, por lo cual se considerará que esta información es fija y que
     solamente se harán operaciones de lectura sobre ella (Aclaración 3.2).
   • Datos. Este bloque de información depende mucho de cada proceso. Los lenguajes
     de programación actuales permiten asignación dinámica de memoria, lo que hace
     que varíe el tamaño del bloque de datos al avanzar la ejecución del proceso. Cada
     programa estructura sus datos de acuerdo a sus necesidades, pudiendo existir los
     siguientes tipos:
     -Datos con valor inicial. Estos datos son estáticos y su valor se fija al cargar el
     proceso desde el archivo ejecutable. Estos valores se asignan en tiempo dc
     compilación.

                                                                           Procesos 87

     -Datos sin valor inicial. Estos datos son estáticos, pero no tienen valor asignado.
     por lo que no están presentes en el archivo ejecutable. Será el sistema operativo el
     que, al cargar el proceso, rellene o no rellene esta zona de datos con valores
     predefinidos.
     -Datos dinámicos. Estos datos se crean y se destruyen de acuerdo a las directrices
     del programa.
     Los datos podrán ser de lectura-escritura o solamente de lectura.

<!-- pág. 108 -->

        Pila. A través del puntero de pila, los programas utilizan una estructura dc pila
         residente en memoria. En ella se almacenan, por ejemplo, los bloques de activación de
         los procedimientos llamados. La pila es una estructura dinámica, puesto que crece y
         decrece según avanza la ejecución del proceso.




             Para adaptarse a estas informaciones, se puede utilizar un modelo de imagen de
       memoria con un número fijo de segmentos de tamaño variable.
              El modelo tradicional utilizado en UNIX contempla tres segmentos: texto, pila y
       datos. La Figura 3.9 presenta esta solución. Observe que el segmento de texto es de
       tamaño lijo (el programa habitualmente no se modifica) y que los segmentos de pila y de
       datos crecen en direcciones contrarias.
             Este modelo se adapta bien a los sistemas con memoria virtual, puesto que el
       espacio virtual reservado para que puedan crecer los segmentos de datos y pila no existe.
       Solamente se crea. gastando recursos de disco y memoria, cuando se asigna. No ocurrirá
       lo mismo en un sistema sin memoria virtual, en el que el espacio reservado para el
       crecimiento ha de existir como memoria principal, dando como resultado que hay un
       recurso costoso que no se está utilizando.
            Si bien este modelo es más flexible que los dos anteriores, tiene el inconveniente de
       no prestar ayuda para la estructuración de los datos. El sistema operativo ofrece un
       espacio de datos que puede crecer y decrecer, pero deja al programa la gestión de este
       espacio.


       Proceso con un número variable de segmentos de tamaño variable

       Esta solución es más avanzada que la anterior, al permitir que existan los segmentos que
       desee el proceso. La Figura 3.10 presenta un caso de siete segmentos, que podrán ser de
       texto. de pila o de datos.




       Figura 3.9. Modelo de imagen de memoria con estructura de segmentos fija.
88 Sistemas operativos una visión aplicada

<!-- pág. 109 -->



<!-- pág. 110 -->

                                                                           Procesos      89

      Los primeros pasos se refieren a la fase de programación de la aplicación, que
desembocan en un objeto ejecutable. Sin embargo, este objeto no suele ser un programa
máquina totalmente completo, puesto que no incluye las rutinas del sistema. Esta
solución tiene la ventaja de no repetir en cada archivo ejecutable estas rutinas, con el
consiguiente ahorro de espacio de disco. El sistema operativo, en el proceso de carga,
incluye las rutinas necesarias formando un ejecutable completo en memoria.
 EI objeto ejecutable es un archivo que incluye la siguiente información:

         • Cabecera que contiene entre otras informaciones las siguientes:
        — Estado inicial de los registros.
        — Tamaño del código y de los datos.
        — Palabra «mágica» que identifica al archivo como un ejecutable.

          • Código.
          • Datos con valor inicial.

     Los datos sin valor inicial no necesitan residir en el archivo ejecutable puesto que el
sistema operativo se encargará de asignarles valor (normalmente O) cuando cree el
proceso encargado de ejecutar dicho programa.

Ejecutable de Win32

El ejecutable de Win32 tiene e! siguiente formato:

      • Cabecera MZ de MS-DOS.
      • Programa MS-DOS.
      • Cabecera del ejecutable.
      • Cabecera de Sección 1.
      • Cabecera de Sección 2.
      • Cabecera de Sección 3.
      • ...
      • Cuerpo de la Sección 1.
      • Cuerpo de la Sección 2.
      • Cuerpo de la Sección 3.
      • ...

      1. Cabecera MZ de MS-DOS. Esta cabecera está presente en todos los ejecutables
         de Win32 para preservar la «compatibilidad hacia atrás». La cabecera del
         programa imprime en pantalla el conocido mensaje «This programs runs under
         Windows». Esta cabecera es ignorada al ejecutar en Win32.

      2. Programa MS-DOS. Programa que sólo imprime el mensaje <<This program
         runs under Windows» en pantalla. Sólo se ejecuta con el sistema operativo MS-
         DOS.
      3. Cabecera del ejecutable, que consta de tres partes fundamentales:

<!-- pág. 111 -->

                    — Cabecera del archivo. Aquí es donde realmente empieza el ejecutable de
                        Win32. Esta cabecera es una estructura donde se indican el tipo de máquina,
                        la hora y la fecha del ejecutable, sus características, entre otras cosas.
                    — Firma. 4 bytes que indican el tipo de ejecutable: Win32, OS/2...
                    — Cabecera opcional del archivo. Esta cabecera contiene información de como
                        cargar el archivo en memoria, versión del sistema operativo requerido,
                        versión del enlazador, etcétera.
90 Sistemas operativos. Una visión aplicada


        4. Cabeceras de las secciones. Los datos del ejecutable en sí están contenidos en las seccio-
           nes. Las secciones se componen de una cabecera y un cuerpo. En el cuerpo de la sección
           están los datos y en la cabecera de la sección información de cómo están organiiados los
           datos y de qué tipo son (de lectura, de escritura, de lectura/escritura...).
        5. Cuerpos de las secciones. Después de las cabeceras de las secciones están los cuerpos de
           las secciones, donde están contenidos todos los datos del ejecutable. Las secciones mas
           comunes son: código, datos con valor inicial, datos con valor inicial de sólo lectura,
           datos sin valor inicial, funciones importadas, funciones exportadas, depuracíon...


            3.3.3.        Información del BCP

            El BCP contiene la información básica del proceso, entre la que cabe destacar la
            siguiente:

            Información de identificación

            Esta información identifica al usuario y al proceso. Como ejemplo, se incluyen los
            siguientes datos:
                  • Identificador del proceso.
                  • Identificador del proceso padre, en caso de existir relaciones padre-hijo como en
                     UNIX.
                  • Información sobre el usuario (identificador de usuario. identificador de grupo).


            Estado del procesador

            Contiene los valores iniciales del estado del procesador o su valor en el instante en que
            fue interrumpido el proceso.

            Información de control del proceso

            En esta sección se incluye diversa información que permite gestionar al proceso.
            Destacaremos los siguientes datos:

                     • Información de planificación y estado.

                     —Estado del proceso.
                     —Evento por el que espera el proceso cuando está bloqueado.
                     —Prioridad del proceso.
                     —Información de planificación.

<!-- pág. 112 -->

         • Descripción de los segmentos de memoria asignados al proceso.
         • Recursos asignados, tales como:
         —Archivos abiertos (tabla de descriptores o manejadores de archivo).
         —Puertos de comunicación asignados.
         • Punteros para estructurar los procesos en colas o anillos. Por ejemplo, los
         procesos que están en estado de listo pueden estar organizados en una cola, de
         forma que se facilite la labor del planificador.
         • Comunicación entre procesos. El BCP puede contener espacio para almacenar las
         señales y para algún mensaje enviado al proceso.

                                                                        Procesos       91

3.3.4.        Tablas del sistema operativo

Como se muestra en la Figura 3.8, el sistema operativo mantiene una serie de tablas que
describen a los procesos y a los recursos del sistema. Algunos de los aspectos de estas
tablas ya se han ido comentando, pero aquí se profundizará y detallará el contenido de
las mismas.
      La información asociada a cada proceso se encuentra parcialmente en el BCP y
parcialmente fuera de él. La decisión de incluir o no una información en el BCP se toma
según dos argumentos: eficiencia y necesidad de compartir información.

Eficiencia

Por razones de eficiencia, es decir, para acelerar los accesos, la tabla de procesos se
construye normalmente como una estructura estática, formada por un número
determinado de BCP del mismo tamaño. En este sentido, aquellas informaciones que
pueden tener un tamaño variable no deben incluirse en el BCP. De incluirlas habría que
reservar en cada BCP el espacio necesario para almacenar el mayor tamaño que puedan
tener estas informaciones. Este espacio estaría presente en todos los BCP, pero estaría
muy desaprovechado en la mayoría de ellos.
       Un ejemplo de este tipo de información es la tabla de páginas, puesto que su
tamaño depende dc las necesidades de memoria de los procesos, valor que es muy
variable de unos a otros. En este sentido, el BCP incluirá el RIED (registro identificador
de espacio de direccionamiento) e incluso una descripción de cada segmento (p. ej.:
incluirá la dirección virtual donde comienza el segmento, su tamaño, la zona reservada
para su crecimiento y el puntero a la subtabla de páginas, pero no la subtabla en sí).

Compartir información

Cuando la información ha de ser compartida por varios procesos, no ha de residir en el
BCP, que es dc acceso restringido al proceso que lo ocupa. A lo sumo, el BCP contendrá
un apuntador que permita alcanzar esa información.
      Un ejemplo de esta situación lo presentan los procesos en relación con los punteros
de posición de los archivos que tienen abiertos. Dos procesos pueden tener
simultáneamente abierto el mismo archivo por dos razones: el archivo se heredó abierto
de un proceso progenitor o el archivo se abrió de forma independiente por los dos
procesos.
    En el primer caso se trata de procesos emparentados que, lógicamente, se han
diseñado para compartir el archivo. Téngase en cuenta que un proceso hijo que no desea

<!-- pág. 113 -->

            utilizar un archivo abierto heredado del padre deberá, de acuerdo a las prácticas correctas
            de programación, cerrarlo. Al tratarse de procesos que están diseñados para compartir el
            archivo, lo más conveniente es que compartan el puntero de posición (PP). De esta
            forma, si ambos escriben en el archivo, lo escrito por uno se pondrá a continuación de lo
            escrito por el otro, pero no encima.
                   El compartir los punteros de posición exige que no estén ubicados en el BCP. La
            Figura 3. 12 nuestra una posible solución, basada en una tabla de archivos externa a los
            BCP y compartida por todos los procesos. En dicha tabla se encuentra el puntero de
            posición PP, además del identificador fisico del archivo IDFF. Este es el modelo que
            sigue UNIX.
                   En la Figura 3.12, el proceso con BCP 7 es un hijo del proceso con BCP 4. El
            descriptor de archivo (fd) 3 de ambos procesos utiliza la entrada 4 de la tabla de
            archivos, lo que significa que comparten cl archivo y su puntero de posición. En dicha
            tabla observamos que el IDFF del archivo es cl 34512 y que cl puntero PP tiene un valor
            de 10000.
            92 Sistemas operativos. Una visión aplicada




Figura 3.12. Tabla de archivos con los punteros de posición y los descriptores físicos de archivo.

                  Ahora bien, se puede dar el caso de que dos procesos independientes A y B abran
            el mismo archivo, Imaginemos que el proceso A lee 1.000 bytes del archivo y que
            seguidamente el proceso B lee 500 bytes. Está claro que el proceso B, que no tiene nada
            que ver con el proceso A, espera leer los primeros 500 bytes del archivo y no los bytes 1
            .000 a 1 .499. Para evitar esta situación, el sistema operativo asignará una nueva entrada
            en la tabla externa de archivos cada vez que se realice una operación de apertura de
            archivo. De esta forma, cada apertura obtiene su propio PP.
                  La Figura 3.12 presenta esta situación, puesto que analizando el proceso con BCP
            23 se observa que su fd 4 utiliza la entrada 2 de la tabla externa de archivos. Esta entrada
            se refiere al archivo de IDFF = 345 12, que coincide con el de la entrada 4. Los tres
            procesos de la figura comparten el archivo 34512, pero de forma distinta, puesto que los
            de BCP 4 y 7 comparten el PP, mientas que el de BCP 23 utiliza otro puntero de posición
            (Aclaración 3.3).

<!-- pág. 114 -->

      Finalmente, diremos que otra razón que obliga a que las tablas de páginas sean
externas al BCP es para permitir que se pueda compartir memoria. En este caso, como
se analizará en detalle en el Capítulo 4, dos o más procesos comparten parte de sus tablas
de páginas.

Tablas de E/S

En las tablas de entrada/salida el sistema operativo mantiene la información asociada a
los periféricos y a las operaciones de entrada/salida. En general, el sistema operativo
mantendrá una cola por cada dispositivo, en la que se almacenarán las operaciones
pendientes de ejecución, así como la operación en curso de ejecución.


                                                                         Procesos      93

3.4. FORMACIÓN DE UN PROCESO

La formación de un proceso consiste en completar todas las informaciones que lo
constituyen, como se muestra en la Figura 3.13.
De forma más específica, las operaciones que debe hacer el sistema operativo son las
siguientes:

      • Asignar un espacio de memoria para albergar la imagen de memoria. En general,
        este espacio será virtual y estará compuesto por varios segmentos.
      • Seleccionar un BCP libre de la tabla de procesos.
      • Rellenar el BCP con la información de identificación del proceso, con la
        descripción de la memoria asignada, con los valores iniciales de los registros
        indicados en el archivo objeto, etc.
      • Cargar en el segmento de texto el código más las rutinas de sistema y en el
        segmento de datos los datos iniciales contenidos en el archivo objeto.
      • Crear en el segmento de pila la pila inicial del proceso. La pila incluye
        inicialmente el entorno del proceso y los parámetros que se pasan en la
        invocación del programa correspondiente.

    Una vez completada toda la información del proceso, se puede marcar como listo
para ejecutar, dc forma que el planificador, cuando lo considere oportuno, lo seleccione
para su ejecución.



3.5.ESTADOS DEL PROCESO

Como se puede observar en la Figura 3.4, no todos los procesos activos de un sistema
multitarea están en la misma situación. Se diferencian, por tanto, tres estados básicos en
los que puede estar un proceso, estados que detallamos seguidamente:

<!-- pág. 115 -->

                 • Ejecución. En este estado está el proceso que está siendo ejecutado por el
                   procesador, es decir, que está en fase de procesamiento. En esta fase el estado
                   del proceso reside en los registros del procesador.




Figura 3.13. Formación de un proceso.

94 Sistemas operativos. Una visión aplicada


                 • Bloqueado. Un proceso bloqueado está esperando a que ocurra un evento y no
                 puede seguir ejecutando hasta que suceda el evento. Una situación típica de
                 proceso bloqueado se produce cuando el proceso solicita una operación de E/S.
                 Hasta que no termina esta operación, el proceso queda bloqueado. En esta fase, el
                 estado del proceso reside en el BCP.
                 • Listo. Un proceso está listo para ejecutar cuando puede entrar en fase de
                 procesamiento. Dado que puede haber varios procesos en este estado, una de las
                 tareas del sistema operativo será seleccionar aquel que debe pasar a ejecución. El
                 módulo del sistema operativo que toma esta decisión se denomina planificador.
                 En esta fase, el estado del proceso reside en el BCP.

                  La Figura 3. 14 presenta estos tres estados, indicando algunas de las posibles
           transiciones entre ellos. Puede observarse que sólo hay un proceso en estado de
           ejecución, puesto que el procesador solamente ejecuta un programa en cada instante
           (Prestaciones 3. 1). Del estado de ejecución se pasa al estado de bloqueado al solicitar,
           por ejemplo, una operación de EIS. También se puede pasar del estado de ejecución al de
           listo cuando el sistema operativo decide que ese proceso lleva mucho tiempo en
           ejecución. Del estado de bloqueado se pasa al estado de listo cuando se produce el
           evento por el que estaba esperando el proceso (p. ej.: cuando se completa la operación de
           E/S solicitada). Todas las transiciones anteriores están gobernadas por el sistema
           operativo, lo que implica la ejecución del mismo en dichas transiciones.

<!-- pág. 116 -->

           Estados suspendidos

           Además de los tres estados básicos de ejecución, listo y bloqueado, los procesos pueden
           estar en los estados de espera y de suspendido. El diagrama de estados completo de un
           proceso se representa en la Figura 3.15.
           Los procesos entran en el sistema porque lo solicita un proceso de usuario o porque está
           prevista su ejecución hatch. Es frecuente tener una lista de procesos batch en espera
           para ser ejecutados cuando se pueda. El sistema operativo ha de ir analizando dicha lista
           para lanzar la ejecución de los procesos a medida que disponga de los recursos
           necesarios.
           Los procesos salen del sistema cuando mueren, es decir, al ejecutar el servicio
           correspondiente o al producir algún error irrecuperable.




Figura 3.14. Estados básicos de un proceso.
                                                                                   Procesos     95

<!-- pág. 117 -->

Figura 3.15. Diagrama completo con los estados de un proceso.


                  Para disminuir el grado de multiprogramación efectivo, el sistema operativo puede
           suspender algunos procesos, lo que implica que les retira todos sus marcos de páginas,
           dejándolos enteramente en la zona de intercambio. En la Figura 3. ¡5 se muestra cómo
           los procesos listos o bloqueados pueden suspenderse. El objetivo de la suspensión estriba
           en dejar suficiente memoria a los procesos no suspendidos para que su conjunto
           residente tenga un tamaño adecuado que evite la hiperpaginacion.
           No todos los sistemas operativos tienen la opción de suspensión. Por ejemplo, un sistema
           operativo monousuario puede no incluir la suspensión, dejando al usuario la labor de
           cerrar procesos si observa que no ejecutan adecuadamente.
           Los procesos hatch que entran en el sistema lo pueden hacer pasando al estado de listo o
           al de listo suspendido.

           3.5.1.        Cambio de contexto

           Como se vio en el Capítulo 2, la activación del sistema operativo se realiza mediante el
           mecanismo de las interrupciones. Cuando se produce una interrupción se realizan las dos
           operaciones siguientes:

                    • Se salva el estado del procesador en el correspondiente BCP.
                    • Se pasa a ejecutar la rutina de tratamiento de interrupción del sistema operativo.

                Llamaremos cambio de contexto al conjunto de estas operaciones.
                Como resultado del cambio de contexto se puede producir un cambio en el estado
           de algunos procesos, pero no necesariamente. Supóngase que el proceso A está
           bloqueado esperando a que se

<!-- pág. 118 -->

96 Sistemas operativos. Una visión aplicada

           complete una lectura de disco y que llega una interrupción del disco. Se produce un
           cambio de contexto y entra a ejecutar el sistema operativo para tratar la interrupción. En
           el caso de que la interrupción indique que ha terminado la lectura por la que esperaba A,
           el sistema operativo cambiará el estado de este proceso a listo o incluso a ejecución si así
           lo decide el planificador. El resultado final es que ha habido un cambio de estado de
           proceso.
                  Supóngase ahora que está ejecutando el proceso A y que llega una interrupción de
           teclado asociado al proceso B. Se produce el cambio de contexto, pero el proceso B
           puede seguir en estado de bloqueado (no llegó el carácter de fin de línea) y el proceso A
           puede seguir en estado de ejecución, por lo que no hay cambio de estado en ]os procesos.

           Salvaguarda del estado

           Las transiciones en el estado del proceso exigen un trabajo cuidadoso por parte del
           sistema operativo, para que se hagan correctamente. El aspecto más delicado se refiere al
           contenido de los registros de la computadora. Veamos detalladamente los pasos
           involucrados:

                 • Un proceso está en ejecución, por tanto, parte de su información reside en los
                   registros de la máquina, que están siendo constantemente modificados por la
                   ejecución de sus instrucciones de máquina.
                 • Bien sea porque llega una interrupción o porque el proceso solicita un servicio
                   del sistema operativo, el proceso para su ejecución.
                 • Inmediatamente entra a ejecutar el sistema operativo, ya sea para atender la
                   interrupción o para atender el servicio demandado.
                 • La ejecución del sistema operativo, como la de todo programa, modifica los
                   contenidos de los registros de la máquina, destruyendo sus valores anteriores.

               Según la secuencia anterior, si se desea más adelante continuar con la ejecución del
           proceso, se presenta un grave problema: los registros ya no contienen los valores que
           deberían. Supongamos que el proceso está ejecutando la secuencia siguiente:

               LD      .5,# CANT
                                         <= En este punto llega una interrupción y se pasa al SO
               LD      .1, [.5]

                  Supongamos que el valor de CANT es HexA4E78, pero que el sistema operativo
           al ejecutar modifica cl registro . 5 dándole el valor HexEB7A4. Al intentar, más tarde,
           que siga la ejecución del mencionado proceso, la instrucción “LD . 1, [ . 5 ] “ cargará en
           el registro . 1 el contenido de la dirección HexEB7A4 en vez del contenido de la
           dirección HexA4E78.
                  Para evitar esta situación, lo primero que hace el sistema operativo al entrar a
           ejecutar es salvar el contenido de todos los registros, teniendo cuidado de no haber
           modificado el valor de ninguno de ellos. Como muestra la Figura 3.16, al interrumpirse
           la ejecución de un proceso el sistema operativo almacena los contenidos de los registros
           en el BCP de ese proceso (Recordatorio 3.3).

<!-- pág. 119 -->

.

                                                                                       Procesos      97




Figura 3.16. Al interrumpirse la ejecución de un proceso se salva su estado en el BCP.


                Cuando el sistema operativo decide volver a pasar un proceso a estado de ejecución,
            ha dc reintegrar los registros al estado previamente salvado en el BCP. De esta forma, se
            consigue que el proceso pueda seguir ejecutando sin notar ninguna diferencia.

            Activación de un proceso

            El módulo del sistema operativo que pone a ejecutar un proceso se denomina activador
            o dispatcher. La activación de un proceso consiste en copiar en los registros del
            procesador el estado del procesador, que está almacenado en su BCP. De esta forma, el
            proceso continuará su ejecución en las mismas condiciones en las que fue parado. El
            activador termina con una instrucción RETI (Recordatorio 3.4) de retorno de
            interrupción. El efecto de esta instrucción es restituir el registro de estado y el contador
            de programa, lo cual tiene los importantes efectos siguientes:

                  • Al restituir el registro de estado, se restituye el bit que especifica el nivel de
                    ejecución. Dado que cuando fue salvado este registro el bit indicaba nivel de
                    usuario, puesto que estaba ejecutando un proceso, su restitución garantiza que el
                    proceso seguirá ejecutando en nivel de usuario.
                  • Al restituir el contador de programa, se consigue que la siguiente instrucción
                    máquina que ejecute el procesador sea justo la instrucción en la que fue
                    interrumpido el proceso. En este momento es cuando se ha dejado de ejecutar el
                    sistema operativo y se pasa a ejecutar el proceso.

<!-- pág. 120 -->

98       Sistemas operativos. Una visión aplicada


     3.6. PROCESOS LIGEROS


     Un proceso ligero, o thread, es un programa en ejecución (flujo de ejecución) que
     comparte la imagen de memoria y otras informaciones con otros procesos ligeros. Como
     muestra la Figura 3.17, un proceso puede contener un solo flujo de ejecución, como
     ocurre en los procesos clásicos, o más de un flujo de ejecución (procesos ligeros).
           Desde el punto de vista de la programación, un proceso ligero se define corno una
     función cuya ejecución se puede lanzar en paralelo con otras. El hilo de ejecución
     primario, o proceso ligero primario, corresponde a la función main.
           Cada proceso ligero tiene informaciones que le son propias y que no comparte con
     otros
     procesos ligeros. Las informaciones propias se refieren fundamentalmente al contexto de
     ejecución, pudiéndose destacar las siguientes:

          • Contador de programa.
          • Pila.
          • Registros.
          • Estado del proceso ligero (ejecutando, listo o bloqueado).


     Todos los procesos ligeros de un mismo proceso comparten la información del mismo.
     En concreto, comparten:
          • Espacio de memoria.
          • Variables globales.
          • Archivos abiertos.
          • Procesos hijos.
          • Temporizadores.
          • Señales y semáforos.
          • Contabilidad.

           Es importante destacar que todos los procesos ligeros de un mismo proceso
     comparten el mismo espacio de direcciones de memoria, que incluye el código, los datos
     y las pilas de los diferentes procesos ligeros. Esto hace que no exista protección de
     memoria entre los procesos ligeros de un mismo proceso, algo que sí ocurre con los
     procesos convencionales.

<!-- pág. 121 -->

                 El proceso ligero constituye la unidad ejecutable en Windows NT. La Figura 3. IX
           representa de forma esquemática la estructura de un proceso de Windows NT con sus
           procesos ligeros.




Figura 3.17. Proceso ligero.
                                                                                     Procesos      99




Figura 3.18. Estructura de un proceso en Windows NT


           3.6.1.      Estados del proceso ligero

           El proceso ligero puede estar en uno de los tres estados siguientes: ejecutando, listo para
           ejecutar y bloqueado. Como muestra la Figura 3.19, cada proceso ligero de un proceso
           tiene su propio estado, pudiendo estar unos bloqueados, otros listos y otros en ejecución
           (Aclaración 3.4).

<!-- pág. 122 -->

                 El estado del proceso será ¡a combinación de los estados de sus procesos ligeros.
           Por ejemplo, si tiene un proceso ligero en ejecución, el proceso está en ejecución. Si no
           tiene proceso ligeros en ejecución, pero tiene alguno listo para ejecutar, el proceso está
           en estado de listo. Finalmente, si todos sus procesos ligeros están bloqueados, el proceso
           está bloqueado. No tiene sentido el estado dc suspendido, puesto que si el proceso está
           suspendido, todos sus procesos ligeros lo estarán.




Figura 3.19. Estado dc un proceso ligero.
100 Sistemas operativos. Una visión aplicada


           3.6.2.Paralelismo

           Los procesos ligeros permiten paralelizar una aplicación, tal y como muestra la Figura
           3.20. En efecto, cuando un programa puede dividirse en procedimientos que pueden
           ejecutar de forma independiente, el mecanismo de los procesos ligeros permite lanzar
           simultáneamente la ejecución de todos ellos. De esta forma se consigue que el proceso
           avance más rápidamente (Prestaciones 3.2).




           La base de este paralelismo estriba en que, mientras un proceso ligero está bloqueado,
           otro puede ejecutar.
           Comparando el uso de los procesos ligeros con otras soluciones se puede decir que:

                 • Los procesos ligeros:

                 — Permiten paralelismo y variables compartidas.
                 — Utilizan llamadas al sistema bloqueantes por proceso ligero. Esta es la solución
                 más sencilla de conseguir paralelismo desde el punto de vista de la programación.

                 • Un proceso convencional con un solo proceso ligero:

                 — No hay paralelismo.

<!-- pág. 123 -->

                     — Utiliza llamadas al sistema bloqueantes.

                     • Un proceso con un solo proceso ligero, que usa llamadas no bloqueantes y
                     estructurado en máquina de estados finitos:

                     — Permite paralelismo.
                     — Utiliza llamadas al sistema no bloqueantes, lo que lleva a un diseño muy
                     complejo y difícil de mantener.




Figura 3.20. Los procesos ligeros permiten paralelizar la ejecución de una aplicación.
                                                                                   Procesos       101


                     •    Varios procesos convencionales cooperando:

                 — Permite paralelismo.
                 — No comparte variables, por lo que la comunicación puede consumir mucho
            tiempo.



            3.6.3.        Diseño con procesos ligeros

            La utilización de procesos ligeros ofrece las ventajas de división de trabajo que dan los
            procesos, pero con una mayor sencillez, lo que se traduce en mejores prestaciones. En
            este sentido, es de destacar que los procesos ligeros comparten memoria directamente,
            por lo que no hay que añadir ningún mecanismo adicional para utilizarla, y que la
            creación y destrucción de procesos ligeros requiere mucho menos trabajo que la de
            procesos.
            Las ventajas de diseño que se pueden atribuir a los procesos ligeros son las siguientes:

                     • Permite separación de tareas. Cada tarea se puede encapsular en un proceso
                       ligero independiente.
                     • Facilita la modularidad, al dividir trabajos complejos en tareas.
                     • Aumenta la velocidad de ejecución del trabajo, puesto que aprovecha los tiempos
                       de bloqueo de unos procesos ligeros para ejecutar otros.

<!-- pág. 124 -->

       El paralelismo que permiten los procesos ligeros, unido a que comparten memoria
(utilizan variables globales que ven todos ellos), permite la programación concurrente.
Este tipo de programación tiene un alto nivel de dificultad, puesto que hay que garantizar
que el acceso a los datos compartidos se haga de forma correcta. Los principios básicos
que hay que aplicar son los siguientes:

      • Hay variables globales que se comparten entre varios procesos ligeros. Dado que
      cada proceso ligero ejecuta de forma independiente a los demás, es fácil que
      ocurran accesos incorrectos a estas variables.
      • Para ordenar la forma en que los procesos ligeros acceden a los datos se emplean
      mecanismos de sincronización, como el mutex, que se describirán en el Capítulo 5.
      El objetivo de estos mecanismos es impedir que un proceso ligero acceda a unos
      datos mientras los esté utilizando otro.
      • Para escribir código correcto hay que imaginar que los códigos de los otros
      procesos ligeros que pueden existir están ejecutando cualquier sentencia al mismo
      tiempo que la sentencia que se está escribiendo.

Diseño de servidores mediante procesos ligeros

Una de las aplicaciones típicas de los procesos ligeros es el diseño de procesos
servidores paralelos.
La Figura 3.21 muestra tres posibles soluciones. En la primera se plantea un proceso
ligero distribuidor cuya función es la recepción de las órdenes y su traspaso a un proceso
ligero trabajador. El esquema puede funcionar creando un nuevo proceso ligero
trabajador por cada solicitud dc servicio, proceso ligero que muere al finalizar su trabajo,
o teniendo un conjunto de ellos creados a los que se va asignando trabajo y que quedan
libres al terminar la tarea encomendada. Esta segunda alternativa es más eficiente, puesto
que se evita el trabajo de crear y destruir a los procesos ligeros.

<!-- pág. 125 -->

102 Sistemas operativos. Una visión aplicada




Figura 3.21. Ejemplos de diseño de servidores paralelos mediante procesos ligeros.


           La segunda solución consiste en disponer de un conjunto de procesos ligeros iguales,
           todos los cuales pueden aceptar una orden (leer de un puerto en el caso de la figura).
           Cuando llega una solicitud, la recibe uno de los procesos ligeros que están leyendo del
           puerto. Este proceso ligero tratará la petición y, una vez finalizado el trabajo solicitado,
           volverá a la fase de leer una nueva petición del puerto.
           La tercera solución aplica la técnica denominada de segmentación (pipe-line). Cada
           trabajo se divide en una serie de fases, encargándose de cada una de ellas un proceso
           ligero especializado. El esquema permite tratar al mismo tiempo tantas solicitudes como
           fases tenga la segmentación, puesto que se puede tener una en cada proceso ligero.


           3.7.         PLANIFICACIÓN

           El objetivo de la planificación de procesos y procesos ligeros es el reparto del tiempo de
           procesador entre los procesos que pueden ejecutar. El planificador es el módulo del
           sistema operativo que realiza la función de seleccionar el proceso en estado de listo que
           pasa a estado de ejecución, mientras que el activador es el módulo que pone en
           ejecución el proceso planificado.
           Los sistemas pueden incluir varios niveles de planificación de procesos. La Figura 3.22
           muestra el caso de tres niveles: corto, medio y largo plazo.
           La planificación a largo plazo tiene por objetivo añadir nuevos procesos al sistema,
           tomándolos de la lista de espera. Estos procesos son procesos de tipo batch, en los que
           no importa el instante preciso en el que se ejecuten (siempre que se cumplan ciertos
           límites de espera).
           La planificación a medio plazo trata la suspensión de procesos. Es la que decide qué
           procesos pasan a suspendido y cuáles dejan de estar suspendidos. Añade o elimina
           procesos de memoria principal modificando, por tanto, el grado de multiprogramación.
           La planificación a corto plazo se encarga de seleccionar el proceso en estado de listo
           que pasa a estado de ejecución. Es, por tanto, la que asigna el procesador.
           También es importante la planificación de entrada/salida. Esta planificación decide el
           orden en que se ejecutan las operaciones de entrada/salida que están encoladas para cada
           periférico.

           Expulsión

<!-- pág. 126 -->

            La planificación puede ser con expulsión o sin ella. En un sistema sin expulsión un
            proceso conserva el procesador mientras lo desee, es decir, mientras no solicite del
            sistema operativo un servicio que lo bloquee. Esta solución minimiza el tiempo que gasta
            el sistema operativo en planificar y
                                                                                    Procesos    130




Figura 3.22. Tipos de planificación.

            activar procesos, pero tiene como inconveniente que un proceso puede monopolizar el
            procesador (imagínese lo que ocurre si el proceso, por error, entra en un bucle infinito).
                  En los sistemas con expulsión, el sistema operativo puede quitar a un proceso del
            estado de ejecución aunque éste no lo solicite. Esta solución permite controlar el tiempo
            que está en ejecución un proceso, pero requiere que el sistema operativo entre de forma
            sistemática a ejecutar para así poder comprobar si el proceso ha superado su límite de
            tiempo de ejecución. Como sabemos, las interrupciones sistemáticas del re]oj garantizan
            que el sistema operativo entre a ejecutar cada pocos milisegundos, pudiendo determinar
            en estos Instantes si ha de producirse un cambio dc proceso o no.

            Colas de procesos

            Para realizar las funciones de planificación, el sistema operativo organiza los procesos
            listos en una serie de estructuras de información que faciliten la búsqueda del proceso a
            planificar. Es muy frecuente organizar los procesos en colas de prioridad y de tipo.
                    La Figura 3.23 muestra un ejemplo con 30 colas para procesos interactivos y 2
            colas para procesos batuh. Las 30 colas interactivas permiten ordenar los procesos listos
            interactivos según 30 niveles dc prioridad, siendo, por ejemplo, el nivel 0 el más
            prioritario. Por su lado, las dos colas batch permiten organizar los procesos listos batch
            en dos niveles de prioridad.
                   Se puede observar en la mencionada figura que se ha incluido una palabra
            resumen. Esta palabra contiene un 1 si la correspondiente cola tiene procesos y un 0 si

<!-- pág. 127 -->

             está vacía. De esta forma, se acelera cl planificador, puesto que puede saber rápidamente
             dónde encontrará procesos listos.




       104       Sistemas operativos. Una visión aplicada




Figura 3.23. Colas de planificación.

                   Corno muestra la Figura 3.24, las colas de procesos se construyen con unas
             cabeceras y con unos punteros que están incluidos en los BCP. Dado que un proceso está
             en cada instante en una sola cola de planificación, es necesario incluir un solo espacio de
             puntero en su BCP, como muestra la Figura 3.24.


             Objetivos de la planificación

             El objetivo de la planificación es optimizar el comportamiento del sistema. Ahora bien,
             el comportamiento de un sistema informático es muy complejo, por tanto, el objetivo de
             la planificación se deberá centrar en la faceta del comportamiento en el que se esté
             interesado. Entre los objetivos que se suelen perseguir están los siguientes:

             •   Reparto equitativo del procesador.
             •   Eficiencia (optimizar el uso del procesador).
             •   Menor tiempo de respuesta en uso interactivo.
             •   Menor tiempo de espera en lotes (batch).
             •   Mayor número de trabajos por unidad de tiempo (batch).
             •   Cumplir los plazos de ejecución de un sistema de tiempo real.

<!-- pág. 128 -->

Figura 3.24. Implementación de las colas de planificación.
                                                                        Procesos     105

       La mayoría de estos objetivos son incompatibles entre sí, por lo que hay que
centrar la atención en aquel que sea de mayor interés. Por ejemplo, una planificación que
realice un reparto equitativo del procesador no conseguirá optimizar el uso del mismo.
       Hay que observar que algunos objetivos están dirigidos a procesos interactivos,
mientras que otros lo están a procesos batch.

3.7.1.     Algoritmos de planificación

En esta sección se presentan los algoritmos de planificación más usuales.


Cíclica o Round-robin

El algoritmo cíclico está diseñado para hacer un reparto equitativo del tiempo del
procesador, por lo que está especialmente destinado a los sistemas de tiempo
compartido. El algoritmo se basa en el concepto de rodaja (slot) de tiempo.
       Los procesos están organizados en forma de cola circular, eligiéndose para su
ejecución el proceso cabecera de la cola. Un proceso permanecerá en ejecución hasta que
ocurra una de las dos condiciones siguientes:
• El proceso pasa a estado de bloqueado, porque solicita un servicio del sistema
  operativo.
• El proceso consume su rodaja de tiempo, es decir, lleva ejecutando el tiempo
  estipulado de rodaja.

       Un proceso que ha consumido su rodaja de tiempo es expulsado y pasa a ocupar el
último lugar en la cola. De esta forma, se consigue que todos los procesos pasen a
ejecutar, repartiendo el tiempo del procesador de forma homogénea entre ellos. La
Figura 3.25 muestra cómo el proceso 5, al consumir su rodaja de tiempo, pasa al final de
la cola.
Según se construya el planificador, los procesos que pasan de bloqueados a listos se
pueden incluir como primero o como último de la cola.

<!-- pág. 129 -->

          FIFO

          En este caso, la cola de procesos en estado de listo está ordenada de acuerdo al instante
          en que los procesos pasan al estado de listo. Los que llevan más tiempo esperando están
          más cerca de la cabecera.
                 El algoritmo es sencillo, puesto que consiste en tomar para ejecutar al proceso de
          la cabecera de la cola. No se plantea expulsión, por lo que el proceso ejecuta hasta que
          realiza una llamada bloqueante al sistema operativo.
                Es aplicable a los sistemas batch, pero no a los interactivos.




          Figura 3.25. Planificación cíclica.


106   Sistemas operativos. Una visión aplicada

          Prioridades

          En el algoritmo de prioridades se selecciona para ejecutar el proceso en estado de listo
          que tenga la máxima prioridad.
          Cuando las prioridades son fijas puede surgir el problema de la inanición, que implica
          que un proceso puede estar esperando indefinidamente sin llegar a ejecutar. Esto ocurrirá
          si van apareciendo siempre procesos de mayor prioridad que estén en estado de listo.
          Para evitar este problema, se puede añadir un mecanismo de envejecimiento, que se
          encargue dc aumentar la prioridad a los procesos que lleven un determinado tiempo
          esperando a ser ejecutados. Por ejemplo, suponiendo que la mayor prioridad es la 0, un
          proceso de prioridad 22 que lleve más de X ms esperando en estado de listo pasaría a
          prioridad 21, si pasados otros X ms siguiese sin ejecutar pasaría a prioridad 20 y así
          sucesivamente. Una vez que haya ejecutado volverá a tomar su prioridad normal de 22.
          Dado que puede haber varios procesos listos con el mismo nivel de prioridad, es
          necesario utilizar otro algoritmo para decidir entre ellos. Se podría utilizar, por ejemplo,
          un cíclico, si el sistema es interactivo o un FIFO si es hatch. Los algoritmos basados en
          prioridades suelen ser con expulsión.

          Primero el trabajo más corto

          Este algoritmo exige conocer a priori el tiempo de ejecución de los procesos, por lo que
          es aplicable a trabajos batch repetitivos cuyo comportamiento se tenga analizado.
           El algoritmo consiste en seleccionar para ejecución al proceso listo con menor tiempo
          de ejecución. No se plantea expulsión, por lo que el proceso sigue ejecutándose mientras
          lo desee.
          La ventaja de este algoritmo es que produce el menor tiempo de respuesta, pero a costa
          de penalizar los trabajos de mayor tiempo de ejecución. También puede sufrir de

<!-- pág. 130 -->

            inanición, puesto que, en el caso de que estén continuamente apareciendo procesos con
            tiempo de ejecución pequeño, un proceso largo puede no llegar a ejecutar.

            Aleatorio o lotería

            Este algoritmo consiste en elegir al azar el proceso a ejecutar. Se puede basar en un
            generador de números pseudoaleatorios.

            Planificación de sistemas de tiempo real

            Los sistemas de tiempo real se caracterizan porque los procesos tienen que ejecutar en
            instantes predeterminados. Se pueden diferenciar dos tipos de procesos de tiempo real: a
            plazo fijo y periódico. La diferencia estriba en que los de plazo fijo tienen que ejecutar
            una vez, en un instante determinado, mientras que los periódicos deben ejecutar de forma
            repetitiva cada cierto tiempo.
            Como muestra la Figura 3.26, se asocia a cada proceso el instante en el que debe
            ejecutar. Los procesos que no han alcanzado su tiempo de ejecución están en una cola de
            espera, mientras que los que han alcanzado el tiempo de ejecución pasan a las colas de
            listo para ejecutar. La planificación consiste en seleccionar de entre estos últimos el
            proceso a ejecutar.
            La planificación de tiempo real está basada en el reloj de tiempo de la computadora y su
            objetivo es conseguir que no se retrase la ejecución de los procesos. En los denominados
            sistemas de tiempo real críticos, los procesos tienen asignada una franja de tiempo en la
            cual deben ejecutar y. en ningún caso, se ha de rebasar el tiempo máximo sin que el
            proceso complete su ejecución.

                                                                                   Procesos       107




Figura 3.26. Planificación de sistemas de tiempo real.

                  Los sistemas de tiempo real se suelen diseñar de forma que estén bastante
            descargados, es decir, que tengan pocos procesos en estado de listo. De esta forma se
            consigue que no se retrase la ejecución de los mismos. Además, se evitan los
            mecanismos que introducen retardos en la ejecución, como puede ser la memoria virtual,
            puesto que la paginación puede introducir retardos inadmisibles en la ejecución.

            Valoración de los algoritmos de planificación

            En la valoración de los algoritmos de planificación hay que tener en cuenta los
            beneficios que presenta cada una de las alternativas a analizar. Además, no hay que

<!-- pág. 131 -->

           olvidar el tiempo de procesador que se consume debido al propio algoritmo (tiempo
           gastado en añadir elementos a las colas, ordenar éstas y analizarlas). En este sentido, un
           algoritmo menos bueno pero muy simple, como el aleatorio, que consume muy poco
           tiempo de procesador, puede ser globalmente mejor que otro más sofisticado, puesto que
           la ganancia de rendimiento conseguida puede no compensar el mayor tiempo consumido.


           3.7.2. Planificación en POSIX

           POSIX especifica una serie de políticas de planificación, aplicables a procesos y
           procesos ligeros, que debe implementar cualquier sistema operativo que ofrezca esta
           interfaz. En POSIX cada unidad ejecutable (proceso o proceso ligero) lleva asociada una
           política de planificación y una prioridad. Estos parámetros, como se verá en la Sección
           3.11, pueden ser modificados mediante los servicios correspondientes.
                  Cada política de planificación lleva asociada un rango de prioridades. POSIX
           especit5ca que cada implementación debería ofrecer un rango de, al menos, 32 niveles de
           prioridad. El planificador elegirá siempre para ejecutar el proceso o proceso ligero con la
           prioridad más alta. Las políticas de planificación disponibles en POSIX son las
           siguientes:
             • FIFO: Los procesos que se planifican según esta política se introducen al final de la
               cola de su prioridad asociada. Un proceso con esta política de planificación sólo se
               expulsará de la UCP cuando ejecute una llamada al sistema bloqueante o cuando
               aparezca en el sistema un proceso con mayor prioridad. El comportamiento del
               planificador para este tipo de planilicación viene dado por las siguientes reglas:
               __ Si un proceso es expulsado de la UCP por otro de mayor prioridad, el proceso
                    expulsado pasa a ser el primero de la cola asociada a su prioridad




108 Sistemas operativos. Una visión aplicada

— Cuando un proceso bloqueado pasa a listo para ejecutar, el proceso se introduce al    final de la
                   cola asociada a su prioridad.
— Cuando un proceso cambia su prioridad o su política de planificación, utilizando para ello los
                   servicios adecuados, se realiza una replanificación. Si como resultado de ésta
                   el proceso resulta expulsado, éste se introduce al final de la cola de procesos
                   de su prioridad.

             • Cíclica: En este caso, los procesos de cada nivel de prioridad se planifican según una
               política de planificación cíclica con una determinada rodaja de tiempo. El
               comportamiento del planificador para los procesos con este tipo de planificación es
               el siguiente:

— Cuando un proceso acaba su rodaja de tiempo, se introduce al final de la cola de procesos de su
                   prioridad.
— Cuando un proceso es expulsado por otro de mayor prioridad, se introduce al principio de su cola
                   sin restaurar su rodaja de tiempo. De esta forma, cuando el proceso continúe la
                   ejecución, lo hará hasta que consuma el resto de la rodaja de tiempo.

<!-- pág. 132 -->

  • Otra: Hace referencia a una política de planificación cuyo comportamiento depende
  de cada implementación. De acuerdo a esto, todo sistema operativo que siga la norma
  POSIX debe ofrecer al menos dos políticas de planificación: FIFO y cíclica, pudiendo,
  además, ofrecer otra política de planificación.

       Observe que la política de planificación se realiza por proceso y, por tanto, las tres
políticas conviven en el planificador. Observe, además, que la planificación en POSIX es
con expulsión.

3.7.3. Planificación en Windows NT/2000

En Windows NT la unidad básica de ejecución es el proceso ligero y, por tanto, la
planificación se realiza sobre este tipo de procesos. La Figura 3.27 (tomada de
(Solomon, 1998) ) describe los distintos estados por los que puede pasar un proceso
ligero durante su ejecución. Estos estados son:

• Listo. Los procesos ligeros en este estado están listos para ejecutar.
• Reserva. Un proceso ligero en este estado será el siguiente proceso ligero a ejecutar
en un procesador determinado. Sólo puede haber un proceso ligero en este estado por
procesador.
• Ejecución. El proceso ligero permanece ejecutando hasta que se cumpla alguna de
estas condiciones: el sistema operativo lo expulsa para ejecutar un proceso ligero de
mayor prioridad, la rodaja de tiempo del proceso termina o bien el proceso ligero finaliza
su ejecución.
• Bloqueado. Cuando el proceso ligero deja de estar bloqueado puede, dependiendo de
su prioridad, comenzar su ejecución inmediatamente o pasar al estado de listo para
ejecutar.
• Transición. Un proceso ligero entra en este estado cuando está listo para ejecutar,
pero la pila que utiliza el sistema operativo para ese proceso no reside en memoria
principal. Cuando la página vuelva a memoria, el proceso ligero pasará al estado de listo
para ejecutar.
• Finalizado. Cuando un proceso ligero finaliza su ejecución, pasa a este estado. Una
vez terminado, el proceso ligero puede o no ser eliminado del sistema. En caso de no ser
eliminado, podría ser reutilizado de nuevo.

                                                                               Procesos 109

      Windows NT implementa una planificación cíclica con prioridades y con
expulsión. En Windows NT existen 32 niveles de prioridad, de 0 a 31, siendo 31 el nivel
de prioridad máximo. Estos niveles se dividen en tres categorías:

<!-- pág. 133 -->

           Figura 3.27. Estados de los procesos ligeros en Windows NT



           •   Dieciséis niveles con prioridades de tiempo real (niveles 16 al 31).
           •   Quince niveles con prioridades variables (niveles 1 al 15).
           •   Un nivel de sistema (0).

                 Todos los procesos ligeros en el mismo nivel se ejecutan según una política de
           planificación cíclica con una determinada rodaja de tiempo (Prestaciones 3.3). En la
           primera categoría, todos los procesos ligeros tienen una prioridad fija. En la segunda, los
           procesos comienzan su ejecución con una determinada prioridad y ésta va cambiando
           durante la vida del proceso, pero sin llegar al nivel 16. Esta prioridad se modifica según
           el comportamiento que tiene el proceso durante su ejecución. Así, un proceso (situado en
           el nivel de prioridades variable) ve decrementada su prioridad si acaba la rodaja de
           tiempo. En cambio, si el proceso se bloquea, por ejemplo, por una petición de E/S
           bloqueante, su prioridad aumentará. Con esto se persigue mejorar el tiempo de respuesta
           de los procesos interactivos que realizan E/S.




110 Sistemas operativos. Una visión aplicada

<!-- pág. 134 -->

3.8.    SEÑALES Y EXCEPCIONES

Cuando un sistema operativo desea notificar a un proceso la ocurrencia de un
determinado evento, o error, recurre a dos tipos de mecanismos: señales y excepciones.
Las primeras se utilizan en POS IX y las segundas en Windows NT. En las siguientes
secciones se tratan estos dos mecanismos.



3.8.1. Señales

Las señales tienen frente al proceso el mismo comportamiento que las interrupciones
tienen frente al procesador, por lo que se puede decir que una señal es una interrupción al
proceso.
   El proceso que recibe una señal se comporta, como muestra la Figura 3.28, de la
siguiente forma:

       • El proceso detiene su ejecución en la instrucción de máquina que está
         ejecutando.
       • Bifurca a ejecutar una rutina de tratamiento de la señal, cuyo código ha de
         formar parte del propio proceso.
       • Una vez ejecutada la rutina de tratamiento, sigue la ejecución del proceso en la
         instrucción en el que fue interrumpido.

El origen de una señal puede ser un proceso o el sistema operativo.


Señal proceso → proceso

Un proceso puede enviar una señal a otro proceso que tenga el mismo identificador de
usuario (uid), a no los que lo tengan distinto (Aclaración 3.5). Un proceso también puede
mandar una señal a un grupo de procesos, que han de tener su mismo uid.




Señal sistema operativo → proceso

El sistema operativo también toma la decisión de enviar señales a los procesos cuando
ocurren determinadas condiciones. Por ejemplo, las excepciones de ejecución programa
(el desbordamiento

<!-- pág. 135 -->

Figura 3.28. Recepción de una señal por parte de un proceso.
                                                                                    Procesos       111

           en las Operaciones aritméticas, la división por cero, el intento de ejecutar una instrucción
           con código de operación incorrecto o de direccionar una posición de memoria prohibida)
           las convierte el sistema operativo en señales al proceso que ha causado la excepción.


           Tipos de señales

           Dado que las señales se utilizan para indicarle al proceso muchas cosas diferentes,
           existen una gran variedad de ellas. A título de ejemplo, se incluyen aquí tres categorías
           de señales:

                   •   Excepciones hardware.
                   •   Comunicación.
                   •   FIS asíncrona.

           Efecto de la señal y armado de la misma

           Como se ha indicado anteriormente, el efecto de la señal es ejecutar una rutina de
           tratamiento. Para que esto sea así, cl proceso debe tener armada ese tipo de señal, es
           decir, ha de estar preparado para recibir dicho tipo de señal.
                  Armar una señal significa indicar al sistema operativo el nombre de la rutina del
           proceso que ha de tratar ese tipo de señal, lo que, como veremos, se consigue en POSIX
           con el servicio sigaction.
                  Algunas señales admiten que se las ignore, lo cual ha de ser indicado por el
           proceso al sistema operativo. En este caso, el sistema operativo simplemente desecha las
           señales ignoradas por ese proceso. Un proceso también puede enmascarar diversos tipos
           de señales. El efecto es que las señales enmascaradas quedan bloqueadas (no se
           desechan), a la espera de que el proceso las desenmascare.
                  Cuando un proceso recibe una señal sin haberla armado o enmascarado
           previamente, se ejecuta la acción por defecto, que en la mayoría de los casos consiste en
           matar al proceso (Aclaración 3.6).




           3.8.2. Excepciones

<!-- pág. 136 -->

      Una excepción es un evento que ocurre durante la ejecución de un programa y que
      requiere la ejecución dc un fragmento de código situado fuera del flujo normal de
      ejecución.
      Las excepciones son generadas por el hardware o el software. Ejemplos de excepciones
      hardware incluyen la división por cero o la ejecución de instrucciones ilegales. Las
      excepciones software incluyen aquellas detectadas y notificadas por el sistema operativo
      o el propio proceso. Cuando ocurre una excepción, tanto hardware como software, el
      control es transferido al Sistema operativo, que ejecuta la rutina de tratamiento de
      excepción correspondiente. Esta rutina crea un registro de excepción que contiene
      información sobre la excepción generada. Si existe un manejador para la excepción
      generada, el sistema operativo transfiere el control a dicho manejador, en caso contrario
      aborta la ejecución del proceso.

112      Sistemas operativos. Una visión aplicada


            El manejo de excepciones necesita el soporte del lenguaje de programación para
      que el programador pueda especificar el manejador a ejecutar cuando se produzca una
      excepción. Un esquema habitual es el que se presenta a continuación:

      try{
          Bloque donde puede producirse una excepción
      }
      except{
          Bloque que se ejecutará si se produce una excepción
          en el bloque anterior
      }


             En el esquema anterior, el programador encierra dentro del bloque try el fragmento
      de código que quiere proteger de la generación de excepciones. En el bloque except sitúa
      el manejador de excepciones. En caso de generarse una excepción en el bloque try, el
      sistema operativo transfiere el control al bloque except que se encargará de manejar la
      correspondiente excepción.
             Windows NT utiliza el mecanismo de excepciones, similar al anterior, para
      notificar a los procesos los eventos o errores que surgen como consecuencia del
      programa que están ejecutando. Win32 hace uso del concepto de manejo de
      excepciones estructurado que permite a las aplicaciones tomar el control cuando ocurre
      una determinada excepción. Este mecanismo será tratado en la Sección 3.12.4.

      3.9. TEMPORIZADORES

      El sistema operativo mantiene en cada BCP un temporizador que suele estar expresado
      en segundos. Cada vez que la rutina del sistema operativo que trata las interrupciones de
      reloj comprueba que ha transcurrido un segundo, decrementa todos los temporizadores
      que no estén a «0» y comprueba si han llegado a «0». Para aquellos procesos cuyo
      temporizador acaba de llegar a «0», el sistema operativo notifica al proceso que el
      temporizador ha vencido. En POSIX se genera una señal SIGALRN. En Win32 se
      ejecuta una función definida por el usuario y que se asocia al temporizador.
             El proceso activa el temporizador mediante un servicio en el que especifica el
      número de segundos o milisegundos que quiere temporizar. Cuando vence la

<!-- pág. 137 -->

temporización, recibirá la correspondiente señal o se ejecutará la función asociada al
mismo.

3.10. SERVIDORES Y DEMONIOS

Los servidores y los demonios son dos tipos de procesos muy frecuentes y que tienen
unas características propias que se analizan seguidamente.
Un servidor es un proceso que está pendiente de recibir órdenes de trabajo que provienen
de otros procesos, que se denominan clientes. Una vez recibida la orden, la ejecuta y
responde al peticionario con el resultado. La Figura 3.29 muestra cómo el proceso
servidor atiende a los procesos clientes.

El proceso servidor tiene la siguiente estructura de bucle infinito:

    •   Lectura de orden. El proceso está bloqueado esperando a que llegue una orden.
    •   Recibida la orden, el servidor la ejecuta.

                                                                               Procesos 113




Figura 3.29. Proceso servidor.


        • Finalizada la ejecución, el servidor responde con el resultado al proceso cliente
          y vuelve al punto de lectura de orden.

      Una forma muy difundida de realizar la comunicación entre el proceso cliente y el
servidor es mediante puertos. El proceso servidor tiene abierto un puerto, del que lee las
peticiones. En la solicitud, el proceso cliente envía el identificador del puerto en el que el
servidor debe contestar.
      Un servidor será secuencial cuando siga estrictamente el esquema anterior. Esto
implica que hasta que no ha terminado el trabajo de una solicitud no admite otra. En
muchos casos interesa que el servidor sea paralelo, es decir, que admita varias peticiones
y las atienda simultáneamente. Para conseguir este paralelismo se puede proceder de la
siguiente manera:

<!-- pág. 138 -->

      • Lectura de la orden. El proceso está bloqueado esperando a que llegue una
      orden.
      • Asignación de un nuevo puerto para el nuevo cliente.
      • Generación de un proceso hijo que realiza el trabajo solicitado por el cliente.
      • Vuelta al punto de lectura de orden.

      De esta forma, el proceso servidor dedica muy poco tiempo a cada cliente, puesto
que el trabajo lo realiza un nuevo proceso, y puede atender rápidamente nuevas
peticiones. La Figura 3.30 muestra esta secuencia.




Figura 3.30. Funcionamiento de un proceso servidor.


 114 Sistemas operativos. Una visión aplicada




Figura 3.31. proceso cliente servidor en maquinas distintas

      La Figura 3.21 presenta otras estrategias para diseñar servidores paralelos,
mientras que la figura 3.3 muestra que los procesos cliente y servidor pueden estar en
máquinas distintas.
      Un proceso demonio es un proceso que suele tener las siguientes características:

    • Se arranca al iniciar el sistema, puesto que debe estar siempre activo.
    • No muere. En caso de que un demonio muera por algún imprevisto es muy
      recomendable que exista un mecanismo que detecte la muerte y lo rearranque.
    • En muchos casos está a la espera de un evento. En el caso frecuente de que el
      demonio sea un servidor, el evento por el que espera es que llegue una petición al
      correspondiente puerto.
    • En otros casos, el demonio tiene encomendada una labor que hay que hacer de
      forma periódica. ya sea cada cierto tiempo o cada vez que una variable alcanza un
      determinado valor.

<!-- pág. 139 -->

    • Es muy frecuente que no haga directamente el trabajo: lanza otros procesos para
      que lo realicen.
    • Los procesos servidores suelen tener el carácter de demonios.
    • Los demonios ejecutan en haekground y no están asociados a un terminal o
      procesos login.

   Como ejemplos de procesos servidores se pueden citar los siguientes: el servidor de
FTP el servidor de TELNET, el servidor de WEB y el spooler de impresora.

3.11.       SERVICIOS POSIX

Esta sección describe los principales servicios que ofrece POSIX para la gestión de
procesos, procesos ligeros y planificación. También se presentan los servicios que
permiten trabajar con señales y temporizadores


3.11.1.     Servicios POSIX para la gestión de procesos

En esta sección se describen los principales servicios que ofrece POSIX para la gestión
de procesos. Estos servicios se han agrupado según las siguientes categorías:

        •   Identificación de procesos.
        •   El entorno de un proceso.
        •   Creación de procesos.
        •   Terminación de procesos.

                                                                            Procesos 115

       En las siguientes secciones se presentan los servicios incluidos en cada una de
estas categorías.

Identificación de procesos

POSIX identifica cada proceso por medio de un entero único denominado identificador
de proceso de tipo pid_ti. Los servicios relativos a la identificación de los procesos son
los siguientes:

a) Obtener el identificador de proceso

Este servicio devuelve el identificador del proceso que realiza la llamada. Su prototipo
en C lenguaje es el siguiente:

        Pid_t getpid(void);

b) Obtener el identificador del proceso padre

Devuelve el identificador del proceso padre. Su prototipo es el que se muestra a
continuación.


        pid ti getppid(void);

<!-- pág. 140 -->

           El Programa 3. 1 muestra un ejemplo de utilización de ambas llamadas.
           _______________________________________________________________________
           Programa 3.1. Programa que imprime el identificador del proceso y el identificador de
           su proceso padre.

           # include <sys/types.h>
           #include <stdio.h>
           main ( )
           {
                   pid_id_proceso;
                   pid_id_padre;

                   id proceso = getpid ( );
                   id_padre = getppid ( );

                   printf(”identificador de proceso: %d\n”, íd_proceso>;
                   printlf(”identificador del proceso padre: %d\n”, Id_padre>;
           }
           _______________________________________________________________________

                 Cada proceso, además, lleva asociado un usuario que se denomina propietario.
           Cada usuario en el sistema tiene un identificador único denominado identificador de
           usuario, de tipo uid_ti. El proceso tiene también un identificador de usuario efectivo, que
           determina los privilegios que un proceso tiene cuando se encuentra ejecutando. El
           sistema incluye también grupos de usuarios, cada usuario debe ser miembro al menos de
           un grupo. Al igual que con los usuarios, cada proceso lleva asociado cl identificador de
           grupo al que pertenece y el identificador de grupo efectivo. Los servicios que permiten
           obtener estos identificadores son las siguientes:

116 Sistemas operativos. Una visión aplicada

            c)Obtener el identificador de usuario real

           Este servicio devuelve el identificador de usuario real del proceso que realiza la llamada.
           Su prototipo es:

                 uid_t getuid(void);

           d) Obtener el identificador de usuario efectivo
           Devuelve el identificador de usuario efectivo. Su prototipo es:

                 uid_t geteuid(void);

           e) Obtener el identificador de grupo real

           Este servicio permite obtener el identificador de grupo real. El prototipo que se utiliza
           para invocar este servicio es el siguiente:

                 gid_t getgid (void);

<!-- pág. 141 -->

Obtener el identificador de grupo efectivo

Devuelve el identificador de grupo efectivo. Su prototipo es:

      gid_t getegid (void);

El siguiente programa muestra un ejemplo de utilización de estos cuatro servicios.

_______________________________________________________________________
Programa 3.2. Programa que imprime la información de identificación de un proceso.

#include <sys/types.h>
#include <stdio.h>
main ( )

printf(”identificador de usuario: %d\n”, getuid ());
printf(”identificador de usuario efectivo: %d\n” ,geteuid ());
printf (“identificador de grupo: %d\n”, getgid ());
printf(”identificador de grupo efectivo: %d\n”, getegid ());
}
_______________________________________________________________________

El entorno de un proceso

El entorno de un proceso viene definido por una lista de variables que se pasan al mismo
en el momento de comenzar su ejecución. Estas variables se denominan variables de
entorno y son accesibles a un proceso a través de la variable externa environ, declarada
de la siguiente forma:

      extern char **environ;



                                                                              Procesos 117
      Esta variable apunta a una lista de variables de entorno. Esta lista no es más que un
vector de punteros a cadenas de caracteres de la forma nombre = valor, donde nombre
hace referencia al nombre de una variable de entorno y valor al contenido de la misma.
      El Programa 3.3 imprime la lista de variables de entorno de un proceso.
_______________________________________________________________________
Programa 3.3. Programa que imprime el entorno del proceso.

#include <stdio.h>
#include <stdlib.h>

extern char **environ;

void main(int argc, char *argv)
{
      int i;
     printf(“ de variables de entorno de %s\n”, argv[0]);

<!-- pág. 142 -->

               for(i=O; environ[i] NULL; i++)
               printf(”environ[%d] = %s\n”, 1, environ[i]);
          }
          _______________________________________________________________________

               Cada aplicación interpreta la lista de variables de entorno de forma específica.
          POSIX establece el significado de determinadas variables de entorno. Las más comunes
          son:

              • HOME: directorio de trabajo inicial del usuario.
              • LOGNAME: nombre del usuario asociado a un proceso.
              • PATH: prefijo de directorios para encontrar ejecutables.
              • TERM: tipo de terminal.
              • TZ: información de la zona horaria.


          a) Obtener el valor de una variable de entorno

          El servicio getenv permite buscar una determinada variable de entorno dentro de la lista
          de variables de entorno de un proceso. La sintaxis de esta función es:

                char *getenv(const char *name)

                Esta función devuelve un puntero al valor asociado a la variable de entorno de
          nombre name. Si la variable de entorno no se encuentra definida, la función devuelve
          NIJLL.
                El Programa 3.4 utiliza la función getenv para imprimir el valor de la variable de
          entorno
          HOME.
          _______________________________________________________________________
          Programa 3.4 Programa que imprime el valor de la variable HOME.

          #include <stdio.h>
          #include <stdlib.h>

          main ()

          char *home = NULL;
118   Sistemas operativos. Una visión aplicada

            home = getenv (”HOME”);
            if (home = = NULL)
                 printf(”HOME no se encuentra definida\n”>;
          else
                 printf(”E1 valor de HOME es %s\n”, home);

          Creación de procesos
          En esta sección se describen los principales servicios POSIX relativos a la creación de
          procesos.

<!-- pág. 143 -->

a) Crear un proceso

La forma de crear un proceso en un sistema operativo que ofrezca la interfaz POSIX es
invocando el servicio fork. El sistema operativo trata este servicio realizando una
donación del proceso que lo solicite. El proceso que solicita el servicio se convierte en el
proceso padre del nuevo proceso, que es, a su vez, el proceso hijo.
      El prototipo de esta función es el siguiente:

      Pid_t fork ();


       La Figura 3.32 muestra que la donación del proceso padre se realiza copiando la
imagen de memoria y el BCP. Observe que el proceso hijo es una copia del proceso
padre en el instante en que éste solicita el servicio fork. Esto significa que los datos y la
pila del proceso hijo son los que tiene el padre en ese instante de ejecución. Es más, dado
que, al entrar el sistema operativo a tratar el servicio, lo primero que hace es salvar los
registros en el BCP del padre, al copiarse el BCP se copian los valores salvados de los
registros, por lo que el hijo tiene los mismos valores que el padre.




Figura 3.32. Creación de un proceso mediante el servicio fork.
                                                                              Procesos 119




Figura 3.33. Uso de la llamada fork.

<!-- pág. 144 -->

           Esto significa, en especial, que el contador de programa de los dos procesos tiene el
           mismo valor, por lo que van a ejecutar la misma instrucción máquina. No hay que caer
           en el error de pensar que el proceso hijo empieza la ejecución del código en su punto de
           inicio. Repetimos que el hijo empieza a ejecutar, al igual que el padre, en la sentencia
           que esté después del fork.
                  En realidad, el proceso hijo no es totalmente idéntico al padre, puesto que algunos
           de los
           valores del BCP han de ser distintos. Las diferencias más importantes son las siguientes:

               •   El proceso hijo tiene su propio identificador de proceso, distinto al del padre.
               •   El proceso hijo tiene una nueva descripción de la memoria. Aunque el hijo tenga
                   los mismos segmentos con el mismo contenido, no tienen por qué estar en la
                   misma zona de memoria (esto es especialmente cierto en el caso de sistemas sin
                   memoria virtual).
               •   El tiempo de ejecución del proceso hijo se iguala a cero.
               •   Todas las alarmas pendientes se desactivan en el proceso hijo.
               •   El conjunto de señales pendientes se pone a vacío.
               •   El valor que retorna el sistema operativo como resultado del fork es distinto en el
                   hijo y el padre.

   — El hijo recibe un «0».
   — El padre recibe el identificador de proceso del hijo.

                 Este valor de retorno se puede utilizar mediante una cláusula de condición para
           que el padre y el hijo sigan flujos de ejecución distintos, como se muestra en la Figura
           3.33.
                 Observe que las modificaciones que realice el proceso padre sobre sus registros e
           imagen de memoria después del FORK no afectan al hijo y, viceversa, las del hijo no
           afectan al padre. Sin embargo, el proceso hijo tiene su propia copia de los descriptores
           del proceso padre. Esto hace que el hijo tenga acceso a los archivos abiertos por el
           proceso padre. El padre y el hijo comparten el puntero de posición de los archivos
           abiertos en el padre.
                 El Programa 3.5 muestra un ejemplo de utilización de la llamada fork. Este
           programa hace uso dc la función de biblioteca perror que imprime un mensaje
           describiendo el error de la última llamada ejecutada. Después de la llamada fork, los
           procesos padre e hijo imprimirán sus identificadores de proceso utilizando la llamada
           getpid, y los identificadores de sus procesos padre por medio de la llamada getppid.
           Observe que los identificadores del proceso padre son distintos en cada uno de los dos
           procesos.
           _______________________________________________________________________
           Programa 3.5. Programa que crea un proceso.
           #include <sys/ypes.h>
           #ineclude <stdio.h>

          main ()
          {
120 Sistemas operativos. Una visión aplicada

           pid_t pid;
           pid = fork ();
           switch(pid) {

<!-- pág. 145 -->

           case -1: /* error del fork<) *1
               perror(”fork”)
               break;
           case 0: /* proceso hilo */
               printf(”Proceso %d; padre = %d \n”, getpidü, getppid();
               break;
           default: /* padre */
               printf(”Proceso %d; padre = %d \n”, getpidú, getppid();
           _______________________________________________________________________
           El código del Programa 3.6 crea una cadena de n procesos como se muestra en la Figura
           3.34.
           _______________________________________________________________________

           Programa 3.6. Programa que crea la cadena de procesos de la Figura 3.34.

           #include <sys/types.h>
           #include <stdio.h>

           main ()
           {
                      piclit pid;
                      int i;
                      int n = 10;

                      for (1 = 0; i < n; i++){
                           pid = fork ();
                           if (pid!= 0)
                               break;
           }
           printf(”E1 padre del proceso %d es %d\n”, getpid(), getppid());

           }
           _______________________________________________________________________




Figura 3.34. Cadena de procesos.
                                                                                      Proceso 121

<!-- pág. 146 -->

       En cada ejecución del bucle se crea un proceso. El proceso padre obtiene el
identificador del proceso hijo, que será distinto de cero y saldrá del bucle utilizando la
sentencia break de C. El proceso hijo continuará la ejecución, repitiéndose este proceso
hasta que se llegue al final del bucle.

El Programa 3.7 crea un conjunto de procesos cuya estructura se muestra en la Figura
3.35




¡      Programa 3.7. Programa que crea la estructura de procesos de la Figura 3.35.
1¡     #include <stdio.h>
     #include <sys/types.h>

mamo

pidt pid;
mt i;
mt n = 10;

for (1 = 0; i < n; i++){
pid = fork<);
II                   <pid     0)
break;

printf(”E1 padre del proceso %d es %d\n”, getpidü, getppid<));




En este programa, a diferencia del anterior, es el proceso hijo el que finaliza la ejecución
del bucle ejecutando la sentencia break, siendo el padre el encargado de crear todos los
procesos.



h)         Ejecutar un programa



El servicio exec de POSIX tiene por objetivo cambiar el programa que está ejecutando
un proceso. Se puede considerar que el servicio tiene dos fases. En la primera se vacía el
proceso de casi todo su contenido, mientras que en la segunda se carga en nuevo
programa. La Figura 3.36 muestra estas dos fases.
                                            2                 N


Figura 3.35. Creación de n procesos hL~os.

<!-- pág. 147 -->

        122Sistemas operativos. Una visión aplicada
                                           Mapa de
                                           memoria
                                                                   Tabla de procesos
                                             del poceso                                El
proceso hace un exec
                                             Mapa de
                                             memoria
                                                                   Tabla de procesos



BCP
                                             Mapa de
                                             memoria

o
                                                                                       Se
carga la nueva imagen
                      Objeto                                       Tabla de procesos   Se
pone PC en dirección de arranque
                     ejecutable               Imagen
co
~                                    detprocaso
Se conservan los fd
Biblioteca
sistema


Figura 3.36. Funcionamiento de la llamada exec.


En la fase de vaciado del proceso se conservan algunas informaciones, como:

•                        Entorno del proceso. Que el sistema operativo incluye en la
nueva pila del proceso.
•                        Algunas informaciones del BCP como: identificador de
proceso, identificador del proceso padre, identificador de usuario y descriptores de
archivos abiertos.

En la fase de carga hay que realizar las siguientes operaciones:

•                       Asignar al proceso un nuevo espacio de memoria.
•                       Cargar el texto y los datos iniciales en los segmentos
correspondientes.
•                       Crear la pila inicial del proceso con el entorno y los parámetros
que se pasan al programa.

<!-- pág. 148 -->

•                       Rellenar el BCP con los valores iniciales de los registros y la
descripción de los nuevos segmentos de memoria.

Recuerde que el servicio fork crea un nuevo proceso que ejecuta el mismo programa que
el
proceso padre y que el servicio exec no crea un nuevo proceso, sino que permite que un
proceso pase a ejecutar un programa distinto.
En POSIX existe una familia de funciones exec, cuyos prototipos se muestran a
continuación:

in~ excl(char ‘~path, char ~arg, ...); icÉ execv(char *path char *argv[]); ints
execle(char *path char *arg, ...);




                                                                                             Procesos   1

mt execve(char *path, char *argv[] char *envp[1); mt execlp(char *file const char *arg,
...);
mt execvp<char *file, char *argv[1);

La familia de funciones exec reemplaza la imagen del proceso actual por una nueva
imagen. Esta nueva imagen se construye a partir de un archivo ejecutable. Si la llamada
se ejecuta con éxito, ésta no devolverá ningún valor puesto que la imagen del proceso
habrá sido reemplazada, en caso contrario devuelve —1.
La función main del nuevo programa llamado tendrá la forma:

mt main(int argc, char **argv)

donde argc representa el número de argumentos que se pasan al programa, incluido el
propio nombre del programa, y argv es un vector de cadenas de caracteres, conteniendo
cada elemento de este vector un argumento pasado al programa. El primer componente
de este vector (argv [0 1) representa el nombre del programa.
El argumento path apunta al nombre del archivo ejecutable donde reside la nueva imagen
del proceso. El argumento file se utiliza para construir el nombre del archivo ejecutable.
Si el argunlcnt() file contiene el carácter /, entonces el argumento file constituye el
nombre del archivo ejecutable. En caso contrario, el prefijo del nombre para el archivo se
construye por medio de la búsqueda en los directorios pasados en la variable de entorno
PATH.
El argumento argv contiene los argumentos pasados al programa y debería acabar con un
puntero NULL. El argumento envp apunta al entorno que se pasará al nuevo proceso y se
obtiene de la variable externa environ.
Los descriptores de los archivos abiertos previamente por el proceso que realiza la
llamada exec permanecen abiertos en la nueva imagen del proceso, excepto aquellos
abiertos con el valor Fi)_CLOEXEC. Los directorios abiertos en el proceso que realiza la
llamada serán cerrados en la nueva imagen del proceso.
Las señales con la acción por defecto seguirán por defecto. Las señales ignoradas
seguirán ignoradas por el nuevo proceso y las señales con manejadores activados
tomarán la acción por defecto en la nueva imagen del proceso.

<!-- pág. 149 -->

Si el archivo ejecutable tiene activo el bit de modo set—user—ID (Aclaración 3.7), el
identiticador efectivo del nuevo proceso será el identificador del propietario del archivo
ejecutable.


ACLARACIóN 3.7

Cuando un usuario ejecuta un archivo ejecutable con el bit de modo set -user- ID, el
nuevo proceso creado tendrá como identificador de usuario efectivo el identificador de
usuario del propietario del archivo ejecutable. Como se verá en el Capítulo 9, este
identificador es el que se utiliza para comprobar los permisos en los accesos a
determinados recursos como son los archivos. Pør tanto, cuando se ejecuta un programa
con este bit, el nuevo proceso ejecuta con los permisos que tiene el propietario del
archivo ejecutable.


El nuevo proceso hereda del proceso que realiza la llamada los siguientes atributos:

•                     ldcntiticador de proceso.
•                     ldentificador del proceso padre.
•                     ldentificador del grupo del proceso.
•                     ldentificador de usuario real.




             124Sistemas operativos. Una visión aplicada


•                             ldentificador de grupo real.
•                             Directorio actual de trabajo.
•                             Directorio raíz.
•                             Máscara de creación de archivos.
•                             Máscara de señales del proceso.
•                             Señales pendientes.

En el Programa 3.8 se muestra un ejemplo de utilización de la llamada execlp. Este
programa crea un proceso hijo, que ejecuta el mandato ls —1, para listar el contenido del
directorio actual de trabajo.


Programa 3.8. Programa que ejecuta el mandato 1s —1.

#include <sys/types.h>
#include <stdio.h>

mamo

pidt pid;
mt status;

<!-- pág. 150 -->

pid = forkü;
switch(pid)
case —1: /* error del fork(> */
exit(-1);
case O: /* proceso hijo */
execlp(”ls”, “ls”, “-1” ,NULL);
perror(”exec”)
break;
default: /* padre */

printf (“Proceso padre\n”);




Igualmente, el Programa 3.9 ejecuta el mandato ls —1 haciendo uso de la llamada
execvp.


Programa 3.9. Programa que ejecuta el mandato ls —1 mediante la llamada execvp.

#include <sys/types .
#include <stdio.h>

main(int argc, char **argv)

pidt pid;
char *argumentos[3];

argumentos[O] = argumentos[11 = “—1”; argumentos[2] = NULL;




                                                             Procesos

pid = fork<);
switch(pid)
case ~-1: /~ error del fork() */
•Xit(-l)
case O: /~ proceso hijo */
execvp(argumentos[O] argumentos);
perror ( “exec”);
break;

<!-- pág. 151 -->

default: /* padre */
printf ( “Proceso padre\n”);




El siguiente programa (Programa 3.10) crea un proceso que ejecuta un mandato recibido
en la línea de argumentos.


Programa 3.10. Programa que ejecuta el mandato recibido en la línea de mandatos.

#include <sys/types.h>
#include <stdio.h>

main(int argc, char **argv)



pid = forkü;
switch<pid)
case -1: /* error del fork() */
•xit(-1);
case O: /* proceso hijo */
if (execvp(argv[1], &argv[1])< O)
perror(”exec”)
default: /* padre */
printf (“Proceso padre\n”);
}




Terminación de procesos

En esta sección se presentan los servicios relacionados con la terminación de procesos.


a)                   Terminar la ejecucion de un proceso

Un proceso puede terminar su ejecución de forma normal o anormal. Un proceso puede
terminar su ejecución de forma normal usando cualquiera de las tres formas siguientes:

•                     Ejecutando una sentencia return en la función main.
•                     Ejecutando la llamada exit.
Ejecutando la llamada _exit.
pidt pid;

<!-- pág. 152 -->

       126Sistemas operativos. Una visión aplicada


Cuando un programa ejecuta dentro de la función main la sentencia return (valor), ésta es
similar a exit (valor). El prototipo de la función exit es:


voidexit(int status);


Estos servicios tienen por función finalizar la ejecución de un proceso. Ambos reciben
como parámetro un valor que sirve para que el proceso dé una indicación de cómo ha
terminado. Como se verá más adelante, esta información la puede recuperar el proceso
padre que, de esta forma, puede conocer cómo ha terminado el hijo.
La finalización de un proceso tiene las siguientes consecuencias:

•                        Se cierran todos los descriptores de archivos.
•                        La terminación del proceso no finaliza de forma directa la
ejecución de sus procesos hijos.
•                        Si el proceso padre del proceso que realiza la llamada se
encuentra ejecutando una llamada walt o wai tpid (su descripción se realizará a
continuación), se notitica la terminación del
proceso.
•                        Si el proceso padre no se encuentra ejecutando una llamada walt
o waitpid, el código de finalización (status) se salva hasta que el proceso padre ejecute la
llamada wait o
waitpid.

<!-- pág. 153 -->

•                         Si la implementación soporta la señal SIGCHLD, ésta se envía al
proceso padre.
•                         El sistema operativo libera todos los recursos utilizados por el
proceso.

Un proceso también puede terminar su ejecución de forma anormal, llamando a la
función abort, por la recepción de una señal que provoca su finalización. La señal puede
ser causada por un evento externo (p. ej.: se pulsa CTRL-C), por una señal enviada por
otro proceso, o por un error dc ejecución, como, por ejemplo, la ejecución de una
instrucción ilegal, un acceso ilegal a una posicion de memoria, etc.
Cuando un proceso termina de forma anormal, generalmente, se produce un archivo
denominado core que incluye la imagen de memoria del proceso en el momento de
producirse su terminación y que puede ser utilizado para depurar el programa.
En realidad, exit es una función de biblioteca que llama al servicio _exit después de
preparar la terminación ordenada del proceso. El prototipo de _exit es:


void _exit(int status>;

En general se recomienda utilizar la llamada exit en vez de _exit, puesto que es más
portahlc y permite volcar a disco los datos no actualizados. Una llamada a exit realiza las
siguientes lu nc iones:

•                         Todas las funciones registradas con la función estándar de C
atexit, con llamadas en orden inverso a su registro. Si cualquiera de estas funciones
llama a exit, los resultados no serán
portahles. La sintaxis de esta función es:


intatexit(void (*func) (void));


•                    Todos los archivos abiertos son cerrados y todos los datos en el
almacenamiento intermedio son copiados al sistema operativo.
•                    Sc llama a la función _exit.




Procesos

127


El Programa 3.11 finaliza su ejecución utilizando la llamada exit. Cuando se llama a esta
tuncion se ejecuta la función fin, registrada previamente por medio de la función atexit.

<!-- pág. 154 -->

Programa 3.11. Ejemplo de utilización de exit y atexit.

#include <stdio.h>
#include <stdlib.h>

void íin(void)

printf(’Fin de la ejecución del proceso %d\n”, getpid());
retiu_n;


void main(void)
             if (atexit(fin)          O)
perror(”atexit”)
exit (1)


exit(O); /~ provoca la ejecución de la función fin *7




h>      Esperar por la jtnalizacion de un proceso hijo

Permite a un ~~OCCS() padre esperar hasta que termine la ejecución de un proceso hijo
(el proceso padre se queda bloqueado hasta que termina un proceso hijo). Existen dos
formas de invocar este servicio:

pidt wait(int *status)
pidt waitpid(pid t pid, mt *status, mt options)


Ambas llamadas esperan la finalización de un proceso hijo y permiten obtener
información
sobre ci estado de terminación del mismo.
La llamada wait suspende la ejecución del proceso hasta que finaliza la ejecución de uno
de
sus procesos hijos. Esta función devuelve el identificador del proceso hijo cuya
ejecución ha finali¡ado. Si status es distinto de NULL, entonces se almacena en esta
variable información relativa al
proceso que ha terminado. Si el hijo retomó un valor desde la función main, utilizando la
sentencia return, o pasó un valor como argumento a exit, éste valor puede ser obtenido
por medio de la variable utilizando las siguientes macros definidas en el archivo de
cabecera sys/wait:

•             WTFEXITED(status): devuelve un valor verdadero (distinto de cero) si el
hijo terminó normal me n te.
•             WE:X1TSTATUs (status): permite obtener el valor devuelto por el proceso
hijo en la llamada exit o el valor devuelto en la función main, utilizando la sentencia
return. Esta macro

<!-- pág. 155 -->

solo puede ser utilizada cuando WIFEXITED devuelve un valor verdadero (distinto de
cero).
•             WIFSIGNALED(status): devuelve un valor verdadero (distinto de cero) si
el proceso hijo finalizó su cjecución como consecuencia de la recepción de una señal
para la cual no se
había programado manejador.




         128Sistemas operativos. Una visión apiicada


•                          WTERI4SIG (status): devuelve el número de la señal que
provocó la finalización del proceso hijo. Esta macro sólo puede utilizarse si
WIFSIGNALED devuelve un valor verdadero
                             (distinto de cero).
•                          WIFSTOPPED (status): devuelve un valor verdadero si el
estado fue devuelto por un proceso hijo actualmente suspendido. Este valor sólo puede
obtenerse en la función waitpid
con la opción WUNTRACED, como se verá a continuación.
•                          WSTOPSIG (status): devuelve el número de la señal que
provocó al proceso hijo suspenderse. Esta macro sólo puede emplearse si WIFSTOPPED
devuelve un valor distinto de cero.

El servicio waitpid tiene el mismo funcionamiento si el argumento pid es —1 y el
argumento
options es cero. Su funcionamiento general es el siguiente:

•                           Si pid es —1, se espera la finalización de cualquier proceso.
•                           Si pid es mayor que cero, se espera la finalización del proceso
hijo con identificador pid.
•                           Si pid es cero, se espera la finalización de cualquier proceso
hijo con el mismo identificador de grupo de proceso que el del proceso que realiza la
llamada.
•                           Si pid es menor que —1, se espera la finalización de cualquier
proceso hijo cuyo identificador de grupo de proceso sea igual al valor absoluto del valor
de pid.
•                           El argumento options se construye mediante el OR binario de
cero o más valores definidos en el archivo de cabecera sys/wait .h. De especial interés
son los siguientes:

—                             WNOHANG. La función waitpid no suspenderá al proceso
que realiza la llamada si el estado del proceso hijo especificado por pid no se encuentra
disponible. WUNTRACED. Permite que el estado de cualquier proceso hijo especificado
por pid que esté suspendido sea devuelto al programa que realiza la llamada waitpid.

E]                           siguiente programa (Programa 3.12) ejecuta un mandato
recibido en la línea de argumentos por la funcion main. En este programa, el proceso
padre realiza una llamada a la función wait para esperar la finalización del mandato. Una

<!-- pág. 156 -->

vez concluida la ejecución, el proceso padre imprime información sobre el estado de
terminación del proceso hijo.



Programa 3.12. Programa que imprime información sobre el estado de terminación de
un proceso hijo.


#include <sys/types.h> #include <sys/wait.h> #include <stdio.h>

main(int argc, char **argv)
{
pidt pid;
mt valor;

pid = fork~
switch(pid)

<!-- pág. 157 -->

case —1: /* error del fork() */
exit(-l)
case O: /~ proceso hijo */
mf (exeevp(argv[11, &argv[l]) <O)
perror(”exec”);




default: /* padre ~/ while (wait(&valor) 1= pid);
Procesos 129

if (valor == O)
printfV’El mandato se ejecuto de formal normal\n”);
else
if (WIFEXITED(valor))
printf(”El hijo termino normalmente y su valor
devuelto fue %d\n”, WEXITEDSTATUS(valor));
}
if (WIFSIGNALZD(valor))
printfV’El hijo termino al recibir la señal
                               %d\n”, WTERMSIG(valor));
La utilización de los servicios fork, exec, wait y exit hace variar la jerarquía de procesos
(Fig. 3.37). Con el servicio fork aparecen nuevos procesos y con el exit desaparecen. Sin
embargo, existen algunas situaciones particulares que conviene analizar.
La primera situación se refleja en la Figura 3.38. Cuando un proceso termina y se
encuentra con que el padre no está bloqueado en un servicio wai t, se presenta el
problema de dónde almacenar el estado de terminación que el hijo retorna al padre. Esta
información no se puede almacenar en el BCP del padre, puesto que puede haber un
número indeterminado de hijos que hayan terminado. Por ello, la información se deja en
el BCP del hijo, hasta que el padre la adquiera mediante el oportuno wa it. Un proceso
muerto que se encuentra esperando el wai t del padre se dice que está en estado zombie.
El proceso ha devuelto todos sus recursos con excepción del BCP, que contiene el pid
del padre y la palabra de estado de terminación.
pid P

padre
pidP              pidP pIdH1 pidP DidH EJ ~DD~D
EZZ1 ‘EZZ —EZ ‘EZZIEZZ1
Figura 3.37. Uso de las llamadas fork, exec, wait y exit.
pid P


EJ
Texto

<!-- pág. 158 -->

Datos
Pila
Archivos, tuberías,...
}
y
1




¡




              130Sistemas operativos. Una visión aplicada
¡ nit
                                       Proceso A
                                         forko
Figura 3.38. Proceso zomhie.
                                           lnit
mit
¡ nit
)
                                                                                            ) 1
mit
)

)
La segunda situación se presenta en la Figura 3.39 y se refiere al caso de que un proceso
con hijos termine antes que éstos. De no tomar alguna acción correctora, estos procesos
contendrían su BCP una información obsoleta del pid del padre, puesto que ese proceso
ya no existe. La solución adoptada en UNIX es que estos procesos «huérfanos» los toma
a su cargo el proceso mit. Er concreto, el proceso B de la mencionada figura pasará a
tener como padre al P~OCCSO ini,.
Para que los procesos heredados por mit acaben correctamente, y no se conviertan en
zombies,
el proceso mit está en un bucle infinito de walt.
La mayoría de los intérpretes de mandatos (shells) permiten ejecutar mandatos en
huckgroi
finalizando la línea de mandatos con el carácter &. Así, cuando se ejecuta el siguiente
mandato;

ls —1 &

<!-- pág. 159 -->

El shell ejecutará el mandato ls —l sin esperar la terminación del proceso que lo ejecutó.
Esto
permite al intérprete de mandatos estar listo para ejecutar otro mandato, el cual puede
ejecutarse d
                                            lnit
                                        Proceso A
                                           forkO
                                            ¡ nit
¡ nit
)
)
(




(
l’~igura 3.39. En UNIX el proceso ini ~ heredo los proce.~os hilos que se quedan sin
padre.
)



)
((
II
(




                                                                                             Proc~sos   131


¡(irma concurrente a ls —1. Los procesos en hackground, además, se caracterizan porque
no se pueden interrumpir con CTRL —C.
El Programa 3.13 crea un proceso que ejecuta un mandato pasado en la línea de
argumentos en
I>a(k~4rOund.


Programa 3.13. Ejecución de un proceso en hackground.

#inciude <sys/types.h>
#include <stdio.h>

<!-- pág. 160 -->

main(inL argc, char **argv)

picit pid;
           pué           fork(>;
SW]LCh(pid>

case -1: /~ error del fork() */
exit(-1>
case O: /* proceso hijo */

if (execvp(argv[l], &argv[1]) < O)
perrorV’exec”)
defauit: /~ padre *7
exit (O);


1
3.11.2.      Servicios POSIX de gestión de procesos ligeros

En esta sección se describen los principales servicios POSIX relativos a la gestión de
procesos ligeros. Estos servicios se han agrupado de acuerdo a las siguientes categorías:

•                Atributos de un proceso ligero.
•                Creación e identificación de procesos ligeros.
•                Terminación de procesos ligeros.

Atributos de un proceso ligero

Cada proceso ligero en POSIX tiene asociado una serie de atributos que representan sus
propiedades. Los valores de los diferentes atributos se almacenan en un objeto atributo
de tipo pth~eadattr_t. Existen una serie de servicios que se aplican sobre el tipo anterior
y que permiten modificar los valores asociados a un objeto de tipo atributo. A
continuación, se describen las principales funciones relacionadas con los atributos de los
procesos ligeros.


a)           Crear atribulas de un I)r~(es() ligero

Este servicio permite iniciar un objeto atributo que se puede utilizar para crear nuevos
procesos ligeros. El prototipo de esta función es:

mt pthread_attr_init(pthread_attr_t *attr)

       132Sistemas operativos. Una visión aplicada


b)                   Destruir atributos

Destruye el objeto de tipo atributo pasado como argumento a la misma. Su prototipo es:

<!-- pág. 161 -->

intpthread_attr_destroy(pthread_attr_t*attr>;


c)                Asignar el tamaño de la pila

Cada proceso ligero tiene una pila cuyo tamaño se puede establecer mediante esta
función, cuyo prototipo es el siguiente:

ini pthread_attr_setstacksize<pthreadattr_t ~ ini stacksize>;


d)                Obtener el tamaño de la pila

El prototipo del servicio que permite obtener el tamaño de la pila de un proceso es:

ini pthread_attr getntacksize(pthread attr_t *attr, mt. *stacksize);


e)                Establecer el estado de terminación El prototipo de este servicio es:

ini pthread_attr_setdetachstate(pthread_attr_t *attr,
ini detachstate)

Si el valor del argumento detachstate es PTHREAD_CREATE_DETACHED, el proceso
ligero que sc cree con esos atributos se considerará como independiente y liberará sus
recursos cuando finalice su ejecución. Si el valor del argumento detachs tate es
PTHREAD_CREATE_JOINABLE, el proceso ligero se crea como no independiente y
no liberará sus recursos cuando finalice su ejecución. En este caso es necesario que otro
proceso ligero espere por su finalización. Esta espera se consigue mediante el servicio
pthread bm, que se describirá más adelante.


f)                Obtener el estado de terminación

Permite conocer el estado de terminación que se especifica en un objeto de tipo atributo.
Su prototies:

mt pthread attr.getdetachstate(pthread attr_t *attr,
ini *detachstate>;


Creación e identificación de procesos ligeros

Los servicios relacionados con la creación e identificación de procesos ligeros son los
siguientes:


a)                     Crear un proceso ligero

Este servicio permite crear un nuevo proceso ligero que ejecuta una determinada
función. Su prototipo es:

<!-- pág. 162 -->

Procegos
                                                                                        1
33


mt pthx-ead_create(pthread_t ~ pthread_attr_r *attr,
void * (*start_routine) (void*h void *arg);

El primer argumento de la función apunta al identificador del proceso ligero que se crea,
este identificador viene determinado por el tipo pthread_t. El segundo argumento
especifica los atributos de ejecución asociados al nuevo proceso ligero. Si el valor de
este segundo argumento es NULL, se utilizarán los atributos por defecto, que incluyen la
creación del proceso como no independiente. El tercer argumento indica el nombre de la
función a ejecutar cuando el proceso ligero comienza su ejecución. Esta función requiere
un solo parámetro que se especifica con el cuarto argumento, arg.


h)          Obtener el identWcador de un proceso ligero

Un proceso ligero puede averiguar su identificador invocando este servicio, cuyo
prototipo es el siguiente:

pthread~t pthread self (void)


Terminación de procesos ligeros

Los servicios relacionados con la terminación de procesos ligeros son los siguientes:


a)          Esperar la terminación de un proceso ligero

Este servicio es similar al walt, pero a diferencia de éste, es necesario especificar el
proceso ligero por el que se quiere esperar, que no tiene por qué ser un proceso ligero
hijo. El prototipo de la función es:

mt pthread join(pthread thid, void **value)


La función suspende la ejecución del proceso ligero llamante hasta que el proceso ligero
con identificador thid finalice su ejecución. La función devuelve en el segundo
argumento el valor que pasa el proceso ligero que finaliza su ejecución en el servicio
pthread exi t, que se verá a continuación. Únicamente se puede solicitar el servicio
pthreadlioín sobre procesos ligeros creados

<!-- pág. 163 -->

1
como no independientes.
b)       Finalizar la ejecución de un proceso ligero
Es análogo al servicio exlt sobre procesos. Su prototipo es:

ini pthread exit (void *value)


Incluye un puntero a una estructura que es devuelta al proceso ligero que ha ejecutado la
correspondiente llamada a pthread joln, lo que es mucho más genérico que el parámetro
que permite el servicio walt.
La Figura 3.40 muestra una jerarquía de procesos ligeros. Se supone que el proceso
ligero A es el primario, por lo que corresponde a la ejecución del main. Los procesos B,
C y D se han creado mediante pthread_create y ejecutan respectivamente los
procedimientos b o, c O) y d O). El proceso ligero D se ha creado como «no
independiente», por lo que otro proceso puede hacer una




)
           134Sistemas operativos. Una visión aplicada




                                       pcreate Nc




                                           5~so
                                         ligero B

<!-- pág. 164 -->

Figura 3.40. E/emplo de jerarquía de procesos ligeros.



operación hin sobre ~1. La figura muestra que el proceso ligero C hace una operacion
/0w sobre el D, por lo que se queda bloqueado hasta que termine.
El Programa 3.14 crea dos procesos ligeros que ejecutan la función func. Una vez
creados se espera su finalización con la función pthreadjoin.



Programa 3.14. Programa que crea dos procesos ligeros no independientes.


#include <pthread.h>
#include <st.dio.h>


void func(void)


printf(’Thread %d \n”, pthreadself(>);
pthreadexit (O);


mo i n


pthread_t thl, th2;


M se crean dos procesos ligeros con atribucos por defecto Y
pthread_create(&thl, NULL, func, NULL); pthreadcreate(&th2, NULL, func, NIJLL);

printf(”E1 proceso ligero principal continua ejecutando\n”);
p_create




Proceso
ligero O
1’

<!-- pág. 165 -->

(




                                                                                Procesos      135


/~ se espera su terminación ~/
pthreadjoin(thl, NULL); pthreadjoin(th2, NULL);

exit (O)




Lii ~ que se muestra a continuación (Programa 3.15) crea diez procesos ligeros
indepcndientcs. que liberan sus recursos cuando finalizan (se han creado con el atributo
PJHHEAD CREATIi_DETACHED). En este caso, no se puede esperar la terminación
de los procesos ligeros. p~r lo que el proceso ligero principal que ejecuta el código de la
función main debe continuar su e~ccucion en paralelo con ellos. Para evitar que el
proceso ligero principal finalice la ejecución dc la lbnción main. lo que supone la
ejecución del servicio exit y, por tanto, la finalización de todo el proceso (Aclaración
3.8), junto con todos los procesos ligeros, el proceso ligero principal suspendc su
ejecución durante cinco segundos para dar tiempo a la creación y destrucción dc los
procesos ligeros que se han creado.

<!-- pág. 166 -->

Progrania 3.15. Programa que crea diez procesos ligeros independientes.


# nciode <pthread. h>
jI 1 tic’) wde tetcii o.


II de) irte tIAX _ ‘111 REA1)3 10


V() i Cl i UflC ( vn 1(11>


printt (‘Thread lid \n”, pthreadself()
pthread_exit (O);


VC)ii] naln))


lot 3;

pt~1iread dtt r — t attr;

pthCeád t LhidIMAXTHREADS]


7~ Oc inicia los atributos y se marcan como independientes *7
pthread attr mit (&attr);
pthread_attr_setdetachstate(&attr, PTHREADCREATEDETACHED)
   for(j       O; j e MAX_THREADS; j ++)
pthreadcreate(&thid[i1, &attr, func, NULL>;




          136Sistemas operativos. Una visión aplicada


/* El proceso ligero principal no puede esperar la finalización */
/~ de los procesos ligeros que ha creado y se suspende durante un */
/~ cierto tiempo esperando su finalización */
sleep(5>




El siguiente programa (Programa 3.16) crea un proceso ligero por cada número que se
introduce. Cada proceso ligero ejecuta el código de la función imprimir.

<!-- pág. 167 -->

¡                   Programa 3.16. Programa que crea un proceso ligero por cada
número introducido.

#include <pthread. h>
#include <stdio.h>

#define MAX_THREADS 10

void imprimir(int ~‘n)
{
printf(”Thread %d %d \n”, pthread_self(>, *fl);
pthread_exit (0);


main ()

pthread_attrt attr;
pthread_t thid;
mt num;

pthread_attrinit(&attr);
pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);

while (1)
scanf(”%d”, &num); /~ espera */
pthreadcreate (&thid, &attr, imprimir, &num);




Este programa, tal y como se ha presentado, presenta un problema ya que falla si el
número que se pasa a un proceso ligero es sobrescrito por el proceso ligero principal en
la siguiente iteración del bucle while, antes de que el proceso ligero que se ha creado lo
haya utilizado. Este problema requiere que los procesos ligeros se sincronicen en el
acceso a este número. La forma de sincronizar procesos y procesos ligeros se tratará en
el Capítulo 5.


3.11.3.                          Servicios POSIX para la planificación de procesos

Como se describió en la Sección 3.7.2, POSIX proporciona planificación basada en
prioridades. Estas prioridades pueden ser modificadas dinámicamente mediante servicios
específicos.

<!-- pág. 168 -->

                                                                                            Procesos   137


POSIX incluye servicios para gestionar la política de planificación de los procesos y
procesos ligeros. Como se vio anteriormente, POSIX especifica tres tipos de políticas de
planificación. Estas
políticas se encuentran definidas por los siguientes símbolos declarados en el archivo de
cabecera <sched. h>:

•                SCHED_FIFO: política de planificación FIFO. Los procesos ejecutan
según una planificación FIFO, pero pueden ser expulsados por procesos de mayor
prioridad.
•                SCHEDRR: política de planificación cíclica (round-robin). Los procesos
dentro del mismo nivel de prioridad ejecutan según una política de planificación round-
robin. Los procesos en este caso son expulsados de la UCP cuando acaba su rodaja de
tiempo o cuando son expulsados por un proceso de mayor prioridad.
•                SCHED_QTHER: otra política de planificación. Esta política se deja
libre a la implenientación, la que debe estar perfectamente documentada.

Para cada política de planificación hay un rango de prioridades mínimo que toda
implementación debe soportar. Para políticas FIFO y cíclicas, debe haber al menos 32
niveles de prioridad.
La prioridad de ejecución de los procesos y procesos ligeros se puede especificar
mediante la
estructura schedparam, que debe incluir al menos el siguiente campo, que especifica la
prioridad de planificación:

mt schedpriority;
/~ prioridad de ejecución del proceso */

A continuación, se describen los servicios que ofrece POSIX para la planificación de
procesos y procesos ligeros.
Servicios de planificación de procesos
A continuación, se describen los principales servicios de planificación de procesos.


a)         Modificar los parámetros de planificación de un proceso

Un proceso puede modificar su prioridad mediante el servicio:

mt sched_setparam(piclit pid, const struct schedparam *param)
Permite modificar la prioridad (especificada en el argumento param) del proceso pid. La
función devuelve O en caso de éxito o --1 en caso de error.
Para modificar tanto la prioridad como la política de planificación de un proceso se
utiliza el
servicio sched_setscheduler, cuyo prototipo es el siguiente:

mt sched_scheduler(pidt pid, mt policy,
                          const struct schedparam *param)

<!-- pág. 169 -->

Cambia la política de planificación (SCHED_FIFQ SCHED_RR o SCHEDOTHER) y la
prioridad
del proceso pid.


b)        Obtener los parámetros de planificación de un proceso

Hay diversas funciones que permiten obtener información sobre los parámetros de
planificación de un proceso. Estas son las siguientes:

mt sched getparain(pidt pid, struct schedpararn *param);




      138Sistemas operativos. Una visión aplicada


La luncion devuelve la prioridad del proceso pid en el campo schedprioritY de la estruc-
tura param.

ini schedgetscheduler(Pid t pid);


Devuelve la política de planificación del proceso (SCHED~FIFO, SCHEWRR o
SCHE’D OTHER).


ini schedgetpriOritYmifl(iflt policy);
ini schedgetpriOritYiftaX(iflt poiicy);


Estas dos funciones devuelven los niveles de prioridad mínimo y máximo dc la política
de
planificación poiicy.


Servicios de planificación de procesos ligeros

Los parámetros de planificación de los procesos ligeros se pueden asignar en su creación
mediante los atributos correspondientes o mediante servicios adecuados.


a)               Atributo.~ (le ¡)ldllLJi(Uciofl

Los procesos ligeros en un sistema operativo conforme a la norma POSIX pueden
crearse con dos arnhitos dc planificación: ámbito de planificación global y ámbito de
planificación local. En el ámbito dc planificación global, los procesos ligeros de un
proceso compiten con el resto de procesos ligeros del sistema por la UCP. En el amhito
de planilicaciofl local, los procesos ligeros de un proceso sólo compiten entre ellos por

<!-- pág. 170 -->

la UCP. El ámbito de planificación de los procesos ligeros, así corno la prioridad y la
política de planificación, se pueden añadir a los atributos de creación de un pro~cso
ligero mediante los siguientes servicios:

Inc pthreadattr~SetSCOPe(Pihread—ait_ E ~ ini conieni3nflScOpe>;
ini pthread_attr getscope(pthread_attr_i *attr,
ini *conteniiOnSCOpe)


La primera permite fijar en el atributo attr el ámbito de planificación y la segunda
permite
obtenerlo. El ámbito de planificación se fija mediante los siguientes símbolos:

•                     PTHREAD_SCOPE SYSTEM especifica                    un      ámbito   de
planificación global.
•                     PTHREAD_SCOPE_PROCESS especifica                   un      ámbito   de
planificación local.

ini pthreadattrsetSChedPOliCY(Pthread attr t *aitr, ini poiicy>;
inc pthrea~attrgetSChedPO1iCY(Pthread attr_i *aiir, ini ~po1iCy);


La primera fija la política de planificación en el atributo atÉr y la segunda obtiene la
política
de planificación almacenada en el atributo attr.

mt pthreadattrfietSChedParalU(Pthread actr t *aitr,
coflsi siruci sched~param *param)
ini pthreadattrgetsChedParafll(Pthread attr_t *atir,
struct schedparam *param)


La primera función fija la prioridad de planificación y la segunda la obtiene.




                                                                                               Procesos   13

h)          Modificar los parámetros de plantficacion de un proceso ligero

Un P~OCCS() ligero puede modificar su prioridad y política de planificación utilizando
cl servicio:

<!-- pág. 171 -->

in~ Pthreadsetschedparam(pthread_t thread, mt policy
const struct schedparam *param)

c)          Obtener los /)arametros de /)lantflcación de un proceso ligero

Un ~~OCCS() ligero puede consultar su prioridad y su política de planificación mediante
el siguiente servicio:

inti pthreadgetschedparam(pthreaa_t thread, mt *pOliCy
struct sched~param *param)



3.11.4.                Servicios POSIX para gestión de señales y temporizadores

Lii esta scccion se presentan los principales servicios que ofrece POSIX para la gestión
de señales y teinporizadores.
El archivo de cabecera signal . h declara la lista de señales posibles que se pueden enviar
a los procesos en un sistema. A continuación se presenta una lista de las señales que
deben incluir todas ¡as implementaciones. La acción por defecto para todas estas señales
es la terminación anormal de proceso.

•                  SIGABRT: terminación anormal.
•                  SIGALRM: señal de fin de temporización.
•                  SIGFPE: operación aritmética errónea.
•                  SJGHUP: desconexión del terminal de control.
•                  £IGTLL: instrucción hardware inválida.
•                  SIGTN’F: señal de atención interactiva.
•                  SIGKILL: señal de terminación (no se puede ignorar ni armar).
•                  SICJPIPE: escritura en una tubería sin lectores.
•                  STGQUIT: señal de terminación interactiva.
•                  SIGSEV: referencia a memoria inválida.
•                  SIGTERN: señal de terminación.
•                  SIGUSR1: señal definida por la aplicación.
•                  STGUSR2: señal definida por la aplicación.

Si una iniplernentación soporta control de trabajos, entonces también debe dar soporte,
entre otras, a las siguientes señales:

•                  SIGCHLD: indica la terminación del proceso hijo.
•                  SICONT: continuar si está detenido el proceso.
•                  £IGsToP: señal de bloqueo (no se puede armar ni ignorar).

La acción por defecto para la señal SIGCHLD, que indica la terminación de un proceso
hijo. es ignorar la señal.
A continuación, sc describen los principales servicios POSIX relativos a las señales.
Estos servicios se han agrupado de acuerdo a las siguientes categorías:

•                  Conjuntos de señales.
•                  Envío dc señales.

<!-- pág. 172 -->

•                  Armado de una señal.




       140Sistemas operativos. Una visión aplicada


•                       Bloqueo de señales.
•                       Espera de señales.
•                       Servicios de temporización.


Conjuntos de señales

Como se ha indicado anteriormente, existe una serie de señales que un proceso puede
recibir durante su ejecución. Un proceso puede realizar operaciones sobre grupos o
conjuntos de señales. Estas operaciones sobre grupos de señales utilizan conjuntos de
señal de tipo sigset~t y son las sigu lentes:


a)                 Iniciar un conjunto de señales

Existen dos servicios que permiten iniciar un conjunto de señales. El servicio

mt sigeiuptyset(sigset t *~~11)


inicia un conjunto de señales de modo que no contenga ninguna señal. El servicio



inicia un conjunto de señales con todas las señales disponibles en el sistema.


b)                 Añadir una señal a un conjunto de señales

Añade una señal a un conjunto de señales previamente iniciado. El prototipo de este
servicio es:

mt sigaddset(sigset t *set, mt signo);


La función añade al conjunto set la señal con número signo.


c)                 Eliminar una señal de un conjunto de señales

<!-- pág. 173 -->

Elimina una señal determinada de un conjunto de señales. El prototipo de este servicio
es:

mt sigdelset(sigset t *set, mt signo);


Elimina del conjunto set la señal con número signo.


d)                  Comprobar si una señal pertenece a un conjunto

Permite determinar si una señal pertenece a un conjunto de señales. Su prototipo es:

mt sigisme~ber(sigset_t *set mt signo)

Esta función devuelve 1 si la señal signo se encuentra en el conjunto de señales set. En
caso
contrario devuelve O.
El resto de las funciones devuelven o si tienen éxito o —1 si hay un error.




Procdsos

141


Envío de señales

Algunas señales como SIGSEGV o SIGBUS las genera el sistema operativo cuando
ocurren ciertos errores. Otras señales se envían de unos procesos a otros utilizando el
siguiente servicio:


una señal

Permite enviar una señal a un proceso. El prototipo de este servicio en lenguaje C es cl
siguiente:

£nL kill (pidt pid, mt sig)

Envía la señal sig al proceso o grupo de procesos especificado por pid. Para que un
~fOCC5() pueda enviar una señal a otro proceso designado por pid, el identificador de
usuario efectivo o real del proceso que envía la señal debe coincidir con el identificador
real o efectivo del proceso que la recibe, a no ser que el proceso que envía la señal tenga
los privilegios adecuados, por ejemplo es un
~fOCC5() ejecutado por cl superusuario.

<!-- pág. 174 -->

Si pid es mayor que cero, la señal se enviará al proceso con identificador de proceso
igual a
p~ ci. Si pid es cero, la señal se enviará a todos los procesos cuyo identificador de grupo
sea igual al dentificador de grupo del proceso que envía la señal. Si pid es negativo pero
distinto de —1, la

señal será enviada a todos los procesos cuyo identificador de grupo sea igual al valor
absoluto de

1
p Ld. Para pid igual a —1, POSIX no especifica funcionamiento alguno.
Armado de tina señal

El servicio que permite armar una señal es:

mt sigaction(int sig, struct sigaction *act,
struct sigaction *oact);


Esta llamada tiene tres parámetros: el número de señal para la que se quiere establecer el
inane jador. un puntero a una estructura de tipo struct sigaction para establecer el nuevo
manejador y un puntero a una estructura también del mismo tipo que almacena
información sobre el manejador establecido anteriormente.
La estructura sigact ion, definida en el archivo de cabecera signal .h, está formada por los
siguientes campos:
    struct sigaction
                                                     void (*sahandler) ~        /*
Manejador para la señal */
slgsets samask;                                       /* Señales bloqueadas durante la
                                 ejecución del manejador */
                                                      mt sa_ filags; /* opciones
especiales */


El primer argumento indica la acción a ejecutar cuando se reciba la señal. Su valor puede
ser:

•               SIG_DFL: indica que se lleve a cabo la acción por defecto que, en la
mayoría de los casos, consiste en matar al proceso.
•               SIG_IGN: especifica que la señal deberá ser ignorada cuando se reciba.
•               Una función que devuelve un valor de tipo void y que acepta como
parámetro un número entero. Cuando envía una señal al proceso el sistema operativo,
éste coloca como parámetro




       142Sistemas operativos. Una visión aplicada

<!-- pág. 175 -->

del manejador el número de la señal que se ha enviado. Esto permite asociar un mismo
manejador para diferentes señales, de tal manera que el manejador realizará una u otra
acción en función del valor pasado al mismo y que identifica a la señal que ha sido
generada.

Si el valor del tercer argumento es distinto de NULL, la acción previamente asociada con
la
señal será almacenada en la posición apuntada por oact. La función devuelve o en caso
de éxito o
-1                  si hubo algún error.
El siguiente fragmento de código hace que el proceso que lo ejecute ignore la señal
SIGINT
que se genera cuando se pulsa CTLR-C.

struct sigaction act;
                      act.sa_handler = SIG_IGN;              /* ignorar la señal */
act.saflags = O;      /* ninguna acción especial */ /* Se inicia el conjunto de señales a
bloquear cuando
se reciba la señal */
sigemptyset<&act.sa_mask);
sigaction(SIGINT, &act, NULL)


Máscara de señales

La máscara de señales de un proceso proporciona un conjunto de señales que serán
bloqueadas. Bloquear una señal es distinto a ignorarla. Cuando un proceso bloquea una
señal, ésta no será enviada al proceso hasta que se desbloquee. Si el proceso ignora la
señal, ésta simplemente sc ignora. Los servicios asociados con la máscara de señales de
un proceso se describen a continuaClOn.



a)                  Modificar la máscara de señales

Permite modificar o examinar la máscara de señales de un proceso. El prototipo de la
función es:

mt sigprocmask<int how, sigsett *set, sigset t *oset>;

Con esta función se permite bloquear un conjunto de señales de tal manera que su envío
será
congelado hasta que se desbloqueen.
El valor del argumento how indica la manera en la cual el conjunto de señales set será
camNado. Los posibles valores de este argumento se encuentran definidos en el archivo
de cabecera signal .h y son los siguientes:

•                       SIG_BLK: añade un conjunto de señales a la actual máscara de
señales del proceso.
•                       SIG_UNBLOCK: elimina de la máscara de señales de un
proceso las señales que se encuentran en el conjunto set.

<!-- pág. 176 -->

•                       SIG_SETMASK: crea la nueva máscara de señales de un
proceso.

Si el segundo argumento de esta función es NTJLL, el tercero proporcionará la máscara
de
señales del proceso que se está utilizando sin ninguna modificación. Si el valor del tercer
argumento es distinto de NULL, la máscara anterior se almacenará en oset.
El siguiente fragmento de código bloquea la recepción de todas las señales.

sigset_t mask;




                                                                                              Procesos   143


sigfillset(&mask)
sigprocmask(SIG_SETMASK, &mask, NULL);

Si sc quiere, a continuación, desbloquear la señal SIGSEGV, se deberá ejecutar el
siguiente
fragmento de código:

sigsett mask;

sigemptyset (&mask)
sigaddset(&mask, SIGSEGV>;
sigprocmask(SIG_UNBLOCK, &mask, NULL);



h)         Obtener las señales bloqueadas pendientes de entrega

Esta función devuelve el conjunto de señales bloqueadas que se encuentran pendientes
de entrega al proceso. Su prototipo es:

mt sigpending(sigset t *~~>


La lbnción almacena en set el conjunto de señales bloqueadas pendientes de entrega.


Espera de señales

Cuando se quiere esperar la recepción de una señal, se utiliza el pause. Este servicio
bloquea al P~OCCS() que la invoca hasta que llegue una señal. Su prototipo es:

mt pause(void);

<!-- pág. 177 -->

Este servicio no permite especificar el tipo de señal por la que se espera, por tanto,
cualquier
señal no ignorada sacará al proceso del estado de bloqueo.


Servicios de temporización

En esta sección se describen los servicios relativos a los temporizadores.


a)         Activar un temporizador

Para activar un temporizador se debe utilizar el servicio:

unsigned mt alarm(unsigned mt seconds>


Esta función envía al proceso la señal SIGALRM después de pasados el número de
segundos
especificados en el parámetro seconds. Si seconds es igual a cero, se cancelará cualquier
petición realizada anteriormente.

<!-- pág. 178 -->

El siguiente programa (Programa 3.17) ejecuta la función tratar_alarma cada tres segun-
dos. Para ello, arma un manejador para la señal SIGALRN mediante la función sigaction.
A continuación, se entra en un bucle infinito en el que el programa activa un
temporizador especificando como argumento de la llamada alarm, 3 segundos.
Seguidamente, el proceso suspende su ejecución, mediante el servicio pause, hasta que se
reciba una señal, en concreto la señal
SIGALRM.


         144Sistemas operativos. Una visión aplicada


Durante la ejecución de la función tratar_alarma, se bloquea la recepción de la señal
S1GINT, que se genera cuando se teclea CTRL-C.


Programa 3.17. Programa que imprime un mensaje cada 3 segundos.

#include <stdio.h>
#include <signal.h>

void tratar_alarma (void)

printf (“Activada \n”);


void main(void)

struct sigaction act;
sigset_s mask;

/* establece el manejador */
act.sa_handler = tratar_alarma; /“ función a ejecutar */ act.saflags = O; /* ninguna acción
específica*/

/* Se bloquea la señal SIGINT cuando se ejecute la función tratar_alarma */
sigemptyset (&act .mask);
sigaddset(&act.mask, SIGINT);


sigaction(SIGALRM, &act, NULL>;


for ( ; ;
alarm(3)
pause ()
/* se arma el temporizador */
/* se suspende el proceso hasta que se
reciba una señal */

<!-- pág. 179 -->

El Programa 3. 1 8 muestra un ejemplo en el que un proceso temporiza la ejecución de un
proceso hijo. El programa crea un proceso hijo que ejecuta un mandato recibido en la
línea de mandatos y espera su finalización. Si el proceso hijo no termina antes de que
haya transcurrido una determinada cantidad de tiempo, el padre mata al proceso
enviándole una señal mediante el servicio kill. La señal que se envía es SIGKILL, señal
que no se puede ignorar ni armar.



Programa 3.18. Programa que temporiza ¡a ejecución de un proceso hijo.

#include <sys/types.h> #include <signal.h>
#include <stdio.h>
                                                                                    Pr
ocesos
                                                                                    14
5


pidt pid;

void matar~proceso (void>

kill(pid, SIGKILL); 7* se envía la señal al hijo *7


main(inc argc, char **argv)

mt status;
char **argumentos;
scruct sigaction act;
argumentos = &argv[l];
/k Se crea el proceso hijo */
pid                 forkü;
switch <pid)

case —1: 7* error del fork() */
exitL-l>
case O: /* proceso hijo *7
7* El proceso hijo ejecuta el mandato recibido *7 execvp(argumentos[O] argumentos>;
perrorV’exec”)
exit(—l>
default: 7* padre *7
7* establece el manejador *7
act.sa_handler matarproceso; /~ función a ejecutar ~/
act.sa_flags = Q~ /~ ninguna acción específica *7
sigemptyset(&act.sa_mask);
sigaction(SIGALRM, &act, MiLL);
alarm(5)
7* Espera al proceso hijo *7
    wait(&status)
1

exit (O);

<!-- pág. 180 -->

En el programa anterior, una vez que el proceso padre ha armado el temporizador, se
bloquea esperando la finalización del proceso hijo, mediante una llamada a walt. Si la
señal SIGALRM se recibe antes de que el proceso haya finalizado, el padre ejecutará la
acción asociada a la recepción de esta señal. Esta acción se corresponde con la función
matarproceso, que es la que se encarga de enviar al proceso hijo la señal SIGKILL.
Cuando el proceso hijo recibe esta señal, se finaliza su ejecución.


h)          Suspender la ejecución de un proceso

Suspende al proceso durante un número determinado de segundos. Su prototipo es:

mt sleep(unsigned mt seconds)
        146Sistemas operativos. Una visión aplicada


El proceso se suspende durante un número de segundos pasado como parámetro. El
proceso
despierta cuando ha transcurrido el tiempo establecido o cuando se recibe una señal.


3.12.     SERVICIOS DE W1N32

Esta sección describe los principales servicios que ofrece Win32 para la gestión de
procesos, procesos ligeros y planificación. También se presentan los servicios que
permiten trabajar con excepciones y temporizadores.


3.12.1.             Servicios de Win32 para la gestión de procesos

En Win32 cada proceso contiene uno o más procesos ligeros. Como se indicó
anteriormente, en Windows el proceso ligero o thread es la unidad básica de ejecución.
Los procesos en Win32 se diferencian de los de POSIX, en que Win32 no mantiene
ninguna relación padre-hijo. Por conveniencia, sin embargo, en el texto se asumirá que
un proceso padre crea a un proceso hijo. Los servicios que ofrece Win32 se han
agrupado, al igual que en POSIX, en las siguientes categorías:

•                        Identificación de procesos.
•                        El entorno de un proceso.
•                        Creación de procesos.
•                        Terminación de procesos.

A continuación, se presentan los servicios incluidos en las categorías anteriores.


Identificación de procesos

En Win32, los procesos se designan mediante identificadores de procesos y manejadores.
Un identiticador de proceso es un objeto de tipo entero que identifica de forma única a un
proceso en el sistema. El manejador se utiliza para identificar al proceso en todas las
funciones que realizan operaciones sobre el proceso.

<!-- pág. 181 -->

Existen dos funciones que permiten obtener la identificación del proceso que realiza la
llamada.

HANDLE GetCurrentProcess (VOID);
DWORD GetCurrentProcessld(VOID);


La primera devuelve el manejador del proceso que realiza la llamada y la segunda su
identificador de proceso.
Conocido el identificador de un proceso, se puede obtener su manejador mediante el
siguiente
servicio:

HANDLE OpenProcess(DWORD fdwAccess, BOOL flnherit, DWORD IdProcess);


El primer argumento especifica el modo de acceso al objeto que identifica al proceso con
idcntificador Idprocess. Algunos de los posibles valores para este argumento son:

•                      PROCESS_ALL_ACCESS: especifica todos los modos de
acceso al objeto.
•                      SYNCHRONIZE: permite que el proceso que obtiene el
manejador pueda esperar la terminación del proceso con identificador IdProcess.
                                                                                Pr
ocesos
                                                                                14
7


•            PROCESS_TER~INATE: permite al proceso que obtiene el manejador
finalizar la ejecución del proceso con identificador IdProcess.
•            PROCESS~QUERY_INFORMATION: el manejador se puede utilizar para
obtener información sobre el proceso.

El argumento flnherit especifica si el manejador devuelto por la función puede ser
heredado por los flUC VOS procesos creados por el que realiza la llamada. Si su valor es
TRUE, el manejador se puede heredar.
La función devuelve el manejador del proceso en caso de éxito o NULL si se produjo
algún
error.


El entorno de un proceso

Un proceso recibe su entorno en su creación (mediante el servicio createProcess descrito
en la siguiente sección). Cualquier proceso puede obtener el valor de una variable de
entorno o modificar su valor mediante los dos servicios siguientes:

DWORD GetEnvironmentVariable(LPCTSTR lpszName, LPTSTR lpszValue,
                           DWORD cchValue);
BOOL SetEnvironmentVariable(LPCTSTR lpszName, LPTSTR lpzsValue>;

La primera función obtiene en lpszvalue el valor de la variable de entorno con nombre
lpszName. El argumento cchValue especifica la longitud del buffer en memoria al que

<!-- pág. 182 -->

apunta ¡lpszValue. La función devuelve la longitud de la cadena en la que se almacena el
valor de la variable (lpszvalue) o O si hubo algún error.
La función SetEnvironmentVariable permite modificar el valor de una variable de en-
torno. Devuelve TRTJE si se ejecutó con éxito.
Un proceso, además, puede obtener un puntero al comienzo del bloque en el que se
almacenan
las variables de entorno mediante la siguiente función:

LPVOID GetEnvironmentStrings (VOID);


El Programa 3.19 ilustra el uso de esta función para imprimir la lista de variables de
entorno de
un proceso.


Programa 3.19. Programa que lista las variables de entorno de un proceso en Windows.

~ ¡
#include <windows.h>
#include cstdio.h>

void rnain(void)

char *lpszVar
void *lpvEnv;
lpvEnv                  GetEnvironinentStrizigs ~
if (lpvEnv == NULL)
printrf(”Error al acceder al entorno\n”)
exit<O~
           148Sistemas operativos. Una visión aplicada

/* las variables de entorno se encuentran separadas por un NULL ‘~/
/~ el bloque de variables de entorno termina también en NULL ~/
for (lpszVar = <char *) lpvEnv; lpszVar NULL; lpszVar++)
while (*lpszVar)

putchar<*lpszVar++);

putchar ( “\n”i;




Creación de procesos

En Win32, los procesos se crean mediante la llamada CreateProcess. Este servicio es
similar ala combinación fork-exec de POSIX. Win32 no permite a un proceso cambiar su
imagen de memoria y ejecutar otro programa distinto. El prototipo de la función
CreateProcess es el siguiente:

EOOL CreateProcess

<!-- pág. 183 -->

                                   LPCTSTR lpszlmageName,
                                   LPTSTR lpszComrnandLine,
                                   LPSECURITY_ATTRIBUTES lpsaProcess,
                                   LPSECURITY_ATTRIBLJTES lpsaThread,
                                   BOQL flnheritHandles,
                                   DWORD fdwCreate,
                                   LPVOID lpvEnvironrnent,
                                   LPCTSTR lpszcurdir,
                                   LPSTARTUPINFO lpsistartlnfo,
                               5   LPPROCESS_INFQRMATION


Esta función crea un nuevo proceso y su proceso ligero principal. El nuevo proceso
ejecuta el archivo ejecutable especificado en lpszlmageName. Esta cadena puede
especificar el nombre de un archivo con camino absoluto o relativo, pero la función no
utilizará el camino de búsqueda. Si lpszlmageName es NULL, se utilizará como nombre
de archivo ejecutable la primera cadena delimitada por blancos del argumento
lpszCommandLine.
El argumento lpszCommandLine especifica la línea de mandatos a ejecutar, incluyendo
el

nombre del programa a ejecutar. Si su valor es NULL, la función utilizará la cadena
apuntada por lpszlmageNarne como línea de mandatos. El nuevo proceso puede acceder
a la línea de mandatos utilizando los parámetros argc y argv de la función main de C.

El argumento lpsaProcess determina si el manejador asociado al proceso creado y
devuelto
por la función puede ser heredado por otros procesos hijos. Si es NJJLL, el manejador no
puede

heredarse. Lo mismo se aplica para el argumento lpsaThread, pero relativo al manejador
del proceso ligero principal devuelto por la funcion.

El argumento flnheritHandles indica si el nuevo proceso hereda los manejadores que
mantiene el proceso que realiza la llamada. Si su valor es TRUE, el nuevo proceso
hereda todos los manejadores, con los mismos privilegios de acceso, que tenga abiertos
el proceso padre.
El argumento fdwCreate puede combinar varios valores que determinan la prioridad y la
creación del nuevo proceso. Alguno de estos valores son:

•                         CREATE_SUS PEND: el proceso ligero principal del
proceso se crea en estado suspendido y solo se ejecutará cuando se llame a la función
ResumeThread descrita más adelante.

Procesos

149

•               DETACHED_PROCESS: para procesos con consola, indica que el nuevo
proceso no tenga acceso a la consola del proceso padre. Este valor no puede utilizarse
con el siguiente.
•               CREATE_NEW_CONSOLE: el nuevo proceso tendrá una nueva consola
asociada y no heredará ¡a del padre. Este valor no puede utiliLarse con el anterior.
•               NORMAL PRIORITY CLASE indica un proceso sin necesidades
especiales de planificación.

<!-- pág. 184 -->

•               HIGH PRIORITY CLASE: indica que el proceso se cree con una
prioridad alta de planificación.
•               IDLE PRIORITYCLASS: especifica que los procesos ligeros del proceso
sólo ejecuten cuando no haya ningún otro proceso ejecutando en el sistema.
•               REALTIME_PRIORITY_CLASS: indica un proceso con la mayor
prioridad posible. Los procesos ligeros del nuevo proceso serán capaces de expulsar a
cualquier otro proceso, incluyendo ¡os procesos del sistema operativo.

Fi parámetro lpEnvironment apunta al bloque del entorno del nuevo proceso. Si el valor
es NULL, el nuevo proceso obtiene el entorno del proceso que realiza la llamada.
El argumento lpszcuraír apunta a una cadena de caracteres que indica el directorio actual
de trabajo para el nuevo proceso. Si el valor de este argumento es NULL, el proceso
creado tendrá el nhismo directorio que el padre.
El parámetro lpStartuplnfo apunta a una estructura de tipo STARTPINFO que especifica
la apariencia de la ventana asociada al nuevo proceso. Para especificar los manejadores
para la entrada, salida y error estándar deben utilizarse los campos hStdln, hStdøut y
hStdErr. En este caso, el campo dwFlags de esta estructura debe contener el valor
STARTFUSESTDHANDLES
Por último, en el argumento lpProcesslnformatjon puntero a una estructura de tipo
PROCESE INFORMATION, se almacenará información sobre el nuevo proceso creado.
Esta estructura tiene la siguiente definición:

typedef struct PROCESS_INFORMATION
HANDLE hProcess;
HANDLE hThread;
DWORD dwProcessld;
DWORD dwThreadld;
PROCESSINFOP1\4ATION;


En los campos hProcess y hThread se almacenan los manejadores del nuevo proceso y
del proceso ligero principal de él. En dwProcessld se almacena el identificador del nuevo
proceso y en dwThreadld el identificador del proceso ligero principal del proceso creado.
FI Programa 3.20 crea un proceso que ejecuta un mandato pasado en la línea de
argumentos. El proceso padre no espera a que finalice, es decir, el nuevo proceso se
ejecuta en background.


Programa 3.20. Programa que crea un proceso que ejecuta la línea de mandatos pasada
como argumento.

¡
#include <windows.h>
#include <stdio.h>


void main(int argc, char argv)


STARTUPINFO si;
PRUCESSINFORMATION pi;


i f (!Createprocess
                                 NULL,      /~ utiliza la línea de mandatos */

<!-- pág. 185 -->

          150Sistemas operativos. Una visión aplicada
argv [1], NTJLL, NULL, FALSE, o, NULL, NTJLL, &s1, &pj)
/~‘ línea de mandatos pasada como argumentos */ /* manejador del proceso no
heredable*/ /* manejador del thread no heredable */ /* no hereda manejadores */
/* sin flags de creación */
/* utiliza el entorno del proceso */
/~ utiliza el directorio de trabalo del padre */
printf                          <“Error al crear el proceso. Error: %x\n”, GetLastError <)>;
ExitProcess<O>



/* el proceso acaba ~/
exit (O)




Terminación de procesos

Los servicios relacionados con la terminación de procesos se agrupan en dos categorías:
servicios para finalizar la ejecución de un proceso y servicios para esperar la terminación
de un proceso. Estos servicios se describen a continuación:


a)                  Terminar la ejecución de un proceso

Un proceso puede finalizar su ejecución de forma voluntaria de tres formas:

•                        Ejecutando dentro de la función main la sentencia return.
•                        Ejecutando el servicio Exitprocess.
•                        La función de la biblioteca de C exit. Esta función es similar a
ExitProcess.

El prototipo de la función ExitProcess es el siguiente:

VOID ExitProcess <UINT nExitCode);


La llamada cierra todos los manejadores abiertos por el proceso y especifica el código de
salida del proceso. Este código lo puede obtener otro proceso mediante el siguiente
servicio:

BOOL GetExitCodeprocess <HANDLE hProcess, LPDWQRD lpdwExitCode);


Esta función devuelve el código de terminación del proceso con manejador hProcess. El
proceso especificado por hProcess debe tener el acceso
PROCESSQUERYINFORIVIATION (veáse OpenProcess). Si el proceso todavía no ha
terminado, la función devuelve en lpdwExitCode el valor STILL_ALIVE en caso
contrario almacenará en este valor el código de terminación.
Además, un proceso puede finalizar la ejecución de otro mediante el servicio:

BOOLTerminateProcess <HANDLEhProcess, UlNTuExitCode);
                                                                                               Procesos

<!-- pág. 186 -->

Este servicio aborta la ejecución del proceso con manejador hProcess. El código de
terminación para el proceso vendrá dado por el argumento uExitCode. La función
devuelve TRUE si se ejecuta con éxito.


h)         Esperar por la finalización de un proceso

En Win32 un proceso puede esperar la terminación de cualquier otro proceso siempre
que tenga permisos para ello y disponga del manejador correspondiente. Para ello, se
utilizan las funciones de espera de propósito general, las cuales también se tratarán en el
Capítulo 5. Estas funciones son:

DWORD WaitForSingleObject(HANDLE høbject, D~PJQRD dwTimeOut);
DWORD WaitForMultipleObjects(DWORD cobjects, LPHANDLE lphObjects,

BOOL fWaitAll, DWORD dwTimeout>;


La primera función bloquea al proceso hasta que el proceso con manejador hObject
finalice su ejecución. El argumento dwTimeOut especifica el tiempo máximo de bloqueo
expresado en rnilisegundos. Un valor de O hace que la función vuelva inmediatamente
después de comprobar si el proceso finalizó la ejecución. Si el valor es INFINITE, la
función bloquea al proceso hasta que el
proceso acabe su ejecución.
La segunda función permite esperar la terminación de varios procesos. El argumento
cObj ects especifica el número de procesos (el tamaño del vector 1phob~ects) por los que
se desea esperar. El argumento lphObjects es un vector con los manejadores de los
procesos sobre los que se quiere esperar. Si el parámetro fWaitAll es TRUE, entonces la
función debe esperar por todos los procesos, en caso contrario la función vuelve tan
pronto como un proceso haya acabado. El paráme1ro dwTimeOut tiene el significado
descrito anteriormente.
Estas funciones, aplicadas a procesos, pueden devolver los siguientes valores:

•                 WAlT OBJECT_o: indica que el proceso terminó en el caso de la
función WaitForSin gleObject, o todos los procesos terminaron si en
WaitForMultipleObjects el parámetro fWaitAll es TRUE.
•                 WAlT_OBJECT_O+n donde O <= n <= cobjects. Restando este valor
de WAlT_OBJECT_O se puede determinar el número de procesos que han acabado.
•                 WAlT TIMEOUT: indica que el tiempo de espera expiró antes de que
algún proceso acabará.

Las funciones devuelven OxFFFFFFFF en caso de error.
El Programa 3.21 crea un proceso que ejecuta el programa pasado en la línea de
mandatos. El programa espera a continuación a que el proceso hijo termine imprimiendo
su código de salida.


Programa 3.21. Programa que crea un proceso que ejecuta la línea de mandatos pasada
como argumento y espera por él.

#include <windows. h>
#include <stdio.h>

<!-- pág. 187 -->

void main(int argc, char arqv)


STARTUPINFO si;
PROCESS_INFORMATION pi;
IDWORD code;




    152Sistemas operativos. Una visión aplicada

if (!Createprocess( NTJLL,
         argv[l],     /*
         NULL,
         NULL,
         FALSE,
         Q
         NULL,
         NULL,
         &sj,
         &pi))
utiliza la línea de mandatos */
línea de mandatos pasada como argumentos */ manejador del proceso no heredable*/
manejador del thread no heredable */ no hereda manejadores */
sin flags de creación */ utiliza el entorno del proceso */
utiliza el directorio de trabajo del padre */

printf                  (“Error al crear el proceso. Error: %x\n”, GetLastError W;
ExitProcess(O);

/“ Espera a que el proceso creado acabe */
WaitForSingleObject(pi.hProcess, INFINITE);

/‘~ Imprime el código de salida del proceso hijo */
if <!GetExitCodeProcess (pi.hProcess, &code)
printf (“Error al acceder al codigo. Error: %x\n”,
GetLastError W;
ExitProcess (O>
}
printf(”codigo de salida del proceso %d\n”, code); ExitProcess(O);




3.12.2.        Servicios de Win32 para la gestión de procesos ligeros

Los procesos ligeros son la unidad básica de ejecución en Windows. Los servicios de
Win32 para la gestión de procesos ligeros pueden agruparse en las siguientes categorlas:
•                    Identificación de procesos ligeros.

<!-- pág. 188 -->

•                     Creación de procesos ligeros.
•                     Terminación de procesos ligeros.
A continuación, se presentan los servicios incluidos en las categorías anteriores.
Identificación de procesos ligeros
En Win32, los procesos ligeros, al igual que los procesos, se identifican mediante
identificadores de procesos ligeros y manejadores. Estos presentan las mismas
características que los identificadores y manejadores para procesos, ya descritos en la
Sección 3.12.1.
Existen dos funciones que permiten obtener la identificación del proceso ligero que
realiza la
llamada.

HANDLE GetCurrentThread (VQID>;
DWORD GetCurrentThreadld (yO ID);
r




                                                                                          Procesos


La primera devuelve el manejador del proceso ligero que realiza la llamada y la segunda
su
identificador de proceso ligero.
Conocido el identificador de un proceso ligero, se puede obtener su manejador mediante
el
siguiente servicio:

HANDLE OpenThread<DWORD fdwAccess, BOOL flnherit, DWORD Idthread);

El primer argumento especifica el modo de acceso al objeto que identifica al proceso
COfl
identificador Idthread. Algunos de los posibles valores para este argumento son:

•                     THREAD_ALL_ACCESS: especifica todos los modos de acceso al
objeto.
•                     SYNCHRONIZE: permite que el proceso que obtiene el manejador
pueda esperar la terminación del proceso con identificador IdThread.
•                     THREAD_TERNINATE: permite al proceso que obtiene el
manejador finalizar la ejecución del proceso con identificador IdThread.
•                     THREAD_QUERY INFORI~IATION: el manejador se puede
utilizar para obtener información sobre el proceso.

El argumento fInherit especifica si el manejador devuelto por la función puede ser
heredado por los nuevos procesos creados por el que realiza la llamada. Si su valor es
TRUE, cl manejador se puede heredar.
La función devuelve el manejador del proceso en caso éxito o NULL si se produjo algún
error.

Creación de procesos ligeros

En Win32, los procesos ligeros se crean mediante la función CreateThread. El prototipo
de esta función es:

<!-- pág. 189 -->

BOOL CreateThread
LPSECURITY_ATTRIBUTES lpsa,
DWORD cbStack,
LPTHREAD_START_ROUTINE lpStartAddr;
LPVOID lpxiThreadParam,
DWORD fdwCreate,
LPDWORD lpldThread);


Esta función crea un nuevo proceso ligero. El argumento lpsa contiene la estructura con
los atributos de seguridad asociados al nuevo proceso ligero. Su significado es el mismo
que el utilizado en la Iunción CreateProcess. El argumento cbStack especifica el tamaño
de la pila asociada al proceso ligero. Un valor de o especifica el tamaño por defecto (1
MB). lpStartAddr apunta a la función a ser ejecutada por el proceso ligero. Esta función
tiene el siguiente prototipo:

DWORDWINAPI ThreadFunc(LPVOID>;


La función a ejecutar acepta un argumento de 32 bits y devuelve un valor de 32 bits. El
proceso ligero puede interpretar el argumento como un DWORD o un puntero. El
parámetro lpvThreadParam almacena el parámetro pasado al proceso ligero. Si
fdwCreate es O, el proceso ligero ejecuta inmediatamente después de su creación. Si su
valor es CREATE_SUSPENDED, el proCC5O ligero se crea en estado suspendido. En
lpldThread se almacena el identificador del nuevo P~OCC5() ligero creado.
La función Crea teThread devuelve el manejador para el nuevo proceso ligero creado o
bien
NULL en caso de error.
         154Sistemas operativos. Una visión aplicada


Una vez creado un proceso ligero, éste puede suspenderse mediante la función:
                        DWORD SuspendThread(HANDLE hThread);

Un proceso ligero suspendido puede ponerse de nuevo en ejecución mediante la función:

DWORD ResunieThread (HANDLE hThread);


Terminación de procesos ligeros

Al igual que con los procesos en Win32, los servicios relacionados con la terminación de
procesos ligeros se agrupan en dos categorías: servicios para finalizar la ejecución de un
proceso ligero y

servicios para esperar la terminación de un proceso ligero. Estos últimos son los mismos
que los empleados para esperar la terminación de procesos (waitForSingleøbject y
WaitForMultipleObjects) y no se volverán a tratar.


a)                   Terminar la ejecución de un proceso

Un proceso ligero puede finalizar su ejecución de forma voluntaria de dos formas:

Ejecutando dentro de la función principal del proceso ligero la sentencia return

<!-- pág. 190 -->

•                         Ejecutando el servicio ExitThread.

El prototipo de la función ExitThread es:

VOID ExitThread(DWORD dwExitCcde>;

Con esta función un proceso ligero finaliza su ejecución especificando su código de
salida
mediante el argumento dwExitCode. Este código puede consultarse con la función
GetExitCcdeThread, similar a la función GetExitCodePrccess.

Un proceso ligero puede también abortar la ejecución de otro proceso ligero mediante el
servicio.

BOOL TerminateThread(HANDLE hThread, DWORD dwExitCode);

Similar a la función TerminateProcess.


3.12.3.              Servicios de planificación en Win32

Win32 ofrece servicios para que los usuarios puedan modificar aspectos relacionados con
la prioridad y planificación de los procesos y de los procesos ligeros. Como se describió
en la Sección 3.7.2, la prioridad de ejecución va asociada a los procesos ligeros, ya que
son éstos las unidades básicas de ejecución. La clase de prioridad va asociada a los
procesos.
La prioridad de cada proceso ligero se determina según los siguientes criterios:
•                           La clase de prioridad de su proceso.
•                           El nivel de prioridad del proceso ligero dentro de la clase de
prioridad de su proceso.

En Windows NT existen seis clases de prioridad que se fijan inicialmente en la llamada
createprocess. Estas seis clases son:

•                         IDLE_PRIORITY_CLASS, con prioridad base 4.

•                         BELOW_NORMAL_PRIORITY_CLASS, con prioridad base
6.

•                         NORMAL_PRIORITY_CLASS, con prioridad base 9.
                                                                                             Proceso


•                      ABOVE_NORMAL_PRIORITY_CLASS, con pnoridad base 10.

•                      HIGH_PRIORITY_CLASS, con prioridad base 13.

•                      REAL_TIME_PRIORITY_CLASE, con prioridad base 24.

La clase de prioridad por defecto para un proceso es NORMAL_PRIORITY_CLASS. Un
proceso puede modificar o consultar su clase o la de otro proceso utilizando los
siguientes
servicios:

<!-- pág. 191 -->

BOOL SetPriorityclass(HANDLE hProcess, DWORD fdwPricrityClass); DWORD
GetPriorityClass (HANDLE hProcess);


Las prioridades de los procesos ligeros son relativas a la prioridad base del proceso al
que pertenecen. Cuando se crea un proceso ligero, éste toma la prioridad de su proceso.
La prioridad de cada proceso ligero varía dentro del rango ±2 desde la clase de prioridad
del proceso. Estos cinco valores vienen determinados por:

•                      THREAD_PRIORITY_LOWEST.

•                      THREAD_PRIORITY_BELOW_NORMAL.

•                      THREAD_PRIORITY_NORMAL.

•                      THREAD_PRIORITY_ABOVE_NORMAL.

•                      THREAD_PRIORITY_HIGHEST.

Todos los procesos ligeros se crean utilizando THREAD_PRIORITY NORMAL, lo que
significa que su prioridad coincide con la clase de prioridad de su proceso.
Para modificar o consultar el nivel de prioridad de un proceso ligero se deben utilizar las
siguientes funciones:

BOOL SetThreadPriority(HANDLE hThread, DWORD fdwPriority); DWORD
GetThreadPriority(HANDLE hProcess);


Además de los valores relativos anteriores, existen dos valores absolutos que son:

•                     THREAD_PRIORITY_IDLE con valor 1 o 16 para procesos de
tiempo real.
•                     THREAD_PRIORITY_TIME_CRITICAL, con valor 15 o 31
para procesos de tiempo real.


3.12.4.                    Servicios de Win32 para el manejo de excepciones

Como se vio en la Sección 3.8, una excepción es un evento que ocurre durante la
ejecución de un

1
programa y que requiere la ejecución de un código situado fuera del flujo normal de
ejecución. Win32 ofrece un manejo de excepciones estructurado, que permite la gestión
de excepciones software y hardware. Este manejo permite la especificación de un bloque
de código o manejador de

1~
excepción a ser ejecutado cuando se produce la excepción.
El manejo de excepciones en Windows necesita del soporte del compilador para llevarla
a cabo. El compilador de C desarrollado por Microsoft ofrece a los programadores dos
palabras reservadas que pueden utilizarse para construir manejadores de excepción. Estas
son: __try y
except. La palabra reservada __try identifica el bloque de código que se desea proteger
de errores. La palabra __except identifica el manejador de excepciones.

<!-- pág. 192 -->

En las siguientes secciones se van a describir los tipos y códigos de excepción y el uso de
un rnanejador de excepción.

‘1
      156Sistemas operativos. Una visión aplicada


Tipos y códigos de excepción

El código de excepción puede obtenerse utilizando la siguiente función:

DWORD GetExceptionCode (VOID);

Esta función debe ejecutarse justo después de producirse una excepción. La función
devuelve
cl valor asociado a la excepción. Existen muchos tipos de excepciones, algunos de ellos
son:

•                      EXCEPTION_ACCESS_VIOLATION: se produce cuando se
accede a una dirección de memoria inválida.
•                      EXCEPTION_DATATYPE_MISAL IGMENT: se produce
cuando se accede a datos no alineados.
•                      EXCEPTION_INT_DIVIDE_BY_ZERO: se genera cuando se
divide por cero.

•                      EXCEPTION_PRIV_INSTRUCTION:                 ejecución     de    una
instrucción ilegal.

Uso de un manejador de excepciones

La estructura básica de un manejador de excepciones es:

try
/~ bloque de código a proueger */


except (expresión)

/~ manejador de excepciones ~/



El bloque de código encerrado dentro de la sección try representa el código del programa
que se quiere proteger. Si ocurre una excepción mientras se está ejecutando este
fragmento de código, el sistema operativo transfiere el control al manejador de
excepciones. Este manejador se encuentra dentro de la sección _except. La expresión
asociada a _except se evalúa inmediatamente después de producirse la excepción. La
expresión debe devolver alguno de los siguientes val ores:

•                     EXCEPTION_EXECUTE_HANDLER: el sistema ejecuta el
bloque except.
•                     EXCEPTION_CONTINUE_SEARCH: el sistema no hace caso al
manejador de excepciones, continuando hasta que encuentra uno.
•                     EXCEPTION_CONTINUE_EXECUTION: el sistema devuelve
inmediatamente el control al punto en el que ocurrió la excepción.

<!-- pág. 193 -->

El Programa 3.22 muestra una versión mejorada de la función de biblioteca de C strcpy.
Esta
nueva función detecta la existencia de punteros inválidos devolviendo NULL en tal caso.


Programa 3.22. Versión mejorada de strcpy utilizando un manejador de excepciones.

LPTSTR StrcpySeguro(LPTSTR si, LPTSTR s2)
t ry
return strcpy(sl, s2);

1
except<GetExceptionCode() == EXCEPTION_ACCESS_VIOLATION ?
EXCEPTION_EXECUTE_HANDLER EXCEPTION_CONTINUE SEARCH)
return NULL;
                                                                                             Procesos


Si se produce un error durante la ejecución de la función strcpy, se elevará una excepción
y
se pasará a evaluar la expresión asociada al bloque except.
Una hrma general de manejar las excepciones que se producen dentro de un bloque try.
utilizando la función GetExceptionCode. es la que se muestra en el Programa 3.23.
Cuando sc produce una excepción en el programa 3.23, se ejecuta la función GetExcept
ion— C’ode que devuelve el código de excepción producido. Este valor se convierte en
el argumento para la función filtrar. La función filtrar analiza el código devuelto y
devuelve el valor adecuado para la expresión de _except. En el Programa 3.23 se muestra
que en el caso de que la excepción se hubiese producido por una división por cero, se
devolvería el valor EXCEPTION_EXECUTE_HANDLER que indicaría la ejecución del
bloque except.


Programa 3.23. Manejo general de excepciones.

~try
7k bloque de código a proteger */


except (Filtrar(GetExceptioncode())) f
/~ manejador de excepciones */



1)WORD Filcrar (DWORD Code)
switch(Code)


case EXCEPTION_INTDIVIDEBYZERO
                 return EXCEPTIQN_EXECUTEHANDLER;

<!-- pág. 194 -->

3.12.5.                 Servicios de temporizadores

Esta sección describe los servicios de Win32 relativos a los temporizadores.


Activación de temporizadores

Para crear un temporizador, el programador debe utilizar en primer lugar el servicio
SetTimer CUYo prototipo es el siguiente:

UINT SetTimer(HwND hWnd, UINT nlDEvent, UINT uElapse, TIMERPROC
lpTimerFunc);

El parámetro hwnd representa la ventana asociada al temporizador. Su valor es NULL a
no ser que el gestor dc ventanas esté en uso. El segundo argumento es un identificador de
evento distinto de cero. Su valor se ignora si es NULL. El argumento uElapse representa
el valor del temporizador en milisegundos. Cuando venza el temporizador se ejecutará la
función especificada en el cuarto argumento. La función devuelve el identificador del
temporizador o cero en caso de error.
158 Sistemas operativos. Una visión aplicada


El prototipo de la función a invocar cuando vence el temporizador es:

XJOID CALLBACK TimerFunc(HWND hwnd, UINT uMsg, UINT idEvent, DWORD
                           dwTime);


Los dos primeros argumentos pueden ignorarse cuando no se está utilizando un gestor de
ventanas. El parámetro idEvent es el mismo identificador de evento proporcionado en la
función SetTimer. El parámetro dwTime representa el tiempo del sistema en formato
UTC (Coordinated Universal Time, tiempo universal coordinado).
La función SetTimer crea un temporizador periódico, es decir, si el valor de uElapse es 5
ms, la función lpTimerFunc se ejecutará cada 5 ms.
La siguiente función permite desactivar un temporizador:

BOOLKillTimer(HWNDhWnd, UINTuIdEvent);

El argumento uldEvent es el valor devuelto por la función setTimer. Esta función
devuelve TRUE en caso de éxito, lo que significa que se desactiva el temporizador
creado con SetTimer.
El Programa 3.24 imprime un mensaje por la pantalla cada 10 ms.


Programa 3.24. Programa que imprime un mensaje cada lO ms.

#include <windows. h>
#include <stdio.h>

void Mensaje(HWND hwnd, UJINT ms, UINT ide, DWORD time)

printf(”Ha vencido el temporizador\n”);

<!-- pág. 195 -->

return;


void mamo

UINT idEvent = 2;
UINT intervalo = 10;
UINT tid;

tid = SetTimer(NULL, idEvent, intervalo, Mensaje); while (TRUE);




Suspender la ejecución de un proceso

Para suspender la ejecución de un proceso ligero un número determinado de
milisegundos se utiliza el servicio:

VOID Sleep(DWORD cMilliseconds);


El proceso se suspende durante un número de milisegundos recibido como parámetro. El
P~OCCS() despierta cuando ha transcurrido el tiempo establecido o cuando se recibe
una señal.




3.13.       PUNTOS A RECORDAR

Un proceso es un programa en ejecución o de forma más precisa una unidad de
procesamiento gestionada
por el sistema operativo.
~ El entorno del proceso consiste en un conjunto de varia-bies que se le pasan al
proceso en el momento de su creación.
~ La multitarea se basa en tres características: paralelismo entre la E/S y el procesador,
alternancia en los procesos de fases de E/S y de procesamiento, y memoria principal
capat de almacenar varios procesos.
~ El planificador es el elemento del sistema operativo que se encarga de seleccionar el
proceso que ha de ejecutar a continuación.
~ El activador es el elemento del sistema operativo que se encarga de poner en
ejecución el proceso seleccionado por el planificador.
~ Se denomina grado de multiprogramación al número de procesos activos que
mantiene el sistema.
~ Se denomina hiperpaginación a la situación de alta paginación que ocurre en sistemas
con memoria virtual
cuando los conjuntos residentes de los procesos son demasiados pequeños.
~ Los elementos de información asociados a un proceso son: el estado del procesador,
la imagen de memoria y las tablas del sistema operativo.
~ El estado del procesador está formado por el contenido de todos sus registros.
~ La imagen de memoria del proceso está formada por los espacios de memoria que
está autorizado a utilizar.

<!-- pág. 196 -->

~ En el modelo típico de imagen de memoria de un proceso, éste tiene un número fijo
de segmentos de tamaño variable que son: el texto o código, los datos y la pila.
~ Los sistemas operativos actuales permiten que un proC~S() tenga un número variable
de segmentos de tamaño variable.
~ El bloque de control de proceso o BCP contiene la información básica del proceso.
Esta incluye información
de identificación, el estado del procesador e información de control.
~ Un ~~OC~S() durante su ejecución pasa por una serie de estados: ejecución,
bloqueado y listo para ejecutar.
~ Además de los estados básicos anteriores, los procesos pueden estar en los estados de
espera y de suspendido.
Un proceso en espera todavía no ha entrado en el sistema y está a la espera de hacerlo.
Un proceso suspendido es aquel que no tiene ninguna página en memoria principal (están
en la zona de intercambio).
U Se denomina cambio de contexto al conjunto de las dos operaciones siguientes:
salvar el estado del procesador
en el BCP correspondiente y pasar a ejecutar otro programa. bien de otro proceso, bien
del sistema operativo.
                        Prdcesos     159




U Un proceso ligero es un flujo de ejecución que comparte la imagen de memoria y
otras informaciones con otros procesos ligeros.
U La información propia de cada proceso ligero es: contador de programa, pila,
registros y estado del proceso ligero (ejecutando, bloqueado o listo).
U El uso de procesos ligeros presenta varias ventajas: permite la separación de tareas
que pueden ejecutarse de forma independiente, facilita la modularidad y aumenta la
velocidad de ejecución de un trabajo, ya que se pueden aprovechar los tiempos de
bloqueo de unos procesos ligeros para ejecutar otros.
U El objetivo de la planificación es el reparto del procesador entre los procesos o
procesos ligeros que deseen y puedan ejecutar.
U La planificación a largo plazo tiene por objetivo añadir al sistema nuevos procesos,
tomándolos de la lista de espera.
U La planificación a medio plazo decide qué procesos pasan a estar suspendidos y
cuáles dejan de estarlo. Por tanto, cambia el grado de multiprogramación del sistema.
U La planificación a corto plazo se encarga de seleccionar el proceso en estado de listo
que pasa a estado de ejecucion. Es la que se encarga de asignar el procesador.
U En una planificación sin expulsión un proceso conserva el procesador mientras no
acabe o mientras no solicite un servicio al sistema operativo que lo bloquee.
U En una planificación con expulsión, el sistema operativo puede quitar a un proceso
del estado de ejecución aunque éste no lo solicite.
U El algoritmo de planificación cíclico realiza un reparto equitativo del procesador,
dejando que los procesos ejecuten durante unidades de tiempo denominadas rodajas.
U Un algoritmo de planificación FIFO ejecuta procesos según una política FIFO. Un
proceso pasa al final de la cola cuando hace una llamada al sistema que lo bloquea. Si
esto no ocurre, el proceso se ejecutará de forma indefinida hasta que acabe.
U En un algoritmo con prioridades se selecciona para ejecutar el proceso en estado listo
con mayor prioridad. Este tipo de algoritmos suelen ser con expulsión, ya que un proceso
abandona el procesador cuando pasa a listo un proceso de mayor prioridad.
U En una planificación basada en el algoritmo primero el trabajo más corto se elige
para ejecutar el proceso COfl tiempo de ejecución más corto, lo que exige conocer u
priori el tiempo de ejecución de los procesos.

<!-- pág. 197 -->

U Un sistema operativo conforme a la norma POS IX debe implementar una política de
planificación con expulsion basada en prioridades y al menos dos políticas de
planificación: cíclica y FIFO.


         160Sistemas operativos. Una visión aplicada

U Windows NT realiza una planificación cíclica con prioridades y con expulsión.
U Las señales y las excepciones permiten a los sistemas operativos notificar a los
procesos de la ocurrencia de determinados eventos que ocurren durante la ejecución de
los mismos. POSIX utiliza el modelo de señales y Windows NT utiliza el modelo de
excepciones.
U un servidor es un proceso que está pendiente de recibir órdenes de trabajo
provenientes de otros procesos denominados clientes.
U POSIX dispone de una serie de servicios para la gestión de procesos, procesos ligeros
y para planificación. También ofrece servicios para trabajar con señales y
temporizadores.
U Win32 ofrece servicios para gestionar procesos, procesos ligeros y su planificación.
También presenta servicios para trabajar con excepciones y con temporizado-res.


3.14.    LECTURAS RECOMENDADAS

Son muchos los libros de sistemas operativos que cubren los temas tratados en este
capítulo. Algunos de ellos son iCrow)ey, 1997], IMilenkovic, 1992], lSilberchatz, 1999],
[Stallings, 1998] y lTanenbaum, 1995]. ISoloilion, 1998] describe en detalle la gestión de
procesos de Windows NT y en [IEEE, 19961 puede encontrarse una descripción
completa de todos los servicios POSIX descritos en este capítulo.



3.15.    EJERCICIOS

3.1.¿Cuál de los siguientes mecanismos hardware no es un requisito para construir un
sistema operativo multiprogramado con protección entre usuarios? Razone su respuesta.

a) Memoria virtual.
b) Protección de memoria.
e) Instrucciones de FIS que sólo pueden ejecutarse en modo kernel.
d) Dos modos de operación: kemel y usuario.

3.2.¿Puede degradarse el rendimiento de la utilización del procesador en un sistema sin
memoria virtual siempre que aumenta el grado de multiprogramaci ón?
3.3.Indique cuál de estas operaciones no es ejecutada por el activador:

a) Restaurar los registros de usuario con los valores almacenados en la tabla del
proceso.
   h      Restaurar el contador de programa.
e) Restaurar el puntero que apunta a la tabla de páginas del proceso.
d) Restaurar la imagen de memoria de un proCeso.

3.4.¿Siempre se produce un cambio de proceso cuando se produce un cambio de
contexto? Razone su respuesta.
3.5.¿Cuál es la información que no comparten los proCCS05 ligeros de un mismo
proceso?

<!-- pág. 198 -->

            .1
            3.6.¿Puede producirse un cambio de contexto en un sistema con un planificador basado
            en el algoritmo primero el trabajo más corto además de cuando se bloquea o se termina el
            proceso? Razone su respuesta.
            3.7.¿Qué algoritmo de planificación será más conveniente para optimizar el rendimiento
            de la UCPen un sistema que sólo tiene procesos en los cuales no hay entrada/salida?
            3.8.¿Cuál de las siguientes políticas de planificación es más adecuada para un sistema de
            tiempo compartido?

            a) Primero el trabajo más corto
            b) Round-rohin.
            e) Prioridades.
            d) ElFO
            3.9.¿Cuál es el criterio de planificación más relevante en un sistema de tiempo
            compartido, el tiempo de respuesta o la optimización en el uso del procesador? Razone
            su respuesta.
            3.10.       ¿Cuál de las siguientes transiciones entre los estados de un proceso no se
            puede producir en un sistema con un algoritmo de planificación no expulsivo?

            a) Bloqueado a listo.
            h) Ejecutando a listo.
            e) Ejecutando a bloqueado
            d) Listo a ejecutando.




Sea un sistema que usa un algoritmo de planificación de ~~OCCSOS round-rohin con una rodaja de
             tiempo de lOO ms. En este sistema ejecutan dos procesos. El primero no realiza
             operaciones de EIS y el segundo solicita una operación de EIS cada 50 ms. ¿Cuál será el
             porcentaje de uso de la UCP?
Considere el siguiente conjunto de procesos planificados con un algoritmo round-rohin con 1 u.t. de
             rodaja. ¿Cuánto tardan en acabar todos ellos?
Proceso Llegada
             Pl 2
             P2
             P3
Duración
8
5
4
3
En un sisteína que usa un algoritmo de planificación de procesos round-rohin, ¿cuántos procesos
             como máximo pueden cambiar de estado cuando se produce una interrupción del disco
             que indica que se ha terminado una operación sobre el mismo?
Se tienen los siguientes trabajos a ejecutar:

Trabajos Unidades de tiempo Prioridad
              2
              2                       4

<!-- pág. 199 -->

                3                    2    2
                4                    7    3

Los trabajos llegan en el orden 1, 2, 3 y 4 y la prioridad más alta es la de valor 1. Se pide:

a) Escribir un diagrama que ilustre la ejecución de estos trabajos usando:

1. Planificación de prioridades no expulsiva.
2. Planificación cíclica con una rodaja de tiempo de 2.
3. FIFO.

b) Indicar cuál es el algoritmo de planificación con menor tiempo medio de espera.

3.15. ¿Qué sucede cuando un proceso recibe una señal? ¿, Y cuando recibe una excepción?
3.16. ¿Cómo se hace en POSIX para que un proceso cree otro proceso que ejecute otro programa? ¿Y
            en W in3 2’?
3.17. ¿Qué información comparten un proceso y su hijo después de ejecutar el siguiente código’?

if (fork() !=0)
wait (&status)
el se
execve (B, parámetros, 0)
3.18. En un sistema operativo conforme a la norma POSIX, ¿cuándo pasa un proceso a estado
             zombie?
3.19. Tras la ejecución del siguiente código, ¿cuántos procesos se habrán creado’?

for (1=0; 1 < n; i+±)
fork()

3.20. Cuando un proceso ejecuta una llamada fork y luego el proceso hijo un exec, ¿qué información
           comparten ambos procesos?
3.21. ¿Qué diferencia existe entre bloquear una señal e ignorarla en POS IX?
3.22. Escribir un programa en lenguaje C que active unos manejadores para las señales SIGINT,
           SIGQUIT y SIGILL. Las acciones a ejecutar por dichos manej adores serán:

a)     Para SIGINT y SIGQUIT, abortar el proceso con un estado de error.
h)     Para SIGILL, imprimir un mensaje de instrucción ilegal y terminar.

3.23. Dado el siguiente programa en lenguaje C:

void main(int argc, char argv)
mt 1;
for (1 =1; 1 <= argc; i+±)
fork ()


se pide:

a)    Dibujar un esquema que muestre la jerarquía de procesos que se crea cuando se ejecuta el
           programa con argc igual a 3.
h)    ¿Cuántos procesos se crean si argc vale n’?
3.24. Responder a las siguientes preguntas sobre las llamadas al sistema walt de POSIX y WaitFor-
           SlngleObject de Win32 cuando ésta se aplica sobre un manejador de proceso.

a)    ¿Cuál es la semántica de estas llamadas’?

<!-- pág. 200 -->

b)    Indicar en qué situaciones puede producirse cambio de proceso y en qué casos no.
c)    Describir los pasos que se realizan en estas llamadas al sistema desde que se llama a la rutina
           de biblioteca hasta que ésta devuelve el control al programa de usuario. Indicar cómo se
           transfiere el control y parámetros al sistema operativo, cómo realizarÇa su labor el
           sistema operativo y cómo devuelve el control y resultados al programa de usuario.
3.25. Escribir un programa similar al Programa 3. 15. que utilice los servicios de Win32 para
           temporizar la ejecución de un proceso.
Procesos 161
3.11.




3.12.
            (1
            P4         3

3.13.




                                                3.14.


8
5

