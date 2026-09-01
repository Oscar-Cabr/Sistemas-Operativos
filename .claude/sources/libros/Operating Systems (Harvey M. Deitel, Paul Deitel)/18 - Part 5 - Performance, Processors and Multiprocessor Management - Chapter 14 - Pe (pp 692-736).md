# Part 5 - Performance, Processors and Multiprocessor Management / Chapter 14 - Performance and Processor Design

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 692–736 (numeración del PDF)

<!-- pág. 692 -->

Performance, Processors
  and Multiprocessor
     Management
   Don't tell me how hard you work. Tell me how much you get done.
                        —Lewis Carroll —




    Part5

<!-- pág. 693 -->

The next two chapters continue our emphasis on
performance. Chapter 14 discusses performance
measures, monitoring, evaluation, bottlenecks, sat-
uration and feedback loops. The chapter also
examines the crucial importance of processor
instruction set architectures for maximizing system
performance. Chapter 15 discusses the profound
performance improvement that is possible in sys-
tems that employ multiple processors, especially
massive numbers of processors. In the next decade,
we expect parallel computing to literally explode,
with individual systems tending to become multi-
processors, and with the proliferation of distrib-
uted    systems.          The         chapter         focuses         on
multiprocessor systems and discusses architecture,
operating system organizations, memory access
architectures, memory sharing, scheduling, process
migration, load balancing and mutual exclusion.




       The most general definition of beauty ... Multeity in Unity.
                    — Samuel Taylor Coleridge —

<!-- pág. 694 -->

Observe due measure, for right riming is in all things the most important factor.
      —Hesiod—


         Don't tell me how hard you work. Tell me how much you get done.
      —James Ling—


It is not permitted to the most equitable of men to be a judge in his own cause.
      —Blaise Pascal—

All words,
And no performance!
      —Philip Massinger—

<!-- pág. 695 -->

Chapter              14



Performance and Processor
          Design
 Objectives
 After reading this chapter, you should understand:
 • the need for performance measures.
 • common performance metrics.
 • several techniques for measuring relative system performance.
 • the notions of bottlenecks, saturation and feedback.
 • popular architectural design philosophies for processors.
 • processor design techniques that increase performance.

<!-- pág. 696 -->

                                 Chapter Outline

                      14.1                                    14.5.6 Synthetic Programs
                Introduction                                      14.5.7     Simulation
                                                            14.5.8 Performance Monitoring
                     14.2
       Important Trends Affecting                                     14.6
          Performance Issues                               Bottlenecks and Saturation

                     14.3                                                  14.7
      Why Performance Monitoring                                  Feedback Loops
        and Evaluation Are Needed                               14.7.1 Negative Feedback
                                                               14.7.2PositiveFeedback
                     14.4
          Performance Measures
                                                                      14.8
                                                           Performance Techniques in
                     14.5                                       Processor Design
         Performance Evaluation                         14.8.1 Complex Instruction Set Computing
               Techniques                                                  (CISC)
          14.5.1 Tracing and Profiling                      14.8.2 Reduced Instruction Set
      14.5.2TimingsandMicrobenchmarks                              Computing (RISC)
      14.5.3 Application-Specific Evaluation                 14.8.3 Post-RISC Processors
            14.5.4 Analytic Models                        14.8.4 Explicitly Parallel Instruction
              14.5.5Benchmarks                                    Computing (EPIC)




        Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited




642

<!-- pág. 697 -->

                                                                                              14.1 Introduction   643

14.1 Introduction
Because an operating system is primarily a resource manager, it is important for
 operating systems designers, managers and users to be able to determine how effec-
tively a particular system manages its resources. System performance measure-
ments enable consumers to make more informed decisions and help developers
build more efficient systems. In this chapter, we describe many performance issues
 and investigate techniques for measuring, monitoring and evaluating performance;
the use of these methods can help designers, managers and users realize maximum
performance from computing systems.
      The performance of a system depends heavily on its hardware, operating sys-
tem and the interaction between the two. Therefore, this chapter considers several
evaluation techniques that measure the performance of entire systems, rather than
just the operating system. We also present an introduction to popular processor-
design philosophies and how each seeks to achieve high performance.

Self Review
1. How do you suppose performance evaluation benefits consumers, developers and users?
2. What resource of a computer system probably has the greatest impact on performance?
Ans: 1) Performance evaluation provides consumers with a basis of comparison to decide
between different systems, developers with useful information on how to write software to
efficiently use system components and users with information that can facilitate tuning the
system to meet the requirements of a specific setting. 2) The processor(s).



14.2 Important Trends Affecting Performance Issues
In the early years of computer systems development, hardware was the dominant
cost, so performance studies concentrated primarily on hardware issues. Now, hard-
ware is relatively inexpensive and prices continue to decline. Software complexity is
increasing with the widespread use of multithreading, multiprocessing, distributed
systems, database management systems, graphical user interfaces and various appli-
cation support systems. The software typically hides the hardware from the user,
creating a virtual machine defined by the operating characteristics of the software.
Cumbersome software causes poor performance, even on systems with powerful
hardware, so it is important to consider a system's software performance as well as
its hardware performance.
      The nature of performance evaluation itself is evolving. Raw and potentially
misleading measures, such as clock speed and bandwidth, have become influential
in the consumer market, because vendors engineer their products with an eye to
these metrics. However, other aspects of performance evaluation are improving.
For example, designers have developed more sophisticated benchmarks, acquired
better trace data and engineered more comprehensive computer simulation mod-
els—we investigate all these techniques later in the chapter. New industry-standard
benchmarks and "synthetic programs" are emerging. Unfortunately, there is still no

<!-- pág. 698 -->

644 Performance and Processor Design

                           consensus on these standards. Critics charge that performance results can be incor-
                           rect or misleading, because the performance evaluation techniques do not necessar-
                           ily measure relevant features of a program.1


                           Self Review
                           1. How has the focus of performance studies shifted over the years?
                           2. Give several examples of how operating systems can improve performance, as discussed
                              in the preceding chapters.
                           Ans: 1) In the early years, hardware was the dominant cost, so performance studies focused
                           on hardware issues. Today, it is recognized that sophisticated software can have a substantial
                           effect on performance. 2) Operating systems can improve disk and processor scheduling pol-
                           icies, implement more efficient thread-synchronization protocols, more effectively manage
                           file systems, perform context switches more efficiently, improve memory management algo-
                           rithms, etc.



                           14.3 Why Performance Monitoring and Evaluation Are Needed
                           In his classic paper, Lucas mentions three common purposes for performance eval-
                           uation.2
                                  • Selection evaluation—The performance evaluator decides whether obtaining
                                    a computer system or application from a particular vendor is appropriate.
                                 • Performance projection—The performance evaluator estimates the perfor-
                                   mance of a system that does not exist. It might be a completely new com-
                                   puter system, or an old system with a new hardware or software
                                   component.
                                 • Performance monitoring—The evaluator accumulates performance data
                                   on an existing system or component to ensure that it is meeting its perfor-
                                   mance goals. Performance monitoring can also help estimate the impact of
                                   planned changes and provide system administrators with the data they
                                   need in order to make strategic decisions, such as whether to modify an
                                   existing process priority system or upgrade a hardware component.
                                 In the early phases of a new system's development, the vendor attempts to
                           predict the nature of applications that will run on the system and the anticipated
                           workloads these applications must handle. Once the vendor begins development
                           and implementation of the new system, performance evaluation and prediction are
                           used to determine the best hardware organization, the resource management strat-
                           egies that should be implemented in the operating system and whether or not the
                           evolving system meets its performance objectives. Once the product is released to
                           the marketplace, the vendor must be prepared to answer questions from potential
                           users about whether the system can handle certain applications with certain levels
                           of performance. Users are often concerned with choosing an appropriate configura-
                           tion of a system that services their needs.

<!-- pág. 699 -->

                                                                                    14.4    Performance Measures 645

      When the system is installed at the user's site, both the vendor and the user
seek to obtain optimal performance. Administrators fine-tune the system to run at
its best in the user's operating environment. This process, called system tuning, can
often cause dramatic performance improvements, once the system is adjusted to the
idiosyncrasies of the user installation.

Self Review
1. When would an evaluator use performance projection in preference to selection evalua-
   tion?
2. How does performance monitoring facilitate system tuning?
Ans: 1) Selection evaluation help an evaluator choose among existing systems. Perfor-
mance projection helps the evaluator predict the performance of systems that do not exist
yet—or how anticipated modifications to existing systems would perform. 2) An evaluator
can monitor performance to determine which modifications would most likely increase sys-
tem performance.


14.4 Performance Measures
By performance, we mean the efficiency with which a computer system meets its
goals. Thus, performance is a relative rather than an absolute quantity, although we
often talk of absolute performance measures such as the amount of time in which a
given computer system can perform a specific computational task. However, when-
ever a performance measure is taken, it is normally to be used as a basis of compar-
ison.
      Performance is often "in the eye of the beholder." For example, a young music
student might find a performance of Beethoven's Fifth Symphony thoroughly
inspiring, whereas the conductor might be sensitive to the most minor flaws in the
way a second violinist plays a certain passage. Similarly, the owner of a large airline
reservation system might be pleased with the high utilization reflected by a large
volume of reservations processed, whereas an individual user might be experienc-
ing excessive delays on such a busy system.
      Quantifying is difficult for some performance measures, such as ease of use,
and simple for others, such as the speed of a disk-to-memory transfer. The perfor-
mance evaluator must be careful to consider both types of measures, even though it
might be possible to provide neat statistics only for the latter. Some performance
measures, such as response time, are user oriented. Others, such as processor utili-
zation, are system oriented.
      Some performance results might be deceptive. For example, one operating sys-
tem might focus on conserving memory by executing complicated page-replacement
algorithms, whereas another might avoid these complex routines to save processor
cycles for executing user programs. The former would appear more efficient on a sys-
tem with a high clock speed; the latter, on a processor with a large main memory. In
addition, some techniques permit the evaluator to measure the performance of small
pieces of a system such as individual components or primitives. Although these tools

<!-- pág. 700 -->

646 Performance and Processor Design

                           can be useful for pinpointing specific weaknesses, they do not tell the entire story. The
                           evaluator might discover that an operating system performs all of its primitives effi-
                           ciently except one. This should not be a major concern, unless that inefficient primi-
                           tive is used extensively. Without taking into account the frequency with which each
                           primitive is used, measurements can be misleading. Similarly, programs designed to
                           evaluate a system for a particular environment that do not resemble the applications
                           for which the system is intended can yield spurious results.
                                 Some common performance measures are:
                                 • Turnaround time—This is the time from submission of a job until the sys-
                                   tem returns a result to the user.
                                 • Response time—This is an interactive system's turnaround time, often
                                   defined as the time from a user's pressing an Enter key or clicking a mouse
                                   until the system displays its response.
                                 • System reaction time—In an interactive system, this is often defined as the
                                   time from a user's pressing Enter or clicking a mouse until the first time
                                   slice of service is given to that user's request.
                                  These are probabilistic quantities, and in simulation and modeling studies of
                           systems they are considered to be random variables. A random variable is one that
                           can assume a certain range of values, where each value has an associated probabil-
                           ity of occurring. We discuss the distribution of response times, for example, because
                           users experience a wide range of response times on a particular interactive system
                           over some interval of operation. A probability distribution can meaningfully char-
                           acterize this range.
                                  When we talk of the expected value of a random variable, we are referring to
                           its mean or average value. However, means can often be deceiving. A certain mean
                           value can be produced by averaging a series of identical or nearly identical values,
                           or it can be produced by averaging a wide variety of values, some much larger and
                           some much smaller than the calculated mean. Therefore, other performance mea-
                           sures often employed are:
                                • Variance in response times (or of any of the random variables we dis-
                                  cuss)—The variance of response times is a measure of dispersion. A small
                                  variance indicates that the response times experienced by users are gener-
                                  ally close to the mean. A large variance indicates that some users are expe-
                                  riencing response times that differ widely from the mean. Some users could
                                  be receiving fast service, while others could be experiencing long delays.
                                  Thus the variance of response times is a measure of predictability; this can
                                  be an important performance measure for users of interactive systems.
                                • Throughput—This is the work-per-unit-time performance measurement.
                                • Workload—This is the measure of the amount of work that has been sub-
                                  mitted to the system. Often, evaluators define an acceptable level of per-
                                  formance for the typical workload of a computing environment. The
                                  system is evaluated compared to the acceptable level.

<!-- pág. 701 -->

                                                                            14.5 Performance Evaluation Tehniques 647

      • Capacity—This is a measure of the maximum throughput a system can
        attain, assuming that whenever the system is ready to accept more jobs,
        another job is immediately available.
      • Utilization—This is the fraction of time that a resource is in use. Utilization
        can be a deceptive measure. Although a high-percent utilization seems
        desirable, it might be the result of inefficient usage. One way to achieve
        high processor utilization, for example, is to run a process that is in an infi-
        nite loop! Another view of processor utilization also yields interesting
        insights. We might view a processor at any moment as being idle, in user
        mode, or in kernel mode. When a processor is in user mode, it is performing
        operations on behalf of a user. When the processor is in kernel mode, it is
        performing tasks for the operating system. Some of this time, such as con-
        text-switching time, is pure overhead. This overhead component can
        become large in some systems. Thus, when we measure processor utiliza-
        tion, we must be concerned with how much of this usage is productive work
        on behalf of the users, and how much is system overhead. Strangely, "poor
        utilization" is actually a positive measure in certain kinds of systems, such
        as hard real-time systems, where the system resources must stand ready to
        respond immediately to incoming tasks, or lives could be at risk. Such sys-
        tems focus on immediate response rather than resource utilization.


Self Review
1. What is the difference between response time and system reaction time?
2. (T/F) When a processor spends most of its time in user mode, the system achieves efficient
   processor utilization.
Ans: 1) Response time is the time required for the system to finish responding to a user
request (from the time the request is submitted); system reaction time is the time required
for the system to begin responding to a user request (from the time the request is submitted).
2) False. If the processor is executing an infinite loop, this system is not using the processor
efficiently.




14.5 Performance Evaluation Techniques
Now that we have considered some possible performance measures, we need some
way of extracting them. In this section, we describe several important performance
evaluation techniques.3, 4, 5 Some of these isolate different components of a system
and report each component's individual performance, allowing developers to identify
areas of inefficiency. Others are oriented toward the system as a whole and allow con-
sumers to make comparisons between systems. Still other techniques are application
specific and therefore allow only indirect comparisons with other systems,. In the sec-
tions that follow, we describe various evaluation techniques and the aspects of system
performance they measure.

<!-- pág. 702 -->

