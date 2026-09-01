# A: Topics in Concurrency

> Fuente: Operating Systems Internals and Design Principles (William Stallings) — páginas 734–747 (numeración del PDF)

<!-- pág. 734 -->

            aPPENDIX a
                                        ToPICs IN CoNCUrrENCy
                      A.1        Race Conditions and Semaphores
                                     Problem Statement
                                     First Attempt
                                     Second Attempt
                                     Third Attempt
                                     Fourth Attempt
                                     A Good Attempt
                      A.2        A Barbershop Problem
                                     An Unfair Barbershop
                                     A Fair Barbershop
                      A.3        Problems




                                                                  A-1




Z01_STAL4290_09_GE_APPA.indd 1                                      4/13/17 11:22 AM

<!-- pág. 735 -->

            A-2   APPENDIX A / Topics in Concurrency

               A.1 RACE CONDITIONS AND SEMAPHORES

                      Although the definition of a race condition provided in Section 5.1 seems straight-
                      forward, experience has shown that students usually have difficulty pinpointing race
                      conditions in their programs. The purpose of this section, which is based on
                      [CARR01],1 is to step through a series of examples using semaphores that should
                      help clarify the topic of race conditions.

                      Problem Statement
                      Assume there are two processes, A and B, each of which consists of a number of
                      concurrent threads. Each thread includes an infinite loop in which a message is
                      exchanged with a thread in the other process. Each message consists of an integer
                      placed in a shared global buffer. There are two requirements:
                          1. After a thread A1 of process A makes a message available to some thread B1
                             in B, A1 can only proceed after it receives a message from B1. Similarly, after
                             B1 makes a message available to A1, it can only proceed after it receives a
                             ­message from A1.
                          2. Once a thread A1 makes a message available, it must make sure that no other
                              thread in A overwrites the global buffer before the message is retrieved by a
                              thread in B.
                           In the remainder of this section, we show four attempts to implement this
                      scheme using semaphores, each of which can result in a race condition. Finally, we
                      show a correct solution.

                      First Attempt
                      Consider this approach:
                          semaphore a = 0, b = 0;
                            int buf_a, buf_b;
                          thread_A(...)                                  thread_B(...)
                          {                                              {
                            int var_a;                                     int var_b;
                            ...                                            ...
                            while (true) {                                 while (true) {
                             . . .                                           . . .
                              var a =...;                                    var_b =...;
                              semSignal(b);                                  semSignal(a);
                              semWait(a);                                    semWait(b);
                              buf_a = var_a;                                 buf_b = var_b;
                              var_a = buf_b;                                 var_b = buf_a;
                              . . .;                                         . . .;
                            }                                              }
                          }                                              }

                      1
                       I am grateful to Professor Ching-Kuang Shene of Michigan Technological University for permission to
                      use this example.




Z01_STAL4290_09_GE_APPA.indd 2                                                                                               4/13/17 11:22 AM

