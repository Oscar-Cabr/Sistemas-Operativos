# Part 1 - Introduction to Hardware, Software and Operating Systems / Chapter 1 - Introduction to Operating Systems

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 60–111 (numeración del PDF)

<!-- pág. 60 -->

   Introduction to
Hardware, Software and
  Operating Systems
 Intelligence ...is the faculty of making artificial objects, especilly tolls to make tools.
                                    —Henri Bergson—




                Part 1

<!-- pág. 61 -->

The following chapters define the term operating
system, present a history of operating systems and
lay a foundation of hardware and software con-
cepts. As you study the history of operating sys-
tems you       will see a              constant emphasis on
performance improvement and on increasing the
intensity of resource management to achieve that
improvement.         You       will see           hardware power
increasing dramatically as costs decline equally
dramatically. You will see the emergence of two
dominant operating systems, Linux and Windows
XP, built with the open-source approach (Linux)
vs. the proprietary approach (Windows XP). You
will study key operating system architectures. You
will study hardware that operating systems man-
age for users and hardware that supports operat-
ing systems functions. You will study your first
performance enhancement techniques—a process
that you will continue throughout the book.




     Every test carries with it the spirit by which it has been created.
                     —Werner Karl Heisenberg—

<!-- pág. 62 -->

Live in fragments no longer. Only connect...
      — Edward Morgan Forster —


Efficiency is getting the job done right. Effectiveness is getting the right job done.
      - Z i g Ziglar-


Nothing endures but change.
      —Heraclitus —


Open sesame!
      - T h e History of Ali Baba-

<!-- pág. 63 -->

Chapter               1




Introduction to Operating
     Systems
 Objectives
 After reading this chapter, you should understand:
 • what an operating system is.
 • a brief history of operating systems.
 • a brief history of the Internet and the World Wide Web.
 • core operating system components.
 • goals of operating systems.
 • operating system architectures.

<!-- pág. 64 -->

                                  Chapter Outline

                       1.1                                     1.7
                Introduction                     History of the Internet and
                                                         World Wide Web
                1.2                                Biographical Note: Tim Berners-lee
    What Is an Operating System?
                                                                 1.8
                  1.3                                         The 1 9 9 0 s
    Early History: The 1940s and                   Biographical Note: Linus Torvalds
                1950?                             Biographical Note: Richard Stallman
      Operating Systems Thinking:
                   Innovation
                                                               1.9
                                                         2000 and Beyond
                      1.4
                  The 1960s
    Operating Systems Thinking: Relative
                                                               1.10
     Value of H u m a n and Computer Resources           Application Bases
    Biographical Note: Ken Thompson and
                 Dennis Ritchie                              1.11
                                                 Operating System Environments
                     1.5
                  The 1970s                                  1.12
    Anecdote:   Abraham lincoln's Technology      Operating System Components
                     Caution                              and Goals
                                                 1.12.1 Core Operating System Components
                     1.6                             1.12.2 Operating System Goals
                  The 1980s
                                                     Operating Systems Thinking:
     Biographical Note: Doug Engelbart                         Performance




4

<!-- pág. 65 -->

              1.13                                      1.13.1 Monolithic Architecture
Operating     System     Architectures         1.13.2   Layered     Architecture
Operating  Systems Thinking: Keep It             1.13.3 Microkernel Architecture
          Simple       (KIS)       1.13.4         Networked    and        Distributed
Anecdote:    System       Architect      vs.      System    Operating Systems
            Engineer
  Operating Systems Thinking:
           Architecture




   Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited




                                                                                         5

<!-- pág. 66 -->

6 Introduction to Operating Systems

                             1.1 Introduction
                             Welcome to the world of operating systems. During the past several decades, com-
                             puting has evolved at an unprecedented pace. Computer power continues to
                             increase at phenomenal rates as costs decline dramatically. Today, computer users
                             have desktop workstations that execute billions of instructions per second (BIPS).
                             and supercomputers that execute over a trillion instructions per second have been
                             built,1, 2 numbers that just a few years ago were inconceivable.
                                    Processors are becoming so inexpensive and powerful that computers can be
                             employed in almost every aspect of our lives. On personal computers, users can edit
                             documents, play games, listen to music, watch videos and manage their personal
                             finances. Portable devices, including laptop computers, personal digital assistants
                             (PDAs), cell phones, and MP3 players all have computers as key components. Wired
                             and wireless network architectures are increasing our interconnectivity—allowing
                             users to communicate instantly over vast distances. The Internet and World Wide Web
                             have revolutionized business, creating demand for networks of large, powerful com-
                             puters that service vast numbers of transactions per second. Networks of computers
                             have become so powerful that they are used to conduct complex research and simula-
                             tion projects, such as modeling the Earth's climate, emulating human intelligence and
                             constructing lifelike 3D animations. Such pervasive and powerful computing is
                             reshaping the roles and responsibilities of operating systems.
                                    In this book, we review operating system principles and discuss cutting-edge
                             advances in computing that are redefining operating systems. We investigate the
                             structure and responsibilities of operating systems. Design considerations, such as
                             performance, fault tolerance, security, modularity and cost, are explored in detail. We
                             also address more recent operating system design issues arising from the rapid growth
                             in distributed computing, made possible by the Internet and the World Wide Web.
                                    We have worked hard to create what we hope will be an informative, enter-
                             taining and challenging experience for you. As you read this book, you may want to
                             refer to our Web site at www.deitel.com for updates and additional information on
                             each topic. You can reach us at deitel@deitel.com.



                             1.2 What Is an Operating System?
                             In the 1960s, the definition of an operating system might have been the software that
                             controls the hardware. But the landscape of computer systems has evolved signifi-
                             cantly since then, requiring a richer definition.
                                   Today's hardware executes a great variety of software applications. To
                             increase hardware utilization, applications are designed to execute concurrently. If
                             these applications are not carefully programmed, they might interfere with one
                             another. As a result, a layer of software called an operating system separates appli-
                             cations from the hardware they access and provides services that allow each appli-
                             cation to execute safely and effectively.

<!-- pág. 67 -->

                                                                           1.3 Early History: The 1940s and 1950s 7
      An operating system is software that enables applications to interact with a
computer's hardware. The software that contains the core components of the oper-
ating system is called the kernel. Operating systems can be found in devices ranging
from cell phones and automobiles to personal and mainframe computers. In most
computer systems, a user requests that the computer perform an action (e.g., exe-
cute an application or print a document) and the operating system manages the
software and hardware to produce the desired result.
      To most users, the operating system is a "black box" between the applications
and the hardware they run on that ensures the proper result, given appropriate
inputs. Operating systems are primarily resource managers —they manage hard-
ware, including processors, memory, input/output devices and communication
devices. They must also manage applications and other software abstractions that,
unlike hardware, are not physical objects.
      In the next several sections we present a brief history of operating systems
from the simple, single-user batch systems of the 1950s to the complex, multiproces-
sor, distributed, multiuser platforms of today.

Self Review
1. (T/F) Operating systems manage only hardware.
2. What are the primary purposes of an operating system?
Ans: 1) False. Operating systems manage applications and other software abstractions, such
as virtual machines. 2) The primary purposes of an operating system are to enable applica-
tions to interact with a computer's hardware and to manage a system's hardware and soft-
ware resources.


1.3 Early History: The 1940s and 1950s
Operating systems have evolved over the last 60 years through several distinct
phases or generations that correspond roughly to the decades (see the Operating
Systems Thinking feature, Innovation). 3 In the 1940s, the earliest electronic digital
computers did not include operating systems.4, 5, 6 Machines of the time were so
primitive that programmers often entered their machine-language programs one bit
at a time on rows of mechanical switches. Eventually, programmers entered their
machine-language programs on punched cards. Then, assembly languages—which
used English-like abbreviations to represent the basic operations of the computer—
were developed to speed the programming process.
      General Motors Research Laboratories implemented the first operating sys-
tem in the early 1950s for its IBM 701 computer. 7 The systems of the 1950s gener-
ally executed only one job at a time, using techniques that smoothed the transition
between jobs to obtain maximum utilization of the computer system.8 A job consti-
tuted the set of program instructions corresponding to a particular computational
task, such as payroll or inventory. Jobs typically executed without user input for
minutes, hours or days. These early computers were called single-stream batch-pro-

<!-- pág. 68 -->

8 Introduction to Operating Systems

                              cessing systems, because programs and data were submitted in groups or batches by
                              loading them consecutively onto tape or disk. A job stream processor read the job
                              control language statements (that defined each job) and facilitated the setup of the
                              next job. When the current job terminated, the job stream reader read in the con-
                              trol-language statements for the next job and performed appropriate housekeeping
                              chores to ease the transition to the next job. Although operating systems of the
                              1950s reduced interjob transition times, programmers often were required to
                              directly control system resources such as memory and input/output devices. This
                              was slow, difficult and tedious work. Further, these early systems required that an
                              entire program be loaded into memory for the program to run. This limited pro-
                              grammers to creating small programs with limited capabilities.9



                              Self Review
                              1. Why were assembly languages developed?
                              2. What limited the size and capabilities of programs in the 1950s?
                              Ans: 1) Assembly languages were developed to speed the programming process. They
                              enabled programmers to specify instructions as English-like abbreviations that were easier
                              for humans to work with than machine-language instructions. 2) The entire program had to
                              be loaded into memory to execute. Because memory was relatively expensive, the amount of
                              memory available to those computers was small.




                  Operating Systems Thinking
     Innovation
     Innovation is a fundamental chal-    how systems should be built. We           journals on the latest research
     lenge for operating systems          have provided thousands of cita-          and development efforts in the
     designers. If we are going to        tions and hundreds of Web                 computer field. You should access
     make the massive investment          resources for you to do additional        the Web frequently to follow
     required to produce new operat-      readings on topics that are of            important developments in the
     ing systems or new versions of       interest to you. You should con-          field. There is always a high
     existing operating systems, we       sider belonging to professional           degree of risk when innovating,
     must constantly be evaluating        organizations like the ACM                but the rewards can be substan-
     new technologies, new applica-       (www.acm.org), the IEEE                   tial.
     tions of computing and communi-      (www.ieee.org) and USENIX
     cations and new thinking about       (www.usenix.org) that publish

<!-- pág. 69 -->

                                                                                            1.4 The 1960s 9

1.4 The 1960s
The systems of the 1960s were also batch-processing systems, but they used the
computer's resources more efficiently by running several jobs at once. Systems
included many peripheral devices such as card readers, card punches, printers, tape
drives and disk drives. Any one job rarely used all the system's resources efficiently.
A typical job would use the processor for a certain period of time before perform-
ing an input/output (I/O) operation on one of the system's peripheral devices. At
this point, the processor would remain idle while the job waited for the I/O opera-
tion to complete.
      The systems of the 1960s improved resource utilization by allowing one job to
use the processor while other jobs used peripheral devices. In fact, running a mix-
ture of diverse jobs—some jobs that mainly used the processor (called processor-
bound jobs or compute-bound jobs) and some jobs that mainly used peripheral
devices (called I/O-bound jobs)—appeared to be the best way to optimize resource
utilization. With these observations in mind, operating systems designers developed
multiprogramming systems that managed several jobs at once.10, 11, 12 In a multipro-
gramming environment, the operating system rapidly switches the processor from
job to job, keeping several jobs advancing while also keeping peripheral devices in
use. A system's degree of multiprogramming (also called its level of multiprogram-
ming) indicates how many jobs can be managed at once. Thus, operating systems
evolved from managing one job to managing several jobs at a time.
      In multiprogrammed computing systems, resource sharing is one of the pri-
mary goals. When resources are shared among a set of processes, each process
maintaining exclusive control over particular resources allocated to it, a process
may be made to wait for a resource that never becomes available. If this occurs, that
process will be unable to complete its task, perhaps requiring the user to restart it,
losing all work that the process had accomplished to that point. In Chapter 7, Dead-
lock and Indefinite Postponement, we discuss how operating systems can deal with
such problems.
      Normally, users of the 1960s were not present at the computing facility when
their jobs were run. Jobs were submitted on punched cards or computer tapes and
remained on input tables until the system's human operator could load them into the
computer for execution. Often, a user's job would sit for hours or even days before it
could be processed. The slightest error in a program, even a missing period or comma,
would "bomb" the job, at which point the (often frustrated) user would correct the
error, resubmit the job and once again wait hours or days for the next attempt at exe-
cution. Software development in that environment was painstakingly slow.
      In 1964, IBM announced its System/360 family of computers ("360" refers to
all points on a compass to denote universal applicability).13, 14, 15, 16 The various 360
computer models were designed to be hardware compatible, to use the OS/360
operating system and to offer greater computer power as the user moved upward in
the series.17 Over the years, IBM evolved its 360 architecture to the 370 series18, 19
and, more recently, the 390 series20 and the zSeries.21

<!-- pág. 70 -->

