# Chapter 17 - Introduction to Distributed Systems

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 835–867 (numeración del PDF)

<!-- pág. 835 -->

Chapter 17


Introduction to Distributed
          Systems
 Objectives
 After reading this chapter, you should understand:
 • the need for distributed computing.
 • fundamental properties and desirable characteristics of distributed systems.
 • remote communication in distributed systems.
 • synchronization, mutual exclusion and deadlock in distributed systems.
 • examples of distributed operating systems.

<!-- pág. 836 -->

                                Chapter Outline

                      17.1                                                17.4
                 Introduction                            Synchronization in Distributed
                                                                        Systems
                       17.2
         Attributes of Distributed                                        17.5
                    Systems                              Mutual Exclusion in Distributed
        17.2.1 Performance and Scalability                            Systems
       17.2.2 Connectivity and Security                   17.5.1 Mutual Exclusion withous Shared
                                                                         Memory
      17.2.3 Reliability and Fault Tolerance             17.5.2 Agrawala and Ricart's Distributed
               17.2.4 Transparency                               Mutual Exclusion Algorithm
        17.2.5 Network Operating Systems
      17.2.6 Distributed Operating Systems                                17.6
                                                         Deadlock in Distributed Systems
                                                               17.6.1 Distributed Deadlock
                17.3                                           17.6.2   Deadlock Prevention
      Communication in Distributed
              Systems                                           17.6.3 Deadlock Detection
                                                          17.6.4 A Distributed Resource Deadlock
                17.3.1 Middleware
                                                                         Algorithm
        Anecdote: Consequences of Errors
      17.3.2 Remote Procedure Call (RPC)
  17.3.3 Remote Method Invocation (RMI)
                                                                          17.7
                                                              Case Study: The Sprite
  17.3.4 CORBA (Common Object Request                      Distributed Operating System
                Broken Architecture)
      17.3.5 DCOM (Distributed Component
                    Object Model)                                         17.8
      17.3.6    Process Migration in Distributed             Case Study: The Amoeba
                      Systems                              Distributed Operating System

         Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited




782

<!-- pág. 837 -->

                                                                                         17.1 Introduction 783

17.1 Introduction
 As the speed and reliability of networking have improved, computers worldwide
have become increasingly interconnected. Remote communication via networks,
originally reserved for large computer installations and academic environments, has
become pervasive. In distributed systems, remote computers cooperate via a net­
work to appear as a local machine. Both distributed systems and network systems
spread computation and storage throughout a network of computers. However,
users of a distributed operating system are given the impression that they are inter­
acting with just one machine, whereas users of a network operating system must be
aware of the distributed implementation. Applications of distributed systems are
able to execute code on local machines and remote machines and to share data, files
and other resources among these machines.
      Distributed systems often arise from the need to improve the capacity (e.g.,
processing power and storage size) and reliability of a single machine. Economic
factors can limit the capabilities of a system. By implementing an operating system
across several inexpensive machines, it is possible to design a powerful system with-
 out expensive machines. For example, it is difficult to connect hundreds of proces­
sors on a single mainboard; moreover, most hard disk interfaces do not support the
hundreds of disks required for terabytes of storage. Having a single machine with
an exorbitant amount of resources is wasteful; a single user would rarely, if ever,
take advantage of such capacity. Dividing the resources among a group of machines
 lets multiple users share the resources, while guaranteeing that there will be enough
for the occasional large job. Another reason to adopt a distributed system is to
serve a large user base. A distributed file system places files on separate machines,
while providing the view of a single file system. Distributed file systems can allow
vast numbers of users to access the same set of files reliably and efficiently.
      Although distributed systems offer many advantages over single-machine oper­
ating systems, they can be complex and difficult to implement and manage. For exam­
ple, they must handle communication delays and reliability problems introduced by
the underlying networks. It is harder to manage machine failure in distributed sys-
tems; an operating system distributed across n machines is far more likely to experi­
ence a system crash than a single-machine operating system. Another challenge is
ensuring that each computer in the system has the same view of the entire system.
      The discussion of distributed systems in this and the next chapter builds on
Chapter 16. In this chapter we discuss distributed communication, distributed file
systems and distributed processing. Distributed communication describes how pro­
cesses on different machines communicate, while distributed processing describes
the interaction among distributed processes. Distributed file systems provide a
means of managing files within a distributed system.

Self Review
1. What are some benefits of a distributed system?
2. What makes distributed systems complex and difficult to implement and manage?

<!-- pág. 838 -->

784   Introduction to Distributed Systems

                              Ans: 1) Distributed systems can achieve a high level of performance for a lesser cost than
                              with a single system. Distributed systems can also allow vast numbers of users access to the
                              same files reliably and efficiently. 2) Handling communication delays and reliability problems-
                              introduced by the underlying networks, responding to machine failure and ensuring that each
                              computer in the system has the same view of the entire system.


                               17.2 Attributes of Distributed Systems
                               For decades, researchers and professionals have stressed the importance of distrib­
                               uted systems. The explosion of the Internet that occurred with the popularization of
                               the World Wide Web in 1993 has made distributed systems common. This section
                               discusses performance, scalability, connectivity, security, reliability and fault toler­
                               ance in distributed systems.

                               17.2.1 Performance and Scalability
                               In a centralized system, a single server handles all user requests. With a distributed
                               system, user requests can be sent to different servers working in parallel to increase
                               performance. Scalability allows a distributed system to grow (i.e., add more
                               machines to the system) without affecting the existing applications and users.

                               Self Review
                               1. How can a distributed systems increase performance?
                               2. How does scalability make distributed systems better than centralized systems?
                               Ans: 1) Multiple servers can handle user requests simultaneously. 2) Scalability allows tin-
                               distributed system to grow (i.e., add more machines) without affecting the existing applica­
                               tions and users.

                               17.2.2 Connectivity and Security
                               A distributed system can provide seamless access to resources distributed across
                               the network. If the resource is a processor, the distributed system should allow
                               tasks to be executed on any machine. If the resource is a globally shared file system,
                               then remote users should be able to access the file system as they would access a
                               local, private file system. For example, a user should be able to navigate the file sys­
                               tem and open a file using a graphical browser or shell instead of connecting to an
                               FTP program.
                                     Connectivity in distributed systems requires communication protocols. The
                               protocols must provide common interfaces to all computers in the system. Many
                               distributed systems require communication of state information to maintain effi­
                               cient operation. State information consists of data that describes the status of one
                               or more resources. Improper state information could lead to inconsistency; trans-
                               mitting state information too often can flood the network and reduce scalability
                               Distributed system designers must determine what state information to maintain
                               and how often to make such information known to the system.1

<!-- pág. 839 -->

                                                                              17.2 Attributes of Distributed Systems 785

       Distributed systems can be susceptible to attacks by malicious users if they
rely on insecure communications media (i.e., a public network). To improve secu­
rity, a distributed system should allow only authorized users to access resources and
ensure that information transmitted over the network is readable only by the
 intended recipients. Also, because many users or objects may request resources, the
system must provide mechanisms to protect resources from attack. Security and
protection are discussed in Chapter 19.

Self Review
1. What facts should distributed system designers consider when designing state informa­
   tion?
2. Give examples of poor state-information design.
Ans: 1) Distributed system designers need to decide whether the system should keep state
 information, what state information to maintain and how often to make such information
known to the system. 2) Poor state-information design may keep multiple entries for the sta-
tus of the same resource, leading to inconsistency; it may cause state information to be trans-
mitted too often, which could flood the network and restrict scalability.

17.2.3 Reliability and Fault Tolerance
The failure of one or more resources on a single machine may cause the whole sys-
tem to fail or may affect the performance of processes running on the system. A dis­
tributed system is more likely to suffer failures than a single-machine system
because it has more components that might malfunction.2
      Distributed systems implement fault tolerance by providing replication of
resources across the system. The failure of any one computer will not affect the
availability of the system's resources. For example, a distributed file system might
keep copies of the same file at different servers. If a user is using a file on a server
that crashes, then the distributed file system can direct future requests to a server
with a copy of the original file. Replication offers users increased reliability and
availability over single-machine implementations.
      This comes at a cost. Distributed system designers must develop software that
detects and reacts to system failures. Furthermore, designers must provide mecha­
nisms to ensure consistency among the state information at different machines.
Such systems must also be equipped to reintegrate failed resources, once they have
been repaired.

Self Review
1. Why is a distributed system more likely to suffer faults than a single machine?
2. What is the side effect of increasing reliability and fault tolerance?
Ans: 1) Distributed systems simply have more components that might malfunction.
2) Increasing reliability and fault tolerance makes designing distributed systems more com­
plex. The designer must provide mechanisms to switch from a failed machine to a working
machine and keep the copies of the duplicated resources consistent across the system.

<!-- pág. 840 -->

786 Introduction to Distributed Systems

                              17.2.4 Transparency
                             One goal of a distributed system is to provide transparency by hiding the distribu­
                             tion aspects from users of the system. Access to a file system that is distributed
                             across several remote computers should be no different than access to a local file
                             system. The user of a distributed file system should be able to access its resources
                             without knowing about the communication between the processes, which process
                             runs the user request and the physical location of the resources.
                                   The ISO Open Distributed Processing Reference Model defines eight types of
                             transparency a distributed system can provide: 3
                                   • access transparency
                                   • location transparency
                                   • failure transparency
                                   • replication transparency
                                   • persistence transparency
                                   • migration transparency
                                   • relocation transparency
                                   • transaction transparency
                                   Access transparency hides the details of networking protocols that enable
                             communication between distributed computers. It also provides a universal means
                             to access data stored in disparate data formats throughout a system.
                                   Location transparency builds on access transparency to hide the location of
                             resources in the distributed system from those attempting to access them. A distrib­
                             uted file system that provides location transparency allows access to remote files as
                             if they were local files.
                                   Failure transparency is the method by which a distributed system provides
                             fault tolerance. If one or more resources or computers in the network fail, users of
                             the system will be aware only of the reduced performance. Failure transparency is
                             typically implemented by replication or checkpoint/recovery. Under replication, a
                             system provides multiple resources that perform the same function. Even if all but
                             one of a set of replicated resources fails, a distributed system can continue to func­
                             tion. A system that employs checkpointing periodically stores the state of an object
                             (such as a process) such that it can be restored (i.e., recovered) if a failure in the dis­
                             tributed system results in the loss of the object.
                                    Replication transparency hides the fact that multiple copies of a resource are
                             available in the system; all access to a group of replicated resources occurs as if
                             there were one such resource available. Persistence transparency hides the informa-
                             tion about where the resource is stored—memory or disk.
                                   Migration and relocation transparency both hide the movement of compo-
                             nents of a distributed system. Migration transparency masks the movement of an
                             object from one location to another in the system, such as the movement of a file
                             from one server to another. Relocation transparency masks the relocation of an

