# Chapter 15 - Multiprocessor Management

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 737–799 (numeración del PDF)

<!-- pág. 737 -->

Chapter 15


Multiprocessor
         Management
 Objectives
 After reading this chapter, you should understand:
 • multiprocessor architectures and operating system organizations.
 • multiprocessor memory architectures.
 • design issues specific to multiprocessor environments.
 • algorithms for multiprocessor scheduling.
 • process migration in multiprocessor systems.
 • load balancing in multiprocessor systems.
 • mutual exclusion techniques for multiprocessor systems.

<!-- pág. 738 -->

                                   Chapter Outline

                        15.1                                    15.5
                  Introduction                        Multiprocessor Memory
       Mini Case Study: Supercomputers                            Sharing
       Biographical Note: Seymour Cray             Operating Systems Thinking: Data
                                                          Replication and C o h e r e n c y
                                                          15.5.1 Cache Coherence
                       15.2                        15.5.2 Page Replication and Migration
       Multiprocessor Architecture
      15.2.1 Classifying Sequential and Parallel      15.5.3 Shared Virtual Memory
                     Architectures
         15.2.2 Processor Interconnection
                      Schemes                                   15.6
  15.2.3 Loosely Coupled vs. Tightly Coupled        Multiprocessor Scheduling
                   Systems                            15.6.1 Job-Blind Multiprocessor
                                                                 Scheduling
                        15.3                         15.6.2   Job-Aware     Multiprocessor
         Multiprocessor Operating                                  Scheduling
       System Organizations
           15.3.1  Master/Slave
         15.3.2 Separate Kernels                                      15.7
    15.3.3 Symmetrical Organization
                                                          Process Migration
  Operating Systems Thinking: Graceful               15.7.1 Flow of Process Migration
                     Degradation                    15.7.2 Process Migration Concepts
                                                    15.7.3 Process Migration Strategies
                        15.4
       Memory Access Architectures                                15.8
          15.4.1 Uniform Memory Access
        15.4.2 Nonuniform Memory Access
                                                             Load Balancing
                                                        15.8.1    Static Load Balancing
      15.4.3 Cache-Only Memory Architecture
                                                      15.8.2 Dynamic Load Balancing
        15.4.4 No Remote Memory Access




684

<!-- pág. 739 -->

            15.9
 Multiprocessor      Mutual
         Exclusion
      15.9.1 Spin Locks
  15.9.2 Sleep/Wakeup Locks
   15.9.3 Read/Write Locks




Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited




                                                                                      685

<!-- pág. 740 -->

686    Multiprocessor Management


                                    15.1 Introduction
                                    For decades, Moore's Law has successfully predicted an exponential rise in proces-
                                    sor transistor count and performance, yielding ever more powerful processors.
                                    Despite these performance gains, researchers, developers, businesses and consum-
                                    ers continue to demand substantially more computing power than one processor
                                    can provide. As a result, multiprocessing systems—computers that contain more
                                    than one processor —are employed in many computing environments.
                                          Large engineering and scientific applications that execute on supercomputers
                                    increase throughput by processing data in parallel on multiple processors. Busi-
                                    nesses and scientific institutions use multiprocessing systems to increase system per-
                                    formance, scale resource usage to application requirements and provide a high
                                    degree of data reliability.1 For example, the Earth Simulator in Yokohama, Japan —
                                    the most powerful supercomputer as of June, 2003 —contains 5,f20 processors, each
                                    operating at 500MHz (see the Mini Case Study, Supercomputers). The system can




                    Mini Case Study
      Supercomputers
      Supercomputer is simply a term           ing) architecture. 6 ' 7 Roughly 10    ond-fastest computer and tens of
      for the most powerful contempo-          years and several machines later,      thousands of times faster than a
      rary computers. The early super-         Cray designed the Cray-1, one of       typical desktop machine. 9, 10 The
      computers would be no match for          the earliest vector-processor mod-     Earth Simulator consists of 5,120
      today's inexpensive PCs. The             els.8 (Vector processors are dis-      vector processors grouped into
      speed of a supercomputer is mea-         cussed in Section 15.2.1,              640 units of eight processors each,
      sured in Flops (Floating-point           Classifying Sequential and Parallel    where each unit has 16GB of
      operations per second).                  Architectures.) The supercomput-       shared main memory, totalling
             The first supercomputer was       ers that Cray designed dominated       10TB of memory.11, 12 These units
      the CDC 6600, manufactured by            the high-performance field for         are connected by 1500 miles of
      Control Data Corporation and             many years.                            network cable and are linked to a
      designed by Seymour Cray, w h o                According to the supercom-       640TB disk system and a tape
      became known as the father of            puter tracking organization            library that can hold over 1.5
      supercomputing (see the Bio-             Top500 (www.top500.org), the           petabytes (1,500,000,000,000,000
      graphical Note, Seymour Cray).2, 3       fastest computer in the world (at      bytes).13, 14 This enormous com-
      This machine, released in the early      the time this book was published)      puting capacity is used for
      1960's, processed 3 million instruc-     is NEC's Earth Simulator, located in   research in predicting environ-
      tions per second. 4, 5 It was also the   Japan. It operates at a peak speed     mental conditions and events. 15
      first computer to use the RISC           of roughly 35 teraflops, more
      (reduced instruction set comput-         than twice the speed of the sec-

<!-- pág. 741 -->

                                                                                                   15.1 Introduction 687
execute 35.86 Tflops (trillion floating point operations per second), enabling
researchers to model weather patterns, which can be used to predict natural disas-
ters and evaluate how human activities affect nature. 16, 17
      Multiprocessing systems must adapt to different workloads. In particular, the
operating system should ensure that
     • all processors remain busy
     • processes are evenly distributed throughout the system
     • execution of related processes is synchronized
     • processors operate on consistent copies of data stored in shared memory
     • mutual exclusion is enforced.
Techniques used to solve deadlock in multiprocessing and distributed systems are
similar and are discussed in Chapter 17, Introduction to Distributed Systems.
      This chapter describes multiprocessor architectures and techniques for opti-
mizing multiprocessing systems. These techniques focus on improving performance,




                Biographical Note
  Seymour Cray
  Seymour Cray is known as the              pletely replaced vacuum tubes             The Cray-1 was much smaller yet
  father of supercomputing. Shortly         w i t h transistors. 26, 27, 28 In 1962   more powerful than the CDC
  after getting his Masters in              Cray designed the CDC 6600, the           7600. 37 It was also visually inter-
  Applied Mathematics from the              first true "supercomputer," f o l -       esting, curving around to form a
  University of Minnesota in 1951,          lowed by the CDC 7600.29, 30, 31 He       cylinder w i t h a gap, and equipped
  he joined Engineering Research            always strove for simplicity, so the      w i t h a bench running around the
  Associates (ERA), one of the first        CDC 6600 featured a simplified            outside. 38 It ran at 133 megaflops,
  companies to build digital                architecture based on a smaller           which was extraordinarily fast at
  computers. 18, 19, 21 At ERA Cray         set of instructions—a design phi-         that time, but slower than today's
  designed the 1103, the first com-         losophy later called RISC (reduced        typical desktop PCs.39 The Cray-1
  puter designed for scientific             instruction set computing). 32, 33, 34    was followed by three more Cray
  research that also sold well to the                Seymour Cray founded Cray        models, each progressively faster
  general market. 20, 22                    Research in 1972 to continue              and more compact than the last.
        In 1957, Cray left the com-         building large scientific comput-         The computational unit (not
  pany w i t h William Norris (the          ers.35 The Cray-1, one of the earli-      including the memory banks and
  founder of ERA) to start Control          est vector-processor computers,           cooling equipment) of the Cray-4
  Data Corporation. 2 3 2 4 - 2 5 By 1960   was released in 1976 (see                 was smaller than the human
  Cray had designed the CDC 1604,           Section 15.2.1, Classifying Sequen-       brain. 40
  the first computer that com-              tial and Parallel Architectures). 36

<!-- pág. 742 -->

688 Multiprocessor Management
                          fairness, cost and fault tolerance. Often, improvement in one of these parameter-
                          occurs at the expense of the others. We also consider how design decisions can
                          affect multiprocessor performance.

                          Self Review
                          1. Why are multiprocessors useful?
                          2. How do the responsibilities of a multiprocessor operating system differ from those of a
                             uniprocessor system?
                          Ans: 1) Many computer users demand more processing power than one processor can provide
                          For example, businesses can use multiprocessors to increase performance and scale resource
                          usage to application needs. 2) The operating system must balance the workload of various pro-
                          cessors, enforce mutual exclusion in a system where multiple processes can execute truly simul-
                          taneously and ensure that all processors are made aware of modifications to shared memory.


                          15.2 Multiprocessor Architecture
                          The term "multiprocessing system" encompasses any system containing more than
                          one processor. Examples of multiprocessors include dual-processor personal com-
                          puters, powerful servers that contain many processors and distributed groups of
                          workstations that work together to perform tasks.
                                Throughout this chapter we present several ways to classify multiprocessors.
                          In this section, we categorize multiprocessing systems by their physical properties,
                          such as the nature of the system's datapath (i.e., the portion of the processor that
                          performs operations on data), the processor interconnection scheme and how pro-
                          cessors share resources.

                          15.2.1 Classifyeing Sequential and Parallel Architectures
                          Flynn developed an early scheme for classifying computers into increasingly parallel
                          configurations. The scheme consists of four categories based on the different types of
                          streams used by processors.41 A stream is simply a sequence of bytes that is fed to a
                          processor. A processor accepts two streams—an instruction stream and a data stream.
                                 Single-instruction-stream, single-data-stream (SISD) computers are the sim-
                          plest type. These are traditional uniprocessors in which a single processor fetches one
                          instruction at a time and executes it on a single data item. Techniques such as pipelin-
                          ing, very long instruction word (VLIW) and superscalar design can introduce paral-
                          lelism into SISD computers. Pipelining divides an instruction's execution path into
                          discrete stages. This allows the processor to process multiple instructions simulta-
                          neously, as long as at most one instruction occupies each stage during a clock cycle.
                          VLIW and superscalar techniques simultaneously issue multiple independent instruc-
                          tions (from one instruction stream) that execute in different execution units. VLIW
                          relies on the compiler to determine which instructions to issue at any given clock
                          cycle, whereas superscalar design requires that the processor make this decision.42
                          Additionally, Intel's Hyper-Threading technology introduces parallelism by creating
                          two virtual processors from one physical processor. This gives a multiprocessor-

<!-- pág. 743 -->

                                                                                  15.2 Multiprocessor Architecture 689
enabled operating system the impression that it is running on two processors that
each execute at a little less than half the speed of the physical processor.43
      Multiple-instruction-stream, single-data-stream (MISD) computers are not
commonly used. A MISD architecture would have several processing units that act
 on a single stream of data. Each unit would execute a different instruction on the
data and pass the result to the next unit.44
      Single-instruction-stream, multiple-data-stream (SIMD) computers issue
 instructions that act on multiple data items. A SIMD computer consists of one or
more processing units. A processor executes a SIMD instruction by performing the
same instruction on a block of data (e.g., adding one to every element in an array).
If there are more data elements than processing units, the processing units fetch
 additional data elements for the next cycle. This can increase performance relative
to SISD architectures, which would require a loop to perform the same operation
 ome data element at a time. A loop contains many conditional tests, requires the
SISD processor to decode the same instruction multiple times and requires the
SISD processor to read data one word at a time. By contrast, SIMD architectures
read in a block of data at once, reducing costly memory-to-register transfers. SIMD
architectures are most effective in environments in which a system applies the same
 instruction to large data sets.45, 46
      Vector processors and array processors use a SIMD architecture. A vector
processor contains one processing unit that executes each vector instruction on a
set of data, performing the same operation on each data element. Vector processors
rely on extremely deep pipelines (i.e., ones containing many stages) and high clock
speeds. Deep pipelines permit the processor to perform work on several instruc-
tions at a time so that many data elements can be manipulated at once. An array
processor contains several processing units that perform the same instruction in
parallel on many data elements. Array processors (often referred to as massively
parallel processors) might contain tens of thousands of processing elements. There-
fore, array processors are most efficient when manipulating large data sets. Vector
and array processing are useful in scientific computing and graphics manipulation
where the same operation must be applied to a large data set (e.g., matrix
transformations).47, 48 The Connection Machine (CM) systems built by Thinking
Machines, Inc., are examples of array processors.49
      Multiple-instruction-stream, multiple-data-stream (MIMD) computers are
multiprocessors in which the processing units are completely independent and
 operate on separate instruction streams.50 However, these systems typically contain
hardware that allows processors to synchronize with each other when necessary,
such as when accessing a shared peripheral device.


Self Review
1. Thread-level parallelism (TLP) refers to the execution of multiple independent threads in
   parallel. Which multiprocessor architecture exploits TLP?
2. (T/F) Only SIMD processor architectures exploit parallelism.

<!-- pág. 744 -->

690 Multiprocessor Management

                          Ans: 1) Only MIMD and MISD architectures can execute multiple threads at once. How-
                          ever, the threads executed by a MISD computer manipulate the same data and are not inde-
                          pendent. Therefore, only MIMD systems can truly exploit TLP. 2) False. SISD systems use
                          techniques such as pipelines, VLIW and superscalar design to exploit parallelism; MISD pro-
                          cessors execute multiple threads at once; and MIMD processors exploit TLP as described in
                          the previous answer.


                          15.2.2 Processor Interconnection Schemes
                          The interconnection scheme of a multiprocessor system describes how the system's
                          components, such as processors and memory modules, are physically connected.
                          The interconnection scheme is a key issue for multiprocessor designers because it
                          affects the system's performance, reliability and cost. An interconnection scheme
                          consists of nodes and links. Nodes are composed of system components and/or
                          switches that route messages between components. A link is a connection between
                          two nodes. In many systems, a single node might contain one or more processors,
                          their associated caches, a memory module and a switch. In large-scale multiproces-
                          sors, we sometimes abstract the concept of a node and denote a group of nodes as a
                          single supernode.
                                Designers use several parameters to evaluate interconnection schemes. A
                          node's degree is the number of nodes to which it is connected. Designers try to min-
                          imize a node's degree to reduce the complexity and cost of its communication inter-
                          face. Nodes with larger degrees require more complex communication hardware to
                          support communication between the node and its neighbor nodes (i.e., nodes con-
                          nected to it). 51
                                One technique for measuring an interconnection scheme's fault tolerance is to
                          count the number of communication links that must fail before the network is
                          unable to function properly. This can be quantified using the bisection width—the
                          minimum number of links that need to be severed to divide the network into two
                          unconnected halves. Systems with larger bisection widths are more fault tolerant
                          than those with smaller bisection widths because more components must fail before
                          the entire system fails.
                                An interconnection scheme's performance largely depends on communication
                          latency between nodes. This can be measured in several ways, one of which is the
                          average latency. Another performance measure is the network diameter—the
                          shortest distance between the two most remote nodes in the interconnection
                          scheme. To determine the network diameter, consider all pairs of nodes in the net-
                          work and find the shortest path length for each pair—computed by totaling the
                          number of links traversed—then find the largest of these paths. A small network
                          diameter indicates low communication latency and higher performance. Finally,
                          system architects attempt to minimize the cost of an interconnection scheme, which
                          is equal to the total number of links in a network. 52
                                In the following subsections, we enumerate several successful interconnection
                          models and evaluate them based on the preceding criteria. Many real systems
                          implement variations of these models. For example, they might add extra communi-

<!-- pág. 745 -->

                                                                              15.2 Multiprocessor Architecture 691

cation links to increase fault tolerance (by increasing the bisection width) and per-
formance (by decreasing the network diameter).

Shared Bus
 The shared bus network organization uses a single communication path (i.e., route
through which messages travel) between all processors and memory modules
  (Fig. 15.1).53 The components' bus interfaces handle transfer operations. The bus is
passive, and the components arbitrate among themselves to use the bus. Only one
transfer can take place at a time on the bus, because the bus cannot convey two
electrical signals at once. Therefore, before a component initiates a transfer, it must
first check that both the bus and the destination component are available. One
problem with shared buses—contention—arises when several components wish to
use the bus at once. To reduce contention and bus traffic, each processor maintains
its own local cache as shown in Fig. 15.1. When the system can fulfill a memory
request from a processor's cache, the processor does not need to communicate over
 the bus with a memory module. Another option is to construct a multiple shared
bus architecture, which reduces contention by providing multiple buses that service
communication requests. However, these require complex bus arbitration logic and
  additional links, which increases the system's cost.54-55
       The shared bus is a simple and inexpensive scheme to connect a small number
of processors. New components can be added to the system by attaching them to
the bus, and software handles the detection and identification of the bus compo-
nents. However, due to contention for the single communication path, shared bus
 organizations do not scale beyond a small number of processors (in practice 16 or
 32 is the maximum). 56 Contention is exacerbated by the fact that processor speed
has increased faster than bus bandwidth. As processors get faster, it takes fewer
processors to saturate a bus.
       Shared buses are dynamic networks, because communication links are formed
and discarded (through the shared bus) during execution. Therefore, the criteria
used to evaluate interconnection schemes that we discussed earlier do not apply;
these criteria are based on static links, which do not change during execution. How-




Figure 15.1 | Shared bus multiprocessor organization.

<!-- pág. 746 -->

692 Multiprocessor Management
                          ever, compared to other interconnection schemes, a shared bus with several proces-
                          sors is fast and inexpensive, but not particularly fault tolerant—if the shared bus
                          fails, the components cannot communicate. 57
                                 Designers can leverage the benefits of shared buses in multiprocessors with
                          larger numbers of processors. In these systems, maintaining a single shared bus (or
                          several buses) that connects all processors is impractical, because the bus becomes
                          saturated easily. However, designers can divide the system's resources (e.g., proces-
                          sors and memory) into several small supernodes. The resources within a supernode
                          communicate via a shared bus, and the supernodes are connected using one of the
                          more scalable interconnection schemes described in the sections that follow. Such
                          systems attempt to keep most communication traffic within a supernode to exploit
                          the fast bus architecture, while enabling communication between supernodes. 58
                          Most multiprocessors with a small number of processors, such as dual-processor
                          Intel Pentium systems, use a shared bus architecture. 59

                          Crossbar-Switch Matrix
                          A crossbar-switch matrix provides a separate path from every processor to even
                          memory module (Fig. 15.2).60 For example, if there are n processors and m memory
                          modules, there will be n x m total switches that connect each processor to each
                          memory module. We can imagine the processors as the rows of a matrix and the
                          memory modules as the columns. In larger networks, nodes often consist of proces-
                          sor and memory components. This improves memory-access performance (for
                          those accesses between a processor and its associated memory module). In the case
                          of a crossbar-switch matrix, this reduces the interconnection scheme's cost. In this
                          design, each node connects to a switch of degree of p - 1, where p is the number of
                          processor-memory nodes in the system (i.e., in this case, m - n because each node
                          contains the same number of processors and memory modules). 61, 62
                                 A crossbar-switch matrix can support data transmissions to all nodes at once,
                          but each node can accept at most one message at a time. Contrast this with the shared
                          bus, which supports only one transmission at a time. A switch uses an arbitration algo-
                          rithm such as "service the requesting processor that has been serviced least recently at
                          this switch" to resolve multiple requests. The crossbar-switch design provides high
                          performance. Because all nodes are linked to all other nodes and transmission
                          through switch nodes has a trivial performance cost, the network diameter is essen-
                          tially one. Each processor is connected to each memory module, so to divide a cross-
                          bar-switch matrix into two equal halves, half of the links between processors and
                          memory modules must be cut. The number of links in the matrix is the product of n
                          and m, so the bisection width is (n x m) / 2, yielding strong fault tolerance. As Fig. 15.2
                          shows, there are many paths a communication can take to reach its destination.
                                 A disadvantage of crossbar-switch matrices is their cost, which increases pro-
                          portionally to nxm, making large-scale systems impractical.63 For this reason, cross-
                          bar-switches are typically employed in smaller multiprocessors (e.g., 16 processors).
                          However, as hardware costs decline, they are being used more frequently in larger
                          systems. The Sun UltraSPARC-Ill uses crossbar switches to share memory.64

<!-- pág. 747 -->

                                                                               15.2 Multiprocessor Architecture 693




Figure 15.2 | Crossbar-switch matrix multiprocessor organization.

2-D Mesh Network
In a 2-D mesh network interconnection scheme, each node consists of one or more
processors and a memory module. In the simplest case (Fig. 15.3), the nodes in a mesh
network are arranged in a rectangle of n rows and m columns, and each node is con-
nected with the nodes directly north, south, east and west of it. This is called a 4-con-
nected 2-D mesh network. This design keeps each node's degree small, regardless of
the number of processors in a system—the corner nodes have a degree of two, the
edge nodes have a degree of three and the interior nodes have a degree of four. In
Fig. 15.3, where n = 4 and m = 5, the 2-D mesh network can be divided into two equal
halves by cutting the five links between the second and third rows of nodes. In fact, if
n is even and m is odd the bisection width is m + 1 if m > n and is n otherwise. If the
2-D mesh contains an even number of rows and columns, the bisection width is the




Figure 15.3 | 4-connected 2-D mesh Network.

<!-- pág. 748 -->