10 Introduction to Operating Systems

                                       More advanced operating systems were developed to service multiple interac-
                                 tive users at once. Interactive users communicate with their jobs during execution. In
                                 the 1960s, users interacted with the computer via "dumb terminals" (i.e., devices that
                                 supplied a user interface but no processor power) which were online (i.e., directly
                                 attached to the computer via an active connection). Because the user was present and
                                 interacting with it, the computer system needed to respond quickly to user requests;
                                 otherwise, user productivity could suffer. As we discuss in the Operating Systems
                                 Thinking feature, Relative Value of Human and Computer Resources, increased pro-
                                 ductivity has become an important goal for computers because human resources are
                                 extremely expensive compared to computer resources. Timesharing systems were
                                 developed to support simultaneous interactive users.22
                                       Many of the timesharing systems of the 1960s were multimode systems that
                                 supported batch-processing as well as real-time applications (such as industrial pro-
                                 cess control systems).23 Real-time systems attempt to supply a response within a
                                 certain bounded time period. For example, a measurement from a petroleum refin-
                                 ery indicating that temperatures are too high might demand immediate attention to



              Operating Systems Thinking

    Relative Value of Human and Computer Resources
     In 1965, reasonably experienced       computing has plummeted, the           the batch-processing systems
     programmers were earning about        cost of man-hours has risen to the     response times of hours or even
     $4 per hour. Computer time on         point that today human resources       days. Another classic example was
     mainframe computers (which            are far more expensive than com-       the advent of the graphical user
     were far less powerful than           puting resources.                      interface (GUI) originally devel-
     today's desktop machines) was                Computer hardware, operat-      oped at the Xerox Palo Alto
     commonly rented for $500 or           ing systems and software applica-      Research Center (PARC) in the
     more per hour—and that was in         tions are all designed to leverage     1970s. With cheaper and more
     1965 dollars which, because of        people's time, to help improve         powerful computing, and with the
     inflation, would be comparable to     efficiency and productivity. A clas-   relative cost of people-time rising
     thousands of dollars in today's       sic example of this was the advent     rapidly compared to that of corn-
     currency! Today, you can buy a        of timesharing systems in the          puting, operating systems design-
     top-of-the-line, enormously pow-      1960s in which these interactive       ers must provide capabilities that
     erful desktop computer for what       systems (with almost immediate         favor the human over the
     it cost to rent a far less powerful   response times) often enabled pro-     machine, exactly the opposite of
     mainframe computer for one            grammers to become far more            what early operating systems did.
     hour 40 years ago! As the cost of     productive than was possible w i t h

<!-- pág. 71 -->

                                                                                         1.4   The   1960s 11

avert an explosion. The resources of a real-time system are often heavily underuti-
lized—it is more important for such systems to respond quickly than it is for them
to use their resources efficiently. Servicing both batch and real-time jobs meant that
operating systems had to distinguish between types of users and provide each with
an appropriate level of service. Batch-processing jobs could suffer reasonable
delays, whereas interactive applications demanded a higher level of service and
real-time systems demanded extremely high levels of service.
      The key timesharing systems development efforts of this period included the
CTSS (Compatible Time-Sharing System)24, 25 developed by MIT, the TSS (Time
Sharing System) 26 developed by IBM, the Multics system27 developed at MIT, GE
and Bell Laboratories as the successor to CTSS and the CP/CMS (Control Pro-
gram/Conversational Monitor System)—which eventually evolved into IBM's VM
(Virtual Machine) operating system—developed by IBM's Cambridge Scientific
Center.28, 29 These systems were designed to perform basic interactive computing
tasks for individuals, but their real value proved to be the manner in which they
shared programs and data and demonstrated the value of interactive computing in
program development environments.
      The designers of the Multics system were the first to use the term process to
describe a program in execution in the context of operating systems. In many cases,
users submitted jobs containing multiple processes that could execute concurrently.
In Chapter 3, Process Concepts, we discuss how multiprogrammed operating sys-
tems manage multiple processes at once.
      In general, concurrent processes execute independently, but multipro-
grammed systems enable multiple processes to cooperate to perform a common
task. In Chapter 5, Asynchronous Concurrent Execution, and Chapter 6, Concur-
rent Programming, we discuss how processes coordinate and synchronize activities
and how operating systems support this capability. We show many examples of con-
current programs, some expressed generally in pseudocode and some in the popu-
lar Java™ programming language.
      Turnaround time —the time between submission of a job and the return of its
results —was reduced to minutes or even seconds. The programmer no longer
needed to wait hours or days to correct even the simplest errors. The programmer
could enter a program, compile it, receive a list of syntax errors, correct them
immediately, recompile and continue this cycle until the program was free of syntax
errors. Then the program could be executed, debugged, corrected and completed
with similar time savings.
      The value of timesharing systems in support of program development was
demonstrated when MIT, GE and Bell Laboratories used the CTSS system to
develop its own successor, Multics. Multics was notable for being the first major
operating system written primarily in a high-level language (EPL—modeled after
IBM's PL/1) instead of an assembly language. The designers of UNIX learned from
this experience; they created the high-level language C specifically to implement
UNIX. A family of UNIX-based operating systems, including Linux and Berkeley

<!-- pág. 72 -->

12 Introduction to Operating Systems

                               Software Distribution (BSD) UNIX, have evolved from the original system created
                               by Dennis Ritchie and Ken Thompson at Bell Laboratories in the late 1960s (see
                               the Biographical Note, Ken Thompson and Dennis Ritchie).
                                     TSS, Multics and CP/CMS all incorporated virtual memory, which we discuss
                               in detail in Chapter 10, Virtual Memory Organization, and Chapter 11, Virtual
                               Memory Management. In systems with virtual memory, programs are able to
                               address more memory locations than are actually provided in main memory, also
                               called real memory or physical memory.30-31 (Real memory is discussed in
                               Chapter 9, Real Memory Organization and Management.) Virtual memory systems
                               help remove much of the burden of memory management from programmers, free-
                               ing them to concentrate on application development.




                Biographical Note
    Ken Thompson and Dennis Ritchie
    Ken Thompson and Dennis Ritchie      nis Ritchie on the Multics                       Dennis Ritchie attended Har-
    are well known in the field of       project. 34 While working on that      vard University, earning a Bache-
    operating systems for their devel-   project, Thompson created the B        lor's degree in Physics and a Ph.D.
    opment of the UNIX operating         language that led to Ritchie's C       in Mathematics. Ritchie went on
    system and the C programming         language. 35 The Multics project       to work at Bell Labs, where he
    language. They have received sev-    eventually led to the creation of      joined Thompson on the Multics
    eral awards and recognition for      the UNIX operating system in           project in 1968. Ritchie is most
    their accomplishments, including     1969. Thompson continued to            recognized for his C language,
    the ACM Turing Award, the            develop UNIX through the early         which he completed in 1972.38
    National Medal of Technology,        1970s, rewriting it in Ritchie's C     Ritchie added some extra capabili-
    the NEC C&C Prize, the IEEE          programming language. 36 After         ties to Thompson's B language
    Emmanuel Piore Award, the IEEE       Thompson completed UNIX, he            and changed the syntax to make
    Hamming Medal, induction into        made news again in 1980 with           it easier to use. Ritchie still works
    the United States National Acad-     Belle. Belle was a chess-playing       for Bell Labs and continues to
    emy of Engineering and the Bell      computer designed by Thompson          work with operating systems.39
    Labs National Fellowship. 32         and Joe Condon that won the            Within the past 10 years he has
          Ken Thompson attended the      World Computing Chess Champi-          created t w o new operating sys-
    University of California at Berke-   onship. Thompson worked as a           terns. Plan 9 and Inferno. 40 The
    ley, where he earned a B.S. and      professor at the University of Cali-   Plan 9 system is designed for com-
    M.S. in Computer Science, gradu-     fornia at Berkeley and at the Uni-     munication and production qual-
    ating in 1966.33 After college       versity of Sydney, Australia. He       ity. 4 1 lnferno is a system intended
    Thompson worked at Bell Labs,        continued to work at Bell Labs         for advanced networking. 4 2
    where he eventually joined Den-      until he retired in 2000. 37

<!-- pág. 73 -->

                                                                                                   1.5 The 1970s 13

       Once loaded into main memory, programs could execute quickly; however,
main memory was far too expensive to contain large numbers of programs at once.
Before the 1960s, jobs were largely loaded into memory using punched cards or
tape, a tedious and time-consuming task, during which the system could not be used
to execute jobs. The systems of the 1960s incorporated devices that reduced system
idle time by storing large amounts of rewritable data on relatively inexpensive mag-
netic storage media such as tapes, disks and drums. Although hard disks enabled
relatively fast access to programs and data compared to tape, they were significantly
slower than main memory. In Chapter 12, Disk Performance Optimization, we dis-
cuss how operating systems can manage disk input/output requests to improve per-
formance. In Chapter 13, File and Database Systems, we discuss how operating
systems organize data into named collections called files and manage space on stor-
age devices such as disks. We also discuss how operating systems protect data from
access by unauthorized users and prevent data from being lost when system failures
or other catastrophic events occur.


Self Review
1. How did interactive computing and its improvement in turnaround time increase pro-
   grammer productivity?
2. What new concept did TSS, Multics and CP/CMS all incorporate? Why was it so helpful
   for programmers?
Ans: 1) The time between submission of a job and the return of its results was reduced from
hours or days to minutes or even seconds. This enabled programmers to interactively enter,
compile and edit programs until their syntax errors were eliminated, then use a similar cycle to
test and debug their programs. 2) TSS, Multics, and CP/CMS all incorporated virtual memory.
Virtual memory allows applications access to more memory than is physically available on the
system. This allows programmers to develop larger, more powerful applications. Also, virtual
memory systems remove much of the memory management burden from the programmer.



1.5 The 1970s
The systems of the 1970s were primarily multimode multiprogramming systems that
supported batch processing, timesharing and real-time applications. Personal com-
puting was in its incipient stages, fostered by early and continuing developments in
microprocessor technology.43 The experimental timesharing systems of the 1960s
evolved into solid commercial products in the 1970s. Communications between
computer systems throughout the United States increased as the Department of
Defense's TCP/IP communications standards became widely used—especially in
military and university computing environments. 44 ' 4546 Communication in local
area networks (LANs) was made practical and economical by the Ethernet stan-
dard developed at Xerox's Palo Alto Research Center (PARC). 4 7 4 8 In Chapter 16,
Introduction to Networking, we discuss TCP/IP, Ethernet and fundamental net-
working concepts.

<!-- pág. 74 -->

14 Introduction to Operating Systems

                                         Security problems increased with the growing volumes of information passing
                                   over vulnerable communications lines (see the Anecdote, Abraham Lincoln's Tech-
                                   nology Caution). Encryption received much attention—it became necessary to
                                   encode proprietary or private data so that, even if the data was compromised, it was
                                   of no value to anyone other than the intended receivers. In Chapter 19, Security, we
                                   discuss how operating systems secure sensitive information from unauthorized access.
                                   During the 1970s, operating systems grew to encompass networking and security
                                   capabilities and continued to improve in performance to meet commercial demands.
                                         The personal computing revolution began in the late 1970s with such systems
                                   as the Apple II, and exploded in the 1980s.


                                   Self Review
                                   1. What developments in the 1970s improved communication between computer systems?
                                   2. What new problem was introduced by the increased communication between computers?
                                      How was this problem addressed?
                                   Ans: 1) The DoD's TCP/IP standards became widely used in network communications—
                                   primarily in university and military computing environments. Also, Xerox's PARC developed
                                   the Ethernet standard, which made relatively high-speed local area networks (LANs) practi-
                                   cal and economical. 2) Communication between computers introduced security problems
                                   because data was sent over vulnerable communication lines. Encryption was employed to
                                   make data unreadable to anyone other than the intended recipient.




                   Anecdote

    Abraham Lincoln's Technology Caution
     The story goes that during the           tlefields for this wonderful new         light!" The older and wiser Presi-
     Civil War one of President Lin-          technology called the telegraph.         dent Lincoln looked d o w n at the
     coin's young lieutenants came            Do you know what that means,             lieutenant and said calmly, "Yes,
     running up to him eager to speak         Mr. President?" "No lieutenant,          lieutenant, but we'll also be able
     w i t h the President. "What is it,      what does it mean?" "Mr. Presi-         to make wrong decisions at the
     lieutenant?" "Mr. President, Mr.         dent, it means we'll be able to          speed of light!"
     President, we are wiring the bat-        make decisions at the speed of

     Lessons to operating systems             cons. You will inevitably spend a        making things happen faster may
     designers: Every new technology          great deal of your time concerned        have unpleasant consequences,
     you will evaluate has its pros and       with performance issues. But,

<!-- pág. 75 -->

                                                                                                 16 The 1980s 15

1.6 The 1980s
The 1980s was the decade of the personal computer and the workstation. 49 Micro-
processor technology evolved to the point where high-end desktop computers
called workstations could be built that were as powerful as the mainframes of a
decade earlier. The IBM Personal Computer released in 1981 and the Apple Macin-
tosh personal computer released in 1984 made it possible for individuals and small
businesses to have their own dedicated computers. Communication facilities could
be used to transmit data quickly and economically between systems. Rather than
bringing data to a central, large-scale computer installation for processing, comput-
ing was distributed to the sites at which it was needed. Software such as spreadsheet
programs, word processors, database packages and graphics packages helped drive
the personal computing revolution by creating demand from businesses that could
use these products to increase their productivity.
      Personal computers proved to be relatively easy to learn and use, partially
because of graphical user interfaces (GUI) that used graphical symbols such as win-
dows, icons and menus to facilitate user interaction with programs. Xerox's Palo
Alto Research Center (PARC) developed the mouse and GUI (for more on the ori-
gins of the mouse, see the Biographical Note, Doug Engelbart); Apple's release of
the Macintosh personal computer in 1984 popularized their use. In Macintosh com-
puters, the GUI was embedded in the operating system so that all applications
would have a similar look and feel.50 Once familiar with the Macintosh GUI, the
user could learn to use new applications faster.
      As technology costs declined, transferring information between computers in
computer networks became more economical and practical. Electronic mail, file
transfer and remote database access applications proliferated. Distributed comput-
ing (i.e., using multiple independent computers to perform a common task) became
widespread under the client/server model. Clients are user computers that request
various services; servers are computers that perform the requested services. Servers
often are dedicated to one type of task, such as rendering graphics, managing data-
bases or serving Web pages.
      The software engineering field continued to evolve, a major thrust coming
from the United States government aimed at providing tighter control of Depart-
ment of Defense software projects.51 Some goals of the initiative included realized
code reusability and the early construction of prototypes so developers and users
could suggest modifications early in the software design process.52

Self review
1. What aspect of personal computers, popularized by the Apple Macintosh, made them
   especially easy to learn and use?
2. (T/F) A server cannot be a client.
Ans: 1) Graphical User Interfaces (GUIs) facilitated personal computer use by providing
an easy-to-use, uniform interface to every application. This enabled users to learn new appli-
cations faster. 2) False. A computer can be a client and server. For example, a Web server can

<!-- pág. 76 -->

16   Introduction to Operating Systems

                                    be both a client and server. When users request a Web page, it is a server; if the server then
                                    requests information from a database system, it becomes a client of the database system.


                                    1.7 History of the Internet and World Wide Web
                                    In the late 1960s ARPA —the Advanced Research Projects Agency of the Depart-
                                    ment of Defense rolled out the blueprints for networking the main computer sys-
                                    tems of about a dozen ARPA-funded universities and research institutions. They
                                    were to be connected with communications lines operating at a then-stunning 56
                                    kilobits per second (Kbps) —1 Kbps is equal to 1,000 bits per second —at a time
                                    when most people (of the few who could be) were connecting over telephone lines
                                    to computers at a rate of 110 bits per second. HMD vividly recalls the excitement at




                           Biographical Note
     Doug Engelbart
     Doug Engelbart invented the               San Francisco, Engelbart and his           NLS system was to create a system
     computer mouse and was one of             coworkers displayed their com-            that could help people solve prob-
     the primary designers of the origi-       puter system, NLS (oNLine System)          lems faster and enhance i n t e r -
     nal graphical displays and w i n -        which featured Engelbart's com-           gence. Engelbart founded the
     dows.                                     puter mouse and a graphical                Bootstrap Institute to foster
           Engelbart's background was          interface w i t h windows. 5 6 This       worldwide awareness of his mis-
     in electronics. During World War II       original mouse, called an X-Y Posi-       sion. Bootstrapping, according to
     he worked as an electronics tech-         tion Indicator for a Display Sys-          Engelbart, is the idea of improv-
     nician on a variety of systems            tern, had only one button. 5 7 The         ing one's methods of improve-
     including RADAR and SONAR.53              mouse had t w o wheels on the              ment. He believes this is the best
     After leaving the military, he            bottom, one horizontal and one             way to improve human intelli-
     went back to Oregon State to              vertical, to detect movement. 58           gence. 59
     complete a degree in Electrical           The mouse and the graphical w i n -              Today, Engelbart is still
     Engineering in 1948.54 He went            dows were interdependent. The              working w i t h the Bootstrap Insti-
     on to receive his Ph.D. from the          mouse made it significantly easier         tute. He has received recognition
     University of California at Berke-        to switch between windows, and             for his work including the Lemel-
     ley, then took a job at the Stan-         w i t h o u t windows the mouse was        son-MIT Prize, the National Medal
     f o r d Research Institute (SRI),         not as useful.                             of Technology and induction into
     where he gained his first experi-                Engelbart has dedicated his         the National Inventors Hall of
     ence w i t h computers. 55 In 1968, at     life to augmenting human intel-           Fame. 60
     the Joint Computer Conference in           lect. His original idea behind the

<!-- pág. 77 -->

                                                                1.7 History of the Internet and World Wide Web 17

that conference. Researchers at Harvard talked about communicating with the
Univac 1108 "supercomputer" across the country at the University of Utah to han-
dle the massive computations related to their computer graphics research. Aca-
demic research was about to take a giant leap forward. Shortly after this
conference, ARPA proceeded to implement what quickly became called the
ARPAnet—the grandparent of today's Internet.
       Although the ARPAnet did enable researchers to network their computers,
its chief benefit proved to be its capability for quick and easy communication via
what came to be known as electronic mail (e-mail). This is true even on the Internet
today, with e-mail, instant messaging and file transfer facilitating communications
among hundreds of millions of people worldwide and growing rapidly.
       The ARPAnet was designed to operate without centralized control. This meant
that if a portion of the network should fail, the remaining working portions would
still be able to route data packets from senders to receivers over alternative paths.
       The protocols (i.e., sets of rules) for communicating over the ARPAnet
became known as the Transmission Control Protocol/Internet Protocol (TCP/IP).
TCP/IP was used to manage communication between applications. The protocols
ensured that messages were routed properly from sender to receiver and that those
messages arrived intact. The advent of TCP/IP promoted worldwide computing
growth. Initially, Internet use was limited to universities and research institutions;
later, the military adopted the technology.
       Eventually, the government decided to allow access to the Internet for com-
mercial purposes. This decision led to some concern among the research and mili-
tary communities—it was felt that response times would suffer as "the Net" became
saturated with users. In fact, the opposite occurred. Businesses rapidly realized that
they could use the Internet to tune their operations and to offer new and better ser-
vices to their clients. Companies spent vast amounts of money to develop and
enhance their Internet presence. This generated intense competition among com-
munications carriers, hardware suppliers and software suppliers to meet the
increased infrastructure demand. The result is that bandwidth (i.e., the information-
carrying capacity of communications lines) on the Internet has increased tremen-
dously, and hardware and communications costs have plummeted.
       The World Wide Web (WWW) allows computer users to locate and view mul-