<!-- pág. 841 -->

                                                                             17.2 Attributes of Distributed Systems 787
object from other objects that communicate with it. Finally, transaction transpar­
ency allows a system to achieve consistency by masking the coordination among a
set of resources. Transactions (see Section 13.10.2, Data Integrity and Log-Struc­
tured File Systems) include service requests (such as file access and function calls)
that change the state of the system. Consequently, transactions often require check­
pointing or replication to meet other goals of the distributed system. Transaction
transparency hides the implementation of these services.

Self Review
1. Give an example of location transparency.
2. When failure transparency is implemented by replication, what issue(s) should the design­
   ers consider?
Ans: 1) When you access a file in a distributed system, you do not know which server owns
the file. 2) The designers should consider consistency among replicated resources.


17.2.5 Network Operating Systems
A network operating system accesses resources on remote computers that run inde­
pendent operating systems, but is not responsible for resource management at
remote locations. Consequently, distributed functions are explicit rather than trans­
parent—a user or process must explicitly specify the resources's location to retrieve
a networked file or remotely execute an application. The lack of transparency in
network operating systems keeps them from providing some of the benefits of dis­
tributed operating systems. However, because network operating systems do not
need to ensure transparency, they are easier to implement than distributed operat­
ing systems.4

Self Review
1. State how network operating systems differ from distributed operating systems.
2. Why are network operating systems easier to implement than distributed operating sys­
   tems?
Ans: 1) The network operating system lacks transparency, which means the client must
explicitly specify the resource location to access the resource. 2) Network operating systems
do not provide transparency and are not responsible for resource management at remote
locations, so network operating systems do not need to implement these capabilities.



17.2.6 Distributed Operating Systems
A distributed operating system manages resources located in multiple networked
computers. Distributed operating systems employ many of the same communica­
tion methods, file system structures and other protocols found in network operating
systems, but make the communication transparent so that objects in the system are
unaware of the separate computers that provide the service. This level of transpar­
ency is difficult to achieve, so it is rare to find a "truly" distributed system.5

<!-- pág. 842 -->

788 Introduction to Distributed Systems

                             17.3 Communication in Distributed Systems
                             One of the primary challenges in designing distributed systems is managing com­
                             munication between computers. Designers must establish interoperability between
                             heterogeneous computers and applications. In the early years of distributed com­
                             puting, processes communicated by calling functions from processes located on
                             remote computers. Many of today's applications, however, require interaction
                             between remote objects via method calls. In this section we discuss remote function
                             calls and interactions among remote objects via remote method calls.6
                                   Interoperability permits software components to interact among different
                             hardware and software platforms, programming languages and communication pro­
                             tocols. An interface allows heterogeneous systems to communicate in a way that is
                             meaningful to both sides—promoting interoperability. In the client/server model,
                             the client issues a request across the network to the server, and the server processes
                             the request and sends the reply back to the client computer, often using an interface
                             to aid the communication. A standardized interface allows each client/server pair to
                             communicate using a single, common interface that is understood by both sides.
                             Standardized interfaces are discussed in Section 17.3.4, CORBA (Common Object
                             Request Broker Architecture).

                             Self Review
                             1. Why is interoperability a challenge in distributed systems?
                             2. Explain how the client/server communication model works.
                             Ans: 1) Distributed systems typically consist of heterogeneous computing systems that
                             must somehow be made to interoperate smoothly despite their differences. 2) In the client/
                             server communication model, the client issues requests across the network to the server, then
                             the server processes the requests and sends the replies back to the client.


                             17.7.1 Middleware
                             The machines that compose distributed systems are often heterogeneous—different
                             hardware running different operating systems communicating across different net­
                             work architectures. In such environments, it is time-consuming and error-prone for
                             the application programmer to provide the routines to convert messages between
                             computers (see the Anecdote, Consequences of Errors). Software known as mid­
                             dleware helps provide portability, transparency and interoperability in distributed
                             systems. Portability enables the movement of a system or component from one
                             environment (including both hardware and software) to another without changing
                             the system or component being moved.
                                   Consider a customer purchasing goods from a merchant by writing a check. A
                             bank has issued the customer a book of checks to use for transactions. Upon receipt
                             of a check, the merchant can process it at any bank (even one which did not issue
                             the check), which transparently performs operations to validate the transaction and
                             process the transfer of funds. In this example, the bank (or banks) represents mid-

<!-- pág. 843 -->

                                                                      17.3 Communication in Distributed Systems 789

 dleware and the merchant and customer represent two computers in a distributed
   system. Similar to the banks, middleware transparently performs operations to vall­
 ­ate transactions and initiate network communication. Middleware provides mech-
  anisms to simplify transactions. Instead of visiting the bank to withdraw funds,
  paying the merchant and having the merchant visit another bank to deposit the
 funds, the customer can simply write a check which the merchant deposits directly.
In a similar manner, middleware facilitates communication and cooperation among
the various components of a distributed system by hiding low-level implementation
details from users and applications developers.7
      Middleware provides standard programming interfaces to enable interprocess
  communication between remote computers. These interfaces provide portability
and transparency.8 The following sections describe several common implementa­
tions and protocols that form the backbone of many distributed systems.

Self Review
1. Why do distributed systems need middleware?
2. How does middleware provide transparency?
Ans: 1) Distributed systems consist of heterogeneous machines. Middleware enables these
heterogeneous machines to work together as a single computer. Middleware provides porta­
bility, transparency and interoperability. 2) Middleware provides standard interfaces so that
heterogeneous computers can communicate with each other. It makes calls to procedures on
another computer look like local procedure calls.




                Anecdote
  Consequences of Errors
  For $125 million, can you answer          the Martian atmosphere, which              (e.g., meters and kilograms). The
  how many feet are in a meter? On          destroyed the spacecraft. The              difference between the t w o mea-
  September 23, 1999, engineers             cause for the error? The project           surements caused the teams to
  lost contact w i t h NASA's Mars Cli-     team in Colorado was measuring             interpret the satellite's bearing
  mate Orbiter, a $125 million satel-       the trajectory of the spacecraft in        incorrectly, which eventually led
  lite orbiting Mars to study its           standard units (e.g., feet and             to the orbiter's loss.
  atmosphere. It was later discov-          pounds) but the California team
  ered that the Orbiter had entered         was measuring it in metric units


  Lesson to operating systems designers: Think twice. Question everything. Dig deeper. The consequences of
  malfunctions in the systems you design could be serious.

<!-- pág. 844 -->

790 Introduction to Distributed Systems

                             17.3.2 Remote Procedure Call (RPC)
                             In the mid-1970s, the concept of a remote procedure call (RPC) was introduced to
                             provide a structured, high-level approach to interprocess communication in distrib­
                             uted systems. A remote procedure call allows a process executing on one computer
                             to invoke a procedure (or function) in a process executing on another computer.
                             This mechanism assumes a client/server model: The client computer issuing the
                             remote procedure call sends its parameters across the network to the server, where
                             the called procedure resides. Execution occurs at the server, and the result (i.e., the
                             return value of the function) is then transmitted across the network to the client.
                                    A goal of RPC was to simplify the process of writing distributed applications
                             by preserving the syntax of a local procedure (or function) call while transparently
                             initiating network communication. In addition to the primary goal of simplicity,
                             RPC also aimed to be efficient and secure.9
                                    To provide transparency to programmers of distributed systems, RPC intro­
                             duces the concept of a stub. A stub prepares outbound data for transmission and
                             translates incoming data so that it may be correctly interpreted. To issue an RPC. a
                             client process makes a call (passing the appropriate parameters) to the procedure in
                             the client stub. The client stub performs marshaling of data, which packages proce­
                             dure arguments along with the procedure name into a message for transmission
                             over a network. 10
                                    To make the remote procedure call, the client stub passes the message (with
                             marshaled parameters) to the server (Fig. 17.1). Upon receipt of the message from
                             the client stub, the server's operating system transmits the message to the server
                             stub. The message is then unmarshaled, and the stub sends the parameters to the
                             appropriate local procedure. When the procedure has completed, the server stub
                             marshals the result and sends it back to the client. Finally, the client stub unmar-
                             shals the result, notifies the process and passes it the result. From the standpoint of




                             Figure 17.1 | RPC communication model.

<!-- pág. 845 -->

                                                                       17.3 Communication in Distributed Systems 791
the client, this looks no different than making a local procedure call and receiving
the return result—the elaborate mechanisms of the RPC are hidden. 11
      There are several complications associated with RPC. RPC can run over
either TCP or UDP, which means that different implementations may offer varying
levels of reliability. If RPC is operating over UDP, then the RPC implementation
must provide communication reliability. Furthermore, each RPC implementation
may offer a different level of security (we discuss this topic in Chapter 19, Security
and Protection). In fact, we will see that the security capabilities provided by NFS—
Section 18.2.2, Network File System (NFS)—are directly related to its underlying
RPC implementation.
      Another complication is that the process issuing an RPC and its correspond­
ing client stub reside in different memory address spaces. This complicates passing
pointers as parameters, which can limit the transparency and capability of RPC.
Similarly, RPC does not support global variables, so every variable that a procedure
uses must be passed to it as an argument.
      Although remote procedure calls promote interoperation in distributed sys­
tems, they are not a sufficient solution to the general problem of distributed com­
munication. Performance and security issues have led to the development of
additional communication protocols, described in the following sections.

Self Review
1. What is the main benefit of RPC?
2. List several problems with RPC.
Ans: 1) RPC enables processes to call procedures on remote hosts as easily as making calls
to procedures on the local machine. 2) Problems with RPCs include: a) Lack of reliability and
security; b) limited transparency and capability; c) Does not support global variables; d)
Complex to implement.

17.3.3 Remote MEthod Invocation (RMI)
Java's RPC protocol, known as remote method invocation (RMI), enables a Java
process executing on one computer to invoke a method of an object on a remote
computer using the same syntax as a local method call. Similar to RPC, the details
of parameter marshaling and message transport in RMI are transparent to the call­
ing program. A key benefit of RMI is that it allows transmission of objects between
remote processes. RMI allows Java programmers to implement distributed systems
without having to explicitly program sockets.12
      Three distinct software layers comprise the RMI architecture: the stub/skele­
ton layer, the remote reference layer (RRL) and the transport layer.13 The stub/
skeleton layer contains parameter-marshaling structures analogous to the client and
server stubs of RPC. An RMI stub is a Java object residing on the client machine
that provides an interface between the client process and the remote object. When a
client process invokes a method on a remote object, the stub method is called first.
The stub employs object serialization to create its marshaled message, a feature

<!-- pág. 846 -->

