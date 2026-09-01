# Part 4 - Secondary Storage, Files and Databases / Chapter 12 - Disk Performance Optimization

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 577–636 (numeración del PDF)

<!-- pág. 577 -->

Secondary Storage, Files
    and Databases
     A fair request should be followed by the deed in silence.
                          —Dante —




     Part 4

<!-- pág. 578 -->

Computers store programs and vast amounts of
data as files and databases on secondary storage
devices. The following two chapters explain how
operating systems organize and manage data on
these devices. We explain the operation of the enor-
mously popular moving-head disk storage device
and show how to achieve maximum performance
with seek and rotational optimization strategies.
RAID     (Redundant Arrays of Independent Disks)
systems, which achieve high levels of performance
and fault tolerance, are presented. We discuss file
systems and examine how files are allocated on
disk, how free space is managed and how file data
is accessed and protected. File servers, and how
they are used in distributed systems, are explained.
We introduce database systems, and discuss rela-
tional databases and the kinds of operating sys-
tems services that support database systems.




     'Tis in my memory lock'd, And you yourself shall keep the key of it.
                       —William Shakespeare —

<!-- pág. 579 -->

The path of duty lies in what is near, and man seeks for it in what is remote.
       —Mencius—

A fair request should be followed by the deed in silence.
       —Dante—

... the latter, in search of the hard latent value with which it alone is concerned, snifs
round the mass as instinctively and unerringly as a dog suspicious of some buried bone.
       —William James—

Go where we will on the surface of things, men have been there before us.
      —Henry David Thoreau—

The wheel that squeaks the loudest is the one that gets the grease.
      —Josh Billings (Henry Wheeler Shaw) —

<!-- pág. 580 -->

Chapter 12

Disk Performance
           Optimization
 Objectives
 After reading this chapter, you should understand:
 • how disk input/output is accomplished.
 • the importance of optimizing disk performance.
 • seek optimization and rotational optimization.
 • various disk scheduling strategies.
 • caching and buffering.
 • other disk performance improvement techniques.
 • key schemes for implementing redundant arrays of independent disks
   (RAID).

<!-- pág. 581 -->

                                    Chapter Outline
                        12.1                                  12.6
                 Introduction                      Rotational Optimization
                                                     12.6.1 SLTF Scheduling
                       12.2                       12.6.2 SPTF and SATF Scheduling
      Evolution of Secondary Storage
                                                              12.7
                    12.3                            System Considerations
      Characteristics of Moving-Head               Operating Systems Thinking:
              Disk Storage                            Saturation and Bottlenecks


                       12.4                                     12.8
                                                    Caching and Buffering
           Why Disk Scheduling Is
                 Necessary
                                                                12.9
                                                   Other    Disk Performance
                       12.5                                 Techniques
         Disk Scheduling Strategies                Operating Systems Thinking:
      12.5.1 First-Come-First-Served (FCFS)         Compression and Decompression
                  Disk Scheduling
                                                  Operating Systems Thinking:
      12.5.2 Shortest-Seek-Time-First (SSTF)                 Redundancy
                  Disk Scheduling
      Anecdote: Every Problem Has a Solution               12.10
         and Everu Solution Has a Problem            Redundant Arrays of
          12.5.3 SCAN Disk Scheduling            Independent Disk (RAID)
         12.5.4 C-SCAN Disk Scheduling                12.10.1 RAID Overview
       12.5.5 FSCAN and N-Step SCAN Disk       Operating Systems Thinking: Mission-
                    Scheduling                             Critical Systems
          12.5.6 LOCK and C-LOCK Disk           Operating Systems Thinking: Fault
                    Scheduling                                Tolerance




526

<!-- pág. 582 -->

       12.10.2 Level 0 (Striping)
      12.10.3 Level 1 (Mirroring)
12.10.4 Level 2 (Bit-Level Hamming ECC
                Parity)
 12.10.5 Level 3 (Bit-level XOR ECC
                Parity)
12.10.6 Level 4 (Block-level XOR ECC
                Parity)
12.10.7 Level 5 (Block-Level Distributed
           XOR ECC Parity)




  Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited




                                                                                        527

<!-- pág. 583 -->

528 Disk Performance Optimization

                           12.1     Introduction
                           In recent years, processor and main memory speeds have increased more rapidly
                           than those of secondary storage devices, such as hard disks. As a result, processes
                           requesting data on secondary storage tend to experience relatively long service
                           delays. In this chapter, we discuss the characteristics of moving-head disk storage
                           and consider how operating system designers can manage such devices to provide
                           better service to processes. We explain how to optimize disk performance by reor-
                           dering disk requests to increase throughput, decrease response times and reduce
                           the Variance of response times. We also discuss how operating systems reorganize
                           data on disk and exploit buffers and caches to boost performance/Finally, we dis-
                           cuss Redundant Arrays of Independent Disks (RAIDs), which improve disk access
                           times and fault tolerance by servicing requests using multiple disks at once.


                           12.2 Evolution of Secondary Storage
                           In early computers, persistent data was stored on punched cards and punched paper
                           tape, which used the absence or presence of holes to represent bits of data. 1 Writing
                           software and loading it into the computer using such media was both labor inten-
                           sive and slow. The need for an inexpensive, rewritable persistent storage device led
                           researchers to develop magnetic storage, which records bits of data by changing the
                           direction of magnetization of regions on the medium's surface. To access data, a
                           current-carrying device called a read-write head hovers above the medium as it
                           moves. The head reads data by measuring how the magnetized medium changes the
                           current; it "writes" data by using the current to change the magnetization on the
                           medium. A challenge in building these devices is that the head must float extremely
                           close to the medium's surface without touching it.
                                 In 1951, the designers of UNIVAC 1 (UNIVersal Automatic Computer) intro-
                           duced magnetic tape storage, which was both persistent and rewritable. 2 Magnetic
                           tape is a form of sequential access storage, like audio or video cassettes. Such a
                           medium is inappropriate for transaction-processing applications, where, for exam-
                           ple, the system must be able to locate and update any record in a fraction of a sec-
                           ond. To address this problem, IBM introduced the first commercial hard disk drive.
                           the RAMAC (Random Access Method of Accounting and Control), in 1957. Hard
                           disk drives are random access (also called direct access) devices because they are
                           not limited to accessing data sequentially. RAMAC's capacity totalled five mega-
                           bytes, and its cost was $50,000; it was generally rented to installations for hundreds
                           of dollars per month. 3 4 Although hard disks provided better performance than
                           magnetic tape storage, their high cost limited their use to large installations.
                                 As the decades passed, hard drive capacity and performance increased, while
                           costs declined. Typical personal computer hard disk capacity increased from hun-
                           dreds of megabytes to several gigabytes during the 1990s while prices fell to a few
                           pennies per megabyte. By 2003, hard drive capacity had exceeded 200GB and cost
                           less than a dollar per gigabyte.5 Due to mechanical constraints that we discuss in the

<!-- pág. 584 -->

                                                              12.3 Characteristics of moving-Head Disk Storage 529

next section, hard disk speeds have improved more slowly than their capacity. As
processor speeds increased and applications consumed larger amounts of data, sys-
tems became increasingly I/O bound.6
      Research in persistent storage technology continues to focus on increasing
capacity and performance. Some solutions attempt to improve the performance of
existing magnetic disk devices; others employ novel techniques and media.

Self Review
1. Why have many of today's systems become I/O bound?
2. Why are disks more appropriate than tapes for secondary storage?
Ans: 1) Processor speeds have increased faster than hard disk speeds. 2) Magnetic tape per-
forms well only in an application in which data is accessed sequentially. In transaction-pro-
cessing applications and in multiprogrammed systems, requests to access secondary storage
from multiple processes can lead to essentially random access patterns. In this case, direct
access storage devices are essential.


12.3 Characteristics of Moving-Head Disk Storage
Unlike main memory, which provides (nearly) uniform access speed to all of its
contents, moving-head disk storage exhibits variable access speed that depends on
the relative positions of the read-write head and the requested data. Figure 12.1
shows a simplified view of a moving-head disk.7-8-9 Data is recorded on a series of




Figure 12.1 | Schematic side view of a moving-head disk.

<!-- pág. 585 -->

530 Disk Performance Optimization

                           magnetic disks, or platters, connected to a spindle that rotates at high speed (typi-
                           cally thousands of revolutions per minute 10 ).
                                 The data on each disk surface is accessed by a read-write head that is sepa-
                           rated by a small amount of space from the surface (much smaller than a particle of
                           smoke). For example, the disk in Fig. 12.1 contains two platters, each having two
                           surfaces (top and bottom) and four read-write heads, one for each surface. A read-
                           write head can access data immediately below (or above) it. Therefore, before data
                           can be accessed, the portion of the disk surface at which the data is to be read (or
                           written) must rotate until it is immediately below (or above) the read-write head.
                           The time it takes for data to rotate from its current position to the beginning of the
                           read-write head is called rotational latency time. A disk's average rotational latency
                           is simply half the time it takes to complete one revolution. Most hard disks exhibit
                           average rotational latency on the order of several milliseconds (Fig. 12.2).
                                 As the platters spin, each read-write head sketches out a circular track of data
                           on a disk surface. Each read-write head is positioned at the end of a disk arm, which
                           is attached to an actuator (also called a boom or moving-arm assembly). The disk
                           arm moves parallel to the surface of the disk. When the disk arm moves the read-
                           write heads to a new position, a different vertical set of circular tracks, or cylinder.
                           becomes accessible. The process of moving the disk arm to a new cylinder is called a
                           seek operation. 1112 To locate small units of data, disks divide tracks into several
                           sectors, often 512 bytes (Fig. 12.3).13 Therefore, an operating system can locate a
                           particular data item by specifying the head (which indicates which disk surface to
                           read from), the cylinder (which indicates which track to read from), and the sector
                           in which the data is located.
                                  To access a particular record of data on a moving-head disk, several opera-
                           tions are usually necessary (Fig. 12.4). First, the disk arm must move to the appro-
                           priate cylinder (i.e., perform a seek operation). The time it takes for the head to
                           move from its current cylinder to the one containing the data record is called the
                           seek time. Then the portion of the disk on which the data record is stored must
                           rotate until it is immediately under (or over) the read-write head. Then the record,
                           which is of arbitrary size, must be made to spin by the read-write head. This is called
                           transmission time. Because each of these operations involves mechanical move-
                           ment, the total time a disk access takes is often an appreciable fraction of a second

                                                                            Average Seek    Average Rotational
                            Model (Environment)                             Time (ms)       latency (ms)
                             Maxtor DiamondMax Plus 9 (High-end desktop)    9.3              4.2
                             WD Caviar (High-end desktop)                   8.9              4.2
                             Toshiba MK8025GAS (Laptop)                     12.0             7.14
                             WD Raptor (Enterprise)                         5.2              2.99
                             Cheetah 15K.3 (Enterprise)                     3.6              2.0

                           Figure 12.2 | Hard disk track-to-track seek times and latency times. 14, 15, 16, 17, 18

<!-- pág. 586 -->

                                                                              12.4 Why Disk Scheduling Is Necessary 531




Figure 12.3 | Schematic top view of a disk surface.

(several milliseconds at least). During this same period of time, a processor can exe-
cute tens or even hundreds of millions of instructions.

Self Review
1. One focus of research in the field of storage technology is on increasing a hard disk's
   areal density (i.e., amount of data per unit area). How does increasing the areal density
   alone affect disk access times?
2. (T/F) Rotational latency is identical for every disk access.
Ans: 1) As the amount of data per unit area increases, then the amount of data contained in
each track increases. If a particular data record is located on a single track, the transmission
time decreases compared to that for a lower areal density because more data can be read per
unit time. 2) False. The rotational latency depends on the location of the beginning of the
requested sector relative to the position of the arm.



12.4 Why Disk Scheduling Is Necessary
Many processes can generate requests for reading and writing data on a disk simul-
taneously. Because these processes sometimes make requests faster than they can
be serviced by the disk, waiting lines or queues build up to hold disk requests. Some
early computing systems simply serviced these requests on a first-come-first-served

<!-- pág. 587 -->

532   Disk   Performance   Optimization




                                Figure 12.4 | Components of a disk access.


                                (FCFS) basis, in which the earliest arriving request is serviced first.19 FCFS is a fair
                                method of allocating service, but when the request rate (i.e., the load) becomes
                                heavy, can be long waiting times.
                                      FCFS exhibits a random seek pattern in which successive requests can cause
                                time-consuming seeks from the innermost to the outermost cylinders. To reduce the
                                time spent seeking records, it seems reasonable to order the request queue in some
                                manner other than FCFS. 20 This process, called disk scheduling, can significantly
                                improve throughput. 21
                                      Disk scheduling involves a careful examination of pending requests to deter-
                                mine the most efficient way to service them. A disk scheduler examines the posi-
                                tional relationships among waiting requests, then reorders the queue so that the
                                requests will be serviced with minimum mechanical motion.
                                      Because FCFS does not reorder requests, it is considered by many to be the
                                simplest disk scheduling algorithm. The two most common types of scheduling are
                                seek optimization and rotational optimization. Because seek times tend to be
                                greater than latency times, most scheduling algorithms concentrate on minimizing
                                total seek time for a set of requests. As the gap between rotational latency and seek
                                times narrows, minimizing the rotational latency of a set of requests can also
                                improve overall system performance, especially under heavy loads.

<!-- pág. 588 -->

                                                                                     12.5 Disk Scheduling Strategies 533

Self Review
1. Indicate which type of disk scheduling algorithm is most appropriate in the following sce-
   narios: seek time is significantly greater than latency time, seek time and latency time are
   nearly equal, seek time is significantly shorter than latency time.
2. Which characteristics of disk geometry are most important to seek optimization and rota-
   tional optimization?
Ans: 1) When seek time is significantly greater than latency time, access times are most
affected by seek operations, so the system should implement seek optimization. When seek
times and latency times are nearly equal, the system can benefit from combining both seek and
rotational optimization techniques. If seek time is much shorter than latency time, then access
times are most affected by latency time, so the system should concentrate on rotational optimi-
zation. Because today's processors are so fast, both forms of optimization should be employed
to improve overall performance. 2) Cylinder locations are most important when optimizing
seek times, and sector locations are most important when optimizing latency times.


12.5 Disk Scheduling Strategies
A system's disk scheduling strategy depends on the system objectives, but most
strategies are evaluated by the following criteria
      • throughput—the number of requests serviced per unit time
      • mean response time—the average time spent waiting for a request to be
        serviced
      • variance of response times—& measure of the predictability of response
        times. Each disk request should be serviced within an acceptable time
        period (i.e., the strategy should prevent indefinite postponement).
       Clearly, a scheduling policy should attempt to maximize throughput and mini-
mize the mean response time. Many scheduling policies attempt to accomplish
these goals by minimizing the time spent performing lengthy seeks. When through-
put and mean response time are optimized, average system performance improves,
nut individual requests may be delayed.
       Variance measures how individual requests are serviced relative to average
system performance. The smaller the variance, the more likely it is that most disk
requests are serviced after waiting for a similar amount of time. Therefore, variance
can be seen as a measure of fairness and of predictability. We desire a scheduling
policy that minimizes variance (or at least keeps it at reasonable levels) to avoid
erratic service times. In a business-critical system, such as a Web server, a high vari-
ance of response times could result in loss of sales if, for example, users' requests to
purchase products were indefinitely postponed or suffer lengthy waits. In mission-
critical systems, the result of such a delay could be catastrophic.
       The following sections describe several common scheduling policies. We use
the set of disk requests in Fig. 12.5 to demonstrate the result of each policy on an
arbitrary series of requests. The arbitrary series of requests is intended to demon-
strate how each policy orders disk requests, it does not necessarily indicate the rela-
tive performance of each policy in a real system. In the examples that follow, we

<!-- pág. 589 -->

534 Disk Performance Optimization




                              Figure 12.5 | Disk request pattern.
                              assume that the disk contains 100 cylinders, numbered 0-99, and that the read/write
                              head is initially located at cylinder 63, unless stated otherwise. For simplicity, we
                              also assume that the disk scheduler has already determined the cylinder number
                              corresponding to each request.


                              Self Review
                              1. Why is minimizing the variance of response times an important goal in disk scheduling?
                              2. We mentioned that FCFS is a fair scheduling algorithm. Which of the criteria mentioned
                                 in this section most directly relates to fairness?
                             Ans: 1) Otherwise the system could experience erratic response times. In a business-critical
                             system, this could cause a company to lose customers; in a mission-critical system, it could
                             put people's lives at risk. 2) FCFS is fair in the sense that arriving requests cannot get in line
                             ahead of waiting requests. This helps reduce the variance of response times.

<!-- pág. 590 -->

                                                                                       12.5 Disk Scheduling Strategies 535

12.5.1 First-Come-First-Served (FCFS) Disk Scheduling
FCFS scheduling uses a FIFO queue so that requests are serviced in the order in
which they arrive.22'23-24 FCFS is fair in the sense that a request's position in the
queue is unaffected by arriving requests. This ensures that no request can be indefi-
nitely postponed, but it also means that FCFS might perform a lengthy seek opera-
tion to service the next waiting request, even if another request in the queue is
closer and can be serviced faster. Although this technique incurs low execution-
time overhead, it can result in low throughput due to lengthy seeks.
      When requests are uniformly distributed over the disk surfaces, FCFS sched-
uling leads to a random seek pattern because it ignores positional relationships
among the pending requests (Fig. 12.6).This is acceptable when the load on a disk is
light. However, as the load grows, FCFS tends to saturate (i.e., overwhelm) the
device, and response times become large. The random seek pattern of FCFS results
in low variance (because arriving requests cannot get ahead of waiting requests),
but this is of little solace to the request sitting at the back of the disk queue while
the disk arm rambles around in a torrid "disk dance."



Self Review
1. One measure of fairness is a low variance in response times. In this sense, is FCFS disk
   scheduling fair?
2. Can indefinite postponement occur with FCFS disk scheduling? Explain.
Ans: 1) Yes, in this sense it is fair, but because no attempt is made to minimize response times,
average response times tend to be longer than necessary. 2) No. Indefinite postponement can-
not occur because arriving requests can never be placed ahead of requests in the queue.




Figure 12.6 | Seek pattern under the FCFS strategy.

<!-- pág. 591 -->

