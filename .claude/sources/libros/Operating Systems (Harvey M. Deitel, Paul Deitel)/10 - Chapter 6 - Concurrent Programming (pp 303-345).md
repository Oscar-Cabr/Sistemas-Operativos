# Chapter 6 - Concurrent Programming

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 303–345 (numeración del PDF)

<!-- pág. 303 -->

Chapter               6



Concurrent Programming
  After reading this chapter, you should understand:
   how monitors synchronize access to data.
   how condition variables are used with monitors.
   solutions for classic problems in concurrent programming such as readers
   and writers and circular buffer.
   Java monitors.
   remote procedure calls.

<!-- pág. 304 -->

                                               Chapter Outline
                             6.1                                          6.3
                     Introduction                                  Java Monitors
      Anecdote: Exhaustive Testing Is Impossible

                            6.2                                           6.4

                       Monitors                            Java Multithreading Case
           Operating Systems Thinking:                           Study: Part III:
                  Information Hiding                           Producer/Consumer
             6.2.1 Condition Variables                        Relationship in Java
       Biographical Note: Per Brinch Hansen
       6.2.2 Simple Resource Allocation with
                                                                          6.5
                         Monitors
      6.2.3 Monitor Example: Circular Buffer                     Java Multithreading Case
                                                                  Study, Part IV:
       6.2.4 Monitor Example: Readers and
                                                            Circular Buffer in Java
                        Writers




          Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited.



246

<!-- pág. 305 -->

                                                                                    6.1 Introduction 247



6.1 Introduction
In the last chapter we presented Dekker's Algorithm and Peterson's Algorithm for
the implementation of mutual exclusion primitives, and we studied Dijkstra's sema-
phores. These mechanisms have a number of weaknesses. They are so primitive that
it is difficult to use them to express solutions to more complex concurrency prob-
lems, and their presence in concurrent programs increases the already difficult
problem of proving program correctness. Their malicious or accidental misuse
could lead to subtle bugs that might corrupt the operation of a concurrent system.
       The semaphore approach, in particular, has many weaknesses.1 If a P opera-
tion is omitted, then mutual exclusion is not enforced. If a V operation is omitted,
then threads waiting because of P operations could become deadlocked. Once the
P operation begins, the thread cannol back out and take an alternate course of
action while the semaphore remains in use. A thread may wait on only one sema-
phore at a time: this could lead to deadlock in resource-allocation situations. For
example, two threads may each hold a resource that the other thread is waiting to
use. This is the classic case of two-thread deadlock, which we will discuss in
Chapter 7, Deadlock and Indefinite Postponement.
      To combat this problem, researchers have developed higher-level mutual exclu-
sion constructs that simplify solving complex concurrency problems, facilitate proving
program correctness and are difficult for a programmer to misuse or corrupt.
       Concurrent programming is much more difficult than sequential program-
ming. Concurrent programs are harder to write, debug, modify, and prove correct
(see the Anecdote. Exhaustive Testing Is Impossible). So whv is the programming
community so intent on concurrent programming?
       There has been a surge of interest in concurrent programming languages
because they enable us to express more natural solutions to problems that are
inherently parallel. Furthermore, the true hardware parallelism possible with multi-
processors (see Chapter I?. Multiprocessor Management) and distributed systems
(sec Chapter 17. Introduction to Distributed Systems) can only be harnessed
through concurrent programming. The potential applications for concurrent pro-
gramming are numerous. There has been much discussion on concurrency in com-
puter networks.2 distributed systems 3 , 5, 6, 7 and real-time systems.8, 9, 10 Certainly,
operating systems themselves are important examples of concurrent systems. So are
air traffic control systems, mission-critical systems, and real-time process control
systems (such as those that control gasoline refineries, chemical manufacturing
plants and food processing plants). It is widely believed that human vision is an
inherently parallel task. Weather forecasting will almost certainly lake great strides
forward when massive parallelism reaches the scale of billions or even trillions of
concurrent processors.
       In this chapter, we consider high-level constructs and languages for concur-
rent programming. In particular, we investigate monitors, condition variables, inter-
process communication using remote procedure calls and the Java programming
language's concurrent programming facilities. The pseudocode examples in

<!-- pág. 306 -->

248 Concurrent Programming

                                Section 6.2. Monitors, use a C-like syntax: the rest of the chapter uses complete
                                Java programs. The chapter concludes with a lengthy literature section indicating
                                the richness of concurrent programming as a research area.
                                      What approach should implementors take when building concurrent systems
                                todav? Prior to the 1990s, high-level concurrent programming languages included
                                to Ada. 11 Concurrent Pascal.12, 13 Distributed Processes,14 Concurrent C.15 Commu-
                                nicating Sequential Processes.16, 17 Modula-2. 18, 19, 20 VAL21 and *MOD (for distrib-
                                uted programming). 22 With the exception of Ada. these languages were generally




                Anecdote
   Exhaustive Testing Is Impossible
    Testing is a hard problem. As you     tester concludes that the software     has been "thoroughly" tested, it
    may study in courses on automata      is simply passing its input through    could still contain "lurking bugs"
    theory, a computer may be             to its output and seems to be          that may not surface until long
    viewed as a finite state machine.     working fine. But suppose the          after the system has been
    How many states can a computer        software actually contains a           deployed. This places a huge bur-
    have? One possible view is that if    counter of the number of times it      den on the shoulders of operating
    the machine stores n bits, then       has been called, and when the          systems developers. When can we
    the number of states is 2 raised to   counter reaches a certain large        truly say that a system is ready for
    the nth power. A machine that         value, it performs some other          deployment? Obviously, this deci-
    has even a small main memory—         (possibly devastating) action. If in   sion depends on the nature of the
    perhaps tens of megabytes—            testing that software, it is called    system. Is it a mission-critical or
    could have far more states than       fewer than that number of times,       business-critical system? Are
    there are atoms in the universe!      then that test case will not occur     human lives at stake? Is it a special-
    Consider this experiment: A com-      and the software "problem" will        purpose system whose use will be
    plex piece of software takes a 1 or   not be detected.                       carefully confined to a narrow,
    0 as input and yields a 1 or 0 as             Dijkstra emphasized that       controlled audience, or is it a gen-
    output. Each time the tester          "testing reveals the presence of       eral-purpose system that could be
    inputs a 1 for a large number of      bugs, but not their absence." Since    employed in a great diversity of
    test cases, the software outputs a    it is simply not possible to exhaus-   applications, many of which can-
    1; each time the tester inputs a 0,   tively test every system we build,     not be determined when the sys-
    the software outputs a 0. The         this means that even after a system    tern is under development.


    Lesson to operating systems designers: Since the systems you build cannot possibly be tested exhaustively,
    you must "design for testability," minimizing the chance of bugs and providing testing capabilities to help
    system testers certify that your system is ready for deployment.

<!-- pág. 307 -->

                                                                              6.2 Monitors 249

developed by academics for research purposes and tend to lack many of the fea-
tures needed to implement real systems. Today, many popular programming lan-
guages support concurrency, including Java. C#. Visual C++ .NET. Visual Basic
.NET and Python. Concurrent programming presents opportunities for computer
science students as they prepare for careers in industry, where few people are expe-
rienced in this complex subject.

Self Review
1. Why have researchers sought higher-level mutual exclusion constructs?
2. What notable high-level concurrent programming language developed prior to the 1990s
   did indeed include the features needed to implement real systems?
Ans: 1) These constructs facilitate proving program correctness and are difficult to misuse
or corrupt. 2) Ada.


6.2 Monitors
A monitor is an object that contains both the data and procedures needed to per-
form allocation of a particular serially reusable shared resource or group of serially
reusable shared resources. The notion of a monitor was suggested by Dijkstra.23
then by Brinch Hansen,24, 25 then refined by Hoare. 26 There has been much discus-
sion in the literature on this important topic.27, 28, 29, 30, 31, 32, 33, 34, 35 Monitors have
become an important software construct —in fact, the Java programming language
makes extensive use of monitors to implement mutual exclusion.
      To accomplish resource allocation using monitors, a thread must call a moni-
                    tor entry routine. Many threads may want to enter the monitor at the
same time, but mutual exclusion is rigidly enforced at the monitor boundary —only one
thread at a time is allowed to enter. A thread that tries to enter the monitor when it is in
use is made to wait by the monitor. Because the monitor guarantees mutual exclu-
sion, concurrency problems (such as indeterminate outcomes) are avoided.
      Data inside a monitor may be either global to all routines within the monitor
or local to a specific routine. Monitor data is accessible only within the monitor:
there is no way for threads outside the monitor to access monitor data. This is a
form of information hiding a software architectural technique that improves mod-
ularity and facilitates the development of more reliable software systems (see the
Operating Svstems Thinking feature. Information Hiding).
      If a thread calls a monitor entry routine while no other threads are executing
inside the monitor, the thread acquires a lock on the monitor and enters it. While
the thread is in the monitor, other threads may not enter the monitor to acquire the
resource. If a thread calls a monitor entry routine while the monitor is locked, the
monitor makes the calling thread wait outside the monitor until the lock on the
monitor is released (i.e.. when a thread is no longer executing inside the monitor).
Once inside the monitor, a thread might need to wait because the resource has been
allocated to another thread. Because mutual exclusion is enforced at the boundary

<!-- pág. 308 -->

