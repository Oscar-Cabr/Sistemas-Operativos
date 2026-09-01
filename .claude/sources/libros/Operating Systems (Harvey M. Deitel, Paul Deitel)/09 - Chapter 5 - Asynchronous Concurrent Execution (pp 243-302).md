# Chapter 5 - Asynchronous Concurrent Execution

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 243–302 (numeración del PDF)

<!-- pág. 243 -->

Chapter 5



Asynchronous Concurrent
    Execution
  Objectives
  After reading this chapter, you should understand:
  • the challenges of synchronizing concurrent processes and threads.
  • critical sections and the need for mutual exclusion.
  • how to implement mutual exclusion primitives in software.
  • hardware mutual exclusion primitives.
  • semaphore usage and implementation.

<!-- pág. 244 -->

                       5.1                                      5.4.2 Peterson's Algorithm
                  Introduction                              5.4.3 N-Thread Mutual Exclusion:
                                                                 Lamport's Bakery Algorithm
                        5.2                                 Biographical Note: Leslie Lamport
               Mutual      Exclusion
       5.2.1 Java Multithreading Case Study,                              5.5
      Part II: A Producer/Consumer Relationship in             Hardware Solutions to the
                          Java                                 Mutual Exclusion Problem
                5.2.2 Critical Sections                          5.5.1 Disabling Interrupts
         5.2.3 Mutual Exclusion Primitives                    5.5.2 Test-and-Set Instruction
                                                                  5.5.3 Swap Instruction
                   5.3
      Implementing Mutual Exclusion                                       5.6
                Primitives                                           Semaphores
                                                          Biographical Note: Edsger W. Dihjstra
                   5.4                                    5.6.1 Mutual Exclusion with Semaphores
         Software Solutions to the                          5 . 6 . 2 Thread Synchronization with
         Mutual Exclusion Problem                                         Semaphores
             5.4.1 Dekker's Algorithm                            5.6.3 Counting Semaphores
       Anecdote: Why Should You Believe That                 5.6.4 Implementing Semaphores
        Your Software Is Functioning Correctly?               Anecdote: Unclear Requirements




         Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited




186

<!-- pág. 245 -->

                                                                                           5.1 Introduction 187

5.1 Introduction
In the previous two chapters, we introduced the concept of units of execution—
processes and threads. Once again, we will focus our discussion on threads in this
chapter, but most of what we say can apply to processes as well. If more than one
thread exists in a system at the same time, then the threads are said to be concur-
rent.1, 2, 3 Two concurrent threads can execute completely independently of one
another, or they can execute in cooperation. Threads that operate independently of
one another but must occasionally communicate and synchronize to perform coop-
erative tasks are said to execute asynchronously.4, 5 Asynchronism is a complex
topic—this chapter and Chapter 6, Concurrent Programming, discuss the organiza-
tion and management of systems that support asynchronous concurrent threads.
       We begin with a Java example that demonstrates the difficulty of writing correct
programs even with as few as two asynchronous concurrent threads. If coded improp-
erly, such programs can produce undesired and unpredictable results. In the remain-
der of the chapter, we discuss various mechanisms that programmers can use to
create correct programs with asynchronous concurrent threads. In the next chapter,
we present two classic asynchronism problems and implement their solutions in Java.

Self Review
1. (T/F) Communication and synchronization are necessary only for asynchronously execut-
   ing threads.
2. (T/F) Threads that occasionally communicate, even though they normally operate inde-
   pendently of one another are said to execute synchronously.
Ans: 1) False. Communication and synchronization are necessary for asynchronously exe-
cuting threads and processes. 2) False. Such threads are said to execute asynchronously.


5 . 2M u t u a lE x c l u s i o n
Consider a mail server that processes e-mail for an organization. Suppose we want
the system to continuously monitor the total number of e-mails that have been sent
since the day began. Assume that the receipt of an e-mail is handled by one of sev-
eral concurrent threads. Each time one of these threads receives an e-mail from a
user, the thread increments a processwide shared variable, mailCount, by 1. Con-
sider what happens if two threads attempt to increment mailCount simultaneously.
First, assume that each thread runs the assembly-language code
      LOAD mailCount
      ADD 1
      STORE mailCount

       Assume that the LOAD instruction copies mailCount from memory to a regis-
ter, the ADD instruction adds the immediate constant 1 from memory to the value in
the register, and the STORE instruction copies the value in the register to memory.
Suppose mailCount is currently 21687. Now suppose the first thread executes the
LOAD and ADD instructions, thus leaving 21688 in the register (but not yet updating

<!-- pág. 246 -->

188 Asynchrnous Concurrent Execution

                           the value in mailCount in memory, which is still 21687). Then, due to a quantum
                           expiration, the first thread loses the processor and the system context switches to
                           the second thread. The second thread now executes all three instructions, thus set-
                           ting mailCount to 21688. This thread loses the processor, and the system context
                           switches back to the first thread, which then continues by executing the STORE
                           instruction—also placing 21688 into mailCount. Due to the uncontrolled access to
                           the shared variable mailCount, the system has essentially lost track of one of the e-
                           mails—mailCount should be 21689. In the case of an e-mail management applica-
                           tion, such an error may seem minor. A similar error occurring in a mission-critical
                           application such as air traffic control could cost lives.
                                  The cause of this incorrect result is the writing of the shared variable mail-
                           Count. Clearly, many concurrent threads may read data simultaneously without this
                           difficulty. But when one thread reads data that another thread is writing, or when
                           one thread writes data that another thread is also writing, indeterminate results can
                           occur.6, 7, 8
                                  We can solve this problem by granting each thread exclusive access to m a i l -
                           Count. While one thread increments the shared variable, all other threads desiring
                           to do so will be made to wait. When the executing thread finishes accessing the
                           shared variable, the system will allow one of the waiting processes to proceed. This
                           is called serializing access to the shared variable. In this manner, threads will not be
                           able to access shared data simultaneously. As each thread proceeds to update the
                           shared variable, all others are excluded from doing so simultaneously. This is called
                           mutual exclusion.9, 10, 11 As we will see in this and subsequent chapters, waiting
                           threads must be carefully managed to ensure that they will be able to proceed
                           within a "reasonable" amount of time.

                           Self Review
                           1. In the mailCount example above, would it be acceptable if several threads simultaneously
                              read the value without updating it?
                           2. (T/F) Suppose each of two threads that share a variable needs to update that shared vari-
                              able at some point during the thread's execution. If the threads are not made to mutually
                              exclude each other from updating the shared variable simultaneously, then on any execu-
                              tion of two threads, the system will fail.
                           Ans: 1) Yes, mutual exclusion is necessary only when threads update the shared variable. 2)
                           False. It is possible that the threads will attempt to update the shared variable at different
                           times, and the program could thus function correctly.

                           5.2.1 Java Multithreading Case Study, Parf II:
                           A Producer/Consumer Relationship in Java
                           In a producer/consumer relationship, the producer portion of the application gener-
                           ates data and stores it in a shared object, and the consumer portion reads data from
                           the shared object. One example of a common producer/consumer relationship is print
                           spooling. A word processor spools data to a buffer (typically a file) and that data is
                           subsequently consumed by the printer as it prints the document. Similarly, an applica-

<!-- pág. 247 -->

                                                                                            5.2 Mutual Exclusion 189
 tion that copies data onto compact discs places data in a fixed-size buffer that is emp-
 tied as the CD-RW drive burns the data onto the compact disk.
       Consider a multithreaded producer/consumer relationship implemented in
Java in which a producer thread generates data and places it into a buffer capable of
 holding a single value and a consumer thread reads data from the buffer. If the pro-
 ducer waiting to put the next data into the buffer determines that the consumer has
 not yet read the previous data from the buffer, the producer should call wai t so the
consumer gets a chance to read unconsumed data before it is overwritten. When the
 consumer reads the data, it should call notify to allow the (possibly waiting) pro-
 ducer to store the next value. Object method notify transitions a thread from the
 waiting state to the ready state. If the consumer finds the buffer empty (because the
producer has not yet produced its first data) or finds that the previous data has
already been read, the consumer should call wait to place itself in the waiting state;
otherwise, the consumer might read "garbage" from an empty buffer or might erro-
neously process the same data again. When the producer places the next data into
the buffer, the producer should call notify to allow the (possibly waiting) con-
sumer thread to proceed, so the consumer can read the new data. Note that notify
has no effect when none of an application's threads are waiting.
       Let us implement this example in Java to see how logic errors can arise if we
do not synchronize access among multiple threads manipulating shared data. The
example that follows (Fig. 5.1-Fig. 5.5) implements a producer/consumer relation-
ship in which a producer thread sequentially writes numbers (1 to 4) into a shared
buffer—a memory location shared between two threads (a single i n t variable
called buffer in Fig. 5.4). The consumer thread reads this data from the shared
buffer and displays the data. The program's output (three samples are shown in
Fig. 5.5) shows the values that the producer writes (produces) into the shared buffer
and the values that the consumer reads (consumes) from the shared buffer.
       Each value the producer writes to the shared buffer must be consumed
exactly once (and in order) by the consumer thread. However, the threads in this
example are not synchronized, meaning that they do not cooperate when perform-
ing their tasks (which, as we have seen, is especially important when one of the
threads is writing to the buffer). Therefore, data (possibly multiple values) can be
lost if the producer places new data into the shared buffer before the consumer con-
sumes the previous data, and data can be incorrectly duplicated (possibly many
times) if the consumer consumes data again before the producer produces the next
value. The consequence of not synchronizing access to shared data is somewhat like
the consequence of not having a traffic light at a busy intersection.
       To show these possibilities, the consumer in the following example keeps a
total of all the values it reads. The producer produces values from 1 to 4 in order. In
the traditional producer/consumer relationship, the consumer reads each produced
value once and only once. In addition, the consumer cannot read each value until
after the producer has produced it. Therefore, the producer must always produce a
value before the consumer reads that value, and the total of the values consumed in

<!-- pág. 248 -->

190   Asynchronous   Concurrent    Execution

                                  our example must be 10. However, if you execute this program several times (see
                                  the sample outputs of Fig. 5.5), you will see that the total is rarely, if ever, 10. The
                                  producer and consumer threads in the example each sleep for random intervals of
                                  up to three seconds between performing their tasks, simulating some lengthy delay
                                  such as waiting for user input or for some event to occur. Thus, we do not know
                                  exactly when the producer will attempt to write a new value, nor do we know when
                                  the consumer will attempt to read a value.
                                           The Java program consists of interface Buffer (Fig. 5.1) and four classes —
                                  Producer (Fig.5.2), Consumer (Fig.5.3), UnsynchronizedBuffer (Fig.5.4) and
                                  SharedBufferTest (Fig. 5.5). Interface Buffer declares methods s e t and get that
                                  a Buffer must implement to enable a Producer thread to place a value in the
                                  Buffer and enable a Consumer thread to retrieve a value from the Buffer, respec-
                                  tively. This interface is implemented in Fig. 5.4 (line 4).
                                           Class Producer (Fig.5.2) —a subclass of Thread (line 5) —contains field
                                  sharedLocation (line 7), a constructor (lines 9-14) and a run method (lines 18-
                                  40). The constructor initializes Buffer reference sharedLocation (line 13) with a
                                  reference to an object that implements the Buffer interface. That object is created
                                  in man n (Fig. 5.5; lines 6-18) and passed to the constructor as the parameter shared
                                  (Fig. 5.2; line 10); the constructor initializes the Buffer reference sharedLocation
                                  (line 13) to be a reference to the parameter shared. The producer thread in this
                                  program executes the tasks specified in method run (lines 18-40). The for state-
                                  ment in lines 20-35 loops four times. Each iteration of the loop invokes Thread
                                  method s l e e p (line 25) to place the producer thread into the sleeping state for a
                                  random time interval between 0 and 3 seconds (to simulate a lengthy operation).
                                           [Note: Normally, a thread awakens when its sleep time expires. A sleeping
                                  thread can be awakened early if another thread calls the sleeping thread's i n t e r rupt
                                  method. If this occurs, s l e e p "throws" an exception (of type I n t e r r u p t - e d E x c e p -
                                  t i o n ) to indicate that the thread was interrupted before its sleep time expired. In
                                  Java, this exception must be "handled," which requires the s l e e p method call to
                                  appear in a t r y block that is followed by a catch handler.The t r y block contains the
                                  code that might throw an exception. The catch handler specifies the type of excep-
                                  tion it handles. In this example, the catch handler prints a stack trace, then the pro-
                                  gram continues with the next statement after the t r y . . . c a t c h sequence.]


                                     1    //Fig. 5.1: Buffer.Java
                                     2    // Buffer interface specifies methods to access buffer data.
                                     3
                                     4    public interface Buffer
                                     5    {                                                                                          |
                                     6       public void set( int value );                 // place value into Buffer
                                     7       public int get();                             // return value from Buffer
                                     8    }

                                  Figure 5.1 | Buffer interface used in producer/consumer examples.

<!-- pág. 249 -->

                                                                                       5.2 Mutual Exclusion 191

     When the thread awakens, line 26 passes the value of control variable count
to the Buffer object's set method to change the shared buffer's value. When the
loop completes, lines 37-38 display a message in the console window indicating that
the thread finished producing data and that the thread is terminating. Next, method
run terminates (line 40) and the producer thread enters the dead state. It is impor-
tant to note that any method called from a thread's run method (such as Buffer
method set in line 26) executes as part of that thread of execution. In fact, each
thread has its own method-call stack.


   1    // Fig. 5,2: Producer.Java
   2    // Producer's run method controls a producer thread that
   3    // stores values from 1 to 4 in Buffer sharedLocation.
   4
   5 p u b l i c c l a s s Producer extends Thread
   6 {
   7      private Buffer sharedLocation; // reference to shared object
   8
   9      // Producer constructor
  10 public Producer( Buffer shared )
  11 {
  12              super( "producer" ); // create thread named "Producer"
  13            sharedLocation = shared; // initialize sharedLocation
  14       } // end Producer constructor
  15
  16       // Producer method run stores values from
  17       // 1 to 4 in Buffer sharedLocation
  18       public void run()
   19      {
   20           for C int count = 1; count <= 4; count++ )
   22              // sleep 0 to 3 seconds, then place value in Buffer
   23              try
   24               {
   25          Thread.sleep(        ( int ) ( Math.random() * 3001 ) );
   26                  sharedLocation.set( count ); // write to the buffer
   27               } // end try
   28
   29              //if sleeping thread interrupted, print stack trace
   30              catch ( InterruptedException exception )
   31              {
   32                 exception.printStackTrace();
   33              } // end catch
   34
   35           } // end for
  Figurv 5.2 | Producer class represents the producer thread in a producer/con-
  sumer relationship. (Part 1 of 2.)

<!-- pág. 250 -->

192   Asynchronous   Concurrent    Execution


                                    36
                                    37            System.err.println( getNameO + " done producing." +
                                    38               "\nTerminating " + getNameO + "." );
                                    39
                                    40       } // end method run
                                    41
                                    42   } // end class Producer

                                  Figure 5.2 | Producer class represents the producer thread in a producer/con-
                                  sumer relationship. (Part 2 of 2.)

                                         Class Consumer (Fig.5.3) contains instance variable sharedLocation (line
                                  7), a constructor (lines 9-14) and a run method (lines 16-41). The constructor ini-
                                  tializes Buffer reference sharedLocation (line 13) with a reference to an object
                                  that implements the Buffer interface. That object is created in main (Fig.5.5) and
                                  passed to the constructor as the parameter shared (Fig. 5.3; line 10). As we will see
                                  (Fig. 5.5; lines 12-13), this is the same UnsynchronizedBuffer object that is used
                                  to initialize the Producer object; thus, the producer and consumer threads share
                                  the object. The consumer thread in this program performs the tasks specified in
                                  method run (Fig. 5.3; lines 16-41). The loop in lines 22-36 loops four times. Each
                                  iteration of the loop invokes Thread method s l e e p (line 27) to put the consumer
                                  thread into the sleeping state for a random time interval between 0 and 3 seconds.
                                  Next, line 28 uses the Buffer's get method to retrieve the value in the shared
                                  buffer, then adds the value to variable sum. When the loop completes, lines 38-39
                                  display a line in the console window indicating the sum of the consumed values and
                                  the fact that the consumer thread is terminating. Then, method run terminates (line
                                  41), and the consumer thread enters the dead state.



                                     1   //Fig. 5.3: Consumer.Java
                                     2   // Consumer's run method controls a thread that loops four
                                     3   // times and reads a value from sharedLocation each time.
                                     4
                                     5   public class Consumer extends Thread
                                     6   {
                                    7          private Buffer sharedLocation; // reference to shared object
                                    8
                                    9        // Consumer constructor
                                   10        public Consumer( Buffer shared )
                                    11       {
                                   12           super( "Consumer" ); // create thread named "Consumer"
                                   13           sharedLocation = shared; // initialize sharedLocation
                                   14        } // end Consumer constructor

                                  Figure 5.3 | Consumer class represents the consumer thread in a producer/con-
                                  sumer relationship. (Part 1 of 2.)

<!-- pág. 251 -->

                                                                                             5.2 Mutual Exclusion 193

  15
  16      // read sharedLocation's value f o u r times and sum the values
  17      public void run()
  18      {
  19          i n t sum = 0;
  20
  21          // alternate between sleeping and getting Buffer value
  22          for (int count = 1; count <= 4; ++count )
  23          {
  24             // sleep 0-3 seconds, read Buffer value and add to sum
  25             try
  26             {
  27                Thread.sleep( ( int ) ( Math.random() * 3001 ) );
  28                 sum += sharedLocation.get();
  29             }
  30
  31             / / i f sleeping thread i n t e r r u p t e d , p r i n t stack t r a c e
  32             catch ( InterruptedException exception )
  33             {
  34                  exception.printStackTrace();
  35             }
  36          } // end for
  37
  38          System.err.println( getName() + " read values totaling: "
  39             + sum + "AnTerminating " + getName() + "." );
  40
  41      } // end method run
  42
  43   } // end class Consumer

Figure 5.3 | Consumer class represents the consumer thread in a producer/con-
sumer relationship. (Part 2 of 2.)


        [Note: We use a randomly generated interval with method sleep in method
run of both the Producer and Consumer classes to emphasize the fact that, in mul-
tithreaded applications, it is unclear when and for how long each thread will per-
form its task. Normally, these thread-scheduling issues are the job of the operating
system. In this program, our thread's tasks are quite simple—for the producer, loop
four times, each time setting a value in the shared buffer; for the consumer, loop
four times, each time retrieving a value from the shared buffer and adding the value
to variable sum. Without the sleep method call, and if the producer were to execute
first, it most likely would complete its task before the consumer got a chance to exe-
cute; if the consumer were to execute first, most likely it would consume the "null"
value ( - 1 , specified in UnsynchronizedBuffer, line 6 of Fig. 5.4) four times, then
terminate (displaying the invalid sum, -4) before the producer produced even its
first value.]