536     Disk Performance Optimization

                                  12.5.2 Shortest-Seek-Time-First (SSTF) Disk Scheduling
                                  Shortest-seek-time-first (SSTF) scheduling next services the request that is closest
                                  to the read-write head's current cylinder (and thus incurs the shortest seek time).
                                  even if that is not the first one in the queue.25, 26, 27, 28 SSTF does not ensure fairness
                                  and can lead to indefinite postponement because its seek pattern tends to be highly
                                  localized, which can lead to poor response times for requests to the innermost and
                                  outermost tracks (Fig. 12.7).
                                        By reducing average seek times, SSTF achieves higher throughput rates than
                                  FCFS, and mean response times tend to be lower for moderate loads. One significant
                                  drawback is that it leads to higher variances of response times because of the discrim-
                                  ination against the outermost and innermost tracks; in the extreme, starvation (see
                                  Chapter 7) of requests far from the read/write heads could occur if new arrivals tend
                                  to be clustered near the middle cylinders. The high variance is acceptable in batch-
                                  processing systems, where throughput and mean response times are more important
                                  goals. However, SSTF is inappropriate for interactive systems, where the system must
                                  ensure that each user experiences prompt, predictable response times (see the Anec-
                                  dote, Every Problem Has a Solution and Every Solution Has a Problem).




                  Anecdote
      Every Problem Has a Solution and Every Solution Has a
      Problem
      This true story happened to a        chomping on the garbage. She              of the garage, close the garage
      neighbor w h o is in no way          called the town's animal control          door with her remote control and
      involved w i t h the computer        department, but they had a back-          head off to work. She followed
      industry. Her husband left for       log and said they would not be            that advice. But much to her cha-
      work shortly before she did and      able to come out for a few hours.         grin, when she threw the bacon
      he forgot to close the garage        They told her, though, that skunks        onto the front lawn, another
      door that day. When she was leav-    love bacon, so she should fry up a        skunk came out of the woods to
      ing her home to go to work, she      batch of bacon and t h r o w it out       eat the bacon, while the first
      walked into her garage and           on her front lawn. The skunk              skunk continued eating the gar-
      found a skunk had pushed over a      would smell the bacon and go out          bage in her garage. She got to
      garbage pail and was sitting next    on the front lawn to eat it. She          work a few hours late that day.
      to the door to her car merrily       could then hop in her car, pull out


      Lesson to operating systems designers: Always try to anticipate the consequences of your design choices.

<!-- pág. 592 -->

                                                                                       12.5 Disk Scheduling Strategies   537




Figure 1 2 . 7 | Seek pattern under the SSTF strategy.

Self Review
1. To which scheduling algorithm from Chapter 8 is SSTF most similar? How do they differ?
2. Compare the overhead incurred by SSTF and FCFS.
Ans: 1) SSTF is most similar to the shortest-process-first (SPF) strategy. Unlike SPF, SSTF
does not require future knowledge (such as runtime-to-completion)—the request's location
is sufficient information to determine which request to service next. 2) Both FCFS and SSTF
must maintain a queue of waiting requests in memory. Because FCFS maintains a simple
FIFO queue, the execution time required to determine which request to service next is small
and is unaffected by the number of requests in the queue. SSTF incurs overhead by either
maintaining a sorted list (or lists) of requests or by searching the entire request queue for the
appropriate request to service. In this case, the overhead incurred by SSTF is proportional to
the number of requests in the queue (whereas the overhead of FCFS is constant—simply the
amount of time it takes to insert entries at the back of the queue and remove them from the
front).


12.5.3 SCAN Disk Scheduling
Denning developed the SCAN disk scheduling strategy to reduce the unfairness
and variance of response times exhibited by SSTF.29 SCAN chooses the request that
requires the shortest seek distance in a preferred direction (Fig. 12.8). Thus, if the
preferred direction is currently outward, the SCAN strategy chooses the shortest
seek distance in the outward direction. SCAN does not change its preferred direc-
tion until it reaches the outermost cylinder or the innermost cylinder. In this sense,
it is called the elevator algorithm, because an elevator continues in one direction
servicing requests before reversing direction.
      SCAN behaves much like SSTF in terms of high throughput and good mean
response times. However, because SCAN ensures that all requests in a given direction
will be serviced before the requests in the opposite direction, it offers a lower variance
of response times than SSTF. SCAN, like SSTF, is a cylinder-oriented strategy.

<!-- pág. 593 -->

538 Disk Performance Optimization




                           Figure 12.8 | Seek pattern under the           SCAN strategy.

                           Because the read-write heads oscillate between opposite ends of each platter in
                           SCAN, the outer tracks are visited less often than the midrange tracks, but generally
                           more often than they would be using SSTF. Because arriving requests can be serviced
                           before waiting requests, both SSTF and SCAN can suffer indefinite postponement.


                           Self Review
                           1. One limitation of the SCAN algorithm is that it might perform unnecessary seek opera-
                              tions. Indicate where this occurs in Fig. 12.8.
                           2. Can requests be indefinitely postponed under SCAN?
                           Ans: 1) The unnecessary seek operation occurs after servicing the request to cylinder 8.
                           Because there are no further requests in the preferred direction, it would be more efficient to
                           change direction after servicing that request. We examine a modification to the SCAN strat-
                           egy that addresses this limitation in Section 12.5.6, LOOK and C-LOOK Disk Scheduling. 2)
                           One could imagine a scenario in which processes issue continuous requests to the same cylin-
                           der, so that the read/write head becomes "stuck" on that cylinder.


                           12.5.4 C-SCAN Disk Scheduling
                           In the Circular SCAN (C-SCAN) modification to the SCAN disk scheduling strat-
                           egy, the arm moves from the outer cylinder to the inner cylinder, servicing requests
                           on a shortest-seek basis (Fig. 12.9). When the arm has completed its inward sweep,
                           it jumps (without servicing requests) to the outermost cylinder, then resumes its
                           inward sweep, processing requests. C-SCAN maintains high levels of throughput
                           while further limiting variance of response times by avoiding discrimination against
                           the innermost and outermost cylinders.30-31 As in SCAN, requests in C-SCAN can
                           be indefinitely postponed if requests to the same cylinder continuously arrive
                           (although this is less likely than with SCAN or SSTF). In the sections that follow,
                           we discuss modifications to SCAN that address this problem.

<!-- pág. 594 -->

                                                                                 12.5 Disk Scheduling Strategies 539




Figure 12.9 | Seek pattern under the C-SCAN strategy.

      Simulation results in the literature indicate that the best disk scheduling pol-
icy might operate in two stages.32 Under a light load, the SCAN policy is best.
Under medium to heavy loads, C-SCAN and other adaptations to the SCAN policy
vield better results. C-SCAN with rotational optimization handles heavy loading
conditions effectively.33


Sel Review
1. Which criteria of disk scheduling strategies does C-SCAN improve upon?
2. (T/F) C-SCAN incurs essentially the same execution-time overhead as SCAN.
Ans: 1) C-SCAN reduces variance of response times compared to SCAN because it is less
biased against the outermost and innermost cylinders. 2) False. C-SCAN incurs overhead
over SCAN when it finishes its inward sweep and skips requests while moving the head to the
 outermost cylinder.


 12.5.5 FSCAN and N-Step SCAN Disk Scheduling
The FSCAN and TV-Step SCAN modifications to the SCAN strategy eliminate the
possibility of indefinitely postponing requests. 34, 35 FSCAN uses the SCAN strategy
to service only those requests waiting when a particular sweep begins (the "F"
stands for "freezing" the request queue at a certain time). Requests arriving during
a sweep are grouped together and ordered for optimum service during the return
sweep (Fig. 12.10).
      TV-Step SCAN services the first n requests in the queue using the SCAN strat-
egy. When the sweep is complete, the next n requests are serviced. Arriving requests
are placed at the end of the request queue (Fig. 12.11). TV-Step SCAN can be tuned
by varying the value for n. When n-1, N-Step SCAN degenerates to FCFS. As n
approaches infinity, TV-Step SCAN degenerates to SCAN.

<!-- pág. 595 -->

540 Disk Performance Optimization




                             Figure 12.10 | Seek pattern under the FSCAN strategy.




                             Figure 12.11 | Seek pattern under the N-Step SCAN strategy (n = 3).

                                   FSCAN and TV-Step SCAN offer good performance due to high throughput
                             and low mean response times. Because they prevent indefinite postponement, their
                             distinguishing characteristic is a lower variance of response times than with SSTF
                             and SCAN, especially when requests would be indefinitely postponed under the lat-
                             ter two strategies.

<!-- pág. 596 -->

                                                                                    12.5 Disk Scheduling Strategies 541

Sel Review
1. Explain how FSCAN can lead to lower throughput than SCAN.
2. Compare and contrast FSCAN and JV-Step SCAN.
Ans: 1) If a request to a cylinder in the preferred direction arrives after FSCAN freezes the
queue, the disk head will pass by the cylinder without servicing the request until the next
pass. 2) Both strategies use SCAN to service a portion of the request queue to prevent indef-
inite postponement. FSCAN services all the requests in the queue before beginning a sweep
in a new preferred direction; TV-Step SCAN services only the next n requests in the queue.


12.5.6 LOOK and C-LOOK Disk Scheduling
The LOOK variation of the SCAN strategy "looks" ahead to the end of the current
sweep to determine the next request to service. If there are no more requests in the
current direction, LOOK changes the preferred direction and begins the next
sweep (Fig. 12.12). In this sense, it is appropriate to call this the elevator algorithm,
because an elevator continues in one direction until it reaches the last request in
that direction, then reverses direction. This strategy eliminates unnecessary seek
operations exhibited by other variations of the SCAN strategy (compare the left
side of Fig. 12.12 to the corresponding location in Fig. 12.8).
      Circular LOOK (C-LOOK) variation of the LOOK strategy uses the same
technique as C-SCAN to reduce the bias against requests located at the extreme
ends of the platters. When there are no more requests on a current inward sweep,
the read/write head moves to the request closest to the outer cylinder (without ser-
vicing requests in between) and begins the next sweep. The C-LOOK policy is char-
acterized by a potentially lower variance of response times compared to LOOK and
nigh throughput (although generally lower than LOOK). 36 Figure 12.13 summa-
rizes each of the disk scheduling strategies we have discussed.




Figure 12.12 | Seek pattern under the LOOK strategy.

<!-- pág. 597 -->

542   Disk   Performance   Optimization


                                 Strategy      Description
                                 FCFS          Services requests in the order in which they arrive.
                                 SSTF          Services the request that results in the shortest seek distance first.
                                 SCAN          Head sweeps back and forth across the disk, servicing requests according to
                                               SSTF in a preferred direction.
                                 C-SCAN        Head sweeps inward across the disk, servicing requests according to SSTF in
                                               the preferred (inward) direction. Upon reaching the innermost track, the
                                               head jumps to the outermost track and resumes servicing requests on the
                                               next inward pass.
                                 FSCAN         Requests are serviced the same as SCAN, except newly arriving requests are
                                               postponed until the next sweep. Avoids indefinite postponement.
                                 N-Step        Services requests as in FSCAN, but services only n requests per sweep.
                                 SCAN          Avoids indefinite postponement.
                                               Same as SCAN except the head changes direction upon reaching the last
                                 LOOK          request in the preferred direction.
                                               Same as C-SCAN except the head stops after servicing the last request in the
                                 C-LOOK        preferred direction, then services the request to the cylinder nearest the
                                               opposite side of the disk.

                                Figure 12.13 | Seek optimization strategies summary.

                                Self Review
                                1. Why does C-LOOK typically exhibit throughput lower than that of LOOK?
                                2. Under C-LOOK, in what order would the requests presented in Fig. 12.5 be serviced?
                               Ans: 1) The time spent seeking from one end of the platter to the furthest request from the
                               position of the read/write head at the end of the sweep increases the mean response time,
                               which decreases throughput. 2) 52, 47, 33, 8, 99, 75, 74, 72


                                12.6 Rotational Optimization
                                Because the dominant component of access time in early hard drives was seek time,
                                research focused on seek optimization. However, today's hard disks exhibit seek
                                times and average latencies that are of the same order of magnitude, meaning that
                                rotational optimization can often improve performance.37 Processes that access data
                                sequentially tend to access entire tracks of data and thus do not benefit much from
                                rotational optimization. However, when there are numerous requests to small pieces
                                of data randomly distributed throughout the disk's cylinders, rotational optimization
                                can improve performance significantly. In this section, we discuss how to combine
                                seek and rotational optimization strategies to achieve maximum performance.

                                12.6.1 SLTF Scheduling
                                Once the disk arm arrives at a particular cylinder, there might be many requests
                                pending on the various tracks of that cylinder. The shortest-latency-time-first

<!-- pág. 598 -->

                                                                                     12.6      Rotational Optimization 543

(SLTF) strategy examines all of these requests and services the one with the short-
est rotational delay first (Fig. 12.14). This strategy has been shown to be close to the
theoretical optimum and is relatively easy to implement. 38 Rotational optimization
is sometimes referred to as sector queuing; requests are queued by sector position
around the disk, and the nearest sectors are serviced first.

Self Review
1. Why is sector queuing easy to implement?
2. Is rotational optimization appropriate for today's hard disks? Why?
Ans: 1) Sector queuing determines the best access pattern for sectors on a track. Assuming
that sectors are at fixed locations and that the disk can spin only in one direction, sector
queuing simply is a sorting problem. 2) Yes, rotational optimization is appropriate. Today's
hard disks exhibit seek times and average latencies that are of the same order of magnitude.


12.6.2 SPTF and SATF Scheduling
The shortest-positioning-time-first (SPTF) strategy next services the request that
requires the shortest positioning time, which is the sum of the seek time and rota-
tional latency time. Like SSTF, SPTF results in high throughput and a low mean




Figure 12.14 | SLTF scheduling. The requests will be serviced in the indicated order
regardless of the order in which they arrived.

<!-- pág. 599 -->

544 Disk Performance Optimization

                              response time, and it can also indefinitely postpone requests to the innermost and
                              outermost cylinders.39
                                    A variation of SPTF is the shortest-access-time-first (SATF) strategy, which
                              next services the request that requires the shortest access time (i.e., positioning time
                              plus transmission time). SATF exhibits higher throughput than SPTF, but large
                              requests can be indefinitely postponed by a series of smaller requests, and requests
                              to the innermost or outermost cylinders can be indefinitely postponed by requests
                              to midrange cylinders. Both SPTF and SATF can improve performance by imple-
                              menting the "look-ahead" mechanisms described in Section 12.5.6.40
                                    Figure 12.15 demonstrates the difference between SPTF and SATF. In
                              Fig. 12.15(a), the disk receives two requests for data records of the same size, A and
                              B, that are located on adjacent cylinders. Data record A is located in the same cylin-
                              der as the read/write head, but approximately one-half rotation away from the
                              read/write head. Data record B is near the read/write head but is located on an
                              adjacent cylinder. In this case, the transmission time is identical for A and B
                              because A and B are the same size, so SATF reduces to SPTF. Thus, for this particu-
                              lar disk, both SATF and SPTF would service the request for data record B first,
                              because the disk takes less time to perform a single-cylinder seek operation than to
                              rotate the platter 180 degrees. If the seek time is adequately small, the disk can ser-
                              vice the request for B, then reposition the head to service the request for A within
                              one disk rotation. On the contrary, SSTF would service A first, requiring more than
                              one revolution of the platter to service both requests. Thus, SATF and SPTF can
                              increase throughput compared to SSTF
                                    Now consider that data record B consumes an entire track whereas A is stored
                              in one sector, as shown in Fig. 12.15(b). Assume that the location of the first byte of




                             Figure 12.15 | SPTF (a) and SATF (b) disk scheduling examples.

<!-- pág. 600 -->

                                                                                    12.6      Relational   Optimization   545

each record is the same as in the previous example. In this case, SPTF would service
requests in exactly the same order as in the previous example, because the position-
ing times are the same. However, SATF would service request A first, because
request A requires one half of a rotation plus nominal transmission time, whereas
request B requires a nominal rotational latency time plus a transmission time equal
to the time required for the platter to complete one revolution.
      SPTF and SATF require knowledge of disk characteristics including latency
time, track-to-track seek times and relative locations of sectors. Unfortunately,
many of today's hard drives expose misleading geometry. For example, many disks
hide error-checking and correcting data from the operating system (so that it can-
not be unintentionally or maliciously modified), so consecutively numbered sectors
may not precisely correspond to contiguous physical locations on disk. On some
systems, when bad sectors are detected, alternate ones are assigned. For example, if
sector 15 becomes unusable, the disk might send its requests to a reserved sector
other than 14 or 16. These alternate sectors can be widely dispersed over the disk
surfaces, causing seeks where none might actually be expected.
      These features, such as using alternate sectors, which improve data integrity,
tend to counteract efforts to improve disk performance using scheduling strategies,
because the disk provides the operating system with incomplete or misleading posi-
tional information.41 Although some architectures and hard disks provide com-
mands to retrieve the real geometry of the disk, this feature is not supported by all
disks. Other hard disk architectural features complicate disk scheduling strategies;
for more information, see the links provided in the Web Resources section at the
end of the chapter.
      A straightforward performance enhancement technique is to decrease rota-
tional latency by increasing the rotational speed of the disk. However, designers
have encountered significant problems when increasing the rotations per minute
 RPM) of a hard disk. Faster-rotating disks consume greater amounts of energy (a
key concern on laptop computers with limited battery power), radiate more heat,
make more noise and require more costly mechanical and electrical mechanisms to
control them. 42 Given these and other problems, RPM speed has increased only
modestly (only a few percent a year over the past decade) to approximately 5,400 to
7.200 RPM for PCs and 10,000-15,000 RPM for servers and high-end machines.43



Self Review
1. What is the difference between the SPTF and SATF algorithms? Why would a designer
   choose one over the other?
2. What factors prevent operating systems from obtaining accurate knowledge of hard disk
   geometries?
Ans: 1) SPTF services the request that it can begin accessing within the shortest period of
time. SATF services the request that it can complete accessing within the shortest time.
Although SATF has higher throughput, it favors requests to small amounts of data over
requests to large amounts of data. Thus, SATF is more appropriate for systems that issue

<!-- pág. 601 -->

