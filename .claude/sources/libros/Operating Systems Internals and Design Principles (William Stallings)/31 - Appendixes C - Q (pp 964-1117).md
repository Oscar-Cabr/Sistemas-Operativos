# Appendixes C - Q

> Fuente: Operating Systems Internals and Design Principles (William Stallings) — páginas 964–1117 (numeración del PDF)

<!-- pág. 964 -->

            aPPENDIX C
                                         ToPIcs IN CoNcUrrENcy
                      C.1        Processor Registers
                                     User-Visible Registers
                                     Control and Status Registers
                      C.2        Instruction Execution For I/O Functions
                      C.3        I/O Communication Techniques
                                      Programmed I/O
                                      Interrupt-Driven I/O
                                      Direct Memory Access
                      C.4        Hardware Performance Issues For Multicore
                                     Increase in Parallelism
                                     Power Consumption
                      C.5        Reference




                                                                             C-1




Z08_STAL4290_09_GE_APPC.indd 1                                                     4/18/17 7:28 AM

<!-- pág. 965 -->

            C-2   APPENDIX C / Topics in Concurrency
                      This appendix provides additional details to supplement Chapter 1.


             	 C.1 PROCESSOR REGISTERS

                      A processor includes a set of registers that provide memory that is faster and smaller
                      than main memory. Processor registers serve two functions:
                          • User-visible registers: Enable the machine or assembly language programmer
                            to minimize main memory references by optimizing register use. For high-level
                            languages, an optimizing compiler will attempt to make intelligent choices of
                            which variables to assign to registers and which to main memory locations.
                            Some high-level languages such as C allow the programmer to suggest to the
                            compiler which variables should be held in registers.
                          • Control and status registers: Used by the processor to control the operation of
                            the processor, and by privileged OS routines to control the execution of
                            programs.
                            There is not a clean separation of registers into these two categories. For exam-
                      ple, on some processors, the program counter is user visible, but on many it is not. For
                      purposes of the following discussion, however, it is convenient to use these
                      categories.

                      User-Visible Registers
                      A user-visible register may be referenced by means of the machine language that the
                      processor executes and is generally available to all programs, including application
                      programs as well as system programs. Types of registers that are typically available
                      are data, address, and condition code registers.
                            Data registers can be assigned to a variety of functions by the programmer. In
                      some cases, they are general purpose in nature and can be used with any machine
                      instruction that performs operations on data. Often, however, there are restrictions.
                      For example, there may be dedicated registers for floating-point operations, and oth-
                      ers for integer operations.
                            Address registers contain main memory addresses of data and instructions, or
                      they contain a portion of the address that is used in the calculation of the complete
                      or effective address. These registers may themselves be general purpose, or may be
                      devoted to a particular way, or mode, of addressing memory. Examples include the
                      following:
                          • Index register: Indexed addressing is a common mode of addressing that
                            involves adding an index to a base value to get the effective address.
                          • Segment pointer: With segmented addressing, memory is divided into seg-
                            ments, which are variable-length blocks of words.1 A memory reference con-
                            sists of a reference to a particular segment and an offset within the segment;

                      1
                        There is no universal definition of the term word. In general, a word is an ordered set of bytes or bits that
                      is the normal unit in which information may be stored, transmitted, or operated on within a given computer.
                      Typically, if a processor has a fixed-length instruction set, then the instruction length equals the word length.




Z08_STAL4290_09_GE_APPC.indd 2                                                                                                            4/18/17 7:28 AM

<!-- pág. 966 -->

                                                                                C.1 / PROCESSOR REGISTERS   C-3

                            this mode of addressing is important in our discussion of memory management
                            in Chapter 7. In this mode of addressing, a register is used to hold the base
                            address (starting location) of the segment. There may be multiple registers; for
                            example, one for the OS (i.e., when OS code is executing on the processor) and
                            one for the currently executing application.
                          • Stack pointer: If there is user-visible stack2 addressing, then there is a dedicated
                            register that points to the top of the stack. This allows the use of instructions
                            that contain no address field, such as push and pop.
                            For some processors, a procedure call will result in automatic saving of all user-
                      visible registers, to be restored on return. Saving and restoring is performed by the
                      processor as part of the execution of the call and return instructions. This allows each
                      procedure to use these registers independently. On other processors, the programmer
                      must save the contents of the relevant user-visible registers prior to a procedure call,
                      by including instructions for this purpose in the program. Thus, the saving and restor-
                      ing functions may be performed in either hardware or software, depending on the
                      processor.

                      Control and Status Registers
                      A variety of processor registers are employed to control the operation of the proces-
                      sor. On most processors, most of these are not visible to the user. Some of them may
                      be accessible by machine instructions executed in what is referred to as a control or
                      kernel mode.
                            Of course, different processors will have different register organizations and use
                      different terminology. We provide here a reasonably complete list of register types,
                      with a brief description. In addition to the MAR, MBR, I/OAR, and I/OBR regis-
                      ters mentioned in Chapter 1 (see Figure 1.1), the following are essential to instruction
                      execution:
                          • Program counter (PC): Contains the address of the next instruction to be
                            fetched
                          • Instruction register (IR): Contains the instruction most recently fetched
                            All processor designs also include a register or set of registers, often known as
                      the program status word (PSW) that contains status information. The PSW typically
                      contains condition codes plus other status information, such as an interrupt enable/
                      disable bit and a kernel/user mode bit.
                            Condition codes (also referred to as flags) are bits typically set by the processor
                      hardware as the result of operations. For example, an arithmetic operation may pro-
                      duce a positive, negative, zero, or overflow result. In addition to the result itself being
                      stored in a register or memory, a condition code is also set following the execution of
                      the arithmetic instruction. The condition code may subsequently be tested as part of
                      a conditional branch operation. Condition code bits are collected into one or more
                      registers. Usually, they form part of a control register. Generally, machine instructions

                      2
                       A stack is located in main memory and is a sequential set of locations that are referenced similarly to a
                      physical stack of papers, by putting on and taking away from the top. See Appendix P for a discussion of
                      stack processing.




Z08_STAL4290_09_GE_APPC.indd 3                                                                                                     4/18/17 7:28 AM

<!-- pág. 967 -->

            C-4   APPENDIX C / Topics in Concurrency
                      allow these bits to be read by implicit reference, but they cannot be altered by explicit
                      reference because they are intended for feedback regarding the results of instruction
                      execution.
                            In processors with multiple types of interrupts, a set of interrupt registers may
                      be provided, with one pointer to each interrupt-handling routine. If a stack is used to
                      implement certain functions (e.g., procedure call), then a stack pointer is needed (see
                      Appendix 1B). Memory management hardware, discussed in Chapter 7, requires dedi-
                      cated registers. Finally, registers may be used in the control of I/O operations.
                            A number of factors go into the design of the control and status register orga-
                      nization. One key issue is OS support. Certain types of control information are of
                      specific utility to the OS. If the processor designer has a functional understanding of
                      the OS to be used, then the register organization can be designed to provide hardware
                      support for particular features such as memory protection and switching between
                      user programs.
                            Another key design decision is the allocation of control information between
                      registers and memory. It is common to dedicate the first (lowest) few hundred or
                      thousand words of memory for control purposes. The designer must decide how much
                      control information should be in more expensive, faster registers and how much in
                      less expensive, slower main memory.


               C.2 INSTRUCTION EXECUTION FOR I/O FUNCTIONS

                      This section supplements the information in Section 1.3.
                             Data can be exchanged directly between an I/O module (e.g., a disk controller)
                      and the processor. Just as the processor can initiate a read or write with memory,
                      specifying the address of a memory location, the processor can also read data from
                      or write data to an I/O module. In this latter case, the processor identifies a specific
                      device that is controlled by a particular I/O module. Thus, an instruction sequence
                      similar in form to that of Figure 1.4 could occur, with I/O instructions rather than
                      memory-referencing instructions.
                             In some cases, it is desirable to allow I/O exchanges to occur directly with main
                      memory to relieve the processor of the I/O task. In such a case, the processor grants
                      to an I/O module the authority to read from or write to memory, so the I/O-memory
                      transfer can occur without tying up the processor. During such a transfer, the I/O
                      module issues read or write commands to memory, relieving the processor of respon-
                      sibility for the exchange. This operation, known as direct memory access (DMA), is
                      examined in Section 1.7.


               C.3 I/O COMMUNICATION TECHNIQUES

                      Three techniques are possible for I/O operations:
                          • Programmed I/O
                          • Interrupt-driven I/O
                          • Direct memory access (DMA)




Z08_STAL4290_09_GE_APPC.indd 4                                                                                    4/18/17 7:28 AM

<!-- pág. 968 -->

                                                         C.3 / I/O COMMUNICATION TECHNIQUES   C-5

                      Programmed I/O
                      When the processor is executing a program and encounters an instruction relating to
                      I/O, it executes that instruction by issuing a command to the appropriate I/O module.
                      In the case of programmed I/O, the I/O module performs the requested action then
                      sets the appropriate bits in the I/O status register, but takes no further action to alert
                      the processor. In particular, it does not interrupt the processor. Thus, after the I/O
                      instruction is invoked, the processor must take some active role in determining when
                      the I/O instruction is completed. For this purpose, the processor periodically checks
                      the status of the I/O module until it finds that the operation is complete.
                             With this technique, the processor is responsible for extracting data from main
                      memory for output, and storing data in main memory for input. I/O software is writ-
                      ten in such a way that the processor executes instructions that give it direct control
                      of the I/O operation, including sensing device status, sending a read or write com-
                      mand, and transferring the data. Thus, the instruction set includes I/O instructions in
                      the following categories:
                          • Control: Used to activate an external device and tell it what to do. For example,
                            a magnetic-tape unit may be instructed to rewind or to move forward one
                            record.
                          • Status: Used to test various status conditions associated with an I/O module
                            and its peripherals.
                          • Transfer: Used to read and/or write data between processor registers and exter-
                            nal devices.
                            Figure C.1a gives an example of the use of programmed I/O to read in a block
                      of data from an external device (e.g., a record from tape) into memory. Data are read
                      in one word (e.g., 16 bits) at a time. For each word that is read in, the processor must
                      remain in a status-checking loop until it determines that the word is available in the
                      I/O module’s data register. This flowchart highlights the main disadvantage of this
                      technique: It is a time-consuming process that keeps the processor busy needlessly.

                      Interrupt-Driven I/O
                      With programmed I/O, the processor has to wait a long time for the I/O module of
                      concern to be ready for either reception or transmission of more data. The processor,
                      while waiting, must repeatedly interrogate the status of the I/O module. As a result,
                      the performance level of the entire system is severely degraded.
                            An alternative is for the processor to issue an I/O command to a module then
                      go on to do some other useful work. The I/O module will then interrupt the proces-
                      sor to request service when it is ready to exchange data with the processor. The
                      processor then executes the data transfer, as before, and resumes its former
                      processing.
                            Let us consider how this works, first from the point of view of the I/O module.
                      For input, the I/O module receives a READ command from the processor. The I/O
                      module then proceeds to read data in from an associated peripheral. Once the data
                      are in the module’s data register, the module signals an interrupt to the processor
                      over a control line. The module then waits until its data are requested by the




Z08_STAL4290_09_GE_APPC.indd 5                                                                                     4/18/17 7:28 AM

<!-- pág. 969 -->

            C-6   APPENDIX C / Topics in Concurrency

                   Issue Read                           Issue Read      CPU       I/O            Issue Read        CPU     DMA
                   command to    CPU      I/O           command to              Do something     block command            Do
                   I/O module                           I/O module              else             to I/O module            something
                                                                                                                          else

                   Read status                          Read status             Interrupt         Read status             Interrupt
                   of I/O        I/O    CPU             of I/O                                    of DMA
                                                                       I/O      CPU
                   module                               module                                    module           DMA      CPU
                Not
                ready                                                                           Next instruction
                        Check          Error               Check              Error
                        status         condition           status             condition        (c) Direct memory access
                   Ready                                Ready
                   Read word                            Read word
                   from I/O      I/O     CPU            from I/O      I/O       CPU
                   Module                               Module


                   Write word                           Write word
                                 CPU      memory                      CPU        memory
                   into memory                          into memory



              No                                   No
                        Done?                              Done?

                    Yes                                  Yes
                 Next instruction                    Next instruction
               (a) Programmed I/O                  (b) Interrupt-driven I/O

             Figure C.1 Three Techniques for Input of a Block of Data


                        processor. When the request is made, the module places its data on the data bus and
                        is then ready for another I/O operation.
                               From the processor’s point of view, the action for input is as follows. The proces-
                        sor issues a READ command. It then saves the context (e.g., program counter and
                        processor registers) of the current program, and goes off and does something else
                        (e.g., the processor may be working on several different programs at the same time).
                        At the end of each instruction cycle, the processor checks for interrupts (see Fig-
                        ure 1.7). When the interrupt from the I/O module occurs, the processor saves the
                        context of the program it is currently executing and begins to execute an interrupt-
                        handling program that processes the interrupt. In this case, the processor reads the
                        word of data from the I/O module and stores it in memory. It then restores the context
                        of the program that had issued the I/O command (or some other program) and
                        resumes execution.
                               Figure C.1b shows the use of interrupt-driven I/O for reading in a block of data.
                        Interrupt-driven I/O is more efficient than programmed I/O because it eliminates
                        needless waiting. However, interrupt-driven I/O still consumes a lot of processor time,
                        because every word of data that goes from memory to I/O module, or from I/O mod-
                        ule to memory, must pass through the processor.




Z08_STAL4290_09_GE_APPC.indd 6                                                                                                        4/18/17 7:28 AM

<!-- pág. 970 -->

                                                         C.3 / I/O COMMUNICATION TECHNIQUES   C-7

                             Almost invariably, there will be multiple I/O modules in a computer system, so
                      mechanisms are needed to enable the processor to determine which device caused
                      the interrupt and to decide, in the case of multiple interrupts, which one to handle
                      first. In some systems, there are multiple interrupt lines, so that each I/O module
                      signals on a different line. Each line will have a different priority. Alternatively, there
                      can be a single interrupt line, but additional lines are used to hold a device address.
                      Again, different devices are assigned different priorities.


                      Direct Memory Access (DMA)
                      Interrupt-driven I/O, though more efficient than simple programmed I/O, still requires
                      the active intervention of the processor to transfer data between memory and an I/O
                      module, and any data transfer must traverse a path through the processor. Thus, both
                      of these forms of I/O suffer from two inherent drawbacks:
                         1. The I/O transfer rate is limited by the speed with which the processor can test
                            and service a device.
                         2. The processor is tied up in managing an I/O transfer; a number of instructions
                            must be executed for each I/O transfer.
                            When large volumes of data are to be moved, a more efficient technique is
                      required: direct memory access (DMA). The DMA function can be performed by a
                      separate module on the system bus or it can be incorporated into an I/O module. In
                      either case, the technique works as follows. When the processor wishes to read or
                      write a block of data, it issues a command to the DMA module, by sending the fol-
                      lowing information to the DMA module:
                          • Whether a read or write is requested
                          • The address of the I/O device involved
                          • The starting location in memory to read data from or write data to
                          • The number of words to be read or written
                            The processor then continues with other work. It has delegated this I/O opera-
                      tion to the DMA module, and that module will take care of it. The DMA module
                      transfers the entire block of data, one word at a time, directly to or from memory
                      without going through the processor. When the transfer is complete, the DMA mod-
                      ule sends an interrupt signal to the processor. Thus the processor is involved only at
                      the beginning and end of the transfer (see Figure C.1c).
                            The DMA module needs to take control of the bus to transfer data to and from
                      memory. Because of this competition for bus usage, there may be times when the
                      processor needs the bus and must wait for the DMA module. Note this is not an
                      interrupt; the processor does not save a context and do something else. Rather, the
                      processor pauses for one bus cycle (the time it takes to transfer one word across the
                      bus). The overall effect is to cause the processor to execute more slowly during a
                      DMA transfer when processor access to the bus is required. Nevertheless, for a mul-
                      tiple-word I/O transfer, DMA is far more efficient than interrupt-driven or pro-
                      grammed I/O.




Z08_STAL4290_09_GE_APPC.indd 7                                                                                      4/18/17 7:28 AM

<!-- pág. 971 -->

            C-8   APPENDIX C / Topics in Concurrency

               C.4 HARDWARE PERFORMANCE ISSUES FOR MULTICORE

                      Microprocessor systems have experienced a steady, exponential increase in execution
                      performance for decades. This increase is due partly to refinements in the organiza-
                      tion of the processor on the chip, and partly to the increase in the clock frequency.

                      Increase in Parallelism
                      The organizational changes in processor design have primarily been focused on
                      increasing instruction-level parallelism, so more work could be done in each clock
                      cycle. These changes include, in chronological order (see Figure C.2):


                                                                                                              Issue logic
                                                        Program counter                                                 Single-thread register file
                                                      Instruction fetch unit                                           Execution units and queues

                                                       L1 instruction cache                                                       L1 data cache

                                                                                                               L2 cache

                                                                                                            (a) Superscalar


                                                                                                              Issue logic



                                                                                                                     Register 1                               Registers n
                                       PC 1                                                                   PC n

                                                      Instruction fetch unit                                                Execution units and queues

                                                       L1 instruction cache                                                       L1 data cache

                                                                                                               L2 cache

                                                                                     (b) Simultaneous multithreading




                                              Core 1                 Core 2                 Core 3                                                       Core n



                                       (superscalar or SMT)   (superscalar or SMT)   (superscalar or SMT)                                         (superscalar or SMT)


                                       L1-I                   L1-I                    L1-I                                                        L1-I
                                       L1-D                   L1-D                    L1-D                                                        L1-D

                                                                                                               L2 cache

                                                                                                            (c) Multicore

                                     Figure C.2 Alternative Chip Organizations




Z08_STAL4290_09_GE_APPC.indd 8                                                                                                                                              4/18/17 7:28 AM

<!-- pág. 972 -->

                                      C.4 / HARDWARE PERFORMANCE ISSUES FOR MULTICORE   C-9

                          • Pipelining: Individual instructions are executed through a pipeline of stages so
                            while one instruction is executing in one stage of the pipeline, another instruc-
                            tion is executing in another stage of the pipeline.
                          • Superscalar: Multiple pipelines are constructed by replicating execution
                            resources. This enables parallel execution of instructions in parallel pipelines,
                            so long as hazards are avoided.
                          • Simultaneous multithreading (SMT): Register banks are replicated so multiple
                            threads can share the use of pipeline resources.
                             For each of these innovations, designers have over the years attempted to
                      increase the performance of the system by adding complexity. In the case of pipelin-
                      ing, simple three-stage pipelines were replaced by pipelines with five stages, then
                      many more stages, with some implementations having over a dozen stages. There is
                      a practical limit to how far this trend can be taken, because with more stages, there
                      is the need for more logic, more interconnections, and more control signals. With
                      superscalar organization, performance increases can be achieved by increasing the
                      number of parallel pipelines. Again, there are diminishing returns as the number of
                      pipelines increases. More logic is required to manage hazards and to stage instruction
                      resources. Eventually, a single thread of execution reaches the point where hazards
                      and resource dependencies prevent the full use of the multiple pipelines available.
                      This same point of diminishing returns is reached with SMT, as the complexity of
                      managing multiple threads over a set of pipelines limits the number of threads and
                      number of pipelines that can be effectively utilized.
                             There is a related set of problems dealing with the design and fabrication of the
                      computer chip. The increase in complexity to deal with all of the logical issues related
                      to very long pipelines, multiple superscalar pipelines, and multiple SMT register
                      banks means that increasing amounts of the chip area is occupied with coordinating
                      and signal transfer logic. This increases the difficulty of designing, fabricating, and
                      debugging the chips. The increasingly difficult engineering challenge related to pro-
                      cessor logic is one of the reasons that an increasing fraction of the processor chip is
                      devoted to the simpler memory logic. Power issues, discussed next, provide another
                      reason.

                      Power Consumption
                      To maintain the trend of higher performance as the number of transistors per chip
                      rise, designers have resorted to more elaborate processor designs (pipelining, super-
                      scalar, and SMT) and to high clock frequencies. Unfortunately, power requirements
                      have grown exponentially as chip density and clock frequency have risen.
                             One way to control power density is to use more of the chip area for cache
                      memory. Memory transistors are smaller and have a power density an order of mag-
                      nitude lower than that of logic (see Figure C.3). The percentage of the chip area
                      devoted to memory has grown to exceed 50% as the chip transistor density has
                      increased.
                             How to use all those logic transistors is a key design issue. As discussed earlier
                      in this section, there are limits to the effective use of such techniques as superscalar
                      and SMT. In general terms, the experience of recent decades has been encapsulated




Z08_STAL4290_09_GE_APPC.indd 9                                                                                    4/18/17 7:28 AM

<!-- pág. 973 -->

            C-10   APPENDIX C / Topics in Concurrency

                                         Power density
                                          (watts/cm2)
                                            100

                                                           logic




                                             10

                                                           memory




                                              1
                                                  0.25             0.18          0.13    0.10
                                                                     Feature size (µm)

                                        Figure C.3       Power and Memory Considerations


                      in a rule of thumb known as Pollack’s rule [POLL99], which states that performance
                      increase is roughly proportional to square root of increase in complexity. In other
                      words, if you double the logic in a processor core, then it delivers only 40% more
                      performance. In principle, the use of multiple cores has the potential to provide near-
                      linear performance improvement with the increase in the number of cores.
                            Power considerations provide another motive for moving toward a multicore
                      organization. Because the chip has such a huge amount of cache memory, it becomes
                      unlikely that any one thread of execution can effectively use all that memory. Even
                      with SMT, you are multithreading in a relatively limited fashion and cannot therefore
                      fully exploit a gigantic cache, whereas a number of relatively independent threads or
                      processes has a greater opportunity to take full advantage of the cache memory.


               C.5 REFERENCE

                      POLL99 Pollack, F. “New Microarchitecture Challenges in the Coming Generations of
                           CMOS Process Technologies (keynote address).” Proceedings of the 32nd annual ACM/
                           IEEE International Symposium on Microarchitecture, 1999.




Z08_STAL4290_09_GE_APPC.indd 10                                                                                 4/18/17 7:28 AM

<!-- pág. 974 -->

            aPPENDIX D
                                        oBJECT-orIENTED DEsIGN
                      D.1        Motivation
                      D.2        Object-Oriented Concepts
                                     Object Structure
                                     Object Classes
                                     Containment
                      D.3        Benefits of Object-Oriented Design
                      D.4        Corba
                      D.5        Recommended Reading and Website




                                                                      D-1




Z09_STAL4290_09_GE_APPD.indd 1                                              4/18/17 7:28 AM

<!-- pág. 975 -->

            D-2   APPENDIX d / Object-Oriented Design
                        Windows and several other contemporary operating systems rely heavily on object-
                        oriented design principles. This appendix provides a brief overview of the main
                        ­concepts of object-oriented design.


               D.1 MOTIVATION

                        Object-oriented concepts have become quite popular in the area of computer pro-
                        gramming, with the promise of interchangeable, reusable, easily updated, and easily
                        interconnected software parts. More recently, database designers have begun to
                        appreciate the advantages of an object orientation, with the result that object-­
                        oriented database management systems (OODBMS) are beginning to appear. Oper-
                        ating systems designers have also recognized the benefits of the object-oriented
                        approach.
                              Object-oriented programming and object-oriented database management sys-
                        tems are in fact different things, but they share one key concept: that software or data
                        can be “containerized.” Everything goes into a box, and there can be boxes within
                        boxes. In the simplest conventional program, one program step equates to one
                        instruction; in an object-oriented language, each step might be a whole boxful of
                        instructions. Similarly, with an object-oriented database, one variable, instead of
                        equating to a single data element, may equate to a whole boxful of data.
                              Table D.1 introduces some of the key terms used in object-oriented design.


            Table D.1       Key Object-Oriented Terms
              Term               Definition
              Attribute          Data variables contained within an object.
              Containment        A relationship between two object instances in which the containing object includes a
                                 pointer to the contained object.
              Encapsulation      The isolation of the attributes and services of an object instance from the external environ-
                                 ment. Services may only be invoked by name and attributes may only be accessed by means
                                 of the services.
              Inheritance        A relationship between two object classes in which the attributes and services of a parent
                                 class are acquired by a child class.
              Interface          A description closely related to an object class. An interface contains method definitions (with-
                                 out implementations) and constant values. An interface cannot be instantiated as an object.
              Message            The means by which objects interact.
              Method             A procedure that is part of an object and that can be activated from outside the object to
                                 perform certain functions.
              Object             An abstraction of a real-world entity.
              Object class       A named set of objects that share the same names, sets of attributes, and services.
              Object instance    A specific member of an object class, with values assigned to the attributes.
              Polymorphism       Refers to the existence of multiple objects that use the same names for services and present
                                 the same interface to the external world but that represent different types of entities.
              Service            A function that performs an operation on an object.




Z09_STAL4290_09_GE_APPD.indd 2                                                                                                       4/18/17 7:28 AM

<!-- pág. 976 -->

                                                                            D.2 / OBJECT-ORIENTED CONCEPTS   D-3


               D.2 OBJECT-ORIENTED CONCEPTS

                      The central concept of object-oriented design is the object. An object is a distinct
                      software unit that contains a collection of related variables (data) and methods (pro-
                      cedures). Generally, these variables and methods are not directly visible outside the
                      object. Rather, well-defined interfaces exist that allow other software to have access
                      to the data and the procedures.
                            An object represents some thing, be it a physical entity, a concept, a software
                      module, or some dynamic entity such as a TCP connection. The values of the variables
                      in the object express the information that is known about the thing that the object
                      represents. The methods include procedures whose execution affect the values in the
                      object and possibly also affect that thing being represented.
                            Figures D.1 and D.2 illustrate key object-oriented concepts.

                      Object Structure
                      The data and procedures contained in an object are generally referred to as variables
                      and methods, respectively. Everything that an object “knows” can be expressed in its
                      variables, and everything it can do is expressed in its methods.
                            The variables in an object, also called attributes, are typically simple scalars or
                      tables. Each variable has a type, possibly a set of allowable values, and may either be
                      constant or variable (by convention, the term variable is used even for constants).


                        Objects               An object knows things (called    Classes                    A group of like
                                              attributes) and does things                                  objects makes
                                              (called services).                                           up a “class.”
                                                                                  Class: Item
                                 “I am a
                                 grocery cart.”           “I am an item.”



                                                                                          • I am an object of the class “item.”
                                                                                          • I know my manufacture date and
                                                                                            my arrival date
                                                                                          • I can check my availability

                                                                                                                Classes can be
                                 “I am a sales                                                                  “specialized”
                                 transaction.”       “I am a customer.”           Class: Perishable Item




                                                                                           • I am a perishable item.
                                                                                           • I know my manufacture date,
                                                                                             arrival date, and expiration date
                                                                                           • I can check my availability


                     Figure D.1       Objects




Z09_STAL4290_09_GE_APPD.indd 3                                                                                                    4/18/17 7:28 AM

<!-- pág. 977 -->

            D-4   APPENDIX d / Object-Oriented Design

                                   Encapsulation                                         Inheritance
                           The principle that an object                        The principle that a class can
                           should hide things from other                       extend from another previously
                           objects, limiting visibility about                  defined class. The guiding principle
                           what “I know and do.”                               is to organize the classes according
                                                                               to generalization/specialization.


                                           Data
                                        Private functions
                                                                               Generalization           Specialization
                                   (“calculate sales urgency”)
                                        Public functions
                                     (“check availability”)

                                                                               Class: Item           Class: Perishable Item
                                                                               “I am an item”        “I am a perishable item”




                                                                 Polymorphism
                                                        The principle that objects in
                                                        different classes may understand
                                                        the same message yet respond in
                                                        different ways.


                                                                  Check Availability




                                                       “I do it my way.”         “I do it my way.”


                      Figure D.2     Object Concepts


                      Access restrictions may also be imposed on variables for certain users, classes of users,
                      or situations.
                            The methods in an object are procedures that can be triggered from outside to
                      perform certain functions. The method may change the state of the object, update
                      some of its variables, or act on outside resources to which the object has access.
                            Objects interact by means of messages. A message includes the name of
                      the sending object, the name of the receiving object, the name of a method in the
                      receiving object, and any parameters needed to qualify the execution of the
                      method. A ­message can only be used to invoke a method within an object. The only




Z09_STAL4290_09_GE_APPD.indd 4                                                                                                  4/18/17 7:28 AM

<!-- pág. 978 -->

                                                                D.2 / OBJECT-ORIENTED CONCEPTS   D-5

                      way to access the data inside an object is by means of the object’s methods. Thus,
                      a method may cause an action to be taken, or for the object’s variables to be
                      accessed, or both. For local objects, passing a message to an object is the same as
                      calling an object’s method. When objects are distributed, passing a message is
                      exactly what it sounds like.
                            The interface of an object is a set of public methods that the object supports.
                      An interface says nothing about implementation; objects in different classes may have
                      different implementations of the same interfaces.
                            The property of an object that its only interface with the outside world is by
                      means of messages is referred to as encapsulation. The methods and variables of an
                      object are encapsulated and available only via message-based communication.
                      Encapsulation offers two advantages:
                         1. It protects an object’s variables from corruption by other objects. This protec-
                            tion may include protection from unauthorized access and protection from the
                            types of problems that arise from concurrent access, such as deadlock and
                            inconsistent values.
                         2. It hides the internal structure of the object so that interaction with the object
                            is relatively simple and standardized. Furthermore, if the internal structure or
                            procedures of an object are modified without changing its external functionality,
                            other objects are unaffected.

                      Object Classes
                      In practice, there will typically be a number of objects representing the same types
                      of things. For example, if a process is represented by an object, then there will be one
                      object for each process present in a system. Clearly, every such object needs its own
                      set of variables. However, if the methods in the object are reentrant procedures, then
                      all similar objects could share the same methods. Furthermore, it would be inefficient
                      to redefine both methods and variables for every new but similar object.
                             The solution to these difficulties is to make a distinction between an object class
                      and an object instance. An object class is a template that defines the methods and
                      variables to be included in a particular type of object. An object instance is an actual
                      object that includes the characteristics of the class that defines it. The object contains
                      values for the variables defined in the object class. Instantiation is the process of
                      creating a new object instance for an object class.

                      Inheritance The concept of an object class is powerful because it allows for the
                      creation of many object instances with a minimum of effort. This concept is made
                      even more powerful by the use of the mechanism of inheritance [TAIV96].
                            Inheritance enables a new object class to be defined in terms of an existing class.
                      The new (lower level) class, called the subclass, or the child class, automatically
                      includes the methods and variable definitions in the original (higher-level) class,
                      called the superclass, or parent class. A subclass may differ from its superclass in a
                      number of ways:
                         1. The subclass may include additional methods and variables not found in its
                            superclass.




Z09_STAL4290_09_GE_APPD.indd 5                                                                                     4/18/17 7:28 AM

<!-- pág. 979 -->

            D-6   APPENDIX d / Object-Oriented Design

                                                                                      X
                                                                                 (superclass)




                                                 (inherits from)


                                                                                     Y
                                                           Derived part          (subclass)
                                                        (inherited from X)



                                                         Incremental part
                                                            (new code
                                                           specific to Y)


                                                Figure D.3         Inheritance

                         2. The subclass may override the definition of any method or variable in its super-
                            class by using the same name with a new definition. This provides a simple and
                            efficient way of handling special cases.
                         3. The subclass may restrict a method or variable inherited from its superclass in
                            some way.
                            Figure D.3, based on one in [KORS90], illustrates the concept.
                            The inheritance mechanism is recursive, allowing a subclass to become the
                      superclass of its own subclasses. In this way, an inheritance hierarchy may be con-
                      structed. Conceptually, we can think of the inheritance hierarchy as defining a search
                      technique for methods and variables. When an object receives a message to carry out
                      a method that is not defined in its class, it automatically searches up the hierarchy
                      until it finds the method. Similarly, if the execution of a method results in the refer-
                      ence to a variable not defined in that class, the object searches up the hierarchy for
                      the variable name.

                      Polymorphism Polymorphism is an intriguing and powerful characteristic that
                      makes it possible to hide different implementations behind a common interface. Two
                      objects that are polymorphic to each other utilize the same names for methods and
                      present the same interface to other objects. For example, there may be a number of
                      print objects for different output devices, such as printDotmatrix, printLaser,
                      printScreen, and so forth, or for different types of documents, such as
                      printText, printDrawing, and printCompound. If each such object
                      includes a method called print, then any document could be printed by sending




Z09_STAL4290_09_GE_APPD.indd 6                                                                                   4/18/17 7:28 AM

<!-- pág. 980 -->

                                                               D.2 / OBJECT-ORIENTED CONCEPTS   D-7

                      the message print to the appropriate object, without concern for how that method
                      is actually carried out. Typically, polymorphism is used to allow you have the same
                      method in multiple subclasses of the same superclass, each with a different detailed
                      implementation.
                            It is instructive to compare polymorphism to the usual modular programming
                      techniques. An objective of top-down modular design is to design lower-level mod-
                      ules of general utility with a fixed interface to higher-level modules. This allows the
                      one lower-level module to be invoked by many different higher-level modules. If the
                      internals of the lower-level module are changed without changing its interface, then
                      none of the upper-level modules that use it are affected. By contrast, with polymor-
                      phism, we are concerned with the ability of one higher-level object to invoke many
                      different lower-level objects using the same message format to accomplish similar
                      functions. With polymorphism, new lower-level objects can be added with minimal
                      changes to existing objects.

                      Interfaces Inheritance enables a subclass object to use functionality of a
                      superclass. There may be cases when you wish to define a subclass that has
                      functionality of more than one superclass. This could be accomplished by allowing a
                      subclass to inherit from more than one superclass. C + + is one language that allows
                      such multiple inheritance. However, for simplicity, most modern object-oriented
                      languages including Java, C\#, and Visual Basic .NET limit a class to inheriting from
                      only one superclass. Instead, a feature known as interfaces is used to enable a class to
                      borrow some functionality from one class and other functionality from a completely
                      different class.
                             Unfortunately, the term interface is used in much of the literature on objects
                      with both a general-purpose and a specific functional meaning. An interface, as we
                      are discussing it here, specifies an application-programming interface (API) for cer-
                      tain functionality. It does not define any implementation for that API. The syntax for
                      an interface definition typically looks similar to a class definition, except that there
                      is no code defined for the methods, just the method names, the arguments passed,
                      and the type of the value returned. An interface may be implemented by a class. This
                      works in much the same way that inheritance works. If a class implements an inter-
                      face, it must have the properties and methods of the interface defined in the class.
                      The methods that are implemented can be coded in any fashion, so long as the name,
                      arguments, and return type of each method from the interface are identical to the
                      definition in the interface.

                      Containment
                      Object instances that contain other objects are called composite objects. Contain-
                      ment may be achieved by including the pointer to one object as a value in another
                      object. The advantage of composite objects is that they permit the representation of
                      complex structures. For example, an object contained in a composite object may itself
                      be a composite object.
                            Typically, the structures built up from composite objects are limited to a tree
                      topology; that is, no circular references are allowed and each “child” object instance
                      may have only one “parent” object instance.




Z09_STAL4290_09_GE_APPD.indd 7                                                                                   4/18/17 7:28 AM

<!-- pág. 981 -->

            D-8   APPENDIX d / Object-Oriented Design
                            It is important to be clear about the distinction between an inheritance hierar-
                      chy of object classes, and a containment hierarchy of object instances. The two are
                      not related. The use of inheritance simply allows many different object types to be
                      defined with a minimum of efforts. The use of containment allows the construction
                      of complex data structures.


               D.3 BENEFITS OF OBJECT-ORIENTED DESIGN

                      [CAST92] lists the following benefits of object-oriented design:
                          • Better organization of inherent complexity: Through the use of inheritance,
                            related concepts, resources, and other objects can be efficiently defined. Through
                            the use of containment, arbitrary data structures, which reflect the underlying
                            task at hand, can be constructed. Object-oriented programming languages and
                            data structures enable designers to describe operating system resources and
                            functions in a way that reflects the designer’s understanding of those resources
                            and functions.
                          • Reduced development effort through reuse: Reusing object classes that have
                            been written, tested, and maintained by others reduces development, testing,
                            and maintenance time.
                          • More extensible and maintainable systems: Maintenance, including product
                            enhancements and repairs, traditionally consumes about 65% of the cost of any
                            product life cycle. Object-oriented design drives that percentage down. The use
                            of object-based software helps limit the number of potential interactions of
                            different parts of the software, ensuring changes to the implementation of a
                            class can be made with little impact on the rest of the system.
                            These benefits are driving operating system design in the direction of object-
                      oriented systems. Objects enable programmers to customize an operating system to
                      meet new requirements without disrupting system integrity. Objects also pave the
                      road to distributed computing. Because objects communicate by means of messages,
                      it matters not whether two communicating objects are on the same system or on two
                      different systems in a network. Data, functions, and threads can be dynamically
                      assigned to workstations and servers as needed. Accordingly, the object-oriented
                      approach to the design of operating systems is becoming increasingly evident in PC
                      and workstation operating systems.


               D.4 CORBA

                      As we have seen in this book, object-oriented concepts have been used to design and
                      implement operating system kernels, bringing benefits of flexibility, manageability,
                      and portability. The benefits of using object-oriented techniques extend with equal
                      or greater benefit to the realm of distributed software, including distributed operating
                      systems. The application of object-oriented techniques to the design and implementa-
                      tion of distributed software is referred to as distributed object computing (DOC).




Z09_STAL4290_09_GE_APPD.indd 8                                                                                   4/18/17 7:28 AM