<!-- pág. 736 -->

                                                     A.1 / RACE CONDITIONS AND SEMAPHORES   A-3

                           This is a simple handshaking protocol. When a thread A1 in A is ready to
                      exchange messages, it sends a signal to a thread in B then waits for a thread B1 in B
                      to be ready. Once a signal comes back from B1, which A perceives by performing
                      semWait(a), then A1 assumes that B1 is ready and performs the exchange. B1
                      behaves similarly, and the exchange happens regardless of which thread is ready first.
                           This attempt can lead to race conditions. For example, consider the following
                      sequence, with time going vertically down the table:


                                             Thread A1                  Thread B1
                                        semSignal(b)
                                        semWait(a)
                                                                  semSignal(a)
                                                                  semWait(b)
                                        buf_a = var_a
                                        var_a = buf_b
                                                                  buf_b = var_b


                            In the preceding sequence, A1 reaches semWait(a) and is blocked. B1 reaches
                      semWait(b) and is not blocked, but is switched out before it can update its buf_b.
                      Meanwhile, A1 executes and reads from buf_b before it has the intended value. At
                      this point, buf_b may have a value provided previously by another thread or pro-
                      vided by B1 in a previous exchange. This is a race condition.
                            A subtler race condition can be seen if two threads in A and B are active. Con-
                      sider the following sequence:


                 Thread A1                 Thread A2              Thread B1               Thread B2
             semSignal(b)
             semWait(a)
                                                             semSignal(a)
                                                             semWait(b)
                                      semSignal(b)
                                      semWait(a)
                                                             buf_b = var_b1
                                                                                     semSignal(a)
             buf_a = var_a1
                                      buf_a = var_a2


                            In this sequence, threads A1 and B1 attempt to exchange messages and go
                      through the proper semaphore signaling instructions. However, immediately after
                      the two semWait signals occur (in threads A1 and B1), thread A2 runs and executes
                      semSignal(b) and semWait(a), which causes thread B2 to execute
                      semSignal(a) to release A2 from semWait(a). At this point, either A1 or A2
                      could update buf_a next, and we have a race condition. By changing the sequence
                      of execution among the threads, we can readily find other race conditions.




Z01_STAL4290_09_GE_APPA.indd 3                                                                             4/13/17 11:22 AM

<!-- pág. 737 -->

            A-4   APPENDIX A / Topics in Concurrency
                            Lesson Learned: When a variable is shared by multiple threads, race conditions
                      are likely to occur unless proper mutual exclusion protection is used.


                      Second Attempt
                      For this attempt, we use a semaphore to protect the shared variable. The purpose is
                      to ensure that access to buf_a and buf_b is mutually exclusive. The program is as
                      follows:


                        semaphore a = 0, b = 0; mutex = 1;
                        int buf_a, buf_b;
                        thread_A(...)                    thread_B(...)
                        {                                {
                          int var_a;                       int var_b;
                          . . .                            . . .
                          while (true) {                   while (true) {
                            . . .                            . . .
                            var_a =...;                      var_b =...;
                            semSignal(b);                    semSignal(a);
                            semWait(a);                      semWait(b);
                              semWait(mutex);                  semWait(mutex);
                                buf_a = var_a;                   buf_b = var_b;
                              semSignal(mutex);                semSignal(mutex);
                            semSignal(b);                    semSignal(a);
                            semWait(a);                      semWait(b);
                              semWait(mutex);                  semWait(mutex);
                                var_a = buf_b;                   var_b = buf_a;
                              semSignal(mutex);                semSignal(mutex);
                            . . .;                           . . .;
                          }                                }
                        }                                }


                            Before a thread can exchange a message, it follows the same handshaking pro-
                      tocol as in the first attempt. The semaphore mutex protects buf_a and buf_b in an
                      attempt to assure that update precedes reading. But the protection is not adequate.
                      Once both threads complete the first handshaking stage, the values of semaphores a
                      and b are both 1. There are three possibilities that could occur:

                         1. Two threads, say A1 and B1, complete the first handshaking and continue with
                            the second stage of the exchange.
                         2. Another pair of threads starts the first stage.
                         3. One of the current pair will continue and exchange a message with a newcomer
                            in the other pair.




Z01_STAL4290_09_GE_APPA.indd 4                                                                               4/13/17 11:22 AM