546 Disk Performance Optimization

                                   many requests for small data records. SPTF is more appropriate for systems that generate
                                   requests for both large and small data records, because it does not consider the size of a
                                   request. 2) Some types of hard disk hide information, such as the location of error-protection
                                   data and bad sectors.



                                   12.7 System Considerations
                                   When is disk scheduling useful? When might it degrade performance? These ques-
                                   tions must be answered in the context of the overall system. The sections that follow
                                   discuss several considerations that might influence a designer's decisions.


                                  Storage as Limiting Resource
                                   When disk storage proves to be a bottleneck, some designers recommend adding
                                   more disks to the system (see the Operating Systems Thinking feature, Saturation
                                   and Bottlenecks). This does not always solve the problem, because the bottleneck
                                   could be caused by a large request load on a relatively small number of disks. When
                                   this situation is detected, disk scheduling may be used as a means of improving per-
                                   formance and eliminating the bottleneck.


                                  System Load
                                  Disk scheduling might not be useful in a batch-processing system with a relatively
                                  low degree of multiprogramming. Scheduling becomes more effective as the ran-
                                  domness of multiprogramming increases, which increases the system load and leads
                                  to erratic disk request patterns. For example, file servers in local area networks can
                                  receive requests from hundreds of users, which normally results in the kind of ran-




                Operating Systems Thinking

    Saturation and Bottlenecks
    Operating systems often manage           a few resources have become sat-           could result in overall system
    hardware and software configu-           urated, i.e., they have reached            improvement at a relatively mod-
    rations. When a system is per-           their capacity and cannot service          est cost. Systems should be built in
    forming poorly, you might be             requests any faster. Such resources        ways that make it easy to locate
    inclined to speak of the problem         are called bottlenecks. Locating           bottlenecks. Chapter 14 presents
    "in the whole"—the "whole sys-           bottlenecks and dealing w i t h            a thorough treatment of perfor-
    t e m " is performing poorly. In fact,   them by adding resources in only           mance issues, including saturation
    its often the case that only one or      one or a few areas of the system,          and bottlenecks.

<!-- pág. 602 -->

                                                                                           12.7 System Considerations 547
dom request patterns that are best serviced using disk scheduling. Similarly, online
transaction processing (OLTP) systems, such as Web and database servers, typically
receive many disk requests to randomly distributed locations containing small
amounts of data (e.g., HTML files and database records). Research has shown that
disk scheduling algorithms such as C-LOOK and SATF (with look-ahead) can
improve performance in this type of environment.44-45



Much of the analytical work in the literature assumes that request distributions are
uniform. Conclusions based on the assumption of uniformity may be invalid on sys-
tems whose request distributions are not uniformly distributed over the disk sur-
faces. Nonuniform request distributions are common in certain situations, and their
consequences have been investigated.46 In one study, Lynch determined that the
vast majority of disk references are to the same cylinder as the immediately preced-
ing reference.47
       One common cause of highly localized nonuniform request distributions is the
use of large sequential files on dedicated disks. When an operating system allocates
space for the adjacent records of a user's sequential file, it usually places adjacent
records on the same track. When a track is full, additional records are placed on
adjacent tracks within the same cylinder; when a cylinder is full, additional records
are placed on adjacent cylinders. Thus requests for successive records in a sequen-
tial file often cause no seeking at all. When needed, seeks are short, because they
are usually to immediately adjacent cylinders. Obviously, an FCFS disk scheduling
policy would be adequate in this situation. In fact, overhead incurred in more com-
plex scheduling strategies might actually result in degraded performance.

File Organization Techniques
As we discuss in Chapter 13, File and Database Systems, sophisticated file organiza-
tion techniques can cause a proliferation of requests with large seek times. In some
cases, file data retrieval may involve reference to a master index, reference to a cyl-
inder index, and then location of the actual record, a process that could incur sev-
eral seek delays. Because the master index and cylinder index are normally stored
on disk (but separate from the main data area), these seeks can be costly. Such file
organization techniques are convenient for the applications designer but can
degrade performance.



Self Review
1. Why do many systems exhibit nonuniform request distributions?
2. Why does disk scheduling become more effective as system load increases?
Ans: 1) File data is often stored and accessed sequentially, so a request to a particular cylin-
der is likely to be followed by a request to the same cylinder, or to an adjacent cylinder.2) As
system load increases, request patterns tend to become more random, which could lead to

<!-- pág. 603 -->

548 Disk Performance Optimization

                           substantial seek activity. Disk scheduling improves performance by reducing the number of
                           wasteful seek operations.


                           12.8 Caching and Buffering
                           Many systems maintain a disk cache buffer, which is a region of main memory that
                           the operating system reserves for disk data. In one context, the reserved memory
                           acts as a cache, allowing processes quick access to data that would otherwise need
                           to be fetched from disk. The reserved memory also acts as a buffer, allowing the
                           operating system to delay writing modified data until the disk experiences a light
                           load or until the disk head is in a favorable position to improve I/O performance.
                           For example, an operating system may delay writing modified data to disk to allow
                           time for multiple requests to contiguous locations to enqueue, so that they can be
                           serviced with one I/O request.
                                 The disk cache buffer presents several challenges to operating system design-
                           ers. Because the size of the disk cache must be limited to allow enough memory for
                           active processes, the designer must implement some replacement strategy. The
                           cache-replacement question is similar to the page-replacement question, and
                           designers use many of the same heuristics. Most commonly, designers choose a
                           strategy that replaces the least-recently used item in the disk cache buffer.
                                 A second concern arises because disk caching can lead to inconsistencies. Disk
                           cache buffers are maintained in volatile memory, so if the system fails or loses power
                           while modified data is in the cache buffer, those changes are lost. To safeguard data
                           against such problems, the contents of the disk cache buffer are periodically flushed
                           to the hard disk; this reduces the probability of data loss if the system crashes.
                                 A system that employs write-back caching does not write modified data to
                           disk immediately. Instead, the cache is written to disk periodically, enabling the
                           operating system to batch multiple I/Os that are serviced using a single request,
                           which can improve system performance. A system that employs write-through cach-
                           ing writes data both to the disk cache buffer and to disk each time cached data is
                           modified. This technique prevents the system from batching requests, but reduces
                           the possibility of inconsistent data in the event of a system crash.48
                                 Many of today's hard disk drives maintain an independent high-speed buffer
                           cache (often called an on-board cache) of several megabytes. 49 If requested data is
                           stored in the on-board cache, the hard drive can deliver the data at or near the
                           speed of main memory. Additionally, some hard disk interface controllers (e.g.,
                           SCSI and RAID controllers) maintain their own buffer caches separate from main
                           memory. When requested data is not located in the main memory buffer cache, on-
                           board buffer caches improve I/O performance by servicing requests without per-
                           forming relatively slow mechanical operations. 50 However, one study showed that
                           disks that include on-board caches typically use replacement strategies that adapt
                           poorly to random request patterns, leading to suboptimal performance. 51 It is also
                           likely that on-board buffer caches and main memory buffer caches will contain the
                           same data, which leads to inefficient resource utilization.

<!-- pág. 604 -->

                                                                            12.9     Other Disk Performance Techniques 549

Self Review
1. What are the trade-offs when selecting the size of the system's disk cache buffer?
2. State when write-back caching and write-through caching are appropriate, and why.
Ans: 1) A small disk cache buffer allows enough memory for active processes, but is likely to
contain only a small portion of requested data, so many requests must be serviced using the
disk. A small cache buffer also limits the number of write requests that can be buffered simulta-
neously, which means that data will need to be flushed frequently. A large cache buffer reduces
the number of I/O operations the system performs, but can reduce the memory available to
store process instructions and data, which could lead to thrashing. 2) Write-back caching
enables the system to batch modified data to reduce the number of disk requests, but does not
prevent loss of buffered data in the event of a power or system failure. Thus, write-back caching
is appropriate for systems where performance is more important than reliability (e.g., some
supercomputers). Because write-through caching immediately sends modified data to disk, it is
appropriate for systems that cannot tolerate loss of data (e.g., database systems).


12.9 Other Disk Performance Techniques
We have considered optimizing the performance of rotational storage devices using
scheduling policies and optimizing system architecture. In this section we analyze
several other disk performance optimization techniques.
      As files and records are added and deleted, a disk's data tends to become dis-
persed throughout the disk, or fragmented. Even sequential files, which one would
expect to exhibit low access latency, become severely fragmented, which increases
access time. Many operating systems provide defragmentation (or disk reorganiza-
tion) programs that can be used periodically to reorganize files. This allows the con-
secutive records of sequential files to be placed contiguously on the disk. Systems
that use noncircular variations of the SCAN strategy tend to visit the midrange cyl-
inders more frequently than the outermost ones. For these systems, frequently ref-
erenced items can be placed on the midrange tracks to reduce average access times.
      Also, operating systems can place files that are likely to be modified near free
space to reduce future fragmentation—as the files grow, new data can be placed in
the adjacent free space instead of elsewhere on disk. Some operating systems allow
users to partition a disk into separate areas. Files are then restricted to these parti-
tions, so fragmentation is reduced. 52 However, partitions can lead to wasted mem-
ory similar to internal fragmentation in paged virtual memory systems.
      Some systems use data compression techniques to reduce the amount of space
required by information on disk (see the Operating Systems Thinking feature,
Compression and Decompression). Data compression decreases the size of a record
by replacing common bit patterns with shorter ones. Therefore, compressed data
consumes less space without losing information. This can ultimately reduce the
number of seeks, latency times and transmission times. However, it can require sub-
stantial processor time to compress the data and later to decompress it to make it
available to applications.
      Systems that need to access certain information quickly benefit from placing
multiple copies of that data at different positions on the disk (see the Operating

<!-- pág. 605 -->

550 Disk Performance Optimization

                               Systems Thinking feature, Redundancy). This can substantially reduce seek and
                               rotation times, but the redundant copies can consume a significant portion of the
                               disk. This technique is more useful for read-only data, or for data that changes nom-
                               inally. Frequent changes degrade the performance of the scheme, because each of
                               the copies must be updated regularly; another danger is that a system crash could
                               leave the multiple copies in an inconsistent state.
                                      In a multiple-disk system in which only one disk request may be serviced at a
                               time, performance can be improved by replicating frequently referenced data on
                               separate drives, which enables higher throughput. Some RAID techniques, dis-
                               cussed in Section 12.10, implement this concept.
                                      Additionally, record blocking can yield significant performance improve-
                               ments. When contiguous records are read or written as a single block, only a single
                               seek is required; if these records are read or written individually, then one seek per
                               record could be required.
                                      Systems that monitor disk access attempts can try to keep frequently accessed
                               data in a favorable position in the memory hierarchy (i.e., in main or cache mem-
                               ory) while transferring infrequently referenced data to slower storage (such as a
                               hard disk or compact disk). This yields an overall performance improvement, but it
                               might provide poor response to users of infrequently accessed data. This is unac-
                               ceptable if the infrequently accessed data belongs to high-priority applications. It
                               might also be helpful to dedicate a disk to a single high-performance application.
                                      In many environments, there are often short periods when there are no wait-
                               ing requests for the disk to service and the disk arm sits idle, waiting for the next




                Operating Systems Thinking
    Compression and Decompression
    An excellent use of abundant,         networking infrastructure, espe-      tively cheap compared to trans-
    cheap processor power is com-         cially transmission lines, is enor-   mission bandwidth. Compression
    pression and decompression of         mous. It simply is not feasible to    enables messages to be shrunk for
    data. On hard disks, this helps       keep upgrading the entire world's     transmission over relatively slow
    reduce the space required to store    networking infrastructure every       networks, essentially increasing
    files. It is also important in net-   time a faster transmission tech-      network throughput. Com-
    work transmissions. The world's       nology becomes available. This        pressed messages must be decom-
    networking infrastructure band-       means that the ratio of processor     pressed at the receiving end to be
    widths tend to increase much          speeds to transmission speeds will    usable. Operating systems will
    slower than processor power           tend to increase over time, with      increasingly include compression
    does. The capital investment in       processor power remaining rela-       and decompression mechanisms.

<!-- pág. 606 -->

                                                                           12.9    Other Disk Performance Techniques 551

request. 53 If the disk arm is currently at one edge of the disk, it is likely that a long
seek will be required to process the next request. By contrast, if the disk arm is in
the center of the disk, or at some hot spot of disk activity, the average seek time will
be less. Moving the disk arm to a location that will minimize the next seek is known
as disk arm anticipation.54
      Disk arm anticipation can be useful in environments where the disk request
patterns of processes exhibit locality. For best results, the arm should move to the
hot spot of disk activity (rather than simply the center of the disk). When processes
issue requests to sequential locations on disk, however, moving the head to the cen-
ter of the disk after servicing each request can lead to excessive seek activity. In this
case, disk arm anticipation might degrade performance. 55

Self Review
1. How do defragmentation and disk reorganization improve performance?
2. Why might data compression techniques become more practical in the future?
3. Under what conditions is it inappropriate to move the read/write head to the center of the
   disk during idle periods?
4. Why does multiprogramming complicate efforts to anticipate the next request?
Ans: 1) Defragmentation places file data in contiguous blocks on disk, which improves
access times by reducing seek activity when accessing sequential data. Disk reorganization
places frequently or heavily used data in favorable locations on disk (e.g., midrange tracks
for noncircular scheduling strategies) to reduce average seek times. 2) There is a growing gap
between processor speed and disk speed. The reduced access time due to data compression




                Operating Systems Thinking
  Redundancy
  We will see many examples of               function w i t h only a single proces-    ent regions of the same disk, so
  redundancy being employed in               sor, having the extra processors          that we can minimize the move-
  operating systems for a variety of         yields better performance because         ment of the read/write head and
  reasons. A common use of redun-            the processors can all work in par-       the amount of rotational move-
  dancy is creating backups to               allel. It is also effective for fault     ment of the disk before the data
  ensure that if one copy of infor-          tolerance—if one processor fails,         becomes accessible, thus increas-
  mation is lost, it can be restored. A      the system can continue operat-           ing performance. Redundancy, of
  multiprocessing system can have a          ing. RAID reduces access times to         course, has its price. The resources
  pool of identical processors avail-        data on disks by placing redun-           costs money and the hardware
  able to assign to processes and            dant copies of that data on sepa-         and the software to support them
  threads as needed. Such redun-             rate disks that may function in           can become more complex. This is
  dancy has several advantages.              parallel. We can also place redun-        yet another example of trade-offs
  Although the system could still            dant copies of the data on differ-        in operating systems.

<!-- pág. 607 -->

552 Disk Performance Optimization

                           might outweigh the overhead incurred by compressing and decompressing data. 3) If pro-
                           grams generally exhibit spatial locality, and the area of locality is not at the center of the disk,
                           then moving the head to the center of the disk during each idle period requires a wasteful
                           seek to return to the disk's hot spot when requests resume. 4) A multiprogramrned system
                           can service requests from multiple concurrent processes, which may lead to several hot spots
                           on the disk. In this case, it is difficult to determine which, if any, hot spot the read/write head
                           should move to when it is idle.



                           12.10 Redundant Arrays of Independent Disk (RAID)
                           RAID (Redundant Arrays of Independent Disks) is a family of techniques that use
                           multiple disks (called an array of disks) that are organized to provide high perfor-
                           mance and/or reliability. RAID was originally proposed by Patterson, Gibson and
                           Katz; in their paper, the "I" in RAID denotes "Inexpensive," but this has been
                           changed to "Independent" because many RAID systems employ expensive, high-
                           performance disks.56
                                 Patterson et al. recognized that processor speed, main memory size and sec-
                           ondary storage size were increasing rapidly while I/O transfer rates (particularly in
                           hard disks) were growing at a much slower pace. Computer systems were becoming
                           increasingly I/O bound—they could not service I/O requests as quickly as they were
                           generated, and could not transfer data as quickly as it was capable of being con-
                           sumed. To improve throughput and transfer rates, the authors recommended creat-
                           ing arrays of disks that could be accessed simultaneously.57

                           12.10.1 RAID Overview
                           In their original paper, Patterson et al. proposed five different organizations, or lev-
                           els, of disk arrays.58 Each RAID level is characterized by data striping and redun-
                           dancy. Data striping entails dividing storage into fixed-size blocks called strips.
                           Contiguous strips of a file are typically placed on separate disks so that requests for
                           file data can be serviced using multiple disks at once, which improves access times.
                           A stripe consists of the set of strips at the same location on each disk in the array. In
                           Fig. 12.16, a portion of a file is divided into four strips of identical length, each on a
                           different disk in the array. Because each strip is placed at the same location on each
                           disk, the four strips form one stripe. Striping distributes a system's data across mul-
                           tiple disks, which enables higher throughput than a single-disk system because data
                           can be accessed from multiple disks simultaneously.
                                 When selecting a strip size, the system designer should consider the average
                           size of disk requests. Smaller strip sizes, also called fine-grained strips, tend to
                           spread file data across several disks. Fine-grained strips can reduce each request's
                           access time and increase transfer rates, because multiple disks simultaneously
                           retrieve portions of the requested data. While these disks service a request, they
                           cannot be used to service other requests in the system's request queue.
                                 Large strip sizes, also called coarse-grained strips, enable some files to fit
                           entirely within one strip. In this case, some requests can be serviced by only a por-

<!-- pág. 608 -->

                                                        12.10   Redundant Arrays of Independent Disks (RAID) 553




Figure 12.16 | Strips and stripe created from a single file in RAID systems.

tion of the disks in the array, so it is more likely that multiple requests can be ser-
viced simultaneously. However, smaller requests are serviced by one disk at a time,
which reduces transfer rates for individual requests compared to fine-grained strips.
      Systems such as Web servers and databases, which typically access multiple
small records simultaneously, benefit from coarse-grained strips, because several 1/
O operations can occur concurrently. Systems such as supercomputers that require
fast access to a small number of records benefit from fine-grained strips, which pro-
vide high transfer rates for individual requests. 59
      The increased transfer rate provided by RAID systems have a price. As the
number of disks in the array increases, so does the likelihood of disk failure. For
example, if the mean-time-to-failure (MTTF) of a single disk is 200,000 hours
(roughly 23 years), the MTTF for a 100-disk array would be 2,000 hours (about
three months). 60 If one disk in an array fails, any files containing strips on that disk
are lost. In business-critical and mission-critical systems, this loss of data could be
catastrophic (see the Operating Systems Thinking feature, Mission-Critical Sys-
tems). As a result, most RAID systems store information that enables the system to
recover from errors, a technique called redundancy. RAID systems use redundancy
to provide fault tolerance (i.e., to sustain failures without loss of data; see the Oper-
ating Systems Thinking feature, Fault Tolerance).
      A straightforward way to provide redundancy is disk mirroring, a technique
that places each unique data item on two disks. A drawback to mirroring is that
only half of the storage capacity of the array can be used to store unique data. As
we discuss in the sections that follow, some RAID levels employ a more sophisti-
cated approach that reduces this overhead. 61

<!-- pág. 609 -->

