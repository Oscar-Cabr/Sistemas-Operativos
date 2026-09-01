# Chapter 8 - Processor Scheduling

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 390–429 (numeración del PDF)

<!-- pág. 390 -->

Chapter 8


Processor Scheduling
 Objectives
 After reading this chapter, you should understand:
 • the goals of processor scheduling.
 • preemptive vs. nonpreemptive scheduling.
 • the role of priorities in scheduling.
 • scheduling criteria.
 • common scheduling algorithms.
 • the notions of deadline scheduling and real-time scheduling.
 • Java thread scheduling.

<!-- pág. 391 -->

                             Chapter Outline
                    8.1                                   8.7.2 Round-Robin (RR) Scheduling
              Introduction                                 8.7.3 Shortest-Process-First (SPF)
                                                                        Scheduling
                    8.2                                    8.7.4 Highest-Response-Ratio-Next
           Scheduling levels                                       (HRRN) Scheduling
                                                         8.7.5 Shortest-Remaining-Time (SRT)
                  8.3                                                   Scheduling
   Preemptive vs. Nonpreemtpive                              8.7.6 Multilevel Feedback Queues
              Scheduling                                       8.7.7 Fair Share Scheduling
  Operating Systems Thinking: Overhead

                   8.4                                                   8.8
                Priorities                                      Deadline    Scheduling
                                                         Operating Systems Thinking: Intensity
                  8.5                                       of Resource Management vs. Relative
        Scheduling Objectives                                         Resource Value
      Operating Systems Thinking:
                Predictability
  Operating Systems Thinking: Fairness                                     8.9
                                                               Real-Time Scheduling
                 8.6                                     Mini Case Study: Real-Time Operating
          Scheduling Criteria                                          Systems

                     8.7
         Scheduling Algorithms                                         8.10
  8.7.1 First-In-First-Out (FIFO) Scheduling                  Java Thread Scheduling




      Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works C i t e d




334

<!-- pág. 392 -->

                                                                                                  8.1 Introduction 335

8.1 Introduction
We have discussed how multiprogramming enables an operating system to use its
resources more efficiently. When a system has a choice of processes to execute, it
must have a strategy —called a processor scheduling policy (or discipline) —for
deciding which process to run at a given time. A scheduling policy should attempt to
satisfy certain performance criteria, such as maximizing the number of processes
that complete per unit time (i.e., throughput), minimizing the time each process
waits before executing (i.e., latency), preventing indefinite postponement of pro-
cesses, ensuring that each process completes before its stated deadline, or maximiz-
ing processor utilization. Some of these goals, such as maximizing processor
utilization and throughput, are complementary; others conflict with one another —a
system that ensures that processes will complete before their deadlines may not
 achieve the highest throughput, fn this chapter, we discuss the problems of deter-
mining when processors should be assigned, and to which processes. Although we
focus on processes, many of the topics we describe apply to jobs and threads as well.

Self Review
1. When might a system that ensures that processes will complete before their deadlines not
   achieve the highest throughput?
2. Which performance criterion is the most important in an operating system? Why is this a
   hard question to answer?
Ans: 1) This occurs, for example, when several short processes are delayed while the system
dispatches a long process that must meets its deadline. 2) No one performance criterion is more
 important than the others for every operating system. It depends on the goals of the system.
For example, in real-time systems, giving processes and threads immediate, predictable service
 is more important than high processor utilization. In supercomputers that perform lengthy cal-
culations, processor utilization is typically more important than minimizing latency.



8.2 Scheduling levels
In this section we consider three levels of scheduling (Fig. 8.1). High-level schedul-
ing—also called job scheduling or long-term scheduling—determines which jobs
the system allows to compete actively for system resources. This level is sometimes
called admission scheduling, because it determines which jobs gain admission to the
system. Once admitted, jobs are initiated and become processes or groups of pro-
cesses. The high-level scheduling policy dictates the degree of multiprogramming—
the total number of processes in a system at a given time. 1 Entry of too many pro-
cesses into the system can saturate the system's resources, leading to poor perfor-
mance. In this case, the high-level scheduling policy may decide to temporarily
prohibit new jobs from entering until other jobs complete.
      After the high-level scheduling policy has admitted a job (which may contain
one or more processes) to the system, the intermediate-level scheduling policy
determines which processes shall be allowed to compete for processors. This policy

<!-- pág. 393 -->

336 Processor Scheduling




                           Figure 8.1 | Scheduling levels.

                           responds to short-term fluctuations in system load. It temporarily suspends and
                           resumes processes to achieve smooth system operation and to help realize certain
                           systemwide performance goals. The intermediate-level scheduler acts as a buffer
                           between the admission of jobs to the system and the assignment of processors to the
                           processes representing these jobs.
                                A system's low-level scheduling policy determines which active process the
                           system will assign to a processor when one next becomes available. In many of
                           today's systems, the low- and intermediate-level schedulers are the only schedulers.

<!-- pág. 394 -->

                                                                     8.3 Preemptive vs. Nonpreemtpive Scheduling   337

  (In this case, job initiation is performed by the intermediate-level scheduler.) High-
 level schedulers are often limited to large mainframe systems that perform batch
processing.
       Low-level scheduling policies often assign a priority to each process, reflecting
its importance —the more important a process, the more likely the scheduling policy
 is to select it to execute next. We discuss priorities in Section 8.4, Priorities, and
 throughout this chapter. The low-level scheduler (also called the dispatcher) also
 assigns (i.e., dispatches) a processor to the selected process. The dispatcher operates
many times per second and must therefore reside in main memory at all times.
       In this chapter we discuss many low-level scheduling policies. We present each
in the context of certain scheduling objectives and criteria (which we discuss in
Section 8.5, Scheduling Objectives, and Section 8.6, Scheduling Criteria), and we
describe how they relate to one another. Coffman and Kleinrock discuss popular
scheduling policies and indicate how users who know which one the system
employs can actually achieve better performance by taking appropriate measures. 2
Ruschitzka and Fabry give a classification of scheduling algorithms, and they for-
malize the notion of priority.3

Self Review
1. How should the intermediate scheduler respond to fluctuations in system load?
2. Which level of scheduler should remain resident in main memory? Why?
Ans: 1) The intermediate scheduler can prohibit processes from proceeding to the low-level
scheduler when the system becomes overloaded and can allow these processes to proceed
when the system load returns to normal. 2) The low-level scheduler should remain resident in
main memory because it executes frequently, requiring it to respond quickly to reduce sched-
uling overhead.



8.3 Preemptive vs. Nonpreemtpive Scheduling
Scheduling disciplines are either preemptive or nonpreemptive. A scheduling disci-
pline is nonpreemptive if, once the system has assigned a processor to a process, the
system cannot remove that processor from that process. A scheduling discipline is
preemptive if the system can remove the processor from the process it is running.
Under a nonpreemptive scheduling discipline, each process, once given a processor,
runs to completion or until it voluntarily relinquishes its processor. Under a pre-
emptive scheduling discipline, the processor may execute a portion of a process's
code and then perform a context switch.
      Preemptive scheduling is useful in systems in which high-priority processes
require rapid response. In real-time systems (discussed in Section 8.9, Real-Time
Scheduling), for example, the consequences of not responding to an interrupt could
be catastrophic. 4, 5, 6, 7 In interactive timesharing systems, preemptive scheduling
helps guarantee acceptable user response times. Preemption is not without c o s t -
context switches incur overhead (see the Operating Systems Thinking feature,

<!-- pág. 395 -->

338   Processor    Scheduling

                                 Overhead). To make preemption effective, the system must maintain many pro-
                                 cesses in main memory, so that the next process is ready when a processor becomes
                                 available. As we will see in Chapter 10, Virtual Memory Organization, only a por-
                                 tion of each process typically is in main memory at any time; the less active portions
                                 typically reside on disk.
                                        In nonpreemptive systems, short processes can experience lengthy service
                                 delays while longer processes complete, but turnaround times are more predictable,
                                 because incoming high-priority processes cannot displace waiting processes.
                                 Because a nonpreemptive system cannot remove a process from a processor until it
                                 completes, errant programs that never complete (e.g., by entering an infinite loop)
                                 may never relinquish control of the system. Also, in a nonpreemptive system, exe-
                                 cuting unimportant processes can make important processes wait.
                                        To prevent users from monopolizing the system (either maliciously or acciden-
                                 tally), a preemptive system can take the processor away from a process. As discussed
                                 in Chapter 3, Process Concepts, this is typically implemented by setting an interrupt-
                                 ing clock or interval timer that periodically generates an interrupt, which allows the
                                 operating system to execute. Once a processor is assigned to a process, the process
                                 executes until it voluntarily releases its processor, or until the clock interrupt or some
                                 other interrupt occurs. The operating system may then decide whether the running
                                 process should continue or some other "next" process should execute.
                                        The interrupting clock helps guarantee reasonable response times to interac-
                                 tive users, prevents the system from getting hung up on a user in an infinite loop.




                  Operating Systems Thinking
      Overhead
      Ultimately, computer systems exist   head while maximizing the                become less of an issue. However,
      to run applications for users.       portion of the systems resources         designers should be aware of a
      Although operating systems cer-      that can be allocated to user            system's workload when consider-
      tainly perform important tasks,      applications. As we will see, over-      ing overhead. For example, a
      they consume valuable system         head can improve performance by          large overhead for a small load
      resources in doing so; that          improving resource utilization; it       may become relatively small
      resource consumption is said to be   can also reduce performance to           under a heavy load; a small over-
      overhead, because the resources      provide a higher level of protec-        head for a small load may become
      are not directly used by user        tion and security. As computer           relatively large under a heavy
      applications to perform useful       power continues to increase with         load.
      work. Operating systems design-      costs decreasing, the resource
      ers seek to minimize that over-      consumption lost to overhead can

<!-- pág. 396 -->

                                                                                                     8.4   Priorities   339

  and allows processes to respond to time-dependent events. Processes that need to
run periodically depend on the interrupting clock.
      In designing a preemptive scheduling mechanism, one must carefully consider
 the arbitrariness of priority schemes. It does not make sense to build a sophisticated
  mechanism to faithfully implement a priority preemption scheme when the priori-
 ties themselves are not meaningfully assigned.


Self R e v i e w
1. When is nonpreemptive scheduling more appropriate than preemptive scheduling?
2. Can a program that enters an infinite loop monopolize a preemptive system?
Ans: 1) Nonpreemptive scheduling provides predictable turnaround times, which is impor-
tant for batch processing systems that must provide users with accurate job-completion times.
2) This depends on the priority of the process and the scheduling policy. In general, a preemp-
  tive system containing a process executing an infinite loop will experience reduced through-
  put but will still be able to execute other processes periodically. A high-priority process that
enters an infinite loop, however, may execute indefinitely if all other processes in the system
 have a lower priority. In general, preemptive systems are less affected by such programs than
nonpreemptive systems. Operating systems typically deal with such situations by limiting the
  maximum time a process can use a processor.




8.4 Priorities
Schedulers often use priorities to determine how to schedule and dispatch pro-
cesses. Priorities may be statically assigned or may change dynamically. Priorities
quantify the relative importance of processes.
      Static priorities remain fixed, so static-priority-based mechanisms are rela-
tively easy to implement and incur relatively low overhead. Such mechanisms are
 not, however, responsive to changes in environment, even those that could increase
throughput and reduce latency.
      Dynamic priority mechanisms are responsive to change. For example, the sys-
tem may want to increase the priority of a process that holds a key resource needed
by a higher-priority process. After the first process relinquishes the resource, the
system lowers the priority, so that the higher-priority process may execute.
Dynamic priority schemes are more complex to implement and have greater over-
head than static schemes. Hopefully, the overhead is justified by the increased
responsiveness of the system.
      In multiuser systems, an operating system must provide reasonable service to
a large community of users but should also provide for situations in which a mem-
ber of the user community needs special treatment. A user with an important job
may be willing to pay a premium, i.e., to purchase priority, for a higher level of ser-
vice. This extra charge is merited because resources may need to be withdrawn from
other paying customers. If there were no extra charge, then all users would request
the higher level of service.

<!-- pág. 397 -->

340   Processor Scheduling

                             Self Review
                             1. Why is it worthwhile to incur the higher cost and increased overhead of a dynamic priority
                                mechanism?
                             2. Why would a dynamic scheduler choose to favor a low-priority process requesting an
                                underutilized resource?
                             Ans: 1) A carefully designed dynamic priority mechanism could yield a more responsive
                             system than would a static priority mechanism. 2) The underutilized resource is likely to be
                             available, allowing the low-priority process to complete and exit the system sooner than a
                             higher-priority process waiting for a saturated resource.



                             8.5 Scheduling Objectives
                             A system designer must consider a variety of factors when developing a scheduling
                             discipline, such as the type of system and the users' needs. For example, the schedul-
                             ing discipline for a real-time system should differ from that for an interactive desk-
                             top system; users expect different results from these kinds of systems. Depending
                             on the system, the user and designer might expect the scheduler to:
                                   • Maximize throughput. A scheduling discipline should attempt to service the
                                     maximum number of processes per unit time.
                                   • Maximize the number of interactive processes receiving "acceptable"
                                     response times.
                                   • Maximize resource utilization. The scheduling mechanisms should keep the
                                     resources of the system busy.
                                   • Avoid indefinite postponement. A process should not experience an
                                     unbounded wait time before or while receiving service.
                                   • Enforce priorities. If the system assigns priorities to processes, the schedul-
                                     ing mechanism should favor the higher-priority processes.
                                   • Minimize overhead. Interestingly, this is not generally considered to be one
                                     of the most important objectives. Overhead often results in wasted
                                     resources. But a certain portion of system resources effectively invested as
                                     overhead can greatly improve overall system performance.
                                   • Ensure predictability. By minimizing the statistical variance in process
                                     response times, a system can guarantee that processes will receive predictable
                                     service levels (see the Operating Systems Thinking feature, Predictability).
                                   A system can accomplish these goals in several ways. In some cases, the sched-
                             uler can prevent indefinite postponement of processes through aging—gradually
                             increasing a process's priority as the process waits for service. Eventually, its prior-
                             ity becomes high enough that the scheduler selects that process to run.
                                   The scheduler can increase throughput by favoring processes whose requests
                             can be satisfied quickly, or whose completion frees other processes to run. One such
                             strategy favors processes holding key resources. For example, a low-priority process
                             may be holding a key resource that is required by a higher-priority process. If the

