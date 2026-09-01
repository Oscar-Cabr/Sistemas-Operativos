# Chapter 4 - Thread Concepts

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 203–242 (numeración del PDF)

<!-- pág. 203 -->

Chapter 4




Thread Concepts
  Objectives
  After reading this chapter, you should understand:
  • the motivation for creating threads.
  • the similarities and differences between processes and threads.
  • the various levels of support for threads.
  • the life cycle of a thread.
  • thread signaling and cancellation.
  • the basics of POSIX, Linux, Windows XP and Java threads.

<!-- pág. 204 -->

                             Chapter Outline

                    4.1                                                   4.7
               Introduction                                   Thread Implementation
        Operating Systems Thinking:                              Considerations
                 Concurrency                                 4 . 7 . 1 Thread Signal Delivery
                                                                  Anecdote: Engineering
                      4.2                                     4 . 7 . 2 Thread Termination
           Definition of Thread

                  4.3                                                     4.8
        Motivation for Threads                                 FOSIX and Pthreads
        Operating    Systems Thinking:                   Anecdote: Standards and Conformance:
                    Parallelism                                 Plug-to-Plug Compatibility

                      4.4
      Thread States: Life Cycle of a                                 4.9
                 Thread                                         Linux Threads
                                                           Operating Systems Thinking:
                  4.5                                                  Scalability
            Thread Operations

                   4.6                                               4.10
             Threading Models                                 Windows XP Threads
         4 . 6 . 1 User-Level Threads
        4.6.2      Kernel-Level Threads
     Operating Systems Thinking:                                      4.11
           Standards Conformance                           Java Multithreading Case
  4.6.3 Combining User- and Kernel-level                        Study, Part I:
                    Threads                              Introduction to Java Threads

       Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited




146

<!-- pág. 205 -->

                                                                                            4.1 Introduction 147

4.1 Introduction
Early operating systems enabled computers to execute several programs concur-
rently, but the programming languages of the time did not enable programmers to
specify concurrent activities (see the Operating Systems Thinking feature, Concur-
rency). Rather, these languages generally provided only a simple set of control
structures that enabled programmers to specify a single thread of control. The types
of concurrent operations that computers performed were generally implemented
by operating system primitives available only to highly experienced systems pro-
grammers.
      The Ada programming language, developed by the United States Department
of Defense in the late 1970s and early 1980s, was one of the first languages to pro-
vide explicit concurrency primitives. Ada was made widely available to defense con-
tractors building military command-and-control systems. However, Ada has not
been widely adopted by universities and commercial industry.




              Operating Systems Thinking
  Concurrency
  We will see numerous examples in      w i t h concurrent programming         and the fascinating protocols
  the text of things that can happen    and the subtle issues of enabling      used to ensure that computers
  concurrently. I/O operations can      concurrent processes and threads       functioning concurrently on the
  proceed concurrently with pro-        to work together to solve com-         same network do not "collide"
  gram execution, several processors    mon problems of coordination           w i t h one another. Chapters 17
  can be executing concurrently, sev-   and data sharing. Chapter 7 deals      and 18 deal w i t h the problems of
  eral users can be using a system      w i t h deadlock and indefinite        building concurrent applications,
  concurrently. Several processes can   postponement of concurrent pro-        pieces of which are distributed
  be trying to access shared data       cesses and threads. Chapter 8          across a computer network.
  concurrently. Several computers       deals w i t h scheduling a processor   Chapter 19 deals w i t h issues of
  can be operating on the same net-     among concurrent processes and         security and protection among
  work concurrently.                    threads. Chapters 9 and 11 deal        concurrent users operating on
       We study concurrency issues      w i t h memory organization and        individual and networked com-
  throughout the book. This and         management issues among con-           puters. The case study chapters on
  the preceding chapter discuss pro-    current threads and processes.         Linux and Windows XP show real-
  cesses and threads—abstractions       Chapter 15 deals w i t h concurrent    world implementations of concur-
  used by the operating system to       processes and threads on multi-        rency control.
  manage concurrent activities.         processor systems. Chapter 16
  Chapters 5 and 6 are concerned        deals with computer networking

<!-- pág. 206 -->

148 Thread Concepts

                            In recent years, many general-purpose programming languages, including
                      Java, C#, Visual C++ .NET, Visual Basic .NET and Python, have made concurrency
                      primitives available to the applications programmer. The programmer specifies that
                      applications contain "threads of execution," each thread designating a portion of a
                      program that may execute concurrently with the other threads. This technology,
                      called multithreading, gives the programmer powerful capabilities not directly
                      available in languages such as C and C++, the languages on which Java and C# are
                      based. C and C++ are called single-threaded languages. [Note: On many computer
                      platforms, C and C++ programs can perform multithreading by using specific code
                      libraries, but these are not part of the ANSI/ISO standard versions of these lan-
                      guages.] Operating system support for threads is essential to supporting languages
                      that provide multithreading semantics.
                            Writing multithreaded programs can be tricky. Although the human mind can
                      perform functions concurrently, people find it difficult to jump between parallel
                      "trains of thought." To see why multithreaded applications can be difficult to pro-
                      gram and understand, try the following experiment: Open three books to page 1
                      and try reading the books concurrently. Read a few words from the first book, then
                      read a few words from the second book, then read a few words from the third book,
                      then loop back and read the next few words from the first book, and so on. After
                      this experiment, you will appreciate some of the key challenges of multithreading—
                      switching between books, reading briefly, remembering your place in each book,
                      moving the book you are reading closer so you can see it, pushing books you are
                      not reading aside—and amid all this chaos, trying to comprehend the content of the
                      books!

                      Self Review
                      1. The text mentions that multithreading capabilities are not directly available in languages
                         such as C and C++. How do programmers still manage to write multithreaded code in
                         these languages?
                      2. What key advantage would you get by running a multithreaded application on a multipro-
                         cessor system over running it on a uniprocessor system?
                      Ans: 1) There are specific code libraries that help with multithreading. However, these
                      libraries are not part of the ANSI/ISO C and C++ standards, so programs written using them
                      are not as portable as "standard C and C++" programs. 2) The multiple threads of the appli-
                      cation that perform parallel tasks could run truly simultaneously on separate processors,
                      speeding application execution.


                      4.2 Definition of Thread
                      Due to the broad support for multithreading in programming languages, virtually
                      all recent operating systems provide at least some support for threads. A thread,
                      sometimes called a lightweight process (LWP), shares many attributes of a process.
                      Threads are scheduled on a processor, and each thread can execute a set of instruc-
                      tions independent of other processes and threads. However, threads are not meant

<!-- pág. 207 -->

                                                                                        4.2 Definition of Thread   149

to exist alone—they normally belong to traditional processes, sometimes referred
to as heavyweight processes (HWP). Threads within a process share many of the
process's resources—most notably its address space and open files—to improve the
efficiency with which they perform their tasks. The name "thread" refers to a single
thread of instructions or thread of control; threads within a process can execute
concurrently and cooperate to attain a common goal. On a multiprocessor system,
multiple threads may be able to execute simultaneously.
       Threads possess a subset of the resources contained in a process. Resources
such as processor registers, the stack and other thread-specific data (TSD), such as
signal masks (data that describes which signals a thread will not receive, discussed
in Section 4.7.1, Thread Signal Delivery) are local to each thread, while the address
space belongs to the process that contains the threads and is global to the threads
i Fig. 4.1). Depending on the thread implementation for the particular platform,
threads may be managed by the operating system or by the user application that
creates them.
       Although many operating systems support threads, the implementations vary
considerably. Win32 threads,1 C-threads2 and POSIX threads 3 are examples of
threading libraries with disparate APIs. Win32 threads are used in the Microsoft 32-
bit Windows operating systems; C-threads are created from a thread library in the
Mach microkernel (on which Macintosh OS X is built) and are also supported by
Solaris and Windows NT operating systems. The POSIX specification provides the
Pthreads standard. The primary goal of Pthreads is to allow multithreaded programs
to be portable across multiple operating system platforms. POSIX has been imple-
mented in a variety of operating systems, including Solaris, Linux and Windows XP.




Figure 4.1 | Thread relationship to processes.

<!-- pág. 208 -->

150 Thread Concepts

                      Self Review
                      1. Why are traditional processes called heavyweight processes?
                      2. Why is it difficult to write portable multithreaded applications?
                      Ans: 1) The primary distinction between relative "weights" of traditional processes and
                      threads is how address spaces are allocated. When a process is created, it is allocated its own
                      address space. When a thread is created, it shares the process's address space, so threads are
                      'lighter weight" than processes. 2) There is no standard threading library that is implemented
                      on all platforms.



                      4.3 Motivatiion for Threads
                      In the previous chapter, we introduced the notion of a process and described how
                      computer systems benefit from improved efficiency and performance when multi-
                      ple processes execute concurrently. When the process concept was introduced by
                      the Multics project in the 1960s, computers typically contained a single processor
                      and applications were relatively small.4 Processes of that era were designed to exe-
                      cute a single thread of control on one processor at a time. Subsequent trends in soft-
                      ware and hardware design indicated that systems could benefit from multiple
                      threads of execution per process. Some motivating factors for multithreading are:
                            • Software design—Due to modularity and compiler design, many of today's
                              applications contain segments of code that can be executed independent of
                              the rest of the application. Separating independent code segments into
                              individual threads can improve application performance and can make
                              inherently parallel tasks simpler to express in code (see the Operating Sys-
                              tems Thinking feature, Parallelism).
                             • Performance — A problem with single-threaded applications is independent
                               activities cannot be scheduled to execute on multiple processors. In a multi-
                               threaded application, threads can share a processor (or set of processors),
                               so that multiple tasks are performed in parallel. Concurrent parallel execu-
                               tion can significantly reduce the time required for a multithreaded applica-
                               tion to complete its task, especially in multiprocessor systems, when
                               compared to a single-threaded application that can execute on only one
                               processor at a time and must perform its operations sequentially. Also, in
                               multithreaded processes, ready threads can execute while others are
                               blocked (i.e., while awaiting I/O completion).
                             • Cooperation—Many applications rely on independent components to com-
                               municate and synchronize activities. Before threads, these components
                               executed as multiple "heavyweight" processes that established interprocess
                               communication channels via the kernel. 5, 6 Performance with a multiple-
                               lightweight-thread approach is often much better than that with a multiple-
                               heavyweight-process approach because a process's threads can communi-
                               cate using their shared address space.

<!-- pág. 209 -->

                                                                                   4.3 Motivation for Threads 151

      Multithreaded applications are ubiquitous in today's computer systems. A
Web server is one environment in which threads can dramatically improve perfor-
mance and interactivity. Web servers typically receive requests from remote appli-
cations for Web pages, images and other files. It is common for Web servers to
service each request with a separate thread. The process that receives requests may
contain one thread that listens for requests from the Internet. For each request
received, a new thread is spawned that interprets the request, retrieves the specified
Web page and transmits the Web page to the client (typically a Web browser). After
the new thread is spawned, its parent can continue to listen for new requests.
Because many Web servers are multiprocessor systems, several requests can be
received and fulfilled concurrently by different threads, improving both throughput
and response time. The overhead incurred by creating and destroying a thread to
service each request is substantial. As a result, most of today's Web servers main-
tain a pool of threads that are assigned to service new requests as they arrive. These
threads are not destroyed after servicing the request; rather, they are reassigned to
the pool to be reassigned to incoming requests. We discuss thread pooling in greater
detail in Section 4.6.3, Combining User- and Kernel-Level Threads.
      Word processors use threads to enhance user productivity and improve inter-