554 Disk Performance Optimization

                                        To realize the improved performance of striped disks with redundancy, the
                                 system must efficiently divide files into strips, form files from strips, determine the
                                 locations of strips in the array and implement the redundancy scheme. Using a gen-
                                 eral-purpose processor for this purpose can significantly degrade the performance
                                 of processes competing for processor time. Thus, many RAID systems contain spe-




                Operating Systems Thinking
   Mission-Critical Systems
    There are systems where the cost       human lives could be lost. If the      commitments to particular appli-
    of failure is so high that enor-       New York Stock Exchange systems        cations, far greater than what
    mous investment must be made in        were to fail, the world's stock        general-purpose applications
    resources to ensure that the sys-      markets could crash. Thus, operat-     would normally receive. In the
    tems do not fail and perform well      ing systems must be designed to        Linux and Windows XP case stud-
    enough to meet their require-          meet the unique reliability and        ies, we will see, for example, that
    ments. Such systems are often          performance requirements of par-       real-time applications can be
    called mission-critical or business-   ticular applications systems. In       given special treatment.
    critical systems. If an air traffic    some cases, the operating system
    control system were to fail.           must make extraordinary resource




                Operating Systems Thinking
    Fault Tolerance
    Computer systems are employed          ance—if a component fails,             ticular emphasis on these tech-
    in many key aspects of our per-        another " e q u a l " component        niques in our treatments of RAID,
    sonal and professional lives. We       takes over. It is costly to design     multiprocessing in Chapter 15,
    depend on computers not to fail.       fault tolerance into a system, but     computer networking in
    Fault tolerant systems are             the costs can be small compared        Chapter 16, distributed systems in
    designed to keep operating, even       to the costs of system failure,        Chapter 17, distributed file sys-
    in the presence of problems that       especially in business-critical or     tems in Chapter 18 and computer
    might typically cause system fail-     mission-critical systems. We dis-      security in Chapter 19.
    ure. Redundancy is a popular           cuss issues of fault tolerance in
    means of achieving fault toler-        many parts of the book, w i t h par-

<!-- pág. 610 -->

                                                             12.10 Redundant Arrays of Independent Disks (RAID) 555
cial-purpose hardware called a RAID controller to perform such operations
quickly. RAID controllers also simplify RAID implementation by enabling the
operating system simply to pass read and write requests to the RAID controller,
 which then performs striping and maintains redundant information as necessary.
However, RAID controllers can significantly increase the cost of a RAID system.
      A systems designer choosing to adopt a RAID system must balance cost, per-
formance and reliability. Typically, improving one characteristic worsens the other
two. For example, to reduce the cost of the RAID system, one might reduce the
number of disks in the array. A smaller number of disks often reduces performance
by limiting transfer rates and can reduce reliability by limiting the array's capacity
to store redundant information.

Self Review
1. Explain when fine-grained and coarse-grained strips are appropriate in RAID systems.
2. Why should RAID systems provide some degree of fault tolerance?
Ans: 1) Fine-grained strips are appropriate for systems requiring individual I/O operations to
be performed quickly. Coarse-grained strips are appropriate for systems that must fulfill many
I/O requests simultaneously. 2) The greater the number of disks in an array, the more likely it is
that one of them will fail. Thus, RAID systems should provide additional fault tolerance.

12.10.2 Level 0 (Striping)
RAID level 0 uses a striped disk array with no redundancy. Figure 12.17 illustrates a
RAID 0 configuration containing four striped disks. If an application requests to read
data stored in strips A and B of the array data from both strips can be read simulta-
neously, because they are on separate disks (Di and D2). Further, the RAID control-
ler can simultaneously service a write request to strip K, located on disk D3.
      RAID level 0 was not one of the five original levels of RAID and is not con-
sidered a "true" RAID level because it does not provide fault tolerance. If one of
the disks fails, all the data in the array that depend on the failed disk are lost.
Depending on the array's strip size, all data stored in the array could become unus-
able with the loss of a single disk.62
      RAID level 0 is simple to implement and does not incur storage overhead to
provide fault tolerance. Further, a RAID 0 system with n disks performs reads and
writes at a rate up to n times greater than that of a single disk. RAID 0 systems are
appropriate for systems where high performance and low cost are more important
than reliability.63, 64

Self Review
1. Why is RAID level 0 not considered a "true" RAID level?
2. What are the benefits of RAID level 0?
Ans: 1) RAID level 0 does not provide fault tolerance through redundancy. 2) RAID level
0 provides high transfer rates, is simple to implement and does not incur storage overhead to
provide fault tolerance.

<!-- pág. 611 -->

556   Disk   Performance   Optimization




                                Figure 12.17 | RAID level 0 (striping).


                                12.10.3 Level 1 (Mirroring)
                                RAID level 1 employs disk mirroring (also called shadowing) to provide redun-
                                dancy, so each disk in the array is duplicated. Stripes are not implemented in level 1,
                                reducing both hardware complexity and system performance. Figure 12.18 displays
                                a RAID 1 array. Notice that disks D1 and D2 contain the same data, and disks D3
                                and D 4 contain the same data. Level 1 arrays permit multiple I/O operations to be
                                serviced simultaneously. For example, in Fig. 12.18, requests to read data stored on
                                blocks A and B can be serviced concurrently by each disk of the mirrored pair, D1
                                and D 2 . To ensure consistency, modified data must be written to a pair of mirrored
                                disks, so multiple write requests to the same mirrored pair must be serviced one at a
                                time. Note that in Fig. 12.18, read requests for blocks A and B can be serviced by
                                disks D1 and D2 while a write request to block I is serviced by disks D3 and D 4 .
                                      Although RAID level 1 provides the highest degree of fault tolerance of any
                                RAID level, only half of the array's disk capacity can be used to store unique data.
                                Thus, the cost per unit storage in a RAID 1 array is twice that in a RAID 0 array.
                                Because each block of data is stored on a pair of disks, the system can sustain multi-
                                ple disk failures without loss of data. For example, if disk D3 fails, the system can
                                continue to operate using the mirrored data on D 4 . A new disk can subsequently be
                                installed to replace D 3 . Recovering and rebuilding data from a failed disk, called
                                data regeneration, entails copying the redundant data from the mirrored disk.
                                However, if both disks in a mirrored pair fail, their data is unrecoverable. 65

<!-- pág. 612 -->

                                                     12.10 Redundant Arrays of Independent Disks (RAID) 557




Figure 12.18 | RAID level 1 (mirroring).

      Some RAID systems contain "spare" disks (also called hot spare disks or online
spares) that can replace failed disks, much like a spare tire for an automobile. Some
systems also feature hot swappable disk drives that can be replaced while the system
is online, which allows data regeneration to occur as the system runs—necessary in
high-availability environments such as online transaction-processing systems.66
      Level 1 arrays are characterized by the following advantages and disadvantages:
     • High storage overhead—only half of the array's storage capacity can be
       used to store unique data.
     • Fast average read transfer rates—two different read requests to data stored
       in the same mirrored pair can be serviced simultaneously.
     • Slower average write transfer rates—multiple write requests to a mirrored
       pair must be performed one at a time. However, write requests to different
       mirrored pairs can be performed simultaneously.
     • High fault tolerance—RAID level 1 can sustain multiple drive failures
       without loss of data or availability. It provides the highest degree of fault
       tolerance among the most popular RAID levels.
     • High cost—the storage overhead increases cost per unit capacity.

<!-- pág. 613 -->

558   Disk   Performance   Optimization

                                RAID 1 is best suited for environments in which reliability is a higher priority than
                                cost or performance. 67

                                Self Review
                                1. Compare and contrast RAID 0 and RAID 1 in terms of cost, performance and reliability.
                                2. Why is RAID 1 appropriate for business- and mission-critical systems?
                                Ans: 1) RAID 0 costs less than RAID 1 when capacity is held fixed. Read and write perfor-
                                mance is dependent on system load and strip sizes, but both RAID 0 and RAID 1 can service
                                read requests for data on different disks simultaneously. RAID 0 can service write requests for
                                data on different disks simultaneously; RAID 1 can perform write requests simultaneously
                                only if they are to data stored on different mirrored pairs. RAID 0 is much more likely to fail
                                than a single disk; RAID 1 is much less likely to fail than a single disk. 2) In these systems, per-
                                formance, reliability and availability are more important than cost. RAID 1 offers high perfor-
                                mance for read requests and extremely high reliability, and it can continue to operate without
                                loss of data if one or more disks fail (but at reduced performance levels).


                                12.10.4 Level 2 (Bit-Level Hamming ECC Parity)
                                RAID level 2 arrays are striped at the bit level, so each strip stores one bit. Level 2
                                arrays are not mirrored, which reduces the storage overhead incurred by level 1
                                arrays. When a disk in a RAID system fails, it is analogous to a portion of a message
                                that has been corrupted during data transfer, such as during network transmission.
                                The problem of unreliable transmission has been well researched and several solu-
                                tions have been proposed (for examples of solutions to the problem of unreliable
                                transmission, see www. eccpage. com). RAID level 2 borrows from a technique that
                                is commonly implemented in memory modules called Hamming error-correctins
                                codes (Hamming ECCs), which uses parity bits to check for errors in data transmit-
                                ted from disks and to correct them, if possible.68
                                      Parity bits can be calculated as follows. Consider an array in which each stripe
                                stores four bits. When the RAID system receives a request to write the data 0110 to
                                a stripe, it determines the parity of the sum of the bits, i.e., whether the sum is odd
                                or even. In this case, the parity sum (2) is even, so the system writes the stripe to the
                                corresponding four data disks of the array and a 0, representing even parity, to a
                                parity disk. [Note: Although data is striped at the bit level, most requests corre-
                                spond to data in multiple stripes that can be written at once to improve perfor-
                                mance.] RAID systems generally place parity bits on a separate disk, so that reads
                                and writes to each stripe can be performed by all disks simultaneously. When the
                                stripe is next accessed, the system reads the stripe and its corresponding parity bit.
                                calculates the stripe's parity and compares it to the value read from the parity disk.
                                If a disk error causes the third bit of the stripe to change from 1 to 0 (i.e., the stripe
                                stores 0100), the stripe will have odd parity, and the system can detect the error by
                                comparing the parity to the value stored on the parity disk.
                                    A limitation of this particular form of parity is that it cannot detect an even
                                number of errors. For example, if both the second and third bits change from 1 to 0

<!-- pág. 614 -->

                                                            12.10 Redundant Arrays of Independent Disks (RAID) 559

(i.e., the stripe stores 0000), the stripe will still have even parity. Further, this tech-
nique does not enable the system to determine which, if any, bits have errors.
       Hamming error-correcting codes (Hamming ECCs) use a more sophisticated
approach to enable the system to detect up to two errors, correct up to one error
and determine the location of the error in a stripe (the algorithm behind Hamming
ECC parity generation is beyond the scope of this book; it is described at
www2.rad.com/networks/1994/err_con/hamming.htm). The size of Hamming
ECC codes, and thus the number of parity disks, increases according to the loga-
rithm of the number of data disks. For example, an array of 10 data disks requires
four parity disks; an array of 25 data disks requires five parity disks.69 Thus, level 2
arrays containing a large number of disks incur significantly less storage overhead
than level 1 arrays.
        Figure 12.19 illustrates a level 2 array containing four data disks and three
parity disks. Stripe A is composed of the strips A0-A3, which occupy the first strips
on the data disks D1-D4. Stripe As corresponding Hamming ECC is composed of
the bits A x -A z , which occupy the first strips on the parity disks P1-P3.
        Consider a write request to store data in strips A 0 , A 1 , A 2 , A 3 , B 0 and B 1 . In
this case, because the Hamming ECC code is computed for each write, the control-
ler must write stripes A and B, and the Hamming ECC code for each stripe. Even




Figure 12.19 | RAID level 2 (bit-level ECC parity).

<!-- pág. 615 -->

560   Disk   Performance   Optimization

                                though only two of the four bits in stripe B are modified, the entire B stripe must be
                                read and its Hamming ECC code calculated and written to disk. This process, which
                                degrades performance because the system must access the array twice for each
                                write, is called a read-modify-write cycle.
                                      Although the ECC disks reduce the overhead associated with redundancy
                                when compared to mirroring, they can degrade performance because multiple
                                requests cannot be serviced simultaneously. Each read request requires the array to
                                access all disks, compute the ECC, and compare it with the value retrieved from the
                                parity disks. Some systems reduce this bottleneck by computing parity information
                                only for write requests. However, the system must access all disks to maintain parity
                                information when performing a write, meaning that write requests must be serviced
                                one at a time.
                                      One way to increase the maximum number of concurrent reads and writes
                                using a RAID level 2 array is to divide the system's disks into several small RAID
                                level 2 arrays. Unfortunately, this technique increases storage overhead, because
                                smaller groups require a a larger ratio of parity disks to data disks. For example, a
                                32-data-disk level 2 array requires six parity disks. If the system were divided into
                                eight groups of four data disks, the resulting arrays would require 24 parity disks.70
                                      The primary reason that RAID 2 is not implemented in today's systems is that
                                modern disk drives maintain Hamming ECCs or comparable fault-tolerance mech-
                                anisms transparently in hardware. Almost all current SCSI and IDE drives contain
                                built-in error detection and disk monitoring. 71

                                Self Review
                                1. How does dividing a large RAID level 2 array into subgroups affect cost, performance
                                   and reliability?
                                2. Why is RAID level 2 rarely implemented?
                                Ans: 1) Dividing a level 2 array into subgroups improves performance because multiple
                                requests can be serviced simultaneously. Subgroups do not affect reliability, because the
                                same error-checking routines are performed for each subgroup. As a whole, the subgroups
                                require more parity disks than a single large array, which increases cost. 2) Because modern
                                hardware devices have built-in error detection and disk monitoring that perform the same
                                checks as level 2 arrays, designers seek a lower-cost and higher-performance alternative to
                                providing fault tolerance.



                                12.10.5 level 3 (Bit-level XOR ECC Parity)
                                RAID level 3 stripes data at the bit or byte level. Instead of using Hamming ECC
                                for parity generation, RAID 3 uses XOR (exclusive or) error-correcting codes
                                (XOR ECCs). The XOR ECC algorithm is much simpler than the Hamming ECC.
                                It is called XOR ECC because it uses the logical XOR operation:
                                      (a XOR b) = 0 when a and b are both zero or both one;
                                                = 1 otherwise.

<!-- pág. 616 -->

                                                           12.10 Redundant Arrays of Independent Disks (RAID) 561

       It follows that (a XOR (b XOR c) ) = 0 only when an even number of the argu-
ments are 1 or 0. RAID level 3 exploits this fact to perform nested XOR operations
on each byte to generate its XOR ECC. For example, consider stripe A in
Fig. 12.20. Let A0 = 1, A1 = 0, A2 = 0 and A3 = 1; or, more succinctly, A = 1001. The
system uses nested XOR operations to compute A's parity. If the number of l's or
0's is even, the parity bit, Ap, is 0; otherwise, Ap is 1. In this case there are two l's, so
Ap = 0. If the system stripes at the byte level, the XOR ECC is calculated for each
bit, so each parity strip stores 8 bits.
        XOR ECC uses only one disk to hold parity information, regardless of the
size of the array. Note that, unlike Hamming ECCs, XOR ECCs do not enable the
system to detect which bit contains erroneous data. This is acceptable, because most
parity errors in RAID systems result from the failure of an entire disk, which is easy
to detect. For example, assume that disk D2 has failed (Fig. 12.20). In this case,
when the system attempts to read stripe A, it finds A = 1x01 (where x is the
unknown bit) and Ap - 0. Because Ap = 0, stripe A must have stored an even num-
ber of l's. Thus, the system can determine that A2 = 0 and regenerate the lost data.
This technique can be applied to recover from any single data disk failure; if the
parity disk fails, recovery entails recomputing the parity from the data disks.72




Figure 12. 20 | RAID level 3 (bit-level, single parity disk).

<!-- pág. 617 -->

562 Disk Performance Optimization

                                  Due to fine-grained striping, most reads require access to the entire array.
                           Further, due to parity generation, only one write can be performed at a time. Simi-
                           lar to RAID level 2, this yields high transfer rates when reading and writing large
                           files, but, in general, only one request can be serviced at a time.73 The primary
                           advantage of RAID level 3 is that it is easy to implement, offers reliability similar to
                           RAID level 2, and entails significantly lower storage overhead than RAID level 2.74



                           Self Review
                           1. Compare and contrast RAID levels 2 and 3.
                           2. Why is XOR ECC parity, instead of Hamming ECC parity, sufficient for most RAID systems?
                           Ans: 1) Both RAID levels 2 and 3 provide fault tolerance using parity to reduce the over-
                           head of mirroring, both use dedicated parity disks and, in general, both cannot service multi-
                           ple requests simultaneously. RAID level 2 incurs greater storage overhead than level 3. 2)
                           Although XOR ECCs cannot determine which disk has failed, the system can easily deter-
                           mine this, because failed disks do not respond to requests.Therefore, the system can regener-
                           ate one failed disk using a single parity disk.




                           12.10.6 Level 4 (Block-Level XOR ECC Parity)
                           RAID level 4 systems are striped using fixed-size blocks (typically much larger than
                           a byte) and use XOR ECC to generate parity data, which requires a single parity
                           disk. Figure 12.21 depicts a RAID 4 array. Note that the only organizational differ-
                           ence between level 3 and level 4 arrays is that each data strip in a level 4 array
                           stores more data.
                                 In RAID levels 2 and 3, each request's data is typically stored on each data
                           disk in the array. However, because RAID level 4 permits coarse-grained strips, it is
                           possible that requested data might be stored on a small fraction of the disks in the
                           array. Thus, if parity is not determined for each read, the system can potentially ser-
                           vice multiple read requests simultaneously. Because the ECC codes are used prima-
                           rily for data regeneration as opposed to error checking and correcting, many
                           systems eliminate the parity calculation when reads are performed so that multiple
                           read requests can be serviced simultaneously.75
                                 When servicing a write request, however, the system must update parity infor-
                           mation to ensure that no data is lost in the event of a disk failure. When coarse-
                           grained strips are employed, write requests rarely modify data on each disk in the
                           array. Again, accessing each disk in the array to compute parity information can
                           lead to substantial overhead. Fortunately, the system can calculate the new parity
                           bit, Ap', simply by using the data block before modification, Ad, the modified data
                           block, Ad', and the corresponding parity block on disk, Ap:
                                 Ap' = (Ad XOR Ad') XOR Ap.76

