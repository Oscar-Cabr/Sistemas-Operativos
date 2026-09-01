# Chapter 11 - Virtual Memory Management

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 532–576 (numeración del PDF)

<!-- pág. 532 -->

Chapter 11


Virtual Memory
         Management
 Objectives
 After reading this chapter, you should understand:
 • the benefits and drawbacks of demand and anticipatory paging.
 • the challenges of page replacement.
 • several popular page-replacement strategies and how they compare to opti-
  mal page replacement.
 • the impact of page size on virtual memory performance.
 • program behavior under paging.

<!-- pág. 533 -->

                                Chapter Outline

                     11.1                                  11.6.6Not-Used-Recently(NUR)Page
                Introduction                                           Replacement
                                                           11.6.7 Modifications to FIFO: Second-
                                                             Chance and Clock Replacement
                      11.2                                     11.6.8 Far Page Replacement
                   Locality

                      11.3                                                 11.7
                                                                 Working Set Model
              Demand       Paging
        Operating Systems Thinking:
       Computer Theory in Operating Systems                               11.8
      Operating Systems Thinking: Space-                   Page-Fault-Frequency   (PFF)
                 Time Trade-offs                                 Page Replacement


                      11.4                                                 11.9
            Anticipatory      Paging                                 Page Release

                      11.5                                               11.10
             Page Replacement                                          Page Size

                     11.6                                                 11.11
       Page-Replacement          Strategies              Program Behavior under Paging
         11.6.1 Random Page Replacement
       11.6.2 First-In-First-Out (FIFO) Page                              11.12
                    Replacement                                 Global vs. Local Page
              11.6.3 FIFO Anomaly                                   Replacement
      11.6.4 Least-Recently-Used (LRU) Page
                    Replacement                                        11.13
      11.6.5Least-Frequently-Used(LFU)Page                    Case Study: Linux Page
                    Replacement                                    Replacement

         Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited




478

<!-- pág. 534 -->

                                                                                               11.1 Introduction   479

11.1 Introduction
Chapter 9 discussed fetch, placement and replacement memory management strat-
egies for real memory systems. Chapter 10 discussed virtual memory organization,
focusing on pure paging systems, pure segmentation systems and hybridized seg-
mentation/paging systems. In this chapter we discuss memory management in vir-
tual memory systems.
      Virtual memory fetch strategies determine when a page or segment should be
moved from secondary storage to main memory. Demand fetch strategies wait for a
process to reference a page or segment before loading it into main memory. Antici-
patory fetch strategies use heuristics to predict which pages or segments a process
will soon reference—if the likelihood of reference is high and if space is available,
then the system brings the page or segment into main memory before the process
explicitly references it, thus improving performance when the reference occurs.
      Paging systems—either pure paging or segmentation/paging systems—that
use only one page size trivialize the placement decision because an incoming page
may be placed in any available page frame. Segmentation systems require place-
ment strategies similar to those used in variable-partition multiprogramming (see
Section 9.9, Variable-Partition Multiprogramming).
      Replacement strategies determine which page or segment to replace to pro-
vide space for an incoming page or segment. In this chapter, we concentrate on
page-replacement strategies that, when properly implemented, help optimize per-
formance in paging systems. The chapter includes a discussion of Denning's Work-
ing Set Model of program behavior, which provides a framework for observing,
analyzing and improving program execution in paging systems.1

Self Review
1. Explain the difference between demand fetch strategies and anticipatory fetch strategies
   in virtual memory systems. Which one requires more overhead?
2. Why are placement strategies trivial in paging systems that use only one page size?
Ans: 1) Demand fetch strategies load pages or segments into main memory only when a
process explicitly references them. Anticipatory fetch strategies attempt to predict which
pages or segments a process will need and load them ahead of time. Anticipatory fetch strat-
egies require more overhead because the system must spend time determining the likelihood
that a page or segment will be referenced; as we will see, this overhead can often be small.
2) Because any incoming page can be placed into any available page frame.


11.2 Locality
Central to most memory management strategies is the concept of locality—that a
process tends to reference memory in highly localized patterns.2'3 Locality mani-
fests itself in both time and space. Temporal locality is locality over time. For exam-
ple, if the weather is sunny in a certain town at 3 p.m., then there is a good chance
 (but certainly no guarantee) that the weather in that town was sunny at 2:30 p.m.

<!-- pág. 535 -->

480 Virtual Memory Management
                          and will be sunny at 3:30 p.m. Spatial locality means that nearby items tend to be
                          similar. Again, considering the weather, if it is sunny in one town, then it is likely,
                          but not guaranteed, to be sunny in nearby towns.
                                Locality is also observed in operating systems environments, particularly in
                          the area of memory management. It is an empirical (i.e., observed) property rather
                          than a theoretical one. It is never guaranteed but is often highly likely. In paging
                          systems, for example, we observe that processes tend to favor certain subsets of
                          their pages, and that these pages tend to be near one another in a process's virtual
                          address space. This behavior does not preclude the possibility that a process may
                          make a reference to a new page in a different area of its virtual memory.
                                Actually, locality is quite reasonable in computer systems, when one considers
                          the way programs are written and data is organized. Loops, functions, procedures
                          and variables used for counting and totalling all involve temporal locality. In these
                          cases, recently referenced memory locations are likely to be referenced again in the
                          near future. Array traversals, sequential code execution and the tendency of pro-
                          grammers (or compilers) to place related variable definitions near one another all
                          involve spatial locality—they all tend to generate clustered memory references.

                         Self Review
                          1. Does locality favor anticipatory paging or demand paging? Explain.
                          2. Explain how looping through an array exhibits both spatial and temporal locality.
                         Ans: 1) Locality favors anticipatory paging because it indicates that the operating system
                         should be able to predict with reasonable probability the pages that a process will use.
                         2) Looping through an array exhibits spatial locality because the elements of an array are
                         contiguous in virtual memory. It exhibits temporal locality because the elements are gener-
                         ally much smaller than a page. Therefore, references to two consecutive elements usually
                         result in the same page being referenced twice within a short period of time.


                          11.3 Demand Paging
                          The simplest fetch policy implemented in virtual memory systems is demand pag-
                          ing.4 Under this policy, when a process first executes, the system loads into main
                          memory the page that contains its first instruction. Thereafter, the system loads a
                          page from secondary storage to main memory only when the process explicitly ref-
                          erences the page. There are several reasons for the appeal of this strategy. Comput-
                          ability results, specifically the Halting Problem, tell us that, in the general case, it is
                          impossible to predict the path of execution a program will take (see the Operating
                          Systems Thinking feature, Computer Theory in Operating Systems).5-6 Therefore,
                          any attempt to preload pages in anticipation of their use might result in the wrong
                          pages being loaded. The overhead incurred by preloading the wrong pages can
                          impede the performance of the entire system.
                                Demand paging guarantees that the system brings into main memory only
                          those pages that processes actually need. This potentially allows more processes to

<!-- pág. 536 -->

                                                                                          11.3    Demand    Paging    481

 occupy main memory—the space is not "wasted" by pages that may not be refer-
enced for some time (or ever).
      Demand paging is not without its problems. A process in a demand-paged sys-
tem must accumulate pages one at a time. As it references each new page, the pro-
cess must wait while the system transfers that page to main memory. If the process
already has many pages in main memory, then this wait time can be particularly
costly, because a large portion of main memory is occupied by a process that cannot
execute. This factor often affects the value of a process's space-time product—a
measure of its execution time (i.e., how long it occupies memory) multiplied by the
amount of space in main memory the process occupies (see the Operating Systems
Thinking feature, Space-Time Trade-offs).7 The space-time product illustrates not
only how much time a process spends waiting, but how much main memory cannot
be used while it waits. Figure 11.1 illustrates the concept. The y-axis represents the
number of page frames allocated to a process and the x-axis represents "wall clock"
time. The space-time product corresponds to the area under the "curve" in the fig-
ure; the dotted lines indicate that a process has referenced pages that are not in
main memory and must be loaded from the backing store. The shaded region repre-




              Operating Systems Thinking
 Computer Theory in Operating Systems
 Computer science is rich in ele-       then we could for example, imple-       us understand the power of dif-
 gant theoretical fields. Computa-      ment perfect anticipatory               ferent classes of computing
 bility theory helps us determine       resource allocation, so that the        devices; as we discussed in
 what kinds of things computer          resources are ready (if at all possi-   Chapter 6, this helps us realize
 software, such as operating sys-       ble) when the process needs             that modern computer systems
 tems, can and cannot do. The           them, avoiding lengthy delays.          are far t o o complex to allow
 Halting Problem of computability       Once we know what computers             exhaustive testing of all possible
 theory tells us that in the general    can and cannot do, complexity           states of computer hardware and
 case, we cannot write a program        theory helps us determine               software. This last observation is
 to determine the execution path        whether those tasks can be per-         truly a point to ponder, especially
 of another program. This has           formed efficiently and to charac-       if you must build highly reliable
 many ramifications in operating        terize just how efficiently (or         systems.
 systems. If we could predict the       inefficiently) they can be per-
 execution path of a program,           formed. Automata theory helps

<!-- pág. 537 -->

482    Virtual Memory    Management
                                 sents the process's space-time product while it is performing productive work. The
                                 unshaded region represents its space-time product while it waits for pages to be
                                 loaded from secondary storage. [Note: The wait period, F, is much larger than indi-
                                 cated by the figure.] Thus, the unshaded region indicates the amount of time during
                                 which the process's memory allocation cannot be used. Reducing the space-time
                                 product of a process's page waits, in order to improve memory utilization, is an
                                 important goal of memory management strategies. As the average page-wait time
                                 increases, the benefit of demand paging decreases. 8



                                 Self Review
                                 1. Why is the space-time product of demand paging higher than that of anticipatory paging?
                                 2. How could demand paging (as compared to anticipatory paging) increase the degree of
                                    multiprogramming in a system? How could demand paging decrease the degree of multi-
                                    programming in a system?
                                A n s : 1) The reason is that the process has pages in memory that it is not using while it waits
                                for its pages to be painstakingly demand-paged in, one at a time. Anticipatory paging also has a
                                space-time product with associated waste. Pages brought into memory before they are refer-
                                enced occupy page frames that go unused, thus preventing other processes from using them. As




                    Operating Systems Thinking
      Space-Time Trade-offs
      Examples of the space-time trade-     operating system allocates more              in Chapter 12, that maintaining
      off are common in computing and       main memory to an executing                  redundant copies of data can
      other areas. When moving to a         program, for example, the pro-               result in improved system
      new apartment, if you have a          gram may run significantly faster.           throughput. We will see, however
      larger truck, you can complete the    W i t h less, more-expensive mem-            that increasing the amount of
      move in less time, but you will       ory, the operating system must               memory available to a process
      have to pay more to rent the          manage the memory more exten-                does not always increase the
      larger truck. When you study          sively, incurring more processing            speed at which it runs—we will
      searching and sorting algorithms      overhead. W i t h more abundant,             study Belady's Anomaly which
      in data structures and algorithms     cheaper memory, the operating                shows that in some circumstances,
      classes, you see how performance      system can manage the memory                 giving a process more memory
      can improve when more memory          less intensively, perhaps making             could actually degrade perfor-
      is available (e.g., hash tables).     cruder decisions while consuming             mance. Fortunately, this occurs
      These trade-offs are common in        less processor power. We will see            only in rare circumstances.
      operating systems as well. If the     in the discussion of RAID systems

<!-- pág. 538 -->

                                                                                             11.4 Anticipatory Paging 483




Figure 11.1 | Space-time product under demand paging.

we will see, anticipatory paging brings these pages into main memory in groups, which gener-
ally reduces the page-wait time compared to loading pages individually using demand paging.
2) Demand paging could increase the degree of multiprogramming because the system brings
into main memory only those pages that processes actually needed. Therefore, more processes
can fit into physical memory. However, processes require more execution time because they
need to retrieve pages from secondary storage more often (compared with being brought in as
a group with anticipatory paging). While the operating system is retrieving pages from second-
ary storage, the memory that the process takes up is wasted, and thus the degree of multipro-
gramming might decrease (over what is possible with anticipatory paging).


11.4       Anticipatory     Paging
A central theme in resource management is that a resource's relative value influ-
ences just how intensively the resource should be managed.9 As hardware costs
continue their dramatic decline, the relative value of machine time to people time is
reduced. Operating systems designers are constantly focused on reducing the
amount of time people must wait for results from computers.10
     As we demonstrated in the preceding section, one way to reduce wait times is
to avoid the delays in a demand-paged system. In anticipatory paging (also called

<!-- pág. 539 -->

484 Virtual Memory Management
                         prefetching and prepaging), the operating system tries to predict the pages a pro-
                         cess will need and to preload them when memory space is available. If the system is
                         able to make correct decisions about future page use, the process's total runtime
                         can be reduced.11-12
                               Important criteria that determine the success of a prepaging strategy include:
                                • prepaged allocation—the amount of main memory allocated to prepaging
                                • the number of pages that are preloaded at once
                                • the policy—the heuristic that determines which pages are preloaded (e.g.,
                                  those predicted by spatial locality or those predicted by temporal locality).13
                         Anticipatory paging strategies should be designed with care. A strategy that
                         requires significant resources (such as processor time, page frames and disk I/O), or
                         that inaccurately determines which pages a process will need, might result in worse
                         performance than in a demand paging system.
                                Anticipatory paging strategies often are combined with demand paging; the
                         system preloads a few of the process's pages when the process references a nonresi-
                         dent page. These strategies typically exploit spatial locality; i.e., a process referenc-
                         ing a nonresident page will likely reference contiguous pages in its virtual address
                         space in the near future. When a process generates a page fault, the system loads
                         the faulting page and several nearby nonresident pages that are contiguous in the
                         process's virtual address space.
                                Pages contiguous in a process's virtual address space, however, might not be
                         contiguous on secondary storage. Unlike main memory, secondary storage devices
                         (e.g., hard disks) do not provide uniform access times to data stored at different loca-
                         tions, so the time required to load multiple pages from secondary storage may be sig-
                         nificantly greater than that required to load a single page. In this case, processes could
                         suffer greater page-wait times due to anticipatory paging than in demand paging.
                                One solution is to group pages on secondary storage that are contiguous in a
                         process's virtual address space.14 As we discuss in Chapter 12, Disk Performance
                         Optimization, the difference between the page-wait times for loading several pages
                         that are contiguous on disk and for loading a single page is relatively small, so antic-
                         ipatory paging can be performed without significantly increasing the page-wait time
                         compared to demand paging. In Linux, for example, when a process references a
                         nonresident page containing its program instructions or data, the kernel attempts to
                         exploit spatial locality by loading from disk the nonresident page and a small num-
                         ber of pages that are contiguous in the process's address space. By default, the sys-
                         tem loads from disk four contiguous pages (16KB on the IA-32 architecture) if
                         main memory is smaller than 16MB, or eight contiguous pages (32KB on the IA-32
                         architecture) otherwise.15 This technique can yield good performance for processes
                         that exhibit spatial locality.

                         Self Review
                         1. In which scenarios is the Linux anticipatory paging strategy inappropriate?