<!-- pág. 398 -->

                                                                                          8.5    Scheduling Objectives 341

 resource is nonpreemptible, then the scheduler should give the low-priority process
more execution time than it ordinarily would receive, so that it will release the key
 resource sooner. This technique is called priority inversion, because the relative pri-
    -----es of the two processes are reversed so that the high-priority one will obtain the
    resource it requires to continue execution. Similarly, the scheduler may choose to
   favor a process that requests underutilized resources, because the system will be
   more likely to satisfy this process's requests in a shorter period of time.
     Many of these goals conflict with one another, making scheduling a complex
problem. For example, the best way to minimize response times is to have sufficient
 resources available whenever they are needed. The price for this strategy is that
  overall resource utilization will be poor. In real-time systems, fast, predictable
responses are crucial, and resource utilization is less important. In other types of
 systems, the economics often makes effective resource utilization imperative.
   Despite the differences in goals among systems, many scheduling disciplines
 exhibit similar properties:
    • Fairness. A scheduling discipline is fair if all similar processes are treated
      the same, and no process can suffer indefinite postponement due to sched-
      uling issues (see the Operating Systems Thinking feature, Fairness).
    • Predictability. A given process always should run in about the same
      amount of time under similar system loads.
    • Scalability. System performance should degrade gracefully (i.e., it should
      not immediately collapse) under heavy loads.




               Operating Systems Thinking
 Predictability
 Predictability is as important in         inclined to go through the light, a       for interactive users who demand
 your everyday life as it is in com-       potentially dangerous action.             prompt, consistent response times.
 puters. What would you do if you                 Similarly, you have a sense of     Predictability is also important for
 stopped for a red traffic light, and      how long common tasks should              real-time jobs, where human lives
 the light stayed red for a long           take to perform on your computer.         may be at stake (we discuss real-
 time, much longer than any red            It is challenging for operating sys-      time scheduling in Section 8.9,
 light delay you had ever experi-          terns to ensure predictability, espe-     Real-Time Scheduling). We discuss
 enced. You would probably                 daily given that the load on a            predictability issues throughout
 become annoyed and fidgety, and           system can vary considerably based        the book.
 after waiting for what you                on the system load and the nature
 thought was a reasonable                  of the tasks being performed. Pre-
 amount of time; you might be              dictability is especially important

<!-- pág. 399 -->

342    Processor     Scheduling

                                     Self Review
                                     1. How do the goals of reducing the variance in response times and enforcing priorities con-
                                        flict?
                                     2. Is scheduling overhead always "wasteful"?
                                     Ans: 1) In preemptive systems, high-priority processes can preempt lower-priority ones ai
                                     any time, thereby increasing the variance in response times. 2) No, the overhead incurred bj
                                     effective scheduling operations can increase resource utilization.


                                     8.6 Scheduling Criteria
                                     To realize a system's scheduling objectives, the scheduler should consider process
                                     behavior. A processor-bound process tends to use all the processor time that the
                                     system allocates for it. An I/O-bound process tends to use the processor only briefly
                                     before generating an I/O request and relinquishing it. Processor-bound processes
                                     spend most of their time using the processor; I/O-bound processes spend most of
                                     their time waiting for external resources (e.g., printers, disk drives, network connec-
                                     tions, etc.) to service their requests, and only nominal time using processors.
                                           A scheduling discipline might also consider whether a process is batch or
                                     interactive. A batch process contains work for the system to perform without inter-
                                     acting with the user. An interactive process requires frequent inputs from the user.
                                     The system should provide good response times to an interactive process, whereas a
                                     batch process generally can suffer reasonable delays. Similarly, a scheduling disci-
                                     pline should be sensitive to the urgency of a process. An overnight batch process




                    Operating Systems Thinking
      Fairness
      How many times have you                    strategies that yield good perfor-       Operating systems must keep fair-
      expressed annoyance saying,                mance for most users, processes,         ness in mind, but always in the
      "That's not fair!" You have proba-         threads, I/O requests and the like,      context of other considerations.
      bly heard the expression, "Life is         but do so at the expense of other        Fairness issues are particularly
      not fair." We all know what fair-          users, processes, threads and I/O        important in designing resource
      ness is and most people would              requests that wind up being mis-         scheduling strategies, as we will
      agree that it is a "good t h i n g " but   treated. "That's not fair," you say,     see when we investigate proces-
      not universally achieved. We dis-          yet it is hard to ignore how these       sor scheduling in this chapter and
      cuss fairness issues in many chap-         strategies achieve the system's          disk scheduling in Chapter 12,
      ters throughout this book. We              objectives, such as improving            Disk Performance Optimization.
      will see priority-based scheduling         overall system performance.

<!-- pág. 400 -->

                                                                                            8.6   Scheduling Criteria 343

does not require immediate responses. A real-time process control system that
monitors a gasoline refinery must be responsive, possibly to prevent an explosion.
       When the second edition of this book was published, users interacted with
 processes by issuing trivial requests using a keyboard. In this environment, a sched-
uler could favor an interactive process with little effect on other processes, because
the time required to service interactive processes (e.g., by displaying text) was nom-
 inal. AS computers became more powerful, system designers and application pro-
 grammers included features such as graphics and GUIs to improve user-
friendliness. Although some systems still use text-based interfaces, most of today's
  users interact via GUIs, using a mouse to perform actions such as opening, resizing,
 dragging and closing windows. Users expect systems to respond quickly so that
these actions produce smooth movement. Unlike text display, this can be a compu-
tationally intensive task requiring the system to redraw the screen many times per
  second. Favoring these interactive processes can significantly reduce the level of
service provided to other processes in the system. In the case of a batch process, this
temporary reduction in service may be acceptable, though perhaps not for pro-
cesses that execute in real time (e.g., multimedia applications).
       In a system that employs priorities, the scheduler should favor processes with
higher priorities. Schedulers can base their decisions on how frequently a higher
priority process has preempted a lower-priority one. Under some disciplines, fre-
 quently preempted processes receive less favored treatment. This is because the
process's short runtime before preemption does not justify the overhead incurred
by a context switch each time the process is dispatched. One can argue to the con-
trary that such processes should receive more favored treatment to make up for
previous "mistreatment."
       Preemptive scheduling policies often maintain information about how much
real execution time each process has received. Some designers believe a process
that has received little execution time should be favored. Others believe a process
that has received much execution time could be near completion and should be
favored to help it reach completion, free its resources for other processes to use and
exit the system as soon as possible. Similarly, a scheduler may maintain an estimate
  of how much time remains before a process completes. It is easy to prove that aver-
age waiting times can be minimized by running those processes first that require the
minimum runtime until completion. Unfortunately, a system rarely knows exactly
 how much more time each process needs to complete.



Self Review
1. Are interactive processes generally processor bound or I/O bound? How about batch
   processes?
2. The scheduler rarely knows exactly how much more time each process needs to complete.
   Consider a system that schedules processes based on this estimation. How can processes
   abuse this policy?

<!-- pág. 401 -->

344   Processor   Scheduling
                               Ans: 1) Interactive processes often wait for input from users, so they are generally I/O
                               bound, but an interactive process could certainly enter a phase during which it is primarily
                               processor bound. Batch processes do not interact with users and are often processor bound.
                               Batch processes that require frequent access to disk or other I/O devices are I/O bound.
                               2) Processes would tend to underestimate their times to completion to receive favored treat-
                               ment from the scheduler.



                               8.7 Scheduling Algorithms
                               In previous sections we discussed scheduling policies, which specify the goal of the
                               scheduler (e.g., maximizing throughput or enforcing priorities). In the subsections
                               that follow we discuss scheduling algorithms that determine at runtime which pro-
                               cess runs next. These algorithms decide when and for how long each process runs;
                               they make choices about preemptibility, priorities, running time, time-to-comple-
                               tion, fairness and other process characteristics. As we will see, some systems require
                               the use of a particular type of scheduler (e.g., real-time systems typically require
                               preemptive, priority-based schedulers). Others rely on process behavior when mak-
                               ing scheduler decisions (e.g., favoring I/O-bound processes).



                               8.7.1 First-In-First-Out (FIFO) Scheduling
                                Perhaps the simplest scheduling algorithm is first-in-first-out (FIFO), also called
                                first-come-first-served (FCFS) (Fig. 8.2). Processes are dispatched according to
                                their arrival time at the ready queue. FIFO is nonpreemptive — once a process has a
                                processor, the process runs to completion. FIFO is fair in that it schedules processes
                                according to their arrival times, so all processes are treated equally, but somewhat
                                unfair because long processes make short processes wait, and unimportant pro-
                                cesses make important processes wait. FIFO is not useful in scheduling interactive
                                processes because it cannot guarantee short response times.
                                       FIFO is rarely used as a master scheme in today's systems, but it is often found
                                within other schemes. For example, many scheduling schemes dispatch processes
                                according to priority, but processes with the same priority are dispatched in FIFO
                                order.




                                Figure 8.2 | First-in-first out scheduling.

<!-- pág. 402 -->

                                                                                            8.7 Scheduling Algorithms 345

Self Review
1. Can indefinite postponement occur in a system that uses a FIFO scheduler? Assume that
     all processes eventually run to completion (i.e., no process enters an infinite loop).
2. (T/F) FIFO scheduling is rarely found in today's systems.
Ans: 1) No, indefinite postponement cannot occur, because arriving processes must enter at
 the back of the queue, meaning they cannot prevent already waiting processes from execut-
 ing. 2) False. FIFO can be found within many of today's scheduling algorithms (e.g., priority-
   based schedulers that dispatch processes with the same priority in FIFO order).



8.7.2 Round-Robin (RR) Scheduling
In round-robin (RR) scheduling (Fig. 8.3), processes are dispatched FIFO but are
   given a limited amount of processor time called a time slice or a quantum.8 If a pro-
  cess does not complete before its quantum expires, the system preempts it and gives
   the processor to the next waiting process. The system then places the preempted
 process at the back of the ready queue. In Fig. 8.3, process P1 is dispatched to a pro-
cessor, where it executes either until completion, in which case it exits the system,
 or until its time slice expires, at which point it is preempted and placed at the tail of
   the ready queue. The scheduler then dispatches process P 2 .
       Round-robin is effective for interactive environments in which the system
  needs to guarantee reasonable response times. The system can minimize preemp-
    tion overhead through efficient context-switching mechanisms and by keeping wait-
   ing processes in main memory.
       Like FIFO, round-robin is commonly found within more sophisticated proces-
sor scheduling algorithms but is rarely the master scheme. As we will see through-
out this section, many more sophisticated scheduling algorithms degenerate to
either FIFO or round-robin when all processes have the same priority. For this rea-
son, FIFO and round-robin are two of the three scheduling algorithms required by
the POSIX specification for real-time systems (we discuss real-time scheduling in
Section 8.9, Real-Time Scheduling).9




Figure 8.3 | Round-robin Scheduling.

<!-- pág. 403 -->

346 Processor Scheduling

                           Selfish   Round-Robin
                           Kleinrock discussed a variant of round-robin called selfish round-robin (SRR) that
                           uses aging to gradually increase process priorities over time.10 In this scheme, as
                           each process enters the system, it first resides in a holding queue, where it ages until
                           the its priority reaches the level of processes in the active queue. At this point, it is
                           placed in the active queue and scheduled round-robin with other processes in the
                           queue. The scheduler dispatches only processes in the active queue, meaning that
                           older processes are favored over those that have just entered the system.
                                   In SRR. a process's priority increases at a rate a while in the holding queue,
                           and at a rate b, where b ≤ a , in the active queue. When b < a, processes in the hold­
                           ing queue age at a higher rate than those in the active queue, so they will eventually
                           enter the active queue and contend for the processor. Tuning the parameters a and
                           b impacts how a process's age affects average latency and throughput. For example,
                           as a becomes much larger than b, then processes that enter the system will spend lit­
                           tle, if any, time in the holding queue. If b << a, then processes spend an insignificant
                           amount of time in the holding queue, so SRR degenerates to round-robin. If b = a,
                           every process in the system ages at the same rate, so SRR degenerates to FIFO.
                           Exercise 8.23 investigates some properties of the SRR scheme.


                           Quantum Size
                           Determination of quantum size, q, is critical to the effective operation of a com­
                           puter system with preemptive scheduling.11 Should the quantum be large or small?
                           Should it be fixed or variable? Should it be the same for all processes, or should it
                           be determined separately for each process?
                                 First, let us consider the behavior of the system as the quantum gets either
                           extremely large or extremely small. As the quantum gets large, processes tend to
                           receive as much time as they need to complete, so the round-robin scheme degener­
                           ates to FIFO. As the quantum gets small, context-switching overhead dominates;
                           performance eventually degrades to the point that the system spends most of its
                           time context switching with little, if any, useful work accomplished.
                                 Just where between zero and infinity should the quantum be set? Consider the
                           following experiment. Suppose a circular dial is marked with values between q = 0
                           and q = c, where c is an extremely large value. We begin with the dial positioned at
                           zero. As we turn the dial, the quantum for the system increases. Assume that the
                           system is operational and there are many interactive processes. As we initially
                           rotate the dial, the quantum sizes are near zero, and the context-switching overhead
                           consumes most of the processor's cycles. The interactive users experience a sluggish
                           system with poor response times. As we increase the quantum, response times
                           improve. The percentage of processor consumed by overhead is small enough that
                           the processes receive some processor service, but response times are still not as fast
                           as each user might prefer.
                                 As we turn the dial more, response times continue to improve. Eventually, we
                           reach a quantum size for which most of the interactive processes receive promt