<!-- pág. 738 -->

                                                      A.1 / RACE CONDITIONS AND SEMAPHORES   A-5

                           All of these possibilities can lead to race conditions. As an example of a race
                      condition based on the third possibility, consider the following sequence:

                              Thread A1                     Thread A2                     Thread B1
                        semSignal(b)
                        semWait(a)
                                                                                  semSignal(a)
                                                                                  semWait(b)
                        buf_a = var_a1
                                                                                  buf_b = var_b1
                                                    semSignal(b)
                                                    semWait(a)
                                                                                  semSignal(a)
                                                                                  semWait(b)
                                                    buf_a = var_a2

                            In this example, after A1 and B1 go through the first handshake, they both update
                      the corresponding global buffers. Then A2 initiates the first handshaking stage. Follow-
                      ing this, B1 initiates the second handshaking stage. At this point, A2 updates buf_a
                      before B1 can retrieve the value placed in buf_a by A1. This is a race condition.
                            Lesson Learned: Protecting a single variable may be insufficient if the use of that
                      variable is part of a long execution sequence. Protect the whole execution sequence.

                      Third Attempt
                      For this attempt, we want to expand the critical section to include the entire message
                      exchange (two threads each update one of two buffers and read from the other buf-
                      fer). A single semaphore is insufficient because this could lead to deadlock, with each
                      side waiting on the other. The program is as follows:

                        semaphore aready = 1, adone = 0, bready = 1 bdone = 0;
                        int buf_a, buf_b;
                        thread_A(...)                       thread_B(...)
                        {                                   {
                          int var_a;                          int var_b;
                          ...                                 ...
                          while (true) {                      while (true) {
                            . . .                               . . .
                            var_a =...;                         var_b =...;
                            semWait(aready);                    semWait(bready);
                              buf_a = var_a;                      buf_b = var_b;
                              semSignal(adone);                   semSignal(bdone);
                              semWait(bdone);                     semWait(adone);
                              var_a = buf_b;                      var_b = buf_a;
                            semSignal(aready);                  semSignal(bready);
                            . . .;                              . . .;
                          }                                   }
                        }                                   }




Z01_STAL4290_09_GE_APPA.indd 5                                                                                 4/13/17 11:22 AM

<!-- pág. 739 -->

            A-6   APPENDIX A / Topics in Concurrency
                           The semaphore aready is intended to insure that no other thread in A can
                      update buf_a while one thread from A enters its critical section. The semaphore
                      adone is intended to insure that no thread from B will attempt to read buf_a until
                      buf_a has been updated. The same considerations apply to bready and bdone.
                      However, this scheme does not prevent race conditions. Consider the following
                      sequence:


                                        Thread A1                             Thread B1
                                 buf_a = var_a
                                 semSignal(adone)
                                 semWait(bdone)
                                                                    buf_b = var_b
                                                                    semSignal(bdone)
                                                                    semWait(adone)
                                 var_a = buf_b;
                                 semSignal(aready)
                                 ...loop back...
                                 semWait(aready)
                                 buf_a = var_a
                                                                    var_b = buf_a


                            In this sequence, both A1 and B1 enter their critical sections, deposit their mes-
                      sages, and reach the second wait. Then A1 copies the message from B1 and leaves its
                      critical section. At this point, A1 could loop back in its program, generate a new
                      message, and deposit it in buf_a, as shown in the preceding execution sequence.
                      Another possibility is that at this same point, another thread of A could generate a
                      message and put it in buf_a. In either case, a message is lost and a race condition
                      occurs.
                            Lesson Learned: If we have a number of cooperating thread groups, mutual
                      exclusion guaranteed for one group may not prevent interference from threads
                      in other groups. Further, if a critical section is repeatedly entered by one thread,
                      then the timing of the cooperation between threads must be managed
                      properly.


                      Fourth Attempt
                      The third attempt fails to force a thread to remain in its critical section until the other
                      thread retrieves the message. Here is an attempt to achieve this objective:




Z01_STAL4290_09_GE_APPA.indd 6                                                                                      4/13/17 11:22 AM

