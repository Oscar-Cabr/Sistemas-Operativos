# Contents (direct linking)

> Fuente: Operating Systems Internals and Design Principles (William Stallings) — páginas 8–13 (numeración del PDF)

<!-- pág. 8 -->

            CoNTENTs
            Online Chapters and Appendices 13
            VideoNotes 15
            Preface 17
            About the Author 27


            PART 1 Background 29
            Chapter 1          Computer System Overview 29
               1.1             Basic Elements 30
               1.2             Evolution of the Microprocessor 32
               1.3             Instruction Execution 32
               1.4             Interrupts 35
               1.5             The Memory Hierarchy 46
               1.6             Cache Memory 49
               1.7             Direct Memory Access 53
               1.8             Multiprocessor and Multicore Organization 54
               1.9             Key Terms, Review Questions, and Problems 58
               1A              Performance Characteristics of Two-Level Memories 61

            Chapter 2          Operating System Overview 68
               2.1             Operating System Objectives and Functions 69
               2.2             The Evolution of Operating Systems 73
               2.3             Major Achievements 83
               2.4             Developments Leading to Modern Operating Systems 92
               2.5             Fault Tolerance 95
               2.6             Os Design Considerations for Multiprocessor and Multicore 98
               2.7             Microsoft Windows Overview 101
               2.8             Traditional Unix Systems 108
               2.9             Modern Unix Systems 110
               2.10            Linux 113
               2.11            Android 118
               2.12            Key Terms, Review Questions, and Problems 127


            Part 2 Processes 129
            Chapter 3          Process Description and Control 129
               3.1             What is a Process? 131
               3.2             Process States 133
               3.3             Process Description 148
                                                                                              7




A01_STAL4290_09_GE_FM.indd 7                                                                      5/9/17 4:40 PM

<!-- pág. 9 -->

            8  Contents
                 3.4           Process Control 157
                 3.5           Execution of the Operating System 163
                 3.6           Unix Svr4 Process Management 166
                 3.7           Summary 171
                 3.8           Key Terms, Review Questions, and Problems 171

            Chapter 4          Threads 176
               4.1             Processes and Threads 177
               4.2             Types of Threads 183
               4.3             Multicore and Multithreading 190
               4.4             Windows Process and Thread Management 195
               4.5             Solaris Thread and Smp Management 202
               4.6             Linux Process and Thread Management 206
               4.7             Android Process and Thread Management 211
               4.8             Mac OS X Grand Central Dispatch 215
               4.9             Summary 217
               4.10            Key Terms, Review Questions, and Problems 218

            Chapter 5 Concurrency: Mutual Exclusion
                      and Synchronization 223
               5.1    Mutual Exclusion: Software Approaches 226
               5.2    Principles of Concurrency 232
               5.3    Mutual Exclusion: Hardware Support 241
               5.4    Semaphores 244
               5.5    Monitors 257
               5.6    Message Passing 263
               5.7    Readers/Writers Problem 270
               5.8    Summary 274
               5.9    Key Terms, Review Questions, and Problems 275

            Chapter 6          Concurrency: Deadlock and Starvation 289
               6.1             Principles of Deadlock 290
               6.2             Deadlock Prevention 299
               6.3             Deadlock Avoidance 300
               6.4             Deadlock Detection 306
               6.5             An Integrated Deadlock Strategy 308
               6.6             Dining Philosophers Problem 309
               6.7             Unix Concurrency Mechanisms 313
               6.8             Linux Kernel Concurrency Mechanisms 315
               6.9             Solaris Thread Synchronization Primitives 324
               6.10            Windows Concurrency Mechanisms 326
               6.11            Android Interprocess Communication 330
               6.12            Summary 331
               6.13            Key Terms, Review Questions, and Problems 332




A01_STAL4290_09_GE_FM.indd 8                                                   5/9/17 4:40 PM

