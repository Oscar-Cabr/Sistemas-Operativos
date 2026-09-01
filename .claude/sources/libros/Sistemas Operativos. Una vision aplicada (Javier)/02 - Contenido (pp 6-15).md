# Contenido

> Fuente: Sistemas Operativos. Una vision aplicada (Javier) — páginas 6–15 (numeración del PDF)

<!-- pág. 6 -->

                                                                  Contenido

Prólogo                                                                     XV


1. CONCEPTOS ARQUITECTÓNICOS DE LA COMPUTADORA                              1

       1.1.  Estructura y funcionamiento de la computadora                  2
       1.2.  Modelo de programación de la computadora                       3
             1.2.1. Niveles de ejecución                                    4
             1.2.2. Secuencia de funcionamiento de la computadora           5
             1.2.3. Registros de control y estado                           6
       1.3.  Interrupciones                                                 7
       1.4.  El reloj                                                       9
       1.5.  Jerarquía de memoria                                           10
             1.5.1. Migración de la información                             11
             1.5.2. Parámetros característicos de la jerarquía de memoria   12
             1.5.3. Coherencia                                              12
             1.5.4. Direccionamiento                                        12
             1 .5.5. La proximidad referencial                              13
       1.6.  La memoria virtual                                             15
             1.6.1. Concepto de memoria virtual                             16
             1.6.2. La tabla de páginas                                     18
             1.6.3. Caso de varios programas activos                        22
             1.6.4. Asignación de memoria principal y memoria virtual       22
       1.7.  Entrada/salida                                                 23
             1.7.1. Periféricos                                             23
             1.7.2. E/S y concurrencia                                      25
             1.7.3. E/S y memoria virtual                                   27
       1.8.  Protección                                                     27
             1.8.1. Mecanismos de protección del procesador                 27
             1.8.2. Mecanismos de protección de memoria                     28
       1.9.  Multiprocesador y multicomputadora                             30
       1.10. Puntos a recordar                                              31
       1.11. Lecturas recomendadas                                          31
       1.12. Ejercicios                                                     32




Digitalización realizada con propósito académico                            v

<!-- pág. 7 -->

vi   Contenido


2.     INTRODUCCIÓN A LOS SISTEMAS OPERATIVOS                                  33

       2.1.    ¿Qué es un sistema operativo                                    34
               2.1.1. Máquina desnuda                                          34
               2.1.2. Funciones del sistema operativo                          34
               2.1.3. Concepto de usuario y de grupo de usuarios               37
       2.2.    Arranque de la computadora                                      38
       2.3.    Componentes y estructura del sistema operativo                  41
               2.3.1. Componentes del sistema operativo                        41
               2.3.2. Estructura del sistema operativo                         42
       2.4.    Gestión de procesos                                             44
               2.4.1. Servicios de procesos                                    45
       2.5.    Gestión de memoria                                              46
               2.5.1. Servicios                                                47
       2.6.    Comunicación y sincronización entre procesos                    47
               2.6.1. Servicios de comunicación y sincronización               48
       2.7.    Gestión de la E/S                                               49
               2.7.1. Servicios                                                50
       2.8.    Gestión de archivos y directorios                               50
               2.8.1. Servicio de archivos                                     50
               2.8.2. Servicio de directorios                                  53
               2.8.3. Sistema de archivos                                      55
       2.9.    Seguridad y protección                                          55
       2.10.   Activación del sistema operativo                                56
       2.11.   Interfaz        del programador                                 59
               2.11.1. POSIX                                                   59
               2.11.2. Win32                                                   60
       2.12.   Interfaz        de usuario del sistema operativo                61
               2.12.1. Funciones de la interfaz de usuario                     62
               2.12.2. Interfaces alfanuméricas                                63
               2.12.3. Interfaces gráficas                                     65
       2.13.   Historia        de los sistemas operativos                      67
       2.14.   Puntos a recordar                                               72
       2.15.   Lecturas recomendadas                                           74
       2.16.   Ejercicios                                                      74

3. PROCESOS                                                                     77
      3.1. Concepto de proceso                                                  78
      3.2. Multitarea                                                           79
           3.2.1. Base de la multitarea                                         80
           3.2.2. Ventajas de la multitarea                                     82
           3.2.3. Grado de multiprogramación y necesidades de memoria principal 82
      3.3. Información del proceso                                              84
           3.3.1. Estado del procesador                                         84
           3.3.2. Imagen de memoria del proceso                                 85
           3.3.3. Información del BCP                                           90
           3.3.4. Tablas del sistema operativo                                  91
      3.4. Formación de un proceso                                              93