<!-- pág. 618 -->

                                                          12.10 Redundant Arrays of Independent Disks (RAID) 563

      You will be asked to prove this relation in the exercises. This technique elimi-
nates wasteful disk I/O operations, because writes do not require access to the
entire array. However, because each write request must update the parity disk,
write requests must be performed one at a time, creating a write bottleneck. As we
discuss in the next section, RAID level 5 removes the write bottleneck, so RAID
level 4 is rarely implemented.77-78-79-80




Figure 12.21 | RAID level 4 (block-level parity).

Self Review
1. How does RAID level 4 offer higher performance than RAID level 3?
2. Why can RAID level 4 perform only one write at a time?
Ans: 1) RAID level 4 permits coarse-grained striping, which enables multiple read requests
to be performed simultaneously and reduces the number of disks accessed for each write
request. 2) RAID level 4 uses one parity disk that must be accessed to update parity informa-
tion each time data in the array is modified.




12.10.7 Level 5 (Block-Level Distributed XOR ECC Parity)
RAID level 5 arrays are striped at the block level and use XOR ECC parity, but
parity blocks are distributed throughout the array of disks (Fig. 12.22).81 Note that
in Fig. 12.22, the parity for the first stripe is placed on disk D5, while the parity for
the second stripe is placed on disk D 4 . Because parity blocks are distributed across
many disks, multiple parity strips can be accessed simultaneously, removing the
write bottleneck for many requests. For example, consider how RAID level 5 ser-
vices write requests to strips A1 and C 2 . The controller accesses disk D2 to write
strip A 1 and disk D 5 to update the corresponding parity block, Ap. The controller
can simultaneously access disk D 4 to write strip C 2 and access disk D 3 to update its
corresponding parity block, Cp.
      Although RAID level 5 improves write performance by distributing parity,
level 5 arrays must still perform a read-modify-write cycle for each write request,

<!-- pág. 619 -->

564 Disk Performance Optimization




                           Figure 12.22 | RAID level 5 (block-level distributed parity).
                           requiring at least four I/O operations to service each write request. If a system con-
                           sistently writes small amounts of data, the number of costly I/O operations can sig-
                           nificantly degrade performance. 82
                                 Several methods have been developed to address this issue. Caching recently
                           accessed data and parity blocks can reduce the number of I/O operations in the
                           read-modify-write cycle. Parity logging can improve RAID level 5 performance by
                           storing the difference between the old parity and new parity (called the update
                           image) in memory instead of performing a read-modify-write cycle. Because a sin-
                           gle update image can store parity information corresponding to multiple write
                           requests, the system can reduce I/O overhead by performing a single update to the
                           parity block in the array after several writes have been performed. 83 A similar per-
                           formance-enhancing technique is called AFRAID (A Frequently Redundant Array
                           of Independent Disks). Instead of performing the read-modify-write cycle with
                           every write, parity data generation is deferred to times when system load is light.
                           This can greatly improve performance in environments characterized by intermit-
                           tent bursts of requests generating small writes.84
                                  Although RAID level 5 increases performance relative to RAID levels 2-4, it
                           is complex to implement, which increases its cost. Also, because parity is distributed
                           throughout the array, data regeneration is more complicated than in other RAID
                           levels.85 Despite its limitations, RAID level 5 is frequently adopted due to its effec-
                           tive balance of performance, cost and reliability. Level 5 arrays are considered gen-
                           eral-purpose arrays and are often found in file and application servers, enterprise
                           resource planning and other business systems.86 Figure 12.23 compares the six lev-
                           els of RAID presented in this chapter.

<!-- pág. 620 -->

                                                           12.10 Redundant Arrays of Independent Disks (RAID) 565




Figure 12.23 | Comparison of RAID levels 0-5.



Other RAID levels
Many other RAID levels exist, each borrowing from one or more of the RAID levels
we discussed in the preceding sections.87 Unfortunately, there is no standard naming
convention for RAID levels, which often leads to confusing or misleading names.
Some of the more notable RAID levels include
      • RAID level 6—extends RAID 5 by distributing two parity blocks per
        stripe for higher reliability upon disk failure.88
      • RAID level 0+1 — a set of striped disks (level 0) whose image is mirrored to
        a second set of disks (level 1).
      • RAID level 10—a set of mirrored data (level 1) that is striped across
        another set of disks (level 0), requiring a minimum of four disks.
      Other RAID arrays that have been developed include levels 0+3, 0+5, 50,1+5,
51 and 53.89 RAID level 7, which is a high-performance, high-cost solution, is a propri-
etary technique whose name is trademarked by the Storage Computer Corporation.90




Self Review
1. How does RAID level 5 address the write bottleneck in RAID level 4?
2. What techniques have been implemented to improve performance in RAID systems that
   receive many requests for small writes?
Ans: 1) RAID level 5 distributes parity information across all disks in the array so that mul-
tiple write operations can be performed simultaneously. 2) Caching recently accessed data
 improves write performance by reducing the number of I/O operations generated by read-
modify-write cycles. Delaying the update of parity information improves performance by
reducing the number of disks accessed to perform each write operation.

<!-- pág. 621 -->

566 Disk Performance Optimization

Web Resources
www.disk-tape-data-recovery.com/storage-history.htm                 www.microsoft.com/windows2000/techinfo/administra-
Provides a short history of persistent data storage media.          tion/fileandprint/defrag.asp
www.almaden.ibm.com/sst/storage/index.shtml                         Describes how to use the disk defragmenting utilities in Win-
Describes physical limitations of storage technology and            dows 2000.
promising fields of research IBM has pursued to solve them.         www.pcguide.com/ref/hdd/perf/raid/
colossalstorage.net/colossalll.htm                                  Provides an in-depth introduction to RAID.
Provides links to sites describing evolving storage technologies.   www.acne.com/04_00.html
www.cose.brocku.ca/~cspress/Hel1oWorld/1999/03-                     Provides a summary of most RAID levels.
mar/disk_scheduling_algorithms.html                                 linas.org/linux/raid.html
Contains an article from Hello World, a magazine for com-           Contains articles about RAID and its implementation in Linux
puter science students; the article overviews disk scheduling       systems.
algorithms.                                                         www.pdl.emu.edu/RAID/
www.peguide.com/ref/hdd/index.htm                                   Overviews RAID and provides links to current RAID
Discusses hard disk characteristics.                                research.


Summary
As processor and main memory speeds increase more rap-              method of allocating service, but when the request rate (i.e.,
idly than those of secondary storage devices, optimizing disk       the load) becomes heavy, FCFS results in long waiting times.
performance has become important to realizing optimal per-                FCFS exhibits a random seek pattern in which suc-
formance. Magnetic storage records data by changing the             cessive requests can cause time-consuming seeks from the
direction of magnetization of regions, each representing a 1        innermost to the outermost cylinders. To reduce the time
or a 0. To access data, a current-carrying device called a          spent seeking records, it seems reasonable to order the
read/write head hovers above the medium as it moves.                request queue in some other manner than FCFS. This reor-
       Most modern computers use hard disks as secondary            dering is called disk scheduling. The two most common
storage. As the platters spin, each read-write head sketches        types of scheduling are seek optimization and rotational
out a circular track of data on a disk surface. All read-write      optimization. Disk scheduling strategies often are evalu-
heads are attached to a single disk arm (also called an actu-       ated by comparing their throughput, mean response time
ator, boom or moving-arm assembly). When the disk arm               and variance of response times.
moves the read/write heads to a new position, a different                 First-come-first-served scheduling uses a FIFO queue
set of tracks, or cylinder, becomes accessible. The process         so that requests are serviced in the order they arrive.
of moving the disk arm to a new cylinder is called a seek           Although this technique incurs low execution-time over-
operation. The time it takes for the head to move from its          head, it can result in low throughput due to lengthy seeks.
current cylinder to the one containing the data record                     Shortest-seek-time-first (SSTF) scheduling next ser-
being accessed is called the seek time. The time it takes for       vices the request that is closest to the read-write head's cur-
data to rotate from its current position to a position adja-        rent cylinder (thus incurring the shortest seek time), even if
cent to the read/write head is called latency time. Then the        that is not the first one in the queue. By reducing average
record, which is of arbitrary size, must be made to spin by         seek times, SSTF achieves higher throughput rates than
the read/write head so that the data can be read from or            FCFS, and mean response times tend to be lower for mod-
written to the disk. This is called transmission time.              erate loads. One significant drawback is that higher vari-
       Many processes can generate requests for reading and         ances occur on response times because of the
writing data on a disk simultaneously. Because these pro-           discrimination against the outermost and innermost tracks:
cesses sometimes make requests faster than they can be ser-         in the extreme, indefinite postponement of requests far
viced by the disk, queues build up to hold disk requests.           from the read-write heads could occur.
Some early computing systems simply serviced these                         The SCAN scheduling strategy reduces unfairness and
requests on a first-come-first-served (FCFS) basis, in which        variance of response times by choosing the request that
the earliest arriving request is serviced first. FCFS is a fair     requires the shortest seek distance in a preferred direction.

<!-- pág. 622 -->

                                                                                                           Summary         567
Thus, if the preferred direction is currently outward, the        and begins the next sweep. The C-LOOK strategy is char-
SCAN strategy chooses the shortest seek distance in the out-      acterized by potentially lower variance of response times
ward direction. SCAN behaves much like SSTF in terms of           compared to LOOK, and by high throughput, although
high throughput and good mean response time. However,             lower than that of LOOK.
because SCAN ensures that all requests in a given direction              In many environments, there are often short periods
will be serviced before the requests in the opposite direction,   when there are no waiting requests for the disk to service
it offers a lower variance of response times than SSTF.           and the disk arm sits idle, waiting for the next request. If
       The circular SCAN (C-SCAN) modification to the             the disk arm is in the center of the disk, or at some hot spot
SCAN strategy moves the arm from the outer cylinder to            of disk activity, the average seek time will be less. Moving
the inner cylinder, servicing requests on a shortest-seek         the disk arm to a location that will hopefully minimize the
basis. When the arm has completed its inward sweep, it            next seek is known as disk arm anticipation. It can be use-
jumps (without servicing requests) to the outermost cylin-        ful in environments where processes's disk request patterns
der, then resumes its inward sweep processing requests. C-        exhibit locality and where there is typically enough time to
SCAN maintains high levels of throughput while further            move the disk arm between disk requests. If a request is
limiting variance of response times by avoiding the discrim-      received during anticipatory movement, moving the head
ination against the innermost and outermost cylinders.            to the originally specified location and then to the
SCAN is often called the elevator algorithm.                      requested cylinder increases response time. Allowing the
       The FSCAN and JV-Step SCAN modifications to the            seek to a hot spot to be interrupted to adjust to requests
SCAN strategy eliminate the possibility of indefinitely post-     provides the greatest performance boost.
poning requests. FSCAN uses the SCAN strategy to service                 Rotational optimization was used extensively with
only those requests waiting when a particular sweep begins        early fixed-head devices such as drums, and can improve
(the "F" stands for "freezing" the request queue at a certain     performance in today's hard disks, which exhibit seek times
time). Requests arriving during a sweep are grouped               and average latencies of the same order of magnitude. The
together and ordered for optimum service during the return        shortest-latency-time-first (SLTF) strategy examines all
sweep. jV-Step SCAN services the first n requests in the          pending requests and services the one with the shortest
queue using the SCAN strategy. When the sweep is com-             rotational delay first. Rotational optimization is sometimes
plete, the next n requests are serviced. Arriving requests are    referred to as sector queuing; requests are queued by sec-
placed at the end of the request queue, which prevents            tor position around the disk, and the nearest sectors are
requests in the current sweep from being indefinitely post-       serviced first.
poned. FSCAN and N-Step SCAN offer good performance                      The STLF strategy works well for fixed-head disks
due to high throughput, low mean response times and a             but does not incorporate the positioning time, which is the
lower variance of response times than SSTF and SCAN.              seek time plus latency, of moving-head disks. The shortest-
       The LOOK variation of the SCAN strategy (also              positioning-time-first (SPTF) strategy next services the
called the elevator algorithm) "looks" ahead to the end of        request that requires the shortest positioning time. SPTF
the current sweep to determine the next request to service.       results in high throughput and a low mean response time,
If there are no more requests in the current direction,           similar to SSTF, and can also indefinitely postpone requests
LOOK changes the preferred direction and begins the next          to the innermost and outermost cylinders.
sweep, stopping when passing a cylinder that corresponds                 A variation of SPTF is the shortest-access-time-first
to a request in the queue. This strategy eliminates unneces-      (SATF) strategy, which next services the request that
sary seek operations experienced by other variations of the       requires the shortest access time (i.e., positioning time plus
SCAN strategy by preventing the read/write head from              transmission time). SATF exhibits higher throughput than
moving to the innermost or outermost cylinders unless it is       SPTF, but large requests can be indefinitely postponed by a
servicing a request to those locations.                           series of smaller requests. Requests to the innermost or out-
       The circular LOOK (C-LOOK) variation of the                ermost cylinders can be indefinitely postponed by requests
LOOK strategy uses the same technique as C-SCAN to                to intermediate cylinders. SPTF and SATF can improve per-
reduce the bias against requests located at extreme ends of       formance by implementing the "look-ahead" mechanisms
the platters. When there are no more requests on a current        employed by the LOOK and C-LOOK strategies.
sweep, the read/write head moves to the request closest to               One reason why SPTF and SATF are rarely imple-
the outer cylinder (without servicing requests in between)        mented is that they require knowledge of disk characteris-

<!-- pág. 623 -->

568 Disk Performance Optimization

tics including latency, track-to-track seek times and relative   or near the speed of main memory. However, one study
locations of sectors. Unfortunately, many of today's hard        showed that disks that include on-board caches typically
drives hide such geometry or expose misleading geometries        use replacement strategies that adapt poorly to random
due to hidden error-checking data and bad sectors.               request patterns, leading to suboptimal performance.
       When disk storage proves to be a bottleneck, some                Disks tend to become fragmented as files and records
designers recommend adding more disks to the system.             are added and deleted. Many operating systems provide
This does not always solve the problem, because the bottle-      defragmentation (or disk reorganization) programs that
neck could be caused by a large request load on a relatively     can be used periodically to reorganize files. This allows the
small number of disks. When this situation is detected, disk     consecutive records of sequential files to be placed contigu-
scheduling may be used as a means of improving perfor-           ously on the disk. Also, operating systems can place files
mance and eliminating the bottleneck. Disk scheduling            that are likely to be modified near free space to reduce
might not be useful in a batch-processing system with a rel-     future fragmentation. Some operating systems allow users
atively low degree of multiprogramming. Scheduling               to partition a disk into separate areas. Files are then
becomes more effective as the degree of multiprogram-            restricted to these areas, so fragmentation is reduced. Some
ming increases, which increases the system load and leads        systems use data compression techniques to reduce the
to unpredictable disk request patterns.                          amount of space required by information on disk. Data
       Nonuniform request distributions are common in cer-       compression decreases the size of a record by replacing
tain situations and their consequences have been investi-        common bit patterns with shorter ones. This can reduce
gated. One study determined that the vast majority of disk       seeks, latency times and transmission times, but may
references are to the same cylinder as the immediately pre-      require substantial processor time to compress the data for
ceding reference. Sophisticated file organization techniques     storage on the disk, and to decompress the data to make it
can cause a proliferation of requests with large seek times.     available to applications.
Such techniques are convenient for the applications                     Systems that need to access certain information
designer but can complicate implementation and degrade           quickly benefit from placing multiple copies of that data at
performance.                                                     different positions on the disk. This can substantially
       Many systems maintain a disk cache buffer, which is a     reduce seek and rotation times, but the redundant copies
region of main memory that the operating system reserves         can consume a significant portion of the disk. Also, if one
for disk data. In one context, the reserved memory acts as a     copy is modified, all other copies must be modified, which
cache, allowing processes quick access to data that would        can degrade performance. Additionally, record blocking
otherwise need to be fetched from disk. The reserved mem-        can yield significant performance improvements by reading
ory also acts as a buffer, allowing the operating system to      contiguous records as a single block, requiring only a single-
delay writing the data to improve I/O performance. The           seek. Systems that monitor disk access attempts can try to
disk cache buffer presents several challenges to operating       keep frequently accessed data in a favorable position in the
system designers, because memory allocated to the cache          memory hierarchy (i.e., in main or cache memory) while
buffer reduces the amount allocated to processes. Also,          transferring infrequently referenced data to slower storage
because memory is volatile, power or system failures can         (such as a hard disk or compact disk).
lead to inconsistencies.                                                Redundant Arrays of fndependent Disks (RAID) is a
       Write-back caching writes buffered data to disk peri-     family of techniques that use arrays of disks to address the
odically, enabling the operating system to use a single          problem of relatively slow disk transfer speeds. Each array
request to batch multiple I/Os, which can improve system         organization, called a level, is characterized by data striping
performance. Write-through caching writes data both to           and redundancy. Storage is divided into fixed-size strips; con-
the disk cache buffer and to disk each time cached data is       tiguous strips on each disk generally store noncontiguous
modified. This technique prevents the system from batch-         data or data from different files. A stripe consists of the set of
ing requests but reduces the possibility of inconsistent data    strips at the same location on each disk in the array.
in the event of a system crash.                                         When selecting a strip size, the system designer
       Many of today's hard disk drives maintain an inde-        should consider the average size of disk requests. Smaller
pendent high-speed buffer cache (often called an on-board        strip sizes, also called fine-grained strips, tend to spread file
cache) of several megabytes. If data requested is stored in      data across several disks. Fine-grained strips can reduce
the on-board cache, the hard drive can deliver the data at       each request's access time and increase transfer rates

<!-- pág. 624 -->

                                                                                                              Summary          569
because multiple disks simultaneously retrieve portions of          erance of any RAID level, only half of the array's capacity
the requested data. While these disks service a request,            can be used to store unique data, which increases cost. For
they cannot be used to service other requests in the sys-           each mirrored pair, two read requests can be serviced
tem's request queue.                                                simultaneously, but only one request can be serviced at a
       Large strip sizes, also called coarse-grained strips,        time during a write. Recovering and rebuilding data from a
enable more files to fit entirely within one strip. In this case,   failed disk, called data regeneration, entails copying the
some requests can be serviced by only a portion of the disks        redundant data from the mirrored disk. If both disks in a
in the array, so it is more likely that multiple requests can       mirrored pair fail, their data is unrecoverable.
be serviced simultaneously. However, smaller requests are                  Some RAID systems contain "spare" disks (also called
serviced by one disk at a time, which reduces transfer rates        hot spare disks or online spares) that can replace failed disks,
for individual requests.                                            much like a spare tire for an automobile. Some systems also
       Systems such as Web servers and databases, which             feature hot swappable disk drives that can to be replaced