<!-- pág. 982 -->

                                                                                        D.4 / CORBA   D-9

                            The motivation for DOC is the increasing difficulty in writing distributed soft-
                      ware: while computing and network hardware get smaller, faster, and cheaper, dis-
                      tributed software gets larger, slower, and more expensive to develop and maintain.
                      [SCHM97] points out that the challenge of distributed software stems from two types
                      of complexity:
                          • Inherent: Inherent complexities arise from fundamental problems of distribu-
                            tion. Chief among these are detecting and recovering from network and host
                            failures, minimizing the impact of communication latency, and determining an
                            optimal partitioning of service components and workload onto computers
                            throughout a network. In addition, concurrent programming, with issues of
                            resource locking and deadlocks, is still difficult, and distributed systems are
                            inherently concurrent.
                          • Accidental: Accidental complexities arise from limitations with tools and tech-
                            niques used to build distributed software. A common source of accidental com-
                            plexity is the widespread use of functional design, which results in nonextensible
                            and nonreusable systems.
                             DOC is a promising approach to managing both types of complexity. The cen-
                      terpiece of the DOC approach are object request brokers (ORBs), which act as inter-
                      mediaries for communication between local and remote objects. ORBs eliminate
                      some of the tedious, error-prone, and nonportable aspects of designing and imple-
                      menting distributed applications. Supplementing the ORB must be a number of con-
                      ventions and formats for message exchange and interface definition between
                      applications and the object-oriented infrastructure.
                             There are three main competing technologies in the DOC market: the object
                      management group (OMG) architecture, called Common Object Request Broker
                      Architecture (CORBA); the Java remote method invocation (RMI) system; and
                      Microsoft’s distributed component object model (DCOM). CORBA is the most
                      advanced and well-established of the three. A number of industry leaders, including
                      IBM, Sun, Netscape, and Oracle, support CORBA, and Microsoft has announced that
                      it will link its Windows-only DCOM with CORBA. The remainder of this appendix
                      provides a brief overview of CORBA.
                             Table D.2 defines some key terms used in CORBA. The main features of
                      CORBA are as follows (see Figure D.4):
                          • Clients: Clients generate requests and access object services through a variety
                            of mechanisms provided by the underlying ORB.
                          • Object implementations: These implementations provide the services requested
                            by various clients in the distributed system. One benefit of the CORBA archi-
                            tecture is that both clients and object implementations can be written in any
                            number of programming languages and can still provide the full range of
                            required services.
                          • ORB core: The ORB core is responsible for communication between objects.
                            The ORB finds an object on the network, delivers requests to the object, acti-
                            vates the object (if not already active), and returns any message back to the
                            sender. The ORB core provides access transparency because programmers use




Z09_STAL4290_09_GE_APPD.indd 9                                                                                   4/18/17 7:28 AM

<!-- pág. 983 -->

            D-10   APPENDIX d / Object-Oriented Design
            Table D.2      Key Concepts in a Distributed CORBA System
              CORBA Concept              Definition
              Client application         Invokes requests for a server to perform operations on objects. A client applica-
                                         tion uses one or more interface definitions that describe the objects and opera-
                                         tions the client can request. A client application uses object references, not
                                         objects, to make requests.
              Exception                  Contains information that indicates whether a request was successfully
                                         performed.
              Implementation             Defines and contains one or more methods that do the work associated with an
                                         object operation. A server can have one or more implementations.
              Interface                  Describes how instances of an object will behave, such as what operations are
                                         valid on those objects.
              Interface definition       Describes the operations that are available on a certain type of object.
              Invocation                 The process of sending a request.
              Method                     The server code that does the work associated with an operation. Methods are
                                         contained within implementations.
              Object                     Represents a person, place, thing, or piece of software. An object can have oper-
                                         ations performed on it, such as the promote operation on an employee object.
              Object instance            An occurrence of one particular kind of object.
              Object reference           An identifier of an object instance.
              OMG Interface Definition   A definition language for defining interfaces in CORBA.
              Language (IDL)
              Operation                  The action that a client can request a server to perform on an object instance.
              Request                    A message sent between a client and a server application.
              Server application         Contains one or more implementations of objects and their operations.




                             exactly the same method with the same parameters when invoking a local
                             method or a remote method. The ORB core also provides location transpar-
                             ency: Programmers do not need to specify the location of an object.
                           • Interface: An object’s interface specifies the operations and types supported by
                             the object, and thus defines the requests that can be made on the object.
                             CORBA interfaces are similar to classes in C + + and interfaces in Java. Unlike
                             C + + classes, a CORBA interface specifies methods and their parameters and
                             return values, but is silent about their implementation. Two objects of the same
                             C + + class have the same implementation of their methods.
                           • OMG interface definition language (IDL): IDL is the language used to define
                             objects. An example IDL interface definition is:

                             //OMG IDL
                             interface Factory
                                { Object create ( ) ;
                             } ;




Z09_STAL4290_09_GE_APPD.indd 10                                                                                              4/18/17 7:28 AM

<!-- pág. 984 -->

                                                                                                       D.4 / CORBA   D-11


                                           Client                                                  Object implementation




                            Dynamic                 IDL               ORB                              IDL
                                                                                       DSI                               Object
                           invocation               stub            interface                        skeleton
                                                                                                                         adapter



                                                                            ORB core



                                  Same for all ORBs                                ORB Object request broker


                                  Interface-specific stubs and skeletons           IDL   Interface definition language


                                  May be multiple object adapters                  DSI   Dynamic skeleton interface


                                  ORB-private interface

                       Figure D.4       Common Object Request Broker Architecture



                            This definition specifies an interface named Factory that supports one opera-
                      tion, create. The create operation takes no parameters and returns an object refer-
                      ence of type Object. Given an object reference for an object of type Factory, a
                      client could invoke it to create a new CORBA object. IDL is a programming-­
                      independent language and, for this reason, a client does not invoke directly any object
                      operation. It needs a mapping to the client programming language to do that. It is
                      also possible, that the server and the client are programmed in different programming
                      languages. The use of a specification language is a way to deal with heterogeneous
                      processing across multiple languages and platform environments. Thus, IDL enables
                      platform independence.
                          • Language binding creation: IDL compilers map one OMG IDL file to different
                            programming languages, which may or may not be object oriented, such as Java,
                            Smalltalk, Ada, C, C + +, and COBOL. That mapping includes the definition of
                            the language-specific data types and procedure interfaces to access service
                            objects, the IDL client stub interface, the IDL skeleton, the object adapters, the
                            dynamic skeleton interface, and the direct ORB interface. Usually, clients have
                            a compile-time knowledge of the object interface and use client stubs to do a
                            static invocation; in certain cases, clients do not have that knowledge and they
                            must do a dynamic invocation.




Z09_STAL4290_09_GE_APPD.indd 11                                                                                                    4/18/17 7:28 AM

<!-- pág. 985 -->

            D-12   APPENDIX d / Object-Oriented Design
                          • IDL stub: Makes calls to the ORB core on behalf of a client application. IDL
                            stubs provide a set of mechanisms that abstract the ORB core functions into
                            direct RPC (remote procedure call) mechanisms that can be employed by the
                            end-client applications. These stubs make the combination of the ORB and
                            remote object implementation appear as if they were tied to the same in-line
                            process. In most cases, IDL compilers generate language-specific interface
                            libraries that complete the interface between the client and object
                            implementations.
                          • IDL skeleton: Provides the code that invokes specific server methods. Static
                            IDL skeletons are the server-side complements to the client-side IDL stubs.
                            They include the bindings between the ORB core and the object implementa-
                            tions that complete the connection between the client and object
                            implementations.
                          • Dynamic invocation: Using the dynamic invocation interface (DII), a client
                            application can invoke requests on any object without having compile-time
                            knowledge of the object’s interfaces. The interface details are filled in by con-
                            sulting with an interface repository and/or other run-time sources. The DII
                            allows a client to issue one-way commands (for which there is no response).
                          • Dynamic skeleton interface (DSI): Similar to the relationship between IDL
                            stubs and static IDL skeletons, the DSI provides dynamic dispatch to objects.
                            Equivalent to dynamic invocation on the server side.
                          • Object adapter: An object adapter is CORBA system component provided by
                            the CORBA vendor to handle general ORB-related tasks, such as activating
                            objects and activating implementations. The adapter takes these general tasks
                            and ties them to particular implementations and methods in the server.


               D.5 RECOMMENDED READING AND WEBSITE

                      [KORS90] is a good overview of object-oriented concepts. [STRO88] is a clear
                      description of object-oriented programming. An interesting perspective on object-
                      oriented concepts is provided in [SYND93]. [VINO97] is an overview of CORBA.
                      KORS90 Korson, T., and McGregor, J. “Understanding Object-Oriented: A Unifying Para-
                           digm.” Communications of the ACM, September 1990.
                      STRO88 Stroustrup, B. “What is Object-Oriented Programming?” IEEE Software, May 1988.
                      SNYD93 Snyder, A. “The Essence of Objects: Concepts and Terms.” IEEE Software, January
                           1993.
                      VINO97 Vinoski, S. “CORBA: Integrating Diverse Applications Within Distributed Hetero-
                           geneous Environments.” IEEE Communications Magazine, February 1997.

                                  Recommended Website:
                                   Object Management Group: Industry consortium that promotes CORBA
                                   and related object technologies




Z09_STAL4290_09_GE_APPD.indd 12                                                                                 4/18/17 7:28 AM

<!-- pág. 986 -->

            aPPENDIX E
                                                aMDaHl’s LaW
                      E.1        Implications of Amdahl’s Law
                      E.2        References




                                                                E-1




Z10_STAL4290_09_GE_APPE.indd 1                                        4/18/17 7:42 AM

<!-- pág. 987 -->

            E-2   APPENDIX E / Amdahl’s Law

               E.1 IMPLICATIONS OF AMDAHL’S LAW

                      When considering system performance, computer system designers look for ways to
                      improve performance by improvement in technology or change in design. Examples
                      include the use of parallel processors, the use of a memory cache hierarchy, and
                      speedup in memory access time and I/O transfer rate due to technology improve-
                      ments. In all of these cases, it is important to note that a speedup in one aspect of the
                      technology or design does not result in a corresponding improvement in performance.
                      This limitation is succinctly expressed by Amdahl’s law.
                            Amdahl’s law was first proposed by Gene Amdahl in 1967 [AMDA67] and
                      deals with the potential speedup of a program using multiple processors compared
                      to a single processor. Consider a program running on a single processor such that a
                      fraction (1 - f ) of the execution time involves code that is inherently serial, and a
                      fraction f that involves code that is infinitely parallelizable with no scheduling over-
                      head. Let T be the total execution time of the program using a single processor. Then
                      the speedup using a parallel processor with N processors that fully exploits the paral-
                      lel portion of the program is as follows:
                                                          time to execute program on a single processor
                                            Speedup =
                                                        time to execute program on N parallel processors
                                                 T(1 - f) + Tf              1
                                                    =             =
                                                               Tf                f
                                                 T(1 - f) +          (1 - f) +
                                                               N                N
                             This equation is illustrated in Figure E.1. Two important conclusions can be drawn:
                         1. When f is small, the use of parallel processors has little effect.
                         2. As N approaches infinity, speedup is bound by 1/(1 - f), so there are diminish-
                            ing returns for using more processors.

                                           20

                                                                                                    f = 0.95

                                           15




                                 Speedup   10                                                f = 0.90




                                            5                                                     f = 0.75

                                                                                                        f = 0.5


                                                1                 10                   100                        1000
                                                                  Number of Processors

                                 Figure E.1 Amdahl’s Law for Multiprocessors




Z10_STAL4290_09_GE_APPE.indd 2                                                                                           4/18/17 7:42 AM

<!-- pág. 988 -->

                                                                                  E.2 / REFERENCES   E-3

                            These conclusions are too pessimistic, an assertion first put forward in
                      [GUST88]. For example, a server can maintain multiple threads or multiple tasks to
                      handle multiple clients and execute the threads or tasks in parallel up to the limit of
                      the number of processors. Many database applications involve computations on mas-
                      sive amounts of data that can be split up into multiple parallel tasks. Nevertheless,
                      Amdahl’s law illustrates the problems facing industry in the development of multi-
                      core machines with an ever-growing number of cores: The software that runs on such
                      machines must be adapted to a highly parallel execution environment to exploit the
                      power of parallel processing.
                            Amdahl’s law can be generalized to evaluate any design or technical improve-
                      ment in a computer system. Consider any enhancement to a feature of a system that
                      results in a speedup. The speedup can be expressed as follows:
                                    Performance after enhancement   Execution time before enhancement
                      Speedup =                                   =
                                   Performance before enhancement    Execution time after enhancement
                           Suppose a feature of the system is used during execution a fraction of the time f,
                      before enhancement, and the speedup of that feature after enhancement is SUf. Then
                      the overall speedup of the system is
                                                                       1
                                                   Speedup =
                                                                             f
                                                                (1 - f) +
                                                                            SUf
                      For example, suppose a task makes extensive use of floating-point operations, with
                      40% of the time is consumed by floating-point operations. With a new hardware
                      design, the floating-point module is speeded up by a factor of K. Then, the overall
                      speedup is:
                                                                       1
                                                      Speedup =
                                                                           0.4
                                                                  0.6 +
                                                                           K
                      Thus, independent of K, the maximum speedup is 1.67.


               E.2 REFERENCES

                      AMDA67 Amdahl, G. “Validity of the Single-Processor Approach to Achieving Large-Scale
                           Computing Capability.” Proceedings, of the AFIPS Conference, 1967.
                      GUST88 Gustafson, J. “Reevaluating Amdahl’s Law.” Communications of the ACM,
                           May 1988.




Z10_STAL4290_09_GE_APPE.indd 3                                                                                  4/18/17 7:42 AM

<!-- pág. 989 -->

            aPPENDIX F
                                 Hash TaBlEs




                                               F-1




Z11_STAL4290_09_GE_APPF.indd 1                       4/18/17 7:29 AM

<!-- pág. 990 -->

            F-2   APPENDIX F / Hash Tables
                      Consider the following problem. A set of N items is to be stored in a table. Each item
                      consists of a label plus some additional information, which we can refer to as the
                      value of the item. We would like to be able to perform a number of ordinary opera-
                      tions on the table, such as insertion, deletion, and searching for a given item by label.
                            If the labels of the items are numeric, in the range 0 to M - 1, then a simple
                      solution would be to use a table of length M. An item with label i would be inserted
                      into the table at location i. As long as items are of fixed length, table lookup is trivial
                      and involves indexing into the table based on the numeric label of the item. Further-
                      more, it is not necessary to store the label of an item in the table, because this is
                      implied by the position of the item. Such a table is known as a direct access table.
                            If the labels are nonnumeric, then it is still possible to use a direct access
                      approach. Let us refer to the items as A[1], . . . A[N]. Each item A[i] consists of a
                      label, or key, ki, and a value vi. Let us define a mapping function I(k) such that I(k)
                      takes a value between 1 and M for all keys, and I(ki) ≠ I(kj) for any i and j. In this
                      case, a direct access table can also be used, with the length of the table equal to M.
                            The one difficulty with these schemes occurs if M is much greater than N. In
                      this case, the proportion of unused entries in the table is large, and this is an inefficient
                      use of memory. An alternative would be to use a table of length N and store the N
                      items (label plus value) in the N table entries. In this scheme, the amount of memory
                      is minimized, but there is now a processing burden to do table lookup. There are
                      several possibilities:
                           • Sequential search: This brute-force approach is time consuming for large tables.
                           • Associative search: With the proper hardware, all of the elements in a table can
                             be searched simultaneously. This approach is not general purpose and cannot
                             be applied to any and all tables of interest.
                           • Binary search: If the labels or the numeric mapping of the labels are arranged
                             in ascending order in the table, then a binary search is much quicker than
                             sequential (see Table F.1) and requires no special hardware.
                            The binary search looks promising for table lookup. The major drawback with
                      this method is that adding new items is not usually a simple process and will require
                      reordering of the entries. Therefore, binary search is usually used only for reasonably
                      static tables that are seldom changed.

                      Table F.1 Average Search Length for One of N items in a Table of Length M
                        Technique                                                      Search Length
                        Direct                                                                 1
                        Sequential                                                         M + 1
                                                                                             2
                        Binary                                                              log 2M
                        Linear hashing                                                     2 - NM
                                                                                          2 - 2NM

                        Hash (overflow with chaining)                                          N - 1
                                                                                         1 +
                                                                                                2M




Z11_STAL4290_09_GE_APPF.indd 2                                                                                        4/18/17 7:30 AM

<!-- pág. 991 -->

                                                                                           Hash Tables   F-3

                            We would like to avoid the memory penalties of a simple direct access approach
                      and the processing penalties of the alternatives listed previously. The most frequently
                      used method to achieve this compromise is hashing. Hashing, which was developed
                      in the 1950s, is simple to implement and has two advantages. First, it can find most
                      items with a single seek, as in direct accessing. Second, insertions and deletions can
                      be handled without added complexity.
                            The hashing function can be defined as follows. Assume up to N items are to be
                      stored in a hash table of length M, with M Ú N, but not much larger than N. To insert
                      an item in the table:

                        I1.	Convert the label of the item to a near-random number n between 0 and M - 1.
                             For example, if the label is numeric, a popular mapping function is to divide the
                             label by M and take the remainder as the value of n.
                        I2.	Use n as the index into the hash table.

                             a. If the corresponding entry in the table is empty, store the item (label and
                                value) in that entry.
                             b. If the entry is already occupied, then store the item in an overflow area, as
                                discussed subsequently.
                      To perform table lookup of an item whose label is known:
                        L1.	Convert the label of the item to a near-random number n between 0 and M - 1,
                             using the same mapping function as for insertion.
                        L2.	Use n as the index into the hash table.

                             a. If the corresponding entry in the table is empty, then the item has not previ-
                                ously been stored in the table.
                             b. If the entry is already occupied and the labels match, then the value can be
                                retrieved.
                             c. If the entry is already occupied and the labels do not match, then continue
                                the search in the overflow area.

                           Hashing schemes differ in the way in which the overflow is handled. One com-
                      mon technique is referred to as the linear hashing technique and is commonly used
                      in compilers. In this approach, rule I2.b becomes

                        I2.b.	If the entry is already occupied, set n = n + 1 (mod M) and go back to step
                               I2.a.

                      Rule L2.c is modified accordingly.
                            Figure F.1a is an example. In this case, the labels of the items to be stored are
                      numeric, and the hash table has eight positions (M = 8). The mapping function is to
                      take the remainder upon division by 8. The figure assumes the items were inserted in
                      ascending numerical order, although this is not necessary. Thus, items 50 and 51 map
                      into positions 2 and 3, respectively, and as these are empty, they are inserted there.
                      Item 74 also maps into position 2, but as it is not empty, position 3 is tried. This is also
                      occupied, so the position 4 is ultimately used.




Z11_STAL4290_09_GE_APPF.indd 3                                                                                       4/18/17 7:30 AM

<!-- pág. 992 -->

            F-4   APPENDIX F / Hash Tables

                                                                           119 value (119)   0
                                                                            —                1
                                              50                            50 value (50)    2
                                              51                            51 value (51)    3
                                              74                            74 value (74)    4
                                              83                            83 value (83)    5
                                              95                            —                6
                                              119                           95 value (95)    7


                                                                 (a) Linear rehashing


                                                              Hash Table
                                  50
                                  51                                                               Overflow Table
                                  74                     50    value (50)     •                   74 value (74) —
                                  83                     51    value (51)     •                   83 value (83) •
                                  94                                                             119 value (119) —
                                  95                                                             139 value (139 ) —
                                 119                     94    value (94) —
                                 139                     95    value (95) •


                                                              (b) Overflow with chaining
                                 Figure F.1    Hashing

                           It is not easy to determine the average length of the search for an item in an
                      open hash table because of the clustering effect. An approximate formula was
                      obtained by Schay and Spruth:1
                                                                                 2 - r
                                                     Average search length =
                                                                                2 - 2r
                      where r = N/M. Note the result is independent of table size and depends only on
                      how full the table is. The surprising result is with the table 80% full, the average length
                      of the search is still around 3.
                             Even so, a search length of 3 may be considered long, and the linear hashing table
                      has the additional problem that it is not easy to delete items. A more attractive approach,
                      which provides shorter search lengths (see Table F.1) and allows deletions as well as
                      additions, is overflow with chaining. This technique is illustrated in Figure F.1b. In this
                      case, there is a separate table into which overflow entries are inserted. This table includes
                      pointers passing down the chain of entries associated with any position in the hash table.
                      In this case, the average search length, assuming randomly distributed data, is
                                                                           N - 1
                                                    Average search length = 1 +
                                                                             2M
                      For large values of N and M, this value approaches 1.5 for N = M. Thus, this tech-
                      nique provides for compact storage with rapid lookup.

                      1
                       Schay, G., and Spruth, W. “Analysis of a File Addressing Method.” Communications of the ACM,
                      August 1962.




Z11_STAL4290_09_GE_APPF.indd 4                                                                                        4/18/17 7:30 AM

<!-- pág. 993 -->

            aPPENDIX G
                                                rEsPoNsE TIME
                      G.1        Response Time Considerations
                      G.2        References




                                                                G-1




Z12_STAL4290_09_GE_APPG.indd 1                                        4/18/17 7:30 AM

<!-- pág. 994 -->

            G-2   APPENDIX G / Response Time

               G.1 RESPONSE TIME CONSIDERATIONS

                      Response time is the time taken by a system to react to a given input. In an interactive
                      transaction, it may be defined as the time between the last keystroke by the user and
                      the beginning of the display of a result by the computer. For different types of appli-
                      cations, a slightly different definition is needed. In general, it is the time taken for the
                      system to respond to a request to perform a particular task.
                            Ideally, one would like the response time for any application to be short. How-
                      ever, it is almost invariably the case that shorter response time imposes greater cost.
                      This cost comes from two sources:
                          • Computer processing power: The faster the processor is, the shorter the
                            response time will be. Of course, increased processing power means increased
                            cost.
                          • Competing requirements: Providing rapid response time to some processes may
                            penalize other processes.
                      Thus the value of a given level of response time must be assessed versus the cost of
                      achieving that response time.
                            Table G.1, from [MART88] lists six general ranges of response times. Design
                      difficulties are faced when a response time of less than 1 second is required. A require-
                      ment for a sub-second response time is generated by a system that controls or in some
                      other way interacts with an ongoing external activity, such as an assembly line. Here
                      the requirement is straightforward. When we consider human-computer interaction,
                      such as in a data entry application, then we are in the realm of conversational response
                      time. In this case, there is still a requirement for a short response time, but the accept-
                      able length of time may be difficult to assess.
                            That rapid response time is the key to productivity in interactive applications
                      has been confirmed in a number of studies [SHNE84; THAD81; GUYN88]. These
                      studies show that when a computer and a user interact at a pace that ensures neither
                      has to wait on the other, productivity increases significantly, the cost of the work
                      done on the computer therefore drops, and quality tends to improve. It used to be
                      widely accepted that a relatively slow response, up to 2 seconds, was acceptable for
                      most interactive applications because the person was thinking about the next task.
                      However, it now appears that productivity increases as rapid response times are
                      achieved.
                            The results reported on response time are based on an analysis of online trans-
                      actions. A transaction consists of a user command from a terminal and the system’s
                      reply. It is the fundamental unit of work for online system users. It can be divided into
                      two time sequences:
                          • User response time: The time span between the moment the user receives a
                            complete reply to one command and enters the next command. People often
                            refer to this as think time.
                          • System response time: The time span between the moment the user enters a
                            command and the moment a complete response is displayed on the terminal.




Z12_STAL4290_09_GE_APPG.indd 2                                                                                       4/18/17 7:30 AM

<!-- pág. 995 -->

                                                                   G.1 / RESPONSE TIME CONSIDERATIONS   G-3

            Table G.1     Response Time Ranges
              Greater than 15 seconds
              This rules out a conversational interaction. For certain types of applications, certain types of users may be
              ­content to sit at a terminal for more than 15 seconds waiting for the answer to a single simple inquiry. However,
               for a busy person, captivity for more than 15 seconds seems intolerable. If such delays will occur, the system
               should be designed so the user can turn to other activities and request the response at some later time.
              Greater than 4 seconds
              These are generally too long for a conversation requiring the operator to retain information in short-term
              memory (the operator’s memory, not the computer’s!). Such delays would be very inhibiting in problem-­
              solving activity and frustrating in data entry activity. However, after a major closure, such as the end of a
              ­transaction, delays from 4 to 15 seconds can be tolerated.
              2 to 4 seconds
              A delay longer than 2 seconds can be inhibiting to terminal operations demanding a high level of concentra-
              tion. A wait of 2–4 seconds at a terminal can seem surprisingly long when the user is absorbed and emotionally
              committed to complete what he or she is doing. Again, a delay in this range may be acceptable after a minor
              closure has occurred.
              Less than 2 seconds
              When the terminal user has to remember information throughout several responses, the response time must
              be short. The more detailed the information remembered, the greater the need for responses of less than 2 sec-
              onds. For elaborate terminal activities, 2 seconds represents an important response-time limit.
              Sub-second response time
              Certain types of thought-intensive work, especially with graphics applications, require very short response
              times to maintain the user’s interest and attention for long periods of time.
              Decisecond response time
              A response to pressing a key and seeing the character displayed on the screen or clicking a screen object with
              a mouse needs to be almost instantaneous—less than 0.1 second after the action. Interaction with a mouse
              requires extremely fast interaction if the designer is to avoid the use of alien syntax (one with commands,
              ­mnemonics, punctuation, etc.).




                            As an example of the effect of reduced system response time, Figure G.1 shows
                      the results of a study carried out on engineers using a computer-aided design graphics
                      program for the design of integrated circuit chips and boards [SMIT83]. Each transac-
                      tion consists of a command by the engineer that in some way alters the graphic image
                      being displayed on the screen. The results show that the rate of transactions increases
                      as system response time falls and rises dramatically once system response time falls
                      below 1 second. What is happening is that as the system response time falls, so does
                      the user response time. This has to do with the effects of short-term memory and
                      human attention span.
                            Another area where response time has become critical is the use of the World
                      Wide Web, either over the Internet or over a corporate intranet. The time taken for
                      a typical Web page to come up on the user’s screen varies greatly. Response times can
                      be gauged based on the level of user involvement in the session; in particular, systems
                      with vary fast response times tend to command more user attention. In a study by
                      Sevcik [SEVC96, SEVC02], illustrated in Figure G.2, Web systems with a 3-second or




Z12_STAL4290_09_GE_APPG.indd 3                                                                                                     4/18/17 7:30 AM

<!-- pág. 996 -->

            G-4   APPENDIX G / Response Time

                                                         4000
                                                                                                                                                Expert
                                                         3500
                                                                                                                                                Average
                                                         3000                                                                                   Novice




                            Transactions per user-hour
                                                         2500

                                                         2000

                                                         1500

                                                         1000

                                                          500

                                                               0
                                                              0.25                         0.50           0.75           1.00            1.25             1.50
                                                                                                        System response time (seconds)

                            Figure G.1                                        Response Time Results for High-Function Graphics



                                                                               Full
                                                                               Fast
                                                          Web User
                                                                                           Some
                                                                                          Medium

                                                         Concentration
                                                                                                            Little interaction
                                                                                                                   Slow

                                                                              Changing TV channels on cable service

                                                                              Cross USA telephone call connect time


                                                             Other            Point-of-sale credit card verification


                                                         Response Times
                                                                              Making a 28.8-kbps modem connection

                                                                              Executing a trade on the NY stock exchange


                                                                          0           3               10                                            30
                                                                                                             Time (seconds)

                                                         Figure G.2                   Response Time Requirements



                      better response time maintain a high level of user attention. With a response time of
                      between 3 and 10 seconds, some user concentration is lost, and response times above
                      10 seconds discourage the user, who may simply abort the session. Other studies of
                      Web response time generally confirm these findings [BHAT01].




Z12_STAL4290_09_GE_APPG.indd 4                                                                                                                                   4/18/17 7:30 AM

<!-- pág. 997 -->

                                                                                   G.2 / REFERENCES   G-5


               G.2 REFERENCES

                      BHAT01 Bhatti, N.; Bouch, A.; and Kuchinsky, A. “Integrated User-Perceived Quality into
                            Web Server Design.” Proceedings, 9th International World Wide Web Conference,
                            May 2000.
                      GUYN88 Guynes, J. “Impact of System Response Time on State Anxiety.” Communications
                            of the ACM, March 1988.
                      MART88 Martin, J. Principles of Data Communication. Englewood Cliffs, NJ: Prentice Hall,
                            1988.
                      SELV99 Selvidge, P. “How Long Is Too Long to Wait for a Webpage to Load.” Usability News,
                            Wichita State University, July 1999.
                      SEVC96 Sevcik, P. “Designing a High-Performance Web Site.” Business Communications
                            Review, March 1996.
                      SEVC02 Sevcik, P. “Understanding How Users View Application Performance.” Business
                            Communications Review, July 2002.
                      SHNE84 Shneiderman, B. “Response Time and Display Rate in Human Performance with
                            Computers.” ACM Computing Surveys, September 1984.
                      SMIT83 Smith, D. “Faster Is Better: A Business Case for Subsecond Response Time.” Com-
                            puterworld, April 18, 1983.
                      THAD81 Thadhani, A. “Interactive User Productivity.” IBM Systems Journal, No. 1, 1981.




Z12_STAL4290_09_GE_APPG.indd 5                                                                                    4/18/17 7:30 AM

<!-- pág. 998 -->

            aPPENDIX H
                                     QUEUEING sysTEM CoNcEPTs
                      H.1        Why Queueing Analysis?
                      H.2        The Single-Server Queue
                      H.3        The Multiserver Queue
                      H.4        Poisson Arrival Rate




                                                                H-1




Z13_STAL4290_09_GE_APPH.indd 1                                        4/18/17 7:31 AM

<!-- pág. 999 -->

            H-2   Appendix H / Queueing System Concepts
                      In a number of chapters in this book, results from queueing theory are used.
                      Chapter 21 provides a detailed discussion of queueing analysis. For purposes of
                      ­understanding the description of the results in the book, however, the brief over-
                       view in this appendix should suffice. In this appendix, we present a brief definition
                       of queueing systems and define key terms.


               H.1 WHY QUEUEING ANALYSIS?

                      It is often necessary to make projections of performance on the basis of existing load
                      information or on the basis of estimated load for a new environment. A number of
                      approaches are possible:
                          1. Do an after-the-fact analysis based on actual values.
                          2. Make a simple projection by scaling up from existing experience to the expected
                             future environment.
                          3. Develop an analytic model based on queueing theory.
                          4. Program and run a simulation model.
                            Option 1 is no option at all: we will wait and see what happens. This leads to
                      unhappy users and to unwise purchases. Option 2 sounds more promising. The analyst
                      may take the position that it is impossible to project future demand with any degree
                      of certainty. Therefore, it is pointless to attempt some exact modeling procedure.
                      Rather, a rough-and-ready projection will provide ballpark estimates. The problem
                      with this approach is that the behavior of most systems under a changing load is not
                      what one would intuitively expect. If there is an environment in which there is a
                      shared facility (e.g., a network, a transmission line, and a time-sharing system), then
                      the performance of that system typically responds in an exponential way to increases
                      in demand.
                            Figure H.1 is a representative example. The upper line shows what typically
                      happens to user response time on a shared facility as the load on that facility increases.
                      The load is expressed as a fraction of capacity. Thus, if we are dealing with a router
                      that is capable of processing and forwarding 1000 packets per second, then a load of
                      0.5 represents an arrival rate of 500 packets per second, and the response time is the
                      amount of time it takes to retransmit any incoming packet. The lower line is a simple
                      projection1 based on knowledge of the behavior of the system up to a load of 0.5.
                      Note while things appear rosy when the simple projection is made, performance on
                      the system will in fact collapse beyond a load of about 0.8 to 0.9.
                            Thus, a more exact prediction tool is needed. Option 3 is to make use of an
                      analytic model, which is one that can be expressed as a set of equations that can be
                      solved to yield the desired parameters (response time, throughput, etc.). For com-
                      puter, operating system, and networking problems, and indeed for many practical
                      real-world problems, analytic models based on queueing theory provide a reasonably
                      good fit to reality. The disadvantage of queueing theory is that a number of simplify-
                      ing assumptions must be made to derive equations for the parameters of interest.

                      1
                       The lower line is based on fitting a third-order polynomial to the data available up to a load of 0.5.




Z13_STAL4290_09_GE_APPH.indd 2                                                                                                  4/18/17 7:31 AM

<!-- pág. 1000 -->

                                                                                             H.2 / THE SINGLE-SERVER QUEUE   H-3

                                                 12


                                                 10                        Limit
                                                                       of experience

                                                 8




                                 Response Time
                                                 6
                                                                                                           Actual response
                                                                                                                time
                                                 4

                                                                                                                      Projected
                                                 2                                                                  response time



                                                 0
                                                      0          0.2                   0.4           0.6              0.8
                                                                         System Load (as a fraction of capacity)

                             Figure H.1                   Projected versus Actual Response Time



                             The final approach is a simulation model. Here, given a sufficiently powerful
                      and flexible simulation programming language, the analyst can model reality in great
                      detail and avoid making many of the assumptions required of queueing theory. How-
                      ever, in most cases, a simulation model is not needed or at least is not advisable as a
                      first step in the analysis. For one thing, both existing measurements and projections
                      of future load carry with them a certain margin of error. Thus, no matter how good
                      the simulation model, the value of the results is limited by the quality of the input.
                      For another, despite the many assumptions required of queueing theory, the results
                      that are produced often come quite close to those that would be produced by a more
                      careful simulation analysis. Furthermore, a queueing analysis can literally be accom-
                      plished in a matter of minutes for a well-defined problem, whereas simulation exer-
                      cises can take days, weeks, or longer to program and run.
                             Accordingly, it behooves the analyst to master the basics of queueing theory.


               H.2 THE SINGLE-SERVER QUEUE

                      The simplest queueing system is depicted in Figure H.2. The central element of the
                      system is a server, which provides some service to items. Items from some population
                      of items arrive at the system to be served. If the server is idle, an item is served imme-
                      diately. Otherwise, an arriving item joins a waiting line.2 When the server has com-
                      pleted serving an item, the item departs. If there are items waiting in the queue, one

                      2
                       The waiting line is referred to as a queue in some treatments in the literature; it is also common to refer
                      to the entire system as a queue. Unless otherwise noted, we use the term queue to mean waiting line.




Z13_STAL4290_09_GE_APPH.indd 3                                                                                                       4/18/17 7:31 AM

<!-- pág. 1001 -->

            H-4   Appendix H / Queueing System Concepts

                                                       Waiting line
                                                        (queue)           Dispatching
                              Arrivals                                     discipline                          Departures
                                                                                                Server
                                 l = arrival rate

                                                                                           Ts = service time
                                                    w = items waiting                       r = utilization
                                                    Tw = waiting time




                                                                r = items resident in queueing system
                                                                         Tr = residence time

                             Figure H.2 Queueing System Structure and Parameters for Single-Server Queue


            Table H.1      Notation for Queueing Systems
              l = arrival rate; mean number of arrivals per second
              Ts = mean service time for each arrival; amount of time being served, not counting time waiting in the queue
              r = utilization; fraction of time facility (server or servers) is busy
              w = mean number of items waiting to be served
              Tw = mean waiting time (including items that have to wait and items with waiting time = 0)
              r = mean number of items resident in system (waiting and being served)
              Tr = mean residence time; time an item spends in system (waiting and being served)



                       is immediately dispatched to the server. The server in this model can represent any-
                       thing that performs some function or service for a collection of items. Some examples
                       are: a processor provides service to processes; a transmission line provides a transmis-
                       sion service to packets or frames of data; an I/O device provides a read or write
                       service for I/O requests.
                              Table H.1 summarizes some important parameters associated with a queueing
                       model. Items arrive at the facility at some average rate (items arriving per second)
                       l. At any given time, a certain number of items will be waiting in the queue (zero or
                       more); the average number waiting is w, and the mean time that an item must wait
                       is Tw. Tw is averaged over all incoming items, including those that do not wait at all.
                       The server handles incoming items with an average service time Ts; this is the time
                       interval between the dispatching of an item to the server, and the departure of that
                       item from the server. Utilization, r, is the fraction of time that the server is busy,
                       measured over some interval of time. Finally, two parameters apply to the system as
                       a whole. The average number of items resident in the system, including the item
                       being served (if any) and the items waiting (if any), is r; and the average time that
                       an item spends in the system, waiting and being served, is Tr; we refer to this as the
                       mean residence time.3

                       3
                       Again, in some of the literature, this is referred to as the mean queueing time, while other treatments use
                       mean queueing time to mean the average time spent waiting in the queue (before being served).




Z13_STAL4290_09_GE_APPH.indd 4                                                                                                       4/18/17 7:31 AM

<!-- pág. 1002 -->

                                                                    H.3 / THE MULTISERVER QUEUE   H-5

                            If we assume that the capacity of the queue is infinite, then no items are ever
                      lost from the system; they are just delayed until they can be served. Under these
                      circumstances, the departure rate equals the arrival rate. As the arrival rate increases,
                      the utilization increases and with it, congestion. The queue becomes longer, increas-
                      ing waiting time. At r = 1, the server becomes saturated, working 100% of the time.
                      Thus, the theoretical maximum input rate that can be handled by the system is
                                                                      1
                                                             lmax =
                                                                      Ts
                            However, queues become very large near system saturation, growing without
                      bound when r = 1. Practical considerations, such as response time requirements or
                      buffer sizes, usually limit the input rate for a single server to between 70 and 90% of
                      the theoretical maximum.
                            The following assumptions are typically made:
                          • Item population: Typically, we assume an infinite population. This means the
                            arrival rate is not altered by the loss of population. If the population is finite,
                            then the population available for arrival is reduced by the number of items
                            currently in the system; this would typically reduce the arrival rate
                            proportionally.
                          • Queue size: Typically, we assume an infinite queue size. Thus, the waiting line
                            can grow without bound. With a finite queue, it is possible for items to be lost
                            from the system. In practice, any queue is finite. In many cases, this will make
                            no substantive difference to the analysis.
                          • Dispatching discipline: When the server becomes free, and if there is more than
                            one item waiting, a decision must be made as to which item to dispatch next.
                            The simplest approach is first-in-first-out; this discipline is what is normally
                            implied when the term queue is used. Another possibility is last-in-first-out. One
                            that you might encounter in practice is a dispatching discipline based on service
                            time. For example, a packet-switching node may choose to dispatch packets on
                            the basis of shortest first (to generate the most outgoing packets) or longest first
                            (to minimize processing time relative to transmission time). Unfortunately, a
                            discipline based on service time is very difficult to model analytically.



               H.3 THE MULTISERVER QUEUE

                      Figure H.3 shows a generalization of the simple model we have been discussing for
                      multiple servers, all sharing a common queue. If an item arrives and at least one
                      server is available, then the item is immediately dispatched to that server. It is
                      assumed all servers are identical; thus, if more than one server is available, it makes
                      no difference which server is chosen for the item. If all servers are busy, a queue
                      begins to form. As soon as one server becomes free, an item is dispatched from the
                      queue using the dispatching discipline in force.
                            With the exception of utilization, all of the parameters illustrated in Figure H.2
                      carry over to the multiserver case with the same interpretation. If we have N identical




Z13_STAL4290_09_GE_APPH.indd 5                                                                                     4/18/17 7:31 AM

