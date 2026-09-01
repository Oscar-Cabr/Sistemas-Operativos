# Chapter 10 - Virtual Memory Organization

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 468–531 (numeración del PDF)

<!-- pág. 468 -->

Chapter 10


Virtual Memory
           Organization
 Objectives
 After reading this chapter, you should understand:
 • the concept of virtual memory.
 • paged virtual memory systems.
 • segmented virtual memory systems.
 • combined segmentation/paging virtual memory systems.
 • sharing and protection in virtual memory systems.
 • the hardware that makes virtual memory systems feasible.
 • the IA-32 Intel architecture virtual memory implementation.

<!-- pág. 469 -->

                                       Chapter Outline

                           10.1                                     10.4.5 Inverted Page Tables
                   Introduction                              10.4.6 Sharing in a Paging System
            Mini Case Study: Atlas                          Operating Systems Thinking: Lazy
          Operating Systems Thinking:                                        Allocation
                      Virtualization
         Biographical Note: Peter Denning                                      10.5
                                                                        Segmentation
                           10.2                            10.5.1     Segmentation Address Translation
            Virtual Memory: Basic                                        by Direct Mapping
                   Concepts                               10.5.2 Sharing in a Segmentation System
      Anecdote: Virtual Memory Unnecessary                 10.5.3 Protection and Access Control in
                                                                       Segmentation Systems
                      10.3
                  Block Mapping                                                10.6
                                                            Segmentation/Paging Systems
                                                           10.6.1 Dynamic Address Translation in a
                           10.4                                     Segmentation/Paging   System
                          Paging                             1 0 . 6 . 2 Sharing and Protection in a
        10.4.1 Paging Address Translation by                        Segmentation/Paging System
                    Direct Mapping
        10.4.2   Paging    Address Translation by                       10.7
                  Associative   Mapping
                                                              Case Study: IA-32 Intel
       10.4.3 Paging Address Translation with               Architecture Virtual Memory
             Direct/Associative Mapping
                                                            Mini Case Study: IBM Mainframe
          Operating Systems Thinking:                                   Operating Systems
      Empirical Results: Locality-Based Heuristics         Mini Case Study: Early History of the
            10.4.4 Multilevel Page Tables                              VM Operating System




          Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited



414

<!-- pág. 470 -->

                                                                                            10.1 Introduction 415

10.1 Introduction
In the preceding chapter, we discussed basic memory management techniques, each
 of which ultimately must contend with limited memory space. One solution is larger
main memories; however, it is often prohibitively expensive to build systems with suf-
ficiently large fast-access memory. Another solution would be to create the illusion
that more memory exists. This is a fundamental idea behind virtual memory,1, 2, 3
which first appeared in the Atlas computer system constructed at the University of
Manchester in England in 1960 (see the Mini Case Study, Atlas). 4, 5, 6, 7 Figure 10.1
shows how memory organizations have evolved from single-user real memory sys-
tems to multiuser, segmentation/paging virtual memory systems.
     This chapter describes how a system implements virtual memory (see the
 Operating Systems Thinking feature, Virtualization). Specifically, we present the
techniques the operating system and the hardware use to convert virtual addresses
to physical addresses; and we discuss the two most common noncontiguous alloca-



                Mini Case Study
 Atlas
  The Atlas project began in 1956 at           The Atlas Supervisor operat-     three Atlas computers were ever
  the University of Manchester,          ing system was the first to imple-     sold, the last in 1965, only three
  England. The project, originally       ment virtual memory. 10 Setting a      years after its completion. 1 4 A
  called the MUSE (short for micro-      new standard for job throughput,       contributing factor to Atlas's
  SEcond; "micro" is represented by      the Atlas Supervisor was able to       short lifetime was that its pro-
  the Greek letter " m u " ) , was       execute 16 jobs at once. 11 It also    grams had to be written in Atlas
  launched to compete w i t h the        provided its operators with            Autocode, a language much like
  high-performance computers             detailed runtime statistics,           Algol 60, but not accepted by
  being produced by the United           whereas most other systems             most programmers. 15 Atlas's
  States.8 In 1959, Ferranti Ltd.        required operators to determine        designers were eventually forced
  joined the project as a corporate      them manually. The Atlas Supervi-      to implement more popular lan-
  sponsor, and the first Atlas com-      sor was also one of the earliest       guages such as Fortran. 16 Another
  puter was completed at the end         computers to design detailed           reason for Atlas's quick demise
  of 1962.9 Though the Atlas com-        hardware guidelines in early           was that limited resources were
  puter was produced for only            stages of development to simply        devoted to developing it. A year
  about 10 years, it made significant    systems programming. 1 2               after Atlas's release, ICT bought
  contributions computing technol-            Although Atlas was the most       Ferranti's computer projects. ICT
  ogy. Many of these appeared in         powerful computer when it was          discontinued Atlas in favor of its
  the computer's operating system,       completed in 1962, it was mostly       o w n series of computers known as
  the Atlas Supervisor.                  ignored by the industry. 13 Only       the 1900s.17

<!-- pág. 471 -->

416 Virtual Memory Organization




                                Figure    10.1 | Evolution of memory organizations.

                                tion techniques—paging and segmentation. Address translation and noncontiguous
                                allocation enable virtual memory systems to create the illusion of a larger memory
                                and to increase the degree of multiprogramming. In the next chapter we focus on
                                how a system manages the processes in virtual memory to optimize performance.
                                Much of the information is based on Denning's survey on virtual memory (see the
                                Biographical Note, Peter Denning).18




               Operating Systems Thinking
    Virtualization
   We will see many examples in this      from the underlying hardware.        plexity from users, who instead
   book of how software can be            The Java virtual machine enables     see a simpler, easier-to-use virtual
   used to make resources appear          programmers to develop porta-        machine defined by the operating
   different than they really are. This   ble applications that will run on    system. Virtualization is common
   is called virtualization. We will      different computers running dif-     in distributed systems, which we
   study virtual memories that            ferent operating systems (and        cover in detail in Chapters 17 and
   appear to be far larger than the       hardware). Virtualization is yet     18. Distributed operating systems
   physical memory that is installed      another way of using abundant        create the illusion of there being
   on the underlying computer. We         processor power to provide           a single large machine when in
   will study virtual machines, which     intriguing benefits to computer      fact massive numbers of comput-
   create the illusion that the com-      users. As computers become more      ers and other resources are inter-
   puter being used to execute appli-     complex, virtualization tech-        connected in complex ways across
   cations is really quite different      niques can help hide that com-       networks like the Internet.

<!-- pág. 472 -->

                                                                                                      10.1 Introduction 417

      At the end of this chapter (just before the Web Resources section), you will
find two operating systems Mini Case Studies—IBM Mainframe Operating Systems
 and Early History of the VM Operating System. As you finish reading this chapter,
  you will have studied the evolution of both real memory and virtual memory orga-
nizations. The history of IBM mainframe operating systems closely follows this evo-
 lution.

Self Review
1. Give an example of when it might be inefficient to load an entire program into memory
   before running it.
2. Why is increasing the size of main memory an insufficient solution to the problem of lim-
   ited memory space?
Ans: 1) Many programs have error-processing functions that are rarely, if ever, used. Load-
 ing these functions into memory reduces space available to processes. 2) Purchasing addi-
tional main memory is not always economically feasible. As we will see, a better solution is to
create the illusion that the system contains more memory than the process will ever need.




                Biographical Note
  Peter Denning
   Peter J. Denning is best known for         most of their time using only a            School. He has published hun-
   his work on virtual memory in the          small subset of their virtual mem-         dreds of articles and several books
   1960s. One of his most important           ory pages, which he called the             on computer science topics and
   papers, "The Working Set Model             working set. A program's working           was president of the ACM from
   for Program Behavior," was pub-            set changes from time to time as           1980-1982. 21
   lished in 1968, the same year he           program execution moves along                     Denning has made signifi-
   received his Ph.D. in Computer             its phases. He proposed that a             cant contributions to computer
   Science from MIT.19 This paper             program will run efficiently if its        science education. He w o n several
   introduced the concept of work-            current working set is kept in             teaching awards, managed the
   ing sets (discussed in Section 11.7,       main memory at all times.                  creation of the ACM Digital
   Working Set Model) for use in vir-              Denning has since taught at           Library (an online collection of
   tual memory management and                 Princeton University, founded the          articles from ACM journals) and
   explained why the use of working           Research Institute for Advanced            chaired the ACM Education Board
   sets leads to a page-replacement           Computer Science at the NASA               which publishes the ACM curricu-
   could improve performance over             Ames Research Center and led the           lum. 22 He has also been recog-
   other replacement schemes.20               computer science departments of            nized for his efforts to educate
   Denning's theory is based on               Purdue, George Mason University            the nontechnical community
   observations that programs spend           and now the Naval Postgraduate             about computer science topics. 23

<!-- pág. 473 -->

418 Virtual Memory Organization

                                 10.2 Virtual Memory: Basic Concepts
                                 As we discussed in the previous section, virtual memory systems provide processes
                                 with the illusion that they have more memory than is built into the computer (see
                                 the Anecdote, Virtual Memory Unnecessary). Thus, there are two types of
                                 addresses in virtual memory systems: those referenced by processes and those
                                 available in main memory. The addresses that processes reference are called virtual
                                 addresses. Those available in main memory are called physical (or real) addresses.
                                 [Note: In this chapter we use the terms "physical address," "real address" and "main
                                 memory address" interchangeably]
                                       Whenever a process accesses a virtual address, the system must translate it to
                                 a real address. This happens so often that using a general-purpose processor to per-
                                 form such translations would severely degrade system performance. Thus, virtual
                                 memory systems contain special-purpose hardware called the memory manage-
                                 ment unit (MMU) that quickly maps virtual addresses to real addresses.
                                       A process's virtual address space, V, is the range of virtual addresses that the
                                 process may reference. The range of real addresses available on a particular com-
                                 puter system is called that computer's real address space, R. The number of
                                 addresses in V is denoted |V|, and the number of addresses in R is denoted |R|. In
                                 virtual memory systems, it is normally the case that |V| >> \R\ (i.e., the virtual
                                 address space is much larger than the real address space).
                                       If we are to permit a user's virtual address space to be larger than its real
                                 address space, we must provide a means for retaining programs and data in a large
                                 auxiliary storage. A system normally accomplishes this goal by employing a two-
                                 level storage scheme (Fig. 10.2). One level is the main memory (and caches) in
                                 which in which instructions and data must reside to be accessed by a processor run-
                                 ning a process. The other level is secondary storage, which consists of large-capacity




                Anecdote
    Virtual Memory Unnecessary
    When the concept of virtual mem-       million words of memory. That          thousand times that much main
    ory was first introduced, designers    was thought to be absurd, so           memory and the vast majority of
    mused that virtual memory sys-         work proceeded on building vir-        these systems employ virtual
    tems would never be needed if          tual memory systems. Many of           memory.
    computers could be built w i t h a     today's desktop systems have a


    Lesson to operating systems designers: Take Moore's Law seriously. Hardware capabilities will continue to
    improve at an exponential pace and software requirements will increase as fast.

<!-- pág. 474 -->

                                                                        10.2 Virtual Memory: Basic Concepts 419




Figure 10.2 | Two-level storage.

storage media (typically disks) capable of holding the programs and data that can-
not all fit into the limited main memory.
      When the system is ready to run a process, the system loads the process's code
and data from secondary storage into main memory. Only a small portion of these
needs to be in main memory at once for the process to execute. Figure 10.3 illus-
trates a two-level storage system in which items from various processes' virtual
memory spaces have been placed in main memory.
      A key to implementing virtual memory systems is how to map virtual
addresses to physical addresses. Because processes reference only virtual addresses,
but must execute in main memory, the system must map (i.e., translate) virtual
addresses to physical addresses as processes execute (Fig. 10.4). The system must
perform the translation quickly, otherwise the performance of the computer system
would degrade, nullifying the gains associated with virtual memory.
      Dynamic address translation (DAT) mechanisms convert virtual addresses to
physical addresses during execution. Systems that use dynamic address translation
exhibit the property that the contiguous addresses in a process's virtual address
space need not be contiguous in physical memory —this is called artificial contiguity
(Fig. 10.5).24 Dynamic address translation and artificial contiguity free the program-
mer from concerns about memory placement (e.g., the programmer need not create
overlays to ensure the system can execute the program). The programmer can con-
centrate on algorithm efficiency and program structure, rather than on the underly-
ing hardware structure. The computer is (or can be) viewed in a logical sense as an
implementor of algorithms rather than in a physical sense as a device with unique
characteristics, some of which may impede the program development process.

<!-- pág. 475 -->

420 Virtual Memory Organization




                           Figure 10.3 | Pieces of address spaces exist in memory and in secondary storage.

                           Self Review
                           1. Explain the difference between a process's virtual address space and the system's physical
                              address space.
                           2. Explain the appeal of artificial contiguity.
                          Ans: 1) A process's virtual address space refers to the set of addresses a process may refer-
                          ence to access memory when running on a virtual memory system. Processes do not see phys-
                          ical addresses, which locate physical locations in main memory. 2) Artificial contiguity
                          simplifies programming by enabling a process to reference its memory as if it were contigu-
                          ous, even though its data and instructions may be scattered throughout main memory.



                           10.3 Block Mapping
                           Dynamic address translation mechanisms must maintain address translation maps
                           indicating which regions of a process's virtual address space, V, are currently in
                           main memory and where they are located. If this mapping had to contain entries for
                           every address in V, then the mapping information would require more space than is
                           available in main memory, so this is infeasible. In fact, the amount of mapping infor-
                           mation must be only a small fraction of main memory, otherwise it would take up
                           too much of the memory needed by the operating system and user processes.

<!-- pág. 476 -->

                                                                                              10.3 Block Mapping 421




Figure 10.4 | Mapping virtual addresses to real addresses.

      The most widely implemented solution is to group information in blocks; the
system then keeps track of where in main memory each virtual memory block has
been placed. The larger the average block size, the smaller the amount of mapping
 information. Larger blocks, however, can lead to internal fragmentation and can
take longer to transfer between secondary storage and main memory.
      There is some question as to whether the blocks should be all the same size or
 of different sizes. When blocks are a fixed size (or several fixed sizes), they are
called pages and the associated virtual memory organization is called paging. When
blocks may be of different sizes, they are called segments, and the associated virtual
memory organization is called segmentation.25-26 Some systems combine the two
techniques, implementing segments as variable-size blocks composed of fixed-size
pages. We discuss paging and segmentation in detail in the following sections.
      In a virtual memory system with block mapping, the system represents
 addresses as ordered pairs. To refer to a particular item in the process's virtual
 address space, a process specifies the block in which the item resides and the displace-
ment (or offset) of the item from the start of the block (Fig. 10.6). A virtual address, v,
is denoted by an ordered pair (b, d), where b is the block number in which the refer-
enced item resides, and d is the displacement from the start of the block.

<!-- pág. 477 -->

422 Virtual Memory Organization




                           Figure 10.5 | Artificial contiguity.




                           Figure 10. 6 | Virtual address format in a block mapping system.

                                 The translation from a virtual memory address v = (b, d) to a real memory
                           address, r, proceeds as follows (Fig. 10.7). The system maintains in memory a block
                           map table for each process. The process's block map table contains one entry for each
                           block of the process, and the entries are kept in sequential order (i.e., the entry for
                           block 0 precedes that for block 1, etc.). At context-switch time, the system determines
                           the real address, a, that corresponds to the address in main memory of the new pro-
                           cess's block map table. The system loads this address into a high-speed special-pur-
                           pose register called the block map table origin register. During execution, the process
                           references a virtual address v = (b, d). The system adds the block number, b, to the
                           base address, a, of the process's block map table to form the real address of the entry
                           for block b in the block map table. [Note: For simplicity, we assume that the size of
                           each entry in the block map table is fixed and that each address in memory stores an
                           entry of that size.] This entry contains the address, b', for the start of block b in main

<!-- pág. 478 -->

                                                                                              10.3   Block   Mapping   423




Figure 10.7 | Virtual address translation with block mapping.

memory. The system then adds the displacement, d, to the block start address, b', to
form the desired real address, r. Thus, the system computes the real address, r, from
the virtual address, v = (b, d), through the equation r = b' + d, where b' is stored in the
 block map table cell located at real memory address a + b.
      The block mapping techniques employed in segmentation, paging and com-
bined segmentation/paging systems are all similar to the mapping shown in
Fig. 10.7. It is important to note that block mapping is performed dynamically by
high-speed, special-purpose hardware as a process runs. If not implemented effi-
ciently, this technique's overhead could cause performance degradation that would
negate much of the benefit of using virtual memory. For example, the two additions
 indicated in Fig. 10.7 must execute much faster than conventional machine-lan-
guage add instructions. They are performed within the execution of each machine-
  language instruction for each virtual address reference. If the additions took as long
as machine-language adds, then the computer might run at only a small fraction of
the speed of a purely real-memory-based computer. Similarly, the block address
 translation mechanism must access entries in the block mapping table much faster
than other information in memory. The system normally places entries from the
block mapping table in a high-speed cache to dramatically decrease the time
needed to retrieve them.

<!-- pág. 479 -->