typically access multiple small records simultaneously, ben-        while the system is online. In these systems, data regenera-
efit from coarse-grained strips because several I/O opera-          tion can occur while the system continues to run, which is
tions can occur concurrently; systems such as                       necessary in high-availability environments such as online
supercomputers that require fast access to a small number           transaction processing systems. RAID 1 is best suited for
of records benefit from fine-grained strips, which provide          business-critical and mission-critical environments in which
high transfer rates for individual requests.                        reliability has higher priority than cost or performance.
       As the number of disks in the array increases, so does              RAID level 2 arrays are striped at the bit level, so
the likelihood that one of those disks will fail, measured by       each strip stores one bit. Level 2 arrays are designed to
the mean-time-to-failure (MTTF). Most RAID systems                  reduce the storage overhead incurred by implementing
maintain copies of data to help enable them to recover              fault tolerance using mirroring. Instead of maintaining
from errors and failures, a technique called redundancy.            redundant copies of each data item, RAID level 2 uses a
Disk mirroring is a redundancy technique that maintains             technique of storing parity information called Hamming
copies of each data item on two disks. A drawback to mir-           error-correcting codes (Hamming ECCs), which allow the
roring is that only half of the storage capacity of the array       system to detect up to two errors, correct up to one error
can be used to store unique data.                                   and determine the location of the error in a stripe. The size
       To realize the improved performance of striped disks         of Hamming ECC codes, and thus the number of parity
with redundancy, the system must efficiently divide files           disks, increases in proportion to the logarithm (base 2) of
into strips, form files from strips, determine the locations of     the number of data disks. Thus, level 2 arrays containing a
strips in the array and implement redundancy. Many RAID             large number of disks incur significantly less storage over-
systems contain special-purpose hardware called a RAID              head than level 1 arrays.
controller to perform such operations quickly. The designer                Although the ECC disks reduce the overhead associ-
must balance cost, performance and reliability when select-         ated with redundancy when compared to mirroring, they
ing a RAID level. Typically, improving one characteristic           can degrade performance, because multiple requests can-
worsens the other two.                                              not be serviced simultaneously. Each read request requires
       RAID level 0 uses a striped disk array with no redun-        the array to access all disks, compute the ECC, and com-
dancy. Level 0 arrays are not fault tolerant; if one disk fails,    pare it with the value retrieved from the parity disks. Simi-
all the data in the array that depend on the failed disk are        larly, when servicing a write request, the Hamming ECC
lost. Depending on the array's strip size, all data stored in       must be calculated for each stripe that is written. Further,
the array could become unusable with the loss of a single           the system must perform a read-modify-write cycle, which
disk. Although RAID 0 is not fault tolerant, it is simple to        degrades performance because the system must access the
implement, yields high transfer rates and does not incur            entire array twice for each write. One way to enable con-
any storage overhead.                                               currency using a RAID level 2 array is to divide the sys-
       RAID level 1 employs disk mirroring (also called             tem's disks into several small RAID level 2 arrays, but this
shadowing) to provide redundancy, so each disk in the               increases storage overhead and cost. The primary reason
array is duplicated. Stripes are not implemented in level 1,        that RAID 2 is not implemented in today's systems is that
reducing both hardware complexity and system perfor-                modern disk drives perform Hamming ECCs or compara-
mance. While this results in the highest degree of fault tol-       ble protection transparently in hardware.

<!-- pág. 625 -->

570 Disk Performance Optimization

       RAID level 3 stripes data at the bit or byte level.       formance by distributing parity, level 5 arrays must still per-
RAID 3 uses XOR (exclusive or) error-correcting codes            form a read-modify-write cycle for each write request,
(XOR ECCs), which use the logical XOR operation to               requiring at least four I/O operations to service each write
generate parity information. XOR ECC uses only one disk          request.
to hold parity information, regardless of the size of the               Caching recently accessed data and parity blocks can
array. The system can use the parity bits to recover from        reduce the number of I/O operations in the read-modify-
any single disk failure; if the parity disk fails, it can be     write cycle. Parity logging can improve RAID level 5 per-
rebuilt from the array's data disks. Due to parity checking      formance by storing the difference between the old parity
RAID level 3 reads and writes require access to the entire       and new parity (called the update image) in memory
array. Similar to RAID level 2, this yields high transfer        instead of performing a read-modify-write cycle. A Fre-
rates when reading and writing large files, but only one         quently Redundant Array of Independent Disks
request can be serviced at a time.                               (AFRAID) improves performance by deferring parity data
       RAID level 4 systems are striped using fixed-size         generation to times at which the system load is light.
blocks (typically larger than a byte) and use XOR ECC to                Although RAID level 5 increases performance rela-
generate parity data that is stored on a single parity disk.     tive to RAID levels 2-4, it is complex to implement, which
Because level 4 arrays enable coarse-grained striping, the       increases its cost. Also, because parity is distributed
system can potentially service multiple read requests simul-     throughout the array, data regeneration is more compli-
taneously, if parity is not determined for each read. When       cated than in other RAID levels. Despite its limitations.
servicing a write request, however, the system must update       RAID level 5 is frequently adopted for its effective balance
parity information to ensure that no data is lost in the event   of performance, cost and reliability. Level 5 arrays are con-
of a disk failure. This means that write requests must be        sidered general-purpose arrays and are often found in file
performed one at a time, creating a write bottleneck.            and application servers, enterprise resource planning
      RAID level 5 arrays are striped at the block level and     (ERP) and other business systems.
use XOR ECC for parity, but parity blocks are distributed               Many other RAID levels exist, each borrowing from
throughout the array of disks. Because parity blocks are         one or more of RAID levels 0-5. Unfortunately, there is no
distributed across many disks, multiple parity blocks can be     standard naming convention for RAID levels, which often
accessed simultaneously, removing the write bottleneck for       leads to confusing or misleading names.
many requests. Although RAID level 5 improves write per-


Key Terms
A Frequently Redundant Array of Independent Disks                bottleneck—Condition that occurs when a resource recerves
    (AFRAID) (RAID)—RAID implementation that defers                   requests faster than it can process them, which can slow
    parity data generation to times when the system's load is         process execution and reduce resource utilization. Hard
    light to improve performance when a system performs               disks are a bottleneck in most systems.
    many small writes.
                                                                 circular LOOK (C-LOOK) disk scheduling—Disk scheduling
actuator—See disk arm.                                                strategy that moves the arm in one direction, servicing
anticipatory movement—Movement of the disk arm during                 requests on a shortest-seek basis. When there are no more
     disk arm anticipation.                                           requests on a current sweep, the read-write head moves to
                                                                      the request closest to the cylinder opposite its current
block—Fixed-size unit of data, typically much larger than a           location (without servicing requests in between) and
    byte. Placing contiguous data records in blocks enables           begins the next sweep. The C-LOOK policy is character-
    the system to reduce the number of I/O operations                 ized by potentially lower variance of response times com-
    required to retrieve them.                                        pared to LOOK; it offers high throughput (although
blocking—Grouping of contiguous records into larger blocks            lower than that of LOOK).
    that can be read using a single I/O operation. This tech-    circular SCAN (C-SCAN) disk scheduling—Disk scheduling
    nique reduces access times by retrieving many records             strategy that moves the arm in one direction, servicing
    with a single I/O operation.                                      requests on a shortest-seek basis. When the arm has com-
boom—See disk arm.                                                    pleted its a sweep, it jumps (without servicing requests) to

<!-- pág. 626 -->

                                                                                                               Key Terms 571
    the cylinder opposite its current location, then resumes its        simplifies data regeneration but incurs substantial storage
    inward sweep processing requests. C-SCAN maintains                  overhead, which increases cost.
    high levels of throughput while further limiting variance       disk reorganization—Technique that moves file data on disk to
    of response times by avoiding the discrimination against             improve its access time. One such technique is defragmen-
    the innermost and outermost cylinders.                               tation, which attempts to place sequential file data contig-
coarse-grained strip (RAID)—Strip size that enables average              uously on disk. Another technique attempts to place
    files to be stored in a small number of strips. In this case,        frequently requested data on tracks that result in low
    some requests can be serviced by only a portion of the               average seek times.
    disks in the array, so it is more likely that multiple          disk scheduling—Technique that orders disk requests to maxi-
    requests can be serviced simultaneously. If requests are             mize throughput and minimize response times and the
    small, they are serviced by one disk at a time, which                variance of response times. Disk scheduling strategies
    reduces their average transfer rates.                                improve performance by reducing seek times and rota-
cylinder—Set of tracks that can be accessed by the read-write            tional latencies.
     heads for a specific position of the disk arm.
                                                                    elevator algorithm—See SCAN disk scheduling.
data compression—Technique that decreases the size of a data
                                                                    first-come-first-served (FCFS) disk scheduling—Disk schedul-
    record by replacing repetitive patterns with shorter bit
                                                                          ing strategy in which the earliest arriving request is ser-
    strings. This can reduce seeks, and transmission times, but
                                                                         viced first. FCFS is a fair method of allocating service, but
    may require substantial processor time to compress the
                                                                         when the request rate (i.e., the load) becomes heavy,
    data for storage on the disk, and to decompress the data
                                                                         FCFS can result in long waiting times. FCFS exhibits a
    to make it available to applications.
                                                                          random seek pattern in which successive requests can
data regeneration (RAID)—Reconstruction of lost data (due                 cause time-consuming seeks from the innermost to the
    to disk errors or failures) in RAID systems.                          outermost cylinders.
data striping (RAID)—Technique in RAID systems that                 fine-grained strip (RAID)—Strip size that causes average files
    divides contiguous data into fixed-size strips that can be           to be stored in multiple stripes. Fine-grained strips can
    placed on different disks. This enables multiple disks to            reduce each request's access time and increase transfer
    service requests for data.                                           rates because multiple disks simultaneously retrieve por-
defragmentation— Moving parts of files so that they are                  tions of the requested data.
    located in contiguous blocks on disk. This can reduce
                                                                    FSCAN disk scheduling—Disk scheduling strategy that uses
    access times when reading from or writing to files
                                                                       SCAN to service only those requests waiting when a par-
    sequentially.
                                                                       ticular sweep begins (the " F " stands for "freezing" the
disk arm—Moving-head disk component that moves read-                   request queue at a certain time). Requests arriving during
    write heads linearly, parallel to disk surfaces.                   a sweep are grouped together and ordered for optimum
disk arm anticipation—Moving the disk arm to a location that           service during the return sweep.
     will minimize the next seek. Disk arm anticipation can be      fragmented disk—Disk that stores files in discontinuous blocks
     useful in environments where process disk request pat-             as the result of file creation and deletion. Such disks
     terns exhibit locality and when the load is light enough           exhibit high seek times when reading files sequentially.
     that there is sufficient time to move the disk arm between         Disk defragmentation can reduce or eliminate the prob-
     disk requests without degrading performance.                       lem.
disk cache buffer—A region of main memory that the operat-          Hamming error-correcting codes (Hamming ECCs)—Tech-
     ing system reserves for disk data. In one context, the            nique of generating parity bits that enables systems to
     reserved memory acts as a cache, allowing processes quick         detect and correct errors in data transmission.
     access to data that would otherwise need to be fetched
     from disk. The reserved memory also acts as a buffer,          hard disk drive—Magnetic, rotational secondary storage
     allowing the operating system to delay writing the data to         device that provides persistent storage for, and random
     improve I/O performance by batching multiple writes into           access to, data.
     a small number of requests.                                    hot spare disk (RAID)—Disk in a RAID system that is not
disk mirroring (RAID)—Data redundancy technique in                      used until a disk fails. Once the system regenerates the
    RAID that maintains a copy of each disk's contents on a             failed disk's data, the hot spare disk replaces the failed
    separate disk. This technique provides high reliability and         disk.

<!-- pág. 627 -->

572 Disk Performance Optimization

hot spot—Disk cylinder that contains frequently requested           parity—Technique that detects an even number of errors in
    data. Some disk arm anticipation techniques move the                 data transmission. Parity information is generated by
    disk head to hot spots to reduce average seek times.                 determining whether the data contains an even (or odd)
load—See request rate.                                                   number of l's (or O's). This parity information is gener-
                                                                         ated after transmission and compared to the value gener-
level (RAID) —A particular organization of a RAID system,                ated before transmission. Error-correction codes (ECCs).
     such as level 1 (mirroring) or level 2 (Hamming ECC par-            such as Hamming or XOR, use the parity of a string of
     ity). See also RAID level 0, RAID level 1, RAID level 2,            bits to detect and correct errors. Parity enables RAID sys-
     RAID level 3, RAID level 4 and RAID level 5.                        tems to provide fault tolerance with lower storage over-
LOOK disk scheduling—Variation of the SCAN disk schedul-                 head than mirrored systems.
   ing strategy that "looks" ahead to the end of the current        parity logging (RAID)—Technique that increases write per-
   sweep to determine the next request to service. If there              formance in RAID systems using parity by postponing
   are no more requests in the current direction, LOOK                   writes to the parity disk while the system is busy. Because
   changes the preferred direction and begins the next                   parity logging stores information in volatile memory, par-
   sweep, stopping when passing a cylinder that corresponds              ity information could be lost if the system loses power.
   to a request in the queue. This strategy eliminates unnec-
                                                                    platter—Magnetic disk medium that stores bits on its surfaces.
   essary seek operations experienced by other variations of
   SCAN by preventing the read-write head from moving to            positioning time—Access time plus latency. Positioning time is
   the innermost or outermost cylinder unless it needs to ser-           used by the SPTF strategy to order requests.
   vice a request at those cylinders.                               preferred direction—Direction in which the disk head is mov-
magnetic tape storage—Rewritable magnetic storage medium                 ing in SCAN-based scheduling algorithms.
   that accesses data sequentially. Its sequential nature           RAID (Redundant Array of Independent Disks)—Family of
   makes it unsuitable for direct access applications.                 techniques that use an array of disks to improve disk
mean response time (disk scheduling)—Average time a system             transfer rates while providing fault tolerance.
   spends waiting for a disk request to be serviced.                RAID controller—Special-purpose hardware that efficiently
mean-time-to-failure (MTTF) (RAID)—Average time before                 performs operations such as dividing files into strips.
   a single-disk failure.                                              forming files from strips, determining the locations of
                                                                       strips in the array and implementing the array's fault-tol-
mirroring (RAID) —See disk mirroring.
                                                                       erance mechanism.
moving-arm assembly—See disk arm.                                   RAID level 0—RAID system that uses a striped disk array
nonuniform request distribution—Set of disk requests that are          with no redundancy. Level 0 arrays are not fault tolerant:
    not uniformly distributed across disk surfaces. This occurs        if one disk fails, all the data in the array that depend on
    because processes exhibit spatial locality, leading to local-      the failed disk are lost. Depending on the array's strip
    ized request patterns.                                             size, all data stored in the array could become unusable
N-Step SCAN disk scheduling—Disk scheduling strategy that              with the loss of a single disk. Although RAID 0 is not
    services the first n requests in the queue using the SCAN          fault tolerant, it is simple to implement, yields high trans-
    strategy. When the sweep is complete, the next n requests          fer rates and does not incur any storage overhead. Level 0
    are serviced. Arriving requests are placed at the end of           arrays are implemented in systems where performance is
    the request queue. N-Step SCAN offer good performance              more important than fault tolerance, such as supercom-
    due to high throughput, low mean response times and a              puters.
    lower variance of response times than SSTF and SCAN.            RAID level 1—RAID system that employs disk mirroring
online spare—See hot spare disk.                                       (also called shadowing) to provide redundancy, so that
                                                                       each disk in the array is duplicated. Stripes are not imple-
online transaction processing (OLTP)—Type of system that               mented in level 1, reducing both hardware complexity and
     typically receives many disk requests to randomly distrib-        system performance. While this results in the highest
     uted locations containing small amounts of data (e.g.,            degree of fault tolerance of any RAID level, only half of
     databases and Web servers). Such systems significantly            the array's capacity can be used to store unique data,
     improve performance using disk scheduling algorithms.             which increases cost. Level 1 arrays are implemented in
partition—Area of a disk whose boundaries cannot be crossed            systems where high availability is more important than
    by file data. Partitions can reduce disk fragmentation.            cost, such as database systems.

<!-- pág. 628 -->

                                                                                                             Key     Terms     573
RAID level 2—RAID system that is striped at the bit level           random seek pattern—Series of requests to cylinders ran-
   (i.e., each strip stores one bit). Level 2 arrays are designed       domly distributed across disk surfaces. FCFS causes ran-
   to reduce the storage overhead incurred by implementing              dom seek patterns that result in high response times and
   fault tolerance using mirroring. Instead of maintaining              low throughput.
   redundant copies of each data item, RAID level 2 uses a          read-modify-write cycle (RAID) —Operation that reads a
   version of Hamming error-correcting codes (Hamming                   stripe, modifies its contents and parity, then writes the
   ECCs) to store parity information that allows the system             stripe to the array. It is performed for each write request
   to detect up to two errors, correct up to one error and              in RAID systems that use parity. Some systems reduce the
   determine the location of the error in a stripe. The size of         cost of read-modify-write cycles by caching strips or by
   Hamming ECC codes, and thus the number of parity                     updating parity information only periodically.
   disks, increases according to the logarithm (base 2) of the
   number of data disks. Thus, level 2 arrays containing a          read-write head—Moving-head disk component that hovers
   large number of disks incur significantly less storage over-         over a disk surface, reading and writing bits as the disk
   head than level 1 arrays.                                            moves.

RAID level 3—RAID system that stripes data at the bit or            redundancy—Technique that maintains multiple identical
   byte level. RAID 3 uses XOR (exclusive or) error-cor-                resources to enable recovery upon failure.
   recting codes (XOR ECCs), which use the logical XOR              Redundant Array of Independent Disks ( R A I D ) - S e e RAID.
   operation to generate parity information. XOR ECC uses           reliability—Measure of fault tolerance. The more reliable a
   only one disk to hold parity information, regardless of the           resource, the less likely it is to fail.
   size of the array. The system can use the parity bits to
   recover from any single disk failure. Due to parity check-       request rate—Measure of request frequency. The higher the
   ing, RAID level 3 reads and writes require access to the             request rate, the greater the system load. Systems experi-
   entire array. Similar to RAID level 2, this yields high              encing a high disk request rate tend to benefit from disk
   transfer rates when reading and writing large files, but             scheduling.
   only one request can be serviced at a time.                      rotational latency—Time required for a disk to rotate a
