# Part 3 - Real and Virtual Memory / Chapter 9 - Real Memory Organization and Management

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 430–467 (numeración del PDF)

<!-- pág. 430 -->

Real and Virtual
   Memory
   Lead me from the unreal to the real!
         —The Upanishads —




 Part 3

<!-- pág. 431 -->

Memory is second only to processors in importance
and in the intensity with which it is managed by
the operating system. The next three chapters fol-
low the elegant evolution in memory organiza-
tions from the earliest simple single-user, real
memory systems to today's popular virtual mem-
ory multiprogramming systems. You will learn the
motivation for virtual memory and you will focus
on schemes for implementing it—paging, segmen-
tation and a combination of the two. You will
study the three key types of memory management
strategies: fetch (both demand and anticipatory),
placement and replacement. You will see that a
crucial factor for performance in virtual memory
systems is an effective page replacement strategy
when available memory becomes scarce, and you
will learn a variety of these strategies and Den-
ning's working set model.




         The fancy is indeed no other than a mode of memory
            emancipated from the order of time and space.
                  — Samuel Taylor Coleridge—

<!-- pág. 432 -->

Nothing ever becomes real till it is experienced—even a proverb is no proverb to yon till
your life has illustrated it
       —John Keats—

Let him in whose ears the low-voiced
Best is killed by the clash of the First,
Who holds that if way to the
Better there be, it exacts a full look at the worst, ...
       —Thomas Hardy—


Remove not the landmark on the boundary of the fields.
       —Amenemope—

Protection is not a principle, but an expedient.
       —Benjamin Disraeli—

A great memory does not make a philosopher, any more than a dictionary can be called a
grammar.
       —John Henry Cardinal Newman—

<!-- pág. 433 -->

Chapter 9




Real Memory
   Organization and
          Management
  Objectives
  After reading this chapter, you should understand:
  • the need for real (also called physical) memory management.
  • the memory hierarchy.
  • contiguous and noncontiguous memory allocation.
  • fixed- and variable-partition multiprogramming.
  • memory swapping.
  • memory piacement strategies.

<!-- pág. 434 -->

                               Chapter Outline

                      9.1                                             9.7.1    Overlays
                 Introduction                            9.7.2 Protection in a Single-User System
                                                           9.7.3 Single-Stream Batch Processing
                  9.2                                     Operating Systems Thinking: Change
                                                            Is the Rule Rather Than the Exception
            Memory Organization
      Operating Systems Thinking: There
      Are No upper limits to Processing Power,
          Memory, Storage and Bandwidth                                 9.8
                                                                  Fixed-Partition
                  9.3                                            Multiprogramming
           Memory Management                                Anecdote: Compartmentalization
                                                          Operating Systems Thinking: Spatial
                   9.4                                         Resources and Fragmentation
             Memory Hierarchy

            9.5                                                         9.9
 Memory Management Strategies                                    Variable-Partition
                                                                 Multiprogramming
                                                           9. 9.1 Variable-Partition Characteristics
                  9.6
                                                            9. 9.2 Memory Placement Strategies
      Contiguous vs. Noncontiguous
          Memory Allocation

                   9.7                                                 9.10
       Single-User Contiguous                                 Multiprogramming with
        Memory Allocation                                      Memory Swapping




          Web Resources | Summary | Key Terms | Exercises | Recømmended Reading | Works Cited




378

<!-- pág. 435 -->

                                                                                               9.1 Introduction 379

        9.1 Introduction
The organization         and management of the real memory (also called main memory,
physical memory or primary memory) of a computer system has been a major influ-
ence on operating systems design.1 Secondary storage—most commonly disk and
tape - provides massive, inexpensive capacity for the abundance of programs and
     . data that must be kept readily available for processing. It is, however, slow and not
directly accessible to processors. To be run or referenced directly, programs and
data must be in main memory.
In this and the next two chapters, we discuss many popular schemes for orga-
nizing and managing a computer's memory. This chapter deals with real memory;
Chapters 10 and 11 discuss virtual memory. We present the schemes approximately
as they evolved historically. Most of today's systems are virtual memory systems, so
this chapter is primarily of historical value. However, even in virtual memory sys-
tems, the operating system must manage real memory. Further, some systems, such
as certain types of real-time and embedded systems, cannot afford the overhead of
   virtual memory—so to them, real memory management remains crucial. Many of
the concepts presented in this chapter lay the groundwork for the discussion of vir-
tual memory in the next two chapters.


 9.2 Memory Organization
    Historically, main memory has been viewed as a relatively expensive resource. As
such, systems designers have attempted to optimize its use. Although its cost has
  declined phenomenally over the decades (roughly according to Moore's Law, as
 discussed in Chapter 2; see the Operating Systems Thinking feature, There Are No
  Upper Limits to Processing Power, Memory, Storage and Bandwidth), main mem-
ory is still relatively expensive compared to secondary storage. Also, today's operat-
ing systems and applications require ever more substantial quantities (Fig. 9.1). For
example, Microsoft recommends 256MB of main memory to efficiently run Win-
dows XP Professional.
      We (as operating system designers) view main memory in terms of memory
 organization. Do we place only a single process in main memory, or do we place
several processes in memory at once (i.e., do we implement multiprogramming)? If
main memory contains several processes simultaneously, do we give each the same
amount of space, or do we divide main memory into portions (called partitions) of
  different sizes? Do define partitions rigidly for extended periods, or dynamically,
  allowing the system to adapt quickly to changes in the needs of processes? Do we
require that processes run in a specific partition, or anywhere they will fit? Do we
 require the system to place each process in one contiguous block of memory loca-
tions, or allow it to divide processes into separate blocks and place them in any
 available slots in main memory? Systems have been based on each of these
schemes. This chapter discusses how each scheme is implemented.

<!-- pág. 436 -->

380 Real Memory Organization and Management

                               Self Review
                               1. Why is it generally inefficient to allow only one process to be in memory at a time?
                               2. What would happen if a system allowed many processes to be placed in main memory, but
                                  did not divide memory into partitions?
                              Ans: 1) If the single process blocks for I/O, no other processes can use the processor 2) The
                              processes would share all their memory. Any malfunctioning or malicious process could dam-
                              age any or all of the other processes.



                               9.3 Memort Management
                               Regardless of which memory organization scheme we adopt for a particular system,
                               we must decide which strategies to use to obtain optimal memory performance.2
                               Memory management strategies determine how a particular memory organization
                               performs under various loads. Memory management is typically performed by both
                               software and special-purpose hardware.




             Operating Systems Thinking
    There Are No Upper limits to Processing Power, Memory,
    Storage and Bandwith
    Computing is indeed a dynamic        which they progress; these trends          few decades have had a profound
    field. Processors keep getting       have an enormous impact on                 impact on the requirements for
    faster (and cheaper per executed     what capabilities operating sys-           building contemporary operating
    instruction), main memories keep     tems need to have. Early operat-           systems, as you will see when you
    getting larger (and cheaper per      ing systems did not provide                read the detailed case studies on
    byte), secondary storage media       capabilities to support computer           the Linux and Windows XP oper-
    keep getting larger (and cheaper     graphics, graphical user inter-            ating systems in Chapters 20 and
    per bit), and communications         faces, networking, distributed             21. All of these capabilities have
    bandwidths keep getting wider        computing, Web services, multi-            been made possible by improving
    (and cheaper per bit transferred)—   processing, multithreading, mas-           processing power, storage and
    all kinds of new devices are being   sive parallelism, massive virtual          bandwidth. These improvements
    created to interface with, or be     memories, database systems, mul-           will continue, eventually enabling
    integrated into, computers.          timedia, accessibility for people          even more sophisticated applica-
         Operating systems design-       w i t h disabilities, sophisticated        tions and the operating systems
    ers must stay apprised of these      security capabilities and so on. All       capabilities to support them.
    trends and the relative rates at     of these innovations over the last

<!-- pág. 437 -->

                                                                                      9.3 Memory Management 381

                                                 Minimum
                                                 Memory              Recommended
 Operating System             Release Date       Requirement         Memory
 Windows 1.0                  November 1985       256KB
  Windows 2.03                November 1987       320KB
 Windows 3.0                  March 1990          896KB               1MB
  Winndows 3.1                April 1992          2.6MB              4MB
  Windows 95                  August 1995         8MB                 16MB
  Windows NT 4.0              August 1996         32MB               96MB
 Windows 98                   June 1998           24MB               64MB
 Windows ME                   September 2000      32MB                128MB
 Windows 2000 Professional    February 2000       64MB                128MB
  Windows XP Home             October 2001        64MB                128MB
 Windows XP Professional      October 2001        128MB              256MB

Figure 9.1 | Microsoft Windows operating system memory requirements.3, 4, 5
      The memory manager is an operating system component concerned with the
system's memory organization scheme and memory management strategies. The
memory manager determines how available memory space is allocated to processes
 and how to respond to changes in a process's memory usage. It also interacts with
special-purpose memory management hardware (if any is available) to improve
performance. In this and the next two chapters, we describe several different mem­
ory management and organization strategies.
      Each memory management strategy differs in how it answers certain ques­
tions. When does the strategy retrieve a new program and its data to place in mem­
 ory? Does the strategy retrieve the program and its data when the system
specifically asks for it, or does the strategy attempt to anticipate the system's
requests? Where in main memory does the strategy place the next program to be
run and that program's data? Does it minimize wasted space by packing programs
and data as tightly as possible into available memory areas, or does it minimize exe­
cution time, placing programs and data as quickly as possible?
      If a new program or new data must be placed in main memory and if main
memory is currently full, which programs or data already in memory does the strat­
egy replace? Should it replace those that are oldest, those that are used least fre­
quently, or those that were used least recently? Systems have been implemented
using these and other memory management strategies.

Self Review
1. When is it appropriate for a memory manager to minimize wasted memory space?
2. Why should memory management organizations and strategies be as transparent as possi­
   ble to processes?

<!-- pág. 438 -->