timedia-based documents (i.e., documents with text, graphics, animation, audio or
video) on almost any subject. Although the Internet was developed more than
three decades ago, the introduction of the World Wide Web (WWW) was a rela-
tively recent event. In 1989, Tim Berners-Lee of CERN (the European Center for
Nuclear Research) began to develop a technology for sharing information via
hyperlinked text documents (see the Biographical Note, Tim Berners-Lee). To
implement this new technology, Berners-Lee created the HyperText Markup Lan-
guage (HTML). Berners-Lee also implemented the Hypertext Transfer Protocol
(HTTP) to form the communications backbone of his new hypertext information
system, which he called the World Wide Web.

<!-- pág. 78 -->

18 Introduction to Operating Systems

                                      Surely, historians will list the Internet and the World Wide Web among the
                                most important and profound creations of humankind. In the past, most computer
                                applications ran on "stand-alone" computers (computers that were not connected
                                to one another). Today's applications can be written to communicate among the
                                world's hundreds of millions of computers. The Internet and World Wide Web
                                merge computing and communications technologies, expediting and simplifying our
                                work. They make information instantly and conveniently accessible to large num-
                                bers of people. They enable individuals and small businesses to achieve worldwide
                                exposure. They are changing the way we do business and conduct our personal lives.
                                And they are changing the way we think of building operating systems. Today's
                                operating systems provide GUIs that enable users to "access the world" over the
                                Internet and the Web as seamlessly as accessing the local system. The operating sys-
                                tems of the 1980s were concerned primarily with managing resources on the local
                                computer. Today's distributed operating systems may utilize resources on comput-
                                ers worldwide. This creates many interesting challenges that we discuss throughout
                                the book, especially in Chapters 16-19, which examine networking, distributed
                                computing and security.




                Biographical Note

     Tim Berners-Lee
    The World Wide Web was               fellowship at the European Cen-              Until 1993, Berners-Lee indi-
    invented by Tim Berners-Lee in       ter for Nuclear Research (CERN) in     vidually managed changes and
    1990. The Web allows computer        1984, where he gained experience       suggestions for HTTP and HTML,
    users to locate and view multime-    in communication software for          sent from the early Web users. By
    dia-based documents (i.e., docu-     real-time networked                    1994 the Web community had
    ments w i t h text, graphics, systems.61,    62,  63
                                                                                grown large enough that he
    animation, audio or video) on              Berners-Lee invented HTTP        started the World Wide Web Con-
    almost any subject.                  (the HyperText Transfer Protocol),     sortium (W3C; www.w3.org) to
           Berners-Lee graduated from      HTML (Hypertext Markup Lan-          monitor and establish Web tech-
    Queen's College at Oxford Univer-      guage) and the first World Wide      nology standards. 67 As director of
    sity with a degree in Physics in       Web server and browser in 1989,      the organization, he actively pro-
    1976. In 1980 he wrote a program       while working at CERN.64, 65 He      motes the principle of freely avail-
    called Enquire, which used hyper-      intended the Web to be a mecha-      able information accessed by
    text links to help him quickly navi-   nism for open, available access to   open technologies. 68
    gate the numerous documents in         all shared knowledge and experi-
    a large project. He entered into a     ence. 66

<!-- pág. 79 -->

                                                                                            1.8 The 1990s 19

Self Review
1. How did the ARPAnet differ from traditional computer networks? What was its primary
   benefit?
2. What creations did Berners-Lee develop to facilitate data sharing over the Internet?
Ans: 1) The ARPAnet was decentralized, so the network continued to be able to pass infor-
mation even if portions of the network failed. The primary benefit of the ARPAnet was its
capability for quick and easy communication via e-mail. 2) Berners-Lee developed the
HyperText Markup Language (HTML) and the Hypertext Transfer Protocol (HTTP), mak-
ing possible the World Wide Web.




1.8 The1990s
Hardware performance continued to improve exponentially in the 1990s.69 By the
end of the decade, a typical personal computer could execute several hundred mil-
lion instructions per second (MIPS) and store over a gigabyte of information on a
hard disk; some supercomputers could execute over a trillion operations per sec-
ond.70 Inexpensive processing power and storage enabled users to execute large,
complex programs on personal computers and enabled small- to mid-size compa-
nies to use these economical machines for the extensive database and processing
jobs that were once delegated to mainframe systems. Falling technology costs also
led to an increase in the number of home computers, which were used both for
work and for entertainment.
      In the 1990s, the creation of the World Wide Web led to an explosion in the
popularity of distributed computing. Originally, operating systems performed iso-
lated resource management inside a single computer. With the creation of the
World Wide Web and increasingly fast Internet connections, distributed computing
became commonplace among personal computers. Users could request data stored
at remote locations or request that programs run on distant processors. Large orga-
nizations could use distributed multiprocessors (i.e., networks of computers con-
taining more than one processor) to scale resources and increase efficiency.71
Distributed applications, however, were still limited by the fact that communication
over a network occurred at relatively slow speeds compared to the internal process-
ing speeds of individual computers. Distributed computing is discussed in detail in
Chapter 17, Introduction to Distributed Systems, and Chapter 18, Distributed Sys-
tems and Web Services.
      As demand for Internet connections grew, operating system support for net-
working tasks became standard. Users at home and in organizations increased pro-
ductivity by accessing the resources on networks of computers. However, increased
connectivity led to a proliferation of computer security threats. Operating system
designers developed techniques to protect computers from these malicious attacks.
Ever more sophisticated security threats continued to challenge the computer
industry's ability to counter such attacks.

<!-- pág. 80 -->

20   Introduction   to Operating Systems

                                       Microsoft Corporation became dominant in the 1990s. In 1981, Microsoft
                                released the first version of its DOS operating system for the IBM personal com-
                                puter. In the mid-1980s, Microsoft developed the Windows operating system, a
                                graphical user interface built on top of the DOS operating system. Microsoft
                                released Windows 3.0 in 1990; this new version featured a user-friendly interface
                                and rich functionality. The Windows operating system became incredibly popular
                                after the 1993 release of Windows 3.1, whose successors, Windows 95 and Windows
                                98, virtually cornered the desktop operating system market by the late 90s. These
                                operating systems, which borrowed from many concepts (such as icons, menus and
                                windows) popularized by early Macintosh operating systems, enabled users to navi-
                                gate multiple concurrent applications with ease. Microsoft also entered the corpo-
                                rate operating system market with the 1993 release of Windows NT, which quickly
                                became the operating system of choice for corporate workstations.72 Windows XP,
                                which is based on the Windows NT operating system, is discussed in Chapter 21,
                                Case Study: Windows XP.


                                Object Technology
                                Object technology became popular in many areas of computing, as the number of
                                applications written in object-oriented programming languages, such as C++ or
                                Java, increased steadily. Object concepts also facilitated new approaches to comput-
                                ing. Each software object encapsulates a set of attributes and a set of actions. This
                                allows applications to be built with components that can be reused in many applica-
                                tions, reducing software development time. In object-oriented operating systems
                                (OOOS), objects represent components of the operating system and system
                                resources. 73 Object-oriented concepts such as inheritance and interfaces were
                                exploited to create modular operating systems that were easier to maintain and
                                extend than operating systems built with previous techniques. Modularity facilitates
                                operating system support to new and different architectures. The demand for object
                                integration across multiple platforms and languages led to support for objects in
                                programming languages such as Sun's Java and Microsoft's .NET languages (e.g.,
                                Visual Basic .NET, Visual C++ .NET and C#).


                                Open-Source Movement
                                Another development in the computing community (particularly in the area of oper-
                                ating systems) during the 1990s was the movement toward open-source software.
                                Most software is created by writing source code in a high-level programming lan-
                                guage. However, most commercial software is sold as object code (also called
                                machine code or binaries)—the compiled source code that computers can under-
                                stand. The source code is not included, enabling vendors to hide proprietary informa-
                                tion and programming techniques. However, free and open-source software became
                                increasingly common in the 1990s. Open-source software is distributed with the
                                source code, allowing individuals to examine and modify the software before compil-
                                ing and executing it. For example, the Linux operating system and the Apache Web

<!-- pág. 81 -->

                                                                                                  1.8 The 1990s 21
server, both of which are free and open source, were downloaded and installed by
millions of users during the 1990s, and the number of downloads is increasing rapidly
in the new millennium.74 Linux, created by Linus Torvalds (see the Biographical
Note, Linus Torvalds), is discussed in Chapter 20, Case Study: Linux.
       In the 1980s, Richard Stallman, a software developer at MIT, launched a
project to recreate and extend most of the tools for AT&T's UNIX operating sys-
tem and to make the code available at no charge. Stallman (see the Biographical
Note, Richard Stallman) founded the Free Software Foundation and created the
GNU project—which is a recursive name that stands for "GNU's Not UNIX" —
because he disagreed with the concept of selling the permission to use software.75
He believed that granting users the freedom to modify and distribute software
would lead to better software, driven by user needs instead of personal or corporate
profit. When Linus Torvalds created the original version of the Linux operating sys-
tem, he employed many of the tools published by GNU for free under the General
Public License (GPL). The GPL, published online at www.gnu.org/1icenses/
gpl.html, specifies that anyone can freely modify and redistribute software under
its license, provided that the modifications are clearly indicated and any derivative
of the software is also distributed under the GPL. 76 Although most GPL-licensed
software is available free of charge, the GPL requires only that its software be free
in the sense that users can freely modify and redistribute it. Therefore, vendors can
charge a fee for providing GPL-licensed software and its source code, but cannot



               Biographical Note
  Linus Torvalds
  Linus Torvalds was born in 1969 in     Public License (GPL)80 as open-             Torvalds is currently a fellow i
  Helsinki, Finland. As a child he      source code and gladly accepted      of the Open Source Development
  taught himself how to program         additions, corrections and free       Labs (OSDL), which funds his full-
  by playing w i t h a Commodore         programs f r o m other program-     time work on the kernel. He con-
  VIC-20. In 1988 he entered the      mers.81,   82
                                                     By 1994 Linux had       tinues to lead the open-source
  University of Helsinki to study       accrued enough applications to        Linux project, managing changes
  computer science. While there, he      be a complete, usable operating     and releasing new versions of the
  wrote a UNIX clone based on Pro-      system, and version 1.0 was      kernel. 86,     87
                                                                                            Linux has become one
                                                    83
  fessor Andrew Tanenbaum's Minix        released. Programmers and pro-      of the largest and best-known
  to run on his new PC.77, 78 In 1991   fessors using UNIX on large sys-     open-source developments in corn-
  he completed the first version of     terns liked Linux because it         puting history and has become
  the basic Linux kernel, which ran      brought the features and power       particularly successful in the server
                                 79
  on the Intel 80386 processor. He      of UNIX to inexpensive desktop        market. Linux is discussed in
  distributed Linux under the GNU       systems for free. 84, 85             Chapter 20, Case Study: Linux.

<!-- pág. 82 -->

22   Introduction to Operating Systems

                                 prevent end users from modifying and redistributing them. In the late 90s, the Open
                                 Source Initiative (OSI) was founded to protect open-source software and promote
                                 the benefits of open-source programming (see www.opensource.org).
                                       Open-source software facilitates enhancements to software products by per-
                                 mitting anyone in the developer community to test, debug and enhance applica-
                                 tions. This increases the chance that subtle bugs, which could otherwise be security
                                 risks or logic errors, are caught and fixed. Also, individuals and corporations can
                                 modify the source to create custom software that meets the needs of a particular
                                 environment. Many open-source software vendors remain profitable by charging
                                 individuals and organizations for technical support and customizing software.88
                                 Though most systems in the 1990s still ran proprietary operating systems, such as
                                 IBM mainframe operating systems, UNIX systems, Apple's Macintosh and




                 Biographical Note
     Richard Stallman
     Richard Stallman was the original     shared software. 92 The lab's new     nel to complete his system. The
     developer of the GNU project,         operating system was not shared.      system, known as GNU/Linux, is a
     started in the 1980s to create free   Stallman became frustrated w i t h    fully functional operating system
     software. Stallman graduated          operating systems, drivers, and       and includes a variety of pro-
     from Harvard in 1974 w i t h a        the like, that he could no longer     grams. 97
     degree in Physics.89 While at Har-    modify. 93 In 1984 he left the MIT             Stallman has received
     vard, he worked at the MIT Artifi-    Artificial Intelligence Lab to work   numerous awards and recognition
     cial Intelligence Lab. After          on a new shared operating sys-        for his work, including the Grace
     graduating, he continued at the       tern, which he called GNU (GNU's      Hopper Award, MacArthur Foun-
     lab, where he and his colleagues      Not UNIX).94                          dation Fellowship, the Electric
     worked with shared software. 90             As interest in Stallman's GNU   Frontier Foundation Pioneer
     The idea was that someone             project grew, he created the Free     Award, the Yuri Rubinksi Award,
     receiving someone else's execut-      Software Foundation (FSF) in 1985     the Takeda Award, election to the
     able program would also receive       to promote free software and          National Academy of Engineer-
     its source code. This was advanta-    continue to develop the GNU           ing and t w o honorary doctorates
     geous because a programmer            operating system.95 Stallman and      f r o m the Institute of Technology
     could add more functionality to       his associates at FSF created a       in Sweden and the University of
     someone else's program. 9 1 Stall-    number of GNU programs, includ-       Glasgow. Stallman continues to
     man's specific job was to modify      ing GNU Emacs (a text editor),        promote the free software cause
     and improve the ITS operating         GCC (a C compiler) and GDB (a         and speaks about free software
     system the lab used. However, as      debugger), to name a few. 96 In       all over the world. 9 8
     the 1980s arrived, there was little   1992 Stallman used the Linux ker-

<!-- pág. 83 -->

                                                                                                  1.9   2000   and Beyond 23

Microsoft's Windows, open-source operating systems, such as Linux, FreeBSD and
OpenBSD, became viable competition. In the future, they will undoubtedly con-
tinue to gain ground on proprietary solutions as a result of product improvement,
industry standardization, interoperability, product customization and cost savings.
      In the 1990s, operating systems became increasingly user friendly. The GUI
features that Apple built into its Macintosh operating system in the 1980s became
more sophisticated in the 1990s. "Plug-and-play" capabilities were built into operat-
ing systems, enabling users to add and remove hardware components dynamically
without manually reconfiguring the operating system. Operating systems also main-
tained user profiles—serving authentication needs and enabling per-user customi-
zation of the operating system interface.

Self Review
1. How did object-oriented technology affect operating systems?
2. What are some of the benefits of open-source development?
Ans: 1) Operating systems designers could reuse objects when developing new compo-
nents. Increased modularity due to object-oriented technology facilitated operating system
support for new and different architectures. 2) Open-source software can be viewed and
modified by anyone in the software development community. Because these people con-
stantly test, debug and use the software, there is a greater chance that bugs will be found and
fixed. Also, open-source software enables users and organizations to modify a program to
meet their particular needs.