648   Performance and Processor Design

                             14.5.1 Tracing and Profiling
                             Ideally, a system evaluator would measure the performance of several systems, each
                             executing in the same environment. However, this is usually not feasible, especially
                             for corporations whose environments are complex and difficult to duplicate. Such a
                             process can be invasive, compromising the integrity of the environment and nullify-
                             ing the results. When the performance of a system must be evaluated in a given
                             environment, designers often use trace data. A trace is a record of system activity —
                             typically a log of user and application requests to the operating system.
                                    System evaluators can use trace data to characterize a particular system's exe-
                             cution environment by determining the frequency with which user-mode processes
                             request particular kernel services. Before installing a new computing system, evalua-
                             tors can test the new system using a workload derived from the trace data or using
                             the trace itself. Trace data often can be modified to evaluate "what-if" scenarios. For
                             example, a system administrator might need to determine how a new Web site will
                             affect Web server performance. An existing trace can be modified to estimate how
                             the system will handle its new load.6
                                   When operating systems execute in similar environments, standard traces can
                             be developed and executed on those systems to compare performance. Trace data
                             obtained from one installation, however, might not be applicable to another. Such
                             data is, at best, an approximation of system activity at the other installation. In addi-
                             tion, user logs are considered proprietary to the system on which they were recorded;
                             rarely are such logs distributed to the research community or to vendors. Conse-
                             quently, there is a dearth of trace data available for comparison and evaluation.7
                                   Another method for capturing a computing system's execution environment is
                             profiling. Profiles record system activity while executing in kernel mode, which can
                             include operations such as process scheduling, memory management and I/O man-
                             agement. For example, a profile might record which kernel operations are per-
                             formed most often. Alternatively, a profile can simply log all function calls issued by
                             the operating system. Profiles indicate which operating system primitives are most
                             heavily used, enabling system administrators to identify potential targets for opti-
                             mization and tuning.8 Evaluators must often employ other performance evaluation
                             techniques in concert with profiles to determine the most effective ways to improve
                             system performance.


                             Self Review
                             1. How do evaluators use trace data?
                             2. Explain the difference between traces and profiles.
                             Ans: 1) Trace data permits evaluators to compare the performance of many different sys-
                             tems that operate in the same computing environment. Trace data describes this environ-
                             ment so that evaluators can obtain performance results relevant to the systems' intended use
                             2) Traces record user requests, whereas profiles log all activity in kernel mode. Therefore
                             traces describe a computing environment by capturing the user demand for particular kernel

<!-- pág. 703 -->

                                                                       14.5   Performance Evaluation Techniques 649

services (without regard to the underlying system), and profiles capture operating system
activity in a given environment.


14.5.2     Timings and Microbenchmarks
Timings provide a means of performing quick comparisons of computer hardware.
Early computer systems were often evaluated by their add times or their memory-
cycle times. Timings are useful for indicating the "raw horsepower" of a particular
computer system, often in terms of the number of MIPS (millions of instructions
per second) or BIPS (billions of instructions per second) it executes. Some comput-
ers perform in the TIPS (trillion instructions per second) range.
       With the advent of families of computers, such as the IBM 360 series, first
introduced in 1964, or the Intel Pentium series, a descendant of the Intel x86 series
introduced in 1978, it has become common for hardware vendors to offer comput-
ers that enable a user to upgrade to faster processors (without replacing other com-
puter components) as the user's needs grow. The computers in a family are
compatible in that they can run the same programs but at greater speeds as the user
moves up in the family. Timings provide a convenient means for comparing the
members of a family of computers.
       A microbenchmark measures the time required to perform an operating sys-
tem operation (e.g., process creation). Microbenchmarks are useful for measuring
how a design change affects the performance of a specific operation. Microbench-
mark suites are programs that measure the performance of a number of important
operating system primitives, such as memory operations, process creation and con-
text-switch latency.9 Evaluators also use microbenchmarks to measure system per-
formance for specific operations, such as read/write bandwidth (i.e., how much data
the system can transfer per unit time during a read or write) and network connec-
tion latency.10
       Microbenchmarks describe how quickly a system performs a particular opera-
tion, not how often that operation is performed. Consequently, they do not measure
important evaluation criteria such as throughput and utilization. Microbenchmarks,
however, are useful in isolating which operations could be causing a system to per-
form poorly when coupled with information about how each operation is used.11
       Until the 1990s, no single microbenchmark suite demonstrated the effect of
hardware components on the performance of operating system primitives. In 1995
the Imbench microbenchmark suite, which enabled evaluators to measure and com-
pare system performance on a variety of UNIX platforms, was introduced. 12
Although Imbench provided useful performance evaluation data that allowed com-
parison across multiple platforms, it was inconsistent in the way that it reported sta-
tistical data—some tests returned results based on an average of runs while other
used just one run of the microbenchmark. Imbench was also limited to performing
measurements once per millisecond because it used coarse software timing mecha-
nisms; this is insufficient for measuring fast operations and timing hardware.
Researchers at Harvard University addressed these limitations by creating the

<!-- pág. 704 -->

650 Performance and Processor Design

                           hbench microbenchmark suite, which provides a standard and rigorous model for
                           reporting statistics, enabling evaluators to more effectively analyze the relationship
                           between operating system primitives and hardware components. 13 lmbench and
                           hbench represent different microbenchmark philosophies, lmbench focuses on
                           portability, which permits evaluators to compare performance across different
                           architectures; hbench focuses on the relationship between the operating system and
                           its underlying hardware within a particular system.14, 15

                           Self Review
                           1. How can results from timings and microbenchmarks be misleading? How are they useful?
                           2. Which performance measure can be combined with microbenchmarks to evaluate operat-
                              ing system performance?
                           Ans: 1) Microbenchmarks measure the time required to perform specific primitives (e.g..
                           process creation), and timings perform quick comparisons of hardware operations (e.g., add
                           instructions). Neither of these measurements reflects system performance as a whole. How-
                           ever, microbenchmarks and timings can be useful in pinpointing potential areas of ineffi-
                           ciency and evaluating the effect of small modifications on system performance. 2) Profiles,
                           which record how often an operating system primitive is used, can be combined with
                           microbenchmarks to evaluate operating system performance.


                           14.5.3     Application-Specitic      Evaluation
                           Although "raw performance" is an important measure, many users are more inter-
                           ested in how well particular applications will perform on a particular system. Selt-
                           zer et al. describe a vector-based methodology for calculating an application-
                           specific evaluation of a system by combining trace and profile data with timings and
                           microbenchmarks. 16
                                 In this technique, an evaluator records the results of microbenchmarks for the
                           operating system's primitives. Next, the evaluator constructs a vector by placing the
                           values corresponding to the microbenchmark results in the elements of the vector:
                           this is called the system vector. Next, the evaluator profiles the operating system
                           while executing the target application. The evaluator constructs a second vector by
                           inserting the relative demand for each operating system primitive in an element in
                           the vector; this is called the application vector. Each element in the system vector
                           describes how long the operating system needs to execute a particular primitive,
                           and the corresponding entry in the application vector describes the application's
                           relative demand for that primitive. For example, if the first entry in the system vec-
                           tor records process creation performance, the first entry in the application vector
                           records how many processes were created while executing a particular application
                           (or group of applications). A characterization of the performance of a given system
                           executing a particular application is calculated by

<!-- pág. 705 -->

                                                                             14.5 Performance Evaluation Techniques 651

 where si is the ith entry in the system vector, ai is the ith entry in the application vec-
 tor and n is the size of both vectors.17
       This technique can be useful for comparing how efficiently different operating
systems execute a particular application (or group of applications) by considering
 the demand an application places on each of a system's primitives. The vector-based
methodology can be used to select operating system primitives to tune to improve
system performance.
       Some application behavior depends both on the particular application and on
user input. For example, the type of application requests generated in a database
system depends on its population of active users. Simply profiling the system with-
 out determining the typical stream of user requests can produce misleading results.
In such cases, both the application and user requests determine the system's execu-
tion environment. Therefore, to provide a more accurate system evaluation, the
vector-based methodology can be combined with a trace (Seltzer et al. call this the
hybrid methodology). In this case, the trace data allows the evaluator to construct
the application vector while accounting for how the specific application and typical
stream of user requests affect the demand for each operating system primitive.18
       A kernel program is another application-specific performance evaluation tool,
although it is not often used. A kernel program can range from an entire program
that is typical of one executed at an installation or a simple algorithm such as a matrix
inversion. Using the manufacturer's estimated instruction timings, execution of a ker-
nel program is timed for a given machine. Machines are then compared on the basis
of differences in the expected execution times. Kernel programs are actually "exe-
cuted on paper" rather than being run on a particular computer. They are used in
selection evaluation before a consumer purchases the system being evaluated. [Note:
 "Kernel" here should not be confused with the kernel of the operating system.]19
       Kernel programs give better results than either timings or microbenchmarks,
but they require manual effort to prepare and time. One key advantage of many ker-
nel programs is that they are complete programs, which ultimately is what the user
actually runs on the computer system under consideration.
       Kernel programs can be helpful in evaluating certain software components of a
system. For example, two different compilers might produce dramatically different
code, and kernel programs can help an evaluator decide which one generates more
efficient code.20


Self Review
1. What is a benefit of application-specific evaluation? What is a drawback?
2. Why do you suppose kernel programs are rarely used?
Ans: 1) Application-specific evaluation is useful in determining whether a system will per-
form well in executing the particular programs at a given installation. A drawback is that a
system must be evaluated by each installation that is considering using it; the system's design-
ers cannot simply publish one set of performance results. 2) Kernel programs require time
and effort to prepare and time. Also, they are "executed on paper" and can introduce human

<!-- pág. 706 -->

652 Performance and Processor Design

                           error. Often, it is easier to run the actual program, or one similar to it, on the actual system
                           than calculate the execution time for a kernel program.


                           14.5.4 Analytic Model
                           Analytic models are mathematical representations of computer systems or their
                           components.21, 22, 23, 24, 25 Many types of models are used; those of queuing theory
                           and Markov processes are two of the more popular, because they are relatively
                           manageable and useful.
                                 For evaluators who are mathematically inclined, the analytic model can be rel-
                           atively easy to create and modify. A large body of mathematical results exists that
                           evaluators can apply in order to estimate the performance of a given computer sys-
                           tem or component quickly and fairly accurately. However, several disadvantages of
                           analytic modeling hinder its applicability. One is that evaluators must be highly
                           skilled mathematicians; these people are rare in commercial computing environ-
                           ments. Another is that complex systems are difficult to model precisely; as systems
                           become more complex, analytic modeling becomes less useful.
                                 Today's systems are often so complex that the modeler is forced to make
                           many simplifying assumptions that can diminish the usefulness and applicability of
                           the model. Therefore, an evaluator should use other techniques (e.g.; microbench-
                           marks) in concert with analytic models. Sometimes the results of an evaluation
                           using only analytic models might be invalidated by studies using other techniques.
                           Often the different evaluations tend to reinforce one another, demonstrating the
                           validity of the modeler's conclusions.

                           Self Review
                           1. Explain the relative merits of complex and simple analytic models.
                           2. What are some benefits of using analytic modeling?
                           Ans: 1) Complex analytic models are more accurate, but it might not be possible to find a
                           mathematical solution to model a system's behavior. It is easier to represent the behavior of
                           a system with a simpler model, but it might not accurately represent the system. 2) There is a
                           large body of results that evaluators can draw from when creating models; analytic models
                           can provide accurate and quick performance results; and they can be modified relatively eas-
                           ily when the system changes.


                           14.5.5 Benchmarks
                           A benchmark is a program that is executed to evaluate a machine. Commonly, a
                           benchmark is a production program which is typical of many jobs at the installation.
                           The evaluator is thoroughly familiar with the performance of the benchmark on
                           existing equipment, so when it is run on new equipment, the evaluator can draw
                           meaningful conclusions.26-27 Several organizations, such as Standard Performance
                           Evaluation Corporation (SPEC; www.specbench.org) and Business Application
                           Performance Corporation (BAPCo; www.bapco.com), have developed industry-

<!-- pág. 707 -->

                                                                     14.5    Performance Evaluation Techniques 653

standard benchmarks targeted for different systems (e.g., Web servers or personal
computers). Evaluators can run these benchmarks to compare similar systems from
different vendors.
      .One advantage of benchmarks is that many already exist, so the evaluator
merely needs to choose them from known production programs or use industry-
standard benchmarks. No timings are taken on individual instructions. Instead, the
full program is run on the actual machine using real data, so the computer does
most of the work. The chance of human error is minimal because the benchmark
time is measured by the computer itself. In environments such as multiprogram-
ming, timesharing, multiprocessing, database, data communications and real-time
systems, benchmarks can be particularly valuable, because they run on the actual
machine in real circumstances. The effects of such complex systems can be experi-
enced directly instead of being estimated.
       Several criteria should be considered when developing a benchmark. First, the
results should be repeatable; specifically, every run of the benchmark program on a
certain system should produce nearly the same result. Results do not have to be iden-
tical, and seldom are, because they can be affected by environment-specific details,
such as where an item is stored on disk. Second, benchmarks should accurately reflect
the types of applications that will be executed on a system. Finally, the benchmark
should be widely used so that more accurate comparisons can be made between sys-
tems. A good industry-standard benchmark will have all these properties; however,
the latter two often lead to conflicting design decisions. A benchmark that is specific
to a certain system might not be widely used; a benchmark that is designed to test
multiple systems might not yield as accurate a result for a specific system.28
       Benchmarks are useful in evaluating hardware as well as software, even under
complex operating environments. They also are particularly useful in comparing the
operation of a system before and after certain changes are made. Benchmarks are not
useful, however, in predicting the effects of proposed changes, unless another system
exists with the changes incorporated and on which the benchmarks can be run.
       Benchmarks are probably the technique most widely used by organizations
and consumers when determining which equipment to purchase from several com-
peting vendors. Their popularity as tools for this purpose led to the need for indus-
try-standard benchmarks. SPEC was founded in 1988 to promote the development
of standard, relevant benchmarks. SPEC publishes a variety of benchmarks (often
called SPECmarks) that can be used to evaluate systems ranging from servers to
Java Virtual Machines and publishes performance results obtained using those
SPECmarks for thousands of commercial systems. SPEC ratings can be useful for
making an informed decision determining which computer components to pur-
chase. However, one must first carefully determine the focus of each SPECmark
test to evaluate particular platforms. For example, SPECweb measures systems on
which Web servers typically execute and should not be used to compare systems
that execute in different environments.29 If the environment of a particular Web
server differs from a "typical" one, the SPEC rating might not be relevant. Further-

<!-- pág. 708 -->

654 Performance and Processor Design

                            more, some of SPEC'S benchmarks have been criticized for narrow scope, espe-
                            cially by those who question the assumption that a "typical" workload can
                            accurately approximate a real-world workload for a particular system. To combat
                            such limitations, SPEC continually redesigns its benchmarks to improve their rele-
                            vance to current systems.30, 31
                                  Although SPEC produces some of the best-known benchmarks, there are a
                            number of other popular benchmarks and benchmarking organizations. BAPCo pro-
                            duces several benchmarks, including the popular SYSmark benchmark (for desktop
                            systems), MobileMark (for systems installed on mobile devices) and WebMark (for
                            Internet performance).32 Other popular benchmarks include the Transaction Process-
                            ing Performance Council (TPC) benchmarks, which target database systems,33 and the
                            Standard Application (SAP) benchmarks, which evaluate a system's scalability.34

                           Self Review
                            1. How can benchmarks be used to anticipate the effect of proposed changes to a system?
                            2. Why are there no universally accepted "standard" benchmarks?
                           Ans: 1) In general, benchmarks are effective only for determining the results after a change
                           or for performance comparisons between systems, not for anticipating the effect of proposed
                           changes to a system. However, if the proposed changes match the configuration of an existing
                           system, running the benchmark on that system would be useful. 2) Benchmarks are real pro-
                           grams that are run on real machines, but each machine might contain a different set of hard-
                           ware that runs a different mix of programs. Therefore, benchmark designers provide "typical"
                           application mixes that are updated regularly to better approximate particular environments.

                            14.5.6 Synthetic Programs
                            Synthetic programs (also called synthetic benchmarks) are similar to benchmarks,
                            except that they focus on a specific component of the system, such as the I/O sub-
                            system and memory subsystem. Unlike benchmarks, which are typical of real appli-
                            cations, evaluators construct synthetic programs for specific purposes. For example,
                            a synthetic program might target an operating system component (e.g., the file sys-
                            tem) or might be constructed to match the instruction frequency distribution of a
                            large set of programs. One advantage of synthetic programs is that they can isolate
                            specific components of a system rather than test the entire system.35, 36, 37, 38, 39
                                  Synthetic programs are useful in development environments. As new features
                            become available, synthetic programs can be used to test that they are operational.
                            Evaluators, unfortunately, do not always have sufficient time to code and debug
                            synthetic programs, so they often seek existing benchmark programs that match the
                            desired characteristics of a synthetic program as closely as possible. Evaluators can
                            use synthetic programs with benchmarks and microbenchmarks for a thorough sys-
                            tem evaluation. These three techniques provide different levels of abstraction (the
                            system as a whole, a component of the system or a simple primitive) that, com-
                            bined, give the evaluator an understanding of the performance both of the entire
                            system and of individual parts of the system.

