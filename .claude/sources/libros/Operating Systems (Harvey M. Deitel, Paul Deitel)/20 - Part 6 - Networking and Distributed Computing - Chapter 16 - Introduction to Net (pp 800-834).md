# Part 6 - Networking and Distributed Computing / Chapter 16 - Introduction to Networking

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 800–834 (numeración del PDF)

<!-- pág. 800 -->

  Networking and
Distributed Computing
     Whatever shall we do in that remote spot?
           —Napoleon Bonaparte —




   Part 6

<!-- pág. 801 -->

With the popularization of the Web in 1993, Internet
usage literally exploded. Now there is a huge focus
on building distributed, Internet-based applica-
tions; this is profoundly affecting operating sys-
tems design. Chapter 16 introduces computer
networking and discusses network topologies and
types, and the client/server networking model. We
carefully explain the four layers of the Internet's
TCP/IP protocol stack. Chapter 17 introduces dis-
tributed systems and discusses attributes, commu-
nication, synchronization, mutual exclusion and
deadlock. The chapter also presents case studies of
the Sprite and Amoeba distributed operating sys-
tems. Chapter 18 discusses distributed file systems,
clustering, peer-to-peer distributed computing, grid
computing, Java distributed computing technolo-
gies and the emerging technology of Web services.




           The humblest is the peer of the most powerful.
                  —John Marshall Harlan—

<!-- pág. 802 -->

Live in fragments no longer. Only connect.
       —Edward Morgan Forster—


What networks of railroads, highways and canals were in another age, the networks of
telecommunications, information and computerization...are today.
       —Bruno Kreisky—

It took five months to get word back to Queen Isabella about the voyage of Colombus
two weeks for Europe to hear about Lincoln's assassination, and only 1.2 seconds to get
the words from Neil Armstrong that man can walk on the moon.
      —Isaac Asimov—

<!-- pág. 803 -->

Chapter 16


Introduction to Networking
 Objectives
 After reading this chapter, you should understand:
 • the central role of networking in today's computer systems.
 • various network types and topologies.
 • the TCP/IP protocol stack.
 • the capabilities of TCP/IP's application, transport, network and link layers.
 • protocols such as HTTP, FTP, TCP, UDP, XCP, IP and IPv6.
 • network hardware and hardware protocols such as Ethernet and Wireless
  802.11.
 • the client/server networking model.

<!-- pág. 804 -->

                            Chapter Outline
                     16.1                                16.6.1 Transmission Control Protocol
               Introduction                                             (TCP)
                                                        1 6 . 6 . 2 User Datagram Protocol (UDP)
                  16.2
           Network Topology
       Mini Case Study: Symbian OS                                     16.7
                                                                   Network Layer
                   16.3                                      16.7.1    Internet Protocol (IP)
              Network   Types                          1 6 . 7 . 2 Internet Protocol version 6 (IPv6)

                    16.4
          TCP/IP Protocol Stack                                           16.8
                                                                     Link Layer
                    16.5                                           16.8.1 Ethernet
            Application Layer                                    16.8.2 Token Ring
       16.5.1 Hypertext Transfer Protocol
                     (HTTP)                             16.8.3 Fiber Distributed Data Interface
      16.5.2 File Transfer Protocol (FTP)                              (FDDI)
                                                            16.8.4 IEEE 802.11 (Wireless)
                   16.6
             Transport  Layer
  Anecdote: Unreliable Communication Lines                                16.9
         Can Lead to Embarrassment                             Client/Server Model




       Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited



750

<!-- pág. 805 -->

                                                                                            16.1 Introduction 751

 16.1 Introduction
 Networks have become almost as important as the computers they connect,
  enabling users to access resources that are available on remote computers and com-
  municate with other users around the world. Talking on the telephone, watching
cable television, using a cellular phone, making a credit card purchase, withdrawing
 money from an ATM, browsing the Web and sending e-mail are all activities that
rely on networked computers. As users, we have come to expect that network com-
 munication will occur quickly and without error.
       This chapter discusses common network layouts, focusing on how hosts—enti-
ties that receive and provide services over a network—are connected by links—
 media over which network services are transmitted. If a link breaks, a host fails or a
 message is lost, network communication can be interrupted. We introduce the TCP/
IP protocol stack, which provides well-defined interfaces to enable communication
between computers across a network and to allow problems to be fixed as they
arise. The TCP/IP protocol stack splits networked communication into four logical
 levels called layers. Each layer provides functionality for the layers above it to ease
 the development, management and debugging of networks and simplify the pro-
gramming of applications that rely on those networks. A layer is implemented by
  following certain protocols—sets of rules that govern how two entities should inter-
act. In our discussion of each layer, we consider popular Internet protocols that
allow users worldwide to communicate. We conclude by discussing the popular cli-
ent/server model of network communication.
       The concepts presented in this chapter will help you understand the chapters
 on distributed systems (Chapter 17 and Chapter 18), security (Chapter 19) and the
case studies on Linux (Chapter 20) and Windows XP (Chapter 21).

Self Review
1. Why does the TCP/IP protocol stack separate network communication into four layers?
2. What problems can arise during network communication?
Ans: 1) Separating network communication into four layers modularizes the communica-
tion. Developers can focus on one layer at a time. This eases development, management and
debugging of networks and networked applications. 2) Hosts can fail, links can break and
messages can be lost.


16.2 Network Topology
Network topology describes the relationship among the hosts, also called nodes, on
a network. A logical topology displays which nodes in a network are directly con-
nected (i.e., which nodes can communicate with each other without relying on any
 intermediate nodes). 1 Common network topologies (Fig. 16.1) include bus, ring,
star, tree, mesh and fully-connected mesh networks.
       Nodes on a bus (or linear) network (Fig. 16.1, part a) are all connected to a
  single, common communication link (called a bus). Bus networks are simple

<!-- pág. 806 -->

752   Introduction to Networking




                              Figure 16.1 | Network    topologies.

                              because they do not require intermediate nodes to forward messages to other nodes.
                              As messages travel along a link, resistance in the medium causes the signal to lose
                              strength—this is known as attenuation. Since bus networks do not have intermediate
                              nodes that retransmit messages, the length of the bus communication medium must
                              be limited to minimize attenuation. If any individual node in a bus network fails, the
                              entire network will continue functioning. If the bus itself fails, the entire network will
                              fail. Bus networks are appropriate for homes and small offices. '
                                     Ring networks (Fig. 16.1, part b) consist of a set of nodes, each of which main-
                              tains exactly two connections to other nodes such that a message sent through one
                              connection can eventually return via the other. Ring networks can grow to be larger
                              than bus networks, because each node in the ring forwards each message; this limits
                              message attenuation but introduces a retransmission delay (i.e., the time required
                              for a node to process a message before retransmitting it). One of the most signifi-
                              cant limitations of a ring network is that if one node in a ring fails, then communica-

<!-- pág. 807 -->

                                                                                               16.2   Network   Topology   753

    tion in the entire ring will fail. This means that a ring network has limited fault
   tolerance, since the network cannot recover from a single node failure.
        Star networks (Fig. 16.1, part e) contain a single central node, or hub, that is
   connected to all of the other nodes in the network and is responsible for relaying
 messages between nodes. All transmissions in a star network pass through the hub.
 Since communications over star networks go through a single intermediate node,
  attenuation will limit the geographical size of the network, but transmission delay is
  smaller than in ring networks. The network can survive the failure of one of the
 outer nodes, but the entire network will fail if the central hub fails. Since the central
 hub controls all communication, a bottleneck will occur if the network demand
 exceeds the processing capabilities of the hub. '
        Tree networks (Fig. 16.1, part f) are hierarchical networks that consist of a
  root node and several subnodes, called children, that can have subnodes of their
 own. A tree network can be viewed as multiple star networks. The hub of the first
star network is the root of the tree. Each child node in this star serves as a hub for
 another star network. Hubs are responsible for relaying information to the nodes in
their immediate networks. A tree topology is often used to join nodes that commu-
nicate with each other frequently, thereby increasing network efficiency.6, 7
        In mesh networks (Fig. 16.1, part c), at least two nodes have more than one
path connecting them. A mesh network in which each node is directly connected to
every other node is a fully-connected mesh network (Fig. 16.1, part d). Mesh net-
works and fully connected networks are the most fault-tolerant topologies, because
typically there are multiple paths between each pair of nodes. The primary disad-
vantage of mesh networks is the complexity associated with directing messages
between nodes that have no direct connection. With fully-connected networks, this
 is simple since each pair of nodes has a direct link between them. The problem with
fully-connected networks is that as the number of nodes increase, the number of
links to connect those nodes increases exponentially. 8 ' 9
       The proliferation of wireless network technology has introduced ad hoc net-
works (see the Mini Case Study, Symbian OS). An ad hoc network is spontaneous—
any number of devices may be connected to it at any time. These devices become
part of, and leave, the network at random. Ad hoc networks consist of any combina-
tion of wireless and wired devices. The network topology can change rapidly, which
makes it difficult for the network to be governed by a central node. The variable
nature of ad hoc networks makes determining their topology a challenging problem
in current research. 10


Self Review
1. Why would a network for a mission-critical system (e.g., a nuclear power plant or an air
   traffic control system) not be built with a ring topology?
2. Why do wireless devices require a spontaneous network?
Ans: 1) A mission-critical system would not use a ring topology because of the lack of fault
 tolerance. If a single node failed, the entire network would fail. Mission-critical systems

<!-- pág. 808 -->

754 Introduction to Networking

                                  require networks with multiple levels of redundancy to ensure continuous operation. 2) The
                                  nature of wireless devices is that as they move from place to place; they join and exit multiple
                                  networks. Ad hoc networks do not require a fixed network topology.


                                  16.3 Network Types
                                  The two most prevalent types of networks are local area networks (LANs) and
                                  wide area networks (WANs). A LAN is a network with limited geographic range
                                  designed to optimize data transfer rates between its nodes. Local area networks
                                  interconnect resources using high-speed communication paths with network proto-
                                  cols optimized for local area environments such as office buildings or college cam-
                                  puses. LANs benefit by independence from the larger networks. Those that are
                                  company or university owned can be upgraded or reorganized at the company or
                                  university's discretion. LANs are also free from the congestion that can arise in




                 Mini Case Study
    Symbian OS
    Symbian (www.symbian.com),                     Symbian focuses on size and                  Symbian's latest release,
    maker of the Symbian operating           time efficiency. 16 - 17 The Symbian        v7.0s, is intended for third-gener-
    system, was founded in 1998 by           OS complies w i t h open standards          ation (3G) mobile phones and
    mobile phone manufacturers Eric-         such as the POSIX API 18 —the               comes equipped w i t h new func-
    sson, Nokia, Motorola and Psion          IEEE's Portable Operating System            tionality to meet the needs of
    to develop a cross-platform              Interface standard—as well as               these high-performance wireless
    mobile phone operating system            APIs for high-performance graph-            devices. Some of the new features
    to replace their individual, incom-      ics and multimedia, mobile brows-           of OS v7.0s include a multi-
    patible OSs.11, 12 The result is         ing and messaging,,                         threaded framework for multime-
    S y m b i a n OS, a small operating      communications and mobile tele-             dia, Java Wireless Messaging 1.0
    system that runs on "smart               phony, security and data manage-            and Bluetooth 1.1 capability. 23 OS
    phones" 1 3 —mobile phones w i t h       ment, to make it easier for                 v7.0s also supports W-CDMA
    the functionality of a PDA (Per-         application developers to write             (wideband code-division multiple
    sonal Digital Assistant). Symbian        compatible software. 1 9 , 2 0 Also,        access), which enables 3G mobile
    OS is unique in that it was built        since Java is becoming standard             phones to transfer data at much
    for mobile phones, 1 4 , 1 5 while its   on mobile phones and has a large            higher rates, up to 2Mbps. 24
    major competitors such as Win-           application developer base, an              These new features are built upon
    dows CE, Linux and PalmOS were           implementation of t h e Java                t h e extensive collection of APIs
    all originally designed for differ-      mobile run-time environment                 common in all recent Symbian OS
    ent systems, then adapted to             (MIDP) is included. 21 - 22                 releases.
    mobile phones.