1.9 2000 and Beyond
In the current decade, middleware, which is software that links two separate applica-
tions (often over a network), has become vital as applications are published on the
World Wide Web and consumers use them via affordable, high-speed Internet con-
nections over cable television lines and digital subscriber lines (DSL). Middleware is
common in Web applications, in which a Web server (the application that sends data
to the user's Web browser) must generate content to satisfy a user's request with the
help of a database. The middleware acts as a courier to pass messages between the
Web server and the database, simplifying communication between multiple different
architectures. Web services encompass a set of related standards that can enable any
two computer applications to communicate and exchange data via the Internet. A
Web service communicates over a network to supply a specific set of operations that
other applications can invoke. The data is passed back and forth using standard pro-
tocols such as HTTP, the same protocol used to transfer ordinary Web pages. Web
services operate using open, text-based standards that enable components written in
different languages and on different platforms to communicate. They are ready-to-
use pieces of software on the Internet.
      Web services will help drive the shift toward true distributed computing. For
example, the online retailer Amazon.com allows developers to build online stores
that search Amazon's product databases and display detailed product information

<!-- pág. 84 -->

24 Introduction   to   Operating Systems

                                via Amazon.com Web Services (www.amazon.com/gp/aws/landing.html). The
                                Google search engine also can be integrated with other functionality through the
                                Google Web APIs (www.google.com/apis), which connect to Google's indices of
                                Web sites using Web services. We discuss Web services in more detail in Chapter 18,
                                Distributed Systems and Web Services.
                                       Multiprocessor and network architectures are creating numerous opportuni-
                                ties for research and development of new hardware and software design techniques.
                                Sequential programming languages that specify one computation at a time are now
                                complemented by concurrent programming languages, such as Java, that enable the
                                specification of parallel computations; in Java the units of parallel computing are
                                specified via threads. We discuss threads and the technique of multithreading in
                                Chapter 4, Thread Concepts.
                                       An increasing number of systems exhibit massive parallelism; they have large
                                numbers of processors so that many independent parts of computations can be per-
                                formed in parallel. This is dramatically different in concept from the sequential
                                computing of the past 60 years; there are significant and challenging problems in
                                developing the software appropriate for dealing with such parallelism. We discuss
                                parallel computing architectures in Chapter 15, Multiprocessor Management.
                                       Operating systems are standardizing user and application interfaces so that
                                they are easier to use and support a greater number of programs. Microsoft has
                                already merged the consumer and professional lines of its Windows operating sys-
                                tem into Windows XP. In its next operating system (code-named Longhorn).
                                Microsoft plans to integrate the formats of different types of files. This will, for
                                example, allow users to search their systems for all files (documents, spreadsheets,
                                e-mails, etc.) containing certain keywords. Longhorn will also include an enhanced
                                3D user interface, improved security and support for recordable digital versatile
                                discs (DVDs). 99, 100 Open-source operating systems, such as Linux, will become
                                more widely used and will employ standard application programming interfaces
                                (APIs) such as the Portable Operating System Interface (POSIX) to improve com-
                                patibility with other UNIX-based operating systems.
                                       Computing on mobile devices, such as cell phones and PDAs, will become more
                                common as mobile devices are equipped with increasingly powerful processors.
                                Today, these devices are used for such functions as e-mail, Web browsing and digital
                                imaging. Resource-intensive applications, such as full-motion video, will proliferate
                                on these devices. Because mobile device resources are limited by the devices' small
                                size, distributed computing will play an even larger role, as PDAs and cell phones will
                                request increasing amounts of data and processing power from remote computers.


                                Self Review
                                1. What technologies can be used to bridge the gap between different operating systems?
                                   How would these technologies make it possible to execute the same application on multi-
                                   ple platforms?
                                2. Why is distributed computing useful for computations performed by mobile devices?

<!-- pág. 85 -->

                                                                                                1.10   Application Bases 25

Ans: 1) Virtual machines and operating system emulators bridge the gap between different
operating systems. Applications can be written once to use the functionality of the virtual
machine or emulator. The virtual machines or emulators can be implemented to hide the rep-
resentation of the underlying platform from the applications. 2) Distributed computing
allows a mobile device to delegate jobs to other machines with more resources. The mobile
device, having limited resources and battery life, can request data and processing power from
larger computers across a network.



1.10 Application Bases
When the IBM Personal Computer (often called simply "the PC") appeared in
1981, it immediately spawned a huge software industry in which independent soft-
ware vendors (ISVs) were able to market packages for the IBM PC to run under
the MS-DOS operating system (IBM's version was called DOS). Operating systems
free applications software developers from having to deal with the messy details of
manipulating computer hardware to manage memory, perform input/output, deal
with communication lines, and so on. The operating system provides a series of
application programming interface (API) calls which applications programmers use
to accomplish detailed hardware manipulations and other operations. The API pro-
vides system calls by which a user program instructs the operating system to do the
work; the application developer simply has to know what routines to call to accom-
plish specific tasks (Fig. 1.1). Note that in Fig. 1.1, the area above the dashed line,
user space, indicates software components that are not part of the operating system
and cannot directly access the system's physical resources. The area below the
dashed line, kernel space, indicates software components that are part of the oper-
ating system and have unrestricted access to system resources. We frequently use
this convention in our diagrams to indicate the privilege with which software com-
ponents execute. If an application attempts to misuse system resources, or if the




Figure 1.1 | Interaction between applications and the operating         system.

<!-- pág. 86 -->

26   Introduction to Operating Systems

                              application attempts to use resources that it has not been granted, the operating
                              system must intervene to prevent the application from damaging the system or
                              interfering with other user applications.
                                    If an operating system presents an environment conducive to developing appli-
                              cations quickly and easily, the operating system and the hardware are more likely to
                              be successful in the marketplace. The applications development environment created
                              by MS-DOS encouraged the development of tens of thousands of application soft-
                              ware packages. This in turn encouraged users to buy IBM PCs and compatibles. Win-
                              dows could well have an application base of a hundred thousand applications.
                                    Once an application base (i.e., the combination of the hardware and the oper-
                              ating system environment in which applications are developed) is widely estab-
                              lished, it becomes extremely difficult to ask users and software developers to
                              convert to a completely new application development environment provided by a
                              dramatically different operating system. Thus, it is likely that new architectures
                              evolving over the next several years will make every effort to support the existing
                              major application bases.



                              1.11 Operating System Environments
                              This book focuses on operating system concepts related to general-purpose com-
                              puters with a range of resources, including sizable amounts of main memory, high
                              processor speeds, high-capacity disks, various peripheral devices, and so on. Such
                              computers are typically used as personal computers or as workstations.
                                     Many of the concepts that apply to general-purpose computers also apply to
                              high-end Web and database servers, which contain high-performance hardware.
                              Operating systems intended for high-end environments must be designed to sup-
                              port large main memories, special-purpose hardware, and large numbers of pro-
                              cesses. We discuss these considerations in Chapter 15, Multiprocessor Management.
                                     Embedded systems provide a different operating system design challenge.
                              They are characterized by a small set of specialized resources that provide function-
                              ality to devices such as cell phones and PDAs. In embedded environments, efficient
                              resource management is the key to building a successful operating system. Storage
                              is often limited, so the operating system must provide services using a minimal
                              amount of code. Considerations such as power management and the need for user-
                              friendly interfaces create other challenges in embedded operating system design.
                                     Real-time systems require that tasks be performed within a particular (often
                              short) time frame. For example, the autopilot feature of an aircraft must constantly
                              adjust speed, altitude and direction. Such actions cannot wait indefinitely—and some-
                              times cannot wait at all—for other nonessential tasks to complete. Real-time operat-
                              ing systems must enable processes to respond immediately to critical events. Soft real-
                              time systems ensure that real-time tasks execute with high priority, but do not guaran-
                              tee which, if any, of these tasks will complete on time. Hard real-time systems guaran-
                              tee that all of their tasks complete on time. We discuss how Linux and Windows XP

<!-- pág. 87 -->

                                                                              1.11 Operating System Environments 27

handle real-time applications in Chapters 20 and 21, respectively. These systems are
found in many settings including robotics, avionics and other system control applica-
tions. Often, they are used in mission-critical systems, where the system fails to meet
its objectives (i.e., mission) if any of its tasks are not successfully completed on time.
In mission-critical systems such as those for air traffic control, nuclear reactor moni-
toring and military command and control, people's lives could be at risk.
         Business-critical systems, such as Web servers and databases, must consis-
tently meet their objectives. In e-business, this could mean guaranteeing fast
response times to users purchasing products over the Internet; in large corpora-
tions, it could mean enabling employees to share information efficiently and ensur-
ing that important information is protected from problems such as power failures
and disk failures. Unlike mission-critical systems, the business does not necessarily
fail if a business-critical system does not always meet its objectives.
        Some operating systems must manage hardware that may or may not physi-
cally exist in the machine. A virtual machine (VM) is a software abstraction of a
computer that often executes as a user application on top of the native operating
system.101 A virtual machine operating system manages the resources provided by
the virtual machine. One application of virtual machines is to allow multiple
instances of an operating system to execute concurrently. Another is emulation—
using software or hardware that mimics the functionality of hardware or software
not present in the system.
       Virtual machines interface with the hardware in a system via the underlying
operating system; other user programs can interact with VMs. A VM can create
software components that represent the contents of physical systems —such as pro-
cessors, memory, communication channels, disks and clocks (Fig. 1.2).102 This allows
multiple users to share hardware under the illusion of being serviced by a dedicated
machine. By providing this illusion, virtual machines promote portability, the ability
for software to run on multiple platforms.
       The Java Virtual Machine (JVM) is one of the most widely used virtual
machines. The JVM is the foundation of the Java platform and allows Java applica-
tions to execute on any JVM of the correct version, regardless of the platform on
which the JVM is installed. The company VMware Software also provides virtual
machines, particularly for the Intel architecture, enabling owners of Intel x86-based
computers to run operating systems such as Linux and Windows concurrently on
one computer (each virtual machine appears in its own window).103
       Virtual machines tend to be less efficient than real machines because they
access the hardware indirectly (or simulate hardware that is not actually connected
to the computer). Indirect or simulated hardware access increases the number of
software instructions required to perform each hardware action.104

Self Review
1. What type of system would a temperature monitor in a nuclear power plant probably be
   described as? Why?
2. Describe the advantages and disadvantage of virtual machines.

<!-- pág. 88 -->

28 Introduction to Operating Systems




                             Figure 1.2 | Schematic if a virtual machine.

                            Ans: 1) A hard real-time system would monitor the temperature in a nuclear power plant to
                            ensure that it is always in an appropriate range, and would notify operators in real time (i.e.,
                            instantly) if there was a problem. 2) Virtual machines promote portability by enabling software
                            to run on multiple platforms, but they tend to be less efficient than real machines, because vir-
                            tual machines must execute software instructions that simulate hardware operations.


                             1.12 Operating System Components and Goals
                             Computer systems have evolved from early systems containing no operating sys-
                             tem, to multiprogramming machines, to timesharing machines, to personal comput-
                             ers and finally to truly distributed systems. As the demand for new features and
                             improved efficiency grew and hardware changed, operating systems evolved to fill
                             new roles. This section describes various core operating system components and
                             explains several goals of operating systems.

                             1.12.1 Core Operating System Components
                             A user interacts with the operating system via one or more user applications, and
                             often through a special application called a shell, or command interpreter. 105 Most
                             of today's shells are implemented as text-based interfaces that enable the user to
                             issue commands from a keyboard or as GUIs that allow the user to point and click
                             and drag and drop icons to request services from the operating system (e.g., to open
                             an application). For example, Microsoft Windows XP provides a GUI through

<!-- pág. 89 -->

                                                                 1.12   Operating System Components and Goals 29

which users can issue commands; alternatively, the user can open a command
prompt window that accepts typed commands.
      The software that contains the core components of the operating system is
referred to as the kernel. Typical operating system core components include:
      • the process scheduler, which determines when and for how long a process
        executes on a processor.
      • the memory manager, which determines when and how memory is allo-
        cated to processes and what to do when main memory becomes full.
      • the I/O manager, which services input and output requests from and to
        hardware devices, respectively.
      • the interprocess communication (IPC) manager, which allows processes to
        communicate with one another.
      • the file system manager, which organizes named collections of data on stor-
        age devices and provides an interface for accessing data on those devices.
      Almost all modern operating systems support a multiprogrammed environ-
ment in which multiple applications can execute concurrently. One of the most fun-
damental responsibilities of an operating system is to determine which processor
executes a process and for how long that process executes.
      A program may contain several elements that share data and that can be exe-
cuted concurrently. For example, a Web browser may contain separate components to
read a Web page's HTML, retrieve the page's media (e.g., images, text and video) and
render the page by laying out its content in the browser window. Such program com-
ponents, which execute independently but perform their work in a common memory
space, are called threads. Threads are discussed in Chapter 4, Thread Concepts.
      Typically, many processes compete to use the processor. The process sched-
uler can base its decisions on several criteria, such as importance of a process, its
estimated running time, or how long it has waited to obtain the processor. We dis-
cuss processor scheduling in Chapter 8, Processor Scheduling.
      The memory manager allocates memory to the operating system and to pro-
cesses. To ensure that processes to do not interfere with the operating system or
with one another, the memory manager prevents each process from accessing mem-
ory that has not been allocated to it. Almost all of today's operating systems sup-
port virtual memory, as discussed in Chapters 10 and 11.
      Another core function of the operating system is to manage the computer's
input/output (I/O) devices. Input devices include keyboards, mice, microphones
and scanners; output devices include monitors, printers and speakers. Storage
devices (e.g., hard disks, rewritable optical discs and tape) and network cards func-
tion as both input and output devices. When a process wishes to access an I/O
device, it must issue a system call to the operating system. That system call is subse-
quently handled by a device driver, which is a software component that interacts
directly with hardware, often containing device-specific commands and other
instructions to perform the requested input/output operations.

<!-- pág. 90 -->

30 Introduction to Operating Systems

                                   Most computer systems can store data persistently (i.e., after the computer is
                             turned off). Because main memory is often relatively small and loses its data when
                             the power is turned off, persistent secondary storage devices are used, most com-
                             monly hard disks. Disk I/O — one of the most common forms of I/O —occurs when a
                             process requests access to information on a disk device.
                                   Secondary storage, however, is much slower than processors and main mem-
                             ory. The disk scheduler component of an operating system is responsible for reor-
                             dering disk I/O requests to maximize performance and minimize the amount of
                             time a process waits for disk I/O. Redundant Array of Independent Disks (RAID)
                             systems attempt to reduce the time a process waits for disk I/O by using multiple
                             disks at once to service I/O requests. We discuss disk scheduling algorithms and
                             RAID systems in Chapter 12, Disk Performance Optimization.
                                   Operating systems use file systems to organize and efficiently access named
                             collections of data called files located on storage devices. File system concepts are
                             addressed in Chapter 13, File and Database Systems.
                                   Often, processes (or threads) cooperate to accomplish a common goal. Thus,
                             many operating systems provide interprocess communication (IPC) and synchroni-
                             zation mechanisms to simplify such concurrent programming. Interprocess commu-
                             nication enables processes to communicate via messages sent between the
                             processes (and threads); synchronization provides structures that can be used to
                             ensure that processes (and threads) share data properly. Processes and threads are
                             discussed in Chapters 3 through 8.

                             Self Review
                             1. Which operating system components perform each of the following operations?
                                   a. Write to disk.
                                   b. Determine which process will run next.
                                   c. Determine where in memory a new process should be placed.
                                   d. Organize files on disk.
                                   e. Enable one process to send data to another.
                             2. Why is it dangerous to allow users to perform read or write operations to any region of
                                disk at will?
                             Ans: 1) a) I/O manager; b) processor scheduler; c) memory manager; d) file system man-
                             ager; e) interprocess communication (IPC) manager. 2) It is dangerous because users could
                             accidentally or maliciously overwrite critical data (such as operating system files) or read sen-
                             sitive information (such as confidential documents) without authorization.



                             1.12.2 Operating System Goals
                             Users have come to expect certain characteristics of operating systems, such as:
                                    • efficiency
                                    • robustness

<!-- pág. 91 -->

                                                                     1.12   Operating System Components and       Goals   31

      •   scalability
      •   extensibility
      •   portability
      •   security
      •   interactivity
      •   usability
      An efficient operating system achieves high throughput and low average turn-
around time. Throughput measures the amount of work a processor can complete
within a certain time period. Recall that one role of an operating system is to provide
services to many applications. An efficient operating system minimizes the time spent
providing these services (see the Operating Systems Thinking feature, Performance).
       A robust operating system is fault tolerant and reliable —the system will not