<!-- pág. 709 -->

                                                                          14.5    Performance Evaluation Technique   655

      Although no longer used much, the Whetstone and the Dhrystone are exam-
ples of classic synthetic programs. The Whetstone measures how well systems han-
dle floating point calculations, and was thus helpful in evaluating scientific
programs. The Dhrystone measures how effectively an architecture runs systems
programs. Because the Dhrystone consumes only a small amount of memory, its
effectiveness is particularly sensitive to the size of a processor's cache; if the Dhrys-
tone's data and instruction can fit in the cache, it will execute much faster than if the
processor must access main memory while it executes. In fact, because the Dhrys-
tone fits in most of today's processor caches, in effect it measures a processor's
clock speed and provides no insight into how a system manages memory. One pop-
ular synthetic program used extensively today is WinBench 99, which tests a sys-
tem's graphics, disk and video subsytsems in a Microsoft Windows environment.40
Other popular synthetic benchmarks include IOStone (which tests file systems),41
Hartstone (for real-time systems)42 and STREAM (for the memory subsystem).43

Self Review
1. Explain why synthetic programs are useful for development environments.
2. Should synthetic programs alone be used for a performance evaluation? Why?
Ans: 1) Synthetic programs can be written fairly quickly and can test specific features for
correctness. 2) No, synthetic programs are "artificial" programs used to test specific compo-
nents or to characterize a large set of programs (but not one in particular). Therefore,
although producing valuable results, they do not necessarily describe how the entire system
will perform when executing real programs. It is usually a good idea to use a variety of per-
formance evaluation techniques.


14.5.7 Simulation
Simulation is a technique in which an evaluator develops a computerized model of
the system being evaluated. 44, 45, 46, 47, 48 The evaluator tests the model, which pre-
sumably reflects the target system, to infer performance data about this system.
      With simulation it is possible to prepare a model of a system that does not
exist and then run the model to see how the system might behave in certain circum-
stances. Of course, the simulation must eventually be validated against the real sys-
tem to prove that it is accurate. Simulations can highlight problems early in a
system's development cycle. Computerized simulators have become especially pop-
ular in the space and transportation industries, because of the severe consequences
of building systems that fail.
      Simulators are generally of two types:
      • Event-driven simulators—These are controlled by events that are made to
        occur in the simulator according to probability distributions.49
      • Script-driven simulators—These are controlled by data carefully manipu-
        lated to reflect the anticipated environment of the simulated system; evalu-
        ators derive this data from empirical observations.

<!-- pág. 710 -->

656 Performance and Processor Design

                                 Simulation requires considerable expertise on the part of the evaluator and
                           can consume substantial computer time. Simulators generally produce huge
                           amounts of data that must be carefully analyzed. However, once simulators are
                           developed, they can be reused effectively and economically.
                                 Just as with analytic models, it is difficult to model a complex system exactly
                           with a simulation. Several common errors cause most inaccuracies. Bugs in simula-
                           tors will, of course, produce erroneous performance results. Deliberate omissions,
                           resulting from the necessity of simplifying a simulation, can invalidate results as
                           well. This is usually more of a problem for simple simulators. However, complex
                           simulators suffer from the third problem—lack of detail. Complex simulators
                           attempt to model all parts of the system, but inevitably, they do not model all
                           details exactly. The attendant errors also can hinder a simulator's effectiveness.
                           Therefore, to achieve the most accurate performance results, it is important to vali-
                           date a simulation against the real system.50

                           Self Review
                           1. Which produces more consistent results, event-driven or script-driven simulators?
                           2. (T/F) Complex simulators are always more effective than simpler ones.
                           Ans: 1) Script-driven simulators produce nearly the same result each run because the sys-
                           tem always uses the same inputs. Because event-driven simulators dynamically generate
                           input based on probabilities, the results are less consistent. 2) False. Although complex simu-
                           lators attempt to model a system more completely, they still might not model it accurately.


                           14.5.8 Performance Monitoring
                           Performance monitoring is the collection and analysis of information regarding sys-
                           tem performance for existing systems.51, 52, 53 It can help determine useful perfor-
                           mance measures, such as throughput, response times and predictability.
                           Performance monitoring can locate inefficiencies quickly and help system adminis-
                           trators decide how to improve system performance.
                                 Users can monitor performance using software or hardware techniques. Soft-
                           ware monitors might distort performance readings, because the monitors them-
                           selves consume system resources. Familiar examples of performance monitoring
                           software are Microsoft Windows's Task Manager54 and the Linux proc file system55
                           (see Section 20.7.4, Proc File System). Hardware monitors are generally more
                           costly, but they have little or no impact on system performance. Many of today's
                           processors maintain several counting registers useful for performance monitoring
                           that record events including clockticks, TLB misses and memory operations (such
                           as a write to main memory).56
                                 Monitors generally produce huge volumes of data that must be analyzed, pos-
                           sibly requiring extensive computer resources. However, they indicate precisely how
                           the system is functioning, and this information can be extremely valuable. This is
                           particularly true in development environments in which key design decisions might
                           be based on the observed operation of the system.

<!-- pág. 711 -->

                                                                           14.5    Performance Evaluation Techniques 657

    Instruction execution traces, or module execution traces, can reveal which
areas of a system are most frequently used. A module execution trace might show,
for example, that a small subset of modules is being used a large percentage of the
time. If designers concentrate their optimization efforts on these modules, they
might be able to improve system performance without expending effort and
resources on infrequently used portions of the system. Figure 14.1 summarizes per-
formance evaluation techniques.


Self Review
1. Why do software performance monitors influence a system more than hardware perfor-
   mance monitors?
2. Why is performance monitoring important?
Ans: 1) Software-based performance monitors must compete for system resources that
would otherwise be allocated to programs that are being evaluated. This can result in inaccu-
rate performance measurements. Hardware performance monitors operate in parallel with
 other system hardware, so that measurement does not affect system performance. 2) Perfor-
mance monitoring enables administrators to identify inefficiencies, using data describing how
 the system is functioning.


 Technique              Description
 Trace                  Record of real application requests to the operating system, which
                        identifies a system's workload.
 Profile                Record of kernel activity taken during a real session. Profiles indi-
                        cate the relative usage of operating system primitives.
 Timing                 Raw measure of hardware performance, which can be used for
                        quick comparisons between related systems.
 Microbenchmarks        Raw measure of how quickly an operating system performs an iso-
                        lated operation.
 Application-specific   Evaluation that determines how efficiently a system executes a par-
 evaluation             ticular application.
                        Technique in which an evaluator builds and analyzes a mathemati-
 Analytic modeling      cal model of a computer system.
                        Program typical of one that will be run on the given system, used
 Benchmark              for comparisons between systems.
                        Program that isolates the performance of a particular operating sys-
 Synthetic program      tem component.
                        Technique in which a computer model of the system is evaluated.
 Simulation             The results of the simulation must be validated against the actual
                        system once the system is built.
 Performance            Ongoing evaluation of a system once it is installed, allowing admin-
 monitoring             istrators to assess whether it is meeting its demands and to deter-
                        mine which areas of its performance require improvement.

Figure 14.1 | Summary of performance evaluation techniques.

<!-- pág. 712 -->

658 Performance and Processor Design

                           14.6 Bottlenecks and Saturation
                           Operating systems manage collections of resources that interface and interact in
                           complex ways. Occasionally, resources become bottlenecks, limiting the system's
                           overall performance, because they perform their designated tasks slowly relative to
                           other resources. While other system resources might have excess capacity, the bot-
                           tlenecks cannot pass jobs or processes to these other resources fast enough to keep
                           them busy. 57 . 5859
                                  A bottleneck tends to develop at a resource when the traffic there begins to
                           approach its capacity. We say that the resource becomes saturated—i.e., processes
                           competing for its attention begin to interfere with one another, because one must
                           wait for others to complete using the resource. 60 A classic example is a virtual mem-
                           ory system that is thrashing (see Chapter 11, Virtual Memory Management). This
                           occurs in paged systems when main memory becomes overcommitted and the work-
                           ing sets of the various active processes cannot be maintained simultaneously in main
                           memory. An active process interferes with another process's use of memory by forc-
                           ing the system to flush some of the other process's working set to secondary storage
                           to make room for its own working set. Saturation can be dealt with by reducing the
                           load on the system—e.g., thrashing can be eliminated by temporarily suspending less
                           critical, noninteractive processes, if such processes are available.
                                 How can bottlenecks be detected? Quite simply, each resource's request
                           queue should be monitored. When a queue begins to grow quickly, then the arrival
                           rate of requests at that resource must be larger than its service rate, so the resource
                           has become saturated.
                                  Isolation of bottlenecks is an important part of tuning a system. The bottle-
                           necks can be removed by increasing the capacity of the resources, by adding more
                           resources of that type at that point in the system, or, again, by decreasing the load
                           on those resources. Removing a bottleneck does not always improve throughput,
                           however, because other bottlenecks might also exist in the system. Tuning a system
                           often involves identifying and eliminating bottlenecks until system performance
                           reaches satisfactory levels.




                           Self Review
                           1. Why is it important to identify bottlenecks in a system?
                           2. Thrashing is due to the saturation of what resource? How would an operating system
                              detect thrashing?
                          Ans: 1) Identifying bottlenecks allows designers to focus on optimizing sections of a system
                          that are degrading performance. 2) Main memory. The operating system would notice a high
                          page recapture rate—the pages being paged out to make room for incoming pages would
                          themselves quickly be paged back into main memory.

<!-- pág. 713 -->

                                                                                                14.7 Feedback Loops 659


 14.7 Feedback Loops
 A feedback loop is a technique in which information about the current state of the
system can affect arriving requests. These requests can be rerouted if the feedback
 indicates that the system might have difficulty servicing them. Feedback can be neg-
ative, in which case arrival rates might decrease, or positive, in which case arrival
rates might increase. Although we divide this section to examine positive and nega-
tive feedback situations separately, they do not represent two different techniques.
Rather, a request rate at a particular resource might cause either negative or posi-
tive feedback (or neither).

14.7.1 Negative Feedback
In negative feedback situations, the arrival rate of new requests might decrease as a
result of information being fed back. For example, a motorist pulling into a gas sta-
tion and observing that several cars are waiting at each pump might decide to drive
down the street to less crowded station.
      In distributed systems, spooled outputs can often be printed by any of several
equivalent print servers. If the queue behind one server is too long, the job may be
placed in a less crowded queue.
      Negative feedback contributes to stability in queuing systems. If the scheduler
assigns arriving jobs indiscriminately to a busy device, for example, then the queue
behind that device might grow indefinitely (even though other devices might be
underutilized).

Self Review
1. Explain how negative feedback could improve read performance in Level 1 (mirrored)
   RAID.
2. How does negative feedback contribute to system stability?
Ans: 1) If one of the disks in a mirrored pair contains a large queue of read requests, some
of these requests could be sent to the other disk in the pair if it contains a smaller queue.
2) Negative feedback prevents one resource from being overwhelmed while other identical
resources lie idle.

14.7.2 Positive Feedback
In positive feedback situations, the arrival rate of new requests might increase as a
result of information being fed back. A classic example occurs in paged virtual
memory multiprocessor systems. Suppose the operating system detects that a pro-
cessor is underutilized. The system might inform the process scheduler to admit
more processes to that processor's queue, anticipating that this would place a
greater load on the processor. As more processes are admitted, the amount of
memory that can be allocated to each process decreases and page faults might
increase (because the working sets of all active processes might not fit in memory).
Processor utilization will actually decrease as the system thrashes. A poorly

<!-- pág. 714 -->

660 Performance and Processor Design

                            designed operating system might then decide to admit even more processes. Of
                            course, this would cause further deterioration in processor utilization.
                                  Operating systems designers must be cautious when designing mechanisms to
                            respond to positive feedback to prevent such unstable situations from developing.
                            The effects of each incremental change should be monitored to see whether it
                            results in the anticipated improvement. If a change causes performance to deterio-
                            rate, this signals to the operating system that it might be entering an unstable
                            range and that resource-allocation strategies should be adjusted in order to resume
                            stable operation.

                            Self Review
                            1. In some large server systems, users communicate requests to a "front-end" server. This
                               server accepts the user's request and sends it to a "back-end" server for processing. How
                               could a front-end server balance request loads among a set of equivalent back-end servers
                               using feedback loops?
                            2. This section describes how positive feedback can intensify thrashing. Suggest one possible
                               solution to this problem.
                           Ans: 1) Back-end servers with a long queue of requests might send negative feedback to
                           the front-end sever, and back-end servers that are idle might send positive feedback. The
                           front-end server can use these feedback loops to send incoming requests to underloaded
                           instead of overloaded servers. 2) The system can monitor the number of page recaptures and
                           refuse to admit further processes beyond a certain threshold.



                            14.8 Performance Techniques in Processor Design
                            A system's performance depends heavily on the performance of its processors. Con-
                            ceptually, a processor can be divided into its instruction set, which is the set of
                            machine instructions it can perform, and its implementation, which is the physical
                            hardware. An instruction set might be composed of a few basic instructions that per-
                            form only simple functions, such as loading a value from memory into a register or
                            adding two numbers. Alternatively, instruction sets can contain an abundance of
                            more complex instructions such as those that solve a specified polynomial equation.
                            The penalty for providing such a large number of complex instructions is more com-
                            plex hardware, which increases processor cost and might reduce performance for sim-
                            pier instructions; the benefit is that these complex routines can be performed quickly.
                                  The instruction set architecture (ISA) of a processor is an interface the
                            describes the processor, including its instruction set, number of registers and mem-
                            ory size. The ISA is the hardware equivalent to an operating system API.61
                            Although a particular ISA does not specify the hardware implementation, the ele-
                            ments of an ISA directly affect how the hardware is constructed and therefore sig-
                            nificantly impact performance. Approaches to IS As have evolved over the years.
                            This section investigates these approaches and evaluates how ISA design decisions
                            affect performance.

<!-- pág. 715 -->

                                                                 14.8 Performance Techniques in Processor Design 661