<!-- pág. 252 -->

194 Asynchronous Concurrent Execution
                                 Class UnsynchronizedBuffer (Fig. 5.4) implements interface Buffer (line 4)
                           defined in Fig. 5.1 and declares the variable buffer (line 6), shared between the
                           Producer and Consumer. Variable buffer is initialized with the value - 1 . This
                           value is used to demonstrate the case in which the Consumer attempts to consume a
                           value before the Producer places a value in buffer. Methods s e t (lines 8-15) and
                           get (lines 17-24) do not synchronize access to field buffer (we will see how to do
                           this shortly). Method s e t simply assigns its parameter to buffer (line 14) and
                           method get simply returns the value of buffer (line 23). Note that each method
                           uses class Thread's static method currentThread to obtain a reference to the cur-
                           rently executing thread, then uses that thread's method getName to obtain the
                           thread's name for output purposes (lines 11 and 20).
                                 Class SharedBufferTest (Fig. 5.5) contains method man n (lines 6-18), which
                           launches the application. Line 9 instantiates a shared UnsynchronizedBuffer
                           object and assigns it to Buffer reference sharedLocation. This object stores the
                           data that will be shared between the producer and consumer threads. Lines 12-13
                           create the Producer object producer and the Consumer object consumer. Each of

                             1   / / F i g . 5.4: UnsynchronizedBuffer.Java
                             2   // UnsynchronizedBuffer represents a s i n g l e shared i n t e g e r .
                             3
                             4   p u b l i c class UnsynchronizedBuffer implements Buffer
                             5   {
                             6        p r i v a t e i n t buffer = - 1 ; // shared by Producer and Consumer
                             7
                             8       / / place value i n t o b u f f e r
                             9       p u b l i c v o i d set( i n t value )
                            10       {
                            11           System.err.println( Thread.currentThread().getName() +
                            12              " writes " + value );
                            13
                            14          buffer = value;
                            15       } // end method set
                            16
                            17       // return value from buffer
                            18       public int get()
                            19       {
                            20           System.err.println( Thread.currentThread().getName() +
                            21              " reads " + buffer );
                            22
                            23           return b u f f e r ;
                            24       } // end method get
                            25
                            26    } // end class UnsynchronizedBuffer

                          Figure 5.4 | UnsynchronizedBuffer class maintains the shared integer that is
                          accessed by a producer thread and a consumer thread via methods set and get

<!-- pág. 253 -->

                                                                                            5.2 Mutual Exclusion 195

the constructor calls in these lines passes sharedLocation as the argument to the
constructor (lines 9-14 of Fig. 5.2 for Producer and lines 9-14 of Fig. 5.3 for Con-
 sumer), so that each thread accesses the same Buffer. Next, lines 15-16 of Fig. 5.5
 invoke method s t a r t on the producer and consumer threads, respectively, to
place them in the ready state. This launches the execution of these threads by mak-
 ing an implicit call to each thread's run method. A thread's run method will be
called when the thread is dispatched to a processor for the first time. After the p r o -
ducer and consumer threads are started, method main (i.e., the main thread of exe-
cution) terminates and the main thread enters the dead state. Once both the
producer and consumer threads enter the dead state (which occurs when their run
methods terminate), the program terminates.
      Recall from the overview of this example that the Producer thread must pro-
duce a value before the Consumer thread consumes a value, and every value pro-
duced by the producer must be consumed exactly once by the consumer. However,
when we study the first output of Fig. 5.5, we see that the consumer retrieved the
value -1 before the producer ever placed a value in the buffer. The first value pro-
duced (1) was consumed three times. Furthermore, the consumer finished executing
before the producer had an opportunity to produce the values 2, 3 and 4, so those
three values were lost. An incorrect total of 2 was produced.
      In the second output, we see that the value 1 was lost, because the values 1
and 2 were produced before the consumer thread could read the value 1 (so the


  1    // Fig. 5.5: SharedBufferTest.Java
  2    // SharedBufferTest creates producer and consumer threads,
  3
  4    public class SharedBufferTest
  5    {
  6        public s t a t i c void main( String [ ] args )
  7        {
  8            // create shared object used by threads
  9            Buffer sharedLocation = new UnsynchronizedBuffer();
 10
 11              // create producer and consumer objects
 12              Producer producer = new Producer( sharedLocation );
 13              Consumer consumer = new Consumer( sharedLocation );
 14
 15              producer.start(); // start producer thread
 16              consumer.start(); // start consumer thread
 17
 18        } // end main
 19
 20     } // end class SharedCell

Figure 5.5 | Shared Buffer class enables threads to modify a shared object With-
out synchronization. (Part 1 of 2.)

<!-- pág. 254 -->

196   Asynchronous Concurrent Exclusion


                              Sample Output 1.
                              Consumer reads -1
                              Producer writes 1
                              Consumer reads 1
                              Consumer reads 1
                              Consumer reads 1
                              Consumer read values totaling: 2.
                              Terminating Consumer.
                              Producer writes 2
                              Producer writes 3
                              Producer writes 4
                              Producer done producing.
                              Terminating Producer.

                              Sample Output 2:
                              Producer writes 1
                              Producer writes 2
                              Consumer reads 2
                              Producer writes 3
                              Consumer reads 3
                              Producer writes 4
                              Producer done producing.
                              Terminating Producer.
                              Consumer reads 4
                              Consumer reads 4
                              Consumer read values totaling: 13.
                              Terminating Consumer.


                              Sample Output 3:
                              Producer w r i t e s 1
                              Consumer reads 1
                              Producer w r i t e s 2
                              Consumer reads 2
                              Producer w r i t e s 3
                              Consumer reads 3
                              Producer w r i t e s 4
                              Producer done producing.
                              Terminating Producer.
                              Consumer reads 4
                              Consumer read values t o t a l i n g : 10.
                              Terminating Consumer.

                            Ffffure 5.5 I Shared Buffer class enables threads to modify a shared object with-
                            out synchronization. (Part 2 of 2.)

<!-- pág. 255 -->

                                                                                                 5.2 Mutual   Exclusion   197

value 2 overwrote the value 1 in the buffer). Also, the value 4 was consumed twice.
Once again, an incorrect total was produced. The last sample output demonstrates
that it is possible, with some luck, to get a proper output; clearly, this behavior can-
not be guaranteed.
      This example demonstrates that access to a shared object by concurrent
threads must be controlled carefully; otherwise, a program may produce incorrect
results. We provide a solution to this problem in the next chapter. The remainder of
this chapter discusses how threads control concurrent access to shared data by
enforcing mutually exclusive access to that data.

Self Review
1. (T/F) In the producer/consumer example shown in Fig. 5.1-Fig. 5.5, the output would be
   correct and consistent if the calls to s l e e p were removed.
2. What are the smallest and largest possible values of sum at the end of the execution of the
   example shown in Fig. 5.1-Fig. 5.5, and how would those values be achieved?
Ans: 1) False. The s l e e p calls were put there simply to emphasize the fact that there is
uncertainty within a system regarding the order and timing in which instructions are exe-
cuted. Still, we cannot predict the speeds at which these threads will advance, so the outputs
could still be incorrect. 2) The smallest value would occur if the consumer tried consuming
four values before the producer produced any. In this case, sum would be -4. The largest
value would occur if the producer produced four values before the consumer consumed any.
In this case, the consumer would consume the value four times, and sum would be 16.




5.2.2 Critical Sections
Mutual exclusion needs to be enforced only when threads access shared modifiable
data. When threads are performing operations that do not conflict with one another
(e.g., reading variables), the system should allow the threads to proceed concur-
rently. When a thread is accessing shared modifiable data, it is said to be in a critical
section (or critical region). 12 To prevent the kinds of errors we encountered earlier,
the system should ensure that only one thread at a time can execute the instructions
in its critical section for a particular resource. If one thread attempts to enter its
critical section while another is in its own critical section, the first thread should
wait until the executing thread exits the critical section. Once a thread has exited its
critical section, a waiting thread (or one of the waiting threads, if there are several),
may enter and execute its critical section. Any thread that does not need to enter its
critical section may execute regardless of whether a critical section is occupied.
       A system that enforces mutual exclusion must carefully control access to, and
execution in, critical sections. A thread in a critical section has exclusive access to
shared, modifiable data, and all other threads currently requiring access to that data
are kept waiting. Therefore, a thread should execute a critical section as quickly as
possible. A thread must not block inside its critical section, and critical sections
must be carefully coded to avoid—for example—the possibility of infinite loops. If a
thread in a critical section terminates, either voluntarily or involuntarily, then the

<!-- pág. 256 -->

198 Asynchronous Concurrent Execution

                            operating system, in performing its termination housekeeping, must release mutual
                            exclusion so that other threads may enter their critical sections.
                                  Enforcing mutually exclusive access to critical sections is one of the key prob-
                            lems in concurrent programming. Many solutions have been devised: some soft-
                            ware solutions and some hardware solutions; some rather low-level and some high-
                            level; some requiring voluntary cooperation among threads and some demanding
                            rigid adherence to strict protocols. We will examine a variety of these solutions in
                            the upcoming sections.

                            Self Review
                            1. Why is it important for a thread to execute a critical section as quickly as possible?
                            2. What might happen if the operating system did not perform termination housekeeping?
                           Ans: 1) If other threads are waiting to execute their critical sections, they will be delayed
                           from doing so while any thread is in its critical section. If critical sections do not execute
                           quickly, overall system performance could suffer. 2) A thread could terminate while in its
                           critical section, and never release mutual exclusion. The threads waiting to enter their critical
                           sections would never be able to enter. As we will see in Chapter 7, Deadlock and Indefinite
                           Postponement, these threads will deadlock.


                            5.2.3 Mutual Exclusion Primitives
                            The following pseudocode properly describes the e-mail counting mechanism of
                            Section 5.2, Mutual Exclusion. Notice that we use the words enterMutualExclu-
                            s i o n ( ) and exitMutualExclusion().These words are constructs that encapsulate
                            the thread's critical section—when a thread wants to enter its critical section, the
                            thread must first execute enterMutualExclusion(); when a thread exits the criti-
                            cal section, it executes e x i t M u t u a l E x c l u s i o n ( ) . Because these constructs invoke
                            the most fundamental operations inherent to mutual exclusion, they are sometimes
                            called mutual exclusion primitives.
                                  while ( t r u e ) {
                                      Receive e-mail                    // executing outside critical section
                                      enterMutual Exclusion()            // want to enter critical section
                                         Increment mailCount            // executing inside critical section
                                      exitMutualExclusion()             // leaving critical section
                                  }
                                   Let us consider how these primitives can provide mutual exclusion. For sim-
                            plicity in the example presented in this and the next several sections, we shall
                            assume only two concurrent threads and one processor. Handling n concurrent pro-
                            cesses or threads is a considerably more complex topic, which we discuss in
                            Section 5.4.3, N-Thread Mutual Exclusion: Lamport's Bakery Algorithm. We will
                            also discuss how mutual exclusion is enforced on multiprocessor systems.
                                   Assume that threads T1 and T2 of the same process are both executing in the
                            system. Each thread manages e-mail messages, and each thread contains instructions
                            that correspond to the preceding pseudocode. When T1 reaches the enterMutual Ex-

<!-- pág. 257 -->

                                                                         5.3 Implenting Mutual Exclusion Primitives 199

  c l u s i o n ( ) line, the system must determine whether T2 is already in its critical sec-
  tion. If T2 is not in its critical section, then T1 enters its critical section, increments
  shared variable mail Count and executes exitMutualExclusion() to indicate that
  T1 has left its critical section. If, on the other hand, when T1 executes enterMutual -
  Exclusion(), T2 is in its critical section, then T1 must wait until T2 executes exitMu-
  tual Exclusion(), at which point T1 enters its critical section. If T1 and T2
  simultaneously execute enterMutualExclusion(), then only one of the threads will
  be allowed to proceed, and one will be kept waiting. For the moment, we shall assume
  that the system randomly selects the thread that will proceed. [As we will see, such a
  policy could lead to indefinite postponement of one of the threads if the other is
  always selected when the threads repeatedly try to enter their critical sections.] In the
  next several sections, we discuss various mechanisms for implementing the enterMu-
  t u a l E x c l u s i o n ( ) and exitMutualExclusion() mutual exclusion primitives.

  Self Review
  1. What will happen if a thread does not call enterMutualExclusionO before accessing
     shared variables in a critical section?
  2. What will happen if a thread that is in its critical section does not call exi tMutual Excl u-
     sionO?
  Ans: 1) If other threads also enter their critical section, there could be indeterminate
  results that could have serious consequences. 2) All other threads that are waiting to enter
  their critical sections would never be allowed to do so. As we will see in Chapter 7, Deadlock
  and Indefinite Postponement, all of these other threads would eventually deadlock.



5.3 Implementing Mutual Exclusion Primitives
  Each initial mutual exclusion solutions that we discuss provides an implementation
  of enterMutualExclusion() and exitMutualExclusion() that exhibits the fol-
  lowing properties:
        1. The solution is implemented purely in software on a machine without spe-
           cially designed mutual exclusion machine-language instructions. Each
           machine-language instruction is executed indivisibly—i.e., once started, it
           completes without interruption. If a system contains multiple processors,
           several threads could try to access the same data item simultaneously. As
           we will see, many mutual exclusion solutions for uniprocessor systems rely
           on access to shared data, meaning that they might not work on multipro-
           cessor systems (see Section 15.9, Multiprocessor Mutual Exclusion). For
           simplicity, we will assume that the system contains one processor. Again,
           we will deal with multiprocessor systems later.
        2. No assumption can be made about the relative speeds of asynchronous
           concurrent threads. This means that any solution must assume that a thread
           can be preempted or resumed at any time during its execution and that the
           rate of execution of each thread may not be constant or predictable.

<!-- pág. 258 -->

200 Asynchronous Concurrent Execution

                                 3. A thread that is executing instructions outside its critical section cannot
                                    prevent any other threads from entering their critical sections.
                                 4. A thread must not be indefinitely postponed from entering its critical
                                    section. [Note: Once inside an improperly coded critical section, a thread
                                    could certainly "misbehave" in ways that could lead to indefinite postpone-
                                    ment or even deadlock. We discuss these issues in depth in Chapter 7,
                                    Deadlock and Indefinite Postponement.]

                           Self Review
                           1. Why do you suppose that we cannot predict the relative speeds of asynchronous concur-
                              rent threads?
                           2. How can an improperly coded thread cause indefinite postponement or deadlock?
                           Ans: 1) One reason is that hardware interrupts, which may be randomly distributed, can
                           disrupt thread execution at any time. Over any given period, these interrupts may allow some
                           threads to execute longer than others. In addition, biases in resource-scheduling algorithms
                           may favor certain threads. 2) A thread that never left its critical section (e.g., by entering an
                           infinite loop) would eventually indefinitely postpone or deadlock all other threads as they
                           tried to enter their critical sections.



                           5.4 Software Solutions to the Mutual Exclusion Problem
                           An elegant software implementation of mutual exclusion was first presented by the
                           Dutch mathematician Dekker. In the next section we follow Dijkstra's develop-
                           ment of Dekker's Algorithm, an implementation of mutual exclusion for two
                           threads. 13 The arguments presented introduce many of the subtleties in concurrent
                           programming that make this such an interesting field of study. Then, we discuss sim-
                           pler and more efficient algorithms developed by G. L. Peterson 14 and L. Lamport. 15

                           5.4.1 Dekker's Algorithm
                           In this section we examine several attempts to implement mutual exclusion. Each
                           implementation contains a problem that the subsequent one overcomes. The sec-
                           tion culminates in the presentation of a correct software implementation to mutual
                           exclusion that is free of deadlock and indefinite postponement.

                           First Version (Introducing lockstep Synchronization and Busy Waiting)
                           Figure 5.6 shows a first effort at specifying the code for enforcing mutual exclusion
                           between two threads. The pseudocode is presented using a C-like syntax. Each
                           thread's instructions can be broken into three parts: noncritical instructions (i.e.,
                           instructions that do not modify shared data), critical instructions (i.e., instructions
                           that do modify shared data) and the instructions that ensure mutual exclusion (i.e.,
                           instructions that implement enterMutualExclusion() and exitMutualExclu-
                           s i o n ( ) ) . Each thread repeatedly enters and exits its critical section until it is done.
                                    Under this version of mutual exclusion, the system uses a variable called
                           threadNumber, to which both threads have access. Before the system starts execut-

<!-- pág. 259 -->

                                                  5.4 Software Solutions to the Mutual Exclusion Problem 201

   1 System:
   2
   3 int threadNumber = 1;
   4
   5 startThreads(); // initialize and launch both threads
   6
   7 Thread T1:
  8
  9    void main() {
 10
 11       while ( !done )
 12       {
 13           while ( threadNumber == 2 ); // enterMutualExclusion
 14
 15           // critical section code
 16
 17           threadNumber = 2; // exitMutualExclusion
 18
 19           // code outside critical section
 20
 21       } // end outer while
 22
 23   } // end Thread Tl
 24
 25 Thread T2:
 26                                        \
 27 void main() {
 28
 29    while ( !done )
 30     {
 31       while ( threadNumber == 1 ); // enterMutualExclusion
 32
 33       // critical section code
 34
 35       threadNumber = 1; // exitMutualExclusion
 36
 37       // code outside critical section
 38
 39    } // end outer while
 40
 41    } // end Thread T2

Figure 5.6 | Mutual exclusion implementation- version 1.

ing the threads, threadNumber is set to 1 (line 3). Then the system starts both
threads.The enterMutualExclusion() primitive is implemented as a single while
loop that loops indefinitely until variable threadNumber becomes equal to the
number of the thread (see lines 13 and 31 in threads T1 and T2, respectively). The

<!-- pág. 260 -->