382 Real Memory Organization and Management

                          Ans: 1) When memory is more expensive than the processor-time overhead incurred by
                          placing programs as tightly as possible into main memory. Also, when the system needs to
                          keep the largest possible contiguous memory region available for large incoming programs
                          and data. 2) Memory management transparency improves application portability and facili-
                          tates development, because the programmer is not concerned with memory management
                          strategies. It also allows memory management strategies to be changed without rewriting
                          applications.


                           9.4 Memory Hierarchy
                          In the 1950s and 1960s, main memory was extremely expensive —as much as one
                          dollar per bit! To put that in perspective, Windows XP Professional's recommended
                          256MB of memory would have cost over 2 billion dollars! Designers made careful
                          decisions about how much main memory to place in a computer system. An instal-
                          lation could buy no more than it could afford but had to buy enough to support the
                          operating system and a given number of processes. The goal was to buy the mini-
                          mum amount that could adequately support the anticipated workloads within the
                          economic constraints of the installation.
                                Programs and data must be in main memory before the system can execute or
                          reference them. Those that the system does not need immediately may be kept in sec-
                          ondary storage until needed, then brought into main memory for execution or refer
                          ence. Secondary storage media, such as tape or disk, are generally far less costly per
                          bit than main memory and have much greater capacity. However, main memory may
                          generally be accessed much faster than secondary storage—in today's systems, disk
                          data transfer may be six orders of magnitude slower than that of main memory.6, 7
                                The memory hierarchy contains levels characterized by the speed and cost of
                          memory in each level. Systems move programs and data back and forth between
                          the various levels.8, 9 This shuttling can consume system resources, such as processor
                          time, that could otherwise be put to productive use. To increase efficiency, current
                          systems include hardware units called memory controllers that perform memory
                          transfer operations with virtually no computational overhead. As a result, systems
                          that exploit the memory hierarchy benefit from lower costs and enlarged capacity.
                                In the 1960s, it became clear that the memory hierarchy could achieve dramatic
                          improvements in performance and utilization by adding one higher level.10, 11 This
                          additional level, called cache, is much faster than main memory and is typically
                          located on each processor in today's systems.12, 13 A processor may reference pro-
                          grams and data directly from its cache. Cache memory is extremely expensive com-
                          pared to main memory, and therefore only relatively small caches are used. Figure 9.2
                          shows the relationship between cache, primary memory and secondary storage.
                                Cache memory imposes one more level of data transfer on the system. Pro-
                          grams in main memory are transferred to the cache before being executed—execut-
                          ing programs from cache is much faster than from main memory. Because many
                          processes that access data and instructions once are likely to access them again in
                          the future (a phenomenon known as temporal locality), even a relatively small

<!-- pág. 439 -->

                                                                               9.5 Memory Management Strategies   383




 Figure 9.2 | Hierarchical memory organization
cache can significantly increase performance (when compared to running programs
  in a system without cache). Some systems use several levels of cache.

Self Review
1. (T/F) The low cost of main memory coupled with the increase in memory capacity in most
   systems has obviated the need for memory management strategies.
2. How does a program executing a loop benefit from cache memory?
Ans: 1) False. Despite the low cost and high capacity of main memory, there continue to be
  environments that consume all available memory. Also, memory management strategies
should be applied to cache, which consists of more expensive, low-capacity memory. In either
case, when memory becomes full, a system must implement memory management strategies
to obtain the best possible use of memory. 2) A program executing a loop repeatedly exe-
cutes the same set of instructions and may also reference the same data. If these instructions
and data fit in the cache, the processor can access those instructions and data more quickly
 from cache than from main memory, leading to increased performance.


9.5 Memory Management Strategies
Memory management strategies are designed to obtain the best possible use of
main memory. They are divided into:
      1. Fetch strategies
     2. Placement strategies
     3. Replacement strategies
      Fetch strategies determine when to move the next piece of a program or data
   to main memory from secondary storage. We divide them into two types—demand

<!-- pág. 440 -->

384 Real Memory Organization and Management
                          fetch strategies and anticipatory fetch strategies. For many years, the conventional
                          wisdom has been to employ a demand fetch strategy, in which the system places the
                          next piece of program or data in main memory when a running program references
                          it. Designers believed that because we cannot in general predict the paths of execu-
                          tion that programs will take, the overhead involved in making guesses would far
                          exceed expected benefits. Today, however, many systems have increased perfor-
                          mance by employing anticipatory fetch strategies, which attempt to load a piece of
                          program or data into memory before it is referenced.
                                Placement strategies determine where in main memory the system should
                          place incoming program or data pieces.14-15 In this chapter we consider the first-fit,
                          best-fit, and worst-fit memory placement strategies. When we discuss paged virtual
                          memory systems in Chapters 10 and 11, we will see that program and data can be
                          divided into fixed-size pieces called pages that can be placed in any available "page
                          frame." In these types of systems, placement strategies are trivial.
                                When memory is too full to accommodate a new program, the system must
                          remove some (or all) of a program or data that currently resides in memory. The
                          system's replacement strategy determines which piece to remove.
                                Self Review


                          1. Is high resource utilization or low overhead more important to a placement strategy?
                          2. Name the two types of fetch strategies and describe when each one might be more appro-
                             priate than the other.
                          Ans: 1) The answer depends on system objectives and the relative costs of resources and over-
                          head. In general, the operating system designer must balance overhead with high memory utili-
                          zation to meet the system's goals. 2) The two types are demand fetch and anticipator fetch. If
                          the system cannot predict future memory usage with accuracy, then the lower overhead of
                          demand fetching results in higher performance and utilization (because the system does not
                          load from disk information that will not be referenced). However, if programs exhibit predict
                          able behavior, anticipatory fetch strategies can improve performance by ensuring that pieces of
                          programs or data are located in memory before processes reference them.
                          9.6 Contiguous vs. Noncontigues Memory Allocation


                          To execute a program in early computer systems, the system operator or the operat-
                          ing system had to find enough contiguous main memory to accommodate the entire
                          program. If the program was larger than the available memory, the system could
                          not execute it. In this chapter, we discuss the early use of this method, known as
                          contiguous memory allocation, and some problems it entailed. When researchers
                          attempted to solve these problems, it became clear that systems might benefit from
                          noncontiguous memory allocation.16
                                In noncontiguous memory allocation, a program is divided into blocks or seg-
                          ments that the system may place in nonadjacent slots in main memory. This allows
                          making use of holes (unused gaps) in memory that would be too small to hold
                          whole programs. Although the operating system thereby incurs more overhead, this

<!-- pág. 441 -->

                                                                  9.7 Single-User Contiguou Memory Allocation 385

         can be certified by the increase in the level of multiprogramming (i.e., the number
         of processes that can occupy main memory at once). In this chapter we present the
   techniques that led to noncontiguous physical memory allocation. In the next two
        chapters we discuss the virtual memory organization techniques of paging and seg-
    mentation, each of which requires noncontiguous memory allocation.

 Self Review
  1. When is noncontiguous preferable to contiguous memory allocation?
  2. What sort of overhead might be involved in a noncontiguous memory allocation scheme?
Ans: 1) When available memory contains no area large enough to hold the incoming pro-
gram is one contiguous piece, but sufficient smaller pieces of memory are available that, in
total, are large enough. 2) There would be overhead in keeping track of available blocks and
blocks that belong to separate processes, and where those blocks reside in memory.


 9.7 Single-User Contiguous Memory Allocation
Early computer systems allowed only one person at a time to use a machine. All the
 machine's resources were dedicated to that user. Billing was straightforward—the
user was charged for all the resources whether or not the user's job required them. In
fact, the normal billing mechanisms were based on wall clock time. The system opera-
tor gave the user the machine for some time interval and charged a flat hourly rate.
     Figure 9.3 illustrates the memory organization for a typical single-user contig-
uous memory allocation system. Originally, there were no operating systems—the
programmer wrote all the code necessary to implement a particular application,
including the highly detailed machine-level input/output instructions. Soon, system




 Figure 9.3 | Single-user contiguous memory allocation.

<!-- pág. 442 -->

386 Real Memory Organization and Management

                           designers consolidated input/output coding that implemented basic functions into
                           an input/output control system (IOCS). 17 The programmer called IOCS routines to
                           do the work instead of having to "reinvent the wheel" for each program. The IOCS
                           greatly simplified and expedited the coding process. The implementation of input/
                           output control systems may have been the beginning of today's concept of operat-
                           ing systems.


                           9.7.1 Overlays
                          We have discussed how contiguous memory allocation limited the size of programs
                          that could execute on a system. One way in which a software designer could over-
                          come the memory limitation was to create overlays, which allowed the system to
                          execute programs larger than main memory. Figure 9.4 illustrates a typical overlay.
                          The programmer divides the program into logical sections. When the program does
                          not need the memory for one section, the system can replace some or all of it with
                          the memory for a needed section.18
                                Overlays enable programmers to "extend" main memory. However, manual
                          overlay requires careful and time-consuming planning, and the programmer often




                          Figure 9.4 | Overlay structure.

<!-- pág. 443 -->

                                                                  9.7 Single-User Contiguous Memory Allocation 387

    must have detailed knowledge of the system's memory organization. A program
    with a sophisticated overlay structure can be difficult to modify. Indeed, as pro-
    grams grew in complexity, by some estimates as much as 40 percent of program-
    ming expenes were for organizing overlays.19 It became clear that the operating
    system needed to insulate the programmer from complex memory management
    tasks such as overlays. As we will see in subsequent chapters, virtual memory sys-
    tems obviate the need for programmer-controlled overlays, in the same way that
    the IOCS freed the programmer from repetitive, low-level I/O manipulation.

   Self review
    1. How did the IOCS facilitate program development?
    2. Describe the costs and benefits of overlays.
  Ans: 1) Programmers were able to perform I/O without themselves having to write the low-
  level commands that were now incorporated into the IOCS, which all programmers could use
  instead of having to "reinvent the wheel." 2) Overlays enabled programmers to write pro-
   grams larger than real memory, but managing these overlays increased program complexity,
   which increased the size of programs and the cost of software development.

  9.7.2 Protection in a Single-User System
    In single-user    contiguous memory allocation systems, the question of protection is
    simple. How should the operating system be protected from destruction by the
    user's program?
          A process can interfere with the operating system's memory—either inten-