424   Virtual   Memory   Organization

                                Self Review
                                1. Suppose a block mapping system represents a virtual address v = (b, d) using 32 bits. If
                                   block displacement, d, is specified using n bits, how many blocks does the virtual address
                                   space contain? Discuss how setting n = 6, n = 12 and n = 24 affects memory fragmentation
                                   and the overhead incurred by mapping information.
                                2. Why is the start address of a process's block map table, a, placed in a special high-speed
                                   register?
                                Ans: 1) The system will have 232-n blocks. If n = 6, then the block size would be small and
                                there would be limited internal fragmentation, but the number of blocks would be so large as
                                to make implementation infeasible. If n = 24, then the block size would be large and there
                                would be significant internal fragmentation, but the block mapping table would not consume
                                much memory at all. If n = 12, the system achieves a balance between moderate internal frag-
                                mentation and a reasonably sized block map table. Over the years, n = 12 has been quite pop-
                                ular in paging systems, yielding a page size of 212 = 4,096 bytes, as we will see in Chapter 11.
                                Virtual Memory Management. 2) Placing a in a high-speed register facilitates fast address
                                 translation, which is crucial in making the virtual memory implementation feasible.



                                10.4     Paging
                                A virtual address in a paging system is an ordered pair (p, d), where p is the number
                                of the page in virtual memory on which the referenced item resides, and d is the dis-
                                placement within page p at which the referenced item is located (Fig. 10.8). A pro-
                                cess may run if the page it is currently referencing is in main memory. When the
                                system transfers a page from secondary storage to main memory, it places the page
                                in a main memory block, called a page frame, that is the same size as the incoming
                                page. In discussing paging systems in this chapter, we assume that the system uses a
                                single fixed page size. As we will explain in Chapter 11, Virtual Memory
                                Management, it is common for today's systems to provide more than one page
                                size.27 Page frames begin at physical memory addresses that are integral multiples
                                of the fixed page size, ps (Fig. 10.9). The system may place an incoming page in any
                                available page frame.
                                       Dynamic address translation under paging proceeds as follows (Fig. 10.10). A
                                running process references a virtual memory address v - (p,d). A page mapping
                                mechanism, looks up page p in the process's page map table (often simply called
                                the page table) and determines that page p is in page frame p'. Note that/?' is a page
                                frame number, not a physical memory address. Assuming page frames are num-




                                 Figure 10.8 | Virtual address format in a pure paging system.

<!-- pág. 480 -->

                                                                                         10.4   Paging 425




Figure 10.9 | Main memory divided into page frames.


bered {0,1, 2,..., n], the physical memory address at which page frame p' begins is
the product of p' and the fixed page size, p x ps. The referenced address is formed
by adding the displacement, d, to the physical memory address at which page frame
 p' begins. Thus, the real memory address is r - (p' x ps ) + d .
      Consider a system using n bits to represent both real and virtual addresses; the
page number is represented by the most-significant n-m bits and the displacement
is represented by m bits. Each real address can be represented as the ordered pair,
r = (p', d), where p' is the page frame number and d is the displacement within page
 p' at which the referenced item is located. The system can form a real address by
concatenating p' and d, which places p' in the most-significant bits of the real mem-

<!-- pág. 481 -->

426   Virtual Memory Organization




                             Figure 10.10 | Correspondence between virtual memory addresses and physical
                             memory addresses in a pure paging system.


                             ory address and places d in the least-significant bits of the real memory address. For
                             example, consider a 32-bit system (n = 32) using 4KB pages (m - 12). Each page
                             frame number is represented using 20 bits, so that page frame number 15 would be
                             represented as the binary string 00000000000000001111. Similarly, a displacement
                             of 200 would be represented as the 12-bit binary string 000011001000. The 32-bit
                             address of this location in main memory is formed simply by concatenating the two
                             strings, yielding 00000000000000001111000011001000. This demonstrates how

<!-- pág. 482 -->

                                                                                               10.4   Paging   427

 paging simplifies block mapping by using the concatenation operation to form a
real memory address. On the contrary, with variable-size blocks, the system must
perform an addition operation to form the real memory address from the ordered
pair r = (b',d).
       Now let us consider dynamic address translation in more detail. One benefit of a
paged virtual memory system is that not all pages belonging to a process must reside
 in main memory at the same time—main memory must contain only the page (or
 pages) in which the process is currently referencing an address (or addresses). The
 advantage is that more processes may reside in main memory at the same time. The
disadvantage comes in the form of increased complexity in the address translation
mechanism. Because main memory normally does not contain all of a process's pages
at once, the page table must indicate whether or not a mapped page currently resides
in main memory. If it does, the page table indicates the number of the page frame in
which it resides. Otherwise, the page table yields the location in secondary storage at
which the referenced page can be found. When a process references a page that is not
in main memory, the processor generates a page fault, which invokes the operating
system to load the missing page into memory from secondary storage.
       Figure 10.11 shows a typical page table entry (PTE). A resident bit, r, is set to
 0 if the page is not in main memory and 1 if it is. If the page is not in main memory,
then s is its secondary storage address. If the page is in main memory, then p' is its
frame number. Over the next several subsections we consider several implementa-
tions of the page mapping mechanism.


Self Review
1. Does the page mapping mechanism require that s and p' be stored in separate cells of a
   PTE, as shown in Fig. 10.11?
2. Compare and contrast the notions of a page and a page frame.
Ans: 1) No. To reduce the amount of memory consumed by PTEs, many systems contain
only one cell to store either the page frame number or the secondary storage address. If the




Figure 10.11 | Page table entry.

<!-- pág. 483 -->

428 Virtual Memory Organization

                           resident bit is on. the PTE stores a page frame number, but not a secondary storage address.
                           If the resident bit is off, the PTE stores a secondary storage address, but not a page frame
                           number. 2) Pages and page frames are identical in size; a page refers to a fixed-size block of
                           a process's virtual memory space and a page frame refers to a fixed-size block of main mem-
                           ory. A virtual memory page must be loaded into a page frame in main memory before a pro-
                           cessor can access its contents.




                           10.4.1 Paging Address Translation by Direct Mapping
                          In this section we consider the direct-mapping technique for translating virtual
                          addresses to physical addresses in a pure paging system. Direct mapping proceeds
                          as illustrated in Fig. 10.12.
                                 A process references virtual address v = (p, d). At context-switch time the
                          operating system loads the main memory address of a process's page table into the
                          page table origin register. To determine the main memory address that corresponds
                          to the referenced virtual address, the system first adds the process's page table base
                          address, b, to the referenced page number, p (i.e., p is the index into the page table).
                          This result, b + p, is the main memory address of the PTE for page p. [Note: For
                          simplicity, we assume that the size of each entry in the page table is fixed and that
                          each address in memory stores an entry of that size.] This PTE indicates that virtual
                          page p corresponds to page frame p'. The system then concatenates p' with the dis-
                          placement, d, to form the real address, r. This is an example of direct mapping.




                          Figure 10.12 | Paging address translation by direct mapping.

<!-- pág. 484 -->

                                                                                                          10.4   Paging   429

because the page table contains one entry for every page in this process's virtual
memory space, V. If the process contains n pages in V, then the direct-mapped page
table for the process contains entries successively for page 0, page 1, page 2, ...,
page n — 1. Direct mapping is much like accessing an array location via subscripting;
the system can locate directly any entry in the table with a single access to the table.
      The system maintains the virtual address being translated and the base
address of the page table in high-speed registers on each processor, which enables
 operations on these values to be performed quickly (within a single instruction exe-
cution cycle). However, a system typically keeps the direct-mapped page table —
 which can be quite large—in main memory. Consequently, a reference to the page
table requires one complete main memory cycle. Because the main memory access
time ordinarily represents the largest part of an instruction execution cycle, and
because we require an additional main memory access for page mapping, the use of
direct-mapping page address translation can cause the computer system to run pro-
grams at about half speed (or even worse for machines that support multiple
 address instructions)! To achieve faster translation, one may implement the com-
plete direct-mapped page table in high-speed cache memory. Due to the cost of
nigh-speed cache memory and the potentially large size of virtual address spaces,
maintaining the entire page table in cache memory is typically not viable. We dis-
cuss a solution to this problem in Section 10.4.3, Paging Address Translation with
Direct/Associative Mapping.


Self Review
1. Why should the size of page table entries be fixed?
2. What type of special-purpose hardware is required for page address translation by direct
   mapping?
Ans: 1) The key to virtual memory is that address translation must occur quickly. If the size
  of page table entries is fixed, the calculation that locates the entries is simple, which facilitates
fast page address translation. 2) A high-speed processor register is needed to store the base
address of the page table.



10.4.2 Paging Address Translation by Associative Mapping
One way to increase the performance of dynamic address translation is to place the
entire page table into a content-addressed (rather than location-addressed) associa-
tive memory, which has a cycle time greater than an order of magnitude faster than
main memory.28, 29, 30, 31 Figure 10.13 illustrates how dynamic address translation
proceeds with pure associative mapping. A process refers to virtual address
v = (p,d). Every entry in the associative memory is searched simultaneously for
page p. The search returns p' as the page frame corresponding to page p, and p' is
concatenated with d, forming the real address, r. Note that the arrows into the asso-
ciative map enter every cell of the map, indicating that every cell of the associative
memory is searched simultaneously for a match on p. This is what makes associative
memory prohibitively expensive, even compared to direct-mapped cache. Because

<!-- pág. 485 -->

430 Virtual Memory Organization




                           Figure 10.11 | Paging address translation with pure associative mapping.

                           of this expense, pure associative mapping is not used; we show it here in case its
                           economics eventually becomes more favorable.
                                 In the vast majority of systems, using a cache memory to implement pure
                           direct mapping or an associative memory to implement pure associative mapping is
                           too costly. As a result, many designers have chosen a compromise scheme that
                           offers many of the advantages of the cache or associative memory approach at a
                           more modest cost. We consider this scheme in the next section.

                           Self Review
                           1. Why is page address translation by pure associative mapping not used?
                           2. Does page address translation by pure associative mapping require any special-purpose
                              hardware?
                           Ans: 1) Associative memory is even more expensive than direct-mapped cache memory.
                           Therefore, it would be prohibitively expensive to build a system that contained enough asso-
                           ciative memory to store all of a process's PTEs. 2) This technique requires an associative
                           memory; however, it does not require a page table origin register to store the location of the
                           start of the page table, because associative memory is content addressed, rather than location
                           addressed.


                           10.4.3 Paging Address Translation with Direct/Associative Mapping
                           Much of the discussion to this point has dealt with the computer hardware required to
                           implement virtual memory efficiently. The hardware view presented has been a logi-
                           cal rather a than physical one. We are concerned not with the precise structure of the
                           devices but with their functional organization and relative speeds. This is the view the
                           operating systems designer must have, especially as hardware designs evolve.

<!-- pág. 486 -->

                                                                                       10.4   Paging   431

       Historically, hardware has improved at a much more dramatic pace than
 improvements in software. Designers have become reluctant to commit themselves
to a particular hardware technology because they expect that a better one will soon
 be available. Operating systems designers, however, must use the capabilities and
economics of today's hardware. High-speed cache and associative memories simply
 are far too expensive to hold the complete address mapping data for full virtual
 address spaces. This leads to a compromise page-mapping mechanism.
       the compromise uses an associative memory, called the translation lookaside
buffer (TLB), capable of holding only a small percentage of the complete page
table for a process (Fig. lO.f 4). The TLB's contents may be controlled by the oper-




Figure 10.14 | Paging address translation with combined associative/direct mapping.

<!-- pág. 487 -->

432 Virtual Memory Organization
                               ating system or by hardware, depending on the architecture. 32 In this chapter, we
                               assume that the TLB is managed by hardware. The page table entries maintained in
                               this map typically correspond to the more-recently referenced pages only, using the
                               heuristic that a page referenced recently is likely to be referenced again in the near
                               future. This is an example of locality (more specifically of temporal locality—local-
                               ity in time), a phenomenon discussed in detail in Chapter 11, Virtual Memory
                               Management (see the Operating Systems Thinking feature, Empirical Results.
                               Locality-Based Heuristics). The TLB is an integral part of today's MMUs.
                                     Dynamic address translation under this scheme proceeds as follows. A process
                               references virtual address v = (p, d). The page mapping mechanism first tries to find
                               page p in the TLB. If the TLB contains p, then the search returns p' as the frame
                               number corresponding to virtual page p, and p' is concatenated with the displace-
                               ment d to form the real address, r. When the system locates the mapping for p in the
                               TLB, it experiences a TLB hit. Because the TLB stores entries in high-speed asso-
                               ciative memory, this enables the translation to be performed at the fastest possible
                               speed for the system. The problem, of course, is that because of prohibitive cost, the
                               associative map can hold only a small portion of most virtual address spaces. The
                               challenge is to pick a size within design's economic parameters that holds enough
                               entries so that a large percentage of references will result in TLB hits.
                                     If the TLB does not contain an entry for page p (i.e., the system experiences a
                               TLB miss), the system locates the page table entry using a conventional direct map
                               in slower main memory, which increases execution time. The address in the page



                Operating Systems Thinking
    Empirical Results: Locality-Based Heuristics
    Some fields of computer science      pie, we will study the empirical         will see many examples of locality
    have significant bodies of theory,   phenomena of spatial locality and        in computer systems and we will
    built from a mathematical frame-     temporal locality (i.e., locality in     study many locality-based heuris-
    work. There are indeed aspects of    time), which are observed phe-           tics in various areas of operating
    operating systems to which such      nomena. If it is sunny in your           systems such as virtual memory
    theoretical treatments apply. But    t o w n , it is likely—but not guaran-   management. Perhaps the most
    for the most part, operating sys-    teed—to be sunny in nearby               famous locality-based heuristic in
    tems design is based on empirical,   towns. Also, if it is sunny in your      operating systems is Peter Den-
    (i.e., observed) results and the     t o w n now, it is likely—but not        ning's working set theory of pro-
    heuristics that designers and        guaranteed—that is was sunny in          gram behavior, which we discuss
    implementers have developed the      your t o w n a short while ago and       in Chapter 11.
    first operating systems were         it will be sunny in your t o w n a
    deployed in the 1950s. For exam-     short while into the future. We

<!-- pág. 488 -->

                                                                                                 10.4   Paging   433

table origin register, b, is added to the page number, p, to locate the appropriate
entry for page p in the direct-mapped page table in main memory. The entry con-
tains p', the page frame corresponding to virtual page p\p' is concatenated with the
displacement, d, to form the real address, r. The system then places the PTE in the
 TLB so that references to page/? in the near future can be translated quickly. If the
 TLB is full, the system replaces an entry (typically the one least-recently refer-
enced) to make room for the entry for current page.
       Empirically, due to the phenomenon of locality, the number of entries in the
TLB does not need to be large to achieve good performance. In fact, systems using
 this technique with only 64 or 128 TLB entries (which, assuming a 4KB page size,
covers 256-512KB of virtual memory space) often achieve 90 percent or more of
 the performance possible with a complete associative map. Note that on a TLB
miss, the processor must access main memory to obtain the page frame number.
Depending on the hardware and memory management strategy, such misses can
cost tens or hundreds of processor cycles, because main memory typically operates
at slower speeds than processors do.33-34-35
       Using a combined associative/direct mapping mechanism is an engineering
decision based on the relative economics and capabilities of existing hardware tech-
nologies. Therefore, it is important for operating systems students and developers
  to be aware of such technologies as they emerge. The Recommended Reading and
Web Resources sections provide several resources documenting these technologies.

Self Review
1. (T/F) The majority of a process's PTEs must be stored in the TLB to achieve high perfor-
   mance.
2. Why does the system need to invalidate a PTE in the TLB if a page is moved to secondary
   storage?
Ans: 1) False. Processes often achieve 90 percent or more of the performance possible
when only a small portion of a process's PTEs are stored in the TLB. 2) If the system does not
 invalidate the PTE, a reference to the nonresident page will cause the TLB to return a page
frame that might contain invalid data or instructions (e.g., a page belonging to a different
sprocess).


10.4.4 Multilevel Page Tables
One limitation of address translations using direct mapping is that all of the PTEs
of a page table must be in the map and stored contiguously in sequential order by
page number. Further, these tables can consume a significant amount of memory.
For example, consider a 32-bit virtual address space using 4KB pages. In this sys-
tem, the page size is 2 12 bytes, leaving 232 - 12, or 2 20 , page numbers. Thus, each vir-
tual address space would require approximately one million entries, one for each
page, for a total addressability of about four billion bytes. A 64-bit virtual address
space using 4MB pages would require approximately four trillion entries! Holding
such a large page table in memory (assuming that there was enough memory to do
so) can severely limit the memory available for actual programs; it also does not

<!-- pág. 489 -->

434 Virtual Memory Organization

                            makes sense, because processes may need to access only small portions of their
                            address spaces at any given time to run efficiently.
                                  Multilevel (or hierarchical) page tables enable the system to store in discon-
                            tiguous locations in main memory those portions of a process's page table that the
                           process is actively using. The remaining portions of can be created the first time
                           they are used and moved to secondary storage when they cease being actively used.
                           Multilevel page tables are implemented by creating a hierarchy—each level con-
                           taining a table that stores pointers to tables in the level below. The bottom-most
                           level is comprised of tables containing the page-to-page-frame mappings.
                                 For example, consider a system that uses two levels of page tables (Fig. 10.15).
                           The virtual address is the ordered triplet v = (p,t, d), where the ordered pair (p, t) is
                           the page number and d is the displacement into that page. The system first adds the
                           value of p to the address in main memory of the start of the page directory, a, stored
                           in the page directory origin register. The entry at location a+p contains the address
                           of the start of the corresponding page table, b. The system adds t to b to locate the
                           page table entry that stores a page frame number, p'. Finally, the system forms the
                           real address by concatenating p' and the displacement, d.
                                 In most systems, each table in the hierarchy is the size of one page, which
                           enables the operating system to transfer page tables between main memory and




                          Figure 10.15 | Multilevel page address translation.

<!-- pág. 490 -->

                                                                                                 10.4   Paging 435

secondary storage easily. Let us examine how a two-level page table reduces mem-
ory consumption compared to direct mapping in a system that provides a 32-bit vir-
tual address space using 4KB pages (which, again, requires 20-bit page numbers).
Each page table would contain 220, or 1,048,576, entries for each process. Consider-
ing that typical systems contain tens, if not hundreds, of processes, and that high-
end systems can contain thousands of processes, this could lead to considerable
memory overhead. If each page table entry were 32 bits, this would consume 4MB
of contiguous memory for each process's virtual address space. If the space were
sparsely populated (i.e., few page table entries were in use), much of the page table
would be unused, resulting in significant memory waste called table fragmentation.
      Observe how table fragmentation is reduced using a two-level page table as
