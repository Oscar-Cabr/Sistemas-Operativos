# Chapter 7 - Deadlock and Indefinite Prosponement

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 346–389 (numeración del PDF)

<!-- pág. 346 -->

Chapter 7

Deadlock and Indefinite
           Postponement
 Objectives
 After reading this chapter, you should understand:
 • the problem of deadlock.
 • the four necessary conditions for deadlock to exist.
 • the problem of indefinite postponement.
 • the notions of deadlock prevention, avoidance, detection and recovery.
 • algorithms for deadlock avoidance and detection.
 • how systems can recover from deadlocks.

<!-- pág. 347 -->

                                       Chapter Outline

                          7.1                               7.7.2 Denying the "No-Preemption"
                  Introduction                                           Condition
                                                             7.7.3 Denying the "Circulat-Wait"
                          7.2                                            Condition
           Examples of Deadlock
              7.2.1     Traffic Deadlock                                7.8
            Anecdote:     One-lane   Bridge                  Deadlock Avoidance with
         7.2.2 Simple Resource Deadlock                    Dijkstra's Bankers Algorithm
      Operating Systems Thinking: Waiting,                         Anecdote: Acronyms
         Deadlock and Indefinite Postponement                  7.8.1 Example of a Safe State
       7.2.3 Deadlock in Spooling Systems                    7.8.2 Example of an Unsafe State
        7.2.4 Example: Dining Philosophers                7.8.3 Example of Safe-State-to-Unsafe-
                                                                      State Transition
                          7.3                               7.8.4 Banker's Algorithm Resource
        Related Problem: Indefinite                                      Allocation
              Postponement                                   7.8.5 Wealnesses in the Banker's
                                                                        Algorithm
                          7.4
             Resource Concepts
                                                                        7.9
                          7.5                                    Deadlock Detection
      Four Necessary Conditions for                          7.9.1 Resource-Allocation Graphs
                      Deadlock                            7.9.2 Reduction of Resource-Allocation
                                                                          Graphs
                          7.6
             Deadlock           Solutions                              7.10
                                                                 Deadlock Recovery
                   7.7
            Deadlock Prevention
  Anecdote: No-Nuts, Bolts or Screws Allowed
                                                                          7.11
                                                          Deadlock Strategies in Current
      7.7.1 Denying the "Wait-For" Condition                    and Future Systems
         Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited




290

<!-- pág. 348 -->

                                                                                                7.1 Introduction 291

7.1 Introduction
 In the previous four chapters, we discussed asynchronous, concurrent processes and
threads. A multiprogrammed system provides many benefits, but as discussed in
   Chapter 6, Concurrent Programming, multiprogramming also introduces additional
complexity. One problem that arises in multiprogrammed systems is deadlock. A
process or thread is in a state of deadlock (or is deadlocked) if it is waiting for a par-
   ticular event that will not occur. In a system deadlock, one or more processes are
 deadlocked. 1 ' 2 The remainder of this chapter will focus on processes, but most of
  the discussion applies to threads as well.
        In multiprogrammed computing systems, resource sharing is one of the pri-
mary goals. When resources are shared among a set of processes, each process
maintaining exclusive control over particular resources allocated to it, deadlocks
can develop in which some processes will never be able to complete execution. The
result can be loss of work and reduced system throughput and system failure.
        This chapter discusses the problem of deadlock and summarizes the four major
areas of deadlock research, namely deadlock prevention, avoidance, detection and
recovery. It also considers the closely related problem of indefinite postponement,
also called starvation, in which a process that is not deadlocked could wait for an
event that might never occur or might occur unpredictably far in the future because
  of biases in the systems resource-scheduling policies. In some cases, the price for mak-
 ing a system free of deadlock is high. For some systems, such as those that are mission
critical, the price must be paid no matter how high, because allowing a deadlock to
 develop could be catastrophic, especially if it puts human life at risk.This chapter also
discusses solutions to the problems of deadlock and indefinite postponement in terms
 of trade-offs between their overhead and their anticipated benefits.

Self Review
1. A system designer decides to try to avoid any possibility of deadlock by creating a multi-
   programmed system that does not share resources. What is wrong with this idea?
2. Compare and contrast deadlock with indefinite postponement.
Ans: 1) It would be highly inefficient, because each process would need its own set of
resources. Also, asynchronous concurrent programs often require shared resources such as
semaphores. 2) Deadlock and indefinite postponement are similar in that they occur when
rrocesses wait for an event. Deadlock occurs because the event will never occur; indefinite
postponement occurs because it is uncertain when or even whether the event will ever occur
 (due to biases in a system's resource-scheduling policies).


7.2 Examples of Deadlock
Deadlocks can develop in many ways. If a process is given the task of waiting for an
event to occur, and if the system includes no provision for signaling that event, then
we have a one-process deadlock. 3 Such deadlocks are extremely difficult to detect.
Deadlocks in real systems often involve multiple processes competing for multiple
resources of multiple types. Let us consider several common examples.

<!-- pág. 349 -->

292 Deadlock and Indefinite Postponement

                             7.2.1 Traffic Deadlock
                             Figure 7.1 illustrates a kind of deadlock that occasionally develops in cities. A num-
                             ber of automobiles are attempting to drive through a busy neighborhood, and the
                             traffic is completely snarled. The police have to unwind the jam by slowly and care-
                             fully backing cars out of the congested area. Eventually the traffic begins to flow
                             normally, but not without much annoyance, effort, and loss of time (see the Anec-
                             dote, One-Lane Bridge).

                            Self Review
                             1. Assuming that there are no cars beyond the ellipses in Fig. 7.1, what minimum number of
                                cars would have to back up to relieve the deadlock and which car(s) would they be?
                             2. If cars could be removed by airlifting in Fig. 7.1, what minimum number of cars, and which
                                one(s), would have to be removed to relieve the deadlock?




                             Figure 7.1 | Traffic deadlock example.4

<!-- pág. 350 -->

                                                                                            7.2 Examples of Deadlock 293
Ans: 1.) In Fig. 7.1, only two cars would need to back up to allow every other car to eventually
move-any one of the cars abutting an ellipsis, then the car ahead of that one in the intersec-
tion. 2.) Only one car has to be removed—namely, any one of the four cars in the intersections.


7.2.2 Simple Resource Deadlock
Most deadlocks in operating systems develop because of the normal contention for
 dedicated resources (i.e., resources that may be used over time by many processes
but by only one process at a time, sometimes called serially reusable resources). For
example, a printer can print jobs for only one process at a time (otherwise pieces of
many print jobs would be interwoven). A simple example of a resource deadlock is
 illustrated in Fig. 7.2. This resource allocation graph shows two processes as rectan-
gles and two resources as circles. An arrow from a resource to a process indicates
that the resource belongs to, or has been allocated to, the process. An arrow from a
process to a resource indicates that the process is requesting, but has not yet been
 allocated, the resource. The diagram illustrates a deadlocked system: Process P1
holds resource R 1 and needs resource R 2 to continue. Process P 2 holds resource R 2
 and needs resource R1 to continue. Each process is waiting for the other to free a
resource that the other process will not free. This circular wait is characteristic of
deadlocked systems (see the Operating Systems Thinking feature, Waiting, Dead-
 lock and Indefinite Postponement). Holding resources tenaciously in this way, a is
sometimes referred to as a deadly embrace.




                 Anecdote
   One-lane              Bridge
   A former operating systems stu-             drivers were approaching a one-            said, "I don't back up for idiots."
   dent of HMD's was one of the               lane bridge. They reached the               The other driver calmly got back
   original designers of the IBM per-         middle of the bridge at the same            in his car and started backing up.
   sonal computer. When we studied            time, forcing a confrontation.              He said, "No problem—I do."
   deadlock in class, he shared a             They got out of their cars and
   deadlock anecdote w i t h me. Two          went nose to nose. One driver


   Lesson to operating system designers: Processes are neither stubborn nor cooperative, so deadlock is a pain-
   ful experience at best. Usually, one or more processes will have to be "backed out" of the deadlock, losing
   some or all of their work.

<!-- pág. 351 -->

294   Deadlock and Indefinite Postponement




                             Figure 7.2 | Resource deadlock example. This System is deadlocked because each
                             process holds a resource being requested by the o t h e r process and neither process is
                             willing to release the resource it holds.

                             Self Review
                              1. If the traffic deadlock in Fig. 7.1 were to be represented using a resource-allocation grapr
                                 what would the processes be? What would the resources be?
                              2. Suppose several arrows are pointing from a process to resources in a resource-allocatk'-
                                 graph. What does that mean? How does it affect the possibility of deadlock?
                             Ans: l) The cars would be the processes. The resources would be the sections of the street th..
                             the cars occupy. Each car currently holds the section of the street directly below it and ts
                             requesting the section in front of it. 2) It means that the process is requesting several resource-
                             The possibility of deadlock depends on whether those resources are allocated to other pro
                             cesses, some of which, in turn, are requesting resources held by the process we are discussing.


                              7.2.3 Deadlock in Spooling Systems
                              A spooling system improves system throughput by disassociating a program from
                              slow devices such as printers. For example, if a program sending lines to the printer
                              must wait for each page to be printed before it can transmit the next page, then it
                              will execute slowly. To speed the program's execution, a spooling system routes out-
                              put pages to a much faster device, such as a hard disk, where they are temporarily
                              stored until they can be printed.
                                    Spooling systems can be prone to deadlock. Some spooling systems require
                              that the complete output from a program be available before printing can begin.
                              Several partially completed jobs generating pages to a spool file can become dead-
                              locked if the disk's available space fills before any job completes. The user or system
                              administrator may kill one or more jobs to make sufficient spooling space available
                              for the remaining jobs to complete.

<!-- pág. 352 -->

                                                                                       7.2 Examples of Deadlock 295

       Typically, the system administrator specifies the amount of space for spooling
files. One way to make deadlocks less likely is to provide considerably more space
for spooling files than is likely to be needed. This solution may not be feasible if
space is at a premium. A more common solution is to restrain the input spoolers so
that they do not accept additional print jobs when the spooling files begin to reach
some saturation threshold, such as 75 percent full. This may reduce system through-
put, but it is the price paid to reduce the likelihood of deadlock.
      Today's systems are more sophisticated than this. They might allow printing to
 begin before the job is completed so that a full, or nearly full, spooling file can begin
emptying while a job is still executing. This concept has been applied to streaming
 audio and video clips, where the audio and video begin to play before the clips down-
-oad fully. In many systems spooling space allocation has been made more dynamic,
so that if existing space starts to fill, then more space may be made available.




               Operating Systems Thinking
  Waiting, Deadlock and Indefinite Postponement
  Operating systems must manage            becomes full, the producer cannot        a time can use and that the other
  many different types of waiting          continue to produce more infor-          process is holding. Both processes
  scenarios, which rely on an abun-        mation, so it must wait for the          cease progressing; this can be
  dant use of queues to do so. Pro-        consumer to empty some data;             fatal in mission-critical systems
  cesses and threads must wait for a       when that region becomes empty           where human lives may be at
  processor to become available            the consumer must wait for the           stake. Indefinite postponement
  before they can execute; they            producer to generate more data.          (also called starvation) typically
  often wait for I/O requests to                You will see extensive exam-        occurs when a process is waiting
  complete and for requested               pies of waiting scenarios through-       in line and other processes, per-
  resourcesto become available. I/O        out this book. Operating systems         haps those of a higher priority,
  requests themselves must wait for        must manage waiting carefully to         are allowed to get in line in front
  the I/O devices to become avail-         avoid t w o serious problems,            of the waiting process. A steady
  able. Processes and threads shar-        namely deadlock and indefinite           stream of arriving high-priority
  ing data may have to wait until a        postponement, each of which is           processes is said to indefinitely
  process or thread currently access-      discussed in detail in this chapter.     postpone the lower-priority pro-
  ing that data finishes and leaves a      In a deadlock scenario, processes        cess. This could be as dangerous
  critical section. In the producer/       and threads are waiting for              as deadlock in a mission-critical
  consumer relationship, the pro-          events that will never happen; a         system. So take waiting seri-
  ducer passes information to the          simple two-process deadlock has          ously—if it is mismanaged, system
  consumer via a shared region of          each process waiting on a                failures could occur.
  memory; when that region                 resource that only one process at

<!-- pág. 353 -->

296 Deadlock and Indefinite Postponement

                             Self Review
                             1. Suppose a spooling system has a saturation threshold of 75 percent and limits the maxi-
                                mum size of each file to 25 percent of the total spooling file size. Could deadlock occur in
                                this system?
                             2. Suppose a spooling system has a saturation threshold of 75 percent and limits the maxi-
                                mum size of each file to 25 percent of the total spooling file size. Describe a simple way to
                                ensure that deadlock will never occur in the system. Explain how this could lead to ineffi-
                                cient resource allocation.
                            Ans: 1) Yes, deadlock can still occur in this system. For instance, several jobs can begin
                            transferring their outputs. When the spooling file reaches the 75 percent threshold, new jobs
                            are not allowed. However, jobs that have begun are allowed to continue spooling, which may
                            result in deadlock if there is insufficient space in the spooling file. 2) A simple adjustment
                            would be to allow only one job to continue spooling data when the file reaches the threshold.
                            This would be inefficient because it would limit the maximum job size to much less than the
                            available spooling space.


                             7.2.4 Example: Dining Philosophers
                             Dijkstra's problem of the Dining Philosophers,5, 6 illustrates many of the subtle
                             problems inherent in concurrent programming. The problem is this:
                                     Five philosophers sit around a circular table. Each leads a simple life alternating
                                     between thinking and eating spaghetti. In front of each philosopher is a dish of
                                    spaghetti that is constantly replenished by a dedicated wait staff. There are exactly
                                    five forks on the table, one between each adjacent pair of philosophers. Eating spa-
                                    ghetti (in the most proper manner) requires that a philosopher use both adjacent
                                    forks (simultaneously). Develop a concurrent program free of deadlock and
                                     indefinite postponement that models the activities of the philosophers.
                                   If the solution to this problem were not free of deadlock and indefinite post-
                             ponement, one or more philosophers would starve. The program must, of course,
                             enforce mutual exclusion—two philosophers cannot use the same fork at once. A
                             typical philosopher behaves as shown in Fig. 7.3.
                                   The problems of mutual exclusion, deadlock and indefinite postponement lie
                             in the implementation of method eat. Consider the simple, yet dangerous imple-
                             mentation in Fig. 7.4. Because the philosophers operate asynchronously and con-


                                1     void typicalPhilosopher()
                                2     {
                                3        while ( true )
                                4        {
                                5           think();
                                6               eat();
                                7         } // end w h i l e
                                8
                                9     } // end t y p i c a l P h i l o s p h e r

                             Figure 7.3 | Dining philosopher behavior.