202   Asynchronous Concurrent Execution

                            exitMutualExclusion() primitive is implemented as a single instruction that sets
                            threadNumber to the number of the other thread (see lines 17 and 35 in threads T1
                            and T 2 , respectively).
                                  Consider one way in which execution might proceed under this implementa-
                            tion. Assume T1 begins executing first. The thread executes the while loop (line 13)
                            that acts as enterMutuaIExcIusion(). Because threadNumber is initially 1, T1
                            enters its critical section (the code indicated by the comment in line 15). Now
                            assume that the system suspends T1 and begins executing T2. The second thread
                            finds threadNumber equal to 1 and remains "locked" in the while loop (line 31).
                            This guarantees mutual exclusion, because T2 cannot enter its critical section until
                            T1 exits its critical section and sets threadNumber to 2 (line 17).
                                  Eventually, T1 finishes executing in its critical section (recall that we are assum-
                            ing that the critical sections contain no infinite loops and that threads do not die or
                            block inside critical sections). At this point, T 1 sets threadNumber to 2 (line 17) and
                            continues to its "noncritical" instructions. Now T2 is free to enter its critical section.
                                  Although this implementation guarantees mutual exclusion, the solution has
                            significant drawbacks. In the enterMutualExclusion() primitive, the thread uses
                            the processor to perform essentially no work (i.e., the thread repeatedly tests the
                            value of threadNumber. Such a thread is said to be busy waiting. Busy waiting can
                            be an ineffective technique for implementing mutual exclusion on uniprocessor sys-
                            tems. Recall that one goal of multiprogramming is to increase processor utilization.
                            If our mutual exclusion primitive uses processor cycles to perform work that is not
                            essential to the thread, then processor time is wasted. This overhead, however, is
                            limited to short periods of time (i.e., when there is contention between the threads
                            to enter their critical sections).
                                   A more damaging drawback of this implementation is that it violates one of
                            the key constraints we identified in Section 5.3, Implementing Mutual Exclusion
                            Primitives, namely that a thread that is not in its critical section should not affect a
                            thread that desires to enter its own critical section. For example, T1 must enter the
                            critical section first, because the system initially sets threadNumber to 1. If T2 tries
                            to go first, it begins execution and unsuccessfully attempts to enter its critical sec-
                            tion. Eventually, T1 executes, entering its critical section and setting threadNumber
                            to 2. Thus, T2 may be delayed considerably before it may enter its critical section. In
                            fact, the threads must enter and leave their critical sections in strict alternation. If
                            one thread needs to enter its critical section more frequently than the other, the
                            faster thread will be constrained to operate at the speed of the slower thread. This is
                            called the lockstep synchronization problem.* The next mutual exclusion imple-
                            mentation eliminates this problem but introduces another.



                                 Of course, the problem in Section 5.2.1 required lockstep synchronization because the
                                 buffer was of unit size. However, almost all buffers contain several entries, meaning that
                                 lockstep synchronization causes inefficient behavior if the producer and consumer
                                 operate at different speeds.

<!-- pág. 261 -->

                                                               5.4    Software Solutions to the Mutual Exclusion Problem 203

 Second Version (Violating Mutual Exclusion)
   Figure 5.7 contains a solution that attempts to eliminate the lockstep synchroniza-
tion of the previous implementation. In the first solution, the system maintained
 only a single global variable—this forced the lockstep synchronization. Version 2
maintains two variables — t 1 I n s i d e that is true if T1 is inside its critical section, and
t 2 I n s i d e that is true if T2 is inside its critical section.


   1   System:
   2
   3   boolean t l l n s i d e = f a l s e ;
   4   boolean t2Inside = f a l s e ;
   5
   6   startThreads();                // i n i t i a l i z e and launch both threads
   7
   8   Thread T1:
   9
  10   void main() {
  11
 12        while ( !done )
 13         {
 14           while ( t2Inside ); // enterMutualExclusion
 15
 16       t1Inside              = true; // enterMutualExclusion
 17
 18            // critical section code
 19
 20            tllnside = false; // exitMutualExclusion
 21
 22            // code outside critical section
 23
 24        } // end outer while
 25
 26    } // end Thread Tl
 27
 28    Thread T2:
 29
 30    void main() {
 31
 32        while ( !done )
 33        {
 34           while ( tllnside ); // enterMutualExclusion
 35
 36            t2Inside = true; // enterMutualExclusion
 37
 38              // c r i t i c a l    s e c t i o n code

Figure 5.7 | Mutual exclusion implementation- version 2. (Part 1 of 2.)

<!-- pág. 262 -->

204 Asynchronous Concurrent Execution

                             39
                             40           t2Inside = false; // exitMutualExclusion
                             41
                             42            // code outside critical section
                             43
                             44        } // end outer w h i l e
                             45
                             46    } // end Thread T2

                           Figure5.7 | Mutual exclusion implementation- version 2. (Part 2 of 2)

                                    By using two variables to govern access to the critical sections (one for each
                           thread), we are able to eliminate lockstep synchronization in our second mutual
                           exclusion implementation. T1 will be able to continuously enter its critical section as
                           many times as necessary while t 2 I n s i d e is false. Also, if T1 enters the critical section
                           and sets t 1 I n s i d e to true, then T2 will busy wait. Eventually,T 1 will finish its critical
                           section and perform its mutual exclusion exit code, setting t l l n s i de to false.
                                    Although this solution eliminates the lockstep synchronization issue, it unfor-
                           tunately does not guarantee mutual exclusion. Consider the following situation.
                           Variables t l l n s i d e and t 2 I n s i d e are both false, and both threads attempt to
                           enter their critical sections at the same time. T1 tests the value of t 2 I n s i d e (line
                           14), determines that the value is false and proceeds to the next statement. Now sup-
                           pose that the system preempts T1 before it can execute line 16 (which it needs to do
                           to keep T2 out of its own critical section). T2 now executes, determines that
                           t 1 I n s i d e is false and so T2 enters its critical section. While T2 is in its critical sec-
                           tion, T 2 is preempted and T 1 resumes execution in line 16, setting t 1 I n s i d e to true
                           and entering its critical section. Both threads are concurrently executing their criti-
                           cal sections, violating mutual exclusion.


                           Third Version (Introducing Deadlock)
                           Version 2 failed because between the time a thread determines in its whi 1 e test that
                           it can go ahead (lines 14 and 34) and the time the thread sets a flag to say that it is in
                           its critical section (lines 16 and 36), there is the possibility that the other thread
                           could gain control, pass its while test and enter its critical section. To correct this
                           problem, once a thread attempts the while test, it must be assured that the other
                           process cannot proceed past its own while test. Version 3 (Fig.5.8) attempts to
                           resolve this problem by having each thread set its own flag prior to entering the
                           while loop. Thus, T1 indicates its desire to enter its critical section by setting
                           t1WantsToEnter to true. If t2WantsToEnter is false, then T1 enters its critical sec-
                           tion and prevents T2 from entering its own critical section. Thus mutual exclusion is
                           guaranteed, and it seems that we have a correct solution. We ensure that, once a
                           thread signals its intent to enter the critical section, another thread cannot enter the
                           critical section.

<!-- pág. 263 -->

                                              5.4 Software Solutions to the Mutual Exclusion Problem 205

  1 System:
  2
  3 boolean tlWantsToEnter = false;
  4 boolean t2WantsToEnter = false;
  5
  6 startThreads(); // initialize and launch both threads
  7
  8  Thread T1:
  9
 10   void main()
 11 {
 12       while ( !done )
 13       {
 14           tlWantsToEnter = true; // enterMutuaiExclusion
 15
 16           while ( t2WantsToEnter ); // enterMutualExclusion
 17
 18           // critical section code
 19
 20           tlWantsToEnter = false; // exitMutualExclusion
 21
 22           // code outside critical section
 23
 24       } // end outer while
 25
 26   } // end Thread Tl
 27
 28    Thread T2:
 29
 30   v o i d main()
 31   {
 32         w h i l e ( !done )
 33       {
 34           t2WantsToEnter = true; // enterMutualExclusion
 35
 36           while ( tlWantsToEnter ); // enterMutualExclusion
 37
 38           // critical section code
 39
 40           t2WantsToEnter = false; // exitMutualExclusion
 41
 42           // code outside critical section
 43
 44      } // end outer while
 45
 46   } // end Thread T2

Figure 5.8 | Mutual exclusion implmentation- version 3.

<!-- pág. 264 -->

206   Asynchronous   Concurrent    Execution

                                        One problem has been solved, but another has been introduced. If each
                                  thread sets its flag before proceeding to the while test, then each thread will find
                                  the other's flag set and will loop forever in the while. This is an example of a two-
                                  process deadlock, which is discussed in depth in Chapter 7, Deadlock and Indefinite
                                  Postponement.

                                  Version Fourth (Introducing Indefinite Postponement)
                                  To create an effective mutual exclusion implementation, we need a way to "break
                                  out" of the infinite loops we encountered in the previous version. Version 4
                                  (Fig. 5.9) accomplishes this by forcing each looping thread to repeatedly set its flag
                                  to false for brief periods. This allows the other thread to proceed through its while
                                  loop with its own flag set to true.


                                     1 System:
                                    2
                                    3    boolean tlWantsToEnter = false;
                                    4    boolean t2WantsToEnter = false;
                                    5
                                    6    startThreads(); // initialize and launch both threads
                                    7
                                    8    Thread T1:
                                    9
                                   10    void main()
                                   11 {
                                   12       while ( !done )
                                   13       {
                                   14          t1WantsToEnter = true;        // enterMutualExclusion
                                   15
                                   16           while ( t2WantsToEnter )        // enterMutualExclusion
                                   17           {
                                   18                 t1WantsToEnter = false;     // enterMutualExclusion
                                   19
                                   20                 // wait for small, random amount of time
                                   21
                                   22               tlWantsToEnter = true;
                                   23            } // end while
                                   24
                                   25           // critical section code
                                   26
                                   27           tlWantsToEnter = false; // exitMutualExclusion
                                   28
                                   29           // code outside critical section
                                   30
                                   31       } // end outer while
                                   32

                                  Figure 5.9 | Mutual exclusion implementation- version 4. (Part 1 of 2.)

<!-- pág. 265 -->

                                                    5.4 Software Solutions to the Mutual Exclusion Problem 207

 33    } // end Thread Tl
 34
 35    Thread T2:
 36
 37    void main()
 38    {
 39       while ( !done )
 40       {
 41          t2WantsToEnter = true;         // enterMutualExclusion
 42
 43           while ( tlWantsToEnter ) // enterMutualExclusion
 44           {
 45              t2WantsToEnter = false; // enterMutualExclusion
 46
 47              // wait for small, random amount of time
 48
 49              t2WantsToEnter = true;
 50           } // end while
 51
 52           // critical section code
 53
 54           t2WantsToEnter = false; // exitMutualExclusion
 55
 56           // code outside critical section
 57
 58       } // end outer while
 59
 60    } // end Thread T2

Figure 5.9 | Mutual exclusion implementation- version 4. (Part 2 of 2.)

       The fourth version guarantees mutual exclusion and prevents deadlock, but
allows for another potentially devastating problem to develop, namely, indefinite
postponement. Because we cannot make any assumptions about the relative speeds
of asynchronous concurrent threads, we must consider all possible execution
sequences. The threads could, for example, proceed in tandem. Each thread can set
its flag to true (line 14), then make the while test (line 16), then enter the body of
the while loop, then set its flag to false (line 18), then wait for a random amount of
time (line 20), then set its flag to true (line 22), then repeat the sequence beginning
with the while test. As the threads do this, the tested conditions (lines 18 and 45)
will remain true. Of course, such an execution sequence would occur with low prob-
ability—but nevertheless it could occur. If a system using this type of mutual exclu-
sion were controlling a space flight, a heart pacemaker, or an air traffic control
system, the possibility of indefinite postponement and subsequent system failure
could put people's lives at risk. Therefore, version four, also, is an unacceptable
solution to the mutual exclusion problem.

<!-- pág. 266 -->

208   Asynchronous Concurrent Execution

                            Dekker's Algorithm (A Proper Solution)
                             Figure 5.10 illustrates Dekker's Algorithm—a correct, two-thread mutual exclusion
                             solution implemented purely in software with no special-purpose hardware instruc-
                             tions. Dekker's Algorithm still uses a flag to indicate a thread's desire to enter its
                             critical section, but it also incorporates the concept of a "favored thread" that will
                             enter the critical selection in the case of a tie (i.e., when each thread simultaneously
                             wishes to enter its critical section).


                                1 System:
                                2
                                3 int favoredThread = 1;
                                4 boolean t1WantsToEnter = false;
                                5 boolean t2WantsToEnter = false;
                                6
                                7 startThreads(); // initialize and launch both threads
                                8
                                9   Thread T1:
                               10
                               11   void main()
                               12   {
                               13       while ( !done )
                               14       {
                               15           t1WantsToEnter = true;
                               16
                               17           while ( t2WantsToEnter )
                               18           {
                               19              if ( favoredThread == 2 )
                               20              {
                               21                 t1WantsToEnter = false;
                               22                 while ( favoredThread == 2 ); // busy wait
                               23                 t1WantsToEnter = true;
                               24              } // end if
                               25
                               26           } // end while
                               27
                               28           // critical section code
                               29
                               30           favoredThread = 2;
                               31           t1WantsToEnter = false;
                               32
                               33           // code outside critical section
                               34
                               35       } // end outer while
                               36
                               37   } // end Thread T1

                             Figure 5.10 | Dekker's Algorithm for mutual exclusion. (Part 1 of 2.)

<!-- pág. 267 -->

                                                           5.4    Software Solutions to the Mutual Exclusion Problem 209

  38
  39   Thread T2:
 40
 41    void main()
 42    {
 43       w h i l e ( !done )
 44       {
 45             t2WantsToEnter = true;
 46
 47             while ( t1WantsToEnter )
 48             {
 49                if ( favoredThread == 1 )
 50                {
 51                   t2WantsToEnter = false;
 52                   while ( favoredThread == 1 ); // busy wait
 53                   t2WantsToEnter = true;
 54                } // end if
 55
 56            } // end while
 57
 58            // critical section code
 59
 60             favoredThread = 1;
 61             t2WantsToEnter = false;
 62
 63            // code outside critical section
 64
 65        } // end outer while
 66
 67    } // end Thread T2

Figure 5.10 | Dekker's Algorithm for mutual exclusion. (Part 2 of 2.)

      Let us examine how Dekker's Algorithm eliminates the possibility of the
indefinite postponement experienced in version 4. First note that in this algorithm,
the enterMutualExclusion primitive is implemented by lines 15-26 and 45-56;
the exitMutualExclusion primitive is implemented by lines 30-31 and 60-61.T 1
indicates its desire to enter its critical section by setting its flag to t r u e (line 15).
The thread then proceeds to the while test (line 17) and determines whether T 2
also wants to enter its critical section. If T 2 's flag is set to f a l s e , there is no conten-
tion between threads attempting to enter their critical sections, so T1 skips the body
of the while loop and enters its critical section (line 28).
      Suppose, however, that when T1 performs the whi 1 e test (line 17), it discovers
that T 2 's flag is set to t r u e . In this case, there is contention between threads
attempting to enter their respective critical sections. Thread T1 enters the body of
its while loop, where the thread examines the value of variable favoredThread,
which is used to resolve such conflicts (line 19). If thread T1 is the favored thread,

<!-- pág. 268 -->

210   Asynchronous   Concurrent Execution

                               then T1 skips the body of the i f and repeatedly executes the while test, waiting for
                               T2 to set t2WantsToEnter to f a l s e , which, as we will see, it must eventually do. If
                               T1 determines that T2 is the favored thread (line 19), T1 is forced into the body of
                               the if statement, where T 1 sets tlWantsToEnter to f a l s e (line 21), then loops
                               inside the ensuing while as long as T2 remains the favored thread (line 22). By set-
                               ting tlWantsToEnter to f a l s e , T 1 allows T 2 to enter its own critical section.
                                        Eventually, T2 exits its critical section and executes its mutual exclusion exit
                               code (lines 60-61). These statements set favoredThread back to T1 and set
                               t2WantsToEnter to f a l s e . T1 may now pass the inner whi 1 e test (line 22) and set
                               tlWantsToEnter to t r u e (line 23).T 1 then executes the outer while test (line 17).
                               If t2WantsToEnter (which was recently set to f a l s e ) is still f a l s e , then T 1 enters
                               its critical section (line 28) and is guaranteed exclusive access. If, however, T2 has
                               quickly tried to reenter its own critical section, then t2WantsToEnter will be set to
                               t r u e , and T1 is once again forced into the body of the outer whi 1 e (line 19).
                                        This time, however, T1 is the favored thread. T1 therefore skips the body of
                               the if and repeatedly executes the outer while test (line 17) until T 2 sets
                               t2WantsToEnter to f a l s e , allowing T 1 to enter its critical section.
                                        Dekker's Algorithm guarantees mutual exclusion while preventing deadlock
                               and indefinite postponement. However, the proof of this statement is not immedi-
                               ately apparent, due to the complex nature of mutual exclusion. For example, con-
                               sider the following interesting possibility. As T1 exits the inner busy wait loop (line
                               22), the system might preempt T 1 before it sets tlWantsToEnter to t r u e . This
                               would allow T 2 to loop around and attempt to reenter its own critical section. T 2
                               would then set t2WantsToEnter to t r u e and reenter its critical section. When T 1
                               eventually resumes execution, it sets t1WantsToEnter to t r u e . Because it is T 1 's
                               turn (and because tlWantsToEnter is now set to t r u e ) , if T 2 tries to reenter (line
                               47), it must set t2WantsToEnter to fal se and enter its inner busy wait (line 52). T1
                               now will be able to enter its critical section. Thus, this circumstance, which may
                               seem complicated at first, does not result in indefinite postponement. A rigorous
                               proof that the algorithm never results in indefinite postponement is a more compli-
                               cated task (see the Anecdote, Why Should You Believe That Your Software Is
                               Functioning Correctly?), and one which the reader will find in the literature. 16



                              Self Review
                               1. Identify the key problem in each of our first four attempts at implementing mutual exclu-
                                  sion.
                               2. (T/F) If the algorithm presented in Fig. 5.9 were modified such that the threads waited for
                                  different amounts of time (e.g.. T1 waits from 0 to 0.2 seconds while T2 waits from 0.5 to
                                  0.7 seconds), this algorithm would not suffer from indefinite postponement.
                              Ans: 1) Version 1: Required T1 to go first and demanded strict alternation. Version 2: Vio-
                              lated mutual exclusion; both threads could enter their critical sections at once. Version 3:
                              Enabled the two threads to deadlock so that neither would ever enter its critical section. Ver-
                              sion 4: Allowed the (albeit remote) possibility of the two threads indefinitely postponing one

<!-- pág. 269 -->

                                                         5.4 Software Solutions to the Mutual Exclusion Problem         211
  another (if they operated in tandem). 2) False. The point is that no assumptions can be made
about the relative speeds of asynchronous concurrent threads. Even though the random time
 intervals might indeed be different, we cannot assume how fast the rest of the algorithm will
run.

5.4.2 Peterson's Algorithm
The development of Dekker's Algorithm in the previous section introduces some
subtle problems that arise due to concurrency and asynchronism in multipro-
grammed systems. For many years, this algorithm represented the state of the prac-
tice in busy-wait solutions for enforcing mutual exclusion. In 1981, G. L. Peterson
published a simpler algorithm for enforcing two-process mutual exclusion with busy
waiting (Fig. 5.11).17
      To illustrate the correctness of Peterson's Algorithm, let us examine the algo-
rithm as executed by thread T1. Before entering its critical section, T1 indicates that
 it wishes to do so by setting tlWantsToEnter to t r u e (line 15). To avoid indefinite