<!-- pág. 1003 -->

            H-6   Appendix H / Queueing System Concepts

                                                                                l
                                                                                N    Server 1


                                                                                l
                                                              Dispatching       N    Server 2
                                                      Queue
                                     Arrivals                  discipline                       Departures

                                 l = arrival rate



                                                                                l
                                                                                N
                                                                                     Server N

                                                                (a) Multiserver queue


                                                                            l
                                                                            N
                                                                                     Server 1


                                                                            l
                                                                            N        Server 2
                                     Arrivals                                                   Departures
                                  l = arrival rate



                                                                            l
                                                                            N
                                                                                     Server N


                                                           (b) Multiple single-server queues

                                 Figure H.3         Multiserver Versus Multiple Single-Server Queues


                      servers, then r is the utilization of each server, and we can consider Nr to be the
                      utilization of the entire system; this latter term is often referred to as the traffic inten-
                      sity, u. Thus, the theoretical maximum utilization is N * 100,, and the theoretical
                      maximum input rate is:
                                                                                N
                                                                     lmax =
                                                                                Ts
                            The key characteristics typically chosen for the multiserver queue correspond
                      to those for the single-server queue. That is, we assume an infinite population and an
                      infinite queue size, with a single infinite queue shared among all servers. Unless oth-
                      erwise stated, the dispatching discipline is FIFO. For the multiserver case, if all servers
                      are assumed identical, the selection of a particular server for a waiting item has no
                      effect on service time.
                            By way of contrast, Figure H.3b shows the structure of multiple single-server
                      queues.




Z13_STAL4290_09_GE_APPH.indd 6                                                                                        4/18/17 7:31 AM

<!-- pág. 1004 -->

                                                                       H.4 / POISSON ARRIVAL RATE   H-7


               H.4 POISSON ARRIVAL RATE

                      Typically, analytic queueing models assume the arrival rate obeys a Poisson
                      ­distribution. This is what is assumed in the results of Table 9.6. We define this distribu-
                       tion as follows. If items arrive at a queue according to a Poisson distribution, this may
                       be expressed as
                                                                               (lT)k -lT
                                        Pr[k items arrive in time interval T] =      e
                                                                                 k!
                                      E[number of items to arrive in time interval T] = lT
                                          Mean arrival rate, in items per second = l
                             Arrivals occurring according to a Poisson process are often referred to as
                      ­random arrivals. This is because the probability of arrival of an item in a small interval
                       is proportional to the length of the interval, and is independent of the amount of
                       elapsed time since the arrival of the last item. That is, when items are arriving accord-
                       ing to a Poisson process, an item is as likely to arrive at one instant as any other,
                       regardless of the instants at which the other customers arrive.
                             Another interesting property of the Poisson process is its relationship to the
                       exponential distribution. If we look at the times between arrivals of items Ta (called
                       the interarrival times), then we find that this quantity obeys the exponential
                       distribution:
                                                    Pr[Ta 6 t] = 1 - e-lt
                                                                   1
                                                         E[Ta] =
                                                                   l
                      Thus, the mean interarrival time is the reciprocal of the arrival rate, as we would
                      expect.




Z13_STAL4290_09_GE_APPH.indd 7                                                                                       4/18/17 7:31 AM

<!-- pág. 1005 -->

            aPPENDIX I
                                 THE CoMPlEXIty oF alGorItHMs
                       I.1       Complexity Overview
                       I.2       References




                                                                I-1




Z14_STAL4290_09_GE_APPI.indd 1                                        4/18/17 7:31 AM

<!-- pág. 1006 -->

            I-2   APPENDIX I / The Complexity of Algorithms

               I.1 COMPLEXITY OVERVIEW

                       A central issue in assessing the practicality of an algorithm is the relative amount of
                       time it takes to execute the algorithm. Typically, one cannot be sure that one has found
                       the most efficient algorithm for a particular function. The most that one can say is that
                       for a particular algorithm, the level of effort for execution is of a particular order of
                       magnitude. One can then compare that order of magnitude to the speed of current or
                       predicted processors to determine the level of practicality of a particular algorithm.
                             A common measure of the efficiency of an algorithm is its time complexity. We
                       define the time complexity of an algorithm to be f(n) if, for all n and all inputs of
                       length n, the execution of the algorithm takes at most f(n) steps. Thus, for a given size
                       of input and a given processor speed, the time complexity is an upper bound on the
                       execution time.
                             There are several ambiguities here. First, the definition of a step is not precise.
                       A step could be a single operation of a Turing machine, a single processor machine
                       instruction, a single high-level language machine instruction, and so on. However,
                       these various definitions of step should all be related by simple multiplicative con-
                       stants. For very large values of n, these constants are not important. What is important
                       is how fast the relative execution time is growing.
                             A second issue is that, generally speaking, we cannot pin down an exact formula
                       for f(n). We can only approximate it. But again, we are primarily interested in the rate
                       of change of f(n) as n becomes very large.
                             There is a standard mathematical notation, known as the “big-O” notation, for
                       characterizing the time complexity of algorithms that is useful in this context. The
                       definition is as follows: f(n) = O(g(n)) if and only if there exist two numbers a and
                       M such that
                                                   f(n)  … a *  g(n)  ,   n Ú M                        (I.1)
                            An example helps clarify the use of this notation. Suppose we wish to evaluate
                       a general polynomial of the form:
                                           P(x) = anxn + an - 1xn - 1 + g + a1x + a0
                       Consider the following simple-minded algorithm from [POHL81]:

                       algorithm P1;
                           n, i, j: integer; x, polyval: real;
                           a, S: array [0..100] of real;
                           begin
                            read(x, n);
                            for i := 0 upto n do
                            begin
                                  S[i] := 1; read(a[i]);
                                  for j := 1 upto i do S[i] := x × S[i];
                                  S[i] := a[i] × S[i]
                            end;




Z14_STAL4290_09_GE_APPI.indd 2                                                                                     4/18/17 7:31 AM

<!-- pág. 1007 -->

                                                                       I.1 / COMPLEXITY OVERVIEW   I-3


                                  polyval := 0;
                                  for i := 0 upto n do polyval := polyval + S[i];
                                  write (’value at’, x, ’is’, polyval)
                                 end.

                            In this algorithm, each sub-expression is evaluated separately. Each S[i] requires
                       (i + 1) multiplications: i multiplications to compute S[i] and one to multiply by a[i].
                       Computing all n terms requires

                                                   a (i + 1) =
                                                    n            (n + 2)(n + 1)
                                                   i=0                 2
                       multiplications. There are also (n + 1) additions, which we can ignore relative to the
                       much larger number of multiplications. Thus, the time complexity of this algorithm is
                       f(n) = (n + 2)(n + 1)/2. We now show f(n) = O(n2). From the definition of Equa-
                       tion (I.1), we want to show that for a = 1 and M = 4, the relationship holds for
                       g(n) = n2. We do this by induction on n. The relationship holds for n = 4 because
                       (4 + 2)(4 + 1)/2 = 15 6 42 = 16. Now assume it holds for all values of n up to k
                       [i.e., (k + 2)(k + 1)/2 6 k 2]. Then, with n = k + 1:
                                                (n + 2)(n + 1)    (k + 3)(k + 2)
                                                                =
                                                       2                 2
                                                       (k + 2)(k + 1)
                                                    =                 + k + 2
                                                             2
                                                           … k2 + k + 2
                                                 … k + 2k + 1 = (k + 1)2 = n2
                                                     2


                       Therefore, the result is true for n = k + 1.
                            In general, the big-O notation makes use of the term that grows the fastest. For
                       example:
                          1. O[ax7 + 3x3 + sin(x)] = O(ax7) = O(x7)
                          2. O(en + an10) = O(en)
                          3. O(n! + n50) = O(n!)
                             There is much more to the big-O notation, with fascinating ramifications. For
                       the interested reader, two of the best accounts are in [GRAH94] and [KNUT97].
                             An algorithm with an input of size n is said to be:
                          1. Linear: if the running time is O(n)
                          2. Polynomial: if the running time is O(nt) for some constant t
                          3. Exponential: if the running time is O(t h(n)) for some constant t and polynomial
                             h(n)
                              Generally, a problem that can be solved in polynomial time is considered fea-
                       sible, whereas anything larger than polynomial time, especially exponential time, is
                       considered infeasible. But you must be careful with these terms. First, if the size of
                       the input is small enough, even very complex algorithms become feasible. Suppose,
                       for example, you have a system that can execute 1012 operations per unit time.




Z14_STAL4290_09_GE_APPI.indd 3                                                                                   4/18/17 7:31 AM

<!-- pág. 1008 -->

            I-4   APPENDIX I / The Complexity of Algorithms
                                            Table I.1 Level of Effort for Various Levels
                                            of Complexity
                                              Complexity    Size of Input         Operations
                                                 log 2n          12
                                                            210 = 103 * 10
                                                                             11
                                                                                     1012
                                                   n        1012                     1012
                                                  n2        106                      1012
                                                  n6        102                      1012
                                                    n
                                                  2         39                       1012
                                                  n!        15                       1012




                       Table I-1 shows the size of input that can be handled in one time unit for algorithms
                       of various complexities. For algorithms of exponential or factorial time, only very
                       small inputs can be accommodated.
                             The second thing to be careful about is the way in which the input is character-
                       ized. For example, the complexity of cryptanalysis of an encryption algorithm can be
                       characterized equally well in terms of the number of possible keys or the length of
                       the key. For the Advanced Encryption Standard (AES), for example, the number of
                       possible keys is 2128, and the length of the key is 128 bits. If we consider a single
                       encryption to be a “step” and the number of possible keys to be N = 2n, then the
                       time complexity of the algorithm is linear in terms of the number of keys [O(N)] but
                       exponential in terms of the length of the key [O(2n)].


               I.2 REFERENCES

                       GRAH94 Graham, R.; Knuth, D.; and Patashnik, O. Concrete Mathematics: A Foundation for
                            Computer Science. Reading, MA: Addison-Wesley, 1994.
                       KNUT97 Knuth, D. The Art of Computer Programming, Volume 1: Fundamental Algorithms.
                            Reading, MA: Addison-Wesley, 1997.
                       POHL81 Pohl, I., and Shaw, A. The Nature of Computation: An Introduction to Computer
                            ­Science. Rockville, MD: Computer Science Press, 1981.




Z14_STAL4290_09_GE_APPI.indd 4                                                                                  4/18/17 7:31 AM

<!-- pág. 1009 -->

            aPPENDIX J
                                     DIsK sToraGE DEVICEs
                       J.1       Magnetic Disk
                                    Data Organization and Formatting
                                    Physical Characteristics
                       J.2       Optical Memory
                                     CD-ROM
                                     CD Recordable
                                     CD Rewritable
                                     Digital Versatile Disk
                                     High-Definition Optical Disks




                                                                       J-1




Z15_STAL4290_09_GE_APPJ.indd 1                                               4/18/17 7:32 AM

<!-- pág. 1010 -->

            J-2   APPENDIX J / DISK STORAGE DEVICES

               J.1 MAGNETIC DISK

                       A disk is a circular platter constructed of metal or of plastic coated with a magnetiz-
                       able material. Data are recorded on and later retrieved from the disk via a conducting
                       coil named the head. During a read or write operation, the head is stationary while
                       the platter rotates beneath it.
                             The write mechanism exploits the fact that electricity flowing through a coil
                       produces a magnetic field. Electric pulses are sent to the head, and magnetic patterns
                       are recorded on the surface below, with different patterns for positive and negative
                       currents. The read mechanism is based on the fact that a magnetic field moving relative
                       to a coil produces an electrical current in the coil. When the surface of the disk passes
                       under the head, it generates a current of the same polarity as the one already recorded.

                       Data Organization and Formatting
                       The head is a relatively small device capable of reading from or writing to a portion
                       of the platter rotating beneath it. This gives rise to the organization of data on the
                       platter in a concentric set of rings, called tracks. Each track is the same width as the
                       head. There are thousands of tracks per surface.
                              Figure J.1 depicts this data layout. Adjacent tracks are separated by gaps. This
                       prevents, or at least minimizes, errors due to misalignment of the head or simply
                       interference of magnetic fields.
                              Data are transferred to and from the disk in sectors (see Figure J.1). There are
                       typically hundreds of sectors per track, and these may be of either fixed or variable
                       length. In most contemporary systems, fixed-length sectors are used, with 512 bytes
                       being the nearly universal sector size. To avoid imposing unreasonable precision require-
                       ments on the system, adjacent sectors are separated by intratrack (intersector) gaps.
                              A bit near the center of a rotating disk travels past a fixed point (such as a read-
                       write head) slower than a bit on the outside. Therefore, some way must be found to
                       compensate for the variation in speed so the head can read all the bits at the same
                       rate. This can be done by increasing the spacing between bits of information recorded
                       in segments of the disk. The information can then be scanned at the same rate by
                       rotating the disk at a fixed speed, known as the constant angular velocity (CAV).
                              Figure J.2a shows the layout of a disk using CAV. The disk is divided into a num-
                       ber of pie-shaped sectors and into a series of concentric tracks. The advantage of using
                       CAV is that individual blocks of data can be directly addressed by track and sector.
                       To move the head from its current location to a specific address, it only takes a short
                       movement of the head to a specific track and a short wait for the proper sector to spin
                       under the head. The disadvantage of CAV is that the amount of data that can be stored
                       on the long outer tracks is the same as what can be stored on the short inner tracks.
                              Because the density, in bits per linear inch, increases in moving from the out-
                       ermost track to the innermost track, disk storage capacity in a straightforward CAV
                       system is limited by the maximum recording density that can be achieved on the
                       innermost track. To increase density, modern hard disk systems use a technique
                       known as multiple zone recording, in which the surface is divided into a number of
                       concentric zones (16 is typical). Within a zone, the number of bits per track is




Z15_STAL4290_09_GE_APPJ.indd 2                                                                                       4/18/17 7:32 AM

<!-- pág. 1011 -->

                                                                                                          J.1 / MAGNETIC DISK   J-3

                                                                              Rotation
                                              Intertrack gap                                         Track

                                  Intersector gap
                                                                    S6                         •••


                                                                         S6              •••
                                                                                                                      Track sector
                                 Sector                                             •••
                                                    S5                        S6                               SN
                                                          S5                                           SN
                                                                    S5                         SN


                                                                    S4                         S1
                                                           S4                                          S1
                                                    S4                        S3    S2                         S1


                                                                         S3               S2


                                                                    S3                         S2
                                                                                                       Read-write head
                                                                                                        (1 per surface)




                                 Platter




                                                         Cylinder                                      Direction of       Boom
                                                                              Spindle
                                                                                                       arm motion
                                 Figure J.1    Disk Data Layout

                       constant. Zones farther from the center contain more bits (more sectors) than zones
                       closer to the center. This allows for greater overall storage capacity at the expense of
                       somewhat more complex circuitry. As the disk head moves from one zone to another,
                       the length (along the track) of individual bits changes, causing a change in the timing
                       for reads and writes. Figure J.2b suggests the nature of multiple zone recording; in
                       this illustration, each zone is only a single track wide.
                              Some means is needed to locate sector positions within a track. Clearly, there
                       must be some starting point on the track, and a way of identifying the start and end
                       of each sector. These requirements are handled by means of control data recorded
                       on the disk. Thus, the disk is formatted with some extra data used only by the disk
                       drive and not accessible to the user.




Z15_STAL4290_09_GE_APPJ.indd 3                                                                                                        4/18/17 7:32 AM

<!-- pág. 1012 -->

            J-4   APPENDIX J / DISK STORAGE DEVICES

                                 Track                                                                    Zone
                                                                    Sector




                                         (a) Constant angular velocity            (b) Multiple zone recording

                             Figure J.2        Comparison of Disk Layout Methods


                       Physical Characteristics
                       Table J.1 lists the major characteristics that differentiate among the various types of
                       magnetic disks. First, the head may either be fixed or movable with respect to the
                       radial direction of the platter. In a fixed-head disk, there is one read/write head per
                       track. All of the heads are mounted on a rigid arm that extends across all tracks; such
                       systems are rare today. In a movable-head disk, there is only one read/write head.
                       Again, the head is mounted on an arm. Because the head must be able to be posi-
                       tioned above any track, the arm can be extended or retracted for this purpose.
                             The disk itself is mounted in a disk drive, which consists of the arm, a spindle
                       that rotates the disk, and the electronics needed for input and output of binary data.
                       A nonremovable disk is permanently mounted in the disk drive; the hard disk in a
                       personal computer is a nonremovable disk. A removable disk can be removed and
                       replaced with another disk. The advantage of the latter type is that unlimited amounts
                       of data are available with a limited number of disk systems. Furthermore, such a disk
                       may be moved from one computer system to another.
                             For most disks, the magnetizable coating is applied to both sides of the platter,
                       which is then referred to as double-sided. Some less expensive disk systems use sin-
                       gle-sided disks.

                       Table J.1    Physical Characteristics of Disk Systems
                         Head Motion                                         Platters
                           Fixed head (one per track)                          Single platter
                           Movable head (one per surface)                      Multiple platter
                         Disk Portability                                    Head Mechanism
                           Nonremovable disk                                   Contact (floppy)
                           Removable disk                                      Fixed gap
                         Sides                                                 Aerodynamic gap (Winchester)
                           Single sided
                           Double sided




Z15_STAL4290_09_GE_APPJ.indd 4                                                                                   4/18/17 7:32 AM

<!-- pág. 1013 -->

                                                                                     J.1 / MAGNETIC DISK   J-5

                             Some disk drives accommodate multiple platters stacked vertically a fraction
                       of an inch apart. Multiple arms are provided (Figure J.3). Multiple-platter disks
                       employ a movable head, with one read-write head per platter surface. All of the heads
                       are mechanically fixed so all are at the same distance from the center of the disk and
                       move together. Thus, at any time, all of the heads are positioned over tracks that are
                       of equal distance from the center of the disk. The set of all the tracks in the same rela-
                       tive position on the platter is referred to as a cylinder. For example, all of the shaded
                       tracks in Figure J.4 are part of one cylinder.
                             Finally, the head mechanism provides a classification of disks into three types.
                       Traditionally, the read/write head has been positioned at a fixed distance above the
                       platter, allowing an air gap. At the other extreme is a head mechanism that actually
                       comes into physical contact with the medium during a read or write operation. This
                       mechanism is used with the floppy disk, which is a small, flexible platter and the least
                       expensive type of disk.
                             To understand the third type of disk, we need to comment on the relationship
                       between data density and the size of the air gap. The head must generate or sense an
                       electromagnetic field of sufficient magnitude to write and read properly. The nar-
                       rower the head is, the closer it must be to the platter surface to function. A narrower
                       head means narrower tracks and therefore greater data density, which is desirable.

                                               Read/write head (1 per surface)   Direction of
                                                                                 arm motion



                                               Surface 9
                                     Platter

                                               Surface 8
                                               Surface 7



                                               Surface 6
                                               Surface 5



                                               Surface 4
                                               Surface 3



                                               Surface 2
                                               Surface 1



                                               Surface 0


                                                                    Spindle                     Boom

                                    Figure J.3 Components of a Disk Drive




Z15_STAL4290_09_GE_APPJ.indd 5                                                                                      4/18/17 7:32 AM

<!-- pág. 1014 -->

            J-6   APPENDIX J / DISK STORAGE DEVICES




                                                Figure J.4 Tracks and Cylinders


                       However, the closer the head is to the disk, the greater the risk of error from impuri-
                       ties or imperfections. To push the technology further, the Winchester disk was devel-
                       oped. Winchester heads are used in sealed drive assemblies that are almost free of
                       contaminants. They are designed to operate closer to the disk’s surface than conven-
                       tional rigid disk heads, thus allowing greater data density. The head is actually an
                       aerodynamic foil that rests lightly on the platter’s surface when the disk is motionless.
                       The air pressure generated by a spinning disk is enough to make the foil rise above
                       the surface. The resulting noncontact system can be engineered to use narrower heads
                       that operate closer to the platter’s surface than conventional rigid disk heads.
                             Table J.2 gives disk parameters for typical contemporary high-performance disks.


               J.2 OPTICAL MEMORY

                       In 1983, one of the most successful consumer products of all time was introduced: the
                       compact disk (CD) digital audio system. The CD is a nonerasable disk that can store
                       more than 60 minutes of audio information on one side. The huge commercial success
                       of the CD enabled the development of low-cost optical-disk storage technology that
                       has revolutionized computer data storage. A variety of optical-disk systems are in use
                       (see Table J.3). We briefly review each of these.

                       CD-ROM
                       The audio CD and the CD-ROM (compact disk read-only memory) share a similar
                       technology. The main difference is that CD-ROM players are more rugged and have
                       error-correction devices to ensure data are properly transferred from disk to




Z15_STAL4290_09_GE_APPJ.indd 6                                                                                     4/18/17 7:32 AM

<!-- pág. 1015 -->

                                                                                     J.2 / OPTICAL MEMORY   J-7

            Table J.2 Typical Hard Disk Drive Parameters
                                       Seagate         Seagate              Seagate
                                      ­Barracuda       ­Barracuda          ­Barracuda                  Hitachi
              Characteristics          ES.2             7200.10             7200.9       Seagate       Microdrive
              Application            High-capacity    High-performance    Entry-level    Laptop        Handheld
                                     server           desktop             desktop                      devices
              Capacity               1 TB             750 GB              160 GB         120 GB        8 GB
              Minimum track-to-      0.8 ms           0.3 ms              1.0 ms         —             1.0 ms
              track seek time
              Average seek time      8.5 ms           3.6 ms              9.5 ms         12.5 ms       12 ms
              Spindle speed          7200 rpm         7200 rpm            7200           5400 rpm      3600 rpm
              Average rotational     4.16 ms          4.16 ms             4.17 ms        5.6 ms        8.33 ms
              delay
              Maximum transfer       3 GB/s           300 MB/s            300 MB/s       150 MB/s      10 MB/s
              rate
              Bytes per sector       512              512                 512            512           512
              Tracks per cylinder    8                8                   2              8             2
              (number of platter
              surfaces)



                         computer. Both types of disk are made in the same way. The disk is formed from a
                         resin, such as polycarbonate. Digitally recorded information (either music or com-
                         puter data) is imprinted as a series of microscopic pits on the surface of the poly-
                         carbonate. This is done, first of all, with a finely focused, high-intensity laser to create
                         a master disk. The master is used, in turn, to make a die to stamp out copies onto
                         polycarbonate. The pitted surface is then coated with a highly reflective surface,
                         usually aluminum or gold. This shiny surface is protected against dust and scratches
                         by a top coat of clear acrylic. Finally, a label can be silkscreened onto the acrylic.
                               Information is retrieved from a CD or CD-ROM by a low-powered laser
                         housed in an optical-disk player, or drive unit. The laser shines through the clear
                         polycarbonate while a motor spins the disk past it (see Figure J.5). The intensity of
                         the reflected light of the laser changes as it encounters a pit. Specifically, if the laser
                         beam falls on a pit, which has a somewhat rough surface, the light scatters and a low
                         intensity is reflected back to the source. The areas between pits are called lands. A
                         land is a smooth surface, which reflects back at higher intensity. The change between
                         pits and lands is detected by a photosensor and converted into a digital signal. The
                         sensor tests the surface at regular intervals. The beginning or end of a pit represents
                         a 1; when no change in elevation occurs between intervals, a 0 is recorded.
                               Recall that on a magnetic disk, information is recorded in concentric tracks. With
                         the simplest CAV system, the number of bits per track is constant. An increase in
                         density is achieved with multiple zoned recording, in which the surface is divided into
                         a number of zones, with zones farther from the center containing more bits than zones
                         closer to the center. Although this technique increases capacity, it is still not optimal.
                               To achieve greater capacity, CDs and CD-ROMs do not organize information
                         on concentric tracks. Instead, the disk contains a single spiral track, beginning near




Z15_STAL4290_09_GE_APPJ.indd 7                                                                                          4/18/17 7:32 AM

<!-- pág. 1016 -->

            J-8   APPENDIX J / DISK STORAGE DEVICES

                             Protective
                             acrylic                  Label




                                                                                 Land
                                                                                          Pit
                                    Polycarbonate                                               Aluminum
                                    plastic



                                                              Laser transmit/
                                                                 receive

                            Figure J.5     CD Operation

                       the center and spiraling out to the outer edge of the disk. Sectors near the outside of
                       the disk are the same length as those near the inside. Thus, information is packed
                       evenly across the disk in segments of the same size, and these are scanned at the same
                       rate by rotating the disk at a variable speed. The pits are then read by the laser at a
                       constant linear velocity (CLV). The disk rotates more slowly for accesses near the
                       outer edge than for those near the center. Thus, the capacity of a track and the rota-
                       tional delay both increase for positions nearer the outer edge of the disk. The data
                       capacity for a CD-ROM is about 680 MB.
                             CD-ROM is appropriate for the distribution of large amounts of data to a large
                       number of users. Because of the expense of the initial writing process, it is not appro-
                       priate for individualized applications. Compared with traditional magnetic disks, the
                       CD-ROM has three major advantages:
                           • The information-storage capacity is much greater on the optical disk.
                           • The optical disk together with the information stored on it can be mass repli-
                             cated inexpensively—unlike a magnetic disk. The data on a magnetic disk has
                             to be reproduced by copying one disk at a time using two disk drives.
                           • The optical disk is removable, allowing the disk itself to be used for archival
                             storage. Most magnetic disks are nonremovable. The information on nonremov-
                             able magnetic disks must first be copied to some other storage device before
                             the disk drive/disk can be used to store new information.
                                 The disadvantages of CD-ROM are as follows:
                           • It is read-only and cannot be updated.
                           • It has an access time much longer than that of a magnetic disk drive, as much
                             as half a second.

                       CD Recordable
                       To accommodate applications in which only one or a small number of copies of a
                       set of data is needed, the write-once read-many CD, known as the CD recordable
                       (CD-R) has been developed. For CD-R, a disk is prepared in such a way that it can




Z15_STAL4290_09_GE_APPJ.indd 8                                                                                    4/18/17 7:32 AM

<!-- pág. 1017 -->

                                                                                J.2 / OPTICAL MEMORY   J-9

                       be subsequently written once with a laser beam of modest intensity. Thus, with a
                       somewhat more expensive disk controller than for CD-ROM, the customer can write
                       once as well as read the disk.
                             The CD-R medium is similar to, but not identical to, that of a CD or CD-ROM.
                       For CDs and CD-ROMs, information is recorded by the pitting of the surface of the
                       medium, which changes reflectivity. For a CD-R, the medium includes a dye layer.
                       The dye is used to change reflectivity and is activated by a high-intensity laser. The
                       resulting disk can be read on a CD-R drive or a CD-ROM drive.
                             The CD-R optical disk is attractive for archival storage of documents and files.
                       It provides a permanent record of large volumes of user data.

                       CD Rewritable
                       The CD-RW optical disk can be repeatedly written and overwritten, as with a mag-
                       netic disk. Although a number of approaches have been tried, the only pure optical
                       approach that has proved attractive is called phase change. The phase change disk
                       uses a material that has two significantly different reflectivities in two different phase
                       states. There is an amorphous state, in which the molecules exhibit a random orienta-
                       tion that reflects light poorly; and a crystalline state, which has a smooth surface that
                       reflects light well. A beam of laser light can change the material from one phase to
                       the other. The primary disadvantage of phase change optical disks is that the material
                       eventually and permanently loses its desirable properties. Current materials can be
                       used for between 500,000 and 1,000,000 erase cycles.
                             The CD-RW has the obvious advantage over CD-ROM and CD-R that it can
                       be rewritten and thus used as a true secondary storage. As such, it competes with
                       magnetic disk. A key advantage of the optical disk is that the engineering tolerances
                       for optical disks are much less severe than for high-capacity magnetic disks. Thus,
                       optical disks exhibit higher reliability and longer life.

                       Digital Versatile Disk
                       With the capacious digital versatile disk (DVD), the electronics industry has at last
                       found an acceptable replacement for the analog VHS video tape. The DVD will
                       replace the video tape used in video cassette recorders (VCRs) and, more impor-
                       tant for this discussion, replace the CD-ROM in personal computers and servers.
                       The DVD takes video into the digital age. It delivers movies with impressive pic-
                       ture quality, and it can be randomly accessed like audio CDs, which DVD machines
                       can also play. Vast volumes of data can be crammed onto the disk, currently seven
                       times as much as a CD-ROM. With DVD’s huge storage capacity and vivid quality,
                       PC games will become more realistic, and educational software will incorporate
                       more video. Following in the wake of these developments will be a new crest of
                       traffic over the Internet and corporate intranets, as this material is incorporated
                       into websites.
                             The DVD’s greater capacity is due to three differences from CDs:
                          1. Bits are packed more closely on a DVD. The spacing between loops of a spiral on
                             a CD is 1.6 mm and the minimum distance between pits along the spiral is
                             0.834 mm. The DVD uses a laser with shorter wavelength and achieves a loop




Z15_STAL4290_09_GE_APPJ.indd 9                                                                                      4/18/17 7:32 AM

<!-- pág. 1018 -->

            J-10   APPENDIX J / DISK STORAGE DEVICES
                             spacing of 0.74 mm and a minimum distance between pits of 0.4 mm. The result of
                             these two improvements is about a sevenfold increase in capacity, to about 4.7 GB.
                          2. The DVD employs a second layer of pits and lands on top of the first layer. A
                             dual-layer DVD has a semireflective layer on top of the reflective layer, and by
                             adjusting focus, the lasers in DVD drives can read each layer separately. This
                             technique almost doubles the capacity of the disk, to about 8.5 GB. The lower
                             reflectivity of the second layer limits its storage capacity so a full doubling is
                             not achieved.
                          3. The DVD-ROM can be two sided, whereas data are recorded on only one side
                             of a CD. This brings total capacity up to 17 GB.
                            As with the CD, DVDs come in writeable as well as read-only versions (see
                       Table J.3).

                       High-Definition Optical Disks
                       High-definition optical disks are designed to store high-definition videos and to pro-
                       vide significantly greater storage capacity compared to DVDs. The higher bit density
                       is achieved by using a laser with a shorter wavelength, in the blue-violet range. The
                       data pits, which constitute the digital 1s and 0s, are smaller on the high-definition
                       optical disks compared to DVD because of the shorter laser wavelength.

            Table J.3    Optical Disk Products
              CD
                Compact Disk. A nonerasable disk that stores digitized audio information. The standard system uses 12-cm
              disks and can record more than 60 minutes of uninterrupted playing time.
              CD-ROM
                Compact Disk Read-Only Memory. A nonerasable disk used for storing computer data. The standard system
              uses 12-cm disks and can hold more than 650 Mbytes.
              CD-R
                CD Recordable. Similar to a CD-ROM. The user can write to the disk only once.
              CD-RW
                CD Rewritable. Similar to a CD-ROM. The user can erase and rewrite to the disk multiple times.
              DVD
                 Digital Versatile Disk. A technology for producing digitized, compressed representation of video informa-
              tion, as well as large volumes of other digital data. Both 8- and 12-cm diameters are used, with a double-sided
              capacity of up to 17 GB. The basic DVD is read-only (DVD-ROM).
              DVD-R
                DVD Recordable. Similar to a DVD-ROM. The user can write to the disk only once. Only one-sided disks
              can be used.
              DVD-RW
                DVD Rewritable. Similar to a DVD-ROM. The user can erase and rewrite to the disk multiple times. Only
              one-sided disks can be used.
              Blu-Ray DVD
                High definition video disk. Provides considerably greater data storage density than DVD, using a 405-nm
              (blue-violet) laser. A single layer on a single side can store 25 GB.




Z15_STAL4290_09_GE_APPJ.indd 10                                                                                                 4/18/17 7:32 AM

<!-- pág. 1019 -->

                                                                               J.2 / OPTICAL MEMORY   J-11

                              Two disk formats and technologies initially competed for market acceptance:
                       HD DVD and Blu-ray DVD. The Blu-ray scheme ultimately achieved market domi-
                       nance. The HD DVD scheme can store 15 GB on a single layer on a single side.
                       ­Blu-ray positions the data layer on the disk closer to the laser (shown on the right-
                        hand side of each diagram in Figure J.6). This enables a tighter focus and less distor-
                        tion and thus smaller pits and tracks. Blu-ray can store 25 GB on a single layer. Three
                        versions are available: read only (BD-ROM), recordable once (BD-R), and rerecord-
                        able (BD-RE).



                                          CD             2.11 µm


                                                                              Data layer
                                          Beam spot                   Land


                                               Pit                                              1.2 µm


                                                      Track

                                                                                laser wavelength
                                                                                    = 780 nm

                                                          1.32 µm
                                          DVD




                                                                                            0.6 µm




                                                                                       650 nm


                                                          0.58 µm
                                          Blu-ray




                                                                                                0.1 µm




                                                                                       405 nm
                                       Figure J.6     Optical Memory Characteristics




Z15_STAL4290_09_GE_APPJ.indd 11                                                                                   4/18/17 7:32 AM

<!-- pág. 1020 -->

            aPPENDIX K
                                     CryPToGraPHIc alGorITHMs
                      K.1        Symmetric Encryption
                                    The Data Encryption Standard (DES)
                                    Advanced Encryption Standard (AES)
                      K.2        Public-Key Cryptography
                                      Rivest-Shamir-Adleman (RSA) Algorithm
                      K.3        Message Authentication and Hash Functions
                                     Authentication Using Symmetric Encryption
                                     Message Authentication without Message Encryption
                                     Message Authentication Code
                                     One-Way Hash Function
                      K.4        Secure Hash Functions




                                                                                         K-1




Z16_STAL4290_09_GE_APPK.indd 1                                                                 4/18/17 7:33 AM

<!-- pág. 1021 -->

            K-2   Appendix K / Cryptographic Algorithms
                      The essential technology underlying virtually all automated network and computer
                      security applications is cryptography. Two fundamental approaches are in use: sym-
                      metric encryption, also known as conventional encryption, and public-key encryption,
                      also known as asymmetric encryption. This appendix provides an overview of both
                      types of encryption, together with a brief discussion of some important encryption
                      algorithms.



               K.1 SYMMETRIC ENCRYPTION

                      Symmetric encryption was the only type of encryption in use prior to the introduction
                      of public-key encryption in the late 1970s. Symmetric encryption has been used for
                      secret communication by countless individuals and groups, from Julius Caesar to the
                      German U-boat force to present-day diplomatic, military, and commercial users. It
                      remains by far the more widely used of the two types of encryption.
                            A symmetric encryption scheme has five ingredients (see Figure K.1):
                          • Plaintext: This is the original message or data that is fed into the algorithm as
                            input.
                          • Encryption algorithm: The encryption algorithm performs various substitutions
                            and transformations on the plaintext.
                          • Secret key: The secret key is also input to the encryption algorithm. The exact
                            substitutions and transformations performed by the algorithm depend on
                            the key.
                          • Ciphertext: This is the scrambled message produced as output. It depends on
                            the plaintext and the secret key. For a given message, two different keys will
                            produce two different ciphertexts.
                          • Decryption algorithm: This is essentially the encryption algorithm run in
                            reverse. It takes the ciphertext and the secret key and produces the original
                            plaintext.



                                        Secret key shared by                  Secret key shared by
                                        sender and recipient                  sender and recipient

                                                    K                                      K


                                                               Transmitted
                                 X                              ciphertext
                                                               Y = E[K, X]                       X = D[K, Y]

                     Plaintext                                                                                 Plaintext
                                       Encryption algorithm                  Decryption algorithm
                       input                                                                                    output
                                           (e.g., AES)                       (reverse of encryption
                                                                                   algorithm)

                    Figure K.1       Simplified Model of Symmetric Encryption




Z16_STAL4290_09_GE_APPK.indd 2                                                                                             4/18/17 7:33 AM

<!-- pág. 1022 -->

                                                                     K.1 / SYMMETRIC ENCRYPTION   K-3

                              There are two requirements for secure use of symmetric encryption:
                         1. We need a strong encryption algorithm. At a minimum, we would like the algo-
                            rithm to be such that an opponent who knows the algorithm and has access to
                            one or more ciphertexts would be unable to decipher the ciphertext or figure
                            out the key. This requirement is usually stated in a stronger form: The opponent
                            should be unable to decrypt ciphertext or discover the key, even if he or she is
                            in possession of a number of ciphertexts together with the plaintext that pro-
                            duced each ciphertext.
                         2. Sender and receiver must have obtained copies of the secret key in a secure
                            fashion and must keep the key secure. If someone can discover the key and
                            knows the algorithm, all communication using this key is readable.
                             There are two general approaches to attacking a symmetric encryption scheme.
                      The first attack is known as cryptanalysis. Cryptanalytic attacks rely on the nature of
                      the algorithm plus perhaps some knowledge of the general characteristics of the plain-
                      text or even some sample plaintext-ciphertext pairs. This type of attack exploits the
                      characteristics of the algorithm to attempt to deduce a specific plaintext or to deduce
                      the key being used. If the attack succeeds in deducing the key, the effect is cata-
                      strophic: All future and past messages encrypted with that key are compromised.
                             The second method, known as the brute-force attack, is to try every possible
                      key on a piece of ciphertext until an intelligible translation into plaintext is obtained.
                      On average, half of all possible keys must be tried to achieve success. Table K.1 shows
                      how much time is involved for various key sizes. The table shows results for each key
                      size, assuming it takes 1 ms to perform a single decryption, a reasonable order of
                      magnitude for today’s computers. With the use of massively parallel organizations of
                      microprocessors, it may be possible to achieve processing rates many orders of mag-
                      nitude greater. The final column of the table considers the results for a system that
                      can process 1 million keys per microsecond. As one can see, at this performance level,
                      a 56-bit key can no longer be considered computationally secure.
                             The most commonly used symmetric encryption algorithms are block ciphers.
                      A block cipher processes the plaintext input in fixed-size blocks and produces a block
                      of ciphertext of equal size for each plaintext block. The two most important sym-
                      metric algorithms, both of which are block ciphers, are the Data Encryption Standard
                      (DES) and the Advanced Encryption Standard (AES).


            Table K.1 Average Time Required for Exhaustive Key Search
                                 Number of Alternative   Time Required at                 Time Required at
              Key Size (bits)    Keys                    1 Decryption/Ms                  106 Decryptions/Ms
              32                 232 = 4.3 * 109         231 ms = 35.8 minutes            2.15 milliseconds
              56                 256 = 7.2 * 1016        255 ms = 1142 years              10.01 hours
              128                2128 = 3.4 * 1038       2127 ms = 5.4 * 1024 years       5.4 * 1018 years
              168                2168 = 3.7 * 1050       2167 ms = 5.9 * 1036 years       5.9 * 1030 years
              26 characters      26! = 4 * 1026          2 * 1026 ms = 6.4 * 1012 years   6.4 * 106 years
              (permutation)




