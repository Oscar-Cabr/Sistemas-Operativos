# Programming Projects

> Fuente: Operating Systems Internals and Design Principles (William Stallings) — páginas 953–963 (numeración del PDF)

<!-- pág. 953 -->

            ProGraMMING ProJECT ONE
                                 DEVElopING A sHEll




                                                      PP1-1




Z06_STAL4290_09_GE_PRO1.indd 1                                4/18/17 7:26 AM

<!-- pág. 954 -->

            PP1-2   Programming Project One / Developing A Shell
                      The Shell or Command Line Interpreter is the fundamental User interface to an
                      operating system. Your first project is to write a simple shell—myshell—that has
                      the following properties:
                         1. The shell must support the following internal commands:
                               i. cd <directory>—Change the current default directory to <direc-
                                  tory>. If the <directory> argument is not present, report the current
                                  directory. If the directory does not exist, an appropriate error should be
                                  reported. This command should also change the PWD environment
                                  variable.
                              ii. clr—Clear the screen.
                            iii. dir <directory>—List the contents of directory <directory>.
                             iv. environ—List all the environment strings.
                              v. echo <comment>—Display <comment> on the display followed by a new
                                  line (multiple spaces/tabs may be reduced to a single space).
                             vi. help—Display the user manual using the more filter.
                            vii. pause—Pause operation of the shell until “Enter” is pressed.
                           viii. quit—Quit the shell.
                             ix. The shell environment should contain shell=<pathname>/myshell
                                  where <pathname>/myshell is the full path for the shell executable (not
                                  a hardwired path back to your directory, but the one from which it was
                                  executed).
                         2. All other command line input is interpreted as program invocation, which
                            should be done by the shell forking and execing the programs as its own child
                            processes. The programs should be executed with an environment that contains
                            the entry: parent=<pathname>/myshell where <pathname>/myshell
                            is as described in 1.ix above.
                         3. The shell must be able to take its command line input from a file. That is, if the
                            shell is invoked with a command line argument:

                             myshell batchfile

                            then batchfile is assumed to contain a set of command lines for the shell to
                            process. When the end-of-file is reached, the shell should exit. Obviously, if the
                            shell is invoked without a command line argument, it solicits input from the user
                            via a prompt on the display.
                         4. The shell must support I/O redirection on either or both stdin and/or stdout.
                            That is, the command line

                             programname arg1 arg2 < inputfile > outputfile

                             will execute the program programname with arguments arg1 and arg2, the
                             stdin FILE stream replaced by inputfile and the stdout FILE stream
                             replaced by outputfile.




Z06_STAL4290_09_GE_PRO1.indd 2                                                                                   4/18/17 7:26 AM

<!-- pág. 955 -->

                                                                       Project Requirements   PP1-3

                            stdout redirection should also be possible for the internal commands dir,
                            environ, echo, and help.
                                   With output redirection, if the redirection character is > then the
                            ­outputfile is created if it does not exist, and truncated if it does. If the redi-
                             rection token is >> then outputfile is created if it does not exist, and
                            appended to if it does.
                         5. The shell must support background execution of programs. An ampersand (&)
                            at the end of the command line indicates that the shell should return to the
                            command line prompt immediately after launching that program.
                         6. The command line prompt must contain the pathname of the current
                            directory.
                      Note: You can assume all command line arguments (including the redirection sym-
                      bols, <, > & >> and the background execution symbol, &) will be delimited from other
                      command line arguments by white space—one or more spaces and/or tabs (see the
                      command line in 4. above).

            		        Project Requirements

                         1. Design a simple command line shell that satisfies the above criteria and imple-
                            ment it on the specified UNIX platform.
                         2. Write a simple manual describing how to use the shell. The manual should
                            contain enough detail for a beginner to UNIX to use it. For example, you should
                            explain the concepts of I/O redirection, the program environment, and back-
                            ground program execution. The manual MUST be named readme and must be
                            a simple text document capable of being read by a standard Text Editor.
                                   For an example of the sort of depth and type of description required, you
                            should have a look at the online manuals for csh and tcsh (man csh, man
                             tcsh). These shells obviously have much more functionality than yours and
                             thus, your manuals don’t have to be quite so large.
                                   You should NOT include building instructions, included file lists, or source
                             code—we can find that out from the other files you submit. This should be an
                             Operator’s manual not a Developer’s manual.
                         3. The source code MUST be extensively commented and appropriately struc-
                            tured to allow your peers to understand and easily maintain the code. Properly
                            commented and laid out code is much easier to interpret, and it is in your inter-
                            ests to ensure the person marking your project is able to understand your
                            ­coding without having to perform mental gymnastics!
                         4. Details of submission procedures will be supplied well before the deadline.
                         5. The submission should contain only source code file(s), include file(s), a make-
                             file (all lowercase please), and the readme file (all lowercase, please). No
                             executable program should be included. The person marking your project will
                             be automatically rebuilding your shell program from the source code provided.
                             If the submitted code does not compile, it cannot be marked!