694   Multiprocessor Management

                            smaller of m and n. Although not as fault tolerant as a crossbar-switch matrix, a 2-D
                            mesh network is more so than other simple designs, such as a shared bus. Because the
                            maximum degree of a node is four, a 2-D mesh network will have a network diameter
                            that is too substantial for large-scale systems. However, mesh networks have been
                            used in large systems in which communication is kept mainly between neighboring
                            nodes. For example, the Intel Paragon multiprocessor uses a 2-D mesh network.65

                            Hypercube
                            An n-dimensional hypercube consists of 2n nodes, each linked with n neighbor
                            nodes. Therefore, a two-dimensional hypercube is a 2 x 2 mesh network, and a
                            three-dimensional hypercube is conceptually a cube.66 Figure 15.4 illustrates con-
                            nections between nodes in three-dimensional (part a) and four-dimensional (part b)
                            hypercubes. 67 Note that a three-dimensional hypercube is actually a pair of two-
                            dimensional hypercubes in which the corresponding nodes in each two-dimensional
                            hypercube are connected. Similarly, a four-dimensional hypercube is actually a pair
                            of three-dimensional hypercubes in which the corresponding nodes in each three-
                            dimensional hypercube are connected.
                                   A hypercube's performance scales better than that of a 2-D mesh network,
                            because each node is connected by n links to other nodes. This reduces the network
                            diameter relative to a 2-D mesh network. For example, consider a 16-node multi-
                            processor implemented as either a 4 x 4 mesh network or a 4-dimensional hyper-
                            cube. A 4 x 4 mesh network has a network diameter of 6, whereas a 4-dimensional
                            hypercube has a network diameter of 4. In some hypercubes, designers add commu-
                            nication links between nonneighbor nodes to further reduce the network diame-
                            ter.68 A hypercube's fault tolerance also compares favorably with that of other
                            designs. However, the increased number of links per node increases a hypercube's
                            cost relative to that of a mesh network. 69
                                   The hypercube interconnection scheme is efficient for connecting a modest
                            number of processors and is more economical than a crossbar-switch matrix. The
                            nCUBE system used in streaming media and digital-advertising systems employs
                            hypercubes of up to 13 dimensions (8,192 nodes). 70




                            F i g u r e 15.4 | 3- and 4-dimensional hypercubes.

<!-- pág. 749 -->

                                                                                15.2 Multiprocessor Architecture   695

 Multistage Networks
 An alternative processor interconnection scheme is a multistage network.71 As in
the crossbar-switch matrix design, some nodes are switches rather than processor
nodes with local memory. Switch nodes are smaller, simpler and can be packed
more tightly, increasing performance. To understand the benefits of a multistage
network over a crossbar-switch matrix, consider the problem of flying between
small cities. Instead of offering direct flights between every pair of cities, airlines use
large cities as "hubs." A flight between two small cities normally consists of several
  "legs" in which the traveller first flies to a hub, possibly travels between hubs and
finally travels to the destination airport. In this way, airlines can schedule fewer
total flights and still connect any small city with an airport to any other. The switch-
ing nodes in a multistage network act as hubs for communication between proces-
sors, just as airports in large cities do for airlines.
       There are many schemes for constructing a multistage network. Figure 15.5
shows a popular multistage network called a baseline network.72 Each nodes on the
left is the same as the node on the right. When one processor wants to communicate
with another, the message travels through a series of switches. The leftmost switch
corresponds to the least significant (rightmost) bit of the destination processor's ID;
the middle switch corresponds to the middle bit; and the rightmost switch corre-
sponds to the most significant (leftmost) bit.




Figure 15.5 | Multistage baseline network.

<!-- pág. 750 -->

696   Multiprocessor Management

                                  For example, consider the bold path in Fig. 15.5 from the processor with ID
                            001 to the processor with ID 110. Begin by following the path from processor 001
                            to the switch. Next, determine the least significant bit (i.e., 0) in the destination pro-
                            cessor's ID (110) and follow that path from the current switch to the next switch.
                            From the second switch, follow the path that corresponds to the middle bit (i.e.. 1)
                            in the destination processor's ID. Finally, from the third switch, follow the path that
                            corresponds to the most significant bit (i.e., 1) in the destination processor's ID.
                                  Multistage networks represent a cost-performance compromise. This design
                            employs simple hardware to connect large numbers of processors. Any processor
                            can communicate with any other without routing the message through intermediate
                            processors. However, a multistage network has a larger network diameter, so com-
                            munication is slower than with a crossbar-switch matrix—each message must pass
                            through multiple switches. Also, contention can develop at switching elements,
                            which might degrade performance. IBM's SP series multiprocessor, which evolved
                            to the POWER4, uses a multistage network to connect its processors. The IBM
                            ASCI-White, which can perform over 100 trillion operations per second, is based on
                            the POWER3-II multiprocessor.73, 74


                            Self Review
                            1. An 8-connected 2-D mesh network includes links to diagonal nodes as well as the links in
                               Fig. 15.3. Compare 4-connected and 8-connected 2-D mesh networks using the criteria
                               discussed in this section.
                            2. Compare a multistage network to a crossbar-switch matrix. What are the benefits and
                               drawbacks or each interconnection scheme?
                            Ans: 1) An 8-connected 2-D mesh network has approximately double the degree for each
                            node and, therefore, approximately double the cost compared to a 4-connected 2-D mesh
                            network. However, the network diameter decreases and the bisection width correspondingly
                            increases, because there are more links in the network. Thus, an 8-connected 2-D mesh net-
                            work exhibits lower network latency and higher fault tolerance at a higher cost than a 4-con-
                            nected 2-D mesh network. 2) A multistage network is cheaper to build than a crossbar-switch
                            matrix. However, multistage networks exhibit reduced performance and fault tolerance.

                            15.2.3 Loosely Coupled vs. Tightly Coupled Systems
                            Another defining characteristic of multiprocessors is how the processors share system
                            resources. In a tightly coupled system (Fig. 15.6), the processors share most system
                            resources. Tightly coupled systems often employ shared buses, and processors usually
                            communicate via shared memory. A centralized operating system typically manages
                            the system's components. Loosely coupled systems (Fig. 15.7) normally connect com-
                            ponents indirectly through communication links.75 Processors sometimes share mem-
                            ory, but often each processor maintains its own local memory, to which it has much
                            faster access than to the rest of memory. In other cases, message passing is the only
                            form of communication between processors, and memory is not shared.
                                  In general, loosely coupled systems are more flexible and scalable than tightly
                            coupled systems. When components are loosely connected, designers can easily add

<!-- pág. 751 -->

                                                                           15.2 Multiprocessor Architecture 697

components to or remove components from the system. Loose coupling also
increases fault tolerance because components can operate independently of one
 another. However, loosely coupled systems typically are less efficient, because they
communicate by passing messages over a communications link, which is slower
than communicating through shared memory. This also places a burden on operat-
ing systems programmers, who typically hide most of the complexity of message
passing from application programmers. Japan's Earth Simulator is an example of a
loosely coupled system.76
      By contrast, tightly coupled systems perform better but are less flexible. Such
systems do not scale well, because contention for shared resources builds up
quickly as processors are added. For this reason, most systems with a large number
of processors are loosely coupled. In a tightly coupled system, designers can opti-
mize interactions between components to increase system performance. However,
this decreases the system's flexibility and fault tolerance, because one component
relies on other components. A dual-processor Intel Pentium system is an example
of a tightly coupled system.77




Figure 15.6 | Tightly coupled system




Figure 15.7 | Loosely coupled system.

<!-- pág. 752 -->

698   Multiprocessor Management

                            Self Review
                            1. Why are many small multiprocessors constructed as tightly coupled systems? Why are
                               many large-scale systems loosely coupled?
                            2. Some systems consist of several tightly coupled groups of components connected together
                               in a loosely coupled fashion. Discuss some motivations for this scheme.
                            Ans: 1) A small system would typically be tightly coupled because there is little contention
                            for shared resources. Therefore, designers can optimize the interactions between system com-
                            ponents, thus providing high performance. Typically, large-scale systems are loosely coupled
                            to eliminate contention for shared resources and reduce the likelihood that one failed com-
                            ponent will cause systemwide failure. 2) This scheme leverages the benefits of both intercon-
                            nection organizations. Each group is small, so tightly coupled systems provide the best
                            performance within a group. Making the overall system loosely coupled reduces contention
                            and increases the system's flexibility and fault tolerance.



                            15.3 Multiprocessor Operating System Organizations
                            In organization and structure, multiprocessor operating systems differ significantly
                            from uniprocessor operating systems. In this section, we categorize multiprocessors
                            based on how they share operating system responsibilities. The basic operating sys-
                            tem organizations for multiprocessors are master/slave, separate kernels for each pro-
                            cessor and symmetric (or anonymous) treatment of all processors.

                            15.3.1 Master/Slave
                            The master/slave multiprocessor organization designates one processor as the mas-
                            ter and the others as slaves (Fig. 15.8).78 The master executes operating system
                            code; the slaves execute only user programs. The master performs input/output and
                            computation. The slaves can execute processor-bound jobs effectively, but I/O-
                            bound jobs running on the slaves cause frequent calls for services that only the mas-
                            ter can perform. From a fault-tolerance standpoint, some computing capability is
                            lost when a slave fails, but the system continues to function. Failure of the master
                            processor is catastrophic and halts the system. Master/slave systems are tightly cou-
                            pled because all slave processors depend on the master.
                                  The primary problem with master/slave multiprocessing is the hardware
                            asymmetry, because only the master processor execute the operating system. When




                            Figure 15.8 | Master/Slave multiprocessing.

<!-- pág. 753 -->

                                                            15.3 Multiprocessor Operating System Organizations 699

a process executing on a slave processor requires the operating system's attention,
the slave processor generates an interrupt and waits for the master to handle the
interrupt.
      The nCUBE hypercube system is an example of a master/slave system. Its
many slave processors handle computationally intensive tasks associated with
manipulating graphics and sound.79



Self Review
1. (T/F) Master/slave multiprocessors scale well to large-scale systems.
2. For what type of environments are master/slave multiprocessors best suited?
Ans 1) False. Only one processor can execute the operating system. Contention will build
between processes that are awaiting services (such as I/O) that only the master processor can
provide. 2) Master/slave processors are best suited for environments that mostly execute pro-
cessor-bound processes. The slave processors can execute these processes without interven-
tion from the master processor.




15.3.2 Separate Kernels
In the separate-kernels multiprocessor organization, each processor executes its
own operating system and responds to interrupts from user-mode processes run-
ning on that processor.80 A process assigned to a particular processor runs to com-
pletion on that processor. Several operating system data structures contain global
system information, such as the list of processes known to the system. Access to
these data structures must be controlled with mutual exclusion techniques, which
we discuss in Section 15.9, Multiprocessor Mutual Exclusion. Systems that use the
separate-kernels organization are loosely coupled. This organization is more fault
tolerant than the master/slave organization—if a single processor fails, system fail-
ure is unlikely. However, the processes that were executing on the failed processor
cannot execute until they are restarted on another processor.
       In the separate-kernels organization, each processor controls its own dedi-
cated resources, such as files and I/O devices. I/O interrupts return directly to the
processors that initiate those interrupts.
      This organization benefits from minimal contention over operating system
resources, because the resources are distributed among the individual operating
systems for their own use. However, the processors do not cooperate to execute an
individual process, so some processors might remain idle while one processor exe-
cutes a multithreaded process. The Tandem system, which is popular in business-
critical environments, is an example of a separate-kernels multiprocessor; because
the operating system is distributed throughout the loosely coupled processing
nodes, it is able to achieve nearly 100 percent availability.81

<!-- pág. 754 -->

700 Multiprocessor Management

                          Self Review
                          1. Why is the separate-kernels organization more fault tolerant than the master/slave orga-
                             nization?
                          2. For what type of environment would separate-kernels multiprocessor be useful?
                         Ans: 1) The separate-kernels organization is loosely coupled. Each processor has its own
                         resources and does not interact with other processors to complete its tasks. If one processor
                         fails, the remainder continue to function. In master/slave organizations, if the master fails
                         none of the slave processors can perform operating system tasks that must be handled by the
                         master. 2) A separate-kernels multiprocessor is useful in environments where processes do
                         not interact, such as a cluster of workstations in which users execute independent programs.




                          15.3.3 Symmetrical Organization
                          Symmetrical multiprocessor organization is the most complex organization to
                          implement, but is also the most powerful.82-83 [Note: This organization should not
                          be confused with symmetric multiprocessor (SMP) systems, which we discuss in
                          Section 15.4.1.] The operating system manages a pool of identical processors, any
                          one of which can control any I/O device or reference any storage unit. The symme-
                          try makes it possible to balance the workload more precisely than with the other
                          organizations.
                                Because many processors might be executing the operating system at once,
                          mutual exclusion must be enforced whenever the operating system modifies shared
                          data structures. Hardware and software conflict-resolution techniques are important.
                                Symmetrical multiprocessor organizations are generally the most fault toler-
                          ant. When a processor fails, the operating system removes that processor from its
                          pool of available processors. The system degrades gracefully while repairs are made
                          (see the Operating Systems Thinking feature, Graceful Degradation). Also, a pro-
                          cess running on a symmetrical system organization can be dispatched to any proces-
                          sor. Therefore, a process does not rely on a specific processor as in the separate-
                          kernels organization. The operating system "floats" from one processor to the next.
                                One drawback of the symmetrical multiprocessor organization is contention
                          for operating system resources, such as shared data structures. Careful design of
                          system data structures is essential to prevent excessive locking that prevents the
                          operating system from executing on multiple processors at once. A technique that
                          minimizes contention is to divide the system data structures into separate and inde-
                          pendent entities that can be locked individually.
                                Even in completely symmetrical multiprocessing systems, adding new proces-
                          sors does not cause system throughput to increase by the new processors' rated
                          capacities. There are many reasons for this, including additional operating system
                          overhead, increased contention for system resources and hardware delays in switch-
                          ing and routing transmissions between an increased number of components. Several
                          performance studies have been performed; one early BBN Butterfly system with 256
                          processors operated 180 to 230 times faster than a single-processor system.84

<!-- pág. 755 -->

                                                                                15.4 Memory Access Architectures 701

Self Review
1. Why would doubling the number of processors in a symmetrical organization not double
   the total processing power?
2. What are some benefits of the symmetrical organization over the master/slave and sepa-
   rate-kernels organizations?
Ans: 1) Adding processors increases contention for resources and increases operating sys-
tem overhead, offsetting some of the performance gains attained from adding processors.
2) The symmetrical organization is more scalable than master/slave because all processors
can execute the operating system; this also makes the system more fault tolerant. Symmetri-
cal organization provides better cooperation between processors than separate kernels. This
facilitates IPC and enables systems to exploit parallelism better.



15.4 Memory Access Architectures
So far, we have classified multiprocessor systems by hardware characteristics and by
how processors share operating system responsibilities. We can also classify multi-
processor systems by how they share memory. For example, consider a system with
tew processors and a small amount of memory. If the system contains a group of
memory modules that is easily accessible by all processors (e.g., via a shared bus),
the system can maintain fast memory access. However, systems with many proces-
sors and memory modules will saturate the bus that provides access to these mem-
ory modules. In this case, a portion of memory can be closely tied to a processor so



               Operating Systems Thinking
  Graceful Degradation
  Things do go wrong. Individual           processor can run any process. If        the Internet, the Internet contin-
  components of systems do fail.           one of the processors fails, the sys-    ues to handle new transmissions
  Entire systems fail. The question is,    tem can still function with the          by sending them to the remaining
  "What should a system do after           remaining processors, but with           functioning routers. Providing for
  experiencing some degree of fail-        reduced performance. Graceful            graceful degradation is an impor-
  ure?" Many systems are designed          degradation occurs in many disk          tant task for operating systems
  to degrade gracefully (i.e., con-        systems that, upon detecting a           designers, especially as people
  tinue operating after a failure, but     failed portion of the disk, simply       grow increasingly reliant on hard-
  at reduced levels of service). A         "map around" the failed areas,           ware devices that eventually fail.
  classic example of graceful degra-       enabling the user to continue stor-
  dation occurs in a symmetric multi-      ing and retrieving information on
  processing system in which any           that disk. When a router fails on

<!-- pág. 756 -->

702   Multiprocessor Management

                            that the processor can access its memory more efficiently. Designers, therefore,
                            must weigh concerns about a system's performance, cost and scalability when deter-
                            mining the system's memory-access architecture. The following sections describe
                            several common memory architectures for multiprocessor systems.

                            15.4.1 Uniform Memory Access
                            Uniform-memory-access (LIMA) multiprocessor architectures require all processors
                            to share the system's main memory (Fig. 15.9). This is a straightforward extension of a
                            uniprocessor memory architecture, but with multiple processors and memory mod-
                            ules. Typically, each processor maintains its own cache to reduce bus contention and
                            increase performance. Memory-access time is uniform for any processor accessing
                            any data item, except when the data item is stored in a processor's cache or there is
                            contention on the bus. UMA systems are also called symmetric multiprocessor
                            (SMP) systems because any processor can be assigned any task and all processors
                            share all resources (including memory, I/O devices and processes). UMA multipro-
                            cessors with a small number of processors typically use a shared bus or a crossbar-
                            switch matrix interconnection network. I/O devices are attached directly to the inter-
                            connection network and are equally accessible to all processors.85
                                  UMA architectures are normally found in small multiprocessor systems (typi-
                            cally two to eight processors). UMA multiprocessors do not scale well—a bus
                            quickly becomes saturated when more than a few processors access main memery
                            simultaneously, and crossbar-switch matrices become expensive even for modest-
                            sized systems.86-87

                            Self Review
                            1. Why are mesh networks and hypercubes inappropriate interconnection schemes for
                               UMA systems?
                            2. How is a UMA system "symmetric?"
                            Ans: 1) Mesh networks and hypercubes place processors and memory at each node, so local
                            memory can be accessed faster than remote memory; thus memory-access times are not uni-




                            Figure 1 5 . 9 | UMA multiprocessor.

<!-- pág. 757 -->

                                                                               15.4    Memory Access Architectures 703

 form. 2) It is symmetric because any processor can be assigned any task and all processors
  share all resources (including memory, I/O devices and processes).


15.4.2 Nonuniform Memory Access
Nonuniform-memory-access (NUMA) multiprocessor architectures address
   UMA's scalability problems. The primary bottleneck in a large-scale UMA system
is access to shared memory—performance degrades due to contention from numer-
 ous processors attempting to access shared memory. If a crossbar-switch matrix is
 used, the interconnection scheme's cost might increase substantially to facilitate
 multiple paths to shared memory. NUMA multiprocessors handle these problems
by relaxing the constraint that memory-access time should be uniform for all pro-
  cessors accessing any data item.
       NUMA multiprocessors maintain a global shared memory that is accessible by
  all processors. The global memory is partitioned into modules, and each node uses
  one of these memory modules as the processor's local memory. In Fig. 15.10, each
node contains one processor, but this is not a requirement. Although the interconnec-
tion scheme's implementation might vary, processors are connected directly to their
 local memory modules and connected indirectly (i.e., through one of the interconnec-
   tion schemes discussed in Section 15.2.2) to the rest of global memory. This arrange-
ment provides faster access to local memory than to the rest of global memory,
because access to global memory requires traversing the interconnection network.
       The NUMA architecture is highly scalable because it reduces bus collisions
when a processor's local memory services most of the processor's memory requests.
 A NUMA system can implement a strategy that moves pages to the processor on
which those pages are accessed most frequently —a technique called page migra-
 tion, which is discussed in detail in Section 15.5.2, Page Replication and Migration.
Typically, NUMA systems can support a large number of processors, but they are
more complex to design than UMAs, and systems with many processors can be
expensive to implement.88-89




Figure 15.10 | NUMA multiprocessor.

<!-- pág. 758 -->

704   Multiprocessor Management

                            Self Review
                            1. List some advantages of NUMA multiprocessors over UMA. List some disadvantages.
                            2. What issues does the NUMA design raise for programmers and for operating systems
                               designers?
                            Ans: 1) NUMA multiprocessors are more scalable than UMA multiprocessors because
                            NUMA multiprocessors remove the memory-access bottleneck of UMA systems by using
                            large numbers of processors. UMA multiprocessors are more efficient for small systems
                            because there is little memory contention and access to all memory in a UMA system is fast.
                            2) If two processes executing on processors at separate nodes use shared memory for IPC,
                            then at least one of the two will not have the memory item in its local memory, which
                            degrades performance. Operating system designers place processes and their associated
                            memory together on the same node. This might require scheduling a process on the same
                            processor each time the process executes. Also, the operating system should be able to move
                            pages to different memory modules based on demand.


                            15.4.3 Cache-Only Memory Architecture
                            As described in the previous section, each node in a NUMA system maintains its own
                            local memory, which processors from other nodes can access. Often, local memory
                            access is dramatically faster than global memory access (i.e., access to another node's
                            local memory). Cache-miss latency—the time required to retrieve data that is not in
                            the cache —can be significant when the requested data is not present in local memory.
                            One way to reduce cache-miss latency is to reduce the number of memory requests
                            serviced by remote nodes. Recall that NUMA systems place data in the local memory
                            of the processor that accesses the data most frequently. This is impractical for a com-
                            piler or programmer to implement, because data access patterns change dynamically.
                            Operating systems can perform this task, but can move only page-size chunks of data,
                            which can slow data migration. Also, different data items on a single page often are
                            accessed by processors at different nodes.90
                                  Cache-Only Memory Architecture (COMA) multiprocessors (also called
                            Cache-Only Memory Access multiprocessors) use a slight variation of NUMA to
                            address this memory placement issue (Fig. 15.11). COMA multiprocessors include
                            one or more processors, each with its associated cache, and a portion of the global
                            shared memory. However, the memory associated with each node is organized as a
                            large cache known as an attraction memory (AM). This allows the hardware to
                            migrate data efficiently at the granularity of a memory line—equivalent to a cache
                            line, but in main memory, and typically four or eight bytes.91 Also, because each
                            processor's local memory is viewed as a cache, different AMs can have copies of the
                            same memory line. With these design modifications, data often resides in the local
                            memory of the processor that uses the data most frequently, which reduces the
                            average cache-miss latency. The trade-offs are memory overhead from duplicating
                            data items in multiple memory modules, and complicated hardware and protocols
                            to ensure that memory updates are reflected in each processor's AM. This overhead
                            results in higher latency for those cache misses that are serviced remotely.92