Z16_STAL4290_09_GE_APPK.indd 3                                                                                     4/18/17 7:33 AM

<!-- pág. 1023 -->

            K-4   Appendix K / Cryptographic Algorithms

                      The Data Encryption Standard (DES)
                      DES has been the dominant encryption algorithm since its introduction in 1977. How-
                      ever, because DES uses only a 56-bit key, it was only a matter of time before com-
                      puter processing speed made DES obsolete. In 1998, the Electronic Frontier
                      Foundation (EFF) announced that it had broken a DES challenge using a special-
                      purpose “DES cracker” machine that was built for less than $250,000. The attack took
                      less than three days. The EFF has published a detailed description of the machine,
                      enabling others to build their own cracker. And, of course, hardware prices continue
                      to drop as speeds increase, making DES worthless.
                            The life of DES was extended by the use of triple DES (3DES), which involves
                      repeating the basic DES algorithm three times, using either two or three unique keys,
                      for a key size of 112 or 168 bits.
                            The principal drawback of 3DES is that the algorithm is relatively sluggish in
                      software. A secondary drawback is that both DES and 3DES use a 64-bit block size.
                      For reasons of both efficiency and security, a larger block size is desirable.

                      Advanced Encryption Standard
                      Because of these drawbacks, 3DES is not a reasonable candidate for long-term use.
                      As a replacement, the National Institute of Standards and Technology (NIST) in 1997
                      issued a call for proposals for a new Advanced Encryption Standard (AES), which
                      should have a security strength equal to or better than 3DES and significantly
                      improved efficiency. In addition to these general requirements, NIST specified that
                      AES must be a symmetric block cipher with a block length of 128 bits and support for
                      key lengths of 128, 192, and 256 bits. Evaluation criteria include security, computa-
                      tional efficiency, memory requirements, hardware and software suitability, and flexibil-
                      ity. In 2001, NIST issued AES as a federal information processing standard (FIPS 197).


               K.2 PUBLIC-KEY CRYPTOGRAPHY

                      Public-key encryption, first publicly proposed by Diffie and Hellman in 1976, is the
                      first truly revolutionary advance in encryption in literally thousands of years. For one
                      thing, public-key algorithms are based on mathematical functions rather than on
                      simple operations on bit patterns. More important, public-key cryptography is asym-
                      metric, involving the use of two separate keys, in contrast to symmetric encryption,
                      which uses only one key. The use of two keys has profound consequences in the areas
                      of confidentiality, key distribution, and authentication.
                             Before proceeding, we should first mention several common misconceptions
                      concerning public-key encryption. One is that public-key encryption is more secure
                      from cryptanalysis than symmetric encryption. In fact, the security of any encryption
                      scheme depends on the length of the key and the computational work involved in
                      breaking a cipher. There is nothing in principle about either symmetric or public-key
                      encryption that makes one superior to another from the point of view of resisting
                      cryptanalysis. A second misconception is that public-key encryption is a general-
                      purpose technique that has made symmetric encryption obsolete. On the contrary,
                      because of the computational overhead of current public-key encryption schemes,




Z16_STAL4290_09_GE_APPK.indd 4                                                                                   4/18/17 7:33 AM

<!-- pág. 1024 -->

                                                                 K.2 / PUBLIC-KEY CRYPTOGRAPHY   K-5

                      there seems no foreseeable likelihood that symmetric encryption will be abandoned.
                      Finally, there is a feeling that key distribution is trivial when using public-key encryp-
                      tion, compared to the rather cumbersome handshaking involved with key distribution
                      centers for symmetric encryption. In fact, some form of protocol is needed, often
                      involving a central agent, and the procedures involved are no simpler or any more
                      efficient than those required for symmetric encryption.
                             A public-key encryption scheme has six ingredients (see Figure K.2):
                          • Plaintext: This is the readable message or data that is fed into the algorithm as
                            input.
                          • Encryption algorithm: The encryption algorithm performs various transforma-
                            tions on the plaintext.
                          • Public and private key: This is a pair of keys that have been selected so if one
                            is used for encryption, the other is used for decryption. The exact transforma-
                            tions performed by the encryption algorithm depend on the public or private
                            key that is provided as input.
                          • Ciphertext: This is the scrambled message produced as output. It depends on
                            the plaintext and the key. For a given message, two different keys will produce
                            two different ciphertexts.
                          • Decryption algorithm: This algorithm accepts the ciphertext and the matching
                            key and produces the original plaintext.
                             The process works (produces the correct plaintext on output) regardless of the
                      order in which the pair of keys is used. As the names suggest, the public key of the
                      pair is made public for others to use, while the private key is known only to its owner.
                             Now, say Bob wants to send a private message to Alice, and suppose that he has
                      Alice’s public key and Alice has the matching private key (see Figure K.2a). Using
                      Alice’s public key, Bob encrypts the message to produce ciphertext. The ciphertext is
                      then transmitted to Alice. When Alice gets the ciphertext, she decrypts it using her
                      private key. Because only Alice has a copy of her private key, no one else can read
                      the message.
                             Public-key encryption can be used in another way, as illustrated in Figure K.2b.
                      Suppose Bob wants to send a message to Alice and, although it isn’t important that
                      the message be kept secret, he wants Alice to be certain that the message is indeed
                      from him. In this case Bob uses his own private key to encrypt the message. When
                      Alice receives the ciphertext, she finds that she can decrypt it with Bob’s public key,
                      thus proving that the message must have been encrypted by Bob: No one else has
                      Bob’s private key, and therefore no one else could have created a ciphertext that
                      could be decrypted with Bob’s public key.
                             A general-purpose public-key cryptographic algorithm relies on one key for
                      encryption and a different but related key for decryption. Furthermore, these algo-
                      rithms have the following important characteristics:
                          • It is computationally infeasible to determine the decryption key given only
                            knowledge of the cryptographic algorithm and the encryption key.
                          • Either of the two related keys can be used for encryption, with the other used
                            for decryption.




Z16_STAL4290_09_GE_APPK.indd 5                                                                                     4/18/17 7:33 AM

<!-- pág. 1025 -->

            K-6   Appendix K / Cryptographic Algorithms


                                                    Bobs's
                                                  public key
                                                     ring
                                    Joy
                                                                 Ted
                                           Mike          Alice

                                                  PUa    Alice's public                                PRa   Alice's private
                                                              key                                                 key


                                                                            Transmitted                                X=
                                      X                                      ciphertext                              D[PRa, Y]


                                                                          Y = E[PUa, X]
                        Plaintext                                                                                              Plaintext
                                           Encryption algorithm                                 Decryption algorithm
                          input                                                                                                 output
                                               (e.g., RSA)                                      (reverse of encryption
                                                                                                      algorithm)
                                                               (a) Encryption with public key


                                                                                                     Alice's
                                                                                                    public key
                                                                                                       ring
                                                                                          Joy
                                                                                                                    Ted
                                                                                                Mike          Bob

                                                PRb      Bob's private                                 PUb   Bob's public
                                                             key                                                 key

                                                                                                                        X=
                                      X                                     Transmitted                              D[PUb, Y]
                                                                             ciphertext

                                                                          Y = E[PRb, X]

                        Plaintext                                                                                              Plaintext
                                           Encryption algorithm                                 Decryption algorithm
                          input                                                                                                 output
                                               (e.g., RSA)                                      (reverse of encryption
                                                                                                      algorithm)
                                                               (b) Encryption with private key

                       Figure K.2         Public-Key Cryptography


                             The essential steps are the following:
                         1. Each user generates a pair of keys to be used for the encryption and decryption
                            of messages.
                         2. Each user places one of the two keys in a public register or other accessible file.
                            This is the public key. The companion key is kept private. As Figure K.2a sug-
                            gests, each user maintains a collection of public keys obtained from others.




Z16_STAL4290_09_GE_APPK.indd 6                                                                                                             4/18/17 7:33 AM

<!-- pág. 1026 -->

                                       K.3 / MESSAGE AUTHENTICATION AND HASH FUNCTIONS   K-7

                         3. If Bob wishes to send a private message to Alice, Bob encrypts the message
                            using Alice’s public key.
                         4. When Alice receives the message, she decrypts it using her private key. No other
                            recipient can decrypt the message because only Alice knows her own private key.
                            With this approach, all participants have access to public keys, and private keys
                      are generated locally by each participant and therefore need never be distributed. As
                      long as a user protects his or her private key, incoming communication is secure. At
                      any time, a user can change the private key and publish the companion public key to
                      replace the old public key.
                            The key used in symmetric encryption is typically referred to as a secret key.
                      The two keys used for public-key encryption are referred to as the public key and the
                      private key. Invariably, the private key is kept secret, but it is referred to as a private
                      key rather than a secret key to avoid confusion with symmetric encryption.

                      Rivest-Shamir-Adleman (RSA) Algorithm
                      One of the first public-key schemes was developed in 1977 by Ron Rivest, Adi Shamir,
                      and Len Adleman at MIT. The RSA scheme has since that time reigned supreme as
                      the only widely accepted and implemented approach to public-key encryption. RSA
                      is a cipher in which the plaintext and ciphertext are integers between 0 and n - 1 for
                      some n. Encryption involves modular arithmetic. The strength of the algorithm is
                      based on the difficulty of factoring numbers into their prime factors.


               K.3 MESSAGE AUTHENTICATION AND HASH FUNCTIONS

                      Encryption protects against passive attack (eavesdropping). A different requirement
                      is to protect against active attack (falsification of data and transactions). Protection
                      against such attacks is known as message authentication.
                             A message, file, document, or other collection of data is said to be authentic
                      when it is genuine and came from its alleged source. Message authentication is a
                      procedure that allows communicating parties to verify that received messages are
                      authentic. The two important aspects are to verify that the contents of the message
                      have not been altered, and that the source is authentic. We may also wish to verify a
                      message’s timeliness (it has not been artificially delayed and replayed) and sequence
                      relative to other messages flowing between two parties.

                      Authentication Using Symmetric Encryption
                      It is possible to perform authentication simply by the use of symmetric encryption.
                      If we assume only the sender and receiver share a key (which is as it should be), then
                      only the genuine sender would be able successfully to encrypt a message for the other
                      participant. Furthermore, if the message includes an error-detection code and a
                      sequence number, the receiver is assured no alterations have been made and sequenc-
                      ing is proper. If the message also includes a timestamp, the receiver is assured that
                      the message has not been delayed beyond that normally expected for network
                      transit.




Z16_STAL4290_09_GE_APPK.indd 7                                                                                      4/18/17 7:33 AM

<!-- pág. 1027 -->

            K-8   Appendix K / Cryptographic Algorithms

                      Message Authentication without Message Encryption
                      In this section, we examine several approaches to message authentication that do not
                      rely on message encryption. In all of these approaches, an authentication tag is gener-
                      ated and appended to each message for transmission. The message itself is not
                      encrypted and can be read at the destination independent of the authentication func-
                      tion at the destination.
                            Because the approaches discussed in this section do not encrypt the message,
                      message confidentiality is not provided. Because symmetric encryption will provide
                      authentication, and because it is widely used with readily available products, why not
                      simply use such an approach, which provides both confidentiality and authentication?
                      Here are three situations in which message authentication without confidentiality is
                      preferable:

                         1. There are a number of applications in which the same message is broadcast to
                            a number of destinations. An example is the notification to users that the
                            network is now unavailable or an alarm signal in a control center. It is cheaper
                            and more reliable to have only one destination responsible for monitoring
                            authenticity. Thus, the message must be broadcast in plaintext with an associ-
                            ated message authentication tag. The responsible system performs authentica-
                            tion. If a violation occurs, the other destination systems are alerted by a
                            general alarm.
                         2. Another possible scenario is an exchange in which one side has a heavy load
                            and cannot afford the time to decrypt all incoming messages. Authentication
                            is carried out on a selective basis, with messages chosen at random for
                            checking.
                         3. Authentication of a computer program in plaintext is an attractive service. The
                            computer program can be executed without having to decrypt it every time,
                            which would be wasteful of processor resources. However, if a message authen-
                            tication tag were attached to the program, it could be checked whenever assur-
                            ance is required of the integrity of the program.

                           Thus, there is a place for both authentication and encryption in meeting security
                      requirements.


                      Message Authentication Code
                      One authentication technique involves the use of a secret key to generate a small
                      block of data, known as a message authentication code, that is appended to the mes-
                      sage. This technique assumes that two communicating parties, say A and B, share a
                      common secret key KAB. When A has a message M to send to B, it calculates the
                      message authentication code as a function of the message and the key:
                      MAC M = F(KAB, M). The message plus code are transmitted to the intended recipi-
                      ent. The recipient performs the same calculation on the received message, using the
                      same secret key, to generate a new message authentication code. The received code
                      is compared to the calculated code (see Figure K.3). If we assume only the receiver




Z16_STAL4290_09_GE_APPK.indd 8                                                                                  4/18/17 7:33 AM

<!-- pág. 1028 -->

                                          K.3 / MESSAGE AUTHENTICATION AND HASH FUNCTIONS   K-9

                            Message




                                                                                                     K



                                                                                                    MAC
                                                                  Transmit                        algorithm




                                                                                                  Compare


                              MAC
                            algorithm
                                            MAC

                                 K
                         Figure K.3     Message Authentication Using a Message Authentication Code (MAC)


                      and the sender know the identity of the secret key, and if the received code matches
                      the calculated code, then:
                         1. The receiver is assured the message has not been altered. If an attacker alters
                            the message but does not alter the code, then the receiver’s calculation of the
                            code will differ from the received code. Because the attacker is assumed not to
                            know the secret key, the attacker cannot alter the code to correspond to the
                            alterations in the message.
                         2. The receiver is assured the message is from the alleged sender. Because no one
                            else knows the secret key, no one else could prepare a message with a proper
                            code.
                         3. If the message includes a sequence number (such as is used with X.25, HDLC,
                            and TCP), then the receiver can be assured of the proper sequence, because an
                            attacker cannot successfully alter the sequence number.
                            A number of algorithms could be used to generate the code. The National
                      Bureau of Standards, in its publication DES Modes of Operation, recommends the
                      use of DES. DES is used to generate an encrypted version of the message, and the last
                      number of bits of ciphertext are used as the code. A 16- or 32-bit code is typical.
                            The process just described is similar to encryption. One difference is that the
                      authentication algorithm need not be reversible, as it must for decryption. It turns
                      out that because of the mathematical properties of the authentication function, it is
                      less vulnerable to being broken than encryption.




Z16_STAL4290_09_GE_APPK.indd 9                                                                                4/18/17 7:33 AM

<!-- pág. 1029 -->

            K-10   Appendix K / Cryptographic Algorithms

                      One-Way Hash Function
                      A variation on the message authentication code that has received much attention is
                      the one-way hash function. As with the message authentication code, a hash function
                      accepts a variable-size message M as input and produces a fixed-size message digest
                      H(M) as output. Unlike the MAC, a hash function does not also take a secret key as
                      input. To authenticate a message, the message digest is sent with the message in such
                      a way that the message digest is authentic.
                            Figure K.4 illustrates three ways in which the message can be authenticated.
                      The message digest can be encrypted using symmetric encryption (part a); if it is
                      assumed only the sender and receiver share the encryption key, then authenticity is
                      assured. The message digest can also be encrypted using public-key encryption (part
                      b). The public-key approach has two advantages: it provides a digital signature as well
                      as message authentication, and it does not require the distribution of keys to com-
                      municating parties.
                            These two approaches have an advantage over approaches that encrypt the
                      entire message in that less computation is required. Nevertheless, there has been
                      interest in developing a technique that avoids encryption altogether. Several reasons
                      for this interest are as follows:
                            • Encryption software is somewhat slow. Even though the amount of data to be
                              encrypted per message is small, there may be a steady stream of messages into
                              and out of a system.
                            • Encryption hardware costs are nonnegligible. Low-cost chip implementations
                              of DES are available, but the cost adds up if all nodes in a network must have
                              this capability.
                            • Encryption hardware is optimized toward large data sizes. For small blocks of
                              data, a high proportion of the time is spent in initialization/invocation
                              overhead.
                            • Encryption algorithms may be covered by patents and must be licensed, adding
                              a cost.
                            • Encryption algorithms may be subject to export control.
                             Figure K.4c shows a technique that uses a hash function but no encryption for
                      message authentication. This technique assumes that two communicating parties, say
                      A and B, share a common secret value SAB. When A has a message to send to B, it
                      calculates the hash function over the concatenation of the secret value and the mes-
                      sage: MDM = H(SAB   M).1 It then sends [M   MDM] to B. Because B possesses SAB,
                      it can recompute H(SAB   M) and verify MDM. Because the secret value itself is not
                      sent, it is not possible for an attacker to modify an intercepted message. As long as
                      the secret value remains secret, it is also not possible for an attacker to generate a
                      false message.
                             This third technique, using a shared secret value, is the one adopted for IP
                      security; it has also been specified for SNMPv3.

                      1
                            denotes concatenation.




Z16_STAL4290_09_GE_APPK.indd 10                                                                                 4/18/17 7:33 AM

<!-- pág. 1030 -->

                                                                                        K.4 / SECURE HASH FUNCTIONS   K-11




                                   Message                            Message                        Message
                                                                                                                H



                                                                                                                         Compare
                                    H           K                                                                K


                                                E                                                                D
                                                                    (a) Using conventional encryption




                                   Message                            Message                        Message
                                                                                                                H



                                                                                                                         Compare
                                    H        Kprivate                                                          Kpublic


                                                E                                                                D
                                                                     (b) Using public-key encryption
                                                  S                                                      S



                                                Message               Message                        Message
                                                                                                                H



                                                                                                                         Compare
                                    H



                                                                                (c) Using secret value

                                  Figure K.4              Message Authentication Using a One-Way Hash Function




               K.4 SECURE HASH FUNCTIONS

                      An essential element of many security services and applications is a secure hash
                      function. A hash function accepts a variable-size message M as input and pro-
                      duces a fixed-size tag H(M), sometimes called a message digest, as output. For a
                      digital signature, a hash code is generated for a message, encrypted with the
                      sender’s private key, and sent with the message. The receiver computes a new hash
                      code for the incoming message, decrypts the hash code with the sender’s public
                      key and compares. If the message has been altered in transit, there will be a
                      mismatch.




Z16_STAL4290_09_GE_APPK.indd 11                                                                                                    4/18/17 7:33 AM

<!-- pág. 1031 -->

            K-12   Appendix K / Cryptographic Algorithms
                           To be useful for security applications, a hash function H must have the following
                      properties:
                         1. H can be applied to a block of data of any size.
                         2. H produces a fixed-length output.
                         3. H(x) is relatively easy to compute for any given x, making both hardware and
                            software implementations practical.
                         4. For any given value h, it is computationally infeasible to find x such that
                            H(x) = h. This is sometimes referred to in the literature as the one-way
                            property.
                         5. For any given block x, it is computationally infeasible to find y ≠ x such that
                            H(y) = H(x). This is sometimes referred to as weak collision resistance.
                         6. It is computationally infeasible to find any pair (x, y) such that H(x) = H(y).
                            This is sometimes referred to as strong collision resistance.
                            In recent years, the most widely used hash function has been the Secure Hash
                      Algorithm (SHA). SHA was developed by the NIST and published as a federal infor-
                      mation processing standard (FIPS 180) in 1993. When weaknesses were discovered
                      in SHA, a revised version was issued as FIPS 180-1 in 1995 and is generally referred
                      to as SHA-1. SHA-1 produces a hash value of 160 bits. In 2002, NIST produced a
                      revised version of the standard, FIPS 180-2, that defined three new versions of SHA,
                      with hash value lengths of 256, 384, and 512 bits, known as SHA-256, SHA-384, and
                      SHA-512. These new versions have the same underlying structure and use the same
                      types of modular arithmetic and logical binary operations as SHA-1. In 2005, NIST
                      announced the intention to phase out approval of SHA-1 and move to a reliance on
                      the other SHA versions by 2010. Researchers have demonstrated that SHA-1 is far
                      weaker than its 160-bit hash length suggests, necessitating the move to the newer
                      versions of SHA.




Z16_STAL4290_09_GE_APPK.indd 12                                                                                4/18/17 7:33 AM

<!-- pág. 1032 -->

            aPPENDIX l
                                      sTaNDarDs orGaNIZaTIoNs
                       L.1       The Importance of Standards
                       L.2       Standards and Regulation
                       L.3       Standards-Setting Organizations
                                     Internet Standards and the Internet Society
                                     The International Telecommunication Union
                                     IEEE 802 Committee
                                     The International Organization for Standardization




                                                                                          L-1




Z17_STAL4290_09_GE_APPL.indd 1                                                                  4/18/17 7:34 AM

<!-- pág. 1033 -->

            L-2   Appendix L / Standards Organizations
                       An important concept that recurs frequently in this book is standards. This appen-
                       dix provides some background on the nature and relevance of standards and looks
                       at the key organizations involved in developing standards for networking and
                       communications.


               L.1 THE IMPORTANCE OF STANDARDS

                       It has long been accepted in the telecommunications industry that standards are
                       required to govern the physical, electrical, and procedural characteristics of commu-
                       nication equipment. In the past, this view has not been embraced by the computer
                       industry. Whereas communication equipment vendors recognize that their equipment
                       will generally interface to and communicate with other vendors’ equipment, com-
                       puter vendors have traditionally attempted to monopolize their customers. The pro-
                       liferation of computers and distributed processing has made that an untenable
                       position. Computers from different vendors must communicate with each other and,
                       with the ongoing evolution of protocol standards, customers will no longer accept
                       special-purpose protocol conversion software development. The result is that stan-
                       dards now permeate all the areas of technology discussed in this book.
                             There are a number of advantages and disadvantages to the standards-making
                       process. The principal advantages of standards are:
                           • A standard assures there will be a large market for a particular piece of equip-
                             ment or software. This encourages mass production and, in some cases, the use
                             of large-scale-integration (LSI) or very-large-scale-integration (VLSI) tech-
                             niques, resulting in lower costs.
                           • A standard allows products from multiple vendors to communicate, giving the
                             purchaser more flexibility in equipment selection and use.
                             The principal disadvantages of standards are:
                           • A standard tends to freeze the technology. By the time a standard is developed,
                             subjected to review and compromise, and promulgated, more efficient tech-
                             niques are possible.
                           • There are multiple standards for the same thing. This is not a disadvantage of
                             standards per se, but of the current way things are done. Fortunately, in recent
                             years the various standards-making organizations have begun to cooperate
                             more closely. Nevertheless, there are still areas where multiple conflicting stan-
                             dards exist.


               L.2 STANDARDS AND REGULATION

                       It is helpful for the reader to distinguish three concepts:
                           • Voluntary standards
                           • Regulatory standards
                           • Regulatory use of voluntary standards




Z17_STAL4290_09_GE_APPL.indd 2                                                                                    4/18/17 7:34 AM

<!-- pág. 1034 -->

                                                      L.3 / STANDARDS-SETTING ORGANIZATIONS   L-3

                              Voluntary standards are developed by standards-making organizations, such as
                       those described in the next section. They are voluntary in that the existence of the
                       standard does not compel its use. That is, manufacturers voluntarily implement a prod-
                       uct that conforms to a standard if they perceive a benefit to themselves; there is no
                       legal requirement to conform. These standards are also voluntary in the sense that they
                       are developed by volunteers who are not paid for their efforts by the standards-making
                       organization that administers the process. These volunteers are generally employees
                       of interested organizations, such as manufacturers and government agencies.
                              Voluntary standards work because they are generally developed on the basis
                       of broad consensus, and because the customer demand for standard products encour-
                       ages the implementation of these standards by the vendors.
                              In contrast, a regulatory standard is developed by a government regulatory
                       agency to meet some public objective, such as economic, health, and safety objectives.
                       These standards have the force of regulation behind them and must be met by provid-
                       ers in the context in which the regulations apply. Familiar examples of regulatory
                       standards are in areas such as fire codes and health codes. But regulations can apply
                       to a wide variety of products, including those related to computers and communica-
                       tions. For example, the Federal Communications Commission regulates electromag-
                       netic emissions.
                              A relatively new, or at least newly prevalent, phenomenon is the regulatory use
                       of voluntary standards. A typical example of this is a regulation that requires that the
                       government purchase of a product be limited to those that conform to some refer-
                       enced set of voluntary standards. This approach has a number of benefits:
                           • It reduces the rule-making burden on government agencies.
                           • It encourages cooperation between government and standards organizations
                             to produce standards of broad applicability.
                           • It reduces the variety of standards that providers must meet.


               L.3 STANDARDS-SETTING ORGANIZATIONS

                       Various organizations have been involved in the development of standards related
                       to data and computer communications. The remainder of this document provides an
                       overview of some of the most important of these organizations:
                           • Internet Society
                           • ITU
                           • IEEE 802
                           • ISO

                       Internet Standards and the Internet Society
                       Many of the protocols that make up the TCP/IP protocol suite have been standard-
                       ized or are in the process of standardization. By universal agreement, an organization
                       known as the Internet Society is responsible for the development and publication of
                       these standards. The Internet Society is a professional membership organization that




Z17_STAL4290_09_GE_APPL.indd 3                                                                                    4/18/17 7:34 AM

<!-- pág. 1035 -->

            L-4   Appendix L / Standards Organizations
                       oversees a number of boards and task forces involved in Internet development and
                       standardization.
                            This section provides a brief description of the way in which standards for the
                       TCP/IP protocol suite are developed.

                       The Internet Organizations and RFC Publication The Internet Society is
                       the coordinating committee for Internet design, engineering, and management. Areas
                       covered include the operation of the Internet itself and the standardization of
                       protocols used by end systems on the Internet for interoperability. Three organizations
                       under the Internet Society are responsible for the actual work of standards
                       development and publication:
                           • Internet Architecture Board (IAB): Responsible for defining the overall archi-
                             tecture of the Internet, providing guidance and broad direction to the IETF
                           • Internet Engineering Task Force (IETF): The protocol engineering and devel-
                             opment arm of the Internet
                           • Internet Engineering Steering Group (IESG): Responsible for technical man-
                             agement of IETF activities and the Internet standards process
                             Working groups chartered by the IETF carry out the actual development of
                       new standards and protocols for the Internet. Membership in a working group is
                       voluntary; any interested party may participate. During the development of a speci-
                       fication, a working group will make a draft version of the document available as an
                       Internet Draft, which is placed in the IETF’s “Internet Drafts” online directory. The
                       document may remain as an Internet Draft for up to six months, and interested
                       parties may review and comment on the draft. During that time, the IESG may
                       approve publication of the draft as an RFC (Request for Comment). If the draft
                       has not progressed to the status of an RFC during the six-month period, it is with-
                       drawn from the directory. The working group may subsequently publish a revised
                       version of the draft.
                             The IETF is responsible for publishing the RFCs, with approval of the IESG.
                       The RFCs are the working notes of the Internet research and development commu-
                       nity. A document in this series may be on essentially any topic related to computer
                       communications and may be anything from a meeting report to the specification of
                       a standard.
                             The work of the IETF is divided into eight areas, each with an area director and
                       each composed of numerous working groups. Table L.1 shows the IETF areas and
                       their focus.

                       The Standardization Process The decision of which RFCs become Internet
                       standards is made by the IESG, on the recommendation of the IETF. To become a
                       standard, a specification must meet the following criteria:
                           • Be stable and well understood
                           • Be technically competent
                           • Have multiple, independent, and interoperable implementations with substan-
                             tial operational experience




Z17_STAL4290_09_GE_APPL.indd 4                                                                                   4/18/17 7:34 AM

<!-- pág. 1036 -->

                                                          L.3 / STANDARDS-SETTING ORGANIZATIONS   L-5

            Table L.1      IETF Areas

              IETF Area                       Theme                                  Example Working Groups
              Applications                    Internet applications                  Web-related protocols (HTTP)
                                                                                     EDI-Internet integration
                                                                                     LDAP
              General                         IETF processes and procedures          Policy Framework
                                                                                     Process for Organization of
                                                                                     Internet Standards
              Internet                        Internet infrastructure                IPv6
                                                                                     PPP extensions
              Operations and management       Standards and definitions for net-     SNMPv3
                                              work operations                        Remote Network Monitoring
              Real-time applications and      Protocols and applications for real-   Real-time Transport Protocol (RTP)
              infrastructure                  time requirements                      Session Initiation Protocol (SIP)
              Routing                         Protocols and management for           Multicast routing
                                              routing information                    OSPF
                                                                                     QoS routing
              Security                        Security protocols and                 Kerberos
                                              technologies                           IPSec
                                                                                     X.509
                                                                                     S/MIME
                                                                                     TLS
              Transport                       Transport layer protocols              Differentiated services
                                                                                     IP telephony
                                                                                     NFS
                                                                                     RSVP




                            • Enjoy significant public support
                            • Be recognizably useful in some or all parts of the Internet
                                The key difference between these criteria and those used for international stan-
                         dards from ITU is the emphasis here on operational experience.
                                The left-hand side of Figure L.1 shows the series of steps, called the standards
                         track, that a specification goes through to become a standard; this process is defined
                         in RFC 2026. The steps involve increasing amounts of scrutiny and testing. At each
                         step, the IETF must make a recommendation for advancement of the protocol, and
                         the IESG must ratify it. The process begins when the IESG approves the publica-
                         tion of an Internet Draft document as an RFC with the status of Proposed
                         Standard.
                                The white boxes in the diagram represent temporary states, which should be
                         occupied for the minimum practical time. However, a document must remain a Pro-
                         posed Standard for at least six months and a Draft Standard for at least four months
                         to allow time for review and comment. The shaded boxes represent long-term states
                         that may be occupied for years.




Z17_STAL4290_09_GE_APPL.indd 5                                                                                            4/18/17 7:34 AM

<!-- pág. 1037 -->

            L-6   Appendix L / Standards Organizations

                                                                  Internet
                                                                   Draft



                                       Proposed        Best Current
                                                                             Experimental   Informational
                                       Standard          Practice




                                         Draft
                                       Standard




                                       Internet
                                       Standard



                                                                      Historic


                                   Figure L.1     Internet RFC Publication Process



                              For a specification to be advanced to Draft Standard status, there must be at
                       least two independent and interoperable implementations from which adequate
                       operational experience has been obtained.
                              After significant implementation and operational experience has been obtained,
                       a specification may be elevated to Internet Standard. At this point, the Specification
                       is assigned an STD number as well as an RFC number.
                              Finally, when a protocol becomes obsolete, it is assigned to the Historic state.

                       Internet Standards Categories All Internet standards fall into one of the two
                       categories:
                           • Technical specification (TS): A TS defines a protocol, service, procedure, con-
                             vention, or format. The bulk of the Internet standards are TSs.
                           • Applicability statement (AS): An AS specifies how, and under what circum-
                             stances, one or more TSs may be applied to support a particular Internet capa-
                             bility. An AS identifies one or more TSs that are relevant to the capability, and
                             may specify values or ranges for particular parameters associated with a TS or
                             functional subsets of a TS that are relevant for the capability.

                       Other RFC Types There are numerous RFCs that are not destined to become
                       Internet standards. Some RFCs standardize the results of community deliberations
                       about statements of principle or conclusions about what is the best way to perform
                       some operations or IETF process function. Such RFCs are designated as Best
                       Current Practice (BCP). Approval of BCPs follows essentially the same process for
                       approval of Proposed Standards. Unlike standards-track documents, there is not a




Z17_STAL4290_09_GE_APPL.indd 6                                                                                   4/18/17 7:34 AM

<!-- pág. 1038 -->

                                                      L.3 / STANDARDS-SETTING ORGANIZATIONS   L-7

                       three-stage process for BCPs; a BCP goes from Internet draft status to approved BCP
                       in one step.
                             A protocol or other specification that is not considered ready for standardiza-
                       tion may be published as an Experimental RFC. After further work, the specification
                       may be resubmitted. If the specification is generally stable, has resolved known design
                       choices, is believed to be well understood, has received significant community review,
                       and appears to enjoy enough community interest to be considered valuable, then the
                       RFC will be designated a Proposed Standard.
                             Finally, an Informational Specification is published for the general information
                       of the Internet community.


                       The International Telecommunication Union
                       The International Telecommunication Union (ITU) is a United Nations specialized
                       agency. Hence the members of ITU-T are governments. The U.S. representation is
                       housed in the Department of State. The charter of the ITU is that it “is responsible
                       for studying technical, operating, and tariff questions and issuing Recommendations
                       on them with a view to standardizing telecommunications on a worldwide basis.” Its
                       primary objective is to standardize, to the extent necessary, techniques and opera-
                       tions in telecommunications to achieve end-to-end compatibility of international
                       telecommunication connections, regardless of the countries of origin and
                       destination.

                       ITU Radio Communication Sector The ITU Radiocommunication (ITU-R)
                       Sector was created on March 1, 1993 and comprises the former CCIR and IFRB
                       (founded 1927 and 1947, respectively). ITU-R is responsible for all ITU’s work in the
                       field of radio communications. The main activities of ITU-R are:
                           • Develop draft ITU-R Recommendations on the technical characteristics of,
                             and operational procedures for, radiocommunication services and systems.
                           • Compile Handbooks on spectrum management and emerging radiocommuni-
                             cation services and systems.
                             ITU-R is organized into the following study groups:
                           • SG 1 Spectrum management
                           • SG 3 Radiowave propagation
                           • SG 4 Fixed-satellite service
                           • SG 6 Broadcasting service (terrestrial and satellite)
                           • SG 7 Science services
                           • SG 8 Mobile, radiodetermination, amateur and related satellite services
                           • SG 9 Fixed service
                           • SC Special Committee on Regulatory/Procedural Matters
                           • CCV Coordination Committee for Vocabulary
                           • CPM Conference Preparatory Meeting




Z17_STAL4290_09_GE_APPL.indd 7                                                                                   4/18/17 7:34 AM

<!-- pág. 1039 -->

            L-8   Appendix L / Standards Organizations
                       ITU Telecommunication Standardization Sector The ITU-T was created on
                       March 1, 1993 as one consequence of a reform process within the ITU. It replaces the
                       International Telegraph and Telephone Consultative Committee (CCITT), which had
                       essentially the same charter and objectives as the new ITU-T. The ITU-T fulfills the
                       purposes of the ITU relating to telecommunications standardization by studying
                       technical, operating and tariff questions, and adopting Recommendations on them
                       with a view to standardizing telecommunications on a worldwide basis.
                             ITU-T is organized into 13 study groups that prepare Recommendations, num-
                       bered as follows:
                            1.  Network and service operation
                            2.  Tariff and accounting principles
                            3.  Telecommunications management network and network maintenance
                            4.  Protection against electromagnetic environment effects
                            5. Outside plant
                            6.	Integrated broadband cable networks and television and sound transmission
                            7. Signaling requirements and protocols
                            8. Performance and quality of service
                            9. Next generation networks
                            10. Optical and other transport networks infrastructures
                            11. Multimedia terminals, systems, and applications
                            12. Security, languages, and telecommunication software
                            13. Mobile telecommunications networks

                       Schedule Work within ITU-R and ITU-T is conducted in four-year cycles. Every
                       four years, a World Telecommunications Standardization Conference is held. The
                       work program for the next four years is established at the assembly in the form of
                       questions submitted by the various study groups, based on requests made to the study
                       groups by their members. The conference assesses the questions, reviews the scope
                       of the study groups, creates new or abolishes existing study groups, and allocates
                       questions to them.
                             Based on these questions, each study group prepares draft Recommendations.
                       A draft Recommendation may be submitted to the next conference, four years hence,
                       for approval. Increasingly, however, Recommendations are approved when they are
                       ready, without having to wait for the end of the four-year study period. This acceler-
                       ated procedure was adopted after the study period that ended in 1988. Thus, 1988 was
                       the last time that a large batch of documents was published at one time as a set of
                       Recommendations.

                       IEEE 802 Committee
                       The key to the development of the LAN market is the availability of a low-cost inter-
                       face. The cost to connect equipment to a LAN must be much less than the cost of the
                       equipment alone. This requirement, plus the complexity of the LAN logic, dictates a




Z17_STAL4290_09_GE_APPL.indd 8                                                                                  4/18/17 7:34 AM

<!-- pág. 1040 -->

                                                            L.3 / STANDARDS-SETTING ORGANIZATIONS   L-9

                       solution based on the use of chips and very-large-scale integration (VLSI). However,
                       chip manufacturers will be reluctant to commit the necessary resources unless there
                       is a high-volume market. A widely accepted LAN standard assures volume and also
                       enables equipment from a variety of manufacturers to intercommunicate. This is the
                       rationale of the IEEE 802 committee.
                              The committee issued a set of standards, which were adopted in 1985 by the
                       American National Standards Institute (ANSI) as American National Standards.
                       The standards were subsequently revised and reissued as international standards
                       by the International Organization for Standardization (ISO) in 1987, with the designa-
                       tion ISO 8802. Since then, the IEEE 802 committee has continued to revise and
                       extend the standards, which are ultimately then adopted by ISO.
                              The committee quickly reached two conclusions. First, the task of communica-
                       tion across the local network is sufficiently complex that it needs to be broken up into
                       more manageable subtasks. Accordingly, the standards are organized as a three-layer
                       protocol hierarchy: Logical Link Control (LLC), medium access control (MAC), and
                       physical.
                              Second, no single technical approach will satisfy all requirements. The second
                       conclusion was reluctantly reached when it became apparent that no single standard
                       would satisfy all committee participants. There was support for various topologies,
                       access methods, and transmission media. The response of the committee was to stan-
                       dardize all serious proposals rather than to attempt to settle on just one. The current
                       state of standardization is reflected by the various working groups in IEEE 802 and
                       the work that each is doing (see Table L.2).

                       The International Organization for Standardization
                       The International Organization for Standardization, or ISO,1 is an international
                       agency for the development of standards on a wide range of subjects. It is a voluntary,
                       nontreaty organization whose members are designated standards bodies of partici-
                       pating nations, plus nonvoting observer organizations. Although ISO is not a govern-
                       mental body, more than 70% of ISO member bodies are governmental standards
                       institutions or organizations incorporated by public law. Most of the remainder have
                       close links with the public administrations in their own countries. The U.S. member
                       body is the American National Standards Institute.
                             ISO was founded in 1946 and has issued more than 12,000 standards in a broad
                       range of areas. Its purpose is to promote the development of standardization and
                       related activities to facilitate international exchange of goods and services and to
                       develop cooperation in the sphere of intellectual, scientific, technological, and eco-
                       nomic activity. Standards have been issued to cover everything from screw threads
                       to solar energy. One important area of standardization deals with the Open Systems
                       Interconnection (OSI) communications architecture and the standards at each layer
                       of the OSI architecture.



                       1
                        ISO is not an acronym (in which case it would be IOS), but a word, derived from the Greek isos, meaning
                       “equal.”