<!-- pág. 354 -->

                                                                                             7.2 Examples of Deadlock 297

    1   void eat()
    2 {
   3    pickUpLeftFork();
   4    pickUpRightFork();
   5    eatForSomeTime();
   6    putDownRightFork();
   7    putDownLeftFork();
   8 } // eat
 Figure 7.4 | Implementation of method eat


currently, it is possible for each philosopher to execute line 3 before any
philosopher executes line 4. In this case, each philosopher will hold exactly one
fork, and no forks will remain available on the table. The philosophers will all dead-
  lock and starve.
      One way to break the deadlock when each philosopher holds a left fork is to
force one or more philosophers to put their left fork down so that another philoso-
pher may grab it as a right fork. To implement this rule, pickllpRightForkO can
specify that a philosopher puts down the left fork if that philosopher cannot obtain
the right fork. However, in this case, it is possible (albeit unlikely) that each philos-
 opher will pick up and put down its left fork repeatedly in tandem without ever
 obtaining the two forks it needs to eat spaghetti. In this case, the philosophers are
not deadlocked, but "livelocked," suffering from indefinite postponement, and they
will still starve. The solution must prevent deadlock (by forcing philosophers to put
down forks) but also prevent livelock (indefinite postponement) by guaranteeing
that each philosopher will obtain both forks from time to time. In the exercises, you
will be asked to develop a complete solution to the Dining Philosophers problem.



Self Review
1. Could the implementation of the eat method in Fig. 7.4 allow the philosophers to live in
   harmony without starving?
2. Consider the e a t method in Fig. 7.4. Suppose lines 3 and 4 were replaced with pickUp-
   BothForksAtOnce(); would that implementation prevent deadlock? Would it prevent the
   philosophers from starving?
Ans: 1) Yes. We cannot predict the relative speeds of asynchronous concurrent processes. It
is possible that not all five philosophers will pick up their left fork at once. Various philoso-
phers could acquire the two forks they need, then release them to give the other philosophers
a chance to eat. 2) Yes, it would prevent deadlock, assuming that pickUpBothForksAt-
Once() can be performed atomically, but it would still allow indefinite postponement. This
could occur, for example, if two of the philosophers were to continually pick up two forks,
eat, put down the forks and pick them up again before any of the other philosophers could
grab them; those other philosophers would starve.

<!-- pág. 355 -->

298 Deadlock and Indefinite Postponement

                             7.3 Related Problem: Indefinite Postponement
                             In any system that requires processes to wait as a result of resource-allocation and
                             process scheduling decisions, a process may be delayed indefinitely while other pro-
                             cesses receive the system's attention. This situation, called indefinite postponement,
                             indefinite blocking, or starvation, can be as devastating as deadlock.
                                    Indefinite postponement may occur because of biases in a system's resource-
                             scheduling policies. When resources are scheduled on a priority basis, it is possible
                             for a given process to wait for a resource indefinitely, as processes with higher prior-
                             ities continue to arrive. Waiting is a fact of life and is certainly an important aspect
                             of what goes on inside computer systems, so systems should be designed to manage
                             waiting processes fairly and efficiently. Some systems prevent indefinite postpone-
                             ment by increasing a process's priority gradually as it waits for a resource —this
                             technique is called aging. Eventually, the waiting process's priority will exceed the
                             priorities of all processes, and the it will be serviced.

                             Self Review
                             1. Dekker's Algorithm and Peterson's Algorithm prevented a process from being indefi-
                                nitely postponed from entering its critical section. Describe how indefinite postponement
                                was prevented. How is this related to aging?
                             2. Suppose an interactive process appears to be "dead in the water." Does this mean that the
                                process is definitely deadlocked? Could it be indefinitely postponed? Are there other pos-
                                sibilities?
                             Ans: 1) Both Dekker's Algorithm and Peterson's Algorithm made the waiting process the
                             favored process when the resource was available again. This is similar to aging, because the
                             waiting process earns a higher priority by waiting. 2) This is an interesting question. From the
                             user's perspective, an interactive process would appear "dead in the water" if the system sim-
                             ply stopped responding to the interactive user's requests. The process could be deadlocked,
                             but it does not have to be. It could be suffering from indefinite postponement, but it does not
                             have to be. It could also be waiting for an event that may happen shortly, it could be locked in
                             an infinite loop or it could be doing a lengthy calculation that will soon finish. Anyone who
                             has experienced a system that appears to "hang" knows how frustrating this can be. What ser-
                             vices should the operating system provide to help the user in such situations? We address
                             these issues throughout the book.



                             7.4 Resource Concepts
                             As a resource manager, the operating system is responsible for the allocation of a
                             vast array of resources of various types; this is part of what makes operating system
                             design so interesting. We consider resources that are preemptible, such as proces-
                             sors and main memory. Processors are perhaps the most frequently preempted
                             resources on a computer system. Processors must be rapidly switched (i.e., multi-
                             plexed) among all active processes competing for system service to ensure that
                             these processes progress at a reasonable rates. Whenever a particular process
                             reaches a point at which it cannot effectively use a processor (such as during a long

<!-- pág. 356 -->

                                                                      7.5    Four Necessary Conditions for Deadlock 299

    wait for input/output completion), the operating system dispatches another process
to that processor. As we will see in Chapters 9,10 and 11, a user program currently
  occupying a particular range of locations in main memory may be removed or pre-
    empted by another program. Preemption is thus extremely critical to the success of
   multiprogrammed computer systems.
       Certain resources are nonpreemptible; they cannot be removed from the pro-
   ----es to which they are assigned until the processes voluntarily release them. For
   example, tape drives and optical scanners are normally assigned to a particular pro-
  cess for periods of minutes or hours.
       Some resources may be shared among several processes, while others are ded-
icated to a single process at a time. Although a single processor can normally belong
 to only one process at a time, its multiplexing among many processes creates the
illusion of simultaneous sharing. Disk drives are sometimes dedicated to single pro-
  cesses, but typically they contain files that can be accessed by many processes. Disks
 can be multiplexed among many processes requesting I/O.
       Data and programs certainly are resources that the operating system must
   control and allocate. On multiprogramming systems, many users may simulta-
 neously want to use an editor program. If the operating system maintained in main
   memory a separate copy of the editor for each program, there would be a signifi-
cant amount of redundant data, wasting memory. A better technique is for the
    operating system to load one copy of the code in memory and to make the copy
  available to each user. If a process were allowed to modify this shared code, other
processes might behave unpredictably. As a result, this code must be reentrant,
   meaning the code is not modified as it executes. Code that may be changed but is
reinitialized each time it is used is said to be serially reusable. Reentrant code may
be shared by several processes simultaneously, whereas serially reusable code may
be used correctly by only one process at a time.
       When we call particular resources shared, we must be careful to state whether
they may be used by several processes simultaneously by only one process at a time.
The latter kind—serially reusable resources —are the ones that tend to become
 involved in deadlocks.


Self Review
1. (T/F) Processes do not deadlock as a result of contending for the processor.
2. (T/F) Nonpreemptible resources must be hardware.
Ans: 1) True. The processor is a preemptible resource that can easily be taken from a pro-
cess, assigned to other processes and returned to the original process, enabling it to proceed
normally. 2) False. Certain software resources are nonpreemptible, e.g., monitors.



7.5 F o u r Necessary Conditions for Deadlock
Coffman, Elphick and Shoshani 7 proved that the following four conditions are nec-
essary for deadlock to exist:

<!-- pág. 357 -->

300 Deadlock and Indefinite Postponement

                                    1. A resource may be acquired exclusively by only one process at a time
                                       (mutual exclusion condition).
                                    2. A process that has acquired an exclusive resource may hold that resource
                                       while the process waits to obtain other resources (wait-for condition, also
                                       called the hold-and-wait condition).
                                    3. Once a process has obtained a resource, the system cannot remove it from
                                       the process's control until the process has finished using the resource (no-
                                       preemption condition).
                                    4. Two or more processes are locked in a "circular chain" in which each pro-
                                       cess is waiting for one or more resources that the next process in the chair.
                                       is holding (circular-wait condition).
                                    Because these are necessary conditions, the existence of a deadlock implies that
                             each of them must be in effect. As we will see later, this observation helps us develop
                             schemes to prevent deadlocks. Taken together, all four conditions are necessary and
                             sufficient for deadlock to exist (i.e., if they are all in place, the system is deadlocked).

                             Self Review
                             1. Describe how the four necessary conditions for deadlock apply to spooling systems.
                             2. Which of the four conditions would be violated if a user could remove jobs from a spool-
                                ing system?
                             Ans: 1) No two jobs can simultaneously write data to the same location in the spooling file.
                             Partially spooled jobs remain in the spooling file until more space is available. Jobs cannot
                             remove other jobs from the spooling file. Finally, when the spooling file is full, each job waits for
                             all of the other jobs to free up space. 2) This would violate the "no-preemption" condition.


                             7.6 Deadlock Solutions
                             Deadlock has been one of the more productive research areas in computer science
                             and operating systems. There are four major areas of interest in deadlock
                             research —deadlock prevention, deadlock avoidance, deadlock detection and dead-
                             lock recovery.
                                    In deadlock prevention our concern is to condition a system to remove any pos-
                             sibility of deadlocks occurring. Prevention is a clean solution as far as deadlock itself
                             is concerned, but prevention methods can often result in poor resource utilization.
                                    In deadlock avoidance the goal is to impose less stringent conditions than in
                             deadlock prevention in an attempt to get better resource utilization. Avoidance
                             methods do not precondition the system to remove all possibility of deadlock.
                             Instead, they allow the possibility to loom, but whenever a deadlock is approached,
                             it is carefully sidestepped.
                                    Deadlock detection methods are used in systems in which deadlocks can
                             occur. The goal is to determine if a deadlock has occurred, and to identify the pro-
                             cesses and resources that are involved.

<!-- pág. 358 -->

                                                                                                  7.7 Deadlock Prevention   301

      Deadlock recovery methods are used to clear deadlocks from a system so that it
 may operate free them, and so that the deadlocked processes may complete their exe-
    cution and free their resources. Recovery is a messy problem at best, typically requir-
  ing that one or more of the deadlocked processes be flushed from the system. The
   flushed processes are normally restarted from the beginning when sufficient resources
 are available, with much or all of the work done by these processes being lost.

Self Review
1. Compare and contrast deadlock prevention and deadlock avoidance.
2. Some systems ignore the problem of deadlock. Discuss the costs and benefits of this
   approach.
Ans: 1.) Deadlock prevention makes deadlock impossible but results in lower resource uti-
  lization. With deadlock avoidance, when the threat of deadlock approaches, it is sidestepped
   and resource utilization is higher. Systems using either deadlock prevention or deadlock
avoidance will be free of deadlocks. 2) Systems that ignore deadlock may fail when deadlock
 occurs. This is an unacceptable risk in mission-critical systems, but it may be appropriate in
other systems where deadlocks rarely occur and the "cost" of dealing with an occasional
  deadlock is lower than the costs of implementing deadlock prevention or avoidance schemes.


7.7 Deadlock Prevention
This section considers various methods of deadlock prevention and examines the
effects on both users and systems, especially from the standpoint of performance.8-9-10-
11, 12, 13
           Havender,14 observing that a deadlock cannot occur if a system denies any of
the four necessary conditions, suggested the following deadlock prevention strategies:
      • Each process must request all its required resources at once and cannot
        proceed until all have been granted.
      • If a process holding certain resources is denied a further request, it must
        release its original resources and, if necessary, request them again together
        with the additional resources.
      • A linear ordering of resources must be imposed on all processes; i.e., if a
        process has been allocated certain resources, it may subsequently request
        only those resources later in the ordering.
In the sections that follow, we consider each strategy independently and discuss
how each denies one of the necessary conditions (see the Anecdote, No Nuts, Bolts
or Screws Allowed). Note that Havender presents three strategies, not four. The
first necessary condition, namely that processes claim exclusive use of the resources
they require, is not one that we want to break, because we specifically want to allow
dedicated (i.e., serially reusable) resources.

Self Review
1. What is the basic premise of Havender's research on deadlock prevention?
Ans: Deadlock cannot occur in systems in which any of the necessary conditions for dead-
lock are precluded.

<!-- pág. 359 -->