<!-- pág. 759 -->

                                                                                 15.4    Memory Access Architectures 705




Figure 15.11 | COMA multiprocessor.

Self Review
1. What problems inherent in NUMA multiprocessors does the COMA design address?
2. (T/F) The COMA design always increases performance over a NUMA design.
Ans: 1) Cache misses serviced at remote nodes in both NUMA and COMA systems typi-
cally require much more time than cache misses serviced by local memory. Unlike NUMA
systems, COMA multiprocessors use hardware to move copies of data items to a processor's
local memory (the AM) when referenced. 2) False. COMA multiprocessors reduce the num­
ber of cache misses serviced remotely, but they also add overhead. In particular, cache-miss
latency increases for cache misses that are serviced remotely, and synchronization is required
for data that is copied into several processors' attraction memory.


15.4.4 No Remote Memory Access
UMA, NUMA and COMA multiprocessors are tightly coupled. Although NUMA
(and COMA to a lesser extent) multiprocessors scale well, they require complex
software and hardware. The software controls access to shared resources such as
memory; the hardware implements the interconnection scheme. NO-Remote-
Memory-Access (NORMA) multiprocessors are loosely coupled multiprocessors
that do not provide any shared global memory (Fig. 15.12). Each node maintains its
own local memory, and often, NORMA multiprocessors implement a common
shared virtual memory (SVM). On an SVM system, when a process requests a page
that is not in its processor's local memory, the operating system loads the page into
local memory from another memory module (i.e., from a remote computer over a
network) or from secondary storage (e.g., a disk). 93 - 94 Nodes in NORMA systems
that do not support SVM must share data through explicit message passing. Google,
which powers its service using 15,000 low-end servers located across the world, is an
example of a distributed NORMA multiprocessor system.95

<!-- pág. 760 -->

706 Multiprocessor Management




                          Figure 15.12 | NORMA multiprocessor.



                                NORMA systems are the simplest to build, because they do not require a
                          complex interconnection scheme. However, the absence of shared global memory
                          requires application programmers to implement IPC via message passing and
                          remote procedure calls. On many systems, using shared virtual memory is ineffi-
                          cient, because the system would have to send entire data pages from one processor
                          to the next, and these processors often are not in the same physical machine.96 We
                          discuss SVM in more detail in Section 15.5.3, Shared Virtual Memory.
                                Because NORMA multiprocessors are loosely coupled, it is relatively easy to
                          remove or add nodes. NORMA multiprocessors are distributed systems governed
                          by a single operating system, rather than networked computers each with its own
                          operating system. If a node in a NORMA system fails, a user can simply switch to
                          another node and continue working. If one percent of the nodes fails in a NORMA
                          multiprocessor, the system merely runs one percent slower.97




                         Self Review
                          1. Why are NORMA multiprocessors ideal for workstation clusters?
                          2. In what environments are NORMA multiprocessors not useful?
                         Ans: 1) Different users in a workstation cluster usually do not share memory. However,
                         they share resources such as a file system and processing power, which NORMA systems
                         provide. Also, it is relatively easy to add or remove nodes in NORMA multiprocessors, which
                         can be useful for scaling the system's processing capabilities. 2) NORMA multiprocessors are
                         not useful in shared-memory environments, especially systems with a single user or a few
                         processors. These can be implemented more efficiently with UMA or NUMA designs.

<!-- pág. 761 -->

                                                                            15.5 Multiprocessor Memory Sharing              707

15.5 Multiprocessor Memory Sharing
When multiple processors with private caches or local memories access shared
memory, designers must address the problem of memory coherence. Memory is
coherent if the value obtained from reading a memory address is always the value
that was most recently written to that address.98 For example, consider two proces-
sors that maintain a separate copy of the same page in their local memories. If one
processor modifies its local copy, the system should ensure that the other copy of
the page is updated to reflect the latest changes. Multiprocessors that allow only
one copy of a page to be resident in the system at a time (such as UMA and small
NUMA systems) must still ensure cache coherence —reading a cache entry reflects
the most recent update to that data. Large-scale systems (such as NORMA or
large-scale NUMA systems) often permit the same memory page to be resident in
the local memory of several processors. These systems must integrate memory
coherence into their implementation of shared virtual memory.
      Other important design considerations are page placement and replication.
Local memory access is much faster than global memory access, so ensuring that data
accessed by a processor resides in that processor's local memory can improve perfor-
mance. There are two common strategies for addressing this issue. Page replication
maintains multiple copies of a memory page, so that the page can be accessed quickly
at multiple nodes (see the Operating Systems Thinking feature, Data Replication and
 Coherency). Page migration transfers pages to the node (or nodes, when used with
 page replication) where processors access a page most. In Section 15.5.2, Page Repli-
cation and Migration, we consider implementations of these two strategies.

Self Review
1. Why is memory coherence important?
2. What are the advantages of allowing multiple copies of the same page to exist in one sys-
   tem?




               Operating Systems Thinking
 Data Replication and Coherency
 We will see several examples of           copy of the data is lost. It is also      ency, (i.e., that all copies of the
 data being duplicated for various         done for performance where                data either are identical or will be
 reasons in operating systems.             some copies of the data may be            made so before any differences
 Sometimes this is done for backup         accessed faster than others.              could cause a problem).
 to ensure recoverability if one           Often, it is crucial to ensure coher-

<!-- pág. 762 -->

708 Multiprocessor Management

                          Ans: 1) Without memory coherence, there is no guarantee that a particular copy of data is
                          the most up-to-date version. Data must be coherent to ensure that applications produce cor-
                          rect results. 2) If two processes executing on different processors repeatedly read the same
                          memory page, replicating the page allows both processors to keep the page in local memory
                          so that it can be accessed quickly.



                          15.5.1 Cache Coherence
                          Memory coherence became a design consideration when caches appeared, because
                          computer architectures allowed different access paths to data (i.e., through the
                          cache copy or the main memory copy). In multiprocessor systems, coherence is
                          complicated by the fact that each processor maintains a private cache.

                          UMA Cache Coherence
                          Implementing cache coherence protocols for UMA multiprocessors is simple
                          because caches are relatively small and the bus connecting shared memory is rela-
                          tively fast. When a processor updates a data item, the system must also update or
                          discard all instances of that data in other processors' caches and in main memory.99
                          This can be accomplished by bus snooping (also called cache snooping). In this pro-
                          tocol, a processor "snoops" the bus by determining whether a requested write from
                          another processor is for a data item in the processor's cache. If the data resides in
                          the processor's cache, the processor removes the data item from its cache. Bus
                          snooping is simple to implement, but generates additional traffic on the shared bus.
                          Alternatively, the system can maintain a centralized directory that records the items
                          that reside in each cache and indicates when to remove stale data (i.e., data that
                          does not reflect the most recent update) from a cache. Another option is for the sys-
                          tem to allow only one processor to cache a particular memory item. 100


                          Cache-Coherent NUMA (CC-NUMA)
                          Cache-coherent NUMAs (CC-NUMAs) are NUMA multiprocessors that impose
                          cache coherence. In a typical CC-NUMA architecture, each physical memory
                          address is associated with a home node, which is responsible for storing the data
                          item with that main-memory address. (Often, the home node is simply determined
                          by the higher-order bits in the address.) When a cache miss occurs at a node, that
                          node contacts the home node associated with the requested memory address. If the
                          data item is clean (i.e., no other node has a modified version of the data item in its
                          cache), the home node forwards it to the requesting processor's cache. If the data
                          item is dirty (i.e., another node has written to the data item since the last time the
                          main memory entry was updated), the home node forwards the request to the node
                          with the dirty copy; this node sends the data item to both the requestor and the
                          home node. Similarly, requests to modify data are performed via the home node.
                          The node that wishes to modify data at a particular memory address requests exclu-
                          sive ownership of the data. The most recent version of the data (if not already in the
                          modifying node's cache) is obtained in the same manner as a read request. After the

<!-- pág. 763 -->

                                                                               15.5 Multiprocessor Memory Sharing 709
 modification, the home node notifies other nodes with copies of the data that the
data was modified.101
       This protocol is relatively simple to implement, because all reads and writes
  first contact the home node. Although this might seem inefficient, this coherence
protocol requires a maximum of only three network communications. (Consider
how much traffic would be generated if a writing node had to contact all other
nodes.) This protocol also makes it easy to distribute the load throughout the sys-
 tem—by assigning each node as the home node for approximately the same number
of addresses—which increases fault tolerance and reduces contention. However,
 this protocol can perform poorly if most data accesses come from remote nodes.

Self Review
1. What are the advantages and disadvantages of bus snooping?
2. Why is it difficult for the system to establish a home node for memory that is referenced
   by several different nodes over time? How can the CC-NUMA home-based protocol be
   modified to support such behavior?
Ans: 1) Bus snooping is easy to implement and it enables cache coherence. However, it
generates additional bus traffic. 2) If memory-access patterns for a memory region change
 frequently, then it is difficult to decide which node should be the home node for that region.
 Although one node might make the majority of the references to that item now, this will soon
change and most of the references will come from a remote node. A remedy would be to
dynamically change the home node of a data item (this, of course, would imply changing the
item's physical memory address).


15.5.2 Page Replication and Migration
NUMA systems have higher memory-access latency than UMA multiprocessors,
 which limits NUMA's performance. Therefore, maximizing the number of cache
misses serviced by local memory is an important NUMA design consideration. 102
The COMA design, described in Section 15.4.3, is one attempt to address the
NUMA latency issue. CC-NUMA systems address the latency issue by implement-
 ing page-migration or page-replication strategies.103
       Replicating a page is straightforward. The system copies all data from a remote
page to a page in the requesting processor's local memory. To maintain memory
coherence, the system uses a data structure that records where all duplicate pages
exist. We discuss different strategies for memory coherence in the next section. Page
migration occurs in a similar fashion, except that after a page has been replicated,
the original node deletes the page from its memory and flushes any associated TLB
or cache entries.104
       Although migrating and replicating pages has obvious benefits, these strate-
gies can degrade performance if they are not implemented correctly. For example,
remotely referencing a page is faster than migrating or replicating that page. There-
fore, if a process references a remote page only once, it would be more efficient not
to migrate or replicate the page.105 In addition, some pages are better candidates for
replication than for migration, and vice versa. For example, pages that are read fre-

<!-- pág. 764 -->

710 Multiprocessor Management
                          quently by processes at different processors would benefit from replication. by
                          enabling all processes to access that page from local memory. Also, the drawback of
                          replication—maintaining coherency on writes—would not be a problem for a read-
                          only page. A page frequently modified by one process is a good candidate for
                          migration; if other processes are reading from that page, replicating the page would
                          not be viable because these processes would have to fetch updates continually from
                          the writing node. Pages that are frequently written by processes at more than one
                          processor are not good candidates for either replication or migration, because they
                          would be migrated or replicated after each write operation. 106
                                To help determine the best strategy, many systems maintain each page's access
                          history information. A system might use this information to determine which pages
                          are frequently accessed —these should be considered for replication or migration
                          The overhead of replicating or migrating a page is not justified for pages that are
                          not frequently accessed. A system also might maintain information on which
                          remote processors are accessing the page and whether these processors are reading
                          from, or writing to, the page. The more page-access information the system gathers,
                          the better decision the system can make. However, gathering this history and trans-
                          ferring it during migration incurs overhead. Thus, the system must collect enough
                          information to make good replication or migration decisions without incurring
                          excessive overhead from maintaining this information.107

                          Self Review
                          1. How could an ineffective migration/replication strategy degrade performance?
                          2. For what types of pages is replication appropriate? When is migration appropriate?
                         Ans: 1) Migration and replication are more costly than remotely referencing a page. They are
                         beneficial only if the page will be referenced remotely multiple times from the same node. An
                         ineffective strategy might migrate or replicate pages that are, for example, modified by many
                         nodes, requiring frequent updates and thus reducing performance. Also, manipulating pages
                         access history information imposes additional overhead that can degrade performance.
                         2) Pages that are read frequently by multiple processors (but not modified) should be repli-
                         cated. Pages that are written by only one remote node should be migrated to that node.



                          15.5.3 Shared Virtual Memory
                          Sharing memory on small, tightly coupled multiprocessors, such as UMA multipro-
                          cessors, is a straightforward extension of uniprocessor shared memory because all
                          processors access the same physical addresses with equal access latency. This strategy
                          is impractical for large-scale NUMA multiprocessors due to remote-memory-access
                          latency, and it is impossible for NORMA multiprocessors, which do not share physi-
                          cal memory. Because IPC through shared memory is easier to program than IPC via
                          message passing, many systems enable processes to share memory located on differ-
                          ent nodes (and perhaps in different physical address spaces) through shared virtual
                          memory (SVM). SVM extends uniprocessor virtual memory concepts by ensuring
                          memory coherence for pages accessed by various processors.108

<!-- pág. 765 -->

                                                                          15.5 Multiprocessor Memory Sharing 711

     Two issues facing SVM designers are selecting which coherence protocol to
use and when to apply it. The two primary coherence protocols are invalidation and
write broadcast. First we describe these protocols, then we consider how to imple-
ment them.

Invalidation
In the invalidation memory-coherence approach, only one processor may access a
page while it is being modified —this is called page ownership. To obtain page own-
ership, a processor must first invalidate (deny access to) all other copies of the page.
After the processor obtains ownership, the page's access mode is changed to read/
write, and the processor copies the page into its local memory before accessing it.
To obtain read access to a page, a processor must request that the processor with
read/write access change its access mode to read-only access. If the request is
granted, other processors can copy the page into local memory and read it. Typi-
cally, systems employ the policy of always granting requests unless a processor is
waiting to acquire page ownership; in the case that a request is denied, the
requestor must wait until the page is available. Note that multiple processes modi-
fying a single page concurrently leads to poor performance, because competing pro-
cessors repeatedly invalidate the other processors' copies of the page.109

Write Broadcast
In the write broadcast memory-coherence approach, the writing processor broad-
casts each modification to the entire system. In one version of this technique, only
one processor may obtain write ownership of a page. Rather than invalidating all
other existing copies of the page, the processor updates all copies.110 In a second
version, several processors are granted write access to increase efficiency. Because
this scheme does not require writers to obtain write ownership, processors must
ensure that various updates to a page are applied in the correct order, which can
incur significant overhead. 111

Implementing Coherence Protocols
 There are several ways to implement a memory-coherence protocol, though design-
ers must attempt to limit memory-access bus traffic. Ensuring that every write is
reflected at all nodes as soon as possible can decrease performance; however, weak-
ening coherence constraints can produce erroneous results if programs use stale
data. In general, an implementation must balance performance and data integrity.
      Systems that use sequential consistency ensure that all writes are immediately
reflected in all copies of a page. This scheme does not scale well to large systems due
to communication cost and page size. Internode communication is slow compared
to accessing local memory; if a process repeatedly updates the same page, many
 wasteful communications will result. Also, because the operating system manipu-
lates pages, which often contain many data items, this strategy might result in false
sharing, where processes executing at separate nodes might need access to unre-
lated data on the same page. In this case, sequential consistency effectively requires

<!-- pág. 766 -->

712 Multiprocessor Management

                           the two processes to share the page, even though their modifications do not affect
                           one another. 112
                                  Systems that use relaxed consistency perform coherence operations periodi-
                           cally. The premise behind this strategy is that delaying coherence for remote data by
                           a few seconds is not noticeable to the user and can increase performance and
                           reduce the false sharing effect.113
                                  In release consistency, a series of accesses begin with an acquire operation and
                           end with a release operation. All updates between the acquire and the release are
                           batched as one update message after the release. 114 In lazy release consistency, the
                           update is delayed until the next acquire attempt for the modified memory. This
                           reduces network traffic, because it eliminates coherence operations for pages that
                           are not accessed again.115
                                  One interesting consequence of lazy release consistency is that only a node that
                           attempts to access a modified page receives the modification. If this node also modi-
                           fies the page, a third node would need to apply two updates before it can access the
                           page. This can lead to substantial page-update overhead. One way to reduce this
                           problem is to provide periodic global synchronization points at which all data must
                           be consistent.116 An alternative way to reduce this problem is to use a home-based
                           consistency approach similar to that used for cache coherence in a CC-NUMA. The
                           home node for each page is responsible for keeping an updated version of the page.
                           Nodes that issue an acquire to a page that has been updated since that its last release
                           must obtain the update from the home node. 117
                                  The delayed consistency approach sends update information when a release
                           occurs, but nodes receiving updates do not apply them until the next acquisition.
                           These updates can be collected until a new acquire attempt, at which point the node
                           applies all update information. This does not reduce network traffic, but it improves
                           performance because nodes do not have to perform coherence operations as fre-
                           quently 118
                                  Lazy data propagation notifies other nodes that a page has been modified at
                           release time. This notification does not supply the modified data, which can reduce
                           bus traffic. Before a node acquires data for modification, it determines if that data
                           has been modified by another node, If so, the former node retrieves update infor-
                           mation from the latter. Lazy data propagation has the same benefits and drawbacks
                           as lazy release consistency. This strategy significantly reduces communication traf-
                           fic, but requires a mechanism to control the size of update histories, such as a global
                           synchronization point.119




                          Self Review
                           1. What is a benefit of relaxed consistency? A drawback?
                           2. In many relaxed consistency implementations, data may not be coherent for several seconds.
                              Is this is a problem in all environments? Give an example where it might be a problem.

<!-- pág. 767 -->

                                                                                       15.6 Multiprocessor Scheduling 713
Ans: 1) Relaxed consistency reduces network traffic and increases performance. However,
the system's memory can be incoherent for a significant period of time, which increases the
likelihood that processors will operate on stale data. 2) This is not a problem in all environ-
ments, considering that even sequential consistency schemes may use networks exhibiting
latencies of a second or two. However, latency of this magnitude is not desirable for a super-
computer in which many processes interact and communicate through shared memory. The
extra latency degrades performance due to frequent invalidations.



15.6 Multiprocessor Scheduling
 Multiprocessor scheduling has goals similar to those of uniprocessor scheduling—
 the system attempts to maximize throughput and minimize response time for all
processes. Further, the system must enforce scheduling priority
       Unlike uniprocessor scheduling algorithms which only determine in what
order processes are dispatched, multiprocessor scheduling algorithms also must
determine to which processor they are dispatched, which increases scheduling com-
plexity. For example, multiprocessor scheduling algorithms should ensure that pro-
cessors are not idle while processes are waiting to execute.
       When determining the processor on which a process is executed, the scheduler
considers several factors. For example, some strategies focus on maximizing parallel-
ism in a system to exploit application concurrency. Systems often group collaborating
processes into a job. Executing a job's processes in parallel improves performance by
enabling these processes to execute truly simultaneously. This section introduces sev-
eral timesharing scheduling algorithms that attempt to exploit such parallelism by
scheduling collaborative processes on different processors.120 This enables the pro-
cesses to synchronize their concurrent execution more effectively.
       Other strategies focus on processor affinity—the relationship of a process to a
particular processor and its local memory and cache. A process that exhibits high
processor affinity executes on the same processor through most or all of its life
cycle. The advantage is that the process will experience more cache hits and, in the
case of a NUMA or NORMA design, possibly fewer remote page accesses than if it
were to execute on several processors throughout its life cycle. Scheduling algo-
rithms that attempt to schedule a process on the same processor throughout its life
cycle maintain soft affinity, whereas algorithms that schedule a process on only one
processor maintain hard affinity.121
       Space-partitioning scheduling algorithms attempt to maximize processor
affinity by scheduling collaborative processes on a single processor (or single set of
processors) under the assumption that collaborative processes will access the same
shared data, which is likely stored in the processor's caches and local memory.122
Therefore, space-partitioning scheduling increases cache and local memory hits.
However, it can limit throughput, because these processes typically do not execute
simultaneously.123
       Multiprocessor scheduling algorithms are generally classified as job blind or
job aware. Job-blind scheduling policies incur minimal scheduling overhead,

<!-- pág. 768 -->