tionally or inadvertently—by replacing some or all of its memory contents with
other data. If it destroys the operating system, then the process cannot proceed. If
the process attempts to access memory occupied by the operating system, the user
can detect the problem, terminate execution, possibly fix the problem and relaunch
    the program.
          Without protection, the process may alter the operating system in a more sub-
the, nonfatal manner. For example, suppose the process accidentally changes certain
     input/output routines, causing the system to truncate all output records. The process
    could still run, but the results would be corrupted. If the user does not examine the
    results until the process completes, then the machine resource has been wasted.
 Worse yet, the damage to the operating system might cause outputs to be produced
   that the user cannot easily determine to be inaccurate. Clearly, the operating system
must be protected from processes.
          Protection in single-user contiguous memory allocation systems can be imple-
 mented with a single boundary register built into the processor, as in Fig. 9.5, and
 which can be modified only by a privileged instruction. The boundary register con-
   tains the memory address at which the user's program begins. Each time a process
  references a memory address, the system determines if the request is for an address
   greater than or equal to that stored in the boundary register. If so, the system ser­
   ­­­­­ the memory request. If not, then the program is trying to access the operating

<!-- pág. 444 -->

388   Real   Memory   Organization and Management




                              Figure 9.5 | Memory protection with single-user contiguous memory allocation.

                              system. The system intercepts the request and terminates the process with an
                              appropriate error message. The hardware that checks boundary addresses operates
                              quickly to avoid slowing instruction execution.
                                    Of course, the process must access the operating system from time to time to
                              obtain services such as input/output. Several system calls (also called supervisor calls)
                              are provided that may be used to request services from the operating system. When a
                              process issues a system call (e.g., to write data to a disk), the system detects the call
                              and switches from the user mode to the kernel mode (or executive mode) of execu-
                              tion. In kernel mode, the processor may execute operating system instructions and
                              access data to perform tasks on behalf of the process. After the system has performed
                              the requested task, it switches back to user mode and returns control to the process.20
                                    The single boundary register represents a simple protection mechanism. As
                              operating systems have become more complex, designers have implemented more
                              sophisticated mechanisms to protect the operating system from processes and to
                              protect processes from one another. We discuss these mechanisms in detail later.

                              Self Review
                              1. Why is a single boundary register insufficient for protection in a multiuser system?
                              2. Why are system calls necessary for an operating system?
                              Ans: 1) The single boundary would protect the operating system from being corruted by
                              user processes, but not protect processes from corrupting each other. 2) System calls enable
                              processes to request services from the operating system while ensuring that the operating
                              system is protected from its processes.

<!-- pág. 445 -->

                                                               9.7 Single-User Contiguous Memory Allocation 389

    9.7.3 Single-Stream Batch Processing
Early single-user real memory systems were dedicated to one job for more than the
job's execution time. Jobs generally required considerable setup time during which
the operating system was loaded, tapes and disk packs were mounted, appropriate
     formsplaced in the printer, time cards "punched in," and so on. When jobs com-
    pleted, they required considerable teardown time as tapes and disk packs were
      removed, forms removed, time cards "punched out." During job setup and tear-
down the computer sat idle.
    Designers realized that if they could automate various aspects of job-to-job
 transition, they could reduce considerably the amount of time wasted between jobs.
This led to the development of batch-processing systems (see the Operating Sys-
tems Thinking feature, Change Is the Rule Rather Than the Exception). In single-
 stream batch processing, jobs are grouped in batches by loading them consecutively
onto tape or disk. A job stream processor reads the job control language statements
(that define each job) and facilitates the setup of the next job. It issues directives to
the system operator and performs many functions that the operator previously per-
     formed manually. When the current job terminates, the job stream reader reads in
the control-language statements for the next job and performs appropriate house-
   keeping chores to facilitate the transition to the next job. Batch-processing systems
    greatly improved resource utilization and helped demonstrate the real value of
      operating systems and intensive resource management. Single-stream batch-pro-
cessing systems were the state of the art in the early 1960s.

Self Review
     1. (T/F) Batch-processing systems removed the need for a system operator.
 2. What was the key contribution of early batch-processing systems?



              Operating Systems Thinking

 Change Is the Rule Rather Than the Exception
 Historically, change is the rule        1960s and 1970s; today many of     out the book we discuss many
  rather than the exception and         those companies are gone or have    architectural issues and many
 that those changes happen faster far less prominent positions in the  software engineering issues that
 than anticipated and often are far industry. Look at the way comput- designers must consider as they
 more wrenching than imagined.           ers and operating systems were          create operating systems that
 You see this in the computer field      designed in those decades; today        adapt well to change.
 all the time. Just look at w h o the    those designs, in many cases, are
 leading companies were in the           profoundly different. Through-

<!-- pág. 446 -->

390 Real Memory Organization and Management

                          Ans: 1) False. A system operator was needed to set up and "tear down" the jobs and control
                          them as they executed. 2) They automated various aspects of job-to-job transition, consider-
                          ably reducing the amount of wasted time between jobs and improved resource utilization.


                           9.8 Fixed-Partition Multiprogramming
                           Even with batch-processing operating systems, single-user systems still waste a
                           considerable amount of the computing resource (Fig. 9.6). A typical process would
                           consume the processor time it needed to generate an input/output request; the pro-
                           cess could not continue until the I/O finished. Because I/O speeds were extremely
                           slow compared with processor speeds (and still are), the processor was severely
                           underutilized.
                                 Designers saw that they could further increase processor utilization by imple-
                           menting multiprogramming systems, in which several users simultaneously compete
                           for system resources. The process currently waiting for I/O yields the processor if
                           another process is ready to do calculations. Thus, I/O operations and processor cal-
                           culations can occur simultaneously. This greatly increases processor utilization and
                           system throughput.
                                 To take maximum advantage of multiprogramming, several processes must
                           reside in the computer's main memory at the same time. Thus, when one process
                           requests input/output, the processor may switch to another process and continue to
                           perform calculations without the delay associated with loading programs from sec-
                           ondary storage. When this new process yields the processor, another may be ready




                          Figure 9.6 | Procssor utilization on a single-user s y s t e m . [Note: In many single-
                          user jobs, I/O waits are much longer relative to processor utilization periods indicated
                          in this diagram.]

<!-- pág. 447 -->

                                                                            9.8 Fixed-Partition Multiprogramming 391

 to use it. Many multiprogramming schemes have been implemented, as discussed in
   this and the next several sections.
        The earliest multiprogramming systems used fixed-partition multiprogram­
 ming.21 Under this scheme, the system divides main memory into a number of fixed-
 size partitions. Each partition holds a single job, and the system switches the proces­
 sor rapidly between jobs to create the illusion of simultaneity.22 This technique
 enables the system to provide simple multiprogramming capabilities. Clearly, multi-
 programming normally requires more memory than does a single-user system.
 However, the improved resource use for the processor and the peripheral devices
  justifies the expense of the additional memory.
        In the earliest multiprogramming systems, the programmer translated a job
 using an absolute assembler or compiler (see Section 2.8, Compiling, Linking and
 loading). While this made the memory management system relatively straightfor-
 ward to implement, it meant that a job had its precise location in memory determined
 before it was launched and could run only in a specific partition (Fig. 9.7).This restric-
 tion led to wasted memory If a job was ready to run and the program's partition was
  occupied, then that job had to wait, even if other partitions were available. Figure 9.8
 shows an extreme example. All the jobs in the system must run in partition 3 (i.e., the
 prrograms' instructions all begin at address c). Because this partition currently is in
 use. all other jobs are forced to wait, even though the system has two other partitions
  in which the jobs could run (if they had been compiled for these partitions).
        To overcome the problem of memory waste, developers created relocating
 compilers, assemblers and loaders. These tools produce a relocatable program that
 can run in any available partition that is large enough to hold that program
  (Fig. 9.9). This scheme eliminates some of the memory waste inherent in multipro-




Figure 9.7 | Fixed-partition multiprogramming with absolute translation and
loading.

<!-- pág. 448 -->

392 Real Memory Organization and Management




                          Figure 9.8 | Memory waste under fixed-partition multiprogramming with absolute
                          translation and loading.                                                     I




                          Figure 9.9 | Fixed-partition multiprogramming with relocatable translation and
                          loading.

                          gramming with absolute translation and loading; however, relocating translators
                          and loaders are more complex than their absolute counterparts.
                                As memory organization increased in complexity, designers had to augment
                          the protection schemes. In a single-user system, the system must protect only the

<!-- pág. 449 -->

                                                                        9.8   Fixed-Partition    Multiprogramming      393

        operating system from the user process. In a multiprogramming system, the system
        must protect the operating system from all user processes and protect each process
        from all the others. In contiguous-allocation multiprogramming systems, such as
        those discussed in this section, protection often is implemented with multiple
        boundary registers. The system can delimit each partition with two boundary regis-
        ters-- low and high, also called the base and limit registers (Fig. 9.10). When a pro-


    0


    a

    b


    c




    d


Figure 9.10 | Memory protection in contiguous-allocation multiprogramming sys-
tems.




               Anecdote

 Compartmentalization
 When HMD was interviewing for            offered the job, HMD was enthu-         smiled and said, "Harvey, I'm not
 a job in computer security at the   siastic: "Yes sir, if I come to the          that concerned about the enemy,
 Pentagon, his last interview of the Pentagon you can count on me to              1 just want to make sure that the
 day was w i t h the person ulti-    work day and night to ensure that            Navy doesn't know what the Air
 mately responsible for all Penta-   the enemy can't compromise our               Force is doing."
 gon computer systems. W h e n            computer systems." The employer

 Lesson to operating systems designers: A key goal of operating systems is compartmentalization.           Operating
 systems must provide a working environment in which a great diversity of users can operate concurrently,
 knowing that their work is private and protected from other users.

<!-- pág. 450 -->

39l4 Real Memory Organization and Management

                                  cess issues a memory request, the system checks whether the requested address is
                                  greater than or equal to the process's low boundary register value and less than the
                                  process's high boundary register value (see the Anecdote, Compartmentalization).
                                  If so, the system honors the request; otherwise, the system terminates the program
                                  with an error message. As with single-user systems, multiprogramming systems pro-
                                  vide system calls that enable user programs to access operating system services.
                                         One problem prevalent in all memory organizations is that of fragmenta-
                                  tion —the phenomenon wherein the system cannot use certain areas of available
                                  main memory (see the Operating Systems Thinking feature, Spatial Resources and
                                  Fragmentation). 23 Fixed-partition multiprogramming suffers from internal frag-
                                  mentation, which occurs when the size of a process's memory and data is smaller
                                  than that of the partition in which the process executes.24 (We discuss external frag-
                                  mentation in Section 9.9, Variable-Partition Multiprogramming.)
                                         Figure 9.11 illustrates the problem of internal fragmentation. The system's
                                  three user partitions are occupied, but each program is smaller than its correspond-
                                  ing partition. Consequently, the system may have enough main memory space in
                                  which to run another program but has no remaining partitions in which to run the
                                  program. Thus, some of the system's memory resources are wasted. In the next sec-
                                  tion we discuss another memory organization scheme that attempts to solve the
                                  problem of fixed partitions. We shall see that, although this scheme makes improve-
                                  ments, the system can still suffer from fragmentation.




                Operating Systems Thinking
    Spatial Resources and Fragmentation
    Consider a common scenario: A           the walls are built to delineate        using several noncontiguous,
    restaurant in a shopping mall           the separate office spaces. When        smaller spaces. This is called frag-
    wants to expand, but no larger          a customer wants to expand its          mentation and it is a recurrirg
    unoccupied stores are available in      space, it may be difficult to do so     theme in operating systems.In
    the mall, so the mall owners must       because no larger space may be          this book, you will see how main
    wait for adjacent stores to             available and the adjacent spaces       memory and secondary storage
    become available, and then knock        may not be available. In both of        can each suffer various forms of
    down some walls to create a             these cases the units desiring to       fragmentation and how operat
    larger space. An office building        expand may not be able to find a        ing systems designers deal with
    may initially start off as en empty     sufficiently large contiguous           these problems.
    "shell;" as customers rent spaces,      space and may have to settle for

<!-- pág. 451 -->

                                                                          9.9 Variable-Partition Multiprogramming 395




 Figure 9.11 | Internal fragmentation in a fixed-partition multiprogramming system.

Self Review
 1. Explain the need for relocating compilers, assemblers and loaders.
2. Describe the benefits and drawbacks of large and small partition sizes.
Ans: 1) Before such tools, programmers manually specified the partition into which their
 program had to be loaded, which potentially wasted memory and processor utilization, and