<!-- pág. 740 -->

                                                      A.1 / RACE CONDITIONS AND SEMAPHORES   A-7

                                 semaphore aready = 1, adone = 0, bready = 1 bdone = 0;
                                 int buf_a, buf_b;
                                 thread_A(...)                    thread_B(...)
                                 {                                {
                                   int var_a;                       int var_b;
                                   ...                              ...
                                   while (true) {                   while (true) {
                                     . . .                            . . .
                                     var_a =...;                      var_b =...;
                                     semWait(bready);                 semWait(aready);
                                       buf_a = var_a;                   buf_b = var_b;
                                       semSignal(adone);                semSignal(bdone);
                                       semWait(bdone);                  semWait(adone);
                                       var_a = buf_b;                   var_b = buf_a;
                                     semSignal(aready);               semSignal(bready);
                                     . . .;                           . . .;
                                   }                                }
                                 }                                }


                            In this case, the first thread in A to enter its critical section decrements bready
                      to 0. No subsequent thread from A can attempt a message exchange until a thread
                      from B completes the message exchange and increments bready to 1. This approach
                      too can lead to race conditions, such as in the following sequence:


                                  Thread A1                Thread A2                  Thread B1
                             semWait(bready)
                             buf_a = var_a1
                             semSignal(adone)
                                                                               semWait(aready)
                                                                               buf_b = var_b1
                                                                               semSignal(bdone)
                                                                               semWait(adone)
                                                                               var_b = buf_a
                                                                               semSignal(bready)
                                                     semWait(bready)
                                                     ...
                                                     semWait(bdone)
                                                     var_a2 = buf_b


                           In this sequence, threads A1 and B1 enter corresponding critical sections in
                      order to exchange messages. Thread B1 retrieves its message and signals bready.
                      This enables another thread from A, A2, to enter its critical section. If A2 is faster
                      than A1, then A2 may retrieve the message that was intended for A1.




Z01_STAL4290_09_GE_APPA.indd 7                                                                                4/13/17 11:22 AM

<!-- pág. 741 -->

            A-8   APPENDIX A / Topics in Concurrency
                           Lesson Learned: If the semaphore for mutual exclusion is not released by its
                      owner, race conditions can occur. In this fourth attempt, a semaphore is locked by a
                      thread in A and then unlocked by a thread in B. This is risky programming practice.

                      A Good Attempt
                      The reader may notice the problem in this section is a variation of the bounded-buffer
                      problem and can be approached in a manner similar to the discussion in ­Section 5.4.
                      The most straightforward approach is to use two buffers, one for B-to-A messages
                      and one for A-to-B messages. The size of each buffer needs to be one. To see the
                      reason for this, consider that there is no ordering assumption for releasing threads
                      from a synchronization primitive. If a buffer has more than one slot, then we cannot
                      guarantee that the messages will be properly matched. For example, B1 could receive
                      a message from A1 then send a message to A1. But if the buffer has multiple slots,
                      another thread in A may retrieve the message from the slot intended for A1.
                            Using the same basic approach as was used in Section 5.4, we can develop the
                      following program:

                           semaphore notFull_A = 1, notFull_B = 1;
                           semaphore notEmpty_A = 0, notEmpty_B = 0;
                           int buf_a, buf_b;
                           thread A(...)                      thread_B(...)
                           {                                  {
                             int var_a;                         int var_b;
                             ...                                ...
                             while (true) {                     while (true) {
                               . . .                              . . .
                               var_a =...;                        var_b =...;
                               semWait(notFull_A);                semWait(notFull_B);
                                 buf_a = var_a;                     buf_b = var_b;
                                 semSignal(notEmpty_A);             semSignal(notEmpty_B);
                               semWait(notEmpty_B);               semWait(notEmpty_A);
                                 var_a = buf_b;                     var_b = buf_a;
                                 semSignal(notFull_B);              semSignal(notFull_A);
                               . . .;                             . . .;
                             }                                  }
                           }                                  }


                             To verify that this solution works, we need to address three issues:
                         1. The message exchange section is mutually exclusive within the thread group.
                            Because the initial value of notFull_A is 1, only one thread in A can pass
                            through semWait(notFull_A) until the exchange is complete as signaled by
                            a thread in B that executes semSignal(notFull_A). A similar reasoning
                            applies to threads in B. Thus, this condition is satisfied.
                         2. Once two threads enter their critical sections, they exchange messages without
                            interference from any other threads. No other thread in A can enter its critical




Z01_STAL4290_09_GE_APPA.indd 8                                                                               4/13/17 11:22 AM

