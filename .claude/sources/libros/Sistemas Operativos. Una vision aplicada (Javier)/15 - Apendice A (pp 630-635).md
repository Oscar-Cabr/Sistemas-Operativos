# Apendice A

> Fuente: Sistemas Operativos. Una vision aplicada (Javier) — páginas 630–635 (numeración del PDF)

<!-- pág. 630 -->

                                        Comparación de los servicios
                                                                                               A
                                                     POSIX y Win32




Tema                 POSIX                     Win32                Comentarios
Señales              pause                                          Suspende proceso hasta recepción de
                                                                    señal
Señales              kill                                           Manda una señal
Señales              sigempty,   sigfillset,                        Manipulación de conjuntos de señales
                     sigaddset, sigdelset,
                     sigismember
Señales              sigprocmask                                    Consulta o modificación de la
                                                                    máscara de señales
Señales              sigpending                                     Obtiene qué señales están pendientes
                                                                    de entregar
Señales              sigaction                                      Gestión detallada de señales
Señales              sigsetjmp, siglongjmp                          Realizan saltos no locales
Señales              sigsuspend                                     Especifica máscara y suspende
                                                                    proceso hasta señal
Gestión de memoria   mmap                      CreateFileMapping,   Proyecta en memoria un archivo. En
                                               MapviewOfFile        Win32 requiere el uso de dos
                                                                    funciones     (CreateFileMapping   y
                                                                    MapViewOfFile)
Gestión de memoria   munmap                    UnmapViewOfFile      Desproyecta un archivo
Memoria compartida   shmget                    CreateFileMapping    Crea o asigna un segmento de
                                                                    memoria compartida
Memoria compartida   shmat                     MapViewOfFile        Proyecta un segmento de memoria
                                                                    compartida
Memoria compartida   shmdt                     UnmapViewOfFile      Desproyecta     un    segmento    de
                                                                    memoria compartida




  Digitalización Realizada con propósito académico. Sistemas Operativos                            651

<!-- pág. 631 -->

   652     Sistemas Operativos. Una visión aplicada