postponement, T1 sets favoredThread to 2 (line 16), allowing T2 to enter its critical
section. T 1 then busy waits while t2WantsToEnter is t r u e and favoredThread is 2.
If either condition becomes false, it is safe for T1 to enter its critical section (line 20).




                Anecdote

  Why Should You Believe That Your Software Is Functioning
  Correctly?
  Dijkstra was always thought-pro-           software determines that the       nal     number. But what if the soft-
  voking. Here is one of his best:           number is not prime, it prints out     ware says a number is prime? Why
  Suppose you have software that             the factors of the number, which       should you believe it?
  determines whether a very large            you can multiply together to see
  number is prime or not. If the             if the product is indeed the origi-


  Lesson to operating systems designers: This is one of the most profound points about computing that you
  may ever ponder. We put remarkable trust in computers in our personal lives and in our careers. But how can
  we be sure that complex software really does what it is supposed to do? How can we certify that software is
  indeed correct, especially when we know that we cannot possibly exhaustively test complex software ? The
  answer may lie in the research field called "proving program correctness." This field still has many important
  unsolved problems—only small, relatively trivial programs have been proven correct to date. It is a wonder-
  ful topic for Ph.D. candidates in computer science.

<!-- pág. 270 -->

212   Asynchronous Concurrent Execution

                             After executing the instructions in its critical section, T1 sets t1WantsToEnter to
                             f a l s e (line 22) to indicate that it has completed its critical section.
                                      Now let us consider how preemption affects the behavior of thread T1. If
                             there is no contention for the critical section when thread T1 performs its mutual
                             exclusion entry code, t2WantsToEnter is f a l s e when thread T1 executes line 18:
                             thread T1 enters its critical section (line 20). Consider the case in which thread T1 is
                             preempted immediately following entry into its critical section. Because thread T2
                             must set favoredThread to 1 (line 37), the test that T2 performs in line 39 will
                             cause T2 to busy wait until thread T1 has exited its critical section and set
                             t1WantsToEnter to f a l s e .
                                      However, if t2WantsToEnter is t r u e when thread T1 attempts to enter its
                             critical section (line 18), then T 2 must have been preempted while attempting to
                             enter its critical section. One possibility is that T2 was preempted while executing
                             code in its critical section, meaning favoredThread = 2 and t2WantsToEnter =
                             t r u e . In this case, T1 must simply busy wait at line 18 until T2 completes its critical
                             section and sets t2WantsToEnter to f a l s e , thereby causing the while condition to
                             fail in line 18 and allowing T1 to proceed.
                                      If thread T1 discovers that both t2WantsToEnter is t r u e and favoredThread
                             to 2 in line 18, T1 will busy wait in its while loop (line 18), because it had set
                             favoredThread to 2 immediately before executing line 18. Thread T1 will wait until
                             T2 regains the processor and sets favoredThread to 1 (line 37). At this point, T2
                             must busy wait because t1WantsToEnter is t r u e and favoredThread is 1. When
                             thread T1 regains control of a processor, it performs the test in its while loop and
                             enters its critical section (line 20).
                                      If thread T 1 discovers that t2WantsToEnter is t r u e and favoredThread to 1
                             in line 18,T 1 may safely enter its critical section, because tlWantsToEnter is t r u e
                             and favoredThread is 1; thread T2 must busy wait until T1 completes executing its
                             critical section and sets tlWantsToEnter to f a l s e .
                                      We will now provide a formal proof that Peterson's Algorithm guarantees
                             mutual exclusion. We do so by proving that T2 cannot execute while T1 is inside its
                             critical section. Note that the algorithm is unchanged if every instance of the char-
                             acters 1 and 2 is swapped. Consequently, if we prove that T2 cannot execute while
                             T1 is inside its critical section, we have also proven that T1 cannot execute while T2
                             is inside its critical section.


                                1   System:
                                2
                                3   int favoredThread = 1;
                                4   boolean tlWantsToEnter = false;
                                5   boolean t2WantsToEnter = false;
                                6
                                7   startThreads(); // initialize and launch both threads

                             Figure 5.11 | Peterson's Algorithm for mutual exclusion. (Part 1 of 2.)

<!-- pág. 271 -->

                                                       5.4 Software Solutions to the Mutual Exclusion Problem 213

   8
   9 Thread! v
  10
  11   v o i d main()
  12   {
  13         w h i l e ( !done )
  14       {
 15            t1WantsToEnter = true;
 16            favoredThread = 2;
 17
 18            while ( t2WantsToEnter && favoredThread == 2 );
 19
 20            // critical section code
 21
 22       t1WantsToEnter           = false;
 23
 24            // code outside critical section
 25
 26       } // end while
 27
 28    } // end Thread T1
 29
 30    Thread T2:
 31
 32    void main()
 33    {
 34       while ( !done )
 35       {
 36          t2WantsToEnter = true;
 37          favoredThread = 1;
 38
 39            while ( t1WantsToEnter && favoredThread == 1 );
 40
 41            // critical section code
 42
 43            t2WantsToEnter = false;
 44
 45            // code outside c r i t i c a l   section
 46
 47        } // end w h i l e
 48
 49    } // end Thread T2

Figure 5.11 | Peterson's Algorithm for mutual exclusion. (Part 2 of 2.)

      To begin the proof, we observe that the value of favoredThread is set
immediately before a thread executes its while loop. Furthermore, each thread
sets the value in favoredThread such that the other thread is favored if both

<!-- pág. 272 -->

214 Asynchronous Concurrent Execution
                           threads wish to enter their critical sections. Also, tlWantsToEnter is controlled
                           exclusively by thread T1; similarly, t2WantsToEnter is modified exclusively by
                           thread T 2 . Now assume that T1 is the only thread executing inside its critical sec-
                           tion—this implies that tlWantsToEnter = t r u e and either favoredThread = 1 or
                           t2WantsToEnter = f a l s e .
                                For T2 to enter its critical section (line 39), either
                                 • t1WantsToEnter must be f a l s e ,
                                 • favoredThread must be 2, or
                                 • both t1WantsToEnter is f a l s e and favoredThread is 2.
                                    This proof will assume that T2 has successfully entered its critical section while
                           T1 executes inside its critical section and show that Peterson's Algorithm guaran-
                           tees mutual exclusion because this cannot occur (i.e., proof by contradiction). In the
                           first case (tlWantsToEnter is f a l s e ) , T 2 has entered its critical section because
                           tlWantsToEnter is f a l s e and favoredThread is either 1 or 2. However, as
                           described earlier in this section, t1WantsToEnter must be t r u e if thread T1 is also
                           executing inside its critical section—the only time t1WantsToEnter is f a l s e is
                           after T1 has exited its critical section (line 22) and before it attempts to reenter it
                           (line 15). Thus thread T2 could not have entered its critical section because
                           tlWantsToEnter was f a l s e . This also implies that thread T 2 could not have
                           entered its critical section given the third condition (both t1WantsToEnter is
                           f a l s e and favoredThread is 2).
                                    We now must show by contradiction that T 2 cannot enter its critical section
                           because favoredThread cannot be set to 2 while T1 executes inside its critical sec-
                           tion. To enter its critical section, T 2 must have set t2WantsToEnter to t r u e (line
                           36), then favoredThread to 1 (line 37) before exiting the while loop in line 39.
                           Therefore, if thread T2 executes in its critical section while thread T1 executes in its
                           critical section, the value of favoredThread must have changed after thread T2
                           executed line 37. Note that the only time favoredThread is set to 2 is when T1 exe-
                           cutes line 16 of its mutual exclusion entry code, requiring that T1 exit its critical sec-
                           tion. Note that thread T 2 has already set t2WantsToEnter to t r u e in line 36.
                           Consequently, when thread T1 attempts to enter its critical section in line 18, it will
                           busy wait, because both t2WantsToEnter is t r u e and favoredThread is 2.
                           Although T2 may enter its critical section, now T1 must wait until T2 exits its critical
                           section. This contradicts the statement that T 2 and T 1 are both executing inside their
                           critical sections. Because we have shown by contradiction that T2 and T1 cannot
                           concurrently execute inside their critical sections, we have proven that Peterson's
                           Algorithm ensures mutual exclusion.
                                 Deadlock and indefinite postponement are impossible in Peterson's Algo-
                           rithm as long as no thread terminates unexpectedly. [Note: As always, we mean that
                           deadlock and indefinite postponement could not be caused by the mutual exclusion
                           entry and exit code. They nevertheless could occur if the threads misbehaved in
                           their critical sections.] For deadlock to occur, both T1 and T2 must concurrently

<!-- pág. 273 -->

                                                       5.4    Software Solutions to the Mutual Exclusion Problem 215

busy wait in their whi 1 e loops. This will not occur, because f avoredTh read is either
1 or 2 and is not modified during the while loop, meaning that the whi 1 e test will
always fail for one thread, allowing it to enter its critical section. For indefinite post-
 ponement to occur, one thread would have to be able to continually complete and
reenter its critical section while the other thread busy waited. Because each thread
sets the value of favoredThread to the number corresponding to the other thread
before entering the while loop, Peterson's Algorithm ensures that the two threads
will alternate execution of their critical sections, meaning that indefinite postpone-
ment cannot occur.

Self Review
1. What major similarity is there between Dekker's Algorithm and Peterson's Algorithm?
2. What variable is necessary to prevent indefinite postponement?
Ans: 1) They both have the same three global variables. 2) Removing the favoredThread
• ariable would allow for the possibility of indefinite postponement.

5.4.3 N-Thread Mutual Exclusion: Lamport's Bakery Algorithm
Dijkstra was the first to present a software implementation of n-thread mutual
exclusion primitives.18 Knuth responded with a solution that eliminated the possi-
bility of indefinite postponement in Dijkstra's algorithm, but still allowed a process
to experience a (potentially) lengthy delay.19 This generated a series of efforts to
rind algorithms with shorter delays. Eisenberg and McGuire presented a solution
guaranteeing that a process will enter its critical section within n — \ tries.20 Lam-
port developed a solution that is particularly applicable to networks of computers
(see the Biographical Note, Leslie Lamport). 21 The algorithm, which we discuss in
depth in this section, uses a "take-a-ticket" system like those employed in busy bak-
eries, and has been dubbed Lamport's Bakery Algorithm. Burns et al. offer a solu-
tion to n-thread mutual exclusion that uses a single shared variable.22 Carvalho and
Roucairol discuss enforcing mutual exclusion in computer networks. 23
       Lamport was the first to introduce an algorithm that allows threads to enter
critical sections quickly when access to the critical section is not contested (which is
often the case). 24 Such fast mutual exclusion algorithms tend to suffer from ineffi-
ciency when the critical section is indeed a point of contention. Anderson and Kim
present an algorithm that allows for fast entry into a critical section in the absence
of contention and for good performance under contention. 25
       Many of the early solutions to the n-thread mutual exclusion problem are dif-
ficult to understand because they require a large number of shared variables and
complicated loops that determine if a thread can enter its critical section. Lamport's
algorithm provides a simpler solution that borrows from a common real-world sce-
nario—waiting for service at a bakery. Moreover, Lamport's algorithm does not
require that any operation occur atomically.
       Lamport's algorithm is modeled on a bakery in which one employee services
customer requests for baked goods; this employee can service exactly one customer

<!-- pág. 274 -->

216 Asynchronous Concurrent Execution

                                at a time. If only one customer is present, the transaction is simple: the customer
                                requests baked goods, the employee retrieves the items, the customer pays for the
                                food and exits the bakery. However, when multiple customers concurrently request
                                service, the employee must determine in what order to serve the customers. Many
                                bakeries serve customers in first-come-first-served order by requiring that they take
                                a numbered ticket from a ticket dispenser as they enter the bakery. The tickets are
                                dispensed in ascending order (i.e., if the current ticket contains a value n, the next



                Biographical Note

    Leslie Lamport
    Leslie Lamport received his Ph.D.      that terminate prematurely. This         w i t h o u t any atomic statements,
    in Mathematics from Brandeis           simple algorithm mimics the syn-         which require specific hardware
    University in 1972.26 He has           chronization used for customers at       support. 33 He designed at least
    worked for the Massachusetts           a bakery.29 Each process that hits       four algorithms of varying com-
    Computer Associates, SRI Interna-      the entry gate to its critical section   plexity and degrees of fault toler-
    tional, Digital Equipment Corpo-       gets a number which is one higher        ance. 34 He also invented the first
    ration/Compaq and is currently at      than the previous process's num-         mutual exclusion algorithm that
    Microsoft Research.27 He believes      ber, just as each new customer to a      runs in short, constant time if no
    that his development of a method       bakery takes a new ticket with an        process is currently executing in
    to structure logical proofs in a       ordering number on it. As a pro-         its critical section. 35
    hierarchical fashion that is easier    cess exits its critical section, the           Lamport's most famous
    to read will be his most memora-       next number is "called," and the         paper, "Time, Clocks, and the
    ble work, 2 8 but he is also well      process holding that number is           Ordering of Events in a Distrib-
    known for several computer sci-        allowed to proceed. 30                   uted System," describes a logical
    ence contributions in the area of            Lamport produced numer-            clock mechanism that is used to
    mutual exclusion of processes that     ous papers on methods for writ-          determine the order of events'
    share data.                            ing formal specifications for            occurrences, and a method using
           One of Lamport's major con-     concurrent programs, and on              these clocks to synchronize dis-
    tributions was the bakery algo-        proving program correctness. As          tributed processes.36, 37, 38
    rithm for synchronizing processes      part of his work on proofs, he also           Aside from his work in
    using first-come-first-served prior-   designed a logic system called the       mutual exclusion, Lamport also
    ity (see Section 5.4.3, N-Thread       Temporal Logic of Actions (TLA),         developed the LaTeX typesetting
    Mutual Exclusion: Lamport's Bak-       which can be used to verify both         system in 1985, based on Donald
    ery Algorithm). Important features     circuit and software logic.31, 32        Knuth's TeX typesetting lan-
    of the bakery algorithm are that it         Some of Lamport's mutual            guage. 39
    eliminates indefinite postpone-        exclusion work demonstrated that
    ment and is resilient to processes     mutual exclusion can be attained

<!-- pág. 275 -->

                                                        5.4    Software Solutions to the Mutual Exclusion Problem 217

ticket contains the value n + 1). After each transaction, the employee serves the cus-
tomer possessing the ticket with the lowest numerical value, which ensures that cus-
tomers are served in first-come-first-served order.
      Figure 5.12 presents an implementation of Lamport's algorithm for n threads.
In Lamport's algorithm, each thread represents a customer that must "take a ticket"
to determine when the thread can enter its critical section. When a thread possesses
a ticket with the lowest numerical value, it can enter its critical section. Mutual
exclusion is enforced by resetting the thread's ticket value when it exits its critical
section. Unlike a real-world ticket dispenser, Lamport's algorithm allows multiple
threads to obtain the same ticket number. As we will see, Lamport's algorithm
includes a tie-breaking mechanism to ensure that only one thread can execute in its
critical section at a time.


   1 System:
   2
  3 // array that records which threads are taking a ticket
  4 boolean choosing[n];
  5
  6 // value of the ticket for each thread initialized to 0
  7 int ticket[n];
  8
  9 startThreads(); // initialize and launch all threads
 10
 11 Thread Tx:
 12
 13    void main()
 14    {
 15        x = threadNumber(); // store current thread number
 16
 17        while ( !done )
 18        {
 19            // take a ticket
 20            choosing[x] = t r u e ; // begin t i c k e t s e l e c t i o n process
 21            t i c k e t [ x ] = maxValue( t i c k e t ) + 1;
 22            choosing[x] = f a l s e ; // end t i c k e t s e l e c t i o n process
 23
 24            // w a i t f o r number to be c a l l e d by comparing c u r r e n t
 25            // t i c k e t   value t o other t h r e a d ' s t i c k e t value
 26            for ( i n t i = 0 ; i < n ; i++)
 27            {
 28                i f ( i == x )
 29               {
  30                  continue; // no need to check own ticket
  31               } // end if
  32

Figure 5.12 | Lamport's Bakery Algorithm. (Part 1 of 2.)

<!-- pág. 276 -->

218   Asynchronous Concurrent Execution


                               33                // busy w a i t w h i l e t h r e a d [ i ] is choosing
                               34                while ( choosing[i] != false );
                               35
                               36                // busy w a i t u n t i l c u r r e n t t i c k e t value is lowest
                               37                while ( t i c k e t [ i ] != 0 && t i c k e t [ i ] < t i c k e t [ x ] );
                               38
                               39                // t i e - b r e a k e r code favors smaller thread number
                               40                if ( t i c k e t [ i ] == t i c k e t [ x ] && i < x )
                               41
                               42                   / / loop u n t i l t h r e a d [ i ] leaves i t s c r i t i c a l   section
                               43                   while ( t i c k e t [ i ] != 0 ); // busy w a i t
                               44            } / / end f o r
                               45
                               46           // critical section code
                               47
                               48           ticket[x] = 0; // exitMutualExclusion
                               49
                               50           // code outside critical section
                               51
                               52       } // end while
                               53
                               54   } // end Thread TX

                             Figure 5.12 | Lamport's Bakery Algorithm. (Part 2 of 2.)
                                      Lines 3-7 declare two arrays that are shared among all n threads participating
                             in mutual exclusion. The boolean array choosi ng (line 4) is of size n; if thread Tx is
                             currently selecting a ticket value, then choosing[x] is t r u e . Otherwise, choos-
                             i n g [ x ] is f a l s e . The integer array t i c k e t (line 7) contains values corresponding
                             to each thread's ticket. Similar to choosi ng, thread T x 's ticket value is contained in
                             ti cket [x]. In this example, the initial value for each thread's ticket is zero.
                                      Lines 13-54 represent the code executed by thread T x , one of the n threads
                             attempting to execute their critical sections. Each thread participating in the bakery
                             algorithm executes the same enterMutualExclusion (lines 19-44) and exitMutu-
                             a l E x c l u s i o n (line 48) constructs. When a thread is started, it executes line 15,
                             which stores an integer value in variable x to uniquely identify the thread. The
                             thread uses this value to determine its corresponding entries in the choosing and
                             t i c k e t arrays.
                                      Each thread "takes a ticket" by executing the code in lines 19-22. Line 20 indi-
                             cates that the current thread is attempting to take a ticket by setting choosi ng [x]
                             to t r u e . As we will soon see, this step is necessary to ensure that mutual exclusion is
                             enforced if multiple threads concurrently determine their ticket values. The thread
                             calls method maxVal ue (line 21), which returns the largest value in the integer array
                             t i c k e t . The thread then adds one to that value and stores it as its ticket value,
                             ti cket [x] (line 21). Note that if there are numerous threads in the system, method
                             maxValue can take substantial time to execute, increasing the likelihood that the