714 Multiprocessor Management

                           because they do not attempt to enhance a job's parallelism or processor affinity.
                           Job-aware scheduling evaluates each job's properties and attempts to maximize
                           each job's parallelism or processor affinity, which increases performance at the cost
                           of increased overhead.
                                  Many multiprocessor scheduling algorithms organize processes in global run
                           queues.124 Each global run queue contains all the processes in the system that are
                           ready to execute. Global run queues might be used to organize processes by prior-
                           ity, by job or by which process executed most recently.125
                                  Alternatively, systems might use a per-processor run queue. This is typical of
                           large, loosely coupled systems (such as NORMA systems) in which cache hits and
                           references to local memory should be maximized. In this case, processes are associ-
                           ated with a specific processor and the system implements a scheduling policy for
                           that processor. Some systems use per-node run queues; each node might contain
                           more than one processor. This is appropriate for a system in which a process is tied
                           to a particular group of processors. We describe the related issue of process migra-
                           tion, which entails moving processes from one per-processor or per-node run queue
                           to another, in Section 15.7, Process Migration.


                          Self Review
                           1. What types of processes benefit from timesharing scheduling? From space-partitioning
                              scheduling?
                           2. When are per-node run queues more appropriate than global run queues?
                          Ans: 1) Timesharing scheduling executes related processes simultaneously, improving per-
                          formance for processes that interact frequently because processes can react to messages or
                          modifications to shared memory immediately. Space-partitioning scheduling is more appro-
                          priate for processes that must sequentialize access to shared memory (and other resources)
                          because their processors are likely to have cached shared data, which improves performance.
                          2) Per-node run queues are more appropriate than global run queues in loosely coupled sys-
                          tems, where processes execute much less efficiently when accessing remote memory.


                           15.6.1 Job-Blind Multiprocessor Scheduling
                           Job-blind multiprocessor scheduling algorithms schedule jobs or processes on any
                           available processor. The three algorithms described in this section are examples of
                           job-blind multiprocessor scheduling algorithms. In general, any uniprocessor sched-
                           uling algorithm, such as those described in Chapter 8, can be implemented as a job-
                           blind scheduling multiprocessor algorithm.

                           First-Come-First-Served (FCFS) Process Scheduling
                           First-come-first-served (FCFS) process scheduling places arriving processes in a glo-
                           bal run queue. When a processor becomes available, the scheduler dispatches the pro-
                           cess at the head of the queue and runs it until the process relinquishes the processor.
                                 FCFS treats all processes fairly by scheduling them according to their arrival
                           times. However, FCFS might be considered unfair because long processes make

<!-- pág. 769 -->

                                                                                      15.6       Multiprocessor   Scheduling   715

short processes wait, and low-priority processes can make high-priority processes
wait—although a preemptive version of FCFS can prevent the latter from occur-
ring. Typically, FCFS scheduling is not useful for interactive processes, because
FCFS cannot guarantee short response times. However, FCFS is easy to implement
and eliminates the possibility of indefinite postponement—once a process enters
the queue, no other process will enter the queue ahead of it.126-127

Round-Robin Process (RRprocesss) Multiprocessor Scheduling
Round-robin process (RRprocess) scheduling places each ready process in a global
run queue. RRprocess scheduling is similar to uniprocessor round-robin schedul-
ing—a process executes for at most one quantum before the scheduler dispatches a
new process for execution. The previously executing process is placed at the end of
the global run queue. This algorithm prevents indefinite postponement, but does
not facilitate a high degree of parallelism or processor affinity because it ignores
relationships among processes.128-129

Shortest-Process-First (SPF) Multiprocessor Scheduling
A system can also implement the shortest-process-first (SPF) scheduling algorithm,
which dispatches the process that requires the least amount of time to run to com-
pletion.130 Both preemptive and nonpreemptive versions of SPF exhibit lower
average waiting times for interactive processes than FCFS does, because interactive
processes typically are "short" processes. However, a longer process can be indefi-
nitely postponed if shorter processes continually arrive before it can obtain a pro-
cessor. As with all job-blind algorithms, SPF does not consider parallelism or
processor affinity.

Self Review
1. Is a UMA or a NUMA system more suitable for job-blind multiprocessor scheduling?
2. Which job-blind scheduling strategy discussed in this section is most appropriate for batch
   processing systems and why?
Ans: 1) A UMA system is more appropriate for a job-blind algorithm. NUMA systems
often benefit from scheduling algorithms that consider processor affinity, because memory
access time depends on the node at which a process executes, and nodes in a NUMA system
have their own local memory. 2) SPF is most appropriate because it exhibits high throughput,
an important goal for batch-processing systems.



15.6.2 Job-Aware Multiprocessor Scheduling
Although job-blind algorithms are easy to implement and incur minimal overhead,
they do not consider performance issues specific to multiprocessor scheduling. For
example, if two processes that communicate frequently do not execute simulta-
neously, they might spend a significant amount of their time busy waiting, which
degrades overall system performance. Furthermore, in most multiprocessor systems,

<!-- pág. 770 -->

716 Multiprocessor Management
                          each processor maintains its own private cache. Processes in the same job often
                          access the same memory items, so scheduling one job's processes on the same pro-
                          cessor tends to increase cache hits and improves memory-access performance. In
                          general, job-aware process-scheduling algorithms attempt to maximize parallelism
                          or processor affinity, at the cost of greater scheduling algorithm complexity.

                          Smallest-Number-of-Processes-First (SNPF) Scheduling
                          The smallest-number-of-processes-first (SNPF) scheduling algorithm, which can be
                          either preemptive or nonpreemptive, uses a global job priority queue. A job's prior-
                          ity is inversely proportional to the number of processes in the job. If jobs containing
                          the same number of processes compete for a processor, the job that has waited the
                          longest receives priority. In nonpreemptive SNPF scheduling, when a processor
                          becomes available, the scheduler selects a process from the job at the head of the
                          queue and allows it to execute to completion. In preemptive SNPF scheduling, if a
                          new job arrives with fewer processes, it receives priority and its processes are dis-
                          patched immediately 131 - 132 SNPF algorithms improve parallelism, because pro-
                          cesses that are associated with the same job can often execute concurrently.
                          However, the SNPF algorithms do not attempt to improve processor affinity. Fur-
                          ther, it is possible for jobs with many processes to be postponed indefinitely.


                          Round-Robin Job (RRJob) Scheduling
                         Round-robin job (RRJob) scheduling employs a global job queue from which each
                         job is assigned to a group of processors (although not necessarily the same group each
                         time the job is scheduled). Every job maintains its own process queue. If the system
                         contains p processors and uses a quantum of length q, then a job receives a total of
                         p x q of processor time when dispatched. Typically, a job does not contain exactly p
                         processes that each exhaust one quantum (e.g., a process may block before its quan-
                         tum expires). Therefore, RRJob uses round-robin scheduling to dispatch the job's
                         processes until the job consumes the entire p x q quanta, the job completes or all of
                         the job's processes block. The algorithm also can divide the p x q quanta equally
                         among the processes in the job, allowing each to execute until it exhausts its quantum,
                         completes or blocks. Alternatively, if a job has more than p processes, it can select p
                         processes to execute for a quantum length of q.133
                               Similar to RRprocess scheduling, this algorithm prevents indefinite postpone-
                         ment. Further, because processes from the same job execute concurrently, this algo-
                         rithm promotes parallelism. However, the additional context-switching overhead of
                         round-robin scheduling can reduce job throughput.134-135

                         Cischeduling
                          Coscheduling (or gang scheduling) algorithms employ a global run queue that is
                          accessed in round-robin fashion. The goal of coscheduling algorithms is to execute
                          processes from the same job concurrently rather than maximize processor affin-
                          ity.136 There are several coscheduling implementations—matrix, continuous and

<!-- pág. 771 -->

                                                                               15.6 Multiprocessor Scheduling 717
undivided. We present only the undivided algorithm, because it corrects some of
the deficiencies of the matrix and continuous algorithms.
      The undivided coscheduling algorithm places processes from the same job in
adjacent entries in the global run queue (Fig. 15.13). The scheduler maintains a
  "window" equal to the number of processors in the system. All processes within a
window execute in parallel for at most one quantum. After scheduling a group of
processes, the window moves to the next group of processes, which also execute in
parallel for one quantum. To maximize processor utilization, if a process in the win-
dow is suspended, the algorithm extends the sliding window one process to the right
to allow another runnable process to run for the given quantum, even if it is not
part of a job that is currently executing.
      Because coscheduling algorithms use a round-robin strategy, they prevent
indefinite postponement. Furthermore, because processes from the same job often
run at the same time, coscheduling algorithms allow programs that are designed to
run in parallel to take advantage of a multiprocessing environment. Unfortunately,
the processor on which a process might be dispatched to a different processor each
time, which can reduce processor affinity.137

Dynamic Partitioning
Dynamic partitioning minimizes the performance penalty associated with cache
misses by maintaining high processor affinity.138 The scheduler evenly distributes
processors in the system among jobs. The number of processors allocated to a job is
always less than or equal to the job's number of runnable processes.
      For example, consider a system that contains 32 processors and executes three
jobs—the first with eight runnable processes, the second with 16 and the third with
20. If the scheduler were to divide the processors evenly between jobs, one job
would receive 10 processors and the other two jobs 11. In this case, the first job has
only eight processes, so the scheduler assigns eight processors to that job and evenly
distributes the remaining 24 processors (12 each) to the second and third jobs
(Example 1 in Fig. 15.14). Therefore, a particular job always executes on a certain




Figure 15.13 | Coscheduling (undivided version).

<!-- pág. 772 -->

718 Multiprocessor Management




                           Figure 15.14 |    Dynamic     partitioning.

                           subset of processors as long as no new jobs enter the system. The algorithm can be
                           extended so that a particular process always executes on the same processor. If
                           every job contains only one process, dynamic partitioning reduces to a round-robin
                           scheduling algorithm.139
                                  As new jobs enter the system, the system dynamically updates the processor
                           allocation. Suppose a fourth job containing 10 runnable processes (Example 2 in
                           Fig. 15.14) enters the system. The first job retains its allocation of eight processors, but
                           the second and third jobs each relinquish four processors to the fourth job. Thus, the
                           processors are evenly distributed among the jobs—eight processors per job.140 The
                           algorithm updates the number of processors each job receives whenever jobs enter or
                           exit the system, or a process within a job changes state from running to waiting or vice
                           versa. Although the number of processors allocated to jobs changes, a job still exe-
                           cutes on either a subset or superset of its previous allocation, which helps maintain
                           processor affinity.141 For dynamic partitioning to be effective, the performance
                           increase from cache affinity must outweigh the cost of repartitioning.142

                           Self Review
                           1. How are RRJob and undivided coscheduling similar? How are they different?
                           2. Describe some of the trade-offs between implementing a global scheduling policy that max-
                              imizes processor affinity, such as dynamic partitioning, and per-processor run queues.

<!-- pág. 773 -->

                                                                                               15.7 Process Migration 719
Ans: 1) RRJob and undivided coscheduling are similar in that both schedule processes of a
job to execute concurrently in round-robin fashion. Undivided coscheduling simply places
processes of the same job next to each other in the global run queue where they wait for the
next available processor. RRJob schedules only entire jobs. 2) Global scheduling is more
flexible because it reassigns processes to different processors depending on system load.
However, per-processor run queues are simpler to implement and can be more efficient than
maintaining global run queue information.


15.7 Process Migration
Process migration entails transferring a process between two processors.143-144 This
might occur if, for example, a processor fails or is overloaded.
     The ability to execute a process on any processor has many advantages. The
most obvious is that processes can move to processors that are underutilized to
reduce process response times and increase performance and throughput. 145 - 146
(We describe this technique, called load balancing, in more detail in Section 15.8,
Load Balancing.) Process migration also promotes fault tolerance. 147 For example,
consider a program that must perform intensive, uninterrupted computation. If the
machine running the program needs to be shut down or becomes unstable, the pro-
gram's progress might be lost. Process migration allows the program to move to
another machine to continue computation perhaps in a more stable environment.
      In addition, process migration promotes resource sharing. In large-scale sys-
tems, some resources might not be replicated at every node. For example, in a
NORMA system, processes might execute on machines with different hardware
device support. A process might require access to a RAID array that is available
through only one computer. In this case, the process should migrate to the com-
puter with access to the RAID array for better performance.
     Finally, process migration improves communication performance. Two pro-
cesses that communicate frequently should execute on or near the same node to
reduce communication latency. Because communication links are often dynamic,
process migration can be used to make process placement dynamic.148

Self Review
1. What are some benefits provided by process migration?
2. On which types of systems (UMA, NUMA or NORMA) is process migration most appro-
   priate?
Ans: 1) Process migration promotes fault tolerance by moving processes away from mal-
functioning nodes, supports load balancing, can reduce communication latency and promotes
resource sharing. 2) Process migration is appropriate for large-scale NUMA or NORMA sys-
tems that use per-processor (or per-node) run queues. Process migration enables these sys-
tems to perform load balancing and share resources local to each node.



15.7.1 F l o w of Process Migration
Although process migration implementations vary across architectures, many
implementations follow the same general steps (Fig. 15.15). First, a node issues a

<!-- pág. 774 -->

720   Multiprocessor Management




                            Figure 15.15 | Process migration.


                            migration request to a remote node. In most schemes, the sender initiates the
                            migration because its node is overloaded or a specific process needs to access a
                            resource located at a remote node. In some schemes, an underutilized node might
                            request processes from other nodes. If the sender and receiver agree to migrate a
                            process, the sender suspends the migrating process. The sender creates a message
                            queue to hold all messages destined for the migrating process. Then, the sender
                            extracts the process's state; this includes copying the process's memory contents
                            (i.e., pages marked as valid in the process's virtual memory), register contents, state
                            of open files and other process-specific information. The sender transmits the
                            extracted state to a "dummy" process that the receiver creates. The two nodes
                            notify all other processes of the migrated process's new location. Finally, the
                            receiver dispatches the new instance of the process, the sender forwards the mes-

<!-- pág. 775 -->

                                                                                                15.7 Process Migration 721

sages in the migrated process's message queue and the sender destroys the local
instance of the process.149-150

Self Review
1. List some items that compose a process's state and that must be migrated with a process.
2. What overhead is incurred in process migration?
Ans: 1) The sending process must transfer such items as the process's memory contents,
register contents and state of open files. 2) The overhead includes migrating the process and
its state, rerouting messages to the receiving node, maintaining two instances of the process
for a short time (the old instance and the "dummy process"), suspending the process for a
short time and sending messages to other nodes to inform them about the migrated process's
new location.


15.7.2 Process Migration Concepts
Memory transfer is the most time-consuming element of migration. 151 To minimize
the process migration's performance cost, residual dependency—a process's depen-
dency on its former node—must be minimized. For example, the process's former
node might contain part of the process's working set or might be executing other
processes with which the migrated one was communicating. If migration results in
many residual dependencies, a receiving node must communicate with the sending
node while executing the migrated process. This increases IPC, which generates
more traffic on the interconnection network and degrades performance due to high
latencies. Also, residual dependencies decrease fault tolerance, because the
migrated process's execution depends on both nodes functioning correctly.152
      Often, the strategies that result in the highest degree of residual dependency
transfer pages from the sender only when the process at the receiving node refer-
ences them. These lazy (or on-demand) migration strategies reduce the initial pro-
cess migration time —the duration for which the migrating process is suspended. In
lazy migration, the process's state (and other required) information is transferred to
the receiver, but the original node retains the process's pages. As the process exe-
cutes on the remote node, it must initiate a memory transfer for each access to a
page that remains at the sending node. Although this technique yields fast initial
process migration, memory access can severely decrease an application's perfor-
mance. Lazy migration is most useful when the process does not require frequent
access to the remote address space.153-154
      For successful migration, processes should exhibit several characteristics. A
migrated process should exhibit transparency—i.e., it should not be adversely
affected (except, perhaps, for a slight delay in response time) by migration. In other
words, the process should lose no interprocess messages or open file handles.155 A
system also must be scalable—if process's residual dependencies grow with each
migration, then a system could quickly be overwhelmed by network traffic as pro-
cesses request remote pages. Finally, advances in communication technology across
multiple architectures have created the need for heterogeneous process migra-

<!-- pág. 776 -->

722   Multiprocessor Management

                            tions—processes should be able to migrate between two different processor archi-
                            tectures in distributed systems. This implies that process state should be stored in a
                            platform-independent format.156 Section 17.3.6, Process Migration in Distributed
                            Systems, discusses heterogeneous process migration architectures in more detail.

                           Self Review
                            1. Why is residual dependency undesirable? Why might some residual dependency be bene-
                               ficial?
                            2. How might a migration strategy that results in significant residual dependency not be scal-
                               able?
                           Ans: 1) Residual dependency is undesirable because it decreases fault tolerance and
                           degrades performance after the transfer. One reason for allowing residual dependency is that
                           it reduces initial transfer time. 2) If a process that already has a residual dependency migrates
                           again, it will now rely on three nodes. With each migration, the process's state grows (so it
                           can find its memory pages) and its fault tolerance decreases.


                            15.7.3     Process Migration Strategies
                           Process migration strategies must balance the performance penalty of transferring
                           large amounts of process data with the benefit of minimizing a process's residual
                           dependency. In some systems, designers assume that most of a migrated process's
                           address space will be accessed at its new node. These systems often implement eager
                           migration, which transfers all of a process's pages during initial process migration.
                           This enables the process to execute as efficiently at its new node as it did at its previ-
                           ous one. However, if the process does not access most of its address space, the initial
                           latency and the bandwidth required by eager migration are largely overhead.157, 158
                                  To mitigate eager migration's initial cost, dirty eager migration transfers only a
                           process's dirty pages. This strategy assumes that there is common secondary storage
                           (e.g., a disk to which both nodes have access). All clean pages are brought in from the
                           common secondary storage as the process references them from the remote node.
                           This reduces initial transfer time and eliminates residual dependency. However, each
                           access to a nonresident page takes longer than it would have using eager migration.159
                                  One disadvantage of dirty eager migration is that the migrated process must
                           use secondary storage to retrieve the process's clean pages. Copy-on-reference
                           migration is similar to dirty eager migration, except that the migrated process can
                           request clean pages from either its previous node or the common secondary stor-
                           age. This strategy has the same benefits as dirty eager migration but gives the mem-
                           ory manager more control over the location from which to request pages —access to
                           remote memory may be faster than disk access. However, copy-on-reference migra-
                           tion can add memory overhead at the sender.160-161
                                  The lazy copying implementation of copy-on-reference transfers only the min-
                           imum state information at initial migration time; often, no pages are transferred.
                           This creates a large residual dependency, forces the previous node to keep pages in
                           memory for the migrated process and increases memory-access latency over strate-
                           gies that migrate dirty pages. However, the lazy copying strategy eliminates most

<!-- pág. 777 -->

                                                                                                15.8 Load Balancing 723

 initial migration latency.162' 163 Such latency might be unacceptable for real-time
processes and is inappropriate for most processes.164
       All the strategies discussed so far either create residual dependency or incur a
large initial migration latency. A method that eliminates most of the initial migra-
tion latency and residual dependency is the flushing strategy. In this strategy, the
sender writes all pages of memory to shared secondary storage when migration
begins; the migrating process must be suspended while the data is being written to
secondary storage. The process then accesses the pages from secondary storage as
needed. Therefore, no actual page migration occurs to slow initial migration, and
the process has no residual dependency on the previous node. However, the flush-
ing strategy reduces process performance at its new node, because the process has
no pages in main memory, leading to page faults.165-166
       Another strategy for eliminating most of the initial migration latency and
residual dependency is the precopy method, in which the sender node begins trans-
ferring dirty pages before the original process is suspended. Any transferred page
that the process modifies before it migrates is marked for retransmission. To ensure
that a process eventually migrates, the system defines a lower threshold for the
number of dirty pages that should remain before the process migrates. When that
threshold is reached, the process is suspended and migrated to another processor.
With this technique, the process does not need to be suspended for long (compared
to other techniques such as eager and copy-on-reference), and memory access at
the new node is fast because most data has already been copied. Also, residual
dependency is minimal. The process's working set is duplicated for a short time (it
exists at both nodes involved in migration), but this a minor drawback. 167168

Self Review
1. Which migration strategies should be used with real-time processes?
2. Although initial migration time is minimal and there is little residual dependency for the
   precopy strategy, can you think of any "hidden" performance costs this strategy incurs?
Ans: 1) Real-time processes cannot be suspended for long because this would slow
response time. Therefore, strategies such as lazy copying, flushing, copy-on-reference and
precopy are best for soft real-time processes. However, hard real-time processes should not
be migrated because migration always introduces some indeterministic delay. 2) The process
must continue executing on the sender node while its state is being copied to the receiving
node. Because a migration decision was made, it is reasonable to assume that executing on
the sending node is no longer desirable and therefore, precopy includes this additional cost.



15.8 Load Balancing
One measure of efficiency in a multiprocessor system is overall processor utilization.
In most cases, if processor utilization is high, the system is performing more effi-
ciently. Most multiprocessor systems (especially NUMA and NORMA systems)
attempt to maximize processor affinity. This increases efficiency, because the pro-
cesses do not need to access remote resources as often, but it might reduce processor

<!-- pág. 778 -->