Z06_STAL4290_09_GE_PRO1.indd 3                                                                                    4/18/17 7:26 AM

<!-- pág. 956 -->

            PP1-4   Programming Project One / Developing A Shell
                         6. The makefile (all lowercase, please) MUST generate the binary file myshell
                            (all lowercase please). A sample makefile would be
                                 # Joe Citizen, s1234567 - Operating Systems Project 1
                                 # CompLab1/01 tutor: Fred Bloggs
                                 myshell: myshell.c utility.c myshell.h
                                    gcc -Wall myshell.c utility.c -o myshell
                            The program myshell is then generated by just typing make at the command
                            line prompt.
                            Note: The fourth line in the above makefile MUST begin with a tab.
                         7. In the instance shown above, the files in the submitted directory would be:
                                 makefile
                                 myshell.c
                                 utility.c
                                 myshell.h
                                 readme

            		Submission

                      A makefile is required. All files in your submission will be copied to the same
                      directory, therefore, do not include any paths in your makefile. The makefile
                      should include all dependencies that build your program. If a library is included, your
                      makefile should also build the library.
                      Do not hand in any binary or object code files. All that is required is your source
                      code, a makefile, and a readme file. Test your project by copying the source code
                      only into an empty directory then compile it by entering the command make.
                             We shall be using a shell script that copies your files to a test directory, deletes
                      any preexisting myshell, *.a, and/or *.o files, performs a make, copies a set of test
                      files to the test directory, and then exercises your shell with a standard set of test
                      scripts through stdin and command line arguments. If this sequence fails due to wrong
                      names, wrong case for names, wrong version of source code that fails to compile,
                      nonexistence of files, and so on, then the marking sequence will also stop. In this
                      instance, the only marks that can be awarded will be for the tests completed at that
                      point, and the source code and manual.

            		Required Documentation

                      Your source code will be assessed and marked as well as the readme manual. Com-
                      menting is definitely required in your source code. The user manual can be presented
                      in a format of your choice (within the limitations of being displayable by a simple
                      Text Editor). Again, the manual should contain enough detail for a beginner to UNIX
                      to use the shell. For example, you should explain the concepts of I/O redirection, the
                      program environment, and background program execution. The manual MUST be
                      named readme (all lowercase, please, and NO .txt extension).




Z06_STAL4290_09_GE_PRO1.indd 4                                                                                      4/18/17 7:26 AM

<!-- pág. 957 -->

            ProGraMMING ProJECT TWo
                                 THE HOsT DIspaTCHEr sHEll




                                                             PP2-1




Z07_STAL4290_09_GE_PRO2.indd 1                                       4/18/17 7:27 AM