<!-- pág. 277 -->

                                                       5.4    Software Solutions to the Mutual Exclusion Problem 219

  thread that calls maxValue will be preempted before the method completes. After
the thread has assigned its ticket value to t i c k e t [ x ] (line 21), the thread sets
   choosing[x] to f a l s e (line 22), indicating that it is no longer selecting a ticket
value. Note that when a thread exits its critical section (line 48), the ticket value is
set to zero, meaning that a thread's ticket value is nonzero only if it wishes to enter
its critical section.
      Unlike a real-world bakery, in which an employee calls each customer's num-
ber in turn for service, the bakery algorithm requires that each thread determine
when it can enter its critical section (lines 24-44). Before entering its critical sec-
tion, a thread must execute the for loop (lines 26-44) that determines the state of
all threads in the system. If thread Ti, the thread to examine, and thread Tx, the
thread executing the for statement, are identical (line 28), T x executes the con-
tinue statement (line 30), which skips the remaining statements in the body of the
for loop and proceeds directly to increment i in line 26.
         Otherwise, Tx determines if Ti is choosing a ticket value (line 34). If Tx does
not wait until Ti has chosen its ticket before entering its critical section, mutual
exclusion can be violated. To understand why, let us first examine the other two
conditions that are tested in each iteration of the for loop.
         Line 37 tests if the current thread possesses a ticket value that is less than or
equal to the ticket value for the thread it is examining. This condition is analogous
to a real-world bakery—each thread must wait until it possesses the lowest nonzero
ticket value.
         Unlike a real-world bakery, however, two or more threads in the system may
obtain the same ticket value. For example, consider a thread Ta that is preempted
after method maxValue returns and before the thread assigns a new value to
t i c k e t [a] in line 21. If the next thread that executes calls maxVal ue, the method
will return the same value as it did to Ta. As a result, any of the threads could obtain
the same ticket value. Therefore, in the case of a tie, line 40 indicates that the thread
with the lowest unique identifier proceeds first.
       Let us return to line 34 to examine how mutual exclusion is violated if thread
Tx does not wait if Ti is selecting a ticket value. For example, consider what happens
if thread Ta is preempted after returning from method maxVal ue but before adding
one to the ticket value (line 21). Assume for this example that maxVal ue returns the
value 215. After Ta is preempted, several other threads execute their mutual exclu-
sion entry code. Consider two threads, Tb and T c , that execute after Ta is preempted
and complete the ticket selection code (lines 19-22), leaving thread Tb with ticket
value 216 (note that Ta's ticket value is currently 0) and Tc with ticket value 217. It
is possible for Tb to complete its mutual exclusion entry code (lines 19-14), execute
its critical section (line 46) and exit its critical section (line 48) before Ta regains
control of a processor. It is likewise possible for Tc to enter its critical section before
Ta regains control of a processor.
     If Tc is preempted while executing code in its critical section and Ta regains
control of a processor, Ta completes the instruction in line 21 by setting its ticket

<!-- pág. 278 -->

220   Asynchronous Concurrent Execution

                             value to 216, which is lower than that of T c .Thus,T a could execute its mutual exclu-
                             sion entry code and enter its critical section before Tc exits its critical section,
                             thereby violating mutual exclusion. For this reason, Tx must wait until Ti has com-
                             pleted its ticket selection (line 34) before comparing ticket values in lines 36-43.
                                      When Tx has passed all of the tests for each thread (lines 28-43), Tx is guaran-
                             teed exclusive access to its critical section. When Tx exits its critical section, it sets
                             its ticket value to 0 (line 48) to indicate that it is no longer executing in its critical
                             section nor is it attempting to enter its critical section.
                                      In addition to being one of the simplest n-thread mutual exclusion algorithms.
                             Lamport's bakery algorithm exhibits several interesting properties. For example, it
                             does not require its instructions to be executed atomically. Recall from Section 5.3,
                             Implementing Mutual Exclusion Primitives, that we required instructions to exe-
                             cute atomically. This was necessary because both Dekker's and Peterson's algo-
                             rithms require multiple threads to modify a shared variable to control access to
                             their critical sections. If each thread could read and modify this variable simulta-
                             neously on different processors, the threads might read inconsistent values of their
                             shared variables. This might allow both threads to enter their critical sections simul-
                             taneously, violating mutual exclusion. Although many architectures provide a small
                             set of atomic instructions (see Section 5.5, Hardware Solutions to the Mutual
                             Exclusion Problem), it is rare to find a multiprocessor system that provides hard-
                             ware to prevent threads from reading and writing data simultaneously.
                                      Lamport's Bakery Algorithm provides an elegant solution to mutual exclu-
                             sion on multiprocessor systems, because each thread is assigned its own set of vari-
                             ables that control access to its critical section. Although all threads in the system
                             share the arrays choosing and ti cket, thread T x is the only thread that can modify
                             values in choosi ng [x] and ti cket [x]. This prevents threads from reading incon-
                             sistent data, because the variables a thread examines while performing its mutual
                             exclusion entry code cannot be simultaneously modified by another thread.
                                      Another interesting property of the bakery algorithm is that threads that are
                             waiting to enter their critical sections are admitted in first-come-first-served (FCFS)
                             order unless multiple threads possess the same ticket value. Finally, Lamport's algo-
                             rithm can continue to enforce mutual exclusion even if one or more threads fail,
                             provided that the system sets each failed thread's value in the choosi ng array to
                             f a l s e and each thread's value in the ti cket array to 0. Given this final provision,
                             Lamport's Bakery Algorithm cannot suffer from deadlock or indefinite postpone-
                             ment, a property that is particularly important in multiprocessor and distributed
                             systems, where the failure of a hardware device such as a processor does not neces-
                             sarily result in system failure.

                            Self Review
                             1. Describe why n-thread mutual exclusion might be difficult in a distributed or networked
                                system.
                             2. What would happen if the system did not perform housekeeping tasks such as setting the
                                ticket values to zero and choosi ng values to fal se for terminated threads?

<!-- pág. 279 -->

                                                           5.5 Hardware Solutions to the Mutual Exclusion Problem 221
3. Suppose multiple threads obtain the same ticket value. In the sample code provided, the
   thread with the lowest unique identifier enters its critical section first. Does it matter in
   what order these threads enter their critical sections?
Ans: 1) There is latency between a computer's sending a message and the receiving com-
puter's actually receiving it, meaning that mutual exclusion algorithms must account for delays
 between when a thread modifies a shared variable and when another thread attempts to enter
its critical section. 2) The whole system could suffer from indefinite postponement. Suppose a
 thread terminated while choosing a ticket number, and therefore choosing for that thread
would be set to true forever. Other threads wishing to enter mutual exclusion would wait for-
ever for the terminated thread to set the choosing array entry to false. 3) Unless the pro-
grammer wishes to assign priorities to threads that possess the same ticket value, the order in
which threads with identical ticket values enter their critical section does not matter. Lines 34
and 37 of Fig. 5.12 ensure that no thread with a higher or lower ticket value can enter its critical
section before the threads with identical ticket values. The system need only ensure that each of
 the threads with the same ticket value eventually enters its critical section.



5.5 Hardware Solutions to the Mutual Exclusion Problem
In the preceding examples the software solutions to the mutual exclusion problem
that make few assumptions about the system's instruction set and hardware capa-
bilities. As discussed in Chapter 2, Hardware and Software Concepts, hardware
designers tend to implement mechanisms previously handled by software to
improve performance and reduce development time. This section presents several
mechanisms provided in hardware to help solve the problem of mutual exclusion.

5.5.1 Disabling Interrupts
The reason mutual exclusion primitives are needed in a uniprocessor system is
largely that preemption allows multiple threads to access shared data asynchro-
nously, which can result in program errors. Threads are typically preempted by
interrupts such as the interrupting clock (to signal quantum expiration). Therefore,
a simple way to enforce mutual exclusion is to disable (or mask) interrupts. Unfor-
tunately, the disabling of interrupts places limitations on what software can do
inside a critical section. For example, a thread that enters an infinite loop in its criti-
cal section after disabling interrupts will never yield its processor. On a uniproces-
sor system, the operating system could no longer use timer interrupts to gain
control of the processor, meaning that the system will hang. In real-time systems,
such as an air traffic control system, such a result could put people's lives at risk.
       Disabling interrupts is not a viable solution for mutual exclusion in a multi-
processor system. After all, its purpose is to ensure that preemption will not occur.
However, in a multiprocessor system, two threads can execute at the same time,
each on a different processor. If these threads are unsynchronized, disabling inter-
rupts alone does not prevent them from simultaneously executing inside their criti-
cal sections. Therefore, simply disabling interrupts on either processor (or both) is
insufficient to enforce mutual exclusion. In general, operating system designers
avoid disabling interrupts to provide mutual exclusion. However, there are a lim-

<!-- pág. 280 -->

222 Asynchronous Concurrent Execution
                           ited set of solutions in which it is optimal for the kernel to disable interrupts for
                           trusted code whose execution requires a short period of time. See the Linux and
                           Windows XP case studies in Chapters 20 and 21, respectively, for examples of how
                           current operating systems enforce mutual exclusion by disabling interrupts.

                           Self Review
                           1. (T/F) If a thread enters an infinite loop after disabling interrupts on a multiprocessor sys-
                              tem, the operating system can no longer execute.
                           2. Why should a thread avoid requesting blocking I/O in a critical section in a uniprocessor
                              system while interrupts are disabled?
                          Ans: 1) False. The operating system can execute on any processor on which interrupts are
                          not disabled. The thread in the infinite loop can be aborted or restarted, but any data it shares
                          with other threads may be left in an inconsistent state, which may cause program errors. 2)
                          When a thread requests blocking I/O, the operating system places that thread in the blocked
                          state until it receives an I/O completion event. Since such events are generated by hardware
                          interrupts, but the operating system would never receive this signal while interrupts
                          remained disabled. As a result, the thread will remain waiting in the blocked state for an
                          event it will never receive. This is an example of deadlock, which is further discussed in
                          Chapter 7, Deadlock and Indefinite Postponement.


                           5.5.2 Test-and-Set Instruction
                           Disabling interrupts is rarely a practical solution to the synchronization problem, so
                           other techniques include the use of special hardware instructions. Recall from our
                           previous examples that shared data can become corrupted because the system may
                           preempt a thread after it has read the value at a memory location, but before the
                           thread can write a new value to the location. The test-and-set instruction enables a
                           thread to perform this operation atomically (i.e., indivisibly).40, 41 Such operations
                           are also described as atomic read-modify-write (RMW) memory operations.
                           because the processor reads a value from memory, modifies its value in its registers
                           and writes the modified value to memory without interruption. 42
                                  The previous examples of software mutual exclusion required that a thread
                           read a variable to determine that no other thread is executing a critical section, then
                           set a variable, known as a lock, to indicate that the thread is executing its critical
                           section. The difficulty in guaranteeing mutually exclusive access to critical sections
                           in software was that a thread could be preempted between testing the availability of
                           a critical section and setting a lock to keep other threads from entering their critical
                           sections. The testAndSet instruction eliminates the possibility of preemption
                           occurring during this interval.
                                  The instruction
                                 testAndSet( a, b )

                           works as follows. First the instruction reads the value of b, which may be either
                           t r u e or f a l s e . Then, the value is copied into a, and the instruction sets the value of
                           b to t r u e .

<!-- pág. 281 -->

                                                           5.5 Hardware Solutions to the Mutual Exclusion Problem 223

      Figure 5.13 shows how a thread can employ testAndSet to enforce mutual
exclusion. The global boolean variable, occupied, is true if either thread is in its
critical section. Thread T1 decides to enter its critical section based on its local bool-
ean variable, plMustWait. If p1MustWait is true, T1 must wait; otherwise, the
 thread may enter its critical section. Thread T1 initially sets variable p1MustWait to
true. Then the thread repeatedly calls testAndSet on p1MustWait and the global
variable occupi ed. If T2 is not in its critical section, the value of occupied is f a l s e .
In this case, the testAndSet assigns f a l s e to variable p1MustWait and sets occu-
pied to t r u e . The while fails at this point and T 1 enters its critical section. Because
the indivisible hardware instruction set occupied to t r u e , T 2 will be unable to
enter its critical section until T 1 has reset occupi ed to f a l s e .



   1     System:
   2
   3     boolean occupied = f a l s e ;
   4
   5     startThreads();            // i n i t i a l i z e and launch both threads
   6
   7     Thread T1:
   8
   9     void main()
 10      {
 11           boolean p1MustWait = t r u e ;
 12
 13           w h i l e ( !done )
 14           {
 15                 w h i l e ( p1MustWait )
 16                 {
 17                         testAndSet( p1MustWait, occupied );
 18                 }
 19
 20                 // critical section code
 21
 22                 p1MustWait = true;
 23                 occupied = false;
 24
 25                 // code outside critical section
 26
 27           } // end while
 28
 29      } // end Thread T1
 30
  31     Thread T2:
 32

Figure       5.13       |    testAndSet instruction for mutual exclusion. (Part 1 of   2.)

<!-- pág. 282 -->

224   Asynchronous Concurrent Execution

                              33    void main()
                              34    {
                              35       boolean p2MustWait = true;
                              36
                              37       while ( !done )
                              38       {
                              39          while ( p2MustWait )
                              40          {
                              41             testAndSet( p2Mustwait, occupied );
                              42          }
                              43
                              44           // critical section code
                              45
                              46           p2MustWait = true;
                              47           occupied = f a l s e ;
                              48
                              49           // code outside c r i t i c a l   section
                              50
                              51       } // end w h i l e
                              52
                              53    } // end Thread T2

                            Figure 5.13 | testAndSet instruction for mutual exclution. (Part 2 of 2.)

                                  Now suppose that T2 already is in its critical section when T1 wants to enter. In
                            this case, occupied remains t r u e during T 1 's repeated while tests. Therefore, T 1
                            continues its busy waiting until T2 eventually leaves its critical section and sets
                            occupied to f a l s e . At this point, the testAndSet assigns occupied's value to
                            p1MustWait, thus allowing T1 to enter its critical section.
                                  Although testAndSet as used here does guarantee mutual exclusion, the
                            solution may suffer from indefinite postponement. It is possible for a thread to exit
                            the critical section and loop around to call testAndSet before the competing
                            thread has a chance to execute again.
                            .
                                   Self Review
                            1. Does the algorithm in Fig. 5.13 prevent indefinite postponement?
                            2. (T/F) The testAndSet instruction enforces mutual exclusion.
                            Ans: 1) No, the algorithm in Fig. 5.13 requires a favoredProcess variable as discussed in
                            Section 5.4.1, Dekker's Algorithm, to prevent indefinite postponement. 2) False. The
                            testAndSet instruction is a tool that programmers use to simplify software solutions to
                            mutual exclusion but the instruction itself does not enforce mutual exclusion.
                            .
                            5.5.3 Swap Instruction
                            To simplify synchronization code and improve program efficiency, most architec-
                            tures provide several atomic instructions. However, each architecture supports a
                            different set of atomic operations, meaning the testAndSet instruction might not

<!-- pág. 283 -->

                                                      5.5    Hardware Solutions to the Mutual Exclusion Problem 225

be available to the application or system programmer. In this section, we demon-
strate how another instruction that performs an atomic read-modify-write memory
operation can provide functionality identical to the testAndSet instruction.
      It is common for programs to exchange (or swap) values stored in two differ-
ent variables (consider, for example, the Quicksort algorithm). Although the con-
cept is simple, a successful exchange of values between two variables in most high-
level programming languages requires three instructions and the creation of a tem-
porary variable:
       temp = a;
       a = b;
       b = temp;
      Because such swapping operations are performed regularly, many architec-
tures support a swap instruction that enables a thread to exchange the values of the
two variables atomically.
      The instruction
       swap( a, b )

proceeds as follows. First the instruction loads the value of b, which may be either
t r u e or f a l s e , into a temporary register. Then, the value of a is copied to b and the
value of the temporary register is copied to a.
        Figure 5.14 shows how a thread can employ swap to enforce mutual exclusion.
Similar to Fig. 5.13, the global boolean variable, occupi ed, is t r u e if either thread is
in its critical section. Thread T1 decides to enter its critical section based on its local
boolean variable, p1MustWai t. Similarly, thread T2 decides to enter its critical section
based on its local variable p2MustWait. Note that the swap instruction can be used
interchangeably with the testAndSet instruction in this algorithm. The only differ-
ence between Fig. 5.13 and Fig. 5.14 is that we have created a "fast track" to the criti-
cal section, in which control of the critical section can be obtained by the execution of
one fewer instruction (i.e., by testing the loop condition after the swap instruction).



   1    System:
   2
   3    boolean occupied = f a l s e ;
   4
   5    startThreads();      // i n i t i a l i z e and launch both threads
   6
   7    Thread T1:
   8
   9     v o i d main()
  10    {
  11        boolean plMustWait = t r u e ;
  12

Figure 5.14 I swap instruction for mutual exclusion. (Part 1 of 2.)

<!-- pág. 284 -->

226 Asynchronous Concurrent Execution

                             13       while ( !done )
                             14       {
                             15           do
                             16           {
                             17              swap( p1MustWait, occupied );
                             18           } while ( p1MustWait );
                             19
                             20           // critical section code
                             21
                             22           p1MustWait = true;
                             23           occupied = false;
                             24
                             25           // code outside critical section
                             26
                             27      } // end while
                             28
                             29   } // end Thread T1
                             30
                             31 Thread T2:
                             32
                             33   void main()
                             34   {
                             35      boolean p2MustWait = true;
                             36
                             37       while ( !done )
                             38       {
                             39          do
                             40          {
                             41             swap( p2MustWait, occupied );
                             42          } while ( p2MustWait );
                             43
                             44           // critical section code
                             45
                             46           p2MustWait = true;
                             47           occupied = false;
                             48
                             49           // code outside critical section
                             50
                             51       } // end while
                             52
                             53   } // end Thread T2

                           Figure 5.14 | swap instruction for mutual exclusion. (Part 2 of 2.)

                           Self Review
                           1. Why might it be more likely for a swap instruction to be on a system than a testAndSet?
                           Ans: Many algorithms require some sort of swapping, so a hardware instruction, swap, is
                           very useful for algorithms other than just those providing mutual exclusion.

<!-- pág. 285 -->

                                                                                           5.6    Sermaphores     227

5.6 Semaphores
 Another mechanism that a system can provide to implement mutual exclusion is