<!-- pág. 540 -->

                                                                                                  11.5   Page Replacement 485
2. Why is anticipatory paging likely to yield better performance than demand paging? How
   might it yield poorer performance?
Ans: 1) If processes exhibit random page-reference behavior, Linux would likely load
pages that a process will not reference, leading to memory waste. If main memory is small
 (on the order of kilobytes), this could significantly reduce the amount of memory available to
 other processes, tending to increase the number of page faults the system experiences. 2) It
could yield better performance because it is more efficient to bring in several contiguous
pages in one I/O transfer than to do several I/O operations (as would be the case in demand
paging). Performance could be worse, though, if the process does not actually use the pages
 that were prepaged in.



11.5      Page       Replacement
In a virtual memory system with paging, all of the page frames might be occupied
when a process references a nonresident page. In this case, the system must not only
bring in a new memory page from auxiliary storage, but must first decide which
page in main memory should be replaced (i.e., removed or overwritten) to make
room for the incoming page. In this and the next several sections, we investigate
page-replacement strategies.
      Recall that a page fault occurs if a running process references a nonresident
page. In this case, the memory management system must locate the referenced page
in secondary storage, load it into main memory and update the appropriate page
table entry. Page-replacement strategies typically attempt to reduce the number of
page faults a process experiences as it runs from start to finish, hopefully reducing
the process's execution time.
      If the page chosen for replacement has not been modified since it was last
paged in from disk, then the new page can simply overwrite it. If the page has been
modified, it must first be written (or evicted) to secondary storage to preserve its
contents. A modified bit, or dirty bit, in the page table entry is set to 1 if the page
has been modified and 0 otherwise.
      Writing (or flushing) a modified page to disk, which requires a disk I/O opera-
tion, increases page-wait times if it is performed when a page is replaced. Some
operating systems, such as Linux and Windows XP, periodically flush dirty pages to
secondary storage to increase the likelihood that the operating system can perform
page replacement without first having to write a modified page to disk. Because this
periodic flushing can occur asynchronously with process execution, the system
incurs little overhead by doing so. If a process references a modified page before
the flush is completed, then it is recaptured, thus saving an expensive page-in oper-
ation from secondary storage.
      When we evaluate a page-replacement strategy, we often compare it to the so-
called optimal page replacement strategy (also called OPT or MIN), which states
that, to obtain optimum performance, replace the page that will not be referenced
again until furthest in the future.16, 17, 18, 19, 20 Thus, the strategy increases perfor-
mance by minimizing the number of page faults. This strategy can be demonstrated

<!-- pág. 541 -->

486 Virtual Memory Management

                          to be optimal, but it is not realizable, because we cannot, in general, accurately pre-
                          dict the behavior of processes. Instead, the strategy serves as a benchmark to which
                          we compare realizable strategies. A well-designed replacement strategy balances
                          the goals of minimal future page faults with the overhead incurred by attempting to
                          predict future page use.

                         Self Review
                          1. What other factor complicates replacement strategies on systems that use pure segmenta-
                             tion (as compared with systems that use pure paging)?
                          2. Is it possible to perform optimal page replacement for certain types of processes? If so,
                             give an example.
                         Ans: 1) Such systems must consider the size of the segment being replaced compared to the
                         size of the incoming segment. 2) Yes, a trivial example is a process with one data page that is
                         intensively referenced and whose data and instructions are referenced purely sequentially.



                         11.6 Page-Replacement Strategies
                          In the subsections that follow, we discuss several strategies that determine which
                          page to replace to accommodate an incoming page. Each strategy is characterized
                          by the heuristic it uses to select a page for replacement and the overhead it incurs.
                          Some replacement strategies are intuitively appealing but lead to poor performance
                          due to poor choice of heuristic. Other strategies predict future page usage well, but
                          their overhead can degrade performance. We also discuss how special-purpose
                          hardware can reduce the overhead incurred by page-replacement strategies.

                         11.6.1 Random Page Replacement
                         Random (RAND) page replacement is an easy-to-implement, low-overhead page-
                         replacement strategy. Under this strategy, each page in main memory has an equal
                         likelihood of being selected for replacement. One problem with RAND is that it
                         may accidentally select as the next page to replace the page that will be referenced
                         next (which is, of course, the worst page to replace). A benefit of RAND is that it
                         makes replacement decisions quickly and fairly. Since typically there are many page
                         frames from which to choose, there is only a small probability of replacing a page
                         likely to be referenced again almost immediately. Because of its hit-or-miss
                         approach, RAND is rarely used.

                         Self Review
                         1. How is RAND fair? Why is this type of fairness inappropriate for replacement strategies?
                         2. Could RAND ever operate exactly as OPT?
                         Ans: 1) RAND is fair in that all pages in memory are equally likely to be replaced. This is
                         inappropriate for replacement strategies, which, to reduce page faults, must try not to replace
                         pages that will be referenced soon. 2) Yes, it could accidentally make all the right page-

<!-- pág. 542 -->

                                                                                 11.6 Page-Replacement Strategies 487
replacement decisions, but it would do this with such miniscule probability that it would be
better to answer this question, "No."


11.6.2 First-In-First-Out (FIFO) Page Replacement
In the first-in-first-out (FIFO) page-replacement strategy, we replace the page that
has been in the system the longest. Figure 11.2 provides a simple example of the
FIFO strategy for a process which has been allocated three page frames. The left-
most column contains the process's page-reference pattern. Each row in the figure
shows the state of the FIFO queue after each new page arrives; pages enter the tail
of the queue on the left and exit the head on the right.
      Under FIFO page replacement, the system keeps track of the order in which
pages enter main memory. When a page must be replaced, the strategy chooses the
one that has been in main memory the longest. The intuitive appeal of this strategy
seems reasonable—namely, that this page has had its chance and it is time to give
another page a chance. Unfortunately, first-in-first-out can replace heavily used
pages. For example, on large timesharing systems it is common for many users to
share a copy of a text editor as they enter and correct programs. FIFO page replace-
ment on such a system might choose to replace a heavily used editor page. This
would be a poor choice, because the page would be recalled to main memory
almost immediately, resulting in an increased page-fault rate. Although FIFO can
be implemented with relatively low overhead using a queue, it is impractical for
most systems. But, as we will see in Section 11.6.7, Modifications to FIFO: Second-
Chance and Clock Page Replacement, FIFO forms the basis of various imple-
mented page-replacement schemes.




Figure 11.2 | First-in-first-ot (FIFO) page replacement.

<!-- pág. 543 -->

488   Virtual Memory Management

                           Self Review
                            1. Why does FIFO page replacement lead to poor performance for many processes?
                            2. How does FIFO page replacement compare to OPT for a process executing a loop that ref-
                               erences n pages when main memory can hold no more than n -1 of that process's pages?
                           Ans: 1) FIFO replaces pages according to their age, which, unlike locality, is not a good pre-
                           dictor of how pages will be used in the future. 2) Assume that the pages are numbered from
                           zero to n - 1 . In this case, when the process references page n — 1, FIFO replaces the first page
                           the process referenced in the loop. However, the next page the process references after com-
                           pleting one iteration of the loop is the page that was just replaced. To make room for that page.
                           FIFO replaces the second page the process referenced in the previous iteration of the loop. This
                           is, of course, the next page the process will reference in the current iteration. The optimal strat-
                           egy would be to replace the page that will be referenced the furthest in the future, which is the
                           page that was just referenced. In this case, OPT would result in one page fault per iteration of
                           the loop, whereas FIFO would result in n page faults per iteration of the loop.




                            11.6.3 FIFO Anomaly
                           It would seem reasonable that the more page frames allocated to a process, the
                           fewer page faults the process would experience. Belady, Nelson and Shedler discov-
                           ered that, under FIFO page replacement, certain page reference patterns actually
                           cause more page faults when the number of page frames allocated to a process is
                           increased.21 This phenomenon is called the FIFO Anomaly or Belady's Anomaly.
                                  Figure 11.3 illustrates an example of the anomaly. The first table demonstrates
                           how the reference pattern causes the system to load and replace pages (using
                           FIFO) when the system allocates three page frames to the process. The second table
                           shows how the system behaves in response to the same reference pattern, but when
                           four page frames have been allocated. To the left of each table, we indicate whether
                           the new page reference causes a page fault or not. When the process executes with
                           four pages in memory, it actually experiences one more page fault than when it exe-
                           cutes with only three pages.
                                  The FIFO Anomaly is more of a curiosity than an important result. Perhaps
                           its real significance to the student is to serve as a warning that operating systems are
                           complex entities that sometimes defy intuition.



                           Self Review
                           1. (T/F) When using the FIFO page-replacement strategy, the number of page faults a pro-
                              cess generates always increases as the number of page frames allocated to that process
                              increases.
                           Ans: False. The normal behavior is that page faults will decrease because more of the pro-
                           cess's pages can be available in memory, decreasing the chance that a referenced page will not
                           be available. Belady's observation is an anomaly; the behavior he observed occurs infrequently.

<!-- pág. 544 -->

                                                                              11.6 Page-Replacement Strategies 489




Figure 11.3 | FIFO anomaly-page faults can increase with page frame allocation.

11.6.4 Least-Recently Used (LRU) Page Replacement
The least-recently-used (LRU) page-replacement strategy (Fig. 11.4) relies on the
locality heuristic that a process's recent past behavior is a good indicator of the pro-
cess's near future behavior (temporal locality). When the system must replace a
page, LRU replaces the page that has spent the longest time in memory without
being referenced.
      Although LRU can provide better performance than FIFO, the benefit comes
at the cost of system overhead. 22 LRU can be implemented with a list structure that
contains one entry for each occupied page frame. Every time a page frame is refer-
enced, the system places that page's entry at the head of the list (indicating that the
page has been "most-recently referenced"). Older entries migrate toward the tail of
the list. When an existing page must be replaced to make room for an incoming one,
the system replaces the entry at the tail of the list. The system frees the correspond-
ing page frame (possibly requiring a modified page to be written to secondary stor-

<!-- pág. 545 -->

490 Virtual Memory Management




                          Figure 11.4 | Least-recently-used (LRU) page-replacement strategy.


                          age), places the incoming page into that page frame and moves the entry for that
                          frame to the head of the list (because that page is now the one that has been most
                          recently referenced). This scheme would faithfully implement LRU; however, it
                          incurs substantial overhead, because the system must update the list every time a
                          page is referenced.
                                We must always be careful when applying heuristic reasoning in operating sys-
                          tem design; the heuristic—such as LRU here—could fail in certain common situa-
                          tions. For example, the page least recently used could be the next page to be
                          referenced by a program that is iterating inside a loop that references several pages.
                          If the page is replaced, the system will be required to reload it almost immediately.


                          Self Review
                          1. (T/F) LRU is designed to benefit processes that exhibit spatial locality.
                          2. Why is "pure" LRU rarely implemented?
                          Ans: 1) False. LRU benefits processes that exhibit temporal locality. 2) LRU incurs the
                          overhead of maintaining an ordered list of pages and reordering that list.

<!-- pág. 546 -->

                                                                                    11.6 Page-Replacement Strategies 491

11.6.5       Least-Frequentlu-Used (LFU) Page Replacement
The least-frequently-used (LFU) page-replacement strategy makes replacement
decisions based on how intensively each page is being used. Under LFU, the system
replaces the page that is least frequently used or least intensively referenced. This
strategy is based on the intuitively appealing heuristic that a page that is not being
intensively referenced is not as likely to be referenced in the future. LFU can be
implemented using a counter that is updated each time its corresponding page is
referenced, but this can incur substantial overhead.
      The LFU page-replacement strategy, too, could easily select incorrect pages
for replacement. For example, the least-frequently used page could be the page
brought into main memory most recently. This page has been used once, whereas all
other pages in main memory may have been used more than once. In this case, the
page-replacement mechanism replaces the new page, when in fact the page would
be highly likely to be used immediately. Next, we consider a low-overhead page-
replacement strategy that makes reasonable decisions most of the time.

Self Review
1. Why is frequency of page usage a poor heuristic for reducing the number of future page
   faults?
2. Which page-replacement strategy incurs more execution overhead: LRU or LFU?
Ans: 1) Frequency measures the number of times a page is referenced, but it does not indi-
cate how many of those references generated page faults. Because page faults require the
process to wait for a page to be loaded from secondary storage, they should be treated with
greater weight than references to resident pages. If a reference to a page frequently generates
a page fault, then that page is being actively used, and keeping it in memory is likely to
reduce future page faults. The same is not always true for resident pages that have been refer-
enced frequently, because frequency does not indicate whether a page is still being actively
referenced. 2) The answer depends on the implementation. Both strategies, in their "pure"
form, must update page usage on every memory reference, meaning that the two strategies
incur similar overhead. LFU updates a counter, while LRU could be rethreading a linked list;
the latter would probably involve more overhead.


11.6.6 Not-Used-Recently (NUT) Page Replacement
A popular scheme for approximating LRU with little overhead is the not-used-
recently (NUR) page-replacement strategy. NUR is based on the idea that a page
that has not been used recently is not likely to be used in the near future. The NUR
strategy is implemented using the following two hardware bits per page table entry:
      • referenced bit—set to 0 if the page has not been referenced and set to one
        if the page has been referenced.
      • modified bit—set to 0 if the page has not been modified and set to 1 if the
        page has been modified.
     The referenced bit is sometimes called the accessed bit. The NUR strategy
works as follows. Initially, the system sets the referenced bits of all pages to 0. When

<!-- pág. 547 -->