250 Concurrent Programming
                                of the monitory, a thread waiting for a resource must do so outside the monitor to
                                allow another thread into the monitor to return the resource.
                                      Eventually, the thread that has the resource will call a monitor entry routine
                                to release the resource. This routine could merely free the resource and wait for
                                another requesting thread to arrive. But there may be threads waiting for the
                                resource, so the monitor entry routine calls signal to allow one of the waiting
                                threads to enter the monitor and acquire the resource. If a thread signals the return
                                (also called the release) of the resource, and no threads are waiting, then the signal
                                has no effect (but. of course, the monitor has recaptured the resource, which it can
                                now allocate to arriving threads). To avoid indefinite postponement, a monitor
                                gives a higher priority to waiting threads than to newly arriving ones.


                                Self Review
                                1. Why must a thread wait for a resource outside a monitor?
                                2. How does a monitor prevent multiple threads from concurrently executing inside the
                                   monitor?
                                Ans: 1) If the thread were to wait inside a monitor for a resource, no other threads could
                                enter the monitor to return the resource. As we will see in Chapter 7. Deadlock and
                                Indefinite Postponement, this could cause all the threads waiting for the resource to dead-
                                lock. 2) The monitor enforces mutual exclusion at its border using the kinds of techniques
                                discussed in Chapter 5. Asynchronous Concurrent Execution.




                  Operating Systems Thinking
 Information Hiding
   Information hiding is one of the      ues are expected. Information            Today's operating systems argu-
   most fundamental techniques of        hiding has many advantages. It           ably have tens of thousands (or
   software engineering. It is imple-    makes the caller's job easier. It        more) components that are con-
   mented in many ways in operat-        does not need to be familiar with        stantly being evolved to adapt to
   ing systems. When one function        the (possibly enormous) complex-         new hardware and software
   or method calls another, the caller   ity of how the callee is imple-          trends and tuned to perform bet-
   does not need to know the details     mented. It also makes it easier to       ter. Information hiding places a
   of how the callee is implemented;     modify systems—a called func-            crucial role in making these enor-
   the caller merely has to know the     tion can usually be replaced easily      mous and highly modular systems
   interface to the callee—what          w i t h o u t requiring changes in the   understandable and maintain-
   arguments must be passed and in       caller, as long as the interface to      able.
   what order, and what return val-      the callee remains the same.

<!-- pág. 309 -->

                                                                                                 6.2 Monitors 251
6.2.1 Condition Variables
Monitors implement both mutual exclusion and synchronization between threads
of execution. A thread currently inside a monitor may need to wait outside the
monitor until another thread performs an action inside the monitor. For example, in
the producer/consumer relationship, the producer finding that the consumer still
has not read the value in a single shared buffer must wait outside the monitor gov-
erning the shared buffer so that the consumer can consume the buffer contents.
Similarly, a consumer finding that the shared buffer is empty must wait outside the
monitor until the producer fills the buffer. A thread inside a monitor uses a condition
              variable to wait on a condition outside the monitor. A monitor assicuates a sep-
arate condition variable with each distinct situation that might cause a thread to
have to wait. We define the wait and signal operations as:
     wait (condition Variable)
     signal   (conditionVariable)

       Condition variables are different from '"conventional" variables. Every condi-
tion variable has an associated queue. A thread calling wait on a particular condi-
tion variable is placed into the queue associated with that condition variable (while
in that queue, the thread is outside the monitor, so that another thread can eventu-
ally enter the monitor and call s i g n a l ) . A thread calling signal on a particular
condition variable causes a thread waiting on that condition variable to be removed
from the queue associated with it and to reenter the monitor. We may assume a
first-in-first-out (FIFO) queue discipline, although priority schemes can be useful in
certain sit nations. 36 ' 37
       Before that thread can reenter the monitor, the thread calling signal must
first exit the monitor. Brinch Hansen (see the Biographical Note. Per Brinch
Hansen), noting that many signal statements immediately preceded a r e t u r n
statement (i.e.. the thread exits the monitor), proposed a signal-and-exit monitor, in
which a thread immediately exits the monitor upon signaling.38 The monitors in the
following examples are signal-and-cxit monitors. Alternatively, a signal-and-continue
       monitor allows a thread inside the monitor to signal that the monitor will soon
become available, but still maintain a lock on the monitor until the thread exits the
monitor. A thread can exit the monitor by waiting on a condition variable or bv
completing execution of the code protected bv the monitor. The thread released bv
a signal-and-continue monitor must wait until the signalling thread exits the moni-
tor. As we discuss in Section 6.3. Java Monitors, the Java programming language
implements signal-and-continue monitors.


Self Review
1. What problem might occur if a priority queue (instead of a FIFO queue) were used for a
   condition variable?
2. (T/F) Each monitor contains exactly one condition variable.

<!-- pág. 310 -->

252 Concurrent Programming
                                Ans:    1) A lower-priority thread could be indefinitely postponed by a stream of higher-prior-
                                ity threads calling wait in the monitor enter the priority queue. 2) False. A monitor contains
                                a separate condition variable for each distinct situation that might cause a thread to call wait
                                in the monitor.

                                 6.2.2 Simple Resource Allocation with Monitors
                                Suppose several threads are contending for a resource that requires exclusive
                                access. A simple monitor for handling the allocation and deallocation of such a
                                resource is shown in Fig. 6.1.
                                      Line 4 declares state variable inUse which keeps track of whether the
                                resource is in use or not. Line 5 declares a condition variable that is waited on by a
                                thread finding the resource unavailable and signaled by a thread returning the
                                resource (and thus making it available). Lines 7-17 and 19-25 declare two monitor
                                entry routines. To indicate that these are monitor entry routines (rather than rou-
                                tines private to the monitor), we prefix each routine with the pseudocode keyword
                                monitorEntry.




              Biographical Note
  Per Brinch Hansen

    Per Brinch Hansen has devoted his      Hansen developed the RC 4000         allowed only sequential program-
    research to concurrent program-        Multiprogramming System for the      ming), for users to define access
    ming, which is the technique of        RC (RegneCentralen) 4000 com-        controls on shared data so that
    designing software that has paral-     puter. This operating system was     programs written in Concurrent
    lel paths of execution. He received    the first to separate system func-   Pascal could be checked at com-
    his Masters in Electrical Engineer-    tions into a kernel module. 40       pile time for sharing violations. 42
    ing from the Technical University            Brinch Hansen introduced       As a demonstration of Concurrent
    of Denmark in 1962 and has been        the concept of the monitor con-      Pascal, Brinch Hansen used it to
    a professor at the California Insti-   struct—an object that encapsu-       write Solo, a simple operating
    tute of Technology, the University     lates both shared data and the       system that was secure (meaning
    of Southern California and the         procedures that operate on that      that errors would be detected by
    University of Copenhagen, Den-         shared data—in his book, Operat-     the system instead of crashing the
    mark. He is currently a professor      ing Systems Principles, published    program—not the more common
    of Electrical Engineering and          by Prentice Hall in 1973 (see        meaning of safe from attacks)
    Computer Science at Syracuse Uni-      Section 6.2, Monitors). 41 He incor- w i t h o u t using hardware
    versity.39                             porated monitors into his Concur- support. 43, 44, 45 He later designed
          While working at the Regne-      rent Pascal language (an             the concurrent programming lan-
    centralen, Copenhagen, Brinch          extension of Pascal, which           guage Joyce.46

<!-- pág. 311 -->

                                                                                    6.2 Monitors 253

   1 // Fig. 6.1: Resource allocator monitor
   2
   3 // monitor initialization (performed only once)
   4 boolean inUse = false; // simple state variable
   5 Condition a v a i l a b l e ; // condition variable
   6
   7 // request resource
   8 monitorEntry void getResource()
   9 {
  10             if ( i n U s e ) // is resource in use?
  11         {
  12             wait(available);//waituntilavailableissignalled
  13 } // end if
  14
  15 inUse = true; // indicates resource is now in use
  16
  17 } // end getResource
  18
  19 // return resource
  20 monitorEntry void returnResource()
  21 {
  2 2 inUse = false; // indicate resource is not in use
  23 signal( available ); // signal a waiting thread to process
  24
  25 }      //   end   returnResource

F i g u r e 6.1 | Simple resource allocation with a monitor in pseudocode.


         Line 8 begins method getResource. which a thread calls to request the
resource associated with the condition variable a v a i l a b l e . Line 10 tests the state
variable inUse to see whether the resource is in use. If this value is t r u e , meaning
that the resource has been allocated to another thread, the calling thread must wai t
 on condition variable a v a i l a b l e (line 12). After calling wait, the thread exits the
monitor and is placed in the queue associated with the condition variable aval 1 -
able. As we will see. this allows the thread that is using the resource to enter the
monitor and release the resource by signaling condition variable a v a i l a b l e . When
the resource is not in use. the requesting thread executes line 15. which sets inUse
to t r u e , providing the thread exclusive access to the resource.
         Line 20 begins method returnResource. which a thread calls to release the
resource. Line 22 sets the value of inUse to f a l s e to indicate that the resource is no
longer in use and can be allocated to another thread. Line 23 calls signal on condi-
tion variable a v a i l a b l e to alert any waiting thread that the resource is now free. If
there are any threads waiting in the queue associated with a v a i l a b l e (as a result of
executing line 12). the next waiting thread reenters the monitor and executes line
15. obtaining exclusive access to the resource. If there are no threads waiting on
a v a i l a b l e , signal has no effect.

<!-- pág. 312 -->

254 Concurrent Programming

                                    The beauty of the monitor in Fig. 6.1 is that it performs exactly as a binary sema-
                             phore: method getResource acts as the P operation: method returnResource acts
                             as the V operation. Because the simple one-resource monitor can be used to imple-
                             ment semaphores, monitors are at least as powerful as semaphores. Note that the
                             monitor initialization (lines 3-5) is performed before threads begin using the monitor;
                             in this case inUse is set to false to indicate that the resource is initially available.

                             Self Review
                             1. What would happen if returnResource() did not signal the condition variable
                                avalable?
                             2. What purpose does the keyword monitorEntry serve?
                             Ans: 1) All of the threads waiting on condition variable a v a l a b l e would deadlock — they
                             will wait forever. 2) Keyword monitorEntry distinguishes between monitor entry routines,
                             which are accessible by all threads and can be executed by only one thread at a time, and pri-
                             vate monitor methods, which are accessible only within the monitor.


                             6.2.3 Monitor Example: Circular Buffer
                             In this section we discuss the circular buffer (sometimes called the bounded buffer. )
                             and how it is useful in situations in which a producer thread passes data to a con-
                             sumer thread. Because the producer and consumer access the same data and may
                             operate at different rates, synchronization between the two threads is essential.
                                   We can use an array to implement the circular buffer. In the circular buffer
                             implementation of the solution to the producer/consumer problem, the producer
                             deposits data in the successive elements of the array. The consumer removes them
                             in the order in which they were deposited (FIFO). The producer can be several
                             items ahead of the consumer. Eventually, the producer fills the last element of the
                             array. When it produces more data, it must "wrap around" and again begin deposit-
                             ing data in the first element of the array (assuming, of course, that the consumer has
                             removed the data previously put there by the producer). The array effectively
                             closes in a circle, hence the term circular buffer.
                                    Because of the fixed size of the circular buffer, the producer will occasionally
                             find all the array elements full: in this case the producer must wait until the consumer
                             empties an array element. Similarly, there will be times when the consume]' wants to
                             consume, but the array will be empty: in this case the consumer must wait until the
                             producer deposits data into an array element. The monitor in Fig. 6.2 (based on the
                             example presented by Hoare) 47 implements a circular buffer and the appropriate syn-
                             chronization mechanisms to handle the producer/consumer relationship.

                                 1 // Fig. 6.2: Circular buffer monitor
                                 2

                             Figure 6.2 | Monitor pseudocode implementation of a circular buffer. (Part 1 of
                             2.)

<!-- pág. 313 -->

                                                                                        6.2   Monitors   255

   3   char circularBuffer[] = new char[ BUFFER_SIZE ],; // buffer
   4   int writerPosition = 0; // next slot to write to
   5   int readerPosition = 0; // next slot to read from
   6   int occupiedSTots = 0; // number of slots with data
   7   Condition hasData;      // condition variable
   8   Condition hasSpace;     // condition variable
   9
  10   // monitor entry called by producer to write data
  11   monitorEntry void putChar( char slotData )
  12 {
  13   // wait on condition variable hasSpace if buffer is f u l l
  14      if ( occupiedSTots == BUFFER_SIZE )
  15      {
  16          wait( hasSpace ); // wait until hasSpace is signaled
  17      } // end if
  18
  19      // write character to buffer
  20      circularBuffer[ writerPosition ] = slotData;
  21      ++occupiedSlots; // one more slot has data
  22      writerPosition = (writerPosition + 1) % BUFFER_SIZE;
  23      signal( hasData ); // signal that data is available
  24   } // end putChar
  25
  26   // monitor entry called by consumer to read data
  27   monitorEntry void getChar( outputParameter slotData )
  28   {
  29      // wait on condition variable hasData if the buffer is empty
  30      if ( occupiedSlots == 0 )
  31      {
  32         wait( hasData ); // wait until hasData is signaled
  33      } // end if
  34
  35      // read character from buffer into output parameter slotData
  36      slotData = circularBuffer[ readPosition ];
  37      occupiedSlots--; // one fewer slots has data
  38      readerPosition = (readerPosition + 1) % BUFFER_SIZE;
  39      signal( hasSpace ); // signal that character has been read
  40   } // end getChar

Figure 6.2 | Monitor pseudocode implementation of a circular buffer. (Part 2 of
2.)


      We shall assume that the array circularBuffer contains BUFFER_SIZE
entries consisting of one character (line 3). Variables writerPosition and read-
erPosition (lines 4-5) indicate in which slot of the circular buffer the next item is
to be placed by a producer and from which slot of the circular buffer the next item
is to be removed by a consumer, respectively.

<!-- pág. 314 -->