Digitalización realizada con propósito académico

<!-- pág. 8 -->

                                                                         Contenido    vii



       3.5.    Estados del proceso                                                   93
               3.5.1. Cambio de contexto                                             95
       3.6.    Procesos ligeros                                                      98
               3.6.1. Estados del proceso ligero                                     99
               3.6.2. Paralelismo                                                    100
               3.6.3. Diseño con procesos ligeros                                    101
       3.7.    Planificación                                                         102
               3.7.1. Algoritmos de planificación                                    105
               3.7.2. Planificación en POSIX                                         107
               3.7.3. Planificación en Windows NT/2000                               108
       3.8.    Señales y excepciones                                                 110
               3.8.1. Señales                                                        110
               3.8.2. Excepciones                                                    111
       3.9.    Temporizadores                                                        112
       3.10.   Servidores y demonios                                                 112
       3.11.   Servicios POSIX                                                       114
               3.11.1. Servicios POSIX para la gestión de procesos                   114
               3.11.2. Servicios POSIX de gestión de procesos ligeros                131
               3.11.3. Servicios POSIX para la planificación de procesos             136
               3.11.4. Servicios POSIX para gestión de señales y temporizadores      139
       3.12.   Servicios de W1N32                                                    146
               3.12.1. Servicios de Win32 para la gestión de procesos                146
               3.12.2. Servicios de Win32 para la gestión de procesos ligeros        152
               3.12.3. Servicios de planificación en Win32                           154
               3.12.4. Servicios de Win32 para el manejo de excepciones              155
               3.12.5. Servicios de temporizadores                                   157
       3.13.   Puntos a recordar                                                     159
       3.14.   Lecturas recomendadas                                                 160
       3.15.   Ejercicios                                                            160

4.     GESTIÓN DE MEMORIA                                                            163
       4.1.   Objetivos del sistema de gestión de memoria                            164
       4.2.   Modelo de memoria de un proceso                                        172
              4.2.1. Fases en la generación de un ejecutable                         172
              4.2.2. Mapa de memoria de un proceso                                   178
              4.2.3. Operaciones sobre regiones                                      182
       4.3.   Esquemas de memoria basados en asignación contigua                     183
       4.4.   Intercambio                                                            186
       4.5.   Memoria virtual                                                        187
              4.5.1. Paginación                                                      188
              4.5.2. Segmentación                                                    197
              4.5.3. Segmentación paginada                                           198
              4.5.4. Paginación por demanda                                          199
              4.5.5. Políticas de reemplazo                                          201
              4.5.6. Política de asignación de marcos de página                      204
              4.5.7. Hiperpaginación                                                 205
              4.5.8. Gestión del espacio de swap                                     207
       4.5.9. Operaciones sobre las regiones de un proceso                           208




Digitalización realizada con propósito académico

<!-- pág. 9 -->

viii   Contenido


       4.6.  Archivos proyectados en memoria                                210
       4.7.  Servicios de gestión de memoria                                212
             4.7.1. Servicios genéricos de memoria                          212
             4.7.2. Servicios de memoria de POSIX                           212
             4.7.3. Servicios de memoria de Win32                           216
       4.8.  Puntos a recordar                                              219
       4.9.  Lecturas recomendadas                                          220
       4.10. Ejercicios                                                     221

5. COMUNICACIÓN Y SINCRONIZACIÓN DE PROCESOS                                223
      5.1. Procesos concurrentes                                            224
              5.1.1. Tipos de procesos concurrentes                         225
      5.2. Problemas clásicos de comunicación y sincronización              226
              5.2.1. El problema de la sección crítica                      226
              5.2.2. Problema del productor-consumidor                      230
              5.2.3. El problema de los lectores-escritores                 230
              5.2.4. Comunicación cliente-servidor                          231
      5.3. Mecanismos de comunicación y sincronización                      232
              5.3.1. Comunicación mediante archivos                         232
              5.3.2. Tuberías                                               233
              5.3.3. Sincronización mediante señales                        237
              5.3.4. Semáforos                                              237
              5.3.5. Memoria compartida                                     242
              5.3.6. Mutex y variables condicionales                        243
      5.4. Paso de mensajes                                                 248
      5.5. Aspectos de implementación de los mecanismos de sincronización   253
              5.5.1. Implementación de la espera pasiva                     254
      5.6. Interbloqueos                                                    257
      5.7. Servicios POSIX                                                  258
              5.7.1. Tuberías                                               258
              5.7.2. Semáforos POSIX                                        265
              5.7.3. Mutex y variables condicionales en POSIX               270
              5.7.4. Colas de mensajes POSIX                                274
      5.8. Servicios Wjn32                                                  285
              5.8.1. Tuberías                                               286
              5.8.2. Secciones críticas                                     294
              5.8.3. Semáforos                                              295
              5.8.4. Mutex y eventos                                        299
              5.8.5. Mailslots                                              303
      5.9.    Puntos a recordar                                             305
      5.10. Lecturas recomendadas                                           306
      5.11. Ejercicios                                                      306