724   Multiprocessor Management

                            utilization if all the processes assigned to a particular processor complete. This proces-
                            sor will idle while processes are dispatched to other processors to exploit affinity.
                            Load balancing is a technique in which the system attempts to distribute processing
                            loads evenly among processors. This increases processor utilization and shortens run
                            queues for overloaded processors, reducing average process response times.169
                                  A load balancing algorithm might assign a fixed number of processors to a job
                            when the job is first scheduled. This is called static load balancing. This method
                            yields low runtime overhead, because processors spend little time determining the
                            processors on which a job should execute. However, static load balancing does not
                            account for varying process populations within a job. For example, a job might
                            include many processes initially, but maintain only a few processes throughout the
                            rest of its execution. This can lead to unbalanced run queues, which may lead to
                            processor idling.170
                                  Dynamic load balancing attempts to address this issue by adjusting the num-
                            ber of processors assigned to a job throughout its life. Studies have shown that
                            dynamic load balancing performs better than static load balancing when context-
                            switch time is low and system load is high.171

                           Self Review
                            1. What are some of the benefits of implementing load balancing?
                            2. What scheduling algorithms benefit from load balancing?
                           Ans: 1) Some of the benefits of load balancing include higher processor utilization, which
                           leads to higher throughput, and reduced process response time. 2) Load balancing is appro-
                           priate for scheduling algorithms that maximize processor affinity, such as dynamic partition-
                           ing. Also, it can benefit systems that maintain per-processor or per-node run queues.


                            15.8.1 Static Load Balancing
                            Static load balancing is useful in environments in which jobs repeat certain tests or
                            instructions and therefore exhibit predictable patterns (e.g., scientific comput-
                            ing). 172 These patterns can be represented as graphs that can be used to model
                            scheduling. Consider the processes in a system as vertices in a graph, and communi-
                            cations between processes as edges. For example, if there is an application in which
                            one process continually analyzes similar data, then feeds that data to another pro-
                            cess, this can be modeled as two nodes connected by one edge. Because this rela-
                            tionship will be consistent throughout the application's life, there is no need to
                            adjust the graph.
                                   Due to shared cache and physical memory, communication between processes
                            at the same processor is much faster than communication between processes at differ-
                            ent processors. Therefore, static load balancing algorithms attempt to divide the
                            graph into subgraphs of similar size (i.e., each processor has a similar number of pro-
                            cesses) while minimizing edges between subgraphs to reduce communication
                            between processors.173 However, this technique can incur significant overhead for a
                            large number of jobs.174 Consider the graph in Fig. 15.16. Two dashed lines represent

<!-- pág. 779 -->

                                                                                                    15.8 Load Balancing 725




Figure 15.16 | Static load balancing using graphs.

possible cuts to divide the processes somewhat evenly. Cut #1 yields four interproces-
sor communication channels, whereas cut #2 yields only two, thus representing a bet-
ter grouping of processes.
      Static load balancing can be inadequate when communication patterns change
dynamically and when processes complete with no new processes to take their
places. The first case might perform less efficiently due to high communication
latency. In the second case, processor utilization could decrease even when there
are processes waiting to obtain a processor. In these cases, dynamic load balancing
can improve performance. 175

Self Review
1. When is static load balancing useful? When is it not useful?
2. In Fig. 15.16, there is a substantial difference between cut #1 and cut #2. Considering that
   it is difficult to find the most effective cut when there are large numbers of jobs, what does
   this say about the limitations of static load balancing?
Ans: 1) Static load balancing is useful in environments where processes might exhibit pre-
dictable communication patterns. It is not useful in environments where communication pat-
terns change dynamically and processes are created or terminated unpredictably. 2) The
difference between Cut #1 (four IPC channels) and Cut #2 (two IPC channels) illustrates the
performance implications of making bad decisions. Most large systems will have to estimate
to find a solution; a wrong estimate could severely degrade performance.


15.8.2 Dynamic Load Balancing
Dynamic load balancing algorithms migrate processes after they have been created
in response to system load. The operating system maintains statistical processor
 load information such as the number of active and blocked processes at a processor,
average processor utilization, turnaround time and latency.176-177 If many of a pro-
cessor's processes are blocked or have a large turnaround times, the processor most
likely is overloaded. If a processor does not have a high processor utilization rate, it
probably is underloaded.
      Several policies may be used to determine when to migrate processes in
dynamic load balancing. The sender-initiated policy activates when the system
determines that a processor contains a heavy load. Only then will the system search

<!-- pág. 780 -->

726   Multiprocessor Management
                            for underutilized processors and migrate some of the overloaded processor's jobs to
                            them. This is best for systems with light loads, because process migration is costly
                            and, in this case, the policy will rarely be activated.178, 179
                                  Conversely, a receiver-initiated policy is better for overloaded systems. In this
                            environment, the system initiates process migration when a processor's utilization is
                            low.180, 181
                                  Most systems experience heavy and light loads over time. For these systems,
                            the symmetric policy, which combines the previous two methods, provides maxi-
                            mum versatility to adapt to environmental conditions.182, 183 Finally, the random
                            policy, in which the system arbitrarily chooses a processor to receive a migrated
                            process, has shown decent results due to its simple implementation and (on aver-
                            age) even distribution of processes. The motivation behind the random policy is
                            that the migrating process's destination will likely have a smaller load than its ori-
                            gin, considering that the original processor is severely overloaded. 184, 185
                                  The subsections that follow describe common algorithms that determine how
                            processes are migrated. For the purposes of this discussion, consider that the multi-
                            processor system can be represented by a graph in which each processor and its
                            memory are a vertex and each link is an edge.

                            Bidding Algorithm
                            The bidding algorithm is a simple sender-initiated migration policy. Processors with
                            smaller loads "bid" for processes on overloaded processors, much as in an auction.
                            The value of a bid is based on the current load of the bidding processor and the dis-
                            tance between the underloaded and overloaded processors in the graph. To reduce
                            the process migration cost, more direct communication paths to the overloaded pro-
                            cessor receive higher bid values. The overloaded processor accepts bids from proces-
                            sors that are within a certain distance on the graph. If the overloaded processor
                            receives too many bids, it decreases the distance; if it receives too few, it increases the
                            distance and checks again. The process is sent to the processor with the highest bid.186

                           Drafting Algorithm
                            The drafting algorithm is a receiver-initiated policy that classifies the load at each
                            processor as low, normal or high. Each processor maintains a table describing the
                            other processors' loads using these classifications. Often in large-scale or distrib-
                            uted systems, processors maintain only information about their neighbors. Even
                            time a processor's load changes classification, the processor broadcasts its updated
                            information to the processors in its load table. When a processor receives one of
                            these messages, it appends its own information and forwards the message to its
                            neighbors. In this way, information about load levels eventually reaches all nodes in
                            the network. Underutilized processors use this information to request processes
                            from overloaded processors.187

<!-- pág. 781 -->

                                                                                          15.8 Load Balancing 727

Communications Issues
Inefficient or incorrect communication strategies can overwhelm a system. For exam-
ple, some process migration implementations employ systemwide broadcasts. The
flood of broadcast messages can overwhelm communication channels. Due to com-
munication delays, many overloaded processors could receive a request for a process
at the same time and all send their processes to one underloaded processor.188
      Several strategies have been devised to avoid these problems. For example, the
algorithm could restrict processors to communicate only with then immediate neigh-
bors, which reduces the number of messages that are transmitted, but increases the
time required for information to reach every node in the system.189 Alternatively, pro-
cessors could periodically select a random processor with which to exchange informa-
tion. In this case, processes are migrated from the processor with the higher load to
the one with a lower load.190 In cases where one processor is severely overloaded and
the rest are underloaded, this results in rapid process diffusion.
      Figure 15.17 illustrates process diffusion in a system in which nodes communi-
cate only with their neighbors. The overloaded processor, represented by the middle
vertex, has 17 processes while all others have one process. After one iteration, the
overloaded processor communicates with its neighbors and sends three processes to
each. Now those processors have four processes, which is three more than some of
their neighbors have. In the second iteration, the processors with four processes send
some to their neighbors. Finally, in the third iteration, the overloaded processor once
again sends some processes to its neighbors so that now the processor with the
heaviest load has only three processes. This example illustrates that even when com-
munications are kept among neighboring processors, load balancing can effectively
distribute processing responsibilities throughout the system.




                System at
                    start:




Figure 15.17 | Processor load diffusion. (Part 1 of 2.)

<!-- pág. 782 -->

728 Multiprocessor Management




                                       . . . After one
                                              iteration




                                       ...After two
                                          iterations




                                   ...After three
                                       iterations:




                         Figure 15.17 | Processor load diffusion. (Part 2 of 2.)

<!-- pág. 783 -->

                                                                               15.9 Multiprocessor Mutual Exclusion 729

Self Review
1. In what type of environment should a sender-oriented policy be used? A receiver-oriented
   policy? Justify your answers.
2. How does high communication latency hinder the effectiveness of load balancing?
Ans: 1) A system with a light load should use a sender-oriented policy, whereas a system with
a heavy load should use a receiver-oriented policy. In both cases this will reduce unnecessary
migrations, because there will be few senders in a system with a light load and few receivers in
one with a heavy load. 2) A node sending a message that it is underloaded might have become
overloaded by the time another node receives the message. Thus, the receiving node could fur-
ther unbalance the system's load by migrating additional processes to the sender.



15.9 Multiprocessor Mutual Exclusion
Many of the mutual exclusion mechanisms we described in Chapter 5 are not ade-
quate for multiprocessor systems. For example, disabling interrupts, which prevents
other processes from executing by disabling preemption on uniprocessor systems,
does not guarantee mutual exclusion on multiprocessors because several processes
can execute simultaneously on different processors. Instructions such as test-and-set
can be inefficient when the data these instructions reference is located in remote
memory. Test-and-set has another weakness, namely that each of the pending opera-
tions requires a separate memory access; these are performed sequentially, because
only one access to a memory location may normally occur at a time. Such collisions
can quickly saturate various kinds of interconnection networks, causing serious per-
formance problems. Because of nontrivial communication costs and the fact that
multiple processes execute at the same time, designers have developed a number of
mutual exclusion techniques for multiprocessors. This section introduces mutual
exclusion techniques for nondistributed multiprocessing systems. We present distrib-
uted mutual exclusion in Section 17.5, Mutual Exclusion in Distributed Systems.


15.9.1 Spin Locks
Multiprocessor operating systems, such as Windows XP and Linux, frequently use
spin locks for multiprocessor mutual exclusion. A spin lock is called a "lock"
because a process that holds a spin lock claims exclusive access to the resource the
spin lock protects (e.g., a shared data structure in memory or a critical section of
code). In effect, other processes are "locked out" of the resource. Other processes
that wish to use the resource "spin" (i.e., busy wait) by continually testing a condi-
tion to determine whether the resource is available. In uniprocessing systems, spin
locks are wasteful because they consume processor cycles that could be used by
other processes, including the one that holds the lock, to do useful work. In multi-
processing systems, the process holding the lock could release it while another pro-
cess is busy waiting. In this case, it is more efficient for a process to busy wait if the
time required for the system to perform a context switch to schedule another pro-
cess is longer than the average busy-wait time. 191 Also, if a processor contains no

<!-- pág. 784 -->

730 Multiprocessor Management
                          other runnable processes in its run queue, it makes sense to keep the process spin-
                          ning to minimize the response time when the spin lock is released. 192 ' 193
                                When a process holds a spin lock for a long duration (relative to context-
                          switch time), blocking is more efficient. Delayed blocking is a technique in which a
                          process spins for a short period of time; if it does not acquire the lock in that time,
                          the process blocks.194 An advisable process lock (APL) presents an alternative solu-
                          tion. When a process acquires an APL, it specifies the amount of time it will hold
                          the lock. Based on the time specified, other processes waiting to acquire the APL
                          can determine if it is more efficient to busy wait for the lock or to block.195
                                Adaptive locks (also called configurable locks) add flexibility to a mutual
                          exclusion implementation. At certain times, such as when there are few active pro-
                          cesses, spin locks are preferable because a process can acquire a resource soon after
                          it becomes available. At times when system load is high, spinning wastes valuable
                          processor cycles and blocking is preferable. Adaptive locks permit a process to
                          dynamically change the type of lock being used. These locks can be set to blocking,
                          spinning or delayed blocking and can incorporate APL features to customize the
                          lock according to system load and application needs. 196
                                When multiple processes simultaneously wait for a spin lock to be released,
                          indefinite postponement can occur. Operating systems can prevent indefinite post-
                          ponement by granting the spin lock to processes in first-come-first-served order, or
                          by aging processes waiting on the spin lock, as discussed in Section 7.3.

                          Self Review
                          1. In what way can spinning be useful in a multiprocessor? Under what conditions is it not
                             desirable in a multiprocessor? Why is spinning not useful in a uniprocessor system?
                          2. Why might an APL not be useful in all situations?
                          Ans: 1) Spinning can be useful because it minimizes the time between when a resource
                          becomes available and when a new process acquires the resource. Spinning is not desirable
                          when system load is high and the expected time before the resource is available is greater than
                          context-switch time; in these cases, spinning uses valuable processor cycles. Spinning is not use-
                          ful in uniprocessor systems because it blocks the execution of the process holding the resource.
                          2) An APL is not useful when a process cannot determine how long it will hold the lock.



                          15.9.2 Sleep/Wakeup Locks
                          A sleep/wakeup lock provides synchronization similar to a spin lock, but reduces
                          wasted processor cycles and bus traffic. Consider processes P1 and P 2 , both of which
                          request use of a resource protected by a sleep/wakeup lock. P1 requests the
                          resource first and obtains the lock. When P2 requests the resource owned by P1 and
                          does not receive the resource, P 2 responds by sleeping (i.e., blocking). Once P 1
                          releases the lock, P1 wakes the highest-priority process waiting for the resource (in
                          this case, P 2 ). Unlike spin locks (which give the lock to the next waiting process),
                          sleep/wakeup locks can use the processor scheduler to enforce process priorities.

<!-- pág. 785 -->

                                                                                15.9 Multiprocessor Mutual Exclusion 731

Sleep/wakeup locks can cause waiting processes to be indefinitely postponed,
depending on the system's scheduling policy.
      Note that unlike a uniprocessor implementation, only the process with the high-
est priority is awakened. When all threads are awakened, a race condition can result
because two or more threads may access a resource associated with a lock in a nonde-
terministic order. Race conditions should be avoided because they can cause subtle
errors in applications and are difficult to debug. In uniprocessors, even if all processes
are alerted, there can be no race condition because only one process (the one with
highest priority in most scheduling algorithms) obtains control of the processor and
acquires the lock. In a multiprocessing environment, a broadcast could wake many
processes that are competing for the lock, creating a race condition. This would also
result in one process obtaining the lock and many processes testing, reblocking and
consequently going back to sleep, thus squandering processor time due to context
switching. This phenomenon is known as the thundering herd.197

Self Review
1. What are an advantage and a disadvantage of a sleep/wakeup lock compared to a spin
   lock?
2. How is the implementation of a sleep/wakeup lock different in a multiprocessor environ-
   ment than in a uniprocessor environment?
Ans: 1) A sleep/wakeup lock eliminates wasted processor cycles incurred by spinning. Also, a
sleep/wakeup lock ensures that the highest-priority waiting process obtains the lock next. A dis-
advantage is that reaction to the lock's availability is slower because the new acquirer must
awaken and obtain a processor. 2) In a multiprocessor environment, a releasing process awak-
ens only one waiting process, which prevents a thundering herd that would waste processor
cycles and flood communication channels. This is not a problem on uniprocessor systems.


15.9.3     Read/Write Locks
Enforcing mutually exclusive access to shared memory in a multiprocessor system
can degrade performance. Only writers need exclusive access to the resource,
whereas, in general, multiple readers can access the same memory location at once.
Therefore, many systems protect shared memory with a more versatile read/write
lock rather than a generic mutual exclusion lock.198 A read/write lock provides
mutual exclusion similar to that presented in the readers/writers problem of
Section 6.2.4. A read/write lock permits multiple reader processes (i.e., processes
that will not alter shared data) to enter their critical sections. Unlike the example in
Section 6.2.4, however, read/write locks require that a writer (i.e., a process that will
alter shared data) wait until there are no reader or writer processes in their critical
sections before entering its critical section.199
      To implement this locking approach efficiently, the mutual exclusion mecha-
nism must use shared memory. However, in environments in which memory is not
shared, such as NORMA systems, message passing must be used. We discuss such
techniques in Section 17.5, Mutual Exclusion in Distributed Systems.

<!-- pág. 786 -->

732 Multiprocessor Management

                                     Self Review
                                     1. In what situations are read/write locks more efficient than spin locks?
                                     2. A naive implementation of a read/write lock allows any reader to enter its critical section
                                        when no writer is in its critical section. How can this lead to indefinite postponement for
                                        writers? What is a fairer implementation?
                                    Ans: 1) Read/write locks are more efficient than spin locks when multiple processes read a
                                    memory location, but do not write to it. In this case, multiple processes can be in critical sec-
                                    tions at once. 2) This implementation leads to indefinite postponement if readers continually
                                    enter their critical sections before a writer can enter its critical section. A fairer implementa-
                                    tion would allow a reader to enter its critical section only if no writer is in or is waiting to
                                    enter its critical section as discussed in Section 6.2.4.



Web      Resources
www.winntmag.com/Articles/Index.cfm?Arti-                           www.teamten.com/lawrence/242.paper/242.paper.html
cleID=303&pg=l&show=495                                             This paper discusses mutual exclusion algorithms for multipro-
This article describes multiprocessor scheduling in Windows NT.     cessors.
www.aceshardware.com/Spades/read.php?article_id=                    users.win.be/W0005997/UNIX/LINUX/IL/atomicity-
30000187                                                            eng.html
This article describes how the AMD Athlon (with two processors)     This site explains how to use spin locks to implement mutual
implements cache coherence. It also discusses bus snooping.         exclusion in Linux.
www.mosix.org
This site provides information about MOSIX, a software bun-
dle used on UNIX systems, which implements automatic pro-
cess migration and load balancing.



Summary
Many applications demand substantially more computing               cessing unit. SIMD (single instruction stream, multiple data
power than one processor can provide. As a result, multi-           stream) computers, which include array and vector proces-
processing systems—computers that use more than one                 sors, execute instructions on multiple data items in parallel.
processor to meet a system's processing needs—are often             MIMD (multiple instruction stream, multiple data stream)
employed. The term "multiprocessing system" encom-                  computers have multiple processing units that operate
passes any system with more than one processor. This                independently on separate instruction streams.
includes dual-processor personal computers, powerful serv-                 The interconnection scheme of a multiprocessor sys-
ers that contain many processors and distributed groups of          tern describes how the system physically connects its com-
workstations that work together to perform tasks.                   ponents, such as processors and memory modules. The
       There are several ways to classify multiprocessors.          interconnection scheme affects the system's performance,
Flynn developed an early scheme for classifying computers           reliability and cost, so it is a key issue for multiprocessor
into increasingly parallel configurations based on the types        designers. A shared bus provides low cost and high perfor-
of streams used by processors. SISD (single instruction             mance for a small number of processors but does not scale
stream, single data stream) computers are traditional uni-          well, owing to contention on the bus as the number of pro-
processors that fetch one instruction at a time and execute         cessors increases. A crossbar-switch matrix provides high
it on a single data item. MISD (multiple instruction stream,        fault tolerance and performance but is inappropriate for
single data stream) computers (which are not commonly               small systems in which UMA (uniform memory access) is
used) have multiple processing units, each operating on a           more cost effective. A 2-D mesh network is a simple design
piece of data and then passing the result to the next pro-          that provides adequate performance and fault tolerance at

<!-- pág. 787 -->

                                                                                                          Summary          733
a low cost but that also does not scale well. A hypercube is      multiple processors. Systems that use page migration trans-
more scalable than a 2-D mesh network and provides bet-           fer pages to the processor that accesses the pages most.
ter performance, but at a higher cost. Multistage networks        These techniques can be combined to optimize perfor-
compromise between cost and performance and can be                mance.
used to build extremely large-scale multiprocessors.                     Shared virtual memory (SVM) provides the illusion
       In a tightly coupled system, the processors share most     of shared physical memory in large-scale multiprocessor
system resources. Loosely coupled systems connect compo-          systems. Invalidation (in which a writer voids other copies
nents indirectly through communication links and do not           of a page) and write broadcast (in which a writer notifies
share most resources. Loosely coupled systems are more scal-      other processors of updates to a page) are two approaches
able, flexible and fault tolerant but do not perform as well as   for implementing memory coherence in SVM systems.
tightly coupled systems. Loosely coupled systems also place       These protocols can be strictly applied, but this can be inef-
more burden on programmers, who must implement applica-           ficient. Relaxed consistency, in which the system might not
tions that communicate via IPC rather than shared memory.         be coherent for a few seconds, improves efficiency but sac-
       Multiprocessors can also be categorized based on           rifices some data integrity.