256 Concurrent Programming
                               A producer adds data to the buffer by calling method putChar (lines 10-24).
                         Line 14 tests if the buffer is full. If it is, the producer waits on the condition variable
                         hasSpace (line 16). When it does this, the producer leaves the monitor and waits in
                         the queue associated with the condition variable hasSpace. As we will soon see,
                         this allows a consumer to enter the monitor, consume data in the circular buffer and
                         signal condition variable hasSpace.This enables the producer to continue; it writes
                         the data to the buffer (line 20), increments the number of occupied slots (line 21)
                         and updates the w r i t e r P o s i t i o n variable (line 22). Finally, line 23 signals condi-
                         tion variable hasData to enable a waiting consumer, if there is one, to proceed.
                               A consumer reads data from the buffer by calling method getChar (lines 26-
                         40). Note the use of the output parameter s l o t D a t a in the pseudocode (indicated by
                         keyword outputParameter in line 27). Many languages support such a capability.
                         Data written to the output parameter is immediately available in the caller's argu-
                         ment. Line 30 tests if the buffer is empty. If it is, the consumer waits on condition vari-
                         able hasData (line 32). When the consumer can continue, it reads the data from the
                         buffer directly into the output parameter s l o t D a t a (line 36), immediately making
                         the data available in the caller's argument. The consumer then decrements the num-
                         ber of occupied slots (line 37) and updates readerPosi ti on (line 38). Line 39 signals
                         condition variable hasSpace to enable a waiting producer, if there is one, to proceed.
                               The beauty of the circular buffer is that it allows the producer to "get ahead"
                         of the consumer. The producer can create a new value without waiting for the con-
                         sumer to read the previous value (as is necessary in the single buffer producer/con-
                         sumer relationship). These extra values are placed in the empty slots of the circular
                         buffer. The consumer will still read the values in the correct order. The circular
                         buffer reduces the amount of time the producer must wait before producing
                         another value, thus improving system performance. The larger the circular buffer,
                         the more values the producer can produce before it must wait for the consumer to
                         empty the buffer. If the producer and consumer work at approximately the same
                         speed, using the circular buffer can increase the average speed of the application. If
                         there is a difference in the average speeds of the threads, this advantage is nullified.
                         For example, if the producer works consistently faster than the consumer, the circu-
                         lar buffer will quickly become full and stay full, forcing the producer to wait each
                         time for the consumer to free up space. Similarly, if the consumer works consis-
                         tently faster than the producer, then the consumer will typically find the circular
                         buffer empty and will almost always have to wait for the producer to create a value.
                         In these last two cases, using the circular buffer will simply waste memory rather
                         than increasing the speed of the application.
                               Operating systems can use a circular buffer to implement spooling control
                         One common example of spooling occurs when a thread generates lines to be
                         printed on a relatively slow output device such as a printer. Because the thread can
                         produce the lines much faster than the printer can print them, and because we would
                         like the thread to be able to complete its execution as quickly as possible, the
                         thread's output lines can be directed to a circular buffer. The circular buffer may be

<!-- pág. 315 -->

                                                                                                   6.2   Monitors   257
 in primary storage, or more likely on disk. The thread creating the lines to be printed
 is often called a spooler. Another thread reads the lines from the c i r c u l a r B u f f e r
and writes them to the printer. But this second thread, often called a despooler, runs
  at the slower, speed of the printer. The c i r c u l a r B u f f e r has sufficient storage to
 "take up the slack" resulting from the mismatch in the speeds of the spooler and
despooler threads. Of course, we assume the system does not indefinitely generate
print lines faster than the printer can print them; if it did, the buffer would always be
full and would be of little value in "smoothing" the printing operation.

Self Review
1. Name the two situations in which a circular buffer is less efficient than a single-value
   buffer in the producer/consumer relationship.
2. Would this monitor support one producer and two consumers such that each element that
   the producer produces is consumed by exactly one consumer? Why or why not?
Ans: 1) If the difference in the average speeds of the producer and consumer is significant,
 the advantage of the circular buffer is nullified. If the producer consistently ran faster than
 the consumer, it would almost always find the buffer full and would have to wait each time
  for a consumer to consume. If the consumer consistently ran faster than the producer, it
would almost always find the buffer empty and would have to wait each time for a producer
 to produce. In these cases, a single-value buffer can be used without loss of performance. 2)
Yes. Mutual exclusion would still be enforced by the monitor. The producer would still pro-
duce values as normal. Only one consumer would read each piece of data from the producer.

6.2.4 Monitor Example: Readers and Writers
In computer systems, it is common to have some consumer threads (called readers)
that read data and producer threads (called writers) that write it. For example, in an
airline reservation system there may be many more readers than writers—many
 inquiries will be made against the database of available flight information before
the customer actually selects and commits to a particular seat on a particular flight.
      Because readers do not change the contents of the database, many readers
may access the database at once. But a writer can modify the data, so it must have
exclusive access. When a writer is active, no other readers or writers may be active.
This exclusion needs to be enforced only at the record level. It is not necessary to
grant a writer exclusive access to the entire database —doing so could dramatically
hurt performance.
      The problem of designing a concurrent program to control access of readers
and writers to a database was first posed and solved by Courtois, Heymans, and Par-
nas.48 The solution in Fig. 6.3 is based on that developed by Hoare. 49
      The monitor in Figure 6.3 may be used to control access to an entire database,
a subset of the database consisting of many or few records, or even a single record.
In any of these cases, the following discussion applies. Only one writer may be
active at a time; when a writer is active, the boolean variable wri teLock (line 4) is
true. No readers may be active when a writer is active.The integer variable, read-
ers (line 3), indicates the number of active readers. When the number of readers is

<!-- pág. 316 -->

258 Concurrent Programming



                               1   // Fig. 6.3: Readers/writers problem
                               2
                               3   int readers = 0; // number of readers
                               4   boolean writeLock = false; // true if a writer is writing
                               5   Condition canWrite; // condition variable
                               6   Condition canRead; // condition variable
                               7
                               8   // monitor entry called before performing read
                               9   monitorEntry void beginRead()
                              10   {
                              11       // wait outside monitor if writer is currently writing or if
                              12       // writers are currently waiting to write
                              13       if ( writeLock || queue( canWrite ) )
                              14       {
                              15           wait( canRead ); // wait until reading is allowed
                              16       } // end if
                              17
                              18       ++readers; // there is another reader
                              19
                              20      signal( canRead ); // allow waiting readers to proceed
                              21   } // end beginRead
                              22
                              23   // monitor entry called after reading
                              24   monitorEntry void endReadO
                              25   {
                              26    --readers;   // there are one fewer readers
                              27
                              28       //if no more readers are reading, allow a writer to write
                              29       if ( readers == 0 )
                              30       {
                              31          signal ( canWrite ); // allow a writer to proceed
                              32       } // end if
                              33
                              34   } // end endRead
                              35
                              36   // monitor entry called before performing write
                              37   monitorEntry void beginWrite()
                              38   {
                              39      / / w a i t i f readers are reading o r i f a w r i t e r i s w r i t i n g
                              40      if ( readers > 0 || writeLock )
                              41      {
                              42          w a i t ( canWrite ) ; / / w a i t u n t i l w r i t i n g i s allowed
                              43      } / / end i f
                              44

                             Figure 6.3 | Monitor pseudocode for solving the readers and writers problem.
                             (Part 1 of 2.)

<!-- pág. 317 -->

                                                                                          6.2 Monitors 259

  45    writeLock = true; // "lock out all readers and writers
  46 } // end beginWrite
  47
  48 // monitor entry called after performing write
  49 monitorEntry void endWrite()
  50   {
  51       writeLock = false; // release lock
  52
  53       // if a reader is waiting to enter, signal a reader
  54       if ( queue( canRead ) )
  55       {
  56          signal( canRead ); // cascade in waiting readers
  57       } // end if
  58       else // signal a writer if no readers are waiting
  59
           {
  60
              signal( canWrite ); // one waiting writer can proceed
  61
           } // end else
  62
  63   } // end endWrite

Figure 6.3 | Monitor pseudocode for solving the readers and Writers problem.
 (Part 2 of 2.)

reduced to zero (line 29), then one waiting writer (if there is one) becomes active
(line 31). If a new reader cannot proceed (line 13), it waits on the condition variable
 canRead (line 15). If a new writer cannot proceed (line 40), it waits on the condition
 variable canWrite (line 42).
       When a reader wishes to read, it calls monitor entry beginRead (lines 8-21); a
reader that has finished calls endRead (lines 23-34). In beginRead, a new reader can
proceed as long as no thread is writing and no writer thread is waiting to write (line
 13). The latter condition is important for preventing indefinite postponement of wait-
ing writers; it is tested by using the boolean function, queue, which determines
whether or not threads are waiting on the condition variable specified in its argument.
Note that procedure begi nRead ends by signaling canRead (line 20) to allow another
waiting reader to begin reading. This causes the next reader in the queue of waiting
readers to become active and, in turn, signal the next waiting reader to proceed. This
"chain reaction," also called a cascade, will continue until all waiting readers have
become active. While this chaining is progressing, all arriving threads are forced to
wait because the monitor observes the rule that signaled threads are serviced before
arriving threads. If arriving readers were allowed to proceed, then a continuous
stream of arriving readers would cause indefinite postponement of waiting writers.
Since the readers do not interfere with one another and can be run in parallel on mul-
tiprocessor systems, this is an efficient way to service these threads.
       When a thread is done reading, it calls monitor entry endRead (lines 23-34),
which decrements the number of readers by 1 (line 26). Eventually, this decrement-
ing causes the number of readers to become zero, at which point the thread signals

<!-- pág. 318 -->

260 Concurrent Programming
                             canWrite (line 31) to allow a waiting writer, if there is one, to proceed (preventing
                             indefinite postponement of waiting writers).
                                   When a thread wishes to write, it calls monitor entry beginWrite (lines 36-
                             46). Because a writer must have exclusive access, if there are any readers or if there
                             is an active writer (line 40), the new writer must wait on condition variable can-
                             Write (line 42). When the writer is able to proceed (because canWrite is signaled
                             in line 31 or line 60), writeLock is set to t r u e (line 45). This keeps out any other
                             readers and writers.
                                   When a writer finishes, it calls monitor entry endWrite (lines 48-63).This pro-
                             cedure sets writeLock to f a l s e (line 51) so that either readers or another writer
                             can become active. The monitor then must signal another waiting thread to proceed
                             (lines 53-61). Should it give preference to a waiting reader or a waiting writer? If it
                             gives preference to a waiting writer, then it will be possible for a steady stream of
                             incoming writers to cause the indefinite postponement of waiting readers. There-
                             fore, as a writer finishes, it first checks if there is a waiting reader (line 54). If so.
                             then can Read is signaled (line 56) and the waiting reader proceeds (and this, of
                             course, cascades in all waiting readers). If there is no waiting reader, then canWrite
                             is signaled (line 60) and a waiting writer is allowed to proceed.

                         Self Review
                             1. Figure 6.3 cascades in waiting readers, but never cascades in waiting writers. Why?
                             2. What safeguard is there against a steady stream of readers indefinitely postponing a
                                writer?
                         Ans: 1) Readers don't interfere with one another, so many readers can safely read at once.
                         Each writer, however, must have exclusive access, or indeterminate results could occur. 2) In
                         monitory entry beginRead, if there are any writers waiting to write (line 13), then a thread
                         that wishes to read must wait on condition variable canRead (line 15).




                             6.3 Java Monitors
                             In the following sections, we present complete, working Java multithreaded solu-
                             tions to common concurrent programming problems. Monitors are associated with
                             every object created in Java. Monitors are also the primary mechanism to provide
                             mutual exclusion and synchronization in multithreaded Java applications. The key-
                             word synchronized imposes mutual exclusion on an object in Java. In this section,
                             we explain how Java monitors differ from the pseudocode monitors discussed in the
                             previous section.
                                     When a thread attempts to execute a method protected by a Java monitor
                             (i.e., the method is declared synchronized), it must first enter that monitor's entry
                             set (commonly referred to as an entry queue), which is a queue of threads awaiting
                             entry into the monitor. If there is no contention for entry into the monitor, a thread
                             will immediately enter the monitor. If a thread is already inside the monitor, other
                             threads must remain in the entry set until the monitor becomes available.

<!-- pág. 319 -->

                                                                   6.4 Producer/Consumer Relationship in Java 261

        Java monitors are typically referred to as signal-and-continue monitors.50
 Recall that a signal-and-continue monitor allows a thread inside the monitor to sig-
       nal that the monitor will soon become available, but still maintain a lock on the
 monitor until it exits. A thread can exit the monitor by waiting on a condition vari-
   able or by completing execution of the code protected by the monitor.
        A thread, executing in a monitor, that must wait on a condition variable issues
the wait call. The wait method causes the thread to release the lock on the monitor
   and wait on an unnamed condition variable. After calling wai t, a thread is placed in
     the wait set (also commonly referred to as the wait queue), a queue of threads wait-
 ing to reenter the monitor for the object. Threads remain in the wait set until sig-
 ---ed (notified) by another thread. Because the condition variable is implicit in