activity. Each time the user types a character at the keyboard, the operating system
receives a keyboard interrupt and issues a signal to the word processor. The word
processor responds by storing the character in memory and displaying it on the




                  Operating Systems Thinking
  Parallelism
  One way to implement parallelism         dreds, thousands or even more         resource manager. For years,
  is to do so on the local machine         processors working in parallel.       those resources were the hard-
  with techniques like multipro-                  Today, another kind of par-    ware, software and data of the
  gramming, multithreading, multi-         allelism is becoming prominent,       local computer system. Today, a
  processing and massive                   namely distributed computing          distributed operating system must
  parallelism. Computer hardware is        over computer networks. We            manage resources no matter
  built to be able to perform pro-         study distributed computing in        where they reside, whether on
  cessing in parallel w i t h input/out-   Chapters 16 through 18 where we       the local computer system or on
  put. Multiprocessors are built to        examine computer networking           computer systems distributed
  have several processors working in       and the issues of building distrib-   across computer networks like the
  parallel—massive parallelism car-        uted operating systems. An oper-      Internet.
  ries that to the extreme with hun-       ating system is primarily a

<!-- pág. 210 -->

152   Thread Concepts

                        screen. Because today's computers can execute hundreds of millions of processor
                        instructions between successive keystrokes, word processors can execute several
                        other threads between keyboard interrupts. For example, many of today's word
                        processors detect misspelled words as they are typed and periodically save a copy of
                        the document to disk to prevent loss of data. Each feature is implemented with a
                        separate thread—as a result, the word processor can respond to keyboard inter-
                        rupts even if one or more of its threads are blocked due to an I/O operation (e.g.,
                        saving a copy of the file to disk).

                        Self Review
                        1. How does improved software design help to make multithreaded applications execute
                           faster?
                        2. Why is it typically more efficient for threads of the same process to communicate than it is
                           for separate processes to communicate?
                        Ans: 1) Many applications contain segments of code that can execute independently of one
                        another. When these segments of code are assigned to separate threads, they can, for exam-
                        ple, execute on multiple processors simultaneously. 2) Threads of the same process can com-
                        municate via their shared address space and do not have to rely on IPC mechanisms that
                        invoke the kernel.


                        4.4 Thread States: Life Cycle of a Thread
                        As discussed in Section 3.2, Process States: Life Cycle of a Process, each process can
                        be viewed as transitioning between a series of discrete process states. In this model,
                        each process contains a single thread of control; therefore, we could have also stated
                        that each thread of control moves through a series of discrete states. When processes
                        contain multiple threads of control, we can view each thread as transitioning between
                        a series of discrete thread states. Thus, much of the discussion of process states and
                        state transitions in Section 3.2, applies to thread states and state transitions.
                              For example, consider the following set of states, based largely on the Java
                        thread implementation (Fig. 4.2).7 In Java, a new thread begins its life cycle in the
                        born state. It remains in the born state until the program starts the thread, which
                        places the thread in the ready state (sometimes called the runnable state). In other
                        operating systems, a thread is started upon creation, eliminating the born state. The
                        highest-priority ready thread enters the running state (i.e., begins executing) when
                        it obtains a processor.
                              A running thread enters the dead state when it completes its task or otherwise
                        terminates. Some threading libraries allow a thread to terminate another thread,
                        which forces the latter into the dead state. Once a thread enters the dead state, its
                        resources are released and it is removed from the system.
                              A thread enters the blocked state when it must wait for the completion of an I/
                        O request (e.g., reading data from disk). A blocked thread is not dispatched to a pro-
                        cessor until its I/O request has been completed. At that point, the thread returns to
                        the ready state, so that it can resume execution when a processor becomes available.

<!-- pág. 211 -->

                                                                    4.4 Thread States: Life Cycle of a Thread   153




Figure 4.2 | Thread life cycle.


      When a thread must wait for an event (e.g., mouse movement or a signal from
another thread), it can enter the waiting state. Once in this state, it returns to the
ready state when another thread notifies it (the term awakens it is also used). When
a waiting thread receives a notify event, the thread transitions from waiting to ready.
      A running thread can enter the sleeping state for a specified period of time
(called a sleep interval). A sleeping thread returns to the ready state when its desig-
nated sleep interval expires. Sleeping threads cannot use a processor, even if one is
available. Threads sleep when they momentarily do not have work to perform. For
example, a word processor may contain a thread that periodically writes a copy of
the current document to disk for recovery purposes. If the thread did not sleep
between successive backups, it would require a loop in which it continually tests if it
should write a copy of the document to disk. This loop would consume processor
time without performing productive work, reducing system performance. In this
case, it is more efficient for the thread to specify a sleep interval (equal to the
period between successive backups) and enter the sleeping state. The sleeping

<!-- pág. 212 -->

154 Thread Concepts

                      thread is returned to the ready state when its sleep interval expires, at which point it
                      writes a copy of the document to disk and reenters the sleeping state.

                      Self Review
                      1. How can a thread enter the dead state?
                      2. How are the waiting, blocked and sleeping states similar? How are they different?
                      Ans: 1) A thread enters the dead state when it completes its task or when another thread
                      terminates it. 2) These states are similar in that the threads in them could not use a processor,
                      even if one were available. A blocked thread cannot be dispatched because it is waiting on an
                      I/O operation that it requested. In this case, the operating system is responsible for ensuring
                      that it eventually unblocks the thread. A waiting thread cannot be dispatched until it receives
                      an event from hardware or software that the operating system does not initiate (e.g., a key
                      press or a signal from another thread). In this case, the operating system cannot control
                      whether or when a waiting thread will eventually be awakened. A sleeping thread cannot exe-
                      cute because it has explicitly notified the system that it should not execute until its sleep
                      interval expires.



                      4.5 Thread Operations
                      Threads and processes have many operations in common such as
                             • create
                             • exit (i.e., terminate)
                             • suspend
                             • resume
                             • sleep
                             • wake.
                      In many ways, thread creation is similar to process creation. When a process spawns
                      a thread, the threading library initializes thread-specific data structures that store
                      information such as register contents, the program counter and a thread ID. Unlike
                      process creation, thread creation does not require the operating system to initialize
                      resources that are shared between the parent process and its threads (e.g., the
                      address space). Many operating systems require fewer instructions to share
                      resources than they do to initialize them, so in these systems, thread creation is
                      faster than process creation. 8 Likewise, thread termination is often faster than pro-
                      cess termination. The reduced overhead due to thread creation and termination
                      encourages software developers to implement parallel tasks using multiple threads
                      instead of multiple processes, when feasible.
                             Some thread operations do not correspond precisely to process operations.
                      They include:
                             • cancel—A thread or process can cause a thread to terminate prematurely
                               by cancelling it. Unlike process termination, thread cancellation is not
                               guaranteed to terminate the thread. This is because threads may disable, or

<!-- pág. 213 -->

                                                                                                    4.6 Threading Models 155
        mask, signals; if a thread masks the cancellation signal, it will not receive
        the signal until the thread reenables the cancellation signal.9 However, a
        thread cannot mask an abort signal.
      • join—In some thread implementations (e.g., Windows XP), when a process
        is initialized, it creates a primary thread. The primary thread acts as any
        other thread, except that if it returns, the process terminates. To prevent a
        process from terminating before all its threads complete execution, the pri-
        mary thread typically sleeps until each thread it creates has completed exe-
        cution. In this case, the primary thread is said to join each of the threads it
        creates. When a thread joins another thread, the former does not execute
        until the latter terminates. 10
      Although most thread implementations support the operations discussed in
this section, other thread operations are specific to particular thread libraries. In the
sections that follow, we introduce several popular thread implementations and dis-
cuss issues the designer must address when creating a threading library.

Self Review
1. How does the cancellation signal differ from the abort signal, discussed in Section 3.5.1,
   Signals?
2. Why does thread creation typically require fewer processor cycles than process creation?
Ans: 1) When a thread receives an abort, it is terminated immediately (i.e., threads cannot
mask abort signals). When a thread is cancelled, it may continue to exist until it unmasks the
cancellation signal. 2) Unlike process creation, thread creation requires that the operating
system initialize only resources that are local to the thread of control. Global resources (e.g.,
the process's address space) can be shared using pointers, which requires significantly fewer
processor cycles than initialization.


4.6 Threading Models
Thread implementations vary among operating systems, but almost all operating
systems support one of three primary threading models. This section examines the
three most popular threading models: user-level threads, kernel-level threads, and a
combination of the two.

4.6.1 User-level Threads
Early operating systems supported processes that contained only a single execution
context.11 As a result, each multithreaded process was responsible for maintaining
thread state information, scheduling threads and providing thread-synchronization
primitives. These user-level threads perform threading operations in user space,
meaning that threads are created by runtime libraries that cannot execute privi-
leged instructions or access kernel primitives directly.12 User-level threads are
transparent to the operating system—it treats each multithreaded process as a sin-
gle execution context. This means that the operating system dispatches the multi-
threaded process as a unit, as opposed to dispatching each individual thread. For

<!-- pág. 214 -->

156 Thread Concepts

                      this reason, user-level thread implementations are also called many-to-one thread
                      mappings, because the operating system maps all threads in a multithreaded pro-
                      cess to a single execution context (Fig. 4.3).
                            When a process employs user-level threads, user-level libraries perform sched-
                      uling and dispatching operations on the process's threads because the operating
                      system is unaware that the process contains multiple threads. The multithreaded
                      process continues to execute until its quantum expires or until it is otherwise pre-
                      empted by the kernel. 13
                            There are several benefits to implementing threads in user space instead of in
                      kernel space. User-level threads do not require that the operating system support
                      threads. Therefore, user-level threads are more portable because they do not rely
                      on a particular operating system's threading API. Another advantage is that,
                      because the threading library, not the operating system, controls how threads are
                      scheduled, application developers can tune the threading library's scheduling algo-
                      rithm to meet the needs of specific applications.14
                            Also, user-level threads do not invoke the kernel for scheduling decisions or
                      synchronization procedures. Recall from Section 3.4.1, Interrupt Processing, that a
                      system loses a number of processor cycles to overhead when an interrupt, such as a
                      system call, occurs. Therefore, user-level multithreaded processes that frequently
                      perform threading operations (e.g., scheduling and synchronization) benefit from
                      low overhead relative to threads that rely on the kernel for such operations. 15
                            User-level thread performance varies depending on the system and on process
                      behavior. Many of the deficiencies of user-level threads relate to the fact that the ker-
                      nel views a multithreaded process as a single thread of control. For instance, user-
                      level threads do not scale well to multiprocessor systems, because the kernel cannot
                      simultaneously dispatch a process's threads to multiple processors, so user-level




                      Figure 4.3 | User-level threads.

<!-- pág. 215 -->

                                                                                               4.6 Threading Models 157

threads can result in suboptimal performance in multiprocessor systems.16 In a many-
to-one thread mapping, the entire process blocks when any of its threads requests a
blocking I/O operation, because the entire multithreaded process is the only thread of
control that the operating system recognizes. Even if the multithreaded process con-
tains threads in the ready state, none of its threads can execute until the blocked
thread becomes ready. This can slow progress to a crawl for multithreaded processes
that block frequently. After a user-level thread blocks, the kernel will dispatch
mother process, which may contain threads of a lower priority than the ready threads
contained in the blocked process. Therefore, user-level threads also do not support
systemwide scheduling priority, which could be particularly detrimental to real-time
multithreaded processes.17 Note that some threading libraries translate blocking sys-
tem calls into nonblocking system calls to address this problem.18

Self Review
1. Explain why user-level thread implementations promote portability.
2. In many-to-one thread mappings, why does the operating system block the entire multi-
   threaded process when a single thread blocks?
Ans: 1) User-level threads present an API to applications that is independent of the operat-
ing system's API. 2) To the operating system, the entire multithreaded process is a single
thread of control. Therefore, when the operating system receives a blocking I/O request, it
blocks the entire process.

4.6.2     Kernel-level Threads
Kernel-level threads attempt to address the limitations of user-level threads by
mapping each thread to its own execution context. As a result, kernel-level threads
are often described as a one-to-one thread mapping (Fig. 4.4). Such mappings
require the operating system to provide each user thread with a kernel thread that



                               One process




        Each user
  thread maps to                                            Kernel
     an execution                                           space
          context