fail due to isolated application or hardware errors, and if it fails, it does so gracefully
(i.e., by minimizing loss of work and by preventing damage to the system's hard-




                 Operating Systems Thinking
  Performance
   One of the most important goals          However, performance is often "in        throughput. Chapter 11, Virtual
   of an operating system is to maxi-       the eye of the beholder"—there           Memory Management, discusses
   mize system performance. We are          are many ways to classify operat-        allocating memory to processes
   performance conscious in our             ing system performance. For              to reduce their execution times,
   everyday lives. We measure our           batch-processing systems, through-       Chapter 12, Disk Performance
   cars' gasoline mileage, we record        put is an important measure; for         Optimization, focuses on improv-
   various speed records, professors        interactive timesharing systems,         ing disk performance by reorder-
   assign grades to students, employ-       fast response times are more              ing I/O requests. In Chapter 14,
   ees receive performance evalua-          important.                                Performance and Processor
   tions from their employers, a                 Throughout the book we              Design, we discuss evaluating sys-
   corporate executive's perfor-            present many performance                 terns according to several impor-
   mance is measured by company             improvement techniques. For              tant performance criteria,
   profits, politicians' performance is     example, Chapter 8, Processor            Chapters 20, and 21 discuss per-
   measured in frequent polls of their      Scheduling, discusses allocating         formance issues in the Linux and
   constituents and so on.                  processor time to processes to           Windows XP operating systems.
          High performance is essential     improve system performance as             respectively,
   to successful operating systems.         measured by interactivity and

<!-- pág. 92 -->

32 Introduction to Operating Systems

                             ware). Such an operating system will provide services to each application unless the
                             hardware it relies on fails.
                                    A scalable operating system is able to use resources as they are added. If an
                             operating system is not scalable, then it will quickly reach a point where additional
                             resources will not be fully utilized. A scalable operating system can readily adjust its
                             degree of multiprogramming. Scalability is a particularly important attribute of
                             multiprocessor systems —as more processors are added to a system, ideally the pro-
                             cessing capacity should increase in proportion to the number of processes, though,
                             in practice, that does not happen. Multiprocessing is discussed in Chapter 15, Multi-
                             processor Management.
                                    An extensible operating system will adapt well to new technologies and pro-
                             vide capabilities to extend the operating system to perform tasks beyond its original
                             design.
                                    A portable operating system is designed such that it can operate on many
                             hardware configurations. Application portability is also important, because it is
                             costly to develop applications, so the same application should run on a variety of
                             hardware configurations to reduce development costs. The operating system is cru-
                             cial to achieving this kind of portability.
                                    A secure operating system prevents users and software from accessing ser-
                             vices and resources without authorization. Protection refers to the mechanisms that
                             implement the system's security policy.
                                    An interactive operating system allows applications to respond quickly to user
                             actions, or events. A usable operating system is one that has the potential to serve a
                             significant user base. These operating systems generally provide an easy-to-use user
                             interface. Operating systems such as Linux, Windows XP and MacOS X are charac-
                             terized as usable operating systems, because each supports a large set of applica-
                             tions and provides standard user interfaces. Many experimental and academic
                             operating systems do not support a large number of applications or provide user-
                             friendly interfaces and therefore are not considered to be usable.


                             Self Review
                             1. Which operating system goals correspond to each of the following characteristics?
                                  a. Users cannot access services or information without proper authorization.
                                  b. The operating system runs on a variety of hardware configurations.
                                  c. System performance increases steadily when additional memory and processors are
                                     added.
                                  d. The operating system supports devices that were not available at the time of its design.
                                  e. Hardware failure does not necessarily cause the system to fail.
                             2. How does device driver support contribute to an operating system's extensibility?
                             ANS: 1) a) security; b) portability; c) scalability; d) extensibility; e) robustness. 2) Device
                             drivers enable developers to add support for hardware that did not exist when the operating
                             system was designed. With each new type of device that is added to a system a corresponding
                             device driver must be installed.

<!-- pág. 93 -->

                                                                            1.13 Operating System Architectures 33

1.13 Operating System Architectures
Today's operating systems tend to be complex because they provide many services
and support a variety of hardware and software resources (see the Operating Sys-
tems Thinking feature, Keep It Simple (KIS) and the Anecdote,). Operating system
architectures can help designers manage this complexity by organizing operating
system components and specifying the privilege with which each component exe-
cutes. In the monolithic design, every component of the operating system is con-
tained in the kernel; in the microkernel design, only the essential components are
included. In the sections that follow, we survey several important architectures (see
the Operating Systems Thinking feature, Architecture).


 1.13.1 Monolithic Architecture
The monolithic operating system is the earliest and most common operating system
architecture. Every component of the operating system is contained in the kernel and
can directly communicate with any other (i.e., simply by using function calls). The
kernel typically executes with unrestricted access to the computer system (Fig. 1.3).
OS/360, VMS and Linux are broadly characterized as monolithic operating sys-
tems.106 Direct intercommunication between components makes monolithic operat-
ing systems highly efficient. Because monolithic kernels group components together,




               Operating Systems Thinking
  Keep It Simple (KIS)
  Complex systems are costly to          trivial to program, but runs slowly     see the trade-offs between sim-
  design, implement, test, debug         compared to a more elegant and          plicity and complexity. As you
  and maintain. Often, operating         complicated binary search. Tree         read these solutions, you might
  systems designers will choose the      data structures can be more com-        be inclined to favor certain
  simplest of several approaches to      plex to work w i t h than arrays, but   approaches. The systems you
  solving a particular problem.          make it easier and faster to per-       work with in the future may
  Sometimes, though, a more com-         form certain types of insertions        demand different approaches,
  plex approach can yield perfor-        and deletions. We typically con-        Our philosophy is to present the
  mance benefits or other                sider alternate approaches to           pros and cons of the popular
  improvements that make such an         solving operating systems prob-         approaches to help you prepare
  approach worthwhile. Such trade-       lems and developing resource            to make your own best judgmer
  offs are common in computing. A        management strategies. As you           calls in industry,
  simple linear search of an array is    read these discussions, you will

<!-- pág. 94 -->

34 Introduction to Operating Systems




                                 Figure 1.3 | Monolithic operating System kernel architecture.

                                  however it is difficult to isolate the source of bugs and other errors. Further, because
                                  all code executes with unrestricted access to the system, systems with monolithic ker-
                                  nels are particularly susceptible to damage from errant or malicious code.

                                 Self Review
                                  1. What is the defining characteristic of a monolithic operating system?
                                  2. Why do monolithic operating systems tend to be efficient? What is a key weakness of
                                     monolithic kernels?




                  Anecdote
     System Architect vs. System Engineer
     If you enter the field of operating    some years ago. He was intro-           building, it's very well built, but
     systems development and you            duced as a systems architect. He        it's so ugly that the people tear it
     become more senior, you may be         said: "You may wonder how that          down; when an architect builds a
     given a title like systems architect   differs f r o m being a systems engi-   building, it's very beautiful, but
     or systems engineer. A profes-         neer." He humbly explained the          it falls d o w n ! "
     sional software colleague was a        difference w i t h a building anal-
     guest speaker at a conference          ogy: "When an engineer builds a


     Lesson to operating systems designers: You need to combine aspects of both architecture and engineering
     to insure that your systems are both well built and elegant. The latter goal is less important.

<!-- pág. 95 -->

                                                                                1.13 Operating System Architectures 35

Ans: 1) In a monolithic operating system every component of the operating system is con-
tained in the kernel. 2) Monolithic kernels tend to be efficient because few calls cross from
user space to kernel space. Because all OS code in monolithic kernels operates with unre-
stricted access to the computer's hardware and software, these systems are particularly sus-
ceptible to damage from errant code.

1.13.2 Layered Architecture
As operating systems became larger and more complex, purely monolithic designs
became unwieldy. The layered approach to operating systems attempts to address
this issue by grouping components that perform similar functions into layers. Each
layer communicates exclusively with those immediately above and below it. Lower-
level layers provide services to higher-level ones using an interface that hides their
implementation.
       Layered operating systems are more modular than monolithic operating sys-
tems, because the implementation of each layer can be modified without requiring
any modification to other layers. A modular system has self-contained componen
that can be reused throughout the system. Each component hides how it performs




                 Operating Systems Thinking

  Architecture
   Just as architects use different          increasingly difficult to change          calls the services provided by the
   approaches to designing build-            approaches the further into the           layer below it, while the imple-
   ings, operating systems designers         development you proceed, so it is         mentation of that layer is hidden
   employ different architectural            important to choose the proper            from the layer above. Layering
   approaches to designing operat-           architecture early in system devel-       combines the virtues of the soft-
   ing systems. Sometimes these              opment. More generally, it is             ware engineering techniques of
   approaches are pure in that one           much easier to build the building         modularity and information hiding
   architectural approach is used            correctly in the first place than it      to provide a solid basis for building
   throughout the system. Some-              is to modify the building after it        quality systems. We discuss layered
   times hybridized approaches are           has been built.                           software approaches throughout
   used, mixing the advantages of                  One of the most common              the book, starting with a historic
   several architectural styles. The         architectural approaches                  mention of Dijkstra's THE system
   approach the designer chooses             employed in software systems such         (see Section 1.13.2, Layered Archi-
   will have monumental conse-               as operating systems is called lay-       tecture) and continuing to expla-
   quences on the initial implemen-          ering. This software is divided into      nations of how layering is used
   tation and the evolution of the           modules called layers that each           in Linux and Windows XP in
   operating system. It becomes              perform certain tasks. Each layer         Chapters 20, and 21, respectively.

<!-- pág. 96 -->

36 Introduction to Operating Systems

                             its job and presents a standard interface that other components can use to request
                             its services. Modularity imposes structure and consistency on the operating sys-
                             tem—often simplifying validation, debugging and modification. However, in a lay-
                             ered approach, a user process's request may need to pass through many layers
                             before it is serviced. Because additional methods must be invoked to pass data from
                             one layer to the next, performance degrades compared to that of a monolithic ker-
                             nel, which may require only a single call to service a similar request. Also, because
                             all layers have unrestricted access to the system, layered kernels are also suscepti-
                             ble to damage from errant or malicious code. The THE operating system is an early
                             example of a layered operating system (Fig. 1.4).107 Many of today's operating sys-
                             tems, including Windows XP and Linux, implement some level of layering.

                             Self Review
                             1. How are layered operating systems more modular than monolithic operating systems?
                             2. Why do layered operating systems tend to be less efficient than monolithic operating sys-
                                tems?
                             Ans: 1) In layered operating systems, the implementation and interface are separate for
                             each layer. This allows each layer to be tested and debugged separately. It also enables
                             designers to change each layer's implementation without needing to modify the other layers.
                             2) In layered operating systems, several calls may be required to communicate between the
                             layers, whereas this overhead does not exist in monolithic kernels.

                             1.13.3     Microkernel Architecture
                             A microkernel operating system architecture provides only a small number of ser-
                             vices in an attempt to keep the kernel small and scalable. These services typically
                             include low-level memory management, interprocess communication and basic pro-




                             Figure 1.4 | Layers of the THE operating system.

<!-- pág. 97 -->

                                                                               1.13 Operating System Architectures 37

cess synchronization to enable processes to cooperate. In microkernel designs, most
operating system components—such as process management, networking, file sys-
tem interaction and device management—execute outside the kernel with a lower
privilege level (Fig. 1.5).108, 109, 110, 111
      Microkernels exhibit a high degree of modularity, making them extensible,
portable and scalable.112 Further, because the microkernel does not rely on each
component to execute, one or more components can fail, without causing the oper-
ating system to fail. However, such modularity comes at the cost of an increased
level of intermodule communication, which can degrade system performance.
Although few of today's popular operating systems fully embrace the microkernel
design, Linux and Windows XP, for example, contain modular components.113

Self Review
1. What is the difference between a purely layered architecture and a microkernel architec-
   ture?
2. How do microkernels promote portability?
Ans: 1) A layered architecture enables communication exclusively between operating sys-
tem components in adjacent layers. A microkernel architecture enables communication
between all operating system components via the microkernel. 2) The microkernel does not
depend on a particular hardware platform; support for new hardware can be provided by
loading a new module.




Figure 1.5 | Microkernel operating system architecture.

<!-- pág. 98 -->

38 Introduction to Operating Systems

                             1.13.4 Networked and Distributed Operating Systems
                             Advances in telecommunications technology have profoundly affected operating sys-
                             tems. A network operating system enables its processes to access resources (e.g., files)
                             that reside on other independent computers on a network.114 The structure of many
                             networked and distributed operating systems is often based on the client/server
                             model (Fig. 1.6). The client computers in such a network request resources—such as
                             files and processor time—via the appropriate network protocol. The servers respond
                             with the appropriate resources. In such networks, operating system designers must
                             carefully consider how to manage data and communication among computers.
                                    Some operating systems are more "networked" than others. In a networked
                             environment, a process can execute on the computer on which it is created or on
                             another computer on the network. In some network operating systems, users can
                             specify exactly where their processes run; in others, the operating system deter-
                             mines where processes are executed. For example, the system may determine that a
                             process can be more efficiently executed on a computer experiencing a light load.115
                                    Networked file systems are an important component of networked operating
                             systems. At the lowest level, users acquire resources on another machine by explic-
                             itly connecting to that machine and retrieving files. Higher-level network file sys-
                             tems enable users to access remote files as if they were on the local system.
                             Examples of network file systems include Sun's Network File System (NFS) and




                             Figure 1.6 | Client/server networked operating system model.

<!-- pág. 99 -->

                                                                                                          Web Resources 39
CMU's Andrew and Coda file systems. Networked file systems are discussed in
detail in Chapter 18, Distributed Systems and Web Services.
      A distributed operating system is a single operating system that manages
resources on more than one computer system. Distributed systems provide the illu-
sion that multiple computers are a single powerful computer, so that a process can
access all of the system's resources regardless of the process's location within the
distributed system's network of computers. 116 Distributed operating systems are
often difficult to implement and require complicated algorithms to enable processes
to communicate and share data. Examples of distributed operating systems are
MIT's Chord operating system and the Amoeba operating system from the Vrije
Universiteit (VU) in Amsterdam. 117, 118 We discuss distributed systems in
Chapter 17, Introduction to Distributed Systems.
     Now that we have presented a seemingly endless stream of facts, issues, and
acronyms, we proceed with a discussion of the basic principles of computer hard-
ware and software in Chapter 2, Hardware and Software Concepts.


Self Review
1. What is the major difference between networked and distributed operating systems?
2. What is the primary advantage of a distributed operating system? What is the primary
   challenge of designing one?
Ans: 1) A networked operating system controls one computer but cooperates with other
computers on the network. In a distributed operating system, one operating system controls
many computers in a network. 2) The primary advantage is that processes do not need to
know the locations of the resources they use, which simplifies applications programming. This
comes at the expense of the systems programmer, who must implement complicated algo-
rithms to enable processes to communicate and share data among many computers, creating
the illusion of there being only a single larger computer.




Web Resources
www.bel1-1abs.com/history/unix/ developer.apple.com/darwin/history.html
Provides a history of the UNIX operating system, from its ori-       Covers the evolution of Darwin, the core of Apple's OS X
gins in the Multics system to the mature UNIX operating sys-         operating system.
terns of today. Discusses many of the design and architectural www.cryptonomicon.com/beginning.html
considerations in the evolution of UNIX.                             Contains a link to the article, "In the Beginning Was the Corn-
www.softpanorama.org/History/os_history.shtml                       mand Line," by Neal Stephenson. This text is a narrative
Provides a wealth of information on open-source software             account of the recent history of operating systems, making col-
from a historical perspective.                                       orful use of anecdote and metaphor.
www.microsoft.com/windows/WinHistoryIntro.mspx www.acm.org/sigcse/cc2001/225.html
Provides a history of the Microsoft Windows family of operat-  Lists the operating systems course curriculum recommenda-
ing systems.                                                   tion from the ACM/IEEE Joint Task Force that completed the
www.viewz.com/shoppingguide/os.shtml                           Computing Curricula 2001 (CC2001) project. The curriculum
Compares several popular operating systems, including Win-     indicates key areas of coverage for a typical operating systems
dows, Linux and MacOS, and provides a historical perspective.  course.

<!-- pág. 100 -->

40 Introduction to Operating Systems

whatis.techtarget.com/ www.wikipedia.org/
Provides definitions for computer-related terms.              Wikipedia is a project aimed at creating a free, open and accu-
www.webopedia.com/                                            rate encyclopedia online. Any user may modify the entries in
Provides an online dictionary and a search engine for com-    the encyclopedia, and all entries are licensed under the GNU
puter- and Internet-related terms.                            Free Documentation License (GNUFDL).



Summary
Some years ago an operating system was defined as the                In 1964, IBM announced its System/360 family of
software that controls the hardware, but the landscape of     computers. The various 360 computer models were
computer systems has evolved significantly since then,        designed to be hardware compatible, to use the OS/360
requiring a more complicated description. To increase         operating system and to offer greater computer power as
hardware utilization, applications are designed to execute    the user moved upward in the series. More advanced oper-
concurrently. However, if these applications are not care-    ating systems were developed to service multiple interac-
fully programmed, they might interfere with one another.      tive users at once. Timesharing systems were developed to
As a result, a layer of software called an operating system   support large numbers of simultaneous interactive users.
separates applications (the software layer) from the hard-           Real-time systems attempt to supply a response
ware they access.                                             within a certain bounded time period. The resources of a
       When a user requests that the computer perform an      real-time system are often heavily under-utilized. It is more