Java. a thread may be signaled, reenter the monitor and find that the condition on
which it waited has not been met. Consequently, a thread may be signaled several
   times before the condition on which it is waiting is met.
        Threads issue signals by calling method notify or notifyAll. The notify
method wakes a single thread in the wait set. The algorithm that determines which
  thread will enter the monitor next varies, depending on the Java virtual machine
  (JVM) implementation. As a result, the programmer cannot rely on a particular
queuing discipline when noti f y is called.
        Another pitfall of the notify method is that the order in which some JVM
 implementations remove threads from the entry and wait sets might introduce
lengthy service delays for particular threads in these sets—creating the possibility
   of indefinite postponement. As a result, if more than two threads access a monitor,
it is best to use the notifyAll method, which wakes all threads in the entry and
wait sets. When all threads are awake, the thread scheduler determines which
  thread acquires the monitor. The thread scheduler employs a queue discipline that
prevents indefinite postponement.51, 52 Because notifyAll wakes all threads wait-
ing to enter the monitor (as opposed to notify, which wakes a single thread),
notifyAll incurs more overhead than notify. In the simple case of two-thread syn-
chronization, noti f y yields higher performance than notifyAll without suffering
from indefinite postponement.

Self Review
1. What is the difference between signal-and-continue monitors and signal-and-exit moni-
   tors? Which type does Java use?
Ans: 1) Java uses signal-and-continue monitors. They allow a thread to signal that it will
soon be exiting the monitor, yet retain control of the monitor. Signal-and-exit monitors
require that a thread release its lock on the monitor immediately after signaling.


6.4 Java Multithreading Case Study, Part III:
Producer/Consumer Relationship in Java
In this section, we present a Java implementation of the producer/consumer rela-
tionship investigated in Section 5.2.1, Java Multithreading Case Study, Part II. The

<!-- pág. 320 -->

262 Concurrent Programming

                         application in Fig. 6.4 and Fig. 6.5 demonstrates a producer and a consumer access-
                         ing a single shared buffer, with synchronization provided by a monitor. In this case,
                         the producer produces a new value only when the buffer is empty, making the
                         buffer full; the consumer consumes a value only when the buffer is full, making the
                         buffer empty. This example reuses interface Buffer (Fig. 5.1) and classes Producer
                         (Fig. 5.2) and Consumer (Fig. 5.3) from the example of Section 5.2.1. Reusing these
                         classes from the example without synchronization enables us to demonstrate that
                         the threads accessing the shared object are unaware that they are being synchro-
                         nized. The code that performs the synchronization is placed in the s e t and get
                         methods of class SynchronizedBuffer (Fig. 6.4), which implements interface
                         Buffer (line 4). Thus, the Producer's and Consumer's run methods simply call the
                         shared object's s e t and get methods as in the example of Section 5.2.1.
                                Class SynchronizedBuffer (Fig. 6.4) contains two fields—buffer (line 6)
                         and occupiedBuffers (line 7). Method s e t (lines 9-43) and method get (lines 45-
                         79) are now synchronized methods (lines 10 and 46); thus, only one thread can
                         enter any of these methods at a time on a particular SynchronizedBuffer object.
                         Although occupiedBuffers (line 7) is logically a condition variable, it is of type
                         i nt; there is no object or type in Java that directly represents a condition variable.
                         The methods in SynchronizedBuffer use occupiedBuffers in conditional
                         expressions (lines 16 and 52) to determine whether it is the producer's or the con-
                         sumer's turn to perform a task. If occupiedBuffers is zero, buffer is empty and
                         the producer can place a value into buffer (line 34). This condition (line 52) also
                         means that the consumer must wait (line 59) in the get method to read the value of
                         buffer (again, because it is empty). If occupi edBuffers is one, the consumer can
                         read the value from buffer, because it contains new information. This condition
                         (line 16) also means that the producer must wait to place a value into buffer,
                         because it is currently full.


                              1   // Fig. 6.4: SynchronizedBuffer.Java
                              2   // SynchronizedBuffer synchronizes access to a shared integer.
                              3
                              4   public class SynchronizedBuffer implements Buffer
                              5   {
                              6      private int buffer = -1; // shared by producer and consumer
                              7      private int occupiedBuffers = 0; // counts occupied buffers
                              8
                              9     // place value into buffer
                             10     public synchronized void set( int value )
                             11     {
                             12           // for display, get name of thread that called this method
                             13           String name = Thread.currentThread() .getName() ;
                             14

                         Figure 6.4 I      SynchronizedBuffer synchronizes access to a shared integer.
                         (Part 1 of 3.)

<!-- pág. 321 -->

                                                        6.4 Producer/Consumer Relationship in Java   263



  15        // while no empty buffers, place thread in waiting state
  16        while ( occupiedBuffers == 1 )
  17        {
 18             // output thread and buffer information, then wait
 19             try
 20             {
 21         System.err.println(        name + " tries to write." );
 22                 displayState( "Buffer full. " + name + " waits." );
 23                 wait(); // wait until buffer is empty
 24             } // end try
 25
 26             // if waiting thread interrupted, print stack trace
 27             catch ( InterruptedException exception )
 28             {
 29                exception.printStackTrace();
 30             } // end catch
 31
 32         } // end while
 33
 34         buffer = value; // set new buffer value
 35
 36         // indicate producer cannot store another value
 37         // until consumer retrieves current buffer value
 38         ++occupiedBuffers;
 39
 40         displayStateC name + " writes " + buffer );
 41
 42         notify(); // tell waiting thread to enter ready state
 43      } // end method set; releases lock on SynchronizedBuffer
 44
 45      // return value from buffer
 46      public synchronized int get()
 47      {
 48         // for display, get name of thread that called this method
 49         String name = Thread.currentThread().getName();
 50
 51         // while no data to read, place thread in waiting state
 52         while ( occupiedBuffers == 0 )
 53         {
 54            // output thread and buffer information, then wait
 55            try
 56            {
 57                System.err.println( name + " tries to read." );
 58               displayStateC "Buffer empty. " + name + " waits." );

Figure 6.4 | SynchronizedBuffer synchronizes access to a shared integer.
(Part 2 of 3.)

<!-- pág. 322 -->

264 Concurrent Programming

                             59                w a i t ( ) ; / / w a i t u n t i l b u f f e r contains new values
                             60            } / / end t r y
                             61
                             62            / / i f waiting thread interrupted, print stack trace
                             63            catch ( InterruptedException exception )
                             64            {
                             65                exception.printStackTrace();
                             66            } // end catch
                             67
                             68        } // end while
                             69
                             70         // indicate that producer can store another value
                             71         // because consumer just retrieved buffer value
                             72         --occupiedBuffers;
                             73
                             74         displayState( name + " reads " + buffer );
                             75
                             76        notify(); // tell waiting thread to become ready
                             77
                             78         return buffer;
                             79      } // end method get; releases lock on SynchronizedBuffer
                             80
                             81     // display current operation and buffer state
                             82     public void displayState( String operation )
                             83     {
                             84        StringBuffer outputLine = new StringBuffer( operation );
                             85        outputLine.setLength( 40 );
                             86        outputLine.append( buffer + "\t\t" + occupiedBuffers );
                             87        System.err.println( outputLine );
                             88        System.err.println();
                             89     } // end method displayState
                             90
                             91   } // end class SynchronizedBuffer

                         Figure 6.4 | Synchronizedbuffer synchronizes access to a shared integer.
                         (Part 3 of 3.)

                               When the Producer thread's run method invokes synchronized method set
                         (from line 26 of Fig. 5.2), the thread attempts to acquire a lock on the Synchro-
                         nizedBuffer monitor object. [Note:When we talk about "acquiring a lock" on a Java
                         monitor, we mean "gaining mutually exclusive access to a monitor" in the generic dis-
                         cussion of monitors in Section 6.2, Monitors.] If the lock is available, the Producer
                         thread acquires the lock. Then the loop in method set (lines 16-32 of Fig. 6.4) deter-
                         mines whether occupiedBuffers is equal to one. If so, buffer is full, so line 21 out-
                         puts a message indicating that the Producer thread is trying to write a value, and line
                         22 invokes method displayState (lines 81-89) to output another message indicating
                         that the buffer is full and that the Producer thread is in the waiting state. Note that

<!-- pág. 323 -->

                                                                    6.4 Producer/Consumer Relationship in Java 265

 method d i s p l a y S t a t e is not declared Synchronized because it is called in method
main (line 18 of Fig. 6.5) before the producer and consumer threads are created and
  thereafter only from inside Synchronized methods get and s e t (lines 10 and 46 of
 Fig.6.4). Only one thread can execute inside the SynchronizedBuffer's monitor at
   once and di spl a y S t a t e is accessed only from inside the monitor, so mutually exclu-
sive access is enforced without needing to declare d i s p l a y S t a t e Synchronized.
       Line 23 invokes method wait (inherited from Object by Synchronized-
 Buffer; all Java classes inherit from Object directly or indirectly) to place the
  thread that called method s e t (i.e., the Producer thread) in the waiting state for
  the SynchronizedBuffer object. The call to wait causes the calling thread to
release the lock on the SynchronizedBuffer object. This is important because the
 nread cannot currently perform its task—and holding the lock would prevent other
 threads from accessing the object. This would result in deadlock, because the condi-
tion variable on which the first thread was waiting would never change. After the
rroducer thread calls wait in line 23, another thread can attempt to acquire the
SynchronizedBuffer object's lock and invoke the object's s e t or get methods—
 n particular, a consumer thread can now empty the buffer, eventually allowing the
waiting producer to proceed.
      The producer thread remains in the waiting state until it is notified by another
thread that it may proceed—at which point the producer thread returns to the
ready state and waits for a processor. When the producer thread returns to the run-
ning state, the thread implicitly attempts to reacquire the lock on the Synchro-
nizedBuffer object. If the lock is available, the producer reacquires the lock and
method s e t continues executing with the next statement after wai t. Because wai t
is called in a loop (lines 15-32), the loop continuation condition is tested to deter-
mine whether the thread can proceed with its execution. If not, wai t is invoked
again; otherwise, method s e t continues with the next statement after the loop.
      Line 34 in method s e t assigns the argument value to buffer. Line 38 incre-
ments occupiedBuffers to indicate that the buffer now contains a value (i.e., a
consumer can read the value, but a producer cannot put another value there yet).
Line 40 invokes method di spl a y S t a t e to output a line to the console window indi-
cating that the producer is writing a new value into the buffer. Line 42 invokes
method n o t i f y (inherited from Object). If the consumer thread is waiting, it
enters the ready state, where it can attempt its task again (as soon as the thread is
assigned a processor). Method n o t i f y returns immediately and method s e t
returns to its caller. [Note: Invoking method noti f y works correctly in this program
because only one thread calls method get at any time (the consumer thread). Pro-
grams that have multiple threads waiting on a condition should invoke notifyAll
to ensure that multiple threads receive notifications properly.] When method s e t
returns, it implicitly releases the lock on the SynchronizedBuffer object.
      Methods get and s e t are implemented similarly. When the consumer thread's
run method invokes synch roni zed method get (from line 28 of Fig. 5.3), the thread
attempts to acquire a lock on the SynchronizedBuffer object. When it acquires the

<!-- pág. 324 -->