Figure 4.4 | Kernel-level threads.

<!-- pág. 216 -->

158 Thread Concepts

                      the operating system can dispatch. Kernel threads differ from heavyweight pro-
                      cesses because they share their process's address space. Each kernel thread also
                      stores thread-specific data, such as register contents and a thread identifier, for each
                      thread in the system. When a user process requests a kernel-level thread using sys-
                      tem calls defined by the operating system's API, the operating system creates a ker-
                      nel thread that executes the user thread's instructions.
                             There are several benefits to a one-to-one mapping. The kernel can dispatch a
                      process's threads to several processors at once, which can improve performance for
                      applications designed for concurrent execution.19 Also, the kernel can manage each
                      thread individually, meaning that the operating system can dispatch a process's
                      ready threads even if one of its threads is blocked. Therefore, applications that per-
                      form blocking I/O can execute other threads while waiting for the I/O operation to
                      complete. This can improve interactivity for applications that must respond to user
                      input and can improve performance, in general, as long as the application can bene-
                      fit from concurrent execution.
                              Kernel-level threads enable the operating system's dispatcher to recognize
                      each user thread individually. If the operating system implements a priority-based
                      scheduling algorithm, a process that uses kernel-level threads can adjust the level of
                      service each thread receives from the operating system by assigning scheduling pri-
                      orities to each of its threads. 20 For example, a process can improve its interactivity
                      by assigning a high priority to a thread that responds to user requests and lower pri-
                      orities to its other threads.
                             Kernel-level threads are not always the optimal solution for multithreaded
                      applications. Kernel-level thread implementations tend to be less efficient than
                      user-level thread implementations because scheduling and synchronization opera-
                      tions invoke the kernel, which increases overhead. Also, software that employs ker-
                      nel-level threads is often less portable than software that employs user-level
                      threads —the application programmer that uses kernel-level threads must modify
                      the program to use the thread API for each operating system on which it runs.21
                      Operating systems that conform to standard interfaces such as POSIX reduce this
                      problem (see the Operating Systems Thinking feature, Standards Conformance).
                      Another disadvantage is that kernel-level thread tend to consume more resources
                      than user-level threads. 22 Finally, kernel-level threads require that the operating
                      system manage all threads in the system. Whereas a user-level library might be
                      required to manage tens or hundreds of threads, the operating system may be
                      required to manage thousands. Consequently, the application developer must be
                      sure that the operating system's memory management and scheduling subsystems
                      scale well to large numbers of threads.


                      Self Review
                      1. In what scenarios are kernel-level threads more efficient than user-level threads?
                      2. Why is application software written for kernel-level threads less portable than software
                         written for user-level threads?

<!-- pág. 217 -->

                                                                                                     4.6   Threading Models 159

Ans: 1) If an application contains threads that block or that can perform their instructions in
parallel, kernel-level threads are more efficient than user-level threads. 2) Application software
written using kernel-level threads depends on a particular operating system's thread API.

4.6.3 Combining User- and Kernel-level Threads
Some operating systems, such as Solaris and Windows XP, have attempted to bridge
the gap between many-to-one and one-to-one mappings by creating a hybrid imple-
mentation of threads. The combination of the user- and kernel-level thread imple-
mentation is known as the many-to-many thread mapping (Fig. 4.5).23 As its name
suggests, this implementation maps many user-level threads to a set of kernel
threads. Some refer to this technique as m-to-n thread mapping, because the num-
ber of user threads and the number of kernel threads need not be equal. 24
      One-to-one thread mappings require that the operating system allocate data
structures that represent kernel threads. As a result, the amount of memory con-
sumed by kernel thread data structures can become significant as the number of
threads in the system increases. Many-to-many thread mappings reduce this over-
head by implementing thread pooling. This technique allows an application to spec-
ify the number of kernel-level threads it requires. For example, in Fig. 4.5, process
P 1 has requested three kernel-level threads. Note that the threads T 1 and T 2 are
mapped to a single kernel-level thread—a many-to-one mapping. This requires that



                Operating Systems Thinking

  Standard Conformance
  Imagine trying to access the Inter-          dards Institute) in the United              There are drawbacks to standards
  net w i t h o u t the standardized net-      States, ISO (the International              as well—they can slow or even sti-
  work protocols. Or imagine trying            Organization for Standardiza-               fle innovation. They force operat-
  to buy a lamp if wall plugs were             tion), OMG (the Object Manage-              ing systems development
  not standardized. Even more f u n -          ment Group), W3C (the World                 organizations (and others) to
  damentally, imagine what driving             Wide Web consortium) and many               spend significant time and money
  would be like if cities were to              more.                                       conforming to a vast array of
  assign different meanings to red                   An operating systems                  standards, many of which are
  and green lights than the current            designer must be aware of the               obscure or even outdated. We
  standards of "stop" and " g o , "            many standards to which a system            refer to standards and standards
  There are several major national             must conform. These standards               organizations throughout the
  and international organizations              often are not static; rather, they          book and carefully consider the
  that promote computer-industry               evolve w i t h the changing needs           meaning and impact of standards
  standards, such as POSIX, ANSI               of the world community of com-              conformance.
  (the American National Stan-                 puter and communications users.

<!-- pág. 218 -->

160 Thread Concepts




                      Figure 4.5 | Hybrid threading model.

                                      ffif&rfct threading model.
                      the application maintain state information for each of its threads. Application
                      developers are encouraged to use many-to-one mappings for threads that exhibit a
                      low degree of parallelism (i.e., cannot benefit from simultaneous execution). Pro-
                      cess P1's other threads (T3 andT 4 ) are each mapped to a kernel-level thread. These
                      threads are managed by the operating system, as discussed in the previous section.
                              Thread pooling can significantly reduce the number of costly thread creation
                      and destruction operations. For example, Web and database systems often create a
                      new thread to respond to each incoming request for service. Thread pooling allows
                      kernel threads to remain in the system after a user thread dies. The kernel thread
                       can then be allocated to a new user thread that is created at a later time. This
                       improves system response times in environments such as Web servers because
                       requests can be assigned to threads that already exist in the pool. These persistent
                       kernel threads are called worker threads because they typically perform several dif-
                       ferent functions, depending on the threads that are assigned to them.25
                               An advantage of a many-to-one thread mapping is that applications can
                       improve performance by customizing the threading library's scheduling algorithm.
                        However, as discussed in Section 4.6.1, User-Level Threads, if a single user-level
                        thread blocks, the operating system blocks the entire multithreaded process. Another
                        limitation to a many-to-one thread mapping is that a process's threads cannot simul-
                        taneously execute on multiple processors. Scheduler activations attempt to address
                        these limitations to user-level threads. A scheduler activation is a kernel thread that
                        can notify a user-level threading library of events (e.g., a thread has blocked or a pro-
                        cessor is available). This type of kernel thread is called a "scheduler activation,"
                        because the user-level threading library can perform thread-scheduling operations
                        when "activated" by an event notification, sometimes called an upcall.
                               When a multithreaded process is created, the operating system creates a
                         scheduler activation that executes the process's user-level threading-library initial-
                         ization code, which creates threads and requests additional processors for its

<!-- pág. 219 -->

                                                                             4.7 Thread Implementation Considerations 161
threads, if necessary. The operating system creates an additional scheduler activa-
tion for each processor allocated to a process, enabling the user-level library to
assign different threads to execute simultaneously on multiple processors.
       When a user-level thread blocks, the operating system saves the state of the
thread to its scheduler activation and creates a new scheduler activation to notify the
user-level library that one of its threads has blocked. The user-level threading library
can then save the state of the blocked thread from its scheduler activation and assign
a different thread to that scheduler activation. This mechanism prevents the entire
multithreaded process from being blocked when one of its threads blocks.26
       The primary limitation of the many-to-many threading model is that it compli-
cates operating system design, and there is no standard way in which to implement
it.27 For example, Solaris 2.2's many-to-many threading model allowed user applica-
tions to specify the number of kernel threads assigned to each process; Solaris 2.6
introduced scheduler activations. Interestingly, Solaris 8 abandoned its predeces-
sors' many-to-many thread mapping in favor of a simpler and scalable one-to-one
thread mapping scheme.28 Windows XP, which does not support scheduler activa-
tions, dynamically adjusts the number of worker threads in its thread pools in
response to system load.29-30


Self Review
1. Why is it inefficient for an application to specify a thread pool size that is larger than the
   maximum number of ready user threads at any point during the application's execution?
2. How do scheduler activations improve performance in a many-to-many thread mapping?
Ans: 1) Each worker thread in the thread pool consumes system resources such as memory.
If worker threads outnumber ready user threads, the system incurs overhead due to unneces-
sary thread creation and inefficient memory allocation. 2) Scheduler activations allow the
application to indicate how threads should be scheduled to maximize throughput.



4.7 Thread Implementation Considerations
In this section, we discuss differences among thread implementations relating to
thread signal delivery and thread cancellation. These differences highlight funda-
mental issues related to thread operations and thread management.

4.7.1 Thread Signal Delivery
Signals interrupt process execution, as do hardware interrupts, but signals are gen-
erated by software—either by the operating system or by user processes. Signals
became a standard interprocess communication mechanism after appearing in the
UNIX operating system. The original UNIX operating system did not support
threads, so signals were designed for use with processes.31
      As discussed in Section 3.5.1, Signals, when the operating system delivers a
signal to a process, the process pauses execution and invokes a signal handler to

<!-- pág. 220 -->

162 Thread Concepts

                      respond to the signal. When the signal handler completes, the process resumes exe-
                      cution (assuming the process has not exited). 32
                             There are two types of signals: synchronous and asynchronous. A synchronous
                      signal occurs as the direct result of an instruction executed by the process or thread.
                      For example, if a process or thread performs an illegal memory operation, the oper-
                      ating system sends the process a synchronous signal indicating the exception. An
                      asynchronous signal occurs due to an event unrelated to the current instruction;
                      such signals must specify a process ID to indicate the signal recipient. Asynchro-
                      nous signals are commonly used to notify a process of I/O completion, suspend a
                      process, continue a process or indicate that a process should terminate (see
                      Section 20.10.1, Signals, for a list of POSIX signals).
                             When every process in the system contains a single thread of control, signal
                      delivery is straightforward. If the signal is synchronous (e.g., an illegal memory
                      operation), it is delivered to the process currently executing on the processor that
                      initiated the signal (by generating an interrupt). If the signal is asynchronous, the
                      operating system can deliver it to the target process if it is currently running, or the
                      operating system can add the signal to a queue of pending signals to be delivered
                      when the recipient process enters the running state.
                             Now consider the case of a multithreaded process. If the signal is synchronous,
                      it is reasonable to deliver it to the thread currently executing on the processor that
                      initiated the signal (by generating an interrupt). However, if the signal is asynchro-
                      nous, the operating system must be able to identify the signal's recipient. One solu-
                      tion is to require that the sender specify a thread ID. However, if the process
                      employs a user-level thread library, the operating system cannot determine which
                      thread should receive the signal.
                             Alternatively, the operating system can implement signals such that the
                      sender specifies a process ID. In this case, the operating system must decide
                      whether to deliver the signal to all threads, several threads or one thread in the pro-
                      cess. This may seem strange, but in fact this is the signal model that UNIX systems
                      and the POSIX specification employ, and the aim is to provide compatibility with
                      applications originally written for the UNIX operating system (see the Anecdote,
                      Engineering).
                             According to the POSIX specification, processes send signals by specifying a
                      process identifier, not a thread identifier. To solve the thread signal delivery prob-
                      lem, POSIX uses signal masking. A signal mask allows a thread to disable signals of
                      a particular type, so that it does not receive signals of that type. A thread can
                      thereby mask all signals except those that it wishes to receive (Fig. 4.6). In this
                      approach, when the operating system receives a signal for a process, it delivers that
                      signal to all threads in the process that are not masking signals of that type.
                      Depending on the signal type and the default action (see Section 3.5.1, Signals), sig-
                      nals may be queued for delivery after the thread unmasks the signal, or the signal
                      may simply be dropped. For example, in Fig. 4.6, each shape represents a signal of a
                      different type (e.g., suspend, resume, terminate). In this case, the operating system