492   Virtual Memory Management

                           a process references a particular page, the system sets the referenced bit of that
                           page to 1. The modified bits on all pages also are initially set to 0. Whenever a page
                           is modified, the system sets the page's modified bit to 1. When the system must
                           replace a page, NUR first attempts to find a page that has not been referenced
                           (because NUR is intended to approximate LRU). If no such page exists, the system
                           must replace a referenced page. In this case, NUR checks the modified bit to deter-
                           mine whether the page has been modified. If the page has not been modified, the
                           system selects it for replacement. Otherwise, the system must replace a page that
                           has been modified. Recall that replacing a modified page incurs the substantial
                           delay of an additional I/O operation as the modified page is written to secondary
                           storage to preserve its contents. Note, however, that periodic flushing of dirty pages
                           can, on average, reduce or eliminate this delay.
                                 Of course, main memory will likely be actively referenced in a multiuser sys-
                           tem, so eventually most or all of the pages' referenced bits will be set to 1. When
                           this is the case, NUR loses the ability to identify the most desirable pages to
                           replace. A technique that has been widely implemented to avoid this problem is for
                           the system periodically to set all the referenced bits to 0, then continue as usual.
                           Unfortunately, this makes even active pages vulnerable to replacement, but only for
                           a brief moment after the bits are reset—active pages will have their referenced bits
                           set to 1 again almost immediately.
                                 Pages can be classified into four groups in the NUR scheme (Fig. 11.5). The
                           pages in the lowest-numbered groups should be replaced first, and those in the
                           highest-numbered groups last. Pages within a group are selected randomly for
                           replacement. Note that Group 2 seems to describe an unrealistic situation—namely,
                           pages that have been modified but not referenced. This occurs because of the peri-
                           odic resetting of the referenced bits (but not of the modified bits).
                                 Schemes like NUR also can be implemented on machines that lack a hard-
                           ware referenced bit, and even on machines that lack a hardware modified bit.23 The
                           referenced and modified bits are typically implemented in hardware and set as part
                           of the execution of each machine instruction. Each of these bits can be simulated by
                           intercepting an operating system's fault handlers and exception handlers as follows.
                                 The referenced bit can be simulated by implementing a corresponding soft-
                           ware bit and by initializing each entry in the page table to indicate that the page is
                           not present. When a process references a page and causes a page fault, control
                           reverts to the page fault handler, which sets the referenced bit to 1 and resumes

                            Group       Referenced Modified          Description
                            Group 1      0             0             Best choice to replace
                            Group 2      0             1             [Seems unrealistic]
                            Group 3      1             0
                            Group 4      1             1             Worst choice to replace

                           Figure 11.5 | Page types under NUR.

<!-- pág. 548 -->

                                                                                    11.6 Page-Replacement Strategies 493

normal processing. The modified bit is simulated by marking each page as read-
only. When a process attempts to modify the page, a memory-access exception
occurs; the exception handler gains control, sets the (software-controlled) modified
bit on and changes the access control on that page to read/write. Of course, the
mechanism that implements the modified bit must still protect genuine read-only
pages from being modified, so the operating system must keep track of which pages
are truly read-only and which are truly read/write. The operating system must also
periodically set each resident page's referenced bit to zero; the size of this interval is
crucial to the performance of NUR. The instructions necessary to perform these
actions are most likely to be a small set that can execute quickly. Almost all of
today's processors include both a referenced and modified bit to boost the perfor-
mance of memory managers.


Self Review
1. How does the modified bit improve performance in the NUR replacement strategy?
2. How could NUR replace the worst possible page?
3. How can an NUR page be modified but not referenced?
Ans: 1) The modified bit enables the operating system to determine which pages can be
overwritten without first being flushed to disk. Selecting unmodified pages first reduces I/O
when performing page replacement. Note that NUR—to implement its heuristic—neverthe-
less replaces an unreferenced modified page before it replaces a referenced unmodified page.
2) The next page that is about to be referenced could have its referenced bit reset to zero just
before a page-replacement decision is made. 3) It truly would be referenced, but NUR peri-
odically resets the referenced bits.


11.6.7 Modifications to FIFO: Second.Chance and Clock Page Replacement
 A clear weakness of the FIFO strategy is that it may choose to replace a heavily
 used page that has been in memory for a long time. This possibility can be avoided
 by implementing FIFO with a referenced bit for each page and replacing a page
 only if its referenced bit is set to zero.
        The second-chance variation of FIFO examines the referenced bit of the old-
 est page; if this bit is off, the strategy immediately selects that page for replacement.
 If the referenced bit is on, the algorithm turns off the bit and moves the page to the
 tail of the FIFO queue. Such a page is treated essentially the same as a new arrival.
 Over time, the page gradually moves to the head of the queue. When it reaches the
head, it will be selected for replacement only if the referenced bit is still off.
       Active pages will be selected to return to the tail of the list, because their ref-
erenced bits will be set, and will thus remain in main memory. A modified page
must be flushed to secondary storage before the system can replace it; so when its
referenced bit is set off, the page remains "temporarily unreplaceable" until the sys-
tem completes the transfer. If a process references this page before the flush is com-
pleted, then it is recaptured, thus saving an expensive page-in operation from
secondary storage.

<!-- pág. 549 -->

494 Virtual Memory Management

                                The clock page replacement strategy, which produces essentially the same
                         results as the second-chance algorithm, arranges the pages in a circular list instead
                         of a linear list.24 Each time a page fault occurs, a list pointer moves around the cir-
                         cular list much as the hand of a clock rotates. When a page's referenced bit is turned
                         off, the pointer is moved to the next element of the list (simulating the movement of
                         this page to the rear of a FIFO queue). The clock algorithm places new arrivals in
                         the first page it encounters with the referenced bit turned off.

                         Self Review
                         1. Which strategy incurs more overhead, second chance or clock?
                         2. Why are second-chance and clock page replacement more efficient than LRU?
                         Ans: 1) Second chance requires the system to dequeue and requeue a page each time its
                         resident bit is turned off. Clock generally incurs less overhead, because it modifies the value
                         of a pointer each time a page's resident bit is turned off. 2) These algorithms reduce the num-
                         ber of times the system updates page usage information.



                         11.6.8 Far Page Replacement
                         When programs execute, they tend to reference functions and data in predictable
                         patterns. The far page-replacement strategy uses graphs to make replacement deci-
                         sions based on these predictable patterns. The far strategy has been shown mathe-
                         matically to perform at near-optimal levels, but it is complex to implement and
                         incurs significant execution-time overhead.25-26-27
                               The far strategy creates an access graph (Fig. 11.6) that characterizes a pro-
                         cess's reference patterns. Each vertex in the access graph represents one of the pro-
                         cess's pages. An edge from vertex v to vertex w means that the process can
                         reference page w after it has referenced page v. For example, if an instruction on
                         page v references data on page w, there will be a directed edge from vertex v to ver-
                         tex w. Similarly, if a function call to page x returns to page y, there will be an edge
                         from vertex x to vertex y. The graph, which can become quite complex, describes
                         how a process can reference pages as it executes. Access graphs can be created by
                         analyzing a compiled program to determine which pages can be accessed by each
                         instruction on each page, which can require significant execution time. [Note: Most
                         studies of the far strategy assume the access graph is constructed before a process is
                         run, although graph construction at runtime has been investigated.] 28 The access
                         graph in Fig. 11.6 indicates that, after the process references page B, it will next ref-
                         erence either page A, C, D or E, but it will not reference page G before it has refer-
                         enced page E.
                               The replacement algorithm operates in phases much like the clock algorithm.
                         Far initially marks all vertices in the access graph as unreferenced. When the process
                         accesses a page, the algorithm marks as referenced the vertex that corresponds to that
                         page. When the algorithm must select a page for replacement, it chooses the unrefer-
                         enced page that is furthest away (hence the name "far") from any referenced page in

<!-- pág. 550 -->

                                                                                    11.6 Page-Replacement Strategies   495




Figure 11.6 | Far page-replacement-strategy access graph.

the access graph (in Fig. 11.6, this corresponds to page Q).The intuitive appeal of this
strategy is that the unreferenced page that is furthest from any referenced page is
likely to be referenced furthest in the future. If the graph does not contain an unrefer-
enced vertex, the current phase is complete, and the strategy marks all the vertices as
unreferenced to begin a new phase.29 At this point, the algorithm replaces the page
furthest in the graph from the most-recently referenced page.
      The field of graph theory provides algorithms for building and searching the
the kinds of graphs in the far strategy. However, largely due to its complexity and
execution-time overhead, far has not been implemented in real systems.



Self Review
1. Despite providing near-optimal performance, what hinders the far page-replacement
   strategy from being widely implemented?
2. When might the far strategy replace a page that will be referenced soon?
Ans: 1) Far is complex to implement and it incurs substantial execution-time overhead.
2) The process may subsequently "walk" the access graph directly to the page that was
replaced, at which point it would experience a page fault. This could occur, for example, when a
process referenced error-processing routines or issued a series of nested procedure calls.

<!-- pág. 551 -->

496   Virtual Memory Management


                           11.7 Working Set Model
                           Locality of reference implies that a program can run efficiently even though only a
                           relatively small subset of its pages resides in main memory at any given time. Den-
                           ning's working set theory of program behavior focuses on determining what that
                           favored subset is and maintaining it in main memory to achieve the best
                           performance. 30 ' 31
                                 Many studies have been performed that illustrate the phenomenon of locality.
                           Figure 11.7 shows a graph of a process's memory reference pattern across its
                           pages.32 The darkened areas show which memory areas the process referenced dur-
                           ing consecutive time intervals. The figure vividly illustrates how this process tends
                           to favor a subset of its pages during certain execution intervals.
                                 The hypothetical process behaviors in Fig. 11.8 also support the existence of
                           the phenomenon of locality. This figure demonstrates how a process's page fault




                           Figure 11.7 | Storage reference pattern exhibiting locality. (Reprinted by permission
                           from IBM Systems Journal. © 1971 by International Business Machines Corporation.)

<!-- pág. 552 -->

                                                                                            11.7 Working Set Model 497




Figure 11.8 | Dependency of page fault rate on amount of memory for a process's
pages.
rate depends on the amount of main memory available for its pages. The straight
line shows how this relationship would appear if the process exhibited a random
reference pattern uniformly distributed over all its pages. The curved line shows
how processes typically behave. As the number of page frames available to a pro-
cess decreases, there is an interval over which it does not dramatically affect the
page fault rate. But at a certain point, when the number of page frames decreases
further, the number of page faults experienced by the running process rises dramat-
 ically. The graph shows that the process's page fault rate remains stable as long as its
favored subset remains in main memory. However, when the system cannot allocate
enough page frames to the process for its favored subset to remain in memory, the
process's page fault rate increases dramatically (because the process is constantly
referencing the pages that have been replaced).
       The principle of locality and the behavior of processes exhibited in the previ-
ous figures all support Denning's working set theory of program behavior. 33 ' 34 This
theory asserts that for a program to run efficiently, the system must maintain the
program's favored subset (i.e., its working set) of pages in main memory. Otherwise,
the system might experience excessive paging activity causing low processor utiliza-
tion, called thrashing, as the process repeatedly requests the same pages from sec-
ondary storage. 35 One way to avoid thrashing might be to give each process enough

<!-- pág. 553 -->

498 Virtual Memory Management

                         page frames to hold half its virtual space. Unfortunately, rules like this often result
                         in excessively conservative virtual memory management, ultimately limiting the
                         number of processes that may effectively share physical memory space.
                               A working set memory management policy seeks to maintain in main memory
                         only the pages that comprise each process's current working set.36, 37, 38, 39 The deci-
                         sion to add a new process to the active set of processes (i.e., to increase the level of
                         multiprogramming) is based on whether the system has a sufficient main memory
                         space to accommodate the new process's working set of pages. This decision —espe-
                         cially in the case of freshly initiated processes—-is typically made with heuristics,
                         because it is generally impossible for the system to know in advance how large a
                         given process's working set will be.
                               Figure 11.9 provides a precise definition of the term working set. The x-axis
                         represents process time (i.e., the time during which the process uses a processor as
                         distinguished from "wall clock" time) and the value t corresponds to the current
                         process time. The value w is the process's working set window size, which deter-
                         mines how far into the past the system should consider when calculating the pro-
                         cess's working set. The process's working set of pages W(t, w), is then defined as the
                         set of pages referenced by the process during the process-time interval t - w to t.
                               An effective working set memory management strategy must make careful
                         decisions about the size, w, of its process's working set window. Figure 11.10 illustrates
                         how working set size increases as w increases. This is a consequence of the mathemat-
                         ical definition of working set and is not necessarily an indication of empirically
                         observable working set sizes. The "true" working set of a process is simply the set of
                         pages that must reside in main memory for the process to execute efficiently.




                         Figure 11.9 | Definition of a process's working set of pages.

<!-- pág. 554 -->

                                                                                         11.7 Working Set Model 499




Figure 11.10 | Working set size as a function of window size.

       Working sets change as a process executes.40 Sometimes pages are added or
deleted. Sometimes dramatic changes occur when the process enters a new phase
(i.e., execution requiring a different working set). Thus, any assumptions about the
size and content of a process's initial working set do not necessarily apply to subse-
quent working sets that the process will accumulate. This complicates precise mem-
ory management under a working set strategy.
       Figure 11.11 shows how a process running under a working set memory man-
agement strategy might use main memory. First, as the process demand pages in its
initial working set one page at a time, the system gradually allocates it enough
memory to hold the working set. At this point, the process's memory use stabilizes




Figure 11.11 | Main memory allocation under working set memory management.

<!-- pág. 555 -->

500 Virtual Memory Management
                          as it actively references the pages in its first working set. The process eventually
                          makes a transition to the next working set, as indicated by the curved line from first
                          to second working set. Initially, the curved line rises above the number of pages in
                          the first working set because the process is rapidly demand-paging in its new work-
                          ing set. The system has no way of knowing whether this process is expanding its cur-
                          rent working set or changing working sets. Once the process stabilizes in its next
                          working set, the system sees fewer page references in the window and reduces the
                          process's main memory allocation to the number of pages in its second working set.
                          Each time a transition between the working sets occurs, this rising and falling
                          curved line shows how the system adapts. One goal of working set memory man-
                          agement is to reduce the height of each curved portion of the graph to that of the
                          next working set in the graph as quickly as possible. This would, of course, require
                          that the system rapidly determine which pages from the previous working set (if
                          any) are not part of the process's new working set.
                                The figure illustrates one of the difficulties with a working set memory man-
                          agement strategy, namely that working sets are transient, and a process's next work-
                          ing set may differ substantially from its current one. A memory management
                          strategy must carefully consider this to avoid overcommitting main memory, which
                          can lead to thrashing. Implementing a true working set memory management policy
                          can incur substantial overhead, especially because the composition of working sets
                          can and does change quickly. Morris discusses the use of custom hardware to make
                          working set storage management more efficient.41

                         Self Review
                         1. Why is it difficult to determine the size of a process's working set?
                         2. What trade-offs are inherent in choosing a window size, w?
                         /4nf: 1) If we adhere strictly to Denning's definition, then it is trivial to determine the work-
                          ing set size—it is exactly the number of unique pages that have been referenced within the
                          window, w. If we are concerned with the "true" working set, i.e., the set of pages the process
                          needs to have in memory to run efficiently, then things become more complex. One indica-
                          tion that a process has its working set in memory is a low (or even zero) page fault rate. This
                          could mean that the process has too many pages in memory. If we reduce the number of page
                          frames allocated to the process, at some point the page fault rate will increase, possibly dra-
                          matically. Just before it does is the point at which the working set (only) is in memory. 2) If w
                          is too small, a process's true working set might not be in memory at all times, leading to
                          thrashing. If w is too large, memory might be wasted because pages outside of a process'
                          working set might still be in memory, possibly limiting the degree of multiprogramming.



                         11.8 Page-Fault-Frequency (PFF) Page Replacement
                         One measure of how well a process is executing in a paging environment is its page-
                         fault rate. A process that faults constantly may be thrashing because it has too few
                         page frames and cannot maintain its working sets in memory. A process that almost
                         never faults may have too many page frames and thus may be impeding the