266 Concurrent Programming

                         lock, the while loop (lines 51-68 of Fig. 6.4) determines whether occupiedBuffers
                         is equal to 0. If so, the buffer is empty, so line 57 outputs a message indicating that the
                         consumer thread is trying to read a value, and line 58 invokes method d i s p l a y S t a t e
                         to output another message indicating that the buffer is empty and that the consumer
                         thread waits. Line 59 invokes method want to place the consumer thread that called
                         method get in the waiting state for the SynchronizedBuffer object. Again, the call
                         to wait causes the calling thread to release the lock on the SynchronizedBuffer
                         object, so another thread can attempt to acquire the lock and invoke the object's s e t
                         or get method. If the lock on the SynchronizedBuffer is not available (e.g., if the
                          ProducerThread has not yet returned from method s e t ) the consumer thread is
                         blocked until the lock becomes available.
                                The consumer thread object remains in the waiting state until it is notified by
                         the producer thread that it may proceed—at which point the consumer thread returns
                         to the ready state and waits a processor. When it returns to the running state, the
                         thread implicitly attempts to reacquire the lock on the SynchronizedBuffer object.
                         If the lock is available, the consumer thread reacquires it and method get continues
                         executing with the next statement after the wait. Because wai t is called in a loop
                         (lines 51-68), the loop continuation condition is tested to determine whether the
                         thread can proceed. If not, wait is invoked again; otherwise, method get continues
                         with the next statement after the loop. Line 72 decrements occupiedBuffers to indi-
                         cate that buffer is now empty, line 74 outputs a line to the console window indicating
                         the value the consumer just read and line 76 invokes method notify. If the producer
                         thread is waiting for the lock on this SynchronizedBuf f er object, it enters the ready
                         state. As soon as it is assigned a processor, the thread will attempt to reacquire the
                         lock and continue performing its task. Method n o t i f y returns immediately, then
                         method get returns the value of buffer to its caller (line 78). [Note: Again, invoking
                         method n o t i f y works correctly in this program because only one thread calls
                         method set at any time (the producer thread).] When method get returns, the lock on
                         the SynchronizedBuffer object is released.
                                  Class SharedBufferTest2 (Fig. 6.5) is similar to class SharedBufferTest
                         (Fig. 5.5). SharedBufferTest2 contains method main (lines 6-27), which launches
                         the application. Line 9 instantiates a shared SynchronizedBuffer and assigns its
                         reference to SynchronizedBuffer variable sharedLocation. We use a Synchro-
                         ni zedBuffer variable rather than a Buffer variable, so that mai n can invoke Syn-
                         chronizedBuffer method d i s p l a y S t a t e , which is not declared in interface
                         Buffer. The SynchronizedBuffer object stores the data that is shared between
                         the producer and consumer threads. Lines 11-18 display the column heads for the
                         output. Lines 21-22 create a Producer object and a Consumer object, respectively,
                         and pass sharedLocation to each constructor, so each object is initialized with a
                         reference to the same SynchronizedBuffer. Next, lines 24-25 invoke method
                         s t a r t on the producer and consumer threads to place them in the ready state.This
                         launches these threads and sets up the initial call to each thread's run method.
                         Finally, method main terminates and the mai n thread of execution dies.

<!-- pág. 325 -->

                                                                       6.4 Producer/Consumer Relationship in JAVA 267

     Study the three sample outputs in Fig. 6.5. Observe that every integer produced
is consumed exactly once. The synchronization and the variable occupiedBuffers
ensure that the producer and consumer can execute only when it is their turn. The
producer must go first; the consumer must wait if the producer has not produced
since the consumer last consumed; the producer must wait if the consumer has not yet
consumed the value that the producer most recently produced. In the first and second
sample outputs, notice the comments indicating when the producer and consumer
must wait to perform their respective tasks. In the third sample output, notice that the
producer and consumer were fortuitously able to perform their tasks without waiting.

Self Review
1. Why does the displ ayState method not need to be declared as synchronized?
2. (T/F) If the noti f y method is never called in the get method, the producer will never fin-
   ish producing because it will be indefinitely postponed at line 23 of Fig. 6.4.
Ans: 1) Although occupi edBuffers is a shared resource, the only time that di spl ayState
is called is inside synchronized methods or when the program contains only one thread. 2)
False. It is possible that the buffer will never fill, in which case the producer will never exe-
cute line 23. This is the case in the third output of Fig. 6.5.


   1    // Fig. 6.5: SharedBufferTest2.Java
   2    // SharedBufferTest2creates producer and consumer threads.
   3
   4    public class SharedBufferTest2
   5    {
   6        public s t a t i c void main( String [] args )
   7        {
   8            // create shared object used by threads
   9            SynchronizedBuffer sharedLocation = new SynchronizedBufferO;
  10
  11           // Display column heads for output
  12           StringBuffer columnHeads =
  13              new StringBuffer( "Operation" );
  14           columnHeads.setLength( 40 );
  15           columnHeads.appendC "Buffer\t\tOccupied Count" );
  16           System.err.println( columnHeads );
  17           System.err.println();
  18           sharedLocation.displayStateC "Initial State" );
  19
  20            // create producer and consumer objects
  21            Producer producer = new Producer( sharedLocation );
  22            Consumer consumer = new Consumer( sharedLocation );
  23
  24           producer.start(); // start producer thread

Figure 6.5 | Threads modifying a shared object with synchronization. (Part 1 of 4.)

<!-- pág. 326 -->

268 Concurrent Programming

                             25          consumer.start(); // start consumer thread
                             26
                             27     } // end main
                             28
                             29   } // end class SharedBufferTest2

                             Sample Output 1:
                             Operation                                 Buffer             Occupied Count

                             Initial State                               -1                 0

                             Consumer tries to read.
                             Buffer empty. Consumer waits.               -1                 0

                             Producer writes 1                           1                  1

                             Consumer reads 1                            1
                                                                                            0
                             Consumer tries to read.
                             Buffer empty. Consumer waits.               1
                                                                                            0
                             Producer writes 2                           2
                                                                                            1
                             Consumer reads 2                            2
                                                                                            0
                             Producer writes 3                           3
                                                                                            1
                             Consumer reads 3                            3

                                                                                            0
                             Consumer tries to read.
                             Buffer empty. Consumer waits.               3

                                                                                            0
                             Producer writes 4                           4
                                                                                            1
                             Consumer reads 4                            4                 0
                             Producer done producing.
                             Terminating Producer.

                             Consumer read values totaling: 10.
                             Terminating Consumer.


                         Figure 6.5 | Threads modifying a shared object with syncronization. (Part 2 of 4.)

<!-- pág. 327 -->

                                                             6.4 Producer/Consumer Relationship in Java 269

 Sample Output 2:
   Operation                                   Buffer            Occupied Count

   Initial State                                -1                 0

 Consumer tries to read.
 Buffer empty. Consumer waits.                  -1                 0

   Producer writes 1                            1                  1

 Consumer reads 1                               1                  0

 Producer writes 2                              2                  1


 Producer tries to write.
 Buffer full. Producer waits.                   2                  1

 Consumer reads 2                               2                  0

 Producer writes 3                              3                  1

 Consumer reads 3                               3                  0

 Producer writes 4                              4                  1

 Producer done producing,
 Terminating Producer.
 Consumer reads 4                               4                  0

 Consumer read values totaling: 10.
 Terminating Consumer.



 Sample Output 3:
 Operation                                    Buffer             Occupied Count

 Initial State                                  -1                 0

 Producer writes 1                              1                  1

Figure 6.5 | Threads modifying a shared object with synchronization. (Part 3 of 4.)

<!-- pág. 328 -->

270 Concurrent Programming


                             Sample Output 3 (Cont.):
                             Operation                                  Buffer            Occupied Count

                             Initial State                               -1                 0

                             Producer writes 1                           1                  1

                             Consumer reads 1                            1                  0

                             Producer writes 2                           2                  1

                             Consumer reads 2                            2                  0

                             Producer writes 3                            3                 1

                             Consumer reads 3                            3                  0

                             Producer writes 4                           4                  1

                             Producer done producing.
                             Terminating Producer.
                             Consumer reads 4                            4                  0


                             Consumer read values totaling: 10.
                             Terminating Consumer.


                         Figure 6.5 | Threads modifying a shared object with synchronization (Part 4 of 4.)


                         6.5 Java Multithreading Case Study, Part IV:
                         Circular Buffer in Java
                         The program of Section 6.4 uses thread synchronization to guarantee that two
                         threads manipulate data in a shared buffer correctly. However, the application may
                         not perform optimally. If the two threads operate at different speeds, one of them
                         will spend more (or even most) of its time waiting. If the producer thread produces
                         values faster than the consumer can consume them, the producer will spend most of
                         its time waiting for the consumer. Similarly, if the consumer consumes faster than
                         the producer can produce them, the consumer will spend most of its time waiting
                         for the producer. Even when the threads operate at the same relative speeds, over a
                         period of time, occasionally those threads may become "out of sync," causing one of
                         them to wait for the other. We cannot and should not make assumptions about the
                         relative speeds of asynchronous concurrent threads. Too many interactions occur

<!-- pág. 329 -->

                                                                                      6.5     Circular Buffier in Java 271

  with the operating system, the network, the user and other system components that
. can cause the threads to operate at different and unpredictable speeds. When this
 happens in the producer/consumer example, one thread must wait. When threads
spend a significant portion of their time waiting, programs may become less effi-
cient, the system may become less responsive to interactive users and applications
may suffer long delays because the processor is not used efficiently.
      To minimize the waiting time for threads that share resources and operate at
the same average speeds, we know from earlier in this chapter that we can imple-
ment a circular buffer that provides extra buffer slots into which the producer can
place values at times when it is running faster than the consumer and from which
the consumer can retrieve those values when it is running faster than the producer.
      The key to using a circular buffer is to provide it with sufficient buffer slots to
handle the anticipated "extra" production. If, over a period of time, we determine
that the producer often produces as many as three more values than the consumer
can consume, we can provide a buffer of three or more slots to handle the extra pro-
duction. If the number of buffer slots is too small, threads will wait more; if too
large, that would waste memory.
        The Java program of Fig. 6.6-Fig. 6.7 demonstrates a producer and a con-
sumer accessing a circular buffer (in this case, a shared array of three cells) with
synchronization. In this version of the producer/consumer relationship, the con-
sumer consumes a value only when the array is not empty and the producer pro-
duces a value only when the array is not full.
        Class Producer is slightly modified from the version presented in Fig. 5.2; this
version produces values from 11 to 20 (rather than 1-4). Class Consumer is slightly
modified from the version in Fig. 5.3; this version consumes ten (rather than four)
values from the circular buffer.
        The significant changes of Fig. 6.4-Fig. 6.5 occur in Ci r c u l a r B u f f e r
 (Fig. 6.6), which replaces SynchronizedBuffer (Fig. 6.4). C i r c u l a r B u f f e r con-
tains four fields. Array b u f f e r s (line 8) implements the circular buffer as a three-
element integer array. Variable occupiedBuffers (line 11) is the condition vari-
able that can be used to determine whether a producer can write into the circular
buffer (i.e., when occupiedBuffers is less than the number of elements in buff-
ers) and whether a consumer can read from the circular buffer (i.e., when occu-
piedBuffers is greater than 0). Variable readLocation (line 14) indicates the
position in b u f f e r s from which the next value can be read by a consumer. Variable
w r i t e L o c a t i o n (line 15) indicates the next location in buffers in which a value
can be placed by a producer.

   1   // Fig, 6.6: CircularBuffer.Java
   2   // CircularBuffer synchronizes access to an array of
   3   // shared buffers.

Figure 6.6 | SynchronizedBuffer controls a access to a shared array of integers.
(Part 1 of 5.)

<!-- pág. 330 -->

