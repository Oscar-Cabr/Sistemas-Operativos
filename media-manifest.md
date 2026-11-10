# Manifiesto de material gráfico

Registro global y acumulativo de las imágenes, diagramas y tablas identificados en fuentes confiables para los entregables del curso. Persiste entre trabajos.

Este archivo **no almacena binarios**, solo su referencia y trazabilidad. La obtención y colocación física de cada archivo es responsabilidad del usuario. Lo mantiene la skill `registrar-media`.

Convención de ruta: `media/[t|p]<NN>/<tag>.<ext>`, con `<tag>` en camelCase y alusivo al contenido.

---

## t00 — Registro en sistema EDUCAFI

| Tag | Fuente | Ubicación exacta | Descripción | Ruta destino | Estado |
| --- | --- | --- | --- | --- | --- |
| `fotoPerfil` | Captura propia | — | Evidencia de la actualización de la foto de perfil en EDUCAFI | `media/t00/foto_perfil.jpeg` | colocada |

> Nota: el nombre de archivo `foto_perfil.jpeg` es previo a la convención camelCase y se conserva para no romper el entregable ya compilado.

---

## titlepage — Recursos institucionales compartidos

| Tag | Fuente | Ubicación exacta | Descripción | Ruta destino | Estado |
| --- | --- | --- | --- | --- | --- |
| `escudoUnam` | UNAM | Identidad institucional | Escudo de la Universidad Nacional Autónoma de México | `media/titlepage/Escudo-UNAM.pdf` | colocada |
| `escudoFi` | Facultad de Ingeniería, UNAM | Identidad institucional | Escudo de la Facultad de Ingeniería | `media/titlepage/FI.png` | colocada |

---

## t07 — Herramientas de trabajo

| Tag | Fuente | Ubicación exacta | Descripción | Ruta destino | Estado |
| --- | --- | --- | --- | --- | --- |
| `arquitecturaClienteServidor` | `stallings2018operating` | Cap. 18, §18.1, p. 18-4 (p. 828) | Arquitectura genérica cliente-servidor y separación de capas de presentación y aplicación | `media/t07/arquitecturaClienteServidor.png` | colocada |
| `taxonomiaProcesamiento` | `stallings2018operating` | Cap. 18, §18.1, p. 18-7 (p. 831) | Clasificación de esquemas de procesamiento cliente-servidor y modelo de cliente ligero | `media/t07/taxonomiaProcesamiento.png` | colocada |
| `capturaInyeccionEventosSo` | Arquitectura de SO | Subsistemas gráficos Win32k/Wayland y colas de eventos del SO | Flujo de intercepción de pantalla en el subsistema gráfico e inyección de eventos sintéticos | `media/t07/capturaInyeccionEventosSo.png` | colocada |
| `atravesamientoNatIce` | `rfc8445` | RFC 8445, §2, p. 9 (Figura 1) | Arquitectura de recolección de candidatos ICE y atravesamiento de NAT mediante STUN/TURN | `media/t07/atravesamientoNatIce.png` | colocada |
| `arquitecturaChromeRemoteDesktop` | `chromiumChromoting` | Chromium Source Tree, `remoting/docs/` | Arquitectura multiproceso del host Chromoting y separación de procesos vía Mojo IPC | `media/t07/arquitecturaChromeRemoteDesktop.png` | colocada |
| `arquitecturaPasarelasLogmein` | `anka2007logmein` | White Paper, p. 4 (Figura de pasarelas y brokers) | Arquitectura de pasarela de conexión y túnel saliente de tres entidades en LogMeIn | `media/t07/arquitecturaPasarelasLogmein.png` | colocada |
| `arquitecturaEnrutamientoTeamviewer` | `teamviewerSecurityWhitepaper` | Security Whitepaper, §3, p. 7 | Topología de la red de TeamViewer: Servidores maestros, routers y conmutación P2P/Relay | `media/t07/arquitecturaEnrutamientoTeamviewer.png` | colocada |
| `arquitecturaShowmypcTunnel` | `showmypcUserGuide` | Architecture Overview | Encapsulación de RFB en túnel inverso SSH y pasarela de retransmisión en ShowMyPC | `media/t07/arquitecturaShowmypcTunnel.png` | colocada |
| `arquitecturaMobizenMirroring` | `rsupportMobizenWhitepaper` | Architecture Overview | Arquitectura de réplica móvil, captura por MediaProjection e inyección de eventos en Mobizen | `media/t07/arquitecturaMobizenMirroring.png` | colocada |