how the processors share operating system responsibilities.              Multiprocessor scheduling algorithms must deter-
In the master/slave organization, only the master processor       mine both when and where to dispatch a process. Some
can execute the operating system; the slaves execute only         algorithms maximize processor affinity (the relationship of
user programs. In the separate-kernels organization, each         a process to a particular processor and its local memory) by
processor executes its own operating system, and operating        executing related processes on the same processors. Others
system data structures maintain the system's global infor-        maximize parallelism by executing related processes on
mation. In the symmetrical organization, all processors can       separate processors simultaneously. Some systems use glo-
control any device and reference any storage unit. This           bal run queues, whereas others (typically large-scale sys-
organization enables systems to balance their workloads           tems) maintain per-processor or per-node run queues.
more precisely.                                                           Process migration is the act of transferring a process
       Multiprocessor systems use several architectures to        between two processors or computers. Process migration can
share memory. UMA multiprocessors require all processors          increase performance, resource sharing and fault tolerance.
to share all the system's main memory equally owing to            To migrate a process, nodes must transfer the process's state,
shared-memory contention; these systems are not scalable          which includes the process's memory pages, register con-
beyond a few processors. NUMA (nonuniform memory                  tents, state of open files and kernel context. Migration poli-
access) multiprocessors partition memory into modules,            cies that allow residual dependency (a process's dependency
assigning one to each processor as its local memory. COMA         on its former node) decrease fault tolerance and the pro-
(cache-only memory architecture) multiprocessors are simi-        cess's performance after migration. However, eliminating
lar to NUMA multiprocessors, but treat all memory as a            residual dependency makes initial migration slow. Various
large cache to increase the likelihood that requested data        migration policies balance the goals of minimal residual
resides in the requesting processor's local memory.               dependency and fast initial migration.
NORMA (no remote memory access) multiprocessors are                      Load balancing is a technique in which the system
loosely coupled and do not provide any globally shared            attempts to distribute processing responsibility equally
main memory. NORMA multiprocessors are used to build              among processors to increase processor utilization and
large-scale distributed systems.                                  decrease process response times. Static load balancing algo-
       Memory is coherent if the value obtained from reading      rithms assign a fixed number of processors to a job when the
a memory address is always the same as the value most             job is first scheduled. These algorithms are useful in envi-
recently written to that address. UMA cache-coherence pro-        ronments, such as scientific computing, where process inter-
tocols include bus snooping and directory-based coherence.        actions and execution times are predictable. Dynamic load
CC-NUMAs (cache-coherent NUMAs) often use a home-                 balancing algorithms change the number of processors
based approach in which a home node for each memory               assigned to a job throughout the job's life. These algorithms
address is responsible for keeping that data item coherent        are useful when process interactions are unpredictable, and
throughout the system.                                            when processes can be created and terminate at any time.
       Systems that use page replication maintain multiple               Many uniprocessor mutual exclusion mechanisms are
copies of a memory page so it can be accessed quickly by          either inefficient or ineffective for multiprocessors. Design-

<!-- pág. 788 -->

734 Multiprocessor Management
ers have developed mutual exclusion techniques specific to            With a sleep/wakeup lock, a process releasing the lock
multiprocessors. A spin lock is a mutual exclusion lock in            wakes up the highest-priority waiting process, which
which waiting processes spin (i.e., busy wait) for the lock.          acquires the lock. This reduces the use of processor cycles
This is appropriate when system load is low and spinning              typical in spin locks. Read/write locks allow one writer or
time is short relative to context-switch time. Spin locks             many readers to be in their critical sections at once.
reduce reaction time when resources become available.



Key Terms
2-D mesh network—Multiprocessor interconnection scheme                cache-coherent NUMA (CC-NUMA)—NUMA multiproces-
    that arranges nodes in an m x n rectangle.                            sor that maintains cache coherence, usually through a
4-connected 2-D mesh network—2-D mesh network in which                    home-based approach.
    nodes are connected with the nodes directly to the north,         cache miss latency—Extra time required to access data that
    south, east and west.                                                 does not reside in the cache.
acquire operation—In several coherence strategies, an opera-          cache-only memory architecture (COMA) multiprocessor -
    tion indicating that a process is about to access shared              Multiprocessor architecture in which nodes consist of a
    memory.                                                               processor, cache and memory module; main memory is
adaptive lock—Mutual exclusion lock that allows processes to              organized as a large cache.
    switch between using a spin lock or a blocking lock,              cache snooping—Bus snooping used to ensure cache coher-
    depending on the current condition of the system.                     ency.
advisable process lock (APL)—Locking mechanism in which               configurable lock—See adaptive lock
    an acquirer estimates how long it will hold the lock; other
                                                                      contention—In multiprocessing a situation in which several
    processes can use this estimate to determine whether to
                                                                          processors compete for the use of a shared resource.
    block or spin when waiting for the lock.
array processor—SIMD (single instruction stream, multiple             copy-on-reference migration—Process migration technique in
    data stream) system consisting of many (possibly tens of              which only a process's dirty pages are migrated with the
    thousands) simple processing units, each executing the                process, and the process can request clean pages either
    same instruction in parallel on many data elements.                   from the sending node or from secondary storage.

attraction memory (AM)—Main memory in a COMA (cache-                  cost of an interconnection scheme—Total number of links in a
     only memory architecture) multiprocessor, which is orga-              network.
     nized as a cache.                                                coscheduling—Job-aware process scheduling algorithm that
baseline network—Type of multistage network.                              attempts to execute processes from the same job concur-
                                                                          rently by placing them in adjacent global-run-queue loca-
bidding algorithm—Dynamic load balancing algorithm in
                                                                          tions.
    which processors with smaller loads "bid" for jobs on over-
    loaded processors; the bid value depends on the load of           crossbar-switch matrix—Processor interconnection scheme
    the bidding processor and the distance between the under-              that maintains a separate path from every sender node to
    loaded and overloaded processors.                                      every receiver node.
bisection width—Minimum number of links that need to be               degree of a node—Number of other nodes with which a node
     severed to divide a network into two unconnected halves.             is directly connected.
bus snooping—Coherence protocol in which processors                   delayed blocking—Technique whereby a process spins on a
    "snoop" the shared bus to determine whether a requested               lock for a fixed amount of time before it blocks; the ratio-
    write is to a data item in that processor's cache or, if appli-       nale is that if the process does not obtain the lock quickly,
    cable, local memory.                                                  it will probably have to wait a long time, so it should
cache coherence—Property of a system in which any data item               block.
    read from a cache has the value equal to the last write to        delayed consistency—Memory coherence strategy in which
    that data item.                                                       processors send update information after a release, but a

<!-- pág. 789 -->

                                                                                                           Key      Terms     735
    receiving node does not apply this information until it            node forwards update information to other nodes that
    performs an acquire operation on the memory.                       subsequently access the page.
dirty eager migration—Process migration method in which            home node—Node that is the "home" for a physical memory
     only a process's dirty pages are migrated with the process;      address or page and is responsible for maintaining the
     clean pages must be accessed from secondary storage.             data's coherence.
drafting algorithm—Dynamic load balancing algorithm that           hypercube—Multiprocessor interconnection scheme that con-
     classifies each processor's load as low, normal or high;          sists of 2n nodes (where n is an integer); each node is
     each processor maintains a table of the other processors'         linked with n neighbor nodes.
     loads, and the system uses a receiver-initiated policy to     interconnection scheme—Design that describes how a multi-
     exchange processes.                                                processor system physically connects its components, such
dynamic load balancing—Technique that attempts to distrib-              as processors and memory modules.
    ute processing responsibility equally by changing the          invalidation—Memory-coherence protocol in which a process
    number of processors assigned to a job throughout the              first invalidates—i.e., voids—all other copies of a page
    job's life.                                                         before writing to the page.
dynamic partitioning—Job-aware process scheduling algo-            job-aware scheduling—Multiprocessor scheduling algorithms
    rithm that divides processors in the system evenly among            that account for job properties when making scheduling
    jobs, except that no single job can be allocated more pro-          decisions; these algorithms typically attempt to maximize
    cessors than runnable processes; this algorithm maximizes           parallelism or processor affinity.
    processor affinity.                                            job-blind scheduling—Multiprocessor scheduling algorithms
eager migration—Process migration strategy that transfers the           that ignore job properties when making scheduling deci-
    entire address space of a process during the initial phases         sions; these algorithms are typically simple to implement.
    of migration to eliminate a migrated process's residual        lazy copying—Process migration strategy that transfers pages
    dependencies on its original node.                                  from the sender only when the process at the receiving
false sharing—Situation that occurs when processes on sepa-             node references these pages.
     rate processors are forced to share a page because they       lazy data propagation—Technique in which writing processors
     are each accessing a data item on that page, although not          send coherence information after a release, but not the
     the same data item.                                                data; a processor retrieves the data when it accesses a
first-come-first-served (FCFS) process scheduling—Job-blind             page that it knows is not coherent.
     multiprocessor scheduling algorithm that places arriving      lazy migration—Process migration strategy in multiprocessor
     processes in a queue; the process at the head of the queue         systems that does not transfer all pages during initial
     executes until it freely relinquishes the processor.               migration. This increases residual dependency but reduces
flushing—Process migration strategy in which the sending                initial migration time.
     node writes all of the process's memory pages to a shared     lazy release consistency—Memory-coherence strategy in
     disk at the start of migration; the process then accesses         which a processor does not send coherence information
     the pages from the shared disk as needed on the receiving         after writing to a page until a new processor attempts an
     node.                                                             acquire operation on that memory page.
gang scheduling—Another name for coscheduling.                     load balancing—Technique which attempts to distribute the
global run queue—Process scheduling queue used in some                 system's processing responsibility equally among proces-
    multiprocessor scheduling algorithms, which is indepen-            sors.
    dent of the processors in a system and into which every        loosely coupled system—System in which processors do not
    process or job in the system is placed.                             share most resources; these systems are flexible and fault
hard affinity—Type of processor affinity in which the schedul-          tolerant but perform worse than tightly coupled systems.
    ing algorithm guarantees that a process only executes on a     massively parallel processor—Processor that performs a large
    single node throughout its life cycle.                             number of instructions on large data sets at once; array
home-based consistency—Memory-coherence strategy in                    processors are often called massively parallel processors.
   which processors send coherence information to a home           master/slave multiprocessor organization—Scheme for dele-
   node associated with the page being written; the home               gating operating system responsibilities in which only one

<!-- pág. 790 -->

736 Multiprocessor Management
    processor (the "master") can execute the operating sys-      page migration—Technique in which the system transfers
    tem, and the other processors (the "slaves") can execute         pages to the processor (or processors when used with
    only user processes.                                             page replication) that accesses the pages most.
memory coherence—State of a system in which the value            page replication—Technique in which the system maintains
   obtained from reading a memory address is always the              multiple copies of a page at different nodes so that it can
   same as the most-recently written value at that address.          be accessed quickly by multiple processors.
memory line—Entry in memory that stores one machine word         per-processor run queue—Process scheduling queue associ-
   of data, which is typically four or eight bytes.                  ated with a specific processor; processes entering the
                                                                     queue are scheduled on the associated processor indepen-
multiple-instruction-stream, multiple-data-stream (MIMD)
                                                                     dently of the scheduling decisions made in rest of the sys-
    computer—Computer architecture consisting of multiple
                                                                     tem.
    processing units, which execute independent instructions
    and manipulate independent data streams; this design         per-node run queue—Process scheduling queue associated
    describes multiprocessors.                                       with a group of processors; processes entering the queue
                                                                     are scheduled on the associated node's processors inde-
multiple-instruction-stream, single-data-stream (MISD) com-
                                                                     pendently of the scheduling decisions made in rest of the
    puter—Computer architecture consisting of several pro-
                                                                     system.
    cessing units, which execute independent instruction
    streams on a single stream of data; these architectures      precopy—Process migration strategy in which the sender
    have no commercial application.                                  begins transferring dirty pages before the original process
                                                                     is suspended; once the number of untransferred dirty
multiple shared bus architecture—Interconnection scheme              pages at the sender reaches some threshold, the process
    that employs several shared buses connecting processors          migrates.
    and memory. This reduces contention, but increases cost
    compared to a single shared bus.                             process migration—Transferring a process and its associated
                                                                     state between two processors.
multiprocessing system—Computing system that employs
    more than one processor.                                     processor affinity—Relationship of a process to a particular
                                                                     processor and a corresponding memory bank.
multistage network—Multiprocessor interconnection scheme
                                                                 race condition—Occurs when multiple threads simultaneously
    that uses switch nodes as hubs for communication
    between processor nodes that each have their own local           compete for the same serially reusable resource, and that
    memory.                                                          resource is allocated to these threads in an indeterminate
                                                                     order. This can cause subtle program errors when the
network diameter—Shortest path between the two most                  order in which threads access a resource is important.
    remote nodes in a system.
                                                                 random policy—Dynamic load balancing policy in which the
network link—Connection between two nodes.                           system arbitrarily chooses a processor to receive a
node—System component, such as a processor, memory mod-              migrated process.
    ule or switch, attached to a network; sometimes a group of   read/write lock—Lock that allows a single writer process or
    components might be viewed as a single node.                     multiple reading processes (i.e., processes that will not
nonuniform-memory-access (NUMA) multiprocessor—Multi-                alter shared variables) to enter a critical section.
    processor architecture in which each node consists of a      receiver-initiated policy—Dynamic load balancing policy in
    processor, cache and memory module. Access to a proces-           which processors with low utilization attempt to find over-
    sor's associated memory module (called local memory) is           loaded processors from which to receive a migrated pro-
    faster than access to other memory modules in the system.         cess.
no-remote-memory-access (NORMA) multiprocessor—Mul-              relaxed consistency—Category of memory-coherence strate-
    tiprocessor architecture that does not provide global             gies that permit the system to be in an incoherent state for
    shared memory. Each processor maintains its own local             a few seconds after a write, but improve performance over
    memory. NORMA multiprocessors implement a common                  strict consistency.
    shared virtual memory.                                       release consistency—Memory-coherence strategy in which
on-demand migration—Another name for lazy process migra-              multiple accesses to shared memory are considered a sin-
    tion.                                                             gle access; these accesses begin with an acquire and end

<!-- pág. 791 -->

                                                                                                             Key Terms 737
    with a release, after which coherence is enforced through-         fetches instructions from a single instruction stream and
    out the system.                                                    manipulates a single data stream; this architecture
release operation—In several coherence strategies, this opera-         describes traditional uniprocessors.
     tion indicates that a process is done accessing shared        sleep/wakeup lock—Mutual exclusion lock in which waiting
     memory.                                                            processes block, and a releasing process wakes the high-
residual dependency—Dependency of a migrated process on                 est-priority waiting process and gives it the lock.
     its original node after process migration because some of     smallest-number-of-processes-first (SNPF) scheduling—Job-
     the process's state remains on the original node.                 aware process scheduling algorithm, employing a global
                                                                       job-priority queue, where job priority is inversely propor-
round-robin job (RRJob) scheduling—Job-aware process
                                                                       tional to the number of processes in a job.
    scheduling algorithm employing a global run queue in
    which jobs are dispatched to processors in a round-robin       soft affinity—Type of processor affinity in which the schedul-
    fashion.                                                            ing algorithm tries, but does not guarantee, to schedule a
                                                                        process only on a single node throughout its life cycle.
round-robin process (RRprocess) scheduling—Job-blind mul-
    tiprocessor scheduling algorithm that places each process      space-partitioning scheduling—Multiprocessor scheduling strat-
    in a global run queue and schedules these process in a             egy that attempts to maximize processor affinity by sched-
    round-robin manner.                                                uling collaborative processes on a single processor (or
                                                                       single set of processors); the underlying assumption is that
sender-initiated policy—Dynamic load balancing policy in
                                                                       these processes will access the same shared data.
    which overloaded processors attempt to find underloaded
    processors to which to migrate a process.                      spin lock—Mutual exclusion lock in which a waiting process
                                                                       busy waits for the lock; this reduces the process's reaction
separate kernels multiprocessor organization—Scheme for
                                                                       time when the protected resource's becomes available.
    delegating operating system responsibilities in which each
    processor executes its own operating system, but the pro-      static load balancing—Category of load balancing algorithms
    cessors share some global system information.                       that assign a fixed number of processors to a job when it is
                                                                        first scheduled.
sequential consistency—Category of memory-coherence strat-
    egies in which coherence protocols are enforced immedi-        stream—Sequence of objects fed to the processor.
    ately after a write to a shared memory location.               switch—Node that routes messages between component
shared bus—Multiprocessor interconnection scheme that uses              nodes.
    a single communication path to connect all processors and      symmetric multiprocessor (SMP)—Multiprocessor system in
    memory modules.                                                   which processors share all resources equally, including
shared virtual memory (SVM)—An extension of virtual mem-              memory, I/O devices and processes.
    ory concepts to multiprocessor systems; SVM presents the       symmetrical multiprocessor organization—Scheme for dele-
    illusion of shared physical memory between processors             gating operating system responsibilities in which each
    and ensures coherence for pages accessed by separate              processor can execute the single operating system.
    processors.
                                                                   symmetric policy—Dynamic load balancing policy that com-
shortest-process-first (SPF) scheduling (multiprocessor)—Job-         bines the sender-initiated policy and the receiver-initiated
    blind multiprocessor scheduling algorithm, employing a            policy to provide maximum versatility to adapt to envi-
    global run queue, that selects the process with the smallest      ronmental conditions.
    processor time requirement to execute on an available
                                                                   thundering herd—Phenomenon that occurs when many pro-
    processor.
                                                                       cesses awaken when a resource becomes available; only
single-instruction-stream, multiple-data-stream (SIMD) com-            one process acquires the resource, and the others test the
     puter—Computer architecture consisting of one or more             lock's availability and reblock, wasting processor cycles.
     processing elements that execute instructions from a sin-
                                                                   tightly coupled system—System in which processors share
     gle instruction stream that act on multiple data items.
                                                                        most resources; these systems provide higher perfor-
single-instruction-stream, single-data-stream (SISD) com-               mance but are less fault tolerant and flexible than loosely
     puter—Computer architecture in which one processor                 coupled systems.

<!-- pág. 792 -->

738 Multiprocessor Management

timesharing scheduling—Multiprocessor scheduling technique                of main memory; in general, memory-access time is con-
     that attempts to maximize parallelism by scheduling collab-          stant, regardless of which processor requests data, except
    orative processes concurrently on different processors.               when the data is stored in a processor's cache.
undivided coscheduling algorithm—Job-aware process sched-            vector processor—Type of SIMD computer containing one
    uling algorithm in which processes of the same job are                processing unit that executes instructions that operate on
    placed in adjacent locations in the global run queue, and             multiple data items.
    processes are scheduled round-robin.                             write broadcast—Technique for maintaining memory coher-
uniform-memory-access (UMA) multiprocessor—Multipro-                      ence in which the processor that performs a write broad-
     cessor architecture that requires all processors to share all        casts the write throughout the system.


Exercises
15.1 A multiprocessor's interconnection scheme affects the                 a. COMA multiprocessor.
system's performance, cost and reliability.
                                                                           b. Page migration.
      a. Of the schemes presented in this chapter, which are
         best suited for small systems and which for large-                c. Page replication.
         scale systems?                                              15.5 For each of the following multiprocessor scheduling
      b. Why are some interconnection schemes good for               algorithms, use the classifications discussed early in this chap-
         small networks and others for large networks, but           ter to describe the type of multiprocessor system that would
         none are optimal for all networks?                          likely employ it. Justify your answers.
15.2 For each of the following multiprocessor organizations,               a. Job-blind multiprocessor scheduling
describe an environment in which the organization is useful;               b. Job-aware multiprocessor scheduling
also, list a drawback for each.
                                                                           c. Scheduling using per-processor or per-node run
      a. Master/slave multiprocessor organization
                                                                              queues
      b. Separate-kernels multiprocessor organization
                                                                     15.6 For each of the following system attributes, describe how
      c. Symmetrical organization
                                                                     process migration can increase it in a system and an inefficient
15.3 For each of the following environments, suggest whether         implementation reduce it.
the UMA, NUMA or NORMA memory-access architecture
                                                                           a. Performance
would be best and explain why.
      a. An environment consisting of a few interactive pro-               b. Fault tolerance
         cesses that communicate using shared memory                       c. Scalability
      b. Thousands of workstations performing a common               15.7 In our load balancing discussion, we described how pro-
         task                                                        cessors decide when and with whom to migrate a process.
      c. Large-scale multiprocessor containing 64 processors         However, we did not describe how processors decide which
         in a single machine                                         process to migrate. Suggest some factors that could help deter-
      d. Dual-processor personal computer                            mine which process to migrate. [Hint: Consider the benefits of
                                                                     process migration other than load balancing.]
15.4 As we described in the chapter, one important, but diffi-
cult, goal of a NUMA multiprocessor designer is maximizing           15.8 Can a process waiting for a spin lock be indefinitely
the number of page accesses that can be serviced by local            postponed even if all processes guarantee to leave their critical
memory. Describe the three strategies, COMA, page migra-             sections after a finite amount of time? A process waiting for a
tion and page replication, and discuss the advantages and dis-       sleep/wakeup lock? If you answered yes, suggest a way to pre-
advantages of each.                                                  vent indefinite postponement.

Suggested Projects
15.9 Prepare a research paper describing how the Linux               cache and memory coherency and the various mutual exclu-
operating system supports CC-NUMA multiprocessors.                   sion mechanisms provided by the operating system. Make sure
Describe Linux's scheduling algorithm, how Linux maintains           your research entails reading some source code.