792   Introduction to Distributed Systems

                              that allows objects to be encoded into byte streams and transmitted from one
                              address space to another. Object serialization enables programs to pass Java objects
                              as parameters and receive objects as return values.14
                                    Once the parameters have been serialized by the stub, they are sent to the cli­
                              ent-side component of the RMI system's RRL. The RRL uses the transport layer to
                              send the marshaled message between the client and the server. When the server-
                              side component of the RRL receives the marshaled parameters, it directs them to
                              the skeleton, which unmarshals the parameters, identifies the object on which the
                              method is to be invoked and calls that method. Upon completion of the method,
                              the skeleton marshals the result and returns it to the client via the RRL and stub.15

                              Self Review
                              1. What is the function of the stub/skeleton layer in RMI?
                              2. What benefit does RMI provide over RPC?
                              Ans: 1) The stub/skeleton layer marshals and unmarshals parameters. This allows the com­
                              munication between remote hosts to be hidden from the user. 2) RMI uses object serializa­
                              tion to enable clients to send objects as arguments in remote method calls and to receive
                              objects as return values from servers.



                               17.3.4 CORBA (Common Object Request Broker Architecture)
                              CORBA (Common Object Request Broker Architecture) is a standard specifica­
                              tion of distributed systems architecture that has gained wide acceptance.16 Con­
                              ceived in the early 1990s by the Object Management Group (OMG), CORBA is an
                              open standard designed to enable interoperation among programs in heteroge­
                              neous as well as homogeneous systems. Similar to RMI, CORBA supports objects
                              as parameters or return values in remote procedures during interprocess communi­
                              cation. However, unlike RMI (which is Java based), CORBA is language and sys­
                              tem independent, meaning that applications written in different programming
                              languages and on different operating systems interoperate through access to a com­
                              mon CORBA core.17
                                     CORBA-based distributed systems have a relatively simple structure. The
                              process on the client passes the procedure call along with the required arguments to
                              the client stub. The client stub marshals the parameters and sends the procedure
                              call through its Object Request Broker (ORB), which communicates with the ORB
                              on the server. The ORB on the server then passes off the procedure call to the
                              server's skeleton, which unmarshals the parameters and passes the call to the
                              remote procedure.18
                                     CORBA provides its users language independence with the interface defini­
                              tion language (IDL). IDL allows programmers to strictly define the procedures that
                              can be called on the object; this is known as that object's interface. Applications
                              written in any language can communicate through CORBA by following each
                              object's IDL specification.19

<!-- pág. 847 -->

                                                                     17.3   Communication      in   Distributed   Systems   793

Self Review
1. What advantage does CORBA have over RMI?
2. Why might a user chose RMI over CORBA?
Ans: 1) Unlike RMI, CORBA is language independent, so that applications written in dif­
ferent programming languages can interoperate through access to a common CORBA core.
2) If the user is working strictly in Java, then CORBA's language independence is unnece­
sary. Using CORBA also requires the user to learn IDL so that the client and server can com-
municate properly.

17.3.5 DCOM (Distributed Component Object Model)
In the 1990s, Microsoft independently developed its own distributed object archi­
tecture called DCOM (Distributed Component Object Model).20 21 DCOM has
been included in Windows operating systems since Windows 95 and is CORBA's
key competitor in distributed object computing. DCOM is a distributed extension
of Microsoft's Component Object Model (COM), which was introduced in 1993 to
facilitate component-based development in the Windows environment. The COM
specification was designed to allow software components residing in a single
 address space or in separate address spaces within a single computer to interact
with one another.
       As in CORBA, objects in DCOM are accessed via interfaces. This allows
DCOM objects to be written in a number of different programming languages and
on a number of different platforms. Unlike CORBA, however, DCOM objects may
have multiple interfaces. When a client requests a DCOM object from a server, the
client must also request a specific interface of the object.22 The client request is first
sent to the client stub (called a proxy). The client stub communicates over a net­
work with the server stub, which forwards the request to the specific DCOM object.
When the DCOM object is finished with the request, it sends the return value back
to the server stub. The server stub sends this value back over the network to the
proxy, which finally returns the value to the calling process.23

Self Review
1. How is DCOM similar to CORBA?
2. What is a benefit of having multiple interfaces for a DCOM object?
Ans: 1) Both DCOM and CORBA provide support for remote objects written in different
programming languages on different platforms. 2) This allows a single DCOM object to inter­
act differently with different processes.

17.3.6 Process Migration in Distributed Systems
An alternative to remote communication is process migration, which transfers a pro­
cess between two computers in the distributed system. Recall from Section 15.7 that
process migration implements load balancing in multiprocessor systems. Process
migration can enable more efficient access to remote resources. For example, con­
sider that computers A and B are networked and that a process residing on computer

<!-- pág. 848 -->

794 Introduction to Distributed Systems
                             A frequently accesses files residing on computer B. The combination of disk and net­
                             work latency could severely degrade the performance of the process. To reduce this
                             latency, the process from computer A can be transferred to computer B.24
                                   Process cloning creates a copy of a process on a remote machine. Because
                             process cloning does not destroy the original process, the two processes may need
                             to synchronize access to shared memory.25

                             Self Review
                             1. Why is process migration employed in distributed systems?
                             2. Explain the difference between process migration and process cloning.
                             Ans: 1) Process migration allows a process executing on one computer to be transferred to
                             another to utilize the resources efficiently and to distribute the workload among different pro­
                             cessors; it can improve performance by enabling processes to execute without incurring net­
                             work latencies. 2) In process migration, the process is transferred to, and executed on, a remote
                             computer. In process cloning, a new process is created and executed on the remote computer.



                             17.4 Synchronization in Distributed Systems
                             Distributed systems typically contain many processes that cooperate to achieve a
                             common goal. Events at one node in a distributed system often depend on events at
                             other nodes. Determining the order in which events occur is difficult, because com­
                             munication delays in a distributed network are unpredictable. If two nodes each
                             send a message to a third node, the order of arrival of the two messages might not
                             be the same as the order in which they were sent. This uncertainty can have impor­
                             tant consequences if the two messages are related. For example, suppose a distrib­
                             uted system ensures mutual exclusion by having processes broadcast a message
                             whenever they enter or leave a critical section. Suppose one process leaves its criti­
                             cal section and broadcasts a message. Upon receiving this message, another process
                             enters its critical section and broadcasts a second message. If a third process
                             receives the second message, before the first, it will appear to that process that
                             mutual exclusion has been violated.
                                   This mutual exclusion example describes a causally dependent relationship. The
                             second message (that a process is executing inside its critical section) may occur only
                             if the first message (indicating that a process has exited its critical section) has been
                             broadcast. Causal ordering ensures that all processes recognize that a causally depen­
                             dent event must occur only after the event on which it is dependent.
                                    Causal ordering is implemented by the happens-before relation, which is
                             denoted as a → b. This relation states that if events a and b belong to the same pro­
                             cess, then a → b if a occurred before b. This relation also states that if event a is the
                             sending of a message and event b is the receiving of that message, then a → b.
                             Finally, this relation is transitive, so if a → b and b → c then a → c. Causal ordering
                             is only a partial ordering, because there will be events for which it cannot be deter­
                             mined which occurred earlier. In this case, these events are said to be concurrent.

<!-- pág. 849 -->

                                                                    17.5 Mutual Exclusion in Distributed Systems 795
 Sometimes, a causal ordering is not strong enough. A total ordering ensures that all
 events are ordered and that causality is preserved.26
      One way to implement total ordering is through a logical clock which assigns a
  number (or time stamp) to each event (such as sending and receiving a message,
  accessing a variable, etc.) that occurs in the system. Logical clocks do not measure
time as such, but rather the order in which events occur; they are often imple­
 mented as a simple counter of events. Logical clocks enforce a causal ordering in
that if a → b, then the time associated with event a will be less than that associated
with event b.27
      Scalar logical clocks synchronize the logical clocks on remote hosts and keep a
single time value at each host. They ensure causality by following two simple rules.
 The first rule is that if two events happen within the same process, then the event
that happened earlier in actual time will have the earlier time stamp. The second
rule is that the event corresponding to receiving a message will have a later time
stamp than the event corresponding to sending that message. These two rules also
ensure that scalar logical clocks ensure causality.28
      To follow the first rule, a process will increment its internal clock each time an
event occurs. To follow the second rule, when a process receives a message, it will
compare the value of its logical clock to the time stamp from the message, set its
logical clock to the latter of the two and then increment it.29

Self Review
1. How is a logical clock implemented?
2. What would happen if the clocks used by different processes were not synchronized?
Ans: 1) To implement the logical clock, a process must increment its clock before it exe­
cutes an event, and a process must append a time stamp (the local time at which the message
was sent) to the end of a message. 2) If the clocks used by different processes were not syn­
chronized, then the time stamp from one process would be interpreted incorrectly by the
other process.


17.5 Mutual Exclusion in Distributed Systems
This section discusses how to implement mutual exclusion in distributed systems.
The synchronization methods presented in the previous section are used to enforce
mutual exclusion.

17.5.1 Mutual Exclusion without Shared Memory
Efficient mutual exclusion algorithms for uniprocessor and shared memory multi­
processors use shared memory. However, in environments with no shared memory,
such as NORMA multiprocessors, mutual exclusion must be implemented using
some form of message passing, which often requires clock synchronization. FIFO
broadcast guarantees that when two messages are sent from one process to another,
the message that was sent first will arrive first. Causal broadcast ensures that when

<!-- pág. 850 -->