<!-- pág. 221 -->

                                                                       4.7      Thread Implementation   Considerations   163

attempts to deliver the triangle signal to a multithreaded process. Note that both
threads 1 and 3 are masking the triangle signal. Thread 2 is not masking it; there-
fore, the operating system delivers the triangle signal to thread 2, which then
invokes the process's corresponding signal handler.
      Signal masking allows a process to divide signal handling among different
threads. For example, a word processor may contain a thread that masks all signals
except keyboard events. The sole purpose of this thread would be to record user
keystrokes. Signal masking also enables the operating system to control which
thread receives a signal.
      When implementing a POSIX signal delivery mechanism, the operating sys-
tem must be able to locate a signal mask for each user thread. A one-to-one thread
mapping simplifies this problem because the operating system can attach a signal
mask to each kernel thread, which corresponds to exactly one user thread. How-
ever, if the system employs a many-to-many model, signal masking can become
complex. Consider the case where an asynchronous signal is generated for a process
and the only thread that does not mask that signal is not currently running. In this
case, the operating system can choose to add the signal to a list of pending signals or
to drop the signal. As a general rule, because signals are often used to notify pro-
cesses and threads of important events, the operating system should not drop sig-
nals. [Note: The POSIX specification dictates that the operating system may drop a
signal if all threads in the process have masked it and the corresponding signal-han-
dler action is to ignore the signal.33]
      One way to implement pending signals for a many-to-many threading model
is to create a kernel thread for each multithreaded process that monitors and deliv-
ers its asynchronous signals. The Solaris 7 operating system employed a thread
called the Asynchronous Signal Lightweight Process (ASLWP) that monitored sig-




               Anecdote

  The field of operating systems         neering: "If it's scratched paint it;       resourcefulness of operating sys-
  often seems more like engineer-        if it w o n ' t fit, smash it and it will   tems designers.
  ing than science. A friend once        f i t . " This explanation is certainly
  told me his definition of engi-        crude, but it points to the


  Lesson to operating systems designers: Occasionally, when you dig deep into an operating system, you'll
  see examples of this kind of painting and smashing.

<!-- pág. 222 -->

164 Thread Concepts




                      Figure 4.6 |    Signal    masking.

                      nals and managed pending signals so that they would be delivered to the appropri-
                      ate thread, even if that thread was not running at the time of the signal.34
                            If a multithreaded process employs a user-level library, the operating system
                      simply delivers all signals to the process because it cannot distinguish individual
                      threads. The user-level library registers signal handlers with the operating system,
                      which are then executed upon receipt of a signal. The process's user-level thread
                      library can then deliver the signal to any of its threads that do not mask it.35-36


                      Self Review
                      1. Why is synchronous signal delivery simpler than asynchronous signal delivery?
                      2. Explain how the ASLWP solves to the signal-handling problem in a many-to-many
                         threading model.
                      Ans: 1) Unlike an asynchronous signal, a synchronous signal is generated due to a process
                      or thread that is currently executing on a processor. The operating system can easily identify
                      the recipient of the signal by determining which process or thread is currently running on the
                      processor that generated the interrupt corresponding to the signal. 2) An operating system
                      can create a thread that stores each asynchronous signal until its recipient enters the running
                      state (at which point the signal is delivered).

<!-- pág. 223 -->

                                                                                                 4.8 POSIX and Pthreads 165

4.7.2 Thread Termination
When a thread terminates by completing execution normally (e.g., by an exit call to a
threading library or by exiting the method that contains the thread's code), the oper-
ating system can immediately remove the thread from the system. Threads can also
terminate prematurely, due to either an exception (such an illegal memory reference)
or a cancellation signal from a process or thread. Because threads cooperate by
means such as modifying shared data, an application may produce subtle erroneous
results when one of its threads unexpectedly terminates. Consequently, threading
libraries must carefully determine how and when to remove the thread from the sys-
tem. A thread can choose to disable cancellation by masking the cancellation signal.
Typically it will do so only while performing a task that should not be interrupted
before termination, such as completing a modification to a shared variable.37

Self Review
1. Name three ways a thread can terminate.
2. Why should a thread be allowed to disable its cancellation signal?
Ans: 1) A thread can terminate by completing execution, raising a fatal exception or receiv-
ing a cancellation signal. 2) A thread that modifies a value in its process's shared address
space may leave data in an inconsistent state if terminated prematurely.


4.8 POSIX and Pthreads
POSIX (Portable Operating Systems Interface for Computing Environments) is a
set of standards for operating system interfaces, published by the IEEE's Portable
Application Standards Committee (PASC), that are largely based on UNIX System
V.38 The POSIX specification defines a standard interface between threads and their
threading library (see the Anecdote, Standards and Conformance: Plug-to-Plug
Compatibility). Threads that use the POSIX threading API are called Pthreads
(sometimes referred to as POSIX threads or POSIX 1003.1c threads).39 The
POSIX specification is not concerned with the details of the implementation of the
threading interface—Pthreads can be implemented in the kernel or by user-level
libraries.
       POSIX states that the processor registers, the stack and the signal mask are
maintained individually for each thread, and any other resource information must be
globally accessible to all threads in the process.40 POSIX also defines a signal model
to address many of the concerns discussed in Section 4.7, Thread Implementation
Considerations. According to POSIX, when a thread generates a synchronous signal
due to an exception such as an illegal memory operation, the signal is delivered only
to that thread. If the signal is not specific to a thread, such as a signal to kill a process,
then the threading library delivers that signal to a thread that does not mask it. If mul-
tiple threads leave the kill signal unmasked, that signal is delivered to one of those
threads. More importantly, one may not use the kill signal to terminate a particular
thread—if a thread acts upon a kill signal, the entire process, including all of its

<!-- pág. 224 -->

166     Thread C o n c e p t s

                                 threads, will terminate. This example demonstrates another important property of the
                                 POSIX signal model: although signal masks are stored individually in each thread,
                                 signal handlers are global to all of a process's threads. 41 ' 42
                                       To terminate a particular thread, POSIX provides a cancellation operation
                                 that specifies a target thread, the result of which depends on the target thread's can-
                                 cellation mode. If the target thread chooses asynchronous cancellation, the thread
                                 can be terminated at any point during its execution. If the thread defers cancella-
                                 tion, it will not be cancelled until it explicitly checks for a cancellation request.
                                 Deferred cancellation allows a thread to complete a series of operations before
                                 being abruptly terminated. A thread may also disable cancellation, meaning that it
                                 is not notified that a cancellation operation has been requested. 43
                                       In addition to the common operations discussed in Section 4.5, Thread Opera-
                                 tions, the POSIX specification provides functions that support more advanced opera-
                                 tions. It allows programs to specify various levels of parallelism and implement a
                                 variety of scheduling policies, including user-defined algorithms and real-time sched-
                                 uling. The specification also addresses synchronization using locks, semaphores and
                                 condition variables (see Chapter 5, Asynchronous Concurrent Execution).44, 45, 46
                                       Few of today's most popular operating systems provide complete native
                                 Pthreads implementations, i.e., in the kernel. However, POSIX threading libraries
                                 exist to provide a wide range of support for various operating systems. For example,
                                 although Linux does not conform to POSIX by default, the Native POSIX Thread



                      Anecdote
      Standards and Conformance: Plug-to-Plug Compatibility
      The story goes that a manufac-       drives at a lower price. The drives    formance w i t h the specifications.
      turer of tape drives in the 1960s    were built to conform to the           Why didn't the drives work? Upon
      wanted to produce tape drives        major vendor's specifications. The     careful research, they discovered
      that were equivalent in capabili-    problem was that when they tried       that the specification had bugs.
      ties to those produced by a major    to attach these tape drives to the     They corrected these bugs and
      computer vendor. Their business      computer systems of the major          joked that maybe they should
      strategy was to advertise that       vendor, the drives would not           advertise their drives as being
      their drives were "plug-to-plug      work. They retested their drives       "bug-to-bug compatible" with
      compatible" w i t h those of the     and were puzzled by the fact that      those of the major vendor.
      major vendor and to sell the         their drives were in perfect con-


      Lesson to operating systems designers: We live in a world of abundant and evolving standards. Achieving
      standards conformance is crucial to the success of modern operating systems. But standards are subject to
      human error just as operating systems are.

<!-- pág. 225 -->

                                                                                               4.9   Linux Threads 167

 Library (NPTL) project aims to provide a conforming POSIX threading library that
 employs kernel-level threads in Linux.47 Similarly, the interface to the Microsoft Win-
dows line of operating systems (namely the Win32 API) does not conform to POSIX,
but users can install a POSIX subsystem. [Note: Sun Microsystem's Solaris 9 operat-
ing system provides two threading libraries: a Pthreads library that conforms to
POSIX and a legacy Solaris threads library (called UI threads). There is little differ-
ence between Pthreads and Solaris threads—Solaris has been designed so that calls to
Pthread and Solaris thread functions from within the same application are valid.48

Self Review
1. What is the primary reason to create standard thread interfaces such as Pthreads?
2. Which threading model does the POSIX standard require?
Ans: 1) Standard threading interfaces allow applications to be portable, which reduces soft-
ware development time for applications that must operate on multiple platforms. 2) The
POSIX standard does not require a specific implementation. Therefore, the threads can be
implemented as user-level, kernel-level or hybrid threads.


4.9 Linux Threads
Support for threads in the Linux operating system was introduced as user-level
threads in version 1.0.9 and as kernel-level threads in version 1.3.56.49 Although
Linux supports threads, it is important to note that many Linux kernel subsystems
do not distinguish between threads and processes. In fact, Linux allocates the same
type of process descriptor to processes and threads, both of which are called tasks.
Linux uses the UNIX-based system call fork to spawn child tasks. Linux responds
to the fork system call by creating a new task that contains a copy of all of its par-
ent's resources (e.g., address space, register contents, stack).
      To enable threading, Linux provides a modified version of the fork system
call named clone. Similar to fork, clone creates a copy of the calling task—in the
process hierarchy, the copy becomes the child of the task that issued the clone sys-
tem call. Unlike fork, clone accepts arguments that specify which resources to
share with the child process. At the highest level of resource sharing, tasks created
by clone correspond to threads discussed in Section 4.2, Definition of Thread.
      As of version 2.6 of the kernel, Linux provides a one-to-one thread mapping
that supports an arbitrary number of threads in the system. All tasks are managed
by the same scheduler, meaning that processes and threads with equal priority
receive the same level of service. The scheduler has been designed to scale well to a
large number of processes and threads. The combination of a one-to-one mapping
and an efficient scheduling algorithm provides Linux with a highly scalable thread
implementation (see the Operating Systems Thinking feature, Scalability).
Although Linux does not support POSIX threads by default, it is distributed with a
POSIX threading library. In the 2.4 kernel, a threading library called LinuxThreads
provided POSIX functionality but did not entirely conform to the POSIX specifica-

<!-- pág. 226 -->