<!-- pág. 556 -->

                                                             11.8 Page-Fault-Frequency (PFF) Page Replacement 501

progress of other processes in the system (or preventing the operating system from
 increasing the degree of multiprogramming). Ideally, processes should operate at
some point between these extremes. The page-fault-frequency (PFF) algorithm
 adjusts a process's resident page set (i.e., those pages which are currently in mem-
ory), based on the frequency at which the process is faulting.42, 43, 44, 45, 46 Alterna-
tively, PFF may adjust a process's resident page set based on the time between page
faults, called the process's interfault time.
      PFF has a lower overhead than working set page replacement because it adjusts
the resident page set only after each page fault; a working set mechanism must oper-
ate after each memory reference. Under PFF, when a process makes a request that
results in a page fault, the strategy calculates the time since the last page fault. If that
time is larger than an upper threshold value, then the system releases all pages unref-
erenced in that interval. If the time is less than a lower threshold value, the incoming
page becomes a member of the process's resident page set.
      A benefit of PFF is that it adjusts a process's resident page set dynamically, in
response to the process's changing behavior. If a process is switching to a larger work-
ing set, then it will fault frequently, and PFF will allocate more page frames. Once the
process has accumulated its new working set, the page fault rate will stabilize and PFF
will either maintain the resident page set or reduce it. A key to the proper and effi-
cient operation of PFF is maintaining the thresholds at appropriate values.
      Some systems might increase performance by adjusting their process schedul-
ing algorithms to the frequency with which a process generates page faults. Presum-
ably, processes generating few page faults have accumulated their working sets in
main storage. Processes experiencing large numbers of page faults have not yet
established their working sets. The conventional wisdom is to favor processes that
have established their working sets. Another viewpoint is that processes with high
page fault rates should receive priority because they use a processor only briefly
before generating an I/O request. A process that is faulting in its next working set
appears to be an I/O-bound process. Once the working set is accumulated, the pro-
cess will "settle down" to "regular" behavior—some processes will be processor
bound and others will be I/O bound.



Self Review
1. How does PFF approximate the working set model?
2. What problems could arise if the PFF upper threshold is too small? What if the lower
   threshold is too large?
Ans: 1) Both PFF and the working set model change the size of a process's allocation space
dynamically to prevent thrashing. However, the working set model readjusts after every
memory access, whereas PFF readjusts only after each page fault. 2) If the lower threshold
were too large, the system would allocate more pages to a process than it needs, which would
result in wasted memory. If the upper threshold were too small, the system would release a
process's working set pages, leading to thrashing.

<!-- pág. 557 -->

502   Virtual Memory Management

                           11.9 Page Release
                           Under working set memory management, a process indicates which pages it wants
                           to use by explicitly referencing the pages. Pages that a process no longer requires
                           should be removed from its working set. Under existing memory management
                           strategies, however, needless pages often remain in memory until the management
                           strategy can detect that the process no longer needs them. An alternative strategy
                           would be for the process to issue a voluntary page release command to free a page
                           it no longer needs. This would eliminate the delay period caused by letting the pro-
                           cess gradually pass the page from its working set.
                                 Voluntary page release could speed program execution for the entire system.
                           One hope in this area is for compilers and operating systems to detect page-release
                           situations, and to do so much sooner than is possible under working set strategies.
                           Realistically, users cannot make such decisions, but applications programmers and
                           systems programmers can.

                           Self Review
                           1. Why could voluntary page release yield better performance than a pure working set page-
                              replacement strategy?
                           2. Why, then, is voluntary page release not widely implemented in today's systems?
                           Ans: 1) There is a latency in the working set strategy (i.e., the window size, w) that causes
                           pages no longer needed to "hang around" before being replaced. Voluntary page release
                           could release those pages sooner, leading to more efficient use of memory. 2) The real issue is
                           whether it is indeed possible to choose the right pages to release. This is hard to do, because
                           we know that we cannot, in the general case, predict the path of execution a program will
                           take.



                           11.10 Page Size
                           An important characteristic of a paged virtual memory system is the size of the
                           pages and page frames that the system supports. In today's systems, there is no one
                           "industry standard" page size, and many architectures support multiple page sizes,
                           with demonstrable improvements in performance. 47 When choosing a page size (or
                           page sizes), the system designer should evaluate several concerns, based on the
                           goals and limitations of the system to be designed.
                                  Many early results in the literature, both theoretical and empirical, point to
                           the need for small pages. 48 - 4950 As both memory and program sizes increase rap-
                           idly, larger page sizes have become more desirable. What considerations determine
                           whether a page should be large or small? Several are summarized here:
                                  • A large page size increases the range of memory that the TLB can refer-
                                    ence with each entry. This increases the likelihood of TLB hits, which
                                    improves dynamic address translation performance. 51
                                  • In general, a large page size can reduce the number of time-consuming I/O
                                    operations that transfer information between main memory and secondary

<!-- pág. 558 -->

                                                                                       11.10 Page Size 503

       storage. A system transferring such information using a small page size may
       require several separate I/O operations, which would increase a process's
       space-time product (see Section 11.3). However, anticipatory paging and
       (as we discuss in the next chapter) disk scheduling algorithms can reduce
       this overhead.
     • Processes tend to exhibit locality of reference over a small portion of their
       address spaces, so a smaller page size would help a process establish a
       smaller, tighter working set, leaving more memory available to other pro-
       cesses.52
     • A small page size leads to a large number of pages and page frames and
       correspondingly larger page tables. As discussed in Section 10.4.4, Multi-
       level Page Tables, these tables can consume a significant portion of main
       memory (i.e., table fragmentation). Large page sizes reduce table fragmen-
       tation by decreasing the number of page table entries (at the cost of
       increased internal fragmentation).
     • In a combined segmentation/paging organization the system may experi-
       ence internal fragmentation, because procedure and data units rarely com-
       prise an integral number of pages, so a segment is just as likely to have its
       last page nearly full as nearly empty (Fig. 11.12). Thus, each segment con-
       tains, on average, one-half page of internal fragmentation. More fragmen-
       tation results in a larger average working set size for programs.53 The
       system can reduce the amount of internal fragmentation by employing
       smaller page sizes.54




Figure 11.12 | Internal fragmentation in a paged and segmented system.

<!-- pág. 559 -->

504   Virtual Memory Management

                                 Although supporting multiple page sizes can address many of the limitations
                           of both large and small page sizes, it has several disadvantages. First, operating sys-
                           tems require hardware support for multiple page sizes to provide efficient dynamic
                           address translation. This means that the page address translation hardware must be
                           able to accommodate large and small pages. In the Intel Pentium 4 processor, this is
                           accomplished using multiple TLBs, each of which is dedicated to storing PTEs for
                           one page size. This added hardware complexity increases cost. Also, multiple page
                           sizes introduces the possibility of external fragmentation similar to that in segmen-
                           tation systems, because blocks are of variable size.55
                                 Figure 11.13 lists the page sizes used by several systems. Note the relatively
                           small single page sizes chosen for earlier computers, whereas more recent comput-
                           ers support larger page sizes and multiple page sizes.

                           Self Review
                           1. Why are large page sizes more favorable in today's systems than they were decades ago?
                           2. What are the negatives of having multiple page sizes?
                           Ans: 1) The cost of memory has become cheaper, leading to systems that contain large
                           memories and applications that require increasingly large amounts of memory. In today's sys-
                           tems, the cost of internal fragmentation due to larger page sizes is of less concern than it was



                            Manufacturer          Model                      Page Size                   Real adress size
                             Honeywell             Multics                    1KB                         36 bits
                             IBM                   370/168                   4KB                          32 bits
                             DEC                   PDP-10 and PDP-20          512 bytes                   36 bits
                             DEC                   VAX 8800                   512 bytes                   32 bits
                             Intel                 80386                     4KB                          32 bits
                             Intel/AMD             Pentium 4 / Athlon        4KB or 4MB                   32- or 36 bits
                                                   XP
                             Sun                   UltraSparc II             8KB, 64KB, 512KB,            44 bits
                                                                             4MB
                             AMD                   Opteron / Athlon 64       4KB, 2MB and 4MB             32, 40, or 52 bits
                             Intel-HP              Itanium, Itanium 2        4KB, 8KB, 16KB,              Between 32 and 63
                                                                             64KB, 256KB, 1MB,            bits
                                                                             4MB, 16MB, 64MB,
                                                                             256MB

                             IBM                   PowerPC 970               4KB, 128KB, 256KB,           32 or 64 bits
                                                                             512KB, 1MB, 2MB,
                                                                             4MB, 8MB, 16MB,
                                                                             32MB,        64MB,
                                                                             128MB, 256MB

                           Figure 11.13 | Page      sizes    in    various   processor    architectures.56, 57, 58

<!-- pág. 560 -->

                                                                                                                                                          11.11 Program Behavior under Paging 505

decades ago, when memory was far more expensive. Large pages also require the system to
perform fewer costly I/O operations to load a large portion of a process's virtual address
space into memory. However, there are many cases in which the operating system must store
data which is only a fraction of the page size. In this case, multiple page sizes might improve
memory utilization, at the cost of additional memory management overhead. 2) Both the
operating system and hardware must support multiple page sizes to provide efficient memory
management. Operating systems must be rewritten so that they efficiently manage multiple
page sizes, which requires costly software development. Processors must increase in com-
plexity to support multiple page sizes, which tends to increase their cost.


11.11 Program Behavior under Paging
Many studies have been performed examining the behavior of processes in paging
e n v i r o n m e n t s . 5 9 , 6 0 , 6 1 , 6 2 , 6 3 , 6 4 , 6 5 , 6 6 , 6 7 , 6 8 , 6 9 , 7 0 , 7 1 , 7 2 , 7 3 , 7 4 , 7 5 , 7 6 , 7 7 , 7 8 , 7 9 , 8 0 In this section we
present some qualitative results of these studies.
      Figure 11.14 shows the percentage of a hypothetical process's pages that have
been referenced, starting from the time the process begins execution. The initial
sharp upward slope indicates that a process tends to reference a significant portion
of its pages immediately after execution begins. With time, the slope diminishes, and
the graph asymptotically approaches 100 percent. Certainly some processes refer-
ence 100 percent of their pages, but the graph is drawn to reflect that many pro-
cesses may execute for a long time without doing so. This is the case, for example,
when certain error-processing routines are rarely invoked.
      The number of faults a process experiences depends on the size and behavior
of the system's processes. If they have small working sets, the number of page faults
experienced by a running process tends to increase as the page size increases. This
phenomenon occurs because, as page size increases, more procedures and data that
will not be referenced are brought into a fixed-size main memory. Further, as page




Figure 11.14 | Percentage of a process's pages referenced with time.

<!-- pág. 561 -->

506 Virtual Memory Management

                          size continues to increase, the system incurs more internal fragmentation. Thus, a
                          smaller percentage of a process's limited main memory is occupied by procedures
                          and data that will be referenced. A process with a large working set requires a
                          greater number of small page frames, which can lead to a large number of page
                          faults each time the process runs. If a process's working set contains pages that are
                          contiguous in the process's virtual address space, the number of page faults tends to
                          decrease as the page size increases. This occurs because each page fault loads into
                          memory a significant portion of the process's working set.
                                Figure 11.15 shows how the average interfault time (i.e., the time between
                          page faults) varies as the number of page frames allocated to a process increases.
                          The graph is nondecreasing—the more page frames a process has, the longer the
                          time between page faults (subject, of course, to occasional strange behavior such as
                          the FIFO anomaly). 81 At one point, the graph bends, and its slope declines sharply.
                          At this point the process has its entire working set in main memory. Initially, the
                          interfault time grows quickly, as more of the working set resides in main memory.
                          Once the physical memory allotment is sufficient to hold the process's working set.
                          the curve bends sharply, indicating that the effect of allocating additional page
                          frames on increasing the interfault time is not as great. Again, the goal of a memory
                          management strategy should be to maintain the working set in main memory.
                                 The qualitative discussions of this section generally point to the validity of the
                          working set concept. As computer architecture and software design evolves, these
                          results will need to be reevaluated.




                         Figure 11.15 | Dependency of interfault time on the number of page frames allo-
                         cated to a process.

<!-- pág. 562 -->

                                                                            11.12 Global vs. Local Page Replacement 507

Self Review
1. How does program behavior under paging support the notion of lazy allocation, whereby
   the operating system does not allocate page frames to a process until the process explicitly
   references its pages?
2. (T/F) The interfault time for a particular process always increases as the number of page
   frames allocated to a process increases.
Ans: 1) Figure 11.14 demonstrates that the operating system would waste considerable
memory if it reserved memory that a process would not use until later in its execution. How-
ever, if a process references its pages with predictable patterns, anticipatory paging could
improve performance by reducing page-wait times. 2) False. This is indeed the normal behav-
ior, but if the algorithm is subject to Belady's Anomaly, the interfault time might decrease.


11.12 Global vs. Local Page Replacement
When evaluating the page-replacement strategies presented in the previous sec-
tions, we provided reference patterns for a single, arbitrary process. In most real
systems, the operating system must provide a page-replacement strategy that yields
good performance for a number of diverse processes.
       When implementing a paged virtual memory system, the operating system
designer must decide whether page-replacement strategies should be applied to all
processes as a unit (i.e., global strategies) or consider each process individually (i.e.,
local strategies). Global page-replacement strategies tend to ignore the characteris-
tics of individual process behavior; local page-replacement strategies enable the
system to adjust memory allocation according to the relative importance of each
process to improve performance.
       As we will see, a heuristic that yields good results when applied to individual
process behavior can lead to poor performance when applied to the system as a
whole.There is no conventional wisdom on this—Linux, for example, implements a
global page-replacement strategy and Windows XP implements a local page-
replacement strategy (see Section 20.6.3, Page Replacement, and Section 21.7.3,
Page Replacement, respectively).82
       The global LRU (gLRU) page-replacement strategy replaces the least-