follows. Each 32-bit virtual address is divided into a 10-bit offset into the page
directory, p, a 10-bit offset into a page table, t, and a 12-bit displacement into the
page, d. In this case, the page directory contains pointers to 2 10 tables (one entry for
each number specified by the 10-bit offset into the page directory, p), each of which
holds 2 10 PTEs (one entry for each number specified by the 10-bit offset into a page
table, t). The first 10 bits of the virtual address is used as an index into the first table.
The entry at this index is a pointer to the next table, which is a page table containing
PTEs. The second 10 bits of the virtual address is used as an index into the page
table that locates the PTE. Finally, the PTE provides the page frame number, p',
which is concatenated with the last 12 bits of the virtual address to determine the
real address.
      If a process uses no more than the first 1,024 pages in its virtual address space,
the system need only maintain 1,024 (210) entries for the page directory and 1,024
page table entries, whereas a direct-mapped page table must maintain over one mil-
lion entries. Multilevel page tables enable the system to reduce table fragmentation
by over 99 percent.
      The overhead incurred by multilevel page tables is the addition of another
memory access to the page mapping mechanism. At first, it may appear that this addi-
tional memory cycle would result in worse performance than a direct-mapped page
table. Due to locality of reference and the availability of a high-speed TLB, however,
once a virtual page has been mapped to a page frame, future references to that page
do not incur the memory access overhead. Thus, systems that employ multilevel page
tables rely on an extremely low TLB miss rate to achieve high performance.
      Multilevel page tables have become common in paged virtual memory sys-
tems. For example, the IA-32 architecture supports two levels of page tables (see
Section 10.7, Case Study: IA-32 Intel Architecture Virtual Memory). 36


Self Review
1. Discuss the benefits and drawbacks of using a multilevel paging system instead of a direct-
   mapped paging system.
2. A designer suggests reducing the memory overhead of direct-mapped page tables by
   increasing the size of pages. Evaluate the consequences of such a decision.

<!-- pág. 491 -->

436 Virtual Memory Organization

                          Ans: 1) Multilevel paging systems require considerably less main memory space to hold
                          mapping information than direct-mapped paging systems. However, multilevel paging sys-
                          tems require more memory accesses each time a process references a page whose mapping is
                          not in the TLB, and potentially can run more slowly. 2) Assuming that the size of each virtual
                          address remains fixed, page address translation by direct mapping using large pages reduces
                          the number of entries the system must store for each process. The solution also reduces mem-
                          ory access overhead compared to a multilevel page table. However, as page sizes increase, so
                          do the possibility and magnitude of internal fragmentation. It is possible that the amount of
                          wasted memory due to internal fragmentation could be equal to or greater than the tabic
                          fragmentation due to storing entries for smaller pages.


                           10.4.5 Inverted Page Tables
                           As we discussed in the preceding section, multilevel page tables reduce the number
                           of page table entries that must reside in main memory at once for each process
                           when compared to direct-mapped page tables. In this case, we assumed that pro-
                           cesses use only a small, contiguous region of their virtual address spaces, meaning
                           that the system can reduce memory overhead by storing page table entries only for
                           the region of a process's virtual address space that is in use. However, processes in
                           scientific and commercial environments that modify large quantities of data might
                           use a significant portion of their 32-bit virtual address spaces. In this case, multilevel
                           page tables do not necessarily decrease table fragmentation. In 64-bit systems that
                           contain several levels of page tables, the amount of memory consumed by mapping
                           information can become substantial.
                                 An inverted page table solves this problem by storing exactly one PTE for each
                           page frame in the system. Consequently, the number of PTEs that must be stored in
                           main memory is proportional to the size of physical memory, not to the size of a vir-
                           tual address space. The page tables are inverted relative to traditional page tables
                           because the PTEs are indexed by page frame number rather than virtual page num-
                           ber. Note that inverted page tables do not store the secondary storage location of
                           nonresident pages. This information must be maintained by the operating system, and
                           need not be in tables. For example, an operating system might use a binary tree to
                           store the locations of nonresident pages so that they may be found quickly.
                                 Inverted page tables use hash functions to map virtual pages to PTEs. 37 ' 38 A
                           hash function is a mathematical function that takes a number as an input and out-
                           puts a number, called a hash value, within a finite range. A hash table stores each
                           item in the cell corresponding to the item's hash value. Because the domain of a
                           hash function (e.g., a process's virtual page numbers) is generally larger than its
                           range (e.g., the page frame numbers), multiple inputs can result in the same hash
                           value —these are called collisions. To prevent multiple items from overwriting each
                           other when mapped to the same cell of the hash table, inverted page tables can
                           implement a variant of a chaining mechanism to resolve collisions as follows. When
                           a hash value maps an item to a location that is occupied, a new function is applied
                           to the hash value. The resulting value is used as the position in the table where the
                           input is to be placed. To ensure that the item can be found when referenced, a
                           pointer to this position is appended to the entry in the cell corresponding to the

<!-- pág. 492 -->

                                                                                            10.4   Paging   437

item's original hash value. This process is repeated each time a collision occurs.
Inverted page tables typically use linked lists to chain items.
       In a paging system implementing inverted page tables, each virtual address is
represented by the ordered pair v = (p,d). To quickly locate the hash table entry
corresponding to virtual page p, the system applies a hash function to p, which pro-
duces a value q (Fig. 10.16). If the qth cell in the inverted page table contains p, then
the requested virtual address is in page frame q. If page number in the qth cell of
the inverted page table does not match p, the system checks the value of the chain-
ing pointer for that cell. If the pointer is null, then the page is not in memory, so the
processor issues a page fault. The operating system can then retrieve the page from
secondary storage. Otherwise, there has been a collision at that index in the
  inverted page table, so the page table entry stores a pointer to the next entry in the
 chain. The system follows the pointers in the chain until it finds an entry containing
 p or until the chain ends, at which point the processor issues a page fault to indicate
 that the page is not resident. The operating system can then retrieve the page from
 secondary storage. In Fig. 10.16, the system locates an entry corresponding to p
 after following one chaining pointer to cell p', so p is located in page frame p'.
     Although a careful choice of hash functions can reduce the number of colli-
sions in the hash table, each additional chaining pointer requires the system to




 F i g u r e 10.16 | Page address translation using inverted page tables.

<!-- pág. 493 -->

438   Virtual Memory Organization

                            access main memory, which can substantially increase address translation time. To
                            improve performance, the system can attempt to reduce the number of collisions by
                            increasing the range of hash values produced by the function. Because the size of
                            the inverted page table must remain fixed to provide direct mappings to page
                            frames, most systems increase the range of the hash function using a hash anchor
                            table, which is a hash table containing pointers to entries in the inverted page table
                            (Fig. 10.17). The hash anchor table imposes an additional memory access to virtual-
                            to-physical address translation using inverted page tables and increases table frag-
                            mentation. If the hash anchor table is sufficiently large, however, the number of col-
                            lisions in the inverted page table can be significantly reduced, which can speed
                            address translation. The size of the hash anchor table must be chosen carefully to
                            balance address translation performance with memory overhead.39-40
                                  Inverted page tables are typically found in high-performance architectures, such
                            as the Intel IA-64 and the HP PA-RISC architectures, but are also implemented in
                            the PowerPC architecture, which is found in the consumer line of Apple computers.




                            Figure 10.17 | Inverted page table using a hash anchor table.

<!-- pág. 494 -->

                                                                                                10.4   Paging   439

Self Review
1. Compare and contrast inverted page tables (without a hash anchor table) to direct-
   mapped page tables in terms of memory efficiency and address translation efficiency.
2. Why are PTEs larger in inverted page tables than in direct-mapped page tables?
Ans: 1) Inverted page tables incur less memory overhead than direct-mapped page tables
because an inverted page table contains only one PTE for each physical page frame, whereas
a direct-mapped page table contains one PTE for each virtual page. However, address trans-
lation may be much slower using an inverted page table than when using a direct-mapped
table because the system may have to access memory several times to follow a collision chain.
2) A PTE in an inverted page table must store a virtual page number and a pointer to the
next PTE in the collision chain. A PTE in a direct-mapped page table need only store a page
frame number and a resident bit.



10.4.6 Sharing in a Paging System
In multiprogrammed computer systems, especially in timesharing systems, it is com-
mon for many users to execute the same programs concurrently. If the system allo-
cated individual copies of these programs to each user, much of main memory
would be wasted. The obvious solution is for the system to share those pages com-
mon to individual processes.
      The system must carefully control sharing to prevent one process from modi-
fying data that another process is accessing. In most of today's systems that imple-
ment sharing, programs are divided into separate procedure and data areas.
Nonmodifiable procedures are called pure procedures or reentrant procedures.
Modifiable data cannot be shared without careful concurrency control. Nonmodifi-
able data can be shared. Modifiable procedures cannot be shared (although one
might envision an esoteric example where doing this with some form of concur-
rency control would make sense).
      All this discussion points to the need to identify each page as either sharable
or nonsharable. Once each process's pages have been categorized in this fashion,
then sharing in pure paging systems can be implemented as in Fig. 10.18. If the page
table entries of different processes point to the same page frame, then this page
frame is shared by each of the processes. Sharing reduces the amount of main mem-
ory required for a group of processes to run efficiently and can make it possible for
a given system to increase its degree of multiprogramming.
      One example in which page sharing can substantially reduce memory consump-
tion is with the UNIX fork system call. When a process forks, the data and instruc-
tions for both the parent process and its child are initially identical. Instead of
allocating an identical copy of data in memory for the child process, the operating sys-
tem can simply allow the child process to share its parent's virtual address space while
providing the illusion that each process has its own, independent virtual address
space. This improves performance because it reduces the time required to initialize
the child process and reduces memory consumption between the two processes (see
the Operating Systems Thinking feature, Lazy Allocation). However, because the

<!-- pág. 495 -->

440 Virtual Memory Organization




                           Figure 10.18 | Sharing in a pure paging system.

                           parent and child are unaware of the sharing, the operating system must ensure that
                           the two processes do not interfere with each other when modifying pages.
                                 Many operating systems use a technique called copy-on-write to address this
                           problem. Initially, the system maintains one copy of each shared page in memory, as
                           described previously, for processes P1 through Pn. If P1 attempts to modify a page
                           of shared memory, the operating system creates a copy of the page, applies the
                           modification and assigns the new copy to process P 1 's virtual address space. The
                           unmodified copy of the page remains mapped to the address space of all other pro-
                           cesses sharing the page. This ensures that when one process modifies a shared page,
                           no other processes are affected.
                                 Many architectures provide each PTE with a read/write bit that the processor
                           checks each time a process references an address. When the read/write bit is off, the
                           page can be read, but not modified. When the bit is on, the page can be both read

<!-- pág. 496 -->

                                                                                                    10.4    Paging 441

and modified. Copy-on-write can thus be implemented by marking each shared
page as read-only. When a process attempts to write to a page, the processor on
which it executes will cause a page fault, which invokes the kernel. At this point, the
kernel can determine that the process is attempting to write to a shared page and
perform the copy-on-write.
      Copy-on-write speeds process creation and reduces memory consumption for
processes that do not modify a significant amount of data during execution. How-
ever, copy-on-write can result in poor performance if a significant portion of a pro-
cess's shared data is modified during program execution. In this case, the process
will suffer a page fault each time it modifies a page that is still shared. The overhead
associated with invoking the kernel for each exception can quickly outweigh the
benefits of copy-on-write. In the next chapter, we consider how sharing affects vir-
tual memory management.

Self Review
1. Why might it be difficult to implement page sharing when using inverted page tables?
2. How does page sharing affect performance when the operating system moves a page from
   main memory to secondary storage?




               Operating Systems Thinking
  Lazy Allocation
  Lazy resource allocation schemes        so those processes and threads do       truly be needed. On the other
  allocate resources only at the last     not have to wait for the resources      hand, because such a scheme
  moment, when they are explicitly        to be allocated. We discuss lazy        waits until a page is referenced
  requested by processes or threads.      allocation in various contexts in       before bringing it to main mem-
  For resources that ultimately will      the book. One classic example of        ory, the process will experience a
  not be needed, lazy allocation          lazy allocation is demand paging,       significant execution delay as it
  schemes are more efficient than         which we study in this chapter          waits for the disk I/O operation to
  anticipatory resource allocation        and the chapter that follows.           complete. And while the process
  schemes, which might attempt to         With pure demand paging, a pro-         or thread is waiting, the portion
  allocate those resources that           cess's or thread's pages are            of that process or thread memory
  would not be used, thus wasting         brought to memory only as each          that is in memory is tying up space
  the resources. For resources that       is explicitly referenced. The           that could otherwise be used by
  ultimately will be needed, antici-      advantage of demand paging is           other running processes. Copy-on-
  patory schemes help processes           that the system never incurs the        write is another example of lazy
  and threads run more efficiently        overhead of transferring a page         allocation.
  by having the resources they need       from secondary storage to main
  available when they need them.          memory unless that page will

<!-- pág. 497 -->

442 Virtual Memory Organization

                          Ans: 1) The type of page sharing discussed in this section is accomplished by having PTEs
                          from different process's page tables point to the same page frame number. Because inverted
                          page tables maintain exactly one PTE in memory for each page frame, the operating system
                          must maintain sharing information in a data structure outside the inverted page table. One
                          challenge of this type of page sharing is determining if a shared page is already in memory,
                          because it was recently referenced by a different process, when another process first refer-
                          ences it. 2) When the operating system moves a shared page to secondary storage, it must
                          update the corresponding PTE for every process sharing that page. If numerous processes
                          share the page, this could incur significant overhead compared to that for an unshared page.


                           10.5 Segmentation
                           In the preceding chapter, we discussed how a variable-partition multiprogramming
                           system can place a program in memory on a first-fit, best-fit or worst-fit basis. Under
                           variable-partition multiprogramming, each program's memory and data occupy one
                           contiguous section of memory called a partition. An alternative is physical memory
                           segmentation (Fig. 10.19). Under this scheme, a program's data and instructions are
                           divided into blocks called segments. Each segment consists of contiguous locations;
                           however, the segments need not be the same size nor must they be placed adjacent
                           to one another in main memory.
                                 One advantage of segmentation over paging is that it is a logical rather than a
                           physical concept. In their most general form, segments are not arbitrarily con-
                           strained to a certain size. Instead, they are allowed to be (within reasonable limits)
                           as large or as small as they need to be. A segment corresponding to an array is as
                           large as the array. A segment corresponding to a procedural code unit generated by
                           a compiler is as large as it needs to be to hold the code.
                                 In a virtual memory segmentation system, we have the ability to maintain in
                           main memory only those segments that a program requires to execute at a certain
                           time; the remainder of the segments reside on secondary storage.41 A process may
                           execute while its current instructions and data are located in a segment that resides
                           in main memory. If a process references memory in a segment that does not cur-
                           rently reside in main memory, the virtual memory system must retrieve that seg-
                           ment from secondary storage. Under pure segmentation, the system transfers a
                           segment from secondary storage as a complete unit and places all the locations
                           within that segment in contiguous locations in main memory. An incoming segment
                           may be placed in any available area in main memory that is large enough to hold it.
                           The placement strategies for segmentation are identical to those used in variable-
                           partition multiprogramming. 42
                                 A virtual memory segmentation address is an ordered pair v = (s, d), where s is
                           the segment number in virtual memory in which the referenced item resides, and d is
                           the displacement within segment s at which the referenced item is located (Fig. 10.20).

                          Self Review
                           1. (T/F) Segmented virtual memory systems do not incur fragmentation.
                           2. How does segmentation differ from variable-partition multiprogramming?

<!-- pág. 498 -->

                                                                                               10.5   Segmentation 443




Figure 10.19 | Noncontiguous memory allocation in a real memory segmentation
system.




Figure 10.20 | Virtual address format in a pure segmentation system.

A n s : 1) False. Segmented virtual memory systems can incur external fragmentation, exactly
as in variable-partition multiprogramming systems. 2) Unlike programs in a variable-parti-
tion multiprogramming system, programs in a segmented virtual memory system can be
larger than main memory and need only a portion of their data and instructions in memory to
execute. Also, in variable-partition multiprogramming systems, a process occupies one con-
tiguous range of main memory, whereas in segmentation systems this need not ne so.

<!-- pág. 499 -->

444 Virtual Memory Organization

                           10.5.1 Segmentation Address Translation by Direct Mapping
                           There are many strategies for implementing segmented address translation. A system
                           can employ direct mapping, associative mapping or combined direct/associative map-
                           ping. In this section we consider segmented address translation using direct mapping
                           and maintaining the complete segment map table in a fast-access cache memory.
                                 We consider first the case in which the address translation proceeds normally
                           and consider several problems that may arise. Dynamic address translation under
                           segmentation proceeds as follows. A process references a virtual memory address v
                           = (s, d) to determine where in main memory the referenced segment resides. The
                           system adds the segment number, s, to the segment map table's base address value,
                           b, located in the segment map table origin register (Fig. 10.21). The resulting value,
                           b + s, is the location of the segment's table map entry. [Note: For simplicity, we
                           assume that the size of each entry in the segment map table is fixed and that each
                           address in memory stores an entry of that size.] Each entry contains several pieces
                           of information about the segment, which the mapping mechanism uses to translate
                           the virtual address to a physical address. If the segment currently resides in main
                           memory, the entry contains the segment's main memory starting address, s'. The
                           system adds the displacement, d, to this address to form the referenced location's
                           real memory address, r = s' + d. We cannot simply concatenate d to s', as we do in a
                           pure paging system, because segments are of variable size.




                           Figure 10.21 | Virtual address translation in a pure segmentation system.

<!-- pág. 500 -->

                                                                                           10.5   Segmentation   445

      Figure 10.22 shows a typical segment map table entry in detail. A resident bit,
r, indicates whether or not that segment is currently in main memory. If it is, then s'
is the main memory address at which the segment begins. Otherwise a is the sec-
ondary storage address from which the segment must be retrieved before the pro-
cess may proceed. All references to the segment are checked against the segment
length, l, to ensure that they fall within the range of the segment. Each reference to
the segment is also checked against the protection bits to determine if the operation
being attempted is allowed. For example, if the protection bits indicate that a seg-
ment is read-only, no process is allowed to modify that segment. We discuss protec-
tion in segmented systems in detail in Section 10.5.3, Protection and Access Control
in Segmentation Systems.
      During dynamic address translation, once the segment map table entry for