<!-- pág. 809 -->

                                                                                        16.4 TCP/IP Protocol Stack 755

   lager networks that must serve millions of users. Since LANs are autonomous, they
  can be customized to meet the needs of a particular group and can employ any of
  the network topologies discussed in Section 16.2.25
      WANs are broader, consisting of many LANs and connecting many computers
 over great distances; the largest WAN by far is the Internet. WANs generally employ
 a mesh topology, operate at lower speeds than LANs and have higher error rates
 because they must interact with multiple, often heterogeneous LANs and WANs.

Self Review
 1. What is the purpose of creating smaller subnetworks within a larger network, such as a
   LAN that comprises a piece of a WAN?
2. What are the disadvantages of WANs compared to LANs?
Ans: 1) A subnetwork, such as a LAN on a college campus, allows for a group of related
 computers to be directly connected for faster transmission, higher capacity, greater manage-
ment flexibility and customization. 2) WANs often operate at lower speeds and have higher
error rates than LANs because they must interact with multiple, often heterogeneous LANs
and WANs.


16.4 TCP/IP Protocol Stack
 The four layers of networked communication as defined by the TCP/IP protocol
stack are the application, transport, network and link layers. The application layer is
 the highest level and provides protocols (e.g., HTTP, FTP) for applications, such as
Web browsers and Web servers, to communicate with each other. The transport
layer is responsible for end-to-end communication of information from the sending
process to the receiving process. The network layer is responsible for moving the
data from one computer to the next (also known as routing). The transport layer
relies on the network layer to determine the proper path from one end of the com-
munication to the other. The link layer translates information between bits and a
physical signal that travels through the physical link (e.g., a network cable). 27
       As a message travels down the stack, each layer receives the message and
adds control information to the beginning of the message (called a header) or to
the end of the message (called a trailer) to enable communication with the corre-
sponding layer on other hosts. The control information might include, for example,
the addresses of the source and destination hosts, or the type or size of data that is
being sent. This new message then is passed to the layer below it (or to the physical
medium if the message is coming from the link layer). When receiving information
over a network, each layer receives data from the layer below it (or from the phys-
 ical medium in the case of the link layer). The layer strips off the control informa-
tion from the corresponding layer on the remote host. This data is often used to
ensure that the message is valid and directed to the current host. The message then
 is passed to the layer above it (or to the process if the message is being passed
  upward by the application layer). We discuss these layers in detail in the sections
  that follow.

<!-- pág. 810 -->

756   Introduction to Networking

                                      In 1984, the International Organization for Standardization (ISO) introduced
                               the Open Systems Interconnection (OSI) Reference Model to establish an interna-
                               tional standard for communication between applications over a network. Although
                               not followed strictly on the Internet, it remains an important model to understand.
                               The OSI protocol stack consists of the four layers we discussed previously plus
                               three additional ones. The seven layers of the OSI model are application, presenta-
                               tion, session, transport, network, data link and physical.
                                     The application, presentation and session layers in OSI correspond to the
                               application layer in the TCP/IP protocol stack. In the OSI model, the application
                               layer interacts with the applications and provides network services, such as file
                               transfer and e-mail. The presentation layer solves certain compatibility problems,
                               such as when the two end users use different data formats, by translating the appli-
                               cation data into a standard format that can be understood by other layers. The ses-
                               sion layer establishes, manages and terminates the communication between two
                               end users. The transport and network layers correspond with the transport and net-
                               work layers of the TCP/IP protocol stack, respectively. The data link layer and phys-
                               ical layer in OSI correspond to the link layer in the TCP/IP protocol stack. At the
                               sender, the data link layer converts the data representation it receives from the net-
                               work layer into bits and at the destination, it converts bits received into the data
                               representation for the network layer. The physical layer transmits bits over the
                               physical medium, such as cables.28, 29, 30, 31

                              Self Review
                               1. What type of information is placed in the header or trailer of a message?
                               2. Briefly list the capabilities of each of the four layers of the TCP/IP protocol stack.
                              Ans: 1) Control information is placed in the header or trailer of a message to govern the
                              communication between the two hosts; this information can include the addresses of the two
                              hosts, or the type or size of the data. 2) The application layer allows applications on remote
                              hosts to communicate with one another. The transport layer is responsible for end-to-end
                              communication between two hosts. The network layer is responsible for sending a packet to
                              the next host toward the destination. The link layer serves as an interface between the net-
                              work layer and the physical medium through which the information travels.




                               16.5 Application Layer
                               The application layer provides a well-defined interface for applications on different
                               computers to communicate with one another; for example opening a remote file
                               requesting a Web page, transferring an e-mail or calling a remote procedure. Appli-
                               cation layer protocols simplify communication between processes on a network and
                               determine how processes should interact.32 Common protocols of the application
                               layer include Hypertext Transfer Protocol (HTTP), File Transfer Protocol (FTP),
                               Simple Mail Transfer Protocol (SMTP), Domain Name System (DNS) and Secure
                               Socket Shell (SSH).

<!-- pág. 811 -->

                                                                                           16.5 Application Layer   757

       Many application layer protocols interact with resources on remote hosts.
 These resources are specified by a Uniform Resource Identifier (URI), which is a
  name that references a specific resource on a remote host. The more common term
   Uniform Resource Locator (URL) describes URIs that access resources in com-
 mon protocols such as HTTP or FTP.33 Most URLs contain the protocol, host, port
  and path of the resource. The protocol is the application layer protocol that is being
used to communicate (e.g., HTTP or FTP). The host is the fully qualified name of
the host computer. We discuss computer naming conventions in Section 16.7.1,
 Internet Protocol (IP). The port determines the socket to which a message should
be passed—a socket is a software construct that represents one endpoint of a con-
  nection. Processes use sockets to send and receive messages over a network. The
path is the location of the resource on that host.
       Consider the URL            http://www.deitel.com/index.html.    The first part,
h t t p : / / , denotes that this URL is for HTTP. The second part, www.deitel.com, is
 the host name. Specifically, it accesses the company Web site for Deitel & Associ-
ates. The third part of the URL, the port, is omitted. Certain ports have been
 assigned by the Internet Assigned Numbers Authority as "well-known" ports; these
ports are used by common application layer protocols. For example, HTTP com-
monly uses port 80, whereas FTP commonly uses ports 20 and 21. 34 By omitting the
port, this URL connects to port 80, the default port for HTTP. The final part of the
URL, index.html, specifies the path and name of the resource.

Self Review
1. Name some common protocols of the application layer.
2. Why is the port an important part of a URL?
Ans: 1) FTP, SMTP, DNS, SSH and HTTP. 2) The port identifies the socket on the computer
to which the message should be passed.




16.5.1 Hypertext Transfer Protocol (HTTP)
The Hypertext Transfer Protocol (HTTP) is a versatile application layer protocol,
While HTTP is commonly used to transmit HTML documents over the Internet, it
allows the transfer of data in several formats using Multipurpose Internet Mail
Extensions (MIME). MIME defines five content types: text, image, audio, video and
application. The first four types are often used in multimedia Web pages; application
 is generally reserved for transferring binary files.
      HTTP consists of requests for resources and responses from remote hosts. An
HTTP request involves an action and a resource's URI. The action specifies the
operation to be performed on the resource. The remote host processes the request
and replies with an HTTP response, which contains in its header a code that tells
the client whether the request was processed correctly or an error occurred. If the
request was processed correctly, the requested resource is returned along with the

<!-- pág. 812 -->

758 Introduction to Networking
                            header. The header also specifies the MIME type of the resource to notify the
                            requesting application about the type of content it is receiving.35, 36, 37

                            Self Review
                            1. What would happen if a client sent an HTTP request for a resource that did not exist?
                            2. What is the purpose of MIME types?
                            Ans: 1) The server would reply with an HTTP response that included an error code in the
                            header. 2) The MIME type provides the client with knowledge about the type of data being
                            transmitted. This aids the client in determining how to process the data.


                            16.5.2 File Transfer Protocol (FTP)
                            File Transfer Protocol (FTP) is an application layer protocol that allows the trans-
                            fer of files between remote hosts. FTP specifies connections between two ports: one
                            port (typically port 21) sends control information that governs the session; the
                            other port (typically port 20) sends the actual data. After a connection is estab-
                            lished, the client specifies actions for the FTP server to perform by issuing various
                            commands to the server (Fig. 16.2). The server attempts to satisfy each command,
                            then issues a response with the result.38

                            Sefffovtetf
                            1. What ports do FTP hosts usually use to communicate?
                            2. What is the purpose of FTP?
                            Ans: 1) FTP uses two ports to communicate, typically ports 20 and 21. 2) FTP allows the
                            transfer of files between hosts.



                            16.6 Transport Layer
                            The transport layer is responsible for the end-to-end communication of data
                            between hosts. It receives data from the application layer, breaks it into smaller

                             Name         Function
                                 CDUP     Change from the current directory to the parent of the current directory
                                 CWD      Change the working directory.
                                 PWD      Print the path of the working directory.
                                 LIST     List the contents of the working directory.
                                 DELE     Delete the specified file.
                                 RETR     Retrieve the specified file.
                                 STOR     Upload the specified file.
                                 QUIT     Terminate the FTP session.

                            Figure 16.2 | FTP commands.

<!-- pág. 813 -->

                                                                                          16.6 Transport Layer 759
  pieces suitable for transport, appends control information to these pieces and sends
  them to the network layer.
       There are two primary approaches to implementing the transport layer: coll-
  -ection oriented and connectionless. Connection-oriented services are modeled
  after the telephone system, in which a connection is established and held for the
 length of the session. Connectionless services are modeled after the postal service,
 in which two letters mailed from one place to the same destination may actually
  take two dramatically different paths through the system and even arrive at differ-