recently-used page in the entire system. This simple strategy does not attempt to
analyze individual process behavior or the relative importance of processes when
selecting a page to replace. Consider, for example, a system that schedules pro-
cesses using round robin—the next process to run is the process that has waited the
longest. In this case, pages belonging to the next process to run are often the least-
recently-used pages, so gLRU is likely to replace the next page to be used. Note
that gLRU can result in poor performance regardless of individual process behavior
if the system implements a variant of the round-robin scheduling algorithm.
       Glass and Cao suggest the SEQ (sequence) global replacement strategy,
which is a modified version of LRU that adjusts its strategy based on process behav-
ior.83 In general, the SEQ strategy uses the LRU strategy to replace pages. As dis-
cussed in Section 11.6.4, LRU performs poorly when processes enter loops that

<!-- pág. 563 -->

508 Virtual Memory Management

                          reference a sequence of pages that cannot all fit in memory at once. In this case, the
                          optimal page to replace is the page that was most-recently used because it will be
                          referenced furthest in the future (i.e., during the next iteration of the loop).
                          Accordingly, the SEQ strategy uses the heuristic that a process experiencing a
                          sequence of page faults when referencing a series of contiguous pages is exhibiting
                          looping behavior. When such behavior is detected, it applies the most-recently u s e d
                          (MRU) strategy, which is optimal for that reference pattern. If a process experi-
                          ences page fault when referencing a noncontiguous page, SEQ uses the LRU strat-
                          egy until another sequence of page faults to contiguous pages is detected.




                          11.13 Case Study: Linux Page Replacement
                          In this section we discuss the page-replacement strategy implemented in Linux.
                          More information about memory management in Linux can be found in
                          Section 20.6, Memory Management. When physical memory is full and nonresident
                          data is requested by processes or the kernel, page frames must be freed to fill the
                          request. Pages are divided into active pages and inactive pages. To be considered
                          active, a page must have been referenced recently. One goal of the memory man-
                          ager is to maintain the current working set inside the collection of active pages.84
                                 Linux uses a variation of the clock algorithm to approximate an LRU page-
                          replacement strategy (Fig. 11.16). The memory manager uses two linked lists: the
                          active list contains active pages, the inactive list contains inactive pages. The lists are
                          organized such that the most-recently used pages are near the head of the active
                          list, and the least-recently used pages are near the tail of the inactive list.85
                                 When a page is first brought into memory, it is placed in the inactive list and is
                          marked as having been referenced by setting its referenced bit. The memory man-
                          ager periodically determines whether the page has been subsequently referenced.
                          such as during a page fault. If the page is active or inactive and its referenced bit is
                          off, the bit is turned on. Similar to the clock algorithm, this technique ensures that
                          recently referenced pages are not selected for replacement.
                                 Otherwise, if the page is inactive and is being referenced for the second time
                          (its referenced bit is already on), the memory manager moves the page to the head
                          of the active list, then clears its referenced bit.86 This allows the kernel to determine
                          whether a page has been referenced more than once recently. If so, the page is
                          placed in the active list so that it is not selected for replacement. To ensure that the
                          active list contains only pages that are being heavily referenced, the memory man-
                          ager periodically moves any unreferenced pages in the active list to the head of the
                          inactive list.
                                 This algorithm is repeated until the specified number of pages have been
                          moved from the tail of the active list to the head of the inactive list. A page in the
                          inactive list will remain in memory until it is selected for replacement. While a page
                          is in the active list, however, it cannot be selected for replacement. 87

<!-- pág. 564 -->

                                                                                                   Web Resources 509




Figure 11.16 | Linux page replacement overview.



Web Resources
publib16.boulder.ibm.com/pseries/en_US/aixbman/                 developer.apple.com/documentation/mac/Memory/Mem-
admnconc/vtnm_overview.htm                                      ory-2.html
Describes virtual memory management in AIX, which is            Describes virtual memory management in the Apple Macin-
IBM's UNIX-based system.                                        tosh operating system.
www.csn.ul.ie/~mel/projects/vm/                                 msdn.microsoft.com/library/default.asp?url=/
Describes virtual memory management for the Linux 2.4 kernel.   library/en-us/appendix/hh/appendix/
www.informit.com/isapi/product_id~%7B6D5ACA10-                  enhancements5_3oc3.asp
5AB0-4627-81E5-65B9F6E080AC%7D/content/index.asp                Discusses memory management enhancements in Windows XP.
Describes virtual memory management in Windows 2000 run-        www.nondot.org/~sabre/os/articles/MemoryManagement/
ning on an Intel x86 processor.                                 Lists links to several articles related to memory management.

<!-- pág. 565 -->

510 Virtual Memory Management

Summary
The technique a system employs to select pages for replace-      fied, so that it can improve the performance by avoiding
ment when memory is full is called a replacement strategy.       the cost of writing (or flushing) a modified page to disk
A system's fetch strategy determines when pages or seg-          after a page fault.
ments should be loaded into main memory. Demand fetch                   The optimal page replacement strategy states that, to
strategies wait for a process to reference a page or segment     obtain optimal performance, replace the page that will not
before loading it. Anticipatory fetch strategies use heuris-     be referenced again until furthest into the future. It is possi-
tics to predict which pages a process will soon reference        ble to demonstrate the optimality of this strategy (called
and load those pages or segments. A placement strategy           OPTorMIN).
determines where in main memory to place an incoming                    Random (RAND) page replacement is a low-over-
page or segment. Paging systems with a single page size          head page-replacement strategy that does not discriminate
trivialize the placement decision, because an incoming           against particular processes. Under this strategy, each page
page may be placed in any available page frame. Segmenta-        in main memory has an equal likelihood of being selected
tion systems require placement strategies similar to those       for replacement. A problem it entails is that it could easily
used in variable-partition multiprogramming.                     select as the next page to replace the page that will be ref-
       Central to most memory management strategies is           erenced next.
the concept of locality—that a process tends to reference               In the first-in-first-out (FIFO) page-replacement
memory in highly localized patterns. In paging systems,          strategy, we replace the page that has been in the system
processes tend to favor certain subsets of their pages, and      the longest. Unfortunately, first-in-first-out is likely to
these pages often tend to be adjacent to one another in a        replace heavily used pages, because the reason that a page
process's virtual address space. The simplest fetch policy is    has been in main memory for a long time may be that pro-
demand paging—when a process first executes, the system          cesses reference it often. Although FIFO can be imple-
loads into main memory the page that contains its first          mented with relatively low overhead, it is impractical for
instruction. After that, the system loads a page from sec-       most systems. Under FIFO page replacement, certain page-
ondary storage to main memory only when the process              reference patterns actually cause more page faults when
explicitly references that page. Demand paging requires a        the number of page frames allocated to a process is
process to accumulate pages one at a time, which often           increased—a counterintuitive phenomenon called the
increases a process's space-time product—a measure of its        FIFO Anomaly or Belady's Anomaly.
execution time (i.e., the duration for which a process occu-            The least-recently-used (TRU) page-replacement
pies memory) multiplied by the amount of space in main           strategy exploits temporal locality by replacing the page that
memory it occupies.                                              has spent the longest time in memory without being refer-
       In anticipatory paging, the operating system attempts     enced. Although LRU can provide better performance than
to predict the pages a process will need and preloads these      FIFO, the benefit comes at the cost of increased system over-
pages when memory space is available. Anticipatory paging        head. Unfortunately, the page least-recently used could be
strategies must be carefully designed so that overhead           the next page to be referenced by a program that is iterating
incurred by the strategy does not reduce system perfor-          inside a loop that references several pages.
mance. A demand prepaging strategy preloads a group of                  The least-frequently-used (LFU) page-replacement
pages into memory when a process references a nonresi-           strategy replaces the page that is least intensively refer-
dent page, which can be effective when processes exhibit         enced. This strategy is based on the heuristic that a page
spatial locality.                                                not referenced often is not likely to be referenced in the
       When a process generates a page fault, the memory         future. LFU could select the wrong page for replacement;
management system must locate the referenced page in             for example, the least-frequently-used page could easily be
secondary storage, load it into a page frame in main mem-        the page brought into main memory most recently —a page
ory and update the corresponding page table entry. Most          that any reasonable page-replacement strategy would like
modern architectures support a modified (or dirty) bit in        to keep in main memory.
their page table entries; this bit is set to 1 if the page has          The not-used-recently (NUR) replacement strategy
been modified and 0 otherwise. The operating system uses         approximates LRU with little overhead by using a refer-
this bit to quickly determine which pages have been modi-        enced bit and a modified bit to determine which page has

<!-- pág. 566 -->

                                                                                                               Summary 511
not been used recently and can be replaced quickly.                 page fault, whereas a working set mechanism must operate
Schemes like NUR also can be implemented on machines                after each memory reference. If a process is switching to a
that lack a hardware referenced bit and/or modified bit.            larger working set, then it will fault frequently and PFF will
       The second-chance variation of FIFO examines the             allocate more page frames. Once the process has accumu-
referenced bit of the oldest page; if this bit is off, the strat-   lated its new working set, the page fault rate will stabilize
egy selects that page for replacement. If the referenced bit        and PFF will either maintain the resident page set or
is on, the strategy turns off the bit and moves the page to         reduce it. The key to the proper and efficient operation of
the tail of the FIFO queue. This ensures that active pages          PFF is maintaining the thresholds at appropriate values.
are the least likely to be replaced. The clock variation of                Under all memory management strategies, needless
the second-chance algorithm arranges the pages in a circu-          pages can remain in main memory until the management
lar list instead of a linear list. When a page's referenced bit     strategy detects that the process no longer needs them,
is turned off, the pointer is moved to the next element of          which can be well after the page is no longer needed. One
the list (simulating the movement of this page to the rear of       way to solve this problem would be for the process to issue
a FIFO list). Second chance and clock produce essentially           a voluntary page release to free a page frame that it knows
the same results.                                                   it no longer needs, eliminating the delay period caused by
       The far strategy creates an access graph that charac-        letting the process gradually pass the page from its working
terizes a process's reference patterns. The algorithm               set. The real hope in this area is for compilers and operat-
chooses to replace the unreferenced page that is furthest           ing systems to detect page-release situations, and to do so
away from any referenced page in the access graph.                  much sooner than is possible under working set strategies.
Although the strategy performs at near-optimal levels, it                  An important characteristic of a paged virtual mem-
has not been implemented in real systems, because the               ory system is the size of the pages and page frames that the
access graph is complex to search and manage without                system supports. Some systems improve performance and
hardware support.                                                   utilization by providing multiple page sizes. Small page
       Denning's working set theory of program behavior             sizes reduce internal fragmentation and can reduce the
asserts that for a program to run efficiently, the system           amount of memory required to contain a process's working
must maintain that program's favored subset of pages—its            set, leaving more memory available to other processes.
working set—in main memory. Otherwise, the system                   Large page sizes reduce wasted memory from table frag-
might experience excessive paging activity causing low pro-         mentation, enable each TLB entry to map a larger region
cessor distillation called thrashing as the program repeat-         of memory, and reduce the number of I/O operations the
edly requests pages from secondary storage. A working set           system performs to load a process's working set into mem-
memory management policy seeks to maintain in main                  ory. The use of multiple page sizes requires both hardware
memory only the pages that comprise each process's cur-             and software support, which can be costly to implement,
rent working set. The decision to add a new process to the          and introduces the possibility of external fragmentation
active set of processes is based in part on whether the sys-        due to variable page sizes.
tem has sufficient main memory space to accommodate the                    Processes tend to reference a significant portion of
new process's working set of pages. A process's working set         their pages within a short time after execution begins, then
window size specifies how far into the past the system              access most (or all) of their remaining pages at a slower
should consider when calculating the process's working set.         rate. The average interfault time (i.e., the time between
One challenge of working set memory management is that              page faults) monotonically increases in general—the more
working sets are transient, and a process's next working set        page frames a process has, the longer the time between
may differ substantially from its current one.                      page faults (subject, of course, to strange behavior such as
       The page-fault-frequency (PFF) algorithm adjusts a           that observed in the FIFO Anomaly).
process's resident page set (i.e., those pages which are cur-              When implementing a paged virtual memory system,
rently in memory), based on the frequency at which the              the operating system designer must decide whether page-
process is faulting. Alternatively, PFF may adjust a pro-           replacement strategies should be applied to all processes as a
cess's resident page set based on the time between page             unit (i.e., global strategies) or consider each process individ-
faults, called the process's interfault time. An advantage of       ually (i.e., local strategies). Global page-replacement strate-
PFF over working set page replacement is lower over-                gies tend to ignore the characteristics of individual process
head—PFF adjusts the resident page set only after each              behavior; local page-replacement strategies enable the sys-

<!-- pág. 567 -->

512    Virtual Memory Management

tem to adjust memory allocation according to the relative          (sequence) global replacement strategy, uses the LRU strat-
importance of each process to improve performance. The             egy to replace pages until sequence of page faults to contigu-
global LRU (gLRU) page-replacement strategy replaces the           ous pages is detected, at which point it uses the most-
least-recently-used page in the entire system. The SEQ             recently-used (MRU) page-replacement strategy.



Key Terms
accessed bit—See referenced bit.                                       not been referenced for the longest time in the entire sys-
anticipatory paging—Technique that preloads a process's non-           tem. LRU can perform poorly because variants of round-
     resident pages that are likely to be referenced in the near       robin scheduling cause the system to exhibit a large-scale
     future. Such strategies attempt to reduce the number of           looping reference pattern. The SEQ variant of gLRU
     page faults a process experiences.                                page replacement attempts to improve performance by
                                                                       replacing the most-recently-used page when it detects a
Belady's Anomaly—See FIFO Anomaly.
                                                                       looping reference pattern.
clock page-replacement strategy—Variation of the second-
                                                                   interfault time—Time between a process's page faults. This is
     chance page-replacement strategy that arranges the pages
                                                                        used in the page-fault-frequency page-replacement strat-
     in a circular list instead of a linear list. A list pointer
                                                                        egy to determine when to increase or decrease a pro-
     moves around the circular list, much as the hand of a
                                                                        gram's page frame allocation.
     clock rotates, and replaces the page nearest the pointer
     (in circular order) that has its referenced bit turned off.   least-frequently-used   (LFU)     page replacement—Page-
                                                                        replacement strategy that replaces the page that is least
demand paging—Technique that loads a process's nonresident
                                                                        frequently used or least intensively referenced. LFU is
   pages into memory only when the process explicitly refer-
                                                                        easy to implement, but generally does not predict future
   ences the page.
                                                                        page usage well.
