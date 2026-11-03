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