302 Deadlock and Indefinite Postponement

                                7.7.1 Denying the "Wait-For" Condition
                                Havender's first strategy requires that all of the resources a process needs to com-
                                plete its task must be requested at once. The system must grant them on an "all or
                                none" basis. If all the resources needed by a process are available, then the system
                                may grant them all to the process at once, and the process may continue to execute.
                                If they are not all available, then the process must wait until they are. While the pro-
                                cess waits, however, it may not hold any resources. Thus the "wait-for" condition is
                                denied, and deadlocks cannot occur.
                                      Although this strategy successfully prevents deadlock, it wastes resources. For
                                example, a program requiring four tape drives at one point in its execution must
                                request, and receive, all four before it begins executing. If all four drives are needed
                                throughout the execution of the program, then there is no serious waste. But, sup-
                                pose the program needs only one tape drive to begin execution (or worse yet, none




                Anecdote
    No Nuts, Bolts or Screws Allowed
    Some years ago, HMD had the           previous lines of printers to nuts,     then proceeded to assemble one
    privilege of visiting one of the      bolts and screws that had loos-         of the printers by hand from the
    automated factories of one of the     ened as a consequence of the            pieces sitting on his table. At the
    largest computer vendors. At the      mechanical motion. So when they         end of the demo, he plugged the
    time, the factory—run almost          designed the printer that was           printer into a wall socket and
    exclusively by robots—was pro-        being produced at this factory,         printed several pages to show
    ducing small inexpensive printers     the design team made a pact that        that it was up and running. He
    for personal computers. The head      all the parts of this printer (there    mentioned that the "mean-time-
    of the factory made a strong          were about 80 of them including         to-failure" of this type of printer
    point. He observed that printers      the casing) would be designed to        was proven to be miniscule corn-
    have a significant number of mov-     snap into place—no nuts, bolts or       pared to previous lines.
    ing parts and that the company's      screws would be allowed in the
    engineers had traced failures of      design. The head of the factory


    Lesson to operating systems designers: One way to minimize the chance of system failure is to eliminate as
    many "points of failure" as possible at the design stage. This works well with another design heuristic—KIS
    (keep it simple). Both of these heuristics are appealing, but can be difficult to implement. As you read this
    book, keep this anecdote in mind, searching for points of failure that you may be able to eliminate in future
    operating systems designs.

<!-- pág. 360 -->

                                                                                               7.7   Deadlock   Prevention 303

 at all) and then does not need the remaining tape drives for several hours. The
requirement that the program must request, and receive, all four tape drives before
  execution begins means that substantial resources will sit idle for several hours.
       One approach to getting better resource utilization in these circumstances is
to divide a program into several threads that run relatively independently of one
 another. Then resource allocation can be controlled by each thread rather than for
 the entire process. This can reduce waste, but it involves a greater overhead in
 application design and execution.
       This Havender strategy could cause indefinite postponement if, for example, it
favored waiting processes with small resource needs over those attempting to accu-
mulate many resources. A steady stream of processes arriving with small resource
needs could indefinitely postpone a process with more substantial needs. One way
  to avoid this is to handle the needs of the waiting processes in first-come-first-
served order. Unfortunately, accumulating the full complement of resources for a
process with substantial needs would cause considerable waste, as the gradually
accumulating resources would sit idle until all were available.
       In large mainframe computer environments with expensive resources, there is
some controversy over whom to charge for these unused resources. Because the
resources are being accumulated for a specific user, some designers feel this user
should pay for them, even while they sit idle. Other designers say this would destroy
 the predictability of resource charges; if the user tried to run the process on a busy
  day, the charges would be much higher than when the machine was lightly loaded.


Self Review
1. Explain how denying the "wait-for" condition can reduce the degree of multiprogram-
   ming in a system.
2. Describe under what conditions a process can be indefinitely postponed when using Hav-
   ender's scheme to deny the "wait-for" condition.
Ans: 1) If processes in a system require more resources than are available to concurrently
execute, the system must force some of those processes to wait until others finish and return
their resources. In the worst case, the system may be limited to executing only one process at
 a time. 2) A process could request a substantial number of a system's resources. If the operat-
 ing system gives higher priority to processes that require fewer of system resources, then the
process requesting all of the system's resources will be postponed indefinitely while processes
that require fewer resources proceed.




7.7.2 Denying the "No-Preemption" Condition
Havender's second strategy denies the "no preemption" condition. Suppose a sys-
tem does allow processes to hold resources while requesting additional resources.
As long as sufficient resources remain available to satisfy all requests, the system
cannot deadlock. But consider what happens when a request for additional
resources cannot be satisfied. Now a process holds resources that a second process

<!-- pág. 361 -->

304 Deadlock and Indefinite Postponement

                             may need in order to proceed, while the second process may hold resources needed
                             by the first process—a two-process deadlock.
                                   Havender's second strategy requires that when a process holding resources is
                             denied a request for additional resources, it must release the resources it holds and,
                             if necessary, request them again together with the additional resources. This strat-
                             egy effectively denies the "no-preemption" condition—resources can indeed be
                             removed from the process holding them prior to the completion of that process.
                                   Here, too, the means for preventing deadlock can be costly. When a process
                             releases resources, it may lose all of its work to that point. This may seem to be a
                             high price to pay, but the real question is, "How often does this price have to be
                             paid?" If this occurs infrequently, then this strategy provides a relatively low-cost
                             means of preventing deadlocks. If it occurs frequently, however, then the cost is
                             substantial and the effects are disruptive, particularly when high-priority or dead-
                             line processes cannot be completed on time because of repeated preemptions.
                                   Could this strategy lead to indefinite postponement? It depends. If the system
                             favors processes with small resource requests over those requesting substantial
                             resources, that alone could lead to indefinite postponement. Worse yet, as the pro-
                             cess requests additional resources, this Havender strategy requires the process to
                             give up all the resources it has and request an even larger number. So indefinite
                             postponement can be a problem in a busy system. Also, this strategy requires all
                             resources to be preemptible, which is not always the case (e.g., printers should not
                             be preempted while processing a print job).


                             Self Review
                             1. What is the primary cost of denying the "no-preemption" condition?
                             2. Which of Ha vender's first two deadlock strategies do you suppose people find more palat-
                                able? Why?
                             Ans: 1) A process may lose all of its work up to the point that its resources were preempted.
                             Also, the process could suffer indefinite postponement, depending on the system's resource-
                             allocation strategy. 2) Most people probably would prefer the first strategy, namely, requiring
                             a process to request all the resources it will need in advance. The second strategy requires the
                             process to give up the resources it already has, possibly causing wasteful loss of work. Inter-
                             estingly, the first strategy could cause waste as well, as processes gradually acquire resources
                             they cannot yet use.



                             7.7.3 Denying the "Circular-Wait" Condition
                             Havender's third strategy denies the possibility of a circular wait. In this strategy.
                             we assign a unique number to each resource (e.g., a disk drive, printer, scanner, file)
                             that the system manages and we create a linear ordering of resources. A process
                             must then request its resources in a strictly ascending order. For example, if a pro-
                             cess requests resource R3 (where the subscript, 3, is the resource number), then the
                             process can subsequently request only resources with a number greater than 3.

<!-- pág. 362 -->

                                                                                                7.7 Deadlock Prevention 305

Because all resources are uniquely numbered, and because processes must request
  resources in ascending order, a circular wait cannot develop (Fig. 7.5). [Note: A
   proof of of this property is straightforward. Consider a system that enforces a linear
   ordering of resources in which Ri and Rj are resources numbered by integers i and j,
    respectively (i ≠ j). If the system has a circular wait characteristic of deadlock,
    then according to Fig. 7.5, at least one arrow (or set of arrows) leads upward from
  Ri to Rj and an arrow (or set of arrows) exists leading down from Rj to Ri. How-
ever, the linear ordering of resources with the requirement that resources be
requested in ascending order implies that no arrow can ever lead from Rj to Ri if j >
i, Therefore deadlock cannot occur in this system.]
       Denying the "circular-wait" condition has been implemented in a number of
 legacy operating systems, but not without difficulties.15, 16, 17, 18 One disadvantage of
 this strategy is that it is not as flexible or dynamic as we might desire. Resources
must be requested in ascending order by resource number. Resource numbers are
  assigned for the computer system and must be "lived with" for long periods (i.e.,
 months or even years). If new resources are added or old ones removed at an instal­
lation, existing programs and systems may have to be rewritten.
       Another difficulty is determining the ordering of resources in a system.
    Clearly, the resource numbers should be assigned to reflect the order in which most
processes actually use the resources. For processes matching this ordering, more
efficient operation may be expected. But for processes that need the resources in a
   different order than that specified by the linear ordering, resources must be
 acquired and held, possibly for long periods of time, before they are actually used.
This can result in poor performance.
       An important goal in today's operating systems is to promote software porta-
    bility across multiple environments. Programmers should be able to develop their
applications without being impeded by awkward hardware and software restric-
tions. Havender's linear ordering truly eliminates the possibility of a circular wait,
  yet it diminishes a programmer's ability to freely and easily write application code
that will maximize an application's performance.



Self Review
1. How does a linear ordering for resource allocation reduce application portability?
2. (T/F) Imposing a linear ordering for resource requests yields higher performance than
   denying the "no-preemption" condition.
Ans: 1) Different systems will normally have different sets of resources and may order
resources differently, so an application written for one system may need to be modified to
run effectively on another. 2) False. There are situations where each solution results in higher
performance because the solution requires insignificant overhead. If a system's processes
each request disjoint sets of resources, denying "no preemption" is quite efficient. If a process
uses resources in an order corresponding to the system's linear ordering, then denying the
 "circular wait" condition can result in higher performance.

<!-- pág. 363 -->

306 Deadlock and Indefinite Postponement




                                                                   Process P1 has obtained resources R3,
                                                                   R4, R6 and R7, and is requesting
                                                                   resource R8 (as indicated by the
                                                                   dotted line). No circular wait can
                                                                   develop because all arrows must
                                                                   point upward.




                             Figure 7.5 | Havender's linear ordering of of resources for preventing deadlock.


                             7.8 Deadlock Avoidance with Dijkstra's Banker's Algorithm
                             For some systems, it is impractical to implement the deadlock prevention strategies
                             we discussed in the preceding section. However, if the necessary conditions for a

<!-- pág. 364 -->

                                                   7.8 Dealock Avoidance with Dijkstra's Banker's Algorithm 307

deadlock to occur are in place, it is still possible to avoid deadlock by carefully allo-
--ting system resources. Perhaps the most famous deadlock avoidance algorithm is
Dijkstra's Banker's Algorithm, so named because the strategy is modeled after a
banker who makes loans from a pool of capital and receives payments that are
returned to that pool.19, 20, 21, 22, 23 We paraphrase the algorithm here in the context
 of operating systems resource allocation. Subsequently, much work has been done
in deadlock avoidance.24, 25, 26, 27, 28, 29, 30, 31
      The Banker's Algorithm defines how a particular system can prevent dead-
lock by carefully controlling how resources are distributed to users (see the Anec-
dote, Acronyms). A system groups all the resources it manages into resource types.
Each resource type corresponds to resources that provide identical functionality. To
simplify our presentation of the Banker's Algorithm, we limit our discussion to a
system that manages only one type of resource. The algorithm is easily extendable
to pools of resources of various types; this is left to the exercises.
      The Banker's Algorithm prevents deadlock in operating systems that exhibit
the following properties:
     • The operating system shares a fixed number of resources, t, among a fixed
       number of processes, n.
     • Each process specifies in advance the maximum number of resources that it
       requires to complete its work.
     • The operating system accepts a process's request if that process's maximum
       need does not exceed the total number of resources available in the system,
       t (i.e., the process cannot request more than the total number of resources
       available in the system).
     • Sometimes, a process may have to wait to obtain an additional resource,
       but the operating system guarantees a finite wait time.
     • If the operating system is able to satisfy a process's maximum need for
       resources, then the process guarantees that the resource will be used and
       released to the operating system within a finite time.




                Anecdote
  Acronyms
  Most computer folks are familiar         which nicely describe the relation-     what I want when I want it." The
  w i t h the acronym WYSIWYG for          ship between the process request-       operating system responds,
   " w h a t you see is what you get."     ing resources and the operating          "You'll get what I've got when I
  Few people have seen these t w o -       system attempting to allocate           get it."
  IWWIWWIWI and YGWIGWIGI,                 them. The process says, "I want

<!-- pág. 365 -->

308 Deadlock and Indefinite Postponement

                                   The system is said to be in a safe state if the operating system can guarantee
                             that all current processes can complete their work within a finite time. If not, then
                             the system is said to be in an unsafe state.
                                   We also define four terms that describe the distribution of resources among
                             processes.
                                   • Let max(Pi) be the maximum number of resources that process Pi requires
                                     during its execution. For example, if process P3 never requires more than
                                     two resources, then max(P3) = 2.
                                   • Let loan(Pi) represent process P i 's current loan of a resource, where its
                                     loan is the number of resources the process has already obtained from the
                                     system. For example, if the system has allocated four resources to process
                                     P 5 , then loan(P5) = 4.
                                   • Let claim(Pi) be the current claim of a process, where a process's claim is
                                     equal to its maximum need minus its current loan. For example, if process
                                     P7 has a maximum need of six resources and a current loan of four
                                     resources, then we have
                                         claim(P7) = max( P7) - loan(P7) = 6 - 4 = 2
                                   • Let a be the number of resources still available for allocation. This is equiv-
                                     alent to the total number of resources (t) minus the sum of the loans to all
                                     the processes in the system, i.e.,




                                  So, if the system has a total of three processes and 12 resources, and the sys-
                             tem has allocated two resources to process P 1 , one resource to process P 2 and four
                             resources to process P3, then the number of available resources is
                                   a = 12 - (2 + 1 + 4) = 12 - 7 = 5
                                   Dijkstra's Banker's Algorithm requires that resources be allocated to pro-
                             cesses only when the allocations result in safe states. In that way, all processes
                             remain in safe states at all times, and the system will never deadlock.

                            Self Review
                             1. (T/F) An unsafe state is a deadlocked state.
                             2. Describe the restrictions that the Banker's Algorithm places on processes.
                            Ans: 1) False. A process in an unsafe state might eventually deadlock, or it might complete
                            its execution without entering deadlock. What makes the state unsafe is simply that the oper-
                            ating system cannot guarantee that from this state all processes can complete their work.
                            From an unsafe state, it is possible but not guaranteed that all processes could complete their
                            work, so a system in an unsafe state could eventually deadlock. 2) Each process, before it
                            runs, is required to specify the maximum number of resources it may require at any point
                            during its execution. Each process cannot request more than the total number of resources in