action (e.g., execute an application or print a document),    important for real-time systems to respond quickly when
the operating system manages the software and hardware        needed than to use their resources efficiently.
to produce the desired result. Operating systems are prima-          Turnaround time—the time between submission of a
rily resource managers—they manage hardware, including        job and the return of its results—was reduced to minutes or
processors, memory, input/output devices and communica-       even seconds. The value of timesharing systems in support
tion devices. The operating system must also manage appli-    of program development was demonstrated when MIT
cations and other software abstractions that, unlike          used the CTSS system to develop its own successor, Mul-
hardware, are not physical objects.                           tics. TSS, Multics and CP/CMS all incorporated virtual
       Operating systems have evolved over the last 60        memory, which enables programs to address more memory
years through several distinct phases or generations that     locations than are actually provided in main memory,
correspond roughly to the decades. In the 1940s, the earli-   which is also called real memory or physical memory.
est electronic digital computers did not include operating           The systems of the 1970s were primarily multimode
systems. The systems of the 1950s generally executed only     timesharing systems that supported batch processing, time-
one job at a time, but used techniques that smoothed the      sharing and real-time applications. Personal computing was
transition between jobs to obtain maximum utilization of      in its incipient stages, fostered by early and continuing
the computer system. A job constituted the set of instruc-    developments in microprocessor technology. Communica-
tions that a program would execute. These early computers     tions between computer systems throughout the United
were called single-stream batch-processing systems,           States increased as the Department of Defense's TCP/IP
because programs and data were submitted in groups or         communications standards became widely used—especially
batches by loading them consecutively onto tape or disk.      in military and university computing environments. Secu-
       The systems of the 1960s were also batch-processing    rity problems increased as growing volumes of information
systems, but they used the computer's resources more effi-    passed over vulnerable communications lines.
ciently by running several jobs at once. The systems of the          The 1980s was the decade of the personal computer
1960s improved resource utilization by allowing one job to    and the workstation. Rather than data being brought to a
use the processor while other jobs used peripheral devices.   central, large-scale computer installation for processing,
With these observations in mind, operating systems design-    computing was distributed to the sites at which it was
ers developed multiprogramming systems that managed a         needed. Personal computers proved to be relatively easy to
number of jobs at once, that number being indicated by the    learn and use, partially because of graphical user interfaces
system's degree of multiprogramming.                          (GUI), which used graphical symbols such as windows,

<!-- pág. 101 -->

                                                                                                         Summary        41
icons and menus to facilitate user interaction with pro-        backbone of his new hypertext information system, which
grams. As technology costs declined, transferring informa-      he called the World Wide Web.
tion between computers in computer networks became                    Hardware performance continued to improve expo-
more economical and practical. The client/server distrib-       nentially in the 1990s. Inexpensive processing power and
uted computing model became widespread. Clients are             storage allowed users to execute large, complex programs
user computers that request various services; servers are       on personal computers and enabled small to mid-size com-
computers that perform the requested services.                  panies to use these economical machines for the extensive
       The software engineering field continued to evolve, a    database and processing jobs that earlier had been dele-
major thrust by the United States government being aimed        gated to mainframe systems. In the 1990s, the shift toward
especially at providing tighter control of Department of        distributed computing (i.e., using multiple independent
Defense software projects. Some goals of the initiative         computers to perform a common task) rapidly accelerated.
included realizing code reusability and a greater degree of     As demand for Internet connections grew, operating sys-
abstraction in programming languages. Another software          tem support for networking tasks became standard. Users
engineering development was the implementation of pro-          at home and in large corporations increased productivity
cesses containing multiple threads of instructions that         by accessing the resources on networks of computers.
could execute independently.                                          Microsoft Corporation became dominant in the
       In the late 1960s, ARPA, the Advanced Research           1990s. Its Windows operating systems, which borrowed
Projects Agency of the Department of Defense, rolled out        from many concepts popularized by early Macintosh oper-
the blueprints for networking the main computer systems         ating systems (such as icons, menus and windows), enabled
of about a dozen ARPA-funded universities and research          users to navigate multiple concurrent applications with
institutions. ARPA proceeded to implement what was              ease.
dubbed the ARPAnet—the grandparent of today's Inter-                   Object technology became popular in many areas of
net. ARPAnet's chief benefit proved to be its capability for    computing. Many applications were written in object-ori-
quick and easy communication via what came to be known          ented programming languages, such as C++ or Java. In
as electronic mail (e-mail). This is true even on today's       object-oriented operating systems (OOOS), objects repre-
Internet, with e-mail, instant messaging and file transfer      sent components of the operating system. Object-oriented
facilitating communications among hundreds of millions of       concepts such as inheritance and interfaces were exploited
people worldwide.                                               to create modular operating systems that were easier to
       The ARPAnet was designed to operate without cen-         maintain and extend than operating systems built with pre-
tralized control. The protocols (i.e., set of rules) for com-   vious techniques.
municating over the ARPAnet became known as the                        Most commercial software is sold as object code. The
Transmission Control Protocol/Internet Protocol (TCP/IP).       source code is not included, enabling vendors to hide pro-
TCP/IP was used to manage communication between                 prietary information and programming techniques. Free
applications. The protocols ensured that messages were          and open-source software became increasingly common in
routed properly from sender to receiver and arrived intact.     the 1990s. Open-source software is distributed with the
Eventually, the government decided to allow access to the       source code, allowing individuals to examine and modify
Internet for commercial purposes.                               the software before compiling and executing it. The Linux
       The World Wide Web allows computer users to locate       operating system and the Apache Web server are both free
and view multimedia-based documents (i.e., documents            and open source.
with text, graphics, animations, audios or videos) on almost           In the 1980s, Richard Stallman, a developer at MIT,
any subject. Even though the Internet was developed more        launched the GNU project to recreate and extend most of
than three decades ago, the introduction of the World Wide      the tools for AT&T's UNIX operating system. Stallman
Web (WWW) was a relatively recent event. In 1989, Tim           created the GNU project because he disagreed with the
Berners-Lee of CERN (the European Center for Nuclear            concept of paying for permission to use software. The Open
Research) began to develop a technology for sharing infor-      Source Initiative (OSI) was founded to further the benefits
mation via hyperlinked text documents. To implement this        of open-source programming. Open-source software facili-
new technology, He created the Hypertext Markup Lan-            tates enhancements to software products by permitting
guage (HTML). Berners-Lee also implemented the Hyper-           anyone in the developer community to test, debug and
text Transfer Protocol (HTTP) to form the communications        enhance applications. This increases the chance that subtle

<!-- pág. 102 -->

42 Introduction to Operating Systems

bugs, which could otherwise be security risks or logic                 Some operating systems must manage hardware that
errors, will be caught and fixed. Also, individuals and cor-    may or may not physically exist in the machine. A virtual
porations can modify the source to create custom software       machine (VM) is a software abstraction of a computer that
that meets the needs of a particular environment.               often executes as a user application on top of the native
       In the 1990s, operating systems became increasingly      operating system. A virtual machine operating system man-
user friendly. The GUI features that Apple had built into its   ages the resources provided by the virtual machine. One
Macintosh operating system in the 1980s were widely used        application of virtual machines is to allow multiple
in many operating systems and became more sophisticated.        instances of an operating system to execute concurrently.
"Plug-and-play" capabilities were built into operating sys-     Another use for virtual machines is emulation—the ability
tems, enabling users to add and remove hardware compo-          to use software or hardware that mimics the functionality
nents dynamically without manually reconfiguring the            of hardware or software not present in the system. By pro-
operating system.                                               viding the illusion that applications are running on differ-
       Middleware is software that links two separate appli-    ent hardware or operating systems, virtual machines
cations, often over a network and often between incompat-       promote portability—the ability for software to run on
ible machines. It is particularly important for Web services    multiple platforms —and many other benefits.
because it simplifies communication across multiple archi-             A user interacts with the operating system via one or
tectures. Web services encompass a set of related standards     more user applications. Often, the user interacts with an
that can enable any two computer applications to commu-         operating system through a special application called a
nicate and exchange data via the Internet. They are ready-      shell. The software that contains the core components of
to-use pieces of software on the Internet.                      the operating system is referred to as the kernel. Typical
       When the IBM PC appeared, it immediately spawned         operating system components include the processor sched-
a huge software industry in which independent software          uler, memory manager, I/O manager, interprocess commu-
vendors (ISVs) were able to market software packages for        nication (IPC) manager, and file system manager.
the IBM PC to run under the MS-DOS operating system. If                Almost all modern operating systems support a mul-
an operating system presents an environment conducive to        tiprogrammed environment in which multiple applications
developing applications quickly and easily, the operating       can execute concurrently. The kernel manages the execu-
system and the hardware are more likely to be successful in     tion of processes. Program components, which execute
the marketplace. Once an application base (i.e., the combi-     independently but use a single memory space to share data,
nation of the hardware and the operating system environ-        are called threads.
ment in which applications are developed) is widely                    When a process wishes to access an I/O device, it must
established, it becomes extremely difficult to ask users and    issue a system call to the operating system. That system call
software developers to convert to a completely new appli-       is subsequently handled by a device driver—a software com-
cations development environment provided by a dramati-          ponent that interacts directly with hardware—often contain-
cally different operating system.                               ing device-specific commands and other instructions to
       Operating systems intended for high-end environ-         perform the requested input and output operations.
ments must be designed to support large main memories,                 Users have come to expect certain characteristics of
special-purpose hardware, and large numbers of processes.       operating systems, such as efficiency, robustness, scalability,
Embedded systems are characterized by a small set of spe-       extensibility, portability, security and protection, interactiv-
cialized resources that provide functionality to devices such   ity and usability.
as cell phones and PDAs. In these environments, efficient              In a monolithic operating system, every component is
resource management is the key to building a successful         contained in the kernel. As a result, any component can
operating system.                                               directly communicate with any other. Monolithic operating
       Real-time systems require that tasks be performed        systems tend to be highly efficient. A disadvantage of
within a particular (often short) time frame. For example,      monolithic designs is that it is difficult to determine the
the autopilot feature of an aircraft must constantly adjust     source of subtle errors.
speed, altitude and direction. Such actions cannot wait                The layered approach to operating systems attempts
indefinitely—and sometimes cannot wait at all—for other         to address this issue by grouping components that perform
nonessential tasks to complete.                                 similar functions into layers. Each layer communicates
                                                                exclusively with the layers immediately above and below it.

<!-- pág. 103 -->

                                                                                                               Key     Terms     43

In a layered approach, a user process's request may need to         and scalable. However, such modularity comes at the cost
pass through many layers before completion. Because                 of an increased level of intermodule communication, which
additional methods must be invoked to pass data and con-            can degrade system performance.
trol from one layer to the next, system throughput                        A network operating system runs on one computer
decreases compared to that with a monolithic kernel, which          and allows its processes to access resources such as files and
may require only a single call to service a similar request.        processors on a remote computer. A distributed operating
      A microkernel operating system architecture pro-              system is a single operating system that manages resources
vides only a small number of services in an attempt to keep         on more than one computer system. The goals of a distrib-
the kernel small and scalable. Microkernels exhibit a high          uted operating system include transparent performance,
degree of modularity, making them extensible, portable              scalability, fault tolerance and consistency.




Key Terms
Advanced Research Projects Agency (ARPA)—Government                 device driver—Software through which the kernel interacts
   agency under the Department of Defense that laid the                 with hardware devices. Device drivers are intimately
   groundwork for the Internet; it is now called the Defense            familiar with the specifics of the devices they manage—
   Advanced Research Projects Agency (DARPA).                           such as the arrangement of data on those devices—and
application base—Combination of the hardware and the oper-              they deal with device-specific operations such as reading
    ating system environment in which applications are devel-           data, writing data and opening and closing a DVD drive's
    oped. It is difficult for users and application developers to       tray. Drivers are modular, so they can be added and
    convert from an established application base to another.            removed as a system's hardware changes, enabling users
                                                                        to add new types of devices easily; in this way they con-
application programming interface (API)—Specification that              tribute to a system's extensibility.
    allows applications to request services from the kernel by
    making system calls.                                            disk scheduler—Operating system component that determines
                                                                         the order in which disk I/O requests are serviced to
ARPAnet—Predecessor to the Internet that enabled research-
                                                                         improve performance.
   ers to network their computers. ARPAnet's chief benefit
   proved to be quick and easy communication via what               distributed computing—Using multiple independent comput-
   came to be known as electronic mail (e-mail).                         ers to perform a common task.
bandwidth—Information-carrying capacity of a communica-             distributed operating system—Single operating system that
    tions line.                                                          provides transparent access to resources spread over mul-
business-critical system—System that must function properly,             tiple computers.
    but whose failure of which leads to reduced productivity        distributed system—Collection of computers that cooperate to
    and profitability; not as crucial as a mission-critical sys-         perform a common task.
    tem, where failure could put human lives could be at risk.
                                                                    efficient operating system—Operating system that exhibits
C—High-level programming language that was designed and
                                                                          high throughput and small turnaround time.
  used to implement the UNIX operating system.
client—Process that requests a service from another process (a      embedded system—Small computer containing limited
     server). The machine on which the client process runs is          resources and specialized hardware to run devices such as
     also called a client.                                             PDAs or cellular phones.
compute-bound—See processor-bound.                                  extensible operating system—An operating system that can
                                                                        incorporate new features easily.
CP/CMS—Timesharing operating system developed by IBM
   in the 1960s.                                                    fault tolerance—Operating system's ability to handle software
CTSS—Timesharing operating system developed at MIT in                    or hardware errors.
   the 1960s.                                                       file system manager—Operating system component that orga-
degree of multiprogramming—Number of programs a system                    nizes named collections of data on storage devices and
    can manage at a time.                                                 provides an interface for accessing data on those devices.

<!-- pág. 104 -->

44 Introduction to Operating Systems

General Public License (GPL)—Open-source software license          job—Set of work to be done by a computer.
   which specifies that software distributed under it must         kernel—Software that contains the core components of an
   contain the complete source code, must clearly indicate             operating system.
   any modifications to the original code and must be accom-
                                                                   layered operating system—Modular operating system that
   panied by the GPL. End users are free to modify and
                                                                        places similar components in isolated layers. Each layer
   redistribute any software under the GPL.
                                                                        accesses the services of the layer below and returns results
GNU—Project initiated by Stallman in the 1980s aimed at pro-            to the layer above.
   ducing an open-source operating system with the features
                                                                   level of multiprogramming—See degree of multiprogramming.
   and utilities of UNIX.
                                                                   massive parallelism—Property of a system containing large
graphical user interface (GUI)—User-friendly point of access
                                                                       numbers of processors so that many parts of computations
    to an operating system that uses graphical symbols such as
                                                                       can be performed in parallel.
    windows, icons and menus to facilitate program and file
    manipulation.                                                  memory manager— Operating system component that controls
                                                                      physical and virtual memory.
HyperText Markup Language (HTML)—Language that speci-
   fies the content and arrangement of information on a Web        microkernel operating system—Scalable operating system that
   page and provides hyperlinks to access other pages.                 puts a minimal number of services in the kernel and
                                                                       requires user-level programs to implement services gener-
Hypertext Transfer Protocol (HTTP)—Network protocol
                                                                       ally delegated to the kernel in other types of operating
   used for transferring HTML documents and other data
                                                                       systems.
   formats between a client and a server. This is the key pro-
   tocol of the World Wide Web.                                    middleware—Layer of software that enables communication
                                                                       between different applications. Middleware simplifies
I/O-bound—Process (or job) that tends to use a processor for
                                                                       application programming by performing work such as net-
    a short time before generating an I/O request and relin-
                                                                       work communication and translation between different
    quishing a processor.
                                                                       data formats.
I/O manager—Operating system component that receives,
                                                                   mission-critical system—System that must function properly;
    interprets and performs I/O requests.
                                                                       its failure could lead to loss of property, money or even
independent software vendor (ISV)—Organization that devel-             human life.
    ops and sells software. ISVs prospered after the release of    monolithic operating system—Operating system whose kernel
    the IBM PC.
                                                                      contains every component of the operating system. The
interactive operating system—Operating system that allows             kernel typically operates with unrestricted access to the
     applications to respond quickly to user input.                   computer system.