<!-- pág. 404 -->

                                                                                             8.7 Sceduling Algorithms 347

  responses from the system, but it is still not clear if the quantum setting is optimal.
 We turn the dial a bit further, and response times become slightly better. As we con-
  tinue to turn the dial, response times start to become sluggish again. The quantum,
 as it gets larger, eventually becomes large enough for each process to run to com-
   pletion upon receiving the processor. The scheduling is degenerating to FIFO, in
 which longer processes make shorter ones wait, and the average waiting time
 increases as the longer processes run to completion before yielding the processor.
       Consider the supposedly optimal value of the quantum that yielded good
  response times. It is a small fraction of a second. Just what does this quantum repre-
sent? It is large enough so that the vast majority of interactive requests require less
time than the duration of the quantum. When an interactive process begins execut-
 ing. it normally uses the processor only briefly—just long enough to generate an I/O
request, then block—at which point the process then yields the processor to the
next process. The quantum is larger than this compute-until-I/O time. Each time a
process obtains the processor, there is great likelihood that the process will run
 until it generates an I/O request. This maximizes I/O utilization and provides rela-
tively rapid response times for interactive processes. It does so with minimal impact
to processor-bound processes, which continue to get the lion's share of processor
  time because I/O-bound processes block soon after executing.
       Just what is the optimal quantum in actual seconds? Clearly, the size varies from
system to system and under different loads. It also varies from process to process, but
  our particular experiment is not geared to measuring differences in processes.
       In Linux, the default quantum assigned to a process is 100ms, but can vary from
 10 to 200ms, depending on process priority and behavior. High-priority and I/O-
bound processes receive a larger quantum than low-priority and processor-bound
processes.12 In Windows XP, the default quantum assigned to a process is an architec-
ture-specific value equalling 20ms on most systems. This value can vary depending on
whether the process executes in the foreground or background of the GUI. 13
       When all processes are processor bound, the additional overhead detracts
from system performance. However, even when only processor-bound processes
are active, preemption still is useful. For example, consider that processor-bound
processes could be controlling a real-time, mission critical system—it would be dev-
astating if a process entered an infinite loop or even a phase in which it demanded
more processor time than expected. More simply, many processor-bound systems
support occasional interactive processes, so preemption is needed to ensure that
arriving interactive processes receive good response times.

Self Review
1. Imagine turning the quantum dial for a system that contains only I/O-bound processes.
   After a point q = c, increasing the quantum value results in little, if any, change in system
   performance. What does point c represent, and why is there no change in system perfor-
   mance when q > c?
2. The text describes an optimal quantum value that enables each I/O-bound process to execute
   just long enough to generate an I/O request, then block. Why is this difficult to implement?

<!-- pág. 405 -->

348   Processor   Scheduling

                               Ans: 1) This point would be the longest period of computation between I/O requests for
                               any processes in the system. Increasing the value of q past c does not affect any processes.
                               because each process blocks before its quantum expires, so the processes cannot take advan-
                               tage of the additional processor time allocated to them. 2) In the general case, it is impossi-
                               ble to predict the path of execution a program will take, meaning that the system cannot
                               accurately determine when a process will generate I/O. Therefore, the optimal quantum size
                               is difficult to determine, because it is different for each process and can vary over time.


                               8.7.3     Shortest-Process-First         (SPF) Scheduling
                               Shortest-process-first (SPF) is a nonpreemptive scheduling discipline in which the
                               scheduler selects the waiting process with the smallest estimated run-time-to-com-
                               pletion. SPF reduces average waiting time over FIFO. 14 The waiting times, however,
                               have a larger variance (i.e., are more unpredictable) than FIFO, especially for large
                               processes.
                                      SPF favors short processes at the expense of longer ones. Many designers
                               advocate that the shorter the process, the better the service it should receive. Other
                               designers disagree, because this strategy does not incorporate priorities (as mea-
                               sured by the importance of a process). Interactive processes, in particular, tend to
                               be "shorter" than processor-bound processes, so this discipline would seem to still
                               provide good interactive response times. The problem is that it is nonpreemptive,
                               so, in general, arriving interactive processes will not receive prompt service.
                                     SPF selects processes for service in a manner ensuring the next one will com-
                               plete and leave the system as soon as possible. This tends to reduce the number of
                               waiting processes and also the number of processes waiting behind large processes.
                               As a result, SPF can minimize the average waiting time of processes as they pass
                               through the system.
                                     A key problem with SPF is that it requires precise knowledge of how long a
                               process will run, and this information usually is not available. Therefore, SPF must
                               rely on user- or system-supplied run-time estimates. In production environments
                               where the same processes run regularly, the system may be able to maintain reason-
                               able runtime heuristics. In development environments, however, the user rarely
                               knows how long a process will execute.
                                     Another problem with relying on user process duration estimates is that users
                               may supply small (perhaps inaccurate) estimates so that the system will give their
                               programs higher priority. However, the scheduler can be designed to remove this
                               temptation. For example, if a process runs longer than estimated, the system could
                               terminate it and reduce the priority of that user's other processes, even invoking
                               penalties. A second method is to run the process for the estimated time plus a small
                               percentage extra, then "shelve" it (i.e., preserve it in its current form) so that the
                               system may restart it at a later time.15
                                      SPF derives from a discipline called short job first (SJF), which might have
                               worked well scheduling jobs in factories but clearly is inappropriate for low-level
                               scheduling in operating systems. SPF, like FIFO, is nonpreemptive and thus not
                               suitable for environments in which reasonable response times must be guaranteed.

<!-- pág. 406 -->

                                                                                               8.7 Scheduling Algorithms 349

Self Review
1. Why is SPF more desirable than FIFO when system throughput is a primary system
   objective?
2. Why is SPF inappropriate for low-level scheduling in today's operating systems?
Ans: 1) SPF reduces average wait times, which increases throughput. 2) SPF does not pro-
vide processes with fast response times, which is essential in today's user-friendly, multipro-
 grammed, interactive systems.


8.7.4 Highest-Response-Ratio-Next (HRRN) Scheduling
Brinch Hansen developed the highest-response-ratio-next (HRRN) policy that cor-
rects some of the weaknesses in SPF, particularly the excessive bias against longer
processes and the excessive favoritism toward short processes. HRRN is a nonpre-
emptive scheduling discipline in which each process's priority is a function not only
 of its service time but also of its time spent waiting for service.16 Once a process
 obtains it, the process runs to completion. HRRN calculates dynamic priorities
 according to the formula



      Because the service time appears in the denominator, shorter processes
receive preference. However, because the waiting time appears in the numerator,
  longer processes that have been waiting will also be given favorable treatment. This
 technique is similar to aging and prevents the scheduler from indefinitely postpon-
 ing processes.

Self Review
1. (T/F) With HRRN scheduling, short processes are always scheduled before long ones.
2. Process P1 has declared a service time of 5 seconds and has been waiting for 20 seconds.
   Process P2 has declared a service time of 3 seconds and has been waiting for 9 seconds. If
   the system uses HRRN, which process will execute first?
Ans: 1) False. The longer a process waits, the more likely it will be scheduled before shorter
processes. 2) In this case, process P1 has a priority of 5 and P2 has a priority of 4, so the sys-
tem executes P1 first.


8.7.5 Shortest-Remaining-Time (SRT) Scheduling
Shortest-remaining-time (SRT) scheduling is the preemptive counterpart of SPF that
 attempts to increase throughput by servicing small arriving processes. SRT was effec-
tive for job-processing systems that received a stream of incoming jobs, but it is no
longer useful in most of today's operating systems. In SRT, the scheduler selects the
process with the smallest estimated run-time-to-completion. In SPF, once a process
begins executing, it runs to completion. In SRT, a newly arriving process with a shorter
estimated run-time preempts a running process with a longer run-time-to-completion.
Again, SRT requires estimates of future process behavior to be effective, and the
designer must account for potential user abuse of this system scheduling strategy.

<!-- pág. 407 -->

350 Processor Scheduling

                                 The algorithm must maintain information about the elapsed service time of
                           the running process and perform occasional preemptions. Newly arriving processes
                           with short run-times execute almost immediately. Longer processes, however, have
                           an even longer mean waiting time and variance of waiting times than in SPF. These
                           factors contribute to a larger overhead in SRT than SPF.
                                 The SRT algorithm offers minimum wait times in theory, but in certain situa-
                           tions, due to preemption overhead, SPF might perform better. For example, con-
                           sider a system in which a running process is almost complete and a new process with
                           a small estimated service time arrives. Should the running process be preempted?
                           The SRT discipline would perform the preemption, but this may not be the optimal
                           choice. One solution is to guarantee that a running process is no longer preemptible
                           when its remaining run time reaches a low-end threshold.
                                 A similar problem arises when a newly arriving process requires slightly less
                           time to complete than the running process. Although the algorithm would correctly
                           preempt the running process, this may not be the optimal policy. For example, if the
                           preemption overhead is greater than the difference in service times between the
                           two processes, preemption results in poorer performance.
                                 As these examples illustrate, the operating systems designer must carefully
                           weigh the overhead of resource-management mechanisms against the anticipated
                           benefits. Also we see that relatively simple scheduling policies can yield poor per-
                           formance for subtle reasons.

                           Self Review
                           1. Is SRT an effective processor scheduling algorithm for interactive systems?
                           2. Why is SRT an ineffective scheduling algorithm for real-time processes?
                           Ans: 1) At first glance, SRT may seem to be an effective algorithm for interactive processes
                           if the tasks performed before issuing I/O are short in duration. However, SRT determines
                           priority based on the run-time-to-completion, not the run-time-to-I/O. Some interactive pro-
                           cesses, such as a shell, execute for the lifetime of the session, which would place the shell at
                           the lowest priority level. 2) SRT can result in a large variance of response times, whereas
                           real-time processes require a small variance in response times to ensure that they will always
                           complete their tasks within a particular period of time.


                           8.7.6 Multilevel Feedback Queues
                           When a process obtains a processor, especially when the process has not as yet had a
                           chance to establish a behavior pattern (e.g., how long it typically runs before generat-
                           ing an I/O request, or which portions of memory the process is currently favoring), the
                           scheduler cannot determine the precise amount of processor time the process will
                           require. I/O-bound processes normally use the processor only briefly before generat-
                           ing an I/O request. Processor-bound processes might use the processor for hours at a
                           time if the system makes it available on a nonpreemptible basis. A scheduling algo-
                           rithm should typically favor short processes, favor I/O-bound processes to get good I/O
                           device utilization and good interactive response times and should determine the
                           nature of a process as quickly as possible and schedule the process accordingly.

<!-- pág. 408 -->

                                                                                      8.7 Scheduling Algorithms 351
      Multilevel feedback queues (Fig. 8.4) help accomplish these goals.17 A new pro-
cess enters the queuing network at the tail of the highest queue. The process
progresses through that queue in FIFO order until the process obtains a processor. If
the process completes its execution, or if it relinquishes the processor to wait for I/O
completion or the completion of some other event, exits the queuing network. If a
process's quantum expires before the process voluntarily relinquishes the processor,
the system places the process at the tail of the next lower-level queue. As long as the
process uses the full quantum provided at each level, it continues to move to the tail
 of the next lower queue. Usually there is some bottom-level queue through which the




Figure 8.4 | Multilevel feedback queues.

<!-- pág. 409 -->