<!-- pág. 366 -->

                                                        7.8 Deadlock Avoidance with Dijkstra's Banker's Algorithm 309

  the system. Each process must also guarantee that once allocated a resource, the process will
  eventually return that resource to the system within a finite time.


7.8.1 Example of a Safe State
Suppose a system contains 12 equivalent resources and three processes sharing the
resources, as in Fig. 7.6. The second column contains the maximum need for each
  process, the third column the current loan for each process and the fourth column
  the current claim for each process. The number of available resources, a, is two; this
is computed by subtracting the sum of the current claims from the total number of
 resources, t= 12.
        This state is "safe" because it is possible for all three processes to finish. Note
  that process P2 currently has a loan of four resources and will eventually need a max-
  imum of six, or two additional resources. The system has 12 resources, of which 10 are
  currently in use and two are available. If the system allocates these two available
resources to P 2 , fulfilling P 2 's maximum need, then P 2 can run to completion. Note
that after P2 finishes, it will release six resources, enabling the system to immediately
fulfill the maximum needs of P1 (3) and P3 (3), enabling both of those processes to fin-
ish. Indeed, all processes can eventually finish from the safe sate of Fig. 7.6.

Self Review
1. In Fig. 7.6, once P2 runs to completion, must P1 and P3 run sequentially one after the
   other, or could they run concurrently?
2. Why did we focus initially on allowing P2 to finish rather than focusing on either P1 or P 3 ?
Ans: 1) P 1 and P 3 each need three more resources to complete. When P 2 finishes, it will
release six resources, which is enough to allow P1 and P3 to run concurrently. 2) Because P2 is
the only process whose current claim can be satisfied by the two available resources.


7.8.2 Example of an Unsafe State
 Assume a system's 12 resources are allocated as in Fig. 7.7. We sum the values of
the third column and subtract from 12 to obtain a value of one for a. At this point,
no matter which process requests the available resource, we cannot guarantee that
all three processes will finish. In fact, suppose process P1 requests and is granted the
last available resource. A three-way deadlock could occur if indeed each process

               max( Pi)                      loan ( Pi )              claim( Pi )
 Process       (maximum need)                (current loan)           (current claim)
 P1            4                             1                         3
 P2            6                             4                         2
 P3            8                             5                         3
 Total resources, X, = 12                    Available resources, a, = 2

Figure 7.6 | Safe State.

<!-- pág. 367 -->

310 Deadlock and Indefinite Postponement

                                             max( Pi ) loan( Pi )                        claim ( Pi )
                               Process     (maximum need)   (current                     loan) (current claim)
                               P1             10                          8                        2
                               p2             5                           2                        3
                               p3             3                           1                        2
                               Total resources, t, = 12                   Available resources, a, = 1

                             Figure 7.7 | Unsafe state.

                              needs to request at least one more resource before releasing any resources to the
                              pool. It is important to note here that an unsafe state does not imply the existence of
                              deadlock, nor even that deadlock will eventually occur. What an unsafe state does
                              imply is simply that some unfortunate sequence of events might lead to a deadlock.



                              1. Why is deadlock possible, but not guaranteed, when a system enters an unsafe state?
                              2. What minimum number of resources would have to be added to the system of Fig. 7.7 to
                                 make the state safe?
                             Ans: 1) Processes could give back their resources early, increasing the number of available
                             resources to the point that the state of the system was once again safe and all other processes
                             could finish. 2) By adding one resource, the number of available resources becomes two,
                             enabling P1 to finish and return its resources, enabling both P2 and P3 to finish. Hence the
                             new state is safe.



                              7.8.3      Example      of    Safe-State-to-Unsafe-State         Transition
                              Our resource-allocation policy must carefully consider all resource requests before
                              granting them, or a process in a safe state could enter an unsafe state. For example,
                              suppose the current state of a system is safe, as shown in Fig. 7.6. The current value
                              of a is 2. Now suppose that process P3 requests an additional resource. If the system
                              were to grant this request, then the new state would be as in Fig. 7.8. Now, the cur-
                              rent value of a is 1, which is not enough to satisfy the current claim of any process,
                              so the state is now unsafe.


                                            max( Pi )  loan(     Pi                 )    claim(    Pi          )
                               Process     (maximum need)    (current                loan)   (current         claim)
                               P1            4                            1                        3

                               P2            6                            4                        2

                               P3            8                            6                        2
                               Total resources, t, = 12                  Available resources, a, = 1

                             Figure 7.8 | Safe-state-to-unsafe-state transition.

<!-- pág. 368 -->

                                                            7.8 Deadlock Avoidance with Dijkstra's Banker's Algorithm 311

Self Review
1. If process P2 requested one additional resource in Fig. 7.6, would the system be in a safe
   or an unsafe state?
2. (TIF) A system cannot transition from an unsafe state to a safe state.
Ans: 1) The system would still be in a safe state because there is a path of execution that
will not result in deadlock. For example, if P2 requests another resource, then P2 can com-
plete execution. Then there will be six available resources, which is enough for P 1 and P 3 to
finish. 2) False. As processes release resources, the number of available resources can become
sufficiently large for the state of the system to transition from unsafe to safe.


7.8.4        Banker's Algorithm Resource Allocation
Now it should be clear how resource allocation operates under Dijkstra's Banker's
Algorithm. The "mutual exclusion," "wait-for," and "no-preemption" conditions
are allowed—processes are indeed allowed to hold resources while requesting and
waiting for additional resources, and resources may not be preempted from a pro-
cess holding those resources. As usual, processes claim exclusive use of the
resources they require. Processes ease onto the system by requesting one resource
at a time; the system may either grant or deny each request. If a request is denied,
that process holds any allocated resources and waits for a finite time until that
request is eventually granted. The system grants only requests that result in safe
states. Resource requests that would result in unsafe states are repeatedly denied
until they can eventually be satisfied. Because the system is always maintained in a
safe state, sooner or later (i.e., in a finite time) all requests can be satisfied and all
users can finish.

Self Review
1. (T/F) The state described by Figure 7.9 is safe.
2. What minimum number of additional resources, when added to the system of Fig. 7.9,
   would make the state safe?
Ans: 1) False. There is no guarantee that all of these processes will finish. P2 will be able to
finish by using up the two remaining resources. However, once P2 is done, there are only
three available resources left. This is not enough to satisfy either P 1 's claim of 4 or P 3 's claim
of five. 2) By adding one more resource, we could allow P2 to finish and return three
resources. These plus the added resource would enable P1 to finish, returning five resources
and enabling P3 to finish.


 Process        max(       Pi    )     loan(        Pi     )      claim(       Pi      )
  P1                  5                         1                          4
  P2                  3                         1                          2
  P3                  10                        5                          5
                                                a=2

Figure 7.9     | State description of three processes.

<!-- pág. 369 -->

312 Deadlock and Indefinite Postponement

                             7.8.5 Weaknesses in the Banker's Algorithm
                             The Banker's Algorithm is compelling because it allows processes to proceed that
                             might have had to wait under a deadlock prevention situation. But the algorithm
                             has a number of weaknesses.
                                   • It requires that there be a fixed number of resources to allocate. Because
                                     resources frequently require service, due to breakdowns or preventive
                                     maintenance, we cannot count on the number of resources remaining fixed.
                                     Similarly, operating systems that support hot swappable devices (e.g., USB
                                     devices) allow the number of resources to vary dynamically.
                                   • The algorithm requires that the population of processes remains fixed. This,
                                     too, is unreasonable. In today's interactive and multiprogrammed systems.
                                     the process population is constantly changing.
                                   • The algorithm requires that the banker (i.e., the system) grant all requests
                                     within a "finite time." Clearly, much better guarantees than this are needed
                                     in real systems, especially real-time systems.
                                   • Similarly, the algorithm requires that clients (i.e., processes) repay all loans
                                     (i.e., return all resources) within a "finite time." Again, much better guaran-
                                     tees than this are needed in real systems.
                                   • The algorithm requires that processes state their maximum needs in
                                     advance. With resource allocation becoming increasingly dynamic, it is
                                     becoming more difficult to know a process's maximum needs. Indeed, one
                                     main benefit of today's high-level programming languages and "friendly"
                                     graphical user interfaces is that users are not required to know such low-
                                     level details as resource use. The user or programmer expects the system to
                                     "print the file" or "send the message" and should not need to worry about
                                     what resources the system might need to employ to honor such requests.
                                  For the reasons stated above, Dijkstra's Banker's Algorithm is not imple-
                             mented in today's operating systems. In fact, few systems can afford the overhead
                             incurred by deadlock avoidance strategies.

                             Self Review
                             1. Why does the Banker's Algorithm fail in systems that support hot swappable devices?
                             Ans: The Banker's Algorithm requires that the number of resources of each type remain
                             fixed. Hot swappable devices can be added and removed from the system at any time, mean-
                             ing that the number of resources of each type can vary.



                             7.9 Deadlock Detection
                             We have discussed deadlock prevention and avoidance —two strategies for ensuring
                             that deadlocks do not occur in a system. Another strategy is to allow deadlocks to
                             occur, locate them and remove them, if possible. Deadlock detection is the process
                             of determining that a deadlock exists and identifying the processes and resources

<!-- pág. 370 -->

                                                                                                                    7.9 Deadlock Detection 313

      involved in t h e d e a d l o c k . 3 2 , 33, 34, 35, 36, 37, 38, 39, 40 Deadlock detection algorithms gen-
   erally focus on determining if a circular wait exists, given that the other necessary
    conditions for deadlock are in place.
       Deadlock detection algorithms can incur significant runtime overhead. Thus
we again face the trade-offs so prevalent in operating systems—is the overhead
    involved in deadlock detection justified by the potential savings from locating and
 breaking up deadlocks? For the moment, we shall ignore this issue and concentrate
   instead on the development of algorithms capable of detecting deadlocks.

  7.9.1 Resource-Allocation Graphs
     To facilitate the detection of deadlocks, a popular notation (Fig. 7.10) is used in which
   a directed graph indicates resource allocations and requests.41 Squares represent pro-
   ----es and large circles represent classes of identical resources. Small circles drawn
    inside large circles indicate the separate identical resources of each class. For exam-
  ple, a large circle labeled "R 1 " containing three small circles indicates that there are
    three equivalent resources of type R1 available for allocation in this system.
        Figure 7.10 illustrates the relationships that may be indicated in a resource-
 allocation and request graph. In Fig. 7.10(a), process P1 is requesting a resource of
 type R1. The arrow from P1 touches only the extremity of the large circle, indicating
   that the resource request is under consideration.
        In Fig. 7.10(b), process P2 has been allocated a resource of type R2 (of which
   there are two).The arrow is drawn from the small circle within the large circle R2 to
 the square P 2 , to indicate that the system has allocated a specific resource of that
   type to the process.
        Figure 7.10(c) indicates a situation somewhat closer to a potential deadlock.
 Process P3 is requesting a resource of type R 3 , but the system has allocated the only
 R3 resource to process P 4 .
        Figure 7.10(d) indicates a deadlocked system in which process P5 is requesting
 a resource of type R 4 , the only one of which the system has allocated to process P6.
 Process P6, is requesting a resource of type R 5 , the only one of which the system has
  allocated to process P 5 . This is an example of the "circular wait" necessary for a
 deadlocked system.
        Resource-allocation and request graphs change as processes request
 resources, acquire them and eventually release them to the operating system.


 Self Review
 1. Suppose a process has control of a resource of type R1. Does it matter which small circle
    points to the process in the resource-allocation graph?
 2. What necessary condition for deadlock is easier to identify in a resource-allocation graph
    than it is to locate by analyzing the resource-allocation data of all the system's processes?
 Ans: 1) No; all resources of the same type must provide identical functionality, so it does
 not matter which small circle within the circle R1 points to the process. 2) Resource-alloca-
 tion graphs make it easier to identify circular waits.

<!-- pág. 371 -->

314 Deadlock and Indefinite Postponement




                             Figure 7.10 | Resource-allocation and request graphs.

                             7.9.2 Reduction of Resource-Allocation Graphs
                             One technique useful for detecting deadlocks involves graph reductions, in which
                             the processes that may complete their execution, if any, and the processes that will
                             remain deadlocked (and the resources involved in that deadlock), if any, are deter-
                             mined. 42
                                   If a process's resource requests may be granted, then we say that a graph may
                             be reduced by that process. This reduction is equivalent to showing how the graph
                             would look if the process was allowed to complete its execution and return its
                             resources to the system. We reduce a graph by a process by removing the arrows to
                             that process from resources (i.e., resources allocated to that process) and by remov-
                             ing arrows from that process to resources (i.e., current resource requests of that
                             process). If a graph can be reduced by all its processes, then there is no deadlock. If
                             a graph cannot be reduced by all its processes, then the irreducible processes consti-
                             tute the set of deadlocked processes in the graph.
                                   Figure 7.11 shows a series of graph reductions demonstrating that a particular set
                             of processes is not deadlocked. Figure 7.10(d) shows an irreducible set of processes
                             that constitutes a deadlocked system. It is important to note here that the order in

<!-- pág. 372 -->

                                                                                         7.9 Deadlock Detection 315




Figure 7.11 | Graph reductions determining that no deadlock exists


which the graph reductions are performed does not matter: The final result will always
be the same. We leave the proof of this result to the exercises (see Exercise 7.29).