reduced application portability. 2) Larger partitions allow large programs to run, but result in
internal fragmentation for small programs. Small partitions reduce the amount of internal
 fragmentation and increase the level of multiprogramming by allowing more programs to
reside in memory at once, but limit program size.



9.9 Variable-Partition Multiprogramming
 Fixed-partition multiprogramming imposes restrictions on a system that result in
 inefficient resource use. For example, a partition may be too small to accommodate
 a waiting process, or so large that the system loses considerable resources to inter-
 nal fragmentation. An obvious improvement, operating system designers decided,
 would be to allow a process to occupy only as much space as needed (up to the
 amount of available main memory). This scheme is called variable-partition multi-
  programming.25 26 27

9.9.1 Variable-Partition Characteristics
Figure 9.12 shows how a system allocates memory under variable-partition multi-
programming. We continue to discuss only contiguous-allocation schemes, where a
process must occupy adjacent memory locations. The queue at the top of the figure
  contains available jobs and information about their memory requirements. The
operating system makes no assumption about the size of a job (except that it does

<!-- pág. 452 -->

396 Real Memory Organization and Management




                           Figure 9.12 | Initial partition assignments in variable partition programming

                           not exceed the size of available main memory). The system progresses through the
                           queue and places each job in memory, where there is available space, at which point
                           it becomes a process. In Fig. 9.12, main memory can accommodate the first four
                           jobs; we assume the free space that remains after the system has placed the job cor-
                           responding to process P4 is less than 14KB (the size of the next available job).
                                 Variable-partition multiprogramming organizations do not suffer from inter-
                           nal fragmentation, because a process's partition is exactly the size of the process.
                           But every memory organization scheme involves some degree of waste. In variable
                           partition multiprogramming, the waste does not become obvious until processes
                           finish and leave holes in main memory, as shown in Fig. 9.13. The system can con-
                           tinue to place new processes in these holes. However, as processes continue to com-
                           plete, the holes get smaller, until every hole eventually becomes too small to hold a
                           new process. This is called external fragmentation, where the sum of the holes is

<!-- pág. 453 -->

                                                                           9.9 Variable-Partition Multiprogramming 397




   Figure 9.13 | Memory "holes" in variable-partition multiprogramming.

     enough to accommodate another process, but the size of each hole is too small to
 accomodate any available process.28
         The system can take measures to reduce some of its external fragmentation.
 When a process in a variable-partition multiprogramming system terminates, the
     system can determine whether the newly freed memory area is adjacent to other
    free memory areas. The system then records in a free memory list either (1) that the
     system now has an additional hole or (2) that an existing hole has been enlarged
          (reflecting the merging of the existing hole and the new adjacent hole). 29 - 30 The pro-
(reflecting the merging adjacent holes to form a single, larger hole is called coalescing and
is illustrated    in Fig. 9.14. By coalescing holes, the system reclaims the largest possi-
 ble contiguous blocks of memory.
         Even as the operating system coalesces holes, the separate holes distributed
 throughout main memory rnay still constitute a significant amount of memory—
     enough in total to satisfy a process's memory requirements, although no individual
hole is large enough to hold the process.
         Another technique for reducing external fragmentation is called memory
    compaction (Fig. 9.15), which relocates all occupied areas of memory to one end or
   the other of main memory.31 This leaves a single large free memory hole instead of
the numerous small holes common in variable-partition multiprogramming. Now
all of the available free memory is contiguous, so that an available process can run if
its memory requirement is met by the single hole that results from compaction.
    Sometimes memory compaction is colorfully referred to as burping the memory.
More conventionally, it is called garbage collection.32

<!-- pág. 454 -->

398 Real Memory Organization and Management




                          Figure 9.14 | Coalescing memory "holes" in variable partition multiprogramming




                          Figure 9.15 | Memory compaction in variable-partition multiprogramming.

                               Compaction is not without drawbacks. Compaction overhead consumes sys-
                          tem resources that could otherwise be used productively. The system also must
                          cease all other computation during compaction. This can result in erratic response

<!-- pág. 455 -->

                                                                         9.9 Variable-Partition Multiprogramming 399

 times for interactive users and could be devastating in real-time systems. Further-
    more, compaction must relocate the processes that currently occupy the main mem-
 ory. This means that the system must now maintain relocation information, which
 ordinary is lost when the system loads a program. With a normal, rapidly changing
 job mix, the system may compact frequently. The consumed system resources might
 not justify the benefits of compaction.

  Self Review
     1. Explain the difference between internal fragmentation and external fragmentation,
    2. Describe two techniques to reduce external fragmentation in variable-partition multipro-
    gramming systems.
Ans: 1) Internal fragmentation occurs in fixed-partition environments when a process is
   allocated more space than it needs, leading to wasted memory space inside each partition.
    External fragmentation occurs in variable-partition environments when memory is wasted
due to holes developing in memory between partitions. 2) Coalescing merges adjacent free
memory blocks into one larger block. Memory compaction relocates partitions to be adjacent
to one another to consolidate free memory into a single block.




 9.9.2 Memory Placement Strategies
In a variable-partition multiprogramming system, the system often has a choice as
to which memory hole to allocate for an incoming process. The system's memory
  placement strategy determines where in main memory to place incoming programs
  and data.33, 34, 35 Three strategies frequently discussed in the literature are illus-
trated in Fig. 9.16.36

      • First-fit strategy—The system places an incoming job in main memory in
        the first available hole that is large enough to hold it. First-fit has intuitive
        appeal in that it allows the system to make a placement decision quickly.
      • Best-fit strategy—The system places an incoming job in the hole in main
        memory in which it fits most tightly and which leaves the smallest amount
        of unused space. To many people, best fit is the most intuitive strategy, but
        it requires the overhead of searching all of the holes in memory for the best
        fit and tends to leave many small, unusable holes. Note in Fig. 9.16 that we
        maintain the entries of the free memory list in ascending order; such sort­
        ing is relatively expensive.
      • Worst-fit strategy—At first this appears to be a whimsical choice. Upon
        closer examination, though, worst-fit also has strong intuitive appeal. Worst
        fit says to place a job in main memory in the hole in which it fits worst (i.e.,
        in the largest possible hole). The intuitive appeal is simple: After the job is
        placed in this large hole, the remaining hole often is also large and thus
        able to hold a relatively large new program. The worst-fit strategy also
        requires the overhead of finding the largest hole and tends to leave many
        small, unusable holes.

<!-- pág. 456 -->

400 Real Memory Organization and Management




                          Figure 9.16 | First-fit, best-fit and worst-fit memory placement strategies.

<!-- pág. 457 -->

                                                                        9.10 Multiprogramming with Memory Swapping 401

 A variation of first-fit, called the next-fit strategy, begins each search for an
     available hole at the point where the previous search ended. 37 Exercise 9.20 at the