352   Processor   Scheduling

                               process circulates round-robin until it completes. The process that next gets a proces-
                               sor is the one at the head of the highest nonempty queue in the multilevel feedback
                               queue. A running process is preempted by one arriving in a higher queue.
                                      In this system, a process in a lower queue can suffer indefinite postponement,
                               if a higher queue always contains at least one process. This can occur in systems that
                               have a high rate of incoming processes to be serviced, or in which there are several
                               I/O-bound processes consuming their quanta.
                                      In many multilevel feedback schemes, the scheduler increases a process's
                               quantum size as the process moves to each lower-level queue. Thus, the longer a
                               process has been in the queuing network, the larger the quantum it receives each
                               time it obtains the processor. We will soon see why this is appropriate.
                                      Let us examine the treatment that processes receive by considering how this
                               discipline responds to different process types. Multilevel feedback queues favor I/O-
                               bound processes and other processes that need only small bursts of processor time,
                               because they enter the network with high priority and obtain a processor quickly. The
                               discipline chooses for the first queue a quantum large enough so that the vast major-
                               ity of I/O-bound processes (and interactive processes) issue an I/O request before
                               that quantum expires. When a process requests I/O, it leaves the queuing network,
                               having received the desired favored treatment. The process reenters the network
                               when it next becomes ready.
                                      Now consider a processor-bound process. The process enters the network with
                               high priority, and the system places it in the highest-level queue. At this point the
                               queuing network does not "know" whether the process is processor bound or I/O
                               bound—the network's goal is to decide this quickly. The process obtains the proces-
                               sor quickly, uses its full quantum, its quantum expires, and the scheduler moves the
                               process to the next lower queue. Now the process has a lower priority, and incoming
                               processes obtain the processor first. This means that interactive processes will still
                               continue to receive good response times, even as many processor-bound processes
                               sink lower in the queuing network. Eventually, the processor-bound process does
                               obtain the processor, receives a larger quantum than in the highest queue and again
                               uses its full quantum. The scheduler then places the process at the tail of the next-
                               lower queue. The process continues moving to lower queues, waits longer between
                               time slices and uses its full quantum each time it gets the processor (unless pre-
                               empted by an arriving process). Eventually, the processor-bound process arrives at
                               the lowest-level queue, where it circulates round-robin with other processor-bound
                               processes until it completes.
                                     Multilevel feedback queues are therefore ideal for separating processes into
                               categories based on their need for the processor. When a process exits the queuing
                               network, it can be "stamped" with the identity of the lowest-level queue in which it
                               resided. When the process reenters the queuing network, the system can place it
                               directly in the queue in which it last completed operation—the scheduler here is
                               employing the heuristic that a process's recent-past behavior is a good indicator of
                               its near-future behavior. This technique allows the scheduler to avoid placing a

<!-- pág. 410 -->

                                                                                           8.7   Scheduling Algorithms 353

returning processor-bound process into the higher-level queues, where it would
 interfere with service to high-priority short processes or to I/O-bound processes.
      Unfortunately, if the scheduler always places a returning process in the lowest
queue it occupied the last time it was in the system, the scheduler is unable to
respond to changes in a process's behavior (e.g., the process may be transitioning
from being processor bound to being I/O bound). The scheduler can solve this
problem by recording not only the identity of the lowest-level queue in which the
process resided, but also the amount of its quantum that was unused during its last
execution. If the process consumes its entire quantum, then it is placed in a lower-
 level queue (if one is available). If the process issues an I/O request before its quan-
tum expires, it can be placed in a higher-level queue. If the process is entering a new
phase in which it will change from being processor bound to I/O bound, initially it
may experience some sluggishness as the system determines that its nature is chang-
ing, but the scheduling algorithm will respond to this change.
       Another way to make the system responsive to changes in a process's behav-
 ior is to allow the process to move up one level in the feedback queuing network
each time it voluntarily relinquishes the processor before its quantum expires. Simi-
larly, the scheduler—when assigning a priority—can consider the time a process has
spent waiting for service. The scheduler can age the process by promoting it and
placing it in the next higher queue after it has spent a certain amount of time wait-
ing for service.
       One common variation of the multilevel feedback queuing mechanism is to
have a process circulate round-robin several times through each queue before it
moves to the next lower queue. Also, the number of cycles through each queue may
be increased as the process moves to the next lower queue. This variation attempts
to further refine the service that the scheduler provides to I/O-bound versus proces-
sor-bound processes.
       Multilevel feedback queuing is a good example of an adaptive mechanism,
i.e., one that responds to the changing behavior of the system it controls.18, 19 Adap-
tive mechanisms generally require more overhead than nonadaptive ones, but the
resulting sensitivity to changes in the system makes the system more responsive and
helps justify the increased overhead. As we discuss in Section 20.5.2, Process Sched-
uling, the Linux process scheduler employs an adaptive mechanism borrowing from
multilevel feedback queues. [Note: In the literature, the terms "process scheduling"
and "processor scheduling" have been used equivalently]

Self Review
1. What scheduling objectives should be evaluated when choosing the number of levels to
   use in a multilevel feedback queue?
2. Why are adaptive mechanisms desirable in today's schedulers?
Ans: 1) One major objective is the variance in response times. Increasing the number of
levels can cause processor-bound processes to wait longer, which increases the variance in
response times. Another objective to consider is resource utilization. As the number of levels

<!-- pág. 411 -->

354 Processor Scheduling
                           increases, many processes can execute and issue I/Os before their quanta expire, resulting in
                           effective use of both processor time and I/O devices. 2) In today's computers, many applica-
                           tions can be both computationally intensive and I/O bound. For example, a streaming video
                           player must perform I/O to retrieve video clip data from a remote server, then must perform
                           computationally intensive operations to decode and display the video images. Similarly, an
                           interactive game such as a flight simulator must respond to user input (e.g., joystick move-
                           ments) while rendering complicated 3D scenes. Adaptive mechanisms enable the system to
                           provide alternate responses to these processes as they alternate between I/O-bound and pro-
                           cessor-bound behavior.



                           8.7.7 Fair Share Scheduling
                           Systems generally support various sets of related processes. For example, UNIX (and
                           other multiuser) systems group processes that belong to an individual user. Fair share
                           scheduling (FSS) supports scheduling across such sets of processes.20, 21, 22, 23 Fair
                           share scheduling enables a system to ensure fairness across groups of processes by
                           restricting each group to a certain subset of the system resources. In the UNIX envi-
                           ronment, for example, FSS was developed specifically to "give a pre-specified rate of
                           system resources ... to a related set of users."24
                                  Let us consider an example in which fair share scheduling would be useful.
                           Imagine a research group whose members all share one multiuser system. They are
                           divided into two groups. The principal investigators —of which there are few—use
                           the system to perform important, computationally intensive work such as running
                           simulations. The research assistants—of which there are many—use the system for
                           less intensive work such as aggregating data and printing results. Now imagine that
                           many research assistants and only one principal investigator are using the system.
                           The research assistants may consume a majority of the processor time, to the detri-
                           ment of the principal investigator, who must perform the more important work.
                           However, if the system allowed the research assistants group to use only 25 percent
                           of the processor time and allowed the principal investigators group to use 75 per-
                           cent, the principal investigator would not suffer such service degradation. In this
                           way, fair share scheduling ensures that the performance of a process is affected only
                           by the population of its process group, and not by the user population as a whole.
                                 Let us investigate how fair share scheduling operates in a UNIX system. Nor-
                           mally, UNIX considers resource-consumption rates across all processes (Fig. 8.5).
                           Under FSS, however, the system apportions the resources to various fair share
                           groups (Fig. 8.6). It distributes resources not used by one fair share group to other
                           fair share groups in proportion to their relative needs.
                                 UNIX commands establish fair share groups and associate specific users with
                           them. 25 For the purpose of this discussion, assume that UNIX uses a priority round-
                           robin process scheduler.26 Each process has a priority, and the scheduler associates
                           processes of a given priority with a priority queue for that value. The process sched-
                           uler selects the ready process at the head of the highest-priority queue. Processes

<!-- pág. 412 -->

                                                                                          8.7 Scheduling Algorithms 355




Figure 8.5 | Standard UNIX process scheduler. The scheduler grants the processor
to users, each of whom may have many processes. (Property of AT&T Archives.
Reprinted with permission f AT&T)27


within a given priority are scheduled round-robin. A process requiring further ser-
vice after being preempted receives a lower priority. Kernel priorities are high and
apply to processes executing in the kernel; user priorities are lower. Disk events
receive higher priority than terminal events. The scheduler assigns the user priority
 as the ratio of recent processor usage to elapsed real time; the lower the elapsed
time, the higher the priority.
      The fair share groups are prioritized by how close they are to achieving their
specified resource-utilization goals. Groups doing poorly receive higher priority;
groups doing well, lower priority.



Self Review
1. In FSS, why should groups that are not achieving their resource-utilization goals be given
   higher priority?
2. How does FSS differ from standard process scheduling disciplines?
Ans: 1) Processes that are using fewer resources than specified by their resource-utilization
goals are probably suffering from low levels of service. By increasing their priority, the sys-
tem ensures that these processes execute long enough to use their required resources. 2) FSS
apportions resources to groups of processes, whereas standard process schedulers allow all
processes to compete for all resources on an equal footing.

<!-- pág. 413 -->

356   Processor Scheduling




                             Figure 8.6 | Fair share scheduler. The fair share scheduler divides system resource
                             capacity into portions, which are then allocated by process schedulers assigned to
                             various fair share groups. (Property of AT&T Archives. Reprinted with permission of
                             AT&T)28

                             8.8 Deadline Scheduling
                             In deadline scheduling, certain processes are scheduled to be completed by a spe-
                             cific time or deadline. These processes may have high value if delivered on time and
                             little or no value otherwise.29, 30, 31
                                    Deadline scheduling is complex. First, the user must supply the precise
                             resource requirements in advance to ensure that the process is completed by its
                             deadline. Such information is rarely available. Second, the system should execute
                             the deadline process without severely degrading service to other users. Also, the
                             system must carefully plan its resource requirements through to the deadline. This
                             may be difficult, because new processes may arrive, making unpredictable demands.
                             Finally, if many deadline processes are active at once, scheduling could become
                             extremely complex.
                                    The intensive resource management that deadline scheduling requires may
                             generate substantial overhead (see the Operating Systems Thinking feature, Inten-
                             sity of Resource Management vs. Relative Resource Value). Net consumption of
                             system resources may be high, degrading service to other processes.

<!-- pág. 414 -->

                                                                                           8.9 Real-Time Scheduling 357

      As we will see in the next section, deadline scheduling is important to real-
time process scheduling. Dertouzos demonstrated that when all processes can meet
their deadlines regardless of the order in which they are executed, it is optimal to
schedule processes with the earliest deadlines first.32 However, when the system
becomes overloaded, the system must allocate significant processor time to the
scheduler to determine the proper order in which to execute processes so that they
meet their deadlines. Recent research focuses on the speed33-34 or number 35 of pro-
cessors the system must allocate to the scheduler so that deadlines are met.

Self Review
1. Why is it important for the user to specify in advance the resources a process needs?
2. Why is it difficult to meet a process's stated deadline?
Ans: 1) This allows the scheduler to ensure that resources will be available for the process
so that it can complete its task before its deadline. 2) New processes may arrive and place
unpredictable demands on the system that prevent it from meeting a process's deadline,
resources could fail, the process could dramatically change its behavior and so on.


8.9 Real-Time Scheduling
A primary objective of the scheduling algorithms that we presented in Section 8.7,
scheduling Algorithms, is to ensure high resource utilization. Processes that must
execute periodically (such as once a minute) require different scheduling algo-
rithms. For example, the unbounded wait times for SPF could be catastrophic for a
process that checks the temperature of a nuclear reactor. Similarly, a system using
SRT to schedule a process that plays a video clip could produce choppy playback.
Real-time scheduling meets the needs of processes that must produce correct out-
put by a certain time (i.e., that have a timing constraint).36 A real-time process may
divide its instructions into separate tasks, each of which must complete by a dead-




                Operating Systems Thinking
  Intensity of Resource Management vs. Relative Resource Value
   Operating systems manage hard-            the relative value of those               devices. The operating systems
  ware and software resources. A             resources, and to their scarcity          designer must be aware of trends
  recurring theme you will see               and intensity of use. For example,        that could affect the relative
  throughout this book is that the           the processor and high-speed              value of system resources and
  intensity w i t h which operating          cache memories are managed                people time and must respond
   systems need to manage particu-           much more intensively than sec-           quickly to change.
   lar resources is proportional to          ondary storage and other I/O

<!-- pág. 415 -->

358 Processor Scheduling
                                 line. Other real-time processes might perform a certain task periodically, such as
                                 updating the locations of planes in an air traffic control system. Real-time schedul-
                                 ers must ensure that timing constraints are met (see the Mini Case Study, Real-
                                 Time Operating Systems).
                                       Real-time scheduling disciplines are classified by how well they meet a pro-
                                 cess's deadlines. Soft real-time scheduling ensures that real-time processes are dis-
                                 patched before other processes in the system, but does not guarantee which, if any,
                                 will meet their timing constraints.37-38 Soft real-time scheduling is commonly imple-
                                 mented in personal computers, where smooth playback of multimedia is desirable,
                                 but occasional choppiness under heavy system loads is tolerated. Soft real-time sys-
                                 tems can benefit from high interrupting clock rates to prevent the system from get-
                                 ting "stuck" executing one process while others miss their deadlines. However, the




                  Mini Case Study
    Real-Time Operating Systems
    A real-time system differs from a      bomber attacks in the Cold War.42      It also uses message passing for
    standard system in that every          Implemented in the end of the          interprocess communication. 47
    operation must give results that       1950s, this system integrated 56       Similarly, VxWorks is a microker-
    are both correct and returned          IBM AN/FSQ-7 digital vacuum-           nel system that complies w i t h the
    within a certain amount of time. 3 9   tube computers that monitored          POSIX standard and is widely used
    Real-time systems are used in          data from radar systems across         in embedded systems.48 QNX per-
    time-critical applications such as     the country to track all planes in     forms better than VxWorks on
    monitoring sensors. They are           the United States airspace.43, 44 It   Intel x86 platforms, 49 but QNX
    often small, embedded systems.         analyzed this information and          was not available on other proces-
    Real-time operating systems            directed the interceptor fighter       sors until version 6.1 (the current
    (RTOSs) must be carefully              planes, thus requiring real-time       version is 6.2).50 VxWorks, how-
    designed to achieve these goals.       response.45 The operating system       ever, has concentrated on the
    (Real-time process scheduling is       to handle this task was the largest    PowerPC processor and has a his-
    discussed in Section 8.9, Real-Time    computer program of its time. 4 6      tory of cross-platform compatibil-
    Scheduling.)                                  In contrast, today's RTOSs      ity.51 VxWorks is currently the
         The control program for the       aim for minimal size. There are        most common RTOS for embed-
    SAGE (Semi-Automatic Ground            many available, but QNX and            ded systems.52 Additional RTOSs
    Environment) project may have          VxWorks lead the field. QNX            include Windows CE .NET,53 OS-
    been the first real-time operating     implements the POSIX standard          9, 54 OSE,55 and Linux distributions
    system.40, 41 SAGE was an Air Force    APIs w i t h its own microkernel and   such as uCLinux.56
    project to defend against possible     is tailored to embedded systems.