<!-- pág. 742 -->

                                                                              A.2 / A BARBERSHOP PROBLEM   A-9

                             section until the thread in B is completely done with the exchange, and no other
                             thread in B can enter its critical section until the thread in A is completely done
                             with the exchange. Thus, this condition is satisfied.
                          3. After one thread exits its critical section, no thread in the same group can rush
                             in and ruin the existing message. This condition is satisfied because a one-slot
                             buffer is used in each direction. Once a thread in A has executed
                             semWait(notFull_A) and entered its critical section, no other thread in A
                             can update buf_a until the corresponding thread in B has retrieved the value
                             in buf_a and issued a semSignal(notFull_A).
                           Lesson Learned: It is well to review the solutions to well-known problems,
                      because a correct solution to the problem at hand may be a variation of a solution to
                      a known problem.


               A.2 A BARBERSHOP PROBLEM

                      As another example of the use of semaphores to implement concurrency, we consider
                      a simple barbershop problem.2 This example is instructive because the problems
                      encountered when attempting to provide tailored access to barbershop resources are
                      similar to those encountered in a real operating system.
                            Our barbershop has three chairs, three barbers, and a waiting area that can accom-
                      modate four customers on a sofa and that has standing room for additional customers
                      (see Figure A.1). Fire codes limit the total number of customers in the shop to 20. In
                      this example, we assume the barbershop will eventually process 50 customers.




                                                              Barber chairs



                                                                                              Cashier
                                 Entrance




                                                Standing                                                    Exit
                                                 room
                                                  area
                                                                              Sofa

                                 Figure A.1 The Barbershop


                      2
                      I am indebted to Professor Ralph Hilzer of California State University at Chico for supplying this treat-
                      ment of the problem.




Z01_STAL4290_09_GE_APPA.indd 9                                                                                                    4/13/17 11:22 AM

<!-- pág. 743 -->

            A-10   APPENDIX A / Topics in Concurrency
                            A customer will not enter the shop if it is filled to capacity with other customers.
                      Once inside, the customer takes a seat on the sofa or stands if the sofa is filled. When
                      a barber is free, the customer that has been on the sofa the longest is served and, if
                      there are any standing customers, the one that has been in the shop the longest takes
                      a seat on the sofa. When a customer’s haircut is finished, any barber can accept pay-
                      ment, but because there is only one cash register, payment is accepted for one
                      ­customer at a time. The barbers divide their time among cutting hair, accepting
                       ­payment, and sleeping in their chair waiting for a customer.

                      An Unfair Barbershop
                      Figure A.2 shows an implementation using semaphores; the three procedures are
                      listed side-by-side to conserve space. We assume all semaphore queues are handled
                      with a first-in-first-out policy.
                            The main body of the program activates 50 customers, 3 barbers, and the cashier
                      process. We now consider the purpose and positioning of the various synchronization
                      operators:
                          • Shop and sofa capacity: The capacity of the shop and the capacity of the sofa
                            are governed by the semaphores max_capacity and sofa, respectively.
                            Every time a customer attempts to enter the shop, the max_capacity sema-
                            phore is decremented by 1; every time a customer leaves, the semaphore is
                            incremented. If a customer finds the shop full, then that customer's process is
                            blocked on max_capacity by the semWait function. Similarly, the sem-
                            Wait and semSignal operations surround the actions of sitting on and getting
                            up from the sofa.
                          • Barber chair capacity: There are three barber chairs, and care must be taken
                            that they are used properly. The semaphore barber_chair assures that no
                            more than three customers attempt to obtain service at a time, trying to avoid
                            the undignified occurrence of one customer sitting on the lap of another. A
                            customer will not get up from the sofa until at least one chair is free
                            [semWait(barber_chair)], and each barber signals when a customer has
                            left that barber’s chair [semSignal(barber_chair)]. Fair access to the bar-
                            ber chairs is guaranteed by the semaphore queue organization: The first cus-
                            tomer to be blocked is the first one allowed into an available chair. Note that,
                            in the customer procedure, if semWait(barber_chair) occurred after
                            semSignal(sofa), each customer would only briefly sit on the sofa then
                            stand in line at the barber chairs, creating congestion and leaving the barbers
                            with little elbow room.
                          • Ensuring customers are in barber chair: The semaphore cust_ready provides
                            a wakeup signal for a sleeping barber, indicating that a customer has just taken
                            a chair. Without this semaphore, a barber would never sleep but would begin
                            cutting hair as soon as a customer left the chair; if no new customer had grabbed
                            the seat, the barber would be cutting air.
                          • Holding customers in barber chair: Once seated, a customer remains in the
                            chair until the barber gives the signal that the haircut is complete, using the
                            semaphore finished.