Self Review
1. What trade-offs must be weighed when including single instructions that perform complex
   routines in an instruction set?
2. Why is the choice of an ISA important?
Ans: 1) The penalty for adding these instructions is more complex hardware, which might
slow the execution of other more frequently used instructions; the benefit is faster execution
of these complex routines. 2) The ISA specifies a programming interface between hardware
and low-level software; therefore, it affects how easily code can be generated for the proces-
sor and how much memory that code occupies. Also, the ISA directly affects processor hard-
ware, which influences cost and performance.


14.8.1 Complex Instruction Set Computing (CISC)
Until the mid-1980s, the clear trend was to incorporate frequently used sections of
code into single machine-language instructions, with the hope of making these func-
tions faster to execute and easier to code in assembly language. The logic was
appealing, judging by the number of ISAs that reflected these greatly expanded
instruction sets—an approach that has been named complex instruction set com-
puting (CISC), partly echoing the popular term reduced instruction set computing
(RISC), which we discuss in the next section.62
      CISC processors originated when most systems programs were written in
assembly language. An instruction set including single instructions that each per-
formed several operations enabled assembly-language programmers to write their
programs with fewer lines of code, thus improving programmer productivity. CISC
continued to be attractive when high-level languages became widely used for writ-
ing operating systems (such as the use of C and C++ in UNIX source code), because
special-purpose instructions were added to fit well with the needs of optimizing
compilers. Optimizing compilers alter the structure of compiled code (but not the
semantics) to achieve higher performance for a particular architecture. CISC
instructions mirrored the complex operations of high-level languages rather than
the simple operations a processor could execute in one or two clock cycles. These
complex instruction sets tended to be implemented via microprogramming. Micro-
programming introduces a layer of programming below a computer's machine lan-
guage; this layer specifies the actual primitive operations that a processor must
perform, such as fetching an instruction from memory (see Section 2.9 for a further
description). In these CISC architectures, the machine-language instructions were
interpreted, so that complex instructions were performed as a series of simpler
microprogrammed instructions.63
      CISC processors became popular largely in response to the decreasing cost of
hardware coupled with the increasing cost of developing software with assembly
language. CISC processors attempt to move most of the complexity from the soft-
ware to the hardware. As a side effect, CISC processors also reduce the size of pro-
grams, saving memory and easing debugging. Another characteristic of some CISC
processors is a trend toward reducing the number of general-purpose registers, to

<!-- pág. 716 -->

662 Performance and Processor Design

                           decrease cost and increase space available to other CISC structures, such as the
                           instruction decoder.64-65
                                 One powerful technique to increase performance that developed during the
                           CISC era was pipelining. A pipeline divides a processor's datapath (i.e., the portion
                           of the processor that performs operations on data) into discrete stages. For every
                           clock cycle, a maximum of one instruction can occupy each stage, allowing a proces-
                           sor to perform operations on several instructions simultaneously. In the early 1960s.
                           IBM developed the first pipelined processor, the IBM 7030 (nicknamed "Stretch").
                           The 7030's pipeline consisted of four stages: instruction fetch, instruction decode,
                           operand fetch and execution. While the processor was executing one instruction, it
                           fetched the operands for the next instruction, decoded another instruction and
                           fetched a fourth instruction. After each clock cycle began, each instruction in the
                           pipeline would move forward one stage; this permitted the 7030 to process up to four
                           instructions at once, which improved performance significantly.66, 67, 68
                                 As processor manufacturing technology has improved, chip size and memory
                           bandwidth have become less of a concern. Moreover, advanced compilers can easily
                           perform many optimization techniques previously delegated to the implementation
                           of the CISC instruction set.69 However, CISC processors still are popular in many
                           personal computers; they also can be found in several high-performance computers.
                           Intel Pentium (www.intel.com/products/desktop/processors/pentium4/)
                           and Advanced Micro Devices (AMD) Athlon (www.amd.com/us-en/Processors/
                           Productlnformation/0,,30_118_756,00.html) processors are CISC processors.

                           Sel Review
                           1. (T/F) The widespread use of high-level programming languages eliminated the usefulness
                              of complex instructions.
                           2. What was the motivation behind the CISC processor-design philosophy?
                           Ans: 1) False. Additional complex instructions were created to fit well with the needs of
                           optimizing compilers. 2) Early operating systems were written primarily in assembly code, so
                           complex instructions simplified programming, because each instruction performed several
                           operations.


                           14.8.2 Reduced Instruction Set Computing (RISC)
                           Many of the advantages of CISC processors were rendered unimportant by
                           advances in hardware technology and compiler design. In addition, designers real-
                           ized that the microcode required to interpret complex instructions slowed the exe-
                           cution of the simpler instructions. Various studies indicated that a large majority of
                           programs generated by popular compilers used only a small portion of their target
                           processors' instruction sets. For example, an IBM study observed that the 10 most
                           frequently executed instructions of the hundreds in the System/370 architecture
                           (Fig. 14.2) accounted for two-thirds of the instruction executions on that machine.70
                           The additional instructions incorporated into CISC instruction sets to improve soft-
                           ware development time were being used only infrequently. The simplest instrue-

<!-- pág. 717 -->

                                                          14.8 Performance Techniques in Processor Design 663

 tions to implement, such as register-memory transfers (loads and stores), were the
most commonly used.
       Another IBM study, a static analysis of assembly-language programs written
  for the IBM Series/1 computer, provided more evidence that large CISC instruction
sets might be inefficient. The study observed that programmers tended to generate
  "semantically equivalent instruction sequences" when working with the rich
machine language of the IBM Series/1. The authors concluded that since it is diffi-
cult to detect such sequences automatically, either instruction sets should be made
sparser, or programmers should restrict their use of instructions.71 These observa-
tions provided compelling motivation for the notion of reduced instruction set com-
puting (RISC). This processor-design philosophy emphasizes that computer
architects can optimize performance by concentrating then efforts on making com-
mon instructions, such as branches, loads and stores, execute efficiently.72, 73
       RISC processors execute common instructions efficiently by including rela-
tively few instructions, most of which are simple and can be performed quickly (i.e.,
in one clock cycle). This means that much of the programming complexity is moved
from the hardware to the compiler, which permits RISC processor design to be sim-
ple and to optimize for a small set of instructions. Furthermore, RISC control units
are implemented in hardware, which reduces execution overhead compared to
microcode. RISC instructions, which occupy fixed-length words in memory, are
faster and easier to decode than variable-length CISC instructions. Additionally,
RISC processors attempt to reduce the number of accesses to main memory by pro-
viding many high-speed general-purpose registers in which programs can perform
data manipulation.74
       Providing only simple, uniform-length instructions permits RISC processors
to make better use of pipelines than CISC processors do. Pipelined execution in
CISC architectures can be slowed by the longer processing times of complex

 Opcode                      Instruction                  % of Execution
 BC                          Branch Condition             20.2
 L                           Load                         15.5
 TM                          Test Under Mask              6.1
 ST                          Store                        5.9
 LR                          Load Register               4.7
 LA                          Load Address                 4.0
 LTR                         Test Register                3.8
 BCR                         Branch Register              2.9
 MVC                         Move Characters              2.1
 LH                          Load Half Word               1.8

Figure 14.2 | The 10 most frequently executed instructions on IBM's System/370
architecture.75 (Courtesy of International Business Machines Corporation.)

<!-- pág. 718 -->

664 Performance and Processor Design

                            instructions; these have the effect of idling sections of the pipeline handling simpler
                            instructions. Additionally, pipelines on CISC machines often contain many stages
                            and require complex hardware to support instructions of various lengths. Pipelines
                            in RISC architectures contain few stages and are relatively straightforward to
                            implement because most instructions require one cycle.76
                                  A simple and clever optimizing technique used in many RISC architectures is
                            called delayed branching.77' 78 When a conditional branch is executed, the next
                            sequential instruction might or might not be executed next, depending on the eval-
                            uation of the condition. Delayed branching enables this next sequential instruction
                            to enter execution anyway; then, if the branch is not taken, this next instruction can
                            be well along, if not completely finished. RISC optimizing compilers often rear-
                            range machine instructions so that a useful calculation (one that must be executed
                            regardless of whether the branch is taken) is placed immediately after the branch.
                            Because branching occurs more frequently than most people realize (as often as
                            every fifth instruction on some popular architectures), this can yield considerable
                            performance gains.79 Lilja provides a thorough analysis of delayed branching and
                            several other techniques that can greatly reduce the so-called branch penalty in
                            pipelined architectures.80
                                  The most significant trade-off in the RISC design philosophy is that its simple,
                            reduced instruction set and register-rich architecture increase context-switching
                            complexity.81 RISC architectures must save a large number of registers to main
                            memory during a context switch; this reduces context-switching performance com-
                            pared to CISC architectures due to an increased number of accesses to main mem-
                            ory. Because context switching is pure overhead and occurs frequently, this can
                            significantly impact system performance.
                                  In addition to increased context-switch time, there are other drawbacks to the
                            RISC design. One interesting study tested the effect of instruction complexity on
                            performance; the study selected three increasingly complex instruction subsets of
                            the VAX. The researchers reached several conclusions:82
                                 i. Programs written in the simplest of the instruction subsets required as much
                                    as 2.5 times the memory of equivalent complex instruction set programs.
                                 2. The cache miss ratio was considerably larger for programs written in the
                                    simplest subset.
                                 3. The bus traffic for programs written in the simplest subset was about dou-
                                    ble that of programs written in the most complex subset.
                                 These results and others like them indicate that RISC architectures can have
                            negative consequences.
                                 Floating point operations execute faster in CISC architectures. Additionally
                            CISC processors perform better for graphics or scientific programs, which repeatedly
                            execute complex instructions; these programs tend to perform better on CISC
                            machines with optimized complex instructions than on comparable RISC machines.83
                                  Figure 14.3 provides a summary comparison between the RISC and CISC
                            design philosophies. Examples of RISC processors include the UltraSPARC

<!-- pág. 719 -->

                                                                  14.8 Performances Techniques in Processor Design 665

                                   Characteristics of CISC Characteristics of RISC
  Category                         Processors                     Processors
  Instruction length               Variable, typically 1 to 10    Fixed, typically 4 bytes.
                                   bytes.
  Instruction decode               Via microcode.                 In hardware.
  Number of instructions in        Many (typically several hun-   Few (typically less than one
  ISA                              dred), including many com-     hundred).
                                   plex instructions.
  Number of instructions per       Few.                           Many (often about 20 per-
  program                                                         cent more than for CISC).
  Number of        general-pur-    Often, few (e.g., eight in     Many (typically, 32).
  pose registers                   the   Intel   Pentium    4
                                   processor).84
  Complexity                       In hardware.                   In the compiler.
  Ability to exploit parallelism   Limited.                       Broad.
  through pipelining
                                   Implement as many opera-       Make the common case
  Underlying philosophy            tions as possible.             fast.
                                   Pentium, Athlon.               MIPS, SPARC, G5.
  Examples
Figure 14.3 | RISC and CISC comparison.

(www.sun.com/processors), MIPS (www.mips.com) and G5 (www.apple.com/
powermac/specs.html) processors.


Self Review
1. Why do RISC processors exploit pipelines better than CISC processors?
2. Why does context switching require more overhead on RISC than on CISC processors?
Ans: 1) RISC instructions are of fixed length and generally require one cycle to execute, so
it is easy to overlap instructions such that most stages in the pipeline are performing mean-
ingful work. The variable-length instructions of CISC processors have the effect of idling sec-
tions of the pipeline not needed for simple instructions. 2) RISC processors contain many
more registers than CISC processors, requiring a greater number of memory transfers during
a context switch.




14.8.3 Post-RISC Processors
As RISC and CISC processors have evolved, many techniques that were developed
to independently increase the performance of one or the other have been inte-
grated into both architectures.85, 86, 87 Many of these features add complexity to the
instruction set or place more responsibility on the hardware to optimize perfor-
mance. This convergence of architectures has blurred the line between RISC and
CISC. The philosophy behind these processors is to increase performance in any

<!-- pág. 720 -->

666   Performance and Processor Design

                             way possible, leading Severance et al. to coin the term fast instruction set comput-
                             ing (FISC). Other commonly used names for this modern processor design philoso-
                             phy are "post-RISC" and "second-generation RISC." 88
                                    However, some designers adhere to the traditional terminology, "RISC" and
                             "CISC." This school of thought—that the two types of processors have not
                             converged—argues that RISC and CISC refer specifically to the ISA and not to
                             how the ISA is implemented (i.e., additional hardware complexity is irrelevant).
                             Further, they argue that the primary difference is that RISC instructions are of a
                             uniform length and generally execute in one cycle, unlike CISC instructions. As we
                             see in this section, most of the convergence results from the growing similarity of
                             complex hardware in RISC and CISC machines and the expansion of the number
                             of instructions in RISC ISAs, two aspects which these designers argue are not cen-
                             tral to ISA design philosophies. 89
                                    The sections that follow describe many techniques that post-RISC processors
                             employ to improve processor performance. As we will see, these techniques cause
                             processor hardware to be more complex, which increases cost and strays from the
                             RISC tenet of keeping hardware simple.


                             Superscalar Architecture
                             Superscalar execution enables more than one instruction to be executed in parallel
                             during each clock cycle. Superscalar architectures include multiple execution units on
                             a single chip and, until recently, were primarily used in CISC processors to reduce the
                             time required to decode complex instructions. Today, superscalar execution is found
                             in almost all general-purpose processors, because the parallelism that it allows
                             increases performance. For example, both the Pentium 4 and G5 processors are
                             superscalar. These architectures contain complicated hardware that ensures no two
                             instructions executing simultaneously depend on each other. For example, when a
                             processor executes the machine-code equivalent of an if...then...else control
                             structure, the instructions inside the then and el se clauses cannot be executed until
                             the processor has determined the value of the branch condition.90, 91, 92

                             Out-of-Order Execution (OOO)
                             Out-of-order execution (OOO) is a technique that dynamically reorders instruc-
                             tions at runtime to optimize performance by isolating groups of instructions that
                             can execute simultaneously. OOO facilitates deep pipelines and superscalar design,
                             which require the processor or compiler to detect groups of independent instruc-
                             tions that can be executed in parallel.93, 94
                                   Such a mechanism, now common to both RISC and CISC processors, breaks
                             with the RISC philosophy of leaving optimization to the compiler. OOO requires
                             significant additional hardware to detect dependencies and handle exceptions
                             When an instruction raises an exception, the processor must ensure that the pro-
                             gram is in the state in which it would have been after the exception if the instruc-
                             tions had been executed in order.95, 96

<!-- pág. 721 -->

                                                             14.8 Performance Techniques in Processor Design 667

Branch Prediction
Branch prediction is a mechanism whereby a processor uses heuristics to determine
the most probable result of a branch condition. The processor places instructions
that are predicted to execute into the pipeline for immediate processing after the
branch. If the processor guesses incorrectly, it must remove the predicted code from
the pipeline, losing all work performed on that code. This case is slightly worse than
the alternative, which is to wait until the result of a branch to fill the pipeline. How-
ever, if the processor guesses correctly, performance increases, because the proces-
sor can continue to execute instructions immediately after the branch. To achieve
high performance using branch prediction, the processor must contain accurate
branch prediction units, which also contribute to hardware complexity.97'98