ent times or not at all.
       In a connection-oriented approach, hosts send each other control informa-
 tion — through a technique called handshaking—to initiate an end-to-end connec-
tion. Many networks are unreliable, which means that data sent across them may be
 damaged or lost (see the Anecdote, Unreliable Communication Lines Can Lead to
Embarrassment). These networks do not guarantee anything about the data sent; it
could arrive corrupted or out of order, as duplicates or not at all. These networks




              Anecdote
 Unreliable Communication Lines Can Lead to Embarrassment
 This one happened to one of the         sharing computer at the univer-          She said, "Harvey, I don't think
 authors, HMD. In the early 1980s,       sity where he was a professor at         you want to send this; you'd bet-
 he was offered a consulting             the time. He typed, "Since 1978,         ter take a look at it." HMD came
 opportunity. To formalize the           Harvey M. Deitel has been an             back into the room. Data trans-
 relationship, he had to send the        assistant professor at Boston Uni-       mission over phone lines was a bit
 client a detailed resume along          versity" and started the printout        unreliable at the time. The printer
 with some other materials by            (which was done on an old-style,         failed and stopped typing at a
 overnight package courier. The          30-character-per-second dot              most unfortunate point in the
 package pickup deadline was             matrix printing terminal). He            middle of the sentence (figure it
 approaching. HMD quickly                walked into another room. The            out)! If HMD had sent the pack-
 updated his resume using a termi-       package courier came. He asked           age, he surely would not have
 nal at his home connected by an         his wife to please tear off the          been given the consulting job!
 old-style acoustic coupler to           printout, t h r o w it in the package,   This was a humbling experience!
 phone lines and in t u r n to a time-   seal it and give it to the courier.


 Lesson to operating systems designers: You can't design in a vacuum and simply assume that parts of a sys-
 tem "you're not responsible for" will indeed work perfectly. Every part of a system can fail—the software for
 which operating systems designers and implementors are most directly responsible, the hardware, the com-
 munications lines and even the people who work with the system as users or administrators.

<!-- pág. 814 -->

760   Introduction to Networking

                               make only a "best effort" to deliver data. A connection-oriented approach ensures
                               reliability on unreliable networks. These protocols make communication reliable.
                               guaranteeing that sent data will arrive at the intended receiver undamaged and in
                               the correct sequence. Hosts might also exchange information to regulate the termi-
                               nation of the session so that no processes are left running on either host.
                                     In a connectionless approach, the two hosts do not handshake before trans-
                               mission and reliability is not guaranteed—data sent may never reach the intended
                               recipient. A connectionless approach, however, avoids the overhead associated
                               with handshaking and enforcing reliability; less information often needs to be
                               passed between the hosts.39, 40, 4 1 , 42, 43

                               Self Review
                               1. Why would a bank not implement a connectionless transport layer?
                               2. Most streaming media applications require a connectionless transport layer. What are
                                  some possible reasons for this?
                              Ans: 1) A bank performs business-critical transactions that must be carried out correctly. A
                              connectionless transport layer could lose transactions. 2) Streaming media applications do
                              not require the reliability of a connection-oriented approach, but benefit by the smaller
                              amount of control information that comes with a connectionless approach.


                               16.6.1 Transmission Control Protocol (TCP)
                               The Transmission Control Protocol (TCP) is a connection-oriented transmission
                               protocol that guarantees that data (called segments in TCP) sent from a sender will
                               arrive at the intended receiver undamaged and in the correct sequence. Both HTTP
                               and FTP rely on TCP to guarantee reliable communication. TCP handles error con-
                               trol, congestion control and retransmission, allowing protocols like HTTP and FTP
                               to send information across a network as simply and reliably as writing to a file on a
                               local computer.
                                      To set up a connection, TCP uses a three-way handshake. One of the purposes
                               of this handshaking is to synchronize sequence numbers between the two hosts. The
                               sequence number of each host increases by one with each segment sent and is placed
                               in each segment's header. The destination host uses these sequence numbers to rear-
                               range the segments if they are received out-of-order. First, the source host sends a
                               synchronization segment (SYN) to the destination host. This segment requests that a
                               connection be made and contains the sequence number of the source host. The desti-
                               nation host responds with a synchronization/acknowledgement segment (SYN/ACK)
                               which is an acknowledgement of the connection being established and contains the
                               sequence number for the destination host. Finally, the source host responds with an
                               acknowledgement segment (ACK) which finalizes the connection. 44
                                      When the destination host receives a segment, it responds with an acknowl-
                               edgement (ACK) containing the sequence number of the received segment. If the
                               source host does not receive an ACK for a particular sequence number, it will
                               resend the segment with that sequence number after a certain wait time. This pro-

<!-- pág. 815 -->

                                                                                                16.6 Transport Layer 761

cess guarantees that all segments will eventually be received by the destination
 host, duplicates will be discarded and the segments will be reassembled, if neces-
sary, into the original order.45, 46, 47, 48, 49
       In addition to reliability, TCP offers flow control and congestion control. Flow
control regulates the number of segments sent by each host in an attempt not to
 overwhelm the receiver of those segments. Congestion control restricts the number
of segments sent from a single host in response to overall network congestion. TCP
 implements both flow control and congestion control by maintaining a TCP win-
dow for the sender and receiver. The sender cannot send more segments than spec-
 ified by the window before receiving an ACK from the receiver. The receiver
calculates and sends its window along with each ACK that it sends. There are trade-
offs associated with the size of the window advertised. A large window leads to the
transmission of many segments. If the network or the receiver cannot handle this
volume of segments, some will be discarded leading to retransmission of segments
and inefficiency. Smaller windows can reduce throughput and result in the network
being underutilized.

Self Review
1. TCP guarantees that segments will be delivered to the application in order, but the seg-
   ments may not arrive at the host in order. What additional resource must TCP use?
2. What is the difference between flow control and congestion control?
Ans: 1) TCP must possess a buffer to hold any segments received out of order until the
missing segments are received. 2) Flow control deals with restricting the number of segments
sent by the source host so as to not overwhelm the destination host. Congestion control
restricts the number of segments sent from a single host to help restrict network congestion.



16.6.2 User Datagram Protocol (UDP)
Applications that do not require the reliable end-to-end transmission guaranteed
by TCP may be better served by the connectionless User Datagram Protocol
(UDP). UDP incurs the minimum overhead necessary to implement the transport
layer. There is no guarantee that UDP segments, called datagrams, will reach their
destination or arrive in their original order.
      There are benefits to using UDP over TCP. UDP has little overhead because
UDP headers are small; they do not need to carry the information TCP carries to
ensure reliability. UDP also reduces network traffic relative to TCP due to the
absence of ACKs, handshaking, retransmissions, etc.
      Unreliable communication is acceptable in many situations. First, reliability is
not necessary for some applications, so the overhead imposed by a protocol that guar-
antees reliability can be avoided. Second, some applications, such as streaming audio
and video, can tolerate occasional datagram loss. This usually results in a small pause
(or "hiccup") in the audio or video being played. If the same application were run
over TCP, a lost segment could cause a significant pause, since the protocol would
wait until the lost segment was retransmitted and delivered correctly before continu-

<!-- pág. 816 -->

762 Introduction to Networking

                            ing. Finally, applications that need to implement their own reliability mechanisms dif-
                            ferent from that provided by TCP can build such mechanisms over UDP.50, 51, 52

                            Self Review
                            1. If a UDP datagram is lost due to network traffic, how does the host that sent the datagram
                               respond?
                            2. Why would an application choose to use UDP as its transport layer protocol?
                            Ans: 1) The host does nothing. UDP includes no means by which the sending host could
                            learn that a datagram was lost. The host does not retransmit. 2) An application would use
                            UDP if reliability were not necessary (e.g., as in streaming audio and video applications) or if
                            the application needed to implement its own reliability mechanisms.


                            16.7 Network Layer
                            The network layer receives data from the transport layer and is responsible for
                            sending the data (called datagrams) to the next stop toward the destination through
                            a process known as routing. Routing is the two-step process of determining the next
                            host for a datagram toward the destination and sending the datagram along this
                            path. Routers are computers that connect networks. Note that a router determines
                            the next host for a given source and destination given its particular picture of the
                            network at the time. Networks can change quickly and routers cannot determine
                            these changes instantaneously, so a router's knowledge of the network is not always
                            complete and up-to-date.
                                   Routers determine the next host for a given datagram based on information
                            such as network topologies and link quality, which includes strength of signal, error
                            rate and interference. This information is propagated throughout networks using
                            various routing protocols, one of the better known being the Routing Information
                            Protocol (RIP)—an application layer protocol operating over UDP. RIP requires
                            each router in a network to transmit its entire routing table (a hierarchical matrix
                            listing the current network topology) to its closest neighboring routers. The process
                            is continued until all routers are aware of the current topology. As networks grow in
                            size, each router needs to keep track of the entire network topology This generates
                            excessive network traffic in large networks, which is why RIP is used almost exclu-
                            sively on smaller networks.
                                   Routers keep queues to manage datagrams, because it takes time for the
                            router to determine the best route and send the datagram. When a datagram arrives
                            from a network, it is placed into a queue until it can be serviced. Once the queue is
                            full, additional datagrams are simply dropped from the network. It is therefore
                            important to make sure senders do not overwhelm routers. Transport layer proto-
                            cols must try not to overrun the queues.
                                   Unlike the transport layer, which is concerned with sending data from the
                            originating host to the destination host, the network layer at a particular host sends
                            datagrams only to the next host toward the destination host. This process continues
                            until the datagram reaches its destination host.

<!-- pág. 817 -->

                                                                                                   16.7 Network Layer 763

Self Review
 1. What is the major drawback to the Routing Information Protocol that causes it to be
   reserved for smaller networks?
2. What happens when network congestion causes a router's queue to fill up with unserviced
   datagrams?
Ans: 1) Each router in a network is required to transmit its entire routing table to its closest
 neighbor, regardless of whether or not changes have occurred. In large networks, these rout-
ing tables are larger, which causes increased network traffic. 2) When a router's queue is full,
datagrams that arrive subsequently are discarded. Hosts using TCP will consider this an
example of network congestion and slow down transmission.


16.7.1 Internet Protocol (IP)
 The Internet Protocol (IP) is the dominant network layer protocol for transmitting
 information over a network. IP allows smaller networks. (LANs and small WANs) to
be combined into larger networks (WANs, such as the Internet). IP version 4 (IPv4) is
the version currently used by most networks. Destinations on the Internet are speci-
fied by IP addresses, which are 32-bit numbers in IPv4. Thus, there are 2 32 , or approx-
 imately 4 billion, unique IP addresses. IP addresses are generally divided into four
octets (8-bit bytes). An 8-bit byte can represent a decimal number from 0 to 256.
      One or more host names are mapped to an IP address through the Domain
Name System (DNS). When a person enters a host name into a browser, it uses
DNS to find the correct IP address for that host name. In this way, an easily remem-
bered name is established as an alias for the IP address. This IP address is then used
by the transport and network layers to deliver the data.53, 54, 55

