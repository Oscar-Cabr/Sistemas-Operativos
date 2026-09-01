# T / U / V / ***  ONLINE MATERIAL APPENDED  ***

> Fuente: Operating Systems Internals and Design Principles (William Stallings) — páginas 794–799 (numeración del PDF)

<!-- pág. 794 -->

                                                                                      Index  I-27

            Structured programming (SAL), 62              calls, Linux, 116
            Subject access rights, 671                    files, 591
            Subtask structure, 480                        ISA, 71
            Sun Microsystems, 110                         mode, 158
            SunOS, 110                                    response time, 84
            Superblock object, 587                        utilization of, 74
            Superblocks, 585                            System access control list (SACL), 689
            Supervisor call, 161                        System directory, 594
            Support functions, 158                      System libraries, Android
            Suspended processes states, 143–147           bionic LibC, 121
               characteristics of, 147                    browser engine, 121
               purposes of, 148                           media framework, 121
               states of, 144–145                         openGL, 121
               swapping, 143–147                          SQL database, 121
               transitions of, 145, 146–147               surface manager, 121
            Swap, 242                                   System on a Chip (SoC), 32
            Swappable space, 308                        System operational states, 95
            Swapping process states, 143–147            System oriented, other criteria, 431
            Swap-use table entry, 408–409               System oriented, performance related
            Switching process, 160–162                        ­criteria, 431
            Symbolic links file, 581, 590               System-level context, 168
            Symmetric multiprocessor (SMP), 55–57, 93
               advantages of, 55–56                     T
               availability, 55                         Tape drives, 539
               characteristics of, 55                   Tasks, 618, 619
               definition of, 55                           aperiodic, 474
               incremental growth, 93                      deadline scheduling for, 479–483
               multicore support and, 495–497              hard real-time, 474
               organization of, 55–56                      Linux, 206–208
               OS considerations of, 98–99                 periodic, 474
               scaling, 93                                 soft real-time, 474
               threads for, 105                         Telephony manager, Android, 119
            *syms, 115                                  Temporal locality, 63
            Synchronization, 84, 94, 264–265            Terminals, 539
               design characteristics of, 264           Termination of process states, 201
               granularity, 461–463                     Thrashing, load control, 374
               improper, 84                             Thread scheduling, 467–472
               lock-free, 329                              approaches to, 467
               message passing, 263–264, 264–265           dedicated processor assignment,
               processes, 462                                 470–471
            Synchronized access, 689                       dynamic scheduling, 472
            Synchronous input/output, Windows,             gang scheduling, 467
                  545–546                                  load sharing, 467–469
            System(s)                                   Thread states, 181–183
               access control list (SACL), 689             of Microsoft Windows 36,
               access threats, 658–659                        200–201
               bus, 31                                     of Solaris, 204–205




Z05_STAL4290_09_GE_IDX.indd 27                                                                   4/13/17 11:26 AM