On-Chip Floating-Point and Vector Processing Support
Many modern processors contain on-chip execution units called coprocessors.
Designers optimize coprocessors to perform specific operations that the general-
purpose arithmetic and logic units (ALUs) execute slowly. These include floating
point coprocessors and vector coprocessors. Vector coprocessors execute vector
instructions, which operate on a set of data, applying the same instruction to each
item in the set (e.g., adding one to each element in an array). Placing these copro-
cessors on the processor's chip decreases the communication latency between the
processor and its coprocessors, dramatically increasing the speed with which these
operations are performed, but also increases hardware complexity."

Additional Infrequently-Used Instructions
Perhaps the most significant divergence from the RISC philosophy is the expansion
of the instruction sets in today's so-called RISC processors. These ISAs tend to
include any instruction that enhances overall performance, regardless of the hard-
ware complexity required to execute that instruction.100 For example, the Apple
PowerMac G5 processor, referred to by many as a RISC processor, contains over a
hundred more instructions than its ancestor, the G3. These instructions typically
manipulate large (i.e., 128-bit) integers or perform the same instruction on multiple
data units, a technique called vector processing.101

CISC convergence to RISC
As RISC hardware has become more complex, CISC processors have adopted
components of the RISC philosophy. For example, today's CISC processors often
contain an optimized core subset of commonly used instructions that are decoded
and executed quickly to enable performance comparable to that of RISC when
complex instructions are not employed. In fact, the Intel Pentium 4 decodes all
instructions into simple, fixed-size micro-ops before sending them to the execution
unit. Often, the only reason that some complex instructions remain in a CISC ISA
is to provide backward compatibility with code written for older versions of a CISC
processor.102 In this way, CISC processors incorporate the benefits of simpler
instructions advocated by the RISC philosophy.

<!-- pág. 722 -->

668 Performance and Processor Design

                           Self Review
                           1. Despite increased additional hardware complexity, what is the primary characteristic that
                              distinguishes today's RISC processors from CISC processors?
                           2. (T/F) RISC processors are becoming more complex while CISC processors are becoming
                              simpler.
                          Ans: 1) Most of today's RISC processors continue to provide instructions of uniform length
                          that require a single clock cycle to execute. 2) False. RISC processors are indeed becoming
                          more complex. Although CISC processors incorporate RISC design philosophies, their hard-
                          ware complexity continues to increase.


                           14.8.4      Explicitly      Parallel       Computing         (EPIC)
                           Techniques such as superscalar design, deep pipelines and OOO enable post-RISC
                           processors to exploit parallelism. The hardware required to implement these fea-
                           tures while accounting for dependencies across multiple execution units can
                           become prohibitively expensive. In response, designers at Intel and Hewlett Pack-
                           ard proposed a new design philosophy called Explicitly Parallel Instruction Com-
                           puting (EPIC). EPIC attempts to simplify processor hardware to enable a high
                           degree of parallelism. The EPIC philosophy requires that the compiler, not hard-
                           ware, determines which instructions can be performed in parallel. This technique
                           exploits instruction-level parallelism (ILP), which refers to sets of machine instruc-
                           tions that can be executed in parallel (i.e., the instructions in the set do not rely on
                           one another to execute).
                                 To support ILP, EPIC employs a variation of the very long instruction word
                           (VLIW) method.103 In the VLIW method, the compiler determines which instruc-
                           tions should be executed in parallel. This simplifies hardware, allowing more room
                           for execution units; the Multiflow computer, the first VLIW machine, had 28 execu-
                           tion, which is substantially more than modern superscalar processors.104 However,
                           some dependencies are known only at execution time (e.g., because of branch
                           instructions), but VLIWs form the execution path before the program executes.
                           This limits the level of parallelism VLIW designs can exploit.105
                                 EPIC borrows from both VLIW processor designs and superscalar processor
                           designs. EPIC processors assist the compiler by providing predictability—no out-of-
                           order execution is used, allowing EPIC compilers to optimize the most likely execu-
                           tion path or paths. However, it is often difficult for a compiler to optimize even-
                           path of execution in a program. If the path of execution is incorrectly predicted, the
                           processor ensures program correctness (e.g., by checking data dependencies).106
                                 Typical RISC and CISC processors employ branch prediction to probabilisti-
                           cally determine the result of a branch. Instead, EPIC processors execute all possible
                           instructions that could follow a branch in parallel and use only the result of the cor-
                           rect branch once the predicate (i.e., the branch comparison) is resolved.107 This
                           technique is called branch predication.
                                 Figure 14.4 illustrates the difference between program execution in an EPIC
                           processor versus a post-RISC processor. In Fig. 14.4(a), the EPIC compiler has pro-

<!-- pág. 723 -->

                                                            14.8 Performance Techniques in Processor Design 669




Figure 14.4 | Instruction execution in an (a) EPIC processor and (b) post-RISC
processor.

duced a multi-op instruction, which is a package of a number of instructions that can
be executed in parallel; the number depends on the processor. The processor decodes
this multi-op into a number of single operations, then executes each simultaneously
on several execution units. Because EPIC processors assist the compiler by providing
predictability guarantees, they do not reorder multi-op instructions, and no OOO unit
is needed. In Fig. 14.4(b), the post-RISC processor analyzes the instruction stream
that it is executing and reorders instructions to find two instructions that can execute
simultaneously. The processor places these two instructions into its two execution
units (using a superscalar architecture) for simultaneous execution.
      Aside from improving performance through parallelism, EPIC processors
employ speculative loading, a technique that attempts to reduce memory latency.
When optimizing program code, the compiler converts each load instruction to a
speculative load operation and a verifying load operation. A speculative load
retrieves from memory data specified by an instruction that has yet to be executed.
Therefore, the processor can execute a speculative load well before the actual data

<!-- pág. 724 -->

670 Performance and Processor Design

                                     is needed. The verifying load ensures that the data from the speculative load is con-
                                     sistent (i.e., the value that was speculatively loaded has not been modified in mem-
                                     ory). The processor can execute at full efficiency if the verifying load validates the
                                     speculative load, eliminating much of the cost of memory access. However, if the
                                     verifying load determines that the speculative load is inconsistent, the processor
                                     must wait while the correct data is retrieved from memory 108

                                     Self Review
                                     1. What is a motivation behind the EPIC design philosophy?
                                     2. How do EPIC ISAs reduce the performance cost of branching?
                                     Ans: 1) Superscalar designs do not scale well, because exponentially more hardware is
                                     needed for each additional processing unit. EPIC attempts to move the complexity into the
                                     compiler to exploit ILP. 2) EPIC compilers specify branch predication to execute both possi-
                                     ble paths of execution after a branch. After the branch is performed, one path is discarded
                                     and the other is immediately ready to execute.



Web Resources
www.opersys.com/LTT/                                               arstechnica.com/cpu/4q99/risc-cisc/rvc-1.html
Provides a trace toolkit for Linux.                                Ars Technica is a Web site that publishes technical articles
www.eecs.harvard.edu/~vino/perf/hbench/                            about computers, aimed at educating consumers. This article
Provides information on hbench, which is a microbenchmark          contains information on RISC and CISC design philosophies
suite. The site includes a link to download a copy of the suite,   and characteristics of post-RISC processors.
documentation and related technical publications.                  www.intel.com/products/server/processors/server/
www.specbench.org                                                  Itanium/
SPEC is an organization that develops standard benchmarks.         Describes the Intel Itanium processor, one of the first commer-
Its Web site describes a number of benchmarks (called SPEC-        daily available EPIC processors.
marks) used to evaluate a variety of systems and publishes the     www.bapco.com
results of tests with these benchmarks on real systems.            BAPCo is an organization that develops standard benchmarks,
www.veritest.com/benchmarks/default.asp?visitor=                   such as the popular SYSMark for processors. Its Web site
VeriTest provides computer system evaluation services. This        describes its benchmarks in detail.
page from its Web site provides excellent information on several   www.linuxjournal.com/article.php?sid=2396
commercially available benchmarks and synthetic programs.          Describes performance monitoring in Linux.


Summary
The performance of a system depends heavily on its hard-           Some performance results may be deceptive if the evalua-
ware, operating system and the interaction between the             tion does not use a representative workload or focuses on a
two. Cumbersome software causes poor performance, even             small part of the system.
on systems with powerful hardware, so it is important to                  A trace is a record of system activity—typically a log
consider a system's software performance as well as its            of user and application requests to the operating system. A
hardware performance.                                              profile records the activity of a system when executing in
      Three common purposes for performance evaluation             kernel mode. These techniques are useful in evaluating sys-
are selection evaluation, performance projection and per-          terns whose workload depends heavily on the system's exe-
formance monitoring. Some common performance mea-                  cution environment.
sures are turnaround time, response time, system reaction                 Timings are useful for performing quick comparisons
time, variance in response time, throughput and capacity.          in hardware. Timings measure how many instructions a sys-

<!-- pág. 725 -->

                                                                                                            Key Terms 671

     tem can execute per second. Similarly, microbenchmarks        (or underutilized) a resource is. With negative feedback,
      permit evaluators to make quick comparisons between          the arrival rate of requests at that resource might decrease;
    operating systems (or systems as a whole). A microbench-       with positive feedback, the arrival rate might increase.
     mark measures how long an operating system operation                 A processor's instruction set architecture (ISA) is an
   (e.g., process creation) takes.                                 interface that describes the processor, including its instruc-
         An application-specific evaluation enables organiza-      tion set, number of registers and memory size. The ISA is
    tions and consumers to determine whether a particular sys-     like an API that low-level software uses to construct exe-
   tem is appropriate for a particular installation. The vector-   cutable programs.
  --sed methodology uses a weighted average of various                    CISC ISAs tend to include a large number of instruc-
   microbenchmark results suited to a particular application.      tions, many of which require multiple cycles to execute;
  The hybrid methodology uses a trace to determine the rela-       instruction length is variable. Many CISC implementations
 tive weights for each primitive in the average. A kernel pro-     have few general-purpose registers and complex hardware.
 gram is a typical program that might be run at an                 CISC processors became popular because they reduced
  installation; it is executed "on paper" using manufacturers'     memory cost and facilitated assembly-language program-
  instruction timing estimates.                                    ming.
         Analytic models are mathematical representations of              RISC ISAs tend to include a small number of instruc-
computer systems or their components. A large body of              tions, most of which execute in one cycle; instruction length
mathematical results exists that evaluators can apply in           is fixed. Many RISC implementations have a large number
  order estimate the performance of a given computer sys-          of general-purpose registers and simple hardware. They
 tem or component quickly and fairly accurately.                   optimize the most-common instructions. RISC processors
         A benchmark is a real program that an evaluator exe-      became popular because they use pipelines efficiently and
cutes on the machine being evaluated. Several organizations        eliminate cumbersome hardware, both of which improve
have developed industry-standard benchmarks targeted to            performance.
different kinds of systems. Evaluators use the results from               Today, RISC and CISC designs are converging,
running these benchmarks to compare systems. Benchmarks            prompting many to call these modern processors post-
should be repeatable, accurately reflect the types of applica-     RISC, FISC or second-generation RISC. Still, some main-
tions that will be executed and be widely used.                    tain that this is not the case and that the terms RISC and
         Synthetic programs are artificial programs that evalu-    CISC are still important. This convergence stems from
ate a specific component of an operating system; they              increased hardware complexity and extra infrequently used
might be constructed to match the instruction frequency            instructions in RISC processors and from the fact that
distribution of a large set of programs. Synthetic programs        CISC processors often include an optimized core of RISC-
are useful in development environments; as new features            like instructions.
become available, synthetic programs can be used to test                  EPIC, a newer processor-design philosophy, attempts
that these features are operational.                               to address the limited scalability of superscalar designs.
         Simulation is a technique in which an evaluator           EPIC processors place the responsibility on the compiler to
develops a computerized model of the target system. The            determine the path of execution and use their many execu-
simulation is run to determine how a system might perform          tion units to support a high degree of parallelism. EPIC
when it has been built.                                            processors also reduce the penalty for main memory
         Performance monitoring is the collection and analysis     accesses by performing speculative loads before execution
of system performance information for existing systems. A          of a load instruction; the processor performs a verifying
resource becomes a bottleneck when it hinders the                  load when the instruction is executed, ensuring data integ-
progress of the system because it cannot do its job effi-          rity. If the data that was speculatively loaded has not
ciently. A resource becomes saturated when it has no               changed, then no action is taken as a result of the verifying
excess capacity to fulfill new requests. In a feedback loop,       load; otherwise, the processor reexecutes the instruction
information is reported to the system about how saturated          using data from the verifying load.

Key Terms
absolute performance measure—Measure of the efficiency                 by an absolute quantity such as the amount of time in
    with which a computer system meets its goals, described            which a system executes a certain benchmark. This con-

<!-- pág. 726 -->

672 Performance and Processor Design

    trasts with relative performance measures such as ease of         incorporate single instructions that perform several oper-
    use, which only can be used to make comparisons                   ations.
    between systems.                                              delayed branching—Optimization technique for pipelined pro-
analytic model—Mathematical representation of a computer              cessors in which a compiler places directly after a branch
    system or component of a computer system for the pur-             an instruction that must be executed whether or not the
    pose of estimating its performances quickly and relatively        branch is taken; the processor begins executing this
    accurately.                                                       instruction while determining the outcome of the branch.
application vector—Vector that contains the relative demand       Dhrystone—Classic synthetic program that measures how
    on operating system primitives by a particular application,      effectively an architecture runs systems programs.
    used in an application-specific performance evaluation.
                                                                  dispersion—Measure of the variance of a random variable.
arrival rate—Rate at which new requests are made for a
     resource.                                                    distribution of response times—Set of values describing the
                                                                       response times for jobs in a system and the relative fre-
benchmark—Real program that an evaluator executes on the
                                                                       quencies with which those values occur.
    system being evaluated to determine how efficiently the
    system executes that program; benchmarks are used to          ease of use—Measure of the comfort and convenience associ-
    compare systems.                                                  ated with system use.
BIPS (billion instructions per second)—Unit commonly used         event-driven simulator—Simulator controlled by events that
   to categorize the performance of a particular computer; a          are made to occur according to probability distributions.
   rating of one BIPS means a processor can execute one bil-      expected value—Sum of a series of values each multiplied by
   lion instructions per second.                                      its respective probability of occurrence.
bottleneck—Resource that hinders the progress of the system
                                                                  Explicitly Parallel Instruction Computing (EPIC)—Processor-
     because it cannot do its job efficiently.
                                                                      design philosophy whose goals are to provide a high
branch penalty—Performance loss in pipelined architectures            degree of instruction-level parallelism, reduce processor
    associated with a branch instruction; this occurs when a          hardware complexity and improve performance.
    processor cannot begin processing the instruction after
                                                                  family of computers—Series of computers that are compatible
    the branch until the processor knows the outcome of the
                                                                      in that they can run the same programs.
    branch. The branch penalty can be reduced by using
    delayed branching, branch prediction or branch predica-       fast instruction set computing (FISC)—Term describing the
    tion.                                                              processor-design philosophy resulting from the conver-
branch predication—Technique used in EPIC processors                   gence of RISC and CISC design philosophies. The FISC
    whereby a processor executes all possible instructions that        design philosophy stresses inclusion of any construct that
    could follow a branch in parallel and uses only the result         improves performance.
    of the correct branch once the predicate (i.e., the branch    feedback loop—Technique in which information about the
    comparison) is resolved.                                          current state of the system can influence the number of