dirty bit—Page table entry bit that specifies whether the page
     has been modified (also known as the modified bit).           least-recently-used (LRU) page replacement—Page-replace-
                                                                        ment strategy that replaces the page that has not been ref-
far page-replacement strategy—Graph-based page-replace-                 erenced for the longest time. LRU generally predicts
    ment strategy that analyzes a program's reference pat-              future page usage well but incurs significant overhead.
    terns to determine which page to replace. This strategy
    replaces the page that is furthest from any referenced         modified bit —Page table entry bit that indicates whether a
    page in the graph and that has not been referenced                 page has been modified and hence must be copied to sec-
    recently.                                                          ondary storage before being replaced (also known as the
                                                                       dirty bit).
FIFO Anomaly—Phenomenon in FIFO page-replacement
    strategy whereby increasing a process's page frame alloca-     not-used-recently (NUR) page replacement—Low-overhead
    tion increases the number of page faults it experiences;            approximation to the LRU page-replacement strategy:
    normally, page faults should decrease as more page                 uses referenced bits and dirty bits to replace a page. NUR
    frames become available.                                           first attempts to replace a page that has not been refer-
first-in-first-out (FIFO) page replacement—Page-replace-                enced recently and that has not been modified. If no such
      ment strategy that replaces the page that has been in            page is available, the strategy replaces a dirty page that
      memory longest. FIFO incurs low overhead but generally           has not been referenced recently, a clean page that has
      does not predict future page usage accurately.                   been referenced recently or a referenced page that has
                                                                       been referenced recently, in that order.
flushing a page—Copying the contents of a modified page in
     main memory to secondary storage so another page can          optimal (OPT) page replacement—Unrealizable page-
     be placed in its frame. When this occurs, the page's dirty        replacement strategy that replaces the page that will not
     bit is cleared, which enables the operating system to             be used until furthest in the future. This strategy has been
     quickly determine that the page can be overwritten by an          shown to be optimal.
     incoming page, which can reduce page-wait times.              page-fault-frequency (PFF) page replacement—Algorithm
global least-recently-used (gLRU) page replacement—Global              that adjusts a process's resident page set based on the fre-
    page-replacement strategy that replaces the page that has          quency with which the process is faulting. If a process is

<!-- pág. 568 -->

                                                                                                                Exercises       513

    switching to a larger working set, then it will fault fre-      space-time product—Value that measures the product of a
    quently, and PFF will allocate more page frames. Once the           process's execution time (i.e., the duration for which a
    process has accumulated its new working set, the page               process occupies memory) and the amount of real-mem-
    fault rate will stabilize, and PFF will either maintain the         ory space the process occupies. Ideally, memory manage-
    resident page set or reduce it. The key to the proper and           ment strategies should reduce this quantity to increase a
    efficient operation of PFF is maintaining the thresholds at         system's degree of multiprogramming.
    appropriate values.                                             spatial locality—Empirical property that, in paging systems,
page-replacement strategy—Strategy that determines which                 states that processes tend to favor certain subsets of their
    page to replace to provide space for an incoming page.               pages, and that these pages tend to be near one another in
    Page replacement strategies attempt to optimize perfor-              a process's virtual address space. A process accessing
    mance by predicting future page usage.                               sequential indices of an array exhibits spatial locality.

prefetching—See anticipatory paging.                                thrashing—Excessive paging activity causing low processor
                                                                        utilization that occurs when a process's memory alloca-
prepaging—See anticipatory paging.                                      tion is smaller than its working set. This results in poor
                                                                        performance, as the process spends most of its time wait-
random (RAND) page replacement—Page-replacement strat-
                                                                        ing as pages are transferred between secondary storage
    egy in which each page in main memory has an equal like-
                                                                         and main memory.
    lihood of being selected for replacement. Although this
    strategy is fair and incurs little overhead, it does not        voluntary page release — Occurrence when a process explicitly
    attempt to predict future page usage.                               releases a page frame that it no longer needs. This can
                                                                        improve performance by reducing the number of unused
referenced bit—Page table entry bit indicating whether a page           page frames allocated to a process, leaving more memory
     has been referenced recently. Several strategies reset this        available.
     bit to more accurately determine how recently a page has
     been referenced.                                               working set—A program's favored subset of pages in main
                                                                        memory. Given a working set window, w, the process's
resident page set —Set of a process's pages that are currently in       working set of pages W(t, w), is defined as the set of pages
     memory; these pages may be referenced without generat-             it references during the process-time interval t - w to t.
     ing a page fault. The resident page set might differ in size   working set theory of program behavior—Theory presented
     from a process's working set, which is the set of pages that       by Denning; which asserts that for a program to run effi-
     must be in memory for a process to execute efficiently.            ciently, the system must maintain that program's favored
second-chance page-replacement strategy—Variation of FIFO               subset (i.e., its working set) of pages in main memory.
    page replacement that uses the referenced bit and a FIFO            Given a working set window, w, the process's working set
    queue to determine which page to replace. If the oldest             of pages W(t, w), is defined as the set of pages referenced
    page's referenced bit is off, second chance replaces the            by the process during the process-time interval t - w to t.
    page; otherwise it turns off the referenced bit on the old-         Choosing the window size, w, is a crucial aspect of imple-
    est page and moves it the tail of the FIFO queue. If its ref-       menting working set memory management.
    erenced bit is on, the strategy turns off the bit and           working set window size—Value that determines how far into
    examines the next page or pages until it locates a page             the past the system should consider to determine what
    with its referenced bit turned off.                                 pages are in the process's working set.




Exercises
11.1 Discuss the goals of each of the following memory man-         11.2 Explain why memory management in pure segmenta-
agement strategies in the context of virtual memory systems         tion systems is quite similar to memory management in vari-
with paging.                                                        able-partition multiprogramming systems.
      a. fetch strategy                                             11.3 One particular virtual memory computer system with
                                                                    combined segmentation and paging supports a degree of mul-
      b. placement strategy
                                                                    tiprogramming of 10. Instruction pages (reentrant code) are
      c. replacement strategy                                       maintained separately from data pages (which are modifiable).

<!-- pág. 569 -->

514 Virtual Memory Management
You have studied the system in operation and have made the          11.8 Suppose a memory manager decides which page to
following observations: (1) Most procedure segments are             replace solely on the basis of examining the referenced and
many pages long and (2) most data segments use only a small         modified bits for each page frame. List several incorrect deci-
fraction of a page.                                                 sions the memory manager might make.
       Your associate has proposed that one way to get better       11.9 List several reasons why it is necessary to prevent cer-
utilization out of memory is to pack several of each user's data    tain pages from being paged out of main memory.
segments onto an individual page. Comment on this proposal
considering issues of:                                              11.10 Why is it generally more desirable to replace an unmod-
                                                                    ified page rather than a modified one? In what circumstances
      a. memory use                                                 might it be more desirable to replace a modified page?
      b. execution efficiency                                       11.11 For each of the following pairs of replacement strategies,
      c. protection                                                 explain how a page-reference sequence could result in both
      d. sharing                                                    strategies choosing (1) the same page for replacement and (2)
                                                                    a different page for replacement.
11.4 Today there is much interest in anticipatory paging and
                                                                          a. LRU,NUR
in anticipatory resource allocation in general. What useful
information might each of the following supply to an anticipa-            b. LRU,LFU
tory paging mechanism?                                                    c. LRU, FIFO
      a. the programmer                                                   d. NUR,LFU
      b. the compiler                                                     e. LFU,FIFO
      c. the operating system                                             f. NUR,FIFO.
      d. a log of past executions of the program                    11.12 The optimal (MIN) page-replacement strategy is unreal-
                                                                    izable because the future cannot be predicted. There are cir-
11.5 It is known that in the general case we cannot predict
                                                                    cumstances, however, in which MIN can be implemented.
the path of execution of an arbitrary program. If we could,
                                                                    What are they?
then we would be able to solve the Halting Problem—which is
known to be unsolvable. Explain the ramifications for the           11.13 Suppose a memory manager has chosen a modified page
effectiveness of anticipatory resource-allocation mechanisms.       for replacement. This page must be sent to secondary storage
                                                                    before the new page may be placed in its page frame. There-
11.6 Suppose a memory manager has narrowed its page-                fore, the memory manager requests an I/O operation to write
replacement decision to one of two pages. Suppose that one of       this page to secondary storage. An entry is made in a list of I/O
the pages is shared by several processes, and the other is in use   requests waiting to be serviced. Thus the page will remain in
by only a single process. Should the memory manager always          main memory for some time before the requested I/O opera-
replace the nonshared page? Explain.                                tion is performed. Now suppose that, while the other I/O
11.7 Discuss each of the following unconventional (if not           requests are serviced, a running process requests the page to
whimsical) page-replacement schemes in the context of a vir-        be replaced. How should the memory manager react?
tual memory multiprogramming system servicing both batch            11.14 Design an experiment for a paged system to demon-
and interactive processes.                                          strate the phenomena of temporal and spatial locality.
      a. "Global LIFO"—The page brought into main mem-              11.15 A programmer who writes programs specifically to
         ory most recently is replaced.                             exhibit good locality can expect marked improvement in their
      b. "Local LIFO"—The page brought in most recently             execution efficiency. List several strategies a programmer can
         by the process which requested the incoming page is        use to improve locality. In particular, what high-level language
         replaced.                                                  features should be emphasized?
      c. "Tired Page"—The most heavily referenced page in           11.16 Suppose the bus between memory and secondary stor-
         the system is replaced.                                    age is experiencing heavy page traffic. Does this imply thrash-
                                                                    ing? Explain.
      d. "Battered Page"—The most heavily modified page in
         the system is replaced. One variant would count the        11.17 Why might a global page-replacement policy (in which
         number of writes to the page. Another would consider       an incoming page may replace a page of any process) be more
         the percentage of the page that has been modified.         susceptible to thrashing than a local page-replacement policy

<!-- pág. 570 -->

                                                                                                                   Exercises       515
(in which an incoming page may replace only a page belonging         11.24 The interaction between the various components of an
to the same process)?                                                operating system is critical to achieving good performance.
11.18 Discuss the trade-offs between giving each process more        Discuss the interaction between the memory manager and the
page frames than it needs (to prevent thrashing) and the             job initiator (i.e., admission scheduler) in a virtual-memory
resulting fragmentation of main memory.                              multiprogramming system. In particular, suppose the memory
                                                                     manager uses a working set memory-management approach.
11.19 Suggest a heuristic that a memory manager might use to
determine if main memory has become overcommitted.                   11.25 Consider the following experiment and explain the
                                                                     observations.
11.20 The working set of a process may be defined in several                A process is run by itself on a paged machine. It begins
ways. Discuss the merits of each of the following schemes for        execution with its first procedure page. As it runs, the pages it
deciding which pages constitute a process's working set.             needs are demand-paged into available page frames. The num-
      a. those pages that the process has referenced in the last     ber of available page frames far exceeds the number of pages
         w seconds of wall-clock time                                in the process. But there is a dial external to the computer that
                                                                     allows a person to set the maximum number of page frames
      b. those pages that the process has referenced in the last
                                                                     the process may use.
         w seconds of virtual time (i.e., time during which the
                                                                            Initially, the dial is set at two frames, and the program is
         process was running on a processor)
                                                                     run to completion. The dial is then set at three frames, and
      c. the last k different pages referenced by the process        again the program is run to completion. This continues until
      d. those pages on which a process made its last r instruc-     the dial is eventually set to the number of available page
         tion or data references                                     frames in main memory, and the process is run for the last
                                                                     time. For each run, the run time of the process is recorded.
      e. those pages that the process has referenced in the last
                                                                            Observations:
         w seconds of virtual time with a frequency greater
                                                                            As the dial is changed from two to three to four, the run
         than/times per virtual second.
                                                                     times improve dramatically. From four to five to six, the run
11.21 Give an example in which a working set page-replace-           times still improve each time, but less dramatically. With the
ment strategy would replace:                                         dial settings of seven and higher, the run time remains essen-
      a. the best possible page                                      tially constant.

      b. the worst possible page                                     11.26 An operating systems designer has proposed the "PD
                                                                     memory management strategy" that operates as follows.
11.22 One difficulty in implementing a working set memory            Exactly two page frames are allocated to each active process.
management strategy is that when a process requests a new            These frames hold the most recently referenced procedure
page, it is difficult to determine whether that process is transi-   page, called the P-page, and the most recently referenced data
tioning to a new working set or is expanding its current work-       page, called the D-page. When a page fault occurs, if the refer-
ing set. In the first case it is better for the memory manager to    enced page is a procedure page, the strategy replaces the P-
replace one of the process's pages; in the latter it is better for   page, and if the referenced page is a data page, the strategy
the memory manager to increase the process's page frame              replaces the D-page.
 allocation. How might a memory manager decide which case is                The designer says that the chief virtue of the scheme is
 appropriate?                                                        that it trivializes all aspects of memory management and thus
11.23 Suppose all active processes have established their            has low overhead.
working sets in main memory. As localities change, working                 a. How are each of the following memory management
sets could grow and main memory could become overcommit-                      strategies handled under the PD scheme?
ted, causing thrashing. Discuss the relative merits of each of
                                                                              i.   fetch
the following preventive strategies for preventing this.
                                                                              ii. placement
      a. Never initiate a new process if main memory is
         already 80 percent or more committed.                                iii. replacement
      b. Never initiate a new process if main memory is                    b. In what circumstances would PD actually yield better
         already 97 percent or more committed.                                results than working set memory management?

      c. When a new process is initiated, assign it a maximum              c. In what circumstances would PD yield poor results?
         working set size beyond which it will not be allowed        11.27 Summarize the arguments for and against (1) small page
         to grow.                                                    sizes and (2) large page sizes.

<!-- pág. 571 -->

516 Virtual Memory Management

n . 2 8 The Multics system was originally designed to manage            a. What are the consequences of selecting too large an
64-word pages and 1024-word pages (the dual-page-size                      upper value?
scheme was eventually abandoned).                                       b. What are the consequences of selecting too small a
      a. What factors do you suppose motivated this design                 lower value?
         decision?                                                      c. Should the values remain fixed, or should they be
      b. What effect does this dual-page-size approach have                adjusted dynamically?
         on memory management strategies?                               d. What criteria would you use to adjust the values
                                                                           dynamically?