the semaphore, as described by Dijkstra in his seminal paper on cooperating
sequential processes (see the Biographical Note, Edsger W. Dijkstra). 43 A sema-


                       Biographical Note

  Edsger W. Dijkstra
  One of computer science's most         were the semaphore construct          top honor—for his work on the
  famous and prolific researchers        (the first object invented for use    ALGOL programming language
  was Edsger Wybe Dijkstra. Born in      in mutual exclusion algorithms)       which introduced block structure
  1930 in the Netherlands, he            and the layered design (an            (to define variable scopes and
  received his Ph.D. in Computing        improvement over the older            mark control structure bodies) and
  Science from the University of         monolithic approach, where com-       other concepts used by most mod-
  Amsterdam and worked as a pro-         ponents that provide similar func-    ern languages.49, 50, 51 Yet another
  grammer at the Mathematisch            tions are grouped together in         achievement for Dijkstra was Dijk-
  Centrum in Amsterdam. He later         layers). He implemented both          stra's Algorithm. This efficient
  served as a Professor of Mathe-        concepts in his THE multipro-         algorithm takes a weighted graph
  matics at the Eindhoven Institute      g r a m m i n g system—an operat-     and finds the shortest paths from a
  of Technology, then as a professor     ing system built for the Dutch EL     given node to each of the other
  of Computer Science at the Uni-        X8 computer. 47 He later expanded     nodes.
  versity of Texas at Austin. Dijkstra   the concept of a layered system to           Dijkstra wrote over 1300 doc-
  died in 2002. 44                       enable the construction of a more     uments, mostly in the form of his
        Perhaps his best-known con-      general operating system, where       EWDs—short essays (named after
  tribution to computer science was      the enhanced layered design           his initials) that were numbered in
  his article that started the struc-    could be used to build operating      sequence and distributed infor-
  tured programming revolution,          systems for any computer. 48 In his   mally to the computer science
  "GOTO Considered Harmful," 4 5 a       description of the THE system, he     community. 52 Some were technical
  letter to the editor published in      described how semaphores could        and serious, while others, such as
  Communications of the ACM in           be used for synchronization. He is    "How Do We Tell Truths That
  March of 1968. Dijkstra claimed        also known for posing the Dining      Might Hurt?" were mainly humor-
  that the GOTO statement, unless        Philosophers synchronization          ous.53 In another EWD—"The End
  used carefully, quickly results in     problem, which illustrates subtle     of Computer Science?" written in
  "spaghetti code"—meaning the           difficulties in parallel program-     2000—he attacked the quality of
  path of execution is nearly impos-     ming (see Section 7.2.4, Example:     today's software and argued that
  sible to follow. 4 6                   Dining Philosophers).                 more computer science research is
        Dijkstra's main contribu-             In 1972, Dijkstra received the   needed to improve basic design
  tions to operating system design       Turing Award—computer science's       concepts.54

<!-- pág. 286 -->

228   Asynchronous Concurrent Execution

                             phore contains a protected variable whose integer value, once initialized, can be
                             accessed and altered by only one of two operations, P and V. [Note: P and V are
                             short for the Dutch words, proberen, which means "to test," and verhogen, which
                             means "to increment."] A thread calls the P operation (also called the wait opera-
                             tion) when it wants to enter its critical section and calls the V operation (also called
                             the signal operation) when it wants to exit its critical section. Before a semaphore
                             can be used for synchronization, it must be initialized. Initialization sets the value of
                             the protected variable to indicate that no thread is executing in its critical section. It
                             also creates a queue that stores references to threads waiting to enter their critical
                             sections protected by that semaphore. Note that P and V are simply abstractions
                             that encapsulate and hide the details of mutual exclusion implementations. These
                             operations can be applied to a system with any number of cooperating threads.

                             5.6.1 Mutual Exclusion with Semaphores
                             Figure 5.15 demonstrates how mutual exclusion is enforced using a semaphore. The
                             system initializes the semaphore occupi ed to 1; such semaphores are called binary
                             semaphores. This value indicates that the critical section is available.
                                      The program in Fig. 5.15 uses the P and V operations as the enterMutualEx-
                             c l u s i o n ( ) and exitMutualExclusion() primitives from Section 5.2.3, Mutual
                             Exclusion Primitives. When a thread wants to enter a critical section that is pro-
                             tected by semaphore S, the thread calls P( S ), which operates as follows

                                1   System:
                                2
                                3    // create semaphore and initialize value to 1
                                4    Semaphore occupied = new Semaphore(1);
                                5
                                6   startThreadsO; // initialize and launch both threads
                                7
                                8    Thread Tx:
                                9
                               10   void main()
                               11 {
                               12       while ( !done )
                               13       {
                               14          P( occupied );       // wait
                               15
                               16           // critical section code
                               17

                               18          V( occupied ); // signal
                               19
                               20         // code outside critical section
                               21      } // end while
                               22   } // Thread TX

                             Figure 5.15 | Mutual exclusion with semaphores.

<!-- pág. 287 -->

                                                                                               5.6   Semaphores   229
      If S>0
        S = S-1
      Else
        The calling thread is placed in the semaphore's queue of waiting threads
 Because Fig. 5.15 initializes the semaphore value to 1, only one thread will be
 allowed into the critical section at a time. When this thread calls P, the semaphore's
 value is reduced to 0. When another thread calls P, that thread will be blocked.
       After a thread finishes executing in its critical section, the thread calls V( S ).
  This operation proceeds as follows
      If any threads are waiting on S
         Resume the "next" waiting thread in the semaphore's queue
      Else
         S = S+1
Thus, if any threads are waiting on the semaphore, the "next" thread, which
depends on the semaphore implementation, executes. Otherwise, the value of S is
 incremented, allowing one more thread to enter its critical section.
      A proper semaphore implementation requires that P and V be indivisible
operations. Also, if several threads attempt a P(S) simultaneously, the implementa-
tion should guarantee that only one thread will be allowed to proceed. The others
will be kept waiting, but the implementation of P and V can guarantee that threads
will not suffer indefinite postponement. For example, when a thread blocks on a
semaphore, the system might place that thread in a queue associated with the sema-
phore. When another thread calls P, the system can select one of the threads in the
queue to release. We shall assume a first-in-first-out queuing discipline for threads
blocked on a semaphore (to avoid indefinite postponement).

Self Review
1. What could potentially happen if a thread called the V without having called the P opera-
   tion?
2. What could potentially happen if threads that blocked on a semaphore were not
   dequeued in a first-in-first-out order?
Ans: 1) One scenario is that the semaphore is initially 1 and no threads are waiting. The V
increments the semaphore's value to 2. Now two threads using P could both enter their criti-
cal sections. 2) A thread could suffer from indefinite postponement.


5.6.2 Thread Synchronization with Semphores
In the previous section, we saw how a program can use a semaphore to protect
access to a critical section. Semaphores also can be used to synchronize two or more
concurrent threads. For example, suppose one thread,T 1 , wants to be notified about
the occurrence of a particular event. Suppose some other thread, T 2 , is capable of
detecting that this event has occurred. To synchronize these two threads, T1 exe-
cutes some preliminary instructions, then calls P on a semaphore that has been ini-

<!-- pág. 288 -->

230   Asynchronous Concurrent Execution

                            tialized to 0, causing T1 to block. Eventually, T2 executes V to signal that the event
                            has occurred. This allows T1 to proceed (with the semaphore still zero).
                                   This mechanism succeeds even if T2 detects the event and signals it with V
                            before T1 waits for the event by calling P. The semaphore will have been incre-
                            mented from 0 to 1, so when T1 calls P, the operation will simply decrement the
                            semaphore from 1 to 0, and T1 will proceed without waiting for the event.
                                   One example of thread synchronization is the producer/consumer relation-
                            ship, introduced in Section 5.2.1, Java Multithreading Case Study, Part II.
                            Figure 5.16 shows how to implement this relationship with semaphores. Both
                            threads share a variable called sharedValue. The producer generates values and
                            assigns them to this variable, and the consumer retrieves and processes the values
                            the producer places in this variable. Each thread may need to wait for an event to
                            occur before it can accomplish its task. The consumer may need to wait for a value
                            to be produced (indicated by the producer signaling semaphore valueProduced):
                            the producer must wait for a previously produced value to be consumed (indicated
                            by the consumer signaling semaphore valueConsumed).




                               1   System:
                               2   //' semaphores that synchronize access to sharedValue
                               3   Semaphore valueProduced = new Semaphore(O);
                               4   Semaphore valueConsumed = new Semaphore(1);
                               5   int sharedValue; // variable shared by producer and consumer
                               6
                               7   startThreads(); // initialize and launch both threads
                               8
                               9   Producer Thread:
                              10
                              11   void main()
                              12   {
                              13      int nextValueProduced; // variable to store value produced
                              14
                              15      while ( !done )
                              16      {
                              17         nextValueProduced = generateTheValue(); // produce value
                              18         P( valueConsumed ); // wait until value is consumed
                              19         sharedValue = nextValueProduced; // critical section
                              20     V(    valueProduced ); // signal that value has been produced
                              21
                              22      } // end while
                              23
                              24   } // end producer thread

                            Figure 5.16 | Producer/consumer relationship implemented with semaphores.
                            (Part 1 of 2.)

<!-- pág. 289 -->

                                                                                               5.6   Semaphores   231


  25
  2 6 Consumer Thread:
  27
  28   void main()
  29 {
  30       int nextValue; // variable to store value consumed
  31
  32       while ( !done )
  33       {
  34          P( valueProduced ); // wait until value is produced
  35          nextValueConsumed = sharedValue; // critical section
  36          V( valueConsumed ); // signal that value has been consumed
  37          processTheValue( nextValueConsumed ); // process the value
  38
  39       } // end while
  40
  41   } // end consumer thread

Figure 5.16 | Producer/consumer relationship implemented with semaphores.
(Part 2 of 2.)

       The implementation of each thread is straightforward. The producer gener-
 ---s a new value (line 17), then waits on semaphore valueConsumed (line 18). The
semaphore's value is initially 1 (line 4), so the producer assigns the newly created
value nextValueProduced to shared variable sharedValue (line 19). Then the
producer signals semaphore val ueProduced (line 20). The consumer waits on this
semaphore (line 34) and, when the producer signals val ueProduced (line 20), the
consumer assigns the shared variable sharedVal ue to a local variable nextValue-
Consumed (line 35). The consumer then signals semaphore valueConsumed (line
36). which allows the producer to create a new value, and so on. The semaphores
ensure mutually exclusive access to shared variable sharedValue and ensure that
the threads alternate so that the consumer always reads the value that the producer
has just created.

Self Review
1. (T/F) A thread can be in only one semaphore's waiting queue at a time.
2. What happens if semaphore valueProduced is initialized to a value of 1 instead of a value
   of 0?
Ans: 1) True. A thread is blocked when placed in a semaphore's queue of waiting threads,
meaning that thread is unable to execute code that waits on any other semaphore. 2) The
consumer could potentially consume a value before the produced produces it.


5.6.3 Counting Semaphores
A counting semaphore (also called a general semaphore) is a semaphore that is ini-
tialized to an integral value greater than zero and commonly greater than one. A

<!-- pág. 290 -->

232 Asynchronous Concurrent Execution

                           counting semaphore is particularly useful when a resource is to be allocated from a
                           pool of identical resources. The semaphore is initialized to the number of resources
                           in the pool. Each P operation decrements the semaphore by 1, indicating that
                           another resource has been removed from the pool and is in use by a thread. Each V
                           operation increments the semaphore by 1, indicating that a thread has returned a
                           resource to the pool and the resource may be reallocated to another thread. If a
                           thread attempts a P operation when the semaphore has been decremented to zero,
                           then the thread must wait until a resource is returned to the pool by a V operation.

                           Self Review
                           1. Describe how to implement a binary semaphore with a counting semaphore.
                           2. (T/F) The V operation on a counting semaphore always adds 1 to the count.
                           Ans: 1) Just initialize the counting semaphore to a value of one. 2) False. If one or more
                           threads are waiting, V lets one of the threads proceed and does not increment the count.




                           5.6.4 Implementing Semaphores
                           Semaphores can be implemented in user applications and in the kernel. Given Dek-
                           ker's algorithm or the availability of a testAndSet or swap machine instruction, it
                           is straightforward to implement P and V with busy waiting. However, busy waiting
                           wastes processor cycles that could be put to better use in a multiprogrammed sys-
                           tem. In Chapter 3, Process Concepts, we studied the thread-state switching mecha-
                           nisms implemented in the kernel. We noted that a thread requesting an I/O
                           operation voluntarily blocks itself pending completion of the I/O. The blocked
                           thread does not busy wait—it remains asleep until the system awakens it and moves
                           it to the ready list.
                                  Semaphore operations can be implemented in the kernel by blocking waiting
                           threads to avoid busy waiting.55 A semaphore is implemented as a protected variable
                           and a queue in which threads can wait for V operations. When a thread attempts a P
                           operation on a semaphore whose value is zero, the thread relinquishes the processor
                           and blocks itself to await a V operation on the semaphore. The system places the
                           thread in the queue of threads waiting on that semaphore. (We assume a first-in-first-
                           out queue discipline. Other disciplines have been investigated.)56 The system then
                           reassigns the processor to the next ready thread. The thread in the semaphore queue
                           eventually moves to the head of the queue. A subsequent V operation removes the
                           thread from the semaphore queue and places it on the ready list.57
                                  Of course, threads attempting simultaneous P and V operations on a semaphore
                           must be guaranteed exclusive access to the semaphore by the kernel. In the case of
                           uniprocessor systems, because P and V are so short, their indivisibility can be ensured
                           by simply disabling interrupts while P and V operations are executing. This prevents
                           the processor from being usurped until the operation is complete (at which point

<!-- pág. 291 -->

                                                                                                  5.6 Semaphores 233
 interrupts are again enabled). This should be done with care, or it could lead to poor
performance or even deadlock (see the Anecdote, Unclear Requirements).
      In the kernel of a multiprocessor system, one of the processors can be given
the job of controlling the ready list and determining which processors run which
threads.58 Another approach to implementing a kernel for a multiprocessor system
is to control access (via busy waiting) to a shared ready list.59 A distributed operat-
ing system kernel could have one processor control the ready list, but normally
each processor manages its own ready list and essentially has its own
kernel.60, 61, 62, 63 As a thread migrates between various processors of a distributed
system, control of that thread is passed from one kernel to another.


Self Review
1. What is a major benefit of implementing semaphores in the kernel?
2. Consider a semaphore allows the thread with the highest priority to proceed when V is
   called. What potential problem can this cause?
Ans: 1) Semaphores can avoid busy waiting. The kernel can suspend a thread that attempts
a P operation when the semaphore's current value is 0, and move it back to the ready queue
when a V operation is called. This could increase performance. 2) Threads in the semaphore's
wait queue may be indefinitely postponed by higher-priority threads.




                Anecdote
  Unclear Requirements
  In his early years in industry, HMD       ers w h o died this year in alpha-        printed a alphabetized list of all
  worked for a company that devel-          betical order." This crossed his          the Connecticut pensioners w h o
  oped custom software solutions            eyes, because pensioners, of              died that year-which turns out to
  for a wide range of clients. One          course, rarely die in alphabetical        be what the client really wanted.
  client-an actuarial firm-sent him         order! His client was inaccessible        That client was much more careful
  the following requirements-               for a few days, so HMD created a          when specifying the requirements
  Develop a program that will print         report program that worked as he          for future projects.
  a list of the "Connecticut pension-       thought it shou Id-one that


  Lesson to operating systems designers: Before you build a complex piece of software like a substantial com-
  ponent of an operating system, be sure that the requirements are absolutely clear. You not only need to
  "solve the problem right;" you need to "solve the right problem" in the first place.

<!-- pág. 292 -->

234    Asynchronous Concurrent Execution

Web Resources
www.ddj.com/documents/s=924/ddj9801g/9801g.htm                      developer.java.sun.com/developer/Books/
Describes a method for implementing mutual exclusion in             performance2/chap3.pdf
Java. It describes, both generally and specifically for Java, how   Chapter from Sun's multithreaded and network programming
a programmer might implement mutual exclusion between a             book. It describes how to handle mutual exclusion in Java. The
number of threads.                                                  discussion is motivated by describing some circumstances that
www.es.utexas.edu/users/EWD/                                        mutual exclusion helps avoid; then the article provides a thor-
Contains electronic copies of manuscripts authored by E. W.         ough treatment of implementing mutual exclusion to avoid
Dijkstra, including his seminal paper that introduced sema-         these unwanted circumstances.
phores.
www.osdata.com/topic/1anguage/asm/coproc.htm                        www.teamten.com/1awrence/242.paper/242.paper.html
Describes several machine-language instructions for concur-         Provides a survey of mutual exclusion algorithms implemented
rency, such as test-and-set and swap.                               by operating systems running in a multiprocessor environment.



Summary
When more than one thread exists in a system at the same            another (i.e., reading data), the system should allow the
time, the threads are said to be concurrent. Two concurrent         threads to proceed concurrently. When a thread is access-
threads can execute completely independently of one                 ing shared modifiable data, the thread is said to be in its
another, or they can execute in cooperation. Processes that         critical section (or critical region). To prevent the kinds of
operate independently of one another but must occasion-             errors we encountered earlier, the system should ensure
ally communicate and synchronize to perform cooperative             that only one thread can execute the instructions in its criti-
tasks are said to execute asynchronously.                           cal section at a time. If one thread attempts to enter its crit-
       When one thread reads data that another thread is            ical section while another thread executes its critical
writing, or when one thread writes data that another thread         section, the first thread should wait until the executing
is also writing, indeterminate results can occur. We can solve      thread exits its critical section. Once a thread has exited its
this problem by granting each thread exclusive access to the        critical section, a waiting thread (or one of the waiting
shared variable. While one thread increments the shared             threads, if there are several), may enter and execute its crit-
variable, all other threads desiring to do so will be made to       ical section. If a thread in its critical section terminates,
wait. This is called mutual exclusion. When the executing           either voluntarily or involuntarily, then the operating sys-
thread finishes accessing the shared variable, the system will      tem, in performing its termination housekeeping, must
allow one of the waiting processes to proceed. This is called       release mutual exclusion so that other threads may enter
serializing access to the shared variable. In this manner,          their critical sections.
threads will not be able to access shared data simultaneously.             We discussed the enterMutualExclusion() and e x i t -
       In a producer/consumer relationship, the producer            Mutual Exclusion() primitives, which invoke the most fun-
thread generates data and stores it in a shared object, and         damental operations inherent to mutual exclusion. These
the consumer thread reads data from the shared object. We           primitives exhibit the following properties: each machine-
demonstrated how logic errors can arise with unsynchro-             language instruction is executed indivisibly;no assumption is
nized access among multiple threads to shared data —data            made about the relative speeds of asynchronous concurrent
could be lost if the producer places new data into the              threads; a thread that is executing instructions outside its
shared buffer before the consumer consumes the previous             critical section cannot prevent other threads from entering
data, and data could be incorrectly duplicated if the con-          their critical sections; and a thread cannot be indefinitely
sumer consumes data again before the producer produces              postponed from entering its critical section.
the next value. If this logic were part of an air traffic control          An elegant software implementation of mutual exclu-
application, people's lives could be at risk.                       sion primitives was first presented by Dekker. We followed
       Mutual exclusion needs to be enforced only when              Dijkstra's development of Dekker's Algorithm, which pro-