end of this chapter examines the next-fit strategy in detail.

  Self Review
         1. Why is first-fit an appealing strategy?
          2. (T/F) None of the memory placement strategies in this section result in internal fragmen-

  Ans: 1) First-fit is intuitively appealing because it does not require that the free memory list
     be sorted, so it incurs little overhead. However, it may operate slowly if the holes that are too
     small to hold the incoming job are at the front of the free memory list. 2) True.



  9.10 Multiprogramming with Memory Swapping
   In all the multiprogramming schemes we have discussed in this chapter, the system
 maintains a process in main memory until it completes. An alternative to this
 scheme is swapping, in which a process does not necessarily remain in main mem-
 ory throughout its execution.
        In some swapping systems (Fig. 9.17), only one process occupies main memory
 at a given time. That process runs until it can no longer continue (e.g., because it must
 wait for I/O completion), at which time it relinquishes both the memory and the pro-
 cessor to the next process. Thus, the system dedicates the entire memory to one pro-
 cess for a brief period. When the process relinquishes the resource, the system swaps
 (or rools) out the old process and swaps (or rolls) in the next process. To swap a pro-
 cess out, the system stores the process's memory contents (as well as its PCB) in sec-
 ondary storage. When the system swaps the process back in, the process's memory
      contents and other values are retrieved from secondary storage. The system normally
   swap a process in and out many times before the process completes.
        Many early timesharing systems were implemented with this swapping tech-
   nique. Response times could be guaranteed for a few users, but designers knew that
   they needed better techniques to handle large numbers of users. The swapping sys-
  tems of the early 1960s led to today's paged virtual memory systems. Paging is con-
 sidered in detail in the next two chapters on virtual memory systems.
        More sophisticated swapping systems have been developed that allow several
 processes to remain in main memory at once.38'39 In these systems, the system swaps a
   process out only when an incoming process needs that memory space. With a suffi-
 cient amount of main memory, these systems greatly reduce the time spent swapping.

  Self Review
     1. Explain the overhead of swapping in terms of processor utilization. Assume that memory
   can hold only one process at a time.
   2. Why were swapping systems in which only a single process at a time was in main memory
     insufficient for multiuser interactive systems?

<!-- pág. 458 -->

402 Real Memory Organization and Management




                                         1. Only one process at a time resides in main memory.

                                         2. That process runs until
                                             a) I/O is issued,
                                             b) timer runs out or
                                             c) voluntary termination.

                                         3. System then swaps out the process by copying the
                                            swapping area (main memory) to secondary storage.

                                         4. System swaps in next process by reading that process's
                                            main memory image into the swapping area. The new
                                            process runs until it is eventually swapped out and the
                                            next user is swapped in, and so on.


                                    Figure 9.17 | Multiprogramming in a swapping system in which only a single pro-
                                    cess at a time is in main memory.

                                    Ans: 1) Enormous numbers of processor cycles are wasted when swapping a program
                                    between disk and memory. 2) This type of swapping system could not provide reasonable
                                    response times to a large number of users, which is required for interactive systems.



Web Resources
www.kingston.com/tools/umg/default.asp                              www.memorymanagement.org
Describes the role of memory in a computer. Although the dis-       Presents memory management techniques and garbage collec-
cussion is geared toward today's computers (which use virtual       tion. The site also contains a glossary of over 400 memory man-
memory, a topic introduced in the next chapter), it describes       agement terms and a beginner's guide to memory management.
many fundamental memory concepts.
www.1inux-mag.com/2001-06/compile_01.html
Describes the working of the mallocO function in C, which
allocates memory to newly created variables. The article also
considers some basic allocation strategies that were discussed
above (including first-fit, next-fit and worst-fit).

<!-- pág. 459 -->

                                                                                                                 Summary          403

  Sunmary
  The organization and management of the real memory (also            allocation, a program is divided into blocks or segments that
  called main memory, physical memory or primary memory) of           the system may place in nonadjacent slots in main memory.
  a computer system has been one of the most important influ­         This allows the memory management system to make use of
  ­­­es upon operating systems design. Although most of               holes (unused gaps in memory) that would otherwise be too
  today's systems implement virtual memory, certain types of          small to hold programs. Although the operating system incurs
    real-time and embedded systems cannot afford the overhead         more overhead in managing noncontiguous memory alloca­
   of virtual memory—real memory management remains crucial           tion, this can be justified by the increase in the level of multi­
   to such systems.                                                   programming (i.e., the number of processes that can occupy
          Regardless of which memory organization scheme we           main memory at once).
  adopt for a particular system, we must decide which strategies to          Early computer systems allowed only one person at a
  use to obtain optimal memory performance. Memory manage­            time to use a machine. These computer systems typically did
  ment strategies determine how a particular memory organiza-         not contain an operating system. Later, system designers con­
  tion performs under various policies. Memory management is          solidated input/output coding that implemented basic func­
  typically performed by both software and special-purpose hard-      tions into an input/output control system (IOCS), so the
  ware. The memory manager is a component of the operating            programmer no longer had to code input/output instructions
  system that determines how available memory space is allocated      directly. With overlays, the system could execute programs
  to processes and how to respond to changes in a process's mem-      larger than main memory. However, manual overlay requires
   ory usage. The memory manager also interacts with special-pur-     careful and time-consuming planning, and the programmer
  pose memory management hardware (if any is available) to            often must have detailed knowledge of the system's memory
   improve performance.                                               organization.
           Programs and data must be in main memory before the               Without protection in a single-user system, a process can
  system can execute or reference them. The memory hierarchy          interfere with the operating system's memory—either intention­
  contains levels characterized by the speed and cost of memory       ally or inadvertently—by replacing some or all of its memory
   in each level. Systems with several levels of memory perform       contents with other data. Protection in single-user contiguous
   transfers that move programs and data back and forth between       memory allocation systems can be implemented with a single
   the various levels. Above the main memory level in the hierar-     boundary register built into the processor. Processes must
I chy is cache, which is much faster than main memory and is          access the operating system from time to time to obtain services
  typically located on each processor in today's systems. Pro-        such as input/output. The operating system provides several sys­
  grams in main memory are transferred to the cache, where            tem calls (also called supervisor calls) that may be used to
   they are executed much faster than they would be from main         request such services from the operating system.
  memory. Because many processes that access data and instruc-               Early single-user real memory systems were dedicated
   tions once are likely to access them again in the future (a phe-   to one job for more than the job's execution time. Jobs gener­
  nomenon known as temporal locality), even a relatively small        ally required considerable setup and teardown time, during
  c a c h e can significantly increase performance (when compared     which the computer sat idle. The development of batch-pro­
   to running programs in a system without cache).                    cessing systems improved utilization. In single-stream batch-
           Memory management strategies are divided into fetch        processing, jobs are grouped in batches by loading them con­
  strategies, which determine when to move the next piece of a        secutively onto tape or disk. Even with batch-processing oper­
  program or data to main memory from secondary storage,              ating systems, single-user systems still wasted a considerable
  placement strategies, which determine where in main memory          amount of the computing resource. Therefore, designers chose
   the system should place incoming program or data pieces, and       to implement multiprogramming systems, in which several
  replacement strategies, which determine which piece of a pro-       users simultaneously compete for system resources.
  gram or data to replace to accommodate incoming program                    The earliest multiprogramming systems used fixed-parti­
  and data pieces.                                                    tion multiprogramming, in which the system divides main
           Contiguous memory allocation systems store a program       memory into a number of fixed-size partitions., each holding a
   in contiguous memory locations. In noncontiguous memory            single job. The system switches the processor rapidly between

<!-- pág. 460 -->

404 Real Memory Organization and             Management
jobs to create the illusion of simultaneity. To overcome the        The first-fit strategy places an incoming job in main memory in
problem of memory waste, developers created relocating com­         the first available hole that is large enough to hold it. The best- I
pilers, assemblers and loaders.                                     fit strategy places the job in the hole in main memory in which
       In contiguous-allocation multiprogramming systems,           it fits most tightly and which leaves the smallest amount of
protection often is implemented with multiple boundary regis­       unused space. The worst-fit strategy places the job in main
ters, called the base and limit registers, for each process. One    memory in the hole in which it fits worst (i.e., in the largest
problem prevalent in all memory organizations is that of frag­      possible hole). A variation of the first-fit, called the next-fir
mentation—the phenomenon wherein the system is unable to            strategy, begins each search for an available hole at the point
make use of certain areas of available main memory. Fixed-          where the previous search ended.
partition multiprogramming suffers from internal fragmenta­                 Memory swapping is a technique in which a process does
tion, which occurs when the size of a process's memory and          not necessarily remain in main memory throughout its execu-
data is smaller than the partition in which the process executes.   tion. When a process in memory cannot execute, the system
       Variable-partition multiprogramming allows a process to      swaps (or rolls) out the old process and swaps (or rolls) in the
occupy only as much space as needed (up to the amount of avail­     next process. More sophisticated swapping systems have been
able main memory). Waste does not become obvious until pro­         developed that allow several processes to remain in main
cesses finish and leave holes in main memory, resulting in          memory at once. In these systems, the system swaps a process
external fragmentation. The system can take measures to reduce      out only when an incoming process needs that memory space
some of its external fragmentation by implementing a free mem­      With a sufficient amount of main memory, these system
ory list to coalesce holes, or perform memory compaction.           greatly reduce the time spent swapping.
       The system's memory placement strategy determines
where in main memory to place incoming programs and data.


Key Terms
anticipatory fetch strategy—Method of bringing pages into           demand fetch strategy—Method of bringing program parts or
     main memory before they are requested so they will be              data into main memory as they are requested by a process
     immediately available when they are requested. This is         executive mode—Protected mode in which a processor can
     accomplished by predicting which operations a program              execute operating system instructions on behalf of a user
     will perform next.                                                 (also called kernel mode).
base register—Register containing the lowest memory address         external fragmentation—Phenomenon in variable-partition
     a process may reference.                                            memory systems in which there are holes distributed
best-fit memory placement strategy—Memory placement                      throughout memory that are too small to hold a process.
     strategy that places an incoming job in the smallest hole in
                                                                    fetch strategy—Method of determining when to obtain the
     memory that can hold the job.
                                                                         next piece of program or data for transfer from secondary
boundary register—Register for single-user operating systems             storage to main memory.
    that was used for memory protection by separating user
                                                                    first-fit memory placement strategy—Memory placement
    memory space from kernel memory space.
                                                                           strategy that places an incoming process in the first hole