Self Review
1. How many possible IPv4 addresses are there?
2. How does a Web browser convert a host name into an IP address?
Ans: 1) There are 232, or approximately 4 billion, unique IP addresses. 2) The Web server
uses the Domain Name System (DNS) to convert a host name into an IP address.

16.7.2 Internet Protocol version 6 (IPv6)
Every device that accesses the Internet must be assigned an IP address. As the num-
ber of devices (e.g., PDAs and cellular phones) with network access increases, the
pool of available IP addresses shrinks. In the near future, the number of remaining
32-bit IP addresses will run out. To combat this problem, the Internet Engineering
Task Force has introduced Internet Protocol version 6 (IPv6). IPv5 was proposed in
1990, nine years after IPv4, but it was never implemented. IPv6 eliminates many
limitations of IPv4. IPv6 addresses are 128 bits long, yielding 2 1 2 8 (approximately
3.4 x 1038) possible addressable nodes.
      IPv6 specifies three types of addresses: unicast, anycast and multicast. A uni-
cast address allows users to send a datagram to a single host. Anycast addresses
 allow users to send a datagram to any one of a group of hosts. For example, a series

<!-- pág. 818 -->

764 Introduction to Networking

                             of routers that provide access to a LAN could be assigned anycast addresses.
                             Incoming datagrams would be delivered to the nearest router with that address.
                             Multicast addresses allow users to send datagrams to all hosts in a group.
                                    IPv6's headers are simpler than those of IPv4, because several of the header
                             fields have been eliminated or offered as options in IPv6. This increases the speed
                             with which datagrams are processed. Fewer restrictions are imposed on the header
                             format to increase extensibility; IPv6 provides mechanisms for including additional
                             headers between the required header and the message.
                                   The transition to IPv6 is proving to be gradual. To aid with this transition,
                             some routers have been modified to interpret both IPv6 and IPv4 datagrams. For
                             routers that cannot handle IPv6 addresses, IPv6-enabled routers can implement a
                             technique called tunneling, which places IPv6 datagrams inside IPv4 datagrams.
                             When other IPv6-enabled routers eventually receive the datagram, they can strip
                             the IPv4 control information and continue as usual. This method is attractive
                             because it allows routing to continue without interruption. However, it adds pro-
                             cessing overhead at routers. 58, 59

                            Self Review
                             1. How many possible IPv6 addresses are there?
                             2. What is the difference between anycast and multicast addresses?
                            Ans: 1) There are 2128, or approximately 3.4 x 1038, unique IPv6 addresses. 2) An anycast
                            address allows a user to send a datagram to any one of a group of hosts. A multicast address
                            allows a user to send a datagram to all hosts within a group.


                             16.8 Link Layer
                            The link layer interfaces with the transmission medium (often copper wiring or
                            optical fiber). It is responsible for transforming a datagram (called a frame in the
                            link layer) into a representation (such as electrical or optical) that is suitable for the
                            specific transmission medium and for sending this representation into the medium.
                            The link layer is also responsible for transforming that representation at the receiv-
                            ing computer back into bit streams that can be interpreted by the upper three layers
                            of the TCP/IP stack. Because transmission media are physical entities, they are sus-
                            ceptible to interference which can cause errors. The link layer attempts to detect
                            and, if possible, correct such errors.
                                  Many implementations of the link layer use a checksum to determine if a
                            frame was corrupted. A checksum is the result of a calculation on the bits in the
                            frame. If the checksum calculated by the sender and inserted into the frame
                            matches the checksum calculated by the receiver, it is likely that the frame was not
                            corrupted during transmission. Some systems employ error-correcting codes that
                            enable a receiver to both detect and correct corrupted frames. An example is a
                            Hamming Code, which uses redundant bits to determine which bits in the transmis-
                            sion were corrupted and to correct the frames. If errors cannot be corrected, the
                            sender must resend the original frame.

<!-- pág. 819 -->

                                                                                                  16.8 Link Layer 765

Self Review
1. What is the benefit of using an error-correcting code such as the Hamming Code?
2. What factors contribute to the overhead of using an error-correcting code such as the
   Hamming Code?
Ans: 1) Error-correcting codes can be used to correct errors that occurred during transmis-
sion. This removes the need to retransmit corrupted frames. 2) The complication with error-
correcting codes is that they require additional bits to be sent with each frame. This can slow
network transmission. These bits must be calculated at the sender and recalculated and
checked at the receiver.


16.8.1 Ethernet
Ethernet is a type of LAN first developed at the Xerox Palo Alto Research Center
in 1976 and later denned by the IEEE 802.3 standard. Ethernet uses the Carrier
Sense Multiple Access with Collision Detection (CSMA/CD) protocol. In 802.3-
style CSMA/CD (i.e., CSMA/CD that conforms to the IEEE 802.3 standard),
 "intelligent" nodes are attached to the medium by hardware devices called trans-
ceivers. The nodes are deemed "intelligent" because a transceiver tests a shared
medium to determine if it is available before transmitting data. When the station
connected to the transceiver wishes to transmit, the transceiver sends data into the
shared medium, while monitoring that medium to detect a simultaneous transmis-
sion called a collision. Due to delays in the medium, it is possible that multiple
transceivers may decide that the medium is clear and begin transmitting simulta-
neously. When two frames collide, the data is corrupted.
       If transceivers detect a collision, they continue to transmit bytes for a specific
period of time to ensure that all transceivers become aware of the collision. Each
transceiver, after learning of a collision, waits a random interval before attempting
to transmit again. This interval is calculated to maximize throughput while minimiz-
ing new collisions—one of the most challenging issues in designing CSMA/CD tech-
nology. Ethernet employs a method called exponential backoff. The transceiver
tracks how many times there has been a collision in trying to transmit a certain
frame and uses it to calculate the delay before attempting to retransmit. This is
called the random delay. Each time there is a collision, the length of the delay dou-
bles—rapidly reducing the probability that the offending transceivers will retrans-
mit at the same time. Eventually the frame is sent without collision.
       While this method may seem inefficient, it actually works quite well in prac-
tice. If the delay were not random, then more collisions would be likely, resulting in
greater loss of time. Due to the high transmission speeds and relatively small
frames, multiple successive collisions after random retransmissions are usually rare
and indicate a network configuration error or a hardware error. '

Self Review
1. What are the possible consequences if a transceiver does not continue to transmit bytes
   upon detection of a collision?

<!-- pág. 820 -->

766 Introduction to Networking

                             2. Why are collisions possible in Ethernet transmissions?
                            Ans: 1) Other transceivers may not recognize that a collision has occurred. This can cause a
                            transceiver to think a frame has been transferred correctly when it has in fact been corrupted.
                            2) Transmission is not instantaneous, so two hosts can decide that the medium is free at the
                            same time and start transmitting.


                             16.8.2 Token Ring
                             The Token Ring protocol operates on ring networks and employs tokens to gain
                             access to the transmission medium. In a Token Ring, the token is actually an empty
                             frame that circulates continuously between machines over a network having a logi-
                             cal ring topology (Fig. 16.3). When a node wishes to send a message, it must first
                             wait for the empty frame to arrive. When the node receives the empty frame, it
                             changes one bit in the header to indicate that the frame is no longer empty and
                             writes its message and the address of the intended recipient to the frame. The node
                             then sends the frame to its neighbor. Each node compares its own address to the
                             address in the frame; if the addresses do not match, the node sends the frame on to
                             the next node.
                                   If the address does match, the machine copies the content of the message,
                             changes the bit in the frame's header and passes the frame to the next node on the
                             ring. When the original sender receives the frame (i.e., the frame has completed one
                             cycle of the ring), it can determine if the message was received. At this point, the
                             sender removes the message from the frame and passes the now-empty frame to its
                             neighbor. The Token Ring protocol also contains complex mechanisms to protect
                             the network from losing the token—if a station failed while holding the token, the
                             token might never be released, thus deadlocking the network.
                                   When the token is being passed without incident, the time to transmit a mes-
                             sage is quite predictable, as is the time to recover from various errors. Token Rings
                             are the most common network architecture after Ethernet.64

                             Self Review
                             1. What would happen if a station failed while it owned the token and there was no mecha-
                                nism to recover?
                             2. Describe what happens when a host wants to send information using a Token Ring.
                            Ans: 1) The token would never be released and all of the hosts would become deadlocked.
                            2) The host must first wait until it receives the empty frame (the token). When the host
                            receives the empty frame, it places its message in it. The frame is sent around the Token Ring
                            until it reaches the destination host, which reads the message and indicates that the message
                            has been read. The frame continues around the Token Ring until it reaches the first host,
                            which then releases the token.

                             16.8.3 Fiber Distributed Data Interface (FDDI)
                             Fiber Distributed Data Interface (FDDI) shares many properties of the Token
                             Ring protocol, but operates over fiber-optic cable, allowing it to support more
                             transfers at greater speeds over larger distances. FDDI is built on two Token Rings,

<!-- pág. 821 -->

                                                                                          16.8 Link Layer 767




Figure 16.3 | Sending a message via the Token Ring protocol.

the second usually being reserved for backup. In FDDI, a token circulates around
the optical fiber ring; stations cannot transmit until they obtain the token by receiv-
ing it from a preceding station. While the station is transmitting, no token is circu-
lating, thus forcing all other stations to wait before they are allowed to transmit.
When it has completed transmission, the transmitting station generates a new
token, and other stations may attempt to capture it so they may transmit in turn. If

<!-- pág. 822 -->

768   Introduction to Networking

                               the secondary ring is not needed for backup purposes, FDDI will generally use it to
                               transmit information and tokens in the opposite direction.65, 66, 67

                               Self Review
                               1. What is the major difference between FDDI and the Token Ring protocol?
                               2. What is the purpose of the second ring in FDDI?
                              Ans: 1) FDDI operates over fiber-optic cable, allowing it to support more transfers at
                              greater speeds over larger distances. FDDI is also built on two Token Rings. 2) The second
                              ring is provided as backup for the first. If the first ring fails, the second is used to keep the
                              entire network from failing.

                               16.8.4 IEEE 802.11 (Wireless)
                               IEEE 802.11 is a wireless protocol which employs a method similar to Ethernet to
                               communicate: Carrier Sense Multiple Access with Collision Avoidance (CSMA/
                               CA). Like Ethernet devices, wireless devices determine if the medium (air) is avail-
                               able before transmission. Availability is a good indication that no message is cur-
                               rently being transferred. However, since wireless networks are spontaneous and
                               can be obstructed by physical objects such as buildings, it is not guaranteed that
                               each device will be aware of all other devices, and a collision could still occur.
                                     To circumvent this issue, 802.11 requires that each sender broadcast a Request
                               to Send (RTS) to the entire network. The RTS indicates the sender's desire to trans-
                               mit data and specifies the length of the transmission, the sender's address and the
                               receiver's address. Upon receiving an RTS and if the medium is available, the
                               receiver broadcasts a Clear to Send (CTS) message to the entire network. The CTS
                               message also includes the specified length of transmission. The two stations with the
                               addresses specified in the RTS and CTS can then begin communication. After
                               receiving a CTS message, any other station that wishes to broadcast must wait until
                               the time specified by the CTS (i.e., the length of transmission) has passed.68

                               Self Review
                               1. What complications arise in wireless networks that do not exist in Ethernet networks?
                               2. What two messages are required before a wireless host can begin transmitting data?
                              Ans: 1) Wireless networks are spontaneous and can often be obstructed by physical objects
                              such as buildings. It is not guaranteed that each device will be aware of all other devices, and
                              collisions could still occur. 2) The source host must send out an RTS and the destination host
                              must respond with a CTS, before transmission is allowed to begin.



                               16.9 Client/Server Model
                               Many distributed applications operate according to a popular networking paradigm
                               known as the client/server model. Clients are hosts that need various services per-
                               formed, and servers are hosts that provide these services. Typically, clients transmit
                               requests to servers over a network and servers process requests and return the