796 Introduction to Distributed Systems

                             message M1 is causally dependent on message M2, then no process receives M1
                             before receiving M2. Atomic broadcast guarantees that all messages in a system are
                             received in the same order at each process. Atomic broadcast is also known as
                             totally ordered broadcast or agreed broadcast.30, 31

                             Self Review
                             1. What is FIFO broadcast?
                             2. State the difference between atomic broadcast and causal broadcast.
                             Ans: 1) FIFO broadcast guarantees that when two messages are sent from one process to
                             another, the message that was sent first will arrive first. 2) Causal broadcast does not guaran­
                             tee the delivery order of unrelated messages. Atomic broadcast guarantees that unrelated
                             messages are delivered in the same order to each process.

                             17.5.2 Agrawala and Ricart's Distributed Mutual Exclusion Algorithm
                             G. Ricart and A. K. Agrawala present an algorithm for ensuring mutual exclusion in
                             NORMA systems in their 1981 paper, "An Optimal Algorithm for Mutual Exclusion
                             in Computer Networks"32 which derives from the work by Lamport.33 This algorithm
                             requires that a process first send a request message to all other processes in the sys­
                             tem and receive a response from each of them before that process can enter its critical
                             section. This algorithm assumes that communication between processes is reliable
                             (i.e., no messages are lost) and that processes do not fail. Algorithms have been devel­
                             oped to address these issues, but they are beyond the scope of this book.
                                     When a process receives a request to enter a critical section and has not sent a
                             request of its own, it sends a reply. If the process has sent its own request, it compares
                             the time stamps of the two requests, and if its own request has a later time stamp than
                             the other request, it sends a reply. If the process's own request has an earlier time
                             stamp than the other request, it delays its reply. Finally, if the time stamps of the
                             requests are equal, the process compares its process number to that of the requesting
                             process. If its own number is higher, it sends a reply, otherwise it delays its reply.
                                     Consider processes P1, P2, P3, each residing on different nodes. Process P2
                             wishes to enter its critical section and sends request messages to P1 and P3. Pro­
                             cesses P1 and P3 do not wish to enter their critical sections and immediately
                             respond. Once P2 has received both of these replies, it enters its critical section.
                             While P2 executes inside its critical section, both P1 and P3 attempt to enter their
                             critical sections. Each process sends its request message, and both happen to have
                             identical time stamps. Process P2 receives both requests but delays its reply because
                             it is currently inside its critical section. Process P3 receives the request from P1 and
                             compares the time stamps. Because both are equal, P3 then compares process num­
                             bers. P3's number is higher than P1's, so P3 sends its reply.
                                     Process P1 receives the request from P3 and compares the time stamps. Again,
                             both are equal, but P1's number is less P3's, so the reply is delayed. When P2 exits its
                             critical section, it sends replies to both P1 and P3. Process P2 does not check either
                             time stamp, since it is concerned only about whether it is currently using its critical

<!-- pág. 851 -->

                                                                               17.6 Deadlock in Distributed Systems 797

 section, not whether another process is doing so. Process P1 receives the reply from
  P2 and enters its critical section (as it has already received a reply from P3). Process
P3 receives the reply from P2 but must still wait on the reply from P1. Finally, when
 P1 is done with its critical section, it sends its reply to P3, which will then enter its
 critical section.
      Mutual exclusion is ensured by this algorithm. If two processes entered their
 critical sections at the same time, it would mean that each process sent a request,
 received the other process's request, compared the time stamps, and found that the
other process's request had a lower time stamp than its own. This is not possible;
 therefore, mutual exclusion is ensured.34
      This algorithm also prevents indefinite postponement. If a process is indefi­
nitely postponed, requests are being sent with earlier time stamps than its own. But
because time stamps increase monotonically, all requests sent after the postponed
process's request will have a later time stamp. Eventually, all requests with an ear­
­­er time stamp will be fulfilled and the postponed process's request will have the
  lowest timestamp, allowing the postponed process to proceed. In Exercise 17.12
you will be asked to prove that this algorithm prevents deadlock.35

Self Review
1. What are the consequences if a process does fail in this algorithm?
2. If there are n processes within the system, how many messages must be sent before a pro­
   cess can enter its critical section?
Ans: 1) If a process fails, then other processes will not receive replies from it when they
send out a request. If there is no mechanism to determine that a process has failed, the entire
system could become deadlocked. 2) 2(n - 1 ) messages must be sent.


17.6 Deadlock in Distributed Systems
Distributed deadlock occurs when processes spread over different computers in a
network wait for events that will not occur. This section addresses how distributed
systems complicate the problem of deadlock and provides algorithms to solve them.

17.6.1 Distributed Deadlock
Distributed deadlock can be classified into three types. Resource deadlock is the
type discussed in Chapter 7.36
      As in a centralized system, processes in a distributed system also often block,
waiting for signals from other processes. This introduces a new type of deadlock
called communication deadlock, circular waiting for communication signals. For
 instance, if P1 is waiting for a response from P 2 , P2 is waiting for a response from P3
and P3 is waiting for a response from P1, then the system is deadlocked. 37
      Due to the communications delay associated with distributed computing, it is
possible that a deadlock detection algorithm, introduced in Chapter 7, might detect
 a deadlock that does not exist. For example, consider processes P 1 and P 2 executing

<!-- pág. 852 -->

798 Introduction to Distributed Systems

                             on different nodes and a third node, N3, that is testing for deadlock. Process P1
                             holds resource R1 and process P2 holds resource R2. Process P1 releases resource
                             R1 and sends message M1 to node N3. Process P1 then requests resource R2 and
                             sends message M2 to node N3. Process P2 releases resource R2 and sends message
                             M3 to node N3. Finally, P2 requests R1 and sends message M4 to node N3. Suppose
                             that, because of network latency, messages M2 and M4 arrive at node N3 before M1
                             and M3. Node N3 would then detect a deadlock which did not exist. This is known
                             as phantom deadlock.38

                             Self Review
                             1. When would phantom deadlock occur?
                             2. Why is it difficult to manage distributed deadlock?
                             Ans: 1) Phantom deadlock occurs when communications between two processes are
                             delayed, which leads to a false global state. 2) In distributed systems, the deadlocked pro­
                             cesses are spread over different computers in a network. Managing distributed deadlock
                             requires each process to know the global state of the shared resources and critical sections.


                             17.6.2 Deadlock Prevention
                             To prevent deadlocks in uniprocessor machines, it is sufficient to deny one of the
                             four necessary conditions for deadlock (i.e., mutual exclusion, wait for, no preemp-
                             tion and circular wait). These techniques can also be employed to prevent distrib-
                             uted deadlock. Rosenkrantz et al. developed two algorithms designed specifically
                             for distributed systems in their 1978 paper, "System Level Concurrency Control for
                             Distributed Database Systems." Both of these algorithms rely on ordering pro­
                             cesses based on when each process was started. 39

                             Wound-Wait Strategy
                             The wound-wait deadlock prevention strategy (Fig. 17.2) breaks deadlock by deny-
                             ing the no-preemption condition. Consider the following situation: there are two
                             processes, P1 and P 2 , and P1 was created before P 2 . If process P1 requests a resource
                             held by P 2 , P1 wounds P 2 . Process P2 will then be restarted, freeing all of its
                             resources, including the resource requested by P1. If P2 requests a resource held by
                             P1, P2 will wait for P1 to finish using the resource and release it.40

                             Wait-Die Strategy
                             The wait-die deadlock prevention strategy (Fig. 17.3) prevents deadlock by denying
                             the wait-for condition. Consider the following situation: there are two processes, P1
                             and P2, and P1 was created before P2. Process P1 can request a resource held by P2
                             and wait for P2 to release that resource. But if P2 requests a resource held by P1, P2
                             dies. When P2 dies, it releases all of its resources and restarts.41

<!-- pág. 853 -->

                                                                       17.6 Deadlock in Distributed Systems 799




Figure 17.2 | Wound-wait strategy.




Figure 17.3 | Wait-die strategy.

      Both of these strategies prevent deadlock, but processes interact differently in
each. In the wound-wait strategy, recently created processes will be restarted if they
hold a resource requested by an earlier created process. Recently created processes
are also forced to wait for earlier created processes. As a process ages, it will wait
less often. In the wait-die strategy, recently created processes will die instead of
waiting for a resource. As processes age, they may be forced to wait more often.42

<!-- pág. 854 -->

800 Introduction to Distributed Systems

                              Self Review
                              1. How do the wound-wait and wait-die strategies prevent indefinite postponement?
                              2. What is a problem with the wound-wait and wait-die strategies?
                             Ans: 1) In both algorithms, a process that is rolled back many times would eventually get
                             executed, because at some point it would have an earlier time stamp than other processes.
                             2) In each algorithm, a process may be forced to restart multiple times. This requires the pro­
                             cess to repeatedly execute the code preceding the roll back.

                              17.6.3 Deadlock Detection
                              In a centralized system, all resources and processes are located on a single machine.
                              In a distributed system, resources and processes are spread over multiple, geo­
                              graphically distant machines. This makes it harder for the system to coordinate
                              interactions between processes. Three distributed deadlock detection strategies are
                              central, hierarchical and distributed. Systems that implement central deadlock
                              detection contain a single node that monitors the entire system. Whenever a pro­
                              cess requests or releases a resource, it notifies the central node. The node checks the
                              global system for cycles. Upon detection of a cycle, the system may implement a
                              variety of deadlock recovery algorithms. The centralized deadlock detection strat­
                              egy is simple to implement and is efficient for LANs, which are relatively small and
                              exhibit relatively high communication rates. However, the system may experience
                              decreased performance, because resource requests can create a bottleneck at the
                              central node. Also, central deadlock detection is not fault tolerant, because a failure
                              at the central node prevents all nodes in the system from acquiring resources.43, 44
                                    The hierarchical deadlock detection method organizes a system's nodes in a
                              tree. Each node, except the leaf nodes, collects the resource allocation information
                              of all dependent nodes. This tree structure provides a higher degree of fault toler­
                              ance than centralized systems. Furthermore, because deadlock detection is divided
                              into hierarchies, each branch of the tree needs to have knowledge only of the
                              resources within that branch.45
                                    Distributed deadlock detection strategies require each process to determine
                              whether deadlock exists. To do this, each node queries all other nodes. This is the
                              most fault-tolerant method of deadlock detection, because the failure of one node
                              does not prevent other nodes from functioning properly. However, creating effi­
                              cient algorithms for distributed deadlock detection is difficult, because they must
                              manage synchronized communication among many processes.46


                             Self Review
                              1. In a distributed system operating over a WAN, why would it be infeasible to use a central-
                                 ized deadlock detection strategy?
                              2. What will happen in a hierarchical deadlock detection scheme if a host fails?
                             Ans: 1) In a WAN, a deadlock may not be detected for a long time, due to communication
                             delays. This will cause processes involved in the deadlock to wait unnecessarily long for the

<!-- pág. 855 -->

                                                                               17.6 Deadlock in Distributed Systems 801

deadlock to be resolved. 2) Deadlock detection for all hosts dependent on the failed host will
stop. This can cause a reduction in performance.

17.6.4 A Distributed Resource Deadlock Algorithm
Johnston et al. presented a simple algorithm for deadlock detection in distributed
systems in their 1991 paper, "A Distributed Algorithm for Resource Deadlock
Detection."47 In this algorithm, each operating system enforces mutual exclusion on
its resources and keeps track of which process holds each resource. Processes can
be uniquely identified throughout the entire distributed system.
      Consider a simple example. Process P1 begins executing and requests resource
R1. Resource R1 is available, so its operating system allocates it to P1. Process P2
then begins executing and requests resource R2, which is also available and is allo­
cated to P2. Process P2 then requests R1. Resource R1 is being used, so P2 is
blocked and R1's operating system sends P2 the identifier of process P1, which holds
the resource that P2 has requested. This value is stored in P2's Heldjby variable.
Process P1 also holds all of the resources it needs to execute, so P2 stores P1 in its
Wait_for variable. Finally, P1 records in its Request_queue that process P2 has
requested R1.
      Now process P3 begins executing. It requests resource R3, which is available