segment s has been located, the resident bit, r, is examined to determine if the seg-
ment is in main memory. If it is not, then a missing-segment fault is generated, caus-
ing the operating system to gain control and load the referenced segment which
begins at secondary storage address a. Once the segment is loaded, address transla-
tion proceeds with checking that the displacement, d, is less than or equal to the
segment length, l. If it is not, then a segment-overflow exception is generated, caus-
ing the operating system to get control and potentially terminate the process. If it is,
the protection bits are checked to ensure that the operation being attempted is
allowed. If it is, then the base address, s', of the segment in main memory is added
to the displacement, d, to form the real memory address r = s' + d corresponding to
virtual memory address v = (s, d). If the operation being attempted is not allowed,
then a segment-protection exception is generated, causing the operating system to
gain control of the system and terminate the process.




Figure 10.22 | Segment map table entry.

<!-- pág. 501 -->

446 Virtual Memory Organization

                           SelReview
                           1. Why is it incorrect to form the real address, r, by concatenating s' and d?
                           2. Does the page mapping mechanism require that a and s' be stored in separate cells of a
                              segment map table entry, as shown in Fig. 10.22?
                           Ans: 1) Unlike the page frame number p', the segment base address s' is an address in main
                           memory. Concatenating s' and d would result in an address beyond the limit of main memory.
                           Again, concatenation works with paging because the page size is a power of two and the
                           number of bits reserved for the displacement on a page and the number of bits reserved for
                           the page frame number add up to the number of bits in the virtual address. 2) No. To reduce
                           the amount of memory consumed by segment map table entries, many systems use one cell to
                           store either the segment base address or the secondary storage address. If the resident bit is
                           on, the segment map table entry stores a segment base address, but not a secondary storage
                           address. If the resident bit is off, the segment map table entry stores a secondary storage
                           address, but not a segment base address.



                           10.5.2 Sharing in a Segmentation System
                           Sharing segments can incur less overhead than sharing in a direct-mapped pure
                           paging system. For example, to share an array that is stored in three and one-half
                           pages, a pure paging system must maintain separate sharing data for each page on
                           which the array resides. The problem is compounded if the array is dynamic,
                           because the sharing information must be adjusted at execution time to account for
                           the growing or shrinking number of pages that the array occupies. In a segmenta-
                           tion system, on the other hand, data structures may grow and shrink without chang-
                           ing the sharing information associated with the structure's segment.
                                 Figure 10.23 illustrates how a pure segmentation system accomplishes sharing.
                           Two processes share a segment when their segment table entries point to the same
                           segment in main memory.
                                 Although sharing provides obvious benefits, it also introduces certain risks.
                           For example, one process could intentionally or otherwise perform an operation on
                           a segment that negatively affects other processes sharing that segment. Therefore, a
                           system that provides sharing also should provide appropriate protection mecha-
                           nisms, to ensure that only authorized users may access or modify a segment.

                           Self Review
                           1. How does segmentation reduce sharing overhead compared to sharing under pure paging?
                           2. Can copy-on-write be implemented using segments, and, if so, how?
                          Ans: 1) Segmentation enables an entire block of shared memory to fit inside one segment.
                          so the operating system maintains sharing information for one segment. Under paging, this
                          segment might consume several pages, so the operating system would have to maintain shar-
                          ing information for each page. 2) Yes. Copy-on-write can be implemented by allocating a
                          copy of the parent's segment map table to its child. If process P1 (which can be a parent or
                          child process) attempts to modify segment s, the operating system must create a new copy of
                          the segment, located at main memory address s'. The operating system then changes entry s
                          in P 1 's segment map table to contain the address s'.

<!-- pág. 502 -->

                                                                                         10.5 Segmentation 447




Figure 10.23 | Sharing in a pure segmentation system.

10.5.3 Protection and Access Control in Segmentation Systems
Segmentation promotes program modularity and enables better memory use
through noncontiguous allocation and sharing. With these benefits, however, comes
increased complexity. For example, a single pair of bounds registers no longer suf-
fices to protect each process from destruction by other processes. Similarly, it
becomes more difficult to limit the range of access of any given program. One
scheme for implementing memory protection in segmentation systems is the use of
memory protection keys (Fig. 10.24). In this case, each process is associated with a
value, called a protection key. The operating system strictly controls this key, which
can be manipulated only by privileged instructions. The operating system employs
protection keys as follows. At context-switch time, the operating system loads the
process's protection key into a processor register. When the process references a
particular segment, the processor checks the protection key of the block containing
the referenced item. If the protection key for the process and the requested block
are the same, the process can access the segment. For example, in Fig. 10.24, Process
2 can access only those blocks with a protection-key value of 2. If the process
attempts to access a block with a different protection key, the hardware prevents
the memory access and vectors into the kernel (caused by a segment-protection
exception). Although memory protection keys are not the most common protection

<!-- pág. 503 -->

448   Virtual Memory Organization




                            Figure 10.24 |     Memory protection with keys in noncontiguous memory allocation




                            mechanism in today's systems, they are implemented in the IA-64 Intel architecture
                            (i.e., the Itanium line of processors) and are generally intended for systems contain-
                            ing one virtual address space.43
                                    The operating system can exercise further protection control by specifying
                            how a segment may be accessed and by which processes. This is accomplished by
                            assigning each process certain access rights to segments. Figure 10.25 lists the most
                            common access control types in use in today's systems. If a process has read access
                            to a segment, then it may read data from any address in that segment. If it has write
                            access to a segment, then the process may modify any of the segment's contents and
                            may add further information. A process given execute access to a segment may pass
                            program control to instructions in that segment for execution on a processor. Exe-
                            cute access to a data segment is normally denied. A process given append access to
                            a segment may write additional information to the end of the segment, but may not
                            modify existing information.

<!-- pág. 504 -->

                                                                                            10.5   Segmentation   449

      By either allowing or denying each of these four access types, it is possible to
create 16 different access control modes. Some of these are interesting, while others
do not make sense. For simplicity, consider the eight different combinations of read,
write, and execute access shown in Fig. 10.26.
      In mode 0, no access is permitted to the segment. This is useful in security
schemes in which the segment is not to be accessed by a particular process. In mode 1,
a process is given execute-only access to the segment. This mode is useful when a pro-
cess is allowed to execute instructions in the segment, but may not copy or modify it.
Modes 2 and 3 are not useful—it does not make sense to give a process the right to
modify a segment without also giving it the right to read the segment. Mode 4 allows
a process read-only access to a segment. This is useful for accessing nonmodifiable
data. Mode 5 allows a process read/execute access to a segment. This is useful for

  Type of access   Abbreviation     Description
 Read               R               This segment may be read.
 Write             W                This segment may be modified.
 Execute            E               This segment may be executed.
 Append            A                This segment may have information added to its end.

 Figure 10.25 | Access control types.


 Mode      Read     Write    Execute Description         Application
 Mode 0    No       No       No          No access        Security.
                                         permitted
 Mode 1    No       No       Yes         Execute only     A segment made available to
                                                          processes that cannot modify
                                                          it or copy it, but that can run
                                                          it.
 Mode 2    No       Yes      No         Write only        These possibilities are not
 Mode 3    No       Yes      Yes        Write/execute     useful, because granting
                                        but cannot be     write access without read
                                        read              access is impractical.

 Mode 4    Yes      No       No         Read only         Information retrieval.
 Mode 5    Yes      No       Yes        Read/execute      A program can be copied or
                                                          executed but cannot be
                                                          modified.
 Mode 6    Yes      Yes      No         Read/write but    Protects data from an errone-
                                        no execution      ous attempt to execute it.
 Mode 7    Yes     Yes       Yes        Unrestricted     This access is granted to
                                        access           trusted users.

Figure 10.26 | Combining read, write and execute access to yiels useful access
control modes.

<!-- pág. 505 -->

450   Virtual   Memory   Organization

                                reentrant code. A process may make its own copy of the segment which it may then
                                modify. Mode 6 allows a process read/write access to a segment. This is useful when
                                the segment contains data that may be read or written by the process but that must be
                                protected from accidental execution (because the segment does not contain instruc-
                                tions). Mode 7 allows a process unrestricted access to a segment. This is useful for
                                allowing a process complete access to its own segments (such as self-modifying code)
                                and for giving it most-trusted status to access other processes' segments.
                                      The simple access control mechanism described in this section is the basis of
                                segment protection implemented in many systems. Figure 10.27 shows one way a
                                system can implement access control, namely by including protection bits in a seg-
                                ment's map table entry. The entry includes four bits —one for each type of access
                                control. The system can now enforce protection during address translation. When a
                                process makes a reference to a segment in virtual memory, the system checks the
                                protection bits to determine if the process has proper authorization. For example, if
                                a process is attempting to execute a segment that has not been granted execution
                                rights, then it does not have authorization to perform its task. In this case, a seg-
                                ment-protection exception is generated, causing the operating system to gain con-
                                trol and terminate the process.

                                Self Review
                                 1. Which access rights are appropriate for a process's stack segment?
                                 2. What special-purpose hardware is required to implement memory protection keys?




                                 Figure 10.27 | Segment map table entry with protection bits.

<!-- pág. 506 -->

                                                                                10.6     Segmentation/Paging Systems 451

Ans: 1) A process should be able to read and write data in its stack segment and append
new stack frames to the segment. 2) A high-speed register is required to store the current
process's memory protection key.


10.6 Segmentation/Paging Systems
Both segmentation and paging offer significant advantages as virtual memory orga-
nizations. Beginning with systems constructed in the mid-1960s, in particular Mul-
tics and IBM's TSS, many computer systems have been built that combine paging
 and segmentation. 44, 45, 46, 47, 48, 49 These systems offer the advantages of the two vir-
tual memory organization techniques we have presented in this chapter. In a com-
bined segmentation/paging system, segments are usually arranged across multiple
pages. All the pages of a segment need not be in main memory at once, and virtual
memory pages that are contiguous in virtual memory need not be contiguous in
main memory. Under this scheme, a virtual memory address is implemented as an
 ordered triple v = (s,p,d), where s is the segment number, p the page number
within the segment and d the displacement within the page at which the desired
item is located (Fig. 10.28).

10.6.1 Dynamic Address Translation in a Segmentation/Paging System
Consider the dynamic address translation of virtual addresses to real addresses in a
paged and segmented system using combined associative/direct mapping, as illus-
trated in Fig. 10.29.
      A process references virtual address v = (s, p, d). The most recently referenced
rages have entries in the associative memory map (i.e., the TLB). The translation
mechanism performs an associative search to attempt to locate (s, p). If the TLB
contains (s,p), then the search returns p', the page frame in which page p resides.
This value is concatenated with the displacement, d, to form the real memory
address r.
      If the TLB does not contain an entry for (s,p), the processor must perform a
complete direct mapping as follows. The base address, b, of the segment map table (in
main memory) is added to the segment number, s, to form the address, b+s. This
address corresponds to the physical memory location of the segment's entry in the
segment map table. The segment map table entry indicates the base address, s', of the
page table (in main memory) for segment s. The processor adds the page number, p,
to the base address, s', to form the address of the page table entry for page p of seg-
ment s. This table entry indicates that p' is the page frame number corresponding to




Figure 10.28 | Virtual address format in a segmentation/paging system.

<!-- pág. 507 -->

452 Virtual Memory Organization




                          Figure 10.29 | Virtual address translation with combined associative/direct map-
                          ping in a segmentation/paging system.

                          virtual page p. This frame number, p', is concatenated with the displacement, d, to
                          form the real address, r. The translation is then loaded into the TLB.
                                This translation scheme assumes that the process has made a valid memory
                          reference and that every piece of information required for the process is located in
                          main memory. Under many conditions however, the address translation may
                          require extra steps or will fail. The segment map table search may indicate that seg-
                          ment s is not in main memory, thus generating a missing-segment fault and causing

<!-- pág. 508 -->

                                                                                10.6 Segmentation/Paging Systems 453
 the operating system to locate the segment on secondary storage, create a page
 table for the segment, and load the appropriate page into main memory. If the seg-
 ment is in main memory, then the reference to the page table may indicate that the
 desired page is not in main memory, initiating a page fault. This would cause the
  operating system to gain control, locate the page on secondary storage, and load it
  into main memory. It is also possible that a process has referenced a virtual memory
  address that extends beyond the range of the segment, thus generating a segment-
  overflow exception. Or the protection bits may indicate that the operation to be
performed on the referenced virtual address is not allowed, thus generating a seg-
ment-protection exception. The operating system must handle all these possibilities.
       The associative memory (or, similarly, a high-speed cache memory) is critical to
the efficient operation of this dynamic address translation mechanism. If a purely
direct mapping mechanism were used, with the complete map being maintained in
main memory, the average virtual memory reference would require a memory cycle
to access the segment map table, a second one to reference the page table and a third
to reference the desired item in main memory. Thus every reference to an item would
involve three memory cycles, and the computer system would run only at a small frac-
tion of its normal speed; this would invalidate the benefits of virtual memory.
       Figure 10.30 indicates the detailed table structure required by segmentation/
paging systems. At the top level is a process table that contains an entry for every
process in the system. Each process table entry contains a pointer to its process's
segment map table. Each entry of a process's segment map table points to the page
table for the associated segment, and each entry in a page table points either to the
page frame in which that page resides or to the secondary storage address at which
the page may be found. In a system with a large number of processes, segments and
pages, this table structure can consume a significant portion of main memory. The
benefit of maintaining all the tables in main memory is that address translation pro-
ceeds faster at execution time. However, the more tables a system maintains in
main memory, the fewer processes it can support, and thus productivity declines.
Operating systems designers must evaluate many such trade-offs to achieve the del-
icate balance needed for a system to run efficiently and to provide responsive ser-
vice to system users.


Self Review
1. What special-purpose hardware is required for segmentation/paging systems?
2. In what ways do segmentation/paging systems incur fragmentation?
Ans: 1) Segmentation/paging systems require a high-speed register to store the base
address of the segment map table, a high-speed register to store the base address of the cor-
responding page table and an associative memory map (i.e., a TLB). 2) Segmentation/paging
systems can incur internal fragmentation when a segment is smaller than the page(s) in which
it is placed. They also incur table fragmentation by maintaining both segment map tables and
page tables in memory. Segmentation/paging systems do not incur external fragmentation
(assuming the system uses one page size), because ultimately the memory is divided into
fixed-size page frames, which can accommodate any page of any segment.

<!-- pág. 509 -->

454 Virtual Memory Organization




                          Figure 10.30 | Table structure for a segmentation/paging system.

<!-- pág. 510 -->

                                                     10.7 Case Study: IA-32 Intel Architecture Virtual Memory 455

10.6.2 Sharing and Protection in a Segmentation/Paging System
Segmentation/paging virtual memory systems take advantage of the architectural
simplicity of paging and the access control capabilities of segmentation. In such a
system the benefits of segment sharing become important. Two processes share
memory when each process has a segment map table entry that points to the same
page table, as is indicated in Fig. 10.31.
      Sharing, whether in paged systems, segmented systems, or segmentation/pag-
ing systems, requires careful management by the operating system. In particular,
consider what would happen if an incoming page were to replace a page shared by
many processes. In this case, the operating system must update the resident bit in
the corresponding page table entries for each process sharing the page. The operat-
ing system can incur substantial overhead determining which processes are sharing
the page and which PTEs in their page tables must be changed. As we discuss in
Section 20.6.4, Swapping, Linux reduces this overhead by maintaining a linked list
of PTEs that map to a shared page.


Self Review
1. Why are segmentation/paging systems appealing?
2. What are the benefits and drawbacks of maintaining a linked list of PTEs that map to a
   shared page?
Ans: 1) Segmentation/paging systems offer the architectural simplicity of paging and the
access control capabilities of segmentation. 2) A linked list of PTEs enables the system to
update PTEs quickly when a shared page is replaced. Otherwise, the operating system
would need to search each process's page table to determine if any PTEs need to be
updated, which can incur substantial overhead. A drawback to the linked list of PTEs is
that it incurs memory overhead. In today's systems, however, the cost of accessing main
memory to search page tables generally outweighs the memory overhead incurred by
maintaining the linked list.




10.7 Case Study: IA-32 Intel Architecture Virtual Memory
In this section, we discuss the virtual memory implementation of the IA-32 Intel
architecture (i.e., the Intel Pentium line of processors), which supports either a pure
segmentation or a segmentation/paging virtual memory implementation. 50 The set
of addresses contained in each segment is called a logical address space, and its size
depends on the size of the segment. Segments are placed in any available location
in the system's linear address space, which is a 32-bit (i.e., 4GB) virtual address
space. Under pure segmentation, the processor uses linear addresses to access main
memory. If paging is enabled, the linear address space is divided into fixed-size page
frames that are mapped to main memory.

<!-- pág. 511 -->

456   Virtual   Memory   Organization




                               Figure 10.31 | Two processes sharing a segment in a segmentation/paging system.

<!-- pág. 512 -->

                                                   10.7 Case Study: IA-32 Intel Architecture Virtual Memory 457

      The first stage of dynamic address translation maps segmented virtual addresses
to the linear address space. Because there is no way to disable segmentation in the
IA-32 specification, this translation occurs for every memory reference. Each seg-
mented virtual address can be represented by the ordered pair v = (s, d), as discussed
in Section 10.5.1. In the IA-32 architecture, s is specified by a 16-bit segment selector
and d by a 32-bit offset (i.e., the displacement within segment s' at which the refer-
enced item is located). The segment index, which is the 13 most-significant bits of the
segment selector, specifies an 8-byte entry in the segment map table.
      To speed address translation under segmentation, the IA-32 architecture