272 Concurrent Programming

                             4
                             5    public class CircularBuffer implements Buffer
                             6    {
                              7       // each array element is a buffer
                              8       private int buffers[] = { -1, -1, -1 };
                              9
                             10       // occupiedBuffers maintains count of occupied buffers
                             11       private int occupiedBuffers = 0;
                             12
                             13       // variables that maintain read and write buffer locations
                             14       private int readLocation = 0;
                             15       private int writeLocation = 0;
                             16
                             17       // place value into buffer
                             18       public synchronized void set( int value )
                             19       {
                             20           // get name of thread that called this method
                             21           String name = Thread.currentThread().getName();
                             22
                             23           // while buffer full, place thread in waiting state
                             24           while ( occupiedBuffers == buffers.length )
                             25           {
                             26              // output thread and buffer information, then wait
                             27              try
                             28              {
                             29                  System.err.println( "\nAll buffers full. " +
                             30                       name + " waits." );
                             31                  w a i t ( ) ; / / w a i t u n t i l space i s a v a i l a b l e
                             32              } / / end t r y
                             33
                             34              // if waiting thread interrupted, print stack trace
                             35              catch ( InterruptedException exception )
                             36              {
                             37                 exception.printStackTrace();
                             38              } // end catch
                             39
                             40           } // end while
                             41
                             42           // place value in writeLocation of buffers
                             43           buffers[ writeLocation ] = value;
                             44
                             45           // output produced value
                             46           System.err.println( "\n" + name + " writes " +
                             47              buffers[ writeLocation ] + " " ) ;
                             48

                         Figure 6.6 | SynchronizedBuffe controls access to a shared array of integers.
                         (Part 2 of 5.)

<!-- pág. 331 -->

                                                                          6.5 Circular Buffer in Java   273

 49          // indicate that one more buffer is occupied
 50          ++occupiedBuffers;
 51
 52          // update writeLocation for future write operation
 53          writeLocation = ( writeLocation + 1 ) % buffers.length;
 54
 55          // display contents of shared buffers
 56          System.err.println( createStateOutput() );
 57
 58          notify(); // return a waiting thread to ready state
 59       } // end method set
 60
 61       // return value from buffer
 62       public synchronized int get()
 63       {
 64          // get name of thread that called this method
 65          String name = Thread.currentThread().getName();
 66
 67          // while buffer is empty, place thread in waiting state
 68          while ( occupiedBuffers == 0 )
 69          {
 70             // output thread and buffer information, then wait
 71             try
 72             {
 73                 System.err.println( "\nAll buffers empty. " +
 74                    name + " waits." );
 75                wait(); // wait until buffer contains new data
 76             } // end try
 77
 78              // if waiting thread interrupted, print stack trace
 79              catch ( InterruptedException exception )
 80              {
 81                 exception.printStackTrace();
 82              } // end catch
 83
 84          } // end while
 85
 86          // obtain value at current readLocation
 87          int readValue = buffers[ readLocation ];
 88
 89          // output consumed value
 90          System.err.println( "\n" + name + " reads " +
 91             readValue + " " );
 92
 93          // decrement occupied buffers value

Figure 6.6 | SynchronizedBuffer controls access to a shared array of integers.
(Fart 3 of 5.)

<!-- pág. 332 -->

274 Concurrent Programming

                          94          --occupiedBuffers;
                          95
                          96          // update readLocation for future read operation
                          97          readLocation = ( readLocation + 1 ) % buffers.length;
                          98
                          99          // display contents of shared buffers
                         100     System.err.println(    createStateOutput()        );
                         101
                         102     notify();       // return a waiting thread to ready state
                         103
                         104          return readValue;
                         105       } // end method get
                         106
                         107       // create state output
                         108       public String createStateOutput()
                         109       {
                         110          // first line of state information
                         111          String output = "(buffers occupied: " +
                         112             occupiedBuffers + ")\nbuffers: ";
                         113
                         114          for ( int i = 0 ; i < buffers.length; ++i )
                         115          {
                         116             output += " " + buffers[ i ] + " ";
                         117          } // end for
                         118
                         119          // second line of state information
                         120          output += "\n         ";
                         121
                         122          for ( int i = 0; i < buffers.length; ++i )
                         123          {
                         124             output += "---- ";
                         125          } // end for
                         126
                         127          // third line of state information
                         128          output += "\n         ";
                         129
                         130          // append readLocation (R) and writeLocation (W)
                         131          // indicators below appropriate buffer locations
                         132          for ( int i = 0 ; i < buffers.length; ++i )
                         133          {
                         134             if ( i == writeLocation &&
                         135                  writeLocation == readLocation )
                         136             {
                         137                output += " WR ";
                         138             } // end if

                         Figure 6.6 | SyncbronizedBuffer controls access to a shared array of integers.
                         (Part 4 of 5.)

<!-- pág. 333 -->

                                                                                         6.5 Circular Buffer in Java 275

139                else if ( i == writeLocation )
140                {
141                   output += " W   ";
142                } // end if
143                else if ( i == readLocation )
144                {
145                   output += " R ";
146                } // end if
147                else
148                {
149                   output += "     ";
150                } // end else
151
152            } // end for
153
154            output += "\n";
155
156           return output;
157        } // end method createStateOutput
158
159    } // end class CircularBuffer

Figure 6.6 | SynchronizedBuffer controls access to a shared array of integers.
(Part 5 of 5.)

      CircularBuffer method s e t (lines 17-59) performs the same tasks as did the
SynchronizedBuffer in Fig. 6.4, with a few modifications. The while loop in lines
23-40 determines whether the producer must wait (i.e., all buffers are full). If so,
lines 29-30 output that the producer is waiting to perform its task. Then line 31
invokes method wai t to place the producer thread in the waiting state for the Ci r-
cularBuffer object. When execution eventually continues in line 43 after the whi 1 e
loop, the value written by the producer is placed in the circular buffer at location
writeLocation. Next, lines 46-47 output the value produced. Line 50 increments
occupiedBuffers—there is now at least one value in the buffer that the consumer
can read. Then, line 53 updates writeLocation for the next call to CircularBuffer
method s e t . The output continues at line 56 by invoking method c r e a t e S t a t e O u t -
put (lines 107-157), which outputs the number of occupied buffers, the contents of
the buffers and the current writeLocation and readLocation. Finally, line 58
invokes method n o t i f y to indicate that the consumer thread waiting on the Circu-
larBuffer object (if indeed the consumer is waiting) should proceed.
      Method get (lines 61-105) of class C i r c u l a r B u f f e r also performs the same
tasks as it did in Fig. 6.4, with a few minor modifications. The while loop in lines
67-84 determines whether the consumer must wait (i.e., all buffer slots are empty).
If the consumer thread must wait, lines 73-74 output that the consumer is waiting to
perform its task. Then, line 75 invokes method wai t to place the consumer thread
in the waiting state for the C i r c u l a r B u f f e r object. When execution eventually

<!-- pág. 334 -->

276 Concurrent Programming

                         continues at line 87 after the while loop, readValue is assigned the value at loca-
                         tion readLocation in the circular buffer. Lines 90-91 output the consumed value.
                         Line 94 decrements the occupiedBuffers—there is now at least one open position
                         in the buffer in which the producer thread can place a value. Then, line 97 updates
                         readLocation for the next call to C i r c u l a r B u f f e r method get. Line 100 invokes
                         method c r e a t e S t a t e O u t p u t to output the number of occupied buffers, the con-
                         tents of the buffers and the current w r i t e L o c a t i o n and readLocation. Finally,
                         line 102 invokes method n o t i f y to indicate that the producer thread waiting for
                         the C i r c u l a r B u f f e r object (if indeed the producer is waiting) should proceed, and
                         line 104 returns the consumed value to the calling method. Note that because Java
                         implements signal-and-continue monitors, this program does not require the output
                         parameter discussed in Section 6.2.3, Monitor Example: Circular Buffer.
                                  Class C i r c u l a r B u f f e r T e s t (Fig. 6.7) contains the main method (lines 8—24)
                         that launches the application. Line 13 creates the CircularBuff er object sharedLo-
                         c a t i o n . Lines 19-20 create the producer and consumer threads, and lines 22-23
                         start them. The sample outputs include the current occupi edBuffers, the contents
                         of the buffers and the current w r i t e L o c a t i o n and readLocation. In the output,
                         the letters W and R represent the current w r i t e L o c a t i o n and readLocation.
                         respectively. Notice that, after the third value is placed in the third element of the
                         buffer, the fourth value is inserted back at the beginning of the array—this is the
                         circular buffer effect.

                             1    // Fig. 6.7: CircularBufferTest.Java
                             2    // CircularBufferTest shows two threads manipulating a
                             3    // circular buffer.
                             4
                             5    // set up the producer and consumer threads and start them
                             6    public class CircularBufferTest
                             7 {
                             8       public s t a t i c void main ( String args[] )
                             9       {
                             10           // create shared object for threads; use a reference
                             11           // to a CircularBuffer rather than a Buffer reference
                             12           // to invoke CircularBuffer method createStateOutput
                             13           CircularBuffer sharedLocation = new CircularBuffer();
                             14
                             15           // display initial state of buffers in CircularBuffer
                             16           System.err.println( sharedLocation.createStateOutput() );
                             17
                             18           // set up threads
                             19           Producer producer = new Producer( sharedLocation );
                             20           Consumer consumer = new Consumer( sharedLocation );
                             21

                         Figure 6.7 | CircularBufferTest instantiates producer and consumer threads.
                         (Part 1 of 6.)

<!-- pág. 335 -->

                                                                              6.5 Circular Buffer in Java> 277

  22            producer.start(); // start producer thread
  23            consumer.start(); // start consumer thread
  24         } // end main
  25
  26   } // end class CircularBufferTest

 Sample Output:




Figure 6.7     |   CircularBufferTest instantiates producer and consumer threads.
(Part 2 of 6.)

<!-- pág. 336 -->

278 Concurrent Programming




                         Figure 6.7   |   CircularBufferTest instantiates producer and consumer threads.
                         (Part 3 of 6.)

<!-- pág. 337 -->

                                                                       6.5 Circular Buffer in Java 279




Figure 6.7 | CircularBufferTest instantiates producer and consumer threads.
(Part 4 of 6.)

<!-- pág. 338 -->

2-80 foncurrefit Prtyrammjng




                               Figure 6.7   |   CircularBufferTest instantiates producer and consumer threads.
                               (Part 5 of 6.)

<!-- pág. 339 -->

                                                                                                         Web Resources 281


 Sample Output (Cont.):

 Consumer read values totaling: 155.
 Terminating Consumer.

Figure 6.7 |       CircularBufferTest instantiates producer and consumer threads.
(Part 6 of 6.)

Self Review
1. What are the potential costs and benefits of making the circular buffer larger?
1 What would happen if line 102 of Fig. 6.6 was omitted?
Ans: 1) The potential benefit is that the producer can produce more and block less if the
consumer is temporarily slower than the producer. However, this could result in wasted
memory if both the consumer and producer work at the same speed, if one works much
faster than the other or if the producer rarely, if ever, gets far enough ahead of the consumer
to take advantage of the extra space. 2) The consumer thread would complete without issuing
the notify. If the producer fortuitously never waits for the consumer (indeed a rare occur-
rence), then the system would function correctly. More commonly, however, if the producer
were waiting it would never be able to proceed, i.e., the producer could be deadlocked.


WebResources
 developer.java.sun.com/developer/Books/                             java.sun.com/docs/books/tutorial/essential/
 performance2/chap4.pdf                                             threads/synchronization.html
This page from Sun's Web site provides a detailed description       This is Sun's example of implementing mutual exclusion in the
 of how to use Java monitors.                                       consumer/producer relationship in Java.
hissa.nist.gov/rbac/5277/titlerpc.html
 Compares several popular RPC implementations.



Summary
Concurrent programs are harder to write, debug, modify,             thread must call a monitor entry routine. Many threads
and prove correct than non-concurrent programs. None-               might want to enter the monitor at various times, but
theless, there has been a surge of interest in concurrent           mutual exclusion is rigidly enforced at the monitor bound-
programming languages because they enable us to express             ary. A thread that tries to enter the monitor when it is in
more naturally solutions to problems that are inherently            use is made to wait by the monitor.
parallel. The proliferation of multiprocessing systems, dis-               Eventually, the thread that has the resource will call a
tributed systems and massively parallel architectures has           monitor entry routine to return the resource. There might
also fueled the surge.                                              be threads waiting for the resource, so the monitor entry
       A monitor is an object that contains both the data           routine calls signal to allow one of the waiting threads to
and procedures needed to perform allocation one or more             acquire the resource and enter the monitor. To avoid indef-
serially reusable shared resources. Monitor data is accessi-        inite postponement, a monitor gives higher priority to wait-
ble only within the monitor; there is no way for threads            ing threads than to newly arrived threads.
outside the monitor to access monitor data directly. To                    Before a thread can reenter the monitor, the thread
accomplish a resource allocation function using monitors, a         calling signal must first exit the monitor. A signal-and-exit

<!-- pág. 340 -->

282 Concurrent Programming
monitor requires a thread to immediately exit the monitor              In computer systems, it is common to have some
upon signaling. Alternatively, a signal-and-continue monitor    threads (called readers) that read data and others (called
allows a thread inside the monitor to signal that the monitor   writers) that write it. Because readers do not change the
will soon become available, but still maintain a lock on the    contents of the database, many readers can access the data-
monitor until the thread exits the monitor. A thread can exit   base at once. But a writer can modify the data, so it must
the monitor by waiting on a condition variable or by com-       have exclusive access. A new reader can proceed as long as
pleting execution of the code protected by the monitor.         no thread is writing and no writer thread is waiting to write.
       A thread currently inside a monitor may need to wait     Each new reader signals the next waiting reader to pro-