168 Thread Concepts

                                 tion. A more recent project, Native POSIX Thread Library (NPTL), has achieved
                                 nearly complete POSIX conformance and is likely to become the default threading
                                 library for the 2.6 kernel. 50
                                        Each task in the process table stores information about the current task state
                                 (e.g., running, stopped, dead). A task in the running state may be dispatched to a pro-
                                 cessor (Fig. 4.7). A task enters the sleeping state when it sleeps, blocks or otherwise
                                 cannot execute on a processor. It enters the stopped stated when it receives a stop
                                 (i.e., suspend) signal. The zombie state indicates that a task has been terminated but
                                 has not yet been removed from the system. For example, if a task contains several
                                 threads, it will enter the zombie state while notifying its threads that it received a ter-
                                 mination signal. A task in the dead state may be removed from the system. These
                                 states are further discussed in Section 20.5.1, Process and Thread Organization.


                                 Self Review
                                 1. Explain the difference between the fork and clone system calls in Linux.
                                 2. What is the difference between the zombie state and the dead state?
                                 Ans: 1) When a task issues a fork system call, it spawns a child task and allocates it to a
                                 copy of its parent's resources. When a task issues a clone system call, the task specifies which
                                 resources it shares with the task it spawns. Tasks created using the clone system call are anal-
                                 ogous to threads. 2) A task in the zombie state is not removed from the system so other
                                 threads can be notified of its termination. A task in the dead state may be immediately
                                 removed from the system.




                 Operating Systems Thinking
    Scalability
    Users' computing needs tend to          scale smoothly from managing a              the operating system was imple-
    increase w i t h time. Operating sys-   two-processor configuration to              mented. Throughout the book,
    tems need to be scalable, i.e., they    managing a four-processor con-              we discuss techniques for making
    need to be able to adjust dynami-       figuration. We will see that most           operating systems scalable. We
    cally as more hardware and soft-        systems today employ a device-              conclude w i t h discussions of scal-
    ware capabilities are added to a        driver architecture that makes it           ability in Linux and Windows XP.
    system. A multiprocessor operat-        easy to add new types of devices,
    ing system, for example, should         even ones that did not exist when

<!-- pág. 227 -->

                                                                                     4.10 Windows XP Threads   169




Figure 4.7 | Linux task state-transition diagram.



4.10 Windows XP Threads
In Windows XP, a process consists of program code, an execution context, resources
(e.g., open files) and one or more associated threads. The execution context includes
such items as the process's virtual address space and various attributes (e.g., secu-
rity attributes). Threads are the actual unit of execution; threads execute a piece of
a process's code in the process's context, using the process's resources. In addition
to its process's context, a thread contains its own execution context which includes
its runtime stack, the state of the machine's registers and several attributes (e.g,
scheduling priority). 51
       When the system initializes a process, the process creates a primary thread. It
acts as any other thread, except that if the primary thread returns, the process ter-
minates, unless the primary thread explicitly directs the process not to terminate. A
thread can create other threads belonging to its process.52 All threads belonging to
the same process share that process's virtual address space. Threads can maintain
their own private data in thread local storage (TLS).

<!-- pág. 228 -->

170 Thread Concepts

                      Fibers
                      Threads can create fibers, which are similar to threads, except that a fiber is sched-
                      uled for execution by the thread that creates it, rather than the scheduler. Fibers
                      make it easier for developers to port applications that employ user-level threads. A
                      fiber executes in the context of the thread that creates the fiber.53
                              It fiber must maintain state information, such as the next instruction to exe-
                      cute processor registers. The thread stores this state information for each fiber. The
                      thread itself is also a unit of execution, and thus must convert itself into a fiber to
                      separate its own state information from other fibers executing in its context. In fact,
                      the Windows API forces a thread to convert itself into a fiber before creating or
                      scheduling other fibers. The thread's context remains, and all fibers associated with
                      that thread execute in that context. 54
                              Whenever the kernel schedules a thread that has been converted to a fiber for
                      execution, the converted fiber or another fiber belonging to that thread runs. Once
                      a fiber obtains the processor, it executes until the thread in whose context it exe-
                      cutes is preempted, or the fiber switches execution to another fiber within that
                      thread. Just as threads possess their own thread local storage (TLS), fibers possess
                      their own fiber local storage (FLS), which functions for fibers exactly as TLS func-
                      tions for a thread. A fiber can also access its thread's TLS. If a fiber deletes itself
                      (i.e., terminates), its thread terminates. 55



                      Thread Pools
                      Windows XP also provides each process with a thread pool that consists of a num-
                      ber of worker threads, which are kernel-mode threads that execute functions speci-
                      fied by user threads. Because the functions specified by user threads may
                      outnumber worker threads, Windows XP maintains requests to execute functions in
                      a queue. The thread pool consists of worker threads that sleep until a request is
                      queued to the pool. 56 The thread that queues the request must specify the function
                      to execute and must provide context information.57 The thread pool is created the
                      first time a thread submits a function to the pool.
                             Thread pools have many purposes. Web servers and databases can use them to
                      handle client requests (e.g., from Web browsers). Instead of incurring the costly
                      overhead of creating and destroying a thread for each request, the process simply
                      queues the request to its pool of worker threads. Also, several threads that spend
                      most of their time sleeping (e.g., waiting for events to occur) can be replaced by a
                      single worker thread that awakens each time one of these events occurs. Further-
                      more, applications can use the thread pool to accomplish asynchronous I/O by
                      queuing a request to its pool of worker threads to execute the I/O completion rou-
                      tines. Using thread pools can make an application more efficient and simpler,
                      because developers do not have to create and delete as many threads. However,
                      thread pools transfer some control from the programmer to the system, which can
                      introduce inefficiency. For example, the system grows and shrinks the size of a pro-

<!-- pág. 229 -->

                                                                                       4.10 Windows XP Threads   171

cess's thread pool in response to request volume; in some cases, the programmer
can better estimate how many threads are needed.58


Thread States
In Windows XP, threads can be in any one of eight states (Fig. 4.8). A thread begins
in the initialized state during thread creation. Once initialization concludes, the
thread enters the ready state. Threads in the ready state are waiting to use a proces-
sor. A thread that the dispatcher has decided will execute next enters the standby
state as it awaits its turn for a processor. A thread is in the standby state, for exam-
ple, during the context switch from the previously executing thread to that thread.
Once the thread obtains a processor, it enters the running state. A thread transi-
tions out of the running state if it terminates execution, exhausts its quantum, is
 preempted, is suspended or waits on an object. When a thread completes its instruc-
 tions, it enters the terminated state. The system does not necessarily delete a termi-
 nated thread immediately, which can reduce thread creation overhead if the process
 reinitializes that thread. The system deletes a thread after its resources have been
 freed. If a running thread is preempted or exhausts its quantum, it returns to the
 ready state.




 Figure 4.8 | Windows XP thread state-transition diagram.

<!-- pág. 230 -->

172 Thread Concepts

                            A running thread enters the waiting state while waiting for an event (e.g., an
                      I/O completion event). Also, another thread (with sufficient access rights) or the
                      system can suspend a thread, forcing it into the waiting state until the thread is
                      resumed. When the thread completes its wait, it either returns to the ready state or
                      enters the transition state. The system places a thread in the transition state if the
                      thread's data is not currently available (e.g., because the thread has not executed
                      recently and the system needed its memory for other purposes), but the thread is
                      otherwise ready to execute. The thread enters the ready state once the system pages
                      the thread's kernel stack back into memory. The system places a thread in the
                      unknown state when the thread's state is unclear (usually because of an error). 59 - 60



                      Self Review
                      1. What purpose do fibers serve in Windows XP?
                      2. How does a primary thread differ from other threads?
                      Ans: 1) Fibers exist to improve compatibility with applications that schedule their own
                      threads (e.g., user-level threads). 2) Unlike other threads, when a primary thread returns, the
                      process to which it belongs terminates.



                      4.11 Java Multithreading Case Studty, Part I:
                      Introduction to Java Threads
                      As we will see in subsequent chapters, the concurrency introduced by processes and
                      threads has significantly impacted software design. In this and the following
                      optional case studies, we provide examples of real programs that demonstrate and
                      solve problems introduced by concurrency. We have chosen to implement these
                      programs in Java due to its portability across most popular platforms. This case
                      study assumes a basic knowledge of Java.
                            In this section, we overview various thread-related methods in the Java API.
                      We use many of these methods in live-code examples. The reader should refer to
                      the Java API directly for more details on using each method, especially the excep-
                      tions thrown by each method (see java.sun.com/j2se/1.4/docs/api/java/
                      lang/Thread.html).
                            Class Th read (package java.1ang) has several constructors. The constructor
                            p u b l i c Thread( String threadName )

                      constructs a Thread object whose name is threadName.The constructor
                            public    Thread()

                      constructs a Thread whose name is "Thread-" concatenated with a number, like
                      Thread-l,Thread-2,and so on.
                           The code that "does the real work" of a thread is placed in its run method.
                      The run method can be overridden in a subclass of Thread or it may be imple-

<!-- pág. 231 -->

                                                                              4.11 Introduction to Java Threads 173

mented in a Runnable object; Runnable is a Java interface that allows the program-
mer to control a thread's life cycle with the run method in an object of a class that
Joes not extend Thread.
      A program launches a thread's execution by calling the thread's start
method, which, in turn, calls method run. After s t a r t launches the thread, s t a r t
returns to its caller immediately. The caller then executes concurrently with the
launched thread.
      The s t a t i c method si eep is called with an argument specifying how long (in
milliseconds) the currently executing thread should sleep; while a thread sleeps, it
does not contend for the processor, so other threads can execute. This can give
lower-priority threads a chance to run.
      Method setName sets a thread's name, which facilitates debugging by allow-
ing the programmer to identify which thread is executing. Method getName returns
the name of the Thread. Method toString returns a String consisting of the
name of the thread, the priority of the thread and the thread's ThreadGroup (anal-
ogous to the parent process of a group of threads).The s t a t i c method current-
Thread returns a reference to the currently executing Thread.
      Method join waits for the Thread to which the message is sent to terminate
before the calling Thread can proceed; no argument or an argument of 0 millisec-
onds to method join indicates that the current Thread will wait forever for the tar-
get Thread to die before the Thread proceeds. Such waiting can be dangerous; it
can lead to two particularly serious problems called deadlock and indefinite post-
ponement—we discuss these concepts in Chapter 7, Deadlock and Indefinite Post-
ponement.
      Java implements thread signaling using the interrupt method. Calling the
interrupt method on a thread that is blocked (because that thread's wai t, joi n or
sleep method was called) raises (throws) its InterruptedException exception
handler.The s t a t i c method interrupted returns true if the current thread has
been interrupted and false otherwise. A program can invoke a specific thread's
isinterrupted method to determine whether that thread has been interrupted.

Creating and Executing Threads
Figure 4.9 demonstrates basic threading techniques, such as constructing Thread
objects and using Thread method sleep.The program creates three threads of exe-
cution. Each thread displays a message indicating that it is going to sleep for a ran-
dom interval from 0 to 5000 milliseconds, then goes to sleep. When each thread
awakens, it displays its name, indicates that it is done sleeping, terminates and
enters the dead state. You will see that method main (i.e., the main thread of execu-
tion) terminates before the application terminates. The program consists of two
classes—ThreadTester (lines 4-23), which creates the three threads, and Print-
Thread (lines 25-59), which contains in its run method the actions each Print-
Thread will perform.
      Class PrintThread (lines 25-59) extends Thread, so that each PrintThread
object can execute concurrently. The class consists of instance variable sleepTime

<!-- pág. 232 -->