provides six segment registers, named CS, DS, SS, ES, FS and GS, to store a pro-
cess's segment selectors. The operating system normally uses the CS register to
store a process's code segment selector (which typically corresponds to the seg-
ment containing its executable instructions), the DS register to store a process's
data segment selector (which typically corresponds to the segment containing the
process's data) and the SS register to store a process's stack segment selector
 (which typically corresponds to the segment containing its execution stack). The
ES, FS and GS registers can be used for any other process segment selectors.
Before a process can reference an address, the corresponding segment selector
must be loaded into a segment register. This enables the process to reference
addresses using the 32-bit offset, so that it does not have to specify the 16-bit seg-
ment selector for each memory reference.
      To locate a segment map table entry, the processor multiplies the segment
index by 8 (the number of bytes per segment map table entry) and adds that value
to b, the address stored in the segment map table origin register. The IA-32 archi-
tecture provides two segment map table origin registers, the global descriptor table
register (GDTR) and the local descriptor table register (LDTR). The values of the
GDTR and LDTR are loaded at context-switch time.
      The system's primary segment map table is the global descriptor table
(GDT) which contains 8,192 (213) 8-byte entries. The first entry is not used by the
processor—references to a segment corresponding to this entry will generate an
exception. Operating systems load the value corresponding to this entry into
unused segment registers (e.g., ES, FS and GS) to prevent processes .from access-
ing an invalid segment. If the system uses one segment map table for all of its pro-
cesses, then the GDT is the only segment map table in the system. For operating
systems that must maintain more than 8,192 segments, or that maintain a separate
segment map table for each process, the IA-32 architecture provides local
descriptor tables (LDTs), each containing 8,192 entries. In this case, the base
address of each LDT must be stored in the GDT, because the processor places the
LDT in a segment. To perform address translation quickly, the base address of the
LDT, b, is placed in the LDTR. The operating system can create up to 8,191 sepa-
rate segment map tables using LDTs (recall that the first entry in the GDT is not
used by the processor).

<!-- pág. 513 -->

458   Virtual Memory Organization

                                   Each segment map table entry, called a segment descriptor, stores a 32-bit
                             base address, s', that specifies the location in the linear address space of the start of
                             the segment. The system forms a linear address by adding the displacement, d, to
                             the segment base address, s'. Under pure segmentation, the linear address, s' + d, is
                             the real address.
                                   The processor checks each reference against the segment descriptor's resident
                             and protection bits before accessing main memory. The segment descriptor's
                             present bit indicates whether the segment is in main memory; if it is, the address
                             translation proceeds normally. If the present bit is off, the processor generates a
                             segment-not-present exception, so that the operating system can load the segment
                             from secondary storage. [Note: The terms "fault" and "exception" are used differ-
                             ently in the IA-32 specification than in the rest of the text (see Section 3.4.2, Inter-
                             rupt Classes). The segment-not-present exception corresponds to a missing-
                             segment fault.] The processor also checks each reference against the segment
                             descriptor's 20-bit segment limit, l, which specifies the size of the segment. The sys-
                             tem uses the segment descriptor's granularity bit to determine how to interpret the
                             value specified in the segment's limit. If the granularity bit is off, segments can
                             range in size from 1-byte (l = 0) to 1MB (l = 2 20 - 1), in 1 byte increments. In this
                             case, if d > l, the system generates a general protection fault (GPF) exception, indi-
                             cating that a process has attempted to access memory outside of its segment. [Note:
                             Again, the term "fault" is used differently in the IA-32 specification than in the rest
                             of the text.] If the granularity bit is on, segments can range in size from 4KB (l = 0)
                             to 4GB (l = 2 20 - 1), in 4KB increments. In this case, if d > (l x 2 ), the processor
                             generates a GPF exception, indicating that a process has attempted to access mem-
                             ory outside of its segment.
                                   The IA-32 architecture maintains a process's access rights to a segment in the
                            type field of each segment map table entry. The type field's code/data bit determines
                            whether the segment contains executable instructions or program data. Execute
                            access is enabled when this bit is on. The type field also contains a read/write bit
                            that determines whether the segment is read-only or read/write.
                                   If paging is enabled, the operating system can divide the linear address space
                            (i.e., the virtual address space in which segments are placed) into fixed-size pages.
                            As we discuss in the next chapter, page size can significantly impact performance:
                            thus, the IA-32 architecture supports 4KB, 2MB and 4MB pages. When 4KB pages
                            are used, the IA-32 architecture maps each linear address to a' physical address
                            using a two-level page address translation mechanism. In this case, each 32-bit lin-
                            ear address is represented as V = (t,p, d), where t is a 10-bit page table number, p is
                            a 10-bit page number, and d is a 12-bit displacement. Page address translation
                            occurs exactly as described in Section 10.4.4. To locate the page directory entry, t is
                            added to the value of the page directory origin register (analogous to the page table
                            origin register). Each 4-byte page directory entry (PDE) specifies b, the base
                            address of a page table containing 4-byte page table entries (PTEs). To form the
                            physical address at which the page table entry resides, the processor multiplies p by

<!-- pág. 514 -->

                                                          10.7 Case Study: IA-32 Intel Architecture Virtual Memory 459

4 (because each PTE occupies 4 bytes) and adds b. The most active PTEs and PDEs
are stored in a processor's TLB to speed virtual-to-physical address translations.
      When 4MB pages are used, each 32-bit linear address is represented as
v' - (p, d), where p is a 10-bit page directory number and d is a 22-bit displace-
ment. In this case, page address translation occurs exactly as described in
Section 10.4.3.
      Each page reference is checked against its PDE's and PTE's read/write bit.
When the bit is on, all of the pages in the PDE's page table are read-only; otherwise
they are read/write. Similarly, each PTE's read/write bit specifies the read/write
access right for its corresponding page.
      One limitation of a 32-bit physical addresses space is that the system can access
at most 4GB of main memory. Because some systems contain more than that, the IA-
32 architecture provides the Physical Address Extension (PAE) and Page Size Exten-
sion (PSE) features, which enable a system to reference 36-bit physical addresses,
supporting a maximum memory size of 64GB. The implementation of these features
is beyond the scope of the discussion; the reader is encouraged to study these and
other features of the IA-32 specification, which can be found online in the IA-32 Intel
Architecture Software Developer's Manual, Vol. 3, located at d e v e l o p e r . i n t e l . c o m /
design/Pentium4/manuals/. The Web Resources section contains links to several
manuals that describe virtual memory implementations in other architectures, such as
the PowerPC and PA-RISC architectures.




                   Mini Case Study
  IBM Mainframe Operating System
   The first commercial computer                      In 1964 IBM announced its              models of computer was a rela-
   with transistor logic for general            next set of systems, the System/             tively new concept at the time. 5 9
   use was the IBM 7090 which was               360 line, which consisted of sev-            OS/360 had three different con-
   released in 1959. Its operating              eral different models of varying             trol options: PCP, MFT, and MVT.
                                                                                             60,61
   system was called IBSYS.51, 52               processor power, all running on                      OS/360-PCP (for Principal
   IBSYS had roughly t w o dozen                the same architecture. 54,55 The             Control Program) was single-task-
   components, which included                   smallest models ran under the                ing and designed for the smallest
   modules for the FORTRAN and                  Disk Operating System or DOS,                System/360 models; however, in
   COBOL programming languages,                 while the rest came w i t h OS/              practice DOS (or TOS for systems
   in addition to the resource man-             360. 56, 57, 58 Having one operating         w i t h tape drives only) was used
   agers.53                                     system run on several different              (continued)

<!-- pág. 515 -->

460      Virtual Memory Organization




                    Mini Case Study
      IBM Mainframe Operating Systems ( C o n t . )
      on these computers. 62, 63 OS/360-       such address spaces, and so was             In 1988 IBM upgraded the
      MFT and OS/360-MVT were both             renamed 0S/VS2 MVS, or simply         hardware yet again, moving to
      multitasking, w i t h a "Fixed num-      MVS (for Multiple Virtual             the ES/3090 processors on the
      ber of Tasks" and a "Variable            Storages). 72 . 73                    ESA/370 (Enterprise System Archi-
      number of Tasks," respectively,                  MVS was updated to MVS/       tecture). 83 ESA introduced mem-
      which meant that a system run-           370, which soon supported the         ory spaces that were used only for
      ning the MFT option had its mem-         new cross-memory feature of the       data, making it easier to move
      ory divisions preset by the              System/370 hardware; cross-mem-       data around for processing. 84
      operator, while under MVT mem-           ory is a mechanism to separate        MVS/XA was moved up to MVS/
      ory could be divided by the sys-         data and code in memory               ESA for these new systems.85-86
      tem automatically as new jobs            space.74-75 Additionally, because     MVS/ESA was significantly
      arrived. 64, 65 A large project called   16MB of memory space had              updated in 1991 for the new ESA/
      TSS (Time-Sharing System) to             quickly been filled by expanding      390 hardware, which included
      build a multiuser operating sys-         system programs, the processors       mechanisms for linking IBM
      tem to compete w i t h Multics was       now used a 26-bit address, allow-     machines into a loose cluster (SYS-
      eventually cancelled when TSS            ing for 64MB of real memory;          PLEX)87 and changing the settings
      proved to be too large and to            however, while MVS/370 sup-           on I/O devices w i t h o u t the need
      crash too often. 6 6 Its functionality   ported this real memory capacity,     to take the machine offline
      was implemented as TSO (the              it still used a 24-bit address and    (ESCON).88
      Time-Sharing Option) in 1971. 67, 68     therefore only used 16MB virtual            MVS is still the root of IBM's
             IBM announced the System/         memory spaces.76-77                   mainframe operating systems, as
      370 hardware in 1970, which now                Two years later, IBM moved      MVS/ESA was upgraded to OS/390
      included virtual memory sup-             on to the 3081 processors running     in 1996 for the System/390 hard-
      port. 69 To utilize this new capabil-    on the 370-XA "Extended               ware; 89 it is now named z/OS and
      ity, OS/360-MFT was updated and          Architecture." 78 - 79 MVS/370 was    runs on the zSeries mainframes. 90
      renamed OSA/S1, while the MVT            updated, new functionality was        In addition, IBM's mainframe
      option was similarly upgraded            added, and the resulting package      operating systems have remained
      and named OS/VS2 SVS (Single             was subsequently released as          backward compatible with earlier
      Virtual Storage), so named               MVS/XA in 1983. 80 - 81 This OS now   versions; OS/390 can run applica-
      because it had only one 16MB vir-        allowed for 2GB of virtual mem-       tions written for MVS/ESA, MVS/
      tual address space shared among          ory, much more easily satisfying      XA, OSA/S2, or even OS/360.91
      all users.70, 71 It was later updated    any program's space require-
      again to allow any number of             ments. 82

<!-- pág. 516 -->

                                               Case Study: IA-32 Intel Architecture Virtual Memory 461




             Mini Case Study
Early History of the VM Operating System
A virtual machine is an illusion of   process sees a machine smaller in       multiprograms complete virtual
a real machine. 'It is created by a   size and capabilities than the real     machines rather than individual
virtual machine operating sys-        machine executing the process.          tasks or processes. CMS is an
t e m , which makes a single real           Virtual machine multipro-         applications system w i t h powerful
machine appear to be several real     gramming systems (Fig. 10.32)           features for interactive develop-
machines. From the user's view-       share the resources of a single         ment of programs. It contains edi-
point, virtual machines can           machine in a different manner.          tors, language translators, various
appear to be existing real            They create the illusion that one       applications packages and debug-
machines, or they can be dramati-     real machine is actually several        ging tools. Virtual machines run-
cally different. The concept has      machines. They create virtual pro-      ning under CP perform much as if
proven valuable, and many virtual     cessors, virtual storage and virtual    they were real machines, except
machine operating systems have        I/O devices, possibly w i t h much      that they operate more slowly,
been developed—one of the most        larger capacities than those of the     since VM runs many virtual
widely used is IBM's VM.              underlying real machine.                machines simultaneously.
       VM managed the IBM Sys-              The main components of VM                VM's ability to run multiple
tem/370 92 - 93 computer (or com-     are the Control Program (CP),           operating systems simultaneously
patible hardware), creating the       the Conversational Monitor              has many applications. 95 ' 96 It
illusion that each of several users   System (CMS), the Remote                eases migration between differ-
had a complete System/370,            Spooling Communications                 ent operating systems or different
including many input/output           Subsystem (RSCS), the Interac-          versions of the same operating
devices. Each user could choose a     tive Problem Control System             system. It enables people to be
different operating system. VM        (IPCS) and the CMS Batch Facil-         trained simultaneously w i t h run-
can run several operating systems     ity. CP creates the environment in      ning production systems. System
simultaneously, each of them on       which virtual machines can exe-         development can occur simulta-
its own virtual machine. Today's      cute. It provides the support for       neously w i t h production runs.
VM users can run versions of the      the various operating systems           Customers can run different oper-
operating systems OS/390, z/OS,       normally used to control System/        ating systems simultaneously to
TPF, VSE/ESA, CMS and Linux. 94       370 and compatible computer sys-        exploit each system's benefits.
      Conventional multiprogram-      tems. CP manages the real               Running multiple operating sys-
ming systems share the resources      machine underlying the virtual          tems offers a form of backup in
of a single computer among sev-       machine environment. It gives           case of failure; this increases avail-
eral processes. These processes are   each user access to the facilities of   ability. Installations may run
each allocated a portion of the       the real machine such as the pro-       benchmarks on new operating
real machine's resources. Each        cessor, storage and I/O devices. CP     (continued)

<!-- pág. 517 -->

462    Virtual Memory Organization




                    Mini Case Study
      Early History of the VM Operating System (Cont.)
      systems to determine if upgrades               The first operational version   appropriate, so they split the
      are worthwhile; this may be done        appeared in 1966, consisting of        resource management portion
      in parallel with production activity.   CP-40 and CMS. These compo-            from the user support portion of
            Processes running on a vir-       nents were designed to run on a        the operating system, resulting in
      tual machine are not controlled         modified IBM 360/40 w i t h newly      CP and CMS, respectively. CP pro-
      by CP, but rather by the actual         incorporated dynamic address           vides separate computing envi-
      operating system running on that        translation hardware. At about         ronments that give each user
      virtual machine. The operating          this time, IBM announced an            complete access to a full virtual
      systems running on virtual              upgrade to its powerful 360/65.        machine; CMS runs on a CP-cre-
      machines perform their full range       The new system, the 360/67, incor-     ated virtual machine as a single-
      of functions, including storage         porated dynamic address transla-       user interactive system.
      management, processor schedul-          tion hardware and provided the                 The most significant decision
      ing, input/output control, protect-     basis for a general-purpose time-      made in the design of CP was that
      ing users from one another,             sharing, multiprogramming com-         each virtual machine would repli-
      protecting the operating system         puter utility called TSS/360.98 The    cate a real machine. It was clear
      from the users, spooling, multi-        TSS effort, performed indepen-         that the 360 family concept would
      programming, job and process            dently of the work on CP/CMS,          create a long lifetime for 360 pro-
      control, error handling, and so on.     encountered many difficulties          grams; users requiring more
            VM simulates an entire            (typical of the large-scale soft-      power would simply move up in
      machine dedicated to one user. A        ware efforts of the mid-1960s).        the family to a compatible system
      user at a VM virtual machine sees       Meanwhile CP/CMS was success-          w i t h more storage, devices and
      the equivalent of a complete real       fully moved to the 360/67, and         processor speed. Any decision to
      machine, rather than many users         eventually it superseded the TSS       produce virtual machines differ-
      sharing one set of resources.           effort. CP/CMS evolved into VM/        ent in structure from a real 360
            CP/CMS began as an experi-        370, which became available in         probably would have resulted in
      mental system in 1964. It was to        1972 for the virtual storage mod-      the failure of the CP/CMS system.
      be a second-generation timeshar-        els of the IBM 370 series."            Instead, the'concept has been suc-
      ing system based on IBM System/               CTSS, successfully used at       cessful, making VM one of IBM's
      360 computers. 97 Originally devel-     MIT through 1974, most strongly        t w o leading mainframe operating
      oped for local use at the IBM           influenced the design of CP/CMS.       systems in the 1990s. IBM contin-
      Cambridge Scientific Center, it         The CP/CMS designers found that        ues to create new versions of VM
      soon gained favor as a tool for         the CTSS design was difficult to       for use on its mainframe servers,
      evaluating the performance of           work w i t h . They felt that a more   the latest being zA/M, which sup-
      other operating systems.                modular approach would be              ports IBM's 64-bit architecture. 100

<!-- pág. 518 -->

                                                                                                                     Web Resources 463




Figure 10.32 | Virtual machine multiprogramming.



Web Resources
www.redhat.com/docs/manuals/linux/RHL-8.O-Manual/                www-3.ibm.com/chips/techlib/techlib.nsf/product-
admin-primer/s1-memory-concepts.html                             families/
Overview of virtual memory from Red Hat (a Linux vendor).        PowerPC_Microprocessors_and_Embedded_Processors
www.howstuffworks.com/virtual-memory.htm                         Provides technical documentation regarding PowerPC proces-
Overview of virtual memory.                                      sors, found in Apple computers. Descriptions of virtual mem-
                                                                 ory management in these processors is located in the software
www.memorymanagement.org
                                                                 reference manuals (e.g., the PowerPC 970, found in Apple G5
Provides a glossary and guide to physical and virtual memory
                                                                 computers, w w w - 3 . i b m . c o m / c h i p s / t e c h l i b / t e c h l i b . n s f /
management.                                                      products/PowerPC_970_Microprocessor).
developer.intel.com
                                                                 h21007.www2.hp.com/dspp/tech/
Provides technical documentation regarding Intel products,
                                                                 tech_TechDocumentDetai1Page_IDX/
including Pentium and Itanium processors. Their system pro-
                                                                 1,1701,958!13!253,00.html
grammer guides (e.g., for the Pentium 4 processor, d e v e l -
                                                                 Describes virtual memory organization for PA-RISC proces-
oper.intel.com/design/Pentium4/manuals/)            provide
                                                                 sors. PA-RISC is primarily used in high-performance environ-
information on how memory is organized and accessed in Intel
                                                                 ments. See also c p u s . h p . c o m / t e c h n i c a l _ r e f e r e n c e s /
systerns.                                                        pari´sc.shtml.



Summary
Virtual memory solves the problem of limited memory space        addresses. Whenever a process accesses a virtual address, it
by creating the illusion that more memory exists than is         must translate the virtual addresses to a physical address;
available in the system. There are two types of addresses in     this is done by the memory management unit (MMU).
virtual memory systems: those referenced by processes and               A process's virtual address space, V, is the range of
those available in main memory. The addresses that pro-          virtual addresses that it may reference. The range of physi-
cesses reference are called virtual addresses. The addresses     cal addresses available on a particular computer system is
available in main memory are called physical (or real)           called that computer's real address space, R. If we are to

<!-- pág. 519 -->

464 Virtual Memory Organization

permit a user's virtual address space to be larger than its      block table to form the real address of the entry for block b
real address space, we must provide a means for retaining        in the block map table. This entry contains the address, b'.
programs and data in a large auxiliary storage. A system         for the start of block b in main memory. The system then
normally accomplishes this by employing a two-level stor-        adds the displacement, d, to the block start address, b', to
age scheme consisting of main memory and secondary stor-         form the desired real address, r.
age. When the system is ready to run a process, the system             Paging uses a fixed-size block mapping; pure paging
loads the process's code and data from secondary storage         systems do not combine segmentation with paging. A virtual
into main memory. Only a small portion of a process's code       address in a paging system is an ordered pair (p, d), where p
and data needs to be in main memory for that process to          is the number of the page in virtual memory on which the
execute.                                                         referenced item resides, and d is the displacement within
       Dynamic address translation (DAT) mechanisms              page p at which the referenced item is located. When the sys-
convert virtual addresses to physical addresses during exe-      tem transfers a page from secondary storage to main mem-
cution. Systems that use DAT exhibit the property that the       ory, the system places the page in a main memory block,
contiguous addresses in a process's virtual address space        called a page frame, that is the same size as the incoming
need not be contiguous in physical memory—this is called         page. Page frames begin at physical memory addresses that
artificial contiguity. Dynamic address translation and artifi-   are integral multiples of the fixed page size. The system may
cial contiguity free the programmer from concerns about          place an incoming page in any available page frame.
memory placement (e.g., the programmer need not create                 Dynamic address translation under paging is similar
overlays to ensure the system can execute the program).          to block address translation. A running process references
Dynamic address translation mechanisms must maintain             a virtual memory address v = (p,d).A page mapping mech-
address translation maps indicating which regions of a pro-      anism uses the value of the page table origin register to
cess's virtual address space, V, are currently in main mem-      locate the entry for page p in the process's page map table
ory, and where they are located.                                 (often simply called the page table). The corresponding
       Virtual memory systems cannot afford to map               page table entry (PTE) indicates that page p is in page
addresses individually, so information is grouped into           frame p' (p' is not a physical memory address). The real
blocks, and the system keeps track of where in main mem-         memory address, r, corresponding to v is formed by concat-
ory the various virtual memory blocks have been placed.          enating p' and the displacement into the page frame, d.
When blocks are the same size, they are called pages and         which places p' in the most-significant bits of the real mem-
the associated virtual memory organization technique is          ory address and d in the least-significant bits.
called paging. When blocks may be of different sizes, they             When a process references a page that is not in main
are called segments, and the associated virtual memory           memory, the processor generates a page fault, which
organization technique is called segmentation. Some sys-         invokes the operating system to load the missing page into
tems combine the two techniques, implementing segments           memory from secondary storage. In the PTE for this page,
as variable-size blocks composed of fixed-size pages.            a resident bit, r, is set to 0 if the page is not in main memory
       In a virtual memory system with block mapping, the        and 1 if the page is in main memory.