Z01_STAL4290_09_GE_APPA.indd 10                                                                                4/13/17 11:22 AM

<!-- pág. 744 -->

                                                                  A.2 / A BARBERSHOP PROBLEM   A-11

                        /* program barbershop1 */
                        semaphore max_capacity = 20;
                        semaphore sofa = 4;
                        semaphore barber_chair = 3;
                        semaphore coord = 3;
                        semaphore 
                                  cust_ready = 0, finished = 0, leave_b_chair = 0, payment= 0,
                                  receipt = 0;
                        void customer ()                        void barber()
                        {                                       {
                          semWait(max_capacity);                  while (true)
                          enter_shop();                           {
                          semWait(sofa);                            semWait(cust_ready);
                          sit_on_sofa();                            semWait(coord);
                          semWait(barber_chair);                    cut_hair();
                          get_up_from_sofa();                       semSignal(coord);
                          semSignal(sofa);                          semSignal(finished);
                          sit_in_barber_chair();                    semWait(leave_b_chair);
                          semSignal(cust_ready);                    semSignal(barber_chair);
                          semWait(finished);                      }
                          leave_barber_chair();                 }
                          semSignal(leave_b_chair);
                          pay();                                void cashier()
                          semSignal(payment);                   {
                          semWait(receipt);                       while (true)
                          exit_shop();                            { semWait(payment);
                          semSignal(max_capacity)                   semWait(coord);
                        }                                           accept_pay();
                                                                    semSignal(coord);
                                                                    semSignal(receipt);
                                                                  }
                                                                }
                        void main()
                        {
                          parbegin (customer, . . . 50 times, . . . customer, barber, barber,
                                     ­barber, cashier);
                        }

                      Figure A.2 An Unfair Barbershop



                          • Limiting one customer to a barber chair: The semaphore barber_chair
                            is intended to limit the number of customers in barber chairs to three. How-
                            ever, by itself, barber_chair does not succeed in doing this. A customer
                            that fails to get the processor immediately after his barber executes
                            semSignal(finished) (i.e., one who falls into a trance or stops to chat with
                            a neighbor) may still be in the chair when the next customer is given the go
                            ahead to be seated. The semaphore leave_b_chair is intended to correct this
                            problem by restraining the barber from inviting a new customer into the chair
                            until the lingering one has announced his departure from it. In the problems at
                            the end of this chapter, we will find that even this precaution fails to stop the
                            mettlesome customer lap sittings.
                          • Paying and receiving: Naturally, we want to be careful when dealing with money.
                            The cashier wants to be assured that each customer pays before leaving the
                            shop, and the customer wants verification that payment was received (a receipt).
                            This is accomplished, in effect, by a face-to-face transfer of the money. Each




Z01_STAL4290_09_GE_APPA.indd 11                                                                             4/13/17 11:22 AM