---

## t08 — Herramientas de trabajo

| Tag | Fuente | Ubicación exacta | Descripción | Ruta destino | Estado |
| --- | --- | --- | --- | --- | --- |
| `estructurasControlAcceso` | `stallings2018operating` | Cap. 15, §15.3, p. 671 (Figura 15.3) | Representación formal de la matriz de acceso y su descomposición en listas de control de acceso (ACL) y listas de capacidades | `media/t08/estructurasControlAcceso.png` | colocada |
| `desbordamientoPilaMemoria` | `stallings2018operating` | Cap. 15, §15.2, p. 664 (Figura 15.2) | Estado del marco de pila antes y después de un desbordamiento de búfer con sobreescritura de la dirección de retorno | `media/t08/desbordamientoPilaMemoria.png` | colocada |

---

## t02 — Memoria y procesos

| Tag | Fuente | Ubicación exacta | Descripción | Ruta destino | Estado |
| --- | --- | --- | --- | --- | --- |
| `jerarquiaMemoriaPiramide` | `stallings2018operating` | Cap. 1, §1.5, p. 47 (Figura 1.14) | Niveles jerárquicos de memoria, compensación costo-rendimiento y tiempos de acceso | `media/t02/jerarquiaMemoriaPiramide.png` | colocada |
| `memoriaTubosWilliams` | Historia de la computación | Museo de Ciencia e Industria de Mánchester / ourplnt.com | Tubo Williams-Kilburn de almacenamiento electrostático de acceso aleatorio (1947) | `media/t02/memoriaTubosWilliams.png` | colocada |
| `memoriaNucleosFerrita` | El Tamiz / `mchoes2011sistemas` | Cap. 2, §2.1, p. 32 (Figura 2.1) | Matriz de memoria de núcleos magnéticos toroidales con hilos coincidentes (1953) | `media/t02/memoriaNucleosFerrita.jpg` | colocada |
| `chipDramIntel1103` | Intel Corporation / Wikipedia | Encapsulado cerámico DIP de 18 pines | Circuito integrado Intel 1103 en encapsulado DIP de 18 pines, primera DRAM comercial (1970) | `media/t02/chipDramIntel1103.jpg` | colocada |
| `evolucionModulosDram` | Estándares JEDEC / History of Information | Especificaciones JESD79 de memoria SDRAM | Comparativa de formatos de módulos DIMM y muescas mecánicas de SDR a DDR5 | `media/t02/evolucionModulosDram.png` | colocada |
| `discoIbmRamac` | HistoryBit / IBM Archives | IBM 305 RAMAC Historical Timeline | Sistema de almacenamiento en disco rígido IBM 305 RAMAC con 50 platos de 24 pulgadas (1956) | `media/t02/discoIbmRamac.jpg` | colocada |
| `estructuraInternaHdd` | `silberschatz2006fundamentos` | Cap. 12, §12.1, p. 409 (Figura 12.1) | Anatomía interna de un disco rígido magnético (platos, cabezales, cilindros y actuador VCM) | `media/t02/estructuraInternaHdd.png` | colocada |
| `arquitecturaSsdNvme` | Greenliant / Mouser / NVM Express | Diagrama de bloques de arquitectura de almacenamiento | Diagrama de bloques de un SSD NVMe M.2 (controlador FTL, DRAM caché, canales Flash 3D NAND y PCIe) | `media/t02/arquitecturaSsdNvme.png` | colocada |

---

## t03 — Atajos, Vi y comandos