system represents addresses as ordered pairs. To refer to a            Page address translation can be performed by direct
particular item in the process's virtual address space, the      mapping, associative mapping or combined direct/associa-
process specifies the block in which the item resides, and       tive mapping. Due to the cost of high-speed, location-
the displacement (or offset) of the item from the start of       addressed cache memory and the relatively large size of
the block. A virtual address, v, is denoted by an ordered        programs, maintaining the entire page table in cache mem-
pair (b, d), where b is the block number in which the refer-     ory is often not viable, which limits the performance of
enced item resides, and d is the displacement from the start     direct-mapping page address translation because the page
of the block. The system maintains in memory a block map         table must then be stored in much slower main memory.
table for each process. The real address, a, that corresponds    One way to increase the performance of dynamic address
to the address in main memory of a process's block map           translation is to place the entire page table into a content-
table is loaded into a special processor register called the     addressed (rather than location-addressed) associative
block map table origin register. During execution, the pro-      memory, which has a cycle time perhaps an order of magni-
cess references a virtual address v = (b, d).The system adds     tude faster than main memory. In this case, every entry in
the block number, b, to the base address, a, of the process's    the associative memory is searched simultaneously for page

<!-- pág. 520 -->

                                                                                                           Summary          465
p. In the vast majority of systems, using a cache memory to      page table entries of different processes point to the same
implement pure direct mapping or an associative memory           page frame, the page frame is shared by each of the pro-
to implement pure associative mapping is too costly.             cesses. Copy-on-write uses shared memory to reduce pro-
       As a result, many designers have chosen a compro-         cess creation time by sharing a parent's address space with
mise scheme that offers many of the advantages of the            its child. Each time a process writes to a shared page, the
cache or associative memory approach but at a more mod-          operating system copies the shared page to a new page that
est cost. This approach uses an associative memory, called       is mapped to that process's address space. The operating
the translation lookaside buffer (TLB), capable of holding       system can mark these shared pages as read-only so that
only a small percentage of the complete page table for a         the system generates an exception when a process attempts
process. The page table entries maintained in this map typi-     to modify a page. To handle the exception, the operating
cally correspond to the rhost-recently referenced pages          system allocates an unshared copy of the page to the pro-
 only, using the heuristic that a page referenced recently in    cess that generated the exception. Copy-on-write can result
the past is likely to be referenced again in the near future.    in poor performance if the majority of a process's shared
 This is an example of locality (more specifically of temporal   data is modified during program execution.
locality —locality in time). When the system locates the                Under segmentation, a program's data and instruc-
mapping for p in the TLB, it experiences a TLB hit; other-       tions are divided into blocks called segments. Each seg-
wise a TLB miss occurs, requiring the system to access           ment contains a meaningful portion of the program, such as
slower main memory. Empirically, due to the phenomenon           a procedure or an array. Each segment consists of contigu-
 of locality, the number of entries in the TLB does not need     ous locations; however, the segments need not be the same
to be large to achieve good performance.                         size nor must they be adjacent to one another in main
       Multilevel (or hierarchical) page tables enable the       memory. A process may execute while its current instruc-
system to store in discontiguous locations in main memory        tions and referenced data are in segments in main memory.
those portions of a process's page table that the process is     If a process references memory in a segment not currently
using. These layers form a hierarchy of page tables, each        resident in main memory, the virtual memory system must
level containing a table that stores pointers to tables in the   retrieve that segment from secondary storage. The place-
level below. The bottom-most level is comprised of tables        ment strategies for segmentation are identical to those used
containing address translations. Multilevel page tables can      in variable-partition multiprogramming.
reduce memory overhead compared to a direct-mapping                    A virtual memory segmentation address is an ordered
system, at the cost of additional accesses to main memory        pair v = (s, d), where s is the segment number in which the
to perform address translations that are not contained in        referenced item resides, and d is the displacement within
the TLB.                                                         segment s at which the referenced item is located. The sys-
       An inverted page table stores exactly one PTE in          tem adds the segment number, s, to the segment map table's
memory for each page frame in the system. The page tables        base address value, b, located in the segment map table ori-
are inverted relative to traditional page tables because the     gin register. The resulting value, b + s, is the location of the
PTEs are indexed by page frame number rather than vir-           segment map table entry. If the segment currently resides in
tual page number. Inverted page tables use hash functions        main memory, the segment map table entry contains the seg-
 and chaining pointers to map a virtual page to an inverted      ment's physical memory address, s'. The system then adds
page table entry, which yields a page frame number. The          the displacement, d, to this address to form the referenced
 overhead incurred by accessing main memory to follow            location's real memory address, r = s' + d. We cannot simply
each pointer in an inverted page table's hash collision chain    concatenate s' and d, as we could in a paging system, because
can be substantial. Because the size of the inverted page        segments are of variable size. If the segment is not in main
table must remain fixed to provide direct mappings to page       memory, then a missing-segment fault is generated, causing
frames, most systems employ a hash anchor table that             the operating system to gain control and load the referenced
increases the range of the hash function to reduce colli-        segment from secondary storage.
sions, at the cost of an additional memory access.                     Each reference to a segment is checked against the
      Enabling sharing in multiprogramming systems               segment length, /, to ensure that it falls within the seg-
reduces the memory consumed by programs that use com-            ment's range. If it does not, then a segment-overflow excep-
mon data and/or instructions, but requires that the system       tion is generated, causing the operating system to gain
identify each page as either sharable or nonsharable. If the     control and terminate the process. Each reference to the

<!-- pág. 521 -->

466    Virtual Memory Organization

segment is also checked against the protection bits in the       the displacement into the page table to locate the PTE con-
segment map table entry to determine if the operation is         taining the page frame number p'. The displacement, d, is
allowed. If it is not, then a segment-protection exception is    then concatenated to p' to form the real memory address.
generated, causing the operating system to gain control and      This translation scheme assumes that the process has made
terminate the process. Sharing segments can incur less           a valid memory reference and that every piece of informa-
overhead than sharing in a direct-mapped pure paging sys-        tion required for the process is located in main memory.
tem, because sharing information for each segment (which         Under many conditions however, the address translation
may consume several pages of memory) is maintained in            may require extra steps or may fail.
one segment map table entry.                                             In segmentation/paging systems, two processes share
       One scheme for implementing memory protection in          memory when each process has a segment map table entry
segmentation systems is the use of memory protection             that points to the same page table. Sharing, whether in paged
keys. In this case, each process is associated with a value,     systems, segmented systems, or segmentation/paging sys-
called a protection key. When the process references a par-      tems, requires careful management by the operating system.
ticular segment, it checks the protection key of the block               The IA-32 Intel architecture supports either pure seg-
containing the referenced item. If the protection key for        mentation or segmentation/paging virtual memory. The set
the processor and the requested block are the same, the          of addresses contained in each segment is called a logical
process can access the segment. The operating system can         address space; segments are placed in any available loca-
exercise further protection control by specifying how a seg-     tion in the system's linear address space, which is a 32-bit
ment may be accessed and by which processes. This is             (i.e., 4GB) virtual address space. Under pure segmentation,
accomplished by assigning each process certain access            a referenced item's linear address is its address in main
rights, such as read, write, execute and append. By either       memory. If paging is enabled, the linear address space is
allowing or denying each of these access types, it is possible   divided into fixed-size page frames that are mapped to
to create different access control modes.                        main memory. Segment address translation is performed by
       In a combined segmentation/paging system, segments        a direct mapping that uses high-speed processor registers to
occupy one or more pages. All the pages of a segment need        store segment map table origin registers in the global
not be in main memory at once, and pages contiguous in           descriptor table register (GDTR) or in the local descriptor
virtual memory need not be contiguous in main memory.            table register (TDTR), depending on the number of seg-
Under this scheme, a virtual memory address is imple-            ment map tables in the system. The processor also stores
mented as an ordered triple v = (s,p, d), where s is the seg-    segment numbers called segment descriptors in high-speed
ment number, p the page number within the segment and d          registers to improve address translation performance.
is the displacement within the page at which the desired         Under segmentation/paging, segments are placed in the
item is located. When a process references a virtual address     4GB linear address space, which is divided into page
v = (s,p,d), the system attempts to find the corresponding       frames that map to main memory. The IA-32 architecture
page frame number p' in the TLB. If it is not present, the       uses a two-level page table to perform translations from
system first searches the segment map table, which points        page numbers to page frame numbers, which are concate-
to the base of a page table, then uses the page number p as      nated with the page offset to form a real address.


Key Terms
access control mode—Set of privileges (e.g., read, write, exe-   append access—Access right that enables a process to write
    cute and/or append) that determine how a page or seg-            additional information at the end of a segment but not to
    ment of memory can be accessed.                                  modify its existing contents; see also execute access, read
access right—Privilege that determines which resources a pro-        access and write access.
    cess may access. In memory, access rights determine which
    pages or segments a process can access, and in what man-     artificial contiguity—Technique employed by virtual memory
    ner (i.e., read, write, execute and/or append).                    systems to provide the illusion that a program's instruc-
address translation map—Table that assists in the mapping of           tions and data are stored contiguously when pieces of
    virtual addresses to their corresponding real memory               them may be spread throughout main memory; this sim-
    addresses.                                                         plifies programming.

<!-- pág. 522 -->

                                                                                                           Key     Terms     467

associative mapping—Content-addressed associative memory              real addresses, using an index into a table stored in loca-
    that assists in the mapping of virtual addresses to their         tion-addressed memory.
    corresponding real memory addresses; all entries of the       displacement—Distance of an address from the start of a
    associative memory are searched simultaneously.                    block, page or segment, also called offset.
associative memory—Memory that is searched by content, not        dynamic address translation (DAT)—Mechanism that con-
    by location; fast associative memories can help implement         verts virtual addresses to physical addresses during execu-
    high-speed dynamic address translation mechanisms.                tion; this is done at extremely high speed to avoid slowing
block—Portion of a memory space (either real or virtual)              execution.
    defined by a range of contiguous addresses.                   execute access—Access right that enables a process to execute
block map table—Table containing entries that map each of a           instructions from a page or segment; see also read access,
    process's virtual blocks to a corresponding block in main         write access and append access.
    memory (if there is one). Blocks in a virtual memory sys-     general protection fault (GPF) (IA-32 Intel architecture) —
    tem are either segments or pages.                                 Occurs when a process references a segment to which it
 block map table origin register—Register that stores the             does not have appropriate access rights or references an
    address in main memory of a process's block map table;            address outside of the segment.
    this high-speed register facilitates rapid virtual address    global descriptor table (GDT) (IA-32 Intel architecture) —
    translation.                                                      Segment map table that contains mapping information for
block mapping—Mechanism that, a virtual memory system,                process segments or local descriptor table (LDT) seg-
    reduces the number of mappings between virtual memory             ments, which contain mapping information for process
    addresses and real memory addresses by mapping blocks             segments.
    in virtual memory to blocks in main memory.                   granularity bit (IA-32 Intel architecture)—Bit that determines
chaining (hash tables)—Technique that resolves collisions in a        how the processor interprets the size of each segment,
   hash table by placing each unique item in a data structure         specified by the 20-bit segment limit. When the bit is off,
   (typically a linked list). The position in the hash table at       segments range in size from 1 byte to 1MB, in 1-byte
   which the collision occurred contains a pointer to that            increments. When the bit is on, segments range in size
   data structure.                                                    from 4KB to 4GB, in 4KB increments.
CMS Batch Facility ( V M ) - V M Component that allows the        hash anchor table—Hash table that points to entries in an
   user to run longer jobs in a separate virtual machine so           inverted page table. Increasing the size of the hash anchor
   that the user can continue interactive work.                       table decreases the number of collisions, which improves
 virtual machine operating system—Software that creates the           the speed of address translation, at the cost of the
    virtual machine.                                                  increased memory overhead required to store the table.
 collision (hash tables)—Event that occurs when a hash function   hash function—Function that takes a number as input and
    maps two different items to the same position in a hash           returns a number, called a hash value, within a specified
    table. Some hash tables use chaining to resolve collisions.       range. Hash functions facilitate rapidly storing and
                                                                      retrieving information from hash tables.
 Conversational Monitor System (CMS) (VM) — Component of
   VM that is an interactive application development envi-        hash value—Value returned by a hash function that corre-
   ronment.                                                           sponds to a position in a hash table.
 Control Program (CP) (VM) —Component of VM that runs             hash table—Data structure that indexes items according to
   the physical machine and creates the environment for the           their hash values; used with hash functions to rapidly
   virtual machine.                                                   store and retrieve information.
copy-on-write—Mechanism that improves process creation            IBSYS —Operating system for the IBM 7090 mainframe.
   efficiency by sharing mapping information between par-         Interactive Problem Control System (IPCS) ( V M ) - V M com-
   ent and child until a process modifies a page, at which             ponent that provides online analysis and correction of VM
   point a new copy of the page is created and allocated to            software problems.
   that process. This can incur substantial overhead if the       inverted page table—Page table containing one entry for each
   parent or child modifies many of the shared pages.                  page frame in main memory. Inverted page tables incur
direct mapping—Address translation mechanism that assists in           less table fragmentation than traditional page tables,
    the mapping of virtual addresses to their corresponding            which typically maintain in memory a greater number of

<!-- pág. 523 -->

468       Virtual Memory Organization

      page table entries than page frames. Hash functions map              of Tasks." OS/360-MVT evolved into MVS, the ancestor
      virtual page numbers to an index in the inverted page                of the current IBM mainframe operating system z/OS.
      table.                                                           page—Fixed-size set of contiguous addresses in a process's vir-
linear address space (IA-32 Intel architecture)—32-bit (4GB)               tual address space that is managed as one unit. A page
     virtual address space. Under pure segmentation, this                  contains portions of a process's data and/or instructions
     address space is mapped directly to main memory. Under                and can be placed in any available page frame in main
     segmentation/paging, this address space is divided into               memory.
     page frames that are mapped to main memory.
                                                                       page directory entry (IA-32 Intel architecture) — Entry in a
local descriptor table (LDT) (IA-32 Intel architecture)—Seg-               page directory that maps to the base address of a page
     ment map table that contains mapping information for                  table, which stores page table entries.
     process segments. The system may contain up to 8,191              page fault—Fault that occurs as the result of an error when a
     LDTs, each containing 8,192 entries.                                  process attempts to access a nonresident page, in which
locality—Empirical phenomenon describing events that are                   case the operating system can load it from disk.
     closely related in space or time. When applied to memory
                                                                       page frame—Block of main memory that can store a virtual
     access patterns, spatial locality states that when a process
                                                                           page. In systems with a single page size, any page can be
     references a particular address, it is also likely to access
                                                                           placed in any available page frame.
     nearby addresses; temporal locality states that when a
     process references a particular address, it is likely to refer-   page global directory—In a two-tiered multilevel page table,
     ence it again soon.                                                   the page global directory is a table of pointers to portions
                                                                           of a process's page table. Page global directories are the