burping the memory—See memory compaction.                                  that is large enough to hold it.
cache memory—Small, expensive, high-speed memory that               fixed-partition multiprogramming—Memory organization that
    holds copies of programs and data to decrease memory                 divides main memory into a number of fixed-size parti-
    access times.                                                        tions, each holding a single job.
coalescing memory holes—Process of merging adjacent holes
                                                                    fragmentation (of main memory)—Phenomenon wherein a
     in memory in variable partition multiprogramming sys­
                                                                        system is unable to make use of certain areas of available
     tems. This helps create the largest possible holes available
                                                                        main memory.
     for incoming programs and data.
                                                                    free memory list — Operating system data structure that points
contiguous memory allocation—Method of assigning memory
                                                                         to available holes in memory.
     such that all of the addresses in the process's entire
     address space are adjacent to one another.                     garbage collection — See memory compaction.

<!-- pág. 461 -->

                                                                                                             Key      Term      405

hole - An unused area of memory in a variable-partition mul­        overlay—Concept created to enable programs larger than
    tiprogramming system.                                               main memory to run. Programs are broken into pieces
input/output control system (IOCS)—Precursor to modern                  that do not need to exist simultaneously in memory. An
    operating systems that provided programmers with a                  overlay contains one such piece of a program.
    basic set of functions to perform I/O.                          partition—Portion of main memory allocated to a process in
intensive resource management—Notion of devoting substan­                fixed- and variable-partition multiprogramming. Pro­
    tial resources to managing other resources to improve                grams are placed into partitions so that the operating sys­
    overall utilization.                                                 tem can protect itself from user processes and so that
                                                                         processes are protected from each other.
internal fragmentation—Phenomenon in fixed-partition multi­
    programming systems in which there holes occur when             physical memory—See main memory.
    the size of a process's memory and data is smaller than the
                                                                    placement strategy (main memory)—Strategy that determines
    partition in which the process executes.
                                                                        where in the main memory to place incoming programs
job control language—Commands interpreted by a job stream                and data.
    processor that define and facilitate the setup of the next
    job in a single-stream batch-processing system.                 replacement strategy (main memory)—Method that a system
                                                                         uses to determine which piece of program or data to dis­
job stream processor—Entity in single-stream batch-process­
                                                                         place to accommodate incoming programs or data.
    ing systems that controls the transition between jobs.
job-to-job transition—Time during which jobs cannot execute         roll — See swap.
    in single-stream batch-processing systems while one job is      setup time—Time required by a system operator and the oper­
    purged from the system and the next job is loaded and                ating system to prepare the next job to be executed.
    prepared for execution.
                                                                    single-stream batch-processing system—Batch-processing sys­
limit register—Register used in fixed-partition multiprogram­            tem that places ready jobs in available partitions from one
    ming systems to mark where a process's memory partition              queue of pending jobs.
    ends.
                                                                    single-user contiguous memory allocation system—System in
memory compaction—Relocating all partitions in a variable-
                                                                         which programs are placed in adjacent memory addresses
   partition multiprogramming system to one end of main
                                                                         and the system services only one program at a time.
   memory to create the largest possible memory hole.
memory hierarchy—Model that classifies memory into levels           supervisor call—Request by a user process to the operating
   corresponding to speed, size and cost.                               system to perform an operation on its behalf (also called a
                                                                        system call).
memory management strategy—Specification of how a partic­
   ular memory organization performs operations such as             swap—Method of copying a process's memory contents to sec­
   fetching, placing and replacing memory.                              ondary storage, removing the process from memory and
                                                                        allocating the freed memory to a new process.
memory manager—Component of an operating system that
   implements the system's memory organization and mem­             teardown time—Time required by a system operator and the
   ory management strategies.                                            operating system to remove a job from a system after the
memory organization—Manner in which the system views                     job has completed.
   main memory, addressing concerns such as how many                temporal locality—Property of events that are closely related
   processes exist in memory, where to place programs and               over time. In memory references, temporal locality occurs
   data in memory and when to replace those pieces with                 when processes reference the same memory locations
   other pieces.                                                        repeatedly within a short period.
next-fit memory placement strategy—Variation of the first-fit
                                                                    variable-partition multiprogramming—Method of assigning
     memory placement strategy that begins each search for an            partitions that are the exact size of the job entering the
     available hole at the point where the previous search ended.        system.
noncontiguous memory allocation—Method of memory allo­
    cation that divides a program into several, possibly non-       wall clock time—Measure of time as perceived by a user.
    adjacent, pieces that the system places throughout main         worst-fit strategy—Memory placement strategy that places an
    memory.                                                             incoming job in the largest hole in memory.

<!-- pág. 462 -->

40)6 Real Memory Organization and Management

Exercises
9.1 In hierarchical memory systems, a certain amount of                  a. What information would you need to help you make
overhead is involved in moving programs and data between                    your decision?
the various levels of the hierarchy. Discuss why the benefits
                                                                         b. If you had this information readily available, how
derived from such systems justify the overhead involved.
                                                                            would you determine the ideal partitioning?
9.2 Why did demand fetching endure as the conventional wis­
                                                                         c. What are the consequences of repartitioning such a
dom for so long? Why are anticipatory fetch strategies receiving
                                                                            system?
so much more attention today than they did decades ago?
9.3 Discuss how memory fragmentation occurs in each of             9.8 A simple scheme for relocating programs in multipro-
the memory organization schemes presented in this chapter.         gramming environments involves the use of a single relocation
                                                                   register. All programs are translated to locations beginning at
9.4 In what circumstances are overlays useful? When may a          zero, but every address developed as the program executes is
section of main memory be overlayed? How does overlaying           modified by adding to it the contents of the processor's reloca-
affect program development time? How does overlaying affect        tion register. Discuss the use and control of the relocation reg-
program modifiability?                                             ister in variable-partition multiprogramming. How might the
9.5 Discuss the motivations for multiprogramming. What             relocation register be used in a protection scheme?
characteristics of programs and machines make multiprogram­        9.9 Placement strategies determine where in the main mem-
ming desirable? In what circumstances is multiprogramming          ory incoming programs and data should be loaded. Suppose a
undesirable?                                                       job waiting to begin execution has a memory requirement that
9.6 You are given a hierarchical memory system consisting of       can be fulfilled immediately. Should the job be loaded and
four levels—cache, primary memory, secondary memory and            begin execution immediately?
tertiary memory. Assume that programs may be executed in any       9.10 Charging for resources in multiprogramming system
of the memory levels. Each level consists of an identical amount   can be complex.
of memory, and the range of memory addresses in each level is
                                                                         a. In a dedicated system, the user is normally charged for
identical. Cache runs programs the fastest, primary memory is
                                                                            the entire system. Suppose that in a multiprogram-
ten times slower than the cache, secondary memory is ten times
                                                                            ming system only one user is currently on the system.
slower than primary memory and tertiary memory is ten times
                                                                            Should the user be charged for the entire system?
slower than secondary memory. There is only one processor and
it may execute only one program at a time.                               b. Multiprogramming operating systems generally con-
                                                                            sume substantial system resources, as they manage
      a. Assume that programs and data may be shuttled
                                                                            multiple-user environments. Should users pay for this
         from any level to any other level under the operating
                                                                            overhead, or should it be "absorbed" by the operat-
         system's control. The time it takes to transfer items
                                                                            ing system?
         between two particular levels is dependent upon the
         speed of the lowest (and slowest) level involved in             c. Most people agree that charges for computer system
         the transfer. Why might the operating system choose                usage should be fair, but few can define precisely what
         to shuttle a program from cache directly to secondary              "fairness" is. Another attribute of charging schemes,
         memory, thus bypassing primary memory? Why                         but one which is easier to define, is predictability. We
         would items be shuttled to slower levels of the hierar­            want to know that if a job costs a certain amount to
         chy? Why would items be shuttled to faster levels of               run once, running it again in similar circumstances will
         the hierarchy?                                                     cost approximately the same amount. Suppose that in
                                                                            a multiprogramming environment we charge by wall
      b. The scheme above is somewhat unconventional. It is
                                                                            clock time, i.e., the total real time involved in running
         more common for programs and data to be moved only
                                                                            the job from start to completion. Would such a schemes
         between adjacent levels of the hierarchy. Give several
                                                                            yield predictable charges? Why?
         arguments against allowing transfers directly from the
         cache to any level other than primary memory.             9.11 Discuss the advantages and disadvantages of noncontig-
                                                                   uous memory allocation.
9.7 As a systems programmer in a large computer installa­
tion using a fixed-partition multiprogramming system, you          9.12 Many designers believe that the operating system shold
have the task of determining if the current partitioning of the    always be given a "most trusted" status. Some designers fell
system should be altered.                                          that even the operating system should be curtailed, particularly

<!-- pág. 463 -->

                                                                                                                Exercises       407

in its ability to reference certain areas of memory. Discuss the    9.18 Sharing procedures and data can reduce the main mem­
pros and cons of allowing the operating system to access the full   ory demands of jobs, thus enabling a higher level of multipro­
 range of real addresses in a computer system at all times.         gramming. Indicate how a sharing mechanism might be
                                                                    implemented for each of the following schemes. If you feel
9.13 Developments in operating systems have generally
                                                                    that sharing is inappropriate for certain schemes, say so and
 occurred in an evolutionary rather than revolutionary fashion.
                                                                    explain why.