6.     INTERBLOQUEOS                                                        309
       6.1. Los interbloqueos: una historia basada en hechos reales         310
       6.2. Los interbloqueos en un sistema informático                     311
            6.2.1. Tipos de recursos                                        311




Digitalización realizada con propósito académico

<!-- pág. 10 -->

                                                                      Contenido    ix


       6.3.  Un modelo del sistema                                                317
             6.3.1. Representación mediante un grafo de asignación de recursos    318
             6.3.2. Representación matricial                                      322
       6.4.  Definición y caracterización del interbloqueo                        324
             6.4.1. Condición necesaria y suficiente para el interbloqueo         325
       6.5.  Tratamiento del interbloqueo                                         326
       6.6.  Detección y recuperación del interbloqueo                            327
             6.6.1. Detección del interbloqueo                                    328
             6.6.2. Recuperación del interbloqueo                                 334
       6.7.  Prevención del interbloqueo                                          334
             6.7.1. Exclusión mutua                                               335
             6.7.2. Retención y espera                                            336
             6.7.3. Sin expropiación                                              336
             6.7.4. Espera circular                                               337
       6.8.  Predicción del interbloqueo                                          337
             6.8.1. Concepto de estado seguro                                     338
             6.8.2. Algoritmos de predicción                                      339
       6.9.  Tratamiento del interbloqueo en los sistemas operativos              345
       6.10. Puntos a recordar                                                    347
       6.11. Lecturas recomendadas                                                349
       6.12. Ejercicios                                                           349

7. ENTRADA/SALIDA                                                               351
      7.1. Introducción                                                         352
      7.2. Caracterización de los dispositivos de E/S                           354
           7.2.1. Conexión de un dispositivo de E/S a una computadora           354
           7.2.2. Dispositivos conectados por puertos o proyectados en memoria 355
           7.2.3. Dispositivos de bloques y de caracteres                       356
           7.2.4. E/S programada o por interrupciones                           357
           7.2.5. Mecanismos de incremento de prestaciones                      361
      7.3. Arquitectura del sistema de entrada/salida                           363
           7.3.1. Estructura y componentes del sistema de E/S                   363
           7.3.2. Software de E/S                                               364
      7.4. Interfaz de aplicaciones                                             369
      7.5. Almacenamiento secundario                                            373
           7.5.1. Discos                                                        374
           7.5.2. El manejador de disco                                         379
           7.5.3. Discos en memoria                                             384
           7.5.4. Fiabilidad y tolerancia a fallos                              385
      7.6. Almacenamiento terciario                                             387
           7.6.1. Tecnología para el almacenamiento terciario                   388
           7.6.2. Estructura y componentes de un sistema de almacenamiento
                    terciario                                                   389
           7.6.3. Estudio de caso: Sistema de almacenamiento de altas prestaciones
                    (HPSS)                                                      391
      7.7. El reloj                                                             393
           7.7.1. El hardware del reloj                                         393
           7.7.2. El software del reloj                                         394




Digitalización realizada con propósito académico

<!-- pág. 11 -->

x    Contenido

       7.8.   El terminal                                                           397
              7.8.1. Modo de operación del terminal                                 397
              7.8.2. El hardware del terminal                                       398
              7.8.3. El software del terminal                                       400
       7.9.   La red                                                                404
       7.10. Servicios de entrada/salida                                            405
              7.10.1. Servicios genéricos de entrada/salida                         405
              7.10.2. Servicios de entrada/salida en POSIX                          406
              7.10.3. Servicios de entrada/salida en Win32                          410
       7.11. Puntos a recordar                                                      414
       7.12. Lecturas recomendadas                                                  416
       7.13. Ejercicios                                                             417