outside the monitor until another thread performs an            ceed. This causes a "chain reaction" that continues until all
action inside the monitor. A monitor associates a separate      waiting readers have become active. While this chaining is
condition variable with each distinct situation that might      in progress, all arriving threads are forced to wait. During
cause a thread to have to wait. Every condition variable has    the chaining, arriving readers cannot enter the monitor,
an associated queue. A thread calling wai t on a particular     because the monitor observes the rule that signaled threads
condition variable is placed into the queue associated with     are serviced before arriving threads. If arriving readers
that condition variable; a thread calling signal on a partic-   were allowed to proceed, then a continuous stream of
ular condition variable causes a thread waiting on that con-    arriving readers would indefinitely postpone waiting writ-
dition variable (if there is such a thread) to be removed       ers. When the last reader leaves the monitor, the thread sig-
from the queue associated with that condition variable and      nals a waiting writer to proceed. When a writer finishes, it
to enter the monitor.                                           first checks if there is a waiting reader. If there is, the wait-
       In the circular buffer implementation of the solution    ing reader proceeds (again cascading in all waiting read-
to the producer/consumer problem, the producer deposits         ers). If there is no waiting reader, a waiting writer is
data in the successive elements of the shared array. The        allowed to proceed.
consumer removes them in the order in which they were                  Monitors are the primary mechanism providing
deposited (FIFO). The producer can be several items             mutual exclusion and synchronization in multithreaded Java
ahead of the consumer. Eventually, the producer fills the       applications. The keyword synchronized imposes mutual
last element of the array. When it produces more data, it       exclusion on an object in Java. Java monitors are signal-and-
must "wrap around" and again begin depositing data in the       continue monitors, allowing a thread to signal that the moni-
first element of the array.                                     tor will soon become available, but still maintain a lock on
       Because of the fixed size of the circular buffer, the    the monitor until the thread exits the monitor.
producer will occasionally find all the array elements full;           In Java, the wai t method causes the calling thread to
in this case the producer must wait until the consumer emp-     release the lock on the monitor and wait on an unnamed
ties an array element. Similarly, there will be times when      condition variable. After calling wai t, a thread is placed in
the consumer wants to consume, but the array will be            the wait set. A thread remains in the wait set until signaled
empty; in this case the consumer must wait until the pro-       by another thread. Because the condition variable is implicit
ducer deposits data into an array element.                      in Java, a thread may be signaled, reenter the monitor and
       If the two threads operate at different speeds, one of   find that the condition on which it waited has not been met.
them will spend more (or even most) of its time waiting. If            Threads issue signals by calling method notify or
the producer thread produces values faster than the con-        notifyAll. The noti f y method wakes a thread in the wait
sumer can consume them, the producer thread spends most         set. If more than two threads may access a monitor, it is best
of its time waiting for the consumer to remove the next         to use the notifyAll method, which wakes all threads in the
value from the array. Similarly, if the consumer thread con-    wait set. Because notifyAll wakes all threads attempting to
sumes values faster than the producer can produce them,         enter the monitor (instead of a single thread), notify can
the consumer thread spends most of its time waiting for the     yield higher performance in some applications.
producer to place the next value into the array.


Key Terms
bounded buffer—See circular buffer.                             circular buffer—In the producer/consumer relationship, a
                                                                     fixed-size region of shared memory that stores multiple

<!-- pág. 341 -->

                                                                                                               Exercises        283

    values produced by a producer. If the producer occasion-       notify—Java method that wakes one thread in a monitor's
    ally produces values faster than the consumer, a circular          wait set. The thread that is awakened depends on the
    buffer reduces the time the producer spends waiting for a          JVM implementation.
    consumer to consume the values, when compared to a
                                                                   notifyAll —Java method that awakens all threads in a moni-
    buffer that stores a single value. If the consumer tempo-
                                                                       tor's wait and entry sets. Method notifyAll ensures that
    rarily consumes values faster than the producer, a circular
                                                                       waiting threads are not indefinitely postponed, but incurs
    buffer can similarly reduce the time a consumer spends
                                                                       more overhead than notify.
    waiting for the producer to produce values.
condition variable—Variable that contains a value and an           serially reusable shared resource—Resource that can be used
    associated queue. When a thread waits on a condition                by only one thread at a time.
    variable inside a monitor, it exits the monitor and is         signal-and-continue monitor—Monitor that allows a thread to
    placed in the condition variable's queue. Threads wait in           signal that the monitor is available, but does not require
    the queue until signaled by another thread.                         the thread to release the lock until it exits the monitor, at
entry queue—See entry set.                                              which point a signaled thread may enter the monitor.
entry set—In Java, a queue of threads waiting to enter a moni-     signal-and-exit monitor—Monitor that requires a thread to
     tor after calling a synchronized method.                           release the lock on the monitor as soon as the thread sig-
information hiding—Software architectural technique that                nals another thread.
     facilitates the development of more reliable software sys-
                                                                   Solo—Small operating system created by Per Brinch Hansen
     tems by preventing direct access to data within an object
                                                                       to demonstrate fail-safe concurrent programming.
     by outside objects.
monitor—Concurrency construct that contains both the data          synchronization—Coordination between asynchronous con-
   and procedures needed to provide mutual exclusion while             current threads to sequentialize their access to shared
   allocating a serially reusable shared resource or group of          resources.
   serially reusable shared resources.                             synchronized—Java keyword that imposes mutual exclusive
monitor entry routine—Monitor routine that can be called by            access to code inside an object.
   any thread, but that can be executed by only one thread at
                                                                   wait queue—See wait set.
   a time. Unlike private monitor routines, which can be
   called only by threads executing inside the monitor, moni-      wait set—In Java, a set of threads waiting to reacquire the lock
   tor entry routines enforce mutual exclusion.                         on a monitor.




Exercises
6.1 Compare and contrast the use of monitors and sema-             6.6 Why is it considerably more difficult to test, debug, and
phore operations.                                                  prove program correctness for concurrent programs than for
                                                                   sequential programs?
6.2 When a resource is returned by a thread calling a moni-
tor, the monitor gives priority to a waiting thread over a new     6.7 The text states that information hiding is a system struc-
requesting thread. Why?                                            turing technique that contributes to the development of more
                                                                   reliable software systems. Why, do you suppose, is this so?
6.3 How do condition variables differ from conventional            6.8 Refer to the monitor described in Fig. 6.2 and answer
variables? Does it make sense to initialize condition variables?   each of the following questions.
6.4 The text has stated repeatedly that no assumptions                   a. Which procedure places data into the circular buffer?
should be made about the relative speeds of asynchronous                 b. Which procedure removes data from the circular
concurrent threads. Why?
                                                                            buffer?
6.5 What factors, do you suppose, would affect a designer's              c. Which queuing discipline best describes the opera-
choice of the number of slots a circular buffer should have?                tion of the circular buffer?

<!-- pág. 342 -->

284 Concurrent Programming

      d. Is this true: w r i t e r P o s i t i o n >= readerPosition?   has become one of the classic problems in concurrency control
      e. Which statements perform monitor initialization?               Three smokers are represented by threads S1, S2, and S3.
                                                                        Three vendors are represented by threads V1, V2, and V3.
      f. Which statement(s) can "wake up" a thread waiting
                                                                        Each smoker requires tobacco, a wrapper, and a match to
         on a condition variable?
                                                                        smoke; when these resources are available, the smoker smokes
      g. Which statement(s) can put a thread "to sleep"?                the cigarette to completion, then becomes eligible to smoke
      h. Which statement(s) ensure that the buffer "wraps               again. S1 has tobacco, S2 has wrappers, and S3 has matches. V1
         around"?                                                       supplies tobacco and wrappers, V2 supplies wrappers anc
      i. Which statement(s) modify a shared critical variable           matches, and V3 supplies matches and tobacco. V1, V2, and V3
         to indicate that another slot in the buffer is available?      operate in mutual exclusion; only one of these threads car.
                                                                        operate at a time and the next vendor cannot operate until
6.9 In the readers and writers monitor presented in Fig. 6.3            resources supplied by the previous vendor have been con-
why does it make sense to cascade in all waiting readers?               sumed by a smoker. Use a monitor to coordinate the operation
Could this cause indefinite postponement of waiting writers?            of the smoker and vendor threads.
Under what circumstances might you choose to limit the num-
ber of waiting readers you would initiate when reading is               6.12 Semaphores are at least as powerful as monitors. Show
allowed?                                                                how to implement a monitor by using semaphores.
6.10 (The Sleeping Barber Problem)53 A barbershop has a                 6.13 Use semaphores to solve the readers and writers problem.
cutting room with one chair and a waiting room with n chairs.           6.14 Implement the readers and writers problem. Model your
Customers enter the waiting room one at a time if space is              solution after the readers and writers solution in Fig. 6.2 and
available, otherwise they go to another shop. Each time the             the Java-based circular-buffer solution in Fig. 6.6 and Fig. 6.7.
barber finishes a haircut the customer leaves to go to another          6.15 Should a waiting thread receive priority over a thread
store, and a waiting customer, if there is one, enters the cutting      first attempting to enter a monitor? What priority scheme. if
room and has a haircut. Customers may enter the waiting                 any, should be imposed on waiting threads?
room one at a time, or waiting customers may enter the
(empty) cutting room one at a time, but these events are mutu-
                                                                        Suggested Project
ally exclusive. If the barber discovers that the waiting room is
                                                                        6.16 Prepare a research paper on concurrent programming in
empty, the barber falls asleep in the waiting room. An arriving
                                                                        video game consoles. Does the hardware provide mutual
customer, finding the barber asleep, wakes the barber and has
                                                                        exclusion primitives to the application programmer?
a haircut; otherwise the arriving customer waits. Use a monitor
to coordinate the operation of the barber and the clients. If
you know Java, also implement your monitor in Java.                     Suggested Simulation
                                                                        6.17 Extend the producer/consumer solution without a circu-