<!-- pág. 10 -->

                                                                                 Contents  9

            Part 3 Memory 339
            Chapter 7          Memory Management 339
               7.1             Memory Management Requirements 340
               7.2             Memory Partitioning 344
               7.3             Paging 355
               7.4             Segmentation 358
               7.5             Summary 360
               7.6             Key Terms, Review Questions, and Problems 360
               7A              Loading and Linking 363

            Chapter 8          Virtual Memory 370
               8.1             Hardware and Control Structures 371
               8.2             Operating System Software 388
               8.3             Unix and Solaris Memory Management 407
               8.4             Linux Memory Management 413
               8.5             Windows Memory Management 417
               8.6             Android Memory Management 419
               8.7             Summary 420
               8.8             Key Terms, Review Questions, and Problems 421

            PART 4 Scheduling 425
            Chapter 9          Uniprocessor Scheduling 425
               9.1             Types of Processor Scheduling 426
               9.2             Scheduling Algorithms 430
               9.3             Traditional Unix Scheduling 452
               9.4             Summary 454
               9.5             Key Terms, Review Questions, and Problems 455

            Chapter 10 Multiprocessor, Multicore, and Real-Time Scheduling 460
               10.1    Multiprocessor and Multicore Scheduling 461
               10.2    Real-Time Scheduling 474
               10.3    Linux Scheduling 489
               10.4    Unix Svr4 Scheduling 492
               10.5    Unix Freebsd Scheduling 494
               10.6    Windows Scheduling 498
               10.7    Summary 500
               10.8    Key Terms, Review Questions, and Problems 500

            Part 5 Input/Output And Files 505
            Chapter 11 I/O Management and Disk Scheduling 505
               11.1    I/O Devices 506
               11.2    Organization of the I/O Function 508
               11.3    Operating System Design Issues 511




A01_STAL4290_09_GE_FM.indd 9                                                                   5/9/17 4:40 PM

<!-- pág. 11 -->

            10  Contents
                 11.4       I/O Buffering 514
                 11.5       Disk Scheduling 517
                 11.6       Raid 524
                 11.7       Disk Cache 533
                 11.8       Unix Svr4 I/O 537
                 11.9       Linux I/O 540
                 11.10      Windows I/O 544
                 11.11      Summary 546
                 11.12      Key Terms, Review Questions, and Problems 547

            Chapter 12 File Management 550
               12.1    Overview 551
               12.2    File Organization and Access 557
               12.3    B-Trees 561
               12.4    File Directories 564
               12.5    File Sharing 569
               12.6    Record Blocking 570
               12.7    Secondary Storage Management 572
               12.8    Unix File Management 580
               12.9    Linux Virtual File System 585
               12.10 Windows File System 589
               12.11 Android File Management 594
               12.12 Summary 595
               12.13 Key Terms, Review Questions, and Problems 596

            Part 6 Embedded Systems 599
            Chapter 13 Embedded Operating Systems 599
               13.1    Embedded Systems 600
               13.2    Characteristics of Embedded Operating Systems 605
               13.3    Embedded Linux 609
               13.4    Tinyos 615
               13.5    Key Terms, Review Questions, and Problems 625

            Chapter 14 Virtual Machines 627
               14.1    Virtual Machine Concepts 628
               14.2    Hypervisors 631
               14.3    Container Virtualization 635
               14.4    Processor Issues 642
               14.5    Memory Management 644
               14.6    I/O Management 645
               14.7    Vmware Esxi 647
               14.8    Microsoft Hyper-V and Xen Variants 650
               14.9    Java Vm 651
               14.10 Linux Vserver Virtual Machine Architecture 652
               14.11 Summary 655
               14.12 Key Terms, Review Questions, and Problems 655




A01_STAL4290_09_GE_FM.indd 10                                               5/9/17 4:40 PM

<!-- pág. 12 -->

                                                                       Contents  11

            Chapter 15 Operating System Security 657
               15.1    Intruders and Malicious Software 658
               15.2    Buffer Overflow 662
               15.3    Access Control 670
               15.4    Unix Access Control 678
               15.5    Operating Systems Hardening 681
               15.6    Security Maintenance 685
               15.7    Windows Security 686
               15.8    Summary 691
               15.9    Key Terms, Review Questions, and Problems 692

            Chapter 16 Cloud and IoT Operating Systems 695
               16.1    Cloud Computing 696
               16.2    Cloud Operating Systems 704
               16.3    The Internet of Things 720
               16.4    IoT Operating Systems 724
               16.5    Key Terms and Review Questions 731

            Appendices
            Appendix A Topics in Concurrency A-1
               A.1    Race Conditions and Semaphores A-2
               A.2    A Barbershop Problem A-9
               A.3    Problems A-14

            Appendix B Programming and Operating System Projects B-1
               B.1    Semaphore Projects B-2
               B.2    File Systems Project B-3
               B.3    OS/161 B-3
               B.4    Simulations B-4
               B.5    Programming Projects B-4
               B.6    Research Projects B-6
               B.7    Reading/Report Assignments B-7
               B.8    Writing Assignments B-7
               B.9    Discussion Topics B-7
               B.10   BACI B-7

            References R-1

            Credits CL-1

            Index I-1




A01_STAL4290_09_GE_FM.indd 11                                                         5/9/17 4:40 PM

<!-- pág. 13 -->

                               This page intentionally left blank




A01_STAL4290_09_GE_FM.indd 1                                        5/19/17 9:06 PM