logical address space (IA-32 Intel architecture) —Set of
                                                                           top level of a multilevel page table hierarchy.
     addresses contained in a segment.
                                                                       page map table—See page table.
Memory Management Unit (MMU)—Special-purpose hard-
   ware that performs virtual-to-physical address translation.         page table origin register—Register that holds the location of
                                                                           a process's page table in main memory; having this infor-
missing-segment fault—Fault that occurs when a process refer-
                                                                           mation accessible in a high-speed register facilitates rapid
    ences a segment that is not currently in main memory. The
                                                                           virtual-to-physical address translation.
    operating system responds by loading the segment from
    secondary storage into main memory when space is avail-            page table—Table that stores entries that map page numbers
    able.                                                                  to page frames. A page table contains an entry for each of
                                                                           a process's virtual pages.
multilevel paging system—Technique that enables the system
    to store portions of a process's page table in discontiguous       page table entry (PTE)—Entry in a page table that maps a vir-
    locations in main memory and store only those portions                 tual page number to a page frame number. Page table
    that a process is actively using. Multilevel page tables are           entries store other information about a page, such as how
    implemented by creating a hierarchy of page tables, each               the page may be accessed and whether the page is resi-
    level containing a table that stores pointers to tables in the         dent.
    level below. The bottom-most level is comprised of tables          paging—Virtual memory organization technique that divides
    containing the page-to-page-frame mappings. This                       an address space into fixed-size blocks of contiguous
    reduces memory waste compared to single-level page                     addresses. When applied to a process's virtual address
    tables, but incurs greater overhead due to the increased               space, the blocks are called pages, which store process
    number of memory accesses required to perform address                  data and instructions. When applied to main memory, the
    translation when corresponding mappings are not con-                   blocks are called page frames. A page is stored on second-
    tained in the TLB.                                                     ary storage and loaded into a page frame if one is avail-
Multiple Virtual Spaces (MVS)—IBM operating system for                     able. Paging trivializes the memory placement decision
    System/370 mainframes allowing any number of 16MB                      and does not incur external fragmentation (for systems
    virtual address spaces.                                                that contain a single page size); paging does incur internal
                                                                           fragmentation.