8.     GESTIÓN DE ARCHIVOS Y DIRECTORIOS                                            419
       8.1.    Visión de usuario del sistema de archivos                            420
       8.2. Archivos                                                                420
               8.2.1. Concepto de archivo                                           421
               8.2.2. Nombres de archivos                                           423
               8.2.3. Estructura de un archivo                                      424
               8.2.4. Métodos de acceso                                             427
               8.2.5. Semánticas de coutilización                                   428
       8.3. Directorios                                                             429
               8.3.1. Concepto de directorio                                        429
               8.3.2. Estructuras de directorio                                     432
               8.3.3. Nombres jerárquicos                                           435
               8.3.4. Construcción de la jerarquía de directorios                   437
       8.4. Servicios de archivos y directorios                                     438
               8.4.1. Servicios genéricos para archivos                             439
               8.4.2. Servicios POSIX para archivos                                 440
               8.4.3. Ejemplo de uso de servicios POSIX para archivos               443
               8.4.4. Servicios Win32 para archivos                                 445
               8.4.5. Ejemplo de uso de servicios Win32 para archivos               449
               8.4.6. Servicios genéricos de directorios                            451
               8.4.7. Servicios POSIX de directorios                                451
               8.4.8. Ejemplo de uso de servicios POSIX para directorios            454
               8.4.9. Servicios Win32 para directorios                              456
               8.4.10. Ejemplo de uso de servicios Win32 para directorios           458
       8.5. Sistemas de archivos                                                    459
               8.5.1. Estructura del sistema de archivos                            461
               8.5.2. Otros tipos de sistemas de archivos                           465
       8.6. El servidor de archivos                                                 468
               8.6.1. Estructura del servidor de archivos                           469
               8.6.2. Estructuras de datos asociadas con la gestión de archivos     472
               8.6.3. Mecanismos de asignación y correspondencia de bloques a
                       archivos                                                     474
               8.6.4. Mecanismos de gestión de espacio libre                        477
               8.6.5. Mecanismos de incremento de prestaciones                      479
               8.6.6. Montado de sistemas de archivos e interpretación de nombres   483




Digitalización realizada con propósito académico

<!-- pág. 12 -->

                                                                         Contenido    xi

              8.6.7. Fiabilidad y recuperación                                       485
              8.6.8. Otros servicios                                                 489
       8.7.   Puntos a recordar                                                      491
       8.8.   Lecturas recomendadas                                                  493
       8.9.   Ejercicios                                                             493

9.     SEGURIDAD Y PROTECCIÓN                                                        497
       9.1.   Conceptos de seguridad y protección                                    498
       9.2.   Problemas de seguridad                                                 499
              9.2.1. Uso indebido o malicioso de programas                           500
              9.2.2. Usuarios inexpertos o descuidados                               501
              9.2.3. Usuarios no autorizados                                         501
              9.2.4. Virus                                                           502
              9.2.5. Gusanos                                                         503
              9.2.6. Rompedores de sistemas de protección                            504
              9.2.7. Bombardeo                                                       504
       9.3.   Políticas de seguridad                                                 505
              9.3.1. Política militar                                                505
              9.3.2. Políticas comerciales                                           507
              9.3.3. Modelos de seguridad                                            508
       9.4.   Diseño de sistemas operativos seguros                                  509
              9.4.1. Principios de diseño y aspectos de seguridad                    509
              9.4.2. Técnicas de diseño de sistemas seguros                          512
              9.4.3. Controles de seguridad externos al sistema operativo            515
              9.4.4. Controles de seguridad del sistema operativo                    518
       9.5.   Criptografía                                                           519
              9.5.1. Conceptos básicos                                               519
              9.5.2. Sistemas de clave privada y sistemas de clave pública           522
       9.6.   Clasificaciones de seguridad                                           524
              9.6.1. Clasificación del Departamento de Defensa (D0D) de Estados
                      Unidos                                                         524
       9.7.   Seguridad y protección en sistemas operativos de propósito general     526
              9.7.1. Autenticación de usuarios                                       526
              9.7.2. Palabras clave o contraseñas                                    528
              9.7.3. Dominios de protección                                          531
              9.7.4. Matrices de protección                                          534
              9.7.5. Listas de control de accesos                                    535
              9.7.6. Capacidades                                                     538
       9.8. Servicios de protección y seguridad                                      540
              9.8.1. Servicios genéricos                                             540
              9.8.2. Servicios POSIX                                                 541
              9.8.3. Ejemplo de uso de los servicios de protección de POSIX          543
              9.8.4. Servicios de Win32                                              545
              9.8.5. Ejemplo de uso de los servicios de protección de Win32          548
       9.9.   El sistema de seguridad de Windows NT                                  550
       9.10. Kerberos                                                                552
       9.11. Puntos a recordar                                                       556