and allocated to P3. P3 then requests resource R2 which is held by process P2. P3
blocks, and R2's operating system sends P3 the identifier of P2. P2 is then stored in
P3's Held_by variable. P2 has an outstanding resource request, so P3 stores the value
that is in P2's Wait_for variable, which is P1, in its own. Finally, P2 records in its
Request_queue that process P3 has requested R2.
       Process P4 then begins executing and also requests resource R2. P4 blocks, and
R2's operating system sends P4 the identifier of P2, which is then stored in P4's
Held_by variable. P2 has an outstanding resource request, so P4 stores the value of
P2's Wait_for variable (which is P1) in its own. Finally, P2 records in its
Request_queue that process P4 has requested R2.
       Figure 17.4 shows the transaction wait-for graph (TWFG) for this system. In a
TWFG, each process in the system is a node in the graph. A line between nodes indi­
cates that one process has requested a resource that is being held by another process.




Figure 17.4 | System without deadlocks.

<!-- pág. 856 -->

802   Introduction to Distributed Systems

                                     Suppose now that process P1 requests resource R 3 , which will complete a cir­
                               cular wait (Fig. 17.5). P1 now blocks, and R 3 's operating system sends P1 the identi­
                              fier of the process that holds R 3 , which is P 3 . This process is stored in P 1 's Held_by
                              variable. Since P3 has an outstanding resource request, P1 stores in its Wait_for vari­
                              able the process in P 3 's Wait_for variable, which is P1. Finally, P3 stores in its
                              Request_queue that process P1 has requested R 3 .
                                     When P1 changes its Wait_for variable (from null to P 1 ), it sends a message to
                              each process in its Request_queue to update their own Wait_for variables. Process
                              P2 receives this message, but its Wait_for variable is already P1, so no change is
                              made. P 2 then checks for deadlock. This is done by testing whether the process in
                              the Waitjor variable is also in P 2 's Request_queue. The process in P 2 's Wait_for
                              variable is P1, while the only process in its Request_queue is P 3 , so deadlock is not
                              detected at this step. The message is now forwarded to P 3 and P 4 .
                                     Process P3 receives the message, but its Wait_for variable is already P1 also, so
                              no change is made. P3 still checks for deadlock, though. The process in P 3 's Wait_for
                              variable is P1, which is also in P 3 's Request_queue, so a deadlock has been detected.
                              In this algorithm, the process that detects the deadlock aborts, so P 3 releases R3,
                              notifies P 1 that R 3 has been freed, and aborts. P 1 's resource request will then be
                              filled, and the deadlock has been removed (Fig. 17.6).




                              Figure 17.5 | Deadlock is introduced to the system.




                              Figure 17.6 | System after deadlock has been eliminated.

<!-- pág. 857 -->

                                                          17.7 Case Study: The Sprite Distributed Operating System 803

Self Review
1. How does a process check for deadlock in this algorithm?
2. What information is stored in a process's Request queue?
Ans: 1) A process checks for deadlock by determining whether the process in its Wait_for
 variable is also an entry in its Request_queue. If this is the case, deadlock has occurred. 2) The
 Request_queue keeps track of the processes that have requested a resource held by the origi-
 nal process, and of the resource each of those processes requested.


17.7 Case Study: The Sprite Distributed Operating System
Sprite is a distributed operating system developed at the University of California at
Berkeley. Sprite connects large numbers of powerful but inexpensive personal
 workstations in a high-speed LAN. In a Sprite network, large numbers of personal
 workstations are connected, and many computers could be idle at any given time.
 These idle workstations allow Sprite to use process migration to balance the work-
  load of the system.48
       Each workstation in Sprite monitors its own usage to determine if it is idle.
When a workstation does not receive any keyboard or mouse input for 30 seconds
and when it has fewer running processes than processors, the workstation claims it
 is idle and reports to a server, called the central migration server, that keeps infor­
mation about idle workstations. The central migration server will then migrate a
process to that workstation, called the target computer. When the user of the target
computer returns (i.e., the workstation receives a keyboard or mouse input), the
 workstation notifies the central migration server about the return, and the process
 is migrated back to its original computer, called the home computer.49
       Each workstation in the system runs a Sprite kernel, and these can communi­
cate with each other via RPCs. Sprite uses implicit acknowledgements to ensure
that messages are delivered reliably. With implicit acknowledgements, the response
message is an implied acknowledgement for the request message.
       To ensure transparency, the Sprite kernel distinguishes between two kinds of
calls. Location-dependent calls are system calls that produce different results for
different workstations. Location-independent calls are system calls that produce the
same result for all workstations. The system then provides more location-indepen-
dent calls by providing the exact same view of the file system for each workstation.
When a location-dependent call is required, the system either forwards the call to
the home computer for evaluation or transfers the process's state information (such
as virtual memory, open files and process identifiers, etc.) from the home computer
to the target computer.
       The Sprite file system has the same form as a UNIX file system—every client
has the exact same view of the hierarchy. The Sprite file system caches files on both
the server and client sides. On the server side, when a file is requested, the server
checks the server cache first. If the requested file is not cached, the server adds the
 file to the server cache and sends it to the client. On the client side, when a file is

<!-- pág. 858 -->

804 Introduction to Distributed Systems
                             requested, the client checks the client cache first. If the file is in the client cache,
                             then the client gets the file from the client cache. Otherwise, the client gets the file
                             from the server and adds it to the client cache.50 Section 18.2.5, Sprite File System,
                             discusses the Sprite file system in much more detail.

                             Self Review
                             1. Give an example of a location-dependent call.
                             2. How does Sprite share computer power to balance workload?
                             Ans: 1) Obtaining the home computer's name is a location-dependent call. 2) Sprite uses a
                             process migration mechanism to enable idle computers to share computer power. When pro­
                             cess migration happens, a process on one computer is transferred to an idle computer, dis­
                             tributing the workload among the computers in the system.



                             17.8 Case Study: The Amoeba Distributed Operating System
                             Amoeba is a distributed operating system developed at the Vrije Universiteit
                             Amsterdam. Unlike Sprite in which each workstation has its own processors,
                             Amoeba users share processors located in one or more processor pools. A proces­
                             sor pool is a collection of processors, each having its own memory and Ethernet
                             connection. The processors in the processor pool are shared equally among users.
                             When a user issues a command to execute a process, the processor pool dynamically
                             allocates the processors for the user. When the user process terminates, the user
                             returns the allocated processors to the processor pool. Like Sprite, Amoeba pro-
                             vides transparency by hiding the number and location of processors from the user.51
                                   Each processor in an Amoeba system runs a microkernel, which is a collection
                             of services that supports kernel process management, kernel memory management
                             and the communication between clients and servers. It is also the microkernel's
                             responsibility to manage and schedule the threads in a process.52
                                   Amoeba supports two forms of communication—point-to-point and group. In
                             a point-to-point communication, a client stub sends a request message to the server
                             stub and blocks, awaiting the server reply. Amoeba uses explicit acknowledgement,
                             which means the client sends an acknowledgement to the server in an additional
                             packet when the client receives the response from the server. In a group communi-
                             cation, messages are sent to all receivers in exactly the same order.
                                   The Amoeba file system has a standard file server called the bullet server. The
                             bullet server has a large primary memory. The files stored in it are immutable, which
                             means they cannot be modified after being created. If the file is modified, a new file is
                             created to replace the old one, and the old one is deleted from the server.53
                                   The bullet server stores files contiguously on the disk, while Sprite stores files
                             in blocks that are not necessarily contiguous. This means that the bullet server can
                             transfer files faster than Sprite. Unlike Sprite, the bullet server supports only server-
                             side caching. Files located in the cache are also stored contiguously. When a client
                             process wants to access a file, it sends the request to the bullet server. The bullet

<!-- pág. 859 -->

                                                                                                          Web Resources 805
 server retrieves the file from disk if it is not in the cache, otherwise the bullet server
gets the file from the cache.54

Self Review
1. How are processors managed in Amoeba?
2. How is a file stored in the bullet server modified?
Ans: 1) All processors are located in one or more processor pools. The processors in a pool
are not owned by a particular user but are shared among all the users. The processor pool
 dynamically allocates the processor for each client. When the processors finish their job to
 execute a client's command, they are returned to the processor pool. 2) Bullet servers store
 only immutable files. To modify a file, a bullet server creates a new file to replace the old one,
 and the old file is deleted from the server.



Web Resources
www.cs.arizona.edu/computer.help/policy/                               www.omg.org/docs/formal/02-12-06.pdf
  DIGITAL_unix/AA-Q0R5B-TETl_htmVTOC.htm1                              Detailed CORBA architecture and specification.
Discusses the remote procedure call (RPC) model.                       msdn.microsoft.com/library/default.asp?url=/
 www.omg.org/library/wpjava.html                                       1i brary/en-us/dndcom/html/msdn_dcomtec.asp
Demonstrates how Java, RMI and CORBA are used in distrib­              D C O M technical overview provided by Microsoft.
uted systems.                                                          research.microsoft.com/~ymwang/papers/HTML/
 java.sun.com/products/jdk/rmi/                                        DCOMnCORBA/S.html
Java RMI home page, which contains links for white papers,             Architectural comparison of DCOM and CORBA.
specifications and RMI tutorials.                                      ftp://ftp.cs.vu.nl:/pub/papers/amoeba/
java.sun.com/j2se/1.4.2/docs/gui de/rmi/spec/rmi-                      comcom91.ps.Z
TOC.html                                                               Status report on the Amoeba distributed operating system,
Provides the Java platform's remote method invocation system           www.cs.vu.nl/pub/amoeba/Intro.pdf
specification.                                                         Introduction to the Amoeba distributed operating system,
www.omg.org/gettingstarted/corbafaq.htm                                ftp://ftp.cs.vu.nl:/pub/papers/amoeba/cs91.ps.Z
introduces CORBA and provides links to detailed specifica­             Compares the Amoeba and Sprite distributed operating sys­
tions.                                                                 tems.


Summary
In distributed systems, remote computers cooperate via a               Replication offers users increased reliability and availabil­
network to appear as a local machine. Scalability allows the           ity over single-machine implementations, but designers
distributed system to grow without affecting the existing              must provide mechanisms to ensure consistency among the
applications and users. Distributed systems can be suscepti­           state information at different machines.
ble to attacks by malicious users if they rely on insecure                   Access transparency hides the details of networking
communications media. To improve security, a distributed               protocols that enable communication between distributed
system should allow only authorized users to access                    computers. Location transparency builds on access trans­
resources and ensure that information transmitted over the             parency to hide the location of resources in the distributed
network is readable only by the intended recipients. The               system.
system must also provide mechanisms to protect resources                     Failure transparency is the method by which a distrib­
 from attack. Distributed systems implement fault tolerance            uted system provides fault tolerance. Under replication, a