branch prediction—Technique whereby a processor uses heu-             requests arriving at a resource (e.g., positive and negative
    ristics to determine the most probable result of a branch         feedback loops).
    in code; when the processor predicts correctly, perfor-       Hartstone—Popular synthetic benchmark used to evaluate
    mance increases, because the processor can continue to            real-time systems.
    execute instructions immediately after the branch.
                                                                  hbench microbenchmark suite—Popular microbenchmark
Business Application Performance Corporation (BAPCo) —                suite, which enables evaluators to effectively analyze the
    Organization that develops standard benchmarks, such as           relationship between operating system primitives and
    the popular SYSMark for processors.                               hardware components.
capacity—Measure of the maximum throughput a system can
                                                                  hybrid methodology—Performance evaluation technique that
    attain, assuming that whenever the system is ready to
                                                                      combines the vector-based methodology with trace data
    accept more jobs, another job is immediately available.
                                                                      to measure performance for applications whose behavior
complex instruction set computing (CISC)—Processor-design             depends strongly on user input.
   philosophy, emphasizing expanded instruction sets that

<!-- pág. 727 -->

                                                                                                              Key     Terms     673

 Imbench microbenchmark—Microbenchmark suite that                        reorders instructions to isolate groups of independent
     enables evaluators to measure and compare system per-               instructions for parallel execution.
     formance on a variety of UNIX platforms.                        performance monitoring—Collection and analysis of system
instruction-level parallelism (ILP)—Parallelism that permits              performance information for existing systems; the infor-
     two machine instructions to be executed at once. Two                 mation includes a system's throughput, response times,
     instructions exhibit ILP if the execution of one does not            predictability, bottlenecks, etc.
     affect the outcome of the other (i.e., the two instructions     performance projection—Estimate of the performance of a
     do not depend on each other).                                        system that does not exist, useful for deciding whether to
instruction set—Set of machine instructions a processor can               build that system or to modify an existing system's design.
     perform.                                                        positive feedback—Data informing the system that a resource
instruction set architecture (ISA)—Interface exposed by a                 has excess capacity, so the processor can increase the
     processor that describes the processor, including its                arrival rate for requests at that resource.
     instruction set, number of registers and memory size.           predicate—Logical decision made on a subject (e.g., a branch
IOStone—Popular synthetic benchmark that evaluates file sys-             comparison).
     tems.                                                           predictability—Measure of the variance of an entity, such as