174 Thread Concepts


                         1   // Fig. 4.9: ThreadTester.Java
                         2   // Multiple threads printing at different intervals.
                         3
                         4   public class ThreadTester {
                         5
                         6       public static void main( String [] args )
                         7      {
                         8          // create and name each thread
                         9          PrintThread threadl = new PrintThread( "threadl" );
                        10          PrintThread thread2 = new PrintThreadC "thread2" );
                        11          PrintThread thread3 = new PrintThreadC "thread3" );
                        12
                        13          System.err.println( "Starting threads" );
                        14
                        15          threadl.startO; // start threadl; place it in ready state
                        16          thread2.start(); // start thread2; place it in ready state
                        17          thread3.start(); // start thread3; place it in ready state
                        18
                        19          System.err.println( "Threads started, main ends\n" );
                        20
                        21      } // end main
                        22
                        23   } // end class ThreadTester
                        24
                        25   // class PrintThread controls thread execution
                        26   class PrintThread extends Thread {
                        27      private int sleepTime;
                        28
                        29      // assign name to thread by calling superclass constructor
                        30      public PrintThreadC String name )
                        31      {
                        32         super( name );
                        33
                        34         // pick random sleep time between 0 and 5 seconds
                        35         sleepTime = ( int ) ( Math. random() * 5001 );
                        36      } // end PrintThread constructor
                        37
                        38      // method run is the code to be executed by new thread
                        39      public void run()
                        40      {
                        41         // put thread to sleep for sleepTime amount of time
                        42          try {
                        43     System.err.println(     getName()    + " going to sleep for " +
                        44                sleepTime + " milliseconds" );
                        45

                      Figure 4.9 | Java threads being created, starting, sleeping and printing. (Part 1
                      of 2.)

<!-- pág. 233 -->

                                                                         4.11 Introduction to Java Threads 175

 46               Thread.sieep( sleepTime );
 47            } // end try
 48
 49            // if thread interrupted during sleep, print stack trace
 50            catch ( InterruptedException exception ) {
 51               exception.printStackTrace();
 52            } // end catch
 53
 54            // print thread name
 55            System.err.println( getNameO + " done sleeping" );
 56
 57        } // end method run
 58
 59     } // end class PrintThread


 Sample Output 1:
 Starting threads
 Threads started, main ends

 threadl going to sleep for 1217 milliseconds
 thread2 going to sleep for 3989 milliseconds
 thread3 going to sleep for 662 milliseconds
 thread3 done sleeping
 threadl done sleeping
 thread2 done sleeping


 Sample Output 2:
 S t a r t i n g threads
 t h r e a d l going to sleep f o r 314 m i l l i s e c o n d s
 thread2 going to sleep f o r 1990 m i l l i s e c o n d s
 Threads s t a r t e d , main ends

 thread3    going to sleep f o r 3016 m i l l i s e c o n d s
 threadl    done sleeping
 thread2    done sleeping
 thread3    done sleeping

Figure 4.9 | Java threads being created, starting, sleeping and printing. (Part 2
of 2.)
(line 27), a constructor (lines 29-36) and a run method (lines 38-57). Variable
sleepTime stores a random integer value chosen when a new PrintThread
object's constructor is called. Each thread controlled by a PrintThread object
sleeps for the amount of time specified by the corresponding Pri ntThread object's
sleepTi me, then outputs its name.

<!-- pág. 234 -->

176 Thread C o n c e p t s

                                      The PrintThread constructor (lines 29-36) initializes sleepTime to a ran-
                             dom integer from 0 to 5000. When a PrintThread is assigned a processor for the
                             first time, its run method begins executing. Lines 43-44 display a message indicating
                             the name of the currently executing thread and stating that the thread is going to
                             sleep for a certain number of milliseconds. Line 43 uses the currently executing
                             thread's getName method to obtain the thread's name, which was specified as a
                             string argument to the PrintThread constructor and passed to the superclass
                             Thread constructor in line 32. Note that line 43 uses System.err to print the mes-
                             sage because System.err is unbuffered, meaning that it prints its argument imme-
                             diately after being called. Line 46 invokes static Thread method s l e e p to place the
                             thread into the sleeping state. At this point, the thread loses the processor, and the
                             system allows another thread to execute. When the thread awakens, it reenters the
                             ready state, where it waits until the system assigns it a processor. When the Pri n t -
                             Thread object enters the running state again, line 55 outputs the thread's name in a
                             message that indicates the thread is done sleeping; then method run terminates.
                             This places the thread in the dead state, at which point its resources can be freed.
                                      ThreadTester method main (lines 6-21) creates and names three P r i n t -
                             Thread objects (lines 9-11). When debugging a multithreaded program, these
                             names identify which threads are executing. Lines 15-17 invoke each thread's
                             s t a r t method to transition all three PrintThread objects from the born state to
                             the ready state. Method s t a r t returns immediately from each invocation; then line
                             19 outputs a message indicating that the threads were started. Note that all code in
                             this program, except for the code in method run, executes in the main thread. The
                             PrintThread constructor also executes in the main thread, since each P r i n t -
                             Thread object is created in method mai n. When method mai n terminates (line 21),
                             the program itself continues running, because there are still threads that are alive
                             (i.e., the threads were started and have not yet reached the dead state) and are not
                             daemon threads. The program terminates when its last thread dies. When the sys-
                             tem assigns a processor to a PrintThread for the first time, the thread enters the
                             running state, and the thread's run method begins executing.
                                      The sample outputs for this program show each thread's name and sleep time
                             as the thread goes to sleep. The thread with the shortest sleep time normally awak-
                             ens first, indicates that it is done sleeping and terminates. Note in the second sample
                             output that t h r e a d l and thread2 each output their name and sleep time before
                             method mai n completes its execution. This situation demonstrates that, once multi-
                             ple threads are in the ready state, any thread can be assigned the processor.

                             Self Review
                             1. Why should programmers name Java threads?
                             2. How does Java allow programmers to create threads from objects that do not extend
                                Thread?
                             Ans: 1) Naming Java threads allows the programmer to identify each thread when debug-
                             ging. 2) A class can implement the Runnabl e interface so that objects of the class can control
                             the life cycles of threads with their run methods.

<!-- pág. 235 -->

                                                                                                         Web Resources 177

Web Resources
www.serpentine.com/~bos/threads-faq/                             Java.sun.com/docs/books/tutorial/essential/threads/
Contains a frequently-asked-questions (FAQ) page about           Sun's tutorial on Java threads.
threads. Aside from answering basic thread questions, it pro-    java.sun.com/j2se/l.4.1/docs/api/
vides links to books on threads, discusses some common pit-      Java API containing a specification of the Thread class.
falls programmers encounter when implementing operating
                                                                 archive.devx.com/dotnet/articles/pa061702/
system support for threads and directs readers to thread pack-   pa061702-l.asp
ages available on the Internet.                                  Article that overviews multithreading using the .NET plat-
 www.1inux-mag.com/2001-05/compile_01.html                       form, including a concise presentation of multithreading con-
This Linux Magazine article by Benjamin Chelf gives an over-     cepts.
view of thread implementations. Chelf describes in detail how
                                                                 www.microsoft.com/msj/0499/pooling/pooling.aspx
Linux handles Pthreads, providing sample Linux code.
                                                                 Article that describes thread pooling in Windows XP.
 publib.boulder.ibm.com/iseries/v5rl/ic2924/                     java.sun.com/docs/hotspot/threads/threads.html
index.htm?info/apis/rzah4mst.htm                                 White paper that documents the relationship between Java
Provides a complete API for programming Pthreads and             threads and Solaris threads.
defines basic thread concepts.
                                                                 developer.apple.com/documentation/MacOSX/Concep-
sources.redhat.com/pthreads-win32/                               tual/SystemOverview/InverEnvironissues/
Contains an implementation of Pthreads for 32-bit Windows        chapter_14_section_3.html
environments.                                                    Describes the thread manager in Macintosh OS X.



Summary
In recent years, several general-purpose programming lan-        and processes have many operations in common, such as
guages, such as Java, C#, Visual C++ .NET, Visual Basic          create, exit, resume and suspend. Unlike process creation,
.NET and Python, have made concurrency primitives avail-         thread creation does not requires the operating system to
able to the applications programmer. The programmer spec-        initialize resources that are shared between the parent pro-
ifies that applications contain threads of execution, each       cess and its threads (e.g., the address space). This reduces
thread designating a portion of a program that may execute       the overhead of thread creation and termination when
concurrently with other threads. This technology, called mul-    compared to process creation and termination. Some
tithreading, gives the programmer powerful capabilities.         thread operations do not correspond precisely to process
Operating system support for threads is essential to support-    operations, such as cancel and join.
ing languages that provide multithreading semantics.                    Thread implementations vary among operating sys-
       Threads, sometimes called lightweight processes           tems, but almost all operating systems support user-level
(LWPs), share many resources—most notably the address            threads, kernel-level threads or a combination of the two.
space of their process—to improve the efficiency with            User-level threads perform threading operations in user
which they perform their tasks. The name "thread" refers         space, meaning that threads are created by runtime librar-
to a single thread of instructions or thread of control;         ies that cannot execute privileged instructions or access
threads within a process execute concurrently to attain a        kernel primitives directly. User-level thread implementa-
common goal. Resources such as processor registers, the          tions are also called many-to-one thread mappings, because
stack and other thread-specific data (TSD) are local to each     the operating system maps all threads in a multithreaded
thread, while all threads share the address space of their       process to a single execution context. Although user-level
process. Depending on the thread implementation, threads         threads vary in performance among applications, many of
may be managed by the operating system or by a user              their deficiencies relate to the fact that the kernel views a
application. Although many operating systems support             multithreaded process as a single thread of control.
threads, the implementations vary considerably.                         Kernel-level threads attempt to address the limita-
       Threads have become prominent due to trends in            tions of user-level threads by mapping each thread to its
software design, scalability and cooperation. Each thread        own execution context. As a result, kernel-level threads
transitions among a series of discrete thread states. Threads    provide a one-to-one thread mapping. Their benefits

<!-- pág. 236 -->

178 Thread Concepts

include increased scalability, interactivity and throughput.     implementations allow a thread to determine when it can
Due to overhead and reduced portability, however, kernel-        be terminated to prevent the process from entering an
level threads are not always the optimal solution for multi-     inconsistent state.
threaded applications.                                                  Threads that use the POSIX threading API are called
       The combination of the user- and kernel-level thread      Pthreads (sometimes referred to as POSIX threads or
implementation is known as the many-to-many thread map-          POSIX 1003.1c threads). POSIX states that the processor
ping. Some refer to this technique as m-to-n thread mapping      registers, the stack and the signal mask are maintained indi-
because the number of user and kernel threads need not be        vidually for each thread, and any other resource informa-
equal. Many-to-many thread mappings reduce overhead due          tion must be globally accessible to all threads in the
to one-to-one thread mappings by implementing thread             process. POSIX specifies how operating systems should
pooling, which allows an application to specify the number       deliver signals to Pthreads in addition to specifying several
of kernel-level threads it requires. Persistent kernel threads   thread-cancellation modes.
that occupy the thread pool are called worker threads. A                Linux allocates the same type of process descriptor to
technique that enables a user-level library to schedule its      processes and threads, both of which are called tasks. Linux
threads is called a scheduler activation. It occurs when the     uses the UNIX-based system call fork to spawn child tasks.
operating system calls a user-level threading library that       To enable threading, Linux provides a modified version
determines if any of its threads need rescheduling. Scheduler    named clone, which accepts arguments that specify which
activations can reduce context-switching overhead due to         resources to share with the child task. At the highest level
inappropriate scheduling decisions in the kernel by allowing     of resource sharing, tasks created by clone correspond to
the threading library to determine the scheduling policy that    threads discussed in Section 4.2, Definition of Thread.
best addresses the application's needs.                                 In Windows XP, threads—not processes —are dis-
       When the operating system delivers a signal to a pro-     patched to a processor; threads execute a piece of the pro-
cess, the process pauses execution and invokes a signal han-     cess's code in the process's context, using the process's
dler to respond. There are two types of signals:                 resources. In addition to its process's context, a thread con-
synchronous (which occur as the direct result of an instruc-     tains its own execution context, which includes its runtime
tion being executed) or asynchronous (which occur as the         stack, the state of the machine's registers and several
result of an event unrelated to the instructions being exe-      attributes (e.g, scheduling priority). When the system ini-
cuted). Signal delivery introduces several design challenges     tializes a process, the process creates a primary thread,
in threading implementations. The threading library must         which typically terminates the process upon completion.
determine each signal's recipient so that asynchronous sig-      Windows XP threads can create fibers, which are similar to
nals are delivered properly. Each thread is usually associ-      threads, except that a fiber is scheduled for execution by
ated with a set of pending signals that are delivered when it    the thread that creates it, rather than the scheduler. Win-
executes. One way to control which threads receive signals       dows XP provides each process with a thread pool that con-
of a particular type is to require that each thread specify a    sists of a number of worker threads, which are kernel-mode
signal mask that disables signals of particular types. A         threads that execute functions specified by user threads.
thread can thereby mask all signals except those that it                The Java programming language allows the applica-
wishes to receive.                                               tion programmer to create threads that are portable to
       Thread termination, or cancellation, also differs         many computing platforms. Java uses class Thread to create