<!-- pág. 823 -->

                                                                                        16.9 Client/Server Model 769

result to the client. For example, an Internet user might request from a server a list
of airplane flights departing from a particular location at a particular time. Upon
receiving this request, the server might query a local database for the requested
flight information, then send the client a message containing the requested list.
       We have presented the client/server model essentially as a two-tier system.
Typically, in such a system, the user interface resides on the client, the data resides
on the server and the application logic (i.e., rules for processing and handling data)
lies on one or both of these components.
       Some developers find it convenient to use a larger number of tiers in their cli-
ent/server systems for various reasons, including increased flexibility and extensibil-
ity in configuring a single system for many clients. In general, architectures
 consisting of three or more tiers are referred to as n-tier systems. For example, a
 three-tier system offers a clearer separation of the application logic from the user
 interface and the data (Fig. 16.4).70 Ideally, the logic resides in its own layer, possi-
 bly on a separate machine, independent of the client and data. This organization
 affords client/server systems increased flexibility. The trade-off in a multitier system
 is increased network latency and more areas where the network could fail. Since the
 three tiers are separate from one another, we can alter or relocate one without
 affecting the others.
        Web applications commonly use a three-tier architecture, consisting of a client
 browser, a Web server and a relational database.71 The Web browser on the client
 machine usually offers the client a graphical user interface (GUI) which facilitates




 Figure 16.4 | Three-tier client/server model.

<!-- pág. 824 -->

770 Introduction to Networking
                                    access to remote documents. The browser interprets pages written in HyperText
                                    Markup Language (HTML) and produces their representation on the client moni-
                                    tor. To retrieve a remote document, the browser communicates via HTTP with a
                                    Web server, which transmits HTML to the browser also via HTTP. A particular
                                    Web server might dynamically produce Web pages by querying a relational data-
                                    base (see Section 13.12.3). For example, imagine that a user visits an online auction
                                    site and wishes to view all the computers of a certain type that are currently being
                                    auctioned. A request would be sent from the client browser to the auction site's
                                    Web server. The server might then query a relational database residing on a remote
                                    machine and use the resulting information to dynamically create an HTML page.
                                    This page is sent to the browser, which interprets the HTML and displays the infor-
                                    mation on the client monitor. In this example, the client, server and data tiers are
                                    on physically separate machines.

                                   Self Review
                                    1. What are the names of the tiers in a typical three-tier system?
                                    2. What are the benefits and complications associated with increasing the number of tiers of
                                       a Web-based system?
                                   Ans: 1) The client tier, the application logic tier and the data tier. 2) The benefit is that it
                                   further modularizes the system. Each tier can be modified without altering the others. Add-
                                   ing tiers can introduce network latencies as requests are being fulfilled, diminishing applica-
                                   tion performance.



Web Resources
www.ietf.org/rfc                                                  www.its.bldrdoc.gov/fs-1037/
Provides an index of all of the Requests For Comments             Federal Standards 1037 Web site provides a glossary of tele-
(RFCs) that have been published.                                  communications terms.
www.ietf.org                                                      www.iana.org/
Internet Engineering Task Force provides links to its working     Internet Assigned Numbers Authority sets default port num-
groups and a discussion of the Internet standards process.        bers for many common protocols.
www.w3.org
World Wide Web Consortium (W3C) provides guidelines for
many Web-based technologies.


Summary
Network topology describes the relationship between dif-                 Ring networks consist of a set of nodes, each maintain-
ferent hosts, also called nodes, on a network. A logical          ing exactly two connections to other nodes such that a mes-
topology displays which nodes in a network are directly           sage sent through one connection can eventually return via
connected.                                                        the other. Each node in the ring forwards each message, lim-
      Nodes on a bus network are connected to a single,           iting attenuation but introducing a delay for retransmission.
common communication link. Since there are no intermedi-                 In mesh networks at least two nodes have more than
ary nodes to retransmit the message, the length of bus com-       one path connecting them. A fully-connected mesh network
munications medium must be limited to reduce attenuation.         directly connects every node to every other node. The pres-

<!-- pág. 825 -->

                                                                                                           Summary         771
ence of multiple paths between any two nodes increases the       are specified by a Uniform Resource Identifier (URI),
capacity available for network traffic, enabling higher net-     which is a name that references a specific resource on the
work throughput.                                                 remote host.
       Star networks contain a hub that is connected to all             The Hypertext Transfer Protocol (HTTP) is an appli-
 other nodes in the network. Star networks suffer from           cation layer protocol that allows the transfer of a variety of
lower transmission delay than ring networks, because con-        data formats. HTTP defines a request for a resource and a
nections require only one intermediary node. If the central      response. The remote host processes the request and
hub fails, however, messages cannot reach their recipients,      replies with a response, which contains in its header a code
so fault tolerance can be a problem.                             that tells the client whether the request was processed cor-
       Tree networks are hierarchical networks that consist of   rectly or there was an error.
a root node and several subnodes, called children, that can             The File Transfer Protocol (FTP) is an application
have subnodes of their own. A tree topology can be used to       layer protocol that allows file-sharing between remote
 join nodes that communicate with each other frequently into     hosts. FTP specifies connections between two pairs of
a subtree, thereby increasing network efficiency.                ports: one pair sends control information that governs the
       The proliferation of wireless network technology has      session, the other sends the actual data. After a connection
 introduced ad hoc networks. An ad hoc network is charac-        is established, the client specifies actions for the FTP server
terized as being spontaneous —any combination of wireless        to perform by issuing various requests to the server. The
and wired devices may be connected to it at any time. The        server attempts to satisfy each request, then issues a
network topology is not fixed, which makes it difficult to       response specifying the result.
have a network governed by a central node.                              The transport layer is responsible for the end-to-end
       Networks can also be classified by the geographic dis-    communication of messages. In a connection-oriented
persion of their hosts. A local area network (LAN) has lim-      approach, hosts send each other control information—
 ited geographic dispersion and is designed to optimize data     through a technique called handshaking—to set up a logical
transfer rates between its hosts. LANs interconnect              end-to-end connection. A connection-oriented approach
resources using high-speed communication paths with opti-        imposes reliability on unreliable networks. By making com-
mized network protocols for local area environments.             munication reliable, these protocols guarantee that data
 Advantages of local networks include error rates lower          sent from the sender will arrive at the intended receiver
than those of larger networks, greater management flexibil-      undamaged and in the correct sequence. In a connectionless
ity, and independence from the constraints of the public         approach, the two hosts do not handshake before transmis-
networking system. Wide area networks (WANs) are                 sion, and there is no guarantee that sent messages will be
 broader, connecting two or more LANs; the largest WAN is        received in their original order, or at all.
the Internet. WANs generally employ a mesh topology,                    The Transmission Control Protocol (TCP) is a con-
 operate at lower speeds than LANs and have higher error         nection-oriented transmission protocol. TCP guarantees
rates, because they handle larger amounts of data being          that segments sent from a sender will arrive at the intended
transmitted over far greater distances.                          receiver undamaged and in the correct sequence. TCP han-
       The TCP/IP protocol stack is composed of four logi-       dles error control, congestion control and retransmission,
cal levels called layers. The application layer is the highest   allowing protocols like HTTP and FTP to send information
level and provides protocols for applications to communi-        into the network as simply and reliably as writing to a file
cate. The transport layer is responsible for end-to-end com-     on the local computer.
-unication. The network layer is responsible for moving          When TCP is given a message to send over a network, TCP
the data on to the next step. The transport layer relies on      must first make a connection with the receiving host using
the network layer to determine the proper path from one          a three-way handshake. The receiving host in TCP accounts
end of the communication to the other. The link layer pro-       for reordering of the segments by using the sequence num-
vides an interface between the network layer and the             bers found in the message headers to reconstruct the origi-
underlying physical medium of the connection.                    nal message. When the destination host gets one of these
       Application layer protocols specify the rules that gov-   segments, it responds with an ACK segment containing the
ern remote interprocess communication and determine              sequence number of the message. This guarantees that seg-
how processes should interact. Many of these protocols           ments will eventually be received by the destination host
interact with resources on remote hosts. These resources         and that they will be reassembled in the original order.

<!-- pág. 826 -->

772     Introduction to Networking

TCP also implements flow control and congestion control          ting simultaneously. If transceivers detect a collision caused
to regulate the amount of data sent by each host.                by simultaneous transmissions, they continue to transmit
       The connectionless User Datagram Protocol (UDP)           bytes for a specific period of time to ensure that all trans-
provides the minimum overhead necessary for the trans-           ceivers become aware of the collision. Each transceiver,
port layer. There is no guarantee that UDP datagrams will        after learning of a collision, waits a random interval before
reach their destination in their original order, or at all.      attempting to transmit again.
       The network layer receives segments from the trans-              The Token Ring protocol operates on ring networks
port layer and is responsible for sending these packets to       and employs tokens to gain access to the transmission
the next stop toward the destination through a process           medium. In a Token Ring, a token that controls access to
known as routing. Routing is the two-step procedure of first     the transmission medium is actually an empty frame that is
determining the best route between two points and then           continuously circulated between machines over a network
sending packets along this route. Routers determine the          having a logical ring topology. When a machine owns the
next host for a given datagram based on information, such        token, it generates data, places it in the frame and sends the
as network topologies and link quality, which includes           frame to its neighbor. Each machine forwards the token
strength of signal, error rate and interference which is         until it reaches its destination. At the destination, the
broadcast throughout networks using various router proto-        machine copies the content of the message, marks the
cols, such as the Routing Information Protocol (RIP).            frame as having been delivered and passes the frame to its
       Internet Protocol version 4 (IPv4) is the dominant        neighbor. When the original sender receives the frame, it
protocol for directing information over a network. Destina-      removes the message from the frame and passes the token
tions on the Internet are specified by IP addresses, which       to its neighbor.
are 32-bit numbers in IPv4. To make networking simpler                  Fiber Distributed Data Interface (FDDI) operates
for the user, one or more names can be mapped to an IP           over fiber-optic cable, allowing it to support more transfers
address through the Domain Name System (DNS).                    at greater speeds over larger distances. FDDI is built on two
       In the near future, there will be more addressable        Token Rings, the second usually being reserved for backup.