Tema                     POSIX                   Win32                       Comentarios
Cerrojos de archivos y   fentl (emd =            LockFile,LockFileEx         Establece un cerrojo a un
E/S                      F_SETLK, …)                                         archivo
Cerrojos de archivos y   fentl (emd =            UnlockFile,UnlockFileEx     Elimina un cerrojo de un
E/S                      F_SETLK, …)                                         archivo
Procesos                 fork y después exec     CreateProcess               Crea proceso (CreateProcess
                                                                             equivale a fork + exec
Procesos                 _exit                   ExitProcess                 Termina el proceso
Procesos                 getpid                  GetCurrentProcess,          Obtiene identificador del
                                                 GetCurrentProcessId         proceso
Procesos                 wait, waitpid           GetExitCodeProcess          Obtiene información de
                                                                             proceso ya terminado
Procesos                 excel, execv, execle,                               Ejecuta un programa (no hay
                         execve, execlp,                                     equivalente en Win32)
                         execvp
Procesos                 fork                                                Crea proceso duplicado (no
                                                                             hay equivalente en Win32)
Procesos                 getppid                                             Obtiene ID del padre (en
                                                                             Win32 no hay relación
                                                                             padre/hijo)
Procesos                 getgid, getegid                                     Obtiene ID del grupo (en
                                                                             Win32 no hay grupos de
                                                                             procesos)
Procesos                 kill                    TerminateProcess            Finaliza la ejecución de un
                                                                             proceso
Procesos                 waitpid                 WaitForMultipleObjects      Espera la terminación de un
                                                 (manejadores de procesos)   proceso (en Win32 de
                                                                             múltiples procesos)
Procesos                 wait, waitpid           WaitForSingleObject         Espera la terminación de un
                                                 (manejador de proceso)      proceso
Comunicación             close                   CloseHandle (manejador      Cierra una tubería
                                                 de tubería)
Comunicación             mq_open                 CreateFile (mailslot)       Abre una cola de mensajes en
                                                                             POSIX y un mailslot en Win32
Comunicación             mq_open                 CreateMailslot              Crea una cola de mensajes en
                                                                             POSIX y un mailslot en Win32
Comunicación             mq_close                CloseHandle (manejador      Cierra una cola de mensajes
                                                 de mailslot)                en POSIX y un mailslot en
                                                                             Win32
Comunicación             mq_send                 WriteFile (manejador de     Envía datos a una cola de
                                                 mailslot)                   mensajes en POSIX y a un
                                                                             mailslot en Win32
Comunicación             mq_receive              ReadFile (manejador de      Recibe datos de una cola de
                                                 mailslot)                   mensajes en POSIX y de un
                                                                             mailslot en Win32
Comunicación             mq_unlink               CloseHandle (manejador      Borra una cola de mensajes
                                                 de mailslot)                en POSIX y un mailslot en
                                                                             Win32 cuando deja de estar
                                                                             referenciado
Comunicación             mq_getattr              GetMailSlotInfo             Obtiene atributos de una cola
                                                                             de mensajes en POSIX y un
                                                                             mailslot en Win32
Comunicación             mq_setattr              SetMailSlotInfo             Fija los atributos de una cola
                                                                             de mensajes en POSIX y un
                                                                             mailslot en Win32




   Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 632 -->

                           Apéndice A. Comparación de los servicios POSIX y Win32                  653



Tema                  POSIX                  Win32                    Comentarios
Comunicación          mkfifo                 CreateNamedPipe          Crea una tubería con nombre
Comunicación          pipe                   CreatePipe               Crea una tubería sin nombre
Comunicación          dup or dup2 or fentl   DuplicateHandle          Duplica un manejador de
                                                                      archive
Comunicación          read (tubería)         ReadFile (tubería)       Lee datos de una tubería
Comunicación          write (tubería)        WriteFile (tubería)      Escribe datos en una tubería
Comunicación          close                  CloseHandle              Cierra una tubería
Procesos ligeros      pthread_create         Create Thread            Crea un proceso ligero
Procesos ligeros      pthread_exit           ExitThread               Finaliza la ejecución de un
                                                                      proceso ligero
Procesos ligeros                             GetCurrentThread         Devuelve el manejador del
                                                                      proceso ligero que ejecuta
Procesos ligeros                             GetCurrenteThreadId      Devuelve el identificador del
                                                                      proceso ligero que ejecuta
Procesos ligeros      pthread_join           GetExitCodeThread        Obtiene el código de
                                                                      finalizaciónj de un proceso
                                                                      ligero
Procesos ligeros                             ResumeThread             Pone en ejecución un proceso
                                                                      ligero suspendido
Procesos ligeros                             SuspendThread            Suspende la ejecución de un
                                                                      proceso ligero
Procesos ligeros      pthread_join           WaitForSingleObject      Espera la terminación de un
                                             (manejador de proceso    proceso ligero
                                             ligero)
Procesos ligeros                             WaitForMultipleObject    Espera la terminación de
                                             (manejador de proceso    múltiples procesos ligeros en
                                             ligero)                  Win32
Procesos ligeros                             GetPriorityClass         Devuelve la clase de prioridad
                                                                      de un proceso
Procesos ligeros      sched_getparam         GetThreadPriority        Devuelve la prioridad de un
                                                                      proceso ligero
Procesos ligeros                             SetPriorityClass         Fija la clase de prioridad de un
                                                                      proceso
Procesos ligeros      sched_setparam         SetThreadPriority        Fija la prioridad de un proceso
                                                                      ligero
Sincronización        pthread_cont_destroy   CloseHandle (manejador   Destruye una variable
                                             de evento)               condicional en POSIX y un
                                                                      evento en Win32 cuando deja
                                                                      de estar referenciado
Sincronización        pthread_cond_init      CreateEvent              Inicia una variable condicional
                                                                      y un evento
Sincronización        pthread_cond_          PulseEvent               Despierta a los procesos
                      broadcast                                       ligeros bloqueados en una
                                                                      variable condicional o un
                                                                      evento
Sincronización        pthread_cond_signal    SetEvent                 Despierta a un proceso ligero
                                                                      bloqueado en una variable
                                                                      condicional o evento
Sincronización        pthread_cond_wait      WaitForSingleObject      Bloquea a un proceso en una
                                             (manejador de evento)    variable condicional o evento
Semáforos binarios    pthread_mutex_         CloseHandle (manejador   Destruye un mutex
                      destroy                de mutex)




   Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 633 -->

     654        Sistemas Operativos. Una visión aplicada




Tema                   POSIX                   Win32                       Comentarios
Semáforos binarios     pthread_mutex_init      CreateMutex                 Inicia un mutex
Semáforos binarios     pthread_mutex_unlock    ReleaseMutex                Operación unlock sobre un
Semáforos binarios                                                         mutex
                       pthread_mutex_lock      WaitForSingleObject         Operación lock sobre un mutex
                                               (manejador de mutex)
Semáforos              sem_open                CreateSemaphore             Crea un semáforo con nombre
Semáforos              sem_init                                            Inicia un semáforo sin nombre
Semáforos              sem_open                OpenSemaphore               Abre un semáforo con nombre
Semáforos              sem_close               CloseHandle (manejador de   Cierra un semáforo
                                               semáforo)
Semáforos              sem_post                ReleaseSemaphore            Operación signal sobre un
                                                                           semáforo
Semáforos              sem_wait                WaitForSingleObject         Operación       wait   sobre    un
                                               (manejador de semáforo)     semáforo
Manejo de errores      errno                   GetLastError                Almacena información sobre la
                                                                           última llamada al sistema
Tiempo                 time                    GetSystemTime               Obtiene el tiempo de calendario
Tiempo                 localtime               GetLocalTime                Obtiene el tiempo de calendario
                                                                           en horario local
Tiempo                 stime                   SetSystemTime               Establece la hora y fecha
Tiempo                 alarm                   SetTimer                    Establece un temporizador
Tiempo                 times                   GetProcessTimes             Obtiene los tiempos del proceso
Archivo y E/S          tcgetattr, tcsetattr    SetConsoleMode              Establece el modo de operación
                                                                           del terminal
Archivo y E/S          read, write             ReadConsole, WriteConsole   Lectura y escritura en el terminal
Archivo y E/S          close                   CloseHandle                 No está limitada a archivos
Archivo y E/S          open, creat             CreateFile                  Crea o abre un archivo
Archivo y E/S          unlink                  DeleteFile                  Borra un archivo
Archivo y E/S          fsync                   FlushFileBuffers            Vuelca la cache del archivo a
                                                                           disco
Archivo y E/S          stat, fstat             GetFileAttributes           Obtiene los atributos de un
                                                                           archivo
Archivo y E/S          stat, fstat             GetFileSize                 Longitud del archivo en bytes
Archivo y E/S          stat, fstat             GetFileTime                 Fechas relevantes para el
                                                                           archivo
Archivo y E/S          stat, fstat             GetFileType                 Archivo      o    dispositivo   de
                                                                           caracteres
Archivo y E/S          stdin, stdout, stderr   GetStdHandle                Devuelve un dispositivo de E/S
                                                                           estándar
Archivo y E/S          link, symlink                                       Win32 no proporciona enlaces
Archivo y E/S          readv                                               Lectura simple
Archivo y E/S          writev                                              Escritura simple
Archivo y E/S          read                    ReadFile                    Lee datos de un archivo
Archivo y E/S          truncate, ftruncate     SetEndOfFile                Fija la longitud de un archivo
Archivo y E/S          fentl                   SetFileAttributes           Cambia los atributos de un
                                                                           archivo
Archivo y E/S          lseek                   SetFilePointer              Devuelve el apuntador de
                                                                           posición del archivo




     Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 634 -->

                                     Apéndice A. Comparación de los servicios POSIX y Win32               655




Tema            POSIX                        Win32                         Comentarios
Archivo y E/S   utime                        SetFileTime                   Modifica las fechas de un archivo
Archivo y E/S                                SetStdHandle                  Define un manejador de E/S
                                                                           estándar
Archivo y E/S   write                        WriteFile                     Escribe datos a un archivo
Archivo y E/S                                CreateFileMapping             Define la proyección de un archivo
                                                                           en memoria
Archivo y E/S   mmap                         MapViewOfFile                 Proyecta un archivo en memoria
Archivo y E/S                                OpenFileMapping               Abre un archivo proyectado en
                                                                           memoria
Archivo y E/S   munmap                       UnmapViewOfFile               Elimina la proyección en memoria de
                                                                           un archivo
Directorios     mkdir                        CreateDirectory               Crea un nuevo directorio
Directorios     closedir                     FindClose                     Cierra un directorio
Directorios     opendir, readdir             FindFirstFile                 Busca una entrada en un directorio
Directorios     readdir                      FindNextFile                  Extrae la siguiente entrada de
                                                                           directorio
Directorios     getcwd                       GetCurrentDirectory           Devuelve el nombre del directorio de
                                                                           trabajo
Directorios     rmdir, unlink                RemoveDirectory               Borra un directorio
Directorios     chdir, fchdir                SetCurrenteDirectory          Cambia el directorio de trabajo
Seguridad                                    DeleteAce                     Borra una entrada de control de
                                                                           acceso de una ACL
Seguridad       stat, fstat, lstat           GetAce                        Devuelve una entrada de control de
                                                                           acceso de una ACL
Seguridad       stat, fstat, lstat           GetAcInformation              Extrae la información de una ACL
Seguridad       stat, fstat, lstat, access   GetFileSecurity               Devuelve el descriptor de seguridad
                                                                           de un archivo
Seguridad       stat, fstat, lstat           GetSecurityDescriptor         Devuelve el descriptor de seguridad
                                                                           de un usuario
Seguridad       getlogin                     GetUserName                   Devuelve el nombre de sistema de
                                                                           un usuario
Seguridad                                    InitializeAcl                 Inicia la información de una ACL
Seguridad       umask                        IniatilzeSecurityDescriptor   Inicia el descriptor de seguridad de
                                                                           un usuario
Seguridad       getpwnam, getgrnam           LookupAccountName             Devuelve el nombre de sistema de
                                                                           una cuenta
Seguridad       getpwuid, getuid,            LookupAccountSid              Devuelve el identificador de sistema
                geteuid                                                    de una cuenta
Seguridad       setuid, seteuid, setreuid                                  Activan los distintos UID de un
                                                                           archivo en UNIX
Seguridad       setgid, setegid, setregid                                  Activan los distintos GID de un
                                                                           archivo en UNIX
Seguridad       getgroups, setgroups,        OpenProcessToken              Grupos suplementarios
                initgroups
Seguridad       chmod, fchmod                SetFileSecurity               Cambian permisos de archivo




     Digitalización Realizada con propósito académico. Sistemas Operativos

<!-- pág. 635 -->

    656     Sistemas Operativos. Una visión aplicada




Tema           POSIX               Win32                        Comentarios
Seguridad                          SetPrivateObjectSecurity     Cambian permisos de objetos
                                                                privados
Seguridad      umask               SetSecurityDescriptorDacl    Cambian máscara de protección por
                                                                defecto
Seguridad      chown, fchown,      SetSecurityDescriptorGroup   Cambian el dueño de un archivo
               lchown




    Digitalización Realizada con propósito académico. Sistemas Operativos