| Tag | Fuente | Ubicación exacta | Descripción | Ruta destino | Estado |
| --- | --- | --- | --- | --- | --- |
| `vimModoNormalInicio` | Captura propia | Terminal GNU/Linux | Interfaz inicial de Vim en modo Normal sobre un archivo nuevo de código fuente | `media/t03/vimModoNormalInicio.png` | colocada |
| `vimModoInsercion` | Captura propia | Terminal GNU/Linux | Edición e ingreso de código en modo Inserción con indicador `-- INSERT --` | `media/t03/vimModoInsercion.png` | colocada |
| `vimComandoOperador` | Captura propia | Terminal GNU/Linux | Aplicación de operadores gramaticales y movimientos estructurales en modo Normal | `media/t03/vimComandoOperador.png` | colocada |
| `vimModoVisualBloque` | Captura propia | Terminal GNU/Linux | Selección matricial de columnas en modo Visual Bloque (`Ctrl + v`) | `media/t03/vimModoVisualBloque.png` | colocada |
| `vimModoExGuardado` | Captura propia | Terminal GNU/Linux | Ejecución de órdenes de sustitución y persistencia en disco en modo Ex (`:wq`) | `media/t03/vimModoExGuardado.png` | colocada |

---

## t04 — Sistemas de archivos

| Tag | Fuente | Ubicación exacta | Descripción | Ruta destino | Estado |
| --- | --- | --- | --- | --- | --- |
| `estructurasArchivosAbiertos` | `silberschatz2006fundamentos` | Cap. 11, §11.2, p. 373 (Figura 11.3) | Estructuras en memoria del sistema operativo para la apertura y lectura de archivos: tablas por proceso, tabla global del sistema y FCB/inodos | `media/t04/estructurasArchivosAbiertos.png` | colocada |
| `capasSistemaArchivos` | `silberschatz2006fundamentos` | Cap. 11, §11.1, p. 371 (Figura 11.1) | Arquitectura por capas de un sistema de archivos: sistema lógico, módulo de organización, sistema básico y controladores de E/S | `media/t04/capasSistemaArchivos.png` | colocada |

---

## t05 — Particionamiento de discos

| Tag | Fuente | Ubicación exacta | Descripción | Ruta destino | Estado |
| --- | --- | --- | --- | --- | --- |
| — | — | — | Documento estructurado íntegramente mediante 10 cuadros y tablas técnicas comparativas normalizadas en LaTeX sin figuras externas | — | colocada |

---

## t06 — Sistemas distribuidos

| Tag | Fuente | Ubicación exacta | Descripción | Ruta destino | Estado |
| --- | --- | --- | --- | --- | --- |
| `comparativaArquitecturaNosDos1` | `mchoes2011sistemas` | Cap. 10, p. 319 (Figura 10.1) | Modelo estructural desacoplado de un sistema operativo de red (NOS) | `media/t06/comparativaArquitecturaNosDos_1.png` | colocada |
| `comparativaArquitecturaNosDos2` | `mchoes2011sistemas` | Cap. 10, p. 320 (Figura 10.2) | Modelo estructural integrado de un sistema operativo distribuido (DO/S) | `media/t06/comparativaArquitecturaNosDos_2.png` | colocada |

---

## p05 — Windows Server IIS

| Tag | Fuente | Ubicación exacta | Descripción | Ruta destino | Estado |
| --- | --- | --- | --- | --- | --- |
| `puenteRedVmnet0` | `vmwareWorkstationPro26h1` | Doc. VMware Workstation Pro 26H1, p. 151 (Figura 2) | Conexión de la máquina virtual al adaptador de red físico del anfitrión a través del puente virtual y el conmutador VMnet0 | `media/p05/puenteRedVmnet0.png` | colocada |
| `opcionServerCore` | `microsoftInstallWinServer2008` | «Install Windows Server 2008 and Windows Server 2008 R2», Figura 2 | Pantalla de selección de edición con las variantes de instalación completa y Server Core para las ediciones Standard, Enterprise y Datacenter | `media/p05/opcionServerCore.jpg` | colocada |
| `jerarquiaEntidadesGp` | `microsoftGroupPolicyInfra` | «Group Policy Infrastructure», sección «Hierarchy of Managed Entities» | Jerarquía de entidades administradas por la infraestructura de Group Policy: motor de directivas, instalación de software, scripts y registro | `media/p05/jerarquiaEntidadesGp.png` | colocada |
| `delegacionZonaDns` | `microsoftZoneDelegation` | «Understanding Zone Delegation», sección «Example: Delegating a subdomain to a new zone» | Delegación de una zona hija dentro de la zona matriz, con los registros de servidor de nombres y de enlace que la zona matriz debe escribir | `media/p05/delegacionZonaDns.png` | colocada |