nodes on the Internet than available addresses using the                802.11 wireless communications employ a method
current system. To combat this problem, the Internet Engi-       similar to Ethernet to communicate: Carrier Sense Multi-
neering Task Force introduced Internet Protocol version 6        pie Access with Collision Avoidance (CSMA/CA). This
(IPv6). IPv6 specifies three types of addresses: unicast, any-   requires that each sender broadcast a Request to Send
cast and multicast. A unicast address describes a particular     (RTS) to the entire network. Upon receiving an RTS, the
host on the Internet. Anycast addresses are designed to be       receiver broadcasts a Clear to Send (CTS) message to the
sent to the nearest host with a particular address. Multicast    entire network if the medium is available.
addresses are designed to send packets to a group of hosts.             Typically, in a two-tier client/server system, the user
       The link layer interfaces the software-oriented layer     interface resides on the client, the data resides on the
with the physical medium over which frames are sent. The         server and the application logic lies on one or both of these
link layer is responsible for detecting and, if possible, cor-   components. In place of this two-tier model, client/server
recting transmission errors. Some systems employ error-          systems often employ a three-tier system, which offers a
correcting codes to correct the corrupted frames.                clearer separation of the application logic from the user
       Ethernet uses the Carrier Sense Multiple Access with      interface and the data. Ideally, the logic resides in its own
Collision Detection (CSMA/CD) protocol. In 802.3-style           layer, possibly on a separate machine, independent of the
CSMA/CD, a transceiver tests a shared medium to deter-           client and data. This organization affords the client/server
mine if it is available before transmitting data. Due to         system increased flexibility and extensibility. The trade-off
delays in the medium, it is possible that multiple transceiv-    in a multitier system is increased network latency and more
ers may decide that the medium is clear and begin transmit-      areas where the network could fail.


Key Terms
acknowledgement segment (ACK)—In TCP, a segment that is              receive and ACK for a segment, it will retransmit that seg-
    sent to the source host to indicate that the destination         ment. This guarantees that each transmitted segment is
    host has received a segment. If a source host does not           received.

<!-- pág. 827 -->

                                                                                                               Key      Terms     773

ad hoc network—Network characterized as being spontane-              connectionless transport—Method of implementing the trans-
    ous—any number of wireless or wired devices may be                   port layer in which there is no guarantee that data will
    connected to it at any time.                                         arrive in order or at all.
any cast—Type of IPv6 address that enables a datagram to be          connection-oriented transport—Method of implementing the
    sent to any host within a group of hosts.                            transport layer in which hosts send control information to
application layer (in OSI)—Interacts with the applications and           govern the session. Handshaking is used to set up the con-
     provides various network services, such as file transfer            nection. The connection guarantees that all data will
     and e-mail.                                                         arrive and in the correct order.
application layer (in TCP/IP)—Protocols in this layer allow          control information—Data in the form of headers and/or trail-
     applications on remote hosts to communicate with each               ers that allows protocols of the same layer on different
     other. The application layer in TCP/IP performs the func-           machines to communicate. Control information might
     tionality of the top three layers of OSI —the application,          include the addresses of the source and destination hosts
     presentation and session layers.                                    and the type of data or size of the data that is being sent.
attenuation—Deterioration of a signal due to physical charac-        data link layer (in OSI)—At the sender, converts the data rep-
     teristics of the medium.                                            resentation from the network layer into bits to be trans-
                                                                         mitted over the physical layer. At the receiver, converts
bus network—Network in which the nodes are connected by a
                                                                         the bits into the data representation for the network layer.
    single bus link (also known as a linear network).
Carrier Sense Multiple Access with Collision Avoidance               datagram—Piece of data transferred using UDP or IP.
     (CSMA/CA)—Protocol used in 802.11 wireless communi-             Domain Name System (DNS)—System on the Internet used
     cation. Devices must send a Request To Send (RTS) and               to translate a machine's name to an IP address.
     receive a Clear To Send (CTS) from the destination host         Ethernet (IEEE 802.3)—Network that supports many speeds
     before transmitting.                                                over a variety of cables. Ethernet uses the Carrier Sense
Carrier Sense Multiple Access with Collision Detection                   Multiple Access with Collision Detection (CSMA/CD)
     (CSMA/CD)-Protocol used in Ethernet that enables                    protocol. Ethernet is the most popular type of LAN.
     transceivers to test a shared medium to see if it is avail-     exponential backoff—Method employed by Ethernet to calcu-
     able before transmitting data. If a collision is detected,          late the interval before retransmission after a collision;
     transceivers continue transmitting data for a period of             this reduces the chance of subsequent collisions on the
     time to ensure that all transceivers recognize the collision.       same transmission, thus increasing throughput.
checksum—Result of a calculation on the bits of a message.           Fiber Distributed Data Interface (FDDI)—Protocol that shares
    The checksum calculated at the receiver is compared to               many properties of a Token Ring, but operates over fiber-
     the checksum calculated by the sender (which is embed-              optic cable, allowing the transfer of more information at
     ded in the control information). If the checksums do not            greater speeds. In FDDI, a token circulates around the
     match, the message has been corrupted.                              optical fiber ring; stations cannot transmit until they obtain
Clear to Send (CTS)—Message that a receiver broadcasts in                the token by receiving it from a preceding station. FDDI
     the CSMA/CA protocol to indicate that the medium is                 uses a second Token Ring as backup or to circulate tokens
     free. A CTS message is sent in response to a Request to             in the reverse direction of the primary Token Ring.
     Send (RTS).                                                     File Transfer Protocol (FTP)—Application layer protocol that
client/server model—Popular networking paradigm in which                  moves files between different hosts on a network. FTP
     processes that need various services performed (clients)             specifies connections between two pairs of ports: one pair
     transmit their requests to processes that provide these ser-         sends control information that governs the session, the
     vices (servers). The server processes the request and                other sends the actual data.
     returns the result to the client. The client and the server     flow control—Means by which TCP regulates the number of
     are typically on different machines on the network.                  segments sent by a host to avoid overwhelming the
client—Process in the client/server model that needs various              receiver.
     services performed.                                             frame—Piece of data in the link layer. Contains both the mes-
collision—Simultaneous transmission in CSMA/CD protocol.                 sage and the control information.
congestion control—Means by which TCP restricts the number           fully-connected mesh network—Mesh network in which each
    of segments sent by a single host in response to network              node is directly connected to every other node. These net-
    congestion.                                                           works are faster and more fault tolerant than other net-

<!-- pág. 828 -->

774     Introduction to Networking

      works, but also unrealizable on all but the smallest of     multicast—Type of IPv6 address used to send packets to all
      networks because of the cost of the potentially enormous        hosts in a group of related hosts.
      number of connections.                                      Multipurpose Internet Mail Extensions (MIME)—Electronic
handshaking—Mechanism in a connection-oriented transport              mail standard defining five content types: text, image,
    layer in which hosts send control information to create a         audio, video and application.
    logical connection between the hosts.                         network layer—Protocols responsible for sending data to the
header—Control information placed in front of a data message.         next host toward the destination. This layer exists in both
                                                                      the TCP/IP model and the OSI model of network commu-
host—Entity, such as a computer or Internet-enabled cellular
                                                                      nication.
    phone, that receives and/or provides services over a net-
    work. Also called a node.                                     network topology—Representation of the relationships of
                                                                      nodes in a network. Some examples are bus networks
hub—Central node (such as in a star network) responsible for
                                                                      ring networks, star networks, tree networks and mesh net-
   relaying messages between nodes.
                                                                      works.
HTTP request—Resource request from an HTTP client to an
                                                                  n-tier system—Architecture for network-based applications
   HTTP server.
                                                                       The three-tier system, for example, has a client tier, an
HTTP response—Reply message from an HTTP server to an                  application logic tier and a data tier.
   HTTP client, consisting of a status, header and data.          physical layer (in OSI)—Transmits bits over physical media,
Hypertext Transfer Protocol (HTTP)—Application layer pro-             such as cables. The data link layer and physical layer in
   tocol used for transferring HTML documents and other               OSI correspond to the link layer in TCP/IP.
   data formats between a client and a server.                    port—Identifies the specific socket on a machine to which to
IEEE 802.11—One of the standards that governs wireless                send data. For example, HTTP communicates by default
   communication. It dictates that hosts follow the CSMA/             on port 80.
   CA protocol.                                                   presentation layer (in OSI)—Solves compatibility problems by
Internet Protocol version 6 (IPv6)—New version of the Inter-          translating the application data into a standard format
     net Protocol that uses 128-bit addresses and specifies           that can be understood by other layers.
     three types of addresses: unicast, anycast and multicast.    protocol—Set of rules that govern how two entities should
Internet Protocol (IP)—Primary protocol for directing infor-          interact. Common examples include Transmission Control
     mation over a network. Destinations on the Internet are          Protocol (TCP), Internet Protocol (IP) and Hypertext
     specified by 32-bit numbers called IP addresses.                 Transfer Protocol (HTTP).
IP address—Address of a particular host on the Internet.          random delay—Interval of time calculated by the exponential
                                                                      backoff method of CSMA/CD before a transceiver can
layer—Level of abstraction in the TCP/IP protocol stack asso-
                                                                      retransmit a frame after a collision.
     ciated with certain conceptual functions. These layers are
     the application layer, transport layer, network layer and    reliable network—Network which does not damage or lose
     link layer.                                                       packets.
link—Medium over which services are physically transmitted        Request to Send (RTS)—Message sent from a wireless device in
    in a network.                                                    the CSMA/CA protocol that indicates a desire to transmit
                                                                     data, the length of the transmission, the sender address and
link layer (in TCP/IP) —Responsible for interfacing with and         the receiver address. If the medium is available, the
     controlling the physical medium over which data is sent.        receiver will send a Clear To Send (CTS) message.
local area network (LAN)—Type of network used to intercon-        ring network—Network consisting of a set of nodes, each
     nect resources using high-speed communication paths              maintaining exactly two connections to other nodes in
     optimized for local area environments, such as office            that network. These networks have a low fault tolerance
     buildings or college campuses.                                   since the failure of any single node can cause the whole
logical topology—Map of a network that depicts which nodes            network to fail.
     are directly connected.                                      router—Computer that is an intermediate destination between
mesh network—Network in which at least two nodes have                 the sending host and the receiving host. The router is
    more than one path connecting them. Faster and more               responsible for determining where to send a datagram
    fault tolerant than all but fully-connected mesh networks.        next in order for it to eventually reach its destination.

<!-- pág. 829 -->

                                                                                                              Key     Terms     775
Routing Information Protocol (RIP)—Protocol that defines            Token Ring—Protocol in which a token is circulated around a
    how routing information is propagated throughout net-               ring network. Only one host can own the token at a time,
    works. RIP requires routers to share their entire routing           and only its owner can transmit data.
    table with other routers; this limits its use to small net-     trailer—Control information appended to the end of a data
    works.                                                               message.