<!-- pág. 958 -->

            PP2-2   Programming Project Two / The HOST Dispatcher Shell
                      The Hypothetical Operating System Testbed (HOST) is a multiprogramming system
                      with a four-level priority process dispatcher operating within the constraints of finite
                      available resources.


            		        Four-Level Priority Dispatcher

                      The dispatcher operates at four priority levels:
                         1. Real-Time processes must be run immediately on a first-come-first-served
                            (FCFS) basis, preempting any other processes running with lower priority.
                            These processes are run until completion.
                         2. Normal user processes are run on a three-level feedback dispatcher (­see Fig-
                            ure PP2.1). The basic timing quantum of the dispatcher is one second. This is also
                            the value for the time quantum of the feedback scheduler.
                      The dispatcher needs to maintain two submission queues—Real-Time and User
                      ­priority—fed from the job dispatch list. The dispatch list is examined at every
                       ­dispatcher tick and jobs that “have arrived” are transferred to the appropriate
                        ­submission queue. The submission queues are then examined; any Real-Time jobs
                         are run to completion, preempting any other jobs currently running.
                               The Real-Time priority job queue must be empty before the lower-priority
                         feedback dispatcher is reactivated. Any User priority jobs in the User job queue that
                         can run within available resources (memory and I/O devices) are transferred to the
                         appropriate priority queue. Normal operation of a feedback queue will accept all


                                                RQ0                                            Release
                                   Admit
                                                                              Processor




                                                RQ1                                            Release

                                                                              Processor




                                                RQ2                                            Release

                                                                              Processor




                                 Figure PP2.1




Z07_STAL4290_09_GE_PRO2.indd 2                                                                                   4/18/17 7:27 AM

<!-- pág. 959 -->

                                                                                     Resource Constraints   PP2-3


                                                        RRQ                                                    Release
                                 Admit
                                                                                          Processor




                                 Figure PP2.2

                                                                                              Real-Time Queue

                                  Job Dispatch List

                                                                    User Job Queue                Priority 1



                                                                                                  Priority 2
                                   Arrival time ≤ Dispatcher time


                                                                       Resources                  Priority 3
                                                                       available


                             Figure PP2.3



                      jobs at the highest-priority level and degrade the priority after each completed time
                      quantum. However, this dispatcher has the ability to accept jobs at a lower priority,
                      inserting them in the appropriate queue. This enables the dispatcher to emulate a
                      simple round-robin dispatcher (see Figure PP2.2) if all jobs are accepted at the low-
                      est priority.
                            When all “ready” higher-priority jobs have been completed, the feedback dis-
                      patcher resumes by starting or resuming the process at the head of the highest-pri-
                      ority nonempty queue. At the next tick the current job is suspended (or terminated
                      and its resources released) if there are any other jobs “ready” of an equal or higher
                      priority.
                            The logic flow should be as shown in Figure PP2.3 (and as discussed subse-
                      quently in this project assignment).


            		Resource Constraints

                      The HOST has the following resources:
                          • 2 Printers
                          • 1 Scanner
                          • 1 Modem
                          • 2 CD drives
                          • 1024 Mbytes of memory available for processes




Z07_STAL4290_09_GE_PRO2.indd 3                                                                                           4/18/17 7:27 AM

<!-- pág. 960 -->

            PP2-4   Programming Project Two / The HOST Dispatcher Shell
                            Low-priority processes can use any or all of these resources, but the HOST
                      dispatcher is notified of which resources the process will use when the process is
                      submitted. The dispatcher ensures that each requested resource is solely available to
                      that process throughout its lifetime in the “ready-to-run” dispatch queues: from the
                      initial transfer from the job queue to the Priority 1–3 queues through to process
                      completion, including intervening idle time quanta.
                            Real-Time processes will not need any I/O resources (Printer, Scanner, Modem,
                      and CD), but will obviously require memory allocation—this memory requirement
                      will always be 64 Mbytes or less for Real-Time jobs.


            		        Memory Allocation

                      For each process, a contiguous block of memory must be assigned. The memory block
                      must remain assigned to the process for the lifetime of the process.
                           Enough contiguous spare memory must be left so the Real-Time processes are
                      not blocked from execution—64 Mbytes for a running Real-Time job, leaving
                      960 Mbytes to be shared among “active” User jobs.
                           The HOST hardware MMU cannot support virtual memory, so no swapping of
                      memory to disk is possible. Neither is it a paged system.
                           Within these constraints, any suitable variable partition memory allocation
                      scheme (First Fit, Next Fit, Best Fit, Worst Fit, Buddy, and so on) may be used.


            		        Processes

                      Processes on HOST are simulated by the dispatcher creating a new process for each
                      dispatched process. This process is a generic process (supplied as process—source:
                      sigtrap.c) that can be used for any priority process. It actually runs itself at very
                      low priority, sleeping for one-second periods and displaying the following:
                         1. A message displaying the process ID when the process starts;
                         2. A regular message every second the process is executed, and;
                         3. A message when the process is Suspended, Continued, or Terminated.
                            The process will terminate of its own accord after 20 seconds if it is not termi-
                      nated by your dispatcher. The process prints out using a randomly generated color
                      scheme for each unique process, so individual “slices” of processes can be easily
                      distinguishable. Use this process rather than your own.
                            The life cycle of a process is as follows:
                         1. The process is submitted to the dispatcher input queues via an initial process
                            list that designates the arrival time, priority, processor time required (in
                            ­seconds), memory block size, and other resources requested.
                         2. A process is “ready-to-run” when it has “arrived” and all required resources are
                             available.
                         3. Any pending Real-Time jobs are submitted for execution on a FCFS basis.