RAID level 4—RAID system that is striped using fixed-size                requested data item from its current position to a position
   blocks (typically larger than a byte) and uses XOR ECC                adjacent to the read-write head.
   to generate parity data that is stored on a single parity        rotational optimization—Disk scheduling technique that
   disk. Because level 4 arrays enable coarse-grained strip-             reduces access times by next servicing the request to the
   ing, the system can potentially service multiple read                 nearest sector in the read-write head's current cylinder.
   requests simultaneously, if parity is not determined for         SCAN disk scheduling—Disk scheduling strategy that reduces
   each read. When servicing a write request, however, the             unfairness and variance of response times as compared to
   system must update parity information to ensure that no             SSTF by servicing the request that requires the shortest
   data is lost in the event of a disk failure. This means that        seek distance in a preferred direction. SCAN behaves
   write requests must be performed one at a time, creating a          much like SSTF in terms of high throughput and good
   write bottleneck.                                                   mean response times. However, because SCAN ensures
RAID level 5—RAID system that is striped at the block level            that all requests in a given direction will be serviced
   and uses XOR ECC for parity, but distributes parity                 before the requests in the opposite direction, it offers a
   blocks throughout the array of disks. Because parity                lower variance of response times than SSTF. Also called
   blocks are distributed across many disks, multiple parity           the elevator algorithm.
   strips can be accessed simultaneously, removing the write        sector—Smallest portion of a track that can be accessed by an
   bottleneck for many requests. Although RAID level 5                   I/O request.
   increases performance relative to RAID levels 2-A, it is
   complex to implement and more costly. Level 5 arrays are         sector queuing—See rotational optimization.
   considered general-purpose arrays and are often found in         seek operation—Operation that moves the disk head to a dif-
   file and application servers, enterprise resource planning           ferent cylinder.
   (ERP) and other business systems.                                seek time—Time it takes for the read/write head to move from
RAMAC (Random Access Method of Accounting and Con-                      its current cylinder to the cylinder containing the
  trol—First commercial hard drive produced by IBM.                     requested data record.

<!-- pág. 629 -->

574 Disk Performance Optimization

seek optimization—Disk scheduling technique that reduces            spindle—Moving-head disk component that spins platters at
    seek times by generally servicing requests to the cylinder          high speeds.
    near the read-write head.                                       strip (RAID)—Smallest unit of data operated on by a RAID
shadowing (RAID)—See mirroring.                                          system. The set of strips at the same location on each disk
shortest-access-time-first (SATF) disk scheduling—Disk                   is called a stripe.
    scheduling strategy that next services the request that         stripe (RAID)—Set of strips at the same location on each disk
    requires the shortest access time (i.e., positioning time            in a RAID system. Striping enables RAID systems to
    plus transmission time). SATF exhibits higher throughput             access files using multiple disks at once, which improves
    than SPTF, but large requests can be indefinitely post-              transfer times.
    poned by a series of smaller requests, and requests to the      track—Circular region of data on a platter. Sequential file data
    innermost or outermost cylinders can be indefinitely post-          is typically placed contiguously on one track to improve
    poned by requests to intermediate cylinders.                        access time by reducing seeking activity.
shortest-latency-time-first (SLTF) disk scheduling—Disk             transmission time—Time required for a data record to pass by
    scheduling strategy that examines all of the waiting                the read-write head.
    requests and services the one with the shortest rotational
                                                                    UNIVAC 1 (UNIVersal Automatic Computer)—First com-
    delay first. This strategy has been shown to be close to the
                                                                       puter to introduce a magnetic storage tape.
    theoretical optimum and is relatively easy to implement.
                                                                    update image (RAID)—Method to reduce parity computation
shortest-positioning-time-first (SPTF) disk scheduling—Disk
                                                                        time by storing the difference between new and old pari-
    scheduling strategy that next services the request that
                                                                        ties in memory instead of performing a read-modify-
    requires the shortest positioning time. SPTF results in
                                                                        write cycle.
    high throughput and a low mean response time, similar to
    SSTF, and can also indefinitely postpone requests to the        write-back caching—Technique that writes buffered data to
    innermost and outermost cylinders.                                   disk periodically, enabling the operating system to batch
shortest-seek-time-first (SSTF) disk scheduling—Disk sched-             multiple I/Os that are serviced using a single request,
    uling strategy that next services the request that is closest        which can improve system performance.
    to the read-write head's current cylinder (and thus incurs      write-through caching—Technique that writes data both to the
    the shortest seek time), even if that is not the first one in        disk cache buffer and to disk each time cached data is
    the queue. By reducing average seek times, SSTF achieves            modified. This technique prevents the system from batch-
    higher throughput rates than FCFS, and mean response                ing requests, but reduces the possibility of inconsistent
    times tend to be lower for moderate loads. One significant           data in the event of a system crash.
    drawback is that higher variances occur on response times       XOR (exclusive-or) operation—Operation on two bits that
    because of the discrimination against the outermost and            returns 1 if the two bits are not the same, 0 otherwise.
    innermost tracks; in the extreme, starvation of requests           RAID levels 3-5 use the XOR operation to generate par-
    far from the read-write heads could occur.                         ity bits.




Exercises
12.1 What are the essential goals of disk scheduling? Why is        12.4 Disk scheduling disciplines that are not fair generally
each important?                                                     have a larger variance of response times than FCFS. Why is
                                                                    this true?
12.2 Suppose that on a particular model of disk drive, aver-
                                                                    12.5 Under light loading conditions, virtually all the disk
age seek times approximately equal average latency times.
                                                                    scheduling disciplines discussed in this chapter degenerate to
How might this affect a designer's choice of disk scheduling
                                                                    which scheme? Why?
strategies?
                                                                    12.6 One criterion that influences the desirability of imple-
12.3 What makes a given disk scheduling discipline fair? Just       menting disk scheduling is the disk scheduling mechanism's
how important is fairness compared to other goals of disk           runtime overhead. What factors contribute to this overhead?
scheduling disciplines?                                             Suppose t is the average seek time on a system with FCFS disk

<!-- pág. 630 -->

                                                                                                                 Exercises       575
scheduling. Suppose s is the approximate time it would take to        immediate servicing of a new request for the same cylinder as
schedule an average disk request if another form of disk sched-       the previous request?
uling were in use. Assume all other factors are favorable to          12.15 Why does SCAN have a lower variance of response
incorporating disk scheduling on this system. For each of the         times than SSTF?
following cases, comment on the potential effectiveness of
incorporating disk scheduling on the system.                          12.16 Compare the throughput of FSCAN with that of SCAN.
      a. 5 = 0.01t                                                    12.17 Compare the throughput of C-SCAN with that of SCAN.
      b. s = 0.1t                                                     12.18 How does a latency optimization scheme operate?
      c. s = t                                                        12.19 A disk storage bottleneck may not always be removed
                                                                      by adding more disk drives. Why?
      d. s = 10r
                                                                      12.20 How does the level of multiprogramming affect the need
12.7 Latency optimization usually has little effect on system         for disk scheduling?
performance except under extremely heavy loads. Why?
                                                                      12.21 Suppose controller saturation is indicated. Might disk
12.8 On interactive systems it is essential to ensure reason-         scheduling be useful? What other actions should be taken?
able response times to users. Reducing the variance of                12.22 Why is it desirable to assume uniform request distribu-
response times is still an important goal, but it is not sufficient   tions when considering disk scheduling disciplines? In what
to prevent an occasional user from suffering indefinite post-         types of systems might you expect to observe relatively uni-
ponement. What additional mechanism would you                         form request distributions? Give several examples of systems
incorporate into a disk scheduling discipline on an interactive       that tend to have nonuniform request distributions.
system to help ensure reasonable response times and to avoid
the possibility of indefinite postponement?                           12.23 Would disk scheduling be useful for a single-user, dedi-
                                                                      cated disk in a sequential file processing application? Why?
12.9 Argue why some people refuse to consider FCFS to be a
disk scheduling discipline. Is there a scheme for servicing disk      12.24 The VSCAN scheduling strategy combines SSTF and
requests that we would be even less inclined to call disk sched-      SCAN according to a variable R.91 VSCAN determines the
uling than FCFS?                                                      next request to service using SSTF, but each request to a cylin-
                                                                      der that requires the read/write head to change direction is
12.10 In what sense is LOOK fairer than SSTF? In what sense           weighted by a factor R. The "distances" to requests in the
is C-LOOK fairer than LOOK?                                           opposite direction are computed as follows. If C is the number
                                                                      of cylinders on the disk and S is the number of cylinders
12.11 Give a statistical argument for why FCFS offers a small
                                                                      between the current location of the head and the next request,
variance of response times.                                           then VSCAN uses the distance, D = S + R x C. Thus,
12.12 Argue why SSTF tends to favor requests to midrange              VSCAN uses R to add an extra cost to the requests in the
tracks at the expense of the requests to the innermost and out-       unpreferred direction.
ermost tracks.                                                        12.25 If R = 0, to which disk scheduling policy does VSCAN
12.13 Chapter 7, Deadlock and Indefinite Postponement, sug-           degenerate?
gests a scheme for avoiding indefinite postponement. Suggest          12.26 If R = 1, to which disk scheduling policy does VSCAN
an appropriate modification to the SSTF scheme to create a            degenerate?
"nonstarving SSTF." Compare this new version with regular
SSTF with regard to throughput, mean response times, and              12.27 Discuss the benefit of choosing a value, R, somewhere
variance of response times.                                           between 0 and 1.

12.14 It is possible that while a disk request for a particular       12.28 In what circumstances might disk scheduling actually
cylinder is being serviced, another request for that cylinder will    result in poorer performance than FCFS?
arrive. Some disk scheduling disciplines would service this new
                                                                      12.29 Compare the essential goals of disk scheduling with
request immediately after processing the current request.
                                                                      those of processor scheduling. What are the similarities? What
Other disciplines preclude the servicing of the new request
                                                                      are the differences?
until the return sweep of the disk arm. What dangerous situa-
tion might occur in a disk scheduling discipline that allowed         12.30 What factors contribute to the need for seeking?

<!-- pág. 631 -->

576 Disk Performance Optimization

12.31 A sequential file "properly" stored on an empty disk can       12.35 The SCAN strategy often exhibits significantly higher
be retrieved with minimal seeking. But disks tend to become          throughput than the C-SCAN algorithm. However, system
heavily fragmented as files are added and deleted. Thus, suc-        designers sometimes choose C-SCAN over SCAN. Why might
cessive references to "adjacent" records in a disk file can result   this decision be justified?
in substantial seeking throughout the disk. Discuss the notion
                                                                     12.36 In Section 12.10.6, we said that a RAID system can
of file reorganization as a scheme for minimizing seeks. Under
                                                                     reduce the number of I/O operations when calculating parity
what circumstances should a file be reorganized? Should every
                                                                     by using the formula Ap' = (Ad XOR Ad') XOR Ap. Prove
file on the disk be reorganized or should this operation be lim-
                                                                     that this relation holds for all strips Ad,, Ad' and Ap.
ited to certain files only?
                                                                     12.37 For each of the following applications, indicate whether
12.32 A designer has proposed the use of multiple disk arms to
                                                                     the system should use RAID level 0, RAID level 1, or RAID
greatly improve the response times of a disk subsystem. Dis-
                                                                     level 5 and explain why.
cuss the advantages and disadvantages of such a scheme.
                                                                     12.38 Storing account transactions for a financial institution
12.33 We mentioned that the LOOK algorithm is like the algo-
rithm followed by elevators in buildings. In what ways is this       12.39 Storing high-resolution telescope images (that have
an appropriate analogy?                                              been transferred from a tape drive) before processing on a
                                                                     supercomputer
12.34 Suggest other techniques besides disk scheduling and
file reorganization for minimizing seeks.                            12.40 Running a personal Web server



Suggested Projects
12.41 Research disk scheduling in Linux. What scheduling             12.42 Prepare a research paper discussing the techniques that
strategies does Linux use? How are these strategies imple-           hard disk manufacturers employ to improve performance. See
mented? For an introduction to Linux disk scheduling, see            the links in the Web Resources section.
Section 20.8.3, Block Device I/O.                                    12.43 Prepare a report briefly describing five RAID levels
                                                                     other than the 6 covered in detail in this chapter.


Suggested Simulations
12.44 Develop monitors (see Chapter 6, Concurrent Program-           number generation to simulate the arrival time of each request
ming) to implement each of the following disk scheduling             as well as the actual cylinder for each request.
disciplines.                                                         12.46 The availability of moving-head disk storage has con-
      a. FCFS                                                        tributed greatly to the success of modern computing systems.
                                                                     Disks offer relatively fast and direct access to enormous
      b. SSTF                                                        amounts of information. Industry forecasters see a solid future
      c. SCAN                                                        for disk-based secondary storage systems, and researchers con-
                                                                     tinue developing new and improved disk scheduling disci-
      d. N-Step SCAN                                                 plines. Propose several new disk scheduling schemes and
                                                                     compare them with those presented in this chapter.
      e. C-SCAN
                                                                            Develop a program that simulates a disk that contains
12.45 In this chapter, we have investigated several cylinder-        two platters (i.e., four surfaces), four read/write heads, 25 cyl-
oriented disk scheduling strategies including FCFS, SSTF,            inders and 20 sectors per track. This disk should store the cur-
SCAN, TV-Step SCAN, and C-SCAN, F-SCAN, LOOK and C-                  rent position of the read/write head and provide functions such
LOOK. Write a simulation program to compare the perfor-              as read, write and seek. These functions should return the
mance of these scheduling methods under light, medium, and           number of milliseconds required to service each request
heavy loads. Define a light load as one in which there is usually    (track-to-track seek times of 2 ms, average seek times of 10 ms
either 0 or 1 requests waiting for the entire disk. Define a         and average latencies of 5 ms are reasonable). Then create a
medium load as one in which each cylinder has either 0 or 1          simulation program that generates a uniform distribution of
request waiting. Define a heavy load as one in which many cyl-       requests specifying a location by platter, cylinder and sector
inders are likely to have many requests pending. Use random          and a size by the number of requested sectors. These requests

<!-- pág. 632 -->

                                                                                                                Recommended Reading 577
should be sent to your disk scheduler, which then orders them           12.47 Extend the simulation in the previous exercise to incor-
and sends them to the disk for service by calling its read, write       porate rotational latency. For each strategy, did performance
and seek functions. Use the values returned by the disk to              increase or decrease as a result?
determine each scheduling algorithm's throughput, response
time and variance of response times.


Recommended Reading
Because disks are a bottleneck in most systems, disk perfor-            RAID in their seminal paper;100 subsequent research has fur-
mance optimization continues to be an active area of research           ther explored the trade-offs between various RAID levels.101-102
and analysis in the literature. Denning discussed how disk              As the gap between main memory and hard disk speeds grows
scheduling algorithms can improve performance.92 As hard                at an increasing pace, microelectromechanical storage (MEMS)
disks became the dominant form of secondary storage, research           devices, which access a rectangular media using chips containing
into improving their performance continued.93, 94, 95, 96, 97, 98, 99   thousands of read/write heads, show promise as a technology to
Researchers regularly perform comparative analyses of disk              replace the hard disk as high-capacity, low-cost storage. 103104
scheduling algorithms, often using sophisticated simulations of         The bibliography for this chapter is located on our Web site at
hard disk activity.36-39 Patterson et al. introduced the notion of      www.deitel.com/books/os3e/Bibliography.pdf.


Works Cited
 i.   Kozierok, C, "Life Without Hard Disk Drives," PCGuide, April      13. Kozierok, C, "Hard Disk Tracks, Cylinders and Sectors," modi-
      17,2001, <www.pcguide.com/ref/hdd/histWithout-c.html>.                fied April   17,  2001,    <www.pcguide.com/ref/hdd/geom/
 2. Khurshudov, A., The Essential Guide to Computer Data Storage,           tracks.htm>.
    Upper Saddle River, NJ: Prentice Hall PTR., 2001, p. 6.             14. "DiamondMax Plus 9," Maxtor Corporation, May 14, 2003,
                                                                            <www.maxtor.com/en/documentation/data__sheets/
 3. "RAMAC," Whatis.com, April 30,            2001,    <searchstor-
                                                                            di amondmax_plus_9_data_sheet.pdf>.
    age.techtarget.com/sDefinition/
      0,,sid5_gci548619,00.html>.                                       15. "WD Caviar Hard Drive 250GB 7200 RPM," October 28, 2003,
                                                                            <www.westerndigital.com/en/products/Prod-
 4. Khurshudov, A., The Essential Guide to Computer Data Storage,
                                                                            u c t s . a s p ? D r i veID=41>.
    Upper Saddle River, NJ: Prentice Hall PTR, 2001, p. 90.
                                                                        16. "MK8025GAS," Toshiba America, Inc., October 28, 2003,
 5. "Cost of Hard Drive Space," September 20, 2002, <www.lit-               <sdd.toshiba.com/main.aspx?Path=/
    tletechshop.com/nsl625/winchest.html>.                                  818200000007000000010000659800001516/
 6. Patterson, D.; G. Gibson; and R. Katz, "A Case for Redundant            81820000011d000000010000659c000003fd/
    Arrays of Inexpensive Disks," Proceedings of the ACM SIG-               8182000001c8000000010000659c00000599/
    MOD, June 1998, p. 109.                                                 8182000001e5000000010000659c000005cb/
 7. Gotlieb, C, and G. MacEwen, "Performance of Movable-Head                8182000006db000000010000659c00001559>.
    Disk Storage Devices," Journal of the ACM, Vol. 20, No. 4, Octo-    17. "WD Raptor Enterprise Serial ATA Hard Drive 36.7 GB 10,000
    ber 1973, pp. 604-623.                                                  RPM," October 28, 2003, <www.westerndigital.com/en/prod-
                                                                            ucts/WD360CD.asp>.
 8. Smith, A., "On the Effectiveness of Buffered and Multiple Arm
    Disks," Proceedings of the Fifth Symposium on Computer Archi-       18. "Cheetah 15K.3," Seagate Technology, March 27, 2003,
    tecture, 1978, pp. 109-112.                                             <www.Seagate.com/docs/pdf/datasheet/disc/
                                                                            ds_cheetahl5k.3.pdf>.
 9. Pechura, M., and J. Schoeffler, "Estimated File Access Time of
    Floppy Disks," Communications of the ACM, Vol. 26, No. 10,          19. Wilhelm, N., "An Anomaly in Disk Scheduling: A Comparison of
    October 1983, pp. 754-763.                                              FCFS and SSTF Seek Scheduling Using an Empirical Model for
                                                                            Disk Accesses," Communications of the ACM, Vol. 19, No. 1, Jan-