routing table —Representation of a network used to determine        transceiver—Hardware device that attaches an Ethernet node
     where routers should send datagrams next on their path             to the network transmission medium. Transceivers test a
     to their destination.                                              shared medium to see if it is available before transmitting
routing—Determining the best route between two points and               data, and monitor the medium to detect a simultaneous
     sending packets along this route.                                  transmission called a collision.
segment—Piece of data sent by TCP. It includes the message          Transmission Control Protocol (TCP) —Connection-oriented
    and the TCP header.                                                 transmission protocol designed to provide reliable com-
server—Process in the client/server model that performs vari-           munication over unreliable networks.
    ous services for clients.                                       transmission medium—Material used to propagate a signal
session layer (in OSI)—Establishes, manages and terminates               (e.g., optical fiber or copper wire).
     the communication between two end users.                       transport layer—Set of protocols responsible for end-to-end
                                                                         communication of data in a network. This layer exists in
socket - Software construct that represents one endpoint of a
    connection.                                                          both the TCP/IP model and the OSI model of network
                                                                         communication.
star network—Network containing a hub that is directly con-
     nected to all other nodes in the network. The hub is           tree network—Hierarchical network that consists of multiple
     responsible for relaying messages between nodes.                    star networks. The hub of the first star network is the root
                                                                         of the tree. Each node that this hub connects serves as a
Symbian OS —Small operating system for smart phones                      hub for another star network and is a root of a subtree.
   (mobile phones with the functionality of a PDA).
                                                                    tunneling—Process of placing IPv6 datagrams in the body of
synchronization segment (SYN)—In TCP, the first handshak-               IPv4 datagrams when communicating with routers that do
    ing segment sent; contains the sequence number of the               not support IPv6.
    source host.
                                                                    two-tier system—A system in which the user interface resides
synchronization/acknowledgement segment (SYN/ACK)—In                    on the client, the data resides on the server and the appli-
    TCP, the second handshaking segment sent; acknowledges              cation logic lies on one or both of these components.
    that the SYN segment was received and contains the
                                                                    unicast address—IP address used to deliver data to a single
    sequence number of the destination host.
                                                                         host.
TCP/IP Protocol Stack—Hierarchical decomposition of com-
                                                                    Uniform Resource Identifier (URI)—Name that references a
   puter communications functions into four levels of
   abstraction called layers. These layers are the application          specific resource on the Internet.
   layer, transport layer, network layer and link layer.            Uniform Resource Locator (URL) A URI used to access a
                                                                        resource in a common protocol such as HTTP and FTP.
TCP window—Flow-control and congestion-control mecha-
                                                                        Consists of the protocol, host name, port and path of the
   nism in which only a certain amount of data can be sent by
                                                                        resource.
   the network layer without the receiver explicitly authoriz-
   ing the sender to send more.                                     unreliable network—Network that may damage or lose pack-
                                                                        ets.
three-tier system—System which offers a separation of the
     application logic, the user interface and the data. The user   User Datagram Protocol (UDP) —Connectionless transmis-
     interface tier (also called the client tier) communicates          sion protocol which allows datagrams to arrive out of
     with the user. The application logic tier is responsible for       order, duplicated or not at all.
     the logic associated with the system's function. The data      wide area network (WAN)—Type of network connecting two
     tier stores the information that the user wishes to access.        or more local area networks, usually operating over great
token—Empty frame used to ensure that only one host is                  geographical distances. WANs are generally implemented
    transmitting data at a time in the Token Ring and FDDI              with a mesh topology and high-capacity connections. The
    protocols.                                                          largest WAN is the Internet.

<!-- pág. 830 -->

776    Introduction to Networking

Exercises
16.1 What are the pros and cons of using a layered network         work, no station can transmit. Comment on this problem.
architecture?                                                      What safeguards can be built into a token-passing network to
16.2 Why does TCP/IP not specify a single protocol at each         determine if a token has been lost, and then to restore proper
layer?                                                             operation of the network?

16.3 Compare and contrast connection-oriented services and         16.7 The text said that the Internet is implemented as a mesh
connectionless services.                                           network. What would be the consequences if the internet were
                                                                   implemented as a tree network? If it was implemented as a
16.4 Distinguish between addressing, routing, and flow con-        ring network? If it was implemented as a fully-connected mesh
trol. What is a windowing mechanism?                               network?
16.5 Explain the operation of CSMA/CD. Compare the pre-            16.8 HTTP and FTP are both implemented on top of TCP
dictability of CSMA/CD with token-based approaches. Which          What would be the effect if they were implemented on top of
of these schemes has the greatest potential for indefinite post-   UDP?
ponement?
                                                                   16.9 Why was CSMA/CD not used for wireless systems?
16.6 One interesting problem that occurs in distributed con-
trol, token-passing systems, is that the token may get lost.       16.10 Why would an implementation of the link layer utilize
Indeed, if a token is not properly circulating around the net-     error-correcting codes? How would that affect the system?


Suggested Projects
I 6 . I I A number of protocols have been proposed to replace      16.12 In the text, we mentioned that Routing Information Pro-
TCP. Researchers at MIT and Berkeley have recently devel-          tocol (RIP) is a means to determine the next host for a data-
oped the eXplicit Control Protocol (XCP) which is designed to      gram. Research RIP and explore how it determines the next
speed up transmissions. Research this protocol and examine         host for a datagram.
what changes it makes to TCP.


Suggested Simulations
16.13 Write a simulation program to experiment with routing        see that each node can efficiently determine the next node
procedures. Create a mesh network containing some number           along a path between two nodes in the graph. Experiment with
of nodes and links. Create your own routing protocol to send       "crashing" a node or changing the network topology. How
information about the links throughout the network. Check to       quickly will all of your nodes figure out the new topology?




Recommended Reading
Many books go into greater depth on networking than space          more general idea of how this exciting research area is progress-
permits in an operating systems text. Those include Tanen-         ing.75, 76 Professional groups such as the Institute of Electrical
baum's classic Computer Networks, 4th ed. and Computer Net-        and Electronics Engineers (IEEE; www.ieee.org) and the
working: A Top-Down Approach Including the Internet by             Association for Computing Machinery (ACM; www.acm.org)
Kurose and Ross.73, 74                                             are an ideal source of new literature on the topic. Interesting
      Requests for Comments (RFCs) describe networking             papers available through the ACM include "Frameworks for
protocols, including TCP, IP, UDP, FTP and SMTP. The Inter-        Component-Based Client/Server Computing," "The Transport
net Engineering Task Force (IETF) provides free access to          Layer: Tutorial and Survey" and "Fundamental Challenges in
every RFC via their Web site (www.ietf.org).                       Mobile Computing."77, 78, 79 The bibliography for this chapter
      Networking remains a rich research area. Papers such as      is located on our Web site at www.deitel.com/books/os3e
"Congestion Control for High Bandwidth-Delay Product Net-          Bibliography.pdf.
works" and "Why Wi-Fi Wants to be Free" give a technical and

<!-- pág. 831 -->

                                                                                                                                  Works Cited 777

Works Cited
 1. Federal   Standards   On-Line,       "Network      Topology,"   20. Mery, D., "Symbian Technology: Symbian OS v7.0 Functional
    <www.its.bldrdoc.gov/fs-1037/>.                                     Description," March 2003, <www.symbian.com/technology/
 2. Abeysundara, B. W., and A. E. Kamal, "High-Speed Local Area         symbos-v7x-det.html>.
    Networks and Their Performance: A Survey," ACM Computing        2i. de Jode, M., "Symbian: Technology: Standards: Symbian on
    Surveys, Vol. 23, No. 2, June 1991, p. 231.                         Java," June 2003, <www.symbian.com/technology/standard-
3. Federal   Standards   On-Line,        "Network     Topology,"        java.html>.
   <www.its.bldrdoc.gov/fs-1037/>.                                  22. Dixon, K., "Symbian OS Version 7.0s: Functional Description,"
4. Abeysundara, B. W., and A. E. Kamal, "High-Speed Local Area          Rev. 2.1, June 2003, <www.symbian.com/technology/symbos-
   Networks and Their Performance: A Survey," ACM Computing             v7s-det.html>.
   Surveys, Vol. 23, No. 2, June 1991, pp. 248-249.                 23. Dixon, K., "Symbian OS Version 7.0s: Functional Description,"
5. Federal   Standards   On-Line,        "Network      Topology,"       Rev. 2.1, June 2003, <www.symbian.com/technology/symbos-
   <www.its.bldrdoc.gov/fs-1037/>.                                      v7s-det.html>.
6. Abeysundara, B. W., and A. E. Kamal, "High-Speed Local Area      24. "WCDMA," SearchNetworking.com, July 2003, <searchnet-
   Networks and Their Performance: A Survey," ACM Computing             working.techtarget.com/sDefinition/
   Surveys, Vol. 23, No. 2, June 1991, pp. 248-250.                       0,,sid7_gci505610,00.html>.
7. Federal   Standards    On-Line,       "Network     Topology,"    25. Abeysundra, B. W., and A. E. Kamal, "High-Speed Local Area
   <www.its.bldrdoc.gov/fs-1037/>.                                      Networks and Their Performance: A Survey," ACM Computing
8. Abeysundara, B. W., and A. E. Kamal, "High-Speed Local Area          Surveys, Vol. 23, No. 2, June 1991, pp. 223-250.
   Networks and Their Performance: A Survey," ACM Computing         26. Federal  Standards    On-Line,                           "Network             Topology,"
   Surveys, Vol. 23, No. 2, June 1991, pp. 248-250.                     <www.its.bldrdoc.gov/fs-1037/>.
9. Federal   Standards   On-Line,        "Network     Topology,"    27. Yanowitz, Jason, "Under the Hood of the Internet: An Overview
   <www.its.bldrdoc.gov/fs-1037/>.                                      of the TCP/IP Protocol Suite," <www.acm.org/crossroads/
10. Rajaraman, R., "Topology Control and Routing in Ad Hoc Net-         xrdsl-1/tcpjmy.html>.
    works: A Survey," ACM SIGACT News, Vol. 33, No. 2, June 2002,   28. TCP/IP and OSI, < s e a r c h n e t w o r k i n g . t e c h t a r g e t . c o m / o r i g i -
    pp. 60-74.                                                          nalContent/0,289142,sid7_gci851291,00.html>.
11. Symbian, "Symbian: About Us," <www.symbian.com/about/           29. Tyson, J., "How OSI Works—The Layers," <computer.how-
    about.html>.                                                        stuffworks.com/osi1.htm>.
12. Blackwood, X, "Why You Can't Ignore Symbian," May 22, 2002,     30. Tyson, X, "How OSI Works—Protocol Stacks," <computer. how-
    <techupdate.zdnet.com/techupdate/stories/main/                      stuffworks.com/osi2.htm>.
    0,14179,2866892,00.html>.
                                                                    31. "The 7 Layers of the OSI Model," <webopedia.internet.com/