<!-- pág. 373 -->

316 Deadlock and Indefinite Postponement

                             Self Review
                             1. Why might deadlock detection be a better policy than either deadlock prevention or
                                deadlock avoidance? Why might it be a worse policy?
                             2. Suppose a system attempts to reduce deadlock detection overhead by performing dead-
                                lock detection only when there are a large number of processes in the system. What is one
                                drawback to this strategy?
                             Ans:    1) In general, deadlock detection places fewer restrictions on resource allocation,
                             thereby increasing resource utilization. However, it requires that the deadlock detection
                             algorithm be performed regularly, which can incur significant overhead. 2) Because deadlock
                             can occur between two processes, the system might not ever detect some deadlocks if the
                             number of processes in the system is small.


                             7.10 Deadlock Recovery
                             Once a system has become deadlocked, the deadlock must be broken by removing
                             one or more of the four necessary conditions. Usually, several processes will lose
                             some or all of the work they have accomplished. However, this may be a small price
                             to pay compared with leaving a system in a state where it cannot use some of its
                             resources.
                                   Recovery from deadlock is complicated by several factors. First, it may not be
                             clear that the system has become deadlocked. For example, most systems contain
                             processes that wake periodically, perform certain tasks, then go back to sleep.
                             Because such processes do not terminate until the system is shut down, and because
                             they rarely enter the active state, it is difficult to determine if they are deadlocked.
                             Second, most systems do not provide the means to suspend a process indefinitely,
                             remove it from the system and resume it (without loss of work) at a later time.
                             Some processes, in fact, such as real-time processes that must function continuously,
                             are simply not amenable to being suspended and resumed. Assuming that effective
                             suspend/resume capabilities did exist, they would most certainly involve consider-
                             able overhead and might require the attention of a highly skilled system administra-
                             tor. Such an administrator is not always available. Finally, recovery from deadlock is
                             complicated because the deadlock could involve many processes (tens, or even hun-
                             dreds). Given that recovering from deadlocks with even a small number of pro-
                             cesses could require considerable work, dealing with deadlock among many
                             hundreds (or even more) processes could be a monumental task.
                                   In current systems, recovery is ordinarily performed by forcibly removing a
                             process from the system and reclaiming its resources.43, 44 The system ordinarily
                             loses the work that the removed process has performed, but the remaining pro-
                             cesses may now be able to complete. Sometimes it is necessary to remove several
                             processes until sufficient resources have been reclaimed to allow the remaining pro-
                             cesses to finish. Recovery somehow seems like an inappropriate term here, because
                             some processes are in fact "killed" for the benefit of the others.
                                   Processes may be removed according to some priority order. Here, too, we
                             face several difficulties. For example, the priorities of the deadlocked processes may

<!-- pág. 374 -->

                                                                                           7.10 Deatlock Recovery 317
    not exist, so the system may need to make an arbitrary decision. The priorities also
    may be incorrect or somewhat muddled by special considerations, such as deadline
  scheduling, in which a relatively low-priority process has a high priority temporarily
 because of an impending deadline. Furthermore, it may require considerable effort
to determine the right processes to remove.
       The suspend/resume mechanism allows the system to put a temporary hold on
 a process (temporarily preempting its resources), and, when it is safe to do so, to
 resume the held process without loss of work. Research in this area is important for
reasons other than deadlock recovery. For example, a suspend/resume mechanism
 can be applied to a system as a whole, allowing a user to shut down the entire sys-
tem and start it later without loss of work. Such technology has been incorporated
  into many laptop systems, where limited battery life requires users to minimize
power consumption. The Advanced Configuration and Power Interface (ACPI), a
 popular specification for power management, defines a sleeping state in which the
 contents of memory, registers and other system state information are written to a
nonvolatile medium (such as the hard disk) and the system is powered off. In Win-
dows XP, this feature is known as "suspend to disk" or "hibernate." When the sys-
tem starts up again, it resumes from the point at which it entered the sleeping state
 without loss of work.45
       Checkpoint/rollback, the precursor to suspend/resume, is widely used in cur-
rent database systems. Checkpoint/rollback copes with system failures and dead-
locks by attempting to preserve as much data as possible from each terminated
process. Checkpoint/rollback facilitates suspend/resume capabilities by limiting the
 loss of work to the time at which the last checkpoint (i.e., saved state of the system)
was taken. When a process in a system terminates (by accident or intentionally as
the result of a deadlock recovery algorithm), the system performs a rollback by
undoing every operation related to the terminated process that occurred since the
last checkpoint.
       When databases may have many resources (perhaps millions or more) that
must be accessed exclusively, there can be a risk of deadlock. To ensure that data in
the database remains in a consistent state when deadlocked processes are termi-
nated, database systems typically perform resource allocations using transactions.
The changes specified by a transaction are made permanent only if the transaction
completes successfully. We discuss transactions in more detail in Chapter 13, File
and Database Systems.
       Deadlocks could have horrendous consequences in certain real-time systems.
A real-time process control system monitoring a gasoline refinery must function
without interruption for the refinery's safe and proper operation. A computerized
heart pacemaker must literally not "miss a beat." Deadlocks cannot be risked in
such environments. What would happen if a deadlock did develop? Clearly, it would
have to be detected and removed instantaneously. But is this always possible?
These are some of the considerations that keep operating systems designers from
restful sleep.

<!-- pág. 375 -->

318 Deadlock and Indefinite Postponement

                             Self Review
                              1. (T/F) A system can eliminate deadlock by choosing at random an irreducible process in a
                                 resource-allocation graph.
                              2. Why might a system that restarts a process it "kills" to break a deadlock suffer from poor
                                 performance?
                             Ans: 1) False. There may be multiple circular waits within the system by the time a dead-
                             lock is detected. 2) First, because killing a process causes loss of work. Second, because the
                             restarted process will execute the same code that caused the initial deadlock, and if the sys-
                             tem state has not changed, the system can become deadlocked repeatedly.


                              7.11 Deadlock Strategies in Current and Future Systems
                             In personal computer systems and workstations, deadlock has generally been
                             viewed as a limited annoyance. Some systems implement the basic deadlock pre-
                             vention methods suggested by Havender while others ignore the problem—these
                             methods seem to be satisfactory. While ignoring deadlocks may seem dangerous,
                             this approach can actually be rather efficient. Consider that today's systems can
                             contain thousands or millions of serially reusable objects on which processes and
                             threads can deadlock. The time required to execute a deadlock detection algorithm
                             can rise exponentially with the number of serially reusable objects in the system. If
                             deadlock is rare, then the processor time devoted to checking for deadlocks signifi-
                             cantly reduces system performance. In systems that are neither mission critical nor
                             business critical, the choice of ignoring deadlock to favor performance often out-
                             weighs the need for a solution to the occasional deadlock.
                                   Although some systems ignore deadlock that occurs due to user processes, it is
                             far more important to prevent deadlock in the operating system. Systems such as
                             Microsoft Windows provide debugger support, allowing developers to thoroughly
                             test drivers and applications to ensure that they acquire resources without causing
                             deadlock (e.g., they do not attempt to acquire locks in recursive routines, or they
                             specify lock acquisition in a certain order). 46 Interestingly, once such programs are
                             released, these testing mechanisms are often disabled to improve efficiency.47
                                   In real-time, mission-critical or business-critical systems the possibility of
                             deadlock cannot be tolerated. Researchers have developed techniques that handle
                             deadlock while minimizing data loss and maintaining good performance. For exam-
                             ple, deadlock is commonly addressed in distributed database systems, which could
                             provide concurrent access to billions of records for millions of users over thousands
                             of sites.48 Due to the large size of distributed database systems, they often do not
                             employ deadlock prevention or deadlock avoidance algorithms. Instead, they rely
                             on deadlock detection and recovery via checkpoint/rollback (using transactions).49
                             These techniques are beyond the scope of this chapter; see Chapter 17, Introduc-
                             tion to Distributed Systems, for an introduction to such methods.
                                   Given current trends, deadlock will continue to be an important area of
                             research for several reasons:

<!-- pág. 376 -->

                                                                                                      Web     Resources     319

      • Many large-scale systems are oriented more toward asynchronous parallel
        operations than toward the serial operations of the past. Multiprocessing is
        common, and parallel computation will be prevalent. Networks and distrib-
        uted systems are ubiquitous. There are, quite simply, more operations going
        on concurrently, more conflicts over resources and hence more chances of
        deadlock. Consequently, research on deadlock detection and recovery in
        distributed systems has become quite active.
      • With the increasing tendency of operating systems designers to view data
        as a resource, the number of resources that operating systems must manage
        is increasing dramatically. This is particularly evident in Web servers and
        database systems, which require high resource utilization and performance.
        This makes most deadlock prevention techniques impractical and deadlock
        recovery algorithms more important. Researchers have developed
        advanced transaction-based algorithms that ensure high resource utiliza-
        tion while maintaining a low cost of deadlock recovery.50
      • Hundreds of millions of computers are incorporated into common devices,
        particularly small, portable ones such as cell phones, PDAs and navigation
        systems. These systems, increasingly characterized as Systems-on-a-Chip
        (SoC), are limited by a small set of resources and the demands of real-time
        tasks.51, 52 Deadlock-free resource allocation in such systems is essential,
        because users cannot rely on an administrator to detect and rid the system
        of the deadlock.


Self Review
1. Why is deadlock prevention not a primary concern for many operating systems?
2. Why might deadlock in distributed systems be more difficult to detect than in a single
   computer?
Ans: 1) Deadlock is rare and is often considered a minor annoyance for most personal com-
puter users, who are often more concerned with operating system performance and features.
2) Deadlock in distributed systems can be difficult to detect because each computer is man-
aged by a different operating system, requiring each operating system to collect information
from other computers in order to construct its resource-allocation graph.




Web Resources
www.diee.unica.it/~giua/PAPERS/CONF/03smc_b.pdf                   www.linux-mag.com/2001-03/compi1e_01.html
Discusses an efficient approach to deadlock prevention in a       This Compile Time article describes how to deal with deadlock,
real-time system.                                                 using the Dining Philosophers example. The beginning of the
www.db.fmi.uni-passau.de/publications/techreports/                article also reviews mutual exclusion primitives (e.g., sema-
dda.html                                                          phores) and concurrent programming.
Describes a solution to deadlock detection in distributed sys-
tems.

<!-- pág. 377 -->

320 Deadlock and Indefinite Postponement

Summary
One problem that arises in multiprogrammed systems is              a time (mutual exclusion condition); a process that has
deadlock. A process or thread is in a state of deadlock (or is     acquired an exclusive resource may hold it while waiting to
deadlocked) if the process or thread is waiting for a partic-      obtain other resources (wait-for condition, also called the
ular event that will not occur. In a system deadlock, one or       hold-and-wait condition); once a process has obtained a
more processes are deadlocked. Most deadlocks develop              resource, the system cannot remove the resource from the
because of the normal contention for dedicated resources           process's control until the process has finished using the
(i.e., resources that may be used by only one user at a            resource (no-preemption condition); and two or more pro-
time). Circular wait is characteristic of deadlocked systems.      cesses are locked in a "circular chain" in which each process
       One example of a system that is prone to deadlock is        in the chain is waiting for one or more resources that the
a spooling system. A common solution is to restrain the            next process in the chain is holding (circular-wait condition).
input spoolers so that, when the spooling files begin to           Because these are necessary conditions for a deadlock to
reach some saturation threshold, they do not read in more          exist, the existence of a deadlock implies that each of them
print jobs. Today's systems allow printing to begin before         must be in effect. Taken together, all four conditions are nec-
the job is completed so that a full, or nearly full, spooling      essary and sufficient for deadlock to exist (i.e., if all these
file can be emptied or partially cleared even while a job is       conditions are in place, the system is deadlocked).
still executing. This concept has been applied to streaming               The four major areas of interest in deadlock research
audio and video clips, where the audio and video begin to          are deadlock prevention, deadlock avoidance, deadlock
play before the clips are fully downloaded.                        detection, and deadlock recovery. In deadlock prevention
       In any system that keeps processes waiting while it         our concern is to condition a system to remove any possi-
makes resource-allocation and process scheduling decisions,        bility of deadlocks occurring. Havender observed that a
it is possible to delay indefinitely the scheduling of a process   deadlock cannot occur if a system denies any of the four
while other processes receive the system's attention. This sit-    necessary conditions. The first necessary condition, namely
uation, variously called indefinite postponement, indefinite       that processes claim exclusive use of the resources they
blocking, or starvation, can be as devastating as deadlock.        require, is not one that we want to break, because we spe-
Indefinite postponement may occur because of biases in a           cifically want to allow dedicated (i.e., serially reusable)
system's resource scheduling policies. Some systems prevent        resources. Denying the "wait-for" condition requires that
indefinite postponement by increasing a process's priority as      all of the resources a process needs to complete its task be
it waits for a resource—this technique is called aging.            requested at once, which can result in substantial resource
       Resources can be preemptible (e.g., processors and          underutilization and raises concerns over how to charge for
main memory), meaning that they can be removed from a              resources. Denying the "no-preemption" condition can be
process without loss of work, or nonpreemptible meaning            costly, because processes lose work when their resources
that they (e.g., tape drives and optical scanners), cannot be      are preempted. Denying the "circular-wait" condition uses
removed from the processes to which they are assigned.             a linear ordering of resources to prevent deadlock. This
Data and programs certainly are resources that the operat-         strategy can increase efficiency over the other strategies,
ing system must control and allocate. Code that cannot be          but not without difficulties.
changed while in use is said to be reentrant. Code that may               In deadlock avoidance the goal is to impose less strin-
be changed but is reinitialized each time it is used is said to    gent conditions than in deadlock prevention in an attempt
be serially reusable. Reentrant code may be shared by sev-         to get better resource utilization. Avoidance methods allow
eral processes simultaneously, whereas serially reusable           the possibility of deadlock to loom, but whenever a dead-
code may be used by only one process at a time. When we            lock is approached, it is carefully sidestepped. Dijkstra's
call particular resources shared, we must be careful to state      Banker's Algorithm is an example of a deadlock avoidance
whether they may be used by several processes simulta-             algorithm. In the Banker's Algorithm, the system ensures
neously or by only one of several processes at a time. The         that a process's maximum resource need does not exceed
latter kind—serially reusable resources —are the ones that         the number of available resources. The system is said to be
tend to become involved in deadlocks.                              in a safe state if the operating system can guarantee that all
       The four necessary conditions for deadlock are: a           current processes can complete their work within a finite