by providing replication of resources across the system.               system provides multiple resources that perform the same

<!-- pág. 860 -->

806   Introduction to Distributed Systems

function. A system that employs checkpointing periodically        marshals the result and returns it to the client via the RRL
stores the state of an object such that it can be restored if a   and stub.
failure in the distributed system results in the loss of the             CORBA (Common Object Request Broker Archi-
object.                                                           tecture) is an open standard designed to enable interopera-
       Replication transparency hides the fact that multiple      tion among programs in heterogeneous as well as
copies of a resource are available in the system. Persistence     homogeneous systems. CORBA supports objects as param-
transparency hides the information about where the                eters or return values in remote procedures during inter­
resource is stored—memory or disk.                                process communication and is language independent. In
       Migration and relocation transparency both hide the        CORBA, the process on the client passes the procedure
movement of components of a distributed system. The               call along with the required arguments to the client stub.
former masks the movement of an object from one location          The client stub marshals the parameters and sends the pro­
to another in the system; the latter masks the relocation of      cedure call through its Object Request Broker (ORB),
an object from other objects that communicate with it.            which communicates with the ORB on the server. CORBA
Transaction transparency allows a system to achieve consis­       provides its users language independence with the Inter-
tency by masking the coordination among a set of resources.       face Definition Language (IDL), which allows program-
       A remote procedure call allows a process executing         mers to strictly define the procedures that can be called on
on one computer to invoke a procedure in a process exe­           the object.
cuting on another computer. A goal of RPC was to simplify                Distributed Component Object Model (DCOM) is
the process of writing distributed applications by preserv­       designed to allow software components residing on remote
ing the syntax of a local procedure call while transparently      computers to interact with one another. As in CORBA,
initiating network communication. To issue an RPC, a cli­         objects in DCOM are accessed via interfaces. Unlike
ent process makes a call to the procedure in the client stub,     CORBA, however, DCOM objects may have multiple
which performs marshaling of data to package procedure            interfaces. When a client requests a DCOM object from a
arguments along with the procedure name into a message            server, the client must also request a specific interface of
for transmission over a network. The client stub passes the       the object.
message to the server, which transmits the message to the                Process migration transfers a process between two
server stub. The message is then unmarshaled, and the stub        computers in a distributed system. Process migration
sends the parameters to the appropriate local procedure.          between remote computers allows processes to exploit a
When the procedure has completed, the server stub mar­            remote resource, but it is a complicated task that often
shals the result and sends it back to the client. Finally, the    reduces the performance of the process that is being
client stub unmarshals the result, notifies the process and       migrated. Process cloning is similar to process migration,
passes it the result.                                             except that instead of transferring a process to a remote
       Remote method invocation (RMI) enables a Java              location, a new process is created on the remote machine.
process executing on one computer to invoke a method of                  Determining the order in which events occur is diffi-
an object on a remote computer using the same syntax as a         cult, because communication delays in a distributed net-
local method call. Similar to RPC, the details of parameter       work are unpredictable. Causal ordering ensures that all
marshaling and message transport in RMI are transparent           processes recognize that a causally dependent event must
to the calling program.                                           occur only after the event on which it is dependent.
       The stub/skeleton layer of RMI contains parameter-                Causal ordering is implemented by the happens-
marshaling structures analogous to the client and server          before relation, which states that if events a and b belong to
stubs of RPC. The stub employs object serialization, which        the same process, then a → b if a occurred before b. This
enables programs to pass Java objects as parameters and           relation also states that if event a is the sending of a mes-
receive objects as return values. The remote reference layer      sage and event b is the receiving of that message, then
(RRL) and the transport layer of RMI work together to             a → b. Finally, this relation is transitive. Causal ordering is
send the marshaled message between the client and the             only a partial ordering. Events for which it cannot be deter-
server. The skeleton unmarshals the parameters, identifies        mined which occurred earlier are said to be concurrent. A
the object on which the method is to be invoked and calls         total ordering ensures that all events are ordered and that
that method. Upon completion of the method, the skeleton          causality is preserved.

<!-- pág. 861 -->

                                                                                                             Summary          807
       One way to implement total ordering is through a           for another process if the first process was created after the
logical clock which assigns a timestamp to each event that        other process. A process will die (restart) itself if it was cre­
 occurs in the system. Scalar logical clocks synchronize the      ated before the other process.
logical clocks on remote hosts and ensure causality.                     Systems that implement central deadlock detection
       In environments with no shared memory, mutual              have one site that is dedicated to monitoring the entire sys­
exclusion must be implemented over message passing.               tem. Whenever a process requests or releases a resource it
Message-passing systems use clock synchronization con­            informs the central site which continuously checks the sys­
cepts to employ either FIFO broadcast, causal broadcast or        tem for cycles. The central algorithm is simple to implement
atomic broadcast to synchronize the system. FIFO broad­           and is efficient for LANs. However, the system may experi­
cast guarantees that when two messages are sent from one          ence decreased performance and is not fault tolerant.
process to another, the message that was sent first will                 The hierarchical deadlock detection method arranges
arrive first. Causal broadcast ensures that when message          each site in the system as a node in a tree. Each node,
m1 is causally dependent on message m2, then no process           except the leaf nodes, collects the resource allocation infor­
delivers m1 before delivering m2. Atomic broadcast guar­          mation of all dependent nodes. This tree structure helps to
antees that all messages in a system are received in the          ensure fault tolerance. Furthermore, because deadlock
same order at each process.                                       detection is divided into hierarchies and clusters, sites that
       Ricart and Agrawala's algorithm requires that a pro­       are irrelevant to deadlock detection on a particular
cess first send a request message to all other processes in the   resource do not have to participate in deadlock detection.
system and receive a response from each of these processes               Distributed deadlock detection algorithms place the
before that process can enter its critical section. When a pro­   responsibility of deadlock detection with each site. Each site
cess receives a request to enter a critical section and has not   in the system queries all other sites to determine whether
sent a request of its own, it sends a reply. If the process has   any other sites are involved in deadlock. This is the most
sent its own request, it compares the timestamps of the two       fault-tolerant method of deadlock detection because the fail­
requests and if the process's own request has a later times­      ure of one site will not cause any other site to fail.
tamp than the other request, it sends a reply. If the process's          Johnston, et al. presented a simple algorithm for
own request has a earlier timestamp than the other request,       deadlock detection in distributed systems. In this algo­
it delays its reply. Finally, if the timestamps of the requests   rithm, each process keeps track of the transaction wait-for
are equal, the process compares its process number to that of     graph (TWFG) of which they are involved. When a process
the requesting process. If its own number is higher, it sends a   requests a resource that is being held by another process,
response, otherwise it delays its response.                       the requesting process blocks and the TWFG is updated.
      There are three types of distributed deadlock:              As this happens, any deadlocks are detected and removed.
resource deadlock, communication deadlock and phantom                    In a Sprite network, large numbers of personal work­
deadlock. Resource deadlock is the kind of deadlock intro­        stations are connected and many computers could be idle
duced in Chapter 7. Communication deadlock is circular            at any given time. These idle workstations allow Sprite to
waiting for communication signals. Due to the communica­          use process migration to balance the workload of the sys­
tions delay associated with distributed computing, it is pos­     tem. When the central migration server is notified that a
sible that a deadlock detection algorithm might detect a          workstation is idle, it will migrate a process to that target
deadlock (called phantom deadlock, a perceived deadlock)          computer. When the user of the target computer returns,
that does not exist. Although this form of deadlock cannot        the workstation notifies the central migration server about
immediately stop the system, it is a source of inefficiency.      the return, and the process is migrated back to the home
      Two algorithms designed to prevent deadlock rely on         computer.
ordering processes based on when each process was                        The Sprite kernel provides more location-indepen­
started. The wound-wait strategy breaks deadlock by deny­         dent calls by providing the exact same view of the file sys­
ing the no-preemption condition. A process will wait for          tem for each workstation. When a location-dependent call
another process if the first process was created before the       is required, the system either forwards the call to the home
other. In this strategy, a process will wound (restart)           computer for evaluation or transfers the process's state
another process if the first process was created after the        information from the home computer to the target com­
other. The wait-die strategy breaks deadlock by denying           puter. The Sprite file system also caches files on both the
the wait-for condition. In this strategy, a process will wait     server and client sides.

<!-- pág. 862 -->

808 Introduction to Distributed Systems

      Amoeba users share processors located in one or                stub and blocks, awaiting the server reply. In a group com­
more processor pools. When a user issues a command to                munication, messages are sent to all receivers in exactly the
execute a process, the processor pool dynamically allocates          same order.
the processors for the user. When the user process termi­                   The Amoeba file system has a standard file server
nates, the user returns the allocated processors to the pro­         called the bullet server which has a large primary memory.
cessor pool. Amoeba provides transparency by hiding the              The files stored in the bullet server are immutable. If a file-
number and location of processors from the user.                     is modified, a new file is created to replace the old one, and
      Amoeba supports two forms of communication—                    the old one is deleted from the server. The bullet server
point-to-point and group. In a point-to-point communica­             also stores files contiguously on the disk so that it can trans­
tion, a client stub sends a request message to the server            fer files faster than Sprite.




Key Terms
access transparency—Hides the details of networking proto­              Group (OMG), CORBA is a standard specification of dis­
    cols that enable communication between computers in a               tributed systems architecture that has gained wide accep­
    distributed system.                                                 tance.
atomic broadcast—Guarantees that all messages in a system            communication deadlock—One of the two types of distributed
    are received in the same order at each process. Also                deadlock, which is a circular waiting for communication
    known as totally ordered or agreed broadcast.                       signals.
bullet server—Standard file server used in the Amoeba file sys­      concurrent—Two events are concurrent if it cannot be deter­
     tem.                                                                mined which occurred earlier by following the happens-
causal broadcast—Ensures that when a message is sent from                before relation.
    one process to all other processes, any given process will       Distributed Component Object Model (DCOM)—Distributed
    receive the message before it receives a response to the              systems extension of Microsoft's COM.
    message from a different process.                                distributed deadlock—Similar to deadlock in a uniprocessor
causal ordering—Ensures that all processes recognize that a               system, except that the processes concerned are spread
    causally dependent event must occur only after the event              over different computers.
    on which it is dependent.                                        distributed deadlock detection strategy—Technique used to
causally dependent—Event B is causally dependent on event                 find deadlock in a distributed system.
    A if event B may occur only if event A occurs.                   distributed file system—Places files on physically distinct