Z07_STAL4290_09_GE_PRO2.indd 4                                                                                  4/18/17 7:27 AM

<!-- pág. 961 -->

                                                                                     Dispatch List   PP2-5

                         4. If enough resources and memory are available for a lower-priority User process,
                            the process is transferred to the appropriate priority queue within the feedback
                            dispatcher unit, and the remaining resource indicators (memory list and I/O
                            devices) are updated.
                         5. When a job is started (fork and exec("process",...)), the dispatcher
                            will display the job parameters (Process ID, priority, processor time remaining
                            (in seconds), memory location and block size, and resources requested) before
                            performing the exec.
                         6. A Real-Time process is allowed to run until its time has expired when the dis-
                            patcher kills it by sending a SIGINT signal to it.
                         7. A low-priority User job is allowed to run for one dispatcher tick (one second)
                            before it is suspended (SIGTSTP) or terminated (SIGINT) if its time has
                            expired. If suspended, its priority level is lowered (if possible) and it is requeued
                            on the appropriate priority queue as shown in Figures P2.1 and P2.3. To retain
                            synchronization of output between your dispatcher and the child process, your
                            dispatcher should wait for the process to respond to a SIGTSTP or SIGINT
                            signal before continuing (waitpid(p->pid, &status, WUNTRACED)). To
                            match the performance sequence indicated in the comparison of scheduling
                            policies (see Figure 9.5), the User job should not be suspended and moved to a
                            lower-priority level unless another process is waiting to be (re)started.
                         8. Provided no higher-priority Real-Time jobs are pending in the submission
                            queue, the highest-priority pending process in the feedback queues is started
                            or restarted (SIGCONT).
                         9. When a process is terminated, the resources it used are returned to the dis-
                            patcher for reallocation to further processes.
                        10. When there are no more processes in the dispatch list—the input queues and
                            the feedback queues—the dispatcher exits.


            		        Dispatch List

                      The Dispatch List is the list of processes to be processed by the dispatcher. The list
                      is contained in a text file that is specified on the command line. That is,
                                                        >hostd dispatchlist
                           Each line of the list describes one process with the following data as a “comma-
                      space” delimited list:
                              <arrival time>, <priority>, <processor time>, <mbytes>,
                              <#printers>, <#scanners>, <#modems>, <#CDs>
                      Thus,
                                              12, 0, 1, 64, 0, 0, 0, 0
                                              12, 1, 2, 128, 1, 0, 0, 1
                                              13, 3, 6, 128, 1, 0, 1, 2




Z07_STAL4290_09_GE_PRO2.indd 5                                                                                      4/18/17 7:27 AM