offset—See displacement.
OS/360—Operating system for the IBM System/360 main-                   physical address—Location in main memory.
    frames. OS/360 had two major options, MFT and MVT,                 Physical Address Extension (PAE) (IA-32 Intel architec-
    which stood for "Multiprogramming with a Fixed number                  ture)—Mechanism that enables IA-32 processors to
    of Tasks" and "Multiprogramming with a Variable number                 address up to 64GB of main memory.

<!-- pág. 524 -->

                                                                                                               Exercises       469

physical address space—Range of physical addresses corre-           segment-overflow exception—Exception that occurs when a
    sponding to the size of main memory in a given computer.            process attempts to access an address that is outside a seg-
    The physical address space may be (and is often) smaller            ment.
    than each process's virtual address space.                      segment-protection exception—Exception that occurs when a
process table—Table of known processes. In a segmentation/              process attempts to access a segment in ways other than
    paging system, each entry points to a process's virtual             those specified by its access control mode (e.g., attempting
    address space, among other items. '                                 to write to a read-only segment).
pure paging—Memory organization technique that employs              segment selector (IA-32 Intel architecture) — 16-bit value indi-
    paging only, not segmentation.                                      cating the offset into the segment map table at which the
read access—Access right that enables a process to read data            corresponding segment descriptor (i.e., segment map
    from a page or segment; see also execute access, write              table entry) is located.
    access and append access.                                       table fragmentation—Wasted memory consumed by block
                                                                         mapping tables; small blocks tend to increase the number
real address—See physical address.
                                                                         of blocks in the system, which increases table fragmenta-
Remote Spooling Communications Subsystem (RSCS)                          tion.
   (VM) — Component of VM that provides the capability to
                                                                    translation lookaside buffer (TLB)—High-speed associative
   send and receive files in a distributed system.
                                                                        memory map that holds a small number of mappings
segment—Variable-size set of contiguous addresses in a pro-              between virtual page numbers and their corresponding
    cess's virtual address space that is managed as one unit. A         page frame numbers. The TLB typically stores recently
    segment is typically the size of an entire set of similar           used page table entries, which improves performance for
    items, such as a set of instructions in a procedure or the          processes exhibiting locality.
    contents of an array, which enables the system to protect
                                                                    virtual address—Address that a process accesses in a virtual
    such items with fine granularity using appropriate access
                                                                         memory system; virtual addresses are translated to real
    rights. For example, a data segment typically is assigned
                                                                         addresses dynamically at execution time.
    read-only or read/write access, but not execute access. Sim-
    ilarly, a segment containing executable instructions typi-      virtual address space—Range of virtual addresses that a pro-
    cally is assigned read/execute access, but not write access.         cess may reference.
    Segments tend to create external fragmentation in main          virtual memory—Technique that solves the problem of limited
    memory but do not suffer from internal fragmentation.                memory by providing each process with a virtual address
segment descriptor (IA-32 Intel architecture) — Segment map              space (potentially larger than the system's physical
    table entry that stores a segment's base address, present            address space) that the process uses to access data and
    bit, limit address and protection bits.                              instructions.
segment map table origin register—Register that holds the           write access—Access right that enables a process to modify the
    location of a process's segment map table in main mem-               contents of a page or segment; see also execute access,
    ory; having this information accessible in a high-speed              read access and append access.
    register facilitates rapid virtual-to-physical address trans-   z/OS—IBM operating system for zSeries mainframes and the
    lation.                                                             latest version of MVS.




Exercises
10.1 Give several reasons why it is useful to separate a pro-       10.3 Explain the various techniques used for mapping virtual
cess's virtual memory space from its physical memory space.         addresses to physical addresses under paging.
10.2 One attraction of virtual memory is that users no longer       10.4 Discuss the relative merits of each of the following vir-
have to restrict the size of their programs to make them fit into   tual memory mapping techniques.
physical memory. Programming style becomes a freer form of
                                                                          a. direct mapping
expression. Discuss the effects of such a free programming
style on performance in a multiprogramming virtual memory                 b. associative mapping
environment. List both positive and negative effects.                     c. combined direct/associative mapping

<!-- pág. 525 -->

470     Virtual Memory Organization

10.5 Explain the mapping of virtual addresses to physical                  b. How do virtual memory systems with dynamic mem-
addresses under segmentation.                                                 ory allocation greatly reduce the amount of chunk
10.6 Consider a pure paging system that uses 32-bit addresses                 fragmentation over that experienced in real memory
(each of which specifies one byte of memory), contains 128MB                  systems?
of main memory and has a page size of 8KB.                                 c. What effect would smaller page sizes have on chunk
      a. How many page frames does the system contain?                        fragmentation?

      b. How many bits does the system use to maintain the                 d. What considerations, both practical and theoretical,
         displacement, d?                                                     prevent the complete elimination of chunk fragmen-
                                                                              tation?
      c. How many bits does the system use to maintain the
         page number,p?                                                    e. What can each of the following do to minimize chunk
                                                                              fragmentation?
10.7 Consider a pure paging system that uses three levels of
                                                                              i.    the programmer
page tables and 64-bit addresses. Each virtual address is the
ordered set v = (p,m, t, d), where the ordered triple (p, m, t) is            ii.   the hardware designer
the page number and d is the displacement into the page. Each                 iii. the operating system designer
page table entry is 64 bits (8 bytes). The number of bits that
                                                                     10.12 Explain the mapping of virtual addresses to physical
store p is np, the number of bits that store m is nm and the
                                                                     addresses under combined segmentation/paging.
number of bits to store t is nt.
                                                                     10.13 In multiprogramming environments, code and data shar-
      a. Assume np = nm = nt= 18.
                                                                     ing can greatly reduce the main memory needed by a group of
         i.  How large is the table at each level of the multi-      processes to run efficiently. For each of the following types of
             level page table?                                       systems, outline briefly how sharing can be implemented.
         ii. What is the page size, in bytes?
                                                                           a. fixed-partition multiprogramming
      b. Assume np = nm = nt = 14.
                                                                           b. variable-partition multiprogramming
         i.  How large the table at each level of the multi-
                                                                           c. paging
             level page table?
                                                                           d. segmentation
         ii. What is the page size, in bytes?
                                                                           e. combined segmentation/paging
      c. Discuss the trade-offs of large and small table sizes.
                                                                     10.14 Why is sharing of code and data so much more natural in
10.8 Explain how memory protection is implemented in vir-
                                                                     virtual memory systems than in real memory systems?
tual memory systems with segmentation.
                                                                     10.15 Discuss the similarities and differences between paging
10.9 Discuss the various hardware features useful for imple-
                                                                     and segmentation.
menting virtual memory systems.
10.10 Discuss how fragmentation manifests itself in each of          10.16 Compare and contrast pure segmentation with segmen-
                                                                     tation/paging combined.
the following types of virtual memory systems.
       a. segmentation                                               10.17 Suppose you are asked to implement segmentation on a
       b. paging                                                     machine that has paging hardware but no segmentation hard-
                                                                     ware. You may use only software techniques. Is this possible?
       c. combined segmentation/paging
                                                                     Explain your answer.
10.11 In any computer system, regardless of whether it is a real
                                                                     10.18 Suppose you are asked to implement paging on a
memory system or a virtual memory system, the computer will
                                                                     machine that has segmentation hardware but no paging hard-
rarely reference all the instructions or data brought into main
                                                                     ware. You may use only software techniques. Is this possible?
memory. Let us call this chunk fragmentation, because it is the
                                                                     Explain your answer.
result of handling memory items in blocks or chunks rather
than individually. Chunk fragmentation might actually account        10.19 As the chief designer of a new virtual memory system you
for more waste of main memory than all other types of frag-          have been given the choice of implementing either paging or
mentation combined.                                                  segmentation, but not both. Which would you choose? Why?
      a. Why, then, has chunk fragmentation not been given           10.20 Suppose that economical associative memory were to
         the same coverage in the literature as other forms of       become available. How might such associative memory be
         fragmentation?                                              incorporated into future computer architectures to improve

<!-- pág. 526 -->

                                                                                                                                                         Exercises              471

the performance of the hardware, the operating system, and                               ondary storage. What are the costs and benefits of each
user programs?                                                                           approach?
10.21 Give as many ways as you can in which executing a pro-                             10.27 Why did virtual memory emerge as an important
gram on a virtual memory system differs from executing the                               scheme? Why did real memory schemes prove inadequate?
same program on a real memory system. Do these observa-                                  What current trends could conceivably negate the usefulness
tions lead you to favor real memory approaches or virtual                                of virtual memory?
memory approaches?                                                                       10.28 What aspect of paging with a single page size makes
10.22 Give as many reasons as you can why locality is a rea-                             page-replacement algorithms so much simpler than segment-
sonable phenomenon. Give as many examples as you can of                                  replacement algorithms? What hardware or software features
situations in which locality simply does not apply.                                      might be used in support of segment replacement that could
                                                                                         make it almost as straightforward as page replacement in a sys-
10.23 One popular operating system provides separate virtual                             tem with a single page size?
 address spaces to each of its processes, while another has all
processes share a single large address space. Compare and                                10.29 What aspect of content-addressed associative memory
contrast these two different approaches.                                                 will probably ensure that such memory will remain far more
                                                                                         costly than location-addressed cache memory?
10.24 Virtual address translation mechanisms are not without
their costs. List as many factors as you can that contribute to                          10.30 Suppose you are designing a portion of an operating sys-
the overhead of operating a virtual-address-to-physical-                                 tem that requires high-speed information retrieval (such as a
 address translation mechanism. How do these factors tend to                             virtual address translation mechanism). Suppose that you have
  "shape" the hardware and software of systems that support                              been given the option of implementing your search-and-
such address translation mechanisms?                                                     retrieval mechanism with either pure direct mapping, using a
                                                                                         high-speed cache, or pure associative mapping. What factors
10.25 The Multics system, as originally designed, provided for                           would influence your choice? What interesting kind(s) of ques-
two page sizes. It was believed that the large number of small                           tion(s) could conceivably be answered by an associative search
data structures could occupy small pages, and that most other                            (in one access) that cannot be answered in a single direct-
procedures and data structures would best occupy one or more                             mapped search?
large pages. How does a memory organization scheme that
                                                                                         10.31 Deciding what entries to keep in the TLB is crucial to
supports multiple page sizes differ from one that supports a
                                                                                         the efficient operation of a virtual memory system. The per-
single page size? Suppose a system were designed to support n
                                                                                         centage of references that get "resolved" via the TLB is called
page sizes. How would it differ from the Multics approach? Is
                                                                                         the TLB hit ratio. Compare and contrast the performance of
a system that supports a large number of page sizes essentially
                                                                                         virtual address translation systems that achieve a high (near
equivalent to a segmentation system? Explain.
                                                                                         100 percent) hit ratio versus those that achieve a low (near 0
10.26 With multilevel page tables, a process's PTE can be ini-                           percent) hit ratio. List several heuristics not mentioned in the
tialized when the process is first loaded, or each PTE can be                            text that you believe would achieve high hit ratios. Indicate
 initialized the first time its corresponding page is referenced.                        examples of how each might fail, i.e., under what circum-
Similarly, the entire multilevel page table structure can be                             stances would these heuristics place the "wrong" entries into
maintained in main memory, or parts of it can be sent to sec-                            the TLB?


Suggested Projects
10.32 Describe how the IA-32 architecture enables processes                              10.34 Compare and contrast the 64-bit Hewlett-Packard PA-
to access up to 64GB of main memory. See d e v e l -                                     RISC architecture virtual memory implementation with that of
oper .i ntel.com/design/Pentium4/manuals/.                                               the 32-bit Intel IA-32 architecture. See d e v e l o p e r . i n t e l . c o m /
                                                                                         design/Pentium4/manuals/ and cpus.hp.com/technical_
10.33 Compare and contrast the IBM/Motorola PowerPC
                                                                                         r e f e r e n c e s / p a r i s c . shtml.
 architecture virtual memory implementation with that of the
IA-32 Intel architecture. Discuss how 64-bit processing affects                          10.35 Survey the differences between the virtual memory
memory organization in the PowerPC. See d e v e l -                                      implementation in the 32-bit Intel IA-32 architecture and in
o p e r . i n t e l . c o m / d e s i g n / P e n t i u m 4 / m a n u a l s / and www-   the 64-bit IA-64 Intel                                 architecture. See d e v e l -
3.ibm.com/chips/techlib/techlib.nsf/productfami-                                         o p e r . i n t e l . c o m / d e s i g n / P e n t i u m 4 / m a n u a l s / and d e v e l -
lies/PowerPC_Microprocessors_and_Embedded_                                               oper.intel.com/design/itanium/manuals/iiasdmanual.
Processors.                                                                              htm (select Volume 2: System Architecture).

<!-- pág. 527 -->

472 Virtual Memory Organization

Recommended Reading
The concept of virtual memory has been around for decades;              tion, such as combined segmentation and paging, can be found
an early comprehensive survey was produced by Denning. 101              in papers by Daley and Dennis 106 and Denning. 107 Jacob and
The benefits of virtual memory systems spurred the develop-             Mudge 108 provide an excellent survey of virtual memory orga-
ment of specialized hardware to increase their performance              nization techniques and their implementations in modern sys-
and feasibility.102 Associative memories for dynamic address            tems. Two popular textbooks on computer architecture that
translation were presented by Hanlon, 103 and their role in stor-       describe the implementations of MMUs are Patterson and
ing TLB entries has been studied thoroughly.104                         Hennessy's Computer Organization and Design109 and Blaauw
      Denning discusses paging in his work on virtual mem-              and Brooks's Computer Architecture.110 The bibliography for
ory; an in-depth treatment of segmentation is provided by               this chapter is located on our Web site at www.deitel.com/
Dennis. 105 Further discussions on virtual memory organiza-             books/os3e/Bibliography.pdf.



Works Cited
 1. Shiell, I, "Virtual Memory, Virtual Machines," Byte, Vol. 11, No.   14- Lavington, S., "The Manchester Mark I and Atlas: A Historical
    11,1986, pp. 110-121.                                                   Perspective," Communications of the ACM, January 1978, pp. 4-
 2. Leonard, T. E., ed., VAX Architecture Reference Manual, Bed-            12.
    ford, MA: Digital Press, 1987.                                      15. Lavington, S., "The Manchester Mark I and Atlas: A Historical
 3. Kenah, L. J.; R. E. Goldenberg; and S. F. Bate, VAX/VMS Inter-          Perspective," Communications of the ACM, January 1978, pp. 4-
    nals and Data Structures, Bedford, MA: Digital Press, 1988.             12.
 4. Fotheringham, X, "Dynamic Storage Allocation in the Atlas           16. Manchester University Department of Computer Science "The
    Computer, Including an Automatic Use of a Backing Store,"               Atlas,"            1996, <www.computer50.org/kgill/atlas/
    Communications of the ACM, Vol. 4,1961, pp. 435-436.                    a t l a s . html>.
 5. Kilburn, T.; D. J. Howarth; R. B. Payne; and F. H. Sumner, "The     17. Lavington, S., "The Manchester Mark I and Atlas: A Historical
    Manchester University Atlas Operating System, Part I: Internal          Perspective," Communications of the ACM, January 1978, pp. 4-
    Organization," Computer Journal, Vol. 4, No. 3, October 1961,           12.
    pp. 222-225.                                                        18. Denning, P., "Virtual Memory," ACM Computing Surveys, Vol. 2.
 6. Kilburn, T.; R. B. Payne; and D. J. Howarth, "The Atlas Supervi-        No. 3, September 1970, pp. 153-189.
    sor," Proceedings of the Eastern Joint Computer Conference,         19. George Mason University, "Peter J. Denning—Biosketch," Janu-
    AFIPS,Vol. 20, 1961.                                                    ary 1,2003, <cne.gmu.edu/pjd/pjdbio.html>.
 7. Lavington, S. H.. "The Manchester Mark I and Atlas: A Histori-      20. Denning, P., "The Working Set Model for Program Behavior."
    cal Perspective," Communications of the ACM, Vol. 21, No. 1,            Communications of the ACM, Vol. 11, No. 5, May 1968, pp. 323-
    January 1978, pp. 4-12.                                                 333.
 8. Manchester University Department of Computer Science, "The          21. George Mason University, "Peter J. Denning —Biosketch," Janu-
    Atlas," 1996, <www.computer50.org/kgill/atlas/atlas.html>.              ary 1,2003, <cne.gmu.edu/pjd/pjdbio.html>.
 9. Manchester University Department of Computer Science, "His-         22. George Mason University, "Peter J. Denning—Biosketch," Janu-
    tory of the Department of Computer Science," December 14,               ary 1,2003, <cne.gmu.edu/pjd/pjdbio.html>.
    2001,<www.cs.man.ac.uk/Visitor_subweb/history.php3>.                23. ACM, "Peter J. D e n n i n g - A C M Karlstrom Citation 1996," 1996.
10.   Manchester University Department of Computer Science, "His-           <cne.gmu.edu/pjd/pjdkka96.html>.
      tory of the Department of Computer Science," December 14,         24. Randell, B., and C. J. Kuehner, "Dynamic Storage Allocation
      2001, <www.cs.man.ac.uk/Visitor_subweb/history.php3>.                 Systems," Proceedings of the ACM Symposium on Operating Sys-
n.    Lavington, S., "The Manchester Mark 1 and Atlas: A Historical         tem Principles, January 1967, pp. 9.1-9.16.
      Perspective," Communications of the ACM, January 1978, pp. 4-     25. McKeag, R. M., "Burroughs B5500 Master Control Program," in
      12.                                                                   Studies in Operating Systems, Academic Press, 1976, pp. 1-66.
12. Lavington, S., "The Manchester Mark I and Atlas: A Historical       26. Oliphint, C, "Operating System for the B5000," Datamation, Vol.
    Perspective," Communications of the ACM, January 1978, pp. 4-           10, No. 5,1964, pp. 42-54.
    12.                                                                 27. Talluri, M.; S. Kong; M. D. Hill; and D. A. Patterson, "Tradeoffs
13. Manchester University Department of Computer Science, "The              in Supporting Two Page Sizes," In Proceedings of the 19th Inter-
    Atlas,"      1996,      <www.computer50.org/kgill/atlas/                national Symposium on Computer Architecture, Gold Coast, Aus-
    atlas.html>.                                                            tralia, May 1992, pp. 415-424.

<!-- pág. 528 -->

                                                                                                                   Works Cited 473

28. Hanlon, A. G., "Content-Addressable and Associative Memory         44. Daley, R. C, and J. B. Dennis, "Virtual Memory, Processes and
    Systems—A Survey," IEEE Transactions on Electronic Comput-             Sharing in Multics," CACM, Vol. 11. No. 5, May 1968, pp. 306-
    ers, August 1966.                                                      312.
29. Lindquist, A. B.; R. R. Seeder; and L. W. Comeau, "A Time-Shar-    45. Denning, P. X, "Third Generation Computing Systems," ACM
    ing System Using an Associative Memory," Proceedings of the            Computing Surveys, Vol. 3, No. 4. December 1971, pp. 175-216.
    IEEE, Vol. 54,1966, pp. 1774-1779.                                 46. Bensoussan. A.; C. T. Clingen: and R. C. Daley, "The Multics Vir-
30. Cook, R., et al., "Cache Memories: A Tutorial and Survey of Cur-       tual Memory: Concepts and Design," Communications of the
    rent Research Directions," ACM/CSC-ER, 1982, pp. 99-110.               ACM. Vol 15, No. 5, May 1972, pp. 308-318.

31. Wang, Z.; D. Burger; K. S. McKinley; S. K. Reinhardt; and C. C.    47. Organick, E. I., The Multics System: An Examination of Its Struc-
    Weems, "Guided Region Prefetching: A Cooperative Hardware/             ture. Cambridge, MA: M.I.T Press, 1972.
    Software Approach," Proceedings of the 30th Annual Interna-        48. Doran. R. W., "Virtual Memory," Computer, Vol. 9, No. 10, Octo-
    tional Symposium on Computer Architecture, 2003, p. 388.               ber 1976. pp. 27-37.
32. Jacob, B. L., and T. N. Mudge, "A Look at Several Memory Man-      49. Belady, L. A.; R. P. Parmelee; and C. A. Scalzi, "The IBM History
    agement Units, TLB-Refill Mechanisms, and Page Table Organi-           of Memory Management Technology," IBM Journal of Research
    zations," Proceedings of the Eighth International Conference on        and Development, Vol. 25, No. 5, September 1981, pp. 491-503.
    Architectural Support for Programming Languages and Operat-        50. IA-32 Intel Architecture Software Developer's Manual, Vol. 3, Sys-
    ing Systems, 1998, pp. 295-306.                                        tem Programmer's Guide. 2002, pp. 3-1-3-38.
33. Kandiraju, G. B., and A. Sivasubramaniam, "Characterizing the      51. da Cruz, F., "The IBM 7090," July 2003, <www.columbia.edu/
    d-TLB Behavior of SPEC CPU2000 Benchmarks," ACM SIG-                   acis/history/7090.html>.
    METRICS Performance Evaluation Review, Proceedings of the          52. Harper, I, "7090/94 IBSYS Operating System," August 23,2001,
    2002 ACM SIGMETRICS International Conference on Measure-               <www.frobenius.com/ibsys.htm>.
    ment and Modeling of Computer Systems, Vol. 30, No. 1, June        53. Harper, X, "7090/94 IBSYS Operating System," August 23, 2001,
    2002.                                                                  <www.frobenius.com/ibsys.htm>.
34. Sohoni, S.; R. Min; Z. Xu; and Y. Hu, "A Study of Memory Sys-      54. Poulsen, L., "Computer History: IBM 360/370/3090/390," Octo-
    tem Performance of Multimedia Applications," ACM SIGMET-               ber 26, 2001,     <www.beagle-ears.com/lars/engineer/com-
    RICS Performance Evaluation Review, Proceedings of the 2001            phist/ibm360.htm>.
    ACM SIGMETRICS International Conference on Measurement             55. Suko. R., "MVS ... a Long History." December 15, 2002, <os390-
    and Modeling of Computer Systems,Vol. 29, No. 1, June 2001.            mvs.hypermart.net/mvshist.htm>.
35. Kandiraju, Gokul B., and Anand Sivasubramaniam, "Going the         56. Poulsen, L., "Computer History: IBM 360/370/3090/390," Octo-
    Distance for TLB Prefetching: An Application-Driven Study,"            ber 26, 2001,     <www.beagle-ears.com/lars/engineer/com-
    ACM SIGARCH Computer Architecture News, Proceedings of                 phist/ibm360.htm>.
    the 29th Annual International Symposium on Computer Architec-      57. Suko, R., "MVS ... a Long History," December 15, 2002, <os390-
    ture, Vol. 30, No. 2, May 2002.                                        mvs.hypermart.net/mvshist.htm>.
36. Jacob, B., and T. Mudge, "Virtual Memory: Issues of Implementa-    58. Mealy. G., "The Functional Structure of OS/360, Part 1: Introduc-
    tion," IEEE Computer, Vol. 31, No. 6, June 1998, p. 36.                tory Survey," IBM Systems Journal, Vol. 5, No. 1, 1966,
37. Jacob, B., and T. Mudge, "Virtual Memory: Issues of Implementa-        <www.research.ibm.com/journal/sj/051/ibmsj0501B.pdf>.
    tion," IEEE Computer, Vol. 31, No. 6, June 1998, pp. 37-38.        59. Mealy, G., "The Functional Structure of OS/360, Part 1: Introduc-
38. Shyu, I., "Virtual Address Translation for Wide-Address Archi-         tory Survey." IBM Systems Journal, Vol. 5, No. 1, 1966,
    tectures," ACM SIGOPS Operating Systems Review, Vol. 29, No.           <www.research.ibm.com/journal/sj/O5l/ibmsj0501B.pdf>.
    4, October 1995, pp. 41-42.                                        60. Poulsen, L„ "Computer History: IBM 360/370/3090/390," Octo-
                                                                           ber 26, 2001,     <www.beagle-ears.com/lars/engineer/com-
39. Holliday, M. A., "Page Table Management in Local/Remote
                                                                           phist/ibm360.htm>.
    Architectures," Proceedings of the Second International Confer-
    ence on Supercomputing, New York: ACM Press, June 1988, p. 2.      61. Suko, R., "MVS ... a Long History," December 15, 2002, <os390-
                                                                           mvs.hypermart.net/mvshist.htm>.
40. Jacob, B., and T. Mudge, "Virtual Memory: Issues of Implementa-
                                                                       62. Poulsen, L., "Computer History: IBM 360/370/3090/390," Octo-
    tion," IEEE Computer, Vol. 31, No. 6, June 1998, pp. 37-38.
                                                                           ber 26, 2001,     <www.beagle-ears.com/lars/engineer/com-
41. Dennis, J. B., "Segmentation and the Design of Multipro-               phist/ibm360.htm>.
    grammed Computer Systems," Journal of the ACM, Vol. 12, No.
                                                                       63. Suko, R„ "MVS ... a Long History," December 15, 2002 <os390-
    4, October 1965, pp. 589-602.
                                                                           mvs.hypermart.net/mvshist.htm>.
42. Denning, P., "Virtual Memory," ACM Computing Surveys, Vol. 2,      64. Poulsen. L., "Computer History: IBM 360/370/3090/390," Octo-
    No. 3, September 1970, pp. 153-189.                                    ber 26, 2001,      <www.beagle-ears.com/lars/engineer/com-
43. Intel Itanium Software Developer's Manual, Vol. 2, System Archi-       phist/ibm360.htm>.
    tecture, Rev. 2.1, October 2002, pp. 2-431-2-432.

<!-- pág. 529 -->

474     Virtual Memory Organization

65. Suko, R., "MVS ... a Long History," December 15,2002, <os390-    86. Clark, C, "The Facilities and Evolution of MVS/ESA," IBM Sys-
    mvs.hypermart.net/mvshist.htm>.                                      tems Journal, Vol. 28, No. 1, 1989, <www.research.ibm.com/
66. Poulsen, L., "Computer History: IBM 360/370/3090/390," Octo-         journal/sj/281/ibmsj28011.pdf>.
    ber 26, 2001,    <www.beagle-ears.com/lars/engineer/com-         87. Mainframes.com, "Mainframes.com—SYSPLEX," <www.main-
    phist/ibm360.htm>.                                                   frames.com/sysplex.html>.
67. Poulsen, L., "Computer History: IBM 360/370/3090/390," Octo-     88. Suko. R.."MVS ...a Long History," December 15, 2002, <os390-
    ber 26, 2001,    <www.beagle-ears.com/lars/engineer/com-             mvs.hypermart.net/mvshist.htm>.
    phist/ibm360.htm>.
                                                                     89. IBM, "S/390 Parallel Enterprise Server and OS/390 Reference
68. Suko, R., "MVS ... a Long History," December 15,2002, <os390-        Guide," May 2000, <www-l.ibrn.com/servers/eserver/
    mvs.hypermart.net/mvshist.htm>.                                      zseries/library/refguides/pdf/g3263070.pdf>.
69. Clark, C, "The Facilities and Evolution of MVS/ESA," IBM Sys-    90. IBM, "IBM eServer zSeries Mainframe             Servers,"   <www-
    tems Journal, Vol. 28, No. 1, 1989, <www.research.ibm.com/           1.ibrn.com/servers/eserver/zseries/>.
    journal/sj/281/ibmsj28011.pdf>.
                                                                     91. Spruth, W.. "The Evolution of S/390," July 30, 2001, <www-
70. Poulsen, L., "Computer History: IBM 360/370/3090/390," Octo-         ti.informatik.uni-tuebingen.de/os390/arch/his-
    ber 26, 2001,     <www.beagle-ears.com/lars/engineer/com-            tory.pdf>.
    phist/ibm360.htm>.
                                                                     92. Case, R. P. and A. Padegs, "Architecture of the IBM System/370."
71. Suko, R., "MVS ... a Long History," December 15, 2002, <os390-
                                                                         Communications of the ACM, January 1978, pp. 73-96.
    mvs.hypermart.net/mvshist.htm>.
                                                                     93. Gifford, D. and A. Spector, "Case Study: IBM's System/360-370
72. Poulsen, L., "Computer History: IBM 360/370/3090/390," Octo-
                                                                         Architecture," Communications of the ACM, April 1987, pp. 291-
    ber 26, 2001,     <www.beagle-ears.com/lars/engineer/com-
                                                                         307.
    phist/ibm360.htm>.
73. Suko, R., "MVS ... a Long History," December 15, 2002, <os390-   94. IBM,   "z/VM     General    Information,          V4.4,"    2003.
    mvs.hypermart.net/mvshist.htm>.                                      <www.vm.ibm.com/pubs/pdf/HCSF8A60.PDF>.
74. Suko, R., "MVS ... a Long History," December 15, 2002, <os390-   95. Kutnick, D., "Whither VM?" Datamation, December 1, 1985.
    mvs.hypermart.net/mvshist.htm>.                                      pp. 73-78.
75. Clark, C, "The Facilities and Evolution of MVS/ESA," IBM Sys-    96. Doran, R. W., "Amdahl Multiple-Domain Architecture," Com-
    tems Journal, Vol. 28, No. 1, 1989, <www.research.ibm.com/           puter, October 1988, pp. 20-28.
    journal/sj/281/ibmsj28011.pdf>.                                  97. Adair, A.J.; R. U. Bayles; L. W. Comeau; and R. J. Creasy, "A Vir-
76. Suko, R., "MVS ... a Long History," December 15,2002, <os390-        tual Machine System for the 360/40," Cambridge, MA: IBM Sci-
    mvs.hypermart.net/mvshist.htm>.                                      entific Center Report 320-2007', May 1966.
77. D. Elder-Vass, "MVS Systems Programming: Chapter 3a—MVS          98. Lett, A.S. and W. L. Konigsford, "TSS/360: A Time-Shared Oper-
    Internals,"   July    5,   1998,   <www.mvsbook.fsnet.co.uk/         ating System," Proceedings of the Fall Joint Computer Confer-
    chap03a.htm>.                                                        ence, AFIPS, 1968, Montvale, NJ: AFIPS Press, pp. 15-28.
78. Suko, R., "MVS ... a Long History," December 15, 2002, <os390-   99. Creasy, R. J., "The Origin of the VM/370 Time-Sharing System."
    mvs.hypermart.net/mvshist.htm>.                                      IBM Journal of R&D, September 1981, pp. 483-490.
79. Clark, C, "The Facilities and Evolution of MVS/ESA," IBM Sys-    100. IBM,   "IBM    z/VM         and    VM/ESA       Home       Page."
    tems Journal, Vol. 28, No. 1, 1989, <www.research.ibm.com/            <www.vm.ibm.com/>.
    journal/sj/281/ibmsj28011.pdf>.                                  101. Denning, P., "Virtual Memory," ACM Computing Surveys, Vol. 2.
80. Suko, R., "MVS ... a Long History," December 15,2002, <os390-         No. 3, September 1970, pp. 153-189.
    mvs.hypermart.net/mvshist.htm>.
                                                                     102. Randell, B., and C. J. Kuehner, "Dynamic Storage Allocation
81. Clark, C, "The Facilities and Evolution of MVS/ESA," IBM Sys-         Systems," Proceedings of the ACM Symposium on Operating Sys-
    tems Journal, Vol. 28, No. 1, 1989, <www.research.ibm.com/            tem Principles, January 1967, pp. 9.1-9.16.
    journal/sj/281/ibmsj2801I.pdf>.
                                                                     103. Hanlon. A. G., "Content-Addressable and Associative Memory
82. Elder-Vass, D, "MVS Systems Programming: Chapter 3a—MVS               Systems—A Survey," IEEE Transactions on Electronic Comput-
    Internals,"   5    July    1998,   <www.mvsbook.fsnet.co.uk/          ers, August 1966.
    chap03a.htm>.
                                                                     104. Smith, A. J., "Cache Memories," ACM Computing Surveys, Vol.
83. Suko, R., "MVS ... a Long History," December 15,2002, <os390-
                                                                          14, No. 3, September 1982, pp. 473-530.
    mvs.hypermart.net/mvshist.htm>.
                                                                     105. Dennis, J. B., "Segmentation and the Design of Multipro-
84. Clark, C, "The Facilities and Evolution of MVS/ESA," IBM Sys-
                                                                          grammed Computer Systems," Journal of the ACM, Vol. 12, No.
    tems Journal, Vol. 28, No. 1, 1989, <www.research.ibm.com/
                                                                          4, October 1965, pp. 589-602.
    journal/sj/281/ibmsj28011.pdf>.
                                                                     106. Daley, R. C, and J. B. Dennis, "Virtual Memory, Processes and
85. Suko, R., "MVS ... a Long History," December 15, 2002, <os390-
                                                                          Sharing in Multics," CACM, Vol. 11, No. 5, May 1968, pp. 306-312.
    mvs.hypermart.net/mvshist.htm>.

<!-- pág. 530 -->

                                                                                                                 Works Cited 475
107. Denning, P. J., "Third Generation Computing Systems," ACM         109. Patterson, D., and J. Hennessy, Computer Organization and
     Computing Surveys, Vol. 3, No. 4, December 1971, pp. 175-216.          Design, San Francisco: Morgan Kaufmann Publishers, Inc., 1998.
108. Jacob, B., and T. Mudge, "Virtual Memory: Issues of Implementa-   n o . Blaauw, G. A., and F. P. Brooks, Jr., Computer Architecture,
     tion," IEEE Computer,Vol 31, No. 6, June 1998.                          Reading, MA: ACM Press, 1997.

<!-- pág. 531 -->

What we anticipate seldom occurs; what we least expect generally happens.
       —Benjamin Disraeli—

Time will run back and fetch the Age of Gold.
       —John Milton —


Faultless to a fault.
       —Robert Browning—


Condemn the fault and not the actor of it?
       —William Shakespeare—


Gather up the fragments that remain, that nothing be lost.
       -John 6:12-