central deadlock detection—A strategy in distributed dead­                machines, while providing the view of a single file system.
     lock detection, in which one site is dedicated to monitor­      distributed operating system—Provides all of the same ser­
     ing the TWFG of the entire system. Whenever a process                vices as a traditional operating system, but must provide
     requests or releases a resource, it informs the central site.        adequate transparency such that objects in the system are
     The site continuously checks the global TWFG for cycles.             unaware of the computers that provide the service.
central migration server—Workstation in a Sprite distributed         distributed system—Remote computers cooperate via a net-
     operating system that keeps information about idle work­             work to provide a unified operating system.
     stations.
                                                                     explicit acknowledgement—The client sends an acknowledge­
client stub—Stub at the client side that prepares outbound                ment to the server in an additional packet when the client
     data for transmission and translates incoming data so that           receives the response from the server.
     it may be correctly interpreted.
                                                                     failure transparency—Method by which a distributed system
Component Object Model (COM)—Introduced in 1993 by                        provides fault tolerance so that the client is unaware of
   Microsoft to facilitate component-based development in                 the failure of a computer.
   the Windows environment.
                                                                     FIFO broadcast—Guarantees that when two messages are
Common Object Request Broker Architecture (CORBA)—                       sent from one process to another, the message that was
   Conceived in the early 1990s by the Object Management                 sent first will arrive first.

<!-- pág. 863 -->

                                                                                                               Key     Terms     809

happens before relation—A happens before B if A and B               Object Request Broker (ORB)—Component residing on both
   belong to the same process and A occurred before B; or A             CORBA client and server, which is responsible for initiat­
   is the sending of a message and B is the receiver of that            ing communication between systems.
   message.                                                         object serialization—Allows objects to be encoded into byte
hierarchical deadlock detection—A strategy in distributed               streams and transmitted from one address space to
     deadlock, which arranges each site in the system as a node         another.
     in a tree. Each node, except the leaf nodes, collects the      partial ordering—An ordering of events that follows the hap-
    resource allocation information of all dependent nodes.              pens-before relation. Some events cannot be ordered
home computer (in process migration)—Computer on which                   using this system which is why it is only a partial ordering.
   the process originates.                                          persistence transparency—Hides the information about where
                                                                         the resource is stored—memory or disk.
implicit acknowledgement—The response message implies the
    acknowledgement for the request message.                        phantom deadlock—Situation due to communications delay
                                                                        associated with distributed computing, when a deadlock
immutable file—A file that cannot be modified after it is cre­
                                                                        detection algorithm (DDA) might detect a deadlock that
   ated.
                                                                        does not exist.
Interface Definition Language (IDL)—A language used to              process cloning—Creates a copy of a process on a remote
     specify the details of the RPCs, which provides a lan­
                                                                        machine.
     guage-independent representation of interfaces and
     allows distributed applications to transparently call proce­   processor pool—Component in Amoeba system, which con­
     dures on remote computers.                                         tains a collection of processors, each having its own mem­
                                                                        ory and Ethernet connection.
interoperability—Permits software components to interact
                                                                    proxy—In DCOM, the client-side stub that is responsible for
     among different hardware and software platforms, pro­
                                                                        marshaling and unmarshaling messages.
     gramming languages and communication protocols.
                                                                    relocation transparency—Masks the relocation of an object
location-dependent call—System call that depends on the
                                                                         from other objects that communicate with it.
    workstation (in Sprite) on which the call is executed.
    Location-dependent calls produce different results for dif­     remote method invocation (RMI)—Allows Java programmers
    ferent workstations.                                                to implement distributed systems without having to
                                                                        explicitly program sockets.
location-independent call—System call that does not depend
    on the workstation on which the call is executed. Loca­         remote procedure call (RPC)—Allows a process executing on
    tion-independent calls produce the same result for all              one computer to invoke a procedure (or function) in a
    workstations.                                                      process executing on another computer.
                                                                    remote reference layer (RRL)—Works with the transport
location transparency—Builds on access transparency to hide
                                                                        layer to send marshaled messages between the client and
     the location of resources in a distributed system from
                                                                        server in RMI.
     those attempting to access them.
                                                                    replication—Provides multiple resources that perform the
logical clock—Assigns a timestamp to each event that happens
                                                                         same function in a system.
     in a system in order to create a total ordering of events.
                                                                    replication transparency—Hides the fact that multiple copies
marshaling of data—A routine for the client stub to package              of a resource are available in the system. All access to a
    procedure arguments and return values for transmission               group of replicated resources occurs as if there were one
    over a network.                                                      such resource available.
middleware—A software layer that helps provide portability,         scalability—Allows a distributed system to grow (i.e., add
   transparency, and interoperability in distributed systems.            more machines to the system) without affecting the exist­
migration transparency—Masks the movement of an object                   ing applications and users.
    from one location to another in the system, such as the         server stub—A stub at the server side in RPC that prepares
    movement of a file from one server to another.                       outbound data for transmission and translates incoming
network operating system—Accesses resources on remote                    data so that it may be correctly interpreted.
    computers that run independent operating systems.               skeleton—Server-side stub.

<!-- pág. 864 -->

810 Introduction to Distributed Systems
standardized interface—Allows each client/server pair to com­       transparency—Hides the distribution aspects from users of a
     municate using a single, common interface that is under­           distributed system.
     stood by both sides.
                                                                    transport layer (in RMI)—Works with the RRL to send mar­
state information—Data that describes the status of one or               shaled messages between the client and server in RMI.
     more resources.
stub—prepares outbound data for transmission and translates         wait-die deadlock prevention strategy—Prevents deadlock by
     incoming data so that it may be correctly interpreted               denying the wait-for condition. Assigns individual pro­
                                                                         cesses unique priorities based on when they were created.
stub/skeleton layer in RMI—Contains parameter-marshaling                 A process will wait if it was created after the process it is
     structures analogous to the client and server stubs of RPC.         waiting on. A process will die if it was created before the
target computer (in process migration)—Computer to which                 process it is waiting on.
     the process is migrated.
                                                                    wound-wait deadlock prevention strategy—Prevents deadlock
time stamp—Records the local time at which the message was
                                                                       by denying the no-preemption condition. Assigns individ-
     sent.
                                                                       ual processes unique priorities based on when they were
total ordering—Ensures that all events are observed in the             created. A process requesting a resource held by another
     same order by all processes.                                      process will wound that process if the first one was created
transaction transparency—Allows a system to achieve consis­            before the other. A process will wait if it was created after
     tency by masking the coordination among a set of                  the process it is waiting on.
     resources.
                                                                    wound—When a process is wounded by another process, it will
transaction wait-for graph (TWFG)—Graph that represents                be rolled back.
     processes as nodes and dependencies as directed edges,
     which is used for distributed deadlock detection algorithms.

Exercises
17.1 What are the benefits of distributed systems?                  17.10 Distinguish FIFO broadcast, causal broadcast and
17.2 Define each type of transparency.                              atomic broadcast.
17.3 What is the role of middleware? Give examples of mid­          17.11 Suppose processes P1, P2 and P3 share the critical sec­
dleware.                                                            tion,. P1 sends a request to enter the critical section at logical
                                                                    time 1. P2 sends a request to enter the critical section at logical
17.4 Explain how RPC works.                                         time 2. P3 sends a request to enter the critical section at logical
17.5 When the client and the server communicate via RPC,            time 3. Apply Ricart and Agrawala's algorithm to demonstrate
the client blocks until it receives a response from the server.     how mutual exclusion is achieved.
What is the drawback of this design? Give an alternative sug­       17.12 Prove that Ricart and Agrawala's algorithm prevents
gestion to remove this limitation.                                  deadlock.
17.6 Why is the Interface Definition Language (IDL) impor­          17.13 Suppose processes P1, P2 and P3 have time stamps 1.2
tant in CORBA?                                                      and 3, respectively. If P1 requests a resource held by P2, which
17.7 Discuss the major differences in DCOM and CORBA.               process will be rolled back using the wound-wait algorithm?
17.8 Give examples in which process migration is used to            17.14 Suppose processes P1, P2 and P3 have timestamps 1.2
exploit resource locality and to balance work load.                 and 3, respectively. If P3 requests a resource held by P2, which
                                                                    process will be rolled back using the Wait-Die algorithm?
17.9 Draw two diagrams, one illustrating that event e2 is
dependent on e1, the other illustrating that events e2 and e1 are   17.15 Compare the Sprite and Amoeba distributed systems.
concurrent.

Recommended Reading
This chapter has only provided a high-level overview of certain     be found through the Object Management Group (OMG).55
middleware technologies. More information on CORBA can              In addition, many of the algorithms introduced in this chapter

<!-- pág. 865 -->

                                                                                                                                     Works Cited 811

 are discussed in much greater detail in the papers that intro-                         in distributed systems.57 Other resources are the paper by
duced each algorithm. Agrawala and Ricart's paper provides                              Johnston et al.,58 Which describes their deadlock detection
 much greater detail about their mutual exclusion algorithm.56                          algorithm, and Obermarck's paper,59 which covers another
Rosenkrantz et. al. discuss in their paper concurrency control                          deadlock detection algorithm not mentioned in this chapter.




Works Cited
 1. Tanenbaum, A. S., and M. van Steen, Distributed Systems, Princi­                    16. "CORBA Basics," <www.omg.org/gettingstarted/corbafaq.
    ples and Paradigms, Upper Saddle River, NJ: Prentice Hall, 2002,                        htm>.
    pp. 4-5.                                                                            17. "The Common Object Request Broker: Architecture and Specifi­
2. Gartner, F., "Fundamentals of Fault-Tolerant Distributed Corh-                           cation," OMG Document Number 93.12.43, December 1993.
   puting in Asynchronous Environments," ACM Computing Sur-                             18. Chung, P., et al., "DCOM and CORBA Side by Side, Step by
   veys, Vol. 31, No. 1, March 1999.                                                        Step, and Layer by Layer," C++ Report, Vol. 10, No. 1, January
3. ISO "Open Distributed Processing—Reference Model: Archi­                                 1998, pp. 18-29.
   tecture," Ref. Number: ISO/IEC 10746-3:1996E, September 15,                          19. "The Common Object Request Broker: Architecture and Specifi­
   1996, pp. 45-48.                                                                         cation," OMG Document Number 93.12.43, December 1993.
4. Renesse, R. V., and A. S. Tanenbaum, "Distributed Operating                          20. "DCOM Technical Overview," <msdn.microsoft.com/library/
   Systems," Computing Surveys, Vol. 17, No. 4, December 1985, pp.                          default.asp?url=/library/en-us/dndcom/html/msdn_
   421-422.                                                                                 dcomtec.asp>.
