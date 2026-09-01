# Chapter 21 - Case Study: Windows XP

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 1083–1187 (numeración del PDF)

<!-- pág. 1083 -->

Chapter 21

Case Study: Windms XP
 Objectives
 After reading this chapter, you should understand:
 • the history of DOS and Windows operating systems.
 • the Windows XP architecture.
 • the various Windows XP subsystems.
 • asynchronous and deferred procedure calls.
 • how user processes, the executive and the kernel interact.
 • how Windows XP performs process, thread, memory and file management.
 • the Windows XP I/O subsystem.
 • how Windows XP performs interprocess communication.
 • networking and multiprocessing in Windows XP.
 • the Windows XP security model.

<!-- pág. 1084 -->

                             Chapter Outline
                      21.1                                     21.6
                 Introduction                Process and Thread Management
                                             21.6.1 Process and Thread Organization
                     21.2                         21.6.2 Thread Scheduling
                   History                      21.6.3 Thread Synchronization
          Biographical Note: Bill Gates
         Biographical Note: David Cutler
            Mini Case Study: OS/2                      21.7
                                                 Memory Management
                     21.3                        21.7.1    Memory        Organization
                Design Goals                      21.7.2 Memory Allocation
                                                  21.7.3 Page Replacement
                     21.4
            System Architecture                                21.8
                                               File Systems Management
                     21.5                         21.8.1 File System Drivers
            System Management                           21.8.2 NTFS
                Mechanisms
              21.5.1 Registry
          21.5.2 Object Manager                                21.9
   21.5.3 Interrupt Request levels (IRQs)      Input/Output Management
       21.5.4 Asynchronous Procedure Calls          21.9.1 Device Drivers
                    (APCs)                     21.9.2     Input/Output     Processing
   21.5.5 Deferred Procedure Calls (DPCs)        21.9.3 Interrupt Handling
          21.5.6 System Threads                21.9.4 File Cache Management




1034

<!-- pág. 1085 -->

              21.10                                         21.11.4 Network Services
  Interprocess Communication                                     21.11.5 .NET
             21.10.1 Pipes
           21.10.2 Mailslots                                         21.12
        21.10.3 Shared Memory                                    Scalability
21.10.4 Local and Remote Procedure Calls               21.12.1 Symmetric Multiprocessing
                                                                     (SMP)
21.10.5 Component Object Models (COM)
                                                          21.12.2 Windows XP Embedded
 21.10.6 Drag-and-Drop and Compound
                Documents
                                                                    21.13
                  21.11                                            Securuty
               Networking                                    21.13.1 Authentication
     21.11.1    Network Input/Output                         21.13.2Authorization
  21.11.2 Network Driver Architecture                  21.13.3 Internet Connection Firewall
      21.11.3 Network Protocols                             21.13.4     Other Features




          Web Resources | Key Terms | Exercises | Recommended Reading | Works Cited




                                                                                              1035

<!-- pág. 1086 -->

1036 Case Study: Windows XP

                              21.1 Introduction
                              Windows XP, released by the Microsoft Corporation in 2001, combines Microsoft's
                              corporate and consumer operating system lines. By early 2003, over one-third of all
                              Internet users ran Windows XP, making it the most widely used operating system.1
                                    Windows XP ships in five editions. Windows XP Home Edition is the desktop
                              edition, and the other editions provide additional features. Windows XP Profes-
                              sional includes extra security and privacy features, more data recovery support and
                              broader networking capabilities. Windows XP Tablet PC Edition is built for note-
                              books and laptops that need enhanced support for wireless networking and digital
                              pens. Windows XP Media Center Edition provides enhanced multimedia support.2
                              Windows XP 64-Bit Edition is designed for applications that manipulate large
                              amounts of data, such as programs that perform scientific computing or render 3D
                              graphics. At the time of this writing, Microsoft plans to release a sixth edition, Win-
                              dows XP 64-Bit Edition for 64-Bit Extended Systems, which is designed specifically
                              to support AMD Opteron and Athlon 64 processors.3 Windows XP 64-Bit Edition
                              currently executes on Intel Itanium II processors.
                                    Despite their differences, all Windows XP editions are built on the same core
                              architecture, and the following case study applies to all editions (except when we
                              explicitly differentiate between editions). This case study investigates how a popu-
                              lar operating system implements the components and strategies we have discussed
                              throughout the book.


                              21.2 History
                              In 1975, a Harvard University junior and a young programmer at Honeywell
                              showed up at Micro Instrumentation and Telemetry Systems (MITS) headquarters
                              with a BASIC compiler. The two men had written the compiler in just eight weeks
                              and had never tested it on the computer for which it was intended. It worked on the
                              first run. This auspicious beginning inspired the student, Bill Gates, and the pro-
                              grammer, Paul Allen, to drop everything they were doing and move to Albuquer-
                              que, New Mexico, to found Microsoft (see the Biographical Note, Bill Gates).4-5 By
                              2003, the two-man company had become a global corporation, employing over
                              50,000 people and grossing a yearly revenue of over $28 billion.6 Microsoft is the
                              second most valuable and the sixth most profitable company in the world. Forbes
                              Magazine in 2003 listed Bill Gates as the richest man on Earth, worth over $40.7 bil-
                              lion, and Paul Allen as the fourth richest man, worth $20.1 billion.7
                                     Microsoft released the Microsoft Disk Operating System—MS-DOS 1.0—in
                              1981. MS-DOS 1.0 was a 16-bit operating system that supported 1MB of main
                              memory (1MB was enormous by the standards of the time). The system ran one
                              process at a time in response to user input from a command line. All programs exe-
                              cuted in real mode, which provided them direct access to all of main memory
                              including the portion storing the operating system.8 MS-DOS 2.0, released two
                              years later, supported a 10MB hard drive and 360KB floppy disks.9 Subsequent

<!-- pág. 1087 -->

                                                                                                   21.2 History 1037
Microsoft operating systems continued the trend of increasing disk space and sup-
porting an ever-growing number of peripheral devices.
      Microsoft released Windows 1.0, its graphical-user-interface (GUI)-based
operating system, in 1985. The GUI foundation had been developed by Xerox in
the 1970s and popularized by Apple's Macintosh computers. The Windows GUI



               Biographical Note
  Bill Gates
  William H. Gates III was born in        Symbolic Instruction Code) for the        nies, began to take over the
  Seattle, Washington, in 1955.10         Altair. 18, 19 In fact they had no        field. 2 6 In 1980, Gates hired his
  His first experience w i t h comput-    such thing, but Altair was inter-         Harvard classmate, Steve Ballmer,
  ers was in high school. 11 ' 12 He      ested; Gates took a leave of              to help w i t h the business side of
  befriended Paul Allen, a fellow         absence from Harvard (he never            the growing company (Ballmer is
  computer enthusiast, and w i t h        returned) and he and Allen                the current CEO of Microsoft.) 27, 28
  t w o other students formed the         ported BASIC to the Altair in just        Only t w o years later, Microsoft
  Lakeside Programming Group.             over one month, based only on             developed MS-DOS based on
  The group obtained computer             Intel's manual for the 8080. 20, 21, 22   Seattle Computing Product's 86-
  time from nearby companies by           Early personal computers did not          DOS; it was offered as the cheap-
  arranging deals to find bugs in         have operating systems, so all that       est operating system option for
  the companies' systems. They also       was needed was a language inter-          IBM's new line of personal com-
  earned money by forming a small         preter built for the specific system      puters and was a great success. In
  and short-lived company named           to run programs. Gates' and               1984 they broke into the office
  Traf-O-Data, writing software to        Allen's implementation of BASIC           applications market w i t h Word
  process traffic f l o w data. 13, 14    was, in effect, the first operating       and Excel for the Apple Macin-
        Gates went on to Harvard          system for the Altair. It was also        tosh. The following year they
  University, but in 1974 Intel           the beginning of Microsoft. 23, 2 4       released Windows 1.0, one of the
  announced the 8080 chip, and                   Over the next several years,       first GUI operating systems for
  Gates and Paul Allen realized t h a t   Microsoft continued to develop            IBM-compatibles. 29 Microsoft's
  the future of computing was             their BASIC language and licensed         commercial success has continued
  microprocessing. 15, 16, 17 When the    it to other new microcomputer             to mount w i t h progressive ver-
  MITS Altair 8800 was announced          companies including Apple and             sions of Windows and their
  only months later—the world's           Commodore. 25 Microsoft also              Microsoft Office software. Gates is
  first microcomputer—Gates and           implemented other languages for           currently the Chairman and Chief
  Allen quickly contacted MITS to         microcomputers and, because               Software Architect of Microsoft. 30
  say they had a implementation of        they had a jump-start on other            He is also the richest person in the
  BASIC (Beginner's All-purpose           microcomputer software compa-             world. 3 1

<!-- pág. 1088 -->

1038 Case Study: Windows XP

                              improved with each version. The window frames in Windows 1.0 could not overlap;
                              Microsoft fixed this problem in Windows 2.0. The most important feature in Win-
                              dows 2.0 was its support for protected mode for DOS programs. Although pro-
                              tected mode was slower than real mode, it prevented a program from overwriting
                              the memory space of another program, including the operating system, which
                              improved system stability. Even in protected mode, however, programs addressed
                              memory directly. In 1990, Microsoft released Windows 3.0, quickly followed by
                              Windows 3.1. This version of the operating system completely eliminated the unsafe
                              real mode. Windows 3.1 introduced an enhanced mode, which allowed Windows
                              applications to use more memory than DOS programs. Microsoft also released
                              Windows for Workgroups 3.1, an upgrade to Windows 3.1 that included network
                              support, especially for local area networks (LANs), which, at the time, were starting
                              to become popular. Microsoft attempted to increase system stability in Windows by
                              tightening parameter checking during API system calls; these changes broke many
                              older programs that exploited "hidden" features in the API. 32, 33
                                    Emboldened by the success of its home-user-oriented operating systems.
                              Microsoft ventured into the business market. Microsoft hired Dave Cutler, an expe-
                              rienced operating systems designer who helped develop Digital Equipment Corpo-
                              ration's VMS operating system, to create an operating system specifically for the
                              business environment (see the Biographical Note, David Cutler). Developing the
                              new operating system took five years, but in 1993, Microsoft released Windows NT
                              3.1, a New Technology operating system. In so doing, Microsoft created its corpo-
                              rate line of operating systems, which was built from a separate code base than its
                              consumer line. The two lines were not to merge until the release of Windows XP in
                              2001, although operating systems from one line used features and ideas from the
                              other. For example, Windows NT 3.1 and Windows 95 included different implemen-
                              tations of the same API. In addition, the business and consumer GUI interfaces
                              were always similar, although the business version tended to lag behind. 34
                                    Because Windows NT 3.1 was developed for business users, its chief focus was
                              security and stability. Windows NT introduced the New Technology File System
                              (NTFS), which is more secure and more efficient than the then-popular Windows
                              3.1 FAT and IBM OS/2 HPFS file systems (see the Mini Case Study, OS/2). In addi-
                              tion, the 32-bit operating system protects its memory from direct access by user
                              applications. The NT kernel runs in its own protected memory space. This extra
                              layer of security came at a price; many existing graphics-intensive games could not
                              run on Windows NT because they need to access memory directly to optimize per-
                              formance. Windows NT 3.1 also lacks much of the multimedia support that made
                              Windows 3.1 popular with home users.35
                                    Microsoft released Windows NT 4.0 in 1996. The upgraded operating system
                              provides additional security and networking support and includes the popular Win-
                              dows 95 user-interface.36 Windows 2000 (whose kernel is NT 5.0), released in 2000.
                              introduced the Active Directory. This database of users, computers and devices
                              makes it easy for users to find information about resources spread across a network.

<!-- pág. 1089 -->

                                                                                                21.2 History 1039
In addition, system administrators can configure user accounts and computer set-
tings remotely. Windows 2000 supports secure Kerberos single sign-on authentica-
tion and authorization (see Section 19.3.3, Kerberos). In general, Windows 2000 is
more secure and has better networking support than previous Windows operating
systems. It is Microsoft's last purely business-oriented desktop operating system.37
      Microsoft continued developing consumer operating systems. It released Win-
dows 95 in 1995 to replace Windows 3.1 for home users. Like Windows NT 3.1, Win-
dows 95 makes the jump to 32-bit addressing, although it supports 16-bit
applications for backward compatibility. Windows 95 permits applications to access



               Biographical Note
  David Cutler
  David Cutler graduated from             DEC began work on the VAX 32-          new team. Meanwhile, Microsoft
  Olivet College in Michigan in           bit architecture, because increas-     released Windows 3.0, and its
  196538 w i t h a degree in Mathe-       ing application sizes made the         popularity led to a change in
  matics. 39 He first became inter-       memory space accessible by a 16-       plans for Cutler's project. His
  ested in computers when he              bit address insufficient. 45           operating system would now be
  worked on a software simulation               Cutler managed what was          Windows NT and would primarily
  project at DuPont. 40, 41 Cutler        probably DEC'S most important          support the Win32 interface.
  moved to its engineering depart-        OS project ever—VMS for the            However, it needed to support
  ment, where he was involved in          VAX systems.46, 47 Because the         parts of the DOS, POSIX and OS/2
  various programming projects,           PDP-11 was so widely used, VMS         APIs in addition to running Win-
  became interested in operating          needed to be backward compati-         dows 3.0 programs. 53 Inspired by
  systems and worked on the devel-        ble w i t h the PDP-11 system and it   the Mach microkernel operating
  opment of several small, real-time      had to be scalable to VAX systems      system. Cutler's team designed
  operating systems.42                    of varying power. 48, 49 Cutler also   Windows NT to have a fairly small
        In 1971 Cutler moved to Dig-      led the MicroVAX project, DEC's        kernel w i t h layers of separate
  ital Equipment Corporation              microprocessor version of the          modules to handle the various
  (DEC),43, 44 where he led the team      VAX. 50                                interfaces. Windows NT, origi-
  developing the RSX-11M operat-                In 1988, Cutler accepted an      nally intended for Microsoft's pro-
  ing system. This operating system       offer from Bill Gates to be one of     fessional line of operating
  was difficult to design for t w o       the leaders on Microsoft's succes-     systems, eventually was used for
  reasons—there were severe mem-          sor to OS/2—OS/2 New Technol-          the consumer line in version 5.1,
  ory limitations due to the PDP-11 's    ogy, or OS/2 NT, which would use       more popularly known as Win-
  16-bit addressing, and it had to be     the OS/2 API.51, 52 cutler insisted    dows XP. Cutler remains a lead
  compatible w i t h all of the popular   on bringing 20 of his developers       operating systems architect at
  PDP-11 models. A few years later.       from DEC to form the core of this      Microsoft.

<!-- pág. 1090 -->

1040 Case Study: Windows XP

                               main memory directly. However, Microsoft introduced DirectX, which simulates
                               direct hardware access while providing a layer of protection. Microsoft hoped that
                               DirectX, combined with faster hardware, would give game developers a viable
                               alternative to accessing the hardware directly. Windows 95 introduced multithread-
                               ing, an improvement on the multitasking support provided by Windows 3.1.
                               Microsoft released Windows 98 in 1998, although most of the changes were minor
                               (primarily increased multimedia and networking support). The biggest innovation
                               was combining Internet Explorer (IE) with the operating system. Bundling IE
                               made Windows easier to use when accessing the Internet and the Web. Windows
                               Millennium Edition (Windows Me), released in 2000, is the last version in the con-
                               sumer line. Windows Me has even more device drivers and multimedia and net-
                               working support than previous versions of Windows. It is also the first consumer
                               version of Windows that cannot boot in DOS mode. 54




                Mini Case Study
   OS/2
   OS/2 was first released in 1987.           OS/2 1.1, released in 1988,         ten for OS/2 2 at the time. As a
   The operating system was a joint     was its first version w i t h a graphi-   result, many developers wrote pro-
   project between Microsoft and        cal user interface. The interface         grams specifically for Windows,
   IBM designed to run on IBM's new     was similar to early versions of          since they would work on both
   PS/2 line of personal computers.55   Windows. However, unlike Win-             platforms. 58
   OS/2 was based on DOS, the most      dows and many of today's inter-                IBM and Microsoft disagreed
   popular operating system at the      faces, the coordinate (0,0)               on the progress and direction of
   time of OS/2's release, and was      referred to the lower-left corner         OS/2 because Microsoft wanted to
   similar to DOS in many ways (e.g.,   of the screen as opposed to the           devote more resources to Win-
   they had similar commands and        upper-left comer. 57 This made            dows than to OS/2, whereas IBM
   command prompts). OS/2 also          transferring programs from OS/2           wished to further develop OS/2 1.
   made significant improvements        to other operating systems diffi-         In 1990, IBM and Microsoft
   over DOS. OS/2 was the first PC      cult.                                     agreed to work independently On
   operating system to allow multi-           OS/2 version 2.0, released in       upcoming OS/2 projects: IBM took
   tasking (however, only one appli-    1992, was the first 32-bit operating      control of all future versions of
   cation could be on the screen at a   system for personal computers. OS/        OS/2 1 and OS/2 2, while Microsoft
   time). OS/2 also supported multi-    2 2 contained the Integrating Plat-       developed OS/2 3. Soon after this
   threading, interprocess communi-     form, designed to run OS/2 2, OS/2        agreement, Microsoft renamed
   cation (IPC), dynamic linking and    1, DOS and Windows applications.          OS/2 3 to Windows NT.59
   many other features that were        This benefitted OS/2, because
   not supported by DOS.56              there were few applications writ-

<!-- pág. 1091 -->

                                                                                         21.3 Design Goals 1041

       Microsoft released Windows XP in 2001 (whose kernel is NT 5.1). Windows
XP unified the consumer and commercial code bases. Windows XP comes in several
editions, each of which is built from the same code base but is tailored to fit the
needs of a specific group of users. Every edition of Windows XP combines the sta-
bility, security and network support of the corporate line with the multimedia and
device support of the consumer line.



21.3 Design Goals
Microsoft's main design goal for Windows XP was reintegrating the code bases
from its consumer and business operating system lines. In addition, Microsoft
attempted to better meet the traditional goals of each individual line. For example,
the corporate line has often focused on providing security and stability, whereas the
consumer line provides enhanced multimedia support for games.
       When Microsoft created the NT line for business users, its chief focuses were
stability, security and scalability.60 Businesses often employ computers to execute
critical applications and store essential information. It is important for the system
to be reliable and run continuously without error. The internal architecture
described in this case study was developed over many years to enhance the stability
of Microsoft operating systems.
       Corporate computers need to protect sensitive data while being connected to
multiple networks and the Internet. For this reason, Microsoft devoted a great deal
of effort to developing an all-encompassing security system. Windows XP uses
modern security technologies such as Kerberos, access control lists and packet fil-
tering firewalls to protect the system. The Windows XP security system is built on
the codebase of Windows 2000, to which the government gave C2 level certification
(the C2 certification applies only to Windows 2000 machines unconnected to a net-
work). 61 At the time of this writing, Microsoft is in the process of gaining the same
certification for Windows XP Professional.
       Computers must be scalable to meet the needs of different users. Microsoft
developed Windows XP 64-Bit Edition to support high-performance desktop com-
puters and Windows XP Embedded to support devices such as routers. Windows
XP Professional supports symmetric multiprocessing (see Chapter 15, Multiproces-
sor Management).
      Windows XP incorporates many of the features that made the consumer line
popular. The system contains an improved GUI and more multimedia support than
previous versions of Windows. For the first time, both business and home users can
take advantage of these innovations.
       Besides incorporating the strengths of its two lines of operating systems,
Microsoft added another goal specifically for Windows XP. Customers had often com-
plained that Windows started too slowly. As a result, Microsoft aimed at dramatically
decreasing boot time. Windows XP must be usable in 30 seconds after a user turns on
the power, 20 seconds after waking from hibernation (on a laptop) and 5 seconds

<!-- pág. 1092 -->

1042 Case Study: Windows XP

                              after resuming from standby. Later in the chapter, we describe how Windows XP
                              meets these goals by prefetching files necessary to load the operating system.62


                              21.4 System Architecture
                              Windows XP is modeled on a microkernel architecture —often called a modified
                              microkernel architecture. On the one hand, Windows XP is a modular operating
                              system with a compact kernel that provides base services for other operating system
                              components. However, unlike a pure microkernel operating system, these compo-
                              nents (e.g., the file system and memory manager) execute in kernel mode rather
                              than user mode. Windows XP is also a layered operating system, composed of dis-
                              crete layers with lower layers providing functionality for higher layers.63 However,
                              unlike a pure layered operating system, there are times when non-adjacent layers
                              communicate. For a description of microkernel and layered operating system
                              designs, see Section 1.13, Operating System Architectures.
                                    Figure 21.1 illustrates Windows XP's system architecture. The Hardware
                              Abstraction Layer (HAL) interacts directly with the hardware, abstracting hard-
                              ware specifics to the rest of the system. The HAL handles device components on
                              the mainboard such as the cache and system timers. The HAL abstracts hardware
                              specifics that might differ between systems of the same architecture, such as the
                              exact layout of the mainboard. In many cases, kernel-mode components do not
                              access the hardware directly, but instead call functions exposed by the HAL. There-
                              fore, kernel-mode components can be constructed with little regard for architec-
                              ture-specific details such as cache sizes and the number of processors included. The
                              HAL interacts with device drivers to support access to peripheral devices.64
                                    The HAL also interacts with the microkernel. The microkernel provides basic
                              system mechanisms, such as thread scheduling, to support other kernel-mode compo-
                              nents. [Note: The Windows XP microkernel should not be confused with the micro-
                              kernel design philosophy discussed in Section 1.13, Operating System Architectures.]
                              The microkernel also handles thread synchronization, dispatches interrupts and han-
                              dles exceptions.65 Additionally, the microkernel abstracts architecture-specific fea-
                              tures—features that differ between two different architectures, such as the number of
                              interrupts. The microkernel and the HAL combine to make Windows XP portable,
                              allowing it to run in many different hardware environments.66
                                    The microkernel forms only a small part of kernel space. Kernel space
                              describes an execution environment in which components can access all system
                              memory and services. Components that reside in kernel space execute in kernel
                              mode. The microkernel provides the base services for the other components resid-
                              ing in kernel space.67
                                    Layered on top of the microkernel are the kernel-mode components responsi-
                              ble for administering the operating system subsystems (e.g., the I/O manager and
                              virtual memory manager). Collectively, these components are known as the execu-
                              tive. Figure 21.1 displays the key executive components. The rest of this chapter is
                              devoted to describing these subsystems and the executive components which man-

<!-- pág. 1093 -->

                                                                                 21.4 System Architecture 1043




Figure 21.1 | Windows XP system architecture.


age the subsystems. The executive exposes services through an application pro-
gramming interface (API) to user processes.68 This API is called the native API.
      However, most user processes do not call native API functions directly;
rather, they call API functions exposed by user-mode system components called
environment subsystems. Environment subsystems are user-mode processes inter-
posed between the executive and the rest of user space that export an API for a spe-
cific computing environment. For example, the Win32 environment subsystem
provides a typical 32-bit Windows environment. Win32 processes call functions
defined in the Windows API; the Win32 subsystem translates these function calls to
system calls in the native API (although, in some cases, the Win32 subsystem pro-
cess itself can fulfill an API request without calling the native API). 69 Although
Windows XP allows user-mode processes to call native API functions, Microsoft
urges developers to use an environment subsystem's interface.70
      By default, 32-bit Windows XP includes only the Win32 subsystem, but users
can install a POSIX subsystem. Microsoft replaced the POSIX subsystem in older
versions of Windows with a more robust UNIX environment, called Service For
UNIX (SFU) 3.0. Running SFU 3.0, users can port code written for a UNIX envi-
ronment to Windows XP. To run 16-bit DOS applications, Windows XP provides a
Virtual DOS Machine (VDM), which is a Win32 process that provides a DOS envi-
ronment for DOS applications.71

<!-- pág. 1094 -->

1044 Case Study: Windows XP

                                    On Windows XP 64-Bit Edition, the default subsystem supports 64-bit appli-
                              cations. However, Windows XP 64-Bit Edition provides a subsystem called the Win-
                              dows on Windows 64 (WOW64) subsystem, which allows users to execute 32-bit
                              Windows applications. Windows XP 64-Bit Edition does not support 16-bit applica-
                              tions.72
                                    The top layer of the Windows XP architecture consists of user-mode pro-
                              cesses. These are typical applications (e.g., word processors, computer games and
                              Web browsers) as well as dynamic link libraries (DLLs). DLLs are modules that
                              provide data and functions to processes. As shown in Fig. 21.1, the environment
                              subsystems' APIs are simply DLLs that processes dynamically link when calling a
                              function in a subsystem's API. Because DLLs are dynamically linked, applications
                              can be more modular. If the implementation of a DLL function changes, only the
                              DLL must be recompiled and not the applications that use it.73
                                    Windows XP also includes special user-mode processes called system services
                              (or Win32 services), which are similar to Linux daemons (see Section 20.3, Linux
                              Overview). These processes usually execute in the background whether or not a user
                              is logged onto the computer and typically execute the server side of client/server
                              applications.74 Examples of system services are the Task Scheduler (which allows
                              users to schedule tasks to be executed at specific times), IPSec (which manages Inter-
                              net security usually during data transfer operations) and Computer Browser (which
                              maintains a list of computers connected on the local network). 75 [Note: Sometimes,
                              authors also use the term "system services" to refer to native API functions.]



                              21.5 System Management Mechanisms
                              Before we investigate each component in the Windows XP operating system, it is
                              important to understand the environment in which these components execute. This
                              section describes how components and user processes store and access configura-
                              tion data in the system. We also consider how Windows XP implements objects,
                              how these objects are managed and how user- and kernel-mode threads can manip-
                              ulate these objects. Finally, we describe how Windows XP prioritizes interrupts and
                              how the system employs software interrupts to dispatch processing.

                              21.5.1 Registry
                              The registry is a database, accessible to all processes and kernel-mode components
                              that stores configuration information76 specific to users, applications and hardware.
                              For example, user information might include desktop settings and printer settings.
                              Application configuration includes such settings as recently used menus, user pref-
                              erences and application defaults. Hardware information includes which devices are
                              currently connected to the computer, which drivers serve each device and which
                              resources (e.g., hardware ports) are assigned to each device. The registry also stores
                              system information such as file associations (e.g., .doc files are associated with

<!-- pág. 1095 -->

                                                                     21.5 System Management Mechanisms 1045

Microsoft Word). Applications, device drivers and the Windows XP system use the
registry to store and access data in a centralized manner. For example, when a user
installs a hardware device, device drivers place configuration information into the
registry. When Windows XP allocates resources to various devices, it accesses the
registry to determine what devices are installed in the system and distributes
resources accordingly.77
      Windows XP organizes the registry as a tree, and each node in the tree repre-
sents a registry key. A key stores subkeys and values; values consist of a value name
and value data. 78 The system provides several predefined keys. For example,
HKEY_LOCAL_MACHINE is a predefined key which forms the root of all configuration
data for the local computer. Values in the HKEY_LOCAL_MACHINE key or its subkeys
store such information as the hardware devices connected to the computer, system
memory and network information (e.g., server names). Predefined keys act as roots
for a single type of data, such as application-specific data or user preferences. 79
      Threads can access subkeys by navigating the tree structure. Beginning with
any key that is open, a thread can enumerate that key's subkeys and open any of
them. The system's predefined keys remain open at all times. Once a key is open,
values and subkeys can be read, modified, added or deleted (assuming the thread
has access rights for the key to accomplish all these actions). 80, 81
      Windows XP stores the registry in a collection of hives, which are portions of
the registry tree. Most hives are stored as files and flushed to disk periodically to
protect the data against crashes, whereas other hives remain solely in memory (e.g.,
HKEY_LOCAL_MACHINE\HARDWARE, which stores hardware information that the sys-
tem collects at boot time and updates as it runs). 82 The configuration manager is the
executive component responsible for managing the registry. Device drivers, system
components and user applications communicate with the configuration manager to
modify or obtain data from the registry. The configuration manager is also responsi-
ble for managing registry storage in system memory and in the hives.83

21.5.2 Object Manager
Windows XP represents physical resources (e.g., peripheral devices) and logical
resources (e.g., processes and threads) with objects. Note that these objects do not
refer to objects in any object-oriented programming language, but rather constructs
that Windows XP uses to represent resources. Windows XP represents objects with
a data structure in memory; this data structure stores the object's attributes and
procedures. 84 Each object in Windows XP is defined by an object type; the object
type is also stored as a data structure. Object types are created by executive compo-
nents; for example, the I/O manager creates the file object type. The object type
specifies the types of attributes an instance of this type possesses and the object's
standard procedures. Examples of standard procedures include the open procedure,
c l o s e procedure and d e l e t e procedure. 85 Object types in Windows XP include
files, devices, processes, threads, pipes, semaphores and many others. Each Windows
XP object is an instance of an object type.86

<!-- pág. 1096 -->

1046 Case Study: Windows XP

                                    User-mode processes and kernel components can access objects through
                              object handles. An object handle is a data structure that allows processes to manip-
                              ulate the object. Using an object handle, a thread can call one of the object's proce-
                              dures or manipulate the object's attributes. A kernel-mode component or user-
                              mode process with sufficient access rights can obtain a handle to an object by speci-
                              fying the object's name in a call to the object's open method or by receiving a han-
                              dle from another process.87 Once a process obtains a handle to an object, this
                              process can duplicate the handle; this can be used by a process that wishes to pass a
                              handle to another process and also retain a handle to the object.88 Processes can use
                              a handle in similar way as pointers, but a handle gives the system extra control over
                              the actions of a user process (e.g., by restricting what the process can do with the
                              handle, such as not allowing the process to duplicate it).
                                    Kernel-mode components can use handles when interacting with user-mode
                              processes, but otherwise can access objects directly through pointers. In addition,
                              kernel-mode components can create kernel handles, which are handles accessible
                              from any process's address space, but only from kernel mode. In this way, a device
                              driver can create a kernel handle to an object and be guaranteed access to that
                              object, regardless of the context in which the driver executes.89 Objects can be
                              named or unnamed, although only kernel-mode components can open a handle to
                              an unnamed object. A user-mode thread can obtain a handle to an unnamed object
                              only by receiving it from a kernel-mode component. 90
                                    The object manager is the executive component that manages objects for a
                              Windows XP system. The object manager is responsible for creating and deleting
                              objects and maintaining information about each object type, such as how many
                              objects of a certain type exist.91 The object manager organizes all named objects
                              into a hierarchal directory structure. For example, all device objects are stored in
                              the \Device directory or one of its subdirectories. This directory structure com-
                              poses the object manager namespace (i.e., group of object names in which each
                              name is unique in the group). 92
                                    To create an object, a process passes a request to the object manager; the
                              object manager initializes the object and returns a handle (or pointer if a kernel-
                              mode component called the appropriate function) to it. If the object is named, the
                              object manager enters it into the object manager namespace. 93 For each object, the
                              object manager maintains a count of how many existing handles refer to it and a
                              count of how many existing references (both handles and pointers) refer to it. When
                              the number of handles reaches zero, the object manager removes the object from
                              the object manager namespace. When the number of references to the object
                              reaches zero, the object manager deletes the object.94

                              21.5.3 Interrupt Reqiest levels (IRQLs)
                              Interrupt definition and handling are crucial to Windows XP. Because some inter-
                              rupts, such as hardware failure interrupts, are more important than others, Win-
                              dows XP defines interrupt request levels (IRQLs). IRQLs are a measure of

<!-- pág. 1097 -->

                                                                      21.5 System Management Mechanisms 1047
interrupt priority; a processor always executes at some IRQL, and different proces-
sors in a multiprocessor system can be executing at different IRQLs. An interrupt
that executes at an IRQL higher than the current one can interrupt the current exe-
cution and obtain the processor. The system masks (i.e., delays processing) inter-
rupts that execute at an IRQL equal to or lower than the current one.95
      Windows XP defines several IRQLs (Fig. 21.2). User- and kernel-mode threads
normally execute at the passive IRQL, which is the lowest-priority IRQL. Unless
user-mode threads are executing asynchronous procedure calls (APCs), which we
describe in Section 21.5.4, Asynchronous Procedure Calls (APCs), these threads
always execute at the passive IRQL. In some instances, kernel-mode threads execute
at a higher IRQL to mask certain interrupts, but typically, the system executes
threads at the passive level so that incoming interrupts can be serviced promptly. Exe-
cuting at the passive IRQL implies that no interrupt is currently being processed and
no interrupts are masked. APCs, which are procedure calls that threads or the system
can queue for execution by a specific thread, execute at the APC IRQL. Above the
APC level is the DPC/dispatch IRQL at which deferred procedure calls (i.e., software
interrupts that can be executed in any thread's context) and various other important
kernel functions execute, including thread scheduling.96 We describe DPCs in
Section 21.5.5, Deferred Procedure Calls (DPCs). All software interrupts execute at
the APC level or DPC/dispatch level.97
       Hardware interrupts execute at the remaining higher IRQLs. Windows XP
provides multiple device IRQLs (DIRQLs) at which interrupts from devices exe-
cute.98 The number of DIRQLs varies, depending on how many interrupts a given
architecture supports, but the assignment of these levels to devices is arbitrary; it is
dependent on the specific interrupt request line at which a device interrupts. There-
fore, Windows XP maps device interrupts to DIRQLs without priority; still, if a pro-
cessor is executing at a certain DIRQL, interrupts that occur at DIRQLs less than
or equal to the current one are masked. 99
       The system reserves the highest five IRQLs for critical system interrupts. The
first level above DIRQL is the profile IRQL, which is used when kernel profiling is
enabled (see Section 14.5.1, Tracing and Profiling). The system clock, which issues
interrupts at periodic intervals, interrupts at the clock IRQL. Interprocessor
requests (i.e., interrupts sent by one processor to another such as when shutting
down the system) execute at the request IRQL. The power IRQL is reserved for
power failure notification interrupts, although this level has never been used in any
NT-based operating system. Interrupts issued at the high IRQL (which is the high-
est IRQL) include hardware failure interrupts and bus errors. 100
       For each processor, the HAL masks all interrupts with IRQLs less than or
equal to the IRQL at which that processor is currently executing. This allows the
system to prioritize interrupts and execute critical interrupts as quickly as possible.
For example, executing at the DPC/dispatch level masks all other DPC/dispatch
level interrupts and APC level interrupts. Interrupts that execute at an IRQL that is
currently masked are not discarded (i.e., removed from the system). When the

<!-- pág. 1098 -->

1048 Case Study: Windows XP




                          Figure 21.2 | Interrupt request levels (IRQLs)

                          IRQL drops low enough, the processor processes the waiting interrupts. Kernel-
                          mode threads can raise the IRQL, and a thread that does so is responsible for sub-
                          sequently lowering the IRQL to its previous level; user-mode threads cannot
                          change the IRQL. Windows XP attempts to do as much processing as possible at
                          the passive level, at which no interrupts are masked, so that all incoming interrupts
                          can be serviced immediately.101


                          21.5.4 Asynchronous Procedure Calls (APCs)
                          Asynchronous procedure calls (APCs) are procedure calls that threads or the system
                          can queue for execution by a specific thread; the system uses APCs to complete vari-

<!-- pág. 1099 -->

                                                                      21.5 System Management Mechanisms 1049

ous functions that must be done in a specific thread's context. For example, APCs
facilitate asynchronous I/O. After initiating an I/O request, a thread can perform
other work. When the I/O request completes, the system sends an APC to that
thread, which the thread executes to complete the I/O processing. Windows XP
uses APCs to accomplish a variety of system operations. For example, APCs are
used by the SFU to send signals to POSIX threads and by the executive to notify a
thread of an I/O completion or direct a thread to perform an operation. 102
       Each thread maintains two APC queues: one for kernel-mode APCs and one
for user-mode APCs.103 Kernel-mode APCs are software interrupts that are gener-
ated by kernel-mode components, and a thread must process all pending kernel-
mode APCs as soon as it obtains a processor. A user-mode thread can create a user-
mode APC and request to queue this APC to another thread; the system queues the
APC to the target thread if the queuing thread has sufficient access rights. A thread
executes user-mode APCs when the thread enters an alertable wait state.104 In an
alertable wait state, a thread awakens either when it has a pending APC or when
the object or objects on which the thread is waiting become available. A thread can
specify that it enters an alertable wait state when it waits on an object, or a thread
can simply enter an alertable wait state without waiting on any object.105
        Windows XP also differentiates between normal kernel APCs and special
kernel APCs. A thread executes kernel APCs in FIFO order, except that the thread
executes all special kernel APCs before all normal kernel APCs. 106 When the sys-
tem queues a kernel APC, the target thread does not execute the APC until the
thread gains the processor. However, once the thread begins executing at the pas-
sive level, it begins executing kernel APCs until it drains (i.e., empties) its queue.
       Unlike kernel APCs, threads can choose when to execute user-mode APCs. A
thread drains its user-mode APC queue when the thread enters an alertable wait
state. If the thread never enters such a state, its pending user-mode APCs are dis-
carded when it terminates. 107
       A thread executing an APC is not restricted, except that it cannot receive new
APCs. It can be preempted by another higher-priority thread. Because scheduling is
not masked at the APC level (this occurs at the DPC/dispatch level), a thread exe-
cuting an APC can block or access pageable data (which might cause a page fault
and hence cause Windows XP to execute scheduling code at the DPC/dispatch
IRQL). APCs can also cause the currently executing thread to be preempted. If a
thread queues an APC to a thread of higher priority that is in an alertable wait state,
the waiting thread awakens, preempts the queuing thread and executes the APC. 108

21.5.5 Defered Procedure Calls (DPCs)
Most of Windows XP's hardware interrupt processing occurs in deferred procedure
calls (DPCs). DPCs are software interrupts that execute at the DPC/dispatch
IRQL109 and which run in the context of the currently executing thread. In other
words, the routine that creates the DPC does not know the context in which the DPC
will execute. Therefore, DPCs are meant for system processing, such as interrupt pro-

<!-- pág. 1100 -->

1050   Case Study: Windows XP

                                cessing, that does not need a specific thread context in which to execute.110 These pro-
                                cedure calls are called "deferred" because Windows XP processes most hardware
                                interrupts by calling the associated interrupt service routine, which is responsible for
                                quickly acknowledging the interrupt and queuing a DPC for later execution. This
                                strategy increases the system's responsiveness to incoming device interrupts.
                                       Windows XP attempts to minimize the time it spends at DIRQLs to maintain
                                high responsiveness to all device interrupts. Recall that the system maps device
                                interrupts arbitrarily to DIRQLs. Still, device interrupts mapped to a high DIRQL
                                can interrupt the processing of a device interrupt mapped to a lower DIRQL. By
                                using DPCs, the system returns to an IRQL below all DIRQLs and therefore can
                                minimize this difference in the level of interrupt servicing.111
                                       Device interrupt handlers can schedule DPCs, and Windows XP executes
                                some kernel functions, such as thread scheduling, at the DPC/dispatch IRQL. 112
                                When an event that prompts scheduling occurs—such as when a thread enters the
                                ready state, when a thread enters the wait state, when a thread's quantum expires or
                                when a thread's priority changes—the system executes scheduling code at the DPC/
                                dispatch IRQL. 113
                                       As we noted above, DPCs are restricted because the routine that creates a
                                DPC does not specify the context in which the DPC executes (this context is simply
                                the currently executing thread). DPCs are further restricted because they mask
                                thread scheduling. Therefore, a DPC cannot cause the thread within whose context
                                it is executing to block, because this would cause the system to attempt to execute
                                scheduling code. In this case no thread would execute because the executing thread
                                blocks, but the scheduler does not schedule a new thread because scheduling is
                                masked (in reality, Windows XP halts the system and displays an error message).114
                                As a result, DPCs cannot access pageable data because if a page fault occurs, the
                                executing thread blocks to wait for the completion of the data access. DPCs, how-
                                ever, can be preempted by hardware interrupts. 115, 116
                                       When a device driver generates a DPC, the system places the DPC in a queue
                                associated with a specific processor. The driver routine can request a processor to
                                which the DPC should be queued (e.g., to ensure that the DPC routine is executed
                                on the processor with relevant cached data); if no processor is specified, the proces-
                                sor queues the DPC to itself.117 The routine can also specify the D P C s priority.
                                Low- and medium-priority DPCs are placed at the end of the processor's DPC
                                queue; high-priority DPCs enter at the front of the queue. In most cases, when the
                                IRQL drops to the DPC/dispatch level, the processor drains the DPC queue. How-
                                ever, when a low-priority DPC has been waiting for only a short time and the DPC
                                queue is short, the processor does not immediately execute the DPC. The next time
                                the processor drains the DPC queue, it processes this DPC. This policy allows the
                                system to return to the passive level faster to unmask all interrupts and resume nor-
                                mal thread processing.118

<!-- pág. 1101 -->

                                                                         21.6 Process and Thread Management 1051

21.5.6 System Threads
When a kernel-mode component, such as a device driver or executive component,
performs some processing on behalf of a user thread, the component's functions
often execute in the context of the requesting thread. However, in some cases, ker-
nel-mode components must accomplish a task that is not in response to a particular
thread request. For example, the cache manager must periodically flush dirty cache
pages to disk. Also, a device driver servicing an interrupt might not be able to
accomplish all necessary processing at an elevated IRQL (i.e., the device's DIRQL
when it interrupts or the DPC/dispatch level when executing a DPC). For example,
the driver might need to accomplish some work at the passive IRQL, because it
must access pageable data.119
      Developers of kernel-mode components have two options to perform this pro-
cessing. A component can create a kernel thread, which is a thread that executes in
kernel mode and typically belongs to the System process—a kernel-mode process to
which most kernel-mode threads belong. Aside from executing in kernel mode, ker-
nel threads behave and are scheduled the same as user threads.120 Kernel threads nor-
mally execute at the passive IRQL, but can raise and lower the IRQL.121
      A second option is to use a system worker thread—a thread, which is created
at system initialization time or dynamically in response to a high volume of
requests, that sleeps until a work item is received. A work item consists of a func-
tion to execute and a parameter describing the context in which to execute that
function. System worker threads also belong to the System process. Windows XP
includes three types of worker threads: delayed, critical and hypercritical. The dis-
tinction arises from the scheduling priority given to each type. Delayed threads
have the lowest priority of the three types; critical threads have a relatively high pri-
ority; and the hypercritical thread (there is only one), which is reserved for system
use (e.g., device drivers cannot queue work items to this thread), has the highest
priority of the three types.122, 123


21.6 Process and Thread Management
In Windows XP, a process consists of program code, an execution context, resources
(e.g., object handles) and one or more associated threads. The execution context
includes such items as the process's virtual address space and various attributes
(e.g., security attributes and working set size limitations). Threads are the actual
unit of execution; threads execute a piece of a process's code in the process's con-
text, using the process's resources. A thread also contains its own execution context
which includes its runtime stack, the state of the machine registers and several
attributes (e.g., scheduling priority). 124 Both processes and threads are objects, so
other processes can obtain handles for processes and threads, and other threads can
wait on process and thread events just as with other object types.125, 126

<!-- pág. 1102 -->

1052 Case Study: Windows XP

                          21.6.1 Process and Thread Organization
                          Windows XP stores process and thread context information in several data struc-
                          tures. An executive process block (EPROCESS block) is the main data structure that
                          describes a process. The EPROCESS block stores information that executive compo-
                          nents use when manipulating a process object; this information includes the pro-
                          cess's ID, a pointer to the process's handle table, a pointer to the process's access
                          token and working set information (e.g., the process's minimum and maximum
                          working set size, page fault history and the current working set). The system stores
                          EPROCESS blocks in a linked list.127.128
                                Each EPROCESS block also contains a kernel process block (KPROCESS block).
                          A KPROCESS block stores process information used by the microkernel. Recall that
                          the microkernel manages thread scheduling and thread synchronization. Therefore,
                          the KPROCESS block stores such information as the process's base priority class, the
                          default quantum for each of its threads and its spin lock.129, 130
                                The EPROCESS and KPROCESS blocks exist in kernel space and store informa-
                          tion for kernel-mode components to access while manipulating a process. The sys-
                          tem also stores process information in a process environment block (PEB), which is
                          stored in the process's address space. A process's EPROCESS block points to the pro-
                          cess's PEB. The PEB stores information useful for user processes, such as a list of
                          DLLs linked to the process and information about the process's heap.131-132
                                Windows XP stores thread data in a similar manner. An executive thread
                          block (ETHREAD block) is the main data structure describing a thread. It stores
                          information that executive components use when manipulating a thread object.
                          This information includes the ID of the thread's process, its start address, its access
                          token and a list of its pending I/O requests. The ETHREAD block for a thread also
                          points to the EPROCESS block of its process. 133 ' 134
                                Each ETHREAD block stores a kernel thread block (KTHREAD block). The micro-
                          kernel uses information in the KTHREAD block for thread scheduling and synchroni-
                          zation. For example, the KTHREAD block stores information such as the thread's base
                          and current priority (later in this section we see how a thread's priority can change),
                          its current state (e.g., ready, waiting) and any synchronization objects for which it is
                          waiting.135, 136
                                The ETHREAD and KTHREAD blocks exist in kernel space and therefore are not
                          accessible to users. A thread environment block (TEB) stores information about a
                          thread in the thread's process's address space. Each KTHREAD block points to a TEB.
                          A thread's TEB stores information such as the critical sections owned by the
                          thread, its ID and information about its stack. A TEB also points to the PEB of the
                          thread's process. 137, 138
                                All threads belonging to the same process share a virtual address space.
                          Although most of this memory is global, threads can maintain their own data in
                          thread local storage (TLS). A thread within a process can allocate a TLS index for
                          the process; the thread stores a pointer to local data in a specified location (called a
                          TLS slot) in this index. Each thread using the index receives one TLS slot in the

<!-- pág. 1103 -->

                                                                          21.6 Process and Thred Management 1053

index in which it can store a data item. A common use for a TLS index is to store
data associated with a DLL that a process links. Processes often contain many TLS
indexes to accommodate multiple purposes, such as for DLL and environment sub-
system data. When threads no longer need a TLS index (e.g., the DLL completes
execution), the process can discard the index.139 A thread also possesses its own
runtime stack on which it can also store local data.

Creating and Terminating Processes
A process can create another process using API functions. For Windows processes,
the parent (i.e., creating) process and child (i.e., created) process are completely
independent. For example, the child process receives a completely new address
space.140 This differs from the fork command in Linux, in which the child receives a
copy of its parent's address space. The parent process can specify certain attributes
that the child process inherits (i.e., the child acquires a duplicate from the parent),
such as most types of handles, environment variables—i.e., variables that define an
aspect of the current settings, such as the operating system version number—and
the current directory.141 When the system initializes a process, the process creates a
primary thread. The primary thread acts as any other thread, and any thread can
create other threads belonging to that thread's process.142
       A process can terminate execution for a variety of reasons. If all of its threads
terminate, a process terminates, and any of a process's threads can explicitly termi-
nate the process at any time. Additionally, when a user logs off, all the processes
running in the user's context are terminated. Because parent and child processes
are independent of one another, terminating a parent process has no affect on its
children and vice versa.143

Jobs
Sometimes, it is preferable to group several processes together into a unit, called a
job. A job object allows developers to define rules and set limits on a number of
processes. For example, a single application might consist of a group of processes. A
developer might want to restrict the number of processor cycles and amount of
memory that the application consumes (e.g., so that an application executing on
behalf of a client does not monopolize all of a server's resources). Also, the devel-
oper might want to terminate all the processes of a group at once, which is difficult
because all processes are normally independent of one another. 144 A process can be
a member of at most one job object. The job object specifies such attributes as a
base priority class, a security context, a working set minimum and maximum size, a
virtual memory size limit and both a per-process and jobwide processor time limit.
Just as a thread inherits these attributes from the process to which it belongs, a pro-
cess inherits these attributes from its associated job (if the process belongs to a
job). 145, 146 The system can terminate all processes in a job by terminating the job. 147
       Systems executing batch processes, such as data mining, benefit from jobs.
Developers can limit the amount of processor time and memory a computationally
intensive job consumes to free more resources for interactive processes. Sometimes

<!-- pág. 1104 -->

1054 Case Study: Windows XP

                          it is useful to create a job for a single process, because a job allows the developer to
                          specify tighter restrictions than a process allows. For example, with a job object, a
                          developer can limit the process's total processor time; a developer cannot use the
                          process object to do this.148


                          Fibers
                          Threads can create fibers, which are similar to threads, except that a fiber is sched-
                          uled for execution by the thread that creates it, rather than the microkernel. Win-
                          dows XP includes fibers to permit the porting of code written for other operating
                          systems to Windows XP. Some operating systems, such as many UNIX varieties,
                          schedule processes and require them to schedule their own threads. Developers can
                          use fibers to port code to and from these operating systems. A fiber executes in the
                          context of the thread that creates the fiber.149
                                 Creating fibers generates additional units of execution within a single thread.
                          Each fiber must maintain state information, such as the next instruction to execute
                          and the values in a processor's registers. The thread stores this state information for
                          each fiber. The thread itself is also a unit of execution, and thus must convert itself
                          into a fiber to separate its own state information from other fibers executing in its
                          context. In fact, the Windows API forces a thread to convert itself into a fiber before
                          creating or scheduling other fibers. Although the thread becomes a fiber, the thread's
                          context remains, and all fibers associated with that thread execute in that context.150
                                 Whenever the kernel schedules a thread that has been converted to a fiber for
                          execution, the converted fiber or another fiber belonging to that thread runs. Once
                          a fiber obtains the processor, it executes until the thread in whose context the fiber
                          executes is preempted, or the fiber switches execution to another fiber (either
                          within the same thread or a fiber created by a separate thread). Just as threads pos-
                          sess their own thread local storage (TLS), fibers possess their own fiber local stor-
                          age (FLS), which functions for fibers exactly as TLS functions for a thread. A fiber
                          can also access its thread's TLS. If a fiber deletes itself (i.e., terminates), its thread
                          terminates. 151
                                 Fibers permit Windows XP applications to write code executed using the
                          many-to-many mapping; typical Windows XP threads are implemented with a one-
                          to-one mapping (see Section 4.6.2, Kernel-Level Threads). Fibers are user-level
                          units of execution and invisible to the kernel. This makes context switching between
                          fibers of the same thread fast because it is done in user mode. Therefore, a single-
                          threaded process with many fibers can simulate a multithreaded process. However,
                          the Windows XP microkernel only recognizes one thread, and because Windows
                          XP schedules threads, not processes, the single-threaded process receives less exe-
                          cution time (all else being equal). 152, 153

                          Thread Pools
                          Windows XP also provides each process with a thread pool that consists of a num-
                          ber of worker threads, which execute functions queued by user threads. The worker

<!-- pág. 1105 -->

                                                                         21.6 Process and Thread Management   1055

threads sleep until a request is queued to the pool. 154 The thread that queues the
request must specify the function to execute and must provide context informa-
tion.155 When a process is created, it receives an empty thread pool; the system allo-
cates space for worker threads when the process queues its first request. 156
      Thread pools have many purposes. Developers can use them to handle client
requests. Instead of incurring the costly overhead of creating and destroying a
thread for each request, the developer simply queues the request to the thread
pool. Also, several threads that spend most of their time sleeping (e.g., waiting for
events to occur) can be replaced by a single worker thread that awakens each time
one of these events occurs. Furthermore, applications can use the thread pool to
accomplish asynchronous I/O by queuing a worker thread to execute the I/O com-
pletion routines. Using thread pools can make an application more efficient and
simpler because developers do not have to create and delete as many threads. How-
ever, thread pools transfer some control from the programmer to the system, which
can introduce inefficiency. For example, the system grows and shrinks the size of a
process's thread pool in response to request volume; in some cases, the programmer
can better guess how many threads are needed. Thread pools also require memory
overhead, because the system grows a process's (initially empty) thread pool as the
process's threads queue work items.157


21.6.2 Thread Scheduling
Windows XP does not contain a specific "thread scheduler" module —the schedul-
ing code is dispersed throughout the microkernel. The scheduling code collectively
is referred to as the dispatcher.158 Windows XP supports preemptive scheduling
among multiple threads. The dispatcher schedules each thread without regard to
the process to which the thread belongs. This means that, all else being equal, the
same process implemented with more threads will get more execution time. 159 The
scheduling algorithm used by Windows XP is based on a thread's priority. Before
describing the scheduling algorithm in detail, we investigate the lifecycle of a Win-
dows XP thread.

Thread States
In Windows XP, threads can be in any one of eight states (Fig. 21.3). A thread begins
in the initialized state during thread creation. Once initialization concludes, the
thread enters the ready state. Threads in the ready state are waiting to use a proces-
sor. A thread that the dispatcher has decided will execute on a particular processor
next enters the standby state as it awaits its turn for that processor. A thread is in the
standby state, for example, during the context switch from the previously executing
thread to that thread. Once the thread obtains a processor, it enters the running
state. A thread transitions out of the running state if it terminates execution,
exhausts its quantum, is preempted, is suspended or waits on an object. If a thread
terminates, it enters the terminated state. The system does not necessarily delete a
terminated thread; the object manager deletes a thread only when the thread object's

<!-- pág. 1106 -->

1056 Case Study: Windows XP




                              Figure 21.3 | Thread state-transition diagram.

                              reference count becomes zero. If a running thread is preempted or exhausts its quan-
                              tum, it returns to the ready state. If a running thread begins to wait on an object han-
                              dle, it enters the waiting state. Also, another thread (with sufficient access rights) or
                              the system can suspend a thread, forcing it into the waiting state until the thread is
                              resumed. When the thread completes its wait, it either returns to the ready state or
                              enters the transition state. A thread in the transition state has had its kernel stack
                              paged out of memory (e.g., because it has not executed in a while and the system
                              needed the memory for other purposes), but the thread is otherwise ready to exe-
                              cute. The thread enters the ready state once the system pages the thread's kernel
                              stack back into memory. The system places a thread in the unknown state when the
                              system is unsure of the thread's state (usually because of an error).160, 161


                              Thread Scheduling Algorithm
                              The dispatcher schedules threads based on priority—the next subsection describes
                              how thread priorities are determined. When a thread enters the ready state, the ker-
                              nel places it into the ready queue that corresponds to its priority. Windows XP has
                              32 priority levels, denoted by integers from 0 through 31, where 31 is the highest
                              priority and 0 is the lowest. The dispatcher begins with the highest-priority ready
                              queue and schedules the threads in this queue in a round-robin fashion. A thread

<!-- pág. 1107 -->

                                                                        21.6 Process and Thread Management 1057
remains in a ready queue as long as the thread is in either the ready state or the run-
ning state. Once the queue empties, the dispatcher proceeds to the next queue; it
continues in this manner until either all queues are empty or a thread with a higher
priority than the currently executing thread enters its ready state. In the latter case,
the dispatcher preempts execution of the lower-priority thread and executes the
new thread. 162 The dispatcher then executes the first thread in the highest-priority
nonempty ready queue and resumes its normal scheduling procedure. 163
      Each thread executes for at most one quantum. In the case of preemption,
real-time threads have their quantum reset, whereas all other threads finish their
quantum when they reacquire a processor. Giving real-time threads fresh quanta
after preemption allows Windows XP to favor real-time threads, which require a
high level of responsiveness. The system returns preempted threads to the front of
the appropriate ready queue. 164 Note that user-mode threads can preempt kernel-
mode threads in many cases. However, kernel-mode threads can prevent this by
masking certain interrupts. Events such as a thread entering the ready state, a thread
exiting the running state or a change in a thread's priority trigger the system to exe-
cute dispatcher routines—routines that execute at DPC/dispatch level. By raising
the IRQL to the DPC/dispatch IRQL, kernel-mode threads can mask scheduling
and avoid being preempted. However, user-mode threads can still block the execu-
tion of system threads if they have a higher priority than the system threads.165


Determining Thread Priority
Windows XP divides its 32 priority levels (0-31) into two categories. Real-time
threads (i.e., threads that must maintain a high level of responsiveness to user
requests) occupy the upper 16 priority levels (16-31), and dynamic threads occupy
the lower 16 priority levels (0-15). Only the zero-page thread has priority level 0.
This thread uses spare processor cycles to zero free memory pages so they are ready
for use.
      Each thread has a base priority, which defines the lower limit that its actual
priority may occupy. A user-mode thread's base priority is determined by its pro-
cess's base priority class and the thread's priority level. A process's base priority
class specifies a narrow range that the base priority of each of a process's threads
can have. There are six base priority classes: idle, below normal, normal, above nor-
mal, high and real-time. The first five of these priority classes (called the dynamic
priority classes) encompass priority levels 0 through 15; these are called dynamic
priority classes, because threads belonging to processes in these classes can have
their priorities dynamically altered by the operating system. The threads belonging
to processes in the real-time priority class have a priority between 16 and 31; real-
time threads have a static priority. Within each priority class, there are several base
priority levels: idle, lowest, below normal, normal, above normal, highest and time
critical. Each combination of base priority class and base priority level maps to a
specific base priority (e.g., a thread with a normal base priority level and a normal
priority class has a base priority of 7). 166

<!-- pág. 1108 -->

1058 Case Study: Windows XP

                                     A dynamic-priority thread's priority can change. A thread receives a priority
                              boost when the thread exits the waiting state, such as after the completion of an I/O
                              or after the thread gains a handle to a resource for which the thread is waiting. Sim-
                              ilarly, a window that receives input (such as from the keyboard, mouse or timer)
                              gets a priority boost. The system also can reduce a thread's priority. When a thread
                              executes until its quantum expires, its priority is reduced one unit. However, a
                              thread's dynamic priority can never dip below its base priority or rise into the real-
                              time range. 167
                                     Finally, to reduce the likelihood of threads being indefinitely postponed, the
                              dispatcher periodically (every few seconds) scans the lists of ready threads and
                              boosts the priority of dynamic threads that have been waiting for a long time. This
                              scheme also helps solve the problem of priority inversion. Priority inversion occurs
                              when a high-priority thread is prevented from gaining the processor by a lower-pri-
                              ority thread. For example, a high-priority thread might wait for a resource held by a
                              low-priority thread. A third, medium-priority thread obtains the processor, pre-
                              venting the low-priority thread from running. In this way, the medium-priority
                              thread is also preventing the high-priority thread from executing—hence, priority
                              inversion. The dispatcher will eventually boost the priority of the low-priority
                              thread so it can execute and, hopefully, finish using the resource. 168



                              Scheduling on Multiprocessors
                              Multiprocessor thread scheduling extends the preceding uniprocessor scheduling
                              algorithm. All editions of Windows XP, except the Home Edition, provide support
                              for multiple processors. However, even Home Edition provides support for sym-
                              metric multiprocessing (SMP) using Intel's hyper-threading (HT) technology.
                              Recall from Section 15.2.1 that HT technology allows the operating system to view
                              one physical processor as two virtual processors. Scheduling in an SMP system is
                              similar to that in a uniprocessor system. Generally, when a processor becomes avail-
                              able, the dispatcher tries to schedule the thread at the front of the highest-priority
                              nonempty ready queue. However, the system also attempts to keep threads on the
                              same processors to maximize the amount of relevant data stored in L1 caches (see
                              Section 15.4, Memory Access Architectures).
                                     Processes and threads can specify the processors on which they prefer to exe-
                              cute. A process can specify an affinity mask, which is a set of processors on which its
                              threads are allowed to execute. A thread can also specify an affinity mask, which
                              must be a subset of its process's affinity mask.169 Similarly, a job also can have an
                              affinity mask, which each of its associated processes must set as its own affinity
                              mask. One use of affinity masks is restricting computationally intensive processes to
                              a few processors so these processes do not interfere with more time-critical interac-
                              tive processes.
                                     In addition to affinity masks, each thread stores its ideal processor and last
                              processor. Manipulating the value of a thread's ideal processor allows developers to
                              influence whether related threads should execute in parallel (by setting related

<!-- pág. 1109 -->

                                                                        21.6 Process and Thread Management 1059

threads' ideal processors to different processors) or on the same processor to share
cached data (by setting the threads' ideal processors to the same processor). By
default, Windows XP attempts to assign threads of the same process different ideal
processors. The dispatcher uses the last processor in an effort to schedule a thread
on the same processor on which the thread last executed. This strategy increases the
likelihood that data cached by the thread during an execution can be accessed dur-
ing the next execution of that thread. 170, 171
      When a processor becomes available, the dispatcher schedules threads by con-
sidering each thread's priority, ideal processor, last processor and how long a thread
has been waiting. Consequently, the thread at the front of the highest-priority non-
empty ready queue might not be scheduled to the next available processor (even if
the processor is in the thread's affinity mask). If this thread has not been waiting
long and the available processor is not its ideal or last processor, the dispatcher
might choose another thread from that ready queue which meets one or more of
these other criteria.172

21.6.3    Thread Synchronization
Windows XP provides a rich variety of synchronization objects and techniques,
designed for various purposes. For example, some synchronization objects execute
at the DPC/dispatch level. These objects provide certain guarantees —a thread
holding one of these objects will not be preempted—but restrict functionality (e.g.,
a thread holding one of these objects cannot access pageable data). Some synchro-
nization objects are designed specifically for kernel-mode threads, whereas others
are designed for all threads. In the following subsections, we introduce some syn-
chronization mechanisms provided in Windows XP, how they are used and their
benefits and drawbacks.

Dispatcher Objects
Windows XP provides a number of dispatcher objects that kernel- and user-mode
threads can use for synchronization purposes. Dispatcher objects provide synchro-
nization for resources such as shared data structures or files. These objects include
many familiar synchronization constructs such as mutexes, semaphores, events and
timers. Kernel threads use kernel dispatcher objects; synchronization objects avail-
able to user processes encapsulate these kernel dispatcher objects (i.e., synchroni-
zation objects translate many API calls made by user-mode threads into function
calls for kernel dispatcher objects). A thread holding a dispatcher object executes at
the passive IRQL. 173 A developer can use these objects to synchronize the actions
of threads of the same process or different processes.174
       Dispatcher objects can be in either a signaled state or unsignaled state (some
dispatcher objects also have states relating to error conditions). The object remains
in the unsignaled state while the resource for which the dispatcher object provides
synchronization is unavailable. Once the resource becomes available, the object
enters its signaled state. If a thread wishes to access a protected resource, the thread
can call a wait function to wait for one or more dispatcher objects to enter a sig-

<!-- pág. 1110 -->

1060 Case Study: Windows XP
                              naled state. When calling a wait function for a single object, the thread specifies the
                              object on which it is waiting (by passing the object's handle) and a maximum wait
                              time for the object. Multiple-object wait functions can be used when a thread must
                              wait on more than one object. The thread can specify whether it is waiting for all the
                              objects or any one of them. Windows XP supplies numerous variations to these
                              generic wait functions; e.g., a thread can specify that it enters an alertable wait state,
                              allowing it to process any APCs queued to it while waiting. After calling a wait
                              function, a thread blocks and enters its wait state. When the required object enters
                              its signaled state, one or more threads can access the resource (later in this section,
                              we describe how a dispatcher object enters its signaled state). 175 In many cases, the
                              kernel maintains FIFO queues for waiting resources, but kernel APCs can disrupt
                              this ordering. Threads process kernel APCs immediately, and when a thread
                              resumes its wait, it is placed at the end of the queue. 176

                              Event Objects
                              Threads often synchronize with an event, such as user input or I/O completion, by
                              using an event object. When the event occurs, the object manager sets the event
                              object to the signaled state. The event object returns to the unsignaled state by one
                              of two methods (specified by the object's creator). In the first method, the object
                              manager sets the event object to the unsignaled state when one thread is released
                              from waiting. This method can be used when only one thread should awaken (e.g..
                              to process the completion of an I/O operation). In the other method, the event
                              object remains in the signaled state until a thread specifically sets the event to its
                              unsignaled state; this allows multiple threads to awaken. This option can be used,
                              for example, when multiple threads are waiting to read data. When a writing thread
                              completes its operation, the writer can use an event object to signal all the waiting
                              threads to awaken. The next time a thread begins writing, the thread can reset the
                              event object to the unsignaled state. 177

                              Mutex Objects
                              Mutex objects provide mutual exclusion for shared resources; they are essentially
                              binary semaphores (see Section 5.6, Semaphores). Only one thread can own a
                              mutex at a time, and only that thread can access the resource associated with the
                              mutex. When a thread finishes using the resource protected by the mutex, it must
                              release the mutex to transition it into its signaled state. If a thread terminates before
                              releasing a mutex object, the mutex is considered abandoned. In this case the mutex
                              enters an abandoned state. A waiting thread can acquire this abandoned mutex.
                              However, the system cannot guarantee that the resource protected by the mutex is
                              in a consistent state. To be safe, a thread should assume an error has occurred if it
                              acquires an abandoned mutex. 178

                              Semaphore Objects
                              Semaphore objects extend the functionality of mutex objects; they allow the creat-
                              ing thread to specify the maximum number of threads that can access a shared

<!-- pág. 1111 -->

                                                                          21.6 Process and Thread Management 1061

resource.179 For example, a process might have a small number of preallocated buff-
ers; the process can use a semaphore to synchronize access to these buffers.180
Semaphore objects in Windows XP are counting semaphores (see Section 5.6.3,
Counting Semaphores). A semaphore object maintains a count, which is initialized
to the maximum number of threads that can simultaneously access the pool of
resources. The count is decremented every time a thread acquires access to the pool
of resources protected by the semaphore and incremented when a thread releases
the semaphore. The semaphore remains in its signaled state while its count is
greater than zero; it enters the unsignaled state when the count drops to zero.
      A single thread can decrement the count by more than one by specifying the
semaphore object in multiple wait functions. For example, a thread might use sev-
eral of the process's buffers in separate asynchronous I/O operations. Each time the
thread issues a buffered I/O request, the thread reacquires the semaphore (i.e., by
specifying the semaphore object in a wait function), which decrements the sema-
phore's count. The thread must release the semaphore, which increments the sema-
phore's count, each time a request completes.181


Waitable Timer Objects
Threads might need to perform operations at regular intervals (e.g., autosave a
user's document) or at specific times (e.g., display a calendar item). For this type of
synchronization, Windows XP provides waitable timer objects. These objects
become signaled after a specified amount of time elapses. Manual-reset timer
objects remain signaled until a thread specifically resets the timer. Auto-reset timer
objects remain signaled only until one thread finishes waiting on the object. Wait-
able timer objects can be single use, after which they become deactivated, or they
can be periodic. In the latter case, the timer object reactivates after a specified inter-
val and becomes signaled once the specified time expires. Figure 21.4 lists Windows
XP's dispatcher objects.182
      Several other Windows XP objects, such as console input, jobs and processes,
can function as dispatcher objects as well. For example, jobs, processes and threads
are set to the signaled state when they terminate, and a console input object is set to
the signaled state when the console's input buffer contains unread data. In these
cases, threads use wait functions and treat these objects just like other dispatcher
objects.183


 Dispatcher Object          Transitions from Unsignaled to Signaled State When
 Event                      Associated event occurs.
 Mutex                      Owner of the mutex releases the mutex.
 Semaphore                  Semaphore's count rises above zero.
 Waitable timer             Specified amount of time elapses.

Figure 21.4 | Dispatcher objects in Windows XP.

<!-- pág. 1112 -->

1062 Case Study: Windows XP

                              Kernel Mode Locks

                              Windows XP provides several mechanisms for synchronizing access to kernel data
                              structures. If a thread is interrupted while accessing a shared data structure, it might
                              leave the data structure in an inconsistent state. Unsynchronized access to a data
                              structure can result in erroneous results. If the thread belongs to a user process, an
                              application might malfunction; if the thread belongs to a kernel process, the system
                              might crash. In a uniprocessor system, one solution to the synchronization problem
                              is to raise the IRQL level above the one at which any component that might pre-
                              empt the thread executes and access the data structure. The thread lowers the
                              IRQL level when it completes executing the critical code.184
                                    Raising and lowering the IRQL level is inadequate in a multiprocessor sys-
                              tem—two threads, executing concurrently on separate processors, can attempt to
                              access the same data structure simultaneously. Windows XP provides spin locks to
                              address this problem. Threads holding spin locks execute at the DPC/dispatch level
                              or DIRQL, ensuring that the holder of the spin lock is not preempted by another
                              thread. Threads should execute the fewest instructions possible while holding a spin
                              lock to reduce wasteful spinning by other threads.
                                    When a thread attempts to access a resource protected by a spin lock, it
                              requests ownership of the associated spin lock. If the resource is available, the
                              thread acquires the lock, accesses the resource, then releases the spin lock. If the
                              resource is not available, the thread keeps trying to acquire the spin lock until suc-
                              cessful. Because threads holding spin locks execute at the DPC/dispatch level or
                              DIRQL, developers should restrict the actions these threads perform. Threads
                              holding spin locks should never access pageable memory (because a page fault
                              might occur), cause a hardware or software exception, attempt any action that
                              could cause deadlock (e.g., attempt to reacquire that spin lock or attempt to acquire
                              another spin lock unless the thread knows that this will not cause deadlock) or call
                              any function that performs any of these actions.185
                                    Windows XP provides generic spin locks and queued spin locks. A queued
                              spin lock enforces FIFO ordering of requests and is more efficient than a normal
                              spin lock,186 because it reduces the processor-to-memory bus traffic associated with
                              the spin lock. With a normal spin lock, a thread continually attempts to acquire the
                              lock by executing a test-and-set instruction (see Section 5.5.2, Test-and-Set Instruc-
                              tion) on the memory line associated with the spin lock. This creates bus traffic on
                              the processor-to-memory bus. With a queued spin lock, a thread that releases the
                              lock notifies the next thread waiting for it. Threads waiting for queued spin locks do
                              not create unnecessary bus traffic by repeating test-and-set. Queued spin locks also
                              increase fairness by guaranteeing FIFO ordering of requests, because the releasing
                              thread uses a queue associated with the spin lock to notify the appropriate waiting
                              thread. 187 Windows XP supports both spin locks (for legacy compatibility) and
                              queued spin locks, but Microsoft recommends the use of the latter.188
                                    Alternatively, kernel-mode threads can use fast mutexes, a more efficient vari-
                              ant of mutexes that operate at the APC level. Although they require less overhead

<!-- pág. 1113 -->

                                                                         21.6 Process and Thread Management 1063

than mutexes, fast mutexes somewhat restrict the actions of the thread owning the
lock. For example, threads cannot specify a maximum wait time to wait for a fast
mutex—they can either wait indefinitely or not wait at all for an unavailable fast
mutex. Also, if a thread attempts to acquire a fast mutex that it already owns, it cre-
ates a deadlock (dispatcher mutexes allow a thread to reacquire a mutex the thread
already owns as long as it releases the mutex for each acquisition of the mutex).189
Fast mutexes operate at the APC IRQL, which masks APCs that might require the
thread to attempt to acquire a fast mutex it already owns.190 However, some threads
might need to receive APCs. For example, a thread might need to process the result
of an asynchronous I/O operation; the system often uses APCs to notify threads that
an asynchronous I/O request has been processed. For this purpose, Windows XP
provides a variant of fast mutexes that execute at the passive IRQL.191
       Another synchronization resource available only to kernel-mode threads is
the executive resource lock. Executive resource locks have two modes: shared and
exclusive. Any number of threads can simultaneously hold an executive resource
lock in shared mode, or one thread can hold an executive resource lock in exclusive
mode. This lock is useful for solving the readers-and-writers problem (see
Section 6.2.4, Monitor Example: Readers and Writers). A reading thread can gain
shared access to a resource if no other thread currently holds or is waiting for exclu-
sive (i.e., write) access to the resource. A writing thread can gain exclusive access to
a resource as long as no other thread holds either shared (i.e., read) or exclusive
(i.e., write) access to it.192

Other Available Synchronization Tools
Aside from dispatcher objects and kernel-mode locks, Windows XP provides to
threads several other synchronization tools. Kernel-mode locks are not applicable
in all situations—they cannot be used by user-mode threads, and many of them
operate at an elevated IRQL, restricting what threads can do while holding them.
Dispatcher objects facilitate general synchronization but are not optimized for spe-
cific cases. For example, dispatcher objects can be used by threads of different pro-
cesses but are not optimized for use among threads of the same process.
        Critical section objects provide services similar to mutex objects but can be
employed only by threads within a single process. Moreover, critical section objects
do not allow threads to specify a maximum wait time (it is possible to wait indefi-
nitely for a critical section object), and there is no way to determine if a critical sec-
tion object is abandoned. However, critical section objects are more efficient than
mutex objects because critical section objects do not transition to kernel mode if
there is no contention. This optimization requires that critical section objects be
employed only to synchronize threads of the same process. Also, critical section
objects are implemented with a processor-specific test-and-set instruction, further
increasing efficiency.193'194
       A timer-queue timer is an alternate method for using waitable timer objects
that allows threads to wait on timer events while executing other pieces of code.
When a thread wishes to wait on a timer, it can place a timer in a timer queue and

<!-- pág. 1114 -->

1064 Case Study: Windows XP

                          specify a function to perform when the timer becomes signaled. At that time, a
                          worker thread from a thread pool performs the specified function. In cases where
                          the thread waits on both a timer and another object, the thread should use a wait-
                          able timer object with a wait function.195
                                For variables shared among multiple threads, Windows XP provides inter-
                          locked variable access through certain functions. These functions provide atomic
                          read and write access to variables, but they do not ensure the order in which
                          accesses are made. For example, the I n t e r l o c k e d l n c r e m e n t function combines
                          incrementing a variable and returning the result into a single atomic operation. This
                          can be useful, for example, when providing unique ids. Each time a thread needs to
                          obtain a unique id, it can call I n t e r l o c k e d l n c r e m e n t . This avoids a situation in
                          which one thread increments the value of the id variable but is interrupted before
                          checking the result. The interrupting thread might then access the id variable, caus-
                          ing two items to have the same id. Because I n t e r l o c k e d l n c r e m e n t both incre-
                          ments the variable and returns the result in an atomic operation, this situation will
                          not occur.196 Windows XP also provides interlocked singly linked lists (SLists).
                          which provide atomic insertion and deletion operations. 197
                                This section provided a broad survey of Windows XP's synchronization tools.
                          However, Windows XP provides other tools; readers interested in more informa-
                          tion should visit the MSDN Library at m s d n . m i c r o s o f t . c o m / l i b r a r y . In addition
                          to these synchronization tools, threads can synchronize by communicating through
                          various IPC mechanisms (described in Section 21.10, Interprocess Communication)
                          or by queuing APCs to other threads.



                          21.7 Memory Management
                          The Windows XP virtual memory manager (VMM) creates the illusion that each
                          process has a 4GB contiguous memory space. Because the system allocates more
                          virtual memory to processes than can fit into main memory, the VMM stores some
                          of the data on disk in files called pagefiles. Windows XP divides virtual memory into
                          fixed-size pages which it stores either in page frames in main memory or files on
                          disk. The VMM uses a two-level hierarchical addressing system.
                                Windows XP has two strategies for optimizing main memory usage and reduc-
                          ing disk I/O. The VMM uses copy-on-write pages (see Section 10.4.6, Sharing in a
                          Paging System) and employs lazy allocation, which is a policy of postponing allocat-
                          ing pages and page table entries in main memory until absolutely necessary. How-
                          ever, when the VMM is forced to perform disk I/O, it prefetches pages from disk
                          and places pages into main memory before they are needed (see Section 11.4.
                          Anticipatory Paging). Heuristics ensure that the gain in the rate of disk I/O out-
                          weighs the cost of filling main memory with potentially unused pages. When main
                          memory fills, Windows XP performs a modified version of the LRU page-replace-
                          ment algorithm. The following sections describe the internals of the Windows XP
                          memory management system.

<!-- pág. 1115 -->

                                                                                   21.7    Memory   Management   1065

21.7.1 Memory Organization
Windows XP systems provide either a 32-bit or a 64-bit address space, depending
on the processor and the edition of Windows XP. We limit our discussion to mem-
ory operations using the Intel IA-32 architecture (e.g., Intel Pentium and AMD
Athlon systems), because the vast majority of today's Windows systems are built
for that platform. See the MSDN Library for more information on Windows XP 64-
Bit Edition. 198
      Windows XP allocates a unique 4GB virtual address space to each process. By
default, a process can access only the first 2GB of its virtual address space. The sys-
tem reserves the other two gigabytes for kernel-mode components—this space is
called system space. 199
      Physical memory is divided into fixed-size page frames, which are 4KB on a
32-bit system (except in the case when the system uses large pages as described
later in this section). The VMM maintains a two-level memory map in the system
portion of each process's virtual address space that stores the location of pages in
main memory and on disk.200 The VMM assigns each process one page directory
table. When a processor switches contexts, it loads the location of the new process's
page directory table into the page directory register. The page directory table is
composed of page directory entries (PDEs); each PDE points to a page table. Page
tables contain page table entries (PTEs); each PTE points to a page frame in main
memory or a location on disk. The VMM uses the virtual address in conjunction
with the memory map to translate virtual addresses into physical addresses. A vir-
tual address is composed of three portions; the offset in a page directory table, the
offset in a page table and the offset on a page in physical memory 201
      Windows XP translates a virtual address in three stages, as shown in Fig. 21.5.
In the first stage of address translation, the system calculates the sum a + d, which is
the value in the page directory register plus the first portion of the virtual address,
to determine the location of the page directory entry (PDE) in the page directory
table. In the second stage, the system calculates the sum b + t, which is the value in
the PDE plus the second portion of the virtual address, to find the page table entry
(PTE) in the page table. This entry contains c, the page frame number correspond-
ing to the virtual page's location in main memory. Finally, in the last stage, the sys-
tem concatenates c and the page offset, o, to form the physical address (see
Section 10.4.4, Multilevel Page Tables). The system performs all of these operations
quickly; the delay occurs when the system must read the PDE and PTE from main
memory.202 Address translation is often accelerated by the Translation Look-aside
Buffer (TLB) as discussed in Section 10.4.3, Paging Address Translation with
Direct/Associative Mapping.
      The PTE is structured differently depending on whether it points to a page in
memory or a page in a pagefile. Five of the PTE's 32 bits are for protection—they
indicate whether a process may read the page, write to the page and execute code
on the page. These protection bits also tell the system whether the page is a copy-
on-write page and whether the system should raise an exception when a process

<!-- pág. 1116 -->

1066 Case Study: Windows XP




                              Figure 21.5 | Virtual address translation.


                              accesses the page. 203 Twenty bits index a frame in memory or offset in a pagefile on
                              disk; this is enough to address 1,048,576 virtual pages. If the page is stored on disk, a
                              designated four bits indicate in which of 16 possible pagefiles the page is located. If
                              the page is in memory, a different set of three bits indicate the state of the page.
                              Figure 21.6 lists these three bits and their meaning.
                                     Windows XP allows applications to allocate large pages. A large page is a set of
                              contiguous pages that the operating system treats as one page. Large pages are use-
                              ful when the system knows it will repeatedly need the same large chunk of code or
                              data. The system needs to store only one entry in the TLB. Because the page is big-
                              ger, it is more likely to be accessed, and less likely to be deleted from the TLB. Page
                              access is accelerated because the VMM can look up address translations in the TLB
                              rather than consulting page tables.204 Windows XP stores information that cannot be
                              swapped to disk (i.e., the nonpaged pool) and memory maps on large pages.205


                               Page state bit       Definition
                               Valid                PTE is valid—it points to a page of data.
                               Modified             Page in memory is no longer consistent with the version on disk.
                               Transition           VMM is in the process of moving the page to or from disk. Pages in
                                                    transition are always invalid.

                              Figure 21.6 | Page states.206

<!-- pág. 1117 -->

                                                                                 21.7 Memory Management 1067

     Windows XP imposes several restrictions on the use of large pages:
     • Each type of processor has a minimum size for large pages, usually 2MB or
       greater. The size of every large page must be a multiple of that minimum
       large page size.207
     • Large pages always allow read and write access. This means that read-only
       data, such as program code and system DLLs, cannot be stored in large
       pages.208
     • The pages that compose a large page must be contiguous in both virtual
       and physical memory.209, 210
Windows XP uses copy-on-write pages (see Section 10.4.6, Sharing in a Paging Sys-
tem) as one of its lazy allocation mechanisms. The system manages copy-on-write
pages using prototype page tables. The system also uses prototype page tables to
manage file mappings. A file mapping is a portion of main memory that multiple
processes may access simultaneously to communicate with one another (this is dis-
cussed further in Section 21.10.3, Shared Memory). The PTE of a copy-on-write
page does not point directly to the frame in which the page is stored. Instead, it
points to a Prototype Page Table Entry (PPTE), a 32-bit record that points to the
location of the shared page.
       When a process modifies a page whose PTE protection bits indicate that it is a
copy-on-write page, the VMM copies the page to a new frame and sets the process's
PPTE to reference the new location. All of the other processes's PPTE's continue
pointing to the original frame. Using copy-on-write pages conserves memory,
because processes share main memory page frames. As a result, each process can
store more of its pages in main memory. This causes fewer page faults, because
there is more space in main memory, and once the VMM fetches a page from disk,
it is less likely to move the page back to disk. However, PPTEs add a level of indi-
rection; it takes four memory references instead of three to translate an address.
Therefore, translating an address that is not in the TLB is more expensive for copy-
on-write pages than for normal pages.211


21.7.2 Memory Allocation
Windows XP performs memory allocation in three stages (Fig. 21.7). A process
must first reserve space in its virtual address space. Processes can either specify
what virtual addresses to reserve or allow the VMM to decide. A process may not
access space it has reserved until it commits the space. When a process commits a
page, the VMM creates a PTE and ensures that there is enough space in either main
memory or a pagefile for the page. A process usually commits a page only when it is
ready to write to the page; however, the Windows API supports single-step reserve
and commit. Separating memory allocation into two steps allows a process to
reserve a large contiguous virtual memory region and sparsely commit portions of
it.212. 213 Finally, when a process is ready to use its committed memory, it accesses
the committed virtual memory. At that point, the VMM writes the data to a zeroed

<!-- pág. 1118 -->

1068 Case Study: Windows XP




                              Figure 21.7 | Memory allocation stages.


                              page in main memory. This three-stage process ensures that processes use only as
                              much space in main memory as they need, rather than the amount they reserve.214
                                    A system rarely has enough main memory to satisfy all processes. Previous
                              versions of Windows allowed an application that required more main memory to

<!-- pág. 1119 -->

                                                                                         21.7 Memory Management 1069
function properly to issue must-succeed requests. Device drivers often issued these
requests, and the VMM always fulfilled a must-succeed request. This led to system
crashes when the VMM was forced to allocate main memory when none was avail-
able. Windows XP does not suffer from this problem; it denies all must-succeed
requests. The system expects components to handle a denied memory allocation
request without crashing.215, 216
      Windows XP has a special mechanism for handling low-memory conditions
when all or most of main memory is allocated. Under normal circumstances, Win-
dows XP optimizes performance by handling multiple memory allocation requests
simultaneously. When there are few page frames in main memory to allocate, the sys-
tem runs into the same scarce-resource problem faced by all multiprogramming sys-
tems. Windows XP solves this problem via a process called I/O throttling; when the
system detects that it has only a few available page frames, it begins to manage mem-
ory one page at a time. I/O throttling slows the system, because the VMM ceases to
manage multiple requests in parallel but instead retrieves pages from disk only one at
a time. However, it does make the system more robust and helps prevent crashes.217
      To track main memory, Windows XP uses a page frame database, which lists
the state of each frame, ordered by page frame number. There are eight possible
states, as shown in Fig. 21.8.
       The system tracks page frames by state. It has a singly linked list, called a
page list, for each of the eight states. A page list is referred to by the state of its
pages; for example, the Free Page List contains all free pages, the Zeroed Page List
contains all zeroed pages and so on. The page lists permit the VMM to swap pages
and allocate memory quickly. For example, to allocate two new pages, the VMM


 Frame State            Definition
 Valid                  Page belongs to a process's working set and its PTE is set to valid.
 Transition             Page is in the process of being transferred to or from disk.
 Standby                Page has just been removed from a process's working set; its PTE
                        is set to invalid and in transition.
                        Page has just been removed from a process's working set; it is not
                        consistent with the on-disk version. The VMM must write this
 Modified
                        page to disk before freeing this page. The PTE of this page is set
                        to invalid and in transition.
                        Page has just been removed from a process's working set; it is not
                        consistent with the on-disk version. The VMM must write an entry
 Modified No-Write
                        to the log file before freeing this page. The PTE of this page is set
                        to invalid and in transition.
                        Page frame does not contain a valid page; however it might con-
                        tain an invalid page that has no PTE and is not part of any work-
 Free
                        ing set.

Figure 21.8 | Page frame states.218(Part 1 of 2.)

<!-- pág. 1120 -->

1070 Case Study: Windows XP


                               Frame State            Definition
                               Zeroed                  Page frame is not part of any working set and all of its bits have
                                                       been set to zero. For security reasons, only zeroed page frames
                                                       are allocated to processes.
                               Bad                     Page frame has generated a hardware error and should not be
                                                       used.

                              Figure 21.8 | Page frame states 218 (Part 2 of 2.)


                              needs to access only the first two frames in the Zeroed Page List. If the Zeroed
                              Page List is empty, the VMM takes a page from another list, using the algorithm
                              described in Section 21.7.3, Page Replacement. 219
                                    The system uses Virtual Address Descriptors (VADs) to manage the virtual
                              address space of each process. Each VAD describes a range of virtual addresses
                              allocated to the process.220
                                    Windows XP attempts to anticipate requests for pages on disk and move
                              pages to main memory to prevent page faults. A process can invoke API functions
                              to tell the system the process's future memory requirements. 221 In general, the sys-
                              tem employs a policy of demand paging, loading pages into memory only when a
                              process requests them. It also loads several nearby pages—spatial locality implies.
                              that these pages are likely to be referenced soon. The Windows file systems divide
                              disk space into clusters of bytes; pages in the same cluster are, by definition, part of
                              the same file. Windows XP takes advantage of spatial locality by loading all pages in
                              the same cluster at once, a paging policy referred to as clustered demand paging.
                              These two mechanisms reduce disk seek time because only one disk seek is needed
                              to fetch the entire cluster. Prefetching, however, potentially places some unneeded
                              pages into main memory, leaving less space for needed pages and increasing the
                              number of page faults. It might also decrease efficiency during periods of heavy disk
                              I/O by forcing the system to page out pages that are needed right away for pages
                              that are not needed yet.222
                                    Windows XP reduces the time needed to load (i.e., start) applications, includ-
                              ing the operating system itself, by prefetching files. The system records what pages
                              are accessed and in what order during the last eight application loads. Before load-
                              ing an application, the system asks for all of the pages it will need in one asynchro-
                              nous request, thus decreasing disk seek time.223, 224
                                    The system decreases the time it takes to load Windows by simultaneously
                              prefetching pages and initializing devices. When Windows XP starts, it must direct
                              numerous peripheral hardware devices to initialize—the system cannot continue
                              loading until they are done. This is the ideal time to perform prefetching, because
                              the system is otherwise idle.225
                                    Windows XP uses the Logical Prefetcher to perform prefetching. The user can
                              set a special registry key to tell Windows XP for which scenarios, such as all applica-
                              tion loads or Windows start-up, the user wants the system to run the Logical

<!-- pág. 1121 -->

                                                                                    21.7 Memory Management 1071

Prefetches 226 When an application loads, Windows XP stores a trace of memory
accesses in a scenario file. Each application, including the Windows operating sys-
tem, has its own scenario file. The system updates scenario files ten seconds after a
successful application load. Storing scenario files has a price: recording each mem-
ory access uses processor cycles and occupies space on the disk. However, the
reduced disk I/O offsets the extra time it takes to store the memory trace, and most
users are willing to give up some disk space in return for significantly faster load
time for all applications, including for Windows itself.227
      The Logical Prefetcher accesses pages based on their location on disk rather
than waiting for a process to explicitly request them. As a result, Windows XP can
load applications faster and more efficiently. However, the pages and files indicated
in scenario files could be scattered throughout the disk. To further optimize applica-
tion load time, the Logical Prefetcher periodically reorganizes portions of the hard
drive to ensure that all files that the system has previously prefetched are contigu-
ous on disk. Every few days, when the system is idle, the Logical Prefetcher updates
a layout file which contains the ideal disk layout and uses this layout to rearrange
pages on disk.228



21.7.3 Page Restatement
Windows XP bases its page-replacement policy on the working set model. Recall
from Section 11.7, Working Set Model, that a process's working set is the set of
pages that a process is currently using. Because this is difficult to determine, Win-
dows XP simply considers a process's working set to be all of its pages in main
memory Pages not in the process's working set, but mapped to its virtual address
space, are stored on disks in pagefiles.229, 230 Storing pagefiles on different physical
disks accelerates swapping because it enables the system to read and write multiple
pages concurrently 231
       When memory becomes scarce, the balance set manager moves parts of differ-
ent processes' working sets to pagefiles. Windows XP employs a localized least-
recently used (LRU) policy to determine which pages to move to disk. The policy is
localized by process. When the system needs to free a frame to meet a process's
request, it removes a page belonging to the process which the process has not
recently accessed. The VMM assigns each process a working set maximum and a
working set minimum that denote an acceptable range for the size of the process's
working set. Whenever a process whose working set size is equal to its working set
maximum requests an additional page, the balance set manager moves one of the
process's pages to secondary storage, then fulfills the request. A process using less
than its working set minimum is not in danger of losing pages unless available mem-
ory drops below a certain threshold. The balance set manager checks the amount of
free space in memory once per second and adjusts the working set maximums
accordingly. If the number of available bytes exceeds a certain threshold, the work-
ing set maximums of processes working at their working set maximum shift upward;
if it drops below a certain threshold, all working set maximums shift downward.232

<!-- pág. 1122 -->

1072 Case Study: Windows XP
                                     Windows XP does not wait until main memory is full to move pages to disk. It
                              regularly tests each process to ensure that only the pages the process needs are in
                              main memory. Windows XP uses page trimming to remove pages from memory.
                              Periodically, the balance set manager moves all of a process's pages above the work-
                              ing set minimum from the Valid Page List to the Standby Page List, Modified Page
                              List, or Modified No-Write Page List, as appropriate. Collectively, these are called
                              the transitional page list, although there is no such actual list in memory.233
                                     The VMM chooses which pages to trim, using the localized LRU policy, as
                              illustrated in Fig. 21.9. The system sets the status bits of the PTEs of trimmed pages
                              to invalid, meaning the PTEs no longer point to a valid frame, but the system does
                              not modify the PTEs in any other way. The state in the page frame database of
                              trimmed pages is set to transition, standby, modified or modified no-write.234 If the
                              process requests a page that is in one of these transitional page lists, the MMU
                              issues a transitional fault. In this situation, the VMM removes the page from the
                              transitional list and puts it back on the Valid Page List. Otherwise, the page is
                              reclaimed. A system thread writes pages in the Modified Page List to disk. Compo-
                              nents, such as file systems, use the Modified No-Write Page List to ensure that the
                              VMM does not write a dirty page to disk without first making an entry in a log file.
                              The application notifies the VMM when it is safe to write the page.235 Once a modi-




                              Figure 21.9 | Page-replacement process.

<!-- pág. 1123 -->

                                                                           21.8 File Systems Management   1073

fled or modified no-write page becomes consistent with the data on disk, the VMM
moves the page to the Standby Page List. After a waiting period, the VMM moves
pages on the Standby Page List to the Free Page List. Later, another low-priority
thread zeroes the bits of pages on the Free Page List and moves the pages to the
Zeroed Page List. Windows XP zeroes pages to prevent a process that is allocated a
page from reading the (potentially sensitive) information that another process pre-
viously stored on that page. When the system needs to allocate a new page to a pro-
cess, it claims a page from the Zeroed Page List.236
       The localized LRU algorithm requires certain hardware features not available
on all systems. Because portability between different platforms is an important
design criterion for all Windows operating systems, many early Windows systems
avoided using hardware-specific features to ensure that the same operating system
could be used on multiple platforms. Operating systems commonly simulate LRU
page replacement with the clock algorithm (see Section 11.6.7, Modifications to
FIFO: Second-Chance and Clock Page Replacement). Doing so requires an
accessed bit which the system sets on for each page that has been accessed within a
certain time interval. Many early computers did not have an accessed bit. As a
result, early versions of Windows NT used the FIFO page-replacement policy (see
Section 11.6.2, First-In-First-Out (FIFO) Page Replacement) or even an effectively
random page replacement. Microsoft later developed versions of Windows specifi-
cally for Intel IA-32 and other platforms that support the accessed bit, allowing
Windows XP to employ the more effective LRU algorithm.237
      Some data cannot be paged out of memory. For example, code that handles
interrupts must stay in main memory, because processing a page fault during an
interrupt would cause an unacceptable delay and might even crash the system. Pag-
ing passwords presents a security risk if the system crashes, because an unencrypted
copy of secret data would be stored on disk. All such data is stored in a designated
area of system space called the nonpaged pool. Data that can be sent to disk is
stored in the paged pool.238 Portions of device drivers and VMM code are stored in
the nonpaged pool. 239
      A device driver developer must consider several trade-offs when deciding
what portions of the code to place in the nonpaged pool. Space in the nonpaged
pool is limited. In addition, code in the nonpaged pool may not access paged pool
code or data because the VMM might be forced to access the disk, which defeats
the purpose of nonpaged pool code.240


21.8 File Systems Management
Windows XP file systems consist of three layers of drivers. At the very bottom are
various volume drivers that control a specific hardware device, such as the hard
disk. File system drivers, which compose the next level, implement a particular file
system format, such as New Technology File System (NTFS) or File Allocation
Table (FAT). These drivers implement what a typical user views as the file system: a

<!-- pág. 1124 -->

1074 Case Study: Windows XP

                              hierarchical organization of files and the related functions to manipulate these files.
                              Finally, file system filter drivers accomplish high-level tasks such as virus protection,
                              compression and encryption.241242 NTFS is the native Windows XP file system (and
                              the one described in depth in this case study), but FAT16 and FAT32 are also sup-
                              ported (see Section 13.6.3, Tabular Noncontiguous File Allocation) and typically
                              used for floppy disks. Windows XP also supports Compact Disc File System (CDFS)
                              for CDs and Universal Disk Format (UDF) for CDs and DVDs. The following sub-
                              sections introduce Windows XP file system drivers and describe the NTFS file sys-
                              tem.243


                              21.8.1 File System Drivers
                              File system drivers cooperate with the I/O manager to fulfill file I/O requests. File
                              system drivers provide a link between the logical representation of the file system
                              exposed to applications and its corresponding physical representation on a storage
                              volume. The I/O manager interface enables Windows XP to support multiple file
                              systems. Windows XP divides each data storage device into one or more volumes,
                              and associates each volume with a file system.
                                    To understand how file system drivers and the I/O manger interact, consider
                              the flow of a typical file I/O request. A user-mode thread that wishes to read data
                              from a file sends an I/O request via a subsystem API call. The I/O manager trans-
                              lates the thread's file handle into a pointer to the file object and passes the pointer
                              to the appropriate file system driver. The file system driver uses the pointer to
                              locate the file object and determine the location of the file on disk. Next, the file sys-
                              tem driver passes the read request through the layers of drivers and eventually the
                              request reaches the disk. The disk processes the read request and returns the
                              requested data. 244
                                    A file system driver can be either a local file system driver or a remote file
                              system driver. Local file system drivers process I/O for hardware devices such as
                              hard disk drives or DVD drives. The preceding paragraph described the role of a
                              local file system driver in fulfilling a disk I/O request. Remote file system drivers
                              transfer files to and from remote file servers via network protocols. Remote file
                              system drivers cooperate with the I/O manager, but instead of interacting with vol-
                              ume drivers, remote file system drivers interact with remote file system drivers on
                              other computers. 245
                                    In general, a file system driver can act as a black box; it provides support for a
                              particular file system, such as NTFS, independent of the underlying storage volume
                              on which the files reside. File system drivers provide the link between the user's
                              view of a file system and the data's actual representation on a storage volume.

                              21.8.2 NTFS
                              NTFS is the default file system for Windows XP. When creating the NT line of oper-
                              ating systems, Microsoft decided to construct a new file system to address the limi-
                              tations of the FAT file system used in DOS and older versions of Windows. FAT.

<!-- pág. 1125 -->

                                                                                 21.8   File Systems Management   1075

which uses a tabular noncontiguous allocation scheme (see Section 13.6.3, Tabular
Noncontiguous File Allocation), does not scale well to large disk drives. For exam-
ple, a file allocation table for FAT32 (the file system included in Windows ME) on a
32GB hard drive using 2KB clusters consumes 64MB of memory. Furthermore,
FAT32 can address no more than 2 32 data blocks. FAT's addressing limitation was a
problem for FAT12 (12-bit FAT) and FAT16 (16-bit FAT) and undoubtedly will be
a problem in the future for FAT32. To avoid these shortcomings, NTFS uses an
indexed approach (see Section 13.6.4, Indexed Noncontiguous File Allocation) with
64-bit pointers. This allows NTFS to address up to 16 exabytes (i.e., 16 billion
gigabytes) of storage. Furthermore, NTFS includes additional features that make a
file system more robust. These features include file compression, file encryption,
support for multiple data streams and user-level enhancements (e.g., support for
hard links and easy file system and directory browsing).

Master File Table
The most important file on an NTFS volume is the Master File Table (MFT). The
MFT stores information about all files on the volume, including file metadata (e.g.,
time of creation, the filename and whether the file is read-only, archive, etc.). The
MFT is divided into fixed-size records, usually 1KB long. Each file has an entry in
the MFT, which consists of at least one record, plus additional ones if necessary.246
      NTFS stores all information about a file in attributes, each consisting of a
header and data. The header contains the attribute's type (e.g., f i 1 e_name), name
(necessary for files with more than one attribute of the same type) and flags. If any
of a file's attributes do not fit into the file's first MFT record, NTFS creates a special
attribute that stores pointers to the headers of all attributes located on different
records. An attribute's data can be of variable length. Attribute data that fits in an
MFT entry is stored in the entry for quick access; attributes whose data reside in the
MFT entry are called resident attributes. Because the actual file data is an attribute,
the system stores small files entirely within their MFT entry. NTFS stores nonresi-
dent attributes, the attributes whose data does not fit inside the MFT entry, else-
where on disk.247
      The system records the location of nonresident attributes using three num-
bers. The logical cluster number (LCN) tells the system on which cluster on disk the
attribute is located. The run length indicates how many clusters the attribute spans.
Because a file attribute might be split into multiple fragments, the virtual cluster
number (VCN) tells the system to which cluster in the attribute the LCN points.
The first VCN is zero. 248
      Figure 21.10 shows a sample multirecord MFT entry that contains both resi-
dent and nonresident attributes. Attribute 3 is a nonresident attribute. The data
portion of attribute 3 contains a list of pointers to the file on disk. The first 10 clus-
ters are stored on disk clusters (i.e., LCNs) 1023-1032. The eleventh cluster, VCN
10, is stored on disk cluster 624. Attributes 1 and 2 are resident attributes, so they
stored on the first MFT record; attributes 3 and 4 are nonresident attributes stored
on the second MFT record.

<!-- pág. 1126 -->

1076 Case Study: Windows XP




                              Figure 21.10 | Master File Table (MFT) entry for a sample file.


                                    NTFS stores directories as files. Each directory file contains an attribute called
                              index that stores the list of files inside the directory. Each file's directory entry con-
                              tains the file's name and standard file information, such as the time of the most
                              recent modification to the file and the file's access (e.g., read-only). If the index
                              attribute is too large to be a resident attribute, NTFS creates index buffers to con-
                              tain the additional entries. An additional attribute, the index_root, describes
                              where on disk any index buffers are stored.
                                    For easy directory searching, NTFS sorts directory entries alphabetically.
                              NTFS structures a large directory (one that is not a resident attribute) in a two-level
                              B-tree. Figure 21.11 shows a sample directory. Suppose the system directs NTFS to
                              find the file e.txt. NTFS begins searching in the i ndex attribute, where it finds
                              a.txt. The file a . t x t comes before e.txt, so NTFS scans to the next file, j . txt.
                              Because j . t x t comes after e.txt, NTFS proceeds to the appropriate child node
                              of a.txt. NTFS searches in the first index buffer, obtaining its location on the vol-
                              ume from information in the i ndex_root attribute. This index buffer begins with
                              b.txt; NTFS scans the first index buffer until it finds e.txt. 249
                                    Windows XP allows multiple directory entries (either in the same directory or
                              in different directories) to point to the same physical file. The system can create a
                              new path (i.e., a new directory entry) to an already existing file, i.e., a hard link (see
                              Section 13.4.2, Metadata). It first updates the existing file's MFT entry by adding a
                              new file_name attribute and incrementing the value of the hard_link attribute.
                              Next, it creates the new directory entry to point to the MFT entry of the existing
                              file. NTFS treats each newly created hard link to a file exactly as it treats the origi-
                              nal file name. If a user "moves" the file, the value of a file_name attribute is
                              changed from the old to the new path name. NTFS does not delete the file until all
                              hard links to the file are removed. It does not permit hard links to directory files.

<!-- pág. 1127 -->

                                                                             21.8 File Systems Management 1077




Figure 21.11 | Directory contents are stored in B-trees.

and because hard links point directly to MFT entries, a hard link must point to a file
residing on the same physical volume.250, 251

Data Streams
The contents (i.e., the actual file data) of an NTFS file are stored in one or more
data streams. A data stream is simply an attribute in an NTFS file that contains file
data. Unlike many other file systems, including FAT, NTFS allows users to place
multiple data streams into one file. The unnamed default data stream is what most
people consider to be the "contents" of a file. NTFS files can have multiple alter-
nate data streams. These streams can store metadata about a file, such as author,
summary or version number. They also can be a form of supplemental data, such as
a small preview image associated with a large bitmap or a backup of a text file.
      NTFS considers each data stream of a file to be an attribute of type Data.
Recall that header information for an attribute stores both the attribute type (in
this case Data) and the attribute's name. NTFS differentiates between different
alternate data streams using the attribute's name; the default data stream is
unnamed. Using separate attributes for each data stream enables the system to
access any data stream without scanning through the rest of the file.252

File Compression
NTFS permits users to compress files and folders through the GUI interface or via
system calls. When a user compresses a folder, the system compresses any file or

<!-- pág. 1128 -->

1078 Case Study: Windows XP

                              folder that is added to the compressed folder. Compression is transparent; applica-
                              tions can open, manipulate and save compressed files using the same API calls as
                              they would with uncompressed files. This capability exists because NTFS decom-
                              presses and recompresses files at the system level; i.e., the system reads the com-
                              pressed file and decompresses it in memory, and then recompresses when the file is
                              saved.253
                                     NTFS uses the Lempel-Ziv algorithm to compress files.254 Lempel-Ziv is one
                              of the most commonly used compression algorithms. For example, the Windows
                              application WinZip and the application gzip, which is popular on UNIX-compatible
                              systems, both use Lempel-Ziv compression.255
                                     NTFS uses segmented compression, dividing files into compression units and
                              compressing one unit at a time. A compression unit consists of 16 clusters; on most
                              systems the cluster size is 2KB or 4KB, but clusters can range anywhere from 512
                              bytes to 64KB. Sometimes compressing a portion of the file does not significantly
                              reduce its size. In that case, compression and decompression add unnecessary over-
                              head. If the compressed version of a compression unit still occupies 16 clusters,
                              NTFS stores the compression unit in its uncompressed state. 256
                                     Although larger files (or sections of files) tend to compress better than small
                              files, this segmented approach decreases file access time. Segmented compression
                              enables applications to perform random file I/O without decompressing the entire
                              file. Segmented compression also enables NTFS to compress a file while an applica-
                              tion modifies it. Modified portions of the file are cached in memory. Because a por-
                              tion of the file that has been modified once is likely to be modified again, constantly
                              recompressing the file while it is open is inefficient. A low-priority lazy-writer
                              thread is responsible for compressing the modified data and writing it to disk.257

                              File Encryption
                              NTFS performs file encryption, like file compression, by dividing the file into units
                              of 16 clusters and encrypting each unit separately. Applications can specify that a
                              file should be encrypted on disk when created, or if the user has sufficient access
                              rights, an application executing on the user's behalf can encrypt an existing file. The
                              system will encrypt any file or folder for a user-mode thread, except system files,
                              system folders and root directories. Because these files and folders are shared
                              among all users, no user-mode thread can encrypt them (and therefore not allow
                              other users access to them).258
                                     NTFS uses a public/private key pair (see Section 19.2, Cryptography) to
                              encrypt files. NTFS creates recovery keys that administrators can use to decrypt any
                              file. This prevents files from being permanently lost when users forget their private
                              keys or change jobs.259
                                     NTFS stores encryption keys in the nonpaged pool in system memory. This is
                              done for security reasons to ensure that the encryption keys are never written to
                              disk. Storing keys on disk would compromise the security of the storage volume,
                              because malicious users could first access the encryption keys, then use them to

<!-- pág. 1129 -->

                                                                                   21.8 File Systems Management 1079

decrypt the data.260 Instead of storing the actual keys, NTFS encrypts private keys
using a randomly generated "master key" for each user; the master key is a sym-
metric key (i.e., it does both encryption and decryption). The private key is stored
on disk in this encrypted form. The master key itself is encrypted by a key gener-
ated from the user's password and stored on disk. The administrator's recovery key
is stored on disk in a similar manner.261
       When NTFS encrypts a file, it encrypts all data streams of that file. NTFS's
encryption and decryption of files is transparent to applications. Note that NTFS
encryption ensures that files residing on a secondary storage volume are stored in
an encrypted form. If data is stored on a remote server, the user must take extra
precautions to protect it during network transfer, such as using a Secure Sockets
Layer (SSL) connection.262

Sparse Files
A file in which most of the data is unused (i.e., set to zero), such as an image file that
is mostly white space, is referred to as a sparse file. Sparse files can also appear in
databases and scientific data with sparse matrices. A 4MB sparse file might contain
only 1MB of nonzero data; storing the 3MB of zeroes on disk is wasteful. Compres-
sion, although an option, degrades performance, owing to the need to decompress
and compress the files when they are used. Therefore, NTFS provides support for
sparse files.263
       A thread explicitly specifies that a file is sparse. If a thread converts a normal
file to a sparse file, it is responsible for indicating areas of the file that contain large
runs of zeroes. NTFS does not store these zeroes on disk but keeps track of them in
a zero block list for the file. Each entry in the list contains the start and end position
of a run of zeroes in the file. The used portion of the file is stored in the usual man-
ner on disk. Applications can access just the used file segments or the entire file, in
which case NTFS generates streams of zeroes where necessary.264
       When an application writes new data to a sparse file, the writing thread is
responsible for indicating areas of the data that should not be stored on disk but
rather in the zero block list. If a write contains an entire compression unit of zeroes
(i.e., 16 clusters of zeroes), NTFS recognizes this and records the empty block in the
zero block list instead of writing the compression unit full of zeroes to disk. (The
write operation must be done using a special API call that notifies NTFS that the
written data consists exclusively of zeroes.) As a result, while an application can
specify exact ranges of zeroes for better memory management, the system also per-
forms some memory optimizations on its own.265

Resparse Points and Mounted Volumes
Recall our earlier discussion of NTFS hard links from the Master File Table subsec-
tion. We noted that they are limited because they cannot point to directories, and
the data to which they point must reside on the same volume as the hard link. NTFS
includes a file attribute, called a reparse point, to address these limitations. A rep-

<!-- pág. 1130 -->

1080 Case Study: Windows XP

                              arse point contains a 32-bit tag and can contain up to 16KB of attribute data. When
                              the system accesses a file with a reparse point, the system first processes the infor-
                              mation in the reparse point. NTFS uses the tag to determine which file system filter
                              driver should handle the data in the reparse point. The appropriate filter driver
                              reads the attribute data and performs some function, such as scanning for viruses,
                              decrypting a file or locating the file's data.266
                                     Reparse points permit applications to establish links to files on another volume.
                              For example, little-used hard disk data is sometimes moved to a tertiary storage
                              device such as a tape drive. Although NTFS might delete the file's data after it is cop-
                              ied to the tertiary storage (to save space on the hard disk), it retains the file's MFT
                              record. NTFS also adds a reparse point specifying from where to retrieve the data.
                              When an application accesses the data, NTFS encounters the reparse point and uses
                              its tag to call the appropriate file system driver, which retrieves the data from tertian
                              storage and copies it back to disk. This operation is transparent to the application.267
                                     Additionally, reparse points are used to mount volumes. The reparse point
                              data specifies the root directory of the volume to mount and how to find the vol-
                              ume, and the file system driver uses this information to mount that volume. In this
                              way, a user can browse a single directory structure that includes multiple volumes.
                              A reparse point can associate any directory within an NTFS volume with the root
                              directory of any volume; this directory is called a mounting directory. NTFS redi-
                              rects all access to the mounting directory to the mounted volume.268
                                     A reparse point can be used to create a directory junction—a directory refer-
                              ring to another directory, similar to a symbolic directory link in Linux. The reparse
                              point specifies the pathname of the directory to which the directory junction refers.
                              This is similar to mounting volumes, except that both directories must be within the
                              same volume. The referring directory must be empty; a user must remove the direc-
                              tory junction before inserting files or folders into the referring directory.269

                              21.9 Input/Output Management
                              Managing input/output (I/O) in Windows XP involves many operating system com-
                              ponents (Fig. 21.12). User-mode processes interact with an environment subsystem
                              (such as the Win32 subsystem) and not directly with kernel-mode components. The
                              environment subsystems pass I/O requests to the I/O manager, which interacts with
                              device drivers to handle such requests. Often, several device drivers, organized into
                              a driver stack, cooperate to fulfill an I/O request.270 The Plug and Play (PnP) man-
                              ager dynamically recognizes when new devices are added to the system (as long as
                              these devices support PnP) and allocates and deallocates resources, such as I/O
                              ports or DMA channels, to them. Most recently developed devices support PnP.
                              The power manager administers the operating system's power management policy.
                              The power policy determines whether to power down devices to conserve energy or
                              keep them fully powered for high responsiveness.271 We describe the PnP manager
                              and power manager in more detail later in this section. First, we describe how these
                              components and device drivers cooperate to manage I/O in Windows XP.

<!-- pág. 1131 -->

                                                                               21.9 Input/Output Management 1081




21.9.1 Device Drivers
Windows XP stores information about each device in one or more device objects. A
device object stores device-specific information (e.g., the type of device and the cur-
rent I/O request being processed) and is used for processing the device's I/O
requests. Often, a particular device has several device objects associated with it,
because several drivers, organized into a driver stack, handle I/O requests for that
device. Each driver creates a device object for that device.272
      The driver stack consists of several drivers that perform different tasks for I/O
management. A low-level driver—a driver that interacts most closely with the
HAL—controls a peripheral device and does not depend on any lower-level driv-
ers; a bus driver is a low-level driver. A high-level driver abstracts hardware specif-
ics and passes I/O requests to low-level drivers. An NTFS driver is a high-level
driver that abstracts how data is stored on disk. An intermediate driver can be inter-
posed between high- and low-level drivers to filter or process I/O requests and

<!-- pág. 1132 -->

1082 Case Study: Windows XP

                          export an interface for a specific device; a class driver (i.e., a driver that implements
                          services common to a class of devices) is an intermediate driver.
                                For example, a driver stack that handles mouse input might include a PCI bus
                          driver, a USB controller driver, a USB hub driver, a driver that performs mouse
                          acceleration and a driver that provides the user interface and processes incoming
                          mouse data. The drivers cooperate to process mouse input. The drivers for the vari-
                          ous hardware buses (i.e., the PCI bus, USB controller and USB hub) process inter-
                          rupts and handle PnP and power management for the mouse; the intermediate
                          driver manipulates the data, providing mouse acceleration; and the high-level
                          driver translates the incoming data and sends it to a user-level GUI application.273
                                These driver types all refer to kernel-mode drivers. Other drivers, such as
                          some printer drivers, can be user-mode drivers; these drivers execute in user space
                          and are specific to an environment subsystem.274
                                Kernel-mode drivers operate in the thread context of the currently executing
                          thread, implying that developers cannot assume that a driver will execute in the
                          context of the same thread each time driver code executes. However, drivers need
                          to store context information such as device state information, driver data and han-
                          dles to kernel objects. Drivers store this information in a device extension. Windows
                          XP allocates a portion of the nonpaged memory for drivers to store device exten-
                          sions. Each device object points to a device extension, and a driver uses the device
                          extension for each device it serves to store information and objects needed to pro-
                          cess I/O for that device.275
                                The system represents a device driver with a driver object which stores the
                          device objects for the devices the driver services. The driver object also stores point-
                          ers to standard driver routines.276 Many of the standard driver routines must be
                          implemented by all kernel-mode drivers. These include functions for adding a
                          device, unloading the driver and certain routines for processing I/O requests (such
                          as read and write). Other standard driver routines are implemented only by certain
                          classes of drivers. For example, only low-level drivers need to implement the stan-
                          dard routine for handling interrupts. In this way, all drivers expose a uniform inter-
                          face to the system by implementing a subset of the standard driver routines.277

                          Plug and Play (PnP)
                          Plug and Play (PnP), introduced in Section 2.4.4, describes the ability of a system to
                          dynamically add or remove hardware components and redistribute resources (e.g..
                          I/O ports or DMA channels) appropriately. A combination of hardware and soft-
                          ware support enables this functionality. Hardware support involves recognizing
                          when a user adds or removes components from a system and easily identifying
                          these components. Both the operating system and third-party drivers must cooper-
                          ate to provide software support for PnP. Windows XP support for PnP involves uti-
                          lizing information provided by hardware devices, the ability to dynamically allocate
                          resources to devices and a programming interface for device drivers to interact with
                          the PnP system.278

<!-- pág. 1133 -->

                                                                             21.9 Input/Output Management 1083

      Windows XP implements PnP with the PnP manager, which is divided into
two components, one in user space and the other in kernel space. The kernel-mode
PnP manager configures and manages devices and allocates system resources. The
user-mode PnP manager interacts with device setup programs and notifies user-
mode processes when some device event has occurred for which the process has
registered a listener. The PnP manager automates most device maintenance tasks
and adapts to hardware and resource changes dynamically.279
      Driver manufacturers must adhere to certain guidelines to support PnP for
Windows XP. The PnP manager collects information from drivers by sending driver
queries. These queries are called PnP I/O requests, because they are sent in the
form of I/O request packets (IRPs). IRPs are described in Section 21.9.2, Input/
Output Processing. PnP drivers must implement functions that respond to these
PnP I/O requests. The PnP manager uses information from the requests to allocate
resources to hardware devices. PnP drivers must also refrain from searching for
hardware or allocating resources, because the PnP manager handles these tasks.280
Microsoft urges all driver vendors to support PnP, but Windows XP supports non-
PnP drivers for legacy compatibility.281

Power Maanagement
The power manager is the executive component that administers the system's
power policy.282 The power policy dictates how the power manager administers sys-
tem and device power consumption. For example, when the power policy empha-
sizes conservation, the power manager attempts to shut down devices that are not
in use. When the power policy emphasizes performance, the power manager leaves
these devices on for quick response times.283 Drivers that support power manage-
ment must be able to respond to queries or directives made by the power man-
ager.284 The power manager queries a driver to determine whether a change in the
power state of a device is feasible or will disrupt the device's work. The power man-
ager also can direct a driver to change the power state of a device.285
       Devices have power states DO, D1, D2 and D3. A device in state DO is fully
powered, and a device in D3 is off.286 In states Dl and D2, the device is in a sleep
(i.e., low-powered) state, and when the device returns to the DO state, the system
will need to reinitialize some of its context. A device in Dl retains more of its con-
text and is in a higher-powered state than a device in D2.287 In addition to control-
ling devices' power states, the power manager controls the overall system's power
state, which is denoted by values S0-S5. State SO is the fully powered working state,
and S5 denotes that the computer is off. States S1-S4 represent states in which the
computer is on, but in a sleeping state; a system in S1 is closest to fully powered,
and in S4 is closest to off.288

Windows Driver Model (WDM)
Microsoft has defined a standard driver model—the Windows Driver Model
(WDM)—to promote source-code compatibility across all Windows platforms.

<!-- pág. 1134 -->

1084 Case Study: Windows XP

                          Windows XP supports non-WDM drivers to maintain compatibility with legacy
                          drivers, but Microsoft recommends that all new drivers be WDM drivers. This sec-
                          tion briefly outlines the WDM guidelines.289
                                 WDM defines three types of device drivers. Bus drivers interface with a hard-
                          ware bus, such as a SCSI or PCI bus, provide some generic functions for the devices
                          on the bus, enumerate these devices and handle PnP I/O requests. Each bus must
                          have a bus driver, and Microsoft provides bus drivers for most buses.290
                                 Filter drivers are optional and serve a variety of purposes. They can modify the
                          behavior of hardware (e.g., provide mouse acceleration or enable a joystick to emu-
                          late a mouse) or add additional features to a device (e.g., implement security checks
                          or merge audio data from two different applications for simultaneous playback).
                          Additionally, filter drivers can sort I/O requests among several devices. For example,
                          a filter driver might serve multiple storage devices and sort read and write requests
                          between the devices. Filter drivers can be placed in numerous locations in the device
                          stack—a filter driver that modifies hardware behavior is placed near the bus driver,
                          whereas one that provides some high-level feature is placed near the user interface.291
                                 A function driver implements a device's main function. A device's function
                          driver does most of the I/O processing and provides the device's interface. Windows
                          XP groups devices that perform similar functions into a device class (such as the
                          printer device class).292 A function driver can be implemented as a class/miniclass
                          driver pair.293 A class driver provides generic processing for a particular device class
                          (e.g., a printer); a miniclass driver provides the functionality specific to a particular
                          device (e.g., a particular printer model). Typically, Microsoft provides class drivers,
                          and software vendors provide the miniclass drivers.294
                                 All WDM drivers must be designed as either a bus driver, filter driver or func-
                          tion driver.295 Additionally, WDM drivers must support PnP, power management
                          and Windows Management Instrumentation (WMI).296 Drivers that support WMI
                          provide users with measurement and instrumentation data. This data includes con-
                          figuration data, diagnostic data and custom data. Also, WMI drivers permit user
                          applications to register for WMI driver-defined events. The main purpose of WMI is
                          to provide hardware and system information to user processes and allow user pro-
                          cesses greater control in configuring devices.297

                          21.9.2 Input/Output Processing
                          Windows XP describes I/O requests with I/O request packets (IRPs). IRPs contain
                          all the information necessary to process an I/O request. An IRP (Fig. 21.13) consists
                          of a header block and an I/O stack. Most header block information does not change
                          during request processing. The header block records such information as the
                          requestor's mode (either kernel or user), flags (e.g., whether to use caching) and
                          information about the requestor's data buffer.298 The header block also contains the
                          I/O status block, which indicates whether an I/O request completed successfully or.
                          if not, the request's error code.299

<!-- pág. 1135 -->

                                                                                 21.9 Input/Output Management 1085




Figure 21.13 | I/O request packet (IRP).


      The I/O stack portion of an IRP contains at least one different stack location
for each driver in the device stack of the target device. Each I/O stack location con-
tains specific information that each driver needs in order to process the IRP, in par-
ticular the IRP's major function code and the minor function code. Figure 21.14 lists
several major function codes. The major function code specifies the general IRP
function such as read (IRP_MJ_READ) or write (IRP_MJ_WRITE). In some cases, it
designates a class of IRPs, such as IRP_MJ_PNP, which specifies that the IRP is a PnP



                             Typical reason to send an IRP with this major
Major function code          function code
 IRP_MJ_READ                  User-mode process requests to read from a file.
 IRP_MJ_WRITE                 User-mode process requests to write to a file.
 IRP_MJ_CREATE                User-mode process requests a handle to a file object.
 IRP_MJ_CLOSE                 All handles to a file object have been released and all out-
                              standing I/O requests have been completed.
 IRP_MJ_POWER                 Power manager queries a driver or directs a driver to
                              change the power state of a device.

Figure 21.14 | Major function code examples in Windows XP. (Part 1 of 2.)

<!-- pág. 1136 -->

1086 Case Study: Windows XP


                                                             Typical reason to send an IRP with this major
                               Major function code           function code
                               IRP_MJ_PNP                    PnP manager queries a driver, allocates resources to a
                                                             device or directs a driver to perform some operation.
                               IRP_MJ_DEVICE_CONTROL         User-mode process calls a device I/O control function to
                                                             retrieve information about a device or direct a device to per-
                                                             form some operation (e.g., format a disk).

                              Figure 21.14 | Major function code examples in Windows XP. (Part 2 of 2.)

                              I/O request. The minor function code then indicates the particular I/O function to
                              perform.300 For example, the PnP manager starts a device by specifying the major
                              function code IRP_MD_PNP and the minor function code IRP_MN_START_DEVICE.
                              Each I/O stack location contains several other fields, including a pointer to the target
                              device object and some driver-specific parameters.301 Each driver accesses one loca-
                              tion in the stack, and before passing the IRP to the next driver, the currently execut-
                              ing driver initializes the stack location of the next driver by assigning each field in the
                              stack a value.302

                              Processing an I/O Request
                              The I/O manager and device drivers cooperate to fulfill an I/O request. Figure 21.15
                              describes the path an IRP travels as the system fulfills a read I/O request from a user-
                              mode process. First, a thread passes the I/O request to the thread's associated envi-
                              ronment subsystem (1). The environment subsystem passes this request to the I/O
                              manager (2). The I/O manager interprets the request and builds an IRP (3). Each
                              driver in the stack accesses its I/O stack location, processes the IRP, initializes the
                              stack location for the next driver and passes the IRP to the next driver in the stack (4
                              and 5). Additionally, a high-level or intermediate driver can divide a single I/O
                              request into smaller requests by creating more IRPs. For example, in the case of a
                              read to a RAID subsystem, the file system driver might construct several IRPs,
                              enabling different parts of the data transfer to proceed in parallel.303 Any driver,
                              except a low-level driver, can register an I/O completion routine with the I/O man-
                              ager. Low-level drivers complete the I/O request and, therefore, do not need I/O
                              completion routines. When processing of an IRP completes, the I/O manager pro-
                              ceeds up the stack, calling all registered I/O completion. A driver can specify that its
                              completion routine be invoked if an IRP completes successfully, produces an error
                              and/or is canceled. An I/O completion routine can be used to retry an IRP that
                              fails.304 Also, drivers that create new IRPs are responsible for disposing of them when
                              processing completes; they accomplish task by using an I/O completion routine.305
                                     Once the IRP reaches the lowest-level driver, this driver checks that the input
                              parameters are valid, then notifies the I/O manager that an IRP is pending for a
                              particular device (6). The I/O manager determines whether the target device is
                              available.306 If it is, the I/O manager calls the driver routine that handles the I/O
                              operation (7). The driver routine cooperates with the HAL to direct the device to

<!-- pág. 1137 -->

                                                                              21.9 Input/Output Management 1087




Figure 21.15 | Servicing an IRP.

perform an action on behalf of the requesting thread (8). Finally, the data is sent to
the calling process's address space (9). The different methods for transferring I/O
are described later in this section. If the device is not available, the I/O manager
queues the IRP for later processing.307 Section 21.9.3, Interrupt Handling, describes
how Windows XP completes I/O processing.


Synchronous and Asynchronous I/O
Windows XP supports both synchronous and asynchronous I/O requests. Microsoft
uses the term overlapped I/O to mean asynchronous I/O. If a thread issues a
synchronous I/O request, the thread enters its wait state. Once the device services the
I/O request, the thread enters its ready state, and when it obtains the processor, it

<!-- pág. 1138 -->

1088 Case Study: Windows XP

                              completes I/O processing. However, a thread that issues an asynchronous I/O request
                              can continue executing other tasks while the target device services the request.308
                                    Windows XP provides several options for managing asynchronous I/O
                              requests. A thread can poll the device to determine whether an I/O has completed.
                              Polling can be useful when a thread is executing a loop. In this case, the thread can
                              perform useful work while waiting for the I/O to complete and process the comple-
                              tion of the I/O as soon as it occurs.
                                    Alternatively, a thread can employ an event object and wait for this object to
                              enter its signaled state.309 This method is similar to synchronous I/O, except the
                              thread does not enter the wait state immediately, but instead might perform some
                              processing. After completing this processing, the thread waits for the completion of
                              the I/O just as with synchronous I/O.
                                    As a third option, a thread can perform alertable I/O. When the system com-
                              pletes servicing an alertable I/O request, it queues an APC to the requesting thread.
                              The next time this thread enters an alertable wait state, it processes this APC.310
                                    Additionally, threads can accomplish asynchronous I/O using an I/O comple-
                              tion port. Several file handles can be associated with an I/O completion port. When
                              I/O processing completes for a file associated with one of these handles, the I/O
                              manager queues an I/O completion packet to the I/O completion port. A number of
                              threads register with the port and block, waiting for these packets. When a packet
                              arrives, the system awakens one of these threads to complete the I/O processing.311

                              Data Transfer Techniques
                              A driver can choose from three methods for transferring data between a device and
                              a process's memory space by setting flags in the device object for that device.312 If
                              the driver chooses buffered I/O, the I/O manager allocates system pages to form a
                              buffer equal to the size of the requesting thread's buffer. On read requests, the
                              driver reads the data into the system buffer. The I/O manager transfers the data to
                              the thread's buffer the next time the requesting thread gains the processor.313 For
                              writes, the I/O manager transfers the data from the thread's buffer to the newly
                              allocated system buffer before passing the IRP to the top-level driver.314 The system
                              buffer does not act as a cache; it is reclaimed after I/O processing completes.
                                     Buffered I/O is useful for small transfers, such as mouse and keyboard input,
                              because the system does not need to lock physical memory pages due to the fact
                              that the system transfers the data first between the device and nonpaged pool.
                              When the VMM locks a memory page, the page cannot be paged out of memory.
                              However, for large transfers (i.e., more than one memory page), the overhead of
                              first copying the data into the system buffer and then making a second copy to the
                              process buffer reduces I/O performance. Also, because system memory becomes
                              fragmented as the system executes, the buffer for a large transfer likely will not be
                              contiguous, further degrading performance.315
                                     As an alternative, drivers can employ direct I/O, with which the device trans-
                              fers data directly to the process's buffer. Before passing the IRP to the first driver,
                              the I/O manager creates a memory descriptor list (MDL), which maps the applica-

<!-- pág. 1139 -->

                                                                                  21.9 Input/Output Management 1089

ble range of the requesting process's virtual addresses to physical memory
addresses. The VMM then locks the physical pages listed in the MDL and con-
structs the IRP with a pointer to the MDL. Once the device completes transferring
data (using the MDL to access the process's buffer), the I/O manager unlocks the
memory pages.316
      Drivers can choose not to use buffered I/O or direct I/O and, instead, use a
technique called neither I/O. In this technique, the I/O manager passes IRPs that
describe the data's destination (for a read) or origin (for a write) using the virtual
addresses of the calling thread. Because a driver performing neither I/O needs
access to the calling thread's virtual address space, the driver must execute in the
calling thread's context. For each IRP, the driver can decide to set up a buffered I/O
transfer by creating the two buffers and passing a buffered I/O IRP to the next low-
est driver (recall that the I/O manager handles this when the buffered I/O flag is
set). The driver can also choose to create an MDL and set up a direct I/O IRP.
Alternatively, the driver can perform all the necessary transfer operations in the
context of the calling thread. In any of these cases, the driver must handle all excep-
tions that might occur and ensure that the calling thread has sufficient access rights.
The I/O manager handles these issues when direct I/O or buffered I/O is used.317
      Because a driver employing neither I/O must execute in the context of the
calling thread, only high-level drivers can use neither I/O. High-level drivers can
guarantee that they will be entered in the context of the calling thread; on the other
hand, an intermediate or low-level driver is called by another driver and cannot
assume that the other driver will execute in the context of the calling thread.318 All
drivers in a device stack must use the same transfer technique for that device—oth-
erwise the transfer would fail due to device drivers' executing conflicting opera-
tions—except that the highest-level driver can use neither I/O instead.319


21.9.3 Interrupt Handling
Once a device completes processing an I/O request, it notifies the system with an
interrupt. The interrupt handler calls the interrupt service routine (ISR) associated
with that device's interrupt. 320 An ISR is a standard driver routine used to process
interrupts. It returns false if the device with which it is associated is not interrupting;
this can occur because more than one device can interrupt at the same DIRQL. If
the associated device is interrupting, the ISR processes the interrupt and returns
true. 321 When a device that generates interrupts is installed on a Windows XP sys-
tem, a driver for that device must register an ISR with the I/O manager. Typically,
low-level drivers are responsible for providing ISRs for the devices they serve.
       When a driver registers an ISR, the system creates an interrupt object.322 An
interrupt object stores interrupt-related information, such as the specific DIRQL at
which the interrupt executes, the interrupt vector of the interrupt and the address
of the ISR.323 The I/O manager uses the interrupt object to associate an interrupt
vector in the kernel's Interrupt Dispatch Table (IDT) with the ISR. The IDT maps
hardware interrupts to interrupt vectors.324

<!-- pág. 1140 -->

1090 Case Study: Windows XP

                                      When an interrupt occurs, the kernel maps a hardware-specific interrupt
                              request into an entry in its IDT to access the correct interrupt vector.325 Often, there
                              are more devices than entries in the IDT, so the processor must determine which
                              ISR to use. It does this by executing, in succession, each ISR associated with the
                              applicable vector. When an ISR returns false, the processor calls the next ISR.326
                                      An ISR for a Windows XP system should execute as quickly as possible, then
                              queue a DPC to finish processing the interrupt. While a processor is executing an
                              ISR, it executes at the device's DIRQL. This masks interrupts from devices with
                              lower DIRQLs. Quickly returning from an ISR, therefore, increases a system's
                              responsiveness to all device interrupts. Also, executing at a DIRQL restricts the sup-
                              port routines that can be called (because some of these routines must run at some
                              IRQL below DIRQL). Additionally, executing an ISR can prevent other processors
                              from executing the ISR—and some other pieces of the driver's code—because the
                              kernel interrupt handler holds the driver's spin lock while processing the ISR. There-
                              fore, an ISR should determine if the device with which it is associated is interrupting.
                              If it is not interrupting, the ISR should return false immediately; otherwise, it should
                              clear the interrupt, gather the requisite information for interrupt processing, queue a
                              DPC with this information and return true. The driver can use the device extension to
                              store the information needed for the DPC. Typically, the DPC will be processed the
                              next time the IRQL drops below DPC/dispatch level.327

                              21.9.4 File Cache Management
                              Not all I/O operations require the process outlined in the previous sections. When
                              requested data resides in the system's file cache, Windows XP can fulfill an I/O
                              request without a costly device access and without executing device driver code.
                              The cache manager is the executive component that manages Windows XP's file
                              cache, which consists of main memory that caches file data.328 Windows XP does
                              not implement separate caches for each mounted file system, but instead maintains
                              a single systemwide cache.329
                                    Windows XP does not reserve a specific portion of RAM to act as the file
                              cache, but instead allows the file cache to grow or shrink dynamically, depending on
                              system needs. If the system is running many I/O-intensive routines, the file cache
                              grows to facilitate fast data transfer. If the system is executing large programs that
                              consume lots of system memory, the file cache shrinks to reduce page faults. Further-
                              more, the cache manager never knows how much cached data currently resides in
                              physical memory. This is because the cache manager caches by mapping files into the
                              system's virtual address space, rather than managing the cache from physical mem-
                              ory. The memory manager is responsible for paging the data in these views into or
                              out of physical memory. This caching method allows easy integration of Windows
                              XP's two data access methods: memory-mapped files (see Section 13.9, Data Access
                              Techniques) and traditional read/write access. The same file can be accessed via both
                              methods (i.e., as a memory-mapped file through the memory manager and as a tradi-
                              tional file through the file system), because the cache manager maps file data into

<!-- pág. 1141 -->

                                                                            21.10 Interprocess Communication 1091

virtual memory. The cache manager bridges the gap between these two file represen-
tations, ensuring consistency in file data between the two views.330
      When a file is read from a disk, its contents are stored in the system cache,
which is a portion of the system address space. Then, a user-mode process copies
the data from the cache into its own address space. A thread can set a flag that over-
rides this default behavior; in this case, the transfer occurs directly between the disk
and the process's address space. Similarly, instead of writing directly to the disk, a
process writes new data to the cache entry (unless a flag is set).331 Fulfilling an I/O
request without generating an IRP or accessing a device is called fast I/O.332
      Dirty cache entries can be written to disk in several ways. The memory man-
ager might need to page a dirty cache page out of memory to make room for
another memory page. When this occurs, the contents of the cache page are queued
to be written to disk. If a dirty cache page is not paged out of memory by the mem-
ory manager, the cache manager must flush the page back to disk. It accomplishes
this by using a lazy writer thread. The lazy writer is responsible for, once per sec-
ond, choosing one-eighth of the dirty pages to be flushed to disk. It constantly
reevaluates how often dirty pages are being created and adjusts the amount of
pages it queues to be flushed accordingly. The lazy writer chooses pages based on
how long a page has been dirty and the last time the data on that page was accessed
for a read operation. Additionally, threads can force a specific file to be flushed.
Threads can also specify write-through caching (see Section 12.8, Caching and Buff-
ering) by setting a flag when creating the file object.333


21.10 Interprocess Communication
Windows XP provides many interprocess communication (IPC) mechanisms to
allow processes to exchange data and cooperate to complete tasks. It implements
many traditional UNIX IPC mechanisms, such as pipes, message queues (called
mailslots by Windows XP)334 and shared memory. In addition to these "data-ori-
ented" IPCs, Windows XP allows processes to communicate through "procedure-
oriented" or "object-oriented" techniques, using such tools as remote procedure
calls or Microsoft's Component Object Model. Users on a Windows XP system also
can initiate IPC with familiar features such as the clipboard and drag-and-drop
capabilities. In each of Windows XP's IPC mechanisms, a server process makes
some communication object available. A client process can contact the server pro-
cess via this communication object to place a request. The request might be for the
server to execute a function or to return data or objects. The remainder of this sec-
tion describes these IPC tools. Section 21.11, Networking, introduces techniques
and tools, such as sockets, that processes can use to communicate across a network.

21.10.1 Pipes
Windows XP provides pipes for direct communication between two processes.335 If
communicating processes have access to the same memory bank, pipes use shared

<!-- pág. 1142 -->

1092 Case Study: Windows XP
                              memory. Thread can manipulate pipes using standard file system routines (e.g., read,
                              write and open). A process that creates the pipe is called the pipe server; processes
                              that connect to a pipe are referred to as pipe clients.336 Each pipe client communi-
                              cates solely with the pipe server (i.e., not with other clients using the same pipe)
                              because the pipe server uses a unique instance of the pipe for each client process.337
                              The pipe server specifies a mode (read, write or duplex) when the pipe is created. In
                              read mode, the pipe server receives data from clients; in write mode, it sends data to
                              pipe clients; in duplex mode, it can both send and receive data via the pipe.338 Win-
                              dows XP provides two types of pipes: anonymous pipes and named pipes.

                          Anonymous        Pipes
                              Anonymous pipes are used for unidirectional communication (i.e., duplex mode is
                              not allowed) and can be used only among local processes. Local processes are pro-
                              cesses that can communicate with each other without sending messages over a net-
                              work.339 A process that creates an anonymous pipe receives both a read handle and a
                              write handle for the pipe. A process can read from the pipe by passing the read han-
                              dle as an argument in a read function call, and a process can write to the pipe by
                              passing the write handle as an argument in a write function call (for more informa-
                              tion on handles see Section 21.5.2, Object Manager). To communicate with another
                              process, the pipe server must pass one of these handles to another process. Typically,
                              this is accomplished through inheritance (i.e., the parent process allows the child
                              process to inherit one of the pipe handles). Alternatively, the pipe server can send a
                              handle for the pipe to another, unrelated process via some IPC mechanism.340
                                    Anonymous pipes support only synchronous communication. When a thread
                              attempts to read from the pipe, it waits until the requested amount of data has been
                              read from the pipe. If there is no data in the pipe, the thread waits until the writing
                              process places the data in the pipe. Similarly, if a thread attempts to write to a pipe
                              containing a full buffer (the buffer size is specified at creation time), it waits until
                              the reading process removes enough data from the pipe to make room for the new
                              data. A thread that is waiting to read data via a pipe can stop waiting if all write
                              handles to the pipe are closed or if some error occurs. Similarly, a thread waiting to
                              write data to a pipe can stop waiting if all read handles to the pipe are closed or if
                              some error occurs.341

                          Named Pipes
                              Named pipes support several features absent in anonymous pipes. Named pipes can
                              be bidirectional, be shared between remote processes342 and support asynchronous
                              communication. However, named pipes introduce additional overhead. When the
                              pipe server creates a pipe, the pipe server specifies its mode, its name and the maxi-
                              mum number of instances of the pipe. A pipe client can obtain a handle for the pipe
                              by specifying the pipe's name when attempting to connect to the pipe. If the num-
                              ber of pipe instances is less than the maximum, the client process connects to a new
                              instance of the pipe. If there are no available instances, the pipe client can wait for
                              an instance to become available.343

<!-- pág. 1143 -->

                                                                            21.10 Interprocess Communication 1093

      Named pipes permit two pipe writing formats. The system can transmit data
either as a stream of bytes or as a series of messages. All instances of a pipe must
use the same write format (recall that a single pipe server can communicate with
multiple clients by creating a unique instance of the pipe for each client). Although
sending data as a series of bytes is faster, messages are simpler for the receiver to
process because they package related data. 344
      Windows XP permits a process to enable write-through mode. When the write-
through flag is set, write operations do not complete until the data reaches the receiv-
ing process's buffer. In the default mode, once the data enters the writer's buffer, the
write method returns. Write-through mode increases fault tolerance and permits
greater synchronization between communicating processes because the sender knows
whether a message successfully reaches its destination. However, write-through mode
degrades performance, because the writing process must wait for the data to be trans-
ferred across a network from the writer's end of the pipe to the reader's end.345 The
system always performs writes using the write-through method when a process is
using messages to ensure that each message remains a discrete unit.346
      Asynchronous I/O capability increases named pipes' flexibility. Threads can
accomplish asynchronous communication via named pipes in several ways. A
thread can use an event object to perform an asynchronous read or write request.
In this case, when the function completes, the event object enters its signaled state
(see Section 21.6.3, Thread Synchronization). The thread can continue processing,
then wait for one or more of these event objects to enter signaled states to complete
a communication request. Alternatively, a thread can specify an I/O completion
routine. The system queues this routine as an APC when the function completes,
and the thread executes the routine the next time the thread enters an alertable
wait state. 347 In addition, a pipe can be associated with an I/O completion port
because pipes are manipulated like files.


21.10.2 Mailslots
Windows XP provides mailslots for unidirectional communication between a server
and clients.348 The process that creates the mailslot is the mailslot server, whereas
the processes that send messages to the mailslot are mailslot clients. Mailslots act as
repositories for messages sent by mailslot clients to a mailslot server. Mailslot cli-
ents can send messages to either local or remote mailslots; in either case, there is no
confirmation of receipt. Windows XP implements mailslots as files in the sense that
a mailslot resides in memory and can be manipulated with standard file functions
(e.g., read, write and open). Mailslots are temporary files (the Windows XP docu-
mentation refers to them as "pseudofiles"); the object manager deletes a mailslot
when no process holds a handle to it.349
       Mailslot messages can be transmitted in two forms. Small messages are sent as
datagrams, which are discussed in Section 16.6.2, User Datagram Protocol (UDP).
Datagram messages can be broadcast to several mailslots within a particular
domain. A domain is a set of computers that share common resources such as print-

<!-- pág. 1144 -->

1094 Case Study: Windows XP

                              ers.350, 351 Larger messages are sent via a Server Message Block (SMB) connec-
                              tion.352 SMB is a network file sharing protocol used in Windows operating
                              systems.353 Both SMB and datagram messages can be sent from a mailslot client to
                              a mailslot server by specifying the server name in a write operation.354


                              21.10.3 Shared Memory
                              Processes can communicate by mapping the same file to their respective address
                              spaces, a technique known as shared memory. The Windows XP documentation
                              calls this mechanism file mapping. A process can create a file mapping object that
                              maps any file, including a pagefile, to memory The process passes a handle for the
                              file mapping object to other processes, either by name or through inheritance. The
                              process communicates by writing data into these shared memory regions, which
                              other processes can access.
                                     A process can use the handle to create a file view that maps all or part of the
                              file to the process's virtual address space. A process may own multiple file views of
                              the same file. This allows a process to access the beginning and end of a large file
                              without mapping all of the file to memory, which would reduce its available virtual
                              address space. Because identical file views map to the same memory frames, all
                              processes see a consistent view of a memory-mapped file. If one process writes to its
                              file view, the change will be reflected in all file views of that portion of the file.355, 356
                                     File mapping objects accelerate data access. The system maps file views inde-
                              pendently to each process's virtual address space, but the data is located in the same
                              frames in main memory. This minimizes the necessity of reading data from the disk.
                              The VMM treats file mappings the same way it treats copy-on-write pages (see
                              Section 21.7.1, Memory Organization). Because the VMM has been optimized to
                              deal with paging, file access is efficient. Due to its efficient implementation, file
                              mapping has uses beyond communication. Processes can use file mapping to per-
                              form random and sequential I/O quickly. File mapping is also helpful for databases
                              that need to overwrite small sections of large files.357, 358
                                     File mapping objects do not provide synchronization mechanisms to protect
                              the files they map. Two processes can overwrite the same portion of the same file
                              simultaneously. To prevent race conditions, processes must use synchronization
                              mechanisms, such as mutexes and semaphores, that are provided by Windows XP
                              and described in Section 21.6.3, Thread Synchronization.359


                              21.10.4 Local and Remote Procedure Calls
                              Many IPC mechanisms facilitate data exchange between two processes. Local pro-
                              cedure calls (LPCs) and remote procedure calls (RPCs), which we described in
                              Section 17.3.2, provide a more procedural form of IPC and largely hide the underly-
                              ing network programming. LPCs and RPCs allow a process to communicate with
                              another process by calling functions executed by the other process.360 The process
                              that calls the function is the client process, and the one that executes the function is
                              the server process.

<!-- pág. 1145 -->

                                                                             21. 10 Interprocess Communication 1095

       When client and server processes reside on the same physical machine, pro-
cesses execute LPCs; when they reside on separate machines, processes execute
RPCs.361A designer employs LPCs and RPCs the same as procedure calls within a
process. However, in some cases, the programmer takes a few extra steps to estab-
lish a connection (these are described shortly).
      Note that Microsoft does not publicly document the LPC interface, and user-
mode threads cannot expose LPCs. The system reserves LPCs for use by the Win-
dows XP kernel. For example, when a user thread calls a function in an environment
subsystem's API, the kernel might convert the call into an LPC. Also, Windows XP
converts RPCs between two processes on the same machine (called local remote
procedure calls or LRPCs) into LPCs, because LPCs are more efficient.362 LPCs
have less overhead than RPCs, because all data transfers using LPCs involve direct
memory copying rather than network transport.363 Although the name "local remote
procedure call" might sound like an oxymoron, it is simply a descriptive name for a
procedure call made with the RPC interface between local processes.
      Figure 21.16 describes the path through which data travels during an LPC or
RPC call. In both an RPC and an LPC, the client process calls a procedure that maps
to a stub (1). This stub marshals the necessary function arguments (i.e., gathers the
function arguments into a message to send to the server) and converts them to Net-
work Data Representation (NDR), which is a standard network data format,
described in The Open Group's Distributed Computing Environment (DCE) stan-
dard (2).364, 365 Next, the stub calls the appropriate functions from a runtime library to
send the request to the server process. The request traverses the network (in the case
of an RPC) to reach the server-side runtime library (3), which passes the request to




Figure 21.16 | Flow of an LPC or RPC call.

<!-- pág. 1146 -->

1096 Case Study: Windows XP
                              the server stub (4). The server stub unmarshals the data (i.e., converts the client's
                              message into a call to the intended procedure) for the server function (5). The server
                              process executes the requested function and sends any return values to the client via
                              the reverse path (6 through 10).366 Developers can employ RPCs using many differ-
                              ent transport and network protocols such as TCP/IP and Novell Netware's Internet-
                              working Packet eXchange/Sequenced Packet eXchange (IPX/SPX).367 Both client
                              processes and server processes can execute RPCs either synchronously or asynchro-
                              nously, and the communicating processes need not use the same method.368

                              Cliend and Server Communication in an RPC
                              To expose a procedure as an RPC, the server process must create an Interface Def-
                              inition Language (IDL) file. This file specifies the interfaces that the RPC server
                              presents to other processes.369 The developer writes the interface in Microsoft IDL
                              (MIDL), which is Microsoft's extension of IDL—The Open Group's Distributed
                              Computing Environment (DCE) standard for RPC interoperability. 370 The IDL file
                              consists of a header and an interface body. The header describes information global
                              to all interfaces defined in the body such as the universally unique identifier
                              (UUID) for the interface and an RPC version number. 371 The body contains all
                              variable and function prototype declarations. The MIDL compiler builds the client
                              and server stubs from the IDL file.372 The server and client also can create applica-
                              tion configuration files (ACFs), which specify platform-specific attributes, such as
                              the manner in which data should be marshalled or unmarshalled. 373
                                    The physical communication in an RPC is accomplished through an endpoint
                              that specifies the network-specific address of the server process and is typically a
                              hardware port or named pipe. The server creates an endpoint before exposing the
                              RPC to other processes.374 Client-side runtime library functions are responsible for
                              establishing a binding to this endpoint, so that a client can send a request to the
                              server. A binding is a connection between the client and the server. To create a bind-
                              ing, the client process must obtain a binding handle, which is a data structure that
                              stores the connection information.375 The binding handle stores such information as
                              the name of the server, address of the endpoint and the protocol sequence.376 The
                              protocol sequence specifies the RPC protocol (e.g., connection-oriented, LRPC), the
                              transport protocol (e.g., TCP) and the network protocol (e.g., IP). 377
                                    Windows XP supports three types of binding handles: automatic, implicit and
                              explicit handles. Using an automatic handle, the client process calls the remote
                              function, and the stub manages all the communication tasks. Implicit handles per-
                              mit the client process to specify the particular server to use with an RPC, but once
                              the client process passes the handle to the runtime library functions, it no longer
                              needs to manage the handle. With explicit handles, the client process must specify
                              the binding information as well as create and manage the handle. 378 This extra con-
                              trol permits client processes using explicit handles to connect to more than one
                              server process and simultaneously execute multiple RPCs. 379
                                    Communication via an LPC is similar to an RPC, although some steps are
                              omitted. The server must still create an IDL file, which is compiled by a MIDL

<!-- pág. 1147 -->

                                                                            21.10 Interprocess Communication 1097
compiler. The client process must include the client-side runtime library with the
file that calls the LPC. The stub handles the communication, and the client and
server processes communicate over a port for procedure calls that involve small
data transfers. Procedure calls in which processes transfer a large amount of data
must use shared memory. In this case, the sender and receiver place message data
into a section of shared memory.380


21.10.5 Component Object Model (COM)
Microsoft's Component Object Model (COM) provides a software architecture
allowing interoperability between diverse software components. In the COM archi-
tecture, the relative location of two communicating components is transparent to
the programmer and can be in process, cross process or cross network. COM is not
a programming language, but a standard designed to promote interoperability
between components written in different programming languages. COM also is
implemented on some flavors of UNIX and Apple Macintosh operating systems.
Developers use COM to facilitate cooperation and communication between sepa-
rate components in large applications.381
      COM objects (a COM object is the same as a COM component) interact indi-
rectly and exclusively through interfaces.382 A COM interface, which is written in
MIDL, is similar to a Java interface; it contains function prototypes that describe
function arguments and return values, but does not include the actual implementa-
tion of the functions. As with Java, a COM object must implement all of the meth-
ods described in the interface and can implement other methods as well.383 Once
created, a COM interface is immutable (i.e., it cannot change). A COM object can
have more than one interface; developers augment COM objects by adding a new
interface to the object. This permits clients dependent on the old features of a COM
object to continue functioning smoothly when the object is upgraded. Each inter-
face and object class possesses a globally unique ID (GUID), which is a 128-bit
integer that is, for all practical purposes, guaranteed to be unique in the world.
Interface IDs (IIDs) are GUIDs for interfaces, and class IDs (CLSIDs) are GUIDs
for object classes. Clients refer to interfaces using the IID, and because the interface
is immutable and the IID is globally unique, the client is guaranteed to access the
same interface each time.384
      COM promotes interoperability between components written in diverse lan-
guages by specifying a binary standard (i.e., a standard representation of the object
after it has been translated into machine code) for calling functions. Specifically,
COM defines a standard format for storing pointers to functions and a standard
method for accessing the functions using these pointers. 385 Windows XP, and other
operating systems with COM support, provide APIs for allocating and deallocating
memory using this standard. The COM library in Windows XP provides a rich vari-
ety of support functions that hide most of the COM implementations. 386
      COM servers can register their objects with the Windows XP registry. Clients
can query the registry using the COM object's CLSID to obtain a pointer to the

<!-- pág. 1148 -->

1098 Case Study: Windows XP

                          COM object.387 A client can also obtain a pointer to a COM object's interface from
                          another COM object or by creating the object. A client can use a pointer to any
                          interface for a COM object to find a pointer to any other interface that the COM
                          object exposes.388
                                 Once the client obtains a pointer to the desired interface, the client can exe-
                          cute a function call to any procedure exposed by this interface (assuming the client
                          has appropriate access rights). For in-process procedure calls, COM executes the
                          function directly, adding essentially no overhead. For cross-process procedure calls
                          in which both processes reside on the same computer, COM uses LRPCs (see
                          Section 21.10.4, Local and Remote Procedure Calls), and Distributed COM
                          (DCOM) supports cross-network function calls.389 COM marshals and unmarshals
                          all data, creates the stubs and proxies (proxies are client-side stubs) and transports
                          the data (via direct execution, LRPCs or DCOM).390
                                COM supports several threading models a process can employ to maintain its
                          COM objects. In the apartment model, only one thread acts as a server for each
                          COM object. In the free thread model, many threads can act as the server for a sin-
                          gle COM object (each thread operates on one or more instances of the object). A
                          process can also use the mixed model in which some of its COM objects reside in
                          single apartments and others can be accessed by free threads. In an apartment
                          model, COM provides synchronization by placing function calls in the thread's win-
                          dow message queue. COM objects that can be accessed by free threads must main-
                          tain their own synchronization (see Section 21.6.3, Thread Synchronization, for
                          information on thread synchronization).391
                                Microsoft has built several technologies on top of COM to further facilitate
                          cooperation in component software design. COM+ extends COM to handle
                          advanced resource management tasks; e.g., it provides support for transaction pro-
                          cessing and uses thread pools and object pools, which move some of the responsibil-
                          ity for resource management from the component developer to the system.392
                          COM+ also adds support for Web services and optimizes COM scalability.393 Dis-
                          tributed COM (DCOM) provides a transparent extension to basic COM services
                          for cross-network interactions and includes protocols for finding DCOM objects on
                          remote services.394 Object Linking and Embedding (OLE), discussed in the next
                          section, builds on COM to provide standard interfaces for applications to share
                          data and objects. ActiveX Controls are self-registering COM objects (i.e., they
                          insert entries in the registry upon creation). Typically, ActiveX Controls support
                          many of the same embedding interfaces as OLE objects; however, ActiveX Con-
                          trols do not need to support all of them. This makes ActiveX Controls ideal for
                          embedding in Web pages because they have less overhead.395

                          21.10.6 Drag-and-Drop and Compound Documents
                          Windows XP provides several techniques that enable users to initiate IPC. A famil-
                          iar example is permitting users to select text from a Web page, copy this text and
                          paste it into a text editor. Users can also embed one document inside another; e.g., a

<!-- pág. 1149 -->

                                                                                              21.11 Networking 1099
user could place a picture created in a graphical design program into a word pro-
cessing document. In both of these cases, the two applications represent different
processes that exchange information. Windows XP provides two primary tech-
niques for this type of data transport: the clipboard and Object Linking and
Embedding (OLE).
      The clipboard is a central repository of data, accessible to all processes.396 A
process can add data to the clipboard when the user invokes either the copy or the
cut command. The selected data is stored in the clipboard along with the data's for-
mat.397 Windows XP defines several standard data formats, including text, bitmap
and wave. Processes can register new clipboard formats, create private clipboard
formats and synthesize one or more of the existing formats.398 Any process can
retrieve data from the clipboard when the user invokes the paste command.399
Conceptually, the clipboard acts as a small area of globally shared memory.
      OLE builds on COM technology by defining a standard method for processes
to exchange data. All OLE objects implement several standard interfaces that
describe how to store and retrieve data for an OLE object, how to access the object
and how to manipulate the object. Users can create compound documents—docu-
ments with objects from more than one application—either by linking outside objects
or embedding them. When a document links an object from another source, it does
not maintain the object inside its document container (the document container pro-
vides storage for the document's objects and methods for manipulating and viewing
these objects). Rather, the document maintains a reference to the original object. The
linked object reflects updates made by the server process to the object. Embedding
an object places it, along with the interfaces for manipulating the object, inside the cli-
ent document. The linked or embedded object is a COM component complete with a
set of interfaces that the client can use to manipulate the object.400



21.11 Networking
Windows XP supports many networking protocols and services. Developers employ
networking services to accomplish IPC with remote clients and make services and
information available to users. Users exploit networks to retrieve information and
access resources available on remote computers. This section investigates various
aspects of Windows XP's networking model. We examine network I/O and the
driver architecture employed by Windows XP. We consider the network, transport
and application protocols supported by Windows XP. Finally, we describe the net-
work services that Windows XP provides, such as the Active Directory and .NET.

21.11.1 Network Input/Output
Windows XP provides a transparent I/O programming interface. In particular, pro-
grammers use the same functions regardless of where the data reside. However, the
Windows XP system must handle network I/O differently than local I/O.401

<!-- pág. 1150 -->

1100 Case Study: Windows XP

                                     Figure 21.17 illustrates how Windows XP handles a network I/O request. The
                              client contains a driver called a redirector (or network redirector).402 A redirector is
                              a file system driver that directs network I/O requests to appropriate devices over a
                              network.403 First, the client process passes an I/O request to an environment sub-
                              system (1). The environment subsystem then sends this request to the I/O manager
                              (2), which packages the request as an IRP, specifying the file's location in Uniform
                              Naming Convention (UNC) format. UNC format specifies the file's pathname,
                              including on which server and in which directory on that server the file is located.
                              The I/O manager sends the IRP to the Multiple UNC Provider (MUP), which is a
                              file system driver that determines the appropriate redirector to which to send the
                              request (3). Later in this section we see that Windows XP ships with two file sharing
                              protocol, CIFS and WebDAV, which use different redirectors. After the redirector
                              receives the IRP (4), the redirector sends the request over the network to the
                              appropriate server file system driver (5). The server driver determines whether the
                              client has sufficient access rights for the file, then communicates the request to the
                              target device's driver stack via an IRP (6). The server driver receives the result of
                              the I/O request (7). If there is an error processing the request, the server driver
                              informs the client. Otherwise, the server driver passes the data back to the redirec-
                              tor (8), and this data is passed to the client process (9).404,405
                                     The Common Internet File System (CIFS) is Windows XP's native file sharing
                              protocol. CIFS is used for the application layer of the TCP/IP stack (see Section 16.4,




                              Figure 21.17 | Handling & network I/O request.

<!-- pág. 1151 -->

                                                                                          21.11 Networking 1101

TCP/IP Protocol Stack). VMS and several varieties of UNIX also support CIFS.
Developers often pair CIFS with NetBIOS (discussed later in this section) over TCP/
IP for the network and transport layers, but CIFS can use other network and trans-
port protocols as well.406 CIFS is meant to complement HTTP and replace older file
sharing protocols such as FTP.407 Windows XP also supports other network file shar-
ing protocols such as Web-based Distributed Authoring and Versioning (WebDAV).
WebDAV allows users to write data directly to HTTP servers and is designed to sup-
port collaborative authoring between groups in remote locations.408
      To share files using CIFS, the client and server must first establish a connec-
tion. Before a client can access a file, the client and server connect, and the server
authenticates the client (see Section 19.3, Authentication) by evaluating the user-
name and password sent by the client. The redirectors interact to set up the session
and transfer data.409 CIFS provides several types of opportunistic locks (oplocks) to
enhance I/O performance. A client uses an oplock to secure exclusive access to a
remote file. Without one of these oplocks, a client cannot cache network data
locally, because other clients also might be accessing the data. If two clients both
cache data locally and write to this data, their caches will not be coherent (see
Section 15.5, Multiprocessor Memory Sharing). Therefore, a client obtains an
oplock to ensure that it is the only client accessing the data.410 When a second client
attempts to gain access to the locked file (by attempting to open it), the server may
break (i.e., invalidate) the first client's oplock. The server allows the client enough
time to flush its cache before granting access to the second client.411


21.11.2 Network Driver Architecture
Windows XP uses a driver stack to communicate network requests and transmit
network data. This driver stack is divided into several layers, which promotes mod-
ularity and facilitates support for multiple network protocols. This subsection
describes the low-level driver architecture employed in Windows XP.
      Microsoft and 3Com developed the Network Driver Interface Specification
(NDIS), which specifies a standard interface between lower-level drivers in the net-
work driver stack. NDIS drivers provide the functionality of the link layer and
some functionality of the network layer of the TCP/IP protocol stack (see
Section 16.4, TCP/IP Protocol Stack). 412 NDIS drivers communicate through func-
tions provided in Windows XP's NDIS library. The NDIS library functions translate
one driver's function call into a call to a function exposed by another driver. This
standard interface increases the portability of NDIS drivers.413 NDIS allows the
same programming interface (e.g., Windows sockets, see Section 21.11.3, Network
Protocols) to establish connections using different network protocols, such as IP
and Internet Packet eXchange (IPX). 414
      Figure 21.18 illustrates the architecture that Windows XP employs to process
network data. Windows XP divides the network architecture into three layers that
map to layers of the TCP/IP protocol stack. The physical network hardware, such as
the network interface card (NIC) and the network cables, form the physical layer.

<!-- pág. 1152 -->

1102 Case Study: Windows XP




                         Figure 21.18 | Networking driver architecture.

                          NDIS drivers (described in the following paragraphs) manage the data link and net-
                          work layers. Transport Driver Interface (TDI) drivers and TDI clients compose the
                          top layer. The TDI drivers provide a transport interface between NDIS drivers and
                          TDI clients. TDI clients are low-level application drivers and might interact with
                          other application-layer drivers.
                                Designers implement the NDIS layer with several drivers. An NDIS miniport
                          driver manages the NIC and transmits data between the NIC and higher-level driv-
                          ers. The miniport driver interfaces with the drivers above it in the driver stack to
                          transmit outgoing network data to the NIC. An upper-level driver invokes an NDIS
                          function that passes the packet to the miniport driver, and the miniport driver
                          passes the data to the NIC. The miniport driver also processes the NIC's interrupts
                          and passes data that the NIC receives up the driver stack.415

<!-- pág. 1153 -->

                                                                                        21.11 Networking 1103

      NDIS intermediate drivers are optional drivers that reside between a miniport
driver and a higher-level driver. Intermediate drivers translate packets between dif-
ferent communication media, filter packets or provide load balancing across several
NICs.416
      NDIS protocol drivers are the highest-level NDIS drivers. Protocol drivers
place data into packets and pass these packets to lower-level drivers (such as inter-
mediate drivers or miniport drivers). Protocol drivers provide an interface between
the transport drivers and other NDIS drivers and can be used as the lowest layer in
the implementation of a transport protocol stack (such as TCP/IP). 417
      The NDIS protocol driver interacts with TDI drivers. A TDI driver exports a
network interface to upper-level kernel-mode clients. The redirectors described in
the previous subsection are TDI clients. Winsock applications (described in the next
subsection) also are TDI clients. TDI drivers implement transport protocols such as
UDP and TCP; NDIS protocol drivers often implement the network protocol (e.g.,
IP). Alternatively, a TDI transport driver can implement both the network and
transport protocols. Upper-level kernel-mode drivers send network requests to TDI
drivers.418 These drivers implement the application layer of the TCP/IP protocol
stack. The next subsections describe the various protocols and network services
available to Windows XP applications.


21.11.3 Network Protocols
Windows XP supports several different protocols for the network, transport and
application layers of the TCP/IP stack. Windows XP supports some of these proto-
cols to provide compatibility with popular legacy programs or other network clients.

Network and Transport Protocols
IP is installed by default on Windows XP systems; IP provides routing for packets
traversing a network and is the Internet's network protocol. Users can install other
network protocols, such as the Internetwork Packet exchange (IPX) protocol,
which is used by Novell's Netware. 419 IPX provides services similar to IP; IPX
routes packets between different locations in a network, but is designed for
LANs. 420 Because the NDIS library supports a standard interface between protocol
drivers and NICs, Windows XP can use the same NIC to operate both protocols. 421
      Windows XP also supports several transport protocols. TCP, by far the most
commonly used transport protocol, is installed by default. TCP provides a connec-
tion-oriented transport; i.e., the participants of a network communication must cre-
ate a session before communicating.422 For connectionless transport, Windows XP
supports UDP. 423 Users can also install support for Sequenced Packet eXchange
(SPX), which offers connection-oriented services for IPX packets. Windows XP
provides SPX for interoperability with clients and servers using IPX/SPX protocols,
such as Netware, 424
      Before the explosion of interest in the Internet and World Wide Web, the
DOS and Windows operating systems supported NetBIOS Extended User Inter-

<!-- pág. 1154 -->

1104 Case Study: Windows XP

                              face (NetBEUI) as the native network and transport protocols. Network Basic
                              Input/Output System (NetBIOS) is the programming API that supports NetBEUI.
                              NetBEUI is a fairly primitive protocol most applicable for small networks. It has
                              several limitations; for example, it does not provide for network connection routing
                              outside a LAN. 425 Windows XP does not provide support for NetBEUI, although
                              support can be manually installed by a user.
                                    However, NetBIOS over TCP/IP (NBT) is still supported by Windows XP to
                              provide compatibility with old applications that employ the NetBIOS API. 426 Net-
                              BIOS layered over TCP and IP provides connection-oriented communication using
                              NBT. Alternatively, developers can layer NetBIOS over UDP and IP for connec-
                              tionless communication using NBT. CIFS is commonly used with NBT as the
                              underlying network and transport protocols. However, in Windows XP, CIFS can
                              execute over TCP/IP without NetBIOS encapsulation. 427

                              Application Layer Protocols
                              At the application layer, Windows XP supports HTTP for Web browsing and CIFS
                              for file and print sharing. For HTTP support, Windows XP provides WinHTTP and
                              WinlNet. WinHTTP supports communication between clients and servers over an
                              HTTP session. It provides SSL security and is integrated with Microsoft Passport
                              (see Section 19.3.4, Single Sign-On). WinHTTP also provides other HTTP services,
                              such as tracing and Kerberos authentication (see Section 19.3.3, Kerberos) and
                              allows synchronous and asynchronous communication.428 WinlNet is an older API
                              that allows applications to interact with the FTP, HTTP and Gopher protocols to
                              access resources over the Internet.429 WinlNET is designed for client applications,
                              whereas WinHTTP is ideal for servers.430
                                     CIFS, described in the previous section, is an extension of the Server Message
                              Block (SMB) file sharing protocol. SMB is the native file sharing protocol of older
                              Windows operating systems such as Windows NT and Windows 95. SMB uses Net-
                              BIOS to communicate with other computers in a virtual LAN. A virtual LAN con-
                              sists of computers that share the same NetBIOS namespace; the computers can be
                              anywhere in the world. To share files with SMB, two computers on the same virtual
                              LAN set up an SMB session; this includes acknowledging the connection, authenti-
                              cating the identity of both parties and determining the access rights of the client.
                              CIFS extends SMB, adding a suite of protocols that improve access control and han-
                              dle announcing and naming of network resources. The familiar My Network Places
                              program included with Windows XP allows users to share files through CIFS.431

                              Winsock
                              Windows XP supports network communication through sockets. Windows sockets 2
                              (Winsock 2) is an application of BSD sockets (see Section 20.10.3, Sockets) to the
                              Windows environment. Sockets create communication endpoints that a process can
                              use to send and receive data over a network.432 Sockets are not a transport protocol;
                              consequently, they need not be used at both ends of a communication connection.
                              Developers can layer Winsock 2 on top of any transport and network protocols (e.g.

<!-- pág. 1155 -->

                                                                                              21.11   Nefworking   1105

TCP/IP or IPX/SPX). Users can port code written for UNIX-style sockets to Win-
sock applications with minimal changes. However, Winsock 2 includes extended
functionality that might make porting an application from Windows XP to a UNIX-
based operating system implementing Berkeley sockets difficult.433, 434
       The Winsock specification implements many of the same functions that Ber-
keley sockets implement to provide compatibility with Berkeley socket applica-
tions. As with Berkeley sockets, a Windows socket can be either a stream socket or
a datagram socket. Recall that stream sockets provide reliability and packet order-
ing guarantees.435 Winsock adds extra functionality to sockets, such as asynchronous
I/O, protocol transparency (i.e., developers can choose the network and transport
protocols to use with each socket) and quality-of-service (QoS) capabilities.436 The
latter provide to processes information about network conditions and the success or
failure of socket communication attempts.437

21.11.4 Network Services
Windows XP includes various network services that allow users to share informa-
tion, resources and objects across a network. Active Directory provides directory
services for shared objects (e.g., files, printers, services, users, etc.) on a network.438
Its features include location transparency (i.e., users do not know the address of an
object), hierarchical storage of object data, rich and flexible security infrastructure
and the ability to locate objects based on different object properties.439
      Lightweight Directory Access Protocol (LDAP) is a protocol for accessing,
searching and modifying Internet directories. An Internet directory contains a list-
ing of computers or resources accessible over the Internet. LDAP employs a client/
server model.440 LDAP clients can access an Active Directory.441
      Windows XP provides Remote Access Service (RAS), which allows users to
remotely connect to a LAN. The user must be connected to the network through a
WAN or a VPN. Once the user connects to the LAN through RAS, the user oper-
ates as though directly on the LAN.442
      Support for distributed computing on Windows XP is provided through the
Distributed Component Object Model (DCOM) and .NET. DCOM is an extension
of COM, which we described in Section 21.10.5, Component Object Model (COM),
for processes that share objects across a network. Constructing and accessing
DCOM objects is done just as with COM objects, but the underlying communica-
tion protocols support network transport. For information on using DCOM for dis-
tributed computing see Section 17.3.5, DCOM (Distributed Component Object
Model).443 The next section introduces .NET.


21.11.5 .NET
Microsoft has developed a technology called .NET, which supplants DCOM for dis-
tributed computing in newer applications. .NET is aimed at transforming computing
from an environment where users simply execute applications on a single computer
to a fully distributed environment. In this computing model, local applications com-

<!-- pág. 1156 -->

1106 Case Study: Windows XP

                              municate with remote applications to execute user requests. This contrasts with the
                              traditional view of a computer as merely fulfilling a single user's requests. .NET is a
                              middleware technology, which provides a platform- and language-neutral develop-
                              ment environment for components that can easily intemperate.444, 445
                                    Web services are the foundation of .NET; they encompass a set of XML-based
                              standards that define how data should be transported between applications over
                              HTTP. Because of XML's large presence in this technology, .NET Web services are
                              often called XML Web services. Developers use Web services to build applications
                              that can be accessed over the Internet. Web service components can be exposed over
                              the Internet and used in many different applications (i.e., Web services are modular).
                              Because XML messages (which are sent and retrieved by Web services) are simply
                              text messages, any application can retrieve and read XML messages. Web services
                              make .NET interoperable and portable between different platforms and languages.446
                                    The .NET programming model is called the .NET framework. This framework
                              provides an API which expands on the Windows API to include support for Web
                              services. The .NET framework supports many languages, including Visual Basic
                              .NET, Visual C++ .NET and C#. The .NET framework facilitates development of
                              .NET Web services.447
                                    .NET server components include Web sites and .NET enterprise servers, such
                              as Windows Server 2003. Many Web service components that home users access are
                              exposed on these two platforms. Although desktop operating systems, such as Win-
                              dows XP, or server systems running Windows XP can expose Web services, Win-
                              dows XP systems are mainly consumers (i.e., clients) of .NET services.448-449


                              21.12 Scalability
                              To increase Windows XP's flexibility, Microsoft developed several editions. For
                              example, Windows XP Home Edition is tailored for home users, whereas Windows
                              XP Professional is more applicable in a corporate environment. Microsoft has also
                              produced editions of Windows XP to address scalability concerns. Although all edi-
                              tions of Windows XP support symmetric multiprocessing (SMP), Windows XP 64-
                              Bit Edition is specifically designed for high-performance desktop systems, which
                              are often constructed as SMP systems (see Section 15.4.1, Uniform Memory
                              Access). Additionally, Microsoft has developed an embedded operating system
                              derived from Windows XP, called Windows XP Embedded. An embedded system
                              consists of tightly coupled hardware and software designed for a specific electronic
                              device, such as a cellular phone or an assembly-line machine. This section describes
                              the features included in Windows XP to facilitate scaling up to SMP systems and
                              down to embedded systems.

                              21.12.1 Symmetric Multiprocessing (SMP)
                              Windows XP scales to symmetric multiprocessor (SMP) systems. Windows XP sup-
                              ports multiprocessor thread scheduling, locking the kernel, a 64-bit address space

<!-- pág. 1157 -->

                                                                                           21.12 Scalability 1107

(in Windows XP 64-Bit Edition) and API features that support programming server
applications.
      Windows XP can schedule threads efficiently on multiprocessor systems, as
described in Section 21.6.2, Thread Scheduling. Windows XP attempts to schedule a
thread on the same processor on which it recently executed to exploit data cached
on a processor's private cache. The system also uses the ideal processor attribute to
increase the likelihood that a process's threads execute concurrently, thus increas-
ing performance. Alternatively, developers can override this default and use the
ideal processor attribute to increase the likelihood that a process's threads execute
on the same processor to share cached data. 450
      Windows XP implements spin locks (described in Section 21.6.3, Thread Syn-
chronization), which are kernel locks designed for multiprocessor systems. Specifi-
cally, the queued spin lock decreases traffic on the processor-to-memory bus,
increasing Windows XP's scalability.451 In addition, as the original NT kernel has
evolved (recall that Windows XP is NT 5.1), designers have reduced the size of crit-
ical sections, which reduces the amount of time a processor is busy waiting to obtain
a lock. Sometimes, a processor cannot perform other work when waiting for a spin
lock, such as when a processor needs to execute thread scheduling code. Reducing
the size of this critical section increases Windows XP's scalability.452 Additionally,
Windows XP provides a number of other fine-grained locks (e.g., dispatcher objects
and executive resource locks), so that developers need only lock specific sections of
the kernel, allowing other components to execute without disruption. 453
      Memory support for large SMP systems emanates from Windows XP 64-Bit
Edition. 64-bit addressing provides 2 64 bytes (or 16 exabytes) of virtual address
space; this contrasts with 2 32 bytes (or 4 gigabytes) for 32-bit versions of Windows
XP. In practice, Windows XP 64-Bit Edition provides processes with 7152GB of vir-
tual memory address range. 454 Windows XP 64-Bit Edition currently supports up to
1 terabyte of cache memory, 128 gigabytes of paged system memory and 128
gigabytes of nonpaged pool. Windows XP 64-Bit Edition has been ported to Intel
Itanium II processors, which are described in Section 14.8.4, Explicitly Parallel
Instruction Computing (EPIC) 455 . Soon (as of this writing), Microsoft plans to
release Windows XP 64-Bit Edition for Extended Systems to support AMD
Opteron and Athlon 64 processors.456 The 64-bit editions of Windows also offer
greater performance and precision when manipulating floating point numbers,
because these systems store floating point numbers using 64 bits.457
      Finally, Windows XP has added several programming features tailored for
high-performance systems, which is an environment in which many SMP systems are
employed. The job object (described in Section 21.6.1, Process and Thread Organiza-
tion) allows servers to handle resource allocation to a group of processes. In this way,
a server can manage the resources it commits to a client request. 458 Also, I/O com-
pletion ports (described in Section 21.9.2, Input/Output Processing) facilitate the
processing of large numbers of asynchronous I/O requests. In a large server pro-
gram, many threads might issue asynchronous I/O requests; I/O completion ports

<!-- pág. 1158 -->

provide a central area where dedicated threads can wait and process incoming I/O
completion notifications.459 Additionally, thread pools (described in Section 21.6.1,
Process and Thread Organization) permit server processes to handle incoming client
requests without the costly overhead of creating and deleting threads for each new
request. Instead, these requests can be queued to the thread pool.460

21.12.2 Windows XP Embedded
Microsoft has created an operating system called Windows XP Embedded, which
scales Windows XP for embedded devices. Microsoft divides Windows XP into
clearly defined functional units called components. Components range from user-
mode applications such as Notepad to portions of kernel space such as the CD-
ROM interface and power management tools. The designer of a Windows XP
Embedded system chooses from over 10,000 components to customize a system for
a particular device.461 Components for Windows XP Embedded contain the same
code as Windows XP Professional, providing full compatibility with Windows XP.
Windows XP Embedded also contains the core Windows XP microkernel.462
      Windows XP Embedded is designed for more robust embedded devices such
as printers, routers, point-of-sale systems and digital set-top boxes. Microsoft pro-
vides a different operating system, Windows CE, for lighter devices such as cellular
phones and PDAs. The goal of Windows XP Embedded is to allow devices with lim-
ited resources to take advantage of the Windows XP computing environment.463
      Devices such as medical devices, communication equipment and manufactur-
ing equipment would benefit from Windows XP Embedded, but require hard real-
time guarantees. Recall from Section 8.9, Real-Time Scheduling, the difference
between soft real-time scheduling (like that provided by Windows XP) and hard
real-time scheduling. Soft real-time scheduling assigns higher priority to real-time
threads, whereas hard real-time scheduling provides guarantees that, given a start
time, a thread will finish by a certain deadline. Venturcom464 has designed a Real-
Time Extension (RTX) for Windows XP Embedded and Windows XP. RTX
includes a new threading model (implemented as a device driver), a collection of
libraries and an extended HAL. Venturcom's RTX achieves hard real-time goals by
masking all non-real-time interrupts when real-time threads execute, never mask-
ing real-time interrupts (recall that interrupt masking is accomplished through the
HAL) and enforcing strict thread priorities. For example, threads waiting for syn-
chronization objects, such as mutexes and semaphores, are placed in the ready state
in priority order (as opposed to FIFO order). RTX implements 128 priority levels
to increase scheduling flexibility.


21.13 Security
Any operating system aimed at the corporate market must offer substantial security
capabilities. Windows XP Professional provides a wide variety of security services
to its users, whereas Windows XP Home Edition has a slightly more limited range
and is targeted at consumers with simple security needs. The following subsections

<!-- pág. 1159 -->

                                                                                         21.13   Security   1109

describe security in Windows XP Professional. Much of the information, especially
non-networking related material, applies to Windows XP Home Edition as well.
      Windows XP provides users with a range of authentication and authorization
options that permit access a physical terminal, a local network or the Internet. A
database of users' credentials helps provide users with single sign-on; once a user
logs onto Windows XP, the system takes care of authenticating the user to other
domains and networks without prompting for credentials. The operating system
includes a built-in firewall (see Section 19.6.1, Firewalls) that protects the system
from malicious access.


21.13.1 Authentication
Windows XP has a flexible authentication policy. Users provide the system with cre-
dentials which consists of their identity (e.g. username) and proof of identity (e.g.
password). For local access, the system authenticates a user's credentials against the
Security Account Manager (SAM) database. A designated computer, called the
domain controller, handles remote authentication. The native authentication sys-
tem for network access is Kerberos V5 (see Section 19.3.3, Kerberos). Windows XP
also supports the NT LanMan (NTLM) authentication protocol for backward com-
patibility with domain controllers running NT 4.O.465
      Authentication begins at a logon screen; this can be either the standard logon
program (called MSGINA) or a third-party Graphical Identification and Authentica-
tion (GINA) DLL. 466 GINA passes the user's username and password to the Winl-
ogon program, which passes the credentials to the Local Security Authority (LSA).
The LSA is responsible for handling all authentication and authorization for users
physically accessing that particular machine.467
      If the user is logging on only to the local machine, the LSA verifies the user's
credentials with the local SAM database. Otherwise, the LSA passes the credentials
over the network to the domain controller (the computer responsible for handling
authentication) via the Security Support Provider Interface (SSPI). This is a stan-
dard interface for obtaining security services for authentication that is compatible
with both Kerberos V5 and NTLM. The domain controller first attempts to authen-
ticate using Kerberos, which verifies credentials using the Active Directory. If Ker-
beros fails, GINA resends the username and password. This time the domain
controller attempts to authenticate via the NTLM protocol, which relies on a SAM
database stored on the domain controller. If both Kerberos and NTLM fail, GINA
prompts the user to reenter the username and password.468, 469 Figure 21.19 illus-
trates the authentication process.
      Computers, especially mobile ones such as laptops, often use different creden-
tials to connect to different domains. This is done for security reasons; if one
domain is compromised, accounts on the other domains remain secure.(Windows
XP lets users store domain-specific credentials in Stored User Names and Pass-
words. Upon an authentication error, the LSA first attempts to authenticate using a
saved credential for that domain. Upon failure, the LSA activates the GINA screen

<!-- pág. 1160 -->

1110 Case Study: Windows XP




                              Figure 21.19 | Authentication process in a Windows XP network.

                              to prompt the user for a credential. The screen lets the user select a stored creden-
                              tial from a drop-down menu. The system records every credential that a user enters
                              to a GINA (as long as the user selects a box giving the system permission to do so).
                              In addition, users may use a special GUI to add, edit and remove credentials.470

                              21.13.2      Authorization
                              Any user, group, service or computer that performs an action in a Windows XP sys-
                              tem is considered a security principal. A user can set security permissions for any
                              security principal.471 It is often advantageous to place users with the same security
                              privileges into a security group, then set security permissions based on the security
                              group. Security groups can be nested and grouped to form larger security groups.
                              Using security groups simplifies managing the security policy for a large system.472
                                    The system assigns each security principal a unique security identifier (SID).
                              When a security principal logs on, the system uses the security principal's SID to
                              assign an access token. The access token stores security information about the secu-
                              rity principal, including its SID, the SID of all groups to which the security principal
                              belongs and the default access control list (see Section 19.4.3, Access Control
                              Mechanisms) to assign to all objects the security principal creates. The system
                              attaches a copy of the access token to every process and thread that the security
                              principal runs. The system uses a thread's access token to verify that the thread is
                              authorized to perform a desired action.473
                                    Windows XP uses access tokens to implement fast user switching—enabling a
                              new user to log on without logging off the current user. (Fast user switching works
                              only on computers that are not members of a domain). Often, especially in home
                              environments, a user may start a long-running process, then leave the computer to

<!-- pág. 1161 -->

                                                                                          21.13 Security 1111

execute unattended. Fast user switching permits another person to log on, run pro-
grams, check e-mail, play a game, and so on. The first user's processes continue exe-
cuting in the background; however, this is transparent to the new user. An access
token stores a session ID that is unique to each logon session. The system uses the
access token attached to each thread and process to determine to which user a pro-
cess or thread belongs.474, 475
      Every resource, such as a file, folder or device, has a security descriptor that
contains the resource's security information. A descriptor contains the resource
owner's SID and a discretionary access control list (DACL) that determines which
security principals may access the resource. The DACL is an ordered list of access
control entries (ACEs); each ACE contains the SID of a security principal and the
type of access (if any) the security principal has to that particular resource. 476
      When a thread attempts to access a resource, Windows XP uses the thread's
access token and the resource's security descriptor to determine whether to permit
access. The system traverses the DACL and stops when it finds an ACE with a SID
that matches one of the SIDs in the access token. The thread is permitted to per-
form the requested operation only if the first matching ACE authorizes the action.
If the security descriptor has no DACL, access is granted; if the DACL has no
matching ACE, access is denied. 477
      Windows XP offers users flexibility in specifying the security policy of their
system. The main role of the operating system is to enforce the policy that its users
set. However, with so many options to choose from, an administrator might inad-
vertently create an insecure security policy. To prevent this, Windows XP includes
many useful features to help administrators maintain system security.
      Recall the notion of security groups mentioned at the start of the section.
Windows XP defines three basic security groups: Everyone (all authenticated secu-
rity principals), Anonymous (all unauthenticated security principals) and Guest (a
general-purpose account). System administrators can use these three security
groups as the building blocks of their security policy. In addition, Windows XP
includes several default security policies that administrators can employ as a start-
ing point for creating their own policy. In general, each default policy uses the high-
est level of security, and system administrators are responsible for increasing user
privileges. For example, by default, users who log on from a remote machine are
forced to use Guest privileges. Although this might be an annoyance, this policy is
preferable to inadvertently overlooking a security hole.478


21.13.3 Internet Connection Firewall
Windows XP has a built-in packet filtering firewall (see 18.6.1, Firewalls) called the
Internet Connection Firewall (ICF). This firewall can be used to protect either an
entire network or a single computer.479 ICF filters out all unsolicited inbound traf-
fic, with the exception of packets sent to ports explicitly designated as open. The
firewall stores information about all outgoing packets in a flow table. It permits an
incoming packet to enter the system only if there is an entry in the flow table corre-

<!-- pág. 1162 -->

1112 Case Study: Windows XP

                                     sponding to an outgoing packet sent to the home address of the incoming packet. 480
                                     ICF does not filter outgoing packets; it assumes that only legitimate processes
                                     would send an outgoing packet. (This can cause problems if a Trojan Horse pro-
                                     gram gains access to the system.)481
                                            ICF supports common Internet communication protocols such as FTP and
                                     LDAP. To permit applications to communicate with a Windows XP system via these
                                     protocols, ICF leaves certain ports open for all incoming traffic. Also, many applica-
                                     tions such as MSN Messenger and online games require an open port to run success-
                                     fully. Users and applications with administrative privileges can designate a particular
                                     port open for all incoming traffic; this process is called port mapping.482, 483

                                     21.13.4 Other Features
                                     Windows XP comes with many features that help keep the system secure. For exam-
                                     ple, users can encrypt files and folders using the Encrypting File System (see
                                     Section 21.8.2, NTFS, for more information). Users can control which Web sites may
                                     store cookies (small temporary files used by a server to store user-specific informa-
                                     tion) on their computer. Administrators can limit which applications may execute on
                                     the system; each application can be identified by its file hash, so that moving or
                                     renaming it would not bypass the restriction. Windows XP can also check whether
                                     the application is signed with a trusted certificate (i.e., a signature from an entity that
                                     the user specified as trustworthy) or comes from a trusted Internet Zone (i.e., an
                                     Internet domain that the user specified as safe).484 Users can use Automatic Update
                                     to get notification, or even installation, of the latest security patches.485




Web Resources
msdn.microsoft.com/library                                         www.microsoft.com/technet/prodtechnol/winxppro
The MSDN Library provides information about Microsoft              Microsoft TechNet provides technical information on
products and services, including the most recent platform Soft-    Microsoft products. This section is devoted to Windows XP
ware Development Kit (SDK) and Driver Development Kit              Professional; particularly useful is the Resource Kit (click
(DDK). Go to the menu on the left side of the screen and click     Resource Kits),
on Windows Development, followed by Windows Base Services,         www.winnetmag.com
to research the Windows XP SDK. To research the DDK, click         Publishes technical articles about Windows & .NET ranging
on Windows Development, followed by Driver Development             from introductions for novice users to in-depth internals
Kit. Particularly useful information can be found by next click-   descriptions for advanced developers.
ing Kernel-Mode Driver Architecture, followed by Design
                                                                   www.osronline.com
Guide. The MSDN Library also provides networking informa-
                                                                   Features technical articles and tutorials about the internals of
tion (click Networking and Directory Services) and COM infor-
                                                                   Windows operating systems. It offers online articles, as well as
mation (click Component Development).
                                                                   a free subscription to NT Insider, a technical magazine about
www.microsoft.com/windowsxp/default.asp                            the NT line of operating systems.
Microsoft's homepage for Windows XP. From here, the reader         www.extremetech.com/category2/0,3971,23445,00.asp
can find XP overviews, support information and gateways to         ExtremeTech's page for operating systems. It includes news
other areas of Microsoft with more technical information on        articles, some technical insight and a forum to discuss operat-
Windows XP.                                                        ing systems.

<!-- pág. 1163 -->

                                                                                                                 Key    Terms     1113

www.theeldergeek.com/index.htm                                         www.winsupersite.com
Describes Windows XP from the user's perspective, including            Provides updated information about Windows products. It
excellent information about the registry, system services and          evaluates them from both technical and user perspectives.
networking.                                                            developer.intel.com
                                                                       Provides technical documentation regarding Intel products,
www.windowsitlibrary.com
                                                                       including Pentium and Itanium processors. Their system pro-
Provides free articles and sells books and articles about Win-
                                                                       grammer guides (e.g., for the Pentium 4 processor, devel-
dows operating systems. Some of these articles and books pro-
                                                                       oper.intel.com/design/Pentium4/manuals/)               provide
vide technical internals information.
                                                                       information about how Intel processors interact with the oper-
www.sysinternals.com                                                   ating system,
Dedicated to providing internals information about Windows             developer.amd.com
operating systems, especially the NT line.                             Provides technical documentation regarding AMD products,
                                                                       including Athlon and Opteron processors. Their system pro-
msdn.microsoft.com/msdnmag/default.aspx                                grammer guides (e.g., for the Opteron processor,
The MSDN Magazine (formerly know as Microsoft Systems                  www.amd.com/us-en/Processors/DevelopWithAMD/
Journal) contains articles about Microsoft's products, targeted        0,,30_2252_739_7044,00.html) provide information about
for developers.                                                        how AMD processors interact with the operating system.




Key Terms
.NET—Microsoft initiative aimed at transforming computing              ActiveX Controls—Self-registering COM objects useful for
   from an environment in which users simply execute appli-                embedding in Web pages.
   cations on a single computer to a fully distributed envi-
                                                                       affinity mask (Windows XP)—List of processors on which a
   ronment; .NET provides a platform- and language-neutral
                                                                             process's threads are allowed to execute.
   development environment for components that can easily
   interoperate.                                                       alertable I/O (Windows XP)—Type of asynchronous I/O in
                                                                            which the system notifies the requesting thread of the
.NET framework—Programming model for creating XML-
                                                                            completion of the I/O with an APC.
   based Web services and applications. The .NET frame-
   work supports over 20 programming languages and facili-             alertable wait state (Windows XP)—State in which a thread
   tates application programming by providing libraries to                  cannot execute until it is awakened either by an APC
   perform common operations (e.g., input/output, string                    entering the thread's APC queue or by receiving a handle
   manipulation and network communication) and access                       to the object (or objects) for which the thread is waiting.
   data via multiple database interfaces (e.g., Oracle and
   SQL Server).                                                        alternate data stream—File attribute that stores the contents
                                                                            of an NTFS file that are not in the default data stream.
abandoned mutex (Windows XP)—Mutex that was not                             NTFS files may have multiple alternate data streams.
    released before the termination of the thread that held it.
                                                                       anonymous pipe (Windows XP)—Unnamed pipe that can be
access control entry (ACE) (Windows XP)—Entry in a discre-                 used only for synchronous one-way communication
    tionary access control list (DACL) for a specific resource             between local processes.
    that contain the security identifier (SID) of a security
    principal and the type of access (if any) the security prin-       apartment model—COM object threading model in which
    cipal has to that particular resource.                                 only one thread acts as a server for each COM object.

access token (Windows XP)—Data structure that stores secu-             APC IRQL (Windows X P ) - I R Q L at which APCs execute
    rity information, such as the security identifier (SID) and           and incoming asynchronous procedure calls (APCs) are
    group memberships, about a security principal.                        masked.
Active Directory (Windows XP)—Network service that pro-                application configuration file (ACF) (Windows XP)—File that
    vides directory services for shared objects (e.g., files, print-       specifies platform-specific attributes (e.g., how data
    ers, services, etc.) on a network.                                     should be formatted) for an RPC function call.

<!-- pág. 1164 -->

1114 Case Study: Windows XP

asynchronous procedure call (APC) (Windows XP)—Proce-              cluster (NTFS)—Basic unit of disk storage in an NTFS vol-
    dure calls that threads or the system can queue for execu-          ume, consisting of a number of contiguous sectors; a sys-
    tion by a specific thread.                                          tem's cluster size can range from 512 bytes to 64KB, but is
                                                                        typically 2KB, 4KB or 8KB.
automatic binding handle (Windows XP) —RPC binding han-
    dle in which the client process simply calls a remote func-    COM+—Extension of COM (Microsoft's Common Object
    tion, and the stub manages all communication tasks.              Model) that handles advanced resource management
                                                                      tasks, such as providing support for transaction processing
auto-reset timer object (Windows XP)—Timer object that                and using thread and object pools.
    remains signaled only until one thread finishes waiting on
    the object.                                                    commit memory (Windows XP)—Necessary stage before a
                                                                      process can access memory. The VMM ensures that there
Bad Page List (Windows XP)—List of page frames that have              is enough space in a pagefile for the memory and creates
    generated hardware errors; the system does not store              page table entries (PTEs) in main memory for the com-
    pages on these page frames.                                       mitted pages.
balance set manager (Windows XP)—Executive component               Common Internet File System (CIFS)—Native file sharing
    responsible for adjusting working set minimums and max-           protocol of Windows XP.
    imums and trimming working sets.
                                                                   Component Object Model (COM)—Microsoft-developed
base priority class (Windows XP)—Process attribute that               software architecture that allows interoperability between
    determines a narrow range of base priorities the process's        diverse components through the standard manipulation of
    threads can have.                                                 object interfaces.
base priority level (Windows XP)—Thread attribute that             component (Windows XP)—Functional unit of Windows XP.
    describes the thread's base priority within a base priority       Components range from user-mode applications such as
    class.                                                            Notepad to portions of kernel space such as the CD-ROM
                                                                      interface and power management tools. Dividing Win-
binding (Windows XP) — Connection between the client and
                                                                      dows XP into components facilitates operating system
    the server used for network communication (e.g., for an
                                                                      development for embedded systems.
    RPC).
                                                                   compression unit (NTFS)—Sixteen clusters. Windows XP
binding handle (Windows XP)—Data structure that stores the            compresses and encrypts files one compression unit at a
     connection information associated with a binding between         time.
     a client and a server.
                                                                   configuration manager (Windows XP)—Executive component
bus driver—WDM (Windows Driver Model) driver that pro-                  that manages the registry.
    vides some generic functions for devices on a bus, enu-
                                                                   critical section object (Windows XP)—Synchronization object,
    merates those devices and handles Plug and Play I/O
                                                                         which can be employed only by threads within a single
    requests.
                                                                         process, that allows only one thread to own a resource at a
cache manager (Windows XP)—Executive component that                      time.
    handles file cache management.                                 data stream (NTFS)—File attribute that stores the file's con-
class ID (CLSID)- Globally unique ID given to a COM                    tent or metadata; a file can have multiple data streams.
     object class.                                                 default data stream (NTFS)—File attribute that stores the pri-
class/miniclass driver pair (Windows XP)—Pair of device driv-          mary contents of an NTFS file. When an NTFS file is cop-
     ers that act as a function driver for a device; the class         ied to a file system that does not support multiple data
     driver provides generic processing for the device's partic-       streams, only the default data stream is preserved.
     ular device class, and the miniclass driver provides pro-     deferred procedure call (DPC) (Windows XP)—Software
     cessing for the specific device.                                   interrupt that executes at the DPC/dispatch IRQL and
clipboard (Windows XP)—Central repository of data that is               executes in the context of the currently executing thread.
     accessible to all processes, typically used with copy, cut    device extension (Windows XP)—Portion of the nonpaged
     and paste commands.                                               pool that stores information a driver needs to process I/O
clock IRQL (Windows XP)—IRQL at which clock interrupts                 requests for a particular device.
     occur and at which APC, DPC/dispatch, DIRQL and pro-          device IRQL (DIRQL) (Windows X P ) - I R Q L at which
     file-level interrupts are masked.                                 devices interrupt and at which APC, DPC/dispatch and

<!-- pág. 1165 -->

                                                                                                                 Key    Terms     1115

     lower DIRQLs are masked; the number of DIRQLs is                 executive (Windows XP)—Portion of the Windows XP operat-
     architecture dependent.                                              ing system that is responsible for managing the operating
device object (Windows XP)—Object that a device driver uses               system's subsystems (e.g., I/O subsystem, memory sub-
     to store information about a physical or logical device.             system and file system).

direct I/O —I/O transfer method whereby data is transferred           executive resource lock (Windows XP)—Synchronization lock
     between a device and a process's address space without               available only to kernel-mode threads and that may be
     using a system buffer.                                               held either in shared mode by many threads or in exclu-
                                                                          sive mode by one thread.
directory junction (Windows XP)—Directory that refers to
     another directory within the same volume, used to make           executive process (EPROCESS) block (Windows XP)—Execu-
     navigating the file system easier.                                   tive data structure that stores information about a pro-
                                                                          cess, such as that process's object handles and the
discretionary access control list (DACL) (Windows XP) —                   process's ID; an EPROCESS block also stores the process's
     Ordered list that tells Windows XP which security princi-            KPROCESS block.
     pals may access a particular resource and what actions
     those principals may perform on the resource.                    executive thread (ETHREAD) block (Windows XP)—Executive
                                                                          data structure that stores information about a thread,
dispatcher (Windows XP)—Thread scheduling code dispersed
                                                                          such as the thread's pending I/O requests and the thread's
     throughout the microkernel.
                                                                          start address; an ETHREAD block also stores the thread's
dispatcher object (Windows XP)—Object, such as a mutex,                   KTHREAD block.
     semaphore, event or waitable timer, that kernel and user
     threads can use for synchronization purposes.                    explicit handle (Windows XP)—Binding handle in which the
                                                                           client must specify all binding information and create and
domain (Windows XP) — Set of computers that share common                   manage the handle.
   resources.
                                                                      fast mutex (Windows XP)—Efficient mutex variant that oper-
domain controller (Windows XP) — Computer responsible for                  ates at the APC level with some restrictions (e.g., a thread
   security on a network.                                                  cannot specify a maximum wait time to wait for a fast
DPC/dispatch IRQL (Windows X P ) - I R Q L at which DPCs                   mutex).
   and the thread scheduler execute and at which APC and
                                                                      fast user switching (Windows XP)—Ability of a new user to
   incoming DPC/dispatch level interrupts are masked.
                                                                           logon to a Windows XP machine without logging off the
driver object (Windows XP)—Object used to describe device                  previous user.
     drivers; it stores pointers to standard driver routines and to
                                                                      fiber (Windows XP)—Unit of execution created by a thread
     the device objects for the devices that the driver services.
                                                                           and scheduled by that thread.
driver stack—Group of related device drivers that cooperate
     to handle the I/O requests for a particular device.              fiber local storage (FLS) (Windows XP)—Area of a process's
                                                                           address space where a fiber can store data that only the
dynamic-linked library (DLL) (Windows XP)—Module that                      fiber can access.
    provides data or functions to which processes or other
    DLLs link at execution time.                                      file mapping (Windows XP)—Interprocess communication
                                                                           mechanism in which multiple processes access the same
dynamic priority class (Windows XP)—Priority class that
                                                                           file by placing it in their virtual memory space. The differ-
    encompasses the five base priority classes within which a
                                                                           ent virtual addresses correspond to the same main mem-
    thread's priority can change during system execution;
                                                                           ory addresses.
    these classes are idle, below normal, normal, above nor-
    mal and high.                                                     file mapping object (Windows XP) —Object used by processes
                                                                           to map any file into memory.
environment subsystem (Windows XP)—User-mode compo-
     nent that provides a computing environment for other             file view (Windows XP)—Portion of a file specified by a file
     user-mode processes; in most cases, only environment                   mapping object that a process maps into its memory.
     subsystems interact directly with kernel-mode compo-
                                                                      filter driver—WDM (Windows Driver Model) driver that
     nents in Windows XP.
                                                                            modifies the behavior of a hardware device (e.g., provid-
event object (Windows XP)—Synchronization object that                       ing mouse acceleration) or adds some extra services (e.g.,
    becomes signaled when a particular event occurs.                       security checks).

<!-- pág. 1166 -->

1116 Case Study: Windows XP

free model—COM (Microsoft's Component Object Model)                I/O manager (Windows XP)—Executive component that
     object threading model in which many threads can act as           interacts with device drivers to handle I/O requests.
     the server for a COM object.                                  I/O throttling (Windows XP)—Technique that increases stabil-
Free Page List (Windows XP)—List of page frames that are                ity when available memory is low; the VMM manages
    available for reclaiming; although these page frames do             memory one page at a time during I/O throttling.
    not contain any valid data, they may not be used until the     I/O status block (Windows XP)—Field in an IRP that indicates
    zero-page thread sets all of their bits to zero.                    whether an I/O request completed successfully or, if not,
function driver—WDM (Windows Driver Model) device driver                the request's error code.
     that implements a device's main functions; it does most of    Interface Definition Language (IDL) file (Windows XP)—File
     the I/O processing and provides the device's interface.            that specifies the interfaces that an RPC server exposes.
globally unique ID (GUID) —128-bit integer that is, for all        interface ID (IID) — Globally unique ID for a COM interface.
    practical purposes, guaranteed to be unique in the world.      interlocked singly linked list (SList) (Windows XP) —Singly
    COM (Microsoft's Component Object Model) uses                       linked list in which insertions and deletions are performed
    GUIDs to uniquely identify interfaces and object classes.           as atomic operations.
Graphical Identification and Authentication (GINA) (Windows        interlocked variable access (Windows XP)—Method of access-
    XP) — Graphical user interface used that prompts users for          ing variables that ensures atomic reads and writes to
    credentials, usually in the form of a username and pass-            shared variables.
    word. Windows XP ships with its own implementation of
                                                                   intermediate driver (Windows XP)—Device driver that can be
    GINA called MSCINA, but it accepts third-party DLLs.
                                                                        interposed between high- and low-level drivers to filter or
Hardware Abstraction Layer (HAL) (Windows XP)—Operat-                   process I/O requests for a device.
    ing system component that interacts directly with the
                                                                   Internet Connection Firewall (ICF)—Windows XP's packet
    hardware and abstracts hardware details for other system
                                                                        filtering firewall.
    components.
                                                                   Internetwork Packet eXchange (IPX)—Novell Netware's net-
high IRQL (Windows XP)—Highest-priority IRQL, at which                  work protocol designed specifically for LANs.
    machine check and bus error interrupts execute and all
    other interrupts are masked.                                   Interrupt Dispatch Table (IDT)—Kernel data structure that
                                                                        maps hardware interrupts to interrupt vectors.
high-level driver (Windows XP)—Device driver that abstracts
                                                                   interrupt request level (IRQL) (Windows XP)—Measure of
    hardware specifics and passes I/O requests to low-level
                                                                        interrupt priority; an interrupt that occurs at an IRQL
    drivers.
                                                                        equal to or lower than the current IRQL is masked.
ideal processor (Windows XP)—Thread attribute that speci-
                                                                   interrupt service routine (ISR) (Windows XP)—Function,reg-
     fies a processor on which the system should attempt to
                                                                        istered by a device driver, that processes interrupts issued
     schedule the thread for execution.
                                                                        by the device that the driver services.
inheritance (Windows XP)—Technique by which a child pro-           job object (Windows XP)—Object that groups several pro-
    cess obtains attributes (e.g., most types of handles and the       cesses and allows developers to manipulate and set limits
    current directory) from its parent process upon creation.          on these processes as a group.
initialized state (Windows XP) —State in which a thread is         kernel handle (Windows XP)—Object handle accessible from
      created.                                                         any process's address space, but only in kernel mode.
I/O completion port (Windows XP)—Port at which threads             kernel-mode APC (Windows XP)—APC generated by a ker-
    register and block, waiting to be awakened when process-           nel-mode thread and queued to a specified user-mode
    ing completes on an I/O request.                                   thread; the user-mode thread must process the APC as
I/O completion routine (Windows XP)—Function registered                soon as the user-mode thread obtains the processor.
    by a device driver with the I/O manager in reference to an     kernel-mode driver—Device driver that executes in kernel
    IRP; the I/O manager calls this function when processing           mode.
    of the IRP completes.
                                                                   kernel process (KPROCESS) block (Windows XP)—Kernel data
I/O request packet (IRP) (Windows XP)—Data structure that              structure that stores information about a process, such as
    describes an I/O request.                                          that process's base priority class.

<!-- pág. 1167 -->

                                                                                                             Key Terms 1117
kernel thread (KTHREAD) block (Windows X P ) - K e r n e l data     memory descriptor list (MDL) (Windows XP)—Data struc-
    structure that stores information about a thread, such as          ture used in an I/O transfer that maps a process's virtual
    the objects on which that thread is waiting and the loca-          addresses to be accessed in the transfer to physical mem-
    tion in memory of the thread's kernel stack.                       ory addresses.
large page (Windows XP) — Set of pages contiguous in mem-           memory map—Data structure that stores the correspondence
     ory that the VMM treats as a single page.                         between a process's virtual address space and main mem-
last processor (Windows XP)—Thread attribute equal to the              ory locations.
     processor that most recently executed the thread.              Microsoft IDL (MIDL)—Microsoft's extension of Interface
lazy allocation—Policy of waiting to allocate resources, such as        Definition Language (IDL)—The Open Group's Distrib-
     pages in virtual memory and page frames in main mem-               uted Computing Environment (DCE) standard for RPC
     ory, until absolutely necessary.                                   interoperability.
Lempel-Ziv compression algorithm—Data compression algo-             minor function code (Windows XP)—Field in an IRP that,
   rithm that NTFS uses to compress files.                              together with the major function code, describes the spe-
                                                                        cific function that should be performed to fulfill an I/O
Lightweight Directory Access Protocol (LDAP) (Windows
                                                                        request (e.g., to start a device, a PnP major function code
    XP)—Protocol for accessing, searching and modifying
                                                                        is used with a start device minor function code).
    Internet directories (e.g., Active Directory).
                                                                    mixed model—COM threading model, in which some COM
localized least-recently used page replacement (Windows
                                                                        objects reside in single apartments and others can be
     XP)—Policy of moving to disk the least-recently used
                                                                        accessed by free threads.
     page of a process at its working set maximum when that
     process requests a page in main memory. The policy is          Modified No-write Page List (Windows XP)—List of page
     localized by process, because Windows XP moves only the           frames for which the VMM must write an entry to a log
     requesting process's pages; Windows XP approximates               file before freeing.
     this policy using the clock algorithm.                         Modified Page List (Windows XP)—List of page frames that
local procedure call (LPC) (Windows XP)—Procedure call                 the VMM must write to the pagefile before freeing.
     made by a thread in one process to a procedure exposed         Multiple UNC Provider (MUP) (Windows X P ) - F i l e system
     by another process in the same domain (i.e., set of com-           driver that determines the appropriate redirector to which
     puters that share common resources); LPCs can be cre-              to send a network I/O request.
     ated only by system components.                                must-succeed request (Windows XP) —Request for space in
local remote procedure call (LRPCs) (Windows X P ) - R P C s            main memory that a process issues when it requires more
     between two processes on the same machine.                         main memory to continue functioning properly. Windows
low-level driver (Windows XP)—Device driver that controls a             XP always denies must-succeed requests; previous ver-
     peripheral device and does not depend on any lower-level           sions of Windows always fulfilled them.
     drivers.                                                       mutex object (Windows XP) — Synchronization object that
mailslot (Windows XP)—Message queue, which a process can                allows at most one thread access to a protected resource
    employ to receive messages from other processes.                    at any time; it is essentially a binary semaphore.
mailslot client (Windows XP)—Process that sends mailslot            named pipe (Windows XP)—Type of pipe that can provide
    messages to mailslot servers.                                      bidirectional communication between two processes on
                                                                       local or remote machines and that supports both synchro-
mailslot server (Windows XP)—Process that creates a mailslot
                                                                       nous and asynchronous communication.
    and receives messages in it from mailslot clients.
                                                                    native API (Windows XP)—Programming interface exposed
major function code (Windows XP)—Field in an IRP that
                                                                         by the executive, which environment subsystems employ
    describes the general function (e.g., read or write) that
                                                                         to make system calls.
    should be performed to fulfill an I/O request.
                                                                    NDIS intermediate driver (Windows XP)—NDIS driver that
manual-reset timer object (Windows XP)—Timer object that
                                                                       can be interposed between a miniport driver and a higher-
   remains signaled until a thread specifically resets the timer.
                                                                       level driver and adds extra functionality, such as translat-
Master File Table (MFT) (NTFS)-File which is structured as             ing packets between different communication media, fil-
    a table in which NTFS stores information (e.g. name, time          tering packets or providing load balancing across several
    stamp, and location) about all files in the volume.                NICs.

<!-- pág. 1168 -->

1118 Case Study: Windows XP
NDIS miniport driver (Windows XP)—NDIS driver that man-              object manager namespace (Windows XP)—Group of object
   ages a NIC and sends and receives data to and from the                names in which each name is unique in the group.
   NIC.                                                              opportunistic lock (oplock) (Windows XP) —Lock used by a
NDIS protocol driver (Windows XP)—NDIS driver that                       CIFS client to secure exclusive access to a remote file,
   places data into packets and passes these packets to                  ensuring that the client can cache data locally and keep its
   lower-level drivers. NDIS protocol drivers provide an                 cache coherent.
   interface between the transport drivers and other NDIS            overlapped I/O (Windows XP)—Microsoft synonym for asyn-
   drivers and can be used as the lowest layer in the imple-             chronous I/O.
   mentation of a transport protocol stack such as TCP/IP.
                                                                     page directory register—Hardware register that stores a
neither I/O (Windows XP)—I/O transfer technique in which a               pointer to the current process's page directory table.
     high-level driver executes in the context of the calling
     thread to set up a buffered I/O transfer or direct I/O          page directory table (Windows XP)—4KB page that contains
     transfer or to directly perform the transfer in the process's       1024 entries that point to frames in memory.
     address space.                                                  paged pool (Windows XP)—Pages in memory that may be
                                                                         moved to the pagefile on disk.
NetBIOS Extended User Interface (NetBEUI) (Windows
    XP)—Native network and transport protocol for DOS                pagefile (Windows XP)—File on disk that stores all pages that
    and older Windows operating systems.                                 are mapped to a process's virtual address space but do not
                                                                         currently reside in main memory.
NetBIOS over TCP/IP (NBT) (Windows XP)-Replacement
    protocol for NetBEUI that provides backward compati-             page frame database (Windows XP)—Array that contains the
    bility with older applications (by keeping the NetBIOS               state of each page frame in main memory.
    interface) and takes advantage of TCP/IP protocols.              page list (Windows XP)—List of page frames that are in the
Network Basic Input/Output System (NetBIOS) (Windows                     same state. The eight state lists are: the Valid Page List, the
    XP)—API used to support NetBEUI and now used with                    Standby Page List, the Modified Page List, the Modified
    NBT.                                                                 No-write Page List, the Transitional Page List, the Free
                                                                         Page List, the Zeroed Page List, and the Bad Page List.
Network Data Representation (NDR)—Standard format for
    network data described in the The Open Group's Distrib-          page trimming (Windows XP)—Technique in which Windows
    uted Computing Environment (DCE) standard.                           XP takes a page belonging to a process and sets the page's
                                                                         PTE to invalid to determine whether the process actually
Network Driver Interface Specification (NDIS) (Windows                   needs the page. If the process does not request the page
    XP)—Specification that describes a standard interface                within a certain time period, the system removes it from
    between lower-level layered drivers in the network driver            main memory.
    stack; NDIS drivers provide the functionality of the link
    layer in the TCP/IP stack and are used on Windows XP             passive IRQL (Windows XP)—IRQL at which user- and ker-
    systems.                                                              nel-mode normally execute and no interrupts are masked.
                                                                          Passive IRQL is the lowest-priority IRQL.
network redirector—See redirect or (Windows XP).
                                                                     periodic timer (Windows XP)—Waitable timer object that reac-
nonpaged pool—Area of main memory that stores pages that                  tivates after a specified interval.
    are never moved to disk.
                                                                     pipe client (Windows XP)—Process that connects to an exist-
nonresident attribute—NTFS file attribute whose data does                ing pipe to communicate with that pipe's server.
    not fit inside the MFT entry and is stored elsewhere.            pipe server (Windows XP)—Process that creates a pipe and
object handle (Windows XP)—Data structure that allows                    communicates with pipe clients that connect to the pipe.
    threads to manipulate an object.                                 PnP I/O requests (Windows X P ) - I R P s generated by the PnP
Object Linking and Embedding (OLE)—Microsoft technol-                   manager to query a driver for information about a device,
    ogy built on COM that defines a standard method for pro-             to assign resources to a device or to direct a device to per-
    cesses to exchange data by linking or embedding COM                 form some action.
    objects.                                                         Plug and Play (PnP) manager (Windows XP)—Executive
object manager (Windows XP)—Executive component that                     component (which also exists partly in user space) that
    manages objects.                                                     dynamically recognizes when new devices are added to

<!-- pág. 1169 -->

                                                                                                              Key Terms 1119

    the system (as long as these devices support PnP), allo-            when a user has forgotten the private key needed to
    cates and deallocates resources to devices and interacts            decrypt the file.
    with device setup programs.                                     redirector (Windows XP)—File system driver that interacts
port mapping (Windows XP)—Process of explicitly allowing                 with a remote server driver to facilitate network I/O oper-
     the Internet Connection Firewall (ICF) to accept all                ations.
     incoming packets to a particular port.
                                                                    registry (Windows XP)—Central database in which user, sys-
power IRQL (Windows XP) —IRQL at which power failure                     tem and application configuration information is stored.
    interrupts execute and at which all interrupts except high-
                                                                    Remote Access Service (RAS) (Windows XP)—Network ser-
    IRQL interrupts are masked.
                                                                       vice, which allows users to remotely connect to a LAN.
power manager (Windows XP)—Executive component that
                                                                    reparse point (NTFS)—File attribute containing a tag and a
    administers the operating system's power management
                                                                        block of up to 16KB of data that a user associates with a
    policy.
                                                                        file or directory; when an application accesses a reparse
power policy (Windows XP)—Policy of a system with regard                point, the system executes the file system filter driver
    to balancing power consumption and responsiveness of                specified by the reparse point's tag.
    devices.
                                                                    request IRQL (Windows XP) —IRQL at which interprocess
primary thread (Windows XP)—Thread created when a pro-                  interrupts execute and all interrupts except power-level
    cess is created.                                                    and high-level interrupts are masked.
priority inversion—Situation which occurs when a high-prior-        reserve memory (Windows XP)—To indicate to the VMM that a
     ity thread is waiting for a resource held by a low-priority         process intends to use an area of virtual memory; the VMM
     thread, and the low-priority thread cannot obtain the pro-          allocates memory in the process's virtual address space but
     cessor because of a medium-priority thread; hence, the              does not allocate any page frames in main memory.
     high-priority thread is blocked from execution by the
     medium-priority thread.                                        resident attribute (NTFS)—File attribute whose data is stored
                                                                         within the MFT entry.
process environment block (PEB) (Windows XP) —User-
    space data structure that stores information about a pro-       running state (Windows XP) —State in which a thread is cur-
    cess, such as a list of DLLs linked to the process and infor-       rently in execution.
    mation about the process's heap.                                Security Accounts Manager (SAM) (Windows XP)—Data-
profile IRQL (Windows XP)—IRQL at which debugger inter-                 base that administers information about all security prin-
     rupts execute and at which APC, DPC/dispatch, DIRQL                cipals in the system. It provides services such as account
     and incoming debugger interrupts are masked.                       creation, account modification and authentication.
protocol sequence (Windows XP)—String used by a client in           security descriptor (Windows XP)—Data structure that stores
    an RPC call that specifies the RPC protocol, transport              information about which security principals may access a
    protocol and network protocol for that RPC.                         resource and what actions they may perform on that
Prototype Page Table Entry (PPTE) (Windows XP)-32-bit                   resource. The most important element of a security
    record that points to a frame in memory that contains               descriptor is its discretionary access control list (DACL).
    either a copy-on-write page or a page that is part of a pro-    security identifier (SID) (Windows XP)—Unique identification
    cess's view of a mapped file.                                        number assigned to each security principal in the system.
queued spin lock (Windows XP)—Spin lock in which a thread           security principal (Windows XP) —Any user, process, service
    releasing the lock notifies the next thread in the queue of         or computer that can perform an action in a Windows XP
    waiting threads.                                                    system.
ready state (Windows XP)—State in which a thread is waiting         Security Support Provider Interface (SSPI) (Windows XP) —
    to use a processor.                                                 Microsoft's standardized protocol for authentication and
real-time priority class (Windows XP)—Base priority class               authorization recognized by both the Kerberos and
     encompassing the upper 16 priority levels; threads of this         NTLM authentication services.
     class have static priorities.                                  semaphore object (Windows XP) — Synchronization object
recovery key (NTFS)—Key that NTFS stores that can decrypt               that allows a resource to be owned by up to a specified
    an encrypted file; administrators can use recovery keys             number of threads; it is essentially a counting semaphore.

<!-- pág. 1170 -->

1120 Case Study: Windows XP
Sequenced Packet eXchange (SPX)—Novell Netware's trans-            transition state (Windows XP)—Thread state denoting a thread
    port protocol, which offers connection-oriented services            that has completed a wait but is not yet ready to run
    for IPX packets.                                                    because its kernel stack has been paged out of memory.
Server Message Block (SMB)—Network file-sharing protocol           Transport Driver Interface (TDI) driver (Windows X P ) - N e t -
    used in Windows operating systems on top of which CIFS             work driver that exports a network interface to upper-
    (Common Internet File System) is built.                            level kernel-mode clients and interacts with low-level
single-use timer (Windows XP)—Waitable timer object that is            NDIS drivers.
     used once and then discarded.                                 universally unique identifier (UUID)—ID that is guaranteed,
signaled state (Windows XP)—State in which a synchroniza-              for all practical purposes, to be unique in the world.
     tion object can be placed, allowing one or more threads           UUIDs uniquely identify an RPC interface.
     waiting on this object to awaken.                             Uniform Naming Convention (UNC) format (Windows XP) —
sparse file (NTFS)—File with large blocks of regions filled with       Format that specifies a file's pathname, including on which
    zeroes that NTFS tracks using a list of empty regions              server and in which directory on that server the file is
    rather than explicitly recording each zero bit.                    located.
Standby Page List (Windows XP)—List of page frames that            unknown state (Windows XP)—Thread state denoting that the
    are consistent with their on-disk version and can be freed.        some error has occurred and the system does not know
                                                                       the state of the thread.
standby state (Windows XP)—Thread state denoting a thread
     that has been selected for execution.                         unsignaled state (Windows XP)—State in which a synchroni-
                                                                       zation object can be; threads waiting on this object do not
system service (Windows XP)—Process that executes in the
                                                                       awaken until the object transitions to the signaled state.
     background whether or not a user is logged into the com-
     puter and typically executes the server side of a client/     user-mode APC (Windows XP)—APC queued by user-mode
     server application; a system service for Windows XP is            thread and executed by the target thread when the target
     similar to a daemon for Linux.                                    thread enters an alertable wait state.
system worker thread (Windows XP)—Thread controlled by             user-mode driver (Windows XP)—Device driver that executes
     the system that sleeps until a kernel-mode component              in user space.
     queues a work item for processing.                            Valid Page List (Windows XP)—List of page frames that are
terminated state (Windows XP)—Thread state that denotes a              currently in a process's working set.
    thread is no longer available for execution.                   Virtual Address Descriptor (VAD) (Windows XP)—Structure
thread local storage (TLS) (Windows XP)—Area of a thread's             in memory that contains a range of virtual addresses that
    process's address space where the thread can store private          a process may access.
     data, inaccessible to other threads.                          virtual memory manager (VMM) (Windows XP)—Executive
thread environment block (TEB) (Windows XP)—User-space                  component that manages virtual memory.
    data structure that stores information about a thread,         VMS—Operating system for the DEC VAX computers,
    such as the critical sections owned by a thread and excep-       designed by David Cutler's team.
     tion-handling information.                                    waitable timer object (Windows XP) — Synchronization object
thread pool (Windows XP) — Collection of worker threads that           that becomes signaled after a specified amount of time
    sleep until a request is queued to them, at which time one         elapses.
     of the threads awakens and executes the queued function.      wait function (Windows XP)—Function called by a thread to
timer-queue timer (Windows XP)—Timer that signals a                    wait for one or more dispatcher objects to enter a signaled
    worker thread to perform a specified function at a speci-          state; calling this function places a thread in the waiting
    fied time.                                                         state.
transitional fault (Windows XP)—Fault issued by the MMU            waiting state (Windows XP)—Thread state denoting that a
    when it tries to access a page that is in main memory, but          thread is not ready for execution until it is awakened (e.g..
    whose page frame's status is set to standby, modified, or           by obtaining a handle to the object on which it is waiting).
    modified no-write.                                             Web-based Distributed Authoring and Versioning (WebDAV)
Transitional Page List (Windows XP)—List of page frames               (Windows XP)—Network file-sharing protocol that
    whose data is in the process of being moved to or from disk.      allows users to write data directly to HTTP servers and is

<!-- pág. 1171 -->

                                                                                                               Exercises       1121

    designed to support collaborative authoring between            WinHTTP (Windows XP)—API that supports communication
    groups in remote locations.                                       between clients and servers over an HTTP session.
Win32 environment subsystem (Windows XP)—User-mode                 Windows sockets version 2 (Winsock 2)—Adaptation and
   process interposed between the executive and the rest of           extension of BSD sockets for the Windows environment.
   user space that provides a typical 32-bit Windows environ-
   ment.                                                           worker thread (Windows XP)—Kernel-mode thread that the
                                                                       system uses to execute functions queued by user-mode or
Win32 service (Windows XP)—See system service (Windows
                                                                       other kernel-mode threads.
   XP).
Windows Driver Model (WDM) (Windows XP)-Standard                   working set (Windows XP)—All of the pages in main memory
   driver model that enables source-code compatibility                 that belong to a specific process.
   across all Windows platforms; each WDM driver must be           working set maximum (Windows XP)—Upper limit on the
   written as a bus driver, function driver or filter driver and       number of pages a process may have simultaneously in
   support PnP, power management and WML                               main memory.
Windows Management Instrumentation (WMI) (Windows
                                                                   working set minimum (Windows XP)—Number of pages in
   XP)—Standard that describes how drivers provide mea-
                                                                       main memory the working set manager leaves a process
   surement and instrumentation data to users (e.g., configu-
                                                                       when it executes the page-trimming algorithm.
   ration data, diagnostic data or custom data) and allow user
   applications to register for WMI driver-defined events.         write-through mode (Windows XP)—Method of writing to a
Windows XP Embedded—Embedded operating system, which                   pipe whereby write operations do not complete until the
   uses the same binary files as Windows XP but allows                 data being written is confirmed to be in the buffer of the
   designers to choose only those components applicable for            receiving process.
   a particular device.                                            Zeroed Page List (Windows XP)—List of page frames whose
WinlNet (Windows XP)—API that allows applications to                   bits are all set to zero.
   interact with FTP, HTTP and Gopher protocols to access
   resources over the Internet.




Exercises
21.1 [Section 21.4, System Architecture] What aspects of the       21.7 [Section 21.6.1, Process and Thread Organization] What
Windows XP architecture make the system modular and por-           entity schedules fibers?
table to different hardware? In what ways has Microsoft sacri-     21.8 [Section 21.6.1, Process and Thread Organization] How
ficed modularity and portability for performance?                  might thread pools introduce inefficiency?
21.2 [Section 21.5.2, Object Manager] What are the benefits of     21.9 [Section 21.6.2, Thread Scheduling] The dispatcher sched-
managing all objects in a centralized object manager?              ules each thread without regard to the process to which the
                                                                   thread belongs, meaning that, all else being equal, the same pro-
21.3 [Section 21.5.5, Deferred Procedure Calls (DPCs)] Why         cess implemented with more threads receives a greater share of
might a routine that generates a DPC specify the processor (in     execution time. Name a disadvantage of this strategy.
a multiprocessor system) on which the DPC executes?
                                                                   21.10 [Section 21.6.2, Thread Scheduling] Why does the system
21.4 [Section 21.5.5, Deferred Procedure Calls (DPCs)] How         reset a real-time thread's quantum after preemption?
do DPCs increase the system's responsiveness to incoming           21.11 [Section 21.6.2, Thread Scheduling] Under what circum-
device interrupts?                                                 stances would Windows XP increase a dynamic-priority
                                                                   thread's priority? Under what circumstances would Windows
21.5 [Section 21.5.5, Deferred Procedure Calls (DPCs)] Why
                                                                   XP decrease it?
is it that DPCs cannot access pageable data?
                                                                   21.12 [Section 21.6.2, Thread Scheduling] How can policies
21.6 [Section 21.6.1, Process and Thread Organization] Give        implemented in Windows XP lead to priority inversion? How
an example of why it may be useful to create a job for a single    does Windows XP handle priority inversion? In what ways is
process.                                                           this a good policy? What are its drawbacks?

<!-- pág. 1172 -->

1122 Case Study: Windows XP
21.13 [Section 21.6.2, Thread Scheduling] Why might a devel-       This creates extra overhead whenever the process accesses a
oper manipulate the value of a thread's ideal processor?           new portion of an open file. What would happen if the operat-
21.14 [Section 21.6.3, Thread Synchronization] Windows XP          ing system tried to save time by creating all PTEs at once?
does not explicitly detect deadlock situations for threads using   21.22 [Section 21.7.2, Memory Allocation] Windows XP elimi-
dispatcher objects. How might threads using dispatcher objects     nated must-succeed requests to make the system more stable.
create a deadlock? What mechanisms does Windows XP                 Suppose an enterprising programmer rewrote the operating
include to help avoid these situations?                            system to accept must-succeed requests, but only when the sys-
21.15 [Section 21.6.3, Thread Synchronization] In what ways        tem had enough main memory to fulfill the requests. What are
are threads executing at an IRQL equal to or greater than          the pitfalls of this policy?
DPC/dispatch level restricted? Why is this so?                     21.23 [Section 21.7.3, Page Replacement] Why does Windows
21.16 [Section 21.6.3, Thread Synchronization] Why use a           XP enable pagefiles to be stored on separate disks?
queued spin lock in preference to a generic spin lock?             21.24 [Section 21.7.3, Page Replacement] Why does Windows
21.17 [Section 21.6.3, Thread Synchronization] Explain how an      XP zero pages?
executive resource can be used to solve the readers-and-writ-      21.25 [Section 21.7.3, Page Replacement] Suppose process A
ers problem.                                                       requests a new page from disk. However, the Zeroed Page List
21.18 [Section 21.7.1, Memory Organization] Suppose an             and the Free Page List are empty. One page frame originally
enterprising programmer modifies the Windows XP virtual            belonging to process B is in the Standby Page List, and one
memory manager so that it allocates space for all page table       page frame belonging to process A is in the Modified Page
entries that a process may need as soon as the process is cre-     List. Which page frame will the system take and what will hap-
ated. Assume that page table entries cannot be moved to sec-       pen to that page frame? What are the pros and cons of taking
ondary storage and that no page table entries are shared.          the other page frame?

      a. How much space would be needed to store all the           21.26 [Section 21.8.1, File System Drivers] The operating system
         page table entries for one process (on a 32-bit sys-      uses different local file system drivers to access different storage
         tem)?                                                     devices. Would it make sense to develop a remote block file sys-
                                                                   tem driver and remote character file system driver to access dif-
      b. Windows XP stores each process's page table entries
                                                                   ferent types of storage devices on remote computers?
         in system space, which is shared between all pro-
         cesses. If a system devoted all of its system space to    21.27 [Section 21.8.2, NTFS] In Windows XP, shortcuts (the
         page table entries, what is the maximum number of         icons that users put on their desktop) are implemented as soft
         processes that could be active simultaneously?            links—if the file or program to which they are connected is
                                                                   moved, the shortcuts point to nothing. What are the advan-
21.19 [Section 21.7.1, Memory Organization] Large pages need       tages and disadvantages of replacing shortcuts with hard links?
to be stored contiguously in main memory. There are several
ways to do this: a system can designate a portion of main mem-     21.28 [Section 21.8.2, NTFS] A user wants to compress a
ory exclusively for large pages, a system can rearrange pages in   256KB file stored on an NTFS volume with 4KB clusters. Lem-
main memory whenever a process requests a large page, or a         pel-Ziv compression reduces the four 64KB compression units
system can do nothing and deny large-page memory allocation        to 32KB, 31KB, 62KB, and 48KB. How much space does the
requests whenever necessary. Discuss the pros and cons of          compressed file take on the disk?
each of these three policies.                                      21.29 [Section 21.8.2, NTFS] Windows XP performs file
21.20 [Section 21.7.1, Memory Organization] A Windows XP           encryption using reparse points. The file is piped through the
TLB entry contains the full 32-bit virtual address and the 32-     Encrypting File System filter, which does all of the encryption
bit physical address to which it corresponds. Associative mem-     and decryption. Windows XP allows an application to ignore a
ory is very expensive. Suggest a space-saving optimization for     reparse point and access the file directly. Does this compro-
the TLB.                                                           mise the security of encrypted data? Why or why not?

21.21 [Section 21.7.2, Memory Allocation] When a process           21.30 [Section 21.9.1, Device Drivers] What are the advantages
opens a file, Windows XP does not move the entire file into        of servicing device I/O requests with a clearly defined driver
main memory. Instead, the system waits to see which portions       stack rather than a single device driver?
of the file the process will access. The VMM moves only the        21.31 [Section 21.9.1, Device Drivers] What are some of the
accessed pages into main memory and creates PTEs for them.         benefits that systems and users realize from Plug and Play?

<!-- pág. 1173 -->

                                                                                                   Recommended Reading                   1123

21.32 [Section 21.9.2, Input/Output Processing] We discussed       21.37 [Section 21.13.1, Authentication] Suppose a company
four types of asynchronous I/O: polling, waiting on an event       network has only Windows XP machines. What are the advan-
object that signals the completion of the I/O, alertable I/O and   tages of allowing both NTLM and Kerberos authentication?
using I/O completion ports. For each technique, describe a sit-    What are the disadvantages?
uation for which it is useful; also, state a drawback for each
                                                                   21.38 [Section 21.13.2, Authorization] When Windows XP
technique.
                                                                   compares an access token to a DACL (discretionary access
21.33 [Section 21.9.3, Interrupt Handling] Why should an ISR       control list), it scans the ACEs (access control entries) one by
do as little processing as necessary and return quickly, saving    one and stops when it finds the first ACE whose SID (security
most of the interrupt processing for a DPC?                        identifier) matches an SID in the access token. Consider an
                                                                   administrator that wants to permit all authenticated users
21.34 [Section 21.11.2, Network Driver Architecture] Suppose a
                                                                   except interns to use a printer. The first ACE in the printer's
new set of protocols were to replace TCP and IP as standard
                                                                   DACL would deny the security group Interns and the second
network protocols. How difficult would it be to incorporate
                                                                   ACE would permit the security group Everyone. Assume that
support for these new protocols into Windows XP?
                                                                   an intern's access token lists the security group Everyone first
21.35 [Section 21.11.3, Network Protocols] Winsock adds new        and the security group Interns second. What would happen if
functionality on top of BSD sockets, extending sockets' func-      instead the system scanned the access token and stopped when
tionality, but hindering portability. Do you think this was a      it found an SID in the DACL?
good design decision? Support your answer.
                                                                   21.39 [Section 21.13.3, Internet Connection Firewall] The Win-
21.36 [Section 21.12.1, Symmetric Multiprocessing (SMP)]           dows XP ICF filters only inbound packets. What are the advan-
Why does Windows XP attempt to schedule a thread on the            tages of not checking outgoing packets? What are the
same processor on which it recently executed?                      disadvantages?




Recommended Reading
A superb exposition of Windows NT-line internals can be            from the MSDN Library at msdn.microsoft.com/library.
found in Inside Windows 2000, 3d ed., by Mark Russinovich          Also, Microsoft Windows XP Professional Resource Kit Docu-
and David Solomon and published by Microsoft Press. These          mentation by the Microsoft Corporation and published by
authors also discuss kernel enhancements from Windows 2000         Microsoft Press provides useful documentation about Win-
to Windows XP in their article "Windows XP: Kernel Improve-        dows XP. Some of the chapters of this book are available on
ments Create a More Robust, Powerful, and Scalable OS,"            Microsoft     Technet     at   www.microsoft.com/technet/
published in the December 2001 edition of MSDN Magazine.           prodtechnol/winxppro/Default.asp. The NT Insider and
Helen Custer's Inside Windows NT, published by Microsoft           Windows & .NET Magazine both provide excellent articles on
Press, introduces many NT concepts still applicable for Win-       Windows internals. Both of these magazines have archives of
dows XP. For the most updated reference on Windows XP, see         old editions. The NT Insider archives are available at
the platform Software Development Kit (SDK) and Driver             www.osronline.com, and the Windows & .NET Magazine
Development Kit (DDK) for Windows XP. Both are available           archives are available at www.wi nntmag.com.




Works Cited
 1. "Windows XP Captures More Than One-Third of O/S Market on       3. Connolly, C, "First Look: Windows XP 64-Bit Edition for
    Web," StatMarket 13, May 2003, <www.statmarket.com/cgi-            AMD64," Game PC September 5, 2003 <www.gamepc.com/
    bin/sm.cgi?sm&feature&week_stat>.                                  labs/view_content.asp?id=amd64xp&page=l>.
 2. "Windows XP Product Information," Microsoft Corporation,        4. Mirick, John, "William H. Gates III," Department of Computer
    July 29, 2003, <www.microsoft.com/windowsxp/evaluation/            Science at Virginia Tech, September 29, 1996, < e i . c s . v t . e d u /
    default.asp>.                                                      -history/Gates.Mirick.html>.

<!-- pág. 1174 -->

1124 Case Study: Windows XP
 5. Corrigan, Louis, "Paul Allen's Wide Wild Wired World," The                     29. Gates, W., The Road Ahead, New York: Viking Penguin, 1995,
    Motley Fool, June 17, 1999 <www.fool.com/specials/1999/                            pp. 1, 12, 14-17, 48, 54.
    sp990617allen.htm>.                                                            30. Microsoft Corporation, "Bill Gates' Web Site," September 2003,
 6. Forbes, "Forbes' World's Richest People 2003," 2003,                               <www.microsoft.com/billgates/bio.asp>.
    <www.forbes.com/finance/lists/10/2003/LIR.j html?pass-                         31. "Microsoft DOS Version Features," EMS, <www.emsps.com/
    Li stId=10&passYear=2003&passListType=Per-                                         oldtools/msdosv.htm>.
    son&uniqueId=BH69&datatype=Person>.
                                                                                   32. "History of Microsoft Windows," Wikipedia, <www.wikipe-
 7. "Bill Gates," Microsoft, September 2002, <www.microsoft.com/                       dia.org/wiki/History_of_Microsoft_Windows>.
    billgates/bio.asp>.
                                                                                   33. "Windows Desktop Products History," Microsoft Corporation,
 8. Krol, Louisa, and Leo Goldman, "Survival of the Richest,"                          2003,      <www.microsoft.com/windows/WinHistoryDesk-
    Forbes.com, March 17, 2003, <www.forbes.com/free_forbes/                           top.mspx>.
    2003/0317/087.html>.
                                                                                   34. "History of Microsoft Windows," Wikipedia, <www.wikipe-
 9. "MS-DOS," Computer Knowledge, 2001, <www.cknow.com/                                dia.org/wiki/History_of_Microsoft_Windows>.
    ckinfo/acro_m/msdos_1.shtml>.
                                                                                   35. Munro, Jay, "Windows XP Kernel Enhancements," ExtremeTech,
10. Microsoft Corporation, "Bill Gates' Web Site," September 2003,                     June   8,    2001,  <www.extremetech.com/print_article/
    <www.microsoft.com/billgates/bio.asp>.                                             0,3998,a=2473,00.asp>.
11. Microsoft Corporation, "Bill Gates' Web Site," September 2003,                 36. "The Foundations of Microsoft Windows NT System Architec-
    <www.microsof t . c o m / b i l l g a t e s / b i o . a s p > .                    ture," MSDN Library, Microsoft Corporation, September 1997.
12. Allison, D., "Interview with Bill Gates," 1993, <www.american-                     <msdn.microsoft.com/ARCHIVE/en-us/dnarwbgen/html/
    hi s t o r y . s i . e d u / c s r / c o m p h i s t / g a t e s . h t m > .       msdn_ntfound.asp>.
13. Allison, D., "Interview with Bill Gates," 1993, <www.american-                 37. "Microsoft Windows 2000 Overview," Dytech Solutions,
    hi s t o r y . s i . e d u / c s r / c o m p h i s t / g a t e s . h t m > .       Microsoft Corporation, 1999, <www.dytech.com.au/technolo-
14. Gates, W., The Road Ahead, New York: Viking Penguin, 1995,                         gies/Win2000/Features/Features.asp>.
    pp. 1, 12, 14-17, 48, 54.                                                      38. Russinovich, M., "Windows NT and VMS: The Rest of the Story,"
15. Microsoft Corporation, "Bill Gates' Web Site," September 2003,                     December          1998,      <www.winnetmag.com/Articles/
    <www.microsoft.com/billgates/bio.asp>.                                             Index.cfm?ArticleID=4494>.
16. Allison, D., "Interview with Bill Gates," 1993, <www.american-                 39. Custer, H, Inside Windows NT, Microsoft Press, 1992. Foreword
    h i s t o r y . s i .edu/csr/comphist/gates.htm>.                                  by David Cutler.
17. Gates, W, The Road Ahead, New York: Viking Penguin, 1995,                      40. Russinovich, M., "Windows NT and VMS: The Rest of the Story,"
    pp. 1, 12, 14-17, 48, 54.                                                          December          1998,     <www.winnetmag.com/Articles/
18. Allison, D., "Interview with Bill Gates," 1993, <www. ameri can-                   Index.cfm?ArticleID=4494>.
    history.si.edu/csr/comphist/gates.htm>.                                        41. Custer, H, Inside Windows NT, Microsoft Press, 1992. Foreword
19. Gates, W, The Road Ahead, New York: Viking Penguin, 1995,                          by David Cutler.
    pp. 1, 12, 14-17, 48, 54.                                                      42. Custer, H, Inside Windows NT, Microsoft Press, 1992. Foreword
20. Microsoft Corporation, "Bill Gates' Web Site," September 2003,                     by David Cutler.
    <www.microsoft.com/billgates/bio.asp>.                                         43. Russinovich, M., "Windows NT and VMS: The Rest of the Story,"
21. Allison, D., "Interview with Bill Gates," 1993, <www.american-                     December          1998,     <www.winnetmag.com/Articles/
    hi s t o r y . s i . e d u / c s r / c o m p h i s t / g a t e s . h t m > .       Index.cfm?ArticleID=4494>.
22. Gates, W, The Road Ahead, New York: Viking Penguin, 1995,                      44. Custer, H., Inside Windows NT, Microsoft Press, 1992. Foreword
    pp. 1,12,14-17,48,54.                                                              by David Cutler.
23. Allison, D., "Interview with Bill Gates," 1993, <www.american-                 45. Custer, H, Inside Windows NT, Microsoft Press, 1992. Foreword
    hi s t o r y . s i . e d u / c s r / c o m p h i s t / g a t e s . h t m > .       by David Cutler.
24. Gates, W, The Road Ahead, New York: Viking Penguin, 1995,                      46. Russinovich, M., "Windows NT and VMS: The Rest of the Story,"
    pp. 1,12,14-17,48,54.                                                              December          1998,     <www.winnetmag.com/Articles/
25. Allison, D., "Interview with Bill Gates," 1993, <www. ameri can-                   Index.cfm?ArticleID=4494>.
    history.si.edu/csr/comphist/gates.htm>.                                        47. Custer, H., Inside Windows NT, Microsoft Press, 1992. Foreword
26. Allison, D., "Interview with Bill Gates," 1993, <www.american-                     by David Cutler.
    history.si.edu/csr/comphist/gates.htm>.                                        48. Russinovich, M., "Windows NT and VMS: The Rest of the Story."
27. Gates, W, The Road Ahead, New York: Viking Penguin, 1995,                          December          1998,     <www.winnetmag.com/Articles/
    pp. 1, 12, 14-17, 48, 54.                                                          Index.cfm?ArticleID=4494>.
28. Microsoft Corporation,   "PressPass—Steve     Ballmer,"                        49. Custer, H, Inside Windows NT, Microsoft Press, 1992. Foreword
    <www.microsoft.com/presspass/exec/steve/default.asp>.                              by David Cutler.

<!-- pág. 1175 -->

                                                                                                                                                                         Works Cited 1125
50. Custer, H., Inside Windows NT, Microsoft Press, 1992. Foreword                                    69. Walla, M., and R. Williams, "Windows .NET Structure and
    by David Cutler.                                                                                      Architecture," Windows IT Library, April 2003, <www.win-
51. Russinovich, M., "Windows NT and VMS: The Rest of the Story,"                                         dowsitlibrary.com/Content/717/02/1.html >.
    December          1998,      <www.winnetmag.com/Articles/                                         70. S. Schreiber, Undocumented Windows 2000 Secrets, Boston: Add-
    Index.cfm?ArticleID=4494>.                                                                            ison-Wesley, 2001.
52. Custer, H., Inside Windows NT, Microsoft Press, 1992. Foreword                                    71. Walla, M., and R. Williams, "Windows .NET Structure and
    by David Cutler.                                                                                      Architecture," Windows IT Library, April 2003, <www.win-
53. Russinovich, M., "Windows NT and VMS: The Rest of the Story,"                                         dowsitlibrary.com/Content/717/02/1.html>.
    December          1998,     <www.winnetmag.com/Articles/                                          72. "Windows XP 64-Bit Frequently Asked Questions," March 28,
    Index.cfm?ArticleID=4494>.                                                                            2003,     <www.microsoft.com/windowsxp/64bit/evaluation/
54. J. Munro. "Windows XP Kernel Enhancements," ExtremeTech,                                              faq.asp>.
    June   8, 2001,     <www.extremetech.com/print_article/                                           73. "Dynamic-Link Libraries," MSDN Library, February 2003,
    0,3998,a=2473,00.asp>.                                                                                <msdn.microsoft.com/library/en-us/dllproc/base/
55. IBM, "Year 1987," <www-l.ibm.com/ibm/history/history/                                                 dynamic_link_libraries.asp>.
    year_1987.html>.                                                                                  74. "System Services Overview," Microsoft TechNet, viewed July 25,
56. Both, D, "A Short History of OS/2," December 18, 2002,                                                2003, <www.microsoft.com/TechNet/prodtechnol/winxppro/
    <www.millennium-technology.com/History0fOS2.html>.                                                    proddocs/sys_srv_overview_0l.asp>.
57. Necasek, M., "OS/2 1," < p a g e s . p r o d i g y . n e t / m i c h a l n / h i s -              75. Foley, J., "Services Guide for Windows XP," The Elder Geek,
    tory/os210/index.html>.                                                                               viewed           July            25,          2003             <www.theeldergeek.com/
                                                                                                          services_guide.htm#Services>.
58. Necasek, M., "OS/2 2," < p a g e s . p r o d i g y . n e t / m i c h a l n / h i s -
    tory/os220/index.html>.                                                                           76. "Registry,"              MSDN                    Library,                February                  2003,
                                                                                                          < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / s y s i n f o / b a s e / r e g i s-
59. Both, D., "A Short History of OS/2," December 18, 2002,
                                                                                                          try.asp>.
    <www.millennium-technology.com/History0f0S2.html>.
                                                                                                      77.      "Chapter 23—Overview of the Windows NT Registry,"
60. "The Foundations of Microsoft Windows NT System Architec-
                                                                                                             Microsoft TechNet, viewed July 21, 2003, <www.microsoft.com/
    ture," MSDN Library, Microsoft Corporation, September 1997,
                                                                                                             technet/prodtechnol/ntwrkstn/reskit/23_regov.asp>.
    <msdn.microsoft.com/ARCHIVE/en-us/dnarwbgen/html/
    msdn_ntfound.asp>.                                                                                78. "Structure of the Registry," MSDN Library, February 2003,
                                                                                                          <msdn.microsoft.com/library/en-us/sysinfo/base/
61. "Windows NT C2 Evaluations," Microsoft TechNet, Microsoft
                                                                                                          structure_of_the_registry.asp>.
    Corporation, December 2, 1999, <www.microsoft.com/tech-
    n e t / t r e e v i e w / d e f a u l t . a s p ? u r l = / t e c h n e t / s e c u ri ty/news/   79. "Predefined   Keys,"     MSDN              Library,           February              2003,
    c2summ.asp>.                                                                                          <msdn.microsoft.com/en-us/sysinfo/base/
62. "Fast Boot/Fast Resume Design," Microsoft Corporation, June                                           predefined_keys.asp>.
    12, 2002, <www.microsoft.com/whdc/hwdev/platform/per-                                             80. "Predefined   Keys,"     MSDN              Library,           February              2003,
    formance/fastboot/default.mspx>.                                                                      <msdn.microsoft.com/en-us/sysinfo/base/
                                                                                                          predefined_keys.asp>.
63. "MS Windows NT Kernel-Mode User and GDI White Paper,"
    Microsoft TechNet, viewed July 22, 2003, <www.microsoft.com/                                      81. "Opening, Creating, and Closing Keys," MSDN Library, Febru-
    technet/prodtechnol/ntwrkstn/evaluate/featfunc/ker-                                                   ary 2003, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / s y s i n f o /
    nelwp.asp>.                                                                                           base/opening_creating_and_closing_keys.asp>.
64. "DDK Glossary-Hardware Abstraction Layer (HAL)," MSDN                                             82. "Registry    Hives,"   MSDN               Library,           February               2003,
    Library, June 6, 2003, <msdn.microsoft.com/library/en-us/                                             <msdn.microsoft.com/1ibrary/en-us/sysinfo/base/
    gloss/hh/gloss/glossary_01ix.asp>.                                                                    regi stry_hives.asp>.
65. Walla, M., and R. Williams, "Windows .NET Structure and                                           83. Russinovich, M., "Inside the Registry," Windows & .NET Maga-
    Architecture," Windows IT Library, April 2003, <www.win-                                              zine,    May       1999      <www.win2000mag.com/Articles/
    dowsitlibrary.com/Content/717/02/1.html >.                                                            Index.cfm?ArticleID=5195>.
66. Solomon, D, and M. Russinovich, Inside Windows 2000, 3rd ed.,                                     84. "Object Management," MSDN Library, June 6, 2003,
    Redmond: Microsoft Press, 2000.                                                                       <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
                                                                                                          objects_033b.asp>.
67. "MS Windows NT Kernel-Mode User and GDI White Paper,"
    Microsoft TechNet, viewed July 22, 2003, <www.microsoft.com/                                      85. Russinovich, M., "Inside NT's Object Manager," Windows &
    technet/prodtechnol/ntwrkstn/evaluate/featfunc/ker-                                                   .NET Magazine, October 1997, <www.winnetmag.com/Arti-
    nelwp.asp>.                                                                                           cles/Index.cfm?IssueID=24&ArticleID=299>.
68. "Windows 2000 Architectural Tutorial," FindTutorials, viewed                                      86. "Object  Categories," MSDN Library,    February                                                2003,
    July 10, 2003, < t u t o r i a l s . f i n d t u t o r i a l s . c o m / r e a d / c a t e -          <msdn.microsoft.com/library/en-us/sysinfo/base/
    gory/97/id/379>.                                                                                      object_categori es.asp>.

<!-- pág. 1176 -->

1f26> 6a?e>5tudi{: tffndw/F
87. "Object  Handles,"  MSDN     Library, June   6,  2003,              105. "Alterable              I/O,"     MSDN Library, February   2003,
    <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                      <msdn.microsoft.com/library/en-us/fi1eio/base/
    objects_5btz.asp>.                                                       a l e r t a b l e _ i _ o . asp>.
88. "Handle Inheritance," MSDN Library, February               2003,    106. "Asynchronous Procedure Calls," MSDN Library, February
    <msdn.microsoft.com/library/en-us/sysinfo/base/                          2003,  <msdn.microsoft.com/library/en-us/dllproc/base/
    handle_i nheritance.asp>.                                                asynchronous_procedure_cal1s.asp>.
89. "Object   Handles," MSDN      Library, June   6,  2003              107. Hadjidoukas, P. E., "A Device Driver for W2K Signals," Windows
    <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                      Developer Network, September 7, 2003, <www.windevnet.com/
    objects_5btz.asp>.                                                       documents/s=7637/wdj0108a/0108a.htm?_temp=evgyijpt0a>.
90. "Object   Names,"  MSDN      Library, June   6,   2003,             108. "Asynchronous Procedure Calls," NTInsider,Vol. 5, No. 1, Janu-
    <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                      ary 1998,<www.osr.com/_ntinsider/1998/apc.htm>.
    objects_9kl3.asp>.                                                  109. "Introduction to DPCs," MSDN Library, June 6, 2003,
91. "Object   Manager,"    MSDN  Library,  February            2003,         <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
    <msdn.microsoft.com/library/en-us/sysinfo/base/                          intrupts_2zzb.asp>.
    obj ect_manager. asp>.                                              n o . "Managing Hardware Priorities," MSDN Library, June 6, 2003.
92. Russinovich, M., "Inside NT's Object Manager," Windows &                  <msdn.mi crosoft.com/library/en-us/kmarch/hh/kmarch/
    .NET Magazine, October 1997, <www.winnetmag.com/Arti-                     intrupts_0kh3.asp>.
    cles/Index.cfm?IssueID=24&ArticleID=299>.                           i n . "Writing an    ISR," MSDN Library,     June 6, 2003,
93. "Object  Manager,"    MSDN   Library,  February            2003,          <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
    <msdn.microsoft.com/library/en-us/sysinfo/base/                           intrupts_4ron.asp>.
    object_manager. asp>.                                               112. "Introduction to DPC Objects," MSDN Library, June 6, 2003,
94. "Life Cycle of an Object," MSDN Library, June 6, 2003,                   <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
    <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                      intrupts_0m1z.asp>.
    objects_16av.asp>.                                                  113. Russinovich, M, "Inside NT's Interrupt Handling," Windows &
95. "IRQL," MSDN Library, June 6, 2003, <msdn.microsoft.com/                 .NET Magazine, November 1997, <www.winntmag.com/Arti-
    library/en-us/kmarch/hh/kmarch/kl01_62b6.asp>.                           cles/Print.cfm?ArticleID=298>.
96. "Managing Hardware Priorities," MSDN Library, June 6, 2003,         114. "Stop OxOOOOOOOA or IRQL_NOT_LESS_OR_EQUAL,"
    <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                      Microsoft TechNet, viewed July 17, 2003, <www.microsoft.com/
    intrupts_0kh3.asp>.                                                      technet/prodtechnol/winxppro/reskit/
97. "Key Benefits of the I/O APIC," Windows Hardware and Driver              prmd_stp_hwpg.asp>.
    Central,   <www.microsoft.com/whdc/hwdev/platform/proc/             115. "Guidelines for Writing DPC Routines," MSDN Library,
    IO-APIC.mspx>.                                                           <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
98. "Managing Hardware Priorities," MSDN Library, June 6, 2003,              intrupts_6zon.asp>.
    <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                 116. Russinovich, M, "Inside NT's Interrupt Handling," Windows &
    i ntrupts_0kh3. asp>.                                                    .NET Magazine, November 1997, <www.winntmag.com/Arti-
99. "Windows DDK Glossary—Interrupt Dispatch Table (IDT),"                   cles/Print.cfm?ArticleID=298>.
    MSDN Library, June 6, 2003, <msdn.microsoft.com/library/            117. "KeSetTargetProcessorDPC," MSDN Library, June 6, 2003,
    en-us/gloss/hh/gloss/glossary_lqbd.asp>.                                 <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
100. "Windows DDK Glossary—Interrupt Dispatch Table (IDT),"                  kl05_9ovm.asp>.
     MSDN Library, June 6, 2003, <msdn.microsoft.com/library/           118. "KeSetlmportanceDPC," MSDN Library, June 6, 2003,
     en-us/gloss/hh/gloss/glossary_lqbd.asp>.                                <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
101. "Managing Hardware Priorities," MSDN Library, June 6, 2003,             kl05_2pf6.asp>.
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                119. "I've Got Work To Do—Worker Threads and Work Queues," AT
     i ntrupts_0kh3. asp>.                                                   Insider, Vol. 5, No. 5, October 1998 (updated August 20, 2002)
102. "Asynchronous Procedure Calls," NT Insider, Vol. 5, No. 1, Janu-        <www.osronline.com/article.cfm?i d=65>.
     ary 1998,<www.osr.com/ntinsider/1998/apc.htm>.                     120. "Device-Dedicated Threads," MSDN Library, June 6, 2003,
103. "Asynchronous Procedure Calls," NT Insider, Vol. 5, No. 1, Janu-        <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     ary 1998, <www.osr.com/ntinsider/1998/apc.htm>.                         synchro_9blj.asp>.

104. "QueueUserAPC,"    MSDN     Library,  February            2003,    121. "Managing Hardware Priorities," MSDN Library, June 6, 2003,
     <msdn.microsoft.com/library/en-us/dllproc/base/                         <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     queueuserapc.asp>.                                                      intrupts_0kh3.asp>.

<!-- pág. 1177 -->

                                                                                                                                           Works Cited 1127
122. "I've Got Work To Do—Worker Threads and Work Queues," NT         144- Richter, J., "Make Your Windows 2000 Processes Play Nice
     Insider, Vol. 5, No. 5, October 1998 (updated August 20, 2002)        Together with Job Kernel Objects," Microsoft Systems Journal,
     <www.osronline.com/article.cfm?id=65>.                                March 1999, <www.microsoft.com/msj/0399/jobkernelobj/
123. "System Worker Threads," MSDN Library, June 6, 2003,                  jobkernelobj.aspx>.
     <msdn.microsoft.com/en-us/kmarch/hh/kmarch/                      145. "JobObject_Basic_Limit_Information," MSDN Library, Febru-
     synchro_9ylz.asp>.                                                    ary 2003, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / d l l p r o c /
124. "Processes      and       Threads,"      MSDN         Library,        base/jobobject_basic_limit_information_str.asp>.
     <msdn.microsoft.com/library/en-us/dllproc/base/                  146. "SetlnformationJobObject," MSDN Library, February 2003,
     about_processes_and_threads.asp>.                                     < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / d l l p r o c / b a s e / s e t i n-
125. "Creating Processes," MSDN Library, <msdn.microsoft.com/              formationjobobject.asp>.
     library/en-us/dllproc/base/creating_processes.asp>.              147. "Job    Objects," MSDN     Library,   February                                                 2003,
126. "Event Objects," MSDN Library, <msdn.microsoft.com/                   <msdn.microsoft.com/library/en-us/dllproc/base/
     library/en-us/dllproc/base/event_objects.asp>.                        job_objects.asp>.
127. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed.,   148. Richter, J., "Make Your Windows 2000 Processes Play Nice
     Redmond: Microsoft Press, 2000.                                       Together with Job Kernel Objects," Microsoft Systems Journal,
128. Schreiber, S., Undocumented Windows 2000 Secrets, Boston:             March 1999, <www.microsoft.com/msj/0399/jobkernelobj/
     Addison-Wesley, 2001.                                                 jobkernelobj.aspx>.
129. Schreiber, S., Undocumented Windows 2000 Secrets, Boston:        149. "Fibers,"   MSDN       Library,    February                                                    2003,
     Addison-Wesley, 2001, p. 416.                                         <msdn.microsoft.com/library/en-us/dlproc/base/
130. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed,         fibers.aspx
     Redmond: Microsoft Press, 2000, p. 291.                          150. "Convert Thread to Fiber," MSDN Library, February 2003,
131. Schreiber, S., Undocumented Windows 2000 Secrets, Boston:             <msdn.microsoft.com/library/en-us/dllproc/base/con-
     Addison-Wesley, 2001, p. 429.                                         vertthreadtofiber.asp>.
132. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed,    151. "Fibers,"    MSDN       Library,    February                                                   2003,
     Redmond: Microsoft Press, 2000, p. 291.                               <msdn.microsoft.com/library/en-us/dllproc/base/
133. Schreiber, S., Undocumented Windows 2000 Secrets, Boston:             fibers.asp>.
     Addison-Wesley, 2001, p. 416.                                    152. Zabatta, F, and K. Ying, "A Thread Performance Comparison:
134. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed,         Windows NT and Solaris on a Symmetric Multiprocessor," Pro-
     Redmond: Microsoft Press, 2000, p. 319.                               ceedings of the Second USENIX Windows NT Symposium,
                                                                           August 5,1998, pp. 57-66.
135. Schreiber, S., Undocumented Windows 2000 Secrets, Boston:
     Addison-Wesley, 2001, p. 419.                                    153. Benjamin, C, "The Fibers of Threads," Compile Time (Linux
136. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed,         Magazine),   May   2001,    <www.linux-mag.com/2O01-05/
     Redmond: Microsoft Press, 2000, pp. 320-321.                          compile_06.html >.
137. Schreiber, S., Undocumented Windows 2000 Secrets, Boston:        154. "Thread   Pooling,"  MSDN    Library,  February                                                2003,
     Addison-Wesley, 2001, p. 429.                                         <msdn.microsoft.com/library/en-us/dllproc/base/
                                                                           thread_pooling.asp>.
138. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed,
     Redmond: Microsoft Press, 2000, p. 328.                          155. "Queue User Worker Item," MSDN Library, February 2003,
139. "Thread Local Storage," MSDN Library, February 2003,                  <msdn.microsoft.com/library/en-us/dllproc/base/
                                                                           queueuserworkitem.aspx
     <msdn.microsoft.com/library/en-us/dllproc/base/
     thread_local_storage.asp>.                                       156. Richter, J., "New Windows 2000 Pooling Functions Greatly Sim-
140. "Creating Processes," MSDN Library, February 2003,                    plify Thread Management," Microsoft Systems Journal, April
     <msdn.microsoft.com/library/en-us/dllproc/base/                       1999,            <www.microsoft.com/msj/0499/pooling/pool-
     creating_processes.asp>.                                              ing.aspx>.
141. "Inheritance,"    MSDN        Library,    February      2003,    157. Richter, J., "New Windows 2000 Pooling Functions Greatly Sim-
     <msdn.microsoft.com/library/en-us/dllproc/base/inher-                 plify Thread Management," Microsoft Systems Journal, April
     itance.aspx                                                           1999,            <www.microsoft.com/msj/0499/pooling/pool-
                                                                           ing.aspx>.
142. "About Processes and Threads," MSDN Library, February 2003,
     <msdn.microsoft.com/library/en-us/dllproc/base/                  158. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed,
     about_processes_and_threads.asp>.                                     Redmond: Microsoft Press, 2000.
143. "Terminating a Process," MSDN Library, February 2003,            159. "Scheduling Priorities," MSDN Library, February                                                2003,
     <msdn.microsoft.com/library/en-us/dllproc/base/                       <msdn.microsoft.com/library/en-us/dllproc/base/
     terminating_a_process.asp>.                                           scheduling_priorities.asp>.

<!-- pág. 1178 -->

1128 Case Study: Windows XP
i6o. "Win_32     Thread,"   MSDN      Library, July                                         2003,      180. "Synchronicity: A Review of Synchronization Primitives," NT
     <msdn.microsoft.com/library/en-us/wmisdk/wmi/                                                          Insider, Vol. 9, No. 1, January 1, 2002, <www.osr.com/ntin-
     win32_thread.asp>.                                                                                     sider/2002/synchronicity/synchronicity.htm>.
161. Solomon, D., and M. Russinovich, Inside Windows, 2000, 3rd ed,                                    181. "Semaphore Objects," MSDN Library, February 2003,
     Redmond: Microsoft Press, 2000, pp. 348-349.                                                           <msdn.microsoft.com/library/en-us/dllproc/base/
                                                                                                            semaphore_objects.asp>.
162. "Scheduling            Priorities,"           MSDN Library, February                   2003,
     <msdn.microsoft.com/library/en-us/dllproc/base/                                                   182. "Waitable Timer Objects," MSDN Library, February 2003,
     s c h e d u l i n g _ p r i o r i t i e s . asp>.                                                      <msdn.microsoft.com/library/en-us/dllproc/base/
                                                                                                            waitable_timer_objects.asp>.
163. "Scheduling Priorities," MSDN  Library, February                                       2003,
     <msdn.microsoft.com/library/en-us/dllproc/base/
                                                                                                       183. "Synchronization Objects," MSDN Library, February 2003,
     scheduling_priorities.asp>.
                                                                                                            <msdn.microsoft.com/library/en-us/dllproc/base/
                                                                                                            synchronization_objects.asp>.
164. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed,
                                                                                                       184. "Synchronizing Access to Device Data," MSDN Library, June 6,
     Redmond: Microsoft Press, 2000, pp. 356-358.
                                                                                                            2003,       <msdn.microsoft.com/library/en-us/kmarch/hh/
165. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed,                                          kmarch/intrupts_9sfb.asp>.
     Redmond: Microsoft Press, 2000, pp. 338,347.                                                      185. "Introduction to Spin Locks," MSDN Library, June 6, 2003,
166. "Scheduling Priorities," MSDN Library, < m s d n . m i c r o s o f t . c o m /                         <msdn.microsoft.com/1i brary/en-us/kmarch/hh/kmarch/
     library/en-us/dllproc/base/                                                                            synchro_8qsn.asp>.
     scheduling_priorities.asp>.                                                                       186. "Queued Spin Locks," MSDN Library, June 6, 2003,
167. "Priority Boosts," MSDN Library,   <msdn.microsoft.com/                                                <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     library/en-us/dllproc/base/priority_boosts.asp>.                                                       synchro_8ftz.asp>.
168. "Priority Inversion," MSDN Library, < m s d n . m i c r o s o f t . c o m /                       187. Friedman, M., and O. Pentakola, "Chapter 5: Multiprocessing,"
     library/en-us/dl1proc/base/priority_inversion.asp>.                                                    Windows    2000    Performance    Guide,    January     2002,
                                                                                                            <www.orei11y.com/catalog/w2kperf/chapter/ch05.html>.
169. " M u l t i p l e Processors," MSDN Library, < m s d n . m i c r o s o f t . c o m /
     library/en-us/dllproc/base/multipie_processors.asp>.
                                                                                                       188. "Queued Spin Locks," MSDN Library, June 6, 2003.
                                                                                                            <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
170. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed,                                          synchro_8ftz.asp>.
     Redmond: Microsoft Press, 2000, p. 371.
                                                                                                       189. "Fast     Mutexes,"     MSDN      Library, June   6,    2003.
171. " M u l t i p l e Processors," MSDN Library, < m s d n . m i c r o s o f t . c o m /                   <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     library/en-us/dllproc/base/multipie_processors.asp>.                                                   synchro_3zmv.asp>.
172. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed,                                     190. "Synchronicity: A Review of Synchronization Primitives," NT
     Redmond: Microsoft Press, 2000, pp. 371-373.                                                           Insider, Vol. 9, No. 1, January 2002, <www.osr.com/ntinsider/
173. "Introduction to Kernel Dispatcher Objects," MSDN Library,                                             2002/synchronicity/synchronicity.htm>.
     June 6, 2003, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / k m a r c h /   191. "Fast     Mutexes,"     MSDN      Library, June   6,    2003,
     hh/kmarch/synchro_7kfb.asp>.                                                                           <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
174. "Interprocess Synchronization," MSDN Library, February 2003,
                                                                                                            synchro_3zmv.asp>.
     <msdn.microsoft.com/library/en-us/dllproc/base/                                                   192. "Synchronicity: A Review of Synchronization Primitives," NT
     interprocess_synchronization.asp>.                                                                     Insider, Vol. 9, No. 1, January 2002, <www.osr.com/ntinsider/
                                                                                                            2002/synchronicity/synchronicity.htm>.
175. "Wait  Functions,"  MSDN     Library,  February                                        2003,
     <msdn.microsoft.com/library/en-us/dl1proc/base/                                                   193. "Critical Section Objects," MSDN Library, February 2003,
       wait_functions.asp>.                                                                                 <msdn.microsoft.com/library/en-us/dllproc/base/
                                                                                                            critical_section_objects.asp>.
176. " M u t e x Objects," MSDN   Library,  February                                        2003,
                                                                                                       194. Prasad, S., "Windows NT Threads," BYTE, November 1995,
     <msdn.microsoft.com/library/en-us/dllproc/base/
                                                                                                            <www.byte.com/art/9511/secll/art3.htm>.
     mutex_objects.asp>.
                                                                                                       !95- "Time    Queues,"  MSDN     Library,   February         2003,
177. "Event   Objects,"  MSDN     Library,  February                                        2003,
                                                                                                            <msdn.microsoft.com/library/en-us/dllproc/base/
     <msdn.microsoft.com/library/en-us/dllproc/base/
     event_objects.asp>.                                                                                    timer_queues.asp>.

178. " M u t e x Objects," MSDN   Library,  February                                        2003,
                                                                                                       196. "Interlocked Variable Access," MSDN Library, February 2003.
     <msdn.microsoft.com/library/en-us/dllproc/base/
                                                                                                            <msdn.microsoft.com/library/en-us/dllproc/base/
     mutex_objects.asp>.
                                                                                                            interlocked_variable_access.asp>.
                                                                                                       197. "Interlocking Singly Linked Lists," MSDN Library, February
179. "Semaphore  Objects,"   MSDN  Library,  February                                       2003,
                                                                                                            2003,    <msdn.microsoft.com/library/en-us/dllproc/base/
     <msdn.microsoft.com/library/en-us/dllproc/base/
                                                                                                            interlocked_singly_linked_lists.asp>.
     semaphore_objects.asp>.

<!-- pág. 1179 -->

                                                                                                                                  Works Cited 1129
198. "Introducing 64-Bit Windows," MSDN Library, February 2003,   214. "Memory Management Enhancements," MSDN Library, Febru-
     <msdn.microsoft.com/library/en-us/win64/win64/intro               ary 13, 2003, <msdn.microsoft.com/library/en-us/appen-
     ducing_64_bit_windows.asp>.                                       dix/hh/appendix/enhancements5_3oc3.asp?frame=true>.
199. "Memory Support and Windows Operating Systems," Microsoft    215. "Bug Check 0x41: Must_Succeed_Pool_Empty," MSDN Library,
     Windows Platform Development, Microsoft Corporation,              June 6, 2003, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / d d t o o l s /
     December 4, 2001, <www.microsoft.com/hwdev/platform/              hh/ddtools/bccodes_Obon.asp?frame=true>.
     server/PAE/PAEmem.asp>.
                                                                  216. Munro, I, "Windows XP Kernel Enhancements," ExtremeTech,
200. "NT Memory, Storage, Design, and More," <www.windowsitli-         June   8,   2001,   <www.extremetech.com/print_article/
     brary.com/Content/113/01/1.html>.                                 0,3998,a=2473,00.asp>.
201. R. Kath, "The Virtual-Memory Manager in Windows NT,"         217. Munro, J., "Windows XP Kernel Enhancements," ExtremeTech,
     MSDN Library, December 21, 1992, <msdn.microsoft.com/             June   8,   2001,   <www.extremetech.com/print_article/
     library/en-us/dngenlib/html/                                      0,3998,a=2473,00.asp>.
     msdn_ntvmm.asp?frame=true>.
                                                                  218. Russinovich, M., "Inside Memory Management, Part 2," Win-
202. R. Kath, "The Virtual-Memory Manager in Windows NT,"              dows & .NET Magazine, September 1998, <www.winnet-
     MSDN Library, December 21, 1992, <msdn.microsoft.com/             mag.com/Articles/Print.cfm?ArticleID=3774>.
     library/en-us/dngenlib/html/
                                                                  219. Kath, R., "The Virtual-Memory Manager in Windows NT,"
     msdn_ntvmm.asp?frame=true>.
                                                                       MSDN Library, December 21, 1998, <msdn.microsoft.com/
203. "Memory Protection," MSDN Library, February 2003,                 library/en-us/dngenlib/html/msdn_ntvtnm.asp?
     <msdn.microsoft.com/library/default.asp?url=/library/             frame=true>.
     en-us/memory/base/memory_protection.asp>.
                                                                  220. "Windows NT Virtual Memory (Part II)," OSR Open Systems
204. "Large Page Support," MSDN Library, February         2001,        Resources,  Inc.,   1999,  <www.osr.com/ntinsider/1999/
     <msdn.microsoft.com/library/en-us/memory/base/                    virtualmem2/virtualmem2.htm>.
     large_page_support.asp?frame=true>.
                                                                  221. Friedman, M., "Windows NT Page Replacement Policies," Com-
205. Russinovich, M., and D. Solomon, "Windows XP: Kernel              puter Measurement Group CMG, 1999, <www.demandtech.com/
     Improvements Create a More Robust, Powerful, and Scalable         Resources/Papers/WinMemMgmt.pdfx
     OS," MSDN Magazine, December 2001, <msdn.microsoft.com/
                                                                  222. "How Windows NT Provides 4 Gigabytes of Memory," Microsoft
     msdnmag/issues/01/12/XPKernel/print.asp>.
                                                                       Knowledge Base Article—99707, February 20, 2002, <www.itpa-
206. R. Kath, "The Virtual-Memory Manager in Windows NT,"              pers.com/cgi/PSummaryIT.pi?paperid=23661&scid=273>.
     MSDN Library, December 21, 1992, <msdn.microsoft.com/
                                                                  223. Munro, J., "Windows XP Kernel Enhancements," June 8, 2001,
     library/en-us/dngenlib/html/
                                                                       <www.extremetech.com/print_article/
     msdn_ntvmm.asp?frame=true>.
                                                                       0,3998,a=2473,00.asp>.
207. "GetLargePageMinimum," MSDN Library, February 2003,
                                                                  224. LaBorde, D., "TWEAKS for Windows XP for Video Editing (v.
     <msdn.microsoft.com/library/en-us/memory/base/get-
                                                                       1.0)," SlashCAM.com, 2001, <www.siashcam.de/artikel/Tips/
     largepageminimum.asp>.
                                                                       TWEAKS_for_Windows_XP_for_Video_
208. "Large Page Support," MSDN Library, February         2001,        Editing_v_l_0_.html>.
     <msdn.microsoft.com/library/en-us/memory/base/
                                                                  225. "Memory Management Enhancements," MSDN Library,
     large_page_support.asp?frame=true>.
                                                                       <msdn.microsoft.com/library/en-us/appendix/hh/appen-
209. GetLargePageMinimum," MSDN Library, February 2003,                dix/enhancements 5_3oc3.asp>.
     <msdn.microsoft.com/library/en-us/memory/base/get-
                                                                  226. "Memory Management Enhancements," MSDN Library,
     largepageminimum.asp>.
                                                                       <msdn.microsoft.com/library/en-us/appendix/hh/appen-
210. "Large Page Support in the Linux Kernel," LWN.net. 2002,          dix/enhancements 5_3oc3.asp>.
     <lwn.net/Articles/6969/>.
                                                                  227. LaBorde, D., "Windows XP Tweaks/Optimizations for Windows
211. Kath, R., "The Virtual-Memory Manager in Windows NT,"             XP for Video Editing Systems-Part II," SlashCAM, 2002,
     MSDN Library, December 21, 1992, <msdn.microsoft.com/             <www.siashcam.de/artikel/Tips/Windows
     library/en-us/dngenlib/html/msdn_ntvmm.asp>.                        _XP_TWEAKS_Optimization_for_Video_Editing_Systerns_
212. Friedman, M. B., "Windows NT Page Replacement Policies,"            _PART_II.html>.
     Computer Measurement Group, 1999, <www.demandtech.com/       228. "Fast System Startup for PCs Running Windows XP," Windows
     Resources/Papers/WinMemMgmt.pdf>.                                 Platform Design Notes: Designing Hardware for the Microsoft'1'
213. "Allocating Virtual Memory," MSDN Library, February 2003,         Windows® Family of Operating Systems, Microsoft Corporation,
     <msdn.microsoft.com/library/en-us/memory/base/                    January 31, 2002, <www.microsoft.com/hwdev/platform/per-
     allocating_virtual_memory.asp?frame=true>.                        formance/fastboot/fastboot-winxp.asp>.

<!-- pág. 1180 -->

1130 Case Study: Windows XP

229- Kath, R., "Managing Virtual Memory in Win23," MSDN Library,               Systems Journal, November 1998, <www.microsoft.com/msj/
     January 20, 1993, <msdn.microsoft.com/library/en-us/                      1998/ntfs/ntfs.aspx>.
     dngenlib/html/msdn_virtmm.asp?frame=true>.                         247. Russinovich, M., "Inside NTFS," Windows & .NET Magazine,
230. Kath, R., "The Virtual-Memory Manager in Windows NT,"                   January        1998,       <www.win2000mag.com/Articles/
     MSDN Library, December 21, 1992, <msdn.microsfot.com/                   Print.cfm?ArticleID=3455>.
     library/en-us/dngenlib/html/msdn_ntvmm.asp?                        248. Custer, H., Inside the Windows NT File System, Redmond:
     frame=true>.                                                            Microsoft Press, 1994, pp. 24-28.
231. LaBorde, D., "TWEAKS for Windows XP for Video Editing (v.          249. Russinovich, M., "Inside NTFS," Windows & .NET Magazine,
     1.0)," Slashcam.com, 2001, <www.slashcam.de/artikel/Tips/               January       1998.         <www.win200mag.com/Articles/
     TWEAKS_for_Windows_XP_for_Video_                                        Print.cfm?ArticleID=3455>.
     E d i t i n g _ v _ l _ 0 _ . html >.
                                                                        250. Esposito, D., "A Programmer's Perspective on NTFS 2000, Part
232. Friedman, M. B., "Windows NT Page Replacement Policies,"                1: Stream and Hard Link," MSDN Library, March 2000,
     Computer Measurement Group CMG, 1999, <www.demand-                      <msdn.microsoft.com/library/en-us/dnfiles/html/
     tech.com/Resources/Papers/WinMemMgmt.pdf>.                              ntfs5.asp>.
233. Friedman, M. B., "Windows NT Page Replacement Policies,"           251. Richter, J., and L. F. Cabrera, "A File System for the 21st Cen-
     Computer Measurement Group CMG, 1999, <www.demand-                      tury: Previewing the Windows NT 5.0 File System," Microsoft
     tech.com/Resources/Papers/WinMemMgmt.pdf>.                              Systems Journal, November 1998, <www.microsoft.com/msj/
234. Kath, R., "The Virtual-Memory Manager in Windows NT,"                   1198/ntfs/ntfs.aspx>.
     MSDN Library, December 21, 1992, <msdn.microsoft.com/              252. Richter, J., and L. F. Cabrera, "A File System for the 21st Cen-
     library/en-us/dngenlib/html/msdn_ntvmm.asp?                             tury: Previewing the Windows NT 5.0 File System," Microsoft
     frame=true>.                                                            Systems Journal, November 1998, <www.microsoft.com/msj/
235. Russinovich, M., "Inside Memory Management, Part 2," Win-               1198/ntfs/ntfs.aspx>.
     dows & .NET Magazine, September 1998, <www.winnet-                 253. Esposito, D., "A Programmer's Perspective on NTFS 2000, Part
     mag.com/Articles/Index.cfm?ArticleID=3774&pg=2>.                        2: Encryption, Sparseness, and Reparse Points," MSDN Library.
236. Friedman, M. B., "Windows NT Page Replacement Policies,"                May 2000, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / d n f i l e s /
     Computer Measurement Group CMG, 1999, <www.demand-                      html/ntfs2.asp>.
     tech.com/Resources/Papers/WinMemMgmt.pdf>.
                                                                        254. "NTFS,"        MSDN            Library,                 February                   2003.
237. Friedman, M. B., "Windows NT Page Replacement Policies,"                <msdn.microsoft.com/library/en-us/fileio/base/
     Computer Measurement Group CMG, 1999, <www.demand-                      ntfs.asp>.
     tech.com/Resources/Papers/WinMemMgmt.pdf>.
                                                                        255. Phamdo, N., "Lossless Data Compression," Data-Compres-
238. Anderson, C, "Windows NT Paging Fundamentals," Windows &                sion.com, 2001, <www.data-compression.com/lossless.html>.
     .NET Magazine, November 1997, <www.winnetmag.com/Arti-
                                                                        256. Richter, J., and L. F. Cabrera, "A File System for the 21st Cen-
     cles/Print.cfm?ArticleID=595>.
                                                                             tury: Previewing the Windows NT 5.0 File System," Microsoft
239. Munro, J., "Windows XP Kernel Enhancements," ExtremeTech,               Systems Journal, November 1998, <www.microsoft.com/msj/
     June    8,   2001,   <www.extremetech.com/print_article/                1198/ntfs/ntfs.aspx>.
     0,3998,a=2473,00.asp>.
                                                                        257. Richter, J., and L. F. Cabrera, "A File System for the 21st Cen-
240. "When Should Code and Data Be Pageable?" MSDN Library,                  tury: Previewing the Windows NT 5.0 File System," Microsoft
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                     Systems Journal, November 1998, <www.microsoft.com/msj/
     memmgmt_7vhj.asp?frame=true>.                                           1198/ntfs/ntfs.aspx>.
241. "Device Drivers and File System Drivers Defined," MSDN             258. Esposito, D., "A Programmer's Perspective on NTFS 2000, Part
     Library, February 13, 2003, <msdn.microsoft.com/library/                2: Encryption, Sparseness, and Reparse Points," MSDN Library.
     en-us/gstart/hh/gstart/gs_basics_4w6f.asp>.                             May 2000, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / d n f i l e s /
242. Custer, H., Inside the Windows NT File System, Redmond:                 html/ntfs2.asp>.
     Microsoft Press, 1994.                                             259. Richter, J., and L. F. Cabrera, "A File System for the 21st Cen-
243. "File Systems," Microsoft TechNet, September 10, 2003,                  tury: Previewing the Windows NT 5.0 File System," Microsoft
     <www.microsoft.com/technet/prodtechnol/winxppro/res-                    Systems Journal, November 1998, <www.microsoft.com/msj/
     kit/prkc_fil_buvl.asp>.                                                 1198/ntfs/ntfs.aspx>.
244. Custer, H., Inside the Windows NT File System, Redmond:            260. Richter, J., and L. F Cabrera, "A File System for the 21st Cen-
     Microsoft Press, 1994, p. 17.                                           tury: Previewing the Windows NT 5.0 File System," Microsoft
245. Solomon, D, and M. Russinovich, Inside Windows 2000, 3rd ed.,           Systems Journal, November 1998, <www.microsoft.com/msj/
     Redmond: Microsoft Press, 2000.                                         1198/ntfs/ntfs.aspx>.
246. Richter, J., and L. F. Cabrera. "A File System for the 21st Cen-   261. "Microsoft Windows XP: What's New in Security for Windows
     tury: Previewing the Windows NT 5.0 File System," Microsoft             XP Professional and Windows XP Home," Microsoft Corpora-

<!-- pág. 1181 -->

                                                                                                                                                                      Works Cited 1131
       tion,  July   2001.   <www.microsoft.com/windowsxp/pro/                                       275- "Device   Extensions," MSDN    Library, June 6,  2003,
       techinfo/planning/security/whatsnew/WindowsXPSecu-                                                 <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
       rity.doo.                                                                                          devobjts_1gdj.asp>.
262. Richter, J., and L. F. Cabrera, "A File System for the 21st Cen-                                276. "Introduction to Driver Objects," MSDN Library, June 6, 2003,
     tury: Previewing the Windows NT 5.0 File System," Microsoft                                          <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     Systems Journal, November 1998, <www.microsoft.com/msj/                                              drvcomps_6js7.asp>.
     1198/ntfs/ntfs.aspx>.
                                                                                                     277. "Introduction to Standard Driver Routines," MSDN Library,
263. Esposito, D., "A Programmer's Perspective on NTFS 2000, Part                                         June 6, 2003, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / k r n a r c h /
     1: Stream and Hard Link," MSDN Library, March 2000,                                                  hh/kmarch/drvcomps_24kn.asp>.
     <msdn.microsoft.com/library/en-us/dnfiles/html/
                                                                                                     278. "Introduction to Plug and Play," MSDN Library, June 6, 2003,
     ntfs5.asp>.
                                                                                                          <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
264. Esposito, D., "A Programmer's Perspective on NTFS 2000, Part                                         plugplay_2tyf.asp>.
     2: Encryption, Sparseness, and Reparse Points," MSDN Library,
                                                                                                     279. "PnP    Components,"  MSDN    Library, June  6,  2003,
     May 2000, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / d n f i l e s /
     html/ntfs2.asp>.                                                                                     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
                                                                                                          plugplay_4bs7.asp>.
265. Richter, J., and L. F. Cabrera, "A File System for the 21st Cen-
     tury: Previewing the Windows NT 5.0 File System," Microsoft                                     280. "PnP Driver Design Guidelines," MSDN Library, June 6, 2003,
     Systems Journal, November 1998, <www.microsoft.com/msj/                                              <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     1198/ntfs/ntfs.aspx>.                                                                                plugplay_890n.asp>.

266. Richter, J., and L. F. Cabrera, "A File System for the 21st Cen-                                281. "Levels of Support for PnP," MSDN Library, June 6, 2003,
     tury: Previewing the Windows NT 5.0 File System," Microsoft                                          <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     Systems Journal, November 1998, <www.microsoft.com/msj/                                              plugplay_78o7.asp>.
     1198/ntfs/ntfs.aspx>.                                                                           282. "Power   Manager,"  MSDN     Library, June   6,  2003,
267. Esposito, D., "A Programmer's Perspective on NTFS 2000, Part                                         <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     2: Encryption, Sparseness, and Reparse Points," MSDN Library,                                        pwrmgmt_30vb.asp>.
     May 2000, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / d n f i l e s /   283. "System Power Policy," MSDN Library, June 6, 2003,
     html/ntfs2.asp>.                                                                                     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
268. Esposito, D., "A Programmer's Perspective on NTFS 2000, Part                                         pwrmgmt_8baf.asp>.
     2: Encryption, Sparseness, and Reparse Points," MSDN Library,                                   284. " D r i v e r Role in Power Management," MSDN Library, June 6,
     May 2000, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / d n f i l e s /        2003,            <msdn.microsoft.com/library/en-us/kmarch/hh/
     html/ntfs2.asp>.                                                                                     kmarch/pwrmgmt_47jb.asp>.
269. Richter, J., and L. F. Cabrera, "A File System for the 21st Cen-                                285. "Power IRPs for Individual Devices," MSDN Library, June 6,
     tury: Previewing the Windows NT 5.0 File System," Microsoft                                          2003,     <msdn.microsoft.com/library/en-us/kmarch/hh/
     Systems Journal, November 1998, <www.microsoft.com/msj/                                              kmarch/pwrmgmt_6azr.asp>.
     1198/ntfs/ntfs.aspx>.
                                                                                                     286. "Device Power States," MSDN Library, June 6, 2003,
270. "Overview of the Windows I/O Model," MSDN Library, June 6,
                                                                                                          <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     2003,      <msdn.microsoft.com/library/en-us/kmarch/hh/
                                                                                                          pwrmgmt_20f b.asp>.
     kmarch/irps_0rhj.asp>.
                                                                                                     287. "Device Sleeping States," MSDN Library, June 6, 2003,
271. "Plug and Play for Windows 2000 and Windows XP," Windows
                                                                                                          <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     Hardware and       Driver Central,  December 4, 2001,
                                                                                                          pwrmgmt_2i p3.asp>.
     <www.microsoft.com/whdc/hwdev/tech/pnp/
       pnpnt5_2.mspx>.                                                                               288. "System Power States," MSDN Library, June 6, 2003,
                                                                                                          <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
272. "Introduction to Device Objects," MSDN Library, June 6, 2003,
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                                                  pwrmgmt_919j.asp>.
     devobjts_4f qf.asp>.                                                                            289. "Introduction    to     WDM,"       MSDN        Library,
273. "WDM Driver Layers: An Example," MSDN Library, June 6,                                               <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     2003,     <msdn.microsoft.com/library/en-us/kmarch/hh/                                               wdmintro_lep3.asp>.
     kmarch/wdmintro_4uuf.asp>.                                                                      290. "Bus           Drivers,"        MSDN Library, June 6, 2003,
274. "Types of Drivers," MSDN Library, June 6, 2003,                                                      <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                                                  w d m i n t r o _ 8 n f r.asp>.
     intro_8r6v.asp>.                                                                                291. "Filter  Drivers,"  MSDN     Library, June   6,  2003,
                                                                                                          <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
                                                                                                          wdmintro_7dpj.asp>.

<!-- pág. 1182 -->

1132 Case Study: Windows XP

292. "Introduction to Device Interface," MSDN Library, June 6,2003,   309. "Synchronization and Overlapped Input and Output," MSDN
     <msdn.microsoft.com/library/en-us/install/hh/install/                 Library, February 2003, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n -
     setup-cls_8vs7.asp>.                                                  us/dl1proc/base/synchronization_and_overlapped_input_
293. "Function Drivers," MSDN Library,      June  6, 2003.                 and_output.asp>.
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/              310. "Alertable   I/O,"  MSDN    Library,  February                                2003,
     wdmintro_27f r.asp>.                                                  <msdn.microsoft.com/library/en-us/fileio/base/
294. "Types of Drivers," MSDN Library, June 6, 2003,                       alertable_i_o.asp>.
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/              311. " I / O Completion Ports," MSDN Library, February                             2003,
     intro_8r6v.asp>.                                                      <msdn.microsoft.com/library/en-us/fileio/base/
                                                                           i_o_completion_ports.asp>.
295. "Types of WDM Drivers," MSDN Library, June 6, 2003,
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/              312. "Methods for Accessing Data Buffers," MSDN Library, June 6,
     wdmi ntro_3ep3.asp>.                                                  2003,      <msdn.microsoft.com/library/en-us/kmarch/hh/
                                                                           kmarch/iputoput_3m07.asp>.
296. "Introduction    to     WDM,"       MSDN        Library,
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/              313. "Using  Buffered   I/O," MSDN Library,  June  6, 2003,
     wdmintro_lep3.asp>.                                                   <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
                                                                           i putoput_lulj.asp>.
297. "Introduction to WMI," MSDN Library, June 6, 2003,
                                                                      314. "Methods for Accessing Data Buffers," MSDN Library, June 6,
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     wmi_5alz.asp>.                                                        2003,      <msdn.microsoft.com/library/en-us/kmarch/hh/
                                                                           kmarch/iputoput_3m07.asp>.
298. "How NT Describes I/O Requests," NT Insider, Vol. 5, No. 1,
                                                                      315. "Using  Buffered   I/O," MSDN Library,  June  6, 2003.
     January   1998,  <www.osr.com/ntinsider/1998/Requests/
                                                                           <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     requests.htm>.
                                                                           i putoput_lulj.asp>.
299. "I/O Status Blocks," MSDN Library, June 6, 2003,
                                                                      316. "Using Direct I/O with D M A , " MSDN Library, June 6, 2003,
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
                                                                           <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     irps_Oofb.asp>.
                                                                             iputoput_0gx3.asp>.
300. "I/O Stack Locations," MSDN Library, June 6, 2003,
                                                                      317. "Using Neither Buffered nor Direct I/O," MSDN Library, June 6.
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
                                                                           2003,      <msdn.microsoft.com/library/en-us/kmarch/hh/
     irps_81gn.asp>.
                                                                           kmarch/iputoput_3cbr.asp>.
301. "Starting a Device," MSDN Library, June 6, 2003,                 318. " H o w NT Describes I/O Requests," NT Insider, Vol. 5, No. 1,
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                   January    1998,    <www.osr.com/ntinsider/1998/Requests/
     plugplay_4otj.asp>.
                                                                           requests.htm>.
302. "I/O Stack Locations," MSDN Library, June 6, 2003,               319. "Methods for Accessing Data Buffers," MSDN Library, June 6.
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                   2003,      <msdn.microsoft.com/library/en-us/kmarch/hh/
     irps_81gn.asp>.                                                       kmarch/iputoput_3m07.asp>.
303. "Example I/O Request—The Details," MSDN Library, June 6,         320. "Example I/O Request—The Details," MSDN Library, June 6.
     2003,      <msdn.microsoft.com/library/en-us/kmarch/hh/               2003,     <msdn.microsoft.com/library/en-us/kmarch/hh/
     kmarch/irps_le3r.asp>.                                                kmarch/irps_le3r.asp>.
304. "Registering an I/O Completion Routine," MSDN Library, June      321. "InterruptService," MSDN    Library, June    6,  2003.
     6, 2003, <msdn.microsoft.com/library/en-us/kmarch/hh/                 <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     kmarch/irps_6dd3.asp>.                                                drvrrtns_29ma.asp>.
305. "Example I/O Request—The Details," MSDN Library, June 6,         322. "Registering an  ISR," MSDN Library, June 6, 2003.
     2003,      <msdn.microsoft.com/library/en-us/kmarch/hh/               <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     kmarch/irps_le3r.asp>.                                                  intrupts_87qf.asp>.
306. "Example I/O Request—The Details," MSDN Library, June 6,         323. "Introduction to Interrupt Objects," MSDN Library, June 6.
     2003,      <msdn.microsoft.com/library/en-us/kmarch/hh/               2003,       <msdn.microsoft.com/library/en-us/kmarch/hh/
     kmarch/irps_le3r.asp>.                                                kmarch/intrupts_417r.asp>.
307. "Queuing and Dequeuing IRPs," MSDN Library, June 6, 2003,        324. "Registering an  ISR," MSDN Library,    June 6, 2003.
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                   <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     irps_4mqv.asp>.                                                       intrupts_87qf.asp>.
308. "Synchronous and Asynchronous I/O," MSDN Library, February       325. "Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed.
     2003     <msdn.microsoft.com/library/en-us/fileio/base/               Redmond: Microsoft Press, 2000, p. 92.
     synchronous_and_asynchronous_i_o.asp>.

<!-- pág. 1183 -->

                                                                                                                                    Works Cited 1133

326. "Key Benefits of the I/O APIC," Windows Hardware and Driver        344- "Named Pipe Type, Read, and Wait Modes," MSDN Library,
     Central,   <www.microsoft.com/whdc/hwdev/platform/proc/                 February 2003, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / i p c /
     IO-APIC.mspx>.                                                          base/named_pipe_type_read_and_wait_modes.asp>.
327. "Writing an ISR," MSDN Library, June 6, 2003,                      345. "Named Pipes Open Modes," MSDN Library, February 2003,
     <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/                     <msdn.microsoft.com/library/en-us/ipc/base/
     intrupts_4ron.asp>.                                                     named_pipe_open_modes.asp>.
328. "File   Caching,"  MSDN    Library,   February            2003,    346. "Named Pipe Type, Read, and Wait Modes," MSDN Library,
     <msdn.microsoft.com/library/en-us/fileio/base/                          February 2003,  <msdn.microsoft.com/library/en-us/ipc/
     file_caching.asp>.                                                      base/named_pipe_type„read_and_wait_modes.asp>.
329. "The NT Cache Manager," NT Insider, Vol. 3, No. 2, April 1996,     347. "Synchronous and Overlapped Input and Output," MSDN
     <www.osr.com/ntinsider/1996/cacheman.htm>.                              Library, February 2003, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n -
330. "The NT Cache Manager," NT Insider, Vol. 3, No. 2, April 1996.          us/ipc/base/
     <www.osr.com/ntinsider/1996/cacheman.htm>.                                synch ronous_and_overlapped_input_and_output.asp>.
331. "File Caching,"   MSDN     Library,   February            2003,    348. "Mailslots,"    MSDN     Library,    February                                      2003,
     <msdn.microsoft.com/library/en-us/fileio/base/                          <msdn.microsoft.com/library/en-us/ipc/base/
     file_caching.asp>.                                                      mailslots.asp>.

332. "Life in the Fast I/O Lane," NT Insider, Vol. 3, No. 1, February   349. " A b o u t Mailslots," MSDN Library,  February                                    2003,
     15, 1996, updated October 31, 2002, <www.osronline.com/                 <msdn.microsoft.com/library/en-us/ipc/base/
     article.cfm?id=166>.                                                    about_mailsiots.asp>.

333. "File Caching,"   MSDN     Library,   February            2003,    350. " A b o u t Mailslots," MSDN Library,  February                                    2003,
     <msdn.microsoft.com/library/en-us/fileio/base/                          <msdn.microsoft.com/library/en-us/ipc/base/
     file_caching.asp>.                                                      about_mailslots.asp>.

334. "Mailslots,"    MSDN     Library,    February             2003,    351. " C o m m o n Windows Term Glossary," Stanford Windows Infra-
     <msdn.microsoft.com/library/en-us/ipc/base/                             structure, viewed July 10, 2003, < w i n d o w s . s t a n f o r d . e d u / d o c s /
     mailslots.asp>.                                                         glossary.htm>.

335. "About    Pipes," MSDN      Library,  February            2003,    352. " A b o u t Mailslots," MSDN Library,  February                                    2003,
     <msdn.microsoft.com/library/en-us/ipc/base/                             <msdn.microsoft.com/library/en-us/i pc/base/
     about_pipes.asp>.                                                       about_mailslots.asp>.

336. "Pipes," MSDN Library, February 2003, <msdn.microsoft.com/         353. "CIFS/SMB Protocol Overview," MSDN Library, February 2003,
     library/en-us/ipc/base/pipes.asp>.                                      <msdn.microsoft.com/library/en-us/fileio/base/
                                                                             cifs_smb_protocol_overview.asp>.
337. "Named    Pipes,"  MSDN     Library,  February            2003,
     <msdn.microsoft.com/library/en-us/ipc/base/                        354. "Server and Client Functions," MSDN Library, February 2003,
     named_pipes.asp>.                                                       <msdn.microsoft.com/library/en-us/ipc/base/
                                                                             server_and_client_functions.asp>.
338. "Named Pipes Open Modes," MSDN Library, February 2003,
     <msdn.microsoft.com/library/en-us/ipc/base/                        355. "File   Mapping,"    MSDN     Library, February                                    2003,
     named_pipe_open_modes.asp>.                                             <msdn.microsoft.com/library/en-us/fileio/base/
339. "Anonymous Pipes," MSDN Library,       February           2003,         file_mapping.asp?frame=true>.
     <msdn.microsoft.com/library/en-us/ipc/base/                        356. "Sharing Files and Memory," MSDN Library, February 2003,
     anonymous_pipes.asp>.                                                   <msdn.microsoft.com/library/en-us/fileio/base/
340. "Anonymous Pipe Operations," MSDN Library, February 2003,               sharing_files_and_memory.asp?frame=true>.
     <msdn.microsoft.com/library/en-us/ipc/base/                        357. "File   Mapping,"    MSDN     Library, February                                    2003,
     anonymous_pipe_operations.asp>.                                         <msdn.microsoft.com/library/en-us/fileio/base/
341. "Anonymous Pipe Operations," MSDN Library, February 2003,               file_mapping.asp?frame=true>.
     <msdn.microsoft.com/library/en-us/ipc/base/                        358. K a t h , R., "Managing Memory-Mapped Files in Win32," MSDN
     anonymous_pi pe_operations.asp>.                                        Library, February 9, 1993, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n -
342. "Named    Pipes,"  MSDN     Library,  February            2003,         us/dngenlib/html/msdn_manamemo.asp?frame=true>.
     <msdn.microsoft.com/library/en-us/ipc/base/                        359. "Sharing Files and Memory," MSDN Library, February 2003,
     named_pipes.asp>.                                                       <msdn.microsoft.com/library/en-us/fileio/base/
343. "CreateNamedPipe," MSDN     Library,   February   2003,                 sharing_files_and_memory.asp?frame=true>.
     <msdn.microsoft.com/library/en-us/ipc/base/create-
     namedpipe.asp>.

<!-- pág. 1184 -->

1134 Case Study: Windows XP
360. Dabak, P.; M. Borate; and S. Phadke, "Local Procedure Call,"    378. "Types of Binding Handles," MSDN Library, February 2003,
     Windows IT Library, October 1999, <www.windowsitli-                  <msdn.microsoft.com/library/en-us/rpc/rpc/
     brary.com/Content/356/08/1.html>.                                    types_of_binding_handles.asp>.
361. Dabak, P.; M. Borate; and S. Phadke, "Local Procedure Call,"    379. "Explicit Binding Handles," MSDN Library, February 2003,
     Windows IT Library, October 1999, <www.windowsitli-                  <msdn.microsoft.com/library/en-us/rpc/rpc/
     brary.com/Content/356/08/l.htm1>.                                   explicit_binding_handles.asp>.

362. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed,   380. Dabak, P.; M. Borate; and S. Phadke, "Local Procedure Call,"
     Redmond: Microsoft Press, 2000, p. 171.                              Windows IT Library, October 1999, <www.windowsitli-
                                                                          brary.com/Content/356/08/1.html>.
363. Dabak, P.; M. Borate; and S. Phadke, "Local Procedure Call,"
     Windows IT Library, October 1999, <www.windowsitli-             381. Williams, S., and C. Kindel, "The Component Object Model,"
     brary.com/Content/356/08/1.html>.                                    October 1994, <msdn.microsoft.com/library/en-us/dncomg/
                                                                          html/msdn_comppr.asp>.
364. "How RPC Works," MSDN Library, February 2003,
     <msdn.microsoft.com/library/en-us/rpc/rpc/                      382. Williams, S., and C. Kindel, "The Component Object Model,"
     how_rpc_works.asp>.                                                  October 1994, <msdn.microsoft.com/library/en-us/dncomg/
365. "DCE Glossary of Technical Terms," Open Group, 1996,                 html/msdn_comppr.asp>.
     <www.opengroup.org/dce/info/papers/dce-glossary.htm>.           383. "COM Objects and Interfaces," MSDN Library, February 2003,
366. "How RPC Works," MSDN Library, February 2003,                        <msdn.microsoft.com/library/en-us/com/htm/
     <msdn.microsoft.com/library/en-us/rpc/rpc/                           com_Oalv.asp>.
     how_rpc_works.asp>.                                             384. S. Williams and C. Kindel, "The Component Object Model,"
367. "Protocol Sequence Constants," MSDN Library, February 2003,          October 1994, <msdn.microsoft.com/library/en-us/dncomg/
     <msdn.microsoft.com/library/en-us/rpc/rpc/                           html/msdn_comppr.asp>.
     protocol_sequence_constants.asp>.                               385. S. Williams and C. Kindel, "The Component Object Model,"
368. "Asynchronous RPC," MSDN Library, February              2003,        October 1994, <msdn.microsoft.com/library/en-us/dncomg/
     <msdn.microsoft.com/library/en-us/rpc/rpc/                           html/msdn_comppr.asp>.
     asynchronous_rpc.asp>.                                          386. "The COM Library," MSDN Library, February              2003.
369. "The IDL and ACF Files," MSDN Library, February 2003,                <msdn.microsoft.com/library/en-us/com/htm/
     <msdn.microsoft.com/library/en-us/rpc/rpc/                          com_1fuh.asp>.
     the_idl_and_acf_files.asp>.                                     387. "Registering COM Servers," MSDN Library, February 2003.
370. "Microsoft Interface Definition Language SDK Documenta-              <msdn.microsoft.com/library/en-us/com/htm/
     tion," MSDN Library, February 2003, <msdn.microsoft.com/             comext_05pv.asp>.
     library/en-us/midl/midl/midl_start_page.asp>.                   388. "Querylnterface: Navigating an Object," MSDN Library, Febru-
371. "The IDL Interface Header," MSDN Library, February 2003,             ary 2003, <msdn.microsoft.com/library/en-us/com/htm/
     <msdn.microsoft.com/library/en-us/rpc/rpc/                           com_02b8.asp>.
    the_idl_interface_header.asp>.
                                                                     389. Williams, S., and C. Kindel, "The Component Object Model,"
372. "The IDL Interface Body," MSDN Library, February 2003,               October 1994, <msdn.microsoft.com/library/en-us/dncomg/
     <msdn.microsoft.com/library/en-us/rpc/rpc/                           html/msdn_comppr.asp>.
     the_idl_interface_body.asp>.
                                                                     390. "DCOM Technical Overview," Microsoft Corporation, 1996'.
373. "Application Configuration File (ACF)," MSDN Library, Febru-         <msdn.microsoft.com/library/en-us/dndcom/html/
     ary 2003, <msdn.microsoft.com/library/en-us/midl/midl/               msdn_dcomtec.asp>.
     application_configuration_fi1e_acf_.asp>.
                                                                     391. "Processes, Threads and Apartments," MSDN Library, February
374. "Registering Endpoints," MSDN Library, February 2003,                2003,         <msdn.microsoft.com/library/en-us/com/htm/
     <msdn.microsoft.com/library/en-us/rpc/rpc/                           aptnthrd_8po3.asp>.
     registering_endpoints.asp>.
                                                                     392. "Introducing COM+," MSDN Library, February             2003.
375. "Binding Handles,"  MSDN     Library,  February        2003,
                                                                          <msdn.microsoft.com/library/en-us/cossdk/htm/
     <msdn.microsoft.com/library/en-us/rpc/rpc/
                                                                          betaintr_6d5r.asp>.
    binding_handles.asp>.
                                                                     393. "What's New in COM+ 1.5," MSDN Library February 2003.
376. "Client-Side Binding," MSDN Library, February          2003,
                                                                          <msdn.microsoft.com/library/en-us/cossdk/htm/
     <msdn.microsoft.com/library/en-us/rpc/rpc/
                                                                          whatsnewcomplus_350z.asp>.
    client_side_binding.asp>.
                                                                     394. "DCOM Technical Overview," Microsoft Corporation, 1996.
377. "Selecting a Protocol Sequence," MSDN Library, February 2003,
                                                                          <msdn.microsoft.com/library/en-us/dndcom/html/
     <msdn.microsoft.com/library/en-us/rpc/rpc/
                                                                          msdn_dcomtec.asp>.
    selecting_a_protocol_sequence.asp>.

<!-- pág. 1185 -->

                                                                                                                                              Works Cited 1135

395-    "Introduction to A c t i v e X Controls," MSDN Library, July 9,2003,                         410. "Opportunistic Locks," MSDN Library, February          2003,
       <msdn.microsoft.com/workshop/components/activex/                                                   <msdn.microsoft.com/library/en-us/fileio/base/
       intro.asp>.                                                                                        opportunistic_locks.asp>.
396. "Clipboard," MSDN Library, 2003, < m s d n . m i c r o s o f t . c o m /                        411. "Breaking Opportunistic Locks," MSDN Library, February 2003,
     library/en-us/winui/winui/windowsuserinterface/                                                      <msdn.microsoft.com/library/en-us/fileio/base/
     dataexchange/clipboard.asp>.                                                                         breaking_opportunistic_locks.asp>.
397. " A b o u t the  Clipboard,"   MDSN     Library,  2003,                                         412. "NDIS    Drivers," MSDN     Library,  June   6,  2003,
     <msdn.microsoft.com/library/en-us/winui/winui/windows                                                <msdn.microsoft.com/library/en-us/network/hh/network/
     userinterface/dataexchange/clipboard/                                                                102gen_0w2v.asp>.
       abouttheclipboard.asp>.
                                                                                                     413. "Benefits of Remote NDIS," MSDN Library, June 6, 2003,
398. "Clipboard     Formats,"   MSDN       Library,    2003,                                              <msdn.microsoft.com/library/en-us/network/hh/network/
     <msdn.microsoft.com/library/en-us/winui/winui/windows                                                rndisover_44mf.asp>.
     userinterface/dataexchange/clipboard/
                                                                                                     414. "Introduction to Intermediate Drivers," MSDN Library, June 6,
     clipboardformats.asp>.
                                                                                                          2003,      <msdn.microsoft.com/library/en-us/network/hh/
399. " A b o u t the  Clipboard,"   MSDN     Library,  2003,                                              network/301int_78mf.asp>.
     <msdn.microsoft.com/library/en-us/winui/winui/windows                                           415. "NDIS Miniport Drivers," MSDN Library, June 6, 2003,
     userinterface/dataexchange/clipboard/                                                                <msdn.microsoft.com/library/en-us/network/hh/network/
       abouttheclipboard.asp>.                                                                            102gen_lv5d.asp>.
400. Brockschmidt, K., " O L E Integration Technologies: A Technical                                 416. "NDIS Intermediate Drivers," MSDN Library, June 6, 2003,
     Overview,"    Microsoft      Corporation,     October    1994,                                       <msdn.microsoft.com/library/en-us/network/hh/network/
     <msdn.microsoft.com/library/en-us/dnolegen/html/                                                     102gen_4mw7.asp>.
     msdn_ddjole.asp>.                                                                               417. "NDIS Protocol Drivers," MSDN Library, June 6, 2003,
401. " N e t w o r k Redirectors," MSDN Library, February                                 2003,           <msdn.microsoft.com/library/en-us/network/hh/network/
     <msdn.microsoft.com/library/en-us/fileio/base/                                                       102gen_67hj.asp>.
     network_redirectors.asp>.                                                                       418. "TDI    Drivers," MSDN      Library,  June   6,   2003,
402. "Description of a Network I/O Operation," MSDN Library, Feb-                                         <msdn.microsoft.com/library/en-us/network/hh/network/
     ruary 2003, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s / f i l e i o /        102gen_4y93.asp>.
     base/description_of_a_network_i_o_operation.asp>.                                               419. "TCP/IP and Other Network Protocols," Windows XP Profes-
403. " N e t w o r k Redirectors," MSDN Library, February                                 2003,
                                                                                                          sional Resource Kit, viewed July 7, 2003, <www.microsoft.com/
                                                                                                          technetprodtechnol/winxppro/reskit/
     <msdn.microsoft.com/library/en-us/fileio/base/
                                                                                                          prcf_omn_gzcg.asp>.
     network_redirectors.asp>.
                                                                                                     420. "Network Protocols," Windows XP Resource Kit, viewed July 7,
404. "Description of a Network I/O Operation," MSDN Library, Feb-
                                                                                                          2003, <www.microsoft.com/technet/prodtechnol/winxppro/
     ruary 2003,    <msdn.microsoft.com/library/en-us/fileio/
                                                                                                          reskit/prch_cnn_lafg.asp>.
     base/description_of_a_network_i_o_operation.asp>.
                                                                                                     421. "Introduction to Intermediate Drivers," MSDN Library, June 6,
405. Zacker, C, " M u l t i p l e U N C Provider: NT's Traffic Cop," Windows                              2003,      <msdn.microsoft.com/library/en-us/network/hh/
     & .NET Magazine, M a y 1998, < w w w . w i n n e t m a g . c o m / A r t i c l e s /                 network/301int_78mf.asp>.
     Index.cfm?ArticleID=3127>.
                                                                                                     422. "TCP/IP and Other Network Protocols," Windows XP Profes-
406. "CIFS/SMB Protocol Overview," MSDN Library, February 2003,                                           sional Resource Kit, viewed July 7, 2003, <www.microsoft.com/
     <msdn.microsoft.com/library/en-us/fileio/base/                                                       tecr.net/prodtechnol / w i n x p p r o / r e s k i t /
     cifs_smb_protocol_overview.asp>.                                                                     prcc_tcp_tuoz.asp>.
407. Leach, P., and D. Perry, "CIFS: A Common Internet File System,"                                 423. "Defining TCP/IP," Windows XP Professional Resource Kit,
     Microsoft.com, November 1996, <www.microsoft.com/mind/                                               viewed July 7, 2003, <www.microsoft.com/technet/treeview/
     1196/cifs.asp>.                                                                                      default.asp?url=/technet/prodtechnol/winxppro/reski t /
408. Munro, J., "Windows XP Kernel Enhancements," ExtremeTech,                                            prcc_tcp_utip.asp>.
     June   8,    2001,  <www.extremetech.com/print_article/                                         424. "Network Protocols," Windows XP Resource Kit, viewed July 7,
     0,3998,a=2473,00.asp>.                                                                               2003, <www.microsoft.com/technet/prodtechnol/winxppro/
                                                                                                          reskit/prch_cnn_actp.asp>.
409. " C I F Packet Exchange Scenario," MSDN Library, June 6, 2003,
     <msdn.microsoft.com/library/en-us/fileio/base/                                                  425. Hertel, C, "Understanding the Network Neighborhood," Linux
     cif_packet_exchange_scenario.asp>.                                                                   Magazine,     May    2001,    <www.linux-mag.com/2001-05/
                                                                                                          smb_01. html >.

<!-- pág. 1186 -->

1136 Case Study: Windows XP

426. "Network Protocol Support in Windows," MSDN Library, Feb-        443- "DCOM Technical Overview," Microsoft Corporation, 1996,
     ruary 2003, <msdn.microsoft.com/library/en-us/winsock/                <msdn.microsoft.com/library/en-us/dndcom/html/
     winsock/network_protocol_support_in_windows.asp>.                     msdn_dcomtec.asp>.
427. Hertel, C, "Understanding the Network Neighborhood," Linux       444. Kaiser, J., "Windows XP and .NET: An Overview," Microsoft
     Magazine,    May    2001,     <www.linux-mag.com/2001-05/             TechNet, July 2001, <www.microsoft.com/technet/prodtech-
     smb_01.html>.                                                         nol/winxppro/evaluate/xpdotnet.asp>.
428. "About   WinHTTP,"    MSDN      Library,  July           2003,   445. Ricciuti, M., "Strategy: Blueprint Shrouded in Mystery," CNET
     <msdn.microsoft.com/library/en-us/winhttp/http/                       News.com, October 18, 2001, <news.com.com/2009-1001-
     about_winhttp.asp>.                                                   274344.html>.
429. "About   WinlNet,"  MSDN     Library, February    2003,          446. M. Ricciuti, "Strategy: Blueprint Shrouded in Mystery," CNET
     <msdn.microsoft.com/library/en-us/wininet/wininet/                    News.com, October 18, 2001, <news.com.com/2009-1001-
     about_wininet.asp>.                                                   274344.html>.
430. "Porting WinlNET applications to WinHTTP," MSDN Library,         447. Ricciuti, M., "Strategy: Blueprint Shrouded in Mystery," CNET
     February    2003,    <msdn.microsoft.com/library/en-us/               News.com, October 18, 2001, <news.com.com/2009-1001-
     winhttp/http/wininet.asp>.                                            274344.html>.
431. Hertel, C, "Understanding the Network Neighborhood," Linux       448. J. Kaiser, "Windows XP and .NET: An Overview," Microsoft
     Magazine,    May    2001,     <www.linux-mag.com/2001-05/             TechNet, July 2001, <www.microsoft.com/technet/prodtech-
     smb_01.html>.                                                         nol/winxppro/evaluate/xpdotnet.asp>.
432. "Windows Sockets Background," MSDN Library, February 2003,       449. M. Ricciuti, "Strategy: Blueprint Shrouded in Mystery," CNET
     <msdn.microsoft.com/library/en-us/vccore/html/                        News.com, October 18, 2001, <news.com.com/2009-1001-
     _core_Windows_Sockets.3a_.Background.asp>.                            274344.html>.
433- "Windows Sockets 2 API," MSDN Library, February 2003,            450. "Multiple Processors," MSDN Library, February 2003,
     <msdn.microsoft.com/library/en-us/winsock/winsock/                    <msdn.microsoft.com/library/en-us/dllproc/base/
     windows_sockets_2_api_2.asp>.                                         multipie_processors.asp>.
434. Lewandowski, S., "Interprocess Communication in UNIX and         451. "Queued Spin Locks," MSDN Library, June 6, 2003.
     Windows NT," 1997, <www.cs.brown.edu/people/scl/files/                <msdn.microsoft.com/library/en-us/kmarch/hh/kmarch/
     IPCWinNTUNTX.pdf >.                                                   synchro_8ftz.asp>.
435- "Windows Sockets Background," MSDN Library, February 2003,       452. Russinovich, M., and D. Solomon, "Windows XP: Kernel
     <msdn.microsoft.com/library/en-us/vccore/html/                        Improvements Create a More Robust, Powerful, and Scalable
     _core_Windows_Sockets.3a_.Background.asp>.                            OS," MSDN Magazine, December 2001, <msdn.microsoft.com/
436. "Windows Sockets 2 API," MSDN Library February 2003,                  msdnmag/issues/01/12/XPKernel/print.asp>.
     <msdn.microsoft.com/library/en-us/winsock/winsock/               453. "Introduction to Kernel Dispatcher Objects," MSDN Library.
     windows_sockets_2_api_2.asp>.                                         June 6, 2003, <msdn.microsoft.com/library/en-us/kmarch/
437. "Windows Sockets Functions," MSDN Library, February 2003,             hh/kmarch/synchro_7kfb.asp>.
     <msdn.microsoft.com/library/en-us/winsock/winsock/               454. Russinovich, M., and D. Solomon, "Windows XP: Kernel
     windows_sockets_functions_2.asp>.                                     Improvements Create a More Robust, Powerful, and Scalable
438.    "Active   Directory," MSDN    Library,  July         2003,         OS," MSDN Magazine, December 2001, <msdn.microsoft.com/
     <msdn.microsoft.com/library/en-us/netdir/ad/                          msdnmag/issues/01/12/XPKernel/print.asp>.
     active_directory.asp>.                                           455. "Overview of Windows XP 64-Bit Edition," Microsoft TechNet,
439- "About Active Directory," MSDN Library, July            2003,         viewed   July 24, 2003,     <www.microsoft.com/technet/
     <msdn.microsoft.com/library/en-us/netdir/ad/                          prodtechnol/winxppro/reskit/prka_fea_ayuw.asp>.
     about_active_directory.asp>.                                     456. Connolly, C, "First Look: Windows XP 64-Bit Edition for
440. "Lightweight Directory Access Protocol," MSDN Library, July           AMD64," Game PC September 5, 2003 <www.gamepc.com/
     2003,    <msdn.microsoft.com/library/en-us/netdir/ldap/               1abs/view_content.asp?id=amd64xp&page=l>.
     lightweight_directory_access_protocol_ldap_api.asp>.             457. "Overview of Windows XP 64-Bit Edition," Microsoft TechNet.
441. "Active Directory Services Interface (ADSI): Frequently Asked         viewed   July   24, 2003,   <www.microsoft.com/technet/
     Questions,"   MSDN      Library,    viewed   July  7,    2003,        prodtechnol/winxppro/reskit/prka_fea_ayuw.asp>.
     <msdn.microsoft.com/library/en-us/dnactdir/html/                 458. "Job    Objects," MSDN     Library,   February          2003.
     msdn_adsifaq. asp>.                                                   <msdn.microsoft.com/library/en-us/dllproc/base/
442. "Remote Access Service," MSDN Library, February 2003,                 job_objects.asp>.
     <msdn.microsoft.com/library/en-us/rras/rras/                     459. "I/O Completion Ports," MSDN Library, February         2003.
     ras_start_page.asp>.                                                  <msdn.microsoft.com/library/en-us/fileio/base/
                                                                           i_o_completion_ports.asp>.

<!-- pág. 1187 -->

                                                                                                                                                       Works Cited 1137
460. "Thread   Pooling,"  MSDN    Library,  February                                             2003,       473- "Security    Identifiers," Microsoft  TechNet,   2003,
     <msdn.microsoft.com/library/en-us/dllproc/base/                                                              <www.microsoft.com/technet/prodtechnol/winxppro/res-
     thread_pooling.asp>.                                                                                         kit/prdp_log_zhi u.asp>.
461. Fincher, X, "Getting to K n o w Windows NT Embedded and Win-                                            474. "Security             Identifiers," Microsoft TechNet, 2003,
     dows XP Embedded," MSDN Library, November 20, 2001,                                                          <www.microsoft.com/technet/prodtechnol/winxppro/res-
     <msdn.microsoft.com/library/en-us/dnembedded/html/                                                           k i t / p r d p _ l og_zhiu.asp>.
     embeddedll202001.asp>.                                                                                  475. "What's New in Security for Windows XP Professional and Win-
462. " A b o u t Windows XP Embedded," MSDN Library, June 2, 2003,                                                dows XP Home Edition," Microsoft Corporation, July 2001,
     <msdn.microsoft.com/library/en-us/xpehelp/html/xecon-                                                        <www.microsoft.com/windowsxp/pro/techinfo/planning/
     AboutWindowsXPEmbeddedTop.asp>.                                                                              security/whatsnew/WindowsXPSecurity.doo.
463. Fincher, X, "Getting to K n o w Windows NT Embedded and W i n -                                         476. "Important    Terms,"      Microsoft     TechNet,   2003,
     dows XP Embedded," MSDN Library, November 20, 2001,                                                          <www.microsoft.com/technet/prodtechnol/winxppro/res-
     <msdn.microsoft.com/library/en-us/dnembedded/html/                                                           kit/prdd_sec_zrve.asp>.
     embeddedll202001.asp>.                                                                                  477. "User-Based   Authorization,"  Microsoft   TechNet, 2003,
464. Cherepov, M., et al., " H a r d Real-Time with Venturcom R T X on                                            <www.microsoft.com/technet/prodtechnol/winxppro/res-
     Microsoft Windows XP and Windows XP Embedded," MSDN                                                          kit/prdd_sec_qjin.asp>.
     Library, June 2002, < m s d n . m i c r o s o f t . c o m / l i b r a r y / e n - u s /                 478. "New in Windows XP Professional," Microsoft TechNet, 2003,
     dnxpembed/html/hardrealtime.asp>.                                                                            <www.microsoft.com/technet/prodtechnol/winxppro/res-
465. "Components Used in Interactive Logon," Microsoft TechNet,                                                   kit/prdp_log_oeec.asp>.
     2003, < w w w . m i c r o s o f t . c o m / t e c h n e t / p r o d t e c h n o l / w i n x p p r o /   479. "Internet Connection Firewalls," MSDN Library, 2003,
     reskit/prdp_log_axsg.asp>.                                                                                   <www.microsoft.com/technet/prodtechnol/winxppro/res-
466. "Interactive Logons Using Kerberos Authentication," Microsoft                                                kit/prcg_cnd_brph.asp>.
     TechNet, 2003, < w w w . m i c r o s o f t . c o m / t e c h n e t / p r o d t e c h n o l /            480. "What's New in Security for Windows XP Professional and Win-
     winxppro/reskig/prdp_log_brso.asp>.                                                                          dows XP Home Edition," Microsoft Corporation, July 2001,
467. "Components Used in Interactive Logon," Microsoft TechNet,                                                   <www.microsoft.com/windowsxp/pro/techinfo/planning/
     2003, < w w w . m i c r o s o f t . c o m / t e c h n e t / p r o d t e c h n o l / w i n x p p r o /        security/whatsnew/WindowsXPSecurity.doo.
     reskit/prdp_log_axsg.asp>.                                                                              481. Wong, D., "Windows ICF: Can't Live With It, Can't Live Without
                                                                                                                  It," SecurityFocus, August 22, 2002, <www.securityfocus.com/
468. "Protocol     Selection," Microsoft   TechNet,    2003,
                                                                                                                  infocus/1620>.
     <www.microsoft.com/technet/prodtechnol/winxppro/res-
     ki t/prdp_log_axsg.asp>                                                                                 482. Wong, D., "Windows ICF: Can't Live With It, Can't Live Without
                                                                                                                  It," SecurityFocus, August 22, 2002, <www.securityfocus.com/
469. "Components Used in Interactive Logon," Microsoft TechNet,
                                                                                                                  infocus/1620>.
     2003, < w w w . m i c r o s o f t . c o m / t e c h n e t / p r o d t e c h n o l / w i n x p p r o /
     reskit/prdp_log_axsg.asp>.                                                                              483. "What's New in Security for Windows XP Professional and Win-
                                                                                                                  dows XP Home Edition," Microsoft Corporation, July 2001,
470. "What's New in Security for Windows XP Professional and W i n -
                                                                                                                  <www.microsoft.com/windowsxp/pro/techinfo/planning/
     dows XP H o m e Edition," Microsoft Corporation, July 2001,
                                                                                                                  security/whatsnew/WindowsXPSecurity.doo.
     <www.microsoft.com/windowsxp/pro/techinfo/planning/
                                                                                                             484. "What's New in Security for Windows XP Professional and Win-
     security/whatsnew/WindowsXPSecurity.doo.
                                                                                                                  dows XP Home Edition," Microsoft Corporation, July 2001.
471. "Security   Principals," Microsoft    TechNet,    2003,                                                      <www.microsoft.com/windowsxp/pro/techinfo/planning/
     <www.microsoft.com/technet/prodtechnol/winxppro/res-                                                         security/whatsnew/WindowsXPSecurity.doo.
     kit/prdp_log_jrut.asp>.
                                                                                                             485. "Top 10 Reasons to Get Windows XP for Home PC Security,"
472. "Security   Groups,"    Microsoft    TechNet,    2003,                                                       Microsoft Corporation, 2003, <www.microsoft.com/WindowsXP/
     <www.microsoft.com/technet/treeview/default.asp?url=/                                                        security/top10.asp>.
     technet/prodtechnol/winxppro/reskit/
       prdp_log_jrut.asp>.