<!-- pág. 416 -->

                                                                                   8.9 Real-Time Scheduling 359
system can incur significant overhead if the interrupt rate is too high, resulting in
poor performance or missed deadlines.57
      Hard real-time scheduling guarantees that a process's timing constraints are
always met. Each task specified by a hard real-time process must complete before
its deadline; failing to do so could produce catastrophic results, including invalid
work, system failure or even harm to the system's users.58, 59 Hard real-time systems
may contain periodic processes that perform their computations at regular time
intervals (e.g., gathering air traffic control data every second) and asynchronous
processes that execute in response to events (e.g., responding to high temperatures
in a power plant's core). 60

Static Real-Time Scheduling Algorithms
Static real-time scheduling algorithms do not adjust process priority over time.
Because priorities are calculated only once, static real-time scheduling algorithms
tend to be simple and incur little overhead. Such algorithms are limited because
they cannot adjust to variable process behavior and depend on resources staying up
and running to ensure that timing constraints are met.
      Hard real-time systems tend to use static scheduling algorithms, because they
incur low overhead and it is relatively easy to prove that each process's timing con-
straints will be met. The rate-monotonic (RM) algorithm, for example, is a preemp-
tive, priority-based round-robin algorithm that increases a process's priority
linearly (i.e., monotonically) with the frequency (i.e., the rate) with which it must
execute. This static scheduling algorithm favors periodic processes that execute fre-
quently.61 The deadline rate-monotonic algorithm can be used when a periodic pro-
cess specifies a deadline that is not equal to its period.62


Dynamic Real-Time Scheduling Algorithms
Dynamic real-time scheduling algorithms schedule processes by adjusting their pri-
orities during execution, which can incur significant overhead. Some algorithms
attempt to minimize the scheduling overhead by assigning static priorities to some
processes and dynamic priorities to others. 63
      Earliest-deadline-first (EDF) is a preemptive scheduling algorithm that dis-
patches the process with the earliest deadline. If an arriving process has an earlier
deadline than the running process, the system preempts the running process and
dispatches the arriving process. The objective is to maximize throughput by satisfy-
ing the deadlines of the largest number of processes per unit time (analogous to the
SRT algorithm) and minimize the average wait time (which prevents short pro-
cesses from missing their deadlines while long processes execute). Dertouzos
proved that, if a system provides hardware preemption (e.g., timer interrupts) and
the real-time processes being scheduled are not interdependent, EDF minimizes
the amount of time by which the "most tardy" process misses its deadline. 64 How-
ever, many real-time systems do not provide hardware preemption, so other algo-
rithms must be employed.65

<!-- pág. 417 -->

360   Processor   Scheduling

                                     The minimum-laxity-first algorithm is similar to EDF but bases priority on a
                               process's laxity. Laxity is a measure of a process's importance based on the amount
                               of time until its deadline and the remaining execution time until its task (which may
                               be periodic) has completed. Laxity is computed using the formula
                                      L = D - (T+C),
                               where L is the laxity, D the process's deadline, T the current time and C the pro-
                               cess's remaining execution time. For example, if the current time is 5, the deadline
                               for a process is 9 and the process requires 3 units of time to complete, the laxity is 1.
                               If a process has 0 laxity, it must be dispatched immediately or it will miss its dead-
                               line. Priorities in minimum-laxity-first are more accurate than those in EDF
                               because they are determined by including the remaining processor time each pro-
                               cess requires to complete its task. However, such information is often unavailable.66

                               Self Review
                               1. Why are most hard real-time scheduling algorithms static?
                               2. When does the minimum-laxity-first algorithm degenerate to EDF? Can this ever occur?
                               Ans: 1) Hard real-time systems must guarantee that processes' deadlines are met. Static
                               scheduling algorithms facilitate proving this property for a particular system and reduce the
                               implementation overhead. 2) The minimum-laxity-first algorithm degenerates to the EDF
                               algorithm when C is identical for all processes at any given time. It is possible, though highly
                               unlikely, that this would occur.


                               8.10 Java Thread Scheduling
                               As discussed in Section 4.6, Threading Models, operating systems provide various lev-
                               els of support for threads. When scheduling a multithreaded process that implements
                               user-level threads, the operating system is unaware that the process is multithreaded
                               and therefore dispatches the process as one unit, requiring a user-level library to
                               schedule its threads. If the system supports kernel-level threads, it may schedule each
                               thread independently from others within the same process. Still other systems support
                               scheduler activations that assign each process to a kernel-level thread that enables the
                               process's user-level library to perform scheduling operations.
                                     System designers must determine how to allocate quanta to threads, and in
                               what order and with what priorities to schedule threads within a process. For exam-
                               ple, a "fair-share" approach divides the quantum allocated to a process among its
                               threads. This prevents a multithreaded process from receiving high levels of service
                               simply by creating a large number of threads. Further, the order in which threads
                               are executed can impact their performance if they rely on one another to continue
                               their tasks. In this section, we present Java thread scheduling. Thread scheduling in
                               Windows XP is discussed in Section 21.6.2, Thread Scheduling. The Linux scheduler
                               (which dispatches both processes and threads) is discussed in Section 20.5.2, Pro-
                               cess Scheduling.

<!-- pág. 418 -->

                                                                                               8.10 Java Thread Scheduling 361

       One feature of the Java programming language and its virtual machine is that
every Java applet or application is multithreaded. Each Java thread is assigned a
priority in the range between Thread.MIN_PRIORITY (a constant of 1) and
Thread. MAX_PRIORITY (a constant of 10). By default, each thread is given priority
Thread. NORM_PRIORITY (a constant of 5). Each new thread inherits the priority of
the thread that creates it.
      Depending on the platform, Java implements threads in either user or kernel
space (see Section 4.6,Threading Models). 67 - 68 When implementing threads in user
space, the Java runtime relies on timeslicing to perform preemptive thread schedul-
 ing. Without timeslicing, each thread in a set of equal-priority threads runs to com-
pletion, unless it leaves the running state and enters the waiting, sleeping or blocked
state, or it is preempted by a higher-priority thread. With timeslicing, each thread
receives a quantum during which it can execute.
      The Java thread scheduler ensures that the highest-priority thread in the Java
virtual machine is running at all times. If there are multiple threads at the priority
level, those threads execute using round-robin. Figure 8.7 illustrates Java's multi-
level priority queue for threads. In the figure, assuming a single-processor com-
puter, threads A and B each execute for a quantum at a time in round-robin fashion
until both threads complete execution. Next, thread C runs to completion. Threads
D, E and F each execute for a quantum in round-robin fashion until they all com-
plete execution. This process continues until all threads run to completion. Note
that, depending on the operating system, arriving higher-priority threads could
indefinitely postpone the execution of lower-priority ones.
      A thread can call the y i e l d method of class Thread to give other threads a
chance to execute. Because the operating system preempts the current thread
whenever a higher-priority one becomes ready, a thread cannot yi el d to a higher-
priority thread. Similarly, y i e l d always allows the highest-priority ready thread to
run, so if all of the ready threads are of lower priority than the thread calling yi el d,
the current thread will have the highest priority and will continue executing. There-
fore, a thread yi el ds to give threads of an equal priority a chance to run. On a
timesliced system this is unnecessary, because threads of equal priority will each
execute for their quantum (or until they lose the processor for some other reason),
and other threads of equal priority will execute round-robin. Thus yi el d is appro-
priate for nontimesliced systems (e.g., early versions of Solaris69), in which a thread
would ordinarily run to completion before another thread of equal priority would
have an opportunity to run.



1. Why does Java provide the yi el d method? Why would a programmer ever use yield?
2. (T/F) A Java thread of lower priority will never run while a thread of higher priority is ready.
Ans: 1) Method yi el d allows the current thread to voluntarily release the processor and let
a thread of equal priority execute. Because Java applications are designed to be portable and
because the programmer cannot be certain that a particular platform supports timeslicing,

<!-- pág. 419 -->

362 Processor Scheduling




                                     Figure 8.7 | Java thread priority scheduling.

                                     programmers use y i e l d to ensure that their applications execute properly on all platforms.
                                     2) True. Java schedulers will execute the highest-priority ready thread.




Web Resources
www.linux-tutorial.info/cgi-bin/dis-                               www.oreilly.com/catalog/linuxkernel/chapter/
play.pl?85&0&0&0&3                                                 ch10.html
This portion of the Linux tutorial describes process scheduling    Contains the online version of O'Reilly's Linux kernel book
in Linux.                                                          This page details process scheduling in Linux version 2.4.
developer.apple.com/techpubs/mac/Processes/Pro-                    www.javaworld.com/javaworld/jw-07-2002/jw-0703-
cesses-16.html                                                     javal01.html
Describes process scheduling for the Apple Macintosh.              Describes thread scheduling in Java.

<!-- pág. 420 -->

                                                                                                          Summary         363
 csl.cse.ucsc.edu/rt.shtml                                       www.ittc.ku.edu/kurt/
 Mails the results of the real-time operating system scheduler   Describes the Kansas University real-time scheduler that uses
  search unit at the University of California, Santa Cruz.       a modified Linux kernel.



Summary
 When a system has a choice of processes to execute, it must     employs priorities, the scheduler should favor processes
 have a strategy—called a processor scheduling policy (or dis-   with higher priorities.
 cipline)—for deciding which process to run at a given time.            Schedulers employ algorithms that make choices
 High-level scheduling—sometimes called job scheduling or        about preemptibility, priorities, running time and other
 long-term scheduling—determines which jobs the system           process characteristics. FIFO (also called FCFS) is a non-
    allows to compete actively for system resources. The high-   preemptive algorithm that dispatches processes according
level scheduling policy dictates the degree of multiprogram-     to their arrival time at the ready queue. In round-robin
 ming—the total number of processes in a system at a given       (RR) scheduling, processes are dispatched FIFO but are
time. After the high-level scheduling policy has admitted a      given a limited amount of processor time called a time slice
 job (which may contain one or more processes) to the sys-       or a quantum. A variant of round-robin called selfish
tem, the intermediate-level scheduling policy determines         round-robin (SRR) initially places a process in a holding
 which processes shall be allowed to compete for a processor.    queue until its priority reaches the level of processes in the
 This policy responds to short-term fluctuations in system       active queue, at which point, the process is placed in the
   load. A system's low-level scheduling policy determines       active queue and scheduled round-robin with others in the
    which ready process the system will assign to a processor    queue. Determination of quantum size is critical to the
when one next becomes available. Low-level scheduling pol-       effective operation of a computer system. The "optimal"
icies often assign a priority to each process, reflecting its    quantum is large enough so that the vast majority of I/O-
 importance—the more important a process, the more likely        bound and interactive requests require less time than the
  the scheduling policy is to select it to execute next.         duration of the quantum. The optimal quantum size varies
        A scheduling discipline can be preemptive or nonpre-     from system to system and under different loads.
emptive. To prevent users from monopolizing the system                  Shortest-process-first (SPF) is a nonpreemptive
  (either maliciously or accidentally), preemptive schedulers    scheduling discipline in which the scheduler selects the
set an interrupting clock or interval timer that periodically    waiting process with the smallest estimated run-time-to-
generates an interrupt. Priorities may be statically assigned    completion. SPF reduces average waiting time over FIFO
  or be changed dynamically during the course of execution.      but increases the variance in response times. Shortest-
        When developing a scheduling discipline, a system        remaining-time (SRT) scheduling is the preemptive coun-
designer must consider a variety of objectives, such as the      terpart of SPF that selects the process with the smallest
type of system and the users' needs. These objectives may        estimated run-time-to-completion. The SRT algorithm
 include maximizing throughput, maximizing the number of         offers minimum wait times in theory, but in certain situa-
interactive users receiving "acceptable" response times,         tions, due to preemption overhead, SPF might actually per-
maximizing resource utilization, avoiding indefinite post-       form better. Highest-response-ratio-next (HRRN) is a
ponement, enforcing priorities, minimizing overhead and          nonpreemptive scheduling discipline in which the priority
ensuring predictability of response times. To accomplish         of each process is a function not only of its service time but
these goals, a system can use techniques such as aging pro-      also of the amount of time it has been waiting for service.
cesses and favoring processes whose requests can be satis-              Multilevel feedback queues allow a scheduler to
fied quickly. Many scheduling disciplines exhibit fairness,      dynamically adjust to process behavior. The process that gets
predictability and scalability.                                  a processor next is the one that reaches the head of the high-
        Operating system designers can use system objectives     est nonempty queue in the multilevel feedback queuing net-
to determine the criteria on which scheduling decisions are      work. Processor-bound processes are placed at the lowest-
made. Perhaps the most important concern is how a pro-           level queue, and I/O-bound processes tend to be located in
cess uses the processor (i.e., whether it is processor bound     the higher-level queues. A running process is preempted by a
or I/O bound). A scheduling discipline might also consider       process arriving in a higher queue. Multilevel feedback
whether a process is batch or interactive. In a system that      queuing is a good example of an adaptive mechanism.