For each of the following transitions, describe the primary
motivations that led operating systems designers to produce               a. fixed-partition multiprogramming        with   absolute
the new type of system from the old.                                         translation and loading
      a. Single-user dedicated systems to multiprogramming                b. fixed-partition multiprogramming with relocatable
                                                                             translation and loading
      b. Fixed-partition multiprogramming systems with
         absolute translation and loading to fixed-partition              c. variable-partition multiprogramming
         multiprogramming systems with relocatable transla­               d. multiprogramming in a swapping system that enables
         tion and loading                                                    two jobs to reside in main memory at once, but that
      c. Fixed-partition multiprogramming to variable-parti­                 multiprograms more than two jobs.
         tion multiprogramming                                      9.19 Much of the discussion in this chapter assumes that main
      d. Contiguous memory allocation systems to noncontig­         memory is a relatively expensive resource that should be man­
         uous memory allocation systems                             aged intensively. Imagine that main memory eventually
                                                                    becomes so abundant and so inexpensive, that users could
      e. Single-user dedicated systems with manual job-to-job
                                                                    essentially have all they want. Discuss the ramifications of such
         transition to single-user dedicated systems with sin­
                                                                    a development on
         gle-stream batch-processing systems
                                                                          a. operating system design and memory management
9.14 Consider the problem of jobs waiting in a queue until                   strategies
sufficient memory becomes available for them to be loaded
and executed. If the queue is a simple first-in-first-out struc­          b. user application design.
ture, then only the job at the head of the queue may be consid­     9.20 In this exercise, you will examine the next-fit strategy
ered for placement in memory. With a more complex queuing           and compare it to first-fit.
mechanism, it might be possible to examine the entire queue               a. How would the data structure used for implementing
to choose the next job to be loaded and executed. Show how                   next-fit differ from that used for first-fit?
the latter discipline, even though more complex, might yield
better throughput than the simple first-in-first-out strategy.            b. What happens in first-fit if the search reaches the
What problem could the latter approach suffer from?                          highest-addressed block of memory and discovers it
                                                                             is not large enough?
9.15 One pessimistic operating systems designer says it really
does not matter what memory placement strategy is used.                   c. What happens in next-fit when the highest-addressed
Sooner or later a system achieves steady state and all of the                memory block is not large enough?
strategies perform similarly. Do you agree? Explain.                      d. Which strategy uses free memory more uniformly?
9.16 Another pessimistic designer asks why we go to the                   e. Which strategy tends to cause small blocks to collect
trouble of defining a strategy with an official-sounding name                at low memory addresses?
like first-fit. This designer claims that a first-fit strategy is
equivalent to nothing more than random memory placement.                  f. Which strategy does a better job keeping large blocks
Do you agree? Explain.                                                       available?

9.17 Consider a swapping system with several partitions. The        9.21 (Fifty-Percent Rule) The more mathematically inclined
absolute version of such a system would require that programs       student may want to attempt to prove the "fifty-percent rule"
be repeatedly swapped in and out of the same partition. The         developed by Knuth. 40, 41 The rule states that at steady state a
relocatable version would allow programs to be swapped in           variable-partition multiprogramming system will tend to have
and out of any available partitions large enough to hold them,      approximately half as many holes as there are occupied mem­
possibly different partitions on successive swaps. Assuming         ory blocks. It assumes that the vast majority of "fits" are not
that main memory is many times the size of the average job,         exact (so that fits tend not to reduce the number of holes).
discuss the advantages of this multiple-user swapping scheme        9.22 A variable-partition multiprogramming system uses a
over the single-user swapping scheme described in the text.         free memory list to track available memory. The current list

<!-- pág. 464 -->

408 Real Memory Organization and Management

contains entries of 150KB, 360KB, 400KB, 625KB, and 200KB.                    iii. unsorted linked list
The system receives requests for 215KB, 171KB, 86KB, and                      iv. linked list sorted by size of hole
481KB. in that order. Describe the final contents of the free
memory list if the system used each of the following memory                   v. binary tree
placement strategies.                                                         vi. balanced binary tree
      a. best-fit                                                         b. Discuss the efficiency of best-fit when locating the
                                                                             appropriate memory hole in a free memory list
      b. first-fit                                                           stored in the following data structures.
      c. worst-fit                                                            i.   unsorted array
      d. next-fit                                                            ii. array sorted by size of hole
9.23 This exercise analyzes the worst-fit and best-fit strategies            iii. unsorted linked list
discussed in Section 9.9, Variable-Partition Multiprogram­
                                                                             iv. linked list sorted by size of hole
ming, with various data structures.
                                                                              v. binary tree
      a. Discuss the efficiency of worst-fit when locating the
         appropriate memory hole in a free memory list                       vi. balanced binary tree
         stored in the following data structures.                         c. Comparing your results from parts a and b, it might
         i.    unsorted array                                                appear that one algorithm is more efficient than the
                                                                             other. Why is this an invalid conclusion?
         ii.   array sorted by size of hole


Suggested Projects
9.24 Prepare a research paper on the use of real memory             9.25 Prepare a research paper describing variations on the
management in real-time systems.                                    traditional memory hierarchy.


Suggested Simulations
9.26 Develop a simulation program to investigate the relative             e. Based on your observations, suggest some other mem-
effectiveness of the first-fit, best-fit, and worst-fit memory               ory placement strategy that you think would be more
placement strategies. Your program should measure memory                     effective than the ones you have investigated here
utilization and average turnaround time for the various mem­                 Simulate its behavior. What results do you observe?
ory placement strategies. Assume a real memory system with                For each of your simulations, assume that the time it
1GB capacity, of which 300MB is reserved for the operating          takes to make the memory placement decision is negligible.
system. New processes arrive at random intervals between 1
and 10 minutes (in multiples of 1 minute), the sizes of the pro­    9.27 Simulate a system that initially contains 100MB of free
cesses are random between 50MB and 300MB in multiples of            memory, in which processes frequently enter and exit the sys-
10MB, and the durations range from 5 to 60 minutes in multi­        tem. The arriving processes are between 2MB and 35MB in
ples of 5 minutes in units of 1 minute. Your program should         size, and their execution times vary between 2 and 5 seconds.
simulate each strategy over a long enough interval to achieve       Vary the rate of arrival between two processes per second and
steady-state operation.                                             one process every 5 seconds. Evaluate memory utilization and
                                                                    throughput when using the first-fit, best-fit and worst-fit strate-
      a. Discuss the relative difficulties of implementing each
                                                                    gies. Keeping each placement strategy constant, vary the pro-
         strategy.
                                                                    cess scheduling algorithm to evaluate its effect on throughout
      b. Indicate any significant performance differences you       and average wait times. Incorporate scheduling algorithms
         observed.                                                  from Chapter 8, such as FIFO and SPF, and evaluate other
      c. Vary the job arrival rates and job size distributions      algorithms, such as smallest-process-first and largest-process-
         and observe the results for each strategy.                 first. Be sure to determine which, if any, of these algorithms
      d. Based on your observations, state which strategy you       can suffer from indefinite postponement.
         would choose if you were actually implementing a
         physical memory management system.

<!-- pág. 465 -->

                                                                                                        Recommended Reading 409

Recommended Reading
As a result of the widespread usage of virtual memory, many              gies have focused on a faster and more expensive resource,
of the techniques in this chapter are no longer discussed in the         cache.53 The literature also reports application-specific tuning
literature. Belady et al.42 provided a thorough treatment of the         of the memory architecture to improve performance. 54, 55
history of memory management in IBM systems. Mitra 43 and                      Embedded systems are designed differently than general-
 Pohm and Smay44 give a description of the memory hierarchy              purpose systems. Whereas general-purpose systems will provide
   that has become the standard in architectures for decades.            enough resources to perform a wide variety of tasks concur­
Bayes45 and Stephenson 46 presented the primary strategies for           rently, embedded systems provide the bare minimum necessary
memory allocation and placement. Denning 47 presented the                to meet their design goals. Due to size and cost considerations,
pitfalls of single-user contiguous memory allocation, while              resources in embedded systems are much more scarce than in
Knight48 and Coffman and Ryan 49 investigated the implemen-              general-purpose systems. The ACM Transactions on Embedded
 tation of partitioned memory. Memory placement algorithms               Computing Systems, in their November 2002 and February 2003
were presented by Knuth, 50 Stephenson 51 and Oldehoeft and              issues, explored a great deal of research on the topic of memory
 Allan;52 memory swapping concepts, which are vital to virtual           management in embedded systems.56 The bibliography for this
memory, are presented in further detail in the next chapter.             chapter is located on our Web site at www.deitel.com/books/
     Recent research has focused on optimizing the use of                      os3e/Bibliography.pdf.
the memory hierarchy. Several memory management strate­