resource may be acquired exclusively by only one process at        time. If not, then the system is said to be in an unsafe state.

<!-- pág. 378 -->

                                                                                                           Key     Terms    321
Dijkstra's Banker's Algorithm requires that resources be         Checkpoint/rollback facilitates suspend/resume capabilities
allocated to processes only when the allocations result in       by limiting the loss of work to the time at which the last
safe states. It has a number of weaknesses (such as requir-      checkpoint (i.e., saved state of the system) was taken.
ing a fixed number of processes and resources) that prevent      When a process in a system terminates (by accident or
it from being implemented in real systems.                       intentionally as the result of a deadlock recovery algo-
      Deadlock detection methods are used in systems in          rithm), the system performs a rollback by undoing every
which deadlocks can occur. The goal is to determine if a         operation related to the terminated process that occurred
deadlock has occurred, and to identify those processes and       since the last checkpoint. To ensure that data in the data-
resources involved in the deadlock. Deadlock detection           base remains in a consistent state when deadlocked pro-
algorithms can incur significant runtime overhead. To facili-    cesses are terminated, database systems typically perform
tate the detection of deadlocks, a directed graph indicates      resource allocations using transactions.
resource allocations and requests. Deadlock can be                      In personal computer systems and workstations, dead-
detected using graph reductions. If a process's resource         lock has generally been viewed as a limited annoyance.
requests may be granted, then we say that a graph may be         Some systems implement the basic deadlock prevention
reduced by that process. If a graph can be reduced by all its    methods suggested by Havender, while others ignore the
processes, then there is no deadlock. If a graph cannot be       problem—these methods seem to be satisfactory. While
reduced by all its processes, then the irreducible processes     ignoring deadlocks may seem dangerous, this approach can
constitute the set of deadlocked processes in the graph.         actually be rather efficient. If deadlock is rare, then the pro-
      Deadlock recovery methods are used to clear dead-          cessor time devoted to checking for deadlocks significantly
locks from a system so that it may operate free of the dead-     reduces system performance. However, given current trends,
locks, and so that the deadlocked processes may complete         deadlock will continue to be an important area of research as
their execution and free their resources. Recovery typically     the number of concurrent operations and number of
requires that one or more of the deadlocked processes be         resources become large, increasing the likelihood of dead-
flushed from the system. The suspend/resume mechanism            lock in multiprocessor and distributed systems. Also, many
allows the system to put a temporary hold on a process           real-time systems, which are becoming increasingly preva-
(temporarily preempting its resources), and, when it is safe     lent, require deadlock-free resource allocation.
to do so, resume the held process without loss of work.

Key Terms
Advanced Configuration and Power Interface (ACPI)—Power              circular chain such that each process is waiting for a
   management specification supported by many operating              resource held by the next process in the chain.
   systems that allows a system to turn off some or all of its   deadline scheduling—Scheduling a process or thread to com-
   devices without loss of work.                                     plete by a definite time; the priority of the process or
aging—Method of preventing indefinite postponement by                thread may need to be increased as its completion dead-
    increasing a process's priority gradually as it waits.           line approaches.
checkpoint—Record of a state of a system so that it can be       deadlock—Situation in which a process or thread is waiting for
    restored later if a process must be prematurely terminated       an event that will never occur.
    (e.g., to perform deadlock recovery).                        deadlock avoidance—Strategy that eliminates deadlock by
checkpoint/rollback—Method of deadlock and system recov-             allowing a system to approach deadlock, but ensuring that
    ery that undoes every action (or transaction) of a termi-        deadlock never occurs. Avoidance algorithms can achieve
    nated process since the process's last checkpoint.               higher performance than deadlock prevention algorithms.
circular wait—Condition for deadlock that occurs when two or         (See also Dijktra's Banker's Algorithm.)
     more processes are locked in a "circular chain," in which   deadlock detection—Process of determining whether or not a
     each process in the chain is waiting for one or more            system is deadlocked. Once detected, a deadlock can be
     resources that the next process in the chain is holding.        removed from a system, typically resulting in loss of work.
circular-wait necessary condition for deadlock—One of the        deadlock prevention—Process of disallowing deadlock by
     four necessary conditions for deadlock; states that if a        eliminating one of the four necessary conditions for dead-
     deadlock exists, there will be two or more processes in a       lock.

<!-- pág. 379 -->

322 Deadlock and Indefinite Postponement
deadlock recovery—Process of removing a deadlock from a            no-preemption necessary condition for deadlock—One of the
    system. This can involve suspending a process temporarily          four necessary conditions for deadlock; states that dead-
    (and preserving its work) or sometimes killing a process           lock can occur only if resources cannot be forcibly
    (thereby losing its work) and restarting it.                       removed from processes.
deadly embrace—See deadlock.                                       nonpreemptible resource—Resource that cannot be forcibly
dedicated resource—Resource that may be used by only one               removed from a process, e.g., a tape drive. Such resources
    process at a time. Also known as a serially reusable               are the kind that can become involved in deadlock.
    resource.                                                      preemptible resource—Resource that may be removed from a
Dijkstra's Banker's Algorithm—Deadlock avoidance algo-                 process such as a processor or memory. Such resources
     rithm that controls resource allocation based on the              cannot be involved in deadlock.
    amount of resources owned by the system, the amount of         reentrant code—Code that cannot be changed while in use and
    resources owned by each process and the maximum                     therefore can be shared among processes and threads.
     amount of resources that the process will request during
                                                                   resource allocation graph—Graph that shows processes and
    execution. Allows resources to be assigned to processes
                                                                        resources in a system. An arrow pointing from a process
    only when the allocation results in a safe state. (See also
                                                                        to a resource indicates that the process is requesting the
    safe state and unsafe state.)
                                                                       resource. An arrow pointing from a resource to a process
Dining Philosophers—Classic problem introduced by Dijkstra              indicates that the resource is allocated to the process.
    that illustrates the problems inherent in concurrent pro-           Such a graph helps determine if a deadlock exists and. if
    gramming, including deadlock and indefinite postpone-               so, helps identify the processes and resources involved in
    ment. The problem requires the programmer to ensure                 the deadlock.
    that a set of n philosophers at a table containing n forks,
                                                                   resource type —Grouping of resources that perform a common
    who alternate between eating and thinking, do not starve
                                                                        task.
    while attempting to acquire the two adjacent forks neces-
    sary to eat.                                                   safe state—State of a system in Dijkstra's Banker's Algorithm
graph reduction—Altering a resource-allocation graph by                 in which there exists a sequence of actions that will allow
    removing a process if that process can complete. This also          every process in the system to finish without the system
    involves removing any arrows leading to the process (from           becoming deadlocked.
    the resources allocated to the process) or away from the       saturation threshold—A level of resource utilization above
    process (to resources the process is requesting). A                 which the resource will refuse access. Designed to reduce
    resource-allocation graph can be reduced by a process if all        deadlock, it also reduces throughput.
    of that process's resource requests can be granted, enabling   serially reusable code—Code that can be modified but is reini-
    that process to run to completion and free its resources.           tialized each time it is used. Such code can be used by only
Havender's linear ordering—See linear ordering.                         one process or thread at a time.
linear ordering (Havender)—Logical arrangement of                  serially reusable resource—See dedicated resource.
     resources that requires that processes request resources in   shared resource—Resource that can be accessed by more than
     a linear order. This method denies the circular-wait neces-       one process.
     sary condition for deadlock.
                                                                   starvation—Situation in which a thread waits for an event that
maximum need (Dijkstra's Banker's Algorithm) —Characteris-
                                                                        might never occur, also called indefinite postponement.
    tic of a process in Dijkstra's Banker's Algorithm that
    describes the largest number of resources (of a particular     sufficient conditions for deadlock—The four conditions-
    type) the process will need during execution.                       mutual exclusion, no-preemption, wait-for and circular-
                                                                         wait-which are necessary and sufficient for deadlock.
mutual exclusion necessary condition for deadlock—One of
    the four necessary conditions for deadlock; states that        suspend/resume—Method of halting a process, saving its state,
    deadlock can occur only if processes cannot claim exclu-           releasing its resources to other processes, then restoring
    sive use of their resources.                                       its resources after the other processes have released them.
necessary condition for deadlock—Condition that must be            transaction—Atomic, mutually exclusive operation that either
    true for deadlock to occur. The four necessary conditions          completes or is rolled back. Modifications to database
    are the mutual exclusion condition, no-preemption condi-           entries are often performed as transactions to enable high
    tion, wait-for condition and circular-wait condition.              performance and reduce the cost of deadlock recovery.

<!-- pág. 380 -->

                                                                                                              Exercises 323
unsafe state—State of a system in Dijkstra's Banker's Algo-        wait-for condition—One of the four necessary conditions for
    rithm that might eventually lead to deadlock because                deadlock; states that deadlock can occur only if a process
    there might not be enough resources to allow any process            is allowed to wait for a resource while it holds another.
    to finish.


Exercises
7.1       Define deadlock.                                         indefinite postponement. What other means might the system
                                                                   use to prevent indefinite postponement?
7.2 Give an example of a deadlock involving only a single
                                                                   7.8 In a system of n processes, a subset of m of these pro-
process and a single resource.
                                                                   cesses is currently suffering indefinite postponement. Is it pos-
7.3    Give an example of a simple resource deadlock involv-       sible for the system to determine which processes are being
ing three processes and three resources. Draw the appropriate      indefinitely postponed?
resource-allocation graph.                                         7.9    (The Dining Philosophers) One of Dijkstra's more
7.4 What is indefinite postponement? How does indefinite           delightful contributions is his problem of the Dining Philoso-
postponement differ from deadlock? How is indefinite post-         phers. 53, 54 It illustrates many of the subtle problems inherent
ponement similar to deadlock?                                      in concurrent programming.
                                                                          Your goal is to devise a concurrent program (with a
7.5 Suppose a system allows for indefinite postponement of         monitor) that simulates the behavior of the philosophers. Your
certain entities. How would you as a systems designer provide      program should be free of deadlock and indefinite postpone-
a means for preventing indefinite postponement?                    ment—otherwise one or more philosophers might starve. Your
                                                                   program must, of course, enforce mutual exclusion—two phi-
7.6 Discuss the consequences of indefinite postponement in
                                                                   losophers cannot use the same fork at once.
each of the following types of systems.                                   Figure 7.12 shows the behavior of a typical philosopher.
          a. batch processing                                      Comment on each of the following implementations of a typi-
          b. timesharing                                           cal philosopher.
          c. real-time                                                    a. See Fig. 7.13.
                                                                          b. See Fig. 7.14.
7.7 A system requires that arriving processes must wait for
service if the needed resource is busy. The system does not use           c. See Fig. 7.15.
 aging to elevate the priorities of waiting processes to prevent          d. See Fig. 7.16.


      1    typical Philosopher()
      2    {
      3       while ( true )
      4       {
      5          think();
      6              eat();
      7       } // end w h i l e
      8    } // end t y p i c a l Philosopher

Figure 7.12 | Typical philosopher behavior for Exercise 7.9.

      1         typicalPhilosopher()
      2     {
      3           while ( true )
      4           {

Figure 7.13 | Philosopher behavior for Exercise 7.9(a) (Part 1 of 2.)

<!-- pág. 381 -->

324 Deadlock     and Indefinite Postponement


   5            think();
   6
   7            pickUpLeftFork();
   8            pickUpRightFork();
   9
  10            eat();
  11
  12            putDownLeftFork();
  13            putDownRightFork();
  14         } // end while
  15
  16   } // end typical Philosopher

Figure 7.13 | Philosopher behavior for Exercise 7.9(a). (Part 2 of 2.)


   1       typicalPhilosopher()
   2   {
   3         while ( true )
   4         {
   5            think();
   6
   7            pickUpBothForksAtOnce();
   8
   9            eat();
  10
  11            putDownBothForksAtOnce();
  12         } // end while
  13
  14   } // end typical Philosopher

Figure 7.14 | Phjlosopher behavior for Exercise 7.9(b).

   1    typicalPhilosopher()
   2   {
   3      while ( true )
   4      {
   5          think();
   6
   7            w h i l e ( notHoldingBothForks )
   8            {
   9                   pickUpLeftFork();
  10
  11               if ( r i g h t F o r k N o t A v a i l a b l e )
  12               {
  13                   putDownLeftFork();

Figure 7.15 | Philosopher behavior for Exercise 7.9(c). (Part 1 of 2.)

<!-- pág. 382 -->

                                                                          £Exercise   325

  14                } / / end if
  15               else
  16               {
  17                  pickUpRightFork();
  18               } // end w h i l e
  19            } // end else
  20
  21            eat();
  22
  23            putDownLeftFork() ;
  24            putDownRightFork();
  25         } // end while
  26
  27   } // end t y p i c a l Philosopher

 Figure 7.15 | Philosopher behavior for Exercise 7.9(c). (Part 2 of 2.)

   1       typicalPhilosopher()
   2   {
   3         while ( true )
   4         {
   5            think();
   6
   7            if ( philosopherID mod 2 == 0 )
   8            {
   9                pickUpLeftFork();
  10                pickUpRightFork();
  11
  12                eat();
  13
 14               putDownLeftFork();
 15               putDownRightFork();
 16            } // end if
 17            else
 18            {
 19               pickUpRightFork();
 20               pickUpLeftFork();
 21
 22                 eat();
 23
 24               putDownRightFork();
 25               putDownLeftFork();
 26            } /,/ end else
 27         } // end while
 28
 29    } // end typical Philosopher