<!-- pág. 421 -->

364 Processor Scheduling

        Fair share scheduling (FSS) supports scheduling           The earliest-deadline-first (EDF) is a preemptive schedul-
across related processes and threads. It enables a system to      ing algorithm that favors the process with the earliest dead-
ensure fairness across groups of processes by restricting         line. The minimum-laxity-first algorithm is similar to EDF.
each group to a certain subset of system resources. In the        but bases priority on a process's laxity, which measures the
UNIX environment, for example, FSS was developed spe-             difference between the time a process requires to complete
cifically to "give a prespecified rate of system resources ...    and the time remaining until that its deadline.
to a related set of users."                                              The operating system may dispatch a process's
        In deadline scheduling, certain processes are sched-      threads individually or it may schedule a multithreaded
uled to be completed by a specific time or deadline. These        process as a unit, requiring user-level libraries to schedule
processes may have high value if delivered on time and be         their threads. System designers must determine how to
worthless otherwise. Deadline scheduling can be difficult to      allocate quanta to threads, in what order, and what priori-
implement.                                                        ties to assign in scheduling threads within a process. In
        Real-time scheduling must repeatedly meet pro-            Java, each thread is assigned a priority in the range 1-10.
cesses' deadlines as they execute. Soft real-time scheduling      Depending on the platform, Java implements threads in
ensures that real-time processes are dispatched before            either user or kernel space (see Section 4.6, Threading
other processes in the system. Hard real-time scheduling          Models). When implementing threads in user space, the
guarantees that a process's deadlines are met. Hard real-         Java runtime relies on timeslicing to perform preemptive
time processes must meet their deadlines; failing to do so        thread scheduling. The Java thread scheduler ensures that
could be catastrophic, resulting in invalid work, system fail-    the highest-priority thread in the Java virtual machine is
ure or even harm to the system's users. The rate-monotonic        running at all times. If there are multiple threads at the
(RM) algorithm is a static scheduling priority-based round-       same priority level, those threads execute using round-
robin algorithm in which priorities are increase (monotoni-       robin. A thread can call the yield method to give other
cally) with the rate at which a process must be scheduled.        threads of an equal priority a chance to run.


Key Terms
adaptive mechanism—Control entity that adjusts a system in        earliest-deadline-first (EDF)—Scheduling policy that gives a
    response to its changing behavior.                                 processor to the process with the closest deadline.
admission scheduling—See high-level scheduling.                   fairness—Property of a scheduling algorithm that treats all
aging of priorities—Increasing a process's priority gradually,         processes equally.
    based on how long it has been in the system.                  fair share group—Group of processes that receives a percent-
asynchronous real-time process—Real-time process that exe-             age of the processor time under a fair share scheduling
    cutes in response to events.                                       (FSS) policy.
batch process—Process that executes without user interaction.     fair share scheduling (FSS)—Scheduling policy developed for
deadline rate-monotonic scheduling—Scheduling policy in                AT&T's UNIX system that places processes in groups and
    real-time systems that meets a periodic process's deadline         assigns these groups a percentage of processor time.
    that does not equal its period.                               first-in-first-out (FIFO)—Nonpreemptive scheduling policy
deadline scheduling—Scheduling policy that assigns priority             that dispatches processes according to their arrival time in
    based on processes' completion deadlines to ensure that             the ready queue.
    processes complete on time.                                   job scheduling—See high-level scheduling.
degree of multiprogramming—Total number of processes in           hard real-time scheduling—Scheduling policy that ensures
    main memory at a given time.                                      processes meet their deadlines.
dispatcher—Entity that assigns a processor to a process.          highest-response-ratio-next (HRRN)—Scheduling policy that
dispatching—Act of assigning a processor to a process.                assigns priority based on a process's service time and the
                                                                      amount of time the process has been waiting.
dynamic real-time scheduling algorithm—Scheduling algo-
    rithm that uses deadlines to assign priorities to processes   high-level scheduling—Determining which jobs a system
    throughout execution.                                             allows to compete actively for system resources.

<!-- pág. 422 -->

                                                                                                            Key      Terms     365

interactive process—Process that requires user input as it exe-   processor scheduling policy—Strategy used by a system to
    cutes.                                                            determine when and for how long to assign processors to
intermediate-level scheduling—Determining which processes             processes.
    may enter the low-level scheduler to compete for a pro-       purchase priority—to pay to receive higher priority in a sys-
    cessor.                                                           tem.
I/O-bound—Process that tends to use a processor for a short       quantum—Amount of time that a process is allowed to run on
    time before generating an I/O request and relinquishing a         a processor before the process is preempted.
    processor.                                                    rate-monotonic (RM) scheduling—Real-time scheduling pol-
latency (process scheduling)—Time a task spends in a system            icy that sets priority to a value that is proportional to the
    before it is serviced.                                             rate at which the process must be dispatched.
laxity—Value determined by subtracting the sum of the cur-        real-time scheduling—Scheduling policy that bases priority on
     rent time and a process's remaining execution time from           timing constraints.
     the process's deadline. This value decreases as a process    round-robin (RR) scheduling—Scheduling policy that permits
     nears its deadline.                                              each ready process to execute for at most one quantum
long-term scheduling—See high-level scheduling.                       per round. After the last process in the queue has exe-
                                                                      cuted once, the scheduler begins a new round by schedul-
low-level scheduling—Determining which process will gain
                                                                      ing the first process in the queue,
   control of a processor.
                                                                  scalability (scheduler) —Characteristic of a scheduler that
minimum-laxity-first—Scheduling policy that assigns higher
                                                                       ensures system performance degrades gracefully under
    priority to processes that will finish with minimal proces-
                                                                       heavy loads.
   sor usage.
                                                                  selfish round-robin (SRR) scheduling—Variant of round-robin
multilevel feedback queue—Process scheduling structure that
                                                                        scheduling in which processes age at different rates. Pro-
   groups processes of the same priority in the same round-
                                                                        cesses that enter the system are placed in a holding queue,
   robin queue. Processor-bound processes are placed in
                                                                        where they wait until their priority is high enough for
   lower-priority queues because they are typically batch
                                                                        them to be placed in the active queue, in which processes
   processes that do not require fast response times. I/O-
                                                                        compete for processor time.
   bound processes, which exit the system quickly due to I/O,
   remain in high-priority queues. These processes often cor-     shortest-process-first (SPF) scheduling—Nonpreemptive sched-
   respond to interactive processes that should experience            uling algorithm in which the scheduler selects a process
   fast response times.                                               with the smallest estimated run-time-to-completion and
                                                                      runs the process to completion.
nonpreemptive scheduling—Scheduling policy that does not
   allow the system to remove a processor from a process          shortest-remaining-time (SRT) scheduling—Preemptive ver-
   until that process voluntarily relinquishes its processor or       sion of SPF in which the scheduler selects a process with
   runs to completion.                                                the smallest estimated remaining run-time-to-completion.
periodic real-time process—Real-time process that performs        soft real-time scheduling—Scheduling policy that guarantees
    computation at a regular time interval.                            that real-time processes are scheduled with higher priority
predictability—Goal of a scheduling algorithm that ensures             than non-real-time processes.
    that a process takes the same amount of time to execute       static real-time scheduling algorithm—Scheduling algorithm
    regardless of the system load.                                     that uses timing constraints to assign fixed priorities to
preemptive scheduling—Scheduling policy that allows the sys-           processes before execution.
    tem to remove a processor from a process.                     throughput—Number of processes that complete per unit
priority—Measure of a process's or thread's importance used           time.
    to determine the order and duration of execution.
                                                                  time slice— See quantum.
processor-bound—Process that consumes its quantum when
    executing. These processes tend to be calculation inten-      timeslicing—Scheduling each process to execute for at most
    sive and issue few, if any, I/O requests.                         one quantum before preemption.