Works Cited
 1. Belady, L. A.; Parmelee, R. P.; and C. A. Scalzi, "The IBM His­       9. Lin, Y. S., and R. L. Mattson, "Cost-Performance Evaluation of
    tory of Memory Management Technology," IBM Journal of                    Memory Hierarchies," IEEE Transactions Magazine, MAG-8,
    Research and Development, Vol. 25, No. 5, September 1981, pp.            No. 3, September 1972, p. 390.
    491-503.                                                             10. Mitra, D., "Some Aspects of Hierarchical Memory Systems,"
 2. Belady, L. A.; Parmelee, R. P.; and C. A. Scalzi, "The IBM His­          JACM, Vol. 21, No. 1, January 1974, p. 54.
    tory of Memory Management Technology," IBM Journal of                11. Pohm, A. V, and T. A. Smay, "Computer Memory Systems,"
    Research and Development, Vol. 25, No. 5, September 1981, pp.            IEEE Computer, October 1981, pp. 93-110.
    491-503. "How Much Memory Does My Software Need?"
                                                                         12. Pohm, A. V., and T. A. Smay, "Computer Memory Systems,"
    <www.crucial.com/1ibrary/softwareguide.asp>, viewed luly                 IEEE Computer, October 1981, pp. 93-110.
    15,2003.
                                                                         13. Smith, A. J., "Cache Memories," ACM Computing Surveys, Vol.
 3. Belady, L. A.; Parmelee, R. P.; and C. A. Scalzi, "The IBM His­
                                                                             14, No. 3, September 1982, pp. 473-530.
    tory of Memory Management Technology," IBM Journal of
    Research and Development, Vol. 25, No. 5, September 1981, pp.        14. Bays, C, "A Comparison of Next-fit, First-fit, and Best-fit," Com-
    491-503. "How Much Memory Does My Software Need?"                        munications of the ACM,Vol. 20, No. 3, March 1977, pp. 191-192.
    <www.crucial.com/1ibrary/softwareguide.asp>, viewed July             15. Stephenson, C. X, "Fast Fits: New Methods for Dynamic Storage
    15,2003.                                                                 Allocation," Proceedings of the 9th Symposium on Operating
                                                                             Systems Principles, ACM, Vol. 17, No. 5, October 1983, pp. 30-32.
 4. "Microsoft/Windows Timeline," <www.technicalminded.com/
    windowstimeline.htm>, last modified February 16,2003.                16. Belady, L. A.; R. P. Parmelee; and C. A. Scalzi, "The IBM History
 5. "Windows       Version     History,"     <support.microsoft.com/         of Memory Management Technology," IBM Journal of Research
    default.aspx?scid=http://support.mi crosoft.com:80/                      and Development,Vol. 25, No. 5, September 1981, pp. 491-503.
    support/kb/articles/Q32/9/05.asp&NoWebContent=l>,             last   17. Feiertag, R. J. and Organick, E. I., "The Multics Input/Output
    reviewed September 20,1999.                                              System," ACM Symposium on Operating Systems Principles,
 6. Anand Lai Shimpi, "Western Digital Raptor Preview: 10,000                1971, pp. 35-41.
    RPM and Serial ATA," AnandTech.com, March 7, 2003,                   18. Denning, P. J., "Third Generation Computer Systems," ACM
    <www.anandtech.com/storage/showdoc.html?i=1795&p=9>.                     Computing Surveys, Vol. 3, No. 4, December 1971, pp. 175-216.
 7. Todd Tokubo, "Technology Guide: DDR RAM," GamePC.com,                19. Denning, P. X, "Third Generation Computer Systems," ACM
    September 14,2000, <www.gamepc.com/1abs/viewcontent.asp?                 Computing Surveys,Vol. 3, No. 4,December 1971,pp. 175-216.
    id=ddrguide&page=3>.                                                 20. Dennis, X B., "A Multiuser Computation Facility for Education
 8. Baskett, E; Broune, J. C; and W M. Raike, "The Management of             and Research," Communications of the ACM, Vol. 7, No. 9, Sep­
    a Multi-level Non-paged Memory System," Proceedings Spring               tember 1964, pp. 521-529.
    Joint Computer Conference, 1970, pp. 459^65.

<!-- pág. 466 -->

410 Real Memory Organization and Management

21. Belady, L. A.; Parmelee, R. P.; and C. A. Scalzi, "The IBM His­       39. Belady, L. A.; Parmelee, R. P.; and C. A. Scalzi, "The IBM His­
    tory of Memory Management Technology," IBM Journal of                     tory of Memory Management Technology," IBM Journal of
    Research and Development, Vol. 25, No. 5, September 1981, pp.             Research and Development, Vol. 25, No. 5, September 1981, pp.
    491-503.                                                                  491-503.
22. Knight, D. C, "An Algorithm for Scheduling Storage on a Non-          40. Knuth, D. E., The Art of Computer Programming: Fundamental
    Paged Computer," Computer Journal, Vol. 11, No. 1, February               Algorithms, Vol. 1,2nd ed., Reading, MA: Addison-Wesley, 1973.
    1968, pp. 17-21.                                                      41. Shore, J. E., "Anomalous Behavior of the Fifty-Percent Rule."
23. Denning, P., "Virtual Memory", ACM Computing Surveys, Vol. 2,             Communications of the ACM, Vol. 20, No. 11, November 1977.
    No. 3, September 1970, pp. 153-189.                                       pp. 812-820.
24. Randell, B., "A Note on Storage Fragmentation and Program             42. Belady, L. A.; Parmelee, R. P.; and C. A. Scalzi, "The IBM His­
    Segmentation," Communications of the ACM, Vol. 12, No. 7, July            tory of Memory Management Technology," IBM Journal of
    1969, pp. 365-372.                                                        Research and Development, Vol. 25, No. 5, September 1981, pp.
25. Knight, D. C, "An Algorithm for Scheduling Storage on a Non-              491-503.
    Paged Computer," Computer Journal, Vol. 11, No. 1, February           43. Mitra, D, "Some Aspects of Hierarchical Memory Systems."
    1968, pp. 17-21.                                                          JACM, Vol. 21, No. 1, January 1974, p. 54.
26. Coffman, E. G., and T. A. Ryan, "A Study of Storage Partitioning      44. Pohm, A. V, and T A. Smay, "Computer Memory Systems."
    Using a Mathematical Model of Locality," Communications of                IEEE Computer, October 1981, pp. 93-110.
    the ACM, Vol. 15, No. 3, March 1972, pp. 185-190.
                                                                          45. Bays, C, "A Comparison of Next-fit, First-fit, and Best-fit," Com-
27. Belady, L. A.; Parmelee, R. P.; and C. A. Scalzi, "The IBM His­           munications of the ACM, Vol. 20, No. 3, March 1977, pp. 191-192.
    tory of Memory Management Technology," IBM Journal of
    Research and Development, Vol. 25, No. 5, September 1981, pp.         46. Stephenson, C. J., "Fast Fits: New Methods for Dynamic Storage
    491-503.                                                                  Allocation," Proceedings of the 9th Symposium on Operating
                                                                              Systems Principles, ACM, Vol. 17, No. 5, October 1983, pp. 30-32.
28. Randell, B., "A Note on Storage Fragmentation and Program
    Segmentation," Communications of the ACM, Vol. 12, No. 7, July        47. Denning, P. X, "Third Generation Computer Systems," ACM
    1969, pp. 365-372.                                                        Computing Surveys, Vol. 3, No. 4, December 1971, pp. 175-216.
29. Margolin, B. H.; Parmelee, R. P.; and M. Schatzoff, "Analysis of      48. Knight, D. C, "An Algorithm for Scheduling Storage on a Non-
    Free-Storage Algorithms," IBM Systems Journal, Vol. 10, No. 4,            Paged Computer," Computer Journal, Vol. 11, No. 1, Februar.
    1971, pp. 283-304.                                                        1968, pp. 17-21.
30. Bozman, G.; Buco, W.; Daly, T. P.; and W. H. Tetzlaff, "Analysis of   49. Coffman, E. G., and T. A. Ryan, "A Study of Storage Partitioning
    Free-Storage Algorithms—Revisited," IBM Systems Journal, Vol.             Using a Mathematical Model of Locality," Communications of
    23, No. 1,1984, pp. 44-66.                                                the ACM, Vol. 15, No. 3, March 1972, pp. 185-190.
31. Baskett, F; Broune, J. C; and W. M. Raike, "The Management of         50. Knuth, D. E., The Art of Computer Programming: Fundamental
    a Multi-level Non-paged Memory System," Proceedings Spring                Algorithms, Vol. 1,2nd ed., Reading, MA: Addison-Wesley, 1973.
    Joint Computer Conference, 1970, pp. 459-165.                         51. Stephenson, C. J., "Fast Fits: New Methods for Dynamic Storage
32. Davies, D. J. M., "Memory Occupancy Patterns in Garbage Col­              Allocation," Proceedings of the 9th Symposium on Operating
    lection Systems," Communications of the ACM, Vol. 27, No. 8,              Systems Principles, ACM, Vol. 17, No. 5, October 1983, pp. 30-32.
    August 1984, pp. 819-825.                                             52. Oldehoeft, R. R., and S. J. Allan, "Adaptive Exact-fit Storage
33. Knuth, D. E., The Art of Computer Programming: Fundamental                Management," Communications of the ACM, Vol. 28, No. 5, May
    Algorithms, Vol. 1,2nd ed., Reading, MA: Addison-Wesley, 1973.            1985, pp. 506-511.
34. Stephenson, C. J., "Fast Fits: New Methods for Dynamic Storage        53. Luk, C. and Mowry, T C, "Architectural and Compiler Suppor.
    Allocation," Proceedings of the 9th Symposium on Operating                for Effective Instruction Prefetching: A Cooperative Approach."
    Systems Principles, ACM, Vol. 17, No. 5, October 1983, pp. 30-32.         ACM Transactions on Computer Systems (TOCS), Vol. 19 No
35. Oldehoeft, R. R., and S. J. Allan, "Adaptive Exact-fit Storage            1, February 2001.
    Management," Communications of the ACM, Vol. 28, No. 5, May           54. Mellor-Crummey, J.; Whalley, D; and K. Kennedy, "Improving
    1985, pp. 506-511.                                                        Memory Hierarchy Performance for Irregular Applications."
36. Shore, J., "On the External Storage Fragmentation Produced by             Proceedings of the 13th International Conference on Supercom-
    First-fit and Best-fit Allocation Strategies," Communications of          puting, May 1999.
    the ACM, Vol. 18, No. 8, August 1975, pp. 433-440.                    55. Mellor-Crummey, X; Fowler, R.; and D. Whalley, "Tools for
37. Bays, C, "A Comparison of Next-fit, First-fit, and Best-fit," Com-        Application-oriented Performance Tuning," Proceedings of the
    munications of the ACM,Vol. 20, No. 3, March 1977, pp. 191-192.           15th International Conference on Supercomputing, June 2001.
38. Ritchie, D. M., and K. T. Thompson, "The UNIX Time-sharing            56. Jacob, B. and S. Bhattacharyya, "Introduction to the Two Special
    System," Communications of the ACM, Vol. 17, No. 7, July 1974,            Issues on Memory," ACM Transactions on Embedded Computing
    pp. 365-375.                                                              Systems (TECS), February 2003, Vol. 2, No. 1.

<!-- pág. 467 -->

The fancy is indeed no other than a mode of memory emancipated from the order of time
and space.
      — Samuel Taylor Coleridge—


Lead me from the unreal to the real!
      — The Upanishads—


O happy fault, which has deserved to have such and so mighty a Redeemer.
      —The Missal—The Book of Common Prayer—


But every page having an ample marge,
And every marge enclosing in the midst
A square of text that looks a little blot.
      —Alfred, Lord Tennyson—


Addresses are given to us to conceal our whereabouts.
      -Saki(H.H.Munro)-