<!-- pág. 795 -->

            I-28  Index
            Threading granularity options, 193                batch multiprogramming, differentiating
            Threads, 87, 176–217. See also specific              between, 81
                  types of                                    Compatible Time-Sharing System
               Android, 211–215                                  (CTSS), 81
               benefits of, 180                               memory requirements of, 82
               bottom-half kernel, 494                        time sharing, 82–83
               execution state, 179                           time slicing, 81
               functionality of, 181–183                   Time-sharing user, 495
               interactive, 496                            Timeslices/timeslicing, 82–83, 160
               kernel-level (KLT), 187–188, 202            Timing comparison, 519–520
               Linux process and, management of,           TinyOS, 615–625
                  206–210                                     components of, 618–620
               MAC OS Grand Central Dispatch                  configurations for, examples of, 621–623
                  (GCD), 215–217                              goals of, 617–618
               management of, 206–210                         resource interface, 623–625
               many-to-many relationships of, 189–190         scheduler, 621
               migration, 497                                 wireless sensor networks, 616–617
               multithreaded process models, 179           Token, 661
               multithreading, 178–181, 190–195            Token bucket filter (TBF), 653–654
               objects, 198–199                            Top-half kernel threads, 494
               one-to-many relationships of, 189–190       Torvalds, Linus, 113
               operations associated with change in, 181   Trace of process, 135
               pool, 195                                   Transfer time, 518
               priorities, 498–499                         Transition of process state, 201
               process operation latencies (ms ), 187      Translation lookaside buffer (TLB), 379–383
               processes and, 177–183, 188, 202               cache operation and, 382
               processor affinity, 198                        operation of, 381
               remote procedure call (RPC) using, 182      Trap flag, 155
               single-threaded process models, 179         Traps, 118
               in single-user multiprocessing system,      Tree representation of buddy system, 353
                  180–181                                  Tree-structured file directory, 567, 568
               for SMP, 105–106                            TRIX, 189
               Solaris, and SMP management, 202–206        Turnaround time (TAT), 431, 434, 449
               states of, 181–183                          Two-handed clock algorithm, 410
               synchronization, 183                        Two-level hierarchical page table, 377
               top-half kernel, 494                        Two-level memory
               types of, 183–190                              characteristics of, 61–67
               user-level (ULT), 183–188, 202                 locality, 62–64
               Windows 36, 195                                operation of, 62
            Three-level thread structure, Solaris, 203        performance of, 46–47, 64–67
            Throughput, 431                                Two-priority categories, 446
            Tightly coupled multiprocessor system, 461     Two-state process model, 136–137
            Time, creation of, 207
            Timeliness, 561                                U
            Timers, batch systems, 77, 207                 U area, 169–170
            Time-shared (59-0) class, 493                  Unblock state, 181
            Time-sharing systems, 81–83                    Unbounded priority inversion, 486




Z05_STAL4290_09_GE_IDX.indd 28                                                                           4/13/17 11:26 AM

<!-- pág. 796 -->

                                                                                       Index  I-29

            Unbuffered input/output, 539                  input/output, structure of, 537
            Uninterruptible state, 208                    kernel, 109
            Uniprocessor                                  license for, 109
              multithreading on, 183                      memory management, 407–413
              scheduling, 425–455                         modern, 110–112
            Uniprogramming systems, 80                    process structure of, 203
            University of California at Berkeley, 525     scheduling, traditional, 452–454
            UNIX BSD (Berkeley Software                   signals of, 315
                  ­Distribution), 109                     System III, 109
            UNIX FreeBSD, 112                             System V, 109
              files, structure of, 582                    traditional, 109–110
              inodes, structure of, 582                   traditional, file access control,
              scheduling, 494–497                            678–680
            UNIX System V Release 4                       Version 34, 109
              process control of, 170–171                 Version 35, 109
              process description of, 168–170             volume structure, 584–585
              process image of, 168                     Unmarshalling, 331
              process management, 166–171               Unsafe state, resource allocation,
              process states of, 166–168                     302, 304
              process table entry of, 169               Unspanned blocking, variable-length,
              scheduling, 493                                571–572
              U area, 169–170                           Update directory operation, 566
              unbuffered input/output, 539              Updating access rights, 569
            UNIX System V Release 4 (SVR4), 110–111     User applications, Windows, 104
              buffer cache, 537–538                     User control, 475–476
              character queue, 539                      User groups class, 570
              devices, types of, 539–540                User identification (ID), 678
              dispatch queues, 493                      User interfaces, 70–71
              input/output, 537–540                     User ISA, 71
              parameters of, 408–409                    User mode, 104, 158
            UNIX systems, 108–110, 580–585. See also    User-level context, 168
                   ­specific systems                    User-level threads (ULT), 183–187
              access control lists, 678–681               advantages of, 186–187
              architecture of, 109                        and KLT, combined with, 187–188
              Berkeley Software Distribution (BSD),       occurrences of, 184, 186
                    111–112                               process states, relationship with, 185
              buffer cache, organization of, 538        User-mode processes, 104
              C implementation of, 108                    environmental subsystems, 104
              concurrency mechanisms of, 313–315          execution within, 164–165
              description of, general, 109–110            service processes, 104
              devices, types of, 539–540                  special system processes, 104
              directories, 584                            user applications, 104
              file access control, 678–680                in virtual memory, 156
              file allocation, 583–584                  User-mode scheduling (UMS), 196
              files, 580–581                            User-oriented, other criteria, 431
              history of, 108–109                       User-oriented, performance related
              inodes, 581–583                                criteria, 431