5. Renesse, R. V, and A. S. Tanenbaum, "Distributed Operating                           21. Botton, D., "Interfacing ADA 95 to Microsoft COM and DCOM
   Systems," ACM Computing Surveys, Vol. 17, No. 4, December                                Technologies," ACM SIGAda Ada Letters, Proceedings of the
   1985, pp. 420 and 425.                                                                   1999 Annual ACM SIGAda International Conference on Ada,
6. Wegner, P., "Interoperability," ACM Computing Surveys, Vol. 28,                          September 1999, Vol. 19, No. 3.
   No. 1, March 1996, pp. 287.                                                          22. Chung, P., et. at, "DCOM and CORBA Side by Side, Step by
7. Emmerich, W., "Software Engineering and Middleware: A Road-                              Step, and Layer by Layer," C++ Report, Vol. 10, No. 1, January
   map," Proceedings of the Conference on the Future of Software                            1998, pp. 18-29. <research.microsoft.com/~ymwang/papers/
   Engineering 2000, pp. 117-129.                                                           HTML/DCOMnCORBA/S.html >.
8. Bernstein, P., "Middleware: A Model for Distributed System Ser­                      23. DCOM        Architecture,       <msdn.microsoft.com/library/
   vices," Communications of the ACM, Vol. 39, No. 2, February                              default.asp?url=/library/en-us/dndcom/html/msdn_
   1996, pp. 86-98.                                                                         dcomarch.asp>.
 9. Birrell, A., and B. Nelson, "Implementing Remote Procedure                          24. Milojicic, D., et al., "Process Migration," ACM Computing Sur­
    Calls," ACM Transactions on Computer Systems, Vol. 2, No. 1,                            veys, Vol. 32, No. 3, September 2000, pp. 246.
    February 1984, pp. 41-42.                                                           25. Milojicic, D., et al., "Process Migration," ACM Computing Sur­
10. Birrell, A., and B. Nelson, "Implementing Remote Procedure                              veys, Vol. 32, No. 3, September 2000, p. 253.
    Calls," ACM Transactions on Computer Systems, Vol. 2, No. 1,                        26. Lamport, L., "Time, Clocks, and the Ordering of Events in a Dis­
    February 1984, pp. 43-44.                                                               tributed System," Communications of the ACM, Vol. 21, No. 7
11. Birrell, A., and B. Nelson, "Implementing Remote Procedure                              July 1978, pp. 558-560.
    Calls," ACM Transactions on Computer Systems, Vol. 2, No. 1,                        27. Lamport, L., "Time, Clocks, and the Ordering of Events in a Dis­
    February 1984, pp. 43-44.                                                               tributed System," Communications of the ACM, Vol. 21, No. 7,
12. "Java™ Remote Method Invocation (RMI)," <java.sun.com/                                  July 1978, p. 559.
    products/jdk/rmi/>.                                                                 28. Raynal, M., and M. Singhal, "Logical Time: A Way to Capture
                                                                                            Causality in Distributed Systems," Rapport de recherche, No.
13. "Java™ Remote Method Invocation," <java. sun.com/market-
                                                                                            2472, March 1995, pp. 8-9.
    i n g / c o l l a t e r a l / r m i _ds.html>.
                                                                                        29. Raynal, M., and M. Singhal, "Logical Time: A Way to Capture
14. "Java™ Remote Method Invocation: Stubs and Skeletons,"                                  Causality in Distributed Systems," Rapport de recherche, No.
    <java.sun.com/j2se/l.4/docs/guide/rmi/spec/rmi-                                         2472, March 1995, p. 8.
    arch2.html>.
                                                                                        30. Chockler, G. V; I. Keidar; and R. Vitenberg, "Group Communi­
15. "Java™ Remote Method Invocation: 2—Distributed Object                                   cation Specifications: A Comprehensive Study," ACM Computing
    Model," 2001, Sun Microsystems, < j a v a . s u n . c o m / j 2 s e / 1 . 4 . 1 /       Surveys, Vol. 33, No. 4, December 2001, pp. 446-449.
    docs/guide/rmi/spec/rmi-objmodel2.html>.

<!-- pág. 866 -->

812    Introduction to Distributed Systems
31. Tripathi, A., and N. M. Karnik, "Trends in Multiprocessor and      47. Johnston, B.; R Javagal; A. Datta; and S. Ghosh, "A Distributed
    Distributed Operating System Designs," Journal of Supercom-            Algorithm for Resource Deadlock Detection," Proceedings of
    puting,Vol 9, No. 1/2,1995, p. 13.                                     the Tenth Annual Phoenix Conference on Computers and Com­
32. Agrawala, A. K., and G. Ricart, "An Optimal Algorithm for              munication March, 1991, pp. 253-255.
    Mutual Exclusion in Computer Networks," Communications of          48. Ousterhout, J. K.; A. R. Cherenson; F. Doughs; M. N. Nelson; and
    the ACM, Vol. 24, No. 1, January 1981.                                 B. B. Welch, "The Sprite Network Operating System," IEEE
33. Lamport, L., "A New Solution of Djikstra's Concurrent Program­         Computer, Vol. 21, No.2, February 1998, pp. 23-36.
    ming Problem," Communications of the ACM, Vol. 17, No. 8,          49. Doughs, E, and J. K. Ousterhout "Process Migration in Sprite: A
    August 1974.                                                           Status Report," IEEE Computer Society Technical Committee on
34. Agrawala, A. K., and G. Ricart, "An Optimal Algorithm for              Operating Systems Newsletter, Vol. 3, No. 1, Winter 1989, pp. 8-
    Mutual Exclusion in Computer Networks," Communications of              10.
    theACM,Vo\. 24, No. 1, January 1981, p. 12.                        50. Doughs, F, and J. K. Ousterhout, "Transparent Process Migra­
35. Agrawala, A. K., and G. Ricart, "An Optimal Algorithm for              tion: Design Alternatives and the Sprite Implementation," Soft­
    Mutual Exclusion in Computer Networks," Communications of              ware-Practice & Experience,Vo\. 21, No. 8, August 1991, pp. 757-
    the ACM, Vol. 24, No. 1, January 1981, p. 13.                          785.
36. Knapp, E., "Deadlock Detection in Distributed Databases,"          51. Tanenbaum, A. S., and G. J. Sharp, "The Amoeba Distributed
    ACM Computing Surveys, Vol. 19, No. 4, December 1987, p. 309.          System," <wvm.es.vu.nl/pub/amoeba/Intro.pdf>.
37. Chandy, K. M.; J. Misra; and L. M. Haas, "Distributed Deadlock     52. Tanenbaum, A. S.; M. F. Kaashoek; R. van Renesse; and H. E.
    Detection," ACM Transactions on Computer Systems, Vol. 1, No.          Bal, "The Amoeba Distributed Operating System—A Status
    2, May 1983, p. 148.                                                   Report," Computer Communications, Vol. 14, No. 6, July/August
38. Obermarck, R., "Distributed Deadlock Detection Algorithm,"             1991, pp. 324-335, < f t p : / / f t p . c s . v u . n l : / p u b / p a p e r s /
    ACM Transactions on Database Systems, Vol. 7, No. 2, June 1982,        amoeba/comcom91.ps.Z>.
    p. 198.                                                            53. Doughs, E; J. K. Ousterhout; M. F Kaashoek; and A. S. Tanen-
                                                                           baum, "A Comparison of Two Distributed Systems: Amoeba and
39. Rosenkrantz, D. J.; R. E. Sterns; and P. M. Lewis, "System Level
                                                                           Sprite," Computing Systems, Vol. 4, No. 3, December 1991, pp.
    Concurrency Control for Distributed Database Systems," ACM
                                                                           12-14.           <ftp://ftp.cs.vu.nl:/pub/papers/amoeba/
    Transactions on Database Systems, Vol. 3, No. 2, June 1978.
                                                                           c s 9 1 . p s .Z > .
40. Rosenkrantz, D. J.; R. E. Sterns; and P. M. Lewis, "System Level
    Concurrency Control for Distributed Database Systems," ACM         54. Doughs, E; J. K. Ousterhout; M. F Kaashoek; and A. S. Tanen­
                                                                           baum, "A Comparison of Two Distributed Systems: Amoeba and
    Transactions on Database Systems, Vol. 3, No. 2, June 1978, pp.
                                                                           Sprite," Computing Systems, Vol. 4, No. 3, December 1991, pp.
    186-187,192.
                                                                           12-14,           <ftp://ftp.cs.vu.nl:/pub/papers/amoeba/
41. Rosenkrantz, D J.; R. E. Sterns; and P. M. Lewis, "System Level        c s 9 1 . p s .Z > .
    Concurrency Control for Distributed Database Systems," ACM
    Transactions on Database Systems, Vol. 3, No. 2, June 1978, pp.    55. "The Common Object Request Broker: Architecture and Specifi­
    186-197,191-192.                                                       cation," OMG Document Number 93.12.43, December 1993.
42. Rosenkrantz, D. I; R. E. Sterns; and P. M. Lewis, "System Level    56. Agrawala, A. K., and G. Ricart, "An Optimal Algorithm for
    Concurrency Control for Distributed Database Systems," ACM             Mutual Exclusion in Computer Networks," Communications of
    Transactions on Database Systems, Vol. 3, No. 2, June 1978, pp.        theACM,Vol. 24, No. 1, January 1981.
    192-193.                                                           57. Rosenkrantz, D. J.; R. E. Sterns; and P. M. Lewis, "System Level
                                                                           Concurrency Control for Distributed Database Systems," ACM
43. Makki, K., "Detection and Resolution of Deadlocks in Distrib­
                                                                           Transactions on Database Systems, Vol. 3, No. 2, June 1978.
    uted Database Systems," CIKM '95, Baltimore, MD, 1995, p. 412.
44. Knapp, E., "Deadlock Detection in Distributed Databases,"          58. Johnston, B.; R Javagal; A. Datta; and S. Ghosh, "A Distributed
    ACM Computing Surveys,Vol. 19, No. 4, December 1987, p. 308.           Algorithm for Resource Deadlock Detection," Proceedings of
                                                                           the Tenth Annual Phoenix Conference on Computers and Com­
45. Makki, K., "Detection and Resolution of Deadlocks in Distrib­          munication March, 1991, pp. 253-255.
    uted Database Systems," CIKM '95, Baltimore, MD, 1995, p. 412.
                                                                       59. Obermarck, R., "Distributed Deadlock Detection Algorithm."
46. Makki, K., "Detection and Resolution of Deadlocks in Distrib­
                                                                           ACM Transactions on Database Systems, Vol. 7, No. 2, June 1982,
    uted Database Systems," CIKM '95, Baltimore, MD, 1995,pp.
                                                                           p. 198.
    412.

<!-- pág. 867 -->

The humblest is the peer of the most powerful.
      —John Marshall Harlan


O! call back yesterday, bid time reeturn.
      William Shakespeare—