Figure 7.16 | Philosopher behavior for Exercise 7.9(d).

<!-- pág. 383 -->

326 Deadlock and Indefinite Postponement

7.10 Define and discuss each of the following resource concepts.     7.19 Explain the intuitive appeal of deadlock avoidance over
                                                                     deadlock prevention.
      a. preemptible resource
                                                                     7.20 In the context of Dijkstra's Banker's Algorithm discuss
      b. nonpreemptible resource
                                                                     whether each of the states described in Fig. 7.17 and Fig. 7.18 is
      c. shared resource                                             safe or unsafe. If a state is safe, show how it is possible for all
      d. dedicated resource                                          processes to complete. If a state is unsafe, show how it is possi-
                                                                     ble for deadlock to occur.
      e. reentrant code
      f. serially reusable code                                      7.21 The fact that a state is unsafe does not necessarily imply
                                                                     that the system will deadlock. Explain why this is true. Give an
      g. dynamic resource allocation                                 example of an unsafe state and show how all of the processes
7.11 State the four necessary conditions for a deadlock to           could complete without a deadlock occurring.
exist. Give a brief intuitive argument for the necessity of each     7.22 Dijkstra's Banker's Algorithm has a number of weak-
individual condition.                                                nesses that preclude its effective use in real systems. Comment
7.12 In the context of the traffic deadlock, illustrated in          on why each of the following restrictions may be considered a
Fig. 7.1, discuss each of the necessary conditions for deadlock.     weakness in the Banker's Algorithm.
7.13 What are the four areas of deadlock research mentioned                  a. The number of resources to be allocated remains fixed.
in the text? Discuss each briefly.                                           b. The population of processes remains fixed.
7.14 Havender's method for denying the "wait-for" condition                  c. The operating system guarantees that resource
requires that processes must request all of the resources they                  requests will be serviced in a finite time.
will need before the system may let them proceed. The system                 d. Users guarantee that they will return held resources
grants resources on an "all-or-none" basis. Discuss the pros                    within a finite time.
and cons of this method.
                                                                             e. Users must state maximum resource needs in advance.
7.15 Why is Havender's method for denying the "no-preemp-
tion" condition not a popular means for preventing deadlock?         7.23 (Banker's Algorithm for Multiple Resource Types) Con-
                                                                     sider Dijkstra's Banker's Algorithm as discussed in Section 7.8,
7.16 Discuss the pros and cons of Havender's method for              Deadlock Avoidance with Dijkstra's Banker's Algorithm. Sup-
denying the "circular-wait" condition.                               pose that a system using this deadlock avoidance scheme has n
7.17 How does Havender's linear ordering for denying the             processes and m different resource types; assume that multiple
"circular-wait" condition prevent cycles from developing in          resources of each type may exist and that the number of
resource-allocation graphs?                                          resources of each type is known. Develop a version of the
                                                                     Banker's Algorithm that will enable such a system to avoid
7.18 A process repeatedly requests and releases resources of
                                                                     deadlock. [Hint: Under what circumstances could a particular
types R1 and R 2 , one at a time and in that order. There is
                                                                     process be guaranteed to complete its execution, and thus
exactly one resource of each type. A second process also
                                                                     return its resources to the pool?]
requests and releases these resources one at a time repeatedly.
Under what circumstances could these processes deadlock? If          7.24 Could the Banker's Algorithm still function properly if
so, what could be done to prevent deadlock?                          resources could be requested in groups? Explain your answer
                                                                     carefully.



 Process        max(          Pi       )       loan(          Pi         )         claim(          Pi         )
 P1                         4                                 1                                   3
 P2                         6                                 4                                   2
 P3                         8                                 5                                   3
 P4                         2                                 0                                   2
                                                              a =1

Figure 7.17 | Resource description for State A.

<!-- pág. 384 -->

                                                                                                                              Exercises    327

 Process            max(           Pi        )           loan(            Pi        )        claim(          Pi           )
  P1
                                 8                                        4                                 4
 p2                              8                                        3                                 5
  P3                             8                                        5                                 3
                                                                          a=2

Figure 7.18 | Resource description for State B.

7.25 A system that uses Banker's-Algorithm deadlock avoid-                      7.28 In a system in which it is possible for a deadlock to
ance has five processes (1, 2, 3, 4, and 5) and uses resources of               occur, under what circumstances would you use a deadlock
four different types (A, B, C, and D). There are multiple                       detection algorithm?
resources of each type. Is the state of the system depicted by                  7.29 In the deadlock detection algorithm employing the tech-
Fig. 7.19 and Fig. 7.20 safe? Explain your answer. If the system                nique of graph reductions, show that the order of the graph
 is safe, show how all the processes could complete their execu-                reductions does not matter, the same final state will result.
tion successfully. If the system is unsafe, show how deadlock                   [Hint: No matter what the order, after each reduction, the
might occur.                                                                    available resource pool increases.]
7.26 Suppose a system with n processes and m identical                          7.30 Why is deadlock recovery such a difficult problem?
resources uses Banker's Algorithm deadlock avoidance. Write
a function boolean i s S a f e S t a t e l ( i n t [ ] [ ] maximumNeed,         7.31 Why is it difficult to choose which processes to "flush" in
i n t [ ] [ ] loans. int[]        a v a i l a b l e ) that determines           deadlock recovery?
whether the system is in a safe state.                                          7.32 One method of recovering from deadlock is to kill the
7.27 Suppose a system uses the Banker's Algorithm with n                        lowest-priority process (or processes) involved in the dead-
processes, m resource types, and multiple resources of each                     lock. This (these) process(es) could then be restarted and once
type. Write a function boolean i s S a f e S t a t e 2 ( i nt [] [] max-        again allowed to compete for resources. What potential prob-
imumNeed, i n t [ ] [] l o a n s , i n t [ ] a v a i l a b l e ) that deter-    lem might develop in a system using such an algorithm? How
mines whether the system is in a safe state.                                    would you solve this problem?



 Process                  Current                    loan              Maximum                Need                Current Claim
                                         A       B   C      D                  A    B    C     D                  A   B       C   C
 1                                       1       0   2      0                  3    2    4    2                   2   2       2   2
 2                                       0       3   1      2                  3    5    1     2                  3   2       0   0
 3                                       2       4   5      1                  2    7    7    5                   0   3       2   4
 4                                       3       0   0      6                   5   5    0    8                   2   5       0   2
 5                                      4     2      1      3                  6    2    1    4                   2   0       0   1

Figure 7.19 | System state describing current loan, maximum need and current claim.


 Total Resources                                                               Resources Available
  A     B     C      D                                                         A    B    C     D
 13    13     9     13                                                         3    4    0    1

Figure 7.20 | System state describing total number of resources and available resources.

<!-- pág. 385 -->

328 Deadlock and Indefinite Postponement

7.33 Why will deadlock probably be a more critical problem            7.36 The table in Fig. 7.21 shows a system in an unsafe state.
in future operating systems than it is today?                         Explain how all of the processes may manage to finish execu-
                                                                      tion without the system becoming deadlocked.
7.34 Do resource malfunctions that render a resource unus-
able generally increase or decrease the likelihood of deadlocks       7.37 A system has three processes and four identical
and indefinite postponement? Explain your answer.                     resources. Each process requires at most two of the resources
                                                                      at any given time.
7.35 The vast majority of computer systems in use today do
allow at least some kinds of deadlock and indefinite postpone-              a. Can deadlock occur in this system? Explain.
ment situations to develop, and many of these systems provide               b. If there are m processes, and each could request up to
no automatic means of detecting and recovering from these                      n resources, how many resources must be available in
problems. In fact, many designers believe that it is virtually                  the system to ensure that deadlock will never occur?
impossible to certify a system as absolutely free of the possibil-          c. If there are m processes and r resources in the sys-
ities of deadlock and indefinite postponement. Indicate how                    tem, what maximum number of resources, n, could
these observations should affect the design of "mission-criti-                 each process request, if all processes must have the
cal" systems.                                                                  same maximum?

Suggested Projects
7.38 Prepare a research paper on how current operating sys-           7.40 Determine how Web servers and other business-critical
tems deal with deadlock.                                              systems address the problem of deadlock.
7.39 Research how real-time systems ensure that deadlock
never occurs. How do they manage to eliminate deadlock yet
maintain performance?

Suggested Simulations
7.41 (Deadlock Detection and Recovery Project) Write a simu-          discussed in Section 7.7, Deadlock Prevention. In particular,
lation program to determine whether a deadlock has occurred           compare deadlock prevention by denying the "wait-for" condi-
in a system of n identical resources and m processes. Have each       tion (Section 7.7.1, Denying the "Wait-For" Condition) with
process generate a set of resources that it wants (e.g., 3 of         deadlock prevention by denying the "no-preemption" condition
resource A, 1 of resource B and 5 of resource C). Then, from          (Section 7.7.2, Denying the "No-Preemption" Condition). Your
each set, request the resources one type at a time in a random        program should generate a sample user population, user arrival
order and with random pauses between types. Have each pro-            times, user resource needs (assume the system has n identical
cess hold onto all the resources that it has acquired until it can    resources) in terms both of maximum needs and of when the
get all of them. Deadlocks should start developing. Now have          resources are actually required, and so on. Each simulation
another thread check for deadlocks every few seconds. It should       should accumulate statistics on job turnaround times, resource
report when a deadlock has occurred and start killing threads         utilization, number of jobs progressing at once (assume that jobs
involved in the deadlock. Try different heuristics for choosing       may progress when they have the portion of the n resources
processes to kill and see which type of heuristic results in the      they currently need), and the like. Observe the results of your
best average time between deadlocks.                                  simulations and draw conclusions about the relative effective-
                                                                      ness of these deadlock prevention schemes.
7.42 (Deadlock Prevention Simulation Project) Write a simula-
tion program to compare various deadlock prevention schemes

 Process                    loan( Pi )                           max( Pi )                        claim( Pi )
 P1                          1                                   5                                 4
 P2                          1                                   3                                 2
 P3                          5                                   10                                5
                            a= 1

Figure 7.21 | Example of a system in an unsafe state.

<!-- pág. 386 -->

                                                                                                    Recommended Reading 329

7.43 (Deadlock Avoidance Simulation Project) Write a simu-              7.44 (Deadlock Prevention and Avoidance Comparison) Cre-
 lation program to examine the performance of a system of n             ate a program that simulates arriving jobs with various
 identical resources and m processes operating under banker's-          resource needs (listing each resource that will be needed and
algorithm resource allocation. Model your program after the             the time at which it will be needed). This can be a random-
one you developed in Exercise 7.42. Run your simulation and             number-based driver program. Use your simulation to deter-
compare the results with those observed in your deadlock pre-           mine how deadlock prevention and deadlock avoidance strate-
vention simulations. Draw conclusions about the relative effec-         gies yield higher resource utilization.
  tiveness of deadlock avoidance vs. the deadlock prevention
schemes studied.


Recommended Reading
Though many operating systems simply ignore the problem of              detection and handling of deadlocks in Digital Equipment
deadlock, there has been considerable research in the field to          Corporation's VAX/VMS operating system.64
create effective algorithms to solve the problem. Dijkstra,                    Today's systems rarely implement deadlock prevention or
Isloor and Marsland 55 and Zobel 56 characterize the problem of         avoidance mechanisms. In fact, in distributed systems, conven-
deadlock. Dijkstra was one of the first to document the prob-           tional deadlock prevention and avoidance mechanisms are not
lem of deadlock in multiprogrammed systems, presenting both             feasible, because each computer in a distributed system may be
the Dining Philosophers problem and the banker's algorithm              managed by a different operating system. Researchers have
for deadlock avoidance.57, 58 Coffman, Elphick and Shoshani             developed deadlock detection mechanisms65 coupled with
 later provided a framework for research in this area by classi-        checkpoint/rollback capabilities66 to reduce loss of work.
fying the four necessary conditions for deadlock.59 Holt 60, 61         Research into deadlock is currently focused on developing effi-
developed resource-allocation graphs to aid in deadlock pre-            cient deadlock detection algorithms and applying them to dis-
-ention, while Habermann 62 presented a family of deadlock              tributed systems, networks and other deadlock-prone
avoidance techniques. In discussing the UNIX System V oper-             environments.67 The bibliography for this chapter is located on
ating system, Bach indicates how deadlocks may develop in               our Web        site   at www.deitel.com/books/os3e/Bibliogra-
areas such as interrupt handling.63 Kenah et al. discuss the            phy.pdf.