Z05_STAL4290_09_GE_IDX.indd 29                                                                     4/13/17 11:26 AM

<!-- pág. 797 -->

            I-30  Index
            User’s identity authentication, 661             monitor, 629
            User-visible registers, 153                     rapid deployment, 630
            Utilization histograms, 80                      versatility, 630
                                                            VMware ESXi, 647–649
            V                                             Virtual memory, 61, 87–88, 370–420
            Valve game software, 193–195                    addressing, 89, 413–414
            Variable, operations of, 245                    concepts of, 88
            Variable priority classes, 498                  hardware/control structures of, 371–388
            Variable-allocation replacement policy, 399     locality and, 373–374
              global scope, 400–401                         management, 63–417
              local scope, 401–405                          manager, 103, 593
            Variable-interval sampled working set           operating system software, 388–407
                  (VSWS) policy, 404–405                    paging, 373, 374–385
            Variable-length spanned, 570                    protection, sharing and, 388
            Variable-length unspanned, 571                  segmentation, 385–387
            VAX/VMS, 109                                    terminology of, 371
            Verification step of authentication, 660        user-mode processes in, 156
            Very coarse-grained parallelism, 462–463      Virtual network, 711
            View system, Android, 120                     Virtual platform, 653
            Virtual 8086 mode, 155                        Virtual private networks (VPNs), 700, 717
            Virtual addresses                             Virtual runtime, 491
              map, 417                                    Virtual servers, 652, 653
              memory management, 88                       Virtual storage
              space, 179, 371                               SAN and NAS, 710–711
            Virtual computing, 709                          storage services, 709
            Virtual interrupt flag, 155                     topologies of, 709–710
            Virtual interrupt pending, 155                Virtualization, 628
            Virtual LANs (VLANs), 717                       container virtualization, 635–642
            Virtual machine technology, 707–708             hardware-assisted virtualization, 635
            Virtual machines (VM)                           paravirtualization, 634–635
              aggregating, 630                            Virtualized resources, 623
              availability, 630                           Volume, 579, 590–592
              concepts of, 628–631                          layout, 591–592
              consolidation, 630                            master file table, 592
              container virtualization, 635–642             shadow copies, 546
              devices emulation and access control, 632     structure, UNIX, 584–585
              dynamics, 630                               VPNs. See Virtual private networks (VPNs)
              execution management, 632
              Hyper V, 650–651                            W
              hypervisors, 631–635                        Wait functions, Windows, 326–327
              input and output management, 645–647        Waitable timer object, Window, 327, 328
              Java VM, 651–652                            Waiting state, 201
              legacy hardware, 630                        Waiting time, 449
              lifecycle management, 632                   Weak semaphores, 247
              Linux VServer architecture, 652–654         Weblogic, 192
              management, 630                             Websphere, 192
              memory management, 644–645                  While loops, 262




Z05_STAL4290_09_GE_IDX.indd 30                                                                        4/13/17 11:26 AM

<!-- pág. 798 -->

                                                                                     Index  I-31

            Win 60, 104                                WRITE call, 36–37, 40
            Window manager, Android, 119               WRITE instruction, 37
            Windowing/graphics system, 103             Write policy, cache memory, 52, 53
            Windows security, 686–691                  Write_DAC access, 690
              access control scheme, 687               Write_owner access, 689
              access mask, 690
              access token, 687–688                    X
              security descriptors, 688–691            XMPP, Android, 120
            Wireless personal area networks (WPANs),
                 725, 726                              Z
            Wireless sensor networks (WSN), 616–617    ZF (zero flag), 155
            Working directories, 568                   Zombie state, 205, 208
            Working set strategy, 401                  Zombies, 167, 208




Z05_STAL4290_09_GE_IDX.indd 31                                                                 4/13/17 11:26 AM

<!-- pág. 799 -->

                               This page intentionally left blank




A01_STAL4290_09_GE_FM.indd 1                                        5/19/17 9:06 PM