processor scheduling discipline—See processor scheduling          timing constraint—Time period during which a process (or
    policy.                                                           subset of a process's instructions) must complete.

<!-- pág. 423 -->

366 Processor Scheduling

Exercises
8.1    Distinguish among the following three levels of schedul-              iii. The system should admit processes to create a
ers.                                                                              mix that will keep most devices busy.
       a. high-level scheduler                                               iv. The system should favor important processes.
       b. intermediate-level scheduler                                       v.     An important process arrives but cannot proceed
       c. dispatcher                                                               because an unimportant process is holding the
8.2 Which level of scheduler should make a decision on each                        resources the important process needs.
of the following questions?                                                  vi. During peak periods, the system should not col-
       a. Which ready process should be assigned a processor                     lapse from the overhead it takes to manage a
          when one becomes available?                                            large number of processes.
       b. Which of a series of waiting batch processes that have             vii. The system should favor I/O-bound processes.
          been spooled to disk should next be initiated?                     viii. Context switches should execute as quickly as
       c. Which processes should be temporarily suspended to                       possible.
          relieve a short-term burden on the processor?             8.5   The following are common scheduling criteria.
       d. Which temporarily suspended process that is known               a. I/O boundedness of a process
          to be I/O bound should be activated to balance the              b. processor boundedness of a process
          multiprogramming mix?
                                                                          c. whether the process is batch or interactive
8.3 Distinguish between a scheduling policy and a schedul-
                                                                          d. urgency of a fast response
ing mechanism.
                                                                          e. process priority
8.4    The following are common scheduling objectives.
                                                                          f. frequency of a process is being preempted by higher-
       a. to be fair                                                         priority processes
       b. to maximize throughput                                          g. priorities of processes waiting for resources held by
       c. to maximize the number of interactive users receiv-                other processes
          ing acceptable response times                                   h. accumulated waiting time
       d. to be predictable                                               i. accumulated execution time
       e. to minimize overhead                                            j . estimated run-time-to-completion.
       f. to balance resource utilization                                 For each of the following, indicate which of the preced-
                                                                    ing scheduling criteria is most appropriate.
       g. to achieve a balance between response and utilization
                                                                             i.    In a real-time spacecraft monitoring system, the
       h. to avoid indefinite postponement                                         computer must respond immediately to signals
       i. to obey priorities                                                       received from the spacecraft.
       j. to give preference to processes that hold key resources            ii.   Although a process has been receiving occasional
                                                                                   service, it is making only nominal progress.
       k. to give a lower grade of service to high overhead pro-
                                                                             iii. How often does the process voluntarily give up
          cesses
                                                                                  the processor for I/O before its quantum expires?
       l. to degrade gracefully under heavy loads
                                                                             iv. Is the user present and expecting fast interactive
      Which of the preceding objectives most directly applies                    response times, or is the user absent?
to each of the following?                                                    v.    One goal of processor scheduling is to minimize
          i.   If a user has been waiting for an excessive                         average waiting times.
               amount of time, favor that user.                              vi. Processes holding resources in demand by other
          ii. The user who runs a payroll job for a 1000-                        processes should have higher priorities.
              employee company expects the job to take about                 vii. Nearly complete processes should have higher
              the same amount of time each week.                                  priorities.

<!-- pág. 424 -->

                                                                                                                  Exercises        367
8.6 State which of the following are true and which false.                    i.     Arrange the schemes above in order from lowest
 Justify your answers.                                                              to highest runtime overhead.
       a. A process scheduling discipline is preemptive if the                ii.   Arrange the schemes in order from least to most
          processor cannot be forcibly removed from a process.                      responsive to variations in individual processes
       b. Real-time systems generally use preemptive proces-                        and system load.
          sor scheduling.                                                     iii. Relate your answers in (i) and (ii) to one another.
       c. Timesharing systems generally use nonpreemptive
                                                                     8.14 State why each of the following is incorrect.
          processor scheduling.
       d. Turnaround times are more predictable in preemp-                 a. SPF never has a higher throughput than SRT.
          tive than in nonpreemptive systems.                              b. SPF is fair.
       e. One weakness of priority schemes is that the system              c. The shorter the process, the better the service it
          will faithfully honor the priorities, but the priorities            should receive.
          themselves may not be meaningful.                                d. Because SPF gives preference to short processes, it is
8.7 Why should processes be prohibited from setting the                       useful in timesharing.
interrupting clock?                                                  8.15 State some weaknesses in SRT. How would you modify
8.8 State which of the following refer to "static priorities"        the scheme to get better performance?
and which to "dynamic priorities."                                   8.16 Answer each of the following questions about Brinch
      a. are easier to implement                                     Hansen's HRRN strategy.
      b. require less runtime overhead                                     a. How does HRRN prevent indefinite postponement?
      c. are more responsive to changes in a process's envi-               b. How does HRRN decrease the favoritism shown by
         ronment                                                              other strategies to short new processes?
      d. require more careful deliberation over the initial pri-           c. Suppose two processes have been waiting for about
         ority value chosen                                                   the same time. Are their priorities about the same?
8.9   Give several reasons why deadline scheduling is complex.                Explain your answer.
8.10 Give an example showing why FIFO is not an appropri-            8.17 Show how multilevel feedback queues accomplish each
ate processor scheduling scheme for interactive users.               of the following scheduling goals.
8.11 Using the example from the previous problem, show                     a. favor short processes.
why round-robin is a better scheme for interactive users.                  b. favor I/O-bound processes to improve I/O device uti-
8.12 Determining the quantum is a complex and critical task.                  lization.
Assume that the average context-switching time between pro-                c. determine the nature of a process as quickly as possi-
cesses is s, and the average amount of time an I/O-bound pro-                 ble and schedule the process accordingly.
cess uses before generating an I/O request is t (t >> s). Discuss
the effect of each of the following quantum settings, q.             8.18 One heuristic often used by processor schedulers is that a
                                                                     process's past behavior is a good indicator of its future behavior.
       a. q is slightly greater than zero
                                                                     Give several examples of situations in which processor schedul-
       b. q = s                                                      ers following this heuristic would make bad decisions.
       c. s <q <t
                                                                     8.19 An operating systems designer has proposed a multilevel
       d. q-t                                                        feedback queuing network in which there are five levels. The
       e. q>t                                                        quantum at the first level is 0.5 seconds. Each lower level has a
       f. q is an extremely large number                             quantum twice the size of the quantum at the previous level. A
                                                                     process cannot be preempted until its quantum expires. The sys-
8.13 Discuss the effect of each of the following methods of
                                                                     tem runs both batch and interactive processes, and these consist
assigning q.
                                                                     of both processor-bound and I/O-bound processes.
      a. q fixed and identical for all users
                                                                           a. Why is this scheme deficient?
      b. q fixed and unique to each process
                                                                           b. What minimal changes would you propose to make
      c. q variable and identical for all processes                           the scheme more acceptable for its intended process
      d. q variable and unique to each process                                mix?

<!-- pág. 425 -->

368 Processor Scheduling
8.20 The SPF strategy can be proven to be optimal in the sense       8.28 When are static real-time scheduling algorithms more
that it minimizes average response times. In this problem, you       appropriate than dynamic real-time scheduling algorithms?
will demonstrate this result empirically by examining all possi­
                                                                     8.29 Before Sun implemented its current Solaris operating
ble orderings for a given set of five processes. In the next prob­
                                                                     system, Sun's UNIX system,70 primarily used for workstations,
lem, you will actually prove the result. Suppose five different
                                                                     performed process scheduling by assigning base priorities
processes are waiting to be processed, and that they require 1,2,
                                                                     (a high of -20 to a low of +20 with a median of 0), and making
3, 4 and 5 time units, respectively. Write a program that pro­
                                                                     priority adjustments. Priority adjustments were computed in
duces all possible permutations of the five processes (5! = 120)
                                                                     response to changing system conditions. These were added to
and calculates the average waiting time for each permutation.
                                                                     base priorities to compute current priorities; the process with
Sort these into lowest to highest average waiting time order and
                                                                     the highest current priority was dispatched first.
display each average time side by side with the permutation of
                                                                            The priority adjustment was strongly biased in favor of
the processes. Comment on the results.
                                                                     processes that had recently used relatively little processor
8.21 Prove that the SPF strategy is optimal in the sense that it     time. The scheduling algorithm "forgot" processor usage
minimizes average response times. [Hint: Consider a list of          quickly to give the benefit of the doubt to processes with
processes each with an indicated duration. Pick any two pro­         changing behavior. The algorithm "forgot" 90 percent of
cesses arbitrarily. Assuming that one is larger than the other,      recent processor usage in 5 * n seconds; n is the average num­
show the effect that placing the smaller process ahead of the        ber of runnable processes in the last minute. 71 Consider this
longer one has on the waiting time of each process. Draw an          process scheduling algorithm when answering each of the fol­
appropriate conclusion.]                                             lowing questions.
8.22 Two common goals of scheduling policies are to mini­                  a. Are processor-bound processes favored more when
mize response times and to maximize resource utilization.                     the system is heavily loaded or when it is lightly
      a. Indicate how these goals are at odds with one                        loaded?
         another.                                                          b. How will an I/O-bound process perform immediately
      b. Analyze each of the scheduling policies presented in                 after an I/O completion?
         this chapter from these two perspectives. Which are               c. Can processor-bound processes suffer indefinite post­
         biased toward minimizing user response times?                        ponement?
         Which are biased toward maximizing resource utili­                d. As the system load increases, what effect will proces­
         zation?                                                              sor-bound processes have on interactive response
      c. Develop a new scheduling policy that enables a sys­                  times?
         tem to be tuned to achieve a good balance between                 e. How does this algorithm respond to changes in a pro­
         these conflicting objectives.                                        cess's behavior from processor bound to I/O bound
8.23 In the selfish round-robin scheme, the priority of a pro­                or vice versa?
cess residing in the holding queue increases at a rate a until the   8.30 The VAX/VMS 72 operating system ran a wide variety of
priority is as high as that of processes in the active queue, at     computers, from small to large. In VAX/VMS, process priori­
which point the process enters the active queue and its priority     ties range from 0-31, with 31 being the highest priority
continues to increase, but now at the rate b. Earlier we stated      assigned to critical real-time processes. Normal processes
that b ≤ a . Discuss the behavior of an SRR system if b > a .        receive priorities in the range 0-15; real-time processes receive
8.24 How does a fair share scheduler differ in operation from        priorities in the range 16-31. The priorities of real-time pro­
a conventional process scheduler?                                    cesses normally remain constant; no priority adjustments are
                                                                     applied. Real-time processes continue executing (without suf­
8.25 In a uniprocessor system with n processes, how many             fering quantum expirations) until they are preempted by pro­
different ways are there to schedule an execution path?              cesses with higher or equal priorities, or until they enter
8.26 Suppose a system has a multilevel feedback queue                various wait states.
scheduler implemented. How could one adapt this scheduler                   Other processes are scheduled as normal processes with
to form the following schedulers?                                    priorities 0-15. These include interactive and batch processes,
      a. FCFS                                                        among others. Normal process priorities do vary. Their base
                                                                     priorities normally remain fixed, but they receive dynamic pri­
      b. round-robin
                                                                     ority adjustments to give preference to I/O-bound over proces­
8.27 Compare and contrast EDF and SPF.                               sor-bound processes. A normal process retains the processor

<!-- pág. 426 -->

                                                                                              Recommended        Reading      369

until it is preempted by a more important process, until it              b. Why are real-time processes not susceptible to quan-
enters a special state such as an event wait, or until its quan-            tum expirations?
 tum expires. Processes with the same current priorities are             c. Which normal processes, I/O bound or processor
 scheduled round-robin.                                                     bound, generally receive preference?
       Normal processes receive priority adjustments of 0 to 6
                                                                         d. Under what circumstances can a real-time process
above their base priorities. Such positive increments occur, for
                                                                            lose the processor?
example, when requested resources are made available, or
when a condition on which a process is waiting is signaled. I/O-         e. Under what circumstances can a normal process lose
bound processes tend to get positive adjustments in priority,               the processor?
while processor-bound processes tend to have current priori-             f. How are normal processes with the same priorities
ties near their base priorities. Answer each of the following               scheduled?
questions with regard to the VAX/VMS process scheduling                  g. Under what circumstances do normal processes
mechanisms.                                                                 receive priority adjustments?
      a. Why are the priorities of real-time processes nor-
         mally kept constant?



8.31 Prepare a research paper that compares and contrasts          for thread scheduling in user-level threads and scheduler acti-
how Windows XP, Linux, and Mac OS X schedule processes.            vations.
8.32 Although the operating system is typically responsible        8.33 Research how real-time scheduling is implemented in
  for scheduling processes and threads, some systems allow user    embedded systems.
processes to make scheduling decisions. Research how this is       8.34 Research the scheduling policies and mechanisms that
 done for process scheduling in exokernel operating systems        are commonly used in database systems.
(see      www.pdos.lcs.mit.edu/pubs.html#Exokernels)       and


Suggested Simulations
8.35 One solution to the problem of avoiding indefinite post-      8.36 One problem with preemptive scheduling is that the
ponement of processes is aging, in which the priorities of wait-   context-switching overhead may tend to dominate if the sys-
 ing processes increase the longer they wait. Develop several      tem is not carefully tuned. Write a simulation program that
aging algorithms and write simulation programs to examine          determines the effects on system performance of the ratio of
their relative performance. For example, a process's priority      context-switching overhead to typical quantum time. Discuss
may be made to increase linearly with time. For each of the        the factors that determine context-switching overhead and the
aging algorithms you choose, determine how well waiting pro-       factors that determine the typical quantum time. Indicate how
cesses are treated relative to high-priority arriving processes.   achieving a proper balance between these (i.e., tuning the sys-
                                                                   tem) can dramatically affect system performance.


Recommended Reading
Coffman and Kleinrock discuss popular scheduling policies          Stankovic et al. present a discussion of real-time scheduling
and indicate how users who know which scheduling policy the        concerns,75 Pop et. al present scheduling concerns in embed-
system employs can actually achieve better performance by          ded systems76 and Bender et al. discuss scheduling techniques
taking appropriate measures.73 Ruschitzka and Fabry give a         for Web server transactions.77 SMART (Scheduler for Multi-
classification of scheduling algorithms, and they formalize the    media And Real-Time applications), which combines real-time
notion of priority.74 Today's schedulers typically combine sev-    and traditional scheduling techniques to improve multimedia
eral techniques described in this chapter to meet particular       performance, was developed in response to increasing popu-
system objectives. Recent research in the field of processor       larity of multimedia applications on workstations and personal
scheduling focuses on optimizing performance in settings such      computers. 78
as Web servers, real-time systems and embedded devices.

<!-- pág. 427 -->

370 Processor Scheduling

      Dertouzos demonstrated that when all processes can               Recent research focuses on the speed80, 81 or number 82 of pro-
meet their deadlines regardless of the order in which they are         cessors the system must allocate to the scheduler so that it
executed, it is optimal to schedule processes with the earliest        meets its deadlines. The bibliography for this chapter is located
deadlines first.79 However, when the system becomes over-              on our Web site at www.deitel.com/books/osBe/Bibliog-
loaded, the optimal scheduling policy cannot be implemented            raphy.pdf.
without allocating significant processor time to the scheduler.



Works Cited
 1. Ibaraki, T.; Abdel-Wahab, H. M; and T. Kameda, "Design of          15. Deitel, H. M., "Absentee Computations in a Multiple Access
    Minimum-Cost Deadlock-Free Systems," Journal of the ACM.,              Computer System," M.I.T. Project M A C MAC-TR-52.
    Vol. 30, No. 4 October 1983, p. 750.                                   Advanced Research Projects Agency, Department of Defense.
 2. Coffman, E. G., Jr., and L. Kleinrock, "Computer Scheduling            1968.
    Methods and Their Countermeasures," Proceedings of AFIPS,          16. Brinch Hansen, P., ''Short-Term Scheduling in Multiprogram
    S/CC, Vol. 32,1968, pp. 11-21.                                         ming Systems," Third ACM Symposium on Operating Systems
 3. Ruschitzka, M., and R. S. Fabry, "A Unifying Approach to Sched-        Principles, Stanford University, October 1971, pp. 103-105.
    uling," Communications oftheACM.Vol. 20, No. 7, July 1977, pp.     17. Kleinrock, L., "A Continuum of Time-Sharing Scheduling Algo-
    469-477.                                                               rithms," Proceedings ofAFIPS, SJCC, 1970, pp. 453-458.
 4. Abbot, C, "Intervention Schedules for Real-Time Program-           18. Blevins, P. R., and C. V. Ramamoorthy, 'Aspects of a Dynami-
    ming," IEEE Transactions on Software Engineering, Vol. SE-10,          cally Adaptive Operating System," IEEE Transactions on Com-
    No. 3, May 1984, pp. 268-274.                                          puters, Vol. 25, No. 7, July 1976, pp. 713-725.
 5. Ramamritham, K., and J. A. Stanovic, "Dynamic Task Scheduling      19. Potier, D.; Gelenbe, E.; and J. Lenfant, "Adaptive Allocation of
    in Hard Real-Time Distributed Systems," IEEE Software, Vol. 1.         Central Processing Unit Quanta," Journal of the ACM, Vol. 23.
    No. 3, July 1984, pp. 65-75.                                           No. 1, January 1976, pp. 97-102.
 6. Volz, R. A., and T. N. Mudge, "Instruction Level Timing Mecha-     20. Newbury, J. P.. "Immediate Turnaround—An Elusive Goal."
    nisms for Accurate Real-Time Task Scheduling," IEEE Transac-           Software Practice and Experience, Vol. 12, No. 10, October 1982.
    tions on Computers, Vol. C-36, No. 8, August 1987, pp. 988-993.        pp. 897-906.
 7. Potkonjak, M., and W. Wolf, "A Methodology and Algorithms for      21. Henry, G. X, "The Fair Share Scheduler," Bell Systems Technical
    the Design of Hard Real-Time Multitasking ASICs," ACM Trans-           Journal, Vol. 63, No. 8, Part 2, October 1984, pp. 1845-1857.
    actions on Design Automation of Electronic Systems (TODAES)
    Vol, 4. No. 4, October 1999.                                       22. Woodside, C. M., "Controllability of Computer Performance
                                                                           Tradeoffs Obtained Using Controlled-Share Queue Schedulers."
 8. Kleinrock, L., "A Continuum of Time-Sharing Scheduling Algo-
                                                                           IEEE Transactions on Software Engineering, Vol. SE-12, No. 10.
    rithms," Proceedings of AFIPS, SJCC, 1970. pp. 453-458.
                                                                           October 1986, pp. 1041-1048.
 9. "sched.h —Execution Scheduling (REALTIME)," The Open
                                                                       23. Kay, X, and P. Lauder, "A Fair Share Scheduler," Communica-
    Group Base Specifications Issue 6, IEEE Std. 1003.1, 2003 edi-
                                                                           tions oftheACM.Vol. 31, No. 1, January 1988, pp. 44-55.
    tion, <www.opengroup.org/onlinepubs/007904975/basedefs/
    sched.h.html>.                                                     24. Henry, G J, "The Fair Share Scheduler," Bell Systems Technical
                                                                           Journal, Vol. 63, No. 8, Part 2, October 1984, p. 1846.
10. Kleinrock, L., "A Continuum of Time-Sharing Scheduling Algo-
    rithms," Proceedings of AFIPS, SJCC. 1970, pp. 453-458.            25. "Chapter 9, Fair Share Scheduler," Solaris 9 System Administra-
11. Potier, D.; Gelenbe, E.; and J. Lenfant, "Adaptive Allocation of       tor Collection, November 11, 2003, <docs.sun.com/db/doc/
    Central Processing Unit Quanta," Journal of the ACM, Vol. 23,          806-4076/6jd6amqqo?a=view>.
    No. 1. January 1976, pp. 97-102.                                   26. Henry, G X, "The Fair Share Scheduler," Bell Systems Technical
12. Linux source code, version 2.6.0-test3, sched.c, lines 62-135          Journal,Vol. 63, No. 8, Part 2, October 1984, p. 1848.
    <miller.cs.wm.edu/lxr3.linux/http/source/kernel/                   27. Henry, G X, "The Fair Share Scheduler," Bell Systems Technical
    sched.c?v=2.6.0-test3>.                                                JournafVol. 63, No. 8, Part 2, October 1984, p. 1847.
13. Solomon, D., and M. Russinovich, Inside Windows 2000, 3rd ed.,     28. Henry, G. X, "The Fair Share Scheduler," Bell Systems Technical
    Redmond: Microsoft Press. 2000, pp. 338,347.                           Journal, Vol. 63, No. 8, Part 2, October 1984, p. 1846.
14. Bruno, X; Coffman, E. G, Jr.; and R. Sethi, "Scheduling Indepen-   29. Nielsen, N. R., "The Allocation of Computing Resources —Is
    dent Tasks to Reduce Mean Finishing Time," Communications of           Pricing the Answer?" Communications of the ACM, Vol. 13, No.
    the ACM, Vol. 17, No. 7, July 1974, pp. 382-387.                       8, August 1970, pp. 467-474.

<!-- pág. 428 -->

                                                                                                                               Works Cited 371
30. McKell, L. X; Hansen, J. V.; and L. E. Heitger, "Charging for                48. Wind River Systems, Inc., "VxWorks 5.x."                <www.win-
    Computer Resources," ACM Computing Surveys, Vol. 11, No. 2,                      driver,com/products/vxworks5/vxworks5x_ds.pdf>.
    June 1979, pp. 105-120.                                                      49. Dedicated Systems Experts, "Comparison between QNX RTOS
31. Kleijnen, A. J. V., "Principles of Computer Charging in a Univer-                V6.1, VxWorks AE 1.1, and Windows CE .NET," June 21, 2001
    sity-Type Organization," Communications of the ACM, Vol. 26,                     <www.eon-trade.com/data/QNX/QNX61_VXAE_CE.pdf>.
    No. 11, November 1983, pp. 926-932.                                          50. QNX Software Systems Ltd., "QNX Supported Hardware,"
32. Dertouzos, M. L., "Control Robotics: The Procedural Control of                   <www.qnx.com/support/sd_hardware/platform/proces-
    Physical Processes," Proc. IFIP Congress, 1974, pp. 807-813.                     sors.html>.
33. Kalyanasundaram, B., and K., Pruhs, "Speed Is As Powerful As                 51. Timmerman, M., "RTOS Evaluation Project Latest News," Dedi-
    Clairvoyance," Journal of the ACM (JACM), Vol. 47, No. 4, July,                  cated Systems Magazine, 1999, <www.omimo.be/magazine/99ql/
    2002, pp. 617-643.                                                               1999ql_p009.pdf>.
34. Lam, T, and K. To, "Performance Guarantee for Online Dead-                   52. Wind River Systems, Inc.,"VxWorks 5.x.," <www.win-
    line Scheduling in the Presence of Overload," Proceedings of the                 dri ver.com/products/vxworks5/vxworks5x_ds.pdf>.
    TWELFTH ANNUal ACM-SIAM Symposium on Discrete Algo-                          53. Microsoft Corporation, "Windows CE .NET Home Page,"
    rithms, January 7-9,2001, pp. 755-764.                                           <        w      w       w      .     m       ic    r    o             s   o
35. Koo, C; Lam, T; Ngan, T.; and K. To, "Extra Processors Versus                    default .asp>.
    Future Information in Optimal Deadline Scheduling," Proceed-                 54. Radisys Corporation, "RadiSys: Microware OS-9," <www.radi -
    ings of the Fourteenth Annual ACM Symposium on Parallel Algo-                    sys.com/oem_products/op-os9.cfm?MS=Mi cro-
    rithms and Architectures, 2002, pp. 133-142.                                     ware%20Enhanced%200S-9%20Solution>.
36. Stankovic, J., "Real-Time and Embedded Systems," ACM Com-                    55. Enea Embedded Technology, "Welcome to Enea Embedded
    puting Surveys,Vol. 28, No. 1, March 1996, pp. 205-208.                          Technology," <www.ose.com>.
37- Xu, J., and D. L. Parnas, "On Satisfying Timing Constraints in               56. Real Time Linux Foundation, Inc., "Welcome to the Real Time
    Hard-Real-Time Systems," Proceedings of the Conference on                        Linux Foundation Web Site," < w w w . r e a l t i m e l i n u x f o u n d a
    Software for Critical Systems, New Orleans, Louisiana, 1991, pp.                 tion.org>.
    132-146.                                                                     57. Etsion, Y.; Tsafrir, D.; and D. Feiteelson, "Effects of Clock Reso-
38. Stewart, D., and P. Khosla, "Real-Time Scheduling of Dynami-                     lution on the Scheduling of Interactive and Soft Real-Time Pro-
    cally Reconfigurable Systems," Proceedings of the IEEE Interna-                  cesses," SIGMETRICS'03, June 10-14,2003, pp. 172-183.
    tional Conference on Systems Engineering, Dayton, Ohio, August               58. Xu, J., Parnas, D. L., "On Satisfying Timing Constraints in Hard-
    1991, pp. 139-142.                                                               Real-Time Systems," Proceedings of the Conference on Software
39. van Beneden, B., "Comp.realtime: Frequently Asked Questions                      for Critical Systems, New Orleans, Louisiana, 1991, pp. 132-146.
    (FAQs) (Version 3.6)," May 16, 2002 <www.faqs.org/faqs/                      59. Stewart, D., and P. Khosla, "Real-Time Scheduling of Dynami-
    realtime-computing/faq/>.                                                        cally Reconfigurable Systems," Proceedings of the IEEE Interna-
40. MITRE Corporation, "MITRE - About Us - MITRE History -                           tional Conference on Systems Engineering, Dayton, Ohio, August
    Semi-Automatic Ground Environment (SAGE)," January 7,                            1991, pp. 139-142.
    2003 <www.mitre.org/about/sage.html>.                                        60. Xu, J., and D. L. Parnas, "On Satisfying Timing Constraints in
41. Edwards, P., "SAGE," The Closed World, Cambridge, MA: MIT                        Hard-Real-Time Systems," Proceedings of the Conference on
    Press, 1996, <www.si.urrrich.edu/~pne/PDF/cw.ch3.pdf>.                           Software for Critical Systems, New Orleans, Louisiana, 1991, pp.
42. Edwards, P., "SAGE," The Closed World, Cambridge, MA: MIT                        132-146.
    Press, 1996, <www.si.umich.edu/~pne/PDF/cw.ch3.pdf>.                         61. Stewart, D., and P. Khosla, "Real-Time Scheduling of Dynami-
43. MITRE Corporation, " M I T R E - A b o u t U s - M I T R E H i s t o r y -       cally Reconfigurable Systems," Proceedings of the IEEE Interna-
    Semi-Automatic Ground Environment (SAGE)," January 7,                            tional Conference on Systems Engineering, Dayton, Ohio, August
    2003 <www.mitre.org/about/sage.html>.                                            1991, pp. 139-142.
44. Edwards, P., "SAGE," The Closed World, Cambridge, MA: MIT                    62. Potkonjak, M., W Wolf, "A Methodology and Algorithms for the
    Press, 1996, <www.si.umich.edu/~pne/PDF/cw.ch3.pdf>.                             Design of Hard Real-Time Multitasking ASICs," ACM Transac-
                                                                                     tions on Design Automation of Electronic Systems (TODAES),
45. MITRE Corporation. " M I T R E - A b o u t U s - M I T R E H i s t o r y -
                                                                                     Vol. 4, No. 4, October 1999.
    Semi-Automatic Ground Environment (SAGE)," January 7,
    2003 <www.mitre.org/about/sage.html>.                                        63. Xu, X, and D. L. Parnas, "On Satisfying Timing Constraints in
46. Edwards, P., "SAGE," The Closed World, Cambridge, MA: MIT                        Hard-Real-Time Systems," Proceedings of the Conference on
    Press, 1996, <www.si.umich.edu/~pne/PDF/cw.ch3.pdf>.                             Software for Critical Systems, New Orleans, Louisiana, 1991, pp.
                                                                                     132-146.
47. QNX Software Systems Ltd., "The Philosophy of QNX Neu-
    trino," <www.qnx.com/developer/docs/momentics621_docs/                       64. Dertouzos, M. L., "Control Robotics: The Procedural Control of
    neutrino/sys_arch/intro.html>.                                                   Physical Processes," Information Processing, Vol. 74,1974.

<!-- pág. 429 -->

372 Processor Scheduling

65. Stewart, D., and P. Khosla, "Real-Time Scheduling of Dynami-        75. Stankovic, J. A.; Spuri, M.; Natale, M. D.; and G. C. Buttazzo.
    cally Reconfigurable Systems," Proceedings of the IEEE Interna-         "Implications of Classical Scheduling Results for Real-Time Sys-
    tional Conference on Systems Engineerings Dayton, Ohio, August          tems," IEEE Computer,Vo\. 28, No. 6,1995, pp. 16-25.
    1991, pp. 139-142.                                                  76. Pop, P.; Eles, P.; and Z. Peng, "Scheduling with Optimized Com-
66. Stewart, D., and P. Khosla, "Real-Time Scheduling of Dynami-            munication for Time-Triggered Embedded Systems," "Proceedings
    cally Reconfigurable Systems," Proceedings of the IEEE Interna-         of the Seventh International Workshop on Hardware/Software
    tional Conference on Systems Engineering, Dayton, Ohio, August          Codesign, March 1999.
    1991, pp. 139-142.                                                  77. Bender, M. A.; Muthukrishnan, S.; and R. Rajarama, "Improved
67. "A Look at the JVM and Thread Behavior," June 28, 1999,                 Algorithms for Stretch Scheduling," Proceedings of the Thir-
    <www.javaworld.com/javaworld/javaqa/1999-07/04-qa-                      teenth Annual ACM-SIAM Symposium on Discrete Algorithms.
    jvmthreads.html>.                                                       January 2002.
68. Austin, C, "Java Technology on the Linux Platform: A Guide to       78. Nieh, J., and M. S. Lam, "The Design, Implementation and Eval-
    Getting Started," October 2000, <developer.java.sun.com/                uation of SMART: a Scheduler for Multimedia Applications."
    developer/technicalArticles/Programming/linux/>.                        ACM SIGOPS Operating Systems Review, Proceedings of the Six-
69. Holub, A., "Programming Java Threads in the Real World, Part            teenth ACM Symposium on Operating Systems Principles, Octo-
    1," JavaWorld, September 1998, <www.javaworld.com/java¬                 ber 1997.
    world/jw-09-1998/jw-09-threads.html>.
                                                                        79. Dertouzos, M. L., "Control Robotics: The Procedural Control o:
70. Courington, W., The UNIX System: A Sun Technical Report,                Physical Processes," Proc. IFIP Congress, 1974, pp. 807-813.
    Mountain View, CA: Sun Microsystems, Inc., 1985.
                                                                        80. Kalyanasundaram, B., and K., Pruhs, "Speed Is As Powerful As
71. Courington, W., The UNIX System: A Sun Technical Report,
                                                                            Clairvoyance," Journal of the ACM (JACM), Vol. 47, No. 4, July,
    Mountain View, CA: Sun Microsystems, Inc., 1985.
                                                                            2002, pp. 617-643.
72. Kenah, L. J.; Goldenberg, R. E.; and S. F. Bate, VAX/VMS Inter-
    nals and Data Structures: Version 4.4, Bedford, MA: Digital         81. Lam, T, and K. To, "Performance Guarantee for Online Dead-
    Equipment Corporation, 1988.                                            line Scheduling in the Presence of Overload," Proceedings of the
                                                                            TWELFTH ANNUal ACM-SIAM Symposium on Discrete Algo-
73. Coffman, E. G, Jr., and L. Kleinrock, "Computer Scheduling
                                                                            rithms, January 7-9,2001, pp. 755-764.
    Methods and Their Countermeasures," Proceedings of AFIPS,
    SJCC, Vol. 32,1968, pp. 11-21.                                      82. Koo, C; Lam, T; Ngan, T; and K. To, "Extra Processors Versus
74. Ruschitzka, M., and R. S. Fabry, "A Unifying Approach to Sched-         Future Information in Optimal Deadline Scheduling," Proceed-
    uling," Communications of the ACM, Vol. 20, No. 7, July 1977, pp.       ings of the Fourteenth Annual ACM Symposium on Parallel Algo-
    469-477.                                                                rithms and Architectures, 2002, pp. 133-142.