threads access shared modifiable data—when threads are              vides mutual exclusion while addressing the problems of
performing operations that do not conflict with one                 busy waiting, lockstep synchronization, deadlock and

<!-- pág. 293 -->

                                                                                                          Key     Terms      235

 ndefinite postponement. We then discussed simpler and                  Another mutual exclusion mechanism is semaphores,
more efficient algorithms developed by G. L. Peterson and        as described by Dijkstra. A semaphore contains a protected
L. Lamport. Lamport's Bakery Algorithm, which is                 variable whose integer value, once initialized, can be
designed for distributed systems, demonstrates a software        accessed and altered only by calling one of two operations,
mutual exclusion algorithm for n threads that is valid in        P and V. A thread calls the P operation (also called the wait
multiprocessor systems and that does not require its opera-      operation) when it wants to enter a critical section; the
tions to be performed atomically.                                thread calls the V operation (also called the signal opera-
      Several hardware mechanisms have been developed            tion) when it wants to exit the critical section. Before a
to help implement mutual exclusion. A simple way to              semaphore can be used for synchronization, it must be ini-
enforce mutual exclusion using hardware is to disable (or        tialized. Initialization sets the value of the protected vari-
mask) interrupts. This solution benefits from simplicity:        able to indicate that no thread is executing in a critical
however, the disabling of interrupts can be disastrous if a      section. A counting semaphore (also called a general sema-
thread misbehaves inside a critical section. Moreover, dis-      phore) may be initialized to a value greater than one.
abling interrupts is not a viable solution for mutual exclu-     Counting semaphores are particularly useful when
sion in a multiprocessor system. Other hardware                  resources are to be allocated from a pool of identical
techniques have been developed, including the use of spe-        resources. Semaphores can be implemented in user appli-
cial hardware instructions. The test-and-set and swap            cations and in the kernel. Given Dekker's Algorithm or the
instructions enable a thread to perform atomic read-mod-         availability of a testAndSet or swap machine instruction, it
ify-write (RMW) memory operations. These instructions            is straightforward to implement P and V with busy waiting.
eliminate the possibility of preemption between the              However, busy waiting wastes processor cycles that could
instruction that determines if a thread can enter its critical   be put to better use in a multiprogrammed system. Sema-
section and the instruction that sets a variable to indicate     phore operations can also be implemented in the kernel to
that no other thread may enter the critical section.             avoid busy waiting by blocking waiting threads.



Key Terms
atomic operation—Operation performed without interruption.       critical section—Section of code that performs operations on a
asynchronous concurrent threads—Threads that exist simulta-            shared resource (e.g., writing data to a shared variable).
    neously but operate independently of one another and               To ensure program correctness, at most one thread can
    that occasionally communicate and synchronize to per-              simultaneously execute in its critical section.
    form cooperative tasks.                                      deadlock—State of a thread when it cannot continue execution
                                                                     because it is waiting for an event that will never occur.
binary semaphore—Semaphore whose value can be no greater
    than one, typically used to allocate a single resource.      Dekker's Algorithm—Algorithm that ensures mutual exclu-
                                                                    sion between two threads and prevents both indefinite
busy waiting—Form of waiting where a thread continuously
                                                                    postponement and deadlock.
    tests a condition that will let the thread proceed eventu-
    ally; while busy waiting, a thread uses processor time.      Dijkstra's Algorithm—Efficient algorithm to find the shortest
                                                                     paths in a weighted graph.
concurrent—The description of a process or thread that exists
    in a system simultaneously with other processes and/or       disable interrupts—To temporarily ignore interrupts to allow a
    threads.                                                          thread on a uniprocessor system to execute its critical sec-
                                                                      tion atomically.
consumer—Application that reads and processes data from a
                                                                 fast mutual exclusion algorithm—Implementation of mutual
    shared object.
                                                                      exclusion that avoids the overhead of a thread performing
consumer thread—Thread whose purpose is to read and pro-              multiple tests when no other thread is contending for its
    cess data from a shared object.                                   critical section. This first fast mutual exclusion algorithm
counting semaphore- Semaphore whose value may be greater              was proposed by Lamport.
    than one, typically used to allocate resources from a pool   general semaphore—See counting semaphore.
    of identical resources.                                      indefinite postponement—Situation in which a thread waits
critical region—See critical section.                                 for an event that might never occur.

<!-- pág. 294 -->

236 Asynchronous Concurrent Execution
indivisible operation—See atomic operation.                           semaphore—Mutual exclusion abstraction that uses two
Lamport's Bakery Algorithm—N-thread mutual exclusion                      atomic operations (P and V) to access a protected integer
   algorithm based on a "take a ticket" system.                           variable that determines if threads may enter their critical
                                                                          sections.
lockstep synchronization—Situation where            asynchronous
    threads execute code in strict alternation.                       serialize—To control access to a shared variable such that
                                                                           only one thread can access the variable at a time;
mutual exclusion—Restriction whereby execution by a thread
                                                                           another thread can access the variable only after the first
    of its critical section precludes execution by other threads
                                                                           has finished.
    of their critical sections. Mutual exclusion is crucial to cor-
    rect execution when multiple threads access shared writ-          signal (semaphores)—Operation on a semaphore that incre-
    able data.                                                             ments the value of the semaphore's variable. If threads
                                                                           are sleeping on the semaphore, the signal wakes one and
mutual exclusion lock—Variable that indicates if a thread is
                                                                           decrements the semaphore's value by 1.
    executing its critical section; if the lock indicates that a
    thread is in its critical section, other threads are locked       swap instruction—Operation that exchanges the values of two
    out of their own critical sections.                                   variables atomically. This instruction simplifies mutual
                                                                          exclusion implementations by eliminating the possibility
mutual exclusion primitives—Fundamental operations that are
                                                                          that a thread will be preempted while performing a read-
    needed to implement mutual exclusion: enterMutual Ex-
                                                                          modify-write memory operation.
    c l u s i o n ( ) and exitMutualExclusion().
                                                                      termination housekeeping—In the case of mutual exclusion
P operation—Operation on a semaphore. If the variable in the
                                                                          algorithms, task performed by the operating system to
    semaphore is 0, then the P operation blocks the calling
                                                                          ensure that mutual exclusion is not violated and that
    thread. If the variable is greater than 0, the operation will
                                                                          threads can continue to execute if a thread terminates
    decrement the variable by one and allow the calling
                                                                          while executing its critical section.
    thread to proceed.
                                                                      test-and-set—Instruction implemented in hardware that atom-
producer—Thread or process that creates and places data into
                                                                           ically tests the value of a variable and sets the value of the
    a shared object.
                                                                           variable to true. This instruction simplifies mutual exclu-
producer thread—Thread that creates and places data into a                 sion implementations by eliminating the possibility that a
    shared object.                                                         thread will be preempted while performing a read-mod-
producer/consumer relationship—Interaction between threads                 ify-write memory operation.
    that produce data (called producers) and threads that             THE Multiprogramming System—First layered operating sys-
    consume produced data (called consumers) that illus-                 tem architecture, created by Edsger Dijkstra.
    trates many of the intricacies of asynchronous concurrent
                                                                      V operation—Operation on a semaphore that increments the
    execution.
                                                                          value of the semaphore's variable if there are no threads
protected variable (semaphores)—Integer variable storing the              waiting on the semaphore. If threads are waiting, the V
    state of a semaphore that can be accessed and altered only            operation wakes one of these.
    by calling P or V on that semaphore.
                                                                      wait (semaphores)—If the variable in the semaphore is 0, then
read-modify-write (RMW) memory operation—Operation that                    the operation blocks the calling thread. If the variable is
    atomically reads the contents of a variable, changes the               greater than 0, the operation will decrement the variable
    contents (possibly based on what it has read) and writes the           by one and allow the calling thread to proceed. Wait is
    new value to memory. These operations simplify mutual                  also called the P operation.
    exclusion algorithms by providing atomic operations.




Exercises
5.1 Give several reasons why the study of concurrency is              mutual exclusion must be enforced to prevent the production
appropriate and important for students of operating systems.          of indeterminate results.
5.2 Explain why the following statement is false: When sev-           5.3   Dekker's Algorithm, testAndSet, swap, and the sema-
eral threads access shared information in main memory,                phore operations P and V may all be used to enforce mutual

<!-- pág. 295 -->

                                                                                                                    Exercises        237
exclusion. Compare and contrast these various schemes. Con-            5.9 Perform an exhaustive analysis of Dekker's Algorithm.
sider their respective advantages and disadvantages.                   Does it have any weaknesses? If not, explain why.
5.4 When two threads simultaneously attempt enterMutu-                 5.10 The solution for n-thread mutual exclusion presented by
a l E x c l u s i o n ( ) , we have assumed that the "winner" is       Eisenberg and McGuire 64 guarantees that any single process
selected at random. Discuss the ramifications of this assump-          will enter its critical section within n-1 tries in the worst case.
tion. Give a better method. Discuss how such a method might            Should one hope for better performance with n processes?
be implemented on a multiprocessor system where several                5.11 Mutual exclusion primitives can be implemented with
threads could in fact attempt enterMutualExclusion() at                busy waiting or with blocking. Discuss the applicability and
precisely the same moment.                                             relative merits of each approach.
5.5 Comment on the use of mutual exclusion primitives in               5.12 Explain in detail how binary semaphores and binary
Fig. 5.17.                                                             semaphore operations can be implemented in the kernel of an
                                                                       operating system.
5.6       What is the real significance of Dekker's Algorithm?
                                                                       5.13 Explain how the disabling and enabling of interrupts is
5.7 In Dekker's Algorithm (Fig. 5.10), it is possible for T2 to        useful in implementing mutual exclusion primitives on unipro-
leave its critical section, execute its mutual exclusion exit code,    cessor systems.
execute its mutual exclusion entry code, and ultimately reenter
its critical section before T1 gets the chance it has been waiting     5.14 Show how to implement semaphore operations with
for to enter its own critical section. Could T2 actually reenter its   testAndSet.
own critical section many times before T1 got a chance? If it          5.15 Some computers have a swap instruction that, like
could, then explain precisely how this could happen and indicate       testAndSet, simplifies the implementation of mutual exclu-
if this situation is an example of indefinite postponement. If it      sion primitives. The swap instruction simply exchanges the val-
could not happen, then explain precisely how it is prevented.          ues of two booleans and thus requires a temporary holding
                                                                       area; the swap instruction is executed indivisibly.
5.8 Explain how the example concurrent program that
enforces mutual exclusion with testAndSet (Fig. 5.13) could                  a. Express swap as a procedure header in a high-level
lead to indefinite postponement. Indicate why this possibility                  language.
would nevertheless be highly unlikely. Under what circum-                    b. Show how your swap procedure (assuming it is exe-
stances would it be acceptable to use this mutual exclusion                     cuted indivisibly) may be used to implement the
technique? Under what circumstances would it be completely                      enterMutualExclusion() and exitMutualExclu-
unacceptable?                                                                   s i o n ( ) primitives.

      1     // perform instructions outside of a c r i t i c a l section
      2
      3    enterMutualExclusion();
      4
      5        // perform instructions inside a critical section
      6
   7           enterMutualExclusion();
   8
   9               // perform instructions inside a nested c r i t i c a l section
  10
  11           exitMutualExclusion();
  12
  13           // perform instructions inside a c r i t i c a l section
  14
  15       exi tMutualExclusion();
  16
  17        // perform instructions outside of a c r i t i c a l section

Figure 5.17 | Code for Exercise 5.5.

<!-- pág. 296 -->

238 Asynchronous Concurrent Execution

5.16 As mentioned in the text, critical sections that reference                 show that any thread waiting to enter its critical section will be
nonintersecting sets of shared variables may indeed be exe-                     delayed no longer than the time it takes for the other thread to
cuted simultaneously. Suppose the mutual exclusion primitives                   enter and leave its own critical section once.
are each modified to include a parameter list of the particular
shared variables to be referenced in a critical section.                        5.19 Present a detailed analysis of Peterson's Algorithm to
                                                                                demonstrate that it works properly. In particular, show that
       a. Comment on the use of these new mutual exclusion                      deadlock cannot occur, that indefinite postponement cannot
          primitives in Fig. 5.18.                                              occur, and that mutual exclusion is enforced.
       b. Suppose the two threads in Fig. 5.19 operate concur-
          rently. What are the possible outcomes?                               5.20 Show that if a system implementing Lamport's Bakery
                                                                                Algorithm does not perform termination housekeeping, the
5.17 In Dekker's Algorithm, what (if anything) would hap-                       system could suffer from indefinite postponement.
pen if the two assignment statements in the mutual exclusion
exit code were reversed?                                                        5.21 Based on your understanding of the kernel and interrupt
                                                                                handling, describe how semaphore operations may be imple-
5.18 Show that Peterson's Algorithm (Fig. 5.11) is bounded                      mented on a uniprocessor system.
fair65; i.e., a thread cannot be delayed indefinitely on any delay
condition that occurs with indefinite repetition. In particular,



   1    // perform instructions outside of a critical section
   2
   3    enterMutualExclusion(a);
   4
   5        // perform instructions inside a critical section
   6
   7         enterMutualExclusion(b);
   8
   9            / / perform i n s t r u c t i o n s i n s i d e a nested c r i t i c a l s e c t i o n
  10
  11        exitMutualExclusion(b);
  12
  13        // perform i n s t r u c t i o n s i n s i d e a c r i t i c a l    section
  14
  15    exitMutualExclusion(a);
  16
  17     / / perform i n s t r u c t i o n s outside o f a c r i t i c a l section

Figure 5.18 | New mutual exclusion primitives for Exercise 5.16(a).

Thread T1                                                                      Thread T2
   1     enterMutualExclusion(a);                                                1    enterMutualExclusion(b);
   2                                                                             2
   3    enterMutualExclusion(b);                                                 3    enterMutualExclusion(a);
   4                                                                             4
   5    exitMutualExclusion(b);                                                  5    exitMutualExclusion(a);
   6                                                                             6
   7     exitMutualExclusion(a);                                                 7    exitMutualExclusion(b);

Figure 5.19 | Code for Exercise 5.16(b).

<!-- pág. 297 -->

                                                                                                               Exercises       239
5.22 In the text we implied that busy waiting can be wasteful.      these operations are not executed indivisibly, mutual exclusion
Is it always wasteful? What alternatives exist? Discuss the pros    may not be properly enforced.
and cons of busy waiting.
                                                                    5.26 Suppose the only mutual exclusion primitive provided to
5.23 If many threads attempt a P operation, which one should        user-level threads is a command that disables interrupts for the
be allowed to proceed? What are the key issues here? What           next 32 instructions, then reenables interrupts. Explain the
criteria might you use to decide which thread should proceed        benefits and drawbacks of this approach.
on a uniprocessor system? What criteria might you use on a
multiprocessor system?                                              5.27 How could cooperating threads implement mutual
                                                                    exclusion primitives in the system mentioned in the previous
5.24 A system supports only binary semaphores. Show that            exercise?
counting semaphores may be simulated on this system by using
binary semaphores.                                                  5.28 Does the code in Fig. 5.20 provide mutual exclusion? If
                                                                    not, show an interleaving in which mutual exclusion is not pre-
5.25 One requirement in the implementation of a P and V is          served?
that each of these operations must be executed indivisibly; i.e.,
 once started, each operation runs to completion without inter-     5.29 Name one other mutual exclusion constraint the algo-
ruption. Give an example of a simple situation in which, if         rithm in Fig. 5.20 violates.




  1    System:
  2
  3    int turn = 1;
  4    boolean t1WantsToEnter = false;
  5    boolean t2WantsToEnter = false;
  6
  7    startThreads(); // initialize and launch both threads
  8
  9    Thread T1:
 10
 11    void main()
 12    {
 13       while ( !done )
 14       {
 15          t1WantsToEnter = true;
 16
 17              while ( turn != 1 )
 18              {
 19                 while ( t2WantsToEnter );
 20
 21                 turn = 1;
 22
 23              } // end while
 24
 25              // critical section code
 26
 27              t1WantsToEnter = false;

Figure 5.20 | Algorithm for Exercise 5.28 (Part 1 of 2.)

<!-- pág. 298 -->

240 Asynchronous Concurrent Execution

 28          // code outside critical section
 29       } // end outer while
 30    } // end Thread T1
 31
  32   Thread T2:
 33
 34    void main()
 35    {
 36       while ( !done )
 37       {
 38          t2WantsToEnter = true;
 39
 40            while ( turn != 2 )
 41            {
 42                 while ( t1wantsToEnter );
 43
 44               turn = 2;
 45            } // end while
 46
 47            // critical section code
 48
 49            t2WantsToEnter = false;
 50
 51          // code outside critical section
 52       } // end outer while
 53    } // end Thread T2

Figure 5.20 | AAlgorithm for Exercise 5.28. (Part 2 of 2.)


Suggested Projects
5.30 Prepare a research paper on Lamport's "fast mutual          5.34 Dijkstra is probably best known for his shortest-path
exclusion" algorithm. How does it work? Where is it used?        algorithm. However, he also contributed greatly in other fields
                                                                 of computer science. For example, we know from the text that
5.31 Research mutual exclusion in distributed systems. What
                                                                 he invented semaphores. Prepare a biography of E. W Dijk-
research is currently being done in that field?
                                                                 stra and the important contributions he made to the field of
5.32 Research mutual exclusion multiprocessor systems. Why       computer science. See, for example, www.cs.utexas.edu/
might this be easier than mutual exclusion in distributed sys-   users/EWD/.
tems?
                                                                 5.35 Research the Ada concurrency primitives. How is
5.33 Many mutual exclusion algorithms are verified using         mutual exclusion guaranteed in this language?
computer programs. Research how these programs manage to
verify that a certain algorithm is correct.



Suggested Simulations
5.36 Implement semaphores in Java. Then use them to pro-
vide synchronization between two threads in a producer/con-
sumer program.

<!-- pág. 299 -->

                                                                                                       Recommended Reading 241

Recommended Reading
 The problem of process synchronization was identified early            approach. Though Dijkstra first presented a solution to n-
and often in the literature. 66, 67, 68 The related problem of          thread mutual exclusion, Knuth, 75 Eisenberg and McGuire 76 ,
mutual exclusion has been studied in detail, and many                   Lamport, 77 Anderson and Kim 78 and others have continued to
resources are available that present solutions.69, 70, 71 Dijkstra      improve on the original algorithm. Dijkstra also introduced
first described the problem on mutual exclusion, identified             semaphores in his seminal paper on mutual exclusion.79 In
critical sections and applied Dekker's Algorithm to solve the           response, researchers developed techniques to improve upon
problem.72 Subsequently, Peterson 73 and Lamport 74 presented           the concept of semaphores. 80, 81, 82, 83 The bibliography for this
novel approaches to implementing software mutual exclusion,             chapter is located on our Web site at www.dentel.com/books/
both of which simplified code by introducing a more structured          os3e/Bibliography.pdf.