6.11 (The Cigarette Smokers Problem)54 [Note: One of the                lar buffer presented in Fig. 6.1 to handle multiple producers.
authors, HMD, worked with S. Patil and Jack Dennis in the
Computation Structures Group at M.I.T.'s Project Mac] This




Recommended Reading
Solutions to problems in concurrent programming have been               monitor has been attributed to Brinch Hansen 62 and Hoare.63
known for quite some time. Dijkstra55 was the first to truly            An excellent survey of monitors, which describes their history,
address such concerns, and he was soon followed by many oth-            taxonomy and usage, is presented by Buhr.64 For more detailed
ers.56, 57, 58, 59 Recent developments in mutual exclusion algo-        information about the Java programming language and concur-
rithms pertain to distributed systems and are beyond the scope          rent programming, see Java How to Program65 and Concurrent.
of this chapter. However, the reader is encouraged to study             Programming in Java: Design Principles and Pattern, 2nd ed.66
Lamport's survey of the mutual exclusion problem and some               The bibliography for this chapter is located on our Web site at
powerful results.60, 61 Initial development of the concept of a         www.deitel.com/books/os3e/Bibliography.pdf.

<!-- pág. 343 -->

                                                                                                                     Works Cited 285

Works Cited
 1. "Rationale for the Design of the Ada Programming Language,"          18. Hoppe, J., "A Simple Nucleus Written in Modula-2: A Case
    ACM SIGPLAN Notices, Vol. 14, No. 6, June 1979, Part B.                  Study," Software—Practice and Experience, Vol. 10, No. 9, Sep-
 2. Carvalho, O. S. F., and G. Roucairol, "On Mutual Exclusion in            tember 1980, pp. 697-706.
    Computer Networks," Communications of the ACM, Vol. 26, No.          19. Wirth, R, Programming in Modula-2, New York: Springer-Ver-
    2, February 1983, pp. 146-147.                                           lag, 1982.
 3. Liskov, B., and R. Scheifler, "Guardians and Actions: Linguistic     20. Ogilvie, J. W. L., Modula-2 Programming, New York: McGraw-
    Support for Robust, Distributed Programs," ACM Transactions              Hill, 1985.
    on Programming Languages and Systems, Vol. 5, No. 3, 1983, pp.       21. McGraw, J. R., "The VAL Language: Description and Analysis,"
    381-404.                                                                 ACM Transactions on Programming Languages, Vol. 4, No. 1,
 4. Shatz, S. M., "Communication Mechanisms for Programming                  January 1982, pp. 44-82.
    Distributed Systems," Computer, Vol. 17, No. 6, June 1984, pp.       22. Cook, R. P., "*MOD—A Language for Distributed Program-
    21-28.                                                                   ming," IEEE Transactions on Software Engineering, Vol. SE-6,
 5. Fisher, D. A., and R. M. Weatherly, "Issues in the Design of a           No. 6,1980, pp. 563-571.
    Distributed Operating System for Ada," Computer, Vol. 19, No.
                                                                         23. Dijkstra, E. W., "Hierarchical Ordering of Sequential Processes,"
    5, May 1986, pp. 38-47.
                                                                             Acta Informatica,Vol. 1,1971, pp. 115-138.
 6. Liskov, B. H.; M. Herlihy; and L. Gilbert, "Limitations of Syn-
                                                                         24. Brinch Hansen, P., "Structured Multiprogramming," Communi-
    chronous Communication with Static Process Structure in Lan-
                                                                             cations of the ACM, Vol. 15, No. 7, July 1972, pp. 574-578.
    guages for Distributed Computing," Proceedings of the 13th
    ACM Symposium on Principles of Programming Languages, St.            25. Brinch Hansen, P., Operating System Principles, Englewood
    Petersburg, Florida, January 1986.                                       Cliffs, N.J.: Prentice Hall, 1973.
 7. Shatz, S. M., and J. Wang, "Introduction to Distributed-Software     26. Hoare, C. A. R., "Monitors: An Operating System Structuring
    Engineering," Computer,, Vol. 20, No. 10, October 1987, pp. 23-32.       Concept," Communications of the ACM, Vol. 17, No. 10, October
                                                                             1974, pp. 549-557. Corrigendum, Communications of the ACM,
 8. Roberts, E. S.; A. Evans, Jr.; C. R. Morgan; and E. M. Clarke,
                                                                             Vol. 18, No. 2, February 1975, p. 95.
    "Task Management in Ada—A Critical Evaluation for Real-
    Time Multiprocessors," Software—Practice and Experience, Vol.        27. Brinch Hansen, P., "The Solo Operating System: Processes, Mon-
    11, No. 10, October 1981, pp. 1019-1051.                                 itors, and Classes," Software—Practice and Experience, Vol. 6,
 9. Nielsen, K. W., and K. Shumate, "Designing Large Real-Time               1976, pp. 165-200.
    Systems with Ada," Communications of the ACM, Vol. 30, No. 8,        28. Howard, J. H., "Proving Monitors," Communications of the ACM,
    August 1987, pp. 695-715.                                                Vol. 19, No. 5, May 1976, pp. 273-279.
10. Ford, R., "Concurrent Algorithms for Real-Time Memory Manage-        29. Howard, J. H., "Signaling in Monitors," Second International
    ment," IEEE Software,Vol. 5, No. 5, September 1988, pp. 10-24.           Conference on Software Engineering, San Francisco, October
11. "Preliminary Ada Reference Manual," ACM SIGPLAN Notices,                 1976, pp. 47-52.
    Vol. 14, No. 6, June 1979, Part A.                                   30. Lister, A. M., and K. J. Maynard, "An Implementation of Moni-
12. Brinch Hansen, P., "The Programming Language Concurrent                  tors," Software—Practice and Experience,Vol. 6, No. 3, July 1976,
    Pascal," IEEE Transactions on Software Engineering, Vol. SE-1,           pp. 377-386.
    No. 2, June 1975, pp. 199-207.                                       31. Kessels, J. L. W., "An Alternative to Event Queues for Synchroni-
13. Coleman, D; Gallimore, R. M.; Hughes, J. W.; and M. S. Powell,           zation in Monitors," Communications of the ACM, Vol. 20, No. 7,
    "An Assessment of Concurrent Pascal," Software—Practice and              July 1977, pp. 500-503.
    Experience,Vol 9,1979, pp. 827-837.
                                                                         32. Keedy, I, "On Structuring Operating Systems with Monitors,"
14. Brinch Hansen, P., "Distributed Processes: A Concurrent Pro-             Australian Computer Journal, Vol. 10, No. 1, February 1978, pp.
    gramming Concept," Communications of the ACM, Vol. 21, No.               23-27, reprinted in Operating Systems Review, Vol. 13, No. 1, Jan-
    11, November 1978, pp. 934-941.                                          uary 1979, pp. 5-9.
15. Gehani, N H., and W. D. Roome, "Concurrent C," Software-             33. Lampson, B. W., and D. D. Redell, "Experience with Processes
    Practice and Experience,Vol 16, No. 9,1986, pp. 821-844.                 and Monitors in MESA," Communications of the ACM, Vol. 23,
16. Kieburtz, R. B., and A. Silberschatz, "Comments on 'Communi-             No. 2, February 1980, pp. 105-117.
    cating Sequential Processes,' " ACM Transactions on Program-         34. Wegner, P., and S. A. Smolka, "Processes, Tasks and Monitors: A
    ming Languages and Systems, Vol. 1, No. 2,1979, pp. 218-225.             Comparative Study of Concurrent Programming Primitives,"
17. Hoare, C. A. R., Communicating Sequential Processes, Engle-              IEEE Transactions on Software Engineering, Vol. SE-9, No. 4,
    wood Cliffs, NJ: Prentice-Hall, 1985.                                    July 1983, pp. 446-462.

<!-- pág. 344 -->

286 Concurrent Programming

35. Buhr, P. A.; Fortier, M; and Coffin, M., "Monitor Classifications,"   51. Venners, B. "Thread Synchronization", Chapter 20 of Inside the
    ACM Computing Surveys, Vol. 27, No. 1, March 1995, pp. 63-107.            Java Virtual Machine, last updated April 18, 2003,
36. Hoare, C. A. R., "Monitors: An Operating System Structuring               <www.artima.com/insidejvm/ed2/threadsynch.html>.
    Concept," Communications of the ACM', Vol. 17, No. 10, October        52. Christopher, T. W., and , G. K. Thiruvathukal, High-Performance
    1974, pp. 549-557.                                                        Java Platform Computing, Multithreaded and Networked Pro-
37. Buhr, P. A.; Fortier, M.; and Coffin, M., "Monitor Classification,"       gramming, Upper Saddle River, NJ: Prentice Hall PTR, Febru-
    ACM Computing Surveys,Vol. 27, No. 1, March 1995, pp. 63-107.             ary 2001, pp. 89-93.
                                                                          53. Dijkstra, E. W., "Solution of a Problem in Concurrent Program-
38. Brinch Hansen, P., "The Programming Language Concurrent
                                                                              ming Control," Communications of the ACM, Vol. 8, No. 5, Sep-
    Pascal," IEEE Transactions on Software Engineering, No. 2, June
                                                                              tember 1965,p.569.
    1975,199-206.
                                                                          54. Patil, S. S., "Limitations and Capabilities of Dijkstra's Semaphores
39. Syracuse University, "Biography," <web.syr.edu/~pbhansen/                 Primitives for Coordination among Processes," M.l.T. Project
    html/biography.html>.                                                     MAC Computational Structures Group Memo 57, February 1971
40. Syracuse University, "Biography." <web.syr.edu/~pbhansen/             55. Dijkstra, E. W., "Hierarchical Ordering of Sequential Processes,"
    html/biography.html>.                                                     Acta Informatica, Vol. 1,1971, pp. 115-138.
41. Brinch Hansen, P., Operating System Principles, Englewood             56. Knuth, D., "Additional Comments on a Problem in Concurrent
    Cliffs, NX: Prentice Hall, 1973.                                          Programming Control," Communications of the ACM,Vol. 9. No.
42. Brinch Hansen, P., "The Purpose of Concurrent Pascal." Pro-               5, May 1966, pp. 321-322.
    ceedings of the International Conference on Reliable Software, pp.    57. Bernstein, A. J. "Program Analysis for Parallel Processing,"
    305-309,1975.                                                             IEEE Transactions on Computers, Vol. 15, No. 5, October 1966,
                                                                              pp. 757-762.
43. Syracuse University, "Biography," <web.syr.edu/~pbhansen/
                                                                          58. Courtois, P. X; Heymans, E; and D. L. Parnas, "Concurrent Con-
    html/biography.html>.
                                                                              trol with Readers and Writers," Communications of the ACM
44. Brinch Hansen, P., "Java's Insecure Parallelism," SIGPLAN                 Vol. 14, No. 10, October 1971, pp. 667-668.
    Notices, Vol. 34, No. 4, pp. 38-45, April 1999.                       59. Lamport, L., "Concurrent Reading and Writing," Communica-
45. Brinch Hansen, P., "The Solo Operating System," Software—Prac-            tions of the ACM, Vol. 20, No. 11, November 1977, pp. 806-811.
    tice and Experience,Vol. 6, No. 2, pp. 141-205, April-June 1976.      60. Lamport, L., "The Mutual Exclusion Problem: Part I —A Theory
46. Brinch Hansen, P., "Joyce—A Programming Language for Dis-                 of Interprocess Communication," Journal of the ACM (JACM),
    tributed Systems," Software—Practice and Experience, Vol. 17,             Vol.33 No.2,April 1986,pp.313-326.
    No. 1, January 1987, pp. 29-50.                                       61. Lamport, L., "The Mutual Exclusion Problem: Part II —State-
47. Hoare, C. A. R., "Monitors: An Operating System Structuring               ment and Solutions," Journal of the ACM (JACM),Vol. 33 No. 2,
    Concept," Communications of the ACM. Vol. 17, No. 10, October             April 1986, pp. 327-348.
    1974, pp. 549-557. Corrigendum, Communications of the ACM,            62. Brinch Hansen, P., "Structured Multiprogramming," Communi-
    Vol. 18, No. 2, February 1975, p. 95.                                     cations of the ACM, Vol. 15, No. 7, July 1972, pp. 574-578.
48. Courtois, P. X; Heymans, F; and D. L. Parnas, "Concurrent Con-        63. Hoare, C. A. R., "Monitors: An Operating System Structuring
    trol with Readers and Writers," Communications of the ACM,                Concept," Communications of the ACM, Vol. 17, No. 10, October
    Vol. 14, No. 10, October 1971, pp. 667-668.                               1974, pp. 549-557. Corrigendum, Communications of the ACM
49. Hoare, C. A. R„ "Monitors: An Operating System Structuring                Vol. 18, No. 2, February 1975, p. 95.
    Concept," Communications of the ACM, Vol. 17, No. 10. October         64. Buhr, P. A.; Fortier, M.; and M. Coffin, "Monitor Classification."
    1974, pp. 549-557. Corrigendum, Communications of the ACM,                ACM Computing Surveys,Vol 27, No. 1, March 1995 pp. 63-107.
    Vol. 18, No. 2, February 1975, p. 95.                                 65. Deitel, H. M. and P. J. Deitel, Java How to Program, 5th ed.,
50. Hartley, S. X, "Concurrent Programming Using the Java Lan-                Upper Saddle River, NJ: Prentice Hall, 2003.
    guage," Modified: 30 December 1997, <www.mcs.drexel.edu/              66. Lea, D., Concurrent Programming in Java: Design Principles and
    ~shartley/ConcProglava/monitors.html>.                                    Pattern, 2nd ed., Reading, MA: Addison-Wesley, 1999.

<!-- pág. 345 -->

We had better wait and see.
      -H.H.Asquith-


Every man is the center of a circle, whose fatal circumference he cannot pass.
      —John James Ingalls—


Hold me but safe within the bond
Of one immortal look.
      — Robert Browning —


Detection is, or ought to be, an exact science, and should be treated in the same cold and
Unemotional manner.
      — Sir Arthur Conan Doyle —


Delays have dangerous ends.
      —William Shakespeare —