13. Mery, D., "Symbian Technology: Why Is a Different Operating         quick_ref/OSI_Layers.asp>.
    System Needed?" March 2002, <www.symbian.com/technol-
                                                                    32. Module 4: Standards and the ISO OSI Model, "ISO O S I - A p p l i -
    ogy/why-diff-os.html>.
                                                                        cation    Layer    (7),"   <vvv.it.kth.se/edu/gru/Telesys/
14. Blackwood, X, "Why You Can't Ignore Symbian," May 22, 2002,         96P3_Telesystem/HTML/Module4/ISO-15.html>, modified          11/
    <techupdate.zdnet.com/techupdate/stories/main/                      1/95, © 1995 G. Q. Maguire Jr., KTH/Teleinformatics.
    0,14179,2866892,00.html>.
                                                                    33. "Naming and Addressing: URIs, URLs.," W3C July 2002,
15. Mery, D., "Symbian Technology: Why Is a Different Operating         <http://www.w3.org/Addressing/>.
    System Needed?" March 2002, <www.symbian.com/technol-
    ogy/why-diff-os.html>.                                          34. "Port," searchNetworking.com, last modified July 2003, <search-
                                                                        networking.techtarget.com/sDefinition/
16. Mery, D., "Symbian Technology: Symbian OS v7.0 Functional           0„sid7_gci212807,00.html>.
    Description," March 2003, <www.symbian.com/technology/
    symbos-v7x-det.html>.                                           35. "Hypertext Transfer Protocol-HTTP/1.1," RFC 2616, June
                                                                        1999, <www.ietf.org/rfc/rfc2616.txt>.
17. Mery, D., "Symbian Technology: Why Is a Different Operating
    System Needed?" March 2002, <www.symbian.com/technol-           36. "Multipurpose Internet Mail Extensions (MIME), Part One:
    ogy/why-diff-os.html>.                                              Format of Internet Message Bodies," RFC 2045, November 1996,
                                                                        <www.ietf.org/rfc/rfc2045.txt>.
18. PASC, "The Portable Application      Standards   Committee,"
    <www.pasc.org>.                                                 37. "Uniform Resource Identifiers (URI): General Syntax," RFC
                                                                        2396, August 1998, < w w w . i e t f . o r g / r f c / r f c 2 3 9 6 . t x t > .
19. Mery, D., "Symbian Technology: Why Is a Different Operating
    System Needed?" March 2002, <www.symbian.com/technol-           38. "File Transfer Protocol (FTP)," RFC 959, October 1985,
    ogy/why-diff-os.html>.                                              <www.ietf.org/rfc/rfc0959.txt>.

<!-- pág. 832 -->

778 Introduction to Networking

39- Pouzin, L., "Methods, Tools, and Observations on Flow Control                           59. "IP Version 6 Addressing Architecture," RFC 1884, December
    in Packet-Switched Data Networks," IEEE Transactions on                                     1995, < w w w . i e t f . o r g / r f c / r f c l 8 8 4 . t x t > .
    Communications, April 1981.                                                             60. "Cyclic Redundancy Check," Free On-Line Dictionary of Com-
40. George, F. D., and G. E. Young, "SNA Flow Control: Architec-                                puting,   last   modified   August     2003,     <http://
    ture and Implementation," IBM Systems Journal, Vol. 21, No. 2,                              wombat.doc.ic.ac.uk/foldoc/foldoc.cgi?CRC>.
    1982, pp. 179-210.                                                                      61. Duerincks, G., "Cyclic Redundancy Checks in Ada95," ACM
41. Grover, G. A., and K. Bharath-Kumar, "Windows in the S k y -                                SIGAda Ada Letters, Vol. 17, No. 1, January/February 1997. pp.
    Flow Control in SNA Networks with Satellite Links," IBM Sys-                                41-53.
    tems Journal,Vo\. 22, No. 4.1983, pp. 451-463.
                                                                                            62. Chae, L., "Fast Ethernet: 100BaseT," Network Magazine, Decem-
42. Henshall, J., and S. Shaw, OSI Explained: End-to-End Computer                               ber         1995,         <www.networkmagazine.com/article/
    Communication Standards, Chichester, England: Ellis Horwood                                 NMG20000727S0014>.
    Limited, 1988.
                                                                                            63. Intel, "Gigabit Ethernet Solutions (White Paper)," 2001,
43. Iren, S.; P. Amer; and P. Conrad, "The Transport Layer: Tutorial                            <www.intel.com/network/connectivity/resources/doc_
    and Survey," ACM Computing Surveys, Vol. 31, No. 4, December                                library/white_papers/gigabit_ethernet/gigabit_
    1999.                                                                                       ethernet.pdf>.
44. "Explanation of the Three-Way Handshake via TCP/IP," <sup-                              64. "Token Ring," searchNetworking.com, last modified July 2003,
    port.microsoft.com:80/support/kb/articles/Q172/9/                                           <searchnetworking.techtarget.com/sDefinition/
    83.ASP>.                                                                                    0, ,sid7_gci213154,00.html>.
45. "Transmission Control Protocol, DARPA Internet Program, Pro-                            65. Mokhoff, N., "Communications: Fiber Optics," IEEE Spectrum,
    tocol Specification," RFC 793, September 1981, <www.ietf.org/                               January 1981.
    rfc/rfc0793.txt>.
                                                                                            66. Schwartz, M., "Optical Fiber Transmission —from Conception to
46. Iren, S.; P. Amer; and P. Conrad, "The Transport Layer: Tutorial                            Prominence in 20 Years," IEEE Communications Magazine. May
    and Survey," A CM Computing Surveys, Vol. 31, No. 4, December                               1984.
    1999, pp. 360-405.
                                                                                            67. "FDDI," searchNetworking.com, last modified April 2003
47. Federal   Standards   On-Line,                       "Network          Topology,"
                                                                                                <searchnetworking.techtarget.com/gDefinition/
    <www.its.bldrdoc.gov/fs-1037/>.
                                                                                                0,294236,sid7_gci213957,00.html>.
48. "The TCP Maximum Segment Size and Related Topics," RFC
                                                                                            68. Karve, A., "802.11 and Spread Spectrum," Network Magszine,
    789,November 1983, <www.faqs.org/rfcs/rfc879.html>.
                                                                                                December       1997,    <www.networkmagazine.com/article/
49. Deitel, H.; P. Deitel; and S. Santry, Advanced Java 2 Platform:                             NMC20000726S0001>.
    How to Program, Prentice Hall, Upper Saddle River, NJ, 2002,
                                                                                            69. Sinha, A., "Client-Server Computing," Communications of the
    pp. 530-592.
                                                                                                ACM, Vol. 35, Issue 7, July 1992, pp. 77-98.
50. "User Datagram Protocol," RFC                           768,     August       1980,
                                                                                            70. Lewandowski, S., "Frameworks for Component-Based Client
    <www.ietf.org/rfc/rfc0768.txt>.
                                                                                                Server Computing." ACM Computing Surveys, Vol. 30, No. 1,
51. Iren, S.; P. Amer; and P. Conrad, "The Transport Layer: Tutorial                            March 1998. pp. 3-27.
    and Survey," ACM Computing Surveys, Vol. 31, No. 4, December
    1999, pp. 360-405.                                                                      71. Lewandowski, S., "Frameworks for Component-Based Client
                                                                                                Server Computing," ACM Computing Surveys, Vol. 30, No. 1,
52. "Overview of the TCP/IP Protocols," IT Standards Handbook—                                  March 1998, pp. 3-27.
    The     Internet  Protocol   Suite     (Including   TCP/IP).
    <www.nhsia.nhs.uk/napps/step/pages/ithandbook/                                          72. Katabi, D.; M. Handley; and C. Rohrs, "Congestion Control for
    h322-4.htm>.                                                                                High Bandwidth-Delay Product Networks," Proceedings of the
                                                                                                2002 Conference on Applications, Technologies, Architectures, and
53. "How Domain Name Servers Work," <computer.howstuff-                                         Protocols for Computer Communications, August 2002, pp. 89-
    works.com/dns.htm>.                                                                         102.
54. "DNS       Demystified,"                <www.lantimes.com/handson/97/
                                                                                            73. Tanenbaum, A., Computer Networks, 4th ed., Upper Saddle
    706al07a.html>.
                                                                                                River, NJ, Prentice Hall PTR, 2002.
55. "Exploring the Domain Name Space," <hotwired.lycos.com/
                                                                                            74. Kurose, J., and K. Ross, Computer Networking: A Top-Down
    webmonkey/webmonkey/geektalk/97/03/index4a.html>.
                                                                                                Approach Featuring the Internet, Reading, MA. Addison-Wesley
56. "Experimental Internet Stream Protocol, Version 2 (ST-II),"                                 1st ed., 2000.
    RFC 1190, October 1990. < w w w . i e t f . o r g / r f c / r f c l l 9 0 . t x t > .
                                                                                            75. Katabi, D.; M. Handley; and C. Rohrs, "Congestion Control for
57. "Internet Protocol Version 6 (IPv6) Addressing Architecture,"                               High Bandwidth-Delay Product Networks," Proceedings of the
    RFC 3513, April 2003, <www.ietf.org/rfc/rfc3513.txt>.                                       2002 Conference on Applications, Technologies, Architectures, and
58. "Internet Protocol, Version 6 (IPv6) Specification," RFC 1883,                              Protocols for Computer Communications, August 2002, pp. 89-
    December 1993, < w w w . i e t f . o r g / r f c / r f c l 8 8 3 . t x t > .                102.

<!-- pág. 833 -->

                                                                                                                 Works Cited 779
76. Schmidt T., and A. Townsend, "Why Wi-Fi Wants to Be Free,"        78. Iren, S.; P. Amer; and P. Conrad, "The Transport Layer: Tutorial
    Communications of the ACM, Vol. 46, No. 5, May 2003, pp. 47-52.       and Survey," ACM Computing Surveys,Vol. 31, No. 4, December
77. Lewandowski, S., "Frameworks for Component-Based Client/              1999, pp. 360-405.
    Server Computing," ACM Computing Surveys, Vol. 30, No. 1,         79. Satyanarayanan, M., "Fundamental Challenges in Mobile Com-
    March 1998, pp. 3-27.                                                 puting," Symposium on Principles of Distributed Computing '96,
                                                                          ACM, 1996, Philadelphia PA.

<!-- pág. 834 -->

I wish to have no connection with any ship that does not sail fast;for I intend to go in
harm's way.
      —John Paul Jones —


Whatever shall we do in that remote spot?
      —Napoleon Bonaparte—


The art of progress is to preserve order amid change and to preserve change amid order.
      -Alfred North Whitehead—


Order and simplification are the first sted toward the mastery of a subject - the actual
enemy is the unknown.
      —Thomas Mann—

The clock, not the steam-engine, is the key machine of the modern industrial age.
      —Lewis Mumford—

It's so awkward to tell one client that you're working on someone else's business...
      —Andrew Forthingham—


You may delay, but Time will not.
      —Benjamin Franklin—