between thread implementations. Because multiple threads         threads, which execute code specified in a Runnable
share the same address space, prematurely terminating a          object's run method. Java supports operations such as nam-
thread can cause subtle errors in processes. Some thread         ing, starting and joining threads.


Key Terms
asynchronous cancellation (POSIX)—Cancellation mode in           blocked state—Thread state in which the thread is awaiting
    which a thread is terminated immediately upon receiving           notification of some event, such as completion of an I/O
    the cancellation signal.                                          operation, before it can again become ready.
asynchronous signal—Signal generated for reasons unrelated       born state—Thread state in which a new thread begins its life
    to the current instruction of the running thread.                cycle.

<!-- pág. 237 -->

                                                                                                               Key     Terms     179

C-threads—Threads supported natively in the Mach micro-             mask a signal—Prevent a signal from being delivered. Signal
    kernel (on which Macintosh OS X is built).                          masking enables a multithreaded process to specify which
cancellation of a thread—Thread operation that terminates               of its threads will handle signals of a particular type.
    the target thread. Three modes of cancellation are dis-         multithreading—Technique that incorporates multiple threads
    abled, deferred and asynchronous cancellation.                      of execution within a process to perform parallel activi-
dead state—Thread state entered after a thread completes its            ties, possibly simultaneously.
    task or otherwise terminates.                                   notify—Thread operation that transitions its target thread
deferred cancellation (POSIX)—Cancellation mode in which                 from the waiting to the ready state.
    a thread is terminated only after explicitly checking that it   one-to-one mapping—Threading model in which each user-
    has received a cancellation signal.                                 level thread is assigned to a kernel-level thread.
disabled cancellation (POSIX) —Cancellation mode in which a         pending signal—Signal that has not been delivered to a thread
    thread does not receive pending cancellation signals.               because the thread is not running and/or because the
fiber (Windows XP)—Unit of execution in Windows XP cre-                 thread has masked signals of that type.
     ated by a thread and scheduled by the thread. Fibers facil-    primary thread—Thread created upon process creation (also
     itate portability for applications that schedule their own         called main thread of execution). When the primary
     threads.                                                           thread returns, its process terminates.
fiber local storage (FLS) (Windows XP)—Area of a process's          Pthread (POSIX 1003.1c thread)-Thread that conforms to
     baddress space where a fiber can store data that only the          the POSIX 1003.1c standard.
     fiber can access.
                                                                    ready (or runnable) state—Thread state from which a thread
heavyweight process ( H W P ) - A traditional process, which
                                                                        can transition to the running state and execute on a proces-
    may contain one or more threads. The process is "heavy-
                                                                        sor. In Windows XP, a ready thread transitions to the
    weight" because it is allocated its own address space upon
                                                                        standby state, from which it transitions to the running state.
    creation.
                                                                    running state—Thread state in which a thread executes on a
initialized state (Windows XP)—Thread state in which the
                                                                        processor.
      thread is created by the operating system.
                                                                    scheduler activation—Mechanism that allows a user-level
join—Thread operation that causes the calling thread to block
                                                                        library to schedule kernel threads.
    until the thread it joins terminates. A primary thread
    often joins each of threads it creates so that its corre-       signal handler—Code that is executed in response to a particu-
    sponding process does not exit until all of its threads have         lar signal type.
    terminated.                                                     signal mask—Data structure that specifies which signals are
kernel-level thread—Thread created by an operating system                not delivered to a thread. Depending on the signal type
    (also called kernel thread).                                         and default action, masked signals are either queued or
lightweight process (LWP)—A single thread of program                     dropped.
     instructions (also called a thread of execution or thread of   sleep interval—Period of time (specified by the thread that is
     control). Threads are "lightweight" because they share              about to enter the sleeping state) during which a thread
     their address space with other threads in the same process.         remains in the sleeping state.
main thread of execution—Thread created upon process cre-           sleeping state—Thread state in which a thread cannot execute
    ation (also called primary thread).                                  until being returned to the ready state after the sleep
many-to-many (m-to-n) thread mapping—Threading model in                  interval expires.
   which a set of user threads is assigned to a set of kernel       standby state (Windows XP)—Thread state denoting a thread
   threads so that applications can benefit both from kernel-            that has been selected for execution.
   level threads and user-level features such as scheduler
                                                                    synchronous signal—Signal generated due to execution of the
   activations. In practice the number of user threads is
                                                                        currently running thread's instructions.
   greater than or equal to the number of kernel threads in
   the system to minimize memory consumption.                       task—Linux representation of an execution context (i.e., pro-
                                                                        cess or thread).
many-to-one thread mapping—Threading model in which all
   user-level threads in a process are assigned to one kernel       terminated state (Windows XP)—Thread state that denotes a
   thread.                                                              thread has finished executing.

<!-- pág. 238 -->

180 Thread Concepts

thread—Entity that describes an independently executable                 run because its kernel stack has been paged out of mem-
    stream of program instructions (also called a thread of              ory.
    execution or thread of control). Threads facilitate parallel     unknown state (Windows XP)—Thread state denoting that the
    execution of concurrent activities within a process.                 some error has occurred and the system does not know
thread local storage (TLS)—Windows XP implementation of                  the state of the thread.
     thread-specific data. A thread can share its address space      user-level threads—Threading model in which all threads in a
     with other threads of that process, but hide its private data        process are assigned to one execution context.
     in its TLS.                                                     wake—Thread operation that transitions its target from the
thread pooling—Threading technique that employs a number                waiting state to the ready state.
     of kernel threads that exist for the duration of the process    waiting state—Thread state from which a thread cannot exe-
     that creates them. This technique can improve perfor-                cute until transitioning to the ready state via a wake or
     mance by reducing the number of costly thread creation               notify operation.
     and termination operations.
                                                                     Win32 thread—Threads natively supported in the Microsoft
thread state —Status of a thread (e.g., running, ready, blocked,        32-bit Windows line of operating systems.
     and so on).
                                                                     worker thread—Kernel thread that is a member of a thread
transition state (Windows XP)—Thread state denoting a                    pool. Worker threads may be mapped to any user thread
     thread that has completed a wait but is not yet ready to            in the process that created its thread pool.




Exercises
4.1 Compare and contrast thread dispatching in kernel-level          4.5 In Section 4.7.1, Thread Signal Delivery, we explained
threads and in user-level threads.                                   how signals may specify their targets using thread identifiers or
4.2 Would an algorithm that performs several independent             process identifiers. Suggest an alternative way to implement
calculations concurrently (e.g., matrix multiplication) be more      signals to solve the asynchronous signal delivery problem.
efficient if it used threads, or if it did not use threads? Why is
                                                                     4.6 Section 4.7.1, Thread Signal Delivery, discusses how
this a hard question to answer?
                                                                     Solaris 7 employed a thread called the Asynchronous Light-
4.3 Name two situations other than a Web or database server          weight Process (ASLWP) to monitor and deliver pending
for which thread pooling may be useful. Another possibility is       asynchronous signals. How can this solution be simplified if the
an online interactive multi-player game. Several such games can      operating system represents threads using one-to-one thread
have hundreds of active players simultaneously, each of whom         mappings?
can be represented by a thread. In these environments, users
frequently enter and exit the game, meaning that thread pools        4.7 Compare and contrast asynchronous, deferred and dis-
can provide an efficient way to allocate threads. In general, any    abled cancellation in Pthreads.
environment in which threads are rapidly created and
destroyed, but variance in the total number of threads in the sys-   4.8 How do the Linux fork and clone system calls differ?
tem at any given time is small, can benefit from thread pools.       How are they alike?

4.4 Why are scheduler activations less portable than either          4.9 According to the discussion in Section 4.10, Windows XP
user-level or kernel-level threads?                                  Threads, which thread mappings does Windows XP support?



Suggested Projects
4.10 Research how threads are implemented in Windows XP,             track of for each thread? Does the implementation depend on
OS X, and Linux. Compare and contrast the implementations.           the platform on which the JVM is running?
How do these implementations differ from POSIX Pthreads?             4.12 Research the Solaris compatible Thread Library. Pre-
4.11 Prepare a research paper on Java's implementation of            pare a research paper on how this library works. How does it
threads. What information does the Java Virtual Machine keep         handle the thread signal delivery and termination problems

<!-- pág. 239 -->

                                                                                                                 Recommended Reading 181

that were mentioned in the text? Does it conform to the               4.14 Research how threads are managed in multiprocessor
POSIX standard?                                                       systems and distributed systems.
4.13 Research three types of systems that use thread pooling.
What average number of threads does each of these systems
use?

Recommended Reading
The concept of a lightweight process originated in Sun Micro-         Solaris operating system to be particularly sensitive to operating
system's implementation of lightweight processes.61 Lightweight       system design concerns regarding thread implementations.64
processes soon became synonymous with threads, due to the                    In recent years, the level of support for Pthreads across
development of the POSIX Pthreads specification and the intro-        different operating systems has increased significantly. Blel-
duction of the Java programming language. As programmers              loch describes Pthread implementation concerns and presents
increasingly used threads in applications, operating system           a case study on Solaris threads. 65 Butenhof s Programming
designers developed several levels of support for threads. One        with POSIX Threads discusses the POSIX specification and
 of the more successful models is Anderson et al.'s scheduler acti-   demonstrates how to program with Pthreads. 66 For more infor-
vations.62 The paper also discusses many issues relevant to user-     mation regarding threads and thread programming, see Kle-
and kernel-level threads. Likewise, Benjamin provides a clear         iman et al.'s Programming with Threads67 and Birrell's An
discussion of threading models.63 The reader will also find the       Introduction to Programming with Threads.68 Ousterhout dis-
evolution of multithreading support in Sun Microsystem's              cusses how improper use of threads can reduce performance.69


Works Cited
 1. "Process and Thread Functions," MSDN Library. Microsoft Cor-          March 1996, < w w w . c s . a r i z o n a . e d u / c o m p u t e r . h e l p / p o l i c y /
    poration. February 2003, <msdn.microsoft.com/library/                 DIGITAL_unix/AA-Q2DPC-TKTl_html/
    defaul t. asp?u rl =/l i brary/en-us/dl 1 p roc/base/                 thrd0115.html#pt_cancel_13>.
    process_and_thread_functions.asp>.                                10. "2.1.4 Waiting for a Hiread to Terminate," Documentation Over-
 2. Manuel Pavdn Valderrama, "The Unofficial GNU Mach IPC                 view, Glossary, and Master Index, Product Version: Digital
    Beginner's Guide," August 19,2002, <www.nongnu.org/hurdex-            UNIX Version 4.0 or higher, March 1996, <www.cs.ari-
    tras/i pc_gui de/mach_i pc_cth reads.html>.                           zona.edu/computer.help/poli cy/DIGITAL_uni X/AA-Q2DPC-
 3. IEEE Standards Press, 1996, 9945-1:1996 (ISO/IEC) [IEEE/              TKTlJitml/thrd0021.html#join_thread_sec>.
    ANSI Std 1003.1 1996 Edition] Information Technology-Portable     11. "Comp.os.research: Frequently Answered Questions, The His-
    Operating System Interface (POSIX)-Part 1: System Application:        tory of Threads," Modified August 13, 1996, <www.faqs.org/
    Program Interface (API) [C Language] (ANSI).                          faqs/os-research/partl/section-10.html>.
 4. Daley, Robert C, and Jack B. Dennis, "Virtual Memory, Pro-        12. Anderson, T. E.; B. N. Bershad; E. D. Lazowska; and H. M. Levy,
    cesses, and Sharing in Multics," Proceedings of the ACM Sympo-        "Scheduler Activations: Effective Kernel Support for User-Level
    sium on Operating System Principles, January 1967.                    Management of Parallelism," ACM Transactions on Computer