11.29 Discuss the use of each of the following hardware fea-
tures in virtual memory systems.                                 11.32 Compare and contrast the page-fault-frequency (PFF)
      a. dynamic address mapping mechanisms                      page-replacement strategy with the working set (WS) page-
                                                                 replacement strategy. Be sure to consider each of the following:
      b. associative memory
                                                                        a. execution-time overhead
      c. direct-mapped cache memory
                                                                        b. memory overhead for holding the information neces-
      d. "page-referenced" bit                                             sary to support the strategy
      e. "page-modified" bit
                                                                 11.33 A possible weakness of the second-chance page-replace-
      f. "page-in-transit" bit (signifying that a page is cur-   ment strategy is that if the list of pages is short, then an active
         rently being input to a particular page frame)          page that has just moved to the back of the list after having had
                                                                 its referenced bit set off could quickly move to the front of the
11.30 If programs are carefully organized in a paged system so
                                                                 list and be selected for replacement before its referenced bit is
that references are highly localized to small groups of pages,
                                                                 set on. Comment on this phenomenon. Is it an anomaly in sec-
the resulting performance improvements can be impressive.
                                                                 ond-chance page replacement? Defend your answer carefully.
Most programs today are being written in high-level lan-
guages, however, so the programmer does not generally have       11.34 Suppose a system is not currently thrashing. List as
access to information rich enough to aid in producing pro-       many factors as you can that might cause it to begin thrashing.
grams with good organization. Because the path of execution a    What measures should the operating system take, once thrash-
program will take cannot be predicted, it is difficult to know   ing is detected? Can thrashing be absolutely prevented? If so,
precisely which sections of code will be used intensively.       at what cost? If not, explain why not.
       One hope for improving program organization is called     11.35 A- system receives a series of page references in the fol-
dynamic program restructuring. Here, the operating system        lowing order: 1, 1, 3, 5, 2, 2, 6, 8, 7, 6, 2, 1, 5, 5, 5, 1, 4, 9, 7, 7.
monitors the execution characteristics of a program, rearrang-   The system has five page frames. If all of the frames are ini-
ing the code and data so that the more active items are placed   tially empty, calculate the number of page faults using each of
together on pages.                                               these algorithms:
      a. What execution characteristics of a large program              a. FIFO
         should be monitored to facilitate dynamic program
                                                                        b. LRU
         restructuring?
                                                                        c. second chance
      b. How would a dynamic program restructuring mecha-
         nism use this information to make effective restruc-           d. OPT
         turing decisions?                                       11.36 Should a process be penalized for generating excessive
                                                                 page faults?
11.31 The key to the proper and efficient operation of the
page-fault-frequency (PFF) page-replacement strategy is the      11.37 Consider a process experiencing a large number of page
selection of the threshold interfault time values. Answer each   faults. Describe the effect, if any, of increasing this process's
of the following questions.                                      scheduling priority.



Suggested Projects
11.38 Some types of processes perform well under certain         dynamically determine a process's type and then select and use
page-replacement strategies and poorly under others. Discuss     the appropriate page-replacement strategy for that process.
the possibility of implementing a memory manager that would

<!-- pág. 572 -->

                                                                                               Recommended Reading             517

11.39 Suppose you are aware of the page-replacement strategy      11.40 Prepare a research paper that describes how Intel's Pen-
used by the multiuser timesharing system on which you are run-    tium 4 supports three different page sizes. How does the pro-
ning. For each of the page-replacement strategies discussed in    cessor choose which size to use? Also, is there any
this chapter, what countermeasures might you take to force the    communication between the TLBs?
operating system to give your process(es) favored treatment,      11.41 Prepare a research paper on hardware support for the
when in fact the operating system might normally do otherwise?    working set model.
What measures might an operating system take to detect such
processes and prevent them from obtaining such preferred
treatment? Prepare a paper describing your solution.

Suggested Simulations
11.42 Develop a simulator program that will enable you to         essentially random. Describe the optimal page-replacement
compare and contrast the operation of each of the page-           algorithm for each reference string. You might also wish to
replacement strategies discussed in this chapter. Your simula-    simulate the effect of multiprogramming by interleaving dif-
tor needs to be concerned with transitions between pages in       ferent reference patterns.
virtual space, but not with the instruction-by-instruction exe-
cution of programs. Assign a random but high probability to       11.44 Develop a program that simulates page-fault-frequency
the event of remaining on the same page on which the previ-       (PFF) page replacement for a particular reference string.
ous instruction was executed. When page transitions occur, the    Determine the effect of changing the threshold values each
probability of transferring to the next page (or the previous     time the program runs. Use reference strings that simulate spa-
page) in virtual space should be higher than that of transfer-    tial locality over both large and small regions of memory and
ring to some remote page. Assume a moderately loaded sys-         temporal locality over both large and small periods. Also test
tem so that page-replacement decisions are common. Assume         the simulation using reference strings that are essentially ran-
that the same replacement strategy applies to all processes on    dom. Describe the optimal page-replacement algorithm for
the system for a given run of the simulation. Your simulator      each reference string. Enhance your simulation so that it
should maintain statistics on the performance of each replace-    dynamically adjusts these values in response to the reference
ment strategy. Include features to enable you to fine-tune the    string it encounters.
simulator; i.e., you should be able to adjust the working set
window size, the page-fault-frequency threshold values, and so
                                                                  11.45 Develop a program that compares page-fault-frequency
on. When the simulator is completed, develop a new page-
                                                                  (PFF) page replacement and working set (WS) page replace-
replacement strategy and compare the results to those of the
                                                                  ment for a particular reference string. Determine the effect of
other strategies in the text.
                                                                  changing the threshold values for PFF and window size for WS
11.43 Develop a simulation program to investigate how chang-      each time the program runs. Use reference strings that simu-
ing the number of pages allocated to a process affects the num-   late spatial locality over both large and small regions of mem-
ber of page faults it experiences. Use reference strings that     ory and temporal locality over both large and small periods.
simulate spatial locality over both large and small regions of    Also test the simulation using reference strings that are essen-
memory and temporal locality over both large and small peri-      tially random. Describe the optimal page-replacement algo-
ods. Also test the simulation using reference strings that are    rithm for each reference string.


Recommended Reading
Owing to its wide application in operating system design, vir-    algorithms such as FIFO and approximations to LRU can be
:ual memory management is a rich field. Seminal papers, such      found as pieces of some memory management algorithms, typ-
as Denning's discussion of the working set model 88 and his       ically they are not used alone. More sophisticated algorithms
nummary of virtual memory concepts,89 offer a clear presenta-     involving graphs and coloring have been developed in the lit-
tion of the concerns in virtual memory management, most of        erature.94- 95 Morris discusses the use of custom hardware to
which are still valid today. Fetch policies were discussed by     make working set storage management more efficient.96
Aho et al.90 and further analyzed by Kaplan et al.91                     The question of the most appropriate page size has been
      Optimal page replacement was discussed by Belady,92         studied in the literature.97- 9 8 -" To meet different application
who also discovered the FIFO anomaly.93 Though common             needs, modern general-purpose processors have begun to sup-

<!-- pág. 573 -->

518    Virtual Memory Management

port multiple page sizes.100 Program behavior under paging              number of page faults.101, 102, 103, 104, 105, 106, 107, 108 The bibliogra-
continues to be the subject of many studies that seek to                phy for this chapter is located on our Web site at www.dei-
increase system throughput and performance by reducing the              tel.com/books/os3e/Bibliography.pdf.




Works Cited
 1. Denning, P. J., "The Working Set Model for Program Behavior,"       18. Mattson, R. L.; J. Gecsie; D. R. Slutz; and I. L. Traiger, "Evalua-
    Communications of the ACM, Vol. 11, No. 5, May 1968, pp. 323-           tion Techniques for Storage Hierarchies," IBM Systems Journal.
    333.                                                                    Vol. 9, No. 2,1970, pp. 78-117.
 2. Belady, L. A., "A Study of Replacement Algorithms for Virtual       19. Prieve, B. G, and R. S. Fabry, " V M I N - A n Optimal Variable
    Storage Computers," IBM Systems Journal, Vol. 5, No. 2, 1966,           Space Page Replacement Algorithm," Communications of the
    pp. 78-101.                                                             ACM, Vol. 19, No. 5, May 1976, pp. 295-297.
 3. Baer, X, and G. R. Sager, "Dynamic Improvement of Locality in       20. Budzinski, R.; E. Davidson; W. Mayeda; and H. Stone, "DMIN:
    Virtual Memory Systems," IEEE Transactions on Software Engi-            An Algorithm for Computing the Optimal Dynamic Allocation
    neering,Vol SE-1, March 1976, pp. 54-62.                                in a Virtual Memory Computer," IEEE Transactions on Software
 4. Aho, A. V; P. J. Denning; and J. D. Ullman, "Principles of Opti-        Engineering, Vol. SE-7,No. 1, January 1981, pp. 113-121.
    mal Page Replacement," Journal of the ACM, Vol. 18, No. 1, Jan-     21. Belady, L. A., and C J. Kuehner, "Dynamic Space Sharing in
    uary 1971, pp. 80-93.                                                   Computer Systems," Communications of the ACM, Vol. 12, No. 5.
 5. Minsky, M. L., Computation: Finite and Infinite Machines, Engle-        May 1969, pp. 282-288.
    wood Cliffs, NX: Prentice-Hall, 1967.                               22. Turner, R., and H. Levy, "Segmented FIFO Page Replacement."
 6. Hennie, E, Introduction to Computability, Reading, MA: Addi-            Proceedings of the 1981 ACM SIGMETR1CS Conference on Mea-
    son-Wesley, 1977.                                                       surement and Modeling of Computer Systems, 1981, pp. 48-51.
 7. Buzen, X P., "Fundamental Laws of Computer System Perfor-           23. Babaoglu, O., and W. Joy, "Converting a Swap-Based System to
    mance," Proceedings of the 1976 ACM SIGMETRICS Confer-                  Do Paging in an Architecture Lacking Page-Referenced Bits."
    ence on Computer Performance Modeling Measurement and                   Proceedings of the Eighth Symposium on Operating Systems
    Evaluation, 1976, pp. 200-210.                                          Principles, ACM, Vol. 15, No. 5, December 1981, pp. 78-86.
 8. Randell, B., and C. X Kuehner, "Dynamic Storage Allocation          24. Carr, R. W., Virtual Memory Management. UMI Research Press
    Systems," CACM, Vol. 11, No. 5, May 1968, pp. 297-306.                  1984.
 9. Lorin, H., and H. Deitel, Operating Systems, Reading, MA: Add-      25. Borodin, A.; S. Irani; P. Raghavan; and B. Schieber, "Competitive
    ison-Wesley, 1981.                                                      Paging with Locality of Reference," in Proceedings of the 23rd
10. Trivedi, K. S., "Prepaging and Applications to Array Algorithms,"       Annual ACM Symposium on Theory of Computing, New
    IEEE Transactions on Computers,Vol. C-25, September 1976, pp.           Orleans, Louisiana, May 1991, pp. 249-259.
    915-921.                                                            26. Irani, S.; A. Karlin; and S. Phillips, "Strongly Competitive Algo-
11. Smith, A. X, "Sequential Program Prefetching in Memory Hier-            rithms for Paging with Locality of Reference," Proceedings of the
    archies," Computer,Vo\. 11,No. 12, December 1978, pp. 7-21.             Third Annual ACM-SIAM Symposium on Discrete Algorithms.
12. Trivedi, K. S., "Prepaging and Applications to Array Algorithms,"       1992, pp. 228-236.
    IEEE Transactions on Computers, Vol. C-25, September 1976, pp.      27. Albers, S.; L. Favrholdt; and O. Giel, "On Paging with Locality of
    915-921.                                                                Reference," Proceedings of the Thirty-Fourth Annual ACM Sym-
13. Kaplan, S., et al, "Adaptive Caching for Demand Prepaging,"             posium on Theory of Computation, 2002, pp. 258-267.
    Proceedings of the Third International Symposium on Memory          28. Fiat, A., and Z. Rosen, "Experimental Studies of Access Graph
    Management, 2002, pp. 114-116.                                          Based Heuristics: Beating the LRU Standard?" in Proceedings of
14. Linux            Source,        <lxr.linux.no/source/mm/mem-            the Eighth Annual ACM-SIAM Symposium on Discrete Algo-
    ory.c?v=2.5.56>, l i n e 1010 (swapin_readahead).                       rithms, New Orleans, Louisiana, January 1997, pp. 63-72.
15. Linux Source, <lxr.linux.no/source/mm/swap.c?v=2.6.0-               29. Fiat, A., and Z. Rosen, "Experimental Studies of Access Graph
    test2>, line 100 (swap_setup).                                          Based Heuristics: Beating the LRU Standard?" In Proceedings
16. Belady, L. A., "A Study of Replacement Algorithms for Virtual           of the Eighth Annual ACM-SIAM Symposium on Discrete Algo-
    Storage Computers," IBM Systems Journal, Vol. 5, No. 2, 1966,           rithms, New Orleans, Louisiana, January 1997, pp. 63-72.
    pp. 78-101.                                                         30. Denning, P. J., "The Working Set Model for Program Behavior."
17. Denning, P. X, "Virtual Memory," ACM Computing Surveys, Vol.            Communications of the ACM, Vol. 11, No. 5, May 1968, pp. 323-
    2, No. 3, September 1970, pp. 153-189.                                  333.

<!-- pág. 574 -->

                                                                                                                      Works Cited 519
31. Denning, P. X, "Resource Allocation in Multiprocess Computer         48. Batson, A. P.; S. Ju; and D. Wood, "Measurements of Segment
    Systems," Ph.D. Thesis, Report MAC-TR-50 M.I.T. Project                  Size," Communications of the ACM, Vol. 13, No. 3, March 1970,
    MAC, May 1968.                                                           pp. 155-159.
32. Hatfield, D, "Experiments on Page Size, Program Access Pat-          49. Chu, W. W., and H. Opderbeck, "Performance of Replacement
    terns, and Virtual Memory Performance," IBM Journal of                   Algorithms with Different Page Sizes," Computer, Vol. 7, No. 11,
    Research and Development, Vol. 15, No. 1, January 1972, pp. 58-          November 1974, pp. 14-21.
    62.                                                                  50. Denning, P. X, "Working Sets Past and Present," IEEE Transac-
33. Denning, P. X, "The Working Set Model for Program Behavior,"             tions on Software Engineering, Vol. SE-6, No. 1, January 1980, pp.
    Communications of the ACM, Vol. 11, No. 5, May 1968, pp. 323-            64-84.
    333.                                                                 51. Ganapathy, N, and C. Schimmel, "General Purpose Operating