interactive users—Users that are present when the system pro-      Multics—One of the first operating systems to implement vir-
     cesses their jobs. Interactive users communicate with their       tual memory. Developed by MIT, GE and Bell Laborato-
     jobs during execution.                                           ries as the successor to MIT's CTSS.
Internet—Network of communication channels that provides           multiprogramming—Ability to store multiple programs in
    the backbone for telecommunication and the World Wide              memory at once so that they can be executed concur-
    Web. Each computer on the Internet determines which                rently.
    services it uses and which it makes available to other com-    network operating system—Operating system that can manip-
    puters connected to the Internet.                                  ulate resources at remote locations but does not hide the
interprocess communication (IPC) manager—Operating sys-                location of these resources from applications (as distrib-
     tem component that governs communication between                  uted systems can).
     processes.                                                    object-oriented operating system (OOOS)—Operating system
Java Virtual Machine (JVM)—Virtual machine that enables                in which components and resources are represented as
    Java programs to execute on many different architectures           objects. Object-oriented concepts such as inheritance and
    without recompiling Java programs into the native                  interfaces help create modular operating systems that are
    machine language of the computer on which they execute.            easier to maintain and extend than operating systems
    The JVM promotes application portability and simplifies            built with previous techniques. Many operating systems
    programming by freeing the programmer from architec-               use objects, but few are written entirely using object-ori-
    ture-specific considerations.                                      ented languages.

<!-- pág. 105 -->

                                                                                                                  Key     Terms     45

online—State describing a computer that is turned on (i.e.,             scalable operating system—Operating system that is able to
     active) and directly connected to a network.                            employ resources as they are added to the system. It can
open-source software—Software that includes the applica-                     readily adapt its degree of multiprogramming to meet the
    tion's source code and is often distributed under the Gen-               needs of its users.
    eral Public License (GPL) or a similar license. Open-               secure operating system—Operating system that prevents
    source software is typically developed by teams of inde-                users and software from gaining unauthorized access to
    pendent programmers worldwide.                                          services and data.
open-source initiative (OSI)—Group that supports and pro-       server—Process that provides services to other processes
    motes open-source software (      s      e      ew w w . o p e n (called  clients).
                                                                          s o u   r c e The. c o
                                                                                             machine
                                                                                                  m )on. which these processes run
                                                                     is also called a server.
operating system—Software that manages system resources to
    provide services that allow applications to execute prop-   shell—Application (typically GUI or text based) that enables
    erly. An operating system may manage both hardware and           a user to interact with an operating system
    software resources. Operating systems provide an applica-   single-stream batch-processing system—Early computer sys-
    tion programming interface to facilitate application devel-      tem that executed a series of noninteractive jobs sequen-
    opment. They also help make system resources                     tially, one at a time.
    conveniently available to users while providing a reliable, system call— Call from a user process that invokes a service of
    secure and responsive environment to applications and            the kernel.
    users.
                                                                thread—Entity that describes an independently executable
portability—Property of software that can run on different           stream of program instructions (also called a thread of
    platforms.                                                       execution or thread of control). Threads facilitate parallel
portable operating system— Operating system that is designed         execution of concurrent activities within a process.
    to operate on many hardware configurations.                 throughput—Amount of work performed per unit time.
Portable Operating Systems Interface (POSEX)-API based          timesharing system—Operating system that enables multiple
    on early UNIX operating systems.                                 simultaneous interactive users.
priority of a process— Importance or urgency of a process rela-         Transmission Control Protocol/Internet Protocol (TCP/IP)—
    tive to other processes.                                                Family of protocols that provide a framework for net-
process scheduler—Operating system component that deter-                    working on the Internet.
    mines which process can gain access to a processor and for          TSS— Operating system designed by IBM in the 1960s that
    how long.                                                              offered timesharing and virtual memory capabilities.
process—An executing program.                                              Although it was never released commercially, many of its
                                                                           capabilities appeared in later IBM systems.
processor-bound—Process (or job) that consumes its quantum
                                                                        turnaround time—Time it takes from the submission of a
    when executing. These processes (or jobs) tend to be cal-
                                                                            request until the system returns the result.
    culation intensive and issue few, if any, I/O requests.
                                                                        UNIX—Operating system developed at Bell Laboratories that
protection—Mechanism that implements a system's security
                                                                           was written using the C high-level programming language.
    policy by preventing applications from accessing
    resources and services without authorization.                       usable operating system—Operating system that has the
                                                                            potential to serve a significant user base by providing an
real-time system—System that attempts to service requests
                                                                            easy-to-use interface and supporting a large set of user-
     within a specified (usually short) time period. In mission-
                                                                            oriented applications.
     critical real-time systems (e.g., air traffic control and petro-
     leum refinery monitors), money, property or even human             virtual machine—Application that emulates the functionality
     life could be lost if requests are not serviced on time.                of a computer system. A virtual machine can execute
                                                                             applications that are not directly compatible with the
robust operating system— Operating system that is fault toler-               physical system that runs the virtual machine. The user
    ant and reliable—the system will not fail due to unex-                   "sees" the computer not as the virtual machine, but as the
    pected application or hardware errors (but if it must fail,              underlying physical machine.
    it does so gracefully). Such an operating system will pro-
    vide services to each application unless the hardware               virtual memory—Capability of operating systems that enables
    those services requires fails to function.                               programs to address more memory locations than are

<!-- pág. 106 -->

46     Introduction to Operating Systems

      actually provided in main memory. Virtual memory sys-            using open, text-based standards that enable components
      tems help remove much of the burden of memory man-               written in different languages and on different platforms
      agement from programmers, freeing them to concentrate            to communicate. They are ready-to-use pieces of software
      on application development.                                      on the Internet.

VM operating system—One of the first virtual machine oper-         World Wide Web (WWW)-Collection of hyperlinked docu-
   ating systems; developed at IBM in the 1960s and still              ments accessible via the Internet using the Hypertext
   used widely today; its latest version is the z/VM.                  Transfer Protocol (HTTP). Web documents are typically
                                                                       written in languages such as Hypertext Markup Language
Web services—Set of services and related standards that can            (HTML) and Extensible Markup Language (XML).
   allow any two computer applications to communicate and
   exchange data over the Internet. Web services operate



Exercises
1.1 Distinguish between multiprogramming and multipro-             1.7 How has distributed computing affected operating sys-
cessing. What were the key motivations for the development of      tem design?
each?                                                              1.8 What are the advantages and disadvantages of commu-
1.2 Briefly discuss the significance of each of the following      nication between computers?
systems mentioned in this chapter:                                 1.9 Define, compare, and contrast each of the following
       a. MS-DOS                                                   terms:
       b. CTSS                                                          a. online
       c. Multics                                                        b. real time
       d. OS/360                                                         c. interactive computing
       e. TSS                                                            d. timesharing
       f. UNIX                                                     1.10 How do middleware and Web services promote interop-
       g. Macintosh                                                erability?
1.3    What developments made personal computing feasible?         1.11 Evaluate monolithic, layered and microkernel architec-
                                                                   tures according to
1.4    Why is it impractical to use a virtual machine for a hard
real-time system?                                                       a. efficiency.
1.5 What role did the development of graphical user inter-              b. robustness.
faces play in the personal computer revolution?                          c. extensibility.
1.6 The GNU Public License (GPL) promotes software that                  d. security.
is free, as in "freedom." How does the GPL provide such free-
dom?



Suggested Projects
1.12 Prepare a research paper on the Linux operating system.       as in both "freedom" and "price." How do the GPL and similar
In what ways does it support Stallman's "free as in freedom"       licenses promote open-source software?
doctrine for software? In what ways does Linux conflict with
                                                                   1.15 Prepare a research paper on the evolution of operating
this philosophy?
                                                                   systems. Be sure to mention the key hardware, software and
1.13 Prepare a research paper on the Internet and how its          communications technologies that encouraged each new oper-
pervasive use affects operating system design.                     ating system innovation.
1.14 Prepare a research paper on the open-source software          1.16 Prepare a research paper on the future of operating sys-
movement. Discuss whether all open-source software is free,        tems.

<!-- pág. 107 -->

                                                                                                 Recommended Reading 47
1.17 Prepare a research paper giving a thorough taxonomy of         1.26 Prepare a research paper discussing the design of mas-
past and present operating systems.                                 sively parallel systems. Be sure to compare large-scale multi-
1.18 Prepare a research paper on Web services. Discuss the          processor systems (e.g., the Hewlitt-Packard Superdome
key technologies on which the Web services infrastructure is        supercomputer, which contains up to 64 processors;
being built. How will the availability of Web services affect       www.hp.com/productsl/servers/scalableservers/
applications development?                                           superdome/) to clustered systems and server farms that con-
                                                                    tain hundreds or thousands of low-end computers that cooper-
1.19 Prepare a research paper on business-critical and mission-     ate to perform common tasks (see, for example,
critical applications. Discuss the key attributes of hardware,      www.beowulf.org). Use www.top500.org, a listing of the
communications software and operating systems that are essen-       world's most powerful supercomputers, to determine the type
tial to building systems to support these types of applications.    of tasks that each of these massively parallel systems performs.
1.20 Prepare a research paper on virtual machine systems. Be        1.27 What trends are leading the way to dramatic increases in
sure to investigate IBM's VM operating system and Sun's Java        parallel computation? What challenges must be addressed by
Virtual Machine (JVM).                                              hardware designers and software designers before parallel
1.21 Prepare a research paper on operating systems and the          computation will become widely used?
law. Survey legislation related to operating systems.               1.28 Prepare a research paper that compares MIT's Exokernel
1.22 Prepare a research paper on the impact of operating sys-       (www.pdos.lcs.mit.edu/exo.html) and CMU's Mach micro-
tems on business and the economy.                                   kernel        (www-2.cs.emu.edu/afs/cs.emu.edu/project/
                                                                    mach/public/www/mach.html) research operating systems.119
1.23 Prepare a research paper on operating systems and secu-        What is the primary focus of each operating system? Be sure to
rity and privacy. Be sure to consider the issues of worms and       mention how the researchers organized components such as
viruses.                                                            memory management, disk scheduling and process manage-
1.24 Prepare a research paper on the ethical issues with            ment. Has either or both of these systems become commercially
which operating systems designers must be concerned. Be sure        successful? Has either or both of these systems influenced the
to deal with issues such as the use of computer systems in war-     designs of commercially successful operating systems?
fare and in life-threatening situations, viruses and worms, and
                                                                    1.29 Why have UNIX and UNIX-based systems continued to
other important topics you discover as you do your research
                                                                    be popular in recent decades? How does Linux impact the
for your paper.
                                                                    future of UNIX systems?
1.25 List several trends leading the way to future operating
systems designs. How will each affect the nature of future sys-
tems?



Recommended Reading
This section will be used throughout the book to provide the        largest IEEE society, publishes several journals related to com-
reader with references to seminal books and papers and current      puter science, including the popular IEEE Computer (www.com-
research on the topic of each chapter. Many of the papers that      puter.org/computer/). The reader is encouraged to join the
are cited in each chapter can be found in one of several journals   ACM, SIGOPS and the IEEE Computer Society. In the Web
associated with either the Association of Computing Machinery       Resources section, we have listed several links to sites that
(ACM) or the Institute of Electrical and Electronics Engineers      recount the history of operating systems. An enlightening
(IEEE). Communications of the ACM is the ACM's flagship             account of the design and development of the OS/360 operating
journal, containing research papers, editorials and features        system can be found in Frederick P. Brooks, Jr.'s The Mythical
about contemporary topics in computer science. The ACM also         Man-Month.120 Per Brinch Hansen's Classic Operating Systems:
sponsors several special-interest groups (SIGs), each dedicated     From Batch to Distributed Systems provides an anthology of
to particular fields of computer science. SIGOPS, the SIG for       papers describing the design and development of innovative and
the field of operating systems (www.acm.org/sigops/), holds         pioneering operating systems.121 The bibliography for this chap-
annual conferences and publishes the Operating Systems              ter is located on our Web site at www.deitel.com/books/
Review.The IEEE Computer Society (www.computer.org), the            os3e/Bibliography.pdf.

<!-- pág. 108 -->

48 Introduction to Operating Systems

Works Cited
 1. "Evolution of the Intel Microprocessor: 1971-2007,"                                     21. Berlind, D., "Mainframe Linux Advocates Explain It All,"
    <www.berghell .com/whitepapers/Evolution%20                                                 ZDNet, April 12, 2002, <techupdate.zdnet.com/techupdate/
    of%20Intel%20Microprocessors%201971%202007.pdf>.                                            stories/main/0,14179,2860720,00.html>.
 2. "Top 500 List for November 2002," <www.top500.org/list/                                 22. Frenkel, K., "Allan L. Scherr: Big Blue's Time-Sharing Pioneer,"
    2002/ll/>.                                                                                  Communications of the ACM, Vol. 30, No. 10, October 1987, pp.
                                                                                                824-829.
 3. Weizer, N., "A History of Operating Systems," Datamation, Janu-
    ary 1981, pp. 119-126.                                                                  23. Harrison, T, et al, "Evolution of Small Real-Time IBM Com-
                                                                                                puter Systems," IBM Journal of Research and Development, Vol.
 4. Goldstein, H., The Computer from Pascal to von Neumann, Prin-                               25, No. 5, September 1981, pp. 441-451.
    ceton: Princeton University Press, 1972.
                                                                                            24. Corbato, E, et al., The Compatible Time-Sharing System, A Pro-
 5. Stern, N., From ENIAC to UNIVAC: An Appraisal of the Eckert-                                grammer's Guide, Cambridge: MIT Press, 1964.
    Mauchly Computers Bedford: Digital Press, 1981.
                                                                                            25. Crisman, P., et al., eds., The Compatible Time-Sharing System,
 6. Bashe, C, et al., IBM's Early Computers (Cambridge: MIT Press,                              Cambridge: MIT Press, 1964.
    1986).                                                                                  26. Lett, A., and W. Konigsford, "TSS/360: A Time-Shared Operating
 7. Weizer, N., "A History of Operating Systems," Datamation, Janu-                             System," Proceedings of the Fall Joint Computer Conference,
    ary 1981, pp. 119-126.                                                                      AFIPS, Vol. 33, Part 1,1968, pp. 15-28.
 8. Grosch, H, "The Way It Was in 1957," Datamation, September                              27. Bensoussan, A.; C. Clingen; and R. Daley, "The Multics Virtual
    1977.                                                                                       Memory: Concepts and Designs," Communications of the ACM,
                                                                                                Vol. 15, No. 5, May 1972, pp. 308-318.
 9. Denning, P., "Virtual Memory," ACM CSUR, Vol. 2, No. 3, Sep-
                                                                                            28. Creasy, R., "The Origins of the VM/370 Time-Sharing System,"
    tember 1970, pp. 153-189.
                                                                                                IBM Journal of Research and Development, Vol. 25, No. 5, pp.
10. Codd, E.; E. Lowry; E. McDonough; and C. Scalzi, "Multipro-                                 483^190.
    gramming STRETCH: Feasibility Considerations," Communica-
                                                                                            29. Conrow, K., "The CMS Cookbook," Computing and Networking
    tions of the ACM, Vol. 2,1959, pp. 13-17.
                                                                                                Services, Kansas State University, June 29, 1994, < w w w . k s u . e d u /
11. Critchlow, A., "Generalized Multiprocessor and Multiprogram-                                cns/pubs/cms/cms-cook/cms-cook.pdf>.
    ming Systems," Proc. AFIPS, FJCQ Vol. 24,1963, pp. 107-125.                             30. Denning, P., "Virtual Memory," ACM Computing Surveys, Vol. 2,
12. Belady, L., et al., "The IBM History of Memory Management                                   No. 3, September 1970, pp. 153-189.
    Technology," IBM Journal of Research and Development, Vol. 25,                          31. Parmelee, R., et al., "Virtual Storage and Virtual Machine Con-
    No. 5, September 1981, pp. 491-503.                                                         cepts," IBM Systems Journal, Vol. 11, No. 2,1972.
13. "The Evolution of S/390," < w w w - t i . i n f o r m a t i k . u n i - t u e b i n -   32. Ritchie, D, "Dennis M. Ritchie," <cm.ben-labs.com/cm/cs/
    gen.de/os390/arch/history.pdf>.                                                             who/dmr/bigbio1st.html>.