10. Kozierok, C, "Spindle Speed," PCGuide, April 17, 2001,                  uary 1976, pp. 13-17.
    <www.pcguide.com/ref/hdd/op/spinSpeed-c.html>.
                                                                        20. Wong, C, "Minimizing Expected Head Movement in One-
11. Walters, S., "Estimating Magnetic Disc Seeks," Computer Jour-           Dimensional and Two-Dimensional Mass Storage Systems,"
    nal, Vol. 18, No. 1,1973, pp. 412-416.                                  ACM Computing Survey's, Vol. 12, No. 2,1980, pp. 167-178.
12. Kollias, J., "An Estimate of Seek Time for Batched Searching of     21. Frank, H, "Analysis and Optimization of Disk Storage Devices
    Random or Indexed Sequential Structured Files," Computer                for Time-Sharing Systems," Journal of the ACM, Vol. 16, No. 4,
    Journal,Yol 21, No. 2,1978, pp. 21-26.                                  October 1969, pp. 602-620.

<!-- pág. 633 -->

578 Disk Performance Optimization

22. Teorey, T., "Properties of Disk Scheduling Policies in Multipro-     39- Thomasian, A., and C. Liu, "Special Issue on the PAPA 2002
    grammed Computer Systems," Proceedings of AFIPS FJCC, Vol.               Workshop: Disk Scheduling Policies with Look-Ahead," ACM
    41,1972, pp. 1-11.                                                       SIGMETRICS Performance Evaluation Review, Vol. 30, No. 1.
23. Wilhelm, N, "An Anomaly in Disk Scheduling: A Comparison of              September 2002, p. 33.
    FCFS and SSTF Seek Scheduling Using an Empirical Model for           40. Thomasian, A., and C. Liu, "Special Issue on the PAPA 2002
    Disk Access," Communications of the ACM, Vol. 19, No. 1, Janu-           Workshop: Disk Scheduling Policies with Look-Ahead," ACM
    ary 1976, pp. 13-17.                                                     SIGMETRICS Performance Evaluation Review, Vol. 30, No. 2.
                                                                             September 2002, p. 33.
24. Hofri, M., "Disk Scheduling: FCFS vs. SSTF Revisited," Commu-
    nications of the ACM, Vol. 23, No. 11, November 1980, pp. 645-       4 1 . Kozierok, C, "Logical Geometry," PCGuide, A p r i l 17, 2001.
    653.                                                                       <www.pcguide.com/refhdd/perf/perf/extp/pcCaching-
                                                                               c.html>.
25. Denning, P., "Effects of Scheduling on File Memory Operations,"
    Proceedings of AFIPS, SJCC, Vol. 30,1967, pp. 9-21.                  42. Khurshudov, A., The Essential Guide to Computer Data Storage
                                                                             (Upper Saddle River, NJ: Prentice Hall PTR..2001), pp. 106-107.
26. Teorey, T, "Properties of Disk Scheduling Policies in Multipro-
                                                                         43. " D e l l - Learn M o r e - H a r d Drives," 2003, <www.dell.com/us
    grammed Computer Systems," Proceedings of AFIPS FJCC, Vol.
                                                                             en/dhs/learnmore/
    41,1972, pp. 1-11.
                                                                             learnmore_hard_drives_desktop_popup_dimen.htm>.
27. Wilhelm, N., "An Anomaly in Disk Scheduling: A Comparison of
                                                                         44. Chaney, R., and B. Johnson, "Maximizing Hard-Disk Perfor-
    FCFS and SSTF Seek Scheduling Using an Empirical Model for
                                                                             mance: How Cache Memory Can Dramatically Affect Transfer
    Disk Access," Communications of the ACM, Vol. 19, No. 1, Janu-
                                                                             Rate," Byte, May 1984, pp. 307-334.
    ary 1976, pp. 13-17.
                                                                         45. Thomasian, A., and C. Liu, "Special Issue on the PAPA 2002
28. Hofri, M., "Disk Scheduling: FCFS vs. SSTF Revisited," Commu-
                                                                             Workshop: Disk Scheduling Policies with Look-Ahead," ACM
    nications of the ACM, Vol. 23, No. 11, November 1980, pp. 645-
                                                                             SIGMETRICS Performance Evaluation Review, Vol. 30, No. 2.
    653.
                                                                             September 2002, p. 38.
29. Denning, P., "Effects of Scheduling on File Memory Operations,"      46. Wilhelm, N, "An Anomaly in Disk Scheduling: A Comparison of
    Proceedings ofAFIPS, SJCC,Vol. 30,1967, pp. 9-21.                        FCFS and SSTF Seek Scheduling Using an Empirical Model for
30. Teorey, T, "Properties of Disk Scheduling Policies in Multipro-          Disk Accesses," Communications of the ACM, Vol. 19, No. 1, Jan-
    grammed Computer Systems," Proceedings ofAFIPS FJCC, Vol.                uary 1976, pp. 13-17.
    41,1972, pp. 1-11.                                                   47. Lynch, W., "Do Disk Arms Move?" Performance Evaluation
31. Gotlieb, C, and G. MacEwen, "Performance of Movable-Head                 Review, ACM Sigmetrics Newsletter, Vol. 1, December 1972, pp.
    Disk Storage Devices," Journal of the ACM, Vol. 20, No. 4, Octo-         3-16.
    ber 1973, pp. 604-623.                                               48. Kozierok, C, "Cache Write Policies and the D i r t y Bit," PCGuide.
32. Teorey, T, and T. Pinkerton, "A Comparative Analysis of Disk             April     17,    2001,  <www.pcguide.com/ref/mbsys/cache/
    Scheduling Policies," Communications of the ACM, Vol. 15, No. 3,         funcWrite-c.html>.
    March 1972, pp. 177-184.                                             49. Thomasian, A., and C. Liu, "Special Issue on the PAPA 2002
33. Thomasian, A., and C. Liu, "Special Issue on the PAPA 2002               Workshop: Disk Scheduling Policies with Look-Ahead," ACM
    Workshop: Disk Scheduling Policies with Lookahead," ACM                  SIGMETRICS Performance Evaluation Review, Vol. 30, No. 2.
    SIGMETRICS Performance Evaluation Review, Vol. 30, No. 2,                September 2002, p. 32.
    September 2002, pp. 36.                                              50. Kozierok, C, "Operating System and Controller Disk Caching."
34. Teorey, T, "Properties of Disk Scheduling Policies in Multipro-          PCGuide, A p r i l 17, 2001, < w w w . p c g u i d e . c o m / r e f h d d / p e r f /
    grammed Computer Systems," Proceedings of AFIPS FJCC, Vol.               perf/extp/pcCaching-c.html>.
    41,1972, pp. 1-11.                                                   51. Thomasian, A., and C. Liu, "Special Issue on the PAPA 2002
35. Teorey, T, and T. Pinkerton, "A Comparative Analysis of Disk             Workshop: Disk Scheduling Policies with Look-Ahead," ACM
    Scheduling Policies," Communications of the ACM, Vol. 15, No. 3,         SIGMETRICS Performance Evaluation Review, Vol. 30, No. 2.
    March 1972, pp. 177-184.                                                 September 2002, p. 31.
                                                                         52. "Disk Optimization Can Save Time and Resources in a Windows
36. Worthington, B.; G. Ganger; and Y. Patt, "Scheduling Algorithms
                                                                             NT/2000 Environment," Raxco Software, <www.raxco.dk/
    for Modern Disk Drives," Proceedings of the 1994 ACM SIG-
                                                                             raxco/perfectdisk2000/download/
    METRICS Conference, May 1994, p. 243.
                                                                               Opti mi z a t i on_Can_Save_Time.pdf>.
37. "Hard Disk Specifications," viewed October 2,2003, <www.stor¬
                                                                         53. King, R., "Disk Arm Movement in Anticipation of Future
    age review.com/guide2000/ref/hdd/perf/perf/spec/
                                                                             Requests," ACM Transactions in Computer Systems, Vol. 8, No. 3.
    index, html >.
                                                                             August 1990, p. 215.
38. Stone, H., and S. Fuller, "On the Near Optimality of the Shortest-   54. King, R., "Disk Arm Movement in Anticipation of Future
    Latency-Time-First Drum Scheduling Discipline," Communica-               Requests," ACM Transactions in Computer Systems, Vol. 8, No. 3,
    tions oftheACM,\ol. 16, No. 6, June 1973, pp. 352-353.                   August 1990, p. 214.

<!-- pág. 634 -->

                                                                                                                     Works Cited 579
55- King, R., "Disk Arm Movement in Anticipation of Future               75- Patterson, D.; G. Gibson; and R. Katz, "A Case for Redundant
    Requests," ACM Transactions in Computer Systems, Vol. 8, No. 3,          Arrays of Inexpensive Disks," Proceedings of the ACM SIG-
    August 1990, pp. 220,226                                                 M O A June 1988, p. 113.
56. "RAID           Overview,"            <www.amsstorage.com/html/      76. Patterson, D.; G. Gibson; and R. Katz, "A Case for Redundant
    raid_overview.html>.                                                     Arrays of Inexpensive Disks," Proceedings of the ACM S1G-
57. Patterson, D; G. Gibson; and R. Katz, "A Case for Redundant              MOD, June 1988, p. 113.
    Arrays of Inexpensive Disks," Proceedings of the ACM S1G-            77. "RAID            Overview,"        <www.amsstorage.com/html/
    MOD, June 1988, p. 109.                                                  rand_overview.html    >.
58. Patterson, D.; G. Gibson; and R. Katz, "A Case for Redundant         78. "RAID 5: Independent Data Disks with Distributed Parity
    Arrays of Inexpensive Disks," Proceedings of the ACM S1G-                Blocks," <www.rand.com/04_01_05.html>.
    MOD, June 1988, pp. 109-110.
                                                                         79. "RAID Level 4," PCGuide.com, <www.pcguide.com/ref/hdd/
59. Chen, P.; E. Lee; G. Gibson; R. Katz; and D. Patterson, "RAID:           perf/rand/1evels/singleLevel4-c.html>.
    High-Performance, Reliable Secondary Storage," ACM Comput-
                                                                         80. Patterson, D; G Gibson; and R. Katz, "A Case for Redundant
    ing Surveys, Vol. 26, No. 2, June 1994, pp. 151-152.
                                                                             Arrays of Inexpensive Disks," Proceedings of the ACM SIG-
60. Chen, P.; E. Lee; G. Gibson; R. Katz; and D. Patterson, "RAID:           MOD, June 1988, p. 114.
    High-Performance, Reliable Secondary Storage," ACM Comput-
                                                                         81. Patterson, D.; G Gibson; and R. Katz, "A Case for Redundant
    ing Surveys, Vol. 26, No. 2, June 1994, p. 147.
                                                                             Arrays of Inexpensive Disks," Proceedings of the ACM SIG-
61. Chen, P.; E. Lee; G. Gibson; R. Katz; and D. Patterson, "RAID:           MOD, June 1988, p. 114.
    High-Performance, Reliable Secondary Storage," ACM Comput-
                                                                         82. Savage, S., and J. Wilkes, " A F R A I D - A Frequently Redundant
    ing Surveys, Vol. 26, No. 2, June 1994, p. 152.
                                                                             Array of Independent Disks," Proceedings of the 1996 Usenix
fc. "RAID 0: Striped Disk Array without              Fault Tolerance,"       Conference, January 1996, p. 27.
     <www.raid.com/04_01_00.html>.
                                                                         83. Chen, P.; E. Lee; G. Gibson; R. Katz; and D. Patterson, "RAID:
63. "RAID 0: Striped Disk Array without Fault Tolerance,"                    High-Performance, Reliable Secondary Storage," ACM Comput-
    <www.raid.com/04_01_00.html>.                                            ing Surveys, Vol. 26, No. 2, June 1994, pp. 166-168.
64. Chen, P.; E. Lee; G. Gibson; R. Katz; and D. Patterson, "RAID:
                                                                         84. Savage, S., and J. Wilkes, " A F R A I D - A Frequently Redundant
    High-Performance, Reliable Secondary Storage," ACM Comput-
                                                                             Array of Independent Disks," Proceedings of the 1996 Usenix
    ing Surveys,Vo\. 26, No. 2, June 1994, p. 152.
                                                                             Conference, January 1996, pp. 27,37.
65. Patterson, D.; G. Gibson; and R. Katz, "A Case for Redundant
                                                                         85. "RAID 5: Independent Data Disks with Distributed Parity
    Arrays of Inexpensive Disks," Proceedings of the ACM SIG-
                                                                             Blocks," <www.raid.com/04_01_05.html>.
    MOD, June 1988, p. 112.
                                                                         86. "RAID Level 5," PCGuide.com, <www.pcguide.com/ref/hdd/
66. "RAID        Overview,"        <www.masstorage.com.com/html/
                                                                             perf/raid/1evels/singleLevel5-c.html>.
    raid_overview.html>.
                                                                         87. "Multiple  (Nested)   RAID       Levels,"   PCGuide.com,
67. "RAID 1: Mirroring           and   Duplexing,"    <www.raid.com/
                                                                             <www.pcguide.com/ref/hdd/perf/raid/mult.htm>.
    04_01_01.html>.
68. "RAID     2:    Hamming        Code     ECC,"     <www.raid.com/     88. "RAID 6: Independent Data Disks with Two Independent Parity
    04_01_02.html>.                                                          Schemes," <www.raid.com/04_01_06.html>.

69. Patterson, D; G. Gibson; and R. Katz, "A Case for Redundant          89. "Multiple  (Nested)   RAID       Levels,"   PCGuide.com,
    Arrays of Inexpensive Disks," Proceedings of the ACM SIG-                <www.pcguide.com/ref/hdd/perf/raid/mult.htm>.
    MOD, June 1988, p. 112.                                              90. "RAID Level 7," PCGuide.com, <www.pcguide.com/ref/hdd/
70. Patterson, D.; G. Gibson; and R. Katz, "A Case for Redundant             perf/raid/1evels/singleLevel7-c.html>.
    Arrays of Inexpensive Disks," Proceedings of the ACM SIGMOD          91. Geist, R., and S. Daniel, "A Continuum of Disk Scheduling Algo-
    June 1988, p. 112.                                                       rithms," ACM Transactions in Computer Systems, Vol. 5, February
71. "RAID        Overview,"        <www.amsstorage.com.com/html/             1,1987, p. 78.
    raid_overview.html>.                                                 92. Denning, P., "Effects of Scheduling on File Memory Operations,"
72. Patterson, D.; G Gibson; and R. Katz, "A Case for Redundant              Proceedings ofAFIPS, SJCC, Vol. 30,1967, pp. 9-21.
    Arrays of Inexpensive Disks," Proceedings of the ACM SIG-            93. Teorey, T., "Properties of Disk Scheduling Policies in Multipro-
    MOD, June 1988, p. 112.                                                  grammed Computer Systems," Proceedings of AFIPS FJCC, Vol.
73. Chen, P.; E. Lee; G. Gibson; R. Katz; and D Patterson, "RAID:            41,1972, pp. 1-11.
    High-Performance, Reliable Secondary Storage," ACM Comput-           94. Wilhelm, N, "An Anomaly in Disk Scheduling: A Comparison of
    ing Surveys, Vol. 26, No. 2, June 1994, p. 156.                          FCFS and SSTF Seek Scheduling Using an Empirical Model for
74. "RAID 3: Parallel Transfer with Parity," <www.raid.com/                  Disk Access," Communications of the ACM, Vol. 19, No. 1, Janu-
    04_01_03.html>.                                                          ary 1976, pp. 13-17.

<!-- pág. 635 -->

580 Disk Performance Optimization
95- Hofri, M., "Disk Scheduling: FCFS vs. SSTF Revisited," Commu-     ioo. Patterson, D.; G. Gibson; and R. Katz, "A Case for Redundant
    nications of the ACM, Vol. 23, No. 11, November 1980, pp. 645-         Arrays of Inexpensive Disks," Proceedings of the ACM SIG-
    653.                                                                   MOD, June 1988, p. 109.
96. Geist, R., and S. Daniel, "A Continuum of Disk Scheduling Algo-   IOI. Chen, P.; E. Lee; G. Gibson; R. Katz; and D. Patterson, "RAID
    rithms," ACM Transactions in Computer Systems, Vol. 5, February        High-Performance, Reliable Secondary Storage," ACM Comput-
    1,1987, p. 78.                                                         ing Surveys, Vol. 26, No. 2, June 1994, pp. 151-152.
                                                                      102. Savage, S., and J. Wilkes, "AFRAID—A Frequently Redundant
97. King, R., "Disk Arm Movement in Anticipation of Future
                                                                           Array of Independent Disks," Proceedings of the 1996 Usenix
    Requests," ACM Transactions in Computer Systems, Vol. 8, No. 3,
                                                                           Conference, January 1996, pp. 27,37.
    August 1990, p. 215.
                                                                      103. Griffin, J., L.; S. W. Schlosser; G R. Ganger; and D. F. Nagle.
98. Thomasian, A., and C. Liu, "Special Issue on the PAPA 2002             "Operating System Management of MEMS-based Storage
    Workshop: Disk Scheduling Policies with Look-Ahead," ACM               Devices," Proceedings of the Fourth Symposium on Operating
    SIGMETRICS Performance Evaluation Review, Vol. 30, No. 2,              Systems Design and Implementation (OSDI), 2000, pp. 227-242.
    September 2002, p. 33.
                                                                      104. Uysal, M.; A. Merchant; and G A. Alvarez, "Using MEMS-based
99. Patterson, D.; G. Gibson; and R. Katz, "A Case for Redundant           Storage in Disk Arrays," Proceedings of the Second USENIX
    Arrays of Inexpensive Disks," Proceedings of the ACM SIG-              Conference on File and Storage Technologies, March, 2003.
    MOD, June 1988, p. 109.

<!-- pág. 636 -->

'Tis in my memory lock'd, And you yourself shall keep the key of it.
      — William Shakespeare—

E pluribus unus. (One composed of many.)
      —Virgil—


I can only assume that a "Do Not File" document is filled in a "Do Not File" file.
      —Senator Frank Church, Senate Intelligence Subcommittee Hearing, 1975—


A form of government that is not the result of a long sequence of shared experiences,
efforts, and endeavors can never take root.
      —Napoleon Bonaparte—