<!-- pág. 962 -->

            PP2-6   Programming Project Two / The HOST Dispatcher Shell
                      would indicate the following:

                        1st Job:           Arrival at time 12, priority 0 (Real-Time), requiring 1 second of
                                          ­processor time and 64 Mbytes of memory—no I/O resources required.
                        2nd Job:          Arrival at time 12, priority 1 (high-priority User job), requiring
                                          2 ­seconds of processor time, 128 Mbytes of memory, 1 printer, and
                                          1 CD drive.
                        3rd Job:          Arrival at time 13, priority 3 (lowest-priority User job), requiring
                                          6 seconds of processor time, 128 Mbytes of memory, 1 printer,
                                          1 modem, and 2 CD drives.

                            The submission text file can be of any length, containing up to 1000 jobs. It will
                      be terminated with an end-of-line followed by an end-of-file marker.
                            Dispatcher input lists to test the operation of the individual features of the
                      dispatcher are described subsequently in this project assignment. It should be noted
                      that these lists will almost certainly form the basis of tests that will be applied to
                      your dispatcher during marking. Operation as described in the exercises will be
                      expected.
                            Obviously, your submitted dispatcher will be tested with more complex combi-
                      nations as well!
                            A fully functional working example of the dispatcher will be presented during
                      the course. If in any doubt as to the manner of operation or format of output, you
                      should refer to this program to observe how your dispatcher is expected to operate.


            		        Project Requirements

                         1. Design a dispatcher that satisfies the above criteria. In a formal design
                            document,

                             a. Describe and discuss what memory allocation algorithms you could have
                                used and justify your final design choice.
                             b. Describe and discuss the structures used by the dispatcher for queueing,
                                dispatching, and allocating memory and other resources.
                             c. Describe and justify the overall structure of your program, describing the
                                various modules and major functions (descriptions of the function “inter-
                                faces” are expected).
                             d. Discuss why such a multilevel dispatching scheme would be used, comparing
                                it with schemes used by “real” operating systems. Outline shortcomings in
                                such a scheme, suggesting possible improvements. Include the memory and
                                resource allocation schemes in your discussions.
                             The formal design document is expected to have in-depth discussions, descrip-
                             tions, and arguments. The design document is to be submitted separately as a
                             physical paper document. The design document should NOT include any
                             source code.




Z07_STAL4290_09_GE_PRO2.indd 6                                                                                   4/18/17 7:27 AM

<!-- pág. 963 -->

                                                                           Submission of Code   PP2-7

                         2. Implement the dispatcher using the C language.
                         3. The source code MUST be extensively commented and appropriately struc-
                            tured to allow your peers to understand and easily maintain the code. Properly
                            commented and laid out code is much easier to interpret, and it is in your inter-
                            ests to ensure the person marking your project is able to understand your cod-
                            ing without having to perform mental gymnastics.
                         4. Details of submission procedures will be supplied well before the deadline.
                         5. The submission should contain only source code file(s), include file(s), and a
                            makefile. No executable program should be included. The marker will be
                            automatically rebuilding your program from the source code provided. If the
                            submitted code does not compile, it cannot be marked.
                         6. The makefile should generate the binary executable file hostd (all lowercase
                            please). A sample makefile would be as follows:

                                  # Joe Citizen, s1234567 - Operating Systems Project 2
                                  # CompLab1/01 tutor: Fred Bloggs
                                  hostd: hostd.c utility.c hostd.h
                                  gcc hostd.c utility.c -o hostd

                          The program hostd is then generated by typing make at the command line
                      prompt. Note: The fourth line in the above makefile MUST begin with a tab.


            		        Deliverables

                         1. Source code file(s), include file(s), and a makefile.
                         2. The design document as outlined in Project Requirements section 1 above.


            		Submission of Code

                      A makefile is required. All files will be copied to the same directory; therefore, do
                      not include any paths in your makefile. The makefile should include all dependen-
                      cies that build your program. If a library is included, your makefile should also
                      build the library.
                            Do not submit any binary or object code files. All that is required is your source
                      code and a makefile. Test your project by copying the source code only into an
                      empty directory then compile it with your makefile.
                            The marker will be using a shell script that copies your files to a test directory,
                      performs a make, then exercises your dispatcher with a standard set of test files. If
                      this sequence fails due to wrong names, wrong case for names, wrong version of
                      source code that fails to compile, nonexistence of files, etc., then the marking sequence
                      will also stop. In this instance, the only further marks that can be awarded will be for
                      the source code and design document.




Z07_STAL4290_09_GE_PRO2.indd 7                                                                                    4/18/17 7:27 AM