<!-- pág. 745 -->

            A-12   APPENDIX A / Topics in Concurrency
            Table A.1 Purpose of Semaphores in Figure A.2
              Semaphore           Wait Operation                                Signal Operation
              max_capacity        Customer waits for space to enter shop.       Exiting customer signals customer waiting
                                                                                to enter.
              sofa                Customer waits for seat on sofa.              Customer leaving sofa signals customer
                                                                                waiting for sofa.
              barber_chair        Customer waits for empty barber chair.        Barber signals when that barber’s chair is
                                                                                empty.
              cust_ready          Barber waits until a customer is in the       Customer signals barber that customer is
                                  chair.                                        in the chair.
              finished            Customer waits until his haircut is           Barber signals when cutting hair of this
                                  complete.                                     customer is done.
              leave_b_chair       Barber waits until customer gets up from      Customer signals barber when customer
                                  the chair.                                    gets up from chair.
              payment             Cashier waits for a customer to pay.          Customer signals cashier that he has paid.
              receipt             Customer waits for a receipt for payment.     Cashier signals that payment has been
                                                                                accepted.
              coord               Wait for a barber resource to be free to      Signal that a barber resource is free.
                                  perform either the hair cutting or cashier-
                                  ing function.




                            customer, upon arising from a barber chair, pays, alerts the cashier that money
                            has been passed over [semSignal(payment)], then waits for a receipt
                            [semWait(receipt)]. The cashier process repeatedly takes payments: It
                            waits for a payment to be signaled, accepts the money, then signals acceptance
                            of the money. Several programming errors need to be avoided here. If
                            semSignal(payment) occurred just before the action pay, then a customer
                            could be interrupted after signaling; this would leave the cashier free to accept
                            payment even though none had been offered. An even more serious error
                            would be to reverse the positions of the semSignal(payment) and
                            semWait(receipt) lines. This would lead to deadlock because that would
                            cause all customers and the cashier to block at their respective semWait
                            operators.
                          • Coordinating barber and cashier functions: To save money, this barbershop
                            does not employ a separate cashier. Each barber is required to perform that
                            task when not cutting hair. The semaphore coord ensures that barbers perform
                            only one task at a time.

                            Table A.1 summarizes the use of each of the semaphores in the program.
                            The cashier process could be eliminated by merging the payment function into
                      the barber procedure. Each barber would sequentially cut hair and then accept
                      pay. However, with a single cash register, it is necessary to limit access to the
                      accept pay function to one barber at a time. This could be done by treating that
                      function as a critical section and guarding it with a semaphore.




Z01_STAL4290_09_GE_APPA.indd 12                                                                                              4/13/17 11:22 AM

<!-- pág. 746 -->

                                                                   A.2 / A BARBERSHOP PROBLEM   A-13

                        /* program barbershop2 */
                        semaphore max_capacity = 20;
                        semaphore sofa = 4;
                        semaphore barber_chair = 3, coord = 3;
                        semaphore mutex1 = 1, mutex2 = 1;
                        semaphore cust_ready = 0, leave_b_chair = 0, payment = 0, receipt = 0;
                        semaphore finished [50] = {0};
                        int count;
                        void customer()                     void barber()
                        {                                   {
                          int custnr;                         int b_cust;
                          semWait(max_capacity);              while (true)
                          enter_shop();                       {
                          semWait(mutex1);                      semWait(cust_ready);
                          custnr = count;                       semWait(mutex2);
                          count++;                              dequeue1(b_cust);
                          semSignal(mutex1);                    semSignal(mutex2);
                          semWait(sofa);                        semWait(coord);
                          sit_on_sofa();                        cut_hair();
                          semWait(barber_chair);                semSignal(coord);
                          get_up_from_sofa();                   semSignal(finished[b_cust]);
                          semSignal(sofa);                      semWait(leave_b_chair);
                          sit_in_barber_chair();                semSignal(barber_chair);
                          semWait(mutex2);                    }
                          enqueue1(custnr);                 }
                          semSignal(cust_ready);
                          semSignal(mutex2);                void cashier()
                          semWait(finished[custnr]);        {
                          leave_barber_chair();               while (true)
                          semSignal(leave_b_chair);           {
                          pay();                                semWait(payment);
                          semSignal(payment);                   semWait(coord);
                          semWait(receipt);                     accept_pay();
                          exit_shop();                          semSignal(coord);
                          semSignal(max_capacity)               semSignal(receipt);
                        }                                     }
                                                            }
                        void main()
                        { count := 0;
                           parbegin (
                                     customer, . . . 50 times, . . . customer, barber, barber,
                                     barber, cashier);
                        }

                      Figure A.3 A Fair Barbershop



                      A Fair Barbershop
                      Figure A.2 is a good effort, but some difficulties remain. One problem is solved in the
                      remainder of this section; others are left as exercises for the reader (see Problem A.3).
                            There is a timing problem in Figure A.2 that could lead to unfair treatment of
                      customers. Suppose three customers are currently seated in the three barber chairs.
                      In that case, the customers would most likely be blocked on semWait(finished),
                      and due to the queue organization, they would be released in the order they entered
                      the barber chair. However, what if one of the barbers is very fast or one of the cus-
                      tomers is quite bald? Releasing the first customer to enter the chair could result in a
                      situation where one customer is summarily ejected from his seat and forced to pay