Works Cited
 1. Isloor, S. S., and T. A. Marsland, "The Deadlock Problem: An         8. Habermann, A. N., "Prevention of System Deadlocks," Commu-
    Overview," Computer, Vol. 13, No. 9, September 1980, pp. 58-78.         nications of the ACM,Vol. 12, No. 7, July 1969, pp. 373-377,385.
 2. Zobel, D., "The Deadlock Problem: A Classifying Bibliography,"       9. Holt, R. C, "Comments on the Prevention of System Dead-
    Operating Systems Review, Vol. 17, No. 4, October 1983, pp. 6-16.       locks," Communications of the ACM, Vol. 14, No. 1, January 1971,
 3. Holt, R. G, "Some Deadlock Properties of Computer Systems,"             pp. 36-38.
    ACM Computing Surveys,Vol. 4, No. 3, September 1972, pp. 179-       10. Holt, R. C, "On Deadlock Prevention in Computer Systems,"
    196.                                                                    Ph.D. Thesis, Ithaca, NY.: Cornell University, 1971.
 4. Coffman, E. G., Jr.; Elphick, M. J.; and A. Shoshani, "System       11. Parnas, D. L., and A. N. Haberman, "Comment on Deadlock Pre-
    Deadlocks," Computing Surveys,Vol. 3,No. 2, June 1971,p. 69.            vention Method," Communications of the ACM, Vol. 15, No. 9,
 5. Dijkstra, E. W., "Cooperating Sequential Processes," Technologi-        September 1972, pp. 840-841.
    cal University, Eindhoven, Netherlands, 1965, reprinted in F.       12. Newton, G., "Deadlock Prevention, Detection, and Resolution:
    Genuys, ed., Programming Languages, New York: Academic                  An Annotated Bibliography," ACM Operating Systems Review,
    Press, 1968.                                                            Vol. 13, No. 2, April 1979, pp. 33-44.
 6. Dijkstra, E. W., "Hierarchical Ordering of Sequential Processes,"   13. Gelernter, D., "A DAG Based Algorithm for Prevention of Store-
    Acta Informatica,Vol. 1,1971, pp. 115-138.                              and-Forward Deadlock in Packet Networks," IEEE Transactions
 7. Coffman, E. G, Jr.; Elphick, M. J.; and A. Shoshani, "System            on Computers,Vol C-30,No. 10, October 1981, pp. 709-715.
    Deadlocks," Computing Surveys, Vol. 3, No. 2, June 1971, pp. 67-    14. Havender, J. W., "Avoiding Deadlock in Multitasking Systems,"
    78.                                                                     IBM Systems Journal, Vol. 7, No. 2,1968, pp. 74-84.

<!-- pág. 387 -->

330    Deadlock      and Indefinite Postponement

15. Brinch Hansen, P., Operating System Principles, Englewood           33. Newton, G„ "Deadlock Prevention, Detection, and Resolution:
    Cliffs, NJ: Prentice Hall, 1973.                                        An Annotated Bibliography," ACM Operating Systems Review,
16. Scherr, A. L., "Functional Structure of IBM Virtual Storage             Vol. 13, No. 2, April 1979, pp. 33-44.
    Operating Systems, Part II: OS/VS2-2 Concepts and Philoso-          34. Gligor, V., and S. Shattuch, "On Deadlock Detection in Distrib-
    phies," IBM Systems Journal, Vol. 12, No. 4,1973, pp. 382-400.          uted Systems," IEEE Transactions on Software Engineering, Vol.
17. Auslander, M. A.; Larkin, D. C; and A. L. Scherr, "The Evolu-           SE-6, No. 5, September 1980, pp. 435-440.
    tion of the MVS Operating System," IBM Journal of Research          35. Ho, G. S., and C. V. Ramamoorthy, "Protocols for Deadlock
    and Development, Vol. 25, No. 5,1981, pp. 471-482.                      Detection in Distributed Database Systems," IEEE Transactions
18. Kenah, L. J.; Goldenberg, R. E.; and S. F. Bate, VAX/VMS Inter-         on Software Engineering, Vol. SE-8, No. 6, November 1982, pp.
    nals and Data Structures, Version 4.4, Bedford, MA: Digital             554-557.
    Press, 1988.                                                        36. Obermarck, R., "Distributed Deadlock Detection Algorithm."
19. Brinch Hansen, P., Operating System Principles, Englewood               ACM Transactions on Database Systems,Vol. 1, No. 2, June 1982.
    Cliffs, NJ: Prentice Hall, 1973.                                        pp. 187-208.
20. Dijkstra, E. W., Cooperating Sequential Processes, Technological    37. Chandy, K. M., and J. Misra, "Distributed Deadlock Detection."
    University, Eindhoven, The Netherlands, 1965.                           ACM Transactions on Computer Systems,Vol. 1, No. 2, May 1983.
                                                                            pp. 144-156.
21. Dijkstra, E. W., Cooperating Sequential Processes, Technological
                                                                        38. Jagannathan, J. R., and R. Vasudevan, "Comments on 'Protocols
    University, Eindhover, Netherlands, 1965, Reprinted in F.
                                                                            for Deadlock Detection in Distributed Database Systems'."
    Genuys, ed., Programming Languages, New York: Academic
                                                                            IEEE Transactions on Software Engineering, Vol. SE-9, No. 3.
    Press, 1968.
                                                                            May 1983, p. 371.
22. Habermann, A. N, "Prevention of System Deadlocks," Commu-
                                                                        39. Kenah, L. I; Goldenberg, R. E.; and S. F. Bate, VAX/VMS Inter-
    nications of the ACM, Vol. 12, No. 7, July 1969, pp. 373-377,385.
                                                                            nals and Data Structures, version 4.4, Bedford, MA: Digital Press,
23. Madduri, H, and R. Finkel, "Extension of the Banker's Algo-             1988.
    rithm for Resource Allocation in a Distributed Operating Sys-
                                                                        40. Pun H. Shiu, YuDong Tan, Vincent J. Mooney, "A Novel Parallel
    tem," Information Processing Letters, Vol. 19, No. 1, July 1984,
                                                                            Deadlock Detection Algorithm and Architecture" Proceedings
    pp. 1-8.
                                                                            of the Ninth International Symposium on Hardware/Software
24. Havender, J. W., "Avoiding Deadlock in Multitasking Systems,"           Codesign, April 2001.
    IBM Systems Journal.Vol. 1, No. 2,1968, pp. 74-84.
                                                                        41. Holt, R. C, "Some Deadlock Properties of Computer Systems."
25. Fontao, R. O., "A Concurrent Algorithm for Avoiding Dead-               ACM Computing Surveys, Vol. 4, No. 3, September 1972, pp. 179-
    locks," Proc. Third ACM Symposium on Operating Systems Prin-            196.
    ciples, October 1971, pp. 72-79.
                                                                        42. Holt, R. C, "Some Deadlock Properties of Computer Systems."
26. Frailey, D. J., "A Practical Approach to Managing Resources and         ACM Computing Surveys, Vol. 4, No. 3, September 1972, pp. 179-
    Avoiding Deadlock," Communications of the ACM, Vol. 16, No.             196.
    5, May 1973, pp. 323-329.
                                                                        43. Kenah, L. J.; R. E. Goldenberg; and S. F. Bate, VAX/VMS Inter-
27. Devillers, R., "Game Interpretation of the Deadlock Avoidance           nals and Data Structures, version 4.4, Bedford, MA: Digital Press,
    Problem," Communications of the ACM, Vol. 20, No. 10, October           1988.
    1977, pp. 741-745.
                                                                        44. Thomas, K., Programming Locking Applications, IBM Corpora-
28. Lomet, D. B., "Subsystems of Processes with Deadlock Avoid-             tion, 2001, <www-124.ibm.com/developerworks/oss/dlm/cur-
    ance," IEEE Transactions on Software Engineering, Vol. SE-6,            rentbook/dlmbook_index.html>.
    No. 3, May 1980, pp. 297-304.
                                                                        45. Compaq Computer Corporation, Intel Corporation, Microsoft
29. Merlin, P. M., and P. J. Schweitzer, "Deadlock Avoidance in             Corporation, Phoenix Technologies Ltd., Toshiba Corporation.
    Store-and-Forward Networks—I: Store and Forward Deadlock,"              "Advanced Configuration and Power Management," rev. 2.0b,
    IEEE Transactions on Communications, Vol. COM-28, No. 3,                October 11,2002, p. 238
    March 1980, pp. 345-354.
                                                                        46. "Driver Development Tools: Windows DDK, Deadlock Detec-
30. Merlin, P. M., and P. J. Schweitzer, "Deadlock Avoidance in             tion,"    Microsoft MSDN     Library, June    6,  2003.
    Store-and-Forward Networks—II: Other Deadlock Types,"                   <msdn.microsoft.com/library/en-us/ddtools/hh/ddtools/
    IEEE Transactions on Communications, Vol. COM-28, No. 3,                dv_8pkj.asp>.
    March 1980, pp. 355-360.                                            47. "Kernel-Mode Driver Architecture: Windows DDK, Preventing
31. Minoura, T, "Deadlock Avoidance Revisited," Journal of the              Errors and Deadlocks While Using Spin Locks," Microsoft
    ACM, Vol. 29, No. 4, October 1982, pp. 1023-1048.                       MSDN Library, June 6, 2003, <msdn.microsoft.com/library
32. Murphy, J. E., "Resource Allocation with Interlock Detection in         en-us/kmarch/hh/kmarch/synchro_5ktj.asp>.
    a Multitask System," AFIPS FJCC Proc., Vol. 33, No. 2,1968, pp.     48. Krivokapic, N; Kemper, A.; and E. Gudes, "Deadlock Detection
    1169-1176.                                                              in Distributed Database Systems: A New Algorithm and Com-

<!-- pág. 388 -->

                                                                                                                      Works Cited         331
    parative Performance Analysis," The VLDB Journal— The Inter-             Genuys, ed., Programming Languages, New York: Academic
    national Journal on Very Large Data Bases, Vol. 8, No. 2,1999, pp.       Press, 1968.
    79-100.                                                              58. Dijkstra, E. W., "Hierarchical Ordering of Sequential Processes,"
49. Krivokapic, N.; Kemper, A.; and E. Gudes, "Deadlock Detection            Acta Informatica, Vol. 1,1971, pp. 115-138.
    in Distributed Database Systems: A New Algorithm and Com-            59. Coffman, E. G., Jr.; Elphick, M. J.; and A. Shoshani, "System
    parative Performance Analysis," The VLDB Journal— The Inter-             Deadlocks," Computing Surveys, Vol. 3, No. 2, June 1971, pp. 67-
    national Journal on Very Large Data Bases, Vol. 8, No. 2,1999, pp.       78.
    79-100.
                                                                         60. Holt, R. C, "Comments on the Prevention of System Dead-
50. Krivokapic, N.; Kemper, A.; and E. Gudes, "Deadlock Detection            locks," Communications of the ACM, Vol. 14, No. 1, January 1971,
    in Distributed Database Systems: A New Algorithm and Com-                pp. 36-38.
    parative Performance Analysis," The VLDB Journal— The Inter-
                                                                         61. Holt, R. G, "On Deadlock Prevention in Computer Systems,"
    national Journal on Very Large Data Bases, Vol. 8, No. 2,1999, pp.
                                                                             Ph.D. Thesis, Ithaca, NY.: Cornell University, 1971.
    79-100.
                                                                         62. Habermann, A. N., "Prevention of System Deadlocks," Commu-
51. Magarshack, P., and P. Paulin, "System-on-chip Beyond the
                                                                             nications of the ACM, Vol. 12, No. 7, July 1969, pp. 373-377,385.
    Nanometer Wall," Proceedings of the 40th Conference on Design
    Automation, Anaheim, CA: ACM Press, 2003, pp. 419-424.               63. Bach, M. J., The Design of the UNIX Operating System, Engle-
                                                                             wood Cliffs, NJ: Prentice Hall, 1986.
52. Benini, L.; Macci, A.; and M. Poncino, "Energy-Aware Design of
    Embedded Memories: A Survey of Technologies, Architectures,          64. Kenah, L. J.; Goldenberg, R. E.; and S. F. Bate, VAX/VMS Inter-
    and Techniques," ACM Transactions on Embedded Computer                   nals and Data Structures, version 4.4, Bedford, MA: Digital Press,
    Systems (TECS), Vol. 2, No. 1,2003, pp. 5-32.                            1988.
53. Dijkstra, E. W., "Solution of a Problem in Concurrent Program-       65. Obermarck, R., "Distributed Deadlock Detection Algorithm,"
    ming Control," Communications of the ACM, Vol. 8, No. 5, Sep-            ACM Transactions on Database Systems, Vol. 7, No. 2, June 1982,
    tember 1965, p. 569.                                                     pp. 187-208.
54. Dijkstra, E. W., "Hierarchical Ordering of Sequential Processes,"    66. Krivokapic, N.; Kemper, A.; and E. Gudes, "Deadlock Detection
    Acta Informatica,Vol. 1,1971, pp. 115-138.                               in Distributed Database Systems: A New Algorithm and Com-
                                                                             parative Performance Analysis," The VLDB lournal— The Inter-
55. Isloor, S. S., and T. A. Marsland, "The Deadlock Problem: An
                                                                             national lournal on Very Large Data Bases, Vol. 8, No. 2,1999, pp.
    Overview," Computer, Vol. 13, No. 9, September 1980, pp. 58-78.
                                                                             79-100.
56. Zobel, D, "The Deadlock Problem: A Classifying Bibliography,"
                                                                         67. Shiu, P. H.; Tan, Y; and V J. Mooney, "A Novel Parallel Deadlock
    Operating Systems Review, Vol. 17, No. 4, October 1983, pp. 6-16.
                                                                             Detection Algorithm and Architecture," Proceedings of the Ninth
57. Dijkstra, E. W., "Cooperating Sequential Processes," Technologi-         International Symposium on Hardware/Software Codesign, April
    cal University, Eindhoven, Netherlands, 1965, reprinted in E             2001.

<!-- pág. 389 -->

The heavens themselves, the planets and this center observe degree, priority, and place, ...
      —William Shakespeare —


Nothing in progression can, rest on its original plan. We may as well think of rocking a
grows man in the cradle of an infant.
      —Edmund Burke —


For every problen there is one solution which is simple, neat, and wrong.
      —H. L. Mencken—


There is nothing more requisite in business than dispatch.
      —Joseph Addison—