5. "Multithreading in the Solaris Operating Environment, A Tech-          Systems, Vol. 10, No. 1, February 1992, p. 54.
   nical White Paper," Sun Microsystems, 2002.                        13. Benjamin, C, "The Fibers of Threads," Compile Time (Linux
6. O'Sullivan, B., "Answers to Frequently Asked Questions for             Magazine), May 2001,             <www.linux-mag.com/2001-05/
   comp.programming.threads: Part 1 of 1," Rev, 1.10, Last modified       compile_06.html>.
   September 3,1997, <www.serpentine.com/~bos/threads-faq/>.          14. Anderson, T. E.; B. N. Bershad; E. D. Lazowska; and H. M. Levy,
7. "Lesson: Threads: Doing Two or More Tasks at Once," The Java           "Scheduler Activations: Effective Kernel Support for User-Level
   Tutorial, Sun Microsystems, Inc., <java.sun.com/docs/books/            Management of Parallelism," ACM Transactions on Computer
   tutorial/essential/threads/index.html>.                                Systems, Vol. 10, No. 1, February 1992, p. 54.
8. Appleton, R., "Understanding a Context Switching Benchmark,"       15. D.G. Feitelson, "Job Scheduling in Multiprogrammed Parallel
   Modified October 23, 2001, <cs.nmu.edu/~randy/Research/                Systems," IBM Research Report RC19790, October 1994,2d rev.,
   Papers/Scheduler/understanding.html>.                                  August 1997, p. 121.
9. "pthread_cancel," Documentation Overview, Glossary, and Mas-       16. C. Benjamin, "The Fibers of Threads," Compile Time (Linux
   ter Index, © Digital Equipment Corporation 1996, All Rights            Magazine), May 2001,             <www.linux-mag.com/2001-05/
   Reserved; Product Version: Digital UNIX Version 4.0 or higher,         compi1e_06.html>.

<!-- pág. 240 -->

182 Thread Concepts
17. Feitelson, D. G., "Job Scheduling in Multiprogrammed Parallel      36. Drepper, Ulrich, "Requirements of the POSIX Signal Model,"
    Systems," IBM Research Report RC 19790, October 1994, 2d               modified May 17, 2003, <people.redhat.com/drepper/posix-
    rev., August 1997, p. 121.                                             signal-model .xml>,
18. "Package java.nio.channels," Java 2 Platform SE vl.4.2, 2003       37. Butenhof, David R., Programming with POSIX Threads, Boston,
    <java.sun.com/j2se/l.4.2/docs/api/java/nio/channels/                   MA: Addison-Wesley, 1997, p. 144.
    package-summary.html#multipiex>.                                   38. "POSIX Thread API Concepts," IBM iSeries information Center,
19. Benjamin, C, "The Fibers of Threads," Compile Time (Linux              <publib.boulder.ibm.com/iseries/v5rl/ic2924/
    Magazine),     May      2001,   <www.linux-mag.com/2001-05/            index.htm?info/apis/whatare.htm>, modified        October    16,
    compile_06.html>.                                                      2002.
20. Feitelson, D. G., "Job Scheduling in Multiprogrammed Parallel      39. O'Sullivan, B., "Answers to Frequently Asked Questions for
    Systems," IBM Research Report RC 19790, October 1994, 2d               comp.programrning.threads: Part 1 of 1," rev. 1.1, <www.serpen¬
    rev., August 1997. p. 121.                                             tine.com/~bos/threads-faq/>, last  modified      September    3,
2i. Feitelson, D. G., "Job Scheduling in Multiprogrammed Parallel          1997.
    Systems," IBM Research Report RC 19790, October 1994, 2d           40. McCracken, D., "POSIX Threads and the Linux Kernel," Pro-
    rev., August 1997, p. 121.                                             ceedings of the Ottawa Linux Symposium 2002, p. 332.
22. Anderson, T. E.; B. N. Bershad; E. D. Lazowska; and H. M. Levy,    41. Butenhof, David R., Programming with POSIX Threads, Boston,
    "Scheduler Activations: Effective Kernel Support for User-Level        MA: Addison-Wesley, 1997, pp. 214-215.
    Management of Parallelism," ACM Transactions on Computer           42. Drepper, Ulrich, "Requirements of the POSIX Signal Model,"
    Systems, Vol. 10, No. 1, February 1992, p. 54.                         modified May 17, 2003, <people.redhat.com/drepper/posix-
23. Benjamin, C, "The Fibers of Threads," Compile Time (Linux              signal-model.xml>.
    Magazine),   May   2001,    <www.linux-mag.com/2001-05/            43. Butenhof, David R., Programming with POSIX Threads, Boston.
    compile_06.html >.                                                     MA: Addison-Wesley, 1997, pp. 143-144.
24. Benjamin, C, "The Fibers of Threads," Compile Time (Linux          44. Blelloch, G. E., and G. J. Narlikar, "Pthreads for Dynamic and
    Magazine),    May  2001,    <www.linux-mag.com/2001-05/                Irregular Parallelism," Conference on High Performance Net-
    compile_06. html>.                                                     working and Computing, Proceedings of the 1998 ACM/IEEE
25. Richter, J., "New Windows 2000 Pooling Functions Greatly Sim-          Conference on Supercomputing, 1998, San Jose, CA.
    plify Thread Management," Microsoft Systems Journal, April 1999,   45. Rangaraju, K., "Unravel the Complexity of Thread Program-
    <www.microsoft.com/msj/0499/pooling/pooling.aspx>.                     ming," <www.fawcette.com/iavapro/2002_02/magazine/fea-
26. Benjamin, C, "The Fibers of Threads," Compile Time (Linux              tures/krangaraju/>.
    Magazine),    May      2001,    <www.linux-mag.com/2001-05/        46. "Threads Index," The Open Group Base Specifications, Issue 6,
    compile_06.html>.                                                      2003,        <www.opengroup.org/onlinepubs/007904975/idx/
27. Benjamin, C, "The Fibers of Threads," Compile Time (Linux              threads.html>.
    Magazine),    May     2001,     <www.linux-mag.com/2001-05/        47. Drepper, U, and I. Molnar, "The Native POSIX Thread Library
    compile_06.html>.                                                      for Linux," January 30, 2003, <people.redhat.com/drepper/
28. "Multithreading in the Solaris Operating Environment. A Tech-          nptl-design.pdf>.
    nical White Paper," Sun Microsystems, 2002.                        48. "Multithreaded Programming Guide," Sun Microsystems, May
29. "I've Got Work To Do—Worker Threads and Work Queues," AT               2002, pp. 11,175.
    Insider, Vol. 5, No. 5, October 1998 (updated August 20, 2002),    49. Walton, S., "Linux Threads Frequently Asked Questions," Janu-
    <www.osronline.com/article.cfm?id=65>.                                 ary 21,1997, <www.tldp.org/FAQ/Threads-FAQ/>.
30. "System Worker Threads," MSDN Library, June 6, 2003.               50. Drepper, U, and I. Molnar, "The Native POSIX Thread Library
    <msdn.microsoft.com/en-us/kmarch/hh/kmarch/                            for Linux." January 30, 2003, <people.redhat.com/drepper/
    synchro_9ylz.asp>.                                                     nptl-design.pdf>.
31. McCracken, D., "POSIX Threads and the Linux Kernel," Pro-          51. "Processes       and       Threads,"  MSDN          Library,
    ceedings of the Ottawa Linux Symposium 2002, p. 335.                   <msdn.microsoft.com/library/en-us/dllproc/base/
32. Troan, E., "A Look at the Signal API," Linux Magazine, January         about_processes_and_threads.asp>.
    2000, <www.linux-mag.com/2000-01/compile_01.html>.                 52. "About Processes and Threads," MSDN Library, February 2003,
33. Drepper, Ulrich, "Requirements of the POSIX Signal Model,"             <msdn.microsoft.com/library/en-us/dllproc/base/
    modified May 17,2003, <people.redhat.com/drepper/posix-                about_processes_and_threads.asp>.
    signal-model.xml>.                                                 53. "Fibers," MSDN Library, February 2003, <msdn.microsoft.com/
34. "Multithreading in the Solaris Operating Environment, A Tech-           library/en-us/dllproc/base/fibers.asp>.
    nical White Paper," Sun Microsystems, 2002.                        54. "Convert Thread To Fiber," MSDN Library, February 2003,
35. "Multithreading in the Solaris Operating Environment, A Tech-          <msdn.microsoft.com/library/en-us/dllproc/base/con-
    nical White Paper," Sun Microsystems, 2002.                            vertthreadtofiber.asp>.

<!-- pág. 241 -->

                                                                                                                 Works Cited 183
55. "Fibers,"       MSDN     Library,       February         2003,        Management of Parallelism," ACM Transactions on Computer
    <msdn.microsoft.com/library/en-us/dllproc/base/                       Systems, Vol. 10, No. 1, February 1992, p. 54.
    fibers.asp>.                                                      63. Benjamin, C, "The Fibers of Threads," Compile Time (Linux
56. "Thread      Pooling," MSDN     Library    February       2003        Magazine),   May   2001,    <www.linux-mag.com/2001-05/
    <msdn.microsoft.com/library/en-us/dllproc/base/                       compile_06.html>.
    thread_pooling.asp>.                                              64. "Multithreading in the Solaris Operating Environment, A Tech-
57. "Queue User Worker Item," MSDN Library, February 2003,                nical White Paper," Sun Microsystems, 2002.
    <msdn.microsoft.com/library/en-us/dllproc/base/                   65. Blelloch, G. E., and G J. Narlikar, "Pthreads for Dynamic and
    queueuserworkitem.asp>.                                               Irregular Parallelism," Conference on High Performance Net-
58. Richter, J., "New Windows 2000 Pooling Functions Greatly Sim-         working and Computing, Proceedings of the 1998 ACM/IEEE
    plify Thread Management," Microsoft Systems Journal, April            Conference on Supercomputing, 1998, San Jose, CA.
    1999,            <www.microsoft.com/msj/0499/pooling/pool-        66. Butenhof, David R., Programming with POSIX Threads, Boston,
    ing.aspx>.                                                            MA: Addison-Wesley, 1997: pp. 143-144.
59. "Win_32      Thread,"     MSDN       Library,  July    2003,      67. Kleiman, S.; D. Shah; and B. Smaalders, Programming with
    <msdn.microsoft.com/library/en-us/wmisdk/wmi/                         Threads, Prentice Hall PTR, 1997.
    win32_thread.asp>.                                                68. Birrell, A. D, An Introduction to Programming with Threads.
60. Solomon, D., and M. Russinovich, Inside Windows 2000, 3d ed.,         Technical Report 35, Digital Equipment Corporation, Systems
    Redmond: Microsoft Press, 2000, pp. 348-349.                          Research Center, Palo Alto, CA, 1989.
61. Sun Microsystems, "Lightweight Processes," SunOS System Ser-      69. Ousterhout, J., "Why threads are a bad idea (for most pur-
    vice Overview, Mountain View, CA: Sun Microsystems, Decem-            poses)." In USENIX Technical Conference (Invited Talk), Austin,
    ber 1987, pp. 143-174.                                                TX, January 1996.
62. Anderson, T. E.; B. N. Bershad; E. D. Lazowska; and H. M. Levy,
    "Scheduler Activations: Effective Kernel Support for User-Level

<!-- pág. 242 -->

Do not put me to't, For I am nothing if not critical.
      —William Shakespeare—


A person with one watch knows what time it is; a person with two watches is never sure.
      —Proverb—

Bury leisure.
      —Johann Elias Schlegel—


A really busy person never knows how much he weighs.
      —Edgar Watson Howe—


Delays breed dangers.
      —John Lyly—


By delaying he preserved the state.
      —Quintus Ennius—