34. Denning, P. X, "Working Sets Past and Present," IEEE Transac-            System Support for Multiple Page Sizes," Proceedings of the
    tions on Software Engineering, Vol. SE-6, No. 1, January 1980, pp.       USENIX Conference, 1998.
    64-84.                                                               52. Talluri, M.; S. Kong; M. D. Hill; and D. A. Patterson, "Tradeoffs
                                                                             in Supporting Two Page Sizes," in Proceedings of the 19th Inter-
35. Denning, P. X, "Thrashing: Its Causes and Preventions," AFIPS
                                                                             national Symposium on Computer Architecture, Gold Coast, Aus-
    Conference Proceedings,\o\. 33,1968 FJCC, pp. 915-922.
                                                                             tralia, May 1992, pp. 415-424.
36. Rodriguez-Rosell, X, "Empirical Working Set Behavior," Com-
                                                                         53. Talluri, M.; S. Kong; M. D. Hill; and D. A. Patterson, "Tradeoffs
    munications oftheACM,Vo\. 16, No. 9,1973, pp. 556-560.                   in Supporting Two Page Sizes," in Proceedings of the 19th Inter-
37. Fogel, M., "The VMOS Paging Algorithm: A Practical Imple-                national Symposium on Computer Architecture, Gold Coast, Aus-
    mentation of the Working Set Model," Operating Systems                   tralia, May 1992, pp. 415-424.
    Review, Vol. 8, No. 1, Xanuary 1974, pp. 8-16.                       54. McNamee, D., "Flexible Physical Memory Management,"
38. Levy, H. M., and P. H. Lipman, "Virtual Memory Management in             Department of Computer Science and Engineering, University
    the VAX/VMS Operating System," Computer, Vol. 15, No. 3,                 of Washington, September 1995.
    March 1982, pp. 35-41.                                               55. Talluri, M.; S. Kong; M. D. Hill; and D. A. Patterson, "Tradeoffs
39. Kenah, L. X; R. E. Goldenberg; and S. F. Bate, VAXNMS Inter-             in Supporting Two Page Sizes," in Proceedings of the 19th Inter-
    nals and Data Structures, Bedford, MA: Digital Press, 1988.              national Symposium on Computer Architecture, Gold Coast, Aus-
                                                                             tralia, May 1992, pp. 415-424.
40. Bryant, P., "Predicting Working Set Sizes," IBM Journal of
    Research and Development, Vol. 19, No. 3, May 1975, pp. 221-         56. IA-32 Intel Architecture Software Developer's Manual, Vol. 3, Sys-
    229.                                                                     tem Programmer's Guide, Intel, 2002, p. 3-19.
                                                                         57. "UltraSPARC II Detailed View," Modified July 29, 2003,
41. Morris, X B., "Demand Paging through the Use of Working Sets
                                                                             <www.sun.com/processors/intraSPARC-II/detai1s.html>.
    on the Maniac II," Communications of the ACM, Vol. 15, No. 10,
    October 1972, pp. 867-872.                                           58. PowerPC Microprocessor Family: Programming Environments
                                                                             Manual for 64 and 32-Bit Microprocessors, Version 2.0, IBM,
42. Chu, W W, and H. Opderbeck, "Hie Page Fault Frequency
                                                                             June 10,2003, pp. 258,282.
    Replacement Algorithm," Proceedings AFIPS Fall Joint Com-
    puter Conference, Vol. 41, No. 1,1972, pp. 597-609.                  59. Belady, L. A., "A Study of Replacement Algorithms for Virtual
                                                                             Storage Computers," IBM Systems Journal, Vol. 5, No. 2, 1966,
43. Opderdeck, H., and W. W. Chu, "Performance of the Page Fault             pp. 78-101.
    Frequency Algorithm in a Multiprogramming Environment,"
                                                                         60. Fine, E. G; C. W Jackson; and P. V Mclsaac, "Dynamic Program
    Proceedings oflFIP Congress, 191 A, pp. 235-241.
                                                                             Behavior under Paging," ACM 21st National Conference Pro-
44. Sadeh, E., "An Analysis of the Performance of the Page Fault             ceedings, 1966, pp. 223-228.
    Frequency (PFF) Replacement Algorithm," Proceedings of the
                                                                         61. Coffman, E. G, Jr., and L. C. Varian, "Further Experimental
    Fifth ACM Symposium on Operating Systems Principles, Novem-              Data on the Behavior of Programs in a Paging Environment,"
    ber 1975, pp. 6-13.                                                      Communications of the ACM, Vol. 11, No. 7, July 1968, pp. 471-
45. Chu, W W., and H. Opderbeck, "Program Behavior and the                   474.
    Page-Fault-Frequency Replacement Algorithm," Computer, Vol.          62. Freibergs, I. F, "The Dynamic Behavior of Programs," Proceed-
    9, No. 11, November 1976, pp. 29-38.                                     ings AFIPS Fall Joint Computer Conference, Vol. 33, Part 2,1968,
46. Gupta, R. K., and M. A. Franklin, "Working Set and Page Fault            pp. 1163-1167.
    Frequency Replacement Algorithms: A Performance Compari-             63. Hatfield, D., "Experiments on Page Size, Program Access Patterns,
    son," IEEE Transactions on Computers, Vol. C-27, August 1978,            and Virtual Memory Performance," IBM Journal of Research and
    pp. 706-712.                                                             Development,Vo\. 15, No. 1, January 1972, pp. 58-62.
47. Ganapathy, N, and C. Schimmel, "General Purpose Operating            64. Freibergs, I. F., "The Dynamic Behavior of Programs," Proceed-
    System Support for Multiple Page Sizes," Proceedings of the              ings AFIPS Fall Joint Computer Conference, Vol. 33, Part 2,1968,
    USENIXConference,1998.                                                   pp. 1163-1167.

<!-- pág. 575 -->

520    Virtual Memory Management
65. Spirn, J. R., and P. J. Denning, "Experiments with Program Local-    81. Franklin, M. A.; G. S. Graham; and R. K. Gupta, "Anomalies
    ity," AFIPS Conference Proceedings, Vol. 41,1972 FJCC, pp. 611-          with Variable Partition Paging Algorithms," Communications of
    621.                                                                     the ACM, Vol. 21, No. 3, March 1978, pp. 232-236.
66. Morrison, J. E., "User Program Performance in Virtual Storage        82. Glass, G., and Pei Cao, 'Adaptive Page Replacement Based on
    Systems," IBM Systems Journal, Vol. 12, No. 3,1973, pp. 216-237.         Memory Reference Behavior," Proceedings of the 1997 ACM
                                                                             SIGMETRICS International Conference on Measurement and
67. Rodriguez-Rosell, J. "Empirical Working Set Behavior," Com-
                                                                             Modeling of Computer Systems, p.115-126, June 15-18, 199".
    munications oftheACM,Vol. 16, No. 9,1973, pp. 556-560.
                                                                             Seattle, Washington, United States.
68. Chu, W. W., and H. Opderbeck, "Performance of Replacement
                                                                         83. Glass, G, and Pei Cao, "Adaptive Page Replacement Based or.
    Algorithms with Different Page Sizes," Computer, Vol. 7, No. 11,
                                                                             Memory Reference Behavior," Proceedings of the 1997 ACM
    November 1974, pp. 14-21.
                                                                             SIGMETRICS International Conference on Measurement and
69. Oliver, N. A., "Experimental Data on Page Replacement Algo-              Modeling of Computer Systems, p.115-126, June 15-18, 199".
    rithms," Proceedings of AFIPS, 1974 NCC 43, Montvale, NX:                Seattle, Washington, United States.
    AFIPS Press, 1974, pp. 179-184.
                                                                         84. A. Arcangeli, "Le novita' nel Kernel Linux," December 7, 2001.
70. Opderdeck, H., and W. W. Chu, "Performance of the Page Fault             <old.lwn.net/2001/1213/aa-vm-talk/mgp00001.html>.
    Frequency Algorithm in a Multiprogramming Environment,"              85. A. Arcangeli, "Le novita' nel Kernel Linux," December 7, 2001.
    Proceedings oflFIP Congress, 191 A, pp. 235-241.                         <old.lwn.net/2001/1213/aa-vm-talk/mgp00001.html >.
71. Sadeh, E., "An Analysis of the Performance of the Page Fault         86. Linux kernel source code version 2.5.75, < w w w . k e r n e l .org>.
    Frequency (PFF) Replacement Algorithm," Proceedings of the           87. Linux kernel source code version 2.5.75, < w w w . k e r n e l .org>.
    Fifth ACM Symposium on Operating Systems Principles, Novem-
                                                                         88. Denning, P. J, "The Working Set Model for Program Behavior."
    ber 1975, pp. 6-13.
                                                                             Communications of the ACM, Vol. 11, No. 5, May 1968, pp. 323-
72. Baer, I, and G. R. Sager, "Dynamic Improvement of Locality in            333.
    Virtual Memory Systems," IEEE Transactions on Software Engi-
                                                                         89. Denning, P. J, "Virtual Memory," ACM Computing Surveys, Vol.
    neering^. SE-1, March 1976, pp. 54-62.
                                                                             2, No. 3, September 1970, pp. 153-189.
73. Potier, D., "Analysis of Demand Paging Policies with Swapped         90. Aho, A. V; P. J. Denning; and J. D. Ullman, "Principles of Opti-
    Working Sets," Proceedings of the Sixth ACM Symposium on                 mal Page Replacement," Journal of the ACM, Vol. 18, No. 1, Jan-
    Operating Systems Principles, November 1977, pp. 125-131.                uary 1971, pp. 80-93.
74. Franklin, M. A.; G. S. Graham; and R. K. Gupta, "Anomalies           91. Kaplan, S., et al., "Adaptive Caching for Demand Prepaging.
    with Variable Partition Paging Algorithms," Communications of            Proceedings of the Third International Symposium on Memor-.
    theACM,Vol. 21, No. 3, March 1978, pp. 232-236.                          Management, 2002, pp. 114-116.
75. Gupta, R. K., and M. A. Franklin, "Working Set and Page Fault        92. Belady, L. A., "A Study of Replacement Algorithms for Virtual
    Frequency Replacement Algorithms: A Performance Compari-                 Storage Computers," IBM Systems lournal, Vol. 5, No. 2, 196f\
    son," IEEE Transactions on Computers, Vol. C-27, August 1978,            pp. 78-101.
    pp. 706-712.
                                                                         93. Belady, L. A., and C. J. Kuehner, "Dynamic Space Sharing in
76. Denning, P. I, "Working Sets Past and Present," IEEE Transac-            Computer Systems," Communications of the ACM,No\. 12, No. 5.
    tions on Software Engineering,Vo\. SE-6, No. 1, January 1980, pp.        May 1969, pp. 282-288.
    64-84.                                                               94. Irani, S.; A. Karlin; and S. Phillips, "Strongly Competitive Algo-
77. Irani, S.; A. Karlin; and S. Phillips, "Strongly Competitive Algo-       rithms for Paging with Locality of Reference," Proceedings of the
    rithms for Paging with Locality of Reference," Proceedings of the        Third Annual ACM-SIAM Symposium on Discrete Algorithms.
    Third Annual ACM-SIAM Symposium on Discrete Algorithms,                  1992, pp. 228-236.
    1992, pp. 228-236.                                                   95. Albers, S.; L. Favrholdt; and O. Giel, "On Paging with Locality 0:
78. Glass, G, and Pei Cao, "Adaptive Page Replacement Based on               Reference," Proceedings of the 34th Annual ACM Symposium or.
    Memory Reference Behavior," Proceedings of the 1997 ACM                  Theory of Computation, 2002, pp. 258-267.
    SIGMETRICS International Conference on Measurement and               96. Morris, J. B., "Demand Paging through the Use of Working Seb
    Modeling of Computer Systems, pp. 115-126, June 15-18, 1997,             on the Maniac II," Communications of the ACM,\'ol. 15, No. 10.
    Seattle, Washington.                                                     October 1972, pp. 867-872.
79. Ganapathy, N, and C. Schimmel, "General Purpose Operating            97. Batson, A. P.; S. Ju; and D. Wood, "Measurements of Segmen:
    System Support for Multiple Page Sizes," Proceedings of the              Size," Communications of the ACM, Vol. 13, No. 3, March 1970.
    USENIXConference,1998.                                                   pp. 155-159.
80. Albers, S.; L. Favrholdt; and O. Giel, "On Paging with Locality of   98. Chu, W. W., and H. Opderbeck, "Performance of Replacement
    Reference," Proceedings of the 34th Annual ACM Symposium on              Algorithms with Different Page Sizes," Computer, Vol. 7, No. 11.
    Theory of Computation, 2002, pp. 258-267.                                November 1974, pp. 14-21.

<!-- pág. 576 -->

                                                                                                                      Works Cited 521
99- Denning, P. J., "Working Sets Past and Present," IEEE Transac-            Fifth ACM Symposium on Operating Systems Principles, Novem-
     tions on Software Engineering,Vol. SE-6, No. 1, January 1980, pp.        ber 1975, pp. 6-13.
     64-84.
                                                                         105. Gupta, R. K., and M. A. Franklin, "Working Set and Page Fault
100. Ganapathy, N., and C. Schimmel, "General Purpose Operating               Frequency Replacement Algorithms: A Performance Compari-
     System Support for Multiple Page Sizes," Proceedings of the              son," IEEE Transactions on Computers, Vol. C-27, August 1978,
     USENIX Conference, 1998.                                                 pp. 706-712.
101. Freibergs, I. E, "The Dynamic Behavior of Programs," Proceed-
     ings AFIPS Fall Joint Computer Conference, Vol. 33, Part 2,1968,    106. Denning, P. J., "Working Sets Past and Present," IEEE Transac-
     pp. 1163-1167.                                                           tions on Software Engineering, Vol. SE-6, No. 1, January 1980, pp.
                                                                              64-84.
102. Hatfield, D, "Experiments on Page Size, Program Access Pat-
     terns, and Virtual Memory Performance," IBM Journal of              107. Irani, S.; A. Karlin; and S. Phillips, "Strongly Competitive Algo-
     Research and Development, Vol. 15, No. 1, January 1972, pp. 58-          rithms for Paging with Locality of Reference," Proceedings of the
     62.                                                                      Third Annual ACM-SIAM Symposium on Discrete Algorithms,
103. Morrison, J. E., "User Program Performance in Virtual Storage            1992, pp. 228-236.
     Systems," IBM Systems Journal,Vol. 12, No. 3,1973, pp. 216-237.     108. Albers, S.; L. Favrholdts; and O. Giel, "On Paging with Locality
104. Sadeh, E., "An Analysis of the Performance of the Page Fault             of Reference," Proceedings of the 34th Annual ACM Symposium
     Frequency (PFF) Replacement Algorithm," Proceedings of the               on Theory of Computation, 2002, pp. 258-267.