Z01_STAL4290_09_GE_APPA.indd 13                                                                               4/13/17 11:22 AM

<!-- pág. 747 -->

            A-14   APPENDIX A / Topics in Concurrency
                      full price for a partial haircut while another is restrained from leaving his chair even
                      though his haircut is complete.
                            The problem is solved with more semaphores, as shown in Figure A.3. We assign
                      a unique customer number to each customer; this is equivalent to having each cus-
                      tomer take a number upon entering the shop. The semaphore mutex1 protects access
                      to the global variable count so each customer receives a unique number. The sema-
                      phore finished is redefined to be an array of 50 semaphores. Once a customer is
                      seated in a barber chair, he executes semWait(finished[custnr]) to wait on
                      his own unique semaphore; when the barber is finished with that customer, the barber
                      executes semSignal(finished[b_cust]) to release the correct customer.
                            It remains to say how a customer’s number is known to the barber. A customer
                      places his number on the queue enqueue1 just prior to signaling the barber
                      with the semaphore cust_ready. When a barber is ready to cut hair, dequeue1
                      (b_cust) removes the top customer number from queue1 and places it in the
                      barber’s local variable b_cust.


               A.3 PROBLEMS

                        A.1.      Answer the following questions relating to the fair barbershop (see Figure A.3):
                                  a. Does the code require that the barber who finishes a customer’s haircut collect that
                                     customer’s payment?
                                  b. Do barbers always use the same barber chair?
                        A.2.      A number of problems remain with the fair barbershop of Figure A.3. Modify the
                                  program to correct the following problems.
                                  a. The cashier may accept pay from one customer and release another if two or more
                                     are waiting to pay. Fortunately, once a customer presents payment, there is no way
                                     for him to un-present it, so in the end, the right amount of money ends up in the
                                     cash register. Nevertheless, it is desirable to release the right customer as soon as
                                     his payment is taken.
                                  b. The semaphore leave_b_chair supposedly prevents multiple access to a single
                                     barber chair. Unfortunately, this semaphore does not succeed in all cases. For exam-
                                     ple, suppose all three barbers have finished cutting hair and are blocked at
                                     semWait(leave_b_chair). Two of the customers are in an interrupted state
                                     just prior to leave barber chair. The third customer leaves his chair and
                                     executes semSignal (leave_b_chair). Which barber is released? Because
                                     the leave_b_chair queue is first-in-first-out, the first barber that was blocked
                                     is released. Is that the barber that was cutting the signaling customer’s hair? Maybe,
                                     but maybe not. If not, then a new customer will come along and sit on the lap of a
                                     customer that was just about to get up.
                                  c. The program requires a customer first sits on the sofa even if a barber chair is
                                     empty. Granted, this is a rather minor problem, and fixing it makes code that is
                                     already a bit messy even messier. Nevertheless, give it a try.




Z01_STAL4290_09_GE_APPA.indd 14                                                                                           4/13/17 11:22 AM