Works Cited
 1. Atwood, J. W., "Concurrency in Operating Systems," Computer,        13. Dijkstra, E. W, "Cooperating Sequential Processes," Technologi-
    Vol. 9, No. fO, October 1976, pp. 18-26.                                cal University, Eindhoven, Netherlands, 1965, reprinted in E
 2. Thomas, R. H., "A Majority Consensus Approach to Concur-                Genuys, ed., Programming Languages, New York: Academic
    rency Control," ACM Transactions on Database Systems, Vol. 4,           Press, 1968, pp. 43-112.
    1979, pp. 180-209.                                                  14. Peterson, G L., "Myths About the Mutual Exclusion Problem,"
 3. Wegner, P., and S. A. Smolka, "Processes, Tasks and Monitors: A         Information Processing Letters,Vol. 12, No. 3, June 1981. pp. 115-
    Comparative Study of Concurrent Programming Primitives,"                116.
    IEEE Transactions on Software Engineering, Vol. SE-9, No. 4,        15. Lamport, L., "A New Solution of Dijkstra's Concurrent Program-
    1983, pp. 446-462.                                                      ming Problem," Communications of the ACM, Vol. 17, No. 8,
 4. Chandy, K. M., and J. Misra, "Asynchronous Distributed Simula-          August 1974, pp. 453-455.
    tion via a Sequence of Parallel Computations," Communications       16. Dijkstra, E. W., "Cooperating Sequential Processes," Technologi-
    oftheACM,Yo\. 24, No. 4, April 1981.                                    cal University, Eindhoven, Netherlands, 1965, reprinted in F.
 5. Schlichting, R. D., and F. B. Schneider, "Understanding and Using       Genuys, ed., Programming Languages, New York: Academic
    Asynchronous Message Passing Primitives," Proceedings of the            Press, 1968, pp. 43-112.
    Symposium on Principles of Distributed Computing, August 18-20,     17. Peterson, G L., "Myths About the Mutual Exclusion Problem,"
    1982, Ottawa, Canada, ACM, New York, pp. 141-147.                       Information Processing Letters, Vol. 12, No. 3, June 1981, pp. 115-
 6. Bernstein, A. X, "Program Analysis for Parallel Processing,"            116.
    IEEE Transactions on Computers, Vol. 15, No. 5, October 1966,       18. Dijkstra, E. W., "Solution of a Problem in Concurrent Program-
    pp. 757-762.                                                            ming Control," Communications of the ACM, Vol. 8, No. 5, Sep-
 7. Courtois, P. X; Heymans, E; and D. L. Parnas, "Concurrent Con-          tember 1965, p. 569.
    trol with Readers and Writers," Communications of the ACM,          19. Knuth, D., "Additional Comments on a Problem in Concurrent
    Vol. 14, No. 10, October 1971, pp. 667-668.                             Programming Control," Communications of the ACM. Vol. 9,No.
 8. Lamport, L., "Concurrent Reading and Writing," Communica-               5, May 1966, pp. 321-322.
    tions of the ACM, Vol. 20, No. 11, November 1977, pp. 806-811.      20. Eisenberg, M. A., and M. R. McGuire, "Further Comments on
 9. Ricart, G., and A. K. Agrawala, "An Optimal Algorithm for               Dijkstra's Concurrent Programming Control Problem," Commu-
    Mutual Exclusion in Computer Networks," Communications of               nications of the ACM,Vol. 15, No. 11, November 1972, p. 999.
    the ACM, Vol. 24, No. 1, Xanuary 1981, pp. 9-17.                    21. Lamport, L., "A New Solution to Dijkstra's Concurrent Program-
10. Jones, D. W, "An Empirical Comparison of Priority Queue and             ming Problem," Communications of the ACM. Vol. 17, No. 8.
    Event Set Implementations," Communications of the ACM, Vol.             August 1974, pp. 453-455.
    29, No. 4, April 1986, pp. 300-311.                                 22. Burns, X E.; P. Jackson; N A. Lynch; M. J. Fischer; and G L.
11. Raynal, M., Algorithms for Mutual Exclusion, Cambridge, MA:             Peterson, "Data Requirements for Implementation of N-Process
    MIT Press, 1986.                                                        Mutual Exclusion Using a Single Shared Variable," Journal of the
                                                                            ACM, Vol. 29, No. 1, January 1982, pp. 183-205.
12. Dijkstra, E. W, "Cooperating Sequential Processes," Technologi-
    cal University, Eindhoven, Netherlands, 1965, reprinted in E        23. Carvalho, O. S. E., and G. Roucairol, "On Mutual Exclusion in
    Genuys, ed., Programming Languages, New York: Academic                  Computer Networks," Communications of the ACM, Vol. 26, No.
    Press, 1968, pp. 43-112.                                                2, February 1983, pp. 146-147.

<!-- pág. 300 -->

242 Asynchronous Concurrent Execution
24. Leslie Lamport, "A Fast Mutual Exclusion Algorithm," ACM                                            39. The LaTeX Project, "LaTeX Project home page," January 27.
    Transactions on Computer Systems (TOCS), Vol. 5, No. 1, pp.l-                                           2003, <www.latex-project.org/>.
    11,Feb. 1987.                                                                                       40. Gilbert, Philip, and W. J. Chandler, "Interference Between Com-
25. Anderson, James H., and Yong-Jik Kim, "An Improved Lower                                                municating Parallel Processes," Communications of the ACM.
    Bound for the Time Complexity of Mutual Exclusion," Proceed-                                            Vol. 15, No. 6, June 1972, p. 436.
    ings of the Twentieth Annual ACM Symposium on Principles of                                         41. Presser, Leon, "Multiprogramming Coordination," ACM Com-
    Distributed Computing, pp. 90-99, August 2001, Newport, Rhode                                           puting Surveys (CSUR), Vol. 7, No. 1, January 1975, p. 38.
    Island, United States.                                                                              42. Kruskal, Clyde P.; Larry Rudolph; and Marc Snir, "Efficient Syn-
26. Lamport, L., "The Writings of Leslie Lamport," September 8,                                             chronization of Multiprocessors with Shared Memory," ACM
    2003,        <research.microsoft.com/users/lamport/pubs/                                                Transactions on Programming Languages and Systems
    pubs.html>.                                                                                             (TOPLAS), October 1988, p. 580.
27. Lamport, L., "The Writings of Leslie Lamport," September 8,                                         43. Dijkstra, E. W., "Cooperating Sequential Processes," Technologi-
    2003,        <research.microsoft.com/users/lamport/pubs/                                                cal University, Eindhoven, Netherlands, 1965, reprinted in F.
    pubs.html>.                                                                                             Genuys, ed., Programming Languages, New York: Academic
                                                                                                            Press, 1968, pp. 43-112.
28. Milojicic, D., "A Discussion with Leslie Lamport," September
      2002, < d s o n l i n e . c o m p u t e r . o r g / 0 2 0 8 / f / I a m _ p r i n t . h t m > .   44. Computer Science Department of the University of Texas at Aus-
                                                                                                            tin, "E. W. Dijkstra Archive: Obituary," August 2002.
29. Anderson, J., "Lamport on Mutual Exclusion: 27 Years of Plant-
                                                                                                            <www.cs.utexas.edu/users/EWD/obituary.html>.
    ing Seeds," August 2001, <www.cs.unc.edu/~anderson/papers/
                                                                                                        45. Dijkstra, E., "GOTO Considered Harmful," March 1968.
    lamport.pdf>. Proceedings of the 20th Annual ACM Symposium
     on Principles of Distributed Computing, pp. 3-12.                                                      <www.acm.org/classics/oct95/>. Reprinted from Communi-
                                                                                                            cations of the ACM, Vol. 11. No. 3, March 1968, pp. 147-148.
30. Lamport, L., "A New Solution of Dijkstra's Concurrent Pro-
                                                                                                        46. Dijkstra, E„ "GOTO Considered Harmful," March 1968.
    gramming Problem," Communications of the ACM, Vol. 17, No.
                                                                                                            <www.acm.org/classics/oct95/>. Reprinted from Communi-
    8, August 1974, pp. 453-455, < r e s e a r c h . m i c r o s o f t . c o m / u s e r s /
                                                                                                            cations of the ACM, Vol. 11, No. 3, March 1968, pp. 147-148.
     lamport/pubs/bakery.pdf>.
                                                                                                        47. Dijkstra, E., "Appendix of The Structure of the "THE" Multipro-
31. Lamport, L., "TLA: The Temporal Logic of Actions," August 26,                                           gramming System," May 1968, <www.acm.org/classics/mar96/
                                                                                                            >. Reprinted from Communications of the ACM, Vol. 11, No. 5.
      2003, <research.microsoft.com/users/lamport/tIa/tla.html>.
                                                                                                            May 1968, pp. 345-346.
32. Lamport, L., et al., "Specifying and Verifying Systems with                                         48. Dijkstra, E., "Structure of an Extendable Operating System."
    TLA+," September 2002, < r e s e a r c h . m i c r o s o f t . c o m / u s e r s /                      November 1969, <www.cs.utexas.edu/users/EWD/ewd02xx/
     lamport/pubs/spec-and-verifying.pdf>.                                                                  EWD275.PDF>.
33. Anderson, J., "Lamport on Mutual Exclusion: 27 Years of Plant-                                      49. Computer Science Department of the University of Texas at Aus-
    ing Seeds," August 2001, <www.cs.unc.edu/~anderson/papers/                                              tin, "E. W. Dijkstra Archive: Obituary," August 2002.
      lamport.pdf>. Proceedings of the 20th Annual ACM Symposium                                            <www.cs.utexas.edu/users/EWD/obituary.html>.
    on Principles of Distributed Computing, pp. 3—12.                                                   50. T Whaley, "CS 313 — Edsger Wybe Dijkstra," <cs.wlu.edu/
34. Anderson, J., "Lamport on Mutual Exclusion: 27 Years of Plant-                                           ~whaleyt/classes/313/Turing/Crieco-Dijkstra.htm>.
    ing Seeds," August 2001, <www.cs.unc.edu/~anderson/papers/                                          51. Department of Computer and Information Science of the Uni-
      lamport.pdf>. Proceedings of the 20th Annual ACM Symposium                                            versity of Michigan at Dearborn, "The ALGOL Programming
    on Principles of Distributed Computing, pp. 3-12.                                                       Language," November 24, 1996, <www.engin.umd.umich.edu/
35. Lamport, L. "A Fast Mutual Exclusion Algorithm," November                                               CIS/course.des/cis400/algol/algol.html>.
    14, 1985, <research.microsoft.com/users/lamport/pubs/                                               52. Computer Science Department of the University of Texas at Aus-
    fast-mutex.pdf>.                                                                                        tin, "E. W. Dijkstra Archive: Obituary," August 2002.
36. Lamport, L., "The Writings of Leslie Lamport," September 8,                                             <www.cs.utexas.edu/users/EWD/obituary.html>.
    2003,     <research.microsoft.com/users/Iamport/pubs/pubs.html>.                                    53. Dijkstra, E., "How Do We Tell Truths That Might Hurt?" 1975.
                                                                                                            <www.cs.utexas.edu/users/EWD/ewd04xx/EWD498.PDF>.
37. Anderson, X, "Lamport on Mutual Exclusion: 27 Years of Plant-                                       54. Dijkstra, E., "The End of Computing Science?" 2000.
    ing Seeds," August 2001, <www.cs.unc.edu/~anderson/papers/                                              <www.cs.utexas.edu/users/EWD/ewdl3xx/EWD1304.PDF>.
      lamport.pdf >. Proceedings of the 20th Annual ACM Symposium                                       55. Hansen, P. Brinch, "The Nucleus of a Multiprogramming Sys-
    on Principles of Distributed Computing, pp. 3-12.                                                       tem," Communications of the ACM, Vol. 13, No. 4, April 1970, pp.
38. Lamport, L„ "Time, Clocks, and the Ordering of Events in a Dis-                                         238-241,250.
    tributed System," Communications of the ACM, Vol. 21, No. 7,                                        56. Stark, Eugene, "Semaphore Primitives and Starvation-Free
    July 1978, pp.558-565, < r e s e a r c h . m i c r o s o f t . c o m / u s e r s /                      Mutual Exclusion," Journal of the Association for Computing
      lamport/pubs/time-clocks.pdf>.                                                                        Machinery, Vol. 29, No. 4, October 1982, pp. 1049-1072.

<!-- pág. 301 -->

                                                                                                                              Works      Cited     243
     57 . Denning, P. J.; Dennis, T.D.; and J. A. Brumfield, "Low Conten-         71. Raynal, M., Algorithms for Mutual Exclusion, Cambridge, MA:
     tion Semaphores and Ready Lists," Communications of'the ACM,                     MIT Press, 1986.
     Vol. 24, No. 10, October 1981, pp. 687-699.                                  72. Dijkstra, E. W., "Cooperating Sequential Processes," Technologi-
58. v Brinch Hansen, P., "Edison: A Multiprocessor Language," Soft-                   cal University, Eindhoven, Netherlands, 1965, reprinted in E
     ware Practice and Experience, Vol. 11, No. 4, April 1981, pp. 325-               Genuys, ed., Programming Languages, New York: Academic
     361.                                                                             Press, 1968, pp. 43-112.
59. Linux kernel source code, version 2.5.75, < m i n e r . c s . w m . e d u /   73. Peterson, G. L., "Myths About the Mutual Exclusion Problem,"
     lxr3.linux/http/source/ipc/sem.c?v=2.5.75>.                                      Information Processing Letters,Vol. 12, No. 3, June 1981, pp. 115-
                                                                                      116.
60. Hansen, P. Brinch, "Distributed Processes—a Concurrent Pro-
                                                                                  74. Lamport, L., "A New Solution of Dijkstra's Concurrent Program-
    gramming Concept," Communications of the ACM, Vol. 21, No.
                                                                                      ming Problem," Communications of the ACM, Vol. 17, No. 8,
    11, November 1978, pp. 934-941.
                                                                                      August 1974, pp. 453-455.
61. Lamport, L., "Time, Clocks, and the Ordering of Events in a Dis-              75. Knuth, D., "Additional Comments on a Problem in Concurrent
    tributed System," Communications of the ACM, Vol. 21, No. 7,                      Programming Control," Communications of the A CM, Vol. 9, No.
    July 1978, pp. 558-565.                                                           5, May 1966, pp. 321-322.
62. Lamport, L., "The Implementation of Reliable Distributed Mul-                 76. Eisenberg, M. A., and M. R. McGuire, "Further Comments on
    tiprocess Systems," Computer Networks, Vol. 2, No. 2, April 1978,                 Dijkstra's Concurrent Programming Control Problem," Commu-
    pp. 95-114.                                                                       nications oftheACM,\o\. 15, No. 11, November 1972, p. 999.
63. Ricart, G., and A. K. Agrawala, "An Optimal Algorithm for                     77. Lamport, L., "A New Solution to Dijkstra's Concurrent Program-
    Mutual Exclusion in Computer Networks," Communications of                         ming Problem," Communications of the ACM, Vol. 17, No. 8,
    the ACM, Vol. 24, No. 1, January 1981, pp. 9-17.                                  August 1974, pp. 453-455.
64. Eisenberg, M. A., and M. R. McGuire, "Further Comments on                     78. Anderson, James H., and Yong-Jik Kim, "An Improved Lower
    Dijkstra's Concurrent Programming Control Problem," Commu-                        Bound for the Time Complexity of Mutual Exclusion," Proceed-
    nications of the ACM,Vol. 15,No. 11, November 1972, p. 999.                       ings of the Twentieth Annual ACM Symposium on Principles of
                                                                                      Distributed Computing, pp. 90-99, August 2001, Newport, Rhode
65. Andrews, G. R., and E B. Schneider, "Concepts and Notations
                                                                                      Island, United States.
    for Concurrent Programming," ACM Computing Surveys, Vol.
    15, No. 1, March 1983, pp. 3-44.                                              79. Dijkstra, E. W., "Cooperating Sequential Processes," Technologi-
                                                                                      cal University, Eindhoven, Netherlands, 1965, reprinted in F
66. Bernstein, A. J., "Program Analysis for Parallel Processing,"                     Genuys, ed., Programming Languages, New York: Academic
    IEEE Transactions on Computers, Vol. 15, No. 5, October 1966,                     Press, 1968, pp. 43-112.
    pp. 757-762.
                                                                                  80. Denning, P. X; Dennis, T.D.; and J. A. Brumfield, "Low Conten-
67. Courtois, P. X; E Heymans; and D. L. Parnas, "Concurrent Con-                     tion Semaphores and Ready Lists," Communications of the ACM,
    trol with Readers and Writers," Communications of the ACM,                        Vol. 24, No. 10, October 1981, pp. 687-699.
    Vol. 14, No. 10, October 1971, pp. 667-668.
                                                                                  81. Lamport, L., "Time, Clocks, and the Ordering of Events in a Dis-
68. Lamport, L., "Concurrent Reading and Writing," Communica-                         tributed System," Communications of the ACM, Vol. 21, No. 7,
    tions of the ACM,Vol. 20, No. 11, November 1977, pp. 806-811.                     July 1978, pp. 558-565.
69. Ricart, G., and A. K. Agrawala, "An Optimal Algorithm for                     82. Lamport, L., "The Implementation of Reliable Distributed Mul-
    Mutual Exclusion in Computer Networks," Communications of                         tiprocess Systems," Computer Networks,Vol. 2, No. 2, April 1978,
    the ACM, Vol. 24, No. 1, January 1981, pp. 9-17.                                  pp. 95-114.
70. Jones, D. W, "An Empirical Comparison of Priority Queue and                   83. Ricart, G, and A. K. Agrawala, "An Optimal Algorithm for
    Event Set Implementations," Communications of the ACM, Vol.                       Mutual Exclusion in Computer Networks," Communications of
    29, No. 4, April 1986, pp. 300-311                                                the ACM, Vol. 24,No. 1,January 1981,pp. 9-17.

<!-- pág. 302 -->

High thoughts must have high language.
      —Aristophanes—


As writers become more numerous, it is natural for readers to become more indolent.
      —Oliver Goldsmith—


When the last reader reads no more.
      —Oliver Wendell Holmes—


The first precept was never to accept a thing as true until I knew it as such witkout a sin-
gle doubt.
      —Rene Descartes-

This shows how much easier it is to be critical than to be correct.
      —Benjamin Disraeli—