<!-- pág. 793 -->

                                                                                                Recommended Reading 739
15.10 The cost and performance of different hardware devices         algorithm? For what type of environment is each intended?
are changing at different rates. For example, hardware contin-       Are most algorithms static or dynamic?
ues to get cheaper, and processor speed is increasing faster         15.12 Prepare a research paper describing how operating sys-
than bus speed. Write a research paper describing the trends in      tems implement memory coherence. Include a precise descrip-
interconnection schemes. Which schemes are becoming more             tion of the coherence protocol and when it is applied for at
popular? Which less popular? Why?                                    least one real operating system.
15.11 Prepare a research paper surveying the load balancing
algorithms in use today. What are the motivations behind each

Suggested Simulations
15.13 Use Java threads to simulate a multiprocessor, with each       ify when it requires access to a shared memory location and to
thread representing one processor. Be sure to synchronize            which location.
access to global (i.e., shared) variables. Implement shared          15.14 Expand your simulation. Implement per-processor run
memory as an array with memory addresses as subscripts.              queues and a load balancing algorithm. Maintain a data struc-
Define an object class called Process. Randomly create Pro-          ture for a processor's local memory, and implement a function
cess objects and implement a scheduling algorithm for them.          in the Process object to randomly add memory locations to
A Process object should describe how long it runs before             the local memory. Be sure to migrate this local memory when
blocking each time, and when it terminates. It should also spec-     migrating a Process.



Recommended Reading
Flynn and Rudd provide a synopsis of parallel and sequential         non's "The Performance of Multiprogrammed Multiprocessor
architecture classifications in their 1996 paper "Parallel Archi-    Scheduling Policies,"204 and more recently, Bunt et al's "Sched-
tectures."200 Crawley, in his paper "An Analysis of MIMD Pro-        uling in Multiprogrammed Parallel Systems."205 Lai and
cessor Interconnection Networks for Nanoelectronic Systems,"         Hudak discuss "Memory Coherence in Shared Virtual Mem-
surveys processor interconnection schemes.201                        ory Systems."206 Iftode and Singh survey different implemen-
       As multiprocessing systems have become more main-             tation strategies for maintaining memory coherence in
stream, much research has been devoted to optimizing their           "Shared Virtual Memory: Progress and Challenges."207 A com-
performance. Mukherjee et al. present a survey of multipro-          prehensive survey, "Process Migration," has been published by
cessor operating system concepts and systems in "A Survey of         Milojicic et al.,208 and the corresponding problem of load bal-
Multiprocessor Operating Systems."202 More recently Tripathi         ancing has been treated thoroughly by Langendorfer and Petri
and Karnik, in their paper "Trends in Multiprocessor and Dis-        in "Load Balancing and Fault Tolerance in Workstation Clus-
tributed Operating System Designs," summarize many impor-            ters: Migrating Groups of Processes."209 The bibliography for
tant topics such as scheduling, memory access and locks.203          this chapter is located on our Web site at www.deitel.com/
       For more information regarding scheduling algorithms          books/os3e/Bibliography.pdf.
in multiprogrammed environments, see Leutenegger and Ver-



Works Cited
 1. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-    4. Mitchell, R., "The Genius: Meet Seymour Cray, Father of the
    processor Operating Systems," GIT-CC-92/05, November 5,              Supercomputer," BusinessWeek, April 30, 1990, <www.business-
    1993, p. 1.                                                          week.com/1989-94/pre88/b31571.htm>.
 2. Mitchell, R., "The Genius: Meet Seymour Cray, Father of the       5. Breckenridge, C, "Tribute to Seymour Cray," November 19,
    Supercomputer," BusinessWeek, April 30,1990, <www.business-          1996, <www.egl.ucsf.edu/home/tef/cray/tribute.html>.
    week.com/1989-94/pre88/b31571.htm>.                               6. Mitchell, R., "The Genius: Meet Seymour Cray, Father of the
 3. Breckenridge, C, "Tribute to Seymour Cray," November 19,             Supercomputer," BusinessWeek, April 30,1990, <www.business-
    1996,<www.egl.ucsf.edu/home/tef/cray/tribute.html>.                  week.com/1989-94/pre88/b31571.htrn>.

<!-- pág. 794 -->

740    Multiprocessor Management
 7. Breckenridge, C, "Tribute to Seymour Cray," November 19,           28. Mitchell, R., "The Genius: Meet Seymour Cray, Father of the
    1996, <www.cgl.ucsf.edu/home/tef/cray/tribute.html>.                   Supercomputer," BusinessWeek, April 30,1990, <www.business-
 8. Mitchell, R., "The Genius: Meet Seymour Cray, Father of the            week.com/1989-94/pre88/b31571.htm>.
    Supercomputer," BusinessWeek, April 30,1990, <www.business-        29. Allison, D., "Interview with Seymour Cray," May 9,1995, <amer-
    week.com/1989-94/pre88/b31571.htm>.                                    icanhistory.si.edu/csr/comphist/cray.htm>.
 9. Top500, "TOP500 Supercomputer Sites: TOP500 List 06-2003,"         30. Breckenridge, C, "Tribute to Seymour Cray," November 19.
    June 2003, <www.top500.org/list/2003/06/?page>.                        1996,<www.cgl.ucsf.edu/home/tef/cray/tribute.html>.
1o. van der Steen, A., "TOP500 Supercomputer Sites: Intel Itanium      31. Mitchell, R., "The Genius: Meet Seymour Cray, Father of the
    2," <www.top500.org/ORSC/2002/itaniurn.html>.                          Supercomputer," BusinessWeek, April 30,1990, <www.business-
                                                                           week.com/1989-94/pre88/b31571.htrn>.
I I . Habata, S.; M. Yokokawa; and S. Kitawaki, "The Earth Simulator
      System," NEC Research and Development, January 2003,             32. Allison, D., "Interview with Seymour Cray," May 9,1995, <amer-
      <www.nec.co.jp/techrep/en/r_and_d/r03/r03-nol/                       icanhistory.si.edu/csr/comphist/cray.htm>.
      rd06.pdf >.                                                      33. Breckenridge, C, "Tribute to Seymour Cray," November 19.
12. JAMSTEC, "Earth Simulator Hardware,"              <www.es.jam-         1996,<www.cgl.ucsf.edu/home/tef/cray/tribute.html>.
    stec.go.jp/esc/eng/ES/hardware.html>.                              34. Mitchell, R., "The Genius: Meet Seymour Cray, Father of the
                                                                           Supercomputer," BusinessWeek, April 30,1990, <www.business-
13. Habata, S.; M. Yokokawa; and S. Kitawaki, "The Earth Simulator
                                                                           week.com/1989-94/pre88/b31571.htrn>.
    System," NEC Research and Development, January 2003,
    <www.nec.co.jp/techrep/en/r_and_d/r03/r03-nol/                     35. Allison, D., "Interview with Seymour Cray," May 9,1995, <amer-
    rd06.pdf >.                                                            icanhistory.si.edu/csr/comphist/cray.htm>.
14. JAMSTEC, "Earth Simulator Hardware,"              <www.es.jam-     36. Mitchell, R., "The Genius: Meet Seymour Cray, Father of the
    stec.go.jp/esc/eng/ES/hardware.html>.                                  Supercomputer," BusinessWeek, April 30,1990, <www.business-
                                                                           week.com/1989-94/pre88/b31571.htm>.
15. JAMSTEC, "Earth Simulator Mission,"               <www.es.jam-
    stec.go.jp/esc/eng/ESC/mission.html>.                              37. Mitchell, R., "The Genius: Meet Seymour Cray, Father of the
                                                                           Supercomputer," BusinessWeek, April 30,1990, <www.business-
16. "TOP500 Supercomputer Sites," June 1, 2003, <top500.org/               week.com/1989-94/pre88/b31571.htrn>.
    lists/2003/06/l/>.
                                                                       38. Cray Incorporated, "Historic Cray Systems," <www.cray.com/
17. "Our Mission and Basic Principles," The Earth Simulator Center,        company/h_systems.html>.
    October 17, 2003, <www.es.jamstec.go.jp/esc/eng/ESC/mis-
                                                                       39. Cray Incorporated, "Historic Cray Systems," <www.cray.com,
    sion.html>.
                                                                           company/h_systems.html>.
18. Allison, D., "Interview with Seymour Cray," May 9,1995, <amer-
                                                                       40. Allison, D., "Interview with Seymour Cray," May 9,1995, <amer-
    icanhistory.si.edu/csr/comphist/cray.htm>.
                                                                           icanhistory.si.edu/csr/comphist/cray.htm>.
19. Breckenridge, C, "Tribute to Seymour Cray," November 19,           41. Flynn, M., "Very High-Speed Computing Systems," Proceedings
    1996, <www.cgl.ucsf.edu/home/tef/cray/tribute.html>.                   of the IEEE, Vol. 54, December 1966, pp. 1901-1909.
20. Allison, D., "Interview with Seymour Cray," May 9,1995, <amer-     42. Flynn, M., and K. Rudd, "Parallel Architectures," ACM Compiti-
    icanhistory.si.edu/csr/comphist/cray.htm>.                            ■ ing Surveys, Vol. 28, No. 1, March 1996, p. 67.
21. Mitchell, R., "The Genius: Meet Seymour Cray, Father of the        43. "Accelerating Digital Multimedia Production with Hyper-
    Supercomputer," BusinessWeek, April 30,1990, <www.business-            Threading Technology," January 15, 2003.               <http://
    week.com/1989-94/pre88/b31571.htrn>.                                   cedar.intel.com/cgi-bin/ids.dll/content/con¬
22. Breckenridge, C, "Tribute to Seymour Cray," November 19,               tent.jsp?cntKey=Ceneric+Edito¬
    1996,<www.cgl.ucsf.edu/home/tef/cray/tribute.html>.                    ri al%3a%3ahyperthreading_digitaljiultimedia&cntType=I
23. Allison, D., "Interview with Seymour Cray," May 9,1995, <amer-         DS_EDIT0RIAL&catCode=CDN&path=5>.
    icanhistory.si.edu/csr/comphist/cray.htm>.                         44. Flynn, M., and K. Rudd, "Parallel Architectures," ACM Comput­
                                                                           ing Surveys, Vol. 28, No. 1, March 1996, p. 69.
24. Breckenridge, C, "Tribute to Seymour Cray," November 19,
    1996,<www.cgl.ucsf.edu/home/tef/cray/tribute.html >.               45. Zhou, X, and K. Ross, "Research Sessions: Implementation Tech-
                                                                           niques: Implementing Database Operations Using SIMD
25. Mitchell, R., "The Genius: Meet Seymour Cray, Father of the
                                                                           Instructions," Proceedings of the 2002 ACM SIGMOD Interna­
    Supercomputer," BusinessWeek, April 30,1990, <www.business-
                                                                           tional Conference on Management of Data, June 2002, p. 145.
    week.com/1989-94/pre88/b31571.htrn>.
                                                                       46. Flynn, M., and K. Rudd, "Parallel Architectures," ACM Comput­
26. Allison, D., "Interview with Seymour Cray," May 9,1995, <amer-         ing Surveys, Vol. 28, No. 1, March 1996, pp. 68-69.
    icanhistory.si.edu/csr/comphist/cray.htm>.
                                                                       47. Hennessy, X, and D. Patterson, Computer Organization and
27. Breckenridge, C, "Tribute to Seymour Cray," November 19,               Design, San Francisco, CA: Morgan Kaufmann, 1998, pp. 751-
    1996, <www.cgl.ucsf.edu/home/tef/cray/tribute.html>.                   752.

<!-- pág. 795 -->

                                                                                                                  Works Cited 741
48. Flynn, M., and K. Rudd, "Parallel Architectures," ACM Comput­     66. Seitz, C, "The Cosmic Cube," Communications of the ACM, Vol.
    ing Survey s,Vol. 28, No. 1, March 1996, p. 68.                       28, No. 1, January 1985, pp. 22-33.
49. Gelenbe E., "Performance Analysis of the Connection Machine,"     67. Padmanabhan, K., "Cube Structures for Multiprocessors," Com­
    Proceedings of the 1990 ACM SIGMETRICS Conference on                  munications of the ACM, Vol. 33, No. 1, January 1990, pp. 43-52.
    Measurement and Modeling of Computer Systems, Vol. 18, No. 1,
                                                                      68. Hennessy, J, and D. Patterson, Computer Organization and
    April 1990, pp. 183-191.
                                                                          Design, San Francisco, CA: Morgan Kaufmann, 1998, p. 738.
50. Flynn, M., and K. Rudd, "Parallel Architectures," ACM Comput­
                                                                      69. Crawley, D., "An Analysis of MIMD Processor Interconnection
    ing Surveys, Vol. 28, No. 1, March 1996, p. 69.
                                                                          Networks for Nanoelectronic Systems," UCL Image Processing
51. Crawley, D., "An Analysis of MIMD Processor Interconnection           Group Report 98/3,1998, p. 10.
    Networks for Nanoelectronic Systems," UCL Image Processing
                                                                      70. "The nCUBE 2s," Top 500 Supercomputer Sites, February 16,
    Group Report 98/3,1998, p. 3.
                                                                          1998 <www.top500.org/0RSC/1998/ncube.html>.
52. Crawley, D., "An Analysis of MIMD Processor Interconnection
                                                                      71. Bhuyan, L.; Q. Yang; and D. Agrawal, "Performance of Multipro-
    Networks for Nanoelectronic Systems," UCL Image Processing
                                                                          cessor Interconnection Networks," Computer, Vol. 20, No. 4,
    Group Report 98/3,1998, p. 3.
                                                                          April 1987, pp. 50-60.
53. Bhuyan, L.; Q. Yang; and D. Agrawal, "Performance of Multipro-
    cessor Interconnection Networks," Computer, Vol. 20, No. 4,       72. Crawley, D., "An Analysis of MIMD Processor Interconnection
    April 1987, pp. 50-60.                                                Networks for Nanoelectronic Systems," UCL Image Processing
                                                                          Group Report 98/3,1998, p. 15.
54. Rettberg, R., and R. Thomas, "Contention is No Obstacle to
    Shared-Memory Multiprocessors," Communications of the ACM,        73. "Using ASCI White," October 7, 2002,      <www.llnl.gov/asci/
    Vol. 29, No. 12, December 1986, pp. 1202-1212.                        piatforms/white/>.

55. Crawley, D., "An Analysis of MIMD Processor Interconnection       74. "IBM SP Hardware/Software Overview," February 26, 2003,
    Networks for Nanoelectronic Systems," UCL Image Processing            <www.llnl.gov/computing/tutorials/ibmhwsw/#evolu-
    Group Report 98/3,1998, p. 12.                                        tion>.

56. Hennessy, J., and D. Patterson, Computer Organization and         75. Skillicorn, D., "A Taxonomy for Computer Architectures," Com­
    Design, San Francisco, CA: Morgan Kaufmann, 1998, p. 718.             puter, Vol. 21, No. 11, November 1988, pp. 46-57.
57. Crawley, D., "An Analysis of MIMD Processor Interconnection       76. McKinley, D., "Loosely-Coupled Multiprocessing: Scalable,
    Networks for Nanoelectronic Systems," UCL Image Processing            Available, Flexible, and Economical Computing Power," RTC
    Group Report 98/3,1998, p. 12.                                        Europe, May 2001, pp. 22-24, <www.rtceuropeonline.com/
                                                                          may2001/specialreport.pdf>.
58. Qin, X., and J. Baer, "A Performance Evaluation of Cluster
    Architectures," Proceedings of the 1997 ACM SIGMETRICS            77. McKinley, D., "Loosely-Coupled Multiprocessing: Scalable,
    International Conference on Measuring and Modeling of Com­            Available, Flexible, and Economical Computing Power," RTC
    puter Systems, 1997, p. 237.                                          Europe, May 2001, pp. 22-24, <www.rtceuropeonline.com/
                                                                          may2001/specialreport.pdf>.
59. Friedman, M., "Multiprocessor Scalability in Microsoft Windows
    NT/2000," Proceedings of the 26th Annual International Measure­   78. Enslow, P., "Multiprocessor Organization—A Survey," Comput­
    ment Group Conference, December 2000, pp. 645-656.                    ing Surveys, Vol. 9, No. 1, March 1977, pp. 103-129.
60. Enslow, P., "Multiprocessor Organization—A Survey," ACM           79. Van Lang.T, "Strictly On-Line: Parallel Algorithms for Calculat-
    Computing Surveys, Vol. 9, No. 1, March 1977, pp. 103-129.            ing Underground Water Quality," Linux Journal, No. 63, July 1,
61. Bhuyan, L.; Q. Yang; and D. Agrawal, "Performance of Multipro-        1999, <www.linuxjournal.com/article.php?sid=3021>.
    cessor Interconnection Networks," Computer, Vol. 20, No. 4,       80. Enslow, P., "Multiprocessor Organization—A Survey," Comput­
    April 1987, pp. 50-60.                                                ing Surveys, Vol. 9, No. 1, March 1977, pp. 103-129.
62. Stenstrom, P., "Reducing Contention in Shared-Memory Multi-       81. Bartlett, J., "A NonStop Kernel," Proceedings of the Eighth Sym­
    processors," Computer, Vol. 21, No. 11 November 1988, pp. 26-         posium on Operating System Principles, December 1981, pp. 22-
    37.                                                                   29.
63. Crawley, D., "An Analysis of MIMD Processor Interconnection       82. Enslow, P., "Multiprocessor Organization—A Survey," Comput­
    Networks for Nanoelectronic Systems," UCL Image Processing            ing Surveys, Vol. 9, No. 1, March 1977, pp. 103-129.
    Group Report 98/3,1998, p. 19.
                                                                      83. Wilson, A., "More Power to You: Symmetrical Multiprocessing
64. "UltraSPARC-Ill,"  <www.sun.com/processors/UltraSPARC-                Gives Large-Scale Computer Power at a Lower Cost with Higher
    III/USIIITech.htm1>.                                                  Availability," Datamation, June 1980, pp. 216-223.
65. Crawley, D., "An Analysis of MIMD Processor Interconnection       84. Rettberg, R., and R. Thomas, "Contention is No Obstacle to
    Networks for Nanoelectronic Systems," UCL Image Processing            Shared-Memory Multiprocessors," Communications of the ACM,
    Group Report 98/3,1998, p. 8.                                         Vol. 29, No. 12, December 1986, pp. 1202-1212.

<!-- pág. 796 -->

742    Multiprocessor Management

85. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-      102. Soundararajan, V., et al., "Flexible Use of Memory for Replica-
    processor Operating Systems," GIT-CC-92/05, November 5,                  tion/Migration in Cache-Coherent DSM Multiprocessors," Pro-
    1993, p. 2.                                                              ceedings of the 25th Annual Symposium on Computer
86. Tripathi, A., and N. Karnik, "Trends in Multiprocessor and Dis-          Architecture, June 1998, p. 342.
    tributed Operating System Design," Journal of Supercomputing,       103. Lai, A. and B. Falsafi, "Comparing the Effectiveness of Fine-
    Vol. 9, No. 1/2,1995, p. 4.                                              Grain Memory Caching against Page Migration/Replication in
87. Mukherjee, R; K. Schwan; and P. Gopinath, "A Survey of Multi-            Reducing Traffic in DSM Clusters," ACM Symposium on Parallel
    processor Operating Systems," GIT-CC-92/05, November 5,                  Algorithms and Architecture, 2000, p. 79.
    1993, p. 2.
                                                                        104. Soundararajan, V., et al., "Flexible Use of Memory for Replica-
88. Mukherjee, R; K. Schwan; and P. Gopinath, "A Survey of Multi-            tion/Migration in Cache-Coherent DSM Multiprocessors," Pro-
    processor Operating Systems," GIT-CC-92/05, November 5,                  ceedings of the 25th Annual Symposium on Computer
    1993, pp. 2-3.                                                           Architecture, June 1998, p. 342.
89. Tripathi, A., and N Karnik, "Trends in Multiprocessor and Dis-
                                                                        105. Baral, Y; M. Carikar; and P. Indyk, "On Page Migration and
    tributed Operating System Design," Journal of Supercomputing,            Other Relaxed Task Systems," ACM Symposium on Discrete
    Vol. 9, No. 1/2,1995, p. 3.                                              Algorithms, 1997, p. 44.
90. Joe, T, and J. Hennessy, "Evaluating the Memory Overhead
                                                                        106. Vergese, B., et al., "Operating System Support for Improving
    Required for COMA Architectures," Proceedings of the 21st
                                                                             Data Locality on CC-NUMA Computer Servers," Proceedings of
    Annual Symposium on Computer Architecture, April 1994, p. 82.
                                                                             the 7th International Conference on Architectural Support for
91. Stenstrom, P.; T. and Joe; A. Gupta, "Comparative Performance            Programming Languages and Operating Systems, October 1996.
    Evaluation of Cache-Coherent NUMA and COMA Architec-                     p. 281.
    tures," Proceedings of the 19th Annual Symposium on Computer
    Architecture, May 1992, p. 81.                                      107. Vergese, B., et al., "Operating System Support for Improving
                                                                             Data Locality on CC-NUMA Compute Servers," Proceedings of