Z17_STAL4290_09_GE_APPL.indd 9                                                                                                    4/18/17 7:34 AM

<!-- pág. 1041 -->

            L-10   Appendix L / Standards Organizations
            Table L.2     IEEE 802 Active Working Groups

              Number          Name                           Charter
              802.1           Higher Layer LAN Protocols     Standards and recommended practices for: 802 LAN/
                                                             MAN architecture, Internet working among 802 LANs,
                                                             MANs, and other wide area networks, 802 overall net-
                                                             work management, and protocol layers above the MAC
                                                             and LLC layers
              802.3           Ethernet                       Standards for CSMA/CD (Ethernet) based LANs
              802.11          Wireless LAN                   Standards for wireless LANs
              802.15          Wireless Personal Area         Personal area network standards for short distance wire-
                              Networks                       less networks
              802.16          Broadband Wireless Access      Standards for broadband wireless access
              802.17          Resilient Packet Ring          Standards for RPR LAN/MAN for rates up to many
                                                             gigabits per second
              802.18          Radio Regulatory TAG           Monitor regulations that may affect 802.11, 802.15, and
                                                             802.16
              802.19          Coexistence TAG                Standards for coexistence between wireless standards of
                                                             unlicensed devices.
              802.20          Mobile Broadband Wireless      Standards for mobile broadband wireless access
                              Access
              802.21          Media Independent Handoff      Standards to enable handover and interoperability
                                                             between heterogeneous network types including both
                                                             802 and non-802 networks
              802.22          Wireless Regional Area         Standards for regional wireless networks using unused
                              Networks                       frequencies in the broadcast television band
              82.23           Emergency Services             Media independent framework to provide consistent
                                                             access and data that facilitate compliance to applicable
                                                             civil authority requirements for communications systems
                                                             that include IEEE 802 networks.



                             In the areas of data communications and networking, ISO standards are actu-
                       ally developed in a joint effort with another standards body, the International Elec-
                       trotechnical Commission (IEC). IEC is primarily concerned with electrical and
                       electronic engineering standards. In the area of information technology, the interests
                       of the two groups overlap, with IEC emphasizing hardware and ISO focusing on
                       software. In 1987, the two groups formed the Joint Technical Committee 1 (JTC 1).
                       This committee has the responsibility of developing the documents that ultimately
                       become ISO (and IEC) standards in the area of information technology.
                             The development of an ISO standard from first proposal to actual publication
                       of the standard follows a six-step process. The objective is to ensure the final result is
                       acceptable to as many countries as possible. Briefly, the steps are:
                          1. Proposal stage: A new work item is assigned to the appropriate technical com-
                             mittee, and within that technical committee, to the appropriate working group.
                          2. Preparatory stage: The working group prepares a working draft. Successive
                             working drafts may be considered until the working group is satisfied that it has




Z17_STAL4290_09_GE_APPL.indd 10                                                                                         4/18/17 7:34 AM

<!-- pág. 1042 -->

                                                     L.3 / STANDARDS-SETTING ORGANIZATIONS   L-11

                             developed the best technical solution to the problem being addressed. At this
                             stage, the draft is forwarded to the working group’s parent committee for the
                             consensus-building phase.
                          3. Committee stage: As soon as a first committee draft is available, it is registered
                             by the ISO Central Secretariat. It is distributed among interested members for
                             balloting and technical comment. Successive committee drafts may be consid-
                             ered until consensus is reached on the technical content. Once consensus has
                             been attained, the text is finalized for submission as a Draft International Stan-
                             dard (DIS).
                          4. Enquiry stage: The DIS is circulated to all ISO member bodies by the ISO
                             Central Secretariat for voting and commenting within a period of five months.
                             It is approved for submission as a Final Draft International Standard (FDIS) if
                             a two-thirds majority is in favor and not more than one-quarter of the total
                             number of votes cast are negative. If the approval criteria are not met, the text
                             is returned to the originating working group for further study, and a revised
                             document will again be circulated for voting and comment as a DIS.
                          5. Approval stage: The Final Draft International Standard (FDIS) is circulated to
                             all ISO member bodies by the ISO Central Secretariat for a final yes/no vote
                             within a period of two months. If technical comments are received during this
                             period, they are no longer considered at this stage, but registered for consider-
                             ation during a future revision of the International Standard. The text is approved
                             as an International Standard if a two-thirds majority is in favor and not more
                             than one-quarter of the total number of votes cast are negative. If these approval
                             criteria are not met, the standard is referred back to the originating working
                             group for reconsideration in the light of the technical reasons submitted in sup-
                             port of the negative votes received.
                          6. Publication stage: Once a FDIS has been approved, only minor editorial
                             changes, if and where necessary, are introduced into the final text. The final text
                             is sent to the ISO Central Secretariat, which publishes the International
                             Standard.
                             The process of issuing an ISO standard can be a slow one. Certainly, it would
                       be desirable to issue standards as quickly as the technical details can be worked out,
                       but ISO must ensure the standard will receive widespread support.




Z17_STAL4290_09_GE_APPL.indd 11                                                                                    4/18/17 7:34 AM

<!-- pág. 1043 -->

            aPPENDIX M
                    soCKETs: a ProGrammEr’s INTroDUCTIoN
                      M.1        Sockets, Socket Descriptors, Ports, and Connections
                      M.2        The Client/Server Model of Communication
                                     Running a Sockets Program on a Windows Machine Not Connected to
                                          a Network
                                     Running a Sockets Program on a Windows Machine Connected to a
                                          Network, When Both Server and Client Reside on the Same
                                          Machine
                      M.3        Sockets Elements
                                     Socket Creation
                                     The Socket Address
                                     Bind to a Local Port
                                     Data Representation and Byte Ordering
                                     Connecting a Socket
                                     The gethostbyname()Function Call
                                     Listening for an Incoming Client Connection
                                     Accepting a Connection from a Client
                                     Sending and Receiving Messages on a Socket
                                     Closing a Socket
                                     Report errors
                                     Example TCP/IP Client Program (Initiating Connection)
                                     Example TCP/IP Server Program (Passively Awaiting Connection)
                      M.4        Stream and Datagram Sockets
                                      Example UDP Client Program (Initiate Connections)
                                      Example UDP Server Program (Passively Await Connection)
                      M.5        Run-Time Program Control
                                     Nonblocking Socket Calls
                                     Asynchronous I/O (Signal Driven I/O)
                      M.6        Remote Execution of a Windows Console Application
                                    Local Code
                                    Remote Code




                                                                                                 M-1




Z18_STAL4290_09_GE_APPM.indd 1                                                                         4/18/17 7:34 AM

<!-- pág. 1044 -->

            M-2   Appendix M / Sockets: A Programmer’s Introduction
                      The concept of sockets and sockets programming was developed in the 1980s in the
                      Unix environment as the Berkeley Sockets Interface. In essence, a socket enables
                      communications between a client and server process and may be either connection-
                      oriented or connectionless. A socket can be considered an endpoint in a communi-
                      cation. A client socket in one computer uses an address to call a server socket on
                      another computer. Once the appropriate sockets are engaged, the two computers
                      can exchange data.
                             Typically, computers with server sockets keep a TCP or UDP port open, ready
                      for unscheduled incoming calls. The client typically determines the socket identifica-
                      tion of the desired server by finding it in a Domain Name System (DNS) database.
                      Once a connection is made, the server switches the dialogue to a different port num-
                      ber to free up the main port number for additional incoming calls.
                             Internet applications, such as TELNET and remote login (rlogin) make use of
                      sockets, with the details hidden from the user. However, sockets can be constructed
                      from within a program (in a language such as C or Java), enabling the programmer
                      to easily support networking functions and applications. The sockets programming
                      mechanism includes sufficient semantics to permit unrelated processes on different
                      hosts to communicate.
                             The Berkeley Sockets Interface is the de facto standard application program-
                      ming interface (API) for developing networking applications, spanning a wide range
                      of operating systems. The sockets API provides generic access to interprocess com-
                      munications services. Thus, the sockets capability is ideally suited for students to
                      learn the principles of protocols and distributed applications by hands-on program
                      development.
                             The Sockets Application Program Interface (API) provides a library of func-
                      tions that programmers can use to develop network aware applications. It has the
                      functionality of identifying endpoints of the connection, establishing the communica-
                      tion, allowing messages to be sent, waiting for incoming messages, terminating the
                      communication, and error handling. The operating system used and the programming
                      language both determine the specific Sockets API.
                             We concentrate on only two of the most widely used interfaces—the Berkley
                      Software Distribution Sockets (BSD) as introduced for UNIX, and its slight modifi-
                      cation the Windows Sockets (WinSock) API from Microsoft.
                             This sockets material is intended for the C language programmer. (It pro-
                      vides external references for the C + +, Visual Basic, and PASCAL languages.) The
                      Windows operating system is in the center of our discussion. At the same time, topics
                      from the original BSD UNIX specification are introduced in order to point out (usu-
                      ally minor) differences in the sockets specifications for the two operating systems.
                      Basic knowledge of the TCP/IP and UDP network protocols is assumed. Most of the
                      code would compile on both Windows and UNIX-like systems.
                             We cover C language sockets exclusively, but most other programming lan-
                      guages, such as C + +, Visual Basic, and PASCAL, can take advantage of the Winsock
                      API, as well. The only requirement is that the language has to recognize dynamic
                      link libraries (DLLs). In a 32-bit Windows environment, you will need to import the
                      wsock32.lib to take advantage of the WinSock API. This library has to be linked,
                      so at run time the dynamic link library wsock32.dll gets loaded. wsock32.dll
                      runs over the TCP/IP stack. Windows NT, Windows 2000, and Windows 95 i­nclude




Z18_STAL4290_09_GE_APPM.indd 2                                                                                 4/18/17 7:34 AM

<!-- pág. 1045 -->

                            M.1 / SOCKETS, SOCKET DESCRIPTORS, PORTS, AND CONNECTIONS   M-3

                      the file wsock32.dll by default. When you create your executables, if you link with
                      wsock32.lib library, you will implicitly link the wsock32.dll at run time, without
                      adding lines of code to your source file.
                             The website for this book provides links to useful Sockets websites.


               M.1 SOCKETS, SOCKET DESCRIPTORS, PORTS,
                   AND CONNECTIONS

                      Sockets are endpoints of communication referred to by their corresponding socket
                      descriptors, or natural language words describing the socket’s association with a par-
                      ticular machine or application (e.g., we will refer to a server socket as server_s). A
                      connection (or socket pair) consists of the pair of IP addresses that are communicat-
                      ing with each other, as well a pair of port numbers, where a port number is a 32-bit
                      positive integer usually denoted in its decimal form. Some destination port numbers
                      are well known and indicate the type of service being connected to.
                            For many applications, the TCP/IP environment expects that applications use
                      well-known ports to communicate with each other. This is done so client applications
                      assume the corresponding server application is listening on the well-known port
                      associated with that application. For example, the port number for HTTP, the proto-
                      col used to transfer HTML pages across the World Wide Web, is TCP port 80. By
                      default, a Web browser will attempt to open a connection on the destination host’s
                      TCP port 80 unless another port number is specified in the URL (such as 8000
                      or 8080).
                            A port identifies a connection point in the local stack (i.e., port number 80 is
                      typically used by a Web server). A socket identifies an IP address and port number
                      pair (i.e., port 192.168.1.20:80 would be the Web server port 80 on host 192.168.1.20.
                      The two together are considered a socket.). A socket pair identifies all four compo-
                      nents (source address and port, and destination address and port). Since well-known
                      ports are unique, they are sometimes used to refer to a specific application on any
                      host that might be running the application. Using the word socket, however, would
                      imply a specific application on some specific host. Connection, or a socket pair, stands
                      for the sockets connection between two specific systems that are communicating. TCP
                      allows multiple simultaneous connections involving the same local port number as
                      long as the remote IP addresses or port numbers are different for each connection.
                            Port numbers are divided into three ranges:
                          • Ports 0 through 1023 are well known. They are associated with services in a
                            static manner. For example, HTTP servers would always accept requests at
                            port 80.
                          • Port numbers from 1024 through 49151 are registered. They are used for mul-
                            tiple purposes.
                          • Dynamic and private ports are those from 49152 through 65535 and services
                            should not be associated with them.
                           In reality, machines start assigning dynamic ports starting at 1024. If you are
                      developing a protocol or application that will require the use of a link, socket, port,




Z18_STAL4290_09_GE_APPM.indd 3                                                                                   4/18/17 7:34 AM

<!-- pág. 1046 -->

            M-4   Appendix M / Sockets: A Programmer’s Introduction

              Proto               Local Address           Foreign Address           State
              TCP                 Mycomp:1025             Mycomp:0                  LISTENING
              TCP                 Mycomp:1026             Mycomp:0                  LISTENING
              TCP                 Mycomp:6666             Mycomp:0                  LISTENING
              TCP                 Mycomp:6667             Mycomp:0                  LISTENING
              TCP                 Mycomp:1234             mycomp:1234               TIME_WAIT
              TCP                 Mycomp:1025             2hfc327.any.com:6667      ESTABLISHED
              TCP                 Mycomp:1026             46c311.any.com:6668       ESTABLISHED
              UDP                 Mycomp:6667             *.*

            Figure M.1     Sample Netstat Output




                      protocol, etc., please contact the Internet Assigned Numbers Authority (IANA) to
                      receive a port number assignment. The IANA is located at and operated by the
                      Information Sciences Institute (ISI) of the University of Southern California. The
                      Assigned Numbers request for comments (RFC) published by IANA is the official
                      specification that lists port assignments. You can access it at http://www.iana
                      .org/assignments/port-numbers.
                            On both UNIX and Windows, the netstat command can be used to check the
                      status of all active local sockets. Figure M.1 is a sample netstat output.



               M.2 THE CLIENT/SERVER MODEL OF COMMUNICATION

                      A socket application consists of code, executed on both communication ends. The
                      program initiating transmission is often referred to as the client. The server, on the
                      other hand, is a program that passively awaits incoming connections from remote
                      clients. Server applications typically load during system startup and actively listen
                      for incoming connections on their well-known port. Client applications will then
                      attempt to connect to the server, and a TCP exchange will then take place. When the
                      session is complete, usually the client will be the one to terminate the connection.
                      Figure M.2 depicts the basic model of stream-based (or TCP/IP sockets)
                      communication.

                      Running a Sockets Program on a Windows Machine Not
                      Connected to a Network
                      As long as TCP/IP is installed on one machine, you can execute both the server and
                      client code on it. (If you do not have the TCP/IP protocol stack installed, you can
                      expect socket operations to throw exceptions such as BindException, Connect-
                      Exception, ProtocolException, SocketException, etc. ) You will have to
                      use localhost as the hostname or 127.0.0.1 as the IP address.




Z18_STAL4290_09_GE_APPM.indd 4                                                                                 4/18/17 7:34 AM

<!-- pág. 1047 -->

                                             M.2 / THE CLIENT/SERVER MODEL OF COMMUNICATION   M-5




                                  Server                                                       Client
                                 socket()                                                Open communication
                                                                                         endpoint

                                  bind()                                                 Register well-known
                                                                                         address with system


                                  listen()                                               Establish client's connection;
                                                                                         request queue size


                                 accept()                                                Accept first client connection
                                                                                         request on the queue

                               blocks until                                              Open communication
                                                                             socket()
                          connection from client                                         endpoint


                                                              connection
                     accept() creates a new socket to        establishment               Set up connection
                                                                             connect()
                       serve the new client request                                      to server


                                                        data (request)
                                 receive()                                    send()     Send/receive data


                             process request


                                                         data (reply)
                                  send()                                     receive()   Send/receive data



                                  close()                                     close()    Shutdown

                    Figure M.2       Socket System Calls for Connection-Oriented Protocol




                      Running a Sockets Program on a Windows Machine
                      Connected to a Network, When Both Server and Client
                      Reside on the Same Machine
                      In such a case, you will be communicating with yourself. It is important to know
                      whether your machine is attached to an Ethernet or communicates with the network
                      through a telephone modem. In the first case, you will have an IP address assigned




Z18_STAL4290_09_GE_APPM.indd 5                                                                                            4/18/17 7:34 AM

<!-- pág. 1048 -->

            M-6   Appendix M / Sockets: A Programmer’s Introduction
                      to your machine, without efforts on your part. When communicating via a modem,
                      you need to dial in, grab an IP address, and then be able to “talk to yourself.” In both
                      cases you can find out the IP address of the machine you are using with the winip-
                      cfg command for Win9X, and ipconfig for WinNT/2K and UNIX.


               M.3 SOCKETS ELEMENTS

                      Socket Creation
                             #include <sys/types.h>
                             #include <sys/socket.h>

                             int socket(int        domain, int        type, int       protocol)

                          • domain is AF_UNIX, AF_INET, AF_OSI, etc. AF_INET is for communica-
                            tion on the Internet to IP addresses. We will only use AF_INET.
                          • type is either SOCK_STREAM (TCP, connection-oriented, reliable), or SOCK_
                            DGRAM (UDP, datagram, unreliable), or SOCK_RAW (IP level).
                          • protocol specifies the protocol used. It is usually 0 to say we want to use the
                            default protocol for the chosen domain and type. We always use 0.
                      If successful, socket() returns a socket descriptor, which is an integer, and -1 in
                      the case of a failure. An example call:

                             if ((sd = socket(AF_INET, SOCK_DGRAM, 0) < 0)
                               {
                                    printf(socket() failed.);
                                 exit(1);
                               }

                      The Socket Address
                      The structures to store socket addresses as used in the domain AF_INET:

                             struct in_addr {
                                unsigned long s_addr;
                             };

                      in_addr just provides a name (s_addr) for the C language type to be associated
                      with IP addresses.

                             struct sockaddr_in {
                              unsigned short   sin_family; // AF_INET identifiers
                              unsigned short   sin_port;   // port number,
                                                           // if 0 then kernel chosen
                             struct in_addr sin_addr;      // IP address




Z18_STAL4290_09_GE_APPM.indd 6                                                                                   4/18/17 7:34 AM

<!-- pág. 1049 -->

                                                                       M.3 / SOCKETS ELEMENTS   M-7

                                                             // INADDR_ANY refers to the IP
                                                             // addresses of the current host
                              char    sin_zero[8];           // Unused, always zero
                             };

                      Both local and remote addresses will be declared as a sockaddr_in structure.
                      Depending on this declaration, sin_addr will represent a local or remote IP address.
                      (On a UNIX like system, you need to include the file <netinet/in.h> for both
                      structures.)

                      Bind to a Local Port
                             #define WIN   // WIN for Winsock and BSD for BSD sockets
                             #ifdef WIN
                              . . .
                             #include <windows.h> // for all Winsock functions
                              . . .
                             #endif
                             #ifdef BSD
                              . . .
                             #include <sys/types.h>
                             #include <sys/socket.h> // for struct sockaddr
                              . . .
                             #endif
                             int bind(int local_s, const struct sockaddr *addr,
                             int addrlen);
                          • local_s is a socket descriptor of the local socket, as created by the
                            socket()function;
                          • addr is a pointer to the (local) address structure of this socket;
                          • addrlen is the length (in bytes) of the structure referenced by addr.
                      bind() returns the integer 0 on success, and -1 on failure. After a call to bind(),
                      a local port number is associated with the socket, but no remote destination is yet
                      specified.
                            An example call:

                             struct sockaddr_in name;
                             ...
                             name.sin_family = AF_INET;   // use the Internet domain
                             name.sin_port = htons(0);    // kernel provides a port
                             name.sin_addr.s_addr = htonl(INADDR_ANY); // use all IPs
                                                                          of host
                             if (bind(local_socket, (struct sockaddr *)&name,
                                 sizeof(name)) != 0)
                                                          // print error and exit




Z18_STAL4290_09_GE_APPM.indd 7                                                                               4/18/17 7:34 AM

<!-- pág. 1050 -->

            M-8   Appendix M / Sockets: A Programmer’s Introduction
                           A call to bind is optional on the client side, but it is required on the server side.
                      After bind() is called on a socket, we can retrieve its address structure, given the
                      socket file descriptor, by using the function getsockname().

                      Data Representation and Byte Ordering
                      Some computers are big endian. This refers to the representation of objects such as
                      integers within a word. A big endian machine stores them in the expected way: the high
                      byte of an integer is stored in the leftmost byte, while the low byte of an integer is
                      stored in the rightmost byte. So the number 5 * 216 + 6 * 28 + 4 would be stored as:

                       Big endian representation                       5             6             4
                       Little endian representation      4             6             5
                       Memory (byte) address             0             1             2             3

                             As you can see, reading a value of the wrong word size will result in an incorrect
                      value; when done on big endian architecture, on a little endian machine it can some-
                      times return the correct result. The big endian ordering is somewhat more natural to
                      humans, because we are used to reading numbers from left to right.
                             A Sun Sparc is a big endian machine. When it communicates with an i-386
                      PC (which is a little endian), the following discrepancy will exist: The i-386 will inter-
                      pret 5 * 216 + 6 * 28 + 4 as 4 * 216 + 6 * 28 + 5. To avoid this situation from
                      occurring, the TCP/IP protocol defines a machine independent standard for byte
                      order—network byte ordering. In a TCP/IP packet, the first transmitted data is the
                      most significant byte. Because big endian refers to storing the most significant byte
                      in the lowest memory address, which is the address of the data, TCP/IP defines net-
                      work byte order as big endian.
                             Winsock uses network byte order for various values. The functions htonl(),
                      htons(), ntohl(), ntohs() ensure the proper byte order is being used in Winsock
                      calls, regardless of whether the computer normally uses little endian or big endian
                      ordering.
                             The following functions are used to convert from host to network ordering
                      before transmission, and from network to host form after reception:
                          • unsigned long htonl(unsigned long n)—host to network conversion of a 32-bit
                            value;
                          • unsigned short htons(unsigned short n)—host to network conversion of a
                            16-bit value;
                          • unsigned long ntohl(unsigned long n)—network to host conversion of a 32-bit
                            value;
                          • unsigned short ntohs(unsigned short n)—network to host conversion of a
                            16-bit value.

                      Connecting a Socket
                      A remote process is identified by an IP address and a port number. The connect()
                      call evoked on the local site attempts to establish the connection to the remote des-
                      tination. It is required in the case of connection-oriented communication such as




Z18_STAL4290_09_GE_APPM.indd 8                                                                                     4/18/17 7:34 AM

<!-- pág. 1051 -->

                                                                          M.3 / SOCKETS ELEMENTS   M-9

                      stream-based sockets (TCP/IP). Sometimes we call connect() on datagram sockets,
                      as well. The reason is that this stores the destination address locally, so we do not need
                      to specify the destination address every time when we send datagram message and
                      thus can use the send() and recv() system calls instead of sendto() and recv-
                      from(). Such sockets, however, cannot be used to accept datagrams from other
                      addresses.

                             #define WIN   // WIN for Winsock and BSD for BSD sockets
                             #ifdef WIN
                             #include <windows.h> // Needed for all Winsock functions
                             #endif
                             #ifdef BSD
                             #include <sys/types.h> // Needed for system defined
                             identifiers
                             #include <netinet/in.h> // Needed for Internet address
                             structure
                             #include <sys/socket.h> // Needed for socket(), bind(),
                                              etc...
                             #endif
                             int connect(int local_s, const struct sockaddr
                                 *remote_addr, int rmtaddr_len)

                          • local_s is a local socket descriptor;
                          • remote_addr is a pointer to protocol address of other socket;
                          • rmtaddr_len is the length in bytes of the address structure.

                      Returned is an integer 0 (on success). The Windows connect function returns a non-
                      zero value to indicate an error, while the UNIX connection function returns a nega-
                      tive value in such case.
                            An example call:

                             #define PORT_NUM 1050           // Arbitrary port number
                             struct sockaddr_in serv_addr; // Server Internet address
                             int    rmt_s;                  // Remote socket descriptor
                                        // Fill-in the server (remote) socket’s address
                                           information and connect
                                        // with the listening server.
                             server_addr.sin_family = AF_INET; // Address family to use
                             server_addr.sin_port = htons(PORT_NUM); // Port num to use
                             server_addr.sin_addr.s_addr
                                   = inet_addr(inet_ntoa(address));   // IP address
                             if (connect(rmt_s,(struct sockaddr *)&serv_addr,
                                  sizeof(serv_addr)) != 0)
                                        // print error and exit




Z18_STAL4290_09_GE_APPM.indd 9                                                                                     4/18/17 7:34 AM

<!-- pág. 1052 -->

            M-10   Appendix M / Sockets: A Programmer’s Introduction

                      The gethostbyname() Function Call
                      The function gethostbyname() is supplied a host name argument and returns
                      NULL in case of failure, or a pointer to a struct hostent instance on success.
                      It gives information about the host names, aliases, and IP addresses. This informa-
                      tion is obtained from the DNS or a local configuration database. The getservby-
                      name() will determine the port number associated with a named service. If a
                      numeric value is supplied instead, it is converted directly to binary and used as a
                      port number.

                             #define struct hostent {
                                char *h_name;         // official name of host
                               char **h_aliases;     // null terminated list of alias
                                             names
                                                      // for this host
                                int  h_addrtype;      // host address type,
                                                        e.g. AF_INET
                                int  h_length;        // length of address structure
                                char **h_addr_list; // null terminated list of
                                             addresses
                                                      // in network byte order
                             };

                             Note h_addr_list refers to the IP address associated with the host.

                             #define WIN // WIN for Winsock and BSD for BSD sockets
                             #ifdef WIN
                             #include <windows.h> // for all Winsock functions
                             #endif
                             #ifdef BSD
                             #include <netdb.h> // for struct hostent
                             #endif
                             struct hostent *gethostbyname (const char *hostname);

                            Other functions that can be used to find hosts, services, protocols, or networks
                      are: getpeername(), gethostbyaddr(), getprotobyname(), getpro-
                      tobynumber(), getprotoent(), getservbyname(), getservby-
                      port(), getservent(), getnetbyname(), getnetbynumber(),
                      getnetent().
                            An example call:

                             #ifdef BSD
                              . . .
                             #include <sys\types.h> // for caddr_t type
                              . . .
                             #endif




Z18_STAL4290_09_GE_APPM.indd 10                                                                                4/18/17 7:34 AM

<!-- pág. 1053 -->

                                                                        M.3 / SOCKETS ELEMENTS   M-11

                             #define SERV_NAME somehost.somecompany.com
                             #define PORT_NUM 1050           // Arbitrary port number
                             #define h_addr h_addr_list[0] //   To hold host Internet
                                                                 address
                              . . .
                             struct sockaddr_in myhost_addr; // This Internet address
                             struct hostent *hp;        // buffer information about
                             remote host
                             int rmt_s; // Remote socket descriptor
                                         // UNIX specific part
                             bzero( (char *)&myhost_addr, sizeof(myhost_addr) );
                                         // Winsock specific
                             memset( &myhost_addr, 0, sizeof(myhost_addr) );
                                         // Fill-in the server (remote) socket’s
                                      address information and connect
                                         // with the listening server.
                             myhost_addr.sin_family = AF_INET;      // Address family
                                                     to use
                             myhost_addr.sin_port = htons(PORT_NUM); // Port num to use
                             if (hp = gethostbyname(MY_NAME)== NULL)
                                         // print error and exit
                                         // UNIX specific part
                             bcopy(hp->h_name, (char *)&myhost_addr.sin_addr,
                                 hp->h_length );
                                         // Winsock specific
                             memcpy( &myhost_addr.sin_addr, hp->h_addr, hp->h_length );
                             if(connect(rmt_s,(struct sockaddr *)&myhost_addr,
                                sizeof(myhost_addr))!=0)
                                         // print error and exit

                            The UNIX function bzero() zeroes out a buffer of specified length. It is one of
                      a group of functions for dealing with arrays of bytes. bcopy() copies a specified number
                      of bytes from a source to a target buffer. bcmp() compares a specified number of bytes
                      of two byte buffers. The UNIX bzero() and bcopy() functions are not available in
                      Winsock, so the ANSI functions memset() and memcpy() have to be used instead.
                            An example sockets program to get a host IP address for a given host name:

                             #define WIN   // WIN for Winsock and BSD for BSD sockets
                             #include <stdio.h>    // Needed for printf()
                             #include <stdlib.h>   // Needed for exit()
                             #include <string.h>   // Needed for memcpy() and strcpy()
                             #ifdef WIN
                             #include <windows.h> // Needed for all Winsock stuff
                             #endif




Z18_STAL4290_09_GE_APPM.indd 11                                                                                  4/18/17 7:34 AM