kernel program—Typical program that might be run at an                   response time. Predictability is particularly important for
     installation; it is executed "on paper" using manufactur-           interactive systems, where users expect predictable (and
     ers' instruction timings and used for application-specific          short) response times.
     performance evaluation.                                         production program—Program that is run regularly at an
mean—Average of a set of values.                                         installation.
micro-op—Simple, RISC-like instruction that is the only type         profile—Record of kernel activity taken during a real session,
     of instruction processed by a Pentium processor; the Pen-           which indicates the operating system functions that are
     tium's instruction decoder converts complex instructions            used most often and should therefore be optimized.
     into a series of micro-ops.                                     random variable—Variable that can assume a certain range of
microbenchmark—Performance evaluation tool that measures                 values, where each value has an associated probability.
     the speed of a single operating system operation (e.g.,         reduced instruction set computing (RISC)—Processor-design
     process creation).                                                  philosophy that emphasizes small, simple instructions sets
microbenchmark suite—Program that consists of a number of                and optimization of the most-frequently used instructions.
     microbenchmarks, typically used to evaluate many impor-         response time—In an interactive system, the time from when a
     tant operating system operations.                                   user presses an Enter key or clicks a mouse until the sys-
MIPS (million instructions per second)—Unit commonly used                tem delivers a final response.
     to categorize the performance of a particular computer; a       saturation—Condition of a resource that has no excess capac-
     rating of one MIPS means a processor can execute one                ity to fulfill new requests.
     million instructions per second.
                                                                     script-driven simulator—Simulator controlled by data care-
MobileMark—Popular benchmark for evaluating systems                       fully designed to reflect the anticipated environment of
     installed on mobile devices developed by Business Appli-             the simulated system; evaluators derive this data from
     cation Performance Corporation (BAPCo).                              empirical observations.
multi-op instruction—Instruction word used by an EPIC sys-           selection evaluation—Analysis regarding whether obtaining a
     tem in which the compiler packages a number of smaller               computer system or application from a particular vendor
     instructions for the processor to execute in parallel.               is appropriate.
negative feedback—Data informing the system that a resource          service rate—Rate at which requests are completed by a
     is having difficulty servicing all requests and the processor        resource.
     should decrease the arrival rate for requests at that
                                                                     simulation—Performance evaluation technique in which an
     resource.
                                                                         evaluator develops a computerized model of a system
out-of-order execution (OOO)—Technique in which a proces-                being evaluated. The model is then run to reflect the
     sor analyzes a stream of instructions and dynamically               behavior of the system being evaluated.

<!-- pág. 728 -->

674    Performance and Processor Design

SPECmark—Standard benchmark for testing systems; SPEC-               TIPS (trillion instructions per second)—Unit used to catego-
   marks are published by the Standard Performance Evalu-                rize the performance of a particular computer; a rating of
   ation Corporation (SPEC).                                             one TIPS means a processor can execute one trillion
speculative loading—Technique whereby a processor retrieves              instructions per second.
    from memory data specified by an instruction that has yet        trace (performance evaluation)—Record of real system activ-
    to be executed; when the instruction is executed, the pro-            ity, which is executed on systems to test how the system
    cessor performs a verifying load to ensure the data's con-            handles a sample workload.
    sistency.
                                                                     Transaction Processing Performance Council (TPC) bench-
stability—Condition of a system that functions without error             marks—Popular benchmarks which target database sys-
     or significant performance degradation.                             tems.
Standard Application (SAP) benchmarks—Popular bench-
                                                                     turnaround time—Time from when a job is submitted until the
    marks used to evaluate a system's scalability.
                                                                         system completes executing it.
Standard Performance Evaluation Corporation (SPEC)—
                                                                     utilization—Fraction of time that a resource is in use.
    Organization that develops standard, relevant bench-
    marks (called SPECmarks), which are used to evaluate a           validate a model—To demonstrate that a computer model is
    variety of systems; SPEC publishes the results of tests               an accurate representation of the real system the model is
    with these benchmarks on real systems.                                simulating.
STREAM—Popular synthetic benchmark which tests the                   variance in response times—Measure of how much individual
   memory subsystem.                                                      response times deviate from the mean response time.
superscalar architecture—Technique in which a processor con-         vector-based methodology—Method of calculating an applica-
    tains multiple execution units so that it can execute more            tion-specific evaluation of a system based on the weighted
    than one instruction in parallel per clock cycle.                     average of the microbenchmark results for the. target sys-
synthetic benchmark—Another name for a synthetic program.                 tem's primitives; the weights are determined by the the
synthetic program—Artificial program used to evaluate a spe-              target application's relative demand for each primitive.
    cific component of a system or constructed to mirror the         very long instruction word (VLIW)—Technique in which a
    characteristics of a large set of programs.                          compiler chooses which instructions a processor should
SYSmark benchmark—Popular benchmark for desktop sys-                     execute in parallel and packages them into a single (very
   tems developed by Business Application Performance                    long) instruction word; the compiler guarantees that there
   Corporation (BAPCo).                                                  are no dependencies between instructions that the proces-
                                                                         sor executes at the same time.
system reaction time—Time from when a job is submitted to a
     system until the first time slice of service is given to that   WinBench 99—Popular synthetic program used extensively
     job.                                                               today in testing a system's graphics, disk and video subsys-
system tuning—Process of making fine adjustments to a sys-              tems in a Microsoft Windows environment.
     tem based on performance monitoring to optimize the             WebMark—Popular benchmark for Internet performance
     system's execution for a specific operating environment.           developed by Business Application Performance Corpo-
system vector—Vector containing the results of microbench-              ration (BAPCo).
     marks for a number of operating system primitives for a         Whetstone—Classic synthetic program which measures how
     specific system, used in an application-specific evaluation.       well systems handle floating point calculations, and has
throughput—Work-per-unit-time performance measurement.                  thus been helpful in evaluating scientific programs.
timing—Raw measure of an isolated hardware performance               workload—Measure of the amount of work that has been sub-
    metric, such as a BIPS rating, used for quick comparisons            mitted to a system; evaluators determine typical workloads
    between systems.                                                     for a system and evaluate the system using these workloads.



Exercises
14.1 Explain why it is important to monitor and evaluate the         14.2 When a user logged in, some early timesharing systems
performance of a system's software as well as its hardware.          printed the total number of logged-in users.

<!-- pág. 729 -->

                                                                                                              Exercises         675

      a. Why was this information useful to the user?               14.10 What performance measure(s) is (are) of greatest inter-
      b. In what circumstances might this not have been a           est to each of the following? Explain your answers.
         useful indication of load?                                       a. an interactive user
      c. What factors tended to make this a highly reliable              b. a batch-processing user
         indication of system load on a timesharing system                c. a designer of a real-time process control system
         that supported many users?
                                                                          d. installation managers concerned with billing users for
14.3 Briefly discuss each of the following purposes for perfor-              resource usage
mance evaluation.
                                                                          e. installation managers concerned with projecting sys-
      a. selection evaluation                                                tem loads for the next yearly budget cycle
      b. performance projection                                           f. installation managers concerned with predicting the
      c. performance monitoring                                              performance improvements to be gained by adding
14.4 What is system tuning? Why is it important?                             i.    memory
14.5 Distinguish between user-oriented and system-oriented                   ii.   faster processors
performance measures.                                                        iii. disk drives
14.6 What is system reaction time?                                  14.11 There is a limit to how many measurements should be
      Is it more critical to processor-bound or I/O-bound jobs?     taken on any system. What considerations might cause you to
Explain your answer.                                                avoid taking certain measurements?
14.7 In discussing random variables, why can mean values            14.12 Simulation is viewed by many as the most widely appli-
sometimes be deceiving?                                             cable performance evaluation technique.
     What other performance measure is useful in describing               a. Give several reasons for this.
how closely the values of a random variable cluster about its
                                                                         b. Even though simulation is widely applicable, it is not
mean?
                                                                            as widely used as one might expect. Give several rea-
14.8 Why is predictability such an important attribute of                   sons why.
computer systems?
                                                                    14.13 Some of the popular performance evaluation and moni-
     In what types of systems is predictability especially criti-
                                                                    toring techniques are
cal?
                                                                             i.    timings
14.9 Some commonly used performance measures follow.
                                                                             ii.   microbenchmarks
         i.    turnaround time
                                                                             iii. synthetic programs
         ii.   throughput
                                                                             iv.   vector-based methodology
         iii. response time
                                                                             v.    simulations
         iv. workload
                                                                             vi. kernel programs
         v.    system reaction time
                                                                             vii. hardware monitors
         vi. capacity
                                                                             viii. analytic models
         vii. variance of response times
                                                                             ix. software monitors
         viii. utilization
                                                                             x.    benchmarks
     For each of the following, indicate which performance
measure(s) is (are) described.                                            Indicate which of these techniques is best defined by
                                                                    each of the following. (Some items can have more than one
      a. the predictability of a system                             answer.)
      b. the current demands on a system                                  a. their validity might be jeopardized by making sim-
      c. a system's maximum capabilities                                     plfying assumptions
      d. the percentage of a resource in use                             b. weighted average of instruction timings
      e. the work processed per unit time                                 c. produced by skilled mathematicians
      f. turnaround time in interactive systems                           d. models that are run on a computer

<!-- pág. 730 -->

676 Performance and Processor Design
     e. useful for quick comparisons of "raw horsepower"         14.15 On one computer system, the processor contains a BIPS
        for hardware                                             meter that records how many billion instructions per second
     f. particularly valuable in complex software environ-       the processor is performing at any instant in time. The meter is
        ments                                                    calibrated from 0 to 4 BIPS in increments of 0.1 BIPS. All of
                                                                 the workstations to this computer are currently in use. Explain
     g. a real program executed on a real machine
                                                                 how each of the following situations might occur.
     h. useful for determining the performance of operating
                                                                       a. The meter reads 3.8 BIPS and the terminal users are
        system primitives
                                                                          experiencing good response times.
     i.    custom-designed programs to exercise specific fea-
                                                                       b. The meter reads 0.5 BIPS and the terminal users are
          tures of a machine
                                                                          experiencing good response times.
     j.   a real program "executed on paper"
                                                                       c. The meter reads 3.8 BIPS and the terminal users are
     k. a production program                                              experiencing poor response times.
     1.    most commonly developed by using the techniques             d. The meter reads 0.5 BIPS and the terminal users are
          of queuing theory and Markov processes                          experiencing poor response times.
     m. often used when it is too costly or time consuming to    14.16 You are a member of a performance evaluation team
        develop a synthetic program                              working for a computer manufacturer. You have been given
14.14 What performance evaluation techniques are most            the task of developing a generalized synthetic program to facil-
applicable in each of the following situations? Explain your     itate the evaluation of a completely new computer system with
answers.                                                         an innovative instruction set.
     a. An insurance company has a stable workload consist-            a. Why might such a program be useful?
        ing of a large number of lengthy batch-processing              b. What features might you provide to make your pro-
        production runs. Because of a merger, the company                 gram a truly general evaluation tool?
        must increase its capacity by 50 percent. The com-
        pany wishes to replace its equipment with a new com-     14.17 Distinguish between event-driven and script-driven sim-
        puter system.                                            ulators.
     b. The insurance company described in (a) wishes to         14.18 What does it mean to validate a simulation model?
        increase capacity by purchasing some additional                How might you validate a simulation model of a small
        memory and channels.                                     timesharing system (which already exists) with disk storage,
                                                                 several CRT terminals, and a shared laser printer?
     c. A computer company is designing a new, ultrahigh-
        speed computer system and wishes to evaluate sev-        14.19 What information might a performance evaluator get
        eral alternative designs.                                from an instruction execution trace?
     d. A consulting firm that specializes in commercial data          a module execution trace?
        processing gets a large military contract requiring            Which of these is more useful for analyzing the opera-
        extensive mathematical calculations. The company         tion of individual programs?
        wishes to determine if its existing computer equip-            for analyzing the operation of systems?
        ment will process the anticipated load of mathemati-     14.20 How can bottlenecks be detected?
        cal calculations.                                              How can they be removed?
     e. Management in charge of a multicomputer network                If a bottleneck is removed, should we expect a system's
        needs to locate bottlenecks as soon as they develop      performance to improve? Explain.
        and to reroute traffic accordingly.                      14.21 What is a feedback loop?
     f. A systems programmer suspects that one of the soft-            Distinguish between negative and positive feedback.
        ware modules is being called upon more frequently              Which of these contributes to system stability?
        than originally anticipated. The programmer wants to           Which could cause instability? Why?
        confirm this before devoting substantial effort to       14.22 Workload characterization is an important part of any
        recoding the module to make it execute more effi-        performance study. We must know what a computer is sup-
        ciently.                                                 posed to be doing before we can say much about how well it is
     g. An operating systems vendor needs to test all aspects    doing it. What measurements might you take to help charac-
        of the system before selling its product commercially.   terize the workload in each of the following systems?

<!-- pág. 731 -->

                                                                                                                Exercises       677

      a. a timesharing system designed to support program            believes that placing more than three processors on the system
         development                                                 would not be worthwhile and that the contention for memory
      b. a batch-processing system used for preparing                would be too great. What performance evaluation techniques
         monthly bills for an electric utility with half a million   would you recommend to help determine the optimal number
         customers                                                   of connections during the design stage of the project? Explain
                                                                     your answer.
      c. an advanced workstation used solely by one engineer
                                                                     14.24 Why are RISC programs generally longer than their
      d. a microprocessor implanted in a person's chest to
                                                                     CISC equivalents?
         regulate heartbeat
                                                                           Given this, why might RISC programs execute faster
      e. a local area computer network that supports a               than their CISC equivalents?
         heavily used electronic mail system within a large
         office complex                                              14.25 Compare branch prediction to branch predication.
                                                                           Which is likely to yield higher performance? Why?
      f. an air traffic control system for collision avoidance
                                                                     14.26 For each of the following features of modern processors,
      g. a weather forecasting computer network that
                                                                     describe how this feature improves performance and indicate
         receives temperature, humidity, barometric pressure
                                                                     why its inclusion in a processor strays from either a pure RISC
         and other readings from 10,000 grid points through-
                                                                     or pure CISC design.
         out the country over communications lines.
      h. a medical database management system that pro-                    a. superscalar architecture
         vides doctors around the world with answers to medi-              b. out-of-order execution (OOO)
         cal questions.
                                                                           c. branch prediction
      i.   a traffic control computer network for monitoring
           and controlling the flow of traffic in a large city             d. on-chip vector and floating point support
14.23 A computer system manufacturer has a new multipro-                   e. large instruction sets
cessor under development. The system is modularly designed
                                                                           f. decoding complex, multicycle instructions into sim-
so that users may add new processors as needed, but the con-
                                                                              pler, single-cycle instructions.
nections are expensive. The manufacturer must provide the
connections with the original machine because they are too           14.27 How do EPIC processors differ from post-RISC proces-
costly to install in the field. The manufacturer wants to deter-     sors?
mine the optimal number of processor connections to provide.               Given these differences, what could be a hindrance to
The chief designer says that three is optimal. The designer          the adoption of EPIC processors?

Suggested Projects
14.28 It is often difficult to measure performance in a system       14.31 Prepare a research paper on tools such as gprof to allow
without influencing the results. Prepare a research paper on         application developers to profile their software.
the various ways benchmarks minimize the effect they have on         14.32 Prepare a research paper surveying contemporary stud-
a system's performance.
                                                                     ies that compare RISC performance to CISC performance.
14.29 In recent years, graphics-rendering technology has             Describe the strengths and weaknesses of each design philoso-
improved at a phenomenal rate. Prepare a research paper on           phy in today's systems.
the architectural features that boost graphics card perfor-          14.33 In the text, it was indicated that one weakness of the
mance. Also discuss graphics card performance evaluation             RISC approach is a dramatic increase in context-switching
techniques.
                                                                     overhead. Give a detailed explanation of why this is so. Write a
14.30 Prepare a research paper on the IBM PowerPC 970 pro-           paper on context switching. Discuss the various approaches
cessor, which powers Apple's PowerMac G5 series. What type           that have been used. Suggest how context switching might be
of instruction set does it have? What other technology               handled efficiently in RISC-based systems.
improves the performance of this processor?

Suggested Simulations
14.34 Obtain versions of popular benchmarks or synthetic             mark. Run these on several computers and prepare a compari-
programs discussed in the text, such as SYSMark or a SPEC-           son of the results. Are your results similar to those published

<!-- pág. 732 -->

by the vendors? What factors might cause differences between                  10 minutes—10 percent of the jobs
the results? Describe your experience using these benchmarks                  30 minutes—10 percent of the jobs
and synthetic programs.                                                       60 minutes—10 percent of the jobs
14.35 In this problem, you will undertake a reasonably                        The load on the system is such that there is always at
detailed simulation study. You will write an event-driven simu-       least one job waiting to be initiated. Jobs are processed strictly
lation program using random-number generation to produce              first-come-first-served.
events probabilistically.                                                     Write a simulation program to help you decide which
        At one large batch-processing computer installation the       memory placement strategy should be used at this installation.
management wants to decide what memory placement strat-               Your program should use random-number generation to pro-
egy will yield the best possible performance. The installation        duce the memory requirement and execution time for each job
runs a computer with a large main memory that uses variable-          according to the distributions above. Investigate the perfor-
partition multiprogramming. Each user program runs in a sin-          mance of the installation over an eight-hour period by measur-
gle group of contiguous storage locations. Users state their          ing throughput, storage utilization, and other items of interest
memory requirement in advance, and the operating system               to you for each of the following memory placement strategies.
allocates each user the requested memory when the user's job                a. first fit
is initiated. A total of 1024MB of main memory is available for             b. best fit
user programs.
                                                                            c. worst fit
        The storage requirements of jobs at this installation are
distributed as follows.                                               14.36 At the installation described in the previous problem,
        10MB—30 percent of the jobs                                   management suspects that the first-come-first-served job
        20MB - 2 0 percent of the jobs                                scheduling might not be optimal. In particular, they are con-
        30MB—25 percent of the jobs                                   cerned that longer jobs tend to keep shorter jobs waiting. A
        40MB —15 percent of the jobs                                  study of waiting jobs indicates that there are always at least 10
        50MB —10 percent of the jobs                                  jobs waiting to be initiated (i.e., when 10 jobs are waiting and
        Execution times of jobs at this installation are indepen-     one is initiated, another arrives immediately). Modify your
dent of the jobs' storage requirements and are distributed as         simulation program from the previous exercise so that job
follows.                                                              scheduling is now performed on a shortest-job-first basis. How
        1 minute—30 percent of the jobs                               does this affect performance for each of the memory place-
        2 minutes—20 percent of the jobs                              ment strategies? What problems of shortest-job-first schedul-
        5 minutes—20 percent of the jobs                              ing become apparent?


Recommended Reading
Lucas's 1971 paper, "Performance Evaluation and Monitoring,"          information on commercial benchmarks. Patterson and Henne-
provides a survey of performance evaluation.109 A discussion of       sesy's Computer Organization and Design describes processor
recent trends in performance evaluation, particularly bench-          architecture.113 Stokes114 and Aletan 115 survey the histories and
marking, is found in The Seventh Workshop on Hot Topics in            philosophies of RISC and CISC processors. Flynn, Mitchell and
Operating Systems in the section entitled "Lies, Damn Lies, and       Mulder discuss some benefits of the CISC approach.116 Schlan-
Benchmarks."110, 111 The SPEC Web site (www.specbench.org)            sker and Rau explain the EPIC design philosophy.117 The bibli-
and the PC Magazine benchmarks from VeriTest Web site                 ography for this chapter is located on our Web site at
(www.veritest.com/benchmarks/default.asp) 1 1 2        provide        www.deitel.com/books/os3e/Bibliography.pdf.


Works Cited
 1. Mogul, J., "Brittle Metrics in Operating System Research," Pro-    4. Ferrari, D.; G. Serazzi; and A. Zeigner, Measurement and Tun-
    ceedings of the Seventh Workshop on Hot Operating System Top-         ing of Computer Systems, Englewood Cliffs, NJ: Prentice Hall,
    ics, March 1999, pp. 90-95.                                           1983.
 2. Lucas, H., "Performance Evaluation and Monitoring," ACM            5. Anderson, G., "The Coordinated Use of Five Performance Eval-
    Computing Surveys, Vol. 3, No. 3, September 1971, pp. 79-91.          uation Methodologies," Communications of the ACM, Vol 27,
 3. Lucas, H., "Performance Evaluation and Monitoring," ACM               No. 2, February 1984, pp. 119-125.
    Computing Surveys, Vol. 3, No. 3, September 1971, pp. 79-91.

<!-- pág. 733 -->

                                                                                                                    Works Cited 679
 6. Seltzer, M., et al., "The Case for Application-Specific Bench-       23. Kobayashi, H., Modeling and Analysis: An Introduction to System
    marking," Proceedings of the Seventh Workshop on Hot Topics in           Performance Evaluation Methodology, Reading, MA: Addison-
    Operating Systems, March 1999, pp. 105-106.                              Wesley, 1978.
 7. Seltzer, M., et al., "The Case for Application-Specific Bench-       24. Lazowska, E., "The Benchmarking, Tuning, and Analytic Model-
    marking," Proceedings of the Seventh Workshop on Hot Topics in           ing of VAX/VMS," Conference on Simulation, Measurement and
    Operating Systems, March 1999, pp. 105-106.                              Modeling of Computer Systems, August 1979, pp. 57-64.
 8. Spinellis, D., "Trace: A Tool for Logging Operating System Call      25. Sauer, C, and K. Chandy, Computer Systems Performance Mod-
    Transactions," ACM SIGOPS Operating System Review, October               eling, Englewood Cliffs, NJ: Prentice Hall, 1981.
    1994, pp. 56-63.                                                     26. Lucas, H., "Performance Evaluation and Monitoring," ACM
 9. Bull, J. M., and D. O'Neill, "A Microbenchmark Suite for                 Computing Surveys, Vol. 3, No. 3, September 1971, pp. 79-91.
    OpenMP 2.0," ACM SIGARCH Computer Architecture Notes,
                                                                         27. Hindin, H., and M. Bloom, "Balancing Benchmarks Against
    Vol. 29, No. 5, December 2001, pp. 41-48.
                                                                             Manufacturers' Claims," UNIX World, January 1988, pp. 42-50.
10. Keckler, S., et al., "Exploiting Fine-Grain Thread Level Parallel-
                                                                         28. Mogul, J., "Brittle Metrics in Operating System Research," Pro-
    ism on the MIT Multi-ALU Processor," Proceedings of the 25th
                                                                             ceedings of the Seventh Workshop on Hot Topics in Operating
    Annual International Symposium on Computer Architecture,
                                                                             Systems, March 1999, pp. 90-95.
    October 1998, pp. 306-317.
                                                                         29. "SpecWeb99," SPEC (Standard Performance Evaluation Corpo-
11. Brown, A., and M. Seltzer, "Operating System Benchmarking in
                                                                             ration), September 26,2003, <www.specbench.org/web99/>.
     the Wake of Lmbench: A Case Study on the Performance of Net-
    BSD on the Intel x86 Architecture," ACM SIGMETRICS Con-              30. Mogul, J., "Brittle Metrics in Operating System Research," Pro-
    ference on Measurement and Modeling of Computer Systems June             ceedings of the Seventh Workshop on Hot Operating System Top-
     1997, pp. 214-224.                                                      ics, March 1999, pp. 90-95.
12. McVoy, L., and C. Staelin, "lmbench: Portable Tools for Perfor-      31. Seltzer, M., et al., "The Case for Application-Specific Bench-
    mance Analysis," in Proceedings of the 1996 USENIX Annual                marking," Proceedings of the Seventh Workshop on Hot Topics in
     Technical Conference, January 1996, pp. 279-294.                        Operating Systems, March 1999, pp. 102-107.
13. Brown, A., and M. Seltzer, "Operating System Benchmarking in         32. "BAPCo Benchmark Products," BAPCo, August 5, 2002,
    the Wake of lmbench: A Case Study on the Performance of Net-             <www.bapco.com/products.htm>.
    BSD on the Intel x86 Architecture," ACM SIGMETRICS Con-              33. "Overview of the TPC Benchmark C," Transaction Processing
    ference on Measurement and Modeling of Computer Systems,                 Performance Council, August 12, 2003, <www.tpc.org/tpcc/
    June 1997; pp. 214-224.                                                  detail.asp>.
14. McVoy, L., and Staelin, C, "lmbench: Portable tools for Perfor-      34. "SAP Standard Application Benchmarks," August 12, 2003,
    mance Analysis," In Proceedings of the 1996 USENIX Annual                <www.sap.com/benchmark>.
     Technical Conference, January 1996, pp. 279-294.
                                                                         35. Bucholz, W., "A Synthetic Job for Measuring System Perfor-
15. Brown, A., and M. Seltzer, "Operating System Benchmarking in             mance," IBM Journal of Research and Development, Vol. 8, No.
    the Wake of Lmbench: A Case Study on the Performance of Net-             4,1969, pp. 309-308.
    BSD on the Intel x86 Architecture," ACM SIGMETRICS Con-
                                                                         36. Lucas, H., "Performance Evaluation and Monitoring," ACM
    ference on Measurement and Modeling of Computer Systems,
                                                                             Computing Surveys, Vol. 3, No. 3, September 1971, pp. 79-91.
    June 1997, pp. 214-224.
                                                                         37. Weicker, R., "Dhrystone: A Synthetic Systems Programming
16. Seltzer, M., et al., "The Case for Application-Specific Bench-
                                                                             Benchmark," Communications of the ACM, Vol. 21, No. 10,
    marking," Proceedings of the Seventh Workshop on Hot Topics in
                                                                             October 1984, pp. 1013-1030.
     Operating Systems, March 1999, pp. 105-106.
17. Seltzer, M., et al., "The Case for Application-Specific Bench-       38. Dronek, G., "The Standards of System Efficiency," Unix Review,
    marking," Proceedings of the Seventh Workshop on Hot Topics in           March 1985, pp. 26-30.
     Operating Systems, March 1999, pp. 105-106.                         39. Wilson, P., "Floating-Point Survival Kit," Byte, Vol. 21, No. 3,
18. Seltzer, M., et al., "The Case for Application-Specific Bench-           March 1988, pp. 217-226.
    marking," Proceedings of the Seventh Workshop on Hot Topics in       40. "WinBench," PC Magazine, September 2, 2003, <www.etest-
     Operating Systems, March 1999, pp. 102-107.                             inglabs.com/benchmarks/winbench/winbench.asp>.
19. Lucas, H., "Performance Evaluation and Monitoring," ACM              41. "IOStone: A Synthetic File System Benchmark," ACM
    Computing Surveys,Vol. 3, No. 3, September 1971, pp. 79-91.              SIGARCH Computer Architecture News, Vol. 18, No. 2, June
20. Lucas, H., "Performance Evaluation and Monitoring," ACM                  1990, pp. 45-52.
    Computing Surveys,Vol. 3, No. 3, September 1971, pp. 79-91.          42. "Hartstone: Synthetic Benchmark Requirements for Hard Real-
21. Lucas, H., "Performance Evaluation and Monitoring," ACM                  Time Applications," Proceedings of the Working Group on ADA
    Computing Surveys, Vol. 3, No. 3, September 1971, pp. 79-91.             Performance Issues, 1990, pp. 126-136.
22. Svobodova, L., Computer Performance Measurement and Evalua-          43. "Unix Technical Response Benchmark Info Page," May 17,2002,
    tion Methods: Analysis and Applications, New York: Elsevier, 1977.       <www.unix.ualberta.ca/Benchmarks/benchmarks.html>.

<!-- pág. 734 -->

680         Performance and Processor Design

44- Lucas, H., "Performance Evaluation and Monitoring," ACM                                       63. Stokes, J., "Ars Technica: RISC vs. CISC in the Post RISC Era."
    Computing Surveys, Vol. 3, No. 3, September 1971, pp. 79-91.                                      October 1999, <arstechnica.com/cpu/4q99/risc-cisc/rvc-
45. Nance, R., "The Time and State Relationships in Simulation                                        l.html>.
    Modeling," Communications of the ACM, Vol. 24, No. 4, April                                   64. Daily, S., "Killer Hardware for Windows NT," Windows IT
    1981, pp. 173-179.                                                                                Library, January 1998 <www.windowsitlibrary.com/Content/
46. Keller, R., and F. Lin, "Simulated Performance of a Reduction-                                    435/02/toc.html>.
    Based Multiprocessor," Computer, Vol. 17, No. 7, July 1984, pp.                               65. DeMone, P., "RISC vs. CISC Still Matters," February 13, 2000.
    70-82.                                                                                            <ctas.east.asu.edu/bgannod/CET520/Spring02/Projects/
47. Overstreet, C, and R, Nance, "A Specification Language to Assist                                  demone.htm>.
    in Analysis of Discrete Event Simulation Models," Communica-                                  66. Hennessy, J. and D. Patterson, Computer Organization and
    tions of the ACM, Vol. 28, No. 2, February 1985, pp. 190-201.                                     Design, San Francisco, CA: Morgan Kaufmann Publishers, Inc.,
48. Jefferson, D., et al., "Distributed Simulation and the Time Warp                                  1998, p. 525.
    Operating System," Proceeding of the 11th Symposium on Oper-                                  67. Rosen, S., "Electronic Computers—A Historical Survey," ACM
    ating System Principles,Vo\. 21, No. 5, November 1987, pp. 77-93.                                 ComputingSurveys,Vol. l,No. 1, January 1969, pp. 26-28.
49. Overstreet, C, and R. Nance, "A Specification Language to Assist                              68. Ramamoorthy, C. V., and H. F Li, "Pipeline Architecture," ACM
    in Analysis of Discrete Event Simulation Models," Communica-                                      Computing Survey'.s, Vol. 9, No. 1, January 1977, pp. 62-64.
    tions of the ACM, Vol. 28, No. 2, February 1985, pp. 190-201.                                 69. Aletan, S., "An Overview of RISC Architecture," Proceedings of
50. Gibson, J. et al., "FLASH vs. (Simulated) FLASH: Closing the                                      the 1992 ACM/SIGAPP Symposium on Applied Computing:
    Simulation Loop," ACM SIGPLAN Notices, Vol. 35, No. 11,                                           Technological Challenges of the 1990's, 1992, pp. 11-12.
    November 2000, pp. 52-58.                                                                     70. Hopkins, M., "Compiling for the RT PC ROMP," IBM RT Per-
51. Lucas, H, "Performance Evaluation and Monitoring," ACM                                            sonal Computer Technology, 1986, pp. 81.
    Computing Surveys, Vol. 3, No. 3, September 1971, pp. 79-91.                                  71. Coulter, N. S., and N. H. Kelly, "Computer Instruction Set Usage
52. Plattner, B., and J. Nivergelt, "Monitoring Program Execution: A                                  by Programmers: An Empirical Investigation," Communications
    Survey," Computer,Vol 14,No. 11, November 1981,pp. 76-92.                                         of the ACM, Vol. 29, No. 7, July 1986, pp. 643-647.
53. Irving, R.; C. Higgins; and F. Safayeni, "Computerized Perfor-                                72. Serlin, O., "MIPS, Dhrystones, and Other Tales," Datamation,
    mance Monitoring Systems: Use and Abuse," Computer Technol-                                       Vol. 32, No. 11, June 1,1986, pp. 112-118.
    ogy Form No. SA23-1057,1986.                                                                  73. Aletan, S., "An Overview of RISC Architecture," Proceedings of
54. "Windows 2000 Performance Tools: Leverage Native Tools for                                        the 1992 ACM/SIGAPP Symposium on Applied Computing:
    Performance Monitoring and Tuning," InformIT, January 15,2001,                                    Technological Challenges of the 1990's, 1992, p. 13.
    <www.informit.com/content/                                                                    74. Patterson, D. A., "Reduced Instruction Set Computers," Commu-
      index.asp?product_id=%7BA085E192-E708-4AAB-999E-                                                nications of the ACM,Vol. 28, No. 1, January 1985, pp. 8-21.
      5C339560EAA6%7D>.
                                                                                                  75. Hopkins, M., "Compiling for the RT PC ROMP," IBM RT Per-
55. Gavin, D, "Performance Monitoring Tools for Linux," Linux                                         sonal Computer Technology, 1986, pp. 81.
    Journal, No. 56, December 1, 1998, < w w w . l i n u x j o u r -
                                                                                                  76. Patterson, D. A., "Reduced Instruction Set Computers," Commu-
    nal.com/article.php?sid=2396>.
                                                                                                      nications oftheACM,Vol. 28, No. 1, January 1985, pp. 8-21.
56. "IA-32 Intel Architecture Software Developer's Manual," Vol. 3,
                                                                                                  77. Patterson, D., "Reduced Instruction Set Computers," Communi-
    System Programmer's Guide, 2002.
                                                                                                      cations oftheACM,Vol 28, No. 1, January 1985,pp. 8-21.
57. Lucas, H., "Performance Evaluation and Monitoring," ACM
                                                                                                  78. Lilja, D.,"Reducing the Branch Penalty in Pipelined Processors."
    Computing Surveys, Vol. 3, No. 3, September 1971, pp. 79-91.
                                                                                                      Computer,Vol. 21, No. 7, July 1988, pp. 47-55.
58. Ferrari, D.; G Serazzi; and A. Zeigner, Measurement and Tuning
                                                                                                  79. Huang, I., "Co-synthesis of Pipelined Structures and Structured
    of Computer Systems, Englewood Cliffs, NJ: Prentice Hall, 1983.                                   Reordering Constraints for Instruction Set Processors," ACM
59. Bonomi, M., "Avoiding Coprocessor Bottlenecks," Byte, Vol. 13,                                    Transactions on Design Automation of Electronic Systems, Vol. 6.
    No. 3, March 1988, pp. 197-204.                                                                   No. 1, January 2001, pp. 93-121.
60. Coutois, P., "Decomposability, Instability, and Saturation in Mul-                            80. Lilja, D., "Reducing the Branch Penalty in Pipelined Processors,"
    tiprogramming Systems," Communications of the ACM, Vol. 18,                                       Computer,Vol. 21, No. 7, July 1988, pp. 47-55.
    No. 7,1975, pp. 371-376.
                                                                                                  81. Wilson, R., "RISC Chips Explore Parallelism for Boost in
61. Hennessy, J., and D. Patterson, Computer Organization and                                         Speed," Computer Design, January 1,1989, pp. 58-73.
    Design, San Francisco, CA: Morgan Kaufmann Publishers, Inc.,
                                                                                                  82. Davidson, J. W., and R. A. Vaughan, "The Effect of Instruction
    1998, p. G-7.
                                                                                                      Set Complexity on Program Size and Memory Performance,"
62. Stokes, J., "Ars Technica: RISC vs. CISC in the Post RISC Era,"                                   Proceedings of the Second International Conference on Architec-
    October 1999, < a r s t e c h m c a . c o m / c p u / 4 q 9 9 / r i s c - c i s c / r v c -       tural Support for Programming Languages and Operating Sys-
    1.html>.                                                                                          terns, 1987, pp. 60-64.

<!-- pág. 735 -->

                                                                                                                                                                    Works Cited 681
S3. Wilson, R., "RISC Chips Explore Parallelism for Boost in                                        100. Stokes, J., "Ars Technica: RISC vs. CISC in the Post RISC Era,"
    Speed," Computer Design, January 1,1989, pp. 58-73.                                                  October 1999, < a r s t e c h n i c a . c o m / c p u / 4 q 9 9 / r i s c - c i s c / r v c -
                                                                                                         1.html>.
84. "IA-32 Intel Architecture Software Developer's Manual," Vol. 1:
    Basic Architecture, 2002.                                                                       101. "Altivec Fact Sheet," Motorola Corporation,                                  2002,      <e-
                                                                                                         www.motorola.com/files/32bit/doc/fact_sheet/
85. Brehob, M., et al., "Beyond R I S C - T h e Post-RISC Architec-
                                                                                                         ALTIVECCLANCE.pdf>.
    ture," Michigan State University Department of Computer Sci-
    ence, Technical Report CPS-96-11, March 1996.                                                   102. Stokes, J., "Ars Technica: RISC vs. CISC in the Post RISC Era,"
                                                                                                         October 1999, < a r s t e c h n i c a . c o m / c p u / 4 q 9 9 / r i s c - c i s c / r v c -
86. Stokes, X, "Ars Technica: RISC vs. CISC in the Post RISC Era,"
                                                                                                         1.html>.
    October 1999, < a r s t e c h n i c a . c o m / c p u / 4 q 9 9 / r i s c - c i s c / r v c -
    l.html>.                                                                                        103. Schlansker, M., and B. Rau, "EPIC: Explicitly Parallel Instruc-
                                                                                                         tion Computing," Computer, Vol. 33, No. 2, February 2000, pp.
87. Stokes, J., "Ars Technica: RISC vs. CISC in the Post RISC Era,"                                      37-38.
    October 1999, < a r s t e c h n i c a . c o m / c p u / 4 q 9 9 / r i s c - c i s c / r v c -
    l.html>.                                                                                        104. Lowney, P., et al., "The Multiflow Trace Scheduling Compiler,"
                                                                                                         Journal of Supercomputing, Vol. 7, May 1993:51-142.
88. Brehob, M., et al., "Beyond R I S C - T h e Post-RISC Architec-
                                                                                                    105. Hennessy, J., and D. Patterson, Computer Organization and
    ture," Michigan State University Department of Computer Sci-
                                                                                                         Design, San Francisco, CA: Morgan Kaulmann Publishers, Inc.,
    ence, Technical Report CPS-96-11, March 1996.
                                                                                                         1998, p. 528.
89. DeMone, P., "RISC vs. CISC Still Matters," February 13, 2000,
                                                                                                    106. Schlansker, M., and B. Rau, "EPIC: Explicitly Parallel Instruc-
    <ctas.east.asu.edu/bgannod/CET520/Spring02/Projects/
                                                                                                         tion Computing," Computer, Vol. 33, No. 2, February 2000, pp.
    demone.htm>.
                                                                                                         38-39.
90. Hennessy, J., and D. Patterson, Computer Organization and                                       107. Schlansker, M., and B. Rau, "EPIC: Explicitly Parallel Instruc-
    Design, San Francisco, CA: Morgan Kaufmann Publishers, Inc.,                                         tion Computing," Computer, Vol. 33, No. 2, February 2000, pp.
    1998, p. 510.                                                                                        41-44.
91. Jouppi, N., "Superscalar vs. Superpipelined Machines," ACM                                      108. Schlansker, M., and B. Rau, "EPIC: Explicitly Parallel Instruc-
    SIGARCH Computer Architecture News, Vol. 16, No. 3, June                                             tion Computing," Computer, Vol. 33, No. 2, February 2000, pp.
    1988, pp. 71-80.                                                                                     41-44.
92. Ray, X; X Hoe; and B. Falsafi, "Dual Use of Superscalar Datapath                                109. Lucas, H., "Performance Evaluation and Monitoring," ACM
    for Transient-Fault Detection and Recovery," Proceedings of the                                      Computing Surveys, Vol. 3, No. 3, September 1971, pp. 79-91.
    34th Annual ACM/IEEE International Symposium on Microar-
                                                                                                    n o . Mogul, X, "Brittle Metrics in Operating System Research," Pro-
    chitecture, December 2001, pp. 214-224.
                                                                                                          ceedings of the Seventh Workshop on Hot Topics in Operating
93. Stokes, X, "Ars Technica: RISC vs. CISC in the Post RISC Era,"                                        Systems, March 1999, pp. 90-95.
    October 1999, < a r s t e c h n i c a . c o m / c p u / 4 q 9 9 / r i s c - c i s c / r v c -   i n . Seltzer, M., et al., "The Case for Application-Specific Bench-
    1.html>.                                                                                              marking," Proceedings of the Seventh Workshop on Hot Topics in
94. Hwu, W. W., and Y. Patt, "Checkpoint Repair for Out-of-Order                                          Operating Systems, March 1999, pp. 105-106.
    Execution Machines," Proceedings of the 14th International Sym-                                 112. "PC Magazine Benchmarks from VeriTest," PC Magazine
    posium on Computer Architecture, June 1987, pp. 18-26.                                               <www.veritest.com/benchmarks/default.asp?visitor=>.
95. Chuang, W., and B. Calder, "Predicate Prediction for Efficient                                  113. Hennessy, J., and D. Patterson, Computer Organization and
    Out-of-Order Execution," Proceedings of 17th Annual Interna-                                         Design, San Francisco, CA: Morgan Kaufmann Publishers, Inc.,
    tional Conference on Supercomputing, June 2003, pp. 183-192.                                         1998, p. 528.
96. Stokes, X, "Ars Technica: RISC vs. CISC in the Post RISC Era,"                                  114. Stokes, X, "Ars Technica: RISC vs. CISC in the Post RISC Era,"
    October 1999, < a r s t e c h n i c a . c o m / c p u / 4 q 9 9 / r i s c - c i s c / r v c -        October 1999, < a r s t e c h n i c a . c o m / c p u / 4 q 9 9 / r i s c - c i s c / r v c -
    1.html>.                                                                                             1.html>.
97. Stokes, X, "Ars Technica: RISC vs. CISC in the Post RISC Era,"                                  115. Aletan, S., "An Overview of RISC Architecture," Proceedings of
    October 1999, < a r s t e c h n i c a . c o m / c p u / 4 q 9 9 / r i s c - c i s c / r v c -        the 1992 ACM/SIGAPP Symposium on Applied Computing:
    1.html>.                                                                                             Technological Challenges of the 1990's, 1992, pp. 11-12.
98. Young, C, and M. Smith, "Static Correlation Branch Prediction,"                                 116. Flynn, M. X; C. L. Mitchell; and X M. Mulder, "And Now a Case
    ACM Transactions on Programming Languages and Systems, Vol.                                          for More Complex Instruction Sets," Computer, Vol. 20, No. 9,
    21, No. 5, September 1999, pp. 1028-1075.                                                            September 1987, pp. 71-83.
99. Stokes, X, "Ars Technica: RISC vs. CISC in the Post RISC Era,"                                  117. Schlansker, M., and Rau, B., "EPIC: Explicitly Parallel Instruc-
    October 1999, < a r s t e c h n i c a . c o m / c p u / 4 q 9 9 / r i s c - c i s c / r v c -        tion Computing," Computer, Vol. 33, No. 2, February 2000, pp.
    1.html>.                                                                                             41-44.

<!-- pág. 736 -->

What's going to happen in the next decade is that
we'll figure out how to make parallelism work.
      - D a v i d Kuck quoted in TIME,March 28,1988-


"The question is," said Humpty Dumpty, "whish is to be master - that's all."
      — Lewis Carroll —

I hope to see my Pilot face to face When I have crossed the bar.
      — Alfred, Lord Tennyson —

"If seven maids with seven mops
Swept it for half a year,
Do you suppose," the Walrus said,
"That they could get it clear?"
      —Lewis Carroll—


The most general definition of beauty ... Multeity in Unity.
      —Samuel Taylor Coleridge—