92. Stenstrom, P.; T. Joe; and A. Gupta, "Comparative Performance
                                                                             the 7th International Conference on Architectural' Support for
    Evaluation of Cache-Coherent NUMA and COMA Architec-                     Programming Languages and Operating Systems, October 1996.
    tures," Proceedings of the 19th Annual Symposium on Computer             p. 281.
    Architecture, May 1992, p. 80.
                                                                        108. LaRowe, R.; C. Ellis; and L. Kaplan, "The Robustness of NUMA
93. Tripathi, A., and N. Karnik, "Trends in Multiprocessor and Dis-
                                                                             Memory Management," Proceedings of the 13th ACM Sympo­
    tributed Operating System Design," Journal of Supercomputing,
                                                                             sium on Operating System Principles, October 1991, pp. 137-138.
    Vol. 9, No. 1/2,1995, p. 20.
94. Mukherjee, R; K. Schwan; and P. Gopinath, "A Survey of Multi-       109. Lai, K., and P. Hudak, "Memory Coherence in Shared Virtual
    processor Operating Systems," GIT-CC-92/05, November 5,                  Memory Systems," ACM Transactions on Computer Systems, Vol.
    1993, pp. 2-3.                                                           7, No. 4, November 1989, pp. 326-327.
95. Barroso, L.A.; J. Dean; and U. Hoelzle, "Web Search for a Planet:   n o . Lai, K., and P. Hudak, "Memory Coherence in Shared Virtual
    The Google Cluster Architecture," IEEE MICRO, March-April                 Memory Systems," ACM Transactions on Computer Systems, Vol.
    2003, pp. 22-28.                                                          7, No. 4, November 1989, pp. 327-328.
96. Tripathi, A., and N. Karnik, "Trends in Multiprocessor and Dis-     i n . Tripathi, A., and N. Karnik, "Trends in Multiprocessor and Dis-
    tributed Operating System Design," Journal of Supercomputing,             tributed Operating System Design," Journal of Supercomputing.
    Vol. 9, No. 1/2,1995, p. 3.                                               Vol. 9, No. 1/2,1995, p. 21.
97. Tanenbaum, A., and R. Renesse, "Distributed Operating Sys-          112. Iftode, L., and J. Singh, "Shared Virtual Memory: Progress and
    tems," Computing Surveys, Vol. 17, No. 4, December 1985, p. 420.         Challenges," Proceedings of the IEEE Special Issue on Distributed
98. Lai, K., and P. Hudak, "Memory Coherence in Shared Virtual               Shared Memory, Vol. 87, No. 3, March 1999, p. 498.
    Memory Systems," ACM Transactions on Computer Systems, Vol.         113. Iftode, L., and J. Singh, "Shared Virtual Memory: Progress and
    7, No. 4, November 1989, p. 325.                                         Challenges," Proceedings of the IEEE Special Issue on Distributed
99. Lai, K., and P. Hudak, "Memory Coherence in Shared Virtual               Shared Memory, Vol. 87, No. 3, March 1999, p. 499.
    Memory Systems," A CM Transactions on Computer Systems, Vol.        114. Gharacharloo, K., et al., "Memory Consistency and Event Order-
    7, No. 4, November 1989, p. 325.                                         ing in Scalable Shared-Memory Multiprocessors," Proceedings of
100. "Cache Coherence," Webopedia.com,        <www.webopedia.com/            the 17th Annual Symposium on Computer Architecture, May
     TERM/C/cache_coherence.html>.                                           1990, pp. 17-19.
101. Stenstrom, P.; T. Joe; and A. Gupta, "Comparative Performance      115. Carter, J; J. Bennett; and J. Zwaenepoel, "Implementation and
     Evaluation of Cache-Coherent NUMA and COMA Architec-                    Performance of Munin," Proceedings of the 13th ACM Symposium
     tures," Proceedings of the 19th Annual Symposium on Computer            on Operating System Principles, 1991, pp. 153-154.
     Architecture, May 1992, p. 81.

<!-- pág. 797 -->

                                                                                                                     Works      Cited     743
n 6 . Iftode, L., and J. Singh, "Shared Virtual Memory: Progress and         of the ACM Conference on Measurement and Modeling of Com­
      Challenges," Proceedings of the IEEE Special Issue on Distrib­         puter Systems, 1990, p. 227.
      uted Shared Memory,\o\. 87, No. 3, March 1999, pp. 499-500.        133. Leutenegger, S. T., and M. K. Vernon, "The Performance of Mul-
117. Dudnicki, C, et al., "Improving Release-Consistent Shared Vir-           tiprogrammed Multiprocessor Scheduling Policies," Proceedings
     tual Memory Using Automatic Update," Proceedings of the Sec­             of the ACM Conference on Measurement and Modeling of Com­
     ond IEEE Symposium            on    High-Performance Computer            puter Systems, 1990, p. 227.
     Architecture, February 1996, p. 18.                                 134. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
118. "Delayed Consistency and Its Effects on the Miss Rate of Paral-          processor Operating Systems," GIT-CC-92/05, November 5,
     lel Programs," Proceedings of Supercomputing '91,1991, pp. 197-          1993, p. 17.
     206.                                                                135. Tripathi, A., and N. M. Karnik, "Trends in Multiprocessor and
                                                                              Distributed Operating System Design," Journal of Supercomput-
119. Iftode, L,. and J. Singh, "Shared Virtual Memory: Progress and
                                                                              ing, Vol. 9, No. 1/2,1995, p. 16.
     Challenges," Proceedings of the IEEE Special Issue on Distributed
     Shared Memory,Vol. 87, No. 3, March 1999, p. 500.                   136. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
                                                                              processor Operating Systems," GIT-CC-92/05, November 5,
120. Tripath, A., and N. M. Karnik, "Trends in Multiprocessor and             1993, p. 15.
     Distributed Operating System Designs," Journal of Supercom-
                                                                         137. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
     puting, Vol. 9, No. 1/2,1995, p. 14.
                                                                              processor Operating Systems," GIT-CC-92/05, November 5,
121. Tripath, A., and N. M. Karnik, "Trends in Multiprocessor and             1993, p. 16.
     Distributed Operating System Designs," Journal of Supercom-
                                                                         138. Gupta, A., and A. Tucker, "Process Control and Scheduling
     puting,Vo\. 9, No. 1/2,1995, p. 14.
                                                                              Issues for Multiprogrammed Shared-Memory Multiprocessors,"
122. Tripath, A., and N. M. Karnik, "Trends in Multiprocessor and             Proceedings of the 12th ACM Symposium on Operating System
     Distributed Operating System Designs," Journal of Supercom-              Principles, 1989, p. 165.
     puting,Vol. 9, No. 1/2,1995, p. 14.                                 139. Leutenegger, S. T, and M. K. Vernon, "The Performance of Mul-
123. Tannenbaum, A. S., and R. V. Renesse, "Distributed Operating             tiprogrammed Multiprocessor Scheduling Policies," Proceedings
     Systems," ACM Computing Surveys, Vol. 17, No. 4, December                of the ACM Conference on Measurement and Modeling of Com­
     1985, p. 436.                                                            puter Systems, 1990, pp. 227-228.
124. Bunt, R. B.; D. T. Eager; and S. Majumdar, "Scheduling in Multi-    140. Carlson, B.; L. Dowdy; K. Dussa; and K-H. Park, "Dynamic Par-
     programmed Parallel Systems," ACM SIGMETRICS, 1988, p.                   titioning in a Transputer Environment," Proceedings of the ACM,
     106.                                                                     1990, p. 204.
125. BuntyR. B.; D. L. Eager; and S. Majumdar, "Scheduling in Multi-     141. Carlson, B.; L. Dowdy; K. Dussa; and K-H. Park, "Dynamic Par-
     programmed Parallel Systems," ACM SIGMETRICS, 1988, p.                   titioning in a Transputer Environment," Proceedings of the ACM,
     105.                                                                     1990, p. 204.
                                                                         142. Carlson, B.; L. Dowdy; K. Dussa; and K-H. Park, "Dynamic Par-
126. Bunt, R. B.; D. L. Eager; and S. Majumdar, "Scheduling in Multi-
                                                                              titioning in a Transputer Environment," Proceedings of the ACM,
     programmed Parallel Systems," ACM SIGMETRICS, 1998, p.
                                                                              1990, p. 204.
     106.
                                                                         143. Tripathi, A., and N. M. Karnik, "Trends in Multiprocessor and
127. Gopinath, P., et al., "A Survey of Multiprocessing Operating Sys-        Distributed Operating System Designs," Journal of Supercom-
     tems (Draft)," Georgia Institute of Technology, November 5,              puting,\o\. 9, No. 1/2,1995, p. 17
     1993, p. 15.
                                                                         144. Milojicic, D., et a l , "Process Migration," ACM Computing Sur-
128. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-           veys, Vol. 32, No. 3, September 2000, p. 241
     processor Operating Systems," GIT-CC-92/05, November 5,
     1993,1993, p. 15.                                                   145. Milojicic, D., et al., "Process Migration," ACM Computing Sur-
                                                                              veys, Vol. 32, No. 3, September 2000, p. 246
129. Bunt, R. B.; D. L. Eager; and S. Majumdar, "Scheduling in Multi-
     programmed Parallel Systems," ACM SIGMETRICS, 1998, p.              146. Langendorfer, H, and S. Petri, "Load Balancing and Fault Toler-
     106.                                                                     ance in Workstation Clusters: Migrating Groups of Processes,"
                                                                              Operating Systems Review, Vol. 29, No. 4, October 1995, p. 25
130. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
     processor Operating Systems," GIT-CC-92/05, November 5,             147. Milojicic, D., et al., "Process Migration," ACM Computing Sur­
     1993, p. 15.                                                             veys, Vol. 32, No. 3, September 2000, p. 246
131. Tripathi, A., and N. M. Karnik, "Trends in Multiprocessor and       148. Eskicioglu, M., "Design Issues of Process Migration Facilities in
     Distributed Operating System Design," Journal of Supercomput-            Distributed Systems," IEEE Computer Society Technical Commit­
     ing, Vol. 9, No. 1/2,1995, p. 16.                                        tee on Operating Systems Newsletter, Vol. 4, No. 2,1990, pp. 5-6.
132. Leutenegger, S. T, and M. K. Vernon, "The Performance of Mul-       149. Steketee, C; P. Socko; and B. Kiepuszewski, "Experiences with
     tiprogrammed Multiprocessor Scheduling Policies," Proceedings            the Implementation of a Process Migration Mechanism for

<!-- pág. 798 -->

744 Multiprocessor Management
     Amoeba," Proceedings of the 19th ACSC Conference, January-           168. Eskicioglu, M., "Design Issues of Process Migration Facilities in
     February 1996.                                                            Distributed Systems," IEEE Computer Society Technical Commit­
150. Eskicioglu, M., "Design Issues of Process Migration Facilities in         tee on Operating Systems Newsletter, Vol. 4, No. 2,1990, pp. 6-7.
     Distributed Systems," IEEE Computer Society Technical Com­           169. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
     mittee on Operating Systems Newsletter, Vol. 4, No. 2,1990, pp. 5-        processor Operating Systems," GIT-CC-92/05, November 5.
     6.                                                                        1993, p. 14.
151. Milojicic, D., et. al., "Process Migration," ACM Computing Sur­      170. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
     veys, Vol. 32, No. 3, September 2000, p. 255                              processor Operating Systems," GIT-CC-92/05, November 5,
152. Eskicioglu, M., "Design Issues of Process Migration Facilities in         1993, p. 14.
     Distributed Systems," IEEE Computer Society Technical Com­           171. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
     mittee on Operating Systems Newsletter, Vol. 4, No. 2,1990, p. 10.        processor Operating Systems," GIT-CC-92/05, November 5.
153. Milojicic, D., et al., "Process Migration," ACM Computing Sur­            1993, pp. 14-15.
     veys, Vol. 32, No. 3, September 2000, p. 256                         172. Diekmann, R.; B. Monien; and R. Preis, "Load Balancing Strate-
154. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-            gies for Distributed Memory Machines," World Scientific, 1997, p.
     processor Operating Systems," GIT-CC-92/05, November 5,                   3.
     1993, p. 21.                                                         173. Tannenbaum, A. S., and R. V. Renesse, "Distributed Operating
155. Steketee, C; P. Socko; and B. Kiepuszewski, "Experiences with             Systems," ACM Computing Surveys, Vol. 17, No. 4, December
     the Implementation of a Process Migration Mechanism for                   1985, p. 436.
     Amoeba," Proceedings of the 19th ACSC Conference, January-           174. Diekmann, R.; B. Monien; and R. Preis, "Load Balancing Strate-
     February 1996.                                                            gies for Distributed Memory Machines," World Scientific, 1997, p.
156. Milojicic, D., et al., "Process Migration," ACM Computing Sur­            5.
     veys, Vol. 32, No. 3, September 2000, p. 259                         175. Diekmann, R.; B. Monien; and R. Preis, "Load Balancing Strate-
157. Milojicic, D., et al., "Process Migration," ACM Computing Sur­            gies for Distributed Memory Machines," World Scientific, 1997, p.
     veys, Vol. 32, No. 3, September 2000, p. 256                              7.

158. Eskicioglu, M., "Design Issues of Process Migration Facilities in    176. Tannenbaum, A. S., and R. V. Renesse, "Distributed Operating
     Distributed Systems," IEEE Computer Society Technical Com­                Systems," ACM Computing Surveys, Vol. 17, No. 4, December
     mittee on Operating Systems Newsletter, Vol. 4, No. 2,1990, p. 6.         1985, p. 438.

159. Milojicic, D., et al., "Process Migration," ACM Computing Sur­       177. Milojicic, D, et al., "Process Migration," ACM Computing Sur­
     veys, Vol. 32, No. 3, September 2000, p. 256.                             veys, Vol. 32, No. 3, September 2000, p. 250.

160. Milojicic, D., et al., "Process Migration," ACM Computing Sur­       178. Milojicic, D., et al., "Process Migration," ACM Computing Sur-
     veys, Vol. 32, No. 3, September 2000, p. 256                              veys, Vol. 32, No. 3, September 2000, p. 251.

161. Eskicioglu, M., "Design Issues of Process Migration Facilities in    179. Shivarati, N; P. Kreuger; and M. Singhal, "Load Distributing for
     Distributed Systems," IEEE Computer Society Technical Com­                Locally Distributed Systems," IEEE Computer, 1992, pp. 37-39.
     mittee on Operating Systems Newsletter,\o\. 4, No. 2,1990, p. 7.     180. Milojicic, D., e. al., "Process Migration," ACM Computing Sur-
162. Douglis, E, and J. Ousterhout, "Transparent Process Migration:          ' veys, Vol. 32, No. 3, September 2000, p. 251.
     Design Alternatives and the Sprite Implementation," Software         181. Shivarati, N.; P. Kreuger; and M. Singhal, "Load Distributing for
     Practice and Experience, Vol. 21, No. 8, p. 764.                          Locally Distributed Systems," IEEE Computer, 1992, pp. 37-39.
163. Zayas, E., "Attacking the Process Migration Bottleneck," Pro­        182. Milojicic, D., et al., "Process Migration," ACM Computing Sur­
     ceedings of the Eleventh Annual ACM Symposium on Operating                veys, Vol. 32, No. 3, September 2000, p. 251.
     System Principles, 1987, pp. 13-24.                                  183. Shivarati, N; P. Kreuger; and M. Singhal, "Load Distributing for
164. Douglis, E, and J. Ousterhout, "Transparent Process Migration:            Locally Distributed Systems," IEEE Computer, 1992, pp. 37-39.
     Design Alternatives and the Sprite Implementation," Software         184. Milojicic, D., et al., "Process Migration," ACM Computing Sur-
     Practice and Experience,Vol. 21, No. 8, p. 764.                           veys, Vol. 32, No. 3, September 2000, p. 251.
165. Milojicic, D, et al., "Process Migration," ACM Computing Sur-
                                                                          185. Ahmad, I., and Y-K. Kwok, "Static Scheduling Algorithms for
     veys, Vol. 32, No. 3, September 2000, p. 256
                                                                               Allocating Directed Task Graphs to Multiprocessors," Communi­
166. Eskicioglu, M., "Design Issues of Process Migration Facilities in         cations of the ACM, 2000, p. 462.
     Distributed Systems," IEEE Computer Society Technical Com­
     mittee on Operating Systems Newsletter,Vo\. 4, No. 2,1990, p. 7.     186. Luling, R., et al., "A Study on Dynamic Load Balancing Algo-
                                                                               rithms," Proceedings of the IEEE SPDP, 1991, p. 686-689.
167. Dougli, E, and J. Ousterhout, "Transparent Process Migration:
     Design Alternatives and the Sprite Implementation," Software         187. Luling, R., et al., "A Study on Dynamic Load Balancing Algo-
     Practice and Experience, Vol. 21, No. 8, p. 764.                          rithms," Proceedings of the IEEE SPDP, 1991, p. 686-689.

<!-- pág. 799 -->

                                                                                                                     Works Cited 745
[88. Tannenbaum, A. S., and R. V. Renesse, "Distributed Operating        199- Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
     Systems," ACM Computing Surveys, Vol. 17, No. 4, December                processor Operating Systems," GIT-CC-92/05, November 5,
      1985, p. 438.                                                           1993, p. 25.
: S9. Tannenbaum, A. S., and R. V. Renesse, "Distributed Operating       200. Flynn, M., "Very High-Speed Computing Systems," Proceedings
      Systems," ACM Computing Surveys, Vol. 17, No. 4, December               of the IEEE,Vol. 54, December 1966, pp. 1901-1909.
      1985, p. 438.                                                      201. Crawley, D., "An Analysis of MIMD Processor Interconnection
190. Barak, A., and A. Shiloh, "A Distributed Load Balancing Policy           Networks for Nanoelectronic Systems," UCL Image Processing
     for a Multicomputer," Software Practice and Experience, Decem-           Group Report 98/3,1998, p. 3.
     ber 15,1985, pp. 901-913.                                           202. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-
191. Tripathi, A., and N. M. Karnik, "Trends in Multiprocessor and            processor Operating Systems," GIT-CC-92/05, November 5,
     Distributed Operating System Designs," Journal of Supercom-              1993, p. 1.
     puting,Vo\. 9, No 1/2,1995, p. 11.
                                                                         203. Tripathi, A., and N. Karnik, "Trends in Multiprocessor and Dis-
192. Mellor-Crummy, J. and M. Scott, "Algorithms for Scalable Syn-            tributed Operating System Design," Journal of Supercomputing,
     chronization on Shared-Memory Multiprocessors," ACM Trans­               Vol. 9, No. 1/2,1995, p. 3.
     actions on Computer Systems, Vol. 9, No. 1, February 1991, p. 22.   204. Leutenegger, S. T., and M. K. Vernon, "The Performance of Mul-
193. Mukherjee, B.; K. Schwan; and P. Gopinath, "A Survey of Multi-           tiprogrammed Multiprocessor Scheduling Policies," Proceedings
     processor Operating Systems," GIT-CC-92/05, November 5,                  of the ACM Conference on Measurement and Modeling of Com­
     1993, p. 24.                                                             puter Systems, 1990, p. 227.
194. Tripathi, A., and N M. Karnik, "Trends in Multiprocessor and        205. Bunt, R. B.; D. L. Eager; and S. Majumdar, "Scheduling in Multi-
     Distributed Operating System Designs," Journal of Supercom-              programmed Parallel Systems," ACM SIGMETRICS, 1988, p.
     puting,Vol 9, No 1/2,1995, pp. 11-12.                                    106.
195. Tripathi, A., and N. M. Karnik, "Trends in Multiprocessor and
                                                                         206. Lai, K., and P. Hudak, "Memory Coherence in Shared Virtual
     Distributed Operating System Designs," Journal of Supercom-
                                                                              Memory Systems," ACM Transactions on Computer Systems, Vol.
     puting, Vol. 9, No 1/2,1995, p. 12.
                                                                              7, No. 4, November 1989, p. 325.
196. Mukherjee, B., and K. Schwan, "Experiments with Configurable
     Locks for Multiprocessors," GIT-CC-93/05, January 10,1993.          207. Iftode, L., and J. Singh, "Shared Virtual Memory: Progress and
                                                                              Challenges," Proceedings of the IEEE Special Issue on Distributed
197. Tripathi, A., and N. M. Karnik, "Trends in Multiprocessor and
                                                                              Shared Memory, Vol. 87, No. 3, March 1999, p. 498.
     Distributed Operating System Designs," Journal of Supercom-
     puting, Vol. 9, No 1/2,1995, p. 13.                                 208. Milojicic, D., et al., "Process Migration," ACM Computing Sur­
                                                                              veys, Vol. 32, No. 3, September 2000, p. 241
198. Mellor-Crummy, J. and M. Scott, "Scalable Reader-Writer Syn-
     chronization for Shared-Memory Multiprocessors," Proceedings        209. Langendorfer, H., and S. Petri, "Load Balancing and Fault Toler-
     of the Third ACM SIGPLAN Symposium on Principles and Prac­               ance in Workstation Clusters: Migrating Groups of Processes,"
     tices of Parallel Programming, 1991, pp. 106-113.                        Operating Systems Review, Vol, 29, No. 4, October 1995, p. 25