<!-- pág. 1054 -->

            M-12   Appendix M / Sockets: A Programmer’s Introduction
                             #ifdef BSD
                             #include <sys/types.h>         // Needed for system defined
                                                identifiers.
                             #include <netinet/in.h>        // Needed for Internet
                                                address structure.
                             #include <arpa/inet.h>          // Needed for inet_ntoa.
                             #include <sys/socket.h>        // Needed for socket(),
                                                bind(), etc...
                             #include <fcntl.h>
                             #include <netdb.h>
                             #endif
                             void main(int argc, char *argv[])
                             {
                             #ifdef WIN
                             WORD wVersionRequested = MAKEWORD(1,1);
                                              // Stuff for WSA functions
                             WSADATA wsaData;               // Stuff for WSA functions
                             #endif
                             struct hostent *host;   // Structure for gethostbyname()
                             struct in_addr address; // Structure for Internet
                             address
                             char host_name[256];    // String for host name
                             if (argc != 2)
                             {
                             printf(*** ERROR - incorrect number of command line
                             arguments \n);
                             printf( usage is ’getaddr host_name’ \n);
                             exit(1);
                             }
                             #ifdef WIN
                                                     // Initialize winsock
                             WSAStartup(wVersionRequested, &wsaData);
                             #endif
                                                     // Copy host name into host_name
                             strcpy(host_name, argv[1]);
                                                     // Do a gethostbyname()
                             printf(Looking for IP address for '%s'... \n,
                                  host_name);
                             host = gethostbyname(host_name);
                                                     // Output address if host found
                             if (host == NULL)
                             printf( IP address for '%s' could not be found \n,
                                  host_name);
                             else




Z18_STAL4290_09_GE_APPM.indd 12                                                            4/18/17 7:34 AM

<!-- pág. 1055 -->

                                                                      M.3 / SOCKETS ELEMENTS   M-13

                             {
                             memcpy(&address, host->h_addr, 4);
                             printf( IP address for '%s' is %s \n, host_name,
                                  inet_ntoa(address));
                             }
                             #ifdef WIN
                                              // Cleanup winsock
                             WSACleanup();
                             #endif
                             }

                      Listening for an Incoming Client Connection
                      The listen() function is used on the server in the case of connection-oriented com-
                      munication to prepare a socket to accept messages from clients. It has the prototype:

                             int listen(int       sd, int      qlen);

                          • sd is a socket descriptor of a socket after a bind() call
                          • qlen specifies the maximum number of incoming connection requests that can
                            wait to be processed by the server while the server is busy.
                          The call to listen()returns an integer: 0 on success, and -1 on failure. For
                      example:

                             if (listen(sd, 5) < 0) {
                                    // print error and exit

                      Accepting a Connection from a Client
                      The accept() function is used on the server in the case of connection-oriented com-
                      munication (after a call to listen()) to accept a connection request from a client.

                             #define WIN   // WIN for Winsock and BSD for BSD sockets
                             #ifdef WIN
                              . . .
                             #include <windows.h>        // for all Winsock functions
                              . . .
                             #endif
                             #ifdef BSD
                              . . .
                             #include <sys/types.h>
                             #include <sys/socket.h>     // for struct sockaddr
                              . . .
                             #endif
                             int accept(int server_s, struct sockaddr * client_addr,
                             int * clntaddr_len)




Z18_STAL4290_09_GE_APPM.indd 13                                                                               4/18/17 7:34 AM

<!-- pág. 1056 -->

            M-14   Appendix M / Sockets: A Programmer’s Introduction
                          • server_s is a socket descriptor the server is listening on
                          • client_addr will be filled with the client address
                          • clntaddr_len contains the length of the client address structure.
                      The accept() function returns an integer representing a new socket ( -1 in case of
                      failure).
                             Once executed, the first queued incoming connection is accepted, and a new
                      socket with the same properties as sd is created and returned. It is the socket that
                      the server will use from now on to communicate with this client. Multiple successful
                      calls to connect() will result in multiple new sockets returned.
                             An example call:
                             struct sockaddr_in client_addr;
                             int server_s, client_s, clntaddr_len;
                              ...
                             if ((client_s = accept(server_s, (struct sockaddr *)&
                             client_addr, &clntaddr_len) < 0)
                             ­
                                              // print error and exit
                                              // at this stage a thread or a process
                                         can take over and handle
                                       // communication with the client
                      Successive calls to accept on the same listening socket return different connected
                      sockets. These connected sockets are multiplexed on the same port of the server by
                      the running TCP stack functions.

                      Sending and Receiving Messages on a Socket
                      We will present only four function calls in this section. There are, however, more than
                      four ways to send and receive data through sockets. Typical functions for TCP/IP
                      sockets are send() and recv().

                             int send(int socket, const void *msg, unsigned
                                int msg_length, int flags);
                             int recv(int socket, void *rcv_buff, unsigned
                                int buff_length, int flags);
                          • socket is the local socket used to send and receive.
                          • msg is the pointer to a message.
                          • msg_length is the message length.
                          • rcv_buff is a pointer to the receive buffer.
                          • buff_length is its length.
                          • flags changes the default behavior of the call.
                             For example, a particular value of flags will be used to specify that the message
                      is to be sent without using local routing tables (they are used by default).




Z18_STAL4290_09_GE_APPM.indd 14                                                                                  4/18/17 7:34 AM

<!-- pág. 1057 -->

                                                                       M.3 / SOCKETS ELEMENTS   M-15

                             Typical functions for UDP sockets are:

                             int sendto(int socket, const void *msg, unsigned
                                int msg_length, int flags, struct sockaddr
                                 *dest_addr, unsigned int addr_length);
                             int recvfrom(int socket, void *rcv_buff, unsigned
                                int buff_length, int flags, struct sockaddr
                                 *src_addr, unsigned int addr_length);

                            Most parameters are the same as for send() and recv(), except dest_
                      addr/src_addr and addr_length. Unlike with stream sockets, datagram callers
                      of sendto() need to be informed of the destination address to send the message to,
                      and callers of recvfrom() need to distinguish between different sources sending
                      datagram messages to the caller. We provide code for TCP/IP and UDP client and
                      server applications in the following sections, where you can find the sample calls of
                      all four functions.


                      Closing a Socket
                      The prototype:

                             int closesocket(int sd); // Windows prototype
                             int close(int fd); // BSD UNIX prototype

                      fd and sd are a file descriptor (same as socket descriptor in UNIX) and a socket
                      descriptor.
                             When a socket on some reliable protocol, such as TCP/IP is closed, the kernel
                      will still retry to send any outstanding data, and the connection enters a TIME_WAIT
                      state (see Figure M.1). If an application picks the same port number to connect to,
                      the following situation can occur. When this remote application calls connect(),
                      the local application assumes that the existing connection is still active and sees the
                      incoming connection as an attempt to duplicate an existing connection. As a result,
                      [WSA]ECONNREFUSED error is returned. The operating system keeps a reference
                      counter for each active socket. A call to close() is essentially decrementing this
                      counter on the argument socket. This is important to keep in mind when we are using
                      the same socket in multiple processes. We will provide a couple of example calls in
                      the code segments presented in the next subsections.


                      Report errors
                      All the preceding operations on sockets can exhibit a number of different failures at
                      execution time. It is considered a good programming practice to report the returned
                      error. Most of these errors are designed to assist the developer in the debugging
                      process, and some of them can be displayed to the user, as well. In a Windows envi-
                      ronment, all of the returned errors are defined in winsock.h. On an UNIX-like
                      system, you can find these definitions in socket.h. The Windows codes are




Z18_STAL4290_09_GE_APPM.indd 15                                                                                 4/18/17 7:34 AM

<!-- pág. 1058 -->

            M-16   Appendix M / Sockets: A Programmer’s Introduction
                      computed by adding 10,000 to the original BSD error number and adding the prefix
                      WSA in front of the BSD error name. For example:

                        Windows name           BSD name            Windows value       BSD value
                        WSAEPROTOTYPE          EPROTOTYPE          10041               41

                      There are a few Windows-specific errors not present in a UNIX system:

                        WSASYSNOTREADY                 10091       Returned by WSAStartup() indicat-
                                                                   ing that the network subsystem is
                                                                   unusable.
                        WSAVERNOTSUPPORTED             10092       Returned by WSAStartup() indicat-
                                                                   ing that the Windows Sockets DLL
                                                                   cannot support this app.
                        WSANOTINITIALISED              10093       Returned by any function except
                                                                   WSAStartup(), when a successful
                                                                   WSAStartup() has not yet been
                                                                   performed.

                      An example error-catching source file, responsible for displaying an error and
                      exiting:

                             #ifdef WIN
                             #include <stdio.h>             // for fprintf()
                             #include <winsock.h>           // for WSAGetLastError()
                             #include <stdlib.h>            // for exit()
                             #endif
                             #ifdef BSD
                             #include <stdio.h>             // for fprintf() and perror()
                             #include <stdlib.h>            // for exit()
                             #endif

                             void catch_error(char * program_msg)
                             {
                             char err_descr[128];     // to hold error description
                             int err;
                             err = WSAGetLastError();
                                                      // record the winsock.h error
                                              description
                             if (err == WSANO_DATA)
                                strcpy(err_descr, WSANO_DATA (11004) Valid name, no
                             “     data record of requested type.);
                             if (err == WSANO_RECOVERY)
                                strcpy(err_descr, WSANO_RECOVERY (11003) This is a
                                 non-recoverable error.);
                             if (err == WSATRY_AGAIN)




Z18_STAL4290_09_GE_APPM.indd 16                                                                          4/18/17 7:34 AM

<!-- pág. 1059 -->

                                                                       M.3 / SOCKETS ELEMENTS   M-17

                               . . .
                             fprintf(stderr,%s: %s\n, program_msg, err_descr);
                             exit(1);
                             }

                      You can extend the list of errors to be used in your Winsock application by looking
                      at http://www.sockets.com.


                      Example TCP/IP Client Program (Initiating Connection)
                      This client program is designed to receive a single message from a server (lines 39–41)
                      then terminate itself (lines 45–56). It sends a confirmation to the server after the
                      message is received (lines 42–44).

                             #define WIN        // WIN for Winsock and BSD for BSD sockets
                             #include           // Needed for printf()
                             #include           // Needed for memcpy() and strcpy()
                             #ifdef WIN
                             #include           // Needed for all Winsock stuff
                             #endif
                             #ifdef BSD
                             #include           // Needed for system defined identifiers.
                             #include           // Needed for Internet address structure.

                             #include      // Needed for socket(), bind(), etc...
                             #include      // Needed for inet_ntoa()
                             #include
                             #include
                             #endif
                             #define PORT_NUM 1050 // Port number used at the server
                             #define IP_ADDR 131.247.167.101 // IP address of server
                                                   (*** HARDWIRED ***)
                             void main(void)
                             {
                             #ifdef WIN
                             WORD wVersionRequested = MAKEWORD(1,1); // WSA functions
                             WSADATA wsaData;        // WSA functions
                             #endif
                             unsigned int server_s; // Server socket descriptor
                             struct sockaddr_in server_addr; // Server Internet address
                             char out_buf[100];     // 100-byte output buffer for data
                             char in_buf[100];       // 100-byte input buffer for data
                             #ifdef WIN              // Initialize Winsock
                             WSAStartup(wVersionRequested, &wsaData);
                             #endif




Z18_STAL4290_09_GE_APPM.indd 17                                                                                 4/18/17 7:34 AM

<!-- pág. 1060 -->

            M-18   Appendix M / Sockets: A Programmer’s Introduction
                                    // Create a socket
                             server_s = socket(AF_INET, SOCK_STREAM, 0);
                                    // Fill-in the server socket’s address and do a
                                   connect with
                                 // the listening server. The connect() will block.
                             Server_addr.sin_family = AF_INET;     // Address family
                             Server_addr.sin_port = htons(PORT_NUM); // Port num
                             Server_addr.sin_addr.s_addr = inet_addr(IP_ADDR);
                                             // IP address
                             Connect(server_s, (struct sockaddr *)&server_addr,
                             sizeof(server_addr));
                                             // Receive from the server
                             recv(server_s, in_buf, sizeof(in_buf), 0);
                             printf(Received from server... data = ’%s’ \n, in_buf);
                                             // Send to the server
                             strcpy(out_buf, Message -- client to server);
                             send(server_s, out_buf, (strlen(out_buf) + 1), 0);
                                             // Close all open sockets
                             #ifdef WIN
                             closesocket(server_s);
                             #endif
                             #ifdef BSD
                             close(server_s);
                             #endif
                             #ifdef WIN          // Cleanup winsock
                             WSACleanup();
                             #endif
                             }


                      Example TCP/IP Server Program (Passively Awaiting
                      Connection)
                      All the following server program does is serving a message to a client running on
                      another host. It creates one socket in line 37 and listens for a single incoming service
                      request from the client through this single socket. When the request is satisfied, this
                      server terminates (lines 62–74).

                             #define WIN // WIN for Winsock and BSD for BSD sockets
                             #include <stdio.h> // Needed for printf()
                             #include <string.h> // Needed for memcpy() and strcpy()
                             #ifdef WIN
                             #include <windows.h> // Needed for all Winsock calls
                             #endif
                             #ifdef BSD




Z18_STAL4290_09_GE_APPM.indd 18                                                                                  4/18/17 7:34 AM

<!-- pág. 1061 -->

                                                            M.3 / SOCKETS ELEMENTS   M-19

                             #include <sys/types.h>   // Needed for system defined
                                              identifiers.
                             #include <netinet/in.h> // Needed for Internet address
                             structure.
                             #include <sys/socket.h> // Needed for socket(), bind(),
                                               etc...
                             #include <arpa/inet.h>    // Needed for inet_ntoa()
                             #include <fcntl.h>
                             #include <netdb.h>
                             #endif
                             #define PORT_NUM 1050     // Arbitrary port number for
                                              the server
                             #define MAX_LISTEN 3      // Maximum number of listens
                                                          to queue
                             void main(void)
                             {
                             #ifdef WIN
                             WORD wVersionRequested = MAKEWORD(1,1);
                                             // for WSA functions
                             WSADATA wsaData;      // for WSA functions
                             #endif
                             unsigned int server_s;   // Server socket descriptor
                             struct sockaddr_in server_addr;
                                            // Server Internet address
                             unsigned int client_s; // Client socket descriptor
                             struct sockaddr_in client_addr;
                                                      // Client Internet address
                             struct in_addr client_ip_addr; // Client IP address
                             int addr_len;            // Internet address length
                             char out_buf[100];      // 100-byte output buffer for data
                             char in_buf[100];     // 100-byte input buffer for data
                             #ifdef WIN        // Initialize Winsock
                             WSAStartup(wVersionRequested, &wsaData);
                             #endif                 // Create a socket
                                           // - AF_INET is Address Family
                                          Internet and SOCK_STREAM is streams
                             server_s = socket(AF_INET, SOCK_STREAM, 0);
                                           // Fill-in my socket’s address
                                            information and bind the socket
                                            // -          See winsock.h for a
                                                         description of struct
                                                         sockaddr_in
                             server_addr.sin_family = AF_INET; //  Address family
                                                                    to use




Z18_STAL4290_09_GE_APPM.indd 19                                                             4/18/17 7:34 AM

<!-- pág. 1062 -->

            M-20   Appendix M / Sockets: A Programmer’s Introduction
                             server_addr.sin_port = htons(PORT_NUM);
                                       // Port number to use
                             server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
                                       // Listen on any IP addr.
                             bind(server_s, (struct sockaddr *)&server_addr,
                             sizeof(server_addr));
                               // 
                                  Listen for connections (queueing up to MAX_LISTEN)
                             listen(server_s, MAX_LISTEN);
                               // 
                                  Accept a connection. The accept() will block and
                                  then return with
                               // client_addr filled-in.
                             addr_len = sizeof(client_addr);
                             client_s = accept(server_s, (struct sockaddr *)&client_
                             addr, &addr_len);
                               // 
                                  Copy the four-byte client IP address into an IP
                                  address structure
                               // - See winsock.h for a description of struct in_addr
                             memcpy(&client_ip_addr, &client_addr.sin_addr.s_addr, 4);
                               // Print an informational message that accept completed
                             printf(Accept completed!!! IP address of client = %s
                             port = %d \n,
                             inet_ntoa(client_ip_addr), ntohs(client_addr.sin_port));
                                       // Send to the client
                             strcpy(out_buf, Message -- server to client);
                             send(client_s, out_buf, (strlen(out_buf) + 1), 0);
                                       // Receive from the client
                             recv(client_s, in_buf, sizeof(in_buf), 0);
                             printf(Received from client... data = ’%s’ \n, in_buf);
                                       // Close all open sockets
                             #ifdef WIN
                             closesocket(server_s);
                             closesocket(client_s);
                             #endif
                             #ifdef BSD
                             close(server_s);
                             close(client_s);
                             #endif
                             #ifdef WIN
                                       // Cleanup Winsock
                             WSACleanup();
                             #endif
                             }




Z18_STAL4290_09_GE_APPM.indd 20                                                          4/18/17 7:34 AM

<!-- pág. 1063 -->

                                                        M.4 / STREAM AND DATAGRAM SOCKETS   M-21

                      This is not a very realistic implementation. More often, server applications will
                      contain some indefinite loop and be able to accept multiple requests. The preced-
                      ing code can be easily converted into such more realistic server by inserting lines
                      46–61 into a loop in which the termination condition is never satisfied (e.g.,
                      while(1){ . . . }). Such servers will create one permanent socket through
                      the socket() call (line 37), while a temporary socket gets spun off every time
                      when a request is accepted (line 49). In this manner, each temporary socket will
                      be responsible of handling a single incoming connection. If a server gets killed
                      eventually, the permanent socket will be closed, as will each of the active tempo-
                      rary sockets. The TCP implementation determines when the same port number will
                      become available for reuse by other applications. The status of such port will be in
                      TIME-WAIT state for some predetermined period of time, as shown in ­Figure M.1
                      for port number 1234.



               M.4 STREAM AND DATAGRAM SOCKETS

                       When sockets are used to send a connection-oriented, reliable stream of bytes across
                       machines, they are of SOCK_STREAM type. As we previously discussed, in such
                       cases sockets have to be connected before being used. The data are transmitted
                       through a bidirectional stream of bytes and are guaranteed to arrive in the order they
                       were sent.
                             Sockets of SOCK_DGRAM type (or datagram sockets) support a bidirectional
                       flow of data, as well, but data may arrive out of order, and possibly duplicated (i.e., it
                       is not guaranteed to be arriving in sequence or to be unique). Datagram sockets also
                       do not provide reliable service since they can fail to arrive at all. It is important to
                       note, though, that the data record boundaries are preserved, as long as the records
                       are no longer than the receiver could handle. Unlike stream sockets, datagram sockets
                       are connectionless; hence, they do not need to be connected before being used.
                      ­Figure M.3 shows the basic flowchart of datagram sockets communication. Taking
                       the stream-based communication model as a base, as one can easily notice, the calls
                       to listen() and accept() are dropped, and the calls to send() and recv() are
                       replaced by calls to sendto() and recvfrom().

                      Example UDP Client Program (Initiate Connections)

                             #define WIN   // WIN for Winsock and BSD for BSD sockets
                             #include <stdio.h>    // Needed for printf()
                             #include <string.h>   // Needed for memcpy() and strcpy()
                             #ifdef WIN
                             #include <windows.h> // Needed for all Winsock stuff
                             #endif
                             #ifdef BSD




Z18_STAL4290_09_GE_APPM.indd 21                                                                                     4/18/17 7:34 AM

<!-- pág. 1064 -->

            M-22   Appendix M / Sockets: A Programmer’s Introduction




                                      Server                                                             Client
                                     socket()                                                      Open communication
                                                                                                   endpoint

                                      bind()                                                       Register well-known
                                                                                                   address with system

                                                                                                   Open communication
                                                                                  socket()
                                                                                                   endpoint


                                                            data (request)
                                     receive()                                     send()          Send/receive data


                                  process request


                                                             data (reply)
                                      send()                                      receive()        Send/receive data



                                      close()                                      close()         Shutdown

                            Figure M.3           Socket System Calls for Connectionless Protocol


                             #include <sys/types.h>    // Needed for system defined
                                              identifiers.
                             #include <netinet/in.h> // Needed for Internet address
                             structure.
                             #include <sys/socket.h> // 
                                                        Needed for socket(), bind(),
                                                        etc...
                             #include <arpa/inet.h> // Needed for inet_ntoa()
                             #include <fcntl.h>
                             #include <netdb.h>
                             #endif
                             #define PORT_NUM 1050    // Port number used
                             #define IP_ADDR 131.247.167.101
                                     // IP address of server1 (*** HARDWIRED ***)
                             void main(void)
                             {
                             #ifdef WIN




Z18_STAL4290_09_GE_APPM.indd 22                                                                                          4/18/17 7:34 AM

<!-- pág. 1065 -->

                                               M.4 / STREAM AND DATAGRAM SOCKETS   M-23

                             WORD wVersionRequested = MAKEWORD(1,1);
                                            // Stuff for WSA functions
                             WSADATA wsaData;       // Stuff for WSA functions
                             #endif
                             unsigned int server_s;    // Server socket descriptor
                             struct sockaddr_in server_addr;
                                            // Server Internet address
                             int addr_len;        // Internet address length
                             char out_buf[100];     // 100-byte buffer for output data
                             char in_buf[100];      // 100-byte buffer for input data
                             #ifdef WIN             // This stuff initializes winsock
                             WSAStartup(wVersionRequested, &wsaData);
                             #endif                 // Create a socket
                                                    // 
                                                       - AF_INET is Address Family
                                                       Internet and SOCK_DGRAM is
                                                       datagram
                             server_s = socket(AF_INET, SOCK_DGRAM, 0);
                                                    // 
                                                       Fill-in server1 socket’s
                                                       address information
                             server_addr.sin_family = AF_INET;
                                          // Address family to use
                              server_addr.sin_port = htons(PORT_NUM);
                                          // Port num to use
                              server_addr.sin_addr.s_addr = inet_addr(IP_ADDR);
                                          // IP address to use
                                         // Assign a message to buffer out_buf
                              strcpy(out_buf, Message from client1 to server1);
                                         // N      ow send the message to server1.
                                                   The + 1 includes the end-of-string
                                         // delimiter
                              sendto(server_s, out_buf, (strlen(out_buf) + 1), 0,
                              (struct sockaddr *)&server_addr, sizeof(server_addr));
                                         // Wait to receive a message
                              addr_len = sizeof(server_addr);
                              recvfrom(server_s, in_buf, sizeof(in_buf), 0,
                              (struct sockaddr *)&server_addr, &addr_len);
                                         // Output the received message
                              printf(Message received is: ’%s’ \n, in_buf);
                                         // Close all open sockets
                             #ifdef WIN
                              closesocket(server_s);
                             #endif
                             #ifdef BSD
                              close(server_s);




Z18_STAL4290_09_GE_APPM.indd 23                                                           4/18/17 7:34 AM

<!-- pág. 1066 -->

            M-24   Appendix M / Sockets: A Programmer’s Introduction
                             #endif
                             #ifdef WIN
                               // Cleanup Winsock
                               WSACleanup();
                             #endif
                             }

                      Example UDP Server Program (Passively Await
                      Connection)
                             #define WIN   // WIN for Winsock and BSD for BSD sockets
                             #include <stdio.h>     // Needed for printf()
                             #include <string.h>    // Needed for memcpy() and strcpy()
                             #ifdef WIN
                             #include <windows.h> // Needed for all Winsock stuff
                             #endif
                             #ifdef BSD
                             #include <sys/types.h>     // Needed for system defined
                                                            identifiers.
                             #include <netinet/in.h>    // Needed for Internet address
                                                            structure.
                             #include <sys/socket.h>    // Needed for socket(),
                                                            bind(), etc...
                             #include <arpa/inet.h>     // Needed for inet_ntoa()
                             #include <fcntl.h>
                             #include <netdb.h>
                             #endif
                             #define PORT_NUM 1050      // Port number used
                             #define IP_ADDR 131.247.167.101 // IP address of client1
                             void main(void)
                             {
                             #ifdef WIN
                             WORD wVersionRequested = MAKEWORD(1,1);
                                             // Stuff for WSA functions
                             WSADATA wsaData;           // Stuff for WSA functions
                             #endif
                             unsigned int server_s;     // Server socket descriptor
                             struct sockaddr_in server_addr;
                                             // Server1 Internet address
                             struct sockaddr_in client_addr; // Client1 Internet
                             address
                             int addr_len;        // Internet address length
                             char out_buf[100];     // 100-byte buffer for output data
                             char in_buf[100];      // 100-byte buffer for input data
                             long int i;            // Loop counter




Z18_STAL4290_09_GE_APPM.indd 24                                                           4/18/17 7:34 AM

<!-- pág. 1067 -->

                                                M.4 / STREAM AND DATAGRAM SOCKETS   M-25

                             #ifdef WIN    // This stuff initializes winsock
                             WSAStartup(wVersionRequested, &wsaData);
                             #endif      // Create a socket
                                      //     AF_INET is Address Family Internet and
                                              SOCK_DGRAM is datagram
                             server_s = socket(AF_INET, SOCK_DGRAM, 0);
                                     // Fill-in my socket’s address information
                             server_addr.sin_family = AF_INET;    // Address family
                             server_addr.sin_port = htons(PORT_NUM);    // Port number
                             server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
                                     // Listen on any IP address
                             bind(server_s, (struct sockaddr *)&server_addr,
                             sizeof(server_addr));
                                   // Fill-in client1 socket’s address information
                             client_addr.sin_family = AF_INET;
                                  // Address family to use
                             client_addr.sin_port = htons(PORT_NUM); // Port num to use
                             client_addr.sin_addr.s_addr = inet_addr(IP_ADDR);
                                  // IP address to use
                                   // Wait to receive a message from client1
                             addr_len = sizeof(client_addr);
                             recvfrom(server_s, in_buf, sizeof(in_buf), 0,
                             (struct sockaddr *)&client_addr, &addr_len);
                                  // Output the received message
                             printf(Message received is: '%s' \n, in_buf);
                                   // Spin-loop to give client1 time to turn-around
                             for (i=0; i>> Step #5 <<<
                                   //   Now send the message to client1. The + 1
                                         includes the end-of-string
                                  // delimiter
                             sendto(server_s, out_buf, (strlen(out_buf) + 1), 0,
                             (struct sockaddr *)&client_addr, sizeof(client_addr));
                                  // Close all open sockets
                             #ifdef WIN
                             closesocket(server_s);
                             #endif
                             #ifdef BSD
                             close(server_s);
                             #endif
                             #ifdef WIN
                                  // Cleanup Winsock
                             WSACleanup();
                             #endif
                             }




Z18_STAL4290_09_GE_APPM.indd 25                                                            4/18/17 7:34 AM

<!-- pág. 1068 -->

            M-26   Appendix M / Sockets: A Programmer’s Introduction

               M.5 RUN-TIME PROGRAM CONTROL

                      Nonblocking Socket Calls
                      By default, a socket is created as blocking, (i.e., it blocks until the current function
                      call is completed). For example, if we execute an accept() on a socket, the process
                      will block until there is an incoming connection from a client. In UNIX, two functions
                      are involved in turning a blocking socket into a nonblocking one: ioctl() and
                      select(). The first facilitates input/output control on a file descriptor or socket.
                      The select() function is then used to determine the socket status—ready or not
                      ready to perform action.

                             // change the blocking state of a socket
                             unsigned long unblock = TRUE;
                                     // TRUE for nonblocking, FALSE for blocking
                             ioctl(s, FIONBIO, &unblock);

                             We then call accept() periodically:

                             while(client_s = accept(s, NULL, NULL) > 0)
                             {
                               if ( client_s == EWOULDBLOCK)
                                   // wait until a client connection arrives,
                                   // while executing useful tasks
                               else
                                   // process accepted connection
                             }   // display error and exit

                          or use the select() function call to query the socket status, as in the following
                      segment from a nonblocking socket program:

                             if (select(max_descr + 1, &sockSet, NULL, NULL,
                             &sel_timeout) == 0)
                                       // print a message for the user
                             else
                             { . . .
                             client_s = accept(s, NULL, NULL);
                               . . .
                             }

                      In this way, when some socket descriptor is ready for I/O, the process has to be con-
                      stantly polling the OS with select() calls, until the socket is ready. Although the
                      process executing a select() call would suspend the program until the socket is
                      ready or until the select() function times out (as opposed to suspending it until
                      the socket is ready, if the socket were blocking), this solution is still inefficient. Just
                      like calling a nonblocking accept() within a loop, calling select() within a loop
                      results in wasting CPU cycles.




Z18_STAL4290_09_GE_APPM.indd 26                                                                                     4/18/17 7:34 AM

<!-- pág. 1069 -->

                                                        M.5 / RUN-TIME PROGRAM CONTROL   M-27

                      Asynchronous I/O (Signal Driven I/O)
                      A better solution is to use asynchronous I/O (i.e., when I/O activity is detected on
                      the socket, the OS informs the process immediately and thus relieves it from the
                      burden of polling all the time). In the original BSD UNIX, this involves the use of
                      calls to sigaction() and fcntl(). An alternative to poll for the status of a socket
                      through the select() call is to let the kernel inform the application about events
                      via a SIGIO signal. In order to do that, a valid signal handler for SIGIO must be
                      installed with sigaction(). The following program does not involve sockets, it
                      merely provides a simple example on how to install a signal handler. It catches an
                      interrupt char (Cntrl-C) input by setting the signal handling for SIGINT (interrupt
                      signal) via sigaction():

                             #include <stdio.h>          // for printf()
                             #include <sys/signal.h>    // for sigaction()
                             #include <unistd.h>        // for pause()
                             void catch_error(char *errorMessage);
                                            // for error handling
                             void InterruptSignalHandler(int signalType);
                                            // handle interr. signal
                             int main(int argc, char *argv[])
                             {
                               struct sigaction handler;
                                                       // Signal handler specification
                                 // Set InterruptSignalHandler() as a handler function
                               handler.sa_handler = InterruptSignalHandler;
                                              // Create mask for all signals
                               if (sigfillset(&handler.sa_mask) < 0)
                               catch_error(sigfillset() failed);

                                                 // No flags
                                  handler.sa_flags = 0;
                                         // Set signal handling for interrupt signals
                                  if (sigaction(SIGINT, &handler, 0) < 0)
                                  catch_error(sigaction() failed);
                                  for(;;)
                                  pause();   // suspend program until signal received
                                  exit(0);
                             }
                             void InterruptSignalHandler(int signalType)
                             {
                               printf(Interrupt Received. Program terminated.\n);
                               exit(1);
                             }




Z18_STAL4290_09_GE_APPM.indd 27                                                                              4/18/17 7:34 AM

<!-- pág. 1070 -->

            M-28   Appendix M / Sockets: A Programmer’s Introduction
                            A FASYNC flag must be set on a socket file descriptor via fcntl(). In more
                      detail, first we notify the OS about our desire to install a new disposition for SIGIO,
                      using sigaction(); then we force the OS to submit signals to the current process
                      by using fcntl(). This call is needed to ensure that among all processes that access
                      the socket, the signal is delivered to the current process (or process group); next, we
                      use fcntl()again to set the status flag on the same socket descriptor for asynchro-
                      nous FASYNC. The following segment of a datagram sockets program follows this
                      scheme. Note all the unnecessary details are omitted for clarity:

                             int main()
                             {
                               . . .
                                    // Create socket for sending/receiving datagrams
                                    // Set up the server address structure
                                    // Bind to the local address
                                    // Set signal handler for SIGIO
                                    // Create mask that mask all signals
                               if (sigfillset(&handler.sa_mask) < 0)
                                    // print error and exit
                                   // No flags
                               handler.sa_flags = 0;
                               if (sigaction(SIGIO, &handler, 0) < 0)
                                    // print error and exit
                                    //  We must own the socket to receive the SIGIO
                                         message
                               if (fcntl(s_socket, F_SETOWN, getpid()) < 0)
                                    //print error and exit
                                    //  Arrange for asynchronous I/O and SIGIO
                                         delivery
                               if (fcntl(s_socket, F_SETFL, FASYNC | O_NONBLOCK) < 0)
                                    // print error and exit
                               for (;;)
                               pause();
                               . . .
                             }

                          Under Windows, the select() function is not implemented. The WSAAsync-
                      Select() is used to request notification of network events (i.e., request that
                      Ws2_32.dll sends a message to the window hWnd):

                             WSAAsyncSelect (SOCKET socket, HWND                  hWnd,
                             unsigned int wMsg, long lEvent)

                           The SOCKET type is defined in winsock.h. socket is a socket descriptor,
                      hWnd is the window handle, wMsg is the message, lEvent is usually a logical OR of all
                      events we are expecting to be notified of, when completed. Some of the event values




Z18_STAL4290_09_GE_APPM.indd 28                                                                                 4/18/17 7:34 AM

<!-- pág. 1071 -->

                         M.6 / REMOTE EXECUTION OF A WINDOWS CONSOLE APPLICATION   M-29

                      are FD_CONNECT (connection completed), FD_ACCEPT (ready to accept), FD_
                      READ (ready to read), FD_WRITE (ready to write), FD_CLOSE (connection closed).
                      You can easily incorporate the following stream sockets program segment into the
                      previously presented programs or your own application. (Again, details are omitted.):

                                   // the message for the asynchronous notification
                              #define wMsg (WM_USER + 4)
                              ...
                                  // s ocket_s has already been created and bound to
                                       a name
                                 // listen for connections
                             if (listen(socket_s, 3) == SOCKET_ERROR)
                                 // print error message
                                 // exit after cleanup
                                  // get notification on connection accept
                                 // to this window
                             if (WSAAsyncSelect(s, hWnd, wMsg, FD_ACCEPT)==
                             SOCKET_ERROR)
                                  // print cannot process asynchronously
                                 // exit after cleanup
                              else // accept the incoming connection

                      Further references on Asynchronous I/O are “The Pocket Guide to TCP/IP Sockets—
                      C version” by Donahoo and Calvert (for UNIX), and “Windows Sockets Network
                      Programming” (for Windows), by Bob Quinn.


               M.6 REMOTE EXECUTION OF A WINDOWS CONSOLE
                   APPLICATION

                      Simple sockets operations can be used to accomplish tasks that are otherwise hard
                      to achieve. For example, by using sockets we can remotely execute an application.
                      The sample code1 is presented. Two sockets programs, a local and remote, are used
                      to transfer a Windows console application (an .exe file) from the local host to the
                      remote host. The program is executed on the remote host, then stdout is returned
                      to the local host.

                      Local Code
                             #include <stdio.h>   // Needed for printf()
                             #include <stdlib.h> // Needed for exit()
                             #include <string.h> // Needed for memcpy() and strcpy()
                             #include <windows.h> // 
                                                     Needed for Sleep() and Winsock
                                                     stuff
                      1
                        This and other code presented is in part written by Ken Christensen and Karl S. Lataxes at the Computer
                      Science Department of the University of South Florida, http://www.csee.usf.edu/~christen/tools/.




Z18_STAL4290_09_GE_APPM.indd 29                                                                                                   4/18/17 7:34 AM

<!-- pág. 1072 -->

            M-30   Appendix M / Sockets: A Programmer’s Introduction
                             #include <fcntl.h>     // Needed for file i/o constants
                             #include <sys\stat.h> // Needed for file i/o constants
                             #include <io.h> // Needed for open(), close(), and eof()
                             #define PORT_NUM 1050 // Arbitrary port number for the
                                                       server
                             #define MAX_LISTEN 1   // 
                                                       Maximum number of listens to
                                                       queue
                             #define SIZE 256       // 
                                                       Size in bytes of transfer
                                                       buffer

                             void main(int argc, char *argv[])
                             {
                             WORD wVersionRequested = MAKEWORD(1,1); // WSA functions
                             WSADATA wsaData;        // Winsock API data structure
                             unsigned int remote_s; // Remote socket descriptor
                             struct sockaddr_in remote_addr;
                                           // Remote Internet address
                             struct sockaddr_in server_addr;
                                           // Server Internet address
                             unsigned char bin_buf[SIZE]; // Buffer for file transfer
                             unsigned int fh;      // File handle
                             unsigned int length;     // Length of buffers transferred
                             struct hostent *host;    // Structure for gethostbyname()
                             struct in_addr address; // Structure for Internet
                                                         address
                             char host_name[256];     // String for host name
                             int addr_len; // Internet address length
                             unsigned int local_s;   // Local socket descriptor
                             struct sockaddr_in local_addr; // Local Internet address
                             struct in_addr remote_ip_addr; // Remote IP address
                                // Check if number of command line arguments is valid
                             if (argc !=4)
                             {
                             printf( *** ERROR - Must be ’local (host) (exefile)
                                  (outfile)’ \n);
                             printf( where host is the hostname *or* IP address \n);
                             printf( of the host running remote.c, exefile is the \n);
                             printf( name of the file to be remotely run, and \n);
                             printf( outfile is the name of the local output file. \n);
                             exit(1);
                             }
                                  // Initialization of winsock
                             WSAStartup(wVersionRequested, &wsaData);
                                   // Copy host name into host_name




Z18_STAL4290_09_GE_APPM.indd 30                                                           4/18/17 7:34 AM

<!-- pág. 1073 -->

                         M.6 / REMOTE EXECUTION OF A WINDOWS CONSOLE APPLICATION   M-31

                             strcpy(host_name, argv[1]);
                                  // Do a gethostbyname()
                             host = gethostbyname(argv[1]);
                             if (host == NULL)
                             {
                             printf( *** ERROR - IP address for '%s' not be found \n,
                             host_name);
                             exit(1);
                             }      //   Copy the four-byte client IP address into
                                          an IP address structure
                             memcpy(&address, host->h_addr, 4);
                                   // Create a socket for remote
                             remote_s = socket(AF_INET, SOCK_STREAM, 0);
                                   // Fill-in the server (remote) socket’s address
                             information and connect
                                  // with the listening server.
                             server_addr.sin_family = AF_INET; // Address family to use
                             server_addr.sin_port = htons(PORT_NUM); // Port num to use
                             server_addr.sin_addr.s_addr = inet_addr(inet_
                             ntoa(address)); // IP address
                             connect(remote_s, (struct sockaddr *)&server_addr,
                             sizeof(server_addr));
                                   // Open and read *.exe file
                             if((fh = open(argv[2], O_RDONLY | O_BINARY, S_IREAD |
                                S_IWRITE)) == -1)
                             {
                             printf( ERROR - Unable to open file ’%s’\n, argv[2]);
                             exit(1);
                             }
                                   // Output message stating sending executable file
                             printf(Sending '%s' to remote server on ’%s’ \n,
                             argv[2], argv[1]);
                                   // Send *.exe file to remote
                             while(!eof(fh))
                             {
                             length = read(fh, bin_buf, SIZE);
                             send(remote_s, bin_buf, length, 0);
                             }
                                   //   Close the *.exe file that was sent to the
                                         server (remote)
                             close(fh);
                                  // Close the socket
                             closesocket(remote_s);
                                  // Cleanup Winsock




Z18_STAL4290_09_GE_APPM.indd 31                                                           4/18/17 7:34 AM

<!-- pág. 1074 -->

            M-32   Appendix M / Sockets: A Programmer’s Introduction
                             WSACleanup();
                                   // Output message stating remote is executing
                             printf( '%s' is executing on remote server \n, argv[2]);
                                   // Delay to allow everything to cleanup
                             Sleep(100);
                                  // Initialization of winsock
                             WSAStartup(wVersionRequested, &wsaData);

                                   //   Create a new socket to receive output file
                                         from remote server
                             local_s = socket(AF_INET, SOCK_STREAM, 0);
                                   //   Fill-in the socket’s address information and
                                         bind the socket
                             local_addr.sin_family = AF_INET; // Address family to use
                             local_addr.sin_port = htons(PORT_NUM); // Port num to use
                             local_addr.sin_addr.s_addr = htonl(INADDR_ANY);
                                   // Listen on any IP addr
                             bind(local_s, (struct sockaddr *)&local_addr,
                             sizeof(local_addr));
                                   //   Listen for connections (queueing up to
                                         MAX_LISTEN)
                             listen(local_s, MAX_LISTEN);
                                   //   Accept a connection, the accept will block
                                         and then return with
                                  // remote_addr filled in.
                             addr_len = sizeof(remote_addr);
                             remote_s = accept(local_s, (struct sockaddr*)
                                 &remote_addr, &addr_len);
                                   //   Copy the four-byte client IP address into an
                                         IP address structure
                             memcpy(&remote_ip_addr, &remote_addr.sin_addr.s_addr, 4);
                                   // Create and open the output file for writing
                             if ((fh=open(argv[3], O_WRONLY | O_CREAT | O_TRUNC |
                                 O_BINARY,
                             S_IREAD | S_IWRITE)) == - 1)
                             {
                             printf( *** ERROR - Unable to open '%s'\n, argv[3]);
                             exit(1);
                             }
                                   // Receive output file from server
                             length = SIZE;
                             while(length > 0)
                             {
                             length = recv(remote_s, bin_buf, SIZE, 0);




Z18_STAL4290_09_GE_APPM.indd 32                                                          4/18/17 7:34 AM

<!-- pág. 1075 -->

                         M.6 / REMOTE EXECUTION OF A WINDOWS CONSOLE APPLICATION   M-33

                             write(fh, bin_buf, length);
                             }
                               // Close output file that was received from the remote
                             close(fh);
                               // Close the sockets
                             closesocket(local_s);
                             closesocket(remote_s);
                               // Output final status message
                             printf(Execution of '%s' and transfer of output
                                 to '%s' done! \n,
                             argv[2], argv[3]);
                               // Cleanup Winsock
                             WSACleanup();
                             }

                      Remote Code
                             #include <stdio.h>    // Needed for printf()
                             #include <stdlib.h>      // Needed for exit()

                             #include <string.h>    // Needed for memcpy() and strcpy()
                             #include <windows.h> //      Needed for Sleep() and Winsock
                                                           stuff
                             #include <fcntl.h>    // Needed for file i/o constants
                             #include <sys\stat.h> // Needed for file i/o constants
                             #include <io.h> // Needed for open(), close(), and eof()
                             #define PORT_NUM 1050 //     Arbitrary port number for the
                                                           server
                             #define MAX_LISTEN 1       // 
                                                           Maximum number of listens to
                                                           queue
                             #define IN_FILE run.exe //     Name given to transferred
                                                             *.exe file
                             #define TEXT_FILE output
                                           // Name of output file for stdout
                             #define SIZE 256         //  Size in bytes of transfer
                                                           buffer
                             void main(void)
                             {
                             WORD wVersionRequested = MAKEWORD(1,1); // WSA functions
                             WSADATA wsaData;      // WSA functions
                             unsigned int remote_s; // Remote socket descriptor
                             struct sockaddr_in remote_addr;
                                           // Remote Internet address
                             struct sockaddr_in server_addr;
                                           // Server Internet address




Z18_STAL4290_09_GE_APPM.indd 33                                                             4/18/17 7:34 AM

<!-- pág. 1076 -->

            M-34   Appendix M / Sockets: A Programmer’s Introduction
                             unsigned int local_s;      // Local socket descriptor
                             struct sockaddr_in local_addr; // Local Internet address
                             struct in_addr local_ip_addr; // Local IP address
                             int addr_len;                 // Internet address length
                             unsigned char bin_buf[SIZE]; // File transfer buffer
                             unsigned int fh;              // File handle
                             unsigned int length;         // Length of transf. buffers
                                              // Do forever
                             while(1)
                             {                 // Winsock initialization
                             WSAStartup(wVersionRequested, &wsaData);
                                              // Create a socket
                             remote_s = socket(AF_INET, SOCK_STREAM, 0);
                                     // F     ill-in my socket’s address information
                                              and bind the socket
                             remote_addr.sin_family = AF_INET; // Address family to use
                             remote_addr.sin_port = htons(PORT_NUM);
                                     // Port number to use
                             remote_addr.sin_addr.s_addr = htonl(INADDR_ANY);
                                     // Listen on any IP addr
                             bind(remote_s, (struct sockaddr *)&remote_addr,
                             sizeof(remote_addr));
                                     // Output waiting message
                             printf(Waiting for a connection... \n);
                               // Listen for connections (queueing up to MAX_LISTEN)
                             listen(remote_s, MAX_LISTEN);
                               // Accept a connection, accept() will block and return
                                   with local_addr
                             addr_len = sizeof(local_addr);
                             local_s = accept(remote_s, (struct sockaddr *)&local_
                             addr, &addr_len);
                               // Copy the four-byte client IP address into an IP
                                   address structure
                             memcpy(&local_ip_addr, &local_addr.sin_addr.s_addr, 4);
                               // Output message acknowledging receipt, saving of *.exe
                             printf( Connection established, receiving remote ­executable
                             file \n);
                               // Open IN_FILE for remote executable file
                             if((fh = open(IN_FILE, O_WRONLY | O_CREAT | O_TRUNC |
                             O_BINARY,
                             S_IREAD | S_IWRITE)) == - 1)
                             {
                             printf( *** ERROR - unable to open executable file \n);
                             exit(1);




Z18_STAL4290_09_GE_APPM.indd 34                                                             4/18/17 7:34 AM

<!-- pág. 1077 -->

                         M.6 / REMOTE EXECUTION OF A WINDOWS CONSOLE APPLICATION   M-35

                             }
                                 // Receive executable file from local
                             length = 256;
                             while(length > 0)
                             {
                             length = recv(local_s, bin_buf, SIZE, 0);
                             write(fh, bin_buf, length);
                             }
                                 // Close the received IN_FILE
                             close(fh);
                                // Close sockets
                             closesocket(remote_s);
                             closesocket(local_s);
                                // Cleanup Winsock
                             WSACleanup();
                                 // Print message acknowledging execution of *.exe
                             printf( Executing remote executable (stdout to output
                             file) \n);
                                 // Execute remote executable file (in IN_FILE)
                             system(IN_FILE > TEXT_FILE);
                                 // Winsock initialization to reopen socket to send
                                     output file to local
                             WSAStartup(wVersionRequested, &wsaData);
                                 // Create a socket
                                 // - AF_INET is Address Family Internet and SOCK_
                                     STREAM is streams
                             local_s = socket(AF_INET, SOCK_STREAM, 0);
                                 // Fill in the server’s socket address information
                                     and connect with
                                 // the listening local
                             server_addr.sin_family = AF_INET;
                             server_addr.sin_port = htons(PORT_NUM);
                             server_addr.sin_addr.s_addr = inet_addr(inet_ntoa
                                  (local_ip_addr));
                             connect(local_s, (struct sockaddr *)&server_addr,
                             sizeof(server_addr));
                                 // Print message acknowledging transfer of output to
                                     client
                             printf( Sending output file to local host \n);
                                 // Open output file to send to client
                             if((fh = open(TEXT_FILE, O_RDONLY |
                                   O_BINARY, S_IREAD | S_IWRITE)) == - 1)
                             {
                             printf( *** ERROR - unable to open output file \n);




Z18_STAL4290_09_GE_APPM.indd 35                                                           4/18/17 7:34 AM

<!-- pág. 1078 -->

            M-36   Appendix M / Sockets: A Programmer’s Introduction
                             exit(1);
                             }
                                      // Send output file to client
                             while(!eof(fh))
                             {
                             length = read(fh, bin_buf, SIZE);
                             send(local_s, bin_buf, length, 0);
                             }
                                      // Close output file
                             close(fh);
                                      // Close sockets
                             closesocket(remote_s);
                             closesocket(local_s);
                                      // Cleanup Winsock
                             WSACleanup();
                                      // Delay to allow everything to cleanup
                             Sleep(100);
                             }
                             }




Z18_STAL4290_09_GE_APPM.indd 36                                                 4/18/17 7:34 AM

<!-- pág. 1079 -->

            aPPENDIX N
                      THE INtErNatIoNal REFErENCE alPHaBEt




                                                             N-1




Z19_STAL4290_09_GE_APPN.indd 1                                     4/18/17 7:35 AM

<!-- pág. 1080 -->

            N-2   Appendix N / The International Reference Alphabet
                      A familiar example of data is text or character strings. While textual data are most
                      convenient for human beings, they cannot, in character form, be easily stored or
                      transmitted by data processing and communications systems. Such systems are
                      designed for binary data. Thus, a number of codes have been devised by which char-
                      acters are represented by a sequence of bits. Perhaps the earliest common example
                      of this is the Morse code. Today, the most commonly used text code is the Interna-
                      tional Reference Alphabet (IRA).1 Each character in this code is represented by a
                      unique 7-bit binary code; thus, 128 different characters can be represented. Table N.1
                      lists all of the code values. In the table, the bits of each character are labeled from b7,
                      which is the most significant bit, to b1, the least significant bit. Characters are of two
                      types: printable and control (see Table N.2). Printable characters are the alphabetic,
                      numeric, and special characters that can be printed on paper or displayed on a screen.
                      For example, the bit representation of the character “K” is b7b6b5b4b3b2b1 = 1001011.
                      Some of the control characters have to do with controlling the printing or displaying


            Table N.1 The International Reference Alphabet (IRA)
              Bit Position
                         b7                        0        0        0        0        1        1       1        1
                                 b6                0        0        1        1        0        0       1        1
                                          b5       0        1        0        1        0        1       0        1
                b4       b3      b2       b1
                0            0    0       0      NUL      DLE       SP        0       @        P         ‘       p
                0            0    0       1      SOH      DC1        !        1       A        Q        a        q
                0            0    1       0       STX     DC2        ”        2        B       R        b        r
                0            0    1       1       ETX     DC3        #        3        C        S        c       s
                0            1    0       0      EOT       DC4       $        4       D        T        d         t
                0            1    0       1      ENQ      NAK        %        5        E       U        e        u
                0            1    1       0      ACK      SYN        &        6        F       V         f       v
                0            1    1       1       BEL     ETB        ’        7       G        W         g       w
                1            0    0       0       BS      CAN        (        8       H        X        h        x
                1            0    0       1       HT       EM        )        9        I       Y         i       y
                1            0    1       0        LF     SUB        *        :        J       Z         j       z
                1            0    1       1       VT       ESC       +        ;        K        [       k         {
                1            1    0       0        FF       FS       ,        <        L        \        l        |
                1            1    0       1       CR       GS        −        =       M         ]       m         }
                1            1    1        0      SO       RS        .        >        N       ^]       n        ~
                1            1    1        1       SI      US        /        ?       O         _       o       DEL



                      1
                        IRA is defined in ITU-T Recommendation T.50 and was formerly known as International Alphabet
                      Number 5 (IA5). The U.S. national version of IRA is referred to as the American Standard Code for
                      Information Interchange (ASCII).




Z19_STAL4290_09_GE_APPN.indd 2                                                                                            4/18/17 7:35 AM

<!-- pág. 1081 -->

                                                           The International Reference Alphabet   N-3

            Table N.2     IRA Control Characters
              Format Control
              BS (Backspace): Indicates movement of the print-        VT (Vertical Tab): Indicates movement of the printing
                ing mechanism or display cursor backward one            mechanism or display cursor to the next of a series
                position.                                               or preassigned printing lines.
              HT (Horizontal Tab): Indicates movement of the          FF (Form Feed): Indicates movement of the printing
                printing mechanism or display cursor forward to         mechanism or display cursor to the starting position
                the next preassigned “tab” or stopping position.        of the next page, form, or screen.
              LF (Line Feed): Indicates movement of the printing      CR (Carriage Return): Indicates movement of the
                mechanism or display cursor to the start of the         printing mechanism or display cursor to the starting
                next line.                                              position of the same line.
              Transmission Control
              SOH (Start of Heading): Used to indicate the start      ACK (Acknowledge): A character transmitted by a
                of a heading, which may contain address or rout-        receiving device as an affirmation response to a sender.
                ing information.                                        It is used as a positive response to polling messages.
              STX (Start of Text): Used to indicate the start of      NAK (Negative Acknowledgment): A character trans-
                the text and so also indicates the end of the           mitted by a receiving device as a negative response
                heading.                                                to a sender. It is used as a negative response to poll-
              ETX (End of Text): Used to terminate the text that        ing messages.
                was started with STX.                                 SYN (Synchronous/Idle): Used by a synchronous trans-
              EOT (End of Transmission): Indicates the end of a         mission system to achieve synchronization. When no
                transmission, which may have included one or            data is being sent a synchronous transmission sys-
                more “texts” with their headings.                       tem may send SYN characters continuously.
              ENQ (Enquiry): A request for a response from a          ETB (End of Transmission Block): Indicates the end of
                remote station. It may be used as a “WHO ARE            a block of data for communication purposes. It is
                YOU” request for a station to identify itself.          used for blocking data where the block structure is
                                                                        not necessarily related to the processing format.
              Information Separator
              FS (File Separator)                                     Information separators to be used in an optional man-
              GS (Group Separator)                                    ner except that their hierarchy shall be FS (the most
              RS (Record Separator)                                   inclusive) to US (the least inclusive)
              US (Unit Separator)
              Miscellaneous
              NUL (Null): No character. Used for filling in time      DLE (Data Link Escape): A character that shall
                 or filling space on tape when there are no data.       change the meaning of one or more contiguously
              BEL (Bell): Used when there is need to call human         following characters. It can provide supplementary
                 attention. It may control alarm or attention           controls, or permits the sending of data characters
                 devices.                                               having any bit combination.
              SO (Shift Out): Indicates the code combinations         DC1, DC2, DC3, DC4 (Device Controls): Characters
                 that follow shall be interpreted as outside of the     for the control of ancillary devices or special termi-
                 standard character set until a SI character is         nal features.
                 reached.                                             CAN (Cancel): Indicates the data that precedes it in a
              SI (Shift In): Indicates the code combinations that       message or block should be disregarded (usually
                 follow shall be interpreted according to the stan-     because an error has been detected).
                 dard character set.                                  EM (End of Medium): Indicates the physical end of a
              DEL (Delete): Used to obliterate unwanted charac-         tape or other medium, or the end of the required or
                 ters; for example by overwriting.                      used portion of the medium.
              SP (Space): A nonprinting character used to sepa-       SUB (Substitute): Substituted for a character that is
                 rate words, or to move the printing mechanism or       found to be erroneous or invalid.
                 display cursor forward by one position.              ESC (Escape): A character intended to provide code
                                                                        extension in that it gives a specified number of con-
                                                                        tinuously following characters an alternate meaning.




Z19_STAL4290_09_GE_APPN.indd 3                                                                                                     4/18/17 7:35 AM

<!-- pág. 1082 -->

            N-4   Appendix N / The International Reference Alphabet
                      of characters; an example is carriage return. Other control characters are concerned
                      with communications procedures.
                            IRA-encoded characters are almost always stored and transmitted using 8 bits
                      per character. In that case, the eighth bit is a parity bit used for error detection. The
                      parity bit is the most significant bit and is therefore labeled b8. This bit is set such that
                      the total number of binary 1s in each octet is always odd (odd parity) or always even
                      (even parity). Thus a transmission error that changes a single bit, or any odd number
                      of bits, can be detected.




Z19_STAL4290_09_GE_APPN.indd 4                                                                                        4/18/17 7:35 AM

<!-- pág. 1083 -->

            aPPENDIX o
                                 BaCI: THE BEN-arI CoNcUrrENt
                                    Programming System
                      O.1        Introduction
                      O.2        Baci
                                    System Overview
                                    Concurrency Constructs in BACI
                                    How to Obtain BACI
                      O.3        Examples Of Baci Programs
                      O.4        Baci Projects
                                    Implementation of Synchronization Primitives
                                    Semaphores, Monitors, and Implementations
                      O.5        Enhancements To The Baci System




                                                                                   O-1




Z20_STAL4290_09_GE_APPO.indd 1                                                           4/18/17 7:35 AM

<!-- pág. 1084 -->

            O-2   Appendix o / BACI: The Ben-Ari Concurrent Programming System

               O.1 INTRODUCTION

                      In Chapter 5, concurrency concepts are introduced (e.g., mutual exclusion and the
                      critical section problem) and synchronization techniques are proposed (e.g., sema-
                       phores, monitors, and message passing). Deadlock and starvation issues for concur-
                       rent programs are discussed in Chapter 6. Due to the increasing emphasis on parallel
                       and distributed computing, understanding concurrency and synchronization is more
                       necessary than ever. To obtain a thorough understanding of these concepts, practical
                       experience writing concurrent programs is needed.
                              Three options exist for this desired “hands-on” experience. First, we can write
                       concurrent programs with an established concurrent programming language such as
                       Concurrent Pascal, Modula, Ada, or the SR Programming Language. To experiment
                       with a variety of synchronization techniques, however, we must learn the syntax of
                       many concurrent programming languages. Second, we can write concurrent programs
                       using system calls in an operating system such as UNIX. It is easy, however, to be
                       distracted from the goal of understanding concurrent programming by the details and
                       peculiarities of a particular operating system (e.g., details of the semaphore system
                       calls in UNIX). Lastly, we can write concurrent programs with a language developed
                       specifically for giving experience with concurrency concepts such as the Ben-Ari
                       Concurrent Interpreter (BACI). Using such a language offers a variety of synchroni-
                       zation techniques with a syntax that is usually familiar. Languages developed specifi-
                       cally for giving experience with concurrency concepts are the best option to obtain
                       the desired hands-on experience.
                              Section O.2 contains a brief overview of the BACI system and how to obtain
                       the system. Section O.3 contains examples of BACI programs, and Section O.4
                      ­contains a discussion of projects for practical concurrency experience at the imple-
                       mentation and programming levels. Lastly, Section O.5 contains a description of
                       enhancements to the BACI system that have been made.


               O.2 BACI

                      System Overview
                      BACI is a direct descendant of Ben-Ari’s modification to sequential Pascal (Pascal-S).
                      Pascal-S is a subset of standard Pascal by Wirth, without files, except INPUT and
                      OUTPUT, sets, pointer variables, and goto statements. Ben-Ari took the Pascal-S
                      language and added concurrent programming constructs such as the cobegin...
                      coend construct and the semaphore variable type with wait and signal opera-
                      tions. BACI is Ben-Ari’s modification to Pascal-S with additional synchronization
                      features (e.g., monitors) as well as encapsulation mechanisms to ensure that a user is
                      prevented from modifying a variable inappropriately (e.g., a semaphore variable
                      should only be modified by semaphore functions).
                            BACI simulates concurrent process execution and supports the following syn-
                      chronization techniques: general semaphores, binary semaphores, and monitors. The
                      BACI system is composed of two subsystems, as illustrated in Figure O.1. The first




Z20_STAL4290_09_GE_APPO.indd 2                                                                                  4/18/17 7:35 AM

<!-- pág. 1085 -->

                                                                                                  O.2 / BACI   O-3

                                          Compilers                            Interpreter

                                      bacc pgrm-name                          keyboard input

                      pgrmname.cm                            successful                                 correct
                                            bacc                                                       execution
                                                            compilation
                                                                                                        output
                                                            object file
                                                          pgrmname.pco            bainterp
                                                                                                        incorrect
                                                         compilation listing                           execution
                      pgrmname.pm           bapas          pgrmname.lst      bainterp pgrm-name         output

                                    bapas pgrm-name
                                                            compilation
                                                               errors



                                                            text editor


              Figure O.1



                      subsystem, the compiler, compiles a user’s program into intermediate object code,
                      called PCODE. There are two compilers available with the BACI system, corre-
                      sponding to two popular languages taught in introductory programming courses.
                      The syntax of one compiler is similar to standard Pascal; BACI programs that use
                      the Pascal syntax are denoted as pgrm-name.pm. The syntax of the other compiler
                      is similar to standard C + +; these BACI programs are denoted as pgrm-name.cm.
                      Both compilers create two files during the compilation: pgrm-name.lst and pgrm-
                      name.pco.
                            The second subsystem in the BACI system, the interpreter, executes the object
                      code created by the compiler. In other words, the interpreter executes pgrm-name.
                      pco. The core of the interpreter is a preemptive scheduler; during execution, this
                      scheduler randomly swaps between concurrent processes, thus simulating a parallel
                      execution of the concurrent processes. The interpreter offers a number of different
                      debug options, such as single-step execution, disassembly of PCODE instructions,
                      and display of program storage locations.

                      Concurrency Constructs in BACI
                      In the rest of this appendix, we focus on the compiler similar to standard C + +. We
                      call this compiler C - -; although the syntax is similar to C + +, it does not include
                      inheritance, encapsulation, or other object-oriented programming features. In this
                      section, we give an overview of the BACI concurrency constructs; see the user’s
                      guides at the BACI website for further details of the required Pascal or C - - BACI
                      syntax.

                      cobegin A list of processes to be run concurrently is enclosed in a cobegin block.
                      Such blocks cannot be nested and must appear in the main program.

                             cobegin { proc1(...); proc2(...); ... ; procN(...); }




Z20_STAL4290_09_GE_APPO.indd 3                                                                                       4/18/17 7:35 AM

<!-- pág. 1086 -->

            O-4   Appendix o / BACI: The Ben-Ari Concurrent Programming System
                      The PCODE statements created by the compiler for the above block are interleaved
                      by the interpreter in an arbitrary, “random” order; multiple executions of the same
                      program containing a cobegin block will appear to be nondeterministic.


                      Semaphores A semaphore in BACI is a nonnegative-valued int variable, which
                      can only be accessed by the semaphore calls defined subsequently. A binary
                      semaphore in BACI, one that only assumes the values 0 and 1, is supported by the
                      binarysem subtype of the semaphore type. During compilation and execution, the
                      compiler and interpreter enforce the restrictions that a binarysem variable can only
                      have the values 0 or 1 and that semaphore type can only be nonnegative. BACI
                      semaphore calls include
                          • initialsem(semaphore sem, int expression)
                          • p(semaphore sem): If the value of sem is greater than zero, then the inter-
                            preter decrements sem by one and returns, allowing p’s caller to continue. If the
                            value of sem is equal to zero, then the interpreter puts p’s caller to sleep. The
                            command wait is accepted as a synonym for p.
                          • v(semaphore sem): If the value of sem is equal to zero and one or more
                            processes are sleeping on sem, then wake up one of these processes. If no pro-
                            cesses are waiting on sem, then increment sem by one. In any event, v’s caller
                            is allowed to continue. (BACI conforms to Dijkstra’s original semaphore pro-
                            posal by randomly choosing which process to wake up when a signal arrives.)
                            The command signal is accepted as a synonym for v.


                      Monitors BACI supports the monitor concept, with some restrictions. A monitor
                      is a C + + block, like a block defined by a procedure or function, with some
                      additional properties (e.g., conditional variables). In BACI, a monitor must be
                      declared at the outermost, global level and it cannot be nested with another monitor
                      block. Three constructs are used by the procedures and functions of a monitor to
                      control concurrency: condition variables, waitc (wait on a condition), and
                      signalc (signal a condition). A condition never actually has a value; it is
                      somewhere to wait or something to signal. A monitor process can wait for a
                      condition to hold or signal that a given condition now holds through the waitc
                      and signalc calls. waitc and signalc calls have the following syntax and
                      semantics:
                          • waitc(condition cond, int prio): The monitor process (and hence the
                            outside process calling the monitor process) is blocked on the condition cond
                            and assigned the priority prio.
                          • waitc(condition cond): This call has the same semantics as the waitc
                            call, but the wait is assigned a default priority of 10.
                          • signalc(condition cond): Wake some process waiting on cond with the
                            smallest (highest) priority; if no process is waiting on cond, do nothing.




Z20_STAL4290_09_GE_APPO.indd 4                                                                                  4/18/17 7:35 AM

<!-- pág. 1087 -->

                                                             O.3 / EXAMPLES OF BACI PROGRAMS   O-5

                             BACI conforms to the immediate resumption requirement. In other words, a
                      process waiting on a condition has priority over a process trying to enter the monitor,
                      if the process waiting on a condition has been signaled.

                      Other Concurrency Constructs The C - - BACI compiler provides several
                      low-level concurrency constructs that can be used to create new concurrency control
                      primitives. If a function is defined as atomic, then the function is nonpreemptible. In
                      other words, the interpreter will not interrupt an atomic function with a context
                      switch. In BACI, the suspend function puts the calling process to sleep and the revive
                      function revives a suspended process.

                      How to Obtain BACI
                      The BACI system, with two user guides (one for each of the two compilers) and detailed
                      project descriptions, is available at the BACI website at http://inside.mines.edu/fs_
                      home/tcamp/baci/baci_index.html. The BACI system is written in both C and Java. The
                      C version of the BACI system can be compiled in Linux, RS/6000 AIX, Sun OS, DOS,
                      and CYGWIN on Windows with minimal modifications to the Makefile file. (See the
                      README file in the distribution for installation details for a given platform.)


               O.3 EXAMPLES OF BACI PROGRAMS

                      In Chapters 5 and 6, a number of the classical synchronization problems were dis-
                      cussed (e.g., the readers/writers problem and the dining philosophers problem). In
                      this section, we illustrate the BACI system with three BACI programs. Our first
                      example illustrates the nondeterminism in the execution of concurrent processes in
                      the BACI system. Consider the following program:

                             const int m = 5;
                             int n;
                             void incr(char id)
                             {
                               int i;
                                   for(i = 1; i <= m; i = i + 1)
                                    {
                                      n = n + 1;
                                      cout << id << ” n =” << n << ” i =”;
                                      cout << i << ” ” << id << endl;
                                    }
                             }
                             main()
                             {
                                   n = 0;
                                   cobegin {




Z20_STAL4290_09_GE_APPO.indd 5                                                                                  4/18/17 7:35 AM

<!-- pág. 1088 -->

            O-6   Appendix o / BACI: The Ben-Ari Concurrent Programming System
                                    incr( ’A’); incr( ’B’ ); incr(’C’);
                                    }
                                   cout << ”The sum is ” << n << endl;
                             }

                            Note in the preceding program that if each of the three processes created
                      (A, B, and C) executed sequentially, the output sum would be 15. Concurrent execu-
                      tion of the statement n = n + 1; however, can lead to different values of the output
                      sum. After we compiled the preceding program with BACI, we executed the PCODE
                      file with bainterp a number of times. Each execution produced output sums
                      between 9 and 15. One sample execution produced by the BACI interpreter is the
                      following.

                             Source file: incremen.cm Fri Aug 1 16:51:00 1997
                             CB n = 2 i =1 C n =2
                             A n = 2 i =1 i =1 A
                             CB
                                  n = 3 i = 2 C
                             A n = 4 i = 2 C n = 5 i = 3 C
                             A
                             B n = 6C i = 2 B
                                  n = 7 i = 4 C
                             A n = 8 i = 3 A
                             BC n = 10 n = 10 i = 5 C
                             A n = i = 311 i = 4 A
                               B
                             A n = 12 i = B5 n = 13A
                                  i = 4 B
                             B n = 14 i = 5 B
                             The sum is 14

                             Special machine instructions are needed to synchronize the access of processes
                      to a common main memory. Mutual exclusion protocols, or synchronization primi-
                      tives, are then built on top of these special instructions. In BACI, the interpreter will
                      not interrupt a function defined as atomic with a context switch. This feature allows
                      users to implement these low-level special machine instructions. For example, the
                      following program is a BACI implementation of the testset function. A testset instruc-
                      tion tests the value of the function’s argument i. If the value of i is zero, the function
                      replaces it with 1 and returns true; otherwise, the function does not change the value
                      of i and returns false. As discussed in Section 5.2, special machine instructions (e.g.,
                      testset) allow more than one action to occur without interruption. BACI has an
                      atomic keyword defined for this purpose.

                             // Test and set instruction
                             //
                             atomic int testset(int& i)




Z20_STAL4290_09_GE_APPO.indd 6                                                                                     4/18/17 7:35 AM

<!-- pág. 1089 -->

                                                             O.3 / EXAMPLES OF BACI PROGRAMS   O-7

                             {
                                   if (i == 0) {
                                     i = 1;
                                     return 1;
                                   }
                                   else
                                     return 0;
                             }

                            We can use testset to implement mutual exclusion protocols, as shown in the
                      following program. This program is a BACI implementation of a mutual exclusion
                      program based on the test and set instruction. The program assumes three concurrent
                      processes; each process requests mutual exclusion 10 times.

                             int bolt = 0;
                             const int RepeatCount = 10;
                             void proc(int id)
                             {
                                  int i = 0;
                                  while(i < RepeatCount) {
                                    while (testset(bolt)); // wait
                                          // enter critical section
                                    cout << id;
                                          // leave critical section
                                    bolt = 0;
                                    i++;
                                  }
                             }
                             main()
                             {
                                  cobegin {
                                    proc(0); proc(1); proc(2);
                                  }
                             }

                            The following two programs are a BACI solution to the bounded-buffer pro-
                      ducer/consumer problem with semaphores (see Figure 5.13). In this example, we have
                      two producers, three consumers, and a buffer size of five. We first list the program
                      details for this problem. We then list the included file that defines the bounded-buffer
                      implementation.

                             // A solution to the bounded-buffer producer/consumer
                             problem
                             // Stallings, Figure 5.13
                             // bring in the bounded-buffer machinery




Z20_STAL4290_09_GE_APPO.indd 7                                                                                   4/18/17 7:35 AM

<!-- pág. 1090 -->

            O-8   Appendix o / BACI: The Ben-Ari Concurrent Programming System
                             #include “boundedbuff.inc”
                             const int ValueRange = 20; // integers in 0..19 will be
                                                            produced
                             semaphore to; // for exclusive access to terminal output
                             semaphore s; // mutual exclusion for the buffer
                             semaphore n; // # consumable items in the buffer
                             semaphore e; // # empty spaces in the buffer
                             int produce(char id)
                             {
                                  int tmp;
                                  tmp = random(ValueRange);
                                  wait(to);
                                  cout << “Producer ” << id << “ produces ” << tmp
                                     << endl;
                                  signal(to);
                                  return tmp;
                             }
                             void consume(char id, int i)
                             {
                                  wait(to);
                                  cout << “Consumer ” << id << “ consumes ” << i
                                     << endl;
                                  signal(to);
                             }
                             void producer(char id)
                             {
                                  int i;
                                  for (;;) {
                                    i = produce(id);
                                    wait(e);
                                    wait(s);
                                    append(i);
                                    signal(s);
                                    signal(n);
                                  }
                             }
                             void consumer(char id)
                             {
                                  int i;
                                  for (;;) {
                                    wait(n);
                                    wait(s);
                                    i = take();
                                    signal(s);




Z20_STAL4290_09_GE_APPO.indd 8                                                          4/18/17 7:35 AM

<!-- pág. 1091 -->

                                                           O.3 / EXAMPLES OF BACI PROGRAMS   O-9

                                   signal(e);
                                   consume(id,i);
                                  }
                             }
                             main()
                             {
                                  initialsem(s,1);
                                  initialsem(n,0);
                                  initialsem(e,SizeOfBuffer);
                                  initialsem(to,1);
                                  cobegin {
                                    producer(’A’); producer(’B’);
                                    consumer(’x’); consumer(’y’); consumer(’z’);
                                  }
                             }

                             // boundedbuff.inc -- bounded buffer include file
                             const int SizeOfBuffer = 5;
                             int buffer[SizeOfBuffer];
                             int in = 0; // index of buffer to use for next append
                             int out = 0; // index of buffer to use for next take
                             void append(int v)
                                   // add v to the buffer
                                   // overrun is assumed to be taken care of
                                   // externally through semaphores or conditions
                             {
                                   buffer[in] = v;
                                   in = (in + 1) % SizeOfBuffer;
                             }
                             int take()
                                   // return an item from the buffer
                               // underrun is assumed to be taken care of
                               // externally through a semaphore or condition
                             {
                                   int tmp;
                                   tmp = buffer[out];
                                   out = (out + 1) % SizeOfBuffer;
                                   return tmp;
                             }

                            One sample execution of the preceding bounded-buffer solution in BACI is the
                      following.

                             Source file: semprodcons.cm Fri Aug 1 12:36:55 1997
                             Producer B produces 4




Z20_STAL4290_09_GE_APPO.indd 9                                                                             4/18/17 7:35 AM

<!-- pág. 1092 -->

            O-10   Appendix o / BACI: The Ben-Ari Concurrent Programming System
                             Producer A produces 13
                             Producer B produces 12
                             Producer A produces 4
                             Producer B produces 17
                             Consumer x consumes 4
                             Consumer y consumes 13
                             Producer A produces 16
                             Producer B produces 11
                             Consumer z consumes 12
                             Consumer x consumes 4
                             Consumer y consumes 17
                             Producer B produces 6
                             ...


               O.4 BACI PROJECTS

                      In this section, we discuss two general types of projects one can implement in BACI.
                      We first discuss projects that involve the implementation of low-level operations (e.g.,
                      special machine instructions that are used to synchronize the access of processes to
                      a common main memory). We then discuss projects that are built on top of these
                      low-level operations (e.g., classical synchronization problems). For more information
                      on these projects, see the project descriptions included in the BACI distribution. For
                      solutions to some of these projects, teachers should contact the authors. In addition
                      to the projects discussed in this section, many of the problems at the end of Chapter 5
                      and Appendix A can be implemented in BACI.

                      Implementation of Synchronization Primitives
                      Implementation of Machine Instructions There are numerous machine
                      instructions that one can implement in BACI. For example, one can implement the
                      compare-and-swap or the exchange instruction discussed in Figure 5.2. The
                      implementation of these instructions should be based on an atomic function that
                      returns an int value. You can test your implementation of the machine instruction by
                      building a mutual exclusion protocol on top of your low-level operation.

                      Implementation of Fair Semaphores (FIFO) The semaphore operation in
                      BACI is implemented with a random wake up order, which is how semaphores were
                      originally defined by Dijkstra. As discussed in Section 5.3, however, the fairest policy
                      is FIFO. One can implement semaphores with this FIFO wake up order in BACI.
                      At least the following four procedures should be defined in the implementation:
                          • CreateSemaphores() to initialize the program code
                          • InitSemaphore(int sem-index) to initialize the semaphore represented
                            by sem-index
                          • FIFOP(int sem-index)
                          • FIFOV(int sem-index)




Z20_STAL4290_09_GE_APPO.indd 10                                                                                  4/18/17 7:35 AM

<!-- pág. 1093 -->

                                                                               O.4 / BACI PROJECTS   O-11

                           This code needs to be written as a system implementation and, as such, should
                      handle all possible errors. In other words, the semaphore designer is responsible for
                      producing code that is robust in the presence of ignorant, stupid, or even malicious
                      use by the user community.

                      Semaphores, Monitors, and Implementations
                      There are many classical concurrent programming problems: the producer/consumer
                      problem, the dining philosophers, the reader/writer problem with different priorities,
                      the sleeping barber problem, and the cigarette smoker’s problem. All of these prob-
                      lems can be implemented in BACI. In this section, we discuss nonstandard sema-
                      phore/monitor projects that one can implement in BACI to further aid the
                      understanding of concurrency and synchronization concepts.

                      A’s and B’s and Semaphores For the following program outline in BACI,

                             // global semaphore declarations here
                             void A()
                             {
                                  p()’s and v()’s ONLY
                             }
                             void B()
                             {
                                  p()’s and v()’s ONLY
                             }
                             main()
                             {
                                  // semaphore initialization here
                                  cobegin {
                                    A(); A(); A(); B(); B();
                                  }
                             }

                      complete the program using the least number of general semaphores, such that the
                      processes ALWAYS terminate in the order A (any copy), B (any copy), A (any copy),
                      A, B. Use the -t option of the interpreter to display process termination. (Many varia-
                      tions of this project exist. For example, have four concurrent processes terminated in
                      the order ABAA or eight concurrent processes terminated in the order
                      AABABABB.)

                      Using Binary Semaphores Repeat the previous project using binary semaphores.
                      Evaluate why assignment and IF-THEN-ELSE statements are necessary in this
                      solution, although they were not necessary in solutions to the previous project. In
                      other words, explain why you cannot use only Ps and Vs in this case.

                      Busy Waiting versus Semaphores Compare the performance of a solution to
                      mutual exclusion that uses busy waiting (e.g., the testset instruction) to a solution that
                      uses semaphores. For example, compare a semaphore solution and a testset solution




Z20_STAL4290_09_GE_APPO.indd 11                                                                                    4/18/17 7:35 AM

<!-- pág. 1094 -->

            O-12   Appendix o / BACI: The Ben-Ari Concurrent Programming System
                      to the ABAAB project discussed previously. In each case, use a large number of
                      executions (say, 1000) to obtain better statistics. Discuss your results, explaining why
                      one implementation is preferred over another.

                      Semaphores and Monitors In the spirit of Problem 5.17, implement a monitor
                      using general semaphores, then implement a general semaphore using a monitor in
                      BACI.

                      General and Binary Semaphores Prove that general semaphores and binary
                      semaphores are equally powerful, by implementing one type of semaphore with the
                      other type of semaphore and vice versa.

                      Time Ticks: A Monitor Project Write a program containing a monitor
                      AlarmClock. The monitor must have an int variable theClock (initialized to zero)
                      and two functions:
                          • Tick(): This function increments theClock each time that it is called. It can
                            do other things, like signalc, if needed.
                          • int Alarm(int id, int delta): This function blocks the caller with
                            identifier id for at least delta ticks of theClock.
                             The main program should have two functions as well:
                          • void Ticker(): This procedure calls Tick() in a repeat-forever loop.
                          • void Thread(int id, int myDelta): This function calls Alarm in a
                            repeat-forever loop.
                           You may endow the monitor with any other variables that it needs. The monitor
                      should be able to accommodate up to five simultaneous alarms.

                      A Problem of a Popular Baker Due to the recent popularity of a bakery, almost
                      every customer needs to wait for service. To maintain service, the baker wants to
                      install a ticket system that will ensure customers are served in turn. Construct a BACI
                      implementation of this ticket system.


               O.5 ENHANCEMENTS TO THE BACI SYSTEM

                      We have enhanced the BACI System in several ways:
                         1. We have implemented the BACI system in Java (JavaBACI). This, along with
                            our original C implementation of BACI, is available from: http://inside.mines
                            .edu/fs_home/tcamp/baci/baci_index.html. The JavaBACI classes and source
                            files are stored in self-extracting Java .jar files. JavaBACI includes all BACI
                            applications: C and Pascal compilers, disassembler, archiver, linker, and com-
                            mand-line and GUI PCODE interpreters. The input, behavior, and output of
                            programs in JavaBACI are identical to the input, behavior, and output of pro-
                            grams in our C implementation of BACI; we note that, in JavaBACI, students




Z20_STAL4290_09_GE_APPO.indd 12                                                                                  4/18/17 7:35 AM

<!-- pág. 1095 -->

                                                    O.5 / ENHANCEMENTS TO THE BACI SYSTEM   O-13

                            continue to write concurrency programs in C - - or Pascal (not Java). JavaBACI
                            will execute on any computer that has an installation of the Java Virtual
                            Machine.
                         2. We have added graphical user interfaces (GUIs) for JavaBACI and the UNIX
                            version of BACI in C. The windowing environments of these GUIs allow a user
                            to monitor all aspects of the execution of a BACI program; specifically, a user
                            can set and remove breakpoints (either by PCODE address or source line),
                            view variables values, runtime stacks, and process tables, and examine inter-
                            leaved PCODE execution. The BACI GUIs are available at the BACI GUI Web
                            site http://inside.mines.edu/fs_home/tcamp/baci/index_gui.html. For an alterna-
                            tive GUI, see below.
                         3. We have created a distributed version of BACI. Similar to concurrent programs,
                            it is difficult to prove the correctness of distributed programs without an imple-
                            mentation. Distributed BACI allows distributed programs to be easily imple-
                            mented. In addition to proving the correctness of a distributed program, one
                            can use distributed BACI to test the program’s performance. Distributed BACI
                            is available at the following website: http://inside.mines.edu/fs_home/tcamp
                            /baci/dbaci.html.
                         4. We have a PCODE disassembler that will provide the user with an annotated
                            listing of a PCODE file, showing the mnemonics for each PCODE instruction
                            and, if available, the corresponding program source that generated the instruc-
                            tion. This PCODE disassembler is included in the BACI System.
                         5. We have added the capability of separate compilation and external variables to
                            both compilers (C and Pascal). The BACI System includes an archiver and a
                            linker that enable the creation and use of libraries of BACI PCODE. For more
                            details, see the BACI Separate Compilation User’s Guide.
                             The BACI system has also been enhanced by others.
                         1. David Strite, an M.S. student who worked with Linda Null from the ­Pennsylvania
                            State University, created a BACI Debugger: A GUI Debugger for the BACI
                            System. This GUI is available at http://cs.hbg.psu.edu/~null/baci.
                         2. Using BACI and the BACI GUI from Pennsylvania State University, Moti Ben-
                            Ari from the Weizmann Institute of Science in Israel created an integrated
                            development environment for learning concurrent programming by simulating
                            concurrency called jBACI. jBACI is available at: https://code.google.com/
                            archive/p/jbaci/.




Z20_STAL4290_09_GE_APPO.indd 13                                                                                  4/18/17 7:35 AM

<!-- pág. 1096 -->

            aPPENDIX P
                                            ProCEDUrE CoNTrol
                      P.1        Stack Implementation
                      P.2        Procedure Calls and Returns
                      P.3        Reentrant Procedures




                                                                P-1




Z21_STAL4290_09_GE_APPP.indd 1                                        4/18/17 7:37 AM

<!-- pág. 1097 -->

            P-2   Appendix P / Procedure Control
                      A common technique for controlling the execution of procedure calls and returns
                      makes use of a stack. This appendix summarizes the basic properties of stacks and
                      looks at their use in procedure control.


               P.1 STACK IMPLEMENTATION

                      A stack is an ordered set of elements, only one of which (the most recently added)
                      can be accessed at a time. The point of access is called the top of the stack. The num-
                      ber of elements in the stack, or length of the stack, is variable. Items may only be
                      added to or deleted from the top of the stack. For this reason, a stack is also known
                      as a pushdown list or a last-in-first-out (LIFO) list.
                            The implementation of a stack requires that there be some set of locations used
                      to store the stack elements. A typical approach is illustrated in Figure P.1. A contigu-
                      ous block of locations is reserved in main memory (or virtual memory) for the stack.
                      Most of the time, the block is partially filled with stack elements and the remainder
                      is available for stack growth. Three addresses are needed for proper operation, and
                      these are often stored in processor registers:
                          • Stack pointer: Contains the address of the current top of the stack. If an item
                            is appended to (PUSH) or deleted from (POP) the stack, the pointer is decre-
                            mented or incremented to contain the address of the new top of the stack.

                                               Processor            Main
                                               registers           memory

                                      Stack
                                      limit



                                      Stack
                                     pointer




                                                                                             Descending addresses
                                      Stack                          Free
                                      base
                                                                                 Block
                                                                                 reserved
                                                                                 for stack
                                                                    In use




                                     Figure P.1   Typical Stack Organization (full/descending)




Z21_STAL4290_09_GE_APPP.indd 2                                                                                      4/18/17 7:37 AM

<!-- pág. 1098 -->

                                                                      P.2 / PROCEDURE CALLS AND RETURNS   P-3

                          • Stack base: Contains the address of the bottom location in the reserved block.
                            This is the first location to be used when an item is added to an empty stack. If
                            an attempt is made to POP an element when the stack is empty, an error is
                            reported.
                          • Stack limit: Contains the address of the other end, or top, of the reserved block.
                            If an attempt is made to PUSH an element when the stack is full, an error is
                            reported.
                            Traditionally, and on most processors today, the base of the stack is at the high-
                      address end of the reserved stack block, and the limit is at the low-address end. Thus,
                      the stack grows from higher addresses to lower addresses.


               P.2 PROCEDURE CALLS AND RETURNS

                      A common technique for managing procedure calls and returns makes use of a stack.
                      When the processor executes a call, it places (pushes) the return address on the stack.
                      When it executes a return, it uses the address on top of the stack and removes (pops)
                      that address from the stack. For the nested procedures of Figure P.2, Figure P.3 illus-
                      trates the use of a stack.
                            It is also often necessary to pass parameters with a procedure call. These could
                      be passed in registers. Another possibility is to store the parameters in memory just

                                 Addresses       Main Memory
                                     4000

                                                                        Main
                                     4100        CALL Proc1
                                     4101                               Program



                                     4500


                                     4600        CALL Proc2
                                     4601                               Procedure
                                     4650        CALL Proc2             Proc1
                                     4651

                                                   RETURN


                                     4800
                                                                        Procedure
                                                                        Proc2


                                                   RETURN


                                              (a) Calls and returns                    (b) Execution sequence

                                 Figure P.2   Nested Procedures




Z21_STAL4290_09_GE_APPP.indd 3                                                                                   4/18/17 7:37 AM

<!-- pág. 1099 -->

            P-4   Appendix P / Procedure Control




                                                                                         4601

                                                                    4101                 4101                 4101
                                              •                       •                    •                    •

                                      (a) Initial stack           (b) After           (c) Initial           (d) After
                                          contents               CALL Proc1          CALL Proc2             RETURN




                                                          4651
                                                          4101                4101
                                                            •                   •                   •

                                                    (e) After              (f) After            (g) After
                                                   CALL Proc2              RETURN               RETURN
                                 Figure P.3       Use of Stack to Implement Nested Procedures of Figure P.2


                      after the Call instruction. In this case, the return must be to the location following the
                      parameters. Both of these approaches have drawbacks. If registers are used, the called
                      program and the calling program must be written to assure that the registers are used
                      properly. The storing of parameters in memory makes it difficult to exchange a vari-
                      able number of parameters.
                            A more flexible approach to parameter passing is the stack. When the processor
                      executes a call, it not only stacks the return address, it stacks parameters to be passed
                      to the called procedure. The called procedure can access the parameters from the
                      stack. Upon return, return parameters can also be placed on the stack, under the
                      return address. The entire set of parameters, including return address, that is stored
                      for a procedure invocation is referred to as a stack frame.
                            An example is provided in Figure P.4. The example refers to procedure P in
                      which the local variables x1 and x2 are declared, and procedure Q, which can be called
                      by P and in which the local variables y1 and y2 are declared. The first item stored in
                      each stack frame is a pointer to the beginning of the previous frame. This is needed
                      if the number or length of parameters to be stacked is variable. Next is stored the
                      return point for the procedure that corresponds to this stack frame. Finally, space is
                      allocated at the top of the stack frame for local variables. These local variables can
                      be used for parameter passing. For example, suppose when P calls Q, it passes one
                      parameter value. This value could be stored in variable y1. Thus, in a high-level lan-
                      guage, there would be an instruction in the P routine that looks like this:
                                                                    CALL Q(y1)
                      When this call is executed, a new stack frame is created for Q (see Figure P.4b), which
                      includes a pointer to the stack frame for P, the return address to P, and two local




Z21_STAL4290_09_GE_APPP.indd 4                                                                                          4/18/17 7:37 AM

<!-- pág. 1100 -->

                                                                       P.3 / REENTRANT PROCEDURES   P-5




                                                                                                   top of
                                                                                  y2
                                                                                                   stack pointer
                                                                                  y1

                                                                            Return address
                                                                            Previous frame         current
                                                                      Q:
                                                                                pointer            frame
                                                      top of                                       pointer
                                        x2                                        x2
                                                      stack pointer

                                        x1                                        x1

                                 Return address                             Return address
                                 Previous frame       current               Previous frame
                           P:        pointer          frame           P:        pointer
                                                      pointer
                                 (a) P is active                           (b) P has called Q

                           Figure P.4    Stack Frame Growth Using Sample Procedures P and Q


                      variables for Q, one of which is initialized to the passed parameter value from P. The
                      other local variable, y2, is simply a local variable used by Q in its calculations. The need
                      to include such local variables in the stack frame is discussed in the next subsection.


               P.3 REENTRANT PROCEDURES

                      A useful concept, particularly in a system that supports multiple users at the same
                      time, is that of the reentrant procedure. A reentrant procedure is one in which a single
                      copy of the program code can be shared by multiple users during the same period of
                      time. Reentrancy has two key aspects: The program code cannot modify itself and the
                      local data for each user must be stored separately. A reentrant procedure can be
                      interrupted and called by an interrupting program and still execute correctly upon
                      return to the procedure. In a shared system, reentrancy allows more efficient use of
                      main memory: One copy of the program code is kept in main memory, but more than
                      one application can call the procedure.
                            Thus, a reentrant procedure must have a permanent part (the instructions that
                      make up the procedure) and a temporary part (a pointer back to the calling program
                      as well as memory for local variables used by the program). Each execution instance,
                      called activation, of a procedure will execute the code in the permanent part but must
                      have its own copy of local variables and parameters. The temporary part associated
                      with a particular activation is referred to as an activation record.
                            The most convenient way to support reentrant procedures is by means of a
                      stack. When a reentrant procedure is called, the activation record of the procedure
                      can be stored on the stack. Thus, the activation record becomes part of the stack frame
                      that is created on procedure call.




Z21_STAL4290_09_GE_APPP.indd 5                                                                                       4/18/17 7:37 AM

<!-- pág. 1101 -->

            aPPENDIX Q
                                                         ECos
                      Q.1        Configurability
                      Q.2        Ecos Components
                                     Hardware Abstraction Layer (HAL)
                                     eCos Kernel
                                     I/O System
                                     Standard C Libraries
                      Q.3        Ecos Scheduler
                                     Bitmap Scheduler
                                     Multilevel Queue Scheduler
                      Q.4        Ecos Thread Synchronization
                                     Mutexes
                                     Semaphores
                                     Condition Variables
                                     Event Flags
                                     Mailboxes
                                     Spinlocks




                                                                        Q-1




Z22_STAL4290_09_GE_APPQ.indd 1                                                4/18/17 7:36 AM

<!-- pág. 1102 -->

            Q-2   Appendix Q / eCos
                      The Embedded Configurable Operating System (eCos) is an open source, royalty-
                      free, real-time OS intended for embedded applications. The system is targeted at
                      high-performance small embedded systems. For such systems, an embedded form of
                      Linux or other commercial OS would not provide the streamlined software required.
                      The eCos software has been implemented on a wide variety of processor platforms,
                      including Intel IA32, PowerPC, SPARC, ARM, CalmRISC, MIPS, and NEC V8xx.
                      It is one of the most widely used embedded operating systems. It is implemented
                      in C/C++.


               Q.1 CONFIGURABILITY

                      An embedded OS that is flexible enough to be used in a wide variety of embedded
                      applications and on a wide variety of embedded platforms must provide more func-
                      tionality than will be needed for any particular application and platform. For exam-
                      ple, many real-time operating systems support task switching, concurrency controls,
                      and a variety of priority scheduling mechanisms. A relatively simple embedded sys-
                      tem would not need all these features.
                             The challenge is to provide an efficient, user-friendly mechanism for configur-
                      ing selected components and for enabling and disabling particular features within
                      components. The eCos configuration tool, which runs on Windows or Linux, is used
                      to configure an eCos package to run on a target embedded system. The complete
                      eCos package is structured hierarchically, making it easy (using the configuration
                      tool) to assemble a target configuration. At a top level, eCos consists of a number of
                      components, and the configuration user may select only those components needed
                      for the target application. For example, a system might have a particular serial I/O
                      device. The configuration user would select serial I/O for this configuration, then
                      select one or more specific I/O devices to be supported. The configuration tool would
                      include the minimum necessary software for that support. The configuration user can
                      also select specific parameters, such as default data rate and the size of I/O buffers
                      to be used.
                             This configuration process can be extended down to finer levels of detail, even
                      to the level of individual lines of code. For example, the configuration tool provides
                      the option of including or omitting a priority inheritance protocol.
                             Figure Q.1 shows the top level of the eCos configuration tool as seen by the tool
                      user. Each of the items on the list in the left-hand window can be selected or dese-
                      lected. When an item is highlighted, the lower right-hand window provides a descrip-
                      tion, and the upper right-hand window provides a link to further documentation plus
                      additional information about the highlighted item. Items on the list can be expanded
                      to provide a finer-grained menu of options. Figure Q.2 illustrates an expansion of the
                      eCos kernel option. In this figure, note exception handling has been selected for
                      inclusion, but SMP (symmetric multiprocessing) has been omitted. In general, com-
                      ponents and individual options can be selected or omitted. In some cases, individual
                      values can be set; for example, a minimum acceptable stack size is an integer value
                      that can be set or left to a default value.




Z22_STAL4290_09_GE_APPQ.indd 2                                                                                   4/18/17 7:36 AM

<!-- pág. 1103 -->

                                                                           Q.1 / CONFIGURABILITY   Q-3




                      Figure Q.1 
                                 eCos Configuration Tool - Top Level. Courtesy of eCosCentric Limited. Used
                                 with permission.




                      Figure Q.2 
                                 eCos Configuration Tool - Kernel Details. Courtesy of eCosCentric Limited.
                                 Used with permission.




Z22_STAL4290_09_GE_APPQ.indd 3                                                                                4/18/17 7:36 AM

<!-- pág. 1104 -->

            Q-4   Appendix Q / eCos

                                                                          Application
                                             GNU make utility
                                                                          source code




                                                                       GNU cross compiler



                                           —eCos kernel libraries
                                           —target architecture           GNU linker
                                            libraries



                                                                           Executable
                                                                              file

                                         Figure Q.3     Loading an eCos Configuration

                            Figure Q.3 shows a typical example of the overall process of creating the binary
                      image to execute in the embedded system. This process is run on a source system, such
                      as a Windows or Linux platform, and the executable image is destined to execute on a
                      target embedded system, such as a sensor in an industrial environment. At the highest
                      software level is the application source code for the particular embedded application.
                      This code is independent of eCos but makes use of application programming interfaces
                      (API) to sit on top of the eCos software. There may be only one version of the applica-
                      tion source code, or there may be variations for different versions of the target embed-
                      ded platform. In this example, the GNU make utility is used to selectively determine
                      which pieces of a program need to be compiled or recompiled (in the case of a modified
                      version of the source code) and issues the commands to recompile them. The GNU
                      cross compiler, executing on the source platform, then generates the binary executable
                      code for the target embedded platform. The GNU linker links the application object
                      code with the code generated by the eCos configuration tool. This latter set of software
                      includes selected portions of the eCos kernel plus selected software for the target
                      embedded system. The result can then be loaded into the target system.


               Q.2 eCOS COMPONENTS

                      A key design requirement for eCos is portability to different architectures and plat-
                      forms with minimal effort. To meet this requirement, eCos consists of a layered set
                      of components (see Figure Q.4).

                      Hardware Abstraction Layer (HAL)
                      At the bottom is the hardware abstraction layer (HAL). The HAL is software that
                      presents a consistent API to the upper layers and maps upper-layer operations onto
                      a specific hardware platform. Thus, the HAL is different for each hardware




Z22_STAL4290_09_GE_APPQ.indd 4                                                                                   4/18/17 7:36 AM

<!-- pág. 1105 -->

                                                                         Q.2 / eCOS COMPONENTS   Q-5


                                          User application code

                                          Standard C library

                                          I/O system (device drivers)

                                          Kernel

                                          Hardware abstraction layer


                                       Figure Q.4 eCos Layered Structure



                      platform. Figure Q.5 is an example that demonstrates how the HAL abstracts hard-
                      ware-specific implementations for the same API call on two different platforms. As
                      this example shows, the call from an upper layer to enable interrupts is the same on
                      both platforms, but the C code implementation of the function is specific to each
                      platform.



                        1 #define HAL_ENABLE_INTERRUPTS()                      \
                        2     asm volatile (                                   \
                        3         “mrs r3, cpsr;”                              \
                        4         “bic r3, r3, #0xC0;”                         \
                        5         “mrs cpsr, r3;”                              \
                        6         :                                            \
                        7         :                                            \
                        8         : “r3”                                       \
                        9         );                                           \
                                                      (a) ARM architecture


                        1 #define HAL_ENABLE_INTERRUPTS()                      \
                        2     CYG_MACRO_START                                  \
                        3     cyg_uint32 tmp1, tmp2                            \
                        4     asm volatile (                                   \
                        5         “mfmsr    %0;”                               \
                        6         “ori      %1,%1,0x800;”                      \
                        7         “r1wimi %0,%1,0,16,16;”                      \
                        8         “mtmsr    %0;”                               \
                        9         : “=r” (tmp1), “=r” (tmp2));                 \
                        10    CYG_MACRO_END                                    \
                                                    (b) PowerPC architecture
                      Figure Q.5 Two Implementations of HAL_ENABLE_INTERRUPTS() Macro




Z22_STAL4290_09_GE_APPQ.indd 5                                                                               4/18/17 7:36 AM

<!-- pág. 1106 -->

            Q-6   Appendix Q / eCos
                             The HAL is implemented as three separate modules:
                          • Architecture: Defines the processor family type. This module contains the code
                            necessary for processor startup, interrupt delivery, context switching, and other
                            functionality specific to the instruction set architecture of that processor
                            family.
                          • Variant: Supports the features of the specific processor in the family. An exam-
                            ple of a supported feature is an on-chip module such as a memory management
                            unit (MMU).
                          • Platform: Extends the HAL support to tightly coupled peripherals such as
                            interrupt controllers and timer devices. This module defines the platform or
                            board that includes the selected processor architecture and variant. It includes
                            code for startup, chip selection configuration, interrupt controllers, and timer
                            devices.
                            Note the HAL interface can be directly used by any of the upper layers, promot-
                      ing efficient code.

                      eCos Kernel
                      The eCos kernel was designed to satisfy four main objectives:
                          • Low interrupt latency: The time it takes to respond to an interrupt and begin
                            executing an ISR.
                          • Low task switching latency: The time it takes from when a thread becomes
                            available to when actual execution begins.
                          • Small memory footprint: Memory resources for both program and data are kept
                            to a minimum by allowing all components to configure memory as needed.
                          • Deterministic behavior: Throughout all aspect of execution, the kernels perfor-
                            mance must be predictable and bounded to meet real-time application
                            requirements.
                           The eCos kernel provides the core functionality needed for developing multi-
                      threaded applications:
                         1. The ability to create new threads in the system, either during startup or when
                            the system is already running
                         2. Control over the various threads in the system: for example, manipulating their
                            priorities
                         3. A choice of schedulers, determining which thread should currently be
                            running
                         4. A range of synchronization primitives, allowing threads to interact and share
                            data safely
                         5. Integration with the system’s support for interrupts and exceptions
                            Some functionality that is typically included in the kernel of an OS is not
                      included in the eCos kernel. For example, memory allocation is handled by a separate
                      package. Similarly, each device driver is a separate package. Various packages are




Z22_STAL4290_09_GE_APPQ.indd 6                                                                                  4/18/17 7:36 AM

<!-- pág. 1107 -->

                                                                           Q.2 / eCOS COMPONENTS   Q-7

                      combined and configured using the eCos configuration technology to meet the
                      requirements of the application. This makes for a lean kernel. Further, the minimal
                      nature of the kernel means that for some embedded platforms, the eCos kernel is not
                      used at all. Simple single-threaded applications can be run directly on HAL. Such
                      configurations can incorporate needed C library functions and device drivers, but
                      avoid the space and time overhead of the kernel.
                             There are two different techniques for utilizing kernel functions in eCos. One
                      way to employ kernel functionality is by using the C API of kernel. Examples of such
                      functions are cyg_thread_create and cyg_mutex_lock. These functions can
                      be invoked directly from application code. On the other hand, kernel functions can
                      also be invoked by using compatibility packages for existing API’s, for example,
                      POSIX threads or μITRON. The compatibility packages allow application code to
                      call standard functions like pthread_create, and those functions are implemented
                      using the basic functions provided by the eCos kernel. Code sharing and reusability
                      of already developed code is easily achieved by use of compatibility packages.

                      I/O System
                      The eCos I/O system is a framework for supporting device drivers. A variety of driv-
                      ers for a variety of platforms are provided in the eCos configuration package. These
                      include drivers for serial devices, Ethernet, flash memory interfaces, and various I/O
                      interconnects such as PCI (Peripheral Component Interconnect) and USB (Universal
                      Serial Bus). In addition, users can develop their own device drivers.
                            The principal objective for the I/O system is efficiency, with no unnecessary
                      software layering or extraneous functionality. Device drivers provide the necessary
                      functions for input, output, buffering, and device control.
                            As mentioned, device drivers and other higher-layer software may be imple-
                      mented directly on the HAL if this is appropriate. If specialized kernel-type functions
                      are needed, then the device driver is implemented using kernel APIs. The kernel
                      provides a three-level interrupt model:
                          • Interrupt service routines (ISRs): Invoked in response to a hardware interrupt.
                            Hardware interrupts are delivered with minimal intervention to an ISR. The HAL
                            decodes the hardware source of the interrupt and calls the ISR of the attached
                            interrupt object. This ISR may manipulate the hardware but is only allowed to
                            make a restricted set of calls on the driver API. When it returns, an ISR may
                            request that its deferred service routine (DSR) should be scheduled to run.
                          • Deferred service routines (DSRs): Invoked in response to a request by an ISR.
                            A DSR will be run when it is safe to do so without interfering with the sched-
                            uler. Most of the time the DSR will run immediately after the ISR, but if the
                            current thread is in the scheduler, it will be delayed until the thread is finished.
                            A DSR is allowed to make a larger set of driver API calls, including, in particu-
                            lar, being able to call cyg_drv_cond_signal() to wake up waiting threads.
                          • Threads: The clients of the driver. Threads are able to make all API calls and in
                            particular are allowed to wait on mutexes and condition variables.
                            Tables Q.1 and Q.2 show the device driver interface to the kernel. These tables
                      give a good feel for the type of functionality available in the kernel to support device




Z22_STAL4290_09_GE_APPQ.indd 7                                                                                     4/18/17 7:36 AM

<!-- pág. 1108 -->

            Q-8   Appendix Q / eCos
                      Table Q.1   Device Driver Interface to the eCos Kernel: Concurrency
                        cyg_drv_spinlock_init Initialize a spinlock in a locked or unlocked state.
                        cyg_drv_spinlock_destroy Destroy a spinlock that is no longer of use.
                        cyg_drv_spinlock_spin Claim a spinlock, waiting in a busy loop until it is available.
                        cyg_drv_spinlock_clear Clear a spinlock. This clears the spinlock and
                        allows another CPU to claim it. If there is more than one CPU waiting in cyg_drv_
                        spinlock_spin, then just one of them will be allowed to proceed.
                        cyg_drv_spinlock_test Inspect the state of the spinlock. If the spinlock is not
                        locked, then the result is TRUE. If it is locked then the result will be FALSE.
                        cyg_drv_spinlock_spin_intsave This function behaves like cyg_drv_­
                        spinlock_spin except that it also disables interrupts before attempting to claim the
                        lock. The current interrupt enable state is saved in *istate. Interrupts remain disabled
                        once the spinlock has been claimed and must be restored by calling cyg_drv_­
                        spinlock_clear_intsave. Device drivers should use this function to claim and
                        release spinlocks rather than the non-_intsave() variants, to ensure proper exclu-
                        sion with code ­running on both other CPUs and this CPU.
                        cyg_drv_mutex_init Initialize a mutex.
                        cyg_drv_mutex_destroy Destroy a mutex. The mutex should be unlocked and there
                        should be no threads ­waiting to lock it when this call is made.
                        cyg_drv_mutex_lock Attempt to lock the mutex pointed to by the mutex argument.
                        If the mutex is already locked by another thread, then this thread will wait until that
                        thread is finished. If the result from this function is FALSE, then the thread was broken
                        out of its wait by some other thread. In this case the mutex will not have been locked.
                        cyg_drv_mutex_trylock Attempt to lock the mutex pointed to by the mutex
                        ­argument without waiting. If the mutex is already locked by some other thread then this
                         function returns FALSE. If the function can lock the mutex without waiting, then
                         TRUE is returned.
                        cyg_drv_mutex_unlock Unlock the mutex pointed to by the mutex argument. If
                        there are any threads waiting to claim the lock, one of them is woken up to try and
                        claim it.
                        cyg_drv_mutex_release Release all threads waiting on the mutex.
                        cyg_drv_cond_init Initialize a condition variable associated with a mutex. A thread
                        may only wait on this condition variable when it has already locked the associated mutex.
                        Waiting will cause the mutex to be unlocked, and when the thread is reawakened, it will
                        automatically claim the mutex before continuing.
                        cyg_drv_cond_destroy Destroy the condition variable.
                        cyg_drv_cond_wait Wait for a signal on a condition variable.
                        cyg_drv_cond_signal Signal a condition variable. If there are any threads waiting on
                        this variable, at least one of them will all be awakened.
                        cyg_drv_cond_broadcast Signal a condition variable. If there are any threads
                        ­waiting on this variable, they will all be awakened.




Z22_STAL4290_09_GE_APPQ.indd 8                                                                                      4/18/17 7:36 AM

<!-- pág. 1109 -->

                                                                               Q.2 / eCOS COMPONENTS   Q-9

                       Table Q.2    Device Driver Interface to the eCos Kernel: Interrupts
                         cyg_drv_isr_lock Disable delivery of interrupts, preventing all ISRs running.
                         This function maintains a counter of the number of times it is called.
                         cyg_drv_isr_unlock Reenable delivery of interrupts, allowing ISRs to run. This
                         function decrements the counter maintained by cyg_drv_isr_lock, and only
                         ­reallows interrupts when it goes to zero.
                         cyg_ISR_t Define ISR.
                         cyg_drv_dsr_lock Disable scheduling of DSRs. This function maintains a counter of
                         the number of times it has been called.
                         cyg_drv_dsr_unlock Reenable scheduling of DSRs. This function decrements the
                         counter incremented by cyg_drv_dsr_lock. DSRs are only allowed to be delivered
                         when the counter goes to zero.
                         cyg_DSR_t Define DSR prototype.
                         cyg_drv_interrupt_create Create an interrupt object and returns a handle to it.
                         cyg_drv_interrupt_delete Detach the interrupt from the vector and free the
                         memory for reuse.
                         cyg_drv_interrupt_attach Attach an interrupt to a vector so that interrupts will
                         be delivered to the ISR when the interrupt occurs.
                         cyg_drv_interrupt_detach Detach the interrupt from the vector so that ­interrupts
                         will no longer be delivered to the ISR.
                         cyg_drv_interrupt_mask Program the interrupt controller to stop delivery of
                         ­interrupts on the given vector.
                         cyg_drv_interrupt_mask_intunsafe Program the interrupt controller to stop
                         delivery of interrupts on the given vector. This version differs from cyg_drv_­
                         interrupt_mask in not being interrupt safe. So in ­situations where, for example,
                         interrupts are already known to be disabled, this may be called to avoid the extra
                         overhead.
                         cyg_drv_interrupt_unmask, cyg_drv_interrupt_unmask_intunsafe
                         ­Program the interrupt ­controller to reallow delivery of interrupts on the given vector.
                         cyg_drv_interrupt_acknowledge Perform any processing required at the
                         ­interrupt controller and in the CPU to cancel the current interrupt request.
                         cyg_drv_interrupt_configure Program the interrupt controller with the
                         ­characteristics of the interrupt source.
                         cyg_drv_interrupt_level Program the interrupt controller to deliver the given
                         interrupt at the supplied priority level.
                         cyg_drv_interrupt_set_cpu On multiprocessor systems, this function causes all
                         interrupts on the given vector to be routed to the specified CPU. Subsequently, all such
                         interrupts will be handled by that CPU.
                         cyg_drv_interrupt_get_cpu On multiprocessor systems, this function returns the
                         ID of the CPU to which interrupts on the given vector are currently being delivered.




Z22_STAL4290_09_GE_APPQ.indd 9                                                                                       4/18/17 7:36 AM

<!-- pág. 1110 -->

            Q-10   Appendix Q / eCos
                      drivers. Note the device driver interface can be configured for one or more of the
                      following concurrency mechanisms: spinlocks, condition variables, and mutexes.
                      These are described in a subsequent portion of this discussion.


                      Standard C Libraries
                      A complete Standard C run-time library is provided. Also included is a complete
                      math run-time library for high-level mathematics functions, including a complete
                      IEEE-754 floating-point library for those platforms without hardware floating
                      points.


               Q.3 eCOS SCHEDULER

                      The eCos kernel can be configured to provide one of two scheduler designs: the bit-
                      map scheduler and a multilevel queue scheduler. The configuration user selects the
                      appropriate scheduler for the environment and the application. The bitmap scheduler
                      provides efficient scheduling for a system with a small number of threads that may
                      be active at any point in time. The multiqueue scheduler is appropriate if the number
                      of threads is dynamic or if it is desirable to have multiple threads at the same priority
                      level. The multilevel scheduler is also needed if time slicing is desired.

                      Bitmap Scheduler
                      A bitmap scheduler supports multiple priority levels, but only one thread can exist
                      at each priority level at any given time. Scheduling decisions are quite simple with
                      this scheduler (see Figure Q.6a). When a blocked thread become ready to run, it may
                      preempt a thread of lower priority. When a running thread suspends, the ready thread
                      with the highest priority is dispatched. A thread can be suspended because it is
                      blocked on a synchronization primitive, because it is interrupted, or because it relin-
                      quishes control. Because there is only one thread, at most, at each priority level, the
                      scheduler does not have to make a decision as to which thread at a given priority level
                      should be dispatched next.
                             The bitmap scheduler is configured with 8, 16, or 32 priority levels. A simple
                      bitmap is kept of the threads that are ready to execute. The scheduler need only to
                      determine the position of the most significant one bit in the bitmap to make a sched-
                      uling decision.

                      Multilevel Queue Scheduler
                      As with the bitmap scheduler, the multilevel queue scheduler supports up to 32 prior-
                      ity levels. The multilevel queue scheduler allows for multiple active threads at each
                      priority level, limited only by system resources.
                            Figure Q.6b illustrates the nature of the multilevel queue scheduler. A data
                      structure represents the number of ready threads at each priority level. When a
                      blocked thread become ready to run, it may preempt a thread of lower priority.
                      As with the bitmap scheduler, a running thread may be blocked on a synchroniza-
                      tion primitive, because it is interrupted, or because it relinquishes control. When




Z22_STAL4290_09_GE_APPQ.indd 10                                                                                   4/18/17 7:36 AM

<!-- pág. 1111 -->

                                                                                         Q.3 / eCOS SCHEDULER   Q-11

                                                                                Bitmap
                                                                           Scheduling Queue
                                                 Maximum priority 31
                                                                              Thread C




                                                                              Thread B
                                                      Minimum priority 0      Thread A


                                               Thread A

                                                               Deschedule

                                  Preemption                                    Thread B

                                                                                                Deschedule

                         Thread C                                                                             Thread C


                                                        (a) Bitmap scheduler thread operation

                                                            Multilevel Scheduling Queue
                        Maximum priority 31
                                                                                         Thread C




                          Minimum priority 0                           Thread B          Thread A


                                                       Time slice                 Deschedule
                                           Thread A                  Thread B                   Thread A

                                  Preemption                                                         Deschedule

                         Thread C                                                                             Thread C


                                                  (b) Multilevel queue scheduler thread operation

                     Figure Q.6     eCos Scheduler Options




Z22_STAL4290_09_GE_APPQ.indd 11                                                                                          4/18/17 7:36 AM

<!-- pág. 1112 -->

            Q-12   Appendix Q / eCos
                      a thread is blocked, the scheduler must first determine if one or more threads at
                      the same priority level as the blocked thread is ready. If so, the scheduler chooses
                      the one at the front of the queue. Otherwise, the scheduler looks for the next high-
                      est priority level with one or more ready threads and dispatches one of these
                      threads.
                            In addition, the multilevel queue scheduler can be configured for time slicing.
                      Thus, if a thread is running and there is one or more ready threads at the same priority
                      level, the scheduler will suspend the running thread after one time slice and choose
                      the next thread in the queue at that priority level. This is a round-robin policy within
                      one priority level. Not all applications require time slicing. For example, an applica-
                      tion may contain only threads that block regularly for some other reason. For these
                      applications, the user can disable time slicing, which reduces the overhead associated
                      with timer interrupts.


               Q.4 eCOS THREAD SYNCHRONIZATION

                      The eCos kernel can be configured to include one or more of six different thread
                      synchronization mechanisms. These include the classic synchronization mechanisms:
                      mutexes, semaphores, and condition variables. In addition, eCos supports two syn-
                      chronization/communication mechanisms that are common in real-time systems,
                      namely event flags and mailboxes. Finally, the eCos kernel supports spinlocks, which
                      are useful in SMP (symmetric multiprocessing) systems.

                      Mutexes
                      The mutex (mutual exclusion lock) was introduced in Chapter 6. Recall that a mutex
                      is used to enforce mutually exclusive access to a resource, allowing only one thread
                      at a time to gain access. The mutex has only two states: locked and unlocked. This is
                      similar to a binary semaphore: When a mutex is locked by one thread, any other
                      thread attempting to lock the mutex is blocked; when the mutex is unlocked, then
                      one of the threads blocked on this mutex is unblocked and allowed to lock the mutex
                      and gain access to the resource.
                             The mutex differs from a binary semaphore in two respects. First, the thread
                      that locks the mutex must be the one to unlock it. In contrast, it is possible for one
                      thread to lock a binary semaphore and for another to unlock it. The other difference
                      is that a mutex provides protection against priority inversion, whereas a semaphore
                      does not.
                             The eCos kernel can be configured to support either a priority inheritance
                      protocol or a priority ceiling protocol. These are described in Chapter 10.

                      Semaphores
                      The eCos kernel provides support for a counting semaphore. Recall from Chapter
                      5 that a counting semaphore is an integer value used for signaling among threads.
                      The cyg_semaphore_init is used to initialize a semaphore. The cyg_sema-
                      phore_post command increments the semaphore count when an event occurs. If




Z22_STAL4290_09_GE_APPQ.indd 12                                                                                  4/18/17 7:36 AM

<!-- pág. 1113 -->

                                                       Q.4 / eCOS THREAD SYNCHRONIZATION   Q-13

                      the new count is less than or equal to zero, then a thread is waiting on this sema-
                      phore and is awakened. The cyg_semaphore_wait function checks the value of
                      a semaphore count. If the count is zero, the thread calling this function will wait for
                      the semaphore. If the count is nonzero, the count is decremented and the thread
                      continues.
                            Counting semaphores are suited to enabling threads to wait until an event has
                      occurred. The event may be generated by a producer thread, or by a DSR in response
                      to a hardware interrupt. Associated with each semaphore is an integer counter that
                      keeps track of the number of events that have not yet been processed. If this counter
                      is zero, an attempt by a consumer thread to wait on the semaphore will block until
                      some other thread or a DSR posts a new event to the semaphore. If the counter is
                      greater than zero, then an attempt to wait on the semaphore will consume one event
                      (in other words decrement the counter) and return immediately. Posting to a sema-
                      phore will wake up the first thread that is currently waiting, which will then resume
                      inside the semaphore wait operation and decrement the counter again.
                            Another use of semaphores is for certain forms of resource management. The
                      counter would correspond to how many of a certain type of resource are currently
                      available, with threads waiting on the semaphore to claim a resource and posting to
                      release the resource again. In practice, condition variables are usually much better
                      suited for operations like this.

                      Condition Variables
                      A condition variable is used to block a thread until a particular condition is true.
                      Condition variables are used with mutexes to allow multiple threads to access shared
                      data. They can be used to implement monitors of the type discussed in Chapter 6 (e.g.,
                      Figure 6.14). The basic commands are as follows:
                             cyg_cond_wait Causes the current thread to wait on the specified condition
                      variable and simultaneously unlocks the mutex attached to the condition variable.
                             cyg_cond_signal Wakes up one of the threads waiting on this condition
                      variable, causing that thread to become the owner of the mutex.
                             cyg_cond_broadcast Wakes up all the threads waiting on this condition
                      variable. Each thread that was waiting on the condition variable becomes the owner
                      of the mutex when it runs.
                             In eCos, condition variables are typically used in conjunction with mutexes to
                      implement long-term waits for some condition to become true. Consider the follow-
                      ing example. Figure Q.7 defines a set of functions to control access to a pool of
                      resources using mutexes. The mutex is used to make the allocation and freeing of
                      resources from a pool atomic. The function res_t res_allocate checks to see if
                      one or more units of a resource are available and, if so, takes one unit. This operation
                      is protected by a mutex so no other thread can check or alter the resource pool while
                      this thread has control of the mutex. The function res_free(res_t res) enables
                      a thread to release one unit of a resource that it had previously acquired. Again, this
                      operation is made atomic by a mutex.
                             In this example, if a thread attempts to access a resource and none are available,
                      the function returns RES_NONE. Suppose, however, we want the thread to be blocked
                      and wait for a resource to become available, rather than returning RES_NONE.




Z22_STAL4290_09_GE_APPQ.indd 13                                                                                   4/18/17 7:36 AM

<!-- pág. 1114 -->

            Q-14   Appendix Q / eCos

              cyg_mutex_t res_lock;
              res_t res_pool[RES_MAX];
              int res_count = RES_MAX;

              void res_init(void)
              {
                  cyg_mutex_init(&res_lock);
                   <fill pool with resources>
              }
              res_t res_allocate(void)
              {
                  res_t res;
                  cyg_mutex_lock(&res_lock);                          // lock the mutex
                  if( res_count == 0 )                                // check for free resource
                      res =RES_NONE;                                  // return RES_NONE if none
                  else {
                      res_count--;                                    // allocate a resources
                      res =res_pool[res_count];
              }
                  cyg_mutex_unlock(&res_lock);                        // unlock the mutex
                  return res;
              }
              void res_free(res_t res)
              {
                  cyg_mutex_lock(&res_lock);                          // lock the mutex
                  res_pool[res_count] =res;                           // free the resource
                  res_count++;
                  cyg_mutex_unlock(&res_lock);                        // unlock the mutex
              }

            Figure Q.7     Controlling Access to a Pool of Resources Using Mutexes



                      ­Figure Q.8 accomplishes this with the use of a condition variable associated with the
                       mutex. When res_allocate detects that there are no resources, it calls cyg_cond_
                      wait. This latter function unlocks the mutex and puts the calling thread to sleep on
                      the condition variable. When res_free is eventually called, it puts a resource back
                      into the pool and calls cyg_cond_signal to wake up any thread waiting on the
                      condition variable. When the waiting thread eventually gets to run again, it will relock
                      the mutex before returning from cyg_cond_wait.
                             There are two significant features of this example, and of the use of condition
                      variables in general. First, the mutex unlock and wait in cyg_cond_wait are atomic:
                      No other thread can run between the unlock and the wait. If this were not the case,
                      then a call to res_free by some other thread would release the resource, but the
                      call to cyg_cond_signal would be lost, and the first thread would end up waiting
                      when there were resources available.




Z22_STAL4290_09_GE_APPQ.indd 14                                                                                  4/18/17 7:36 AM

<!-- pág. 1115 -->

                                                        Q.4 / eCOS THREAD SYNCHRONIZATION   Q-15


              cyg_mutex_t res_lock;
              cyg_cond_t res_wait;
              res_t res_pool[RES_MAX];
              int res_count =RES_MAX;
              void res_init(void)
              {
                  cyg_mutex_init(&res_lock);
                  cyg_cond_init(&res_wait, &res_lock);
                  <fill pool with resources>
              }
              res_t res_allocate(void)
              {
                  res_t res;
                  cyg_mutex_lock(&res_lock);        // lock the mutex
                  while( res_count == 0 )           // wait for a resources
                     cyg_cond_wait(&res_wait);
                  res_count--;                      // allocate a resource
                  res =res_pool[res_count];
                  cyg_mutex_unlock(&res_lock);      // unlock the mutex
                  return res;
              }
              void res_free(res_t res)
              {
                  cyg_mutex_lock(&res_lock);         // lock the mutex
                  res_pool[res_count] =res;          // free the resource
                  res_count++;
                  cyg_cond_signal(&res_wait);        // 
                                                       wake up any waiting
                                                        allocators
                  cyg_mutex_unlock(&res_lock);       // unlock the mutex
              }

            Figure Q.8    Controlling Access to a Pool of Resources Using Mutexes and Condition Variables

                             The second feature is that the call to cyg_cond_wait is in a while loop and
                      not a simple if statement. This is because of the need to relock the mutex in cyg_
                      cond_wait when the signaled thread reawakens. If there are other threads already
                      queued to claim the lock, then this thread must wait. Depending on the scheduler
                      and the queue order, many other threads may have entered the critical section before
                      this one gets to run. So the condition that it was waiting for may have been rendered
                      false. Using a loop around all condition variable wait operations is the only way to
                      guarantee that the condition being waited for is still true after waiting.

                      Event Flags
                      An event flag is a 32-bit word used as a synchronization mechanism. Application code
                      may associate a different event with each bit in a flag. A thread can wait for either a
                      single event or a combination of events by checking one or multiple bits in the




Z22_STAL4290_09_GE_APPQ.indd 15                                                                                 4/18/17 7:36 AM

<!-- pág. 1116 -->

            Q-16   Appendix Q / eCos
                      corresponding flag. The thread is blocked until all of the required bits are set (AND)
                      or until at least one of the bits is set (OR). A signaling thread can set or reset bits
                      based on specific conditions or events so that the appropriate thread is unblocked.
                      For example, bit 0 could represent completion of a specific I/O operation, making
                      data available, and bit 1 could indicate that the user has pressed a start button. A
                      producer thread or DSR could set these two bits, and a consumer thread waiting on
                      these two events will be woken up.
                             A thread can wait on one or more events using the cyg_flag_wait command,
                      which takes three arguments: a particular event flag, a combination of bit positions
                      in the flag, and a mode parameter. The mode parameter specifies whether the thread
                      will block until all the bits are set (AND) or until at least one of the bits is set (OR).
                      The mode parameter may also specify that when the wait succeeds, the entire event
                      flag is cleared (set to all zeros).

                      Mailboxes
                      Mailboxes, also called message boxes, are an eCos synchronization mechanism that
                      provides a means for two threads to exchange information. Section 5.5 provides a
                      general discussion of message-passing synchronization. Here, we look at the specifics
                      of the eCos version.
                             The eCos mailbox mechanism can be configured for blocking or nonblocking
                      on both the send and receive side. The maximum size of the message queue associated
                      with a given mailbox can also be configured.
                             The send message primitive, called put, includes two arguments: a handle to the
                      mailbox and a pointer for the message itself. There are three variants to this
                      primitive:
                             cyg_mbox_put If there is a spare slot in the mailbox, then the new message is
                      placed there; if there is a waiting thread, it will be woken up so it can receive the mes-
                      sage. If the mailbox is currently full, cyg_mbox_put blocks until there has been a
                      corresponding get operation and a slot is available.
                             cyg_mbox_timed_put Same as cyg_mbox_put if there is a spare slot. Other­
                      wise, the function will wait a specified time limit and place the message if a slot becomes
                      available. If the time limit expires, the operation returns false. Thus, cyg_mbox_
                      timed_put is blocking only for less than or equal to a specified time interval.
                             cyg_mbox_tryput This is a nonblocking version, which returns true if the
                      message is sent successfully and false if the mailbox is full.
                             Similarly, there are three variants to the get primitive.
                             cyg_mbox_get If there is a pending message in the specified mailbox, cyg_
                      mbox_get returns with the message that was put into the mailbox. Otherwise this
                      function blocks until there is a put operation.
                             cyg_mbox_timed_get Immediately returns a message if one is available.
                      Otherwise, the function will wait until either a message is available or until a number
                      of clock ticks have occurred. If the time limit expires, the operation returns a null
                      pointer. Thus, cyg_mbox_timed_get is blocking only for less than or equal to a
                      specified time interval.
                             cyg_mbox_tryget This is a nonblocking version, which returns a message if
                      one is available and a null pointer if the mailbox is empty.




Z22_STAL4290_09_GE_APPQ.indd 16                                                                                     4/18/17 7:36 AM

<!-- pág. 1117 -->

                                                        Q.4 / eCOS THREAD SYNCHRONIZATION   Q-17

                      Spinlocks
                      A spinlock is a flag that a thread can check before executing a particular piece of
                      code. Recall from our discussion of Linux spinlocks in Chapter 6 the basic operation
                      of the spinlock: Only one thread at a time can acquire a spinlock. Any other thread
                      attempting to acquire the same lock will keep trying (spinning) until it can acquire
                      the lock. In essence, a spinlock is built on an integer location in memory that is
                      checked by each thread before it enters its critical section. If the value is 0, the thread
                      sets the value to 1 and enters its critical section. If the value is nonzero, the thread
                      continually checks the value until it is zero.
                            A spinlock should not be used on a single-processor system, which is why it is
                      compiled away on Linux. As an example of the danger, consider a uniprocessor sys-
                      tem with preemptive scheduling, in which a higher-priority thread attempts to acquire
                      a spinlock already held by a lower-priority thread. The lower-priority thread cannot
                      execute so as to finish its work and release the spinlock, because the higher-priority
                      thread preempts it. The higher-priority thread can execute but is stuck checking the
                      spinlock. As a result, the higher-priority thread will just loop forever and the lower-
                      priority thread will never get another chance to run and release the spinlock. On an
                      SMP system, the current owner of a spinlock can continue running on a different
                      processor.




Z22_STAL4290_09_GE_APPQ.indd 17                                                                                     4/18/17 7:36 AM