Digitalización realizada con propósito académico

<!-- pág. 13 -->

xii   Contenido

       9.12. Lecturas recomendadas                                                557
       9.13. Ejercicios                                                           557

10.    INTRODUCCIÓN A LOS SISTEMAS DISTRIBUIDOS                                   561
       10.1. Sistemas distribuidos                                                562
              10.1.1. Características de un sistema distribuido                   562
              10.1.2. Redes e interconexión                                       563
              10.1.3. Protocolos de comunicación                                  564
       10.2. Sistemas operativos distribuidos                                     566
       10.3. Comunicación de procesos en sistemas distribuidos                    570
              10.3.1. Sockets                                                     570
              10.3.2. Llamadas a procedimientos remotos                           582
              10.3.3. Comunicación de grupos                                      592
       10.4. Sincronización de procesos en sistemas distribuidos                  593
              10.4.1. Ordenación de eventos en sistemas distribuidos              593
              10.4.2. Exclusión mutua en sistemas distribuidos                    596
       10.5. Gestión          de procesos                                         598
              10.5.1. Asignación de procesos a procesadores                       598
              10.5.2. Algoritmos de distribución de la carga                      599
              10.5.3. Planificación de procesos en sistemas distribuidos          601
       10.6. Sistemas de archivos distribuidos                                    601
              10.6.1. Nombrado                                                    602
              10.6.2. Métodos de acceso remotos                                   603
              10.6.3. Utilización de cache en sistemas de archivos distribuidos   604
       10.7. Gestión          de memoria en sistemas distribuidos                 606
       10.8. Puntos a recordar                                                    607
       10.9. Lecturas         recomendadas                                        609
       10.10. Ejercicios                                                          609

11.    ESTUDIO DE CASOS: LINUX                                                    611
       11.1. Historia de LINUX                                                    612
       11.2. Características y estructura de LINUX                                613
       11.3. Gestión de procesos                                                  614
       11.4. Gestión de memoria                                                   615
       11.5. Entrada/salida                                                       616
       11.6. Sistema de archivos                                                  616
       11.7. Puntos a recordar                                                    617
       11.8. Lecturas recomendadas                                                617

12.    ESTUDIO DE CASOS: WINDOWS NT                                               619
       12.1. Introducción                                                         620
       12.2. Principios de diseño de Windows NT                                   620
       12.3. Arquitectura de Windows NT                                           621




Digitalización realizada con propósito académico

<!-- pág. 14 -->

                                                                      Contenido    xiii

         12.4. El núcleo de Windows NT                                             623
         12.5. El ejecutivo de Windows NT                                          624
                12.5.1. Gestor de objetos                                          624
                12.5.2. Gestor de procesos                                         625
                12.5.3. Gestor de memoria virtual                                  627
                12.5.4. Llamada a procedimiento local                              630
                12.5.5. Gestor de entrada/salida                                   631
         12.6. Subsistemas de entorno de ejecución                                 635
         12.7. Sistemas de archivos de Windows NT                                  636
                12.7.1. Sistemas de archivos tipo FAT                              637
                12.7.2. Sistemas de archivos de alto rendimiento (HPFS)            638
                12.7.3. NTFS                                                       639
                12.7.4. Comparación de los sistemas de archivos PAT, HPFS y NTFS   642
         12.8. El subsistema de seguridad                                          642
                12.8.1. Autenticación de usuarios                                  643
                12.8.2. Listas de control de acceso en Windows NT                  645
         12.9. Mecanismos para tolerancia a fallos en Windows NT                   646
         12.10. Puntos a recordar                                                  648
         12.11. Lecturas recomendadas                                              649

A.       Comparación de los servicios POSIX y Win32                                651

B.       Entorno de programación de sistemas operativos                            657

C.       Trabajos prácticos de sistemas operativos                                 669

Bibliografía                                                                       709

Índice                                                                             721




Digitalización realizada con propósito académico

<!-- pág. 15 -->

o




Digitalización realizada con propósito académico