14. Amdahl, G.; G. Blaauw; and F. Brooks, "Architecture of the IBM                          33. Bell Labs Lucent Technologies, "Ken Thompson," 2002,
    System/360," IBM Journal of Research and Development, Vol. 8,                               <www.bell-1abs.com/history/unix/thompsonbio.html>.
    No. 2, April 1964, pp. 87-101.                                                          34. Mackenzie, R., "A Brief History of UNIX," <www.Stan¬
15. Weizer, N, "A History of Operating Systems," Datamation, Janu-                              ford.edu/~rachelm/cslu-197/unix.html>.
    ary 1981, pp. 119-126.                                                                  35. Cook, D; J. Urban, and S. Hamilton, "UNIX and Beyond: An
                                                                                                Interview with Ken Thompson," Computer, May 1999, pp. 58-64.
16. Evans, B., "System/360: A Retrospective View," Annals of the
    History of Computing, Vol. 8, No. 2, April 1986, pp. 155-179.                           36. Cook, D.; J. Urban, and S. Hamilton, "UNIX and Beyond: An
                                                                                                Interview with Ken Thompson," Computer, May 1999, pp. 58-64.
17. Mealy, G; B. Witt; and W. Clark, "The Functional Structure of
    OS/360," IBM Systems Journal, Vol. 5, No. 1,1966, pp. 3-51.                             37. Bell Labs Lucent Technologies, "Ken Thompson," 2002,
                                                                                                <www.bel1-1abs.com/history/unix/thompsonbio.html>.
18. Case, R., and A. Padeges, "Architecture of the IBM System/370,"
                                                                                            38. Bell Labs Lucent Technologies, "Dennis Ritchie,"                2002,
    Communications of the ACM, Vol. 21, No. 1, January 1978, pp.
                                                                                                <www.bel1-1abs.com/about/history/unix/ritchie-
    73-96.
                                                                                                bio.html>.
19. Gifford, D., and A. Spector, "Case Study: IBM's System/360-370
                                                                                            39. Bell Labs Lucent Technologies, "Dennis Ritchie,"                2002,
    Architecture," Communications of the ACM, Vol. 30, No. 4, April
                                                                                                <www.bel1-labs.com/about/history/unix/ritchie-
    1987, pp. 291-307.
                                                                                                bio.html>.
20. "The Evolution of S/390," < w w w - t i . i n f o r m a t i k . u n i - t u e b i n -   40. Ritchie, D, "Dennis M. Ritchie," <cm.bell-labs.com/cm/cs/
    gen.de/os390/arch/history.pdf>.                                                             who/dmr/bigbiolst.html>.

<!-- pág. 109 -->

                                                                                                                                    Work Cited 49
41- Reagan, P., and D. Cunningham, "Bell Labs Unveils Open                             62. Quittner, X, "Tim    Berners-Lee," March 29,      1999,
    Source Release of Plan 9 Operating System," June 7, 2000,                              <www.time.com/time/time100/scientist/profi1e/berner-
    <www.bell1-1abs.com/news/2000/june/7/2.html>.                                          slee.html>.
42.    Bell Labs, "Vita Nuova Publishes Source Code for Inferno Oper-                  63. Berners-Lee, T, et al, "The World-Wide Web," Communications
      ating System, Moving Network Computing into the 21st Cen-                            of the ACM, Vol. 37, No. 8, August 1994, pp. 76-82.
      tury," <www.cs.bell-1abs.com/inferno/>.                                          64. World Wide Web Consortium, "Longer Bio for Tim Berners-
43    Kildall, G., "CP/M: A Family of 8- and 16-bit Operating Systems,"                    Lee," <www.w3.org/People/Berners-Lee/Longer.html>.
      Byte, Vol. 6, No. 6, June 1981, pp. 216-232.                                     65. Quittner, J., "Tim  Berners-Lee," March     29,   1999,
44. Quarterman, J. S., and J. C. Hoskins, "Notable Computer Net-                           <www.time.com/time/timelOO/scientist/profile/berner-
    works," Communications of the ACM, Vol. 29, No. 10, October                            slee.html>.
    1986, pp. 932-971.                                                                 66. Berners-Lee, T, et al, "The World-Wide Web," Communications
45. Stefik, M., "Strategic Computing at DARPA: Overview and                                of the ACM, Vol. 37, No. 8, August 1994, pp. 76-82.
    Assessment," Communications of the ACM, Vol. 28, No. 7, July                       67. World Wide Web Consortium, "Longer Bio for Tim Berners-
    1985, pp. 690-707.                                                                     Lee," <www.w3.org/People/Berners-Lee/Longer.html>.
46. Comer, D., Internetworking with TCP/IP: Principles, Protocols,                     68. Quittner, J., "Tim  Berners-Lee,"  March    29,   1999,
    and Architecture, Englewood Cliffs, NJ: Prentice Hall, 1988.                           <www.time.com/time/timelOO/scientist/profile/berner-
47. Martin, J., and K. K. Chapman, Local Area Networks: Architec-                          slee.html>.
    tures and Implementations, Englewood Cliffs, NJ: Prentice Hall,                    69. Moore, G, "Cramming More Components onto Integrated Cir-
    1989.                                                                                  cuits," Electronics, Vol. 38, No. 8, April 19,1965.
48. Metcalfe, R., and D. Boggs, "Ethernet: Distributed Packet                          70. "One Trillion-Operations-Per-Second," Intel Press Release,
    Switching for Local Computer Networks," Communications of                              December 17, 1996, <www.intel.com/pressroom/archive/
    the ACM, Vol. 19, No. 7, July 1976.                                                    releases/cnl21796.htm>.
49. Balkovich, E.; S. Lerman; and R. Parmelee, "Computing in                           71. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
    Higher Education: The Athena Experience," Computer, Vol. 18,                           processor Operating Systems," Georgia Institute of Technology,
    No. 11, November 1985, pp. 112-127.                                                    November 5,1993, p. 2.
50. Zmoelnig, Christine, "The Graphical User Interface. Time for a                     72. "Microsoft Timeline," <www.microsoft.com/museum/mustime-
    Paradigm Shift?" August 30, 2001, <www.sensomatic.com/chz/                             line.mspx>.
    gui/history,html>.                                                                 73. Lea, R.; P. Armaral; and C. Jacquemot, "COOL-2: An Object-ori-
51. Engelbart, D., "Who we are. How we think. What we do." June                            ented Support Platform Built Above the CHORUS Micro-ker-
    24,2003,<www.bootstrap.org/index.html>.                                                nel," Proceedings of the International Workshop on Object
                                                                                           Orientation in Operating Systems 1991, October, 1991.
52. Martin, E., "The Context of STARS," Computer, Vol. 16, No. 11,
    November 1983, pp. 14-20.                                                          74. Weiss, A., "The Politics of Free (Software)," netWorker, Septem-
                                                                                           ber 2001, p. 26.
53. Ecklund, J., "Interview with Douglas Engelbart," May 4, 1994,
    <americanhistory.si.edu/csr/comphist/englebar.htm>.                                75. "The GNU       Manifesto,"   <www.delorie.com/gnu/docs/CNU/
                                                                                           CNU>.
54. Stauth, D., "Prominent Oregon State Alum Receives Leading
    Prize for Inventors," April 9, 1997, < o r e g o n s t a t e . e d u / d e p t /   76. Weiss, A., "The Politics of Free (Software)," netWorker, Septem-
    ncs/newsarch/1997/Apri197/engelbart.htm>.                                              ber 2001, p. 27.
55. "Douglas Engelbart Inventor Profile," 2002, <www.invent.org/                       77. de Brouwer, C, eds, "Linus Torvalds," October 19, 2002,
    hall_of_fame/53.html>.                                                                 <www.thocp.net/biographies/torvaldslinus.html>.
56. "Engelbart's Unfinished Revolution," December 9,1998, <stan-                       78. Learmonth, M., "Giving It All Away," May 8,1997, <www.metro-
    ford-online.Stanford.edu/engelbart/>.                                                  active.com/papers/metro/05.08.97/cover/linus-
                                                                                           9719.html>.
57. "Douglas Engelbart Inventor Profile," 2002, <www.invent.org/
    hall_of_fame/53.html>.                                                             79. Torvalds, L., "Linux History," July 31, 1992, <www.li.org/
                                                                                           linuxhistory.php>.
58. World Wide Web Consortium, "Longer Bio for Tim Berners-
                                                                                       80. Free Software Foundation, "GNU General Public License," May
    Lee," <www.w3.org/People/Berners-Lee/Longer.html>.
                                                                                           26,2003, <www.gnu.org/copyleft/gp1.html>.
59. "Engelbart's Unfinished Revolution," December 9,1998, <stan-
                                                                                       81. Torvalds, L., "Linux History," July 31, 1992, <www.li.org/
    ford-online.Stanford.edu/engelbart/>.
                                                                                           linuxhistory.php>.
60. "Douglas Engelbart Inventor Profile," 2002, <www.invent.org/
                                                                                       82. Ghosh, R., "What Motivates Free Software Developers?" 1998,
    hal1_of_fame/53.html>.
                                                                                           <www.firstmonday.dk/issues/issue3_3/torvalds/>.
61. World Wide Web Consortium, "Longer Bio for Tim Berners-
                                                                                       83. Wirzenius, L., "Linux: The Big Picture," April 28, 2003,
    Lee," <www.w3.org/People/Berners-Lee/Longer.html>.

<!-- pág. 110 -->

50 Introduction to Operating Systems
84. Learmonth, M., "Giving It All Away," May 8,1997, <www.metro-       106. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
    active.com/papers/metro/05.08.97/cover/linus-                           processor Operating Systems," Georgia Institute of Technology
    9719.html>.                                                             (GIT-CC-92/0), November 5,1993, p. 4.
85. Wirzenius, L., "Linux: The Big Picture," April 28, 2003,           107. Dijkstra, E. W., "The Structure of the 'THE'-Multiprogramming
    <liw.iki.fi/liw/texts/linux-the-big-picture.html>.                      System," Communications of the ACM', Vol. 11, No. 5, May 1968,
86. "Linux Creator Linus Torvalds Joins OSDL," June 17, 2003,               pp. 341-346.
    <www.osdl.org/newsroom/press_releases/2003/                        108. Karnik, N. M., and A. R. Tripathi, "Trends in Multiprocessor and
     2003_06_17_beaverton.html>.                                            Distributed Operating Systems," Journal of Supercomputing,Vo\.
87. de Brouwer, C, eds, "Linus Torvalds," October 19, 2002,                 9, No. 1/2,1995, pp. 4-5.
    <www.thocp.net/biographies/torvalds_linus.html>.                   109. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
88. Weiss, A., "The Politics of Free (Software)," netWorker, Septem-        processor Operating System Kernels," Georgia Institute of Tech-
    ber 2001, pp. 27-28.                                                    nology (GIT-CC-92/0), November 5,1993, p. 10.
89. Stallman, R.,"A Serious Bio," <www.stallman.org/#serious>.         n o . Miljocic, D S.; F Doughs; Y. Paindaveine; R. Wheeler; and S.
90. Stallman, R., "Overview of the GNU Project," June 7, 2003,               Zhou, "Process Migration," ACM Computing Surveys, Vol. 32,
    <www.gnu.org/gnu/gnu-history.html>.                                      No. 3, September, 2000, p. 263.
91. DiBona, C; S. Ockman; and M. Stone, eds., Open Sources: Voices     i n . Liedtke, J., "Toward Real Microkernels," Communications of the
    from the Open Source Revolution, Boston, MA: O'Reilly, 1999.             ACM, Vol. 39, No. 9, September 1996, p. 75. Camp, T, and G.
92. R. Stallman, "Overview of the GNU Project," June 7, 2003,                Oberhsause, "Microkernels: A Submodule for a Traditional
    <www.gnu.org/gnu/gnu-history.html>.                                      Operating Systems Course," Communications of the ACM, 1995,
                                                                             p. 155.
93. DiBona, C; S. Ockman; and M. Stone, eds., Open Sources: Voices
    from the Open Source Revolution, Boston, MA: O'Reilly, 1999.       112. Liedtke, J., "Toward Real Microkernels," Communications of the
                                                                            ACM, Vol. 39, No. 9, September 1996, p. 75. Camp, T, and G.
94. Stallman, R., "A Serious Bio," <www.stallman.org/#serious>.
                                                                            Oberhsause, "Microkernels: A Submodule for a Traditional
95. "Free Software Foundation," June 12,2002, <www.gnu.org/fsf/             Operating Systems Course," Communications of the ACM, 1995,
    fsf.html>.                                                              p. 155.
96. DiBona, C; S. Ockman; and M. Stone, eds., Open Sources: Voices
                                                                       113. Miljocic, D. S.; F. Doughs; Y. Paindaveine; R. Wheeler; and S.
    from the Open Source Revolution, Boston, MA: O'Reilly, 1999.
                                                                            Zhou, "Process Migration," ACM Computing Surveys, Vol. 32,
97. Leon, M., "Richard Stallman, GNU/Linux," October 6, 2000,               No. 3, September 2000, p. 263.
    <archive.infoworld.com/articles/hn/xml/00/10/09/
                                                                       114. Tanenbaum, A. S., and R. V. Renesse, "Distributed Operating
    001009hnrs.xml>.
                                                                            Systems," Computing Surveys, Vol. 17, No. 4, December 1985, p.
98. Stallman, R., "A Serious Bio," <www.stallman.org/#serious>.             424.
99. Ricciuti, M., "New Windows Could Solve Age Old Format Puz-
                                                                       115. Tanenbaum, A. S., and R. V. Renesse, "Distributed Operating
    zle—at a Price," CNet, March 13, 2002, <news.com.com/2009-
                                                                            Systems," Computing Surveys, Vol. 17, No. 4, December 1985, p.
    1017-857509.html>.
                                                                            424.
100. Thurrott, P., "Windows 'Longhorn' FAQ," Paul Thurrott's Super-
                                                                       116. Blair, G. S.; J. Malik; J. R. Nicol; and J. Walpole, "Design Issues
     Site for Windows, modified October 6, 2003, <www.winsuper-
                                                                             for the COSMOS Distributed Operating System," Proceedings
     site.com/faq/Ionghorn.asp>.
                                                                            from the 1988 ACM SIGOPS European Workshop, 1988, pp. 1-2.
101. Cannon, M. D., et al., "A Virtual Machine Emulator for Perfor-
                                                                       117. "MIT LCS Parallel and Distributed Operating Systems," June 2,
     mance Evaluation," Communications of the ACM, Vol. 23, No. 2,
                                                                            2003,<www.pdos.1cs.mit.edu>.
     February 1980, p. 72.
102. Cannon, M. D., et. al., "A Virtual Machine Emulator for Perfor-   118. "Amoeba WWW Home Page," April 1998, <www.cs.vu.nl/pub/
     mance Evaluation," Communications of the ACM, Vol. 23, No. 2,          amoeba/>.
     February 1980, p. 72.                                             119. Engler, D. R.; M. F Kaashoek; and J. O'Toole, Jr., "Exokernel:
103. "VMware: Simplifying Computer Infrastructure and Expanding             An Operating System Architecture for Application-Level
     Possibilities", <www.vmware.com/company/>.                             Resource Management," SIGOPS '95, December 1995, p. 252.
104. Cannon, M. D., et. al., "A Virtual Machine Emulator for Perfor-   120. Brooks, Jr., F P., The Mythical Man-Month: Essays on Software
     mance Evaluation," Communications of the ACM, Vol. 23, No. 2,          Engineering, Anniversary edition, Reading, MA: Addison-Wes-
     February 1980, p. 73.                                                  ley, 1995.
105. "Shell," whatis.com, <www.searchsolaris.techtarget.com/           121. Brinch Hansen, P., Classic Operating Systems: From Batch to Dis-
     sDefinition/0,,sid12_gci212978,00.html>.                               tributed Systems, Springer-Verlag, 2001.

<!-- pág. 111 -->

"Now! Now!" cried tke Queen. "Faster! Faster!"
      —Lewis Carroll—


To conquer without risk is to triumph witout glory.
      —Pierre Corneille —


Our life is frittered away by detail ...Simplify, simplify.
      —Henry Thoreau—


O holy simplicity!
      —John Huss —
      (Last words, at the stake)

