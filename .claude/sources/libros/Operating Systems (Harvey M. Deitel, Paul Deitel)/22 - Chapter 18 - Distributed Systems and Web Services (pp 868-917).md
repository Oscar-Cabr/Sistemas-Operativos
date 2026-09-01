# Chapter 18 - Distributed Systems and Web Services

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 868–917 (numeración del PDF)

<!-- pág. 868 -->

Chapter 18


Distributed Systems and
    Web Services
 Objectives
 After reading this chapter, you should understand:
 • characteristics and examples of networked and distributed file systems.
 • types, benefits and examples of clustering.
 • the peer-to-peer distributed computing model.
 • grid computing.
 • Java distributed computing technologies.
 • Web services and the Microsoft .NET and Sun ONE platforms.

<!-- pág. 869 -->

                                  Chapter Outline
                       18.1                              18.5.2 Centralized vs. Decentralized P2P
                 lntroduction                                           Applications
                                                           18.5.3 Peer Discovery and Searching
                   18.2                                               18.5.4         JXTA
         Distributed File Systems
      18.2.1 Distributed File System Concepts
       18.2.2 Network File System (NFS)                                      18.6
       18.3.3 Andrew File System (AFS)                              Grid Computing
            18.4.4 Coda File System
            18.2.5 Sprite File System
                                                                             18.7
                      18.3                                  Java Distributed Computing
         Mukticomputer Systems                           18.7.1   Java Servlets and JavaServer Pages
                                                                             (JSP)
                      18.4                                             18.7.2 Jini
                  Clustering                                        18.7.3       JavaSpaces
             18.4.1 Clustering Types                       18.7.4 Java Management Extensions
            18.4.2 Clustering Benefits                                       (JMX)
           18.4.3 Clustering Examples

                  18.5                                                   18.8
         Peer-to-Peer Distributed                                     Web Services
                Computing                                    18.8.1 Microsoft's .NET Platform
       18.5.1 Client/Server and Peer-to-Peer              18.8.2 Sun Microsystems and the Sun
                   Applications                                       ONE Platform




         Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited




816

<!-- pág. 870 -->

                                                                                              18.1 Introduction 817

18.1 Introduction
In the preceding chapter, we discussed the basic concepts of distributed systems,
 including the middleware technologies that help to build transparent and scalable
systems. We also discussed how to ensure mutual exclusion in distributed systems
and how to prevent and detect distributed deadlocks. In this chapter, we look at
another fundamental element of distributed systems—file sharing. Accessing files
stored on file servers using a distributed file system is similar to accessing files
stored on the user's local computer. We discuss several distributed file systems and
give an overview of how data and files are shared among distributed computers.
Then, we introduce clustering, which takes advantage of distributed systems and
parallel systems to build powerful computers. We discuss the peer-to-peer distrib-
uted computing model which is used to remove many central points of failure in
applications like instant messengers. Another distributed computing model we dis-
cuss is grid computing, which uses unused computer power to solve complex prob-
lems. We continue our presentation of Java distributed systems technologies, with
discussions of servlets, JSP, Jini, JavaSpaces and JMX, and discuss Web services and
how they improve interoperability in distributed systems.


18.2 Distributed File Systems
Networked file systems allow clients to access resources stored on remote comput-
ers as the combination of a server name and the path to the resource within that
server. Distributed file systems, discussed in detail in this chapter, are special exam-
ples of networked file systems that allow transparent access to remote files.1 They
take the form of one global file system to which all machines in the system have
access. This is achieved by allowing users to mount other file systems (see
Chapter 13). Once a remote file system has been mounted, the user can access the
files in it as if the files were local. This section addresses the key concepts of distrib-
uted file systems and presents case studies on various key distributed file systems.

18.2.1 Distributed File System Concepts
A distributed file server can be either stateful or stateless. A stateful server main-
tains state information about client requests—such as the file name, a pointer to the
file and the current position in the file—so that subsequent access to the file is faster
and easier. In a stateless system, the client must specify this state information in
each request. There are benefits to both types of systems: fault tolerance is easier to
implement in stateless systems, but stateful systems can reduce the size of request
messages and hence offer better performance. Distributed file systems can be char-
acterized by transparency, scalability, security, fault tolerance, and consistency.

Transparency
Distributed file systems provide complete file location transparency; the user sees
the distributed file system as a single, global file system. For example, consider a

<!-- pág. 871 -->

818 Distributed Systems and Web Services
                            company with offices located in Boston and New York. If a user is in Boston, the
                            system should allow the user to access files located in either Boston or New York.
                            However, the physical location of the files is hidden from the user. To achieve high
                            degrees of transparency, robust naming mechanisms are required.2


                            Scalabitity
                            Distributed file systems should also be scalable; allowing new computers to be
                            added to the system easily. Designers of scalable distributed file systems must con-
                            sider the size of the file system, file management, data duplication and concurrent
                            user access. Other design issues, such as narrow bandwidth, could also limit scalabil-
                            ity. Further, if any operations are restricted to a single machine, adding clients could
                            make that machine a bottleneck.3


                            Security
                            Two key security concerns in distributed file systems are ensuring secure communi-
                            cations and guaranteeing correct file-access permissions. Providing secure commu-
                            nications can be done by encrypting file content. Ensuring correct file access
                            permissions can be complex. In many operating systems, the kernel can determine
                            what files a process has access to based on the identity of the process' user. How-
                            ever, in a distributed system, users may have different user identifications on differ-
                            ent machines. This can allow users to access files that they should not and prevent
                            users from accessing files that they are authorized to access.4


                            Fault Tolerance
                            Fault tolerance is more complex in distributed systems than in conventional sys-
                            tems. When a machine crashes, the system should provide mechanisms to leave the
                            file system in a stable and consistent state. For example, if a client requests a file and
                            blocks while waiting for a server's response and the server then crashes, the client
                            must have some way to guarantee that it will not wait indefinitely. Often, both the
                            client and server will set a timer and abort a call after a timeout, but this introduces
                            complications. What happens if a client sends a request and does not receive a
                            response from the server? It could be that the server has crashed. It could also be
                            that the server is slow or that its response was lost. In the latter case, if the client's
                            request was idempotent, i.e., several calls to perform the same operation return the
                            same result (such as when checking a bank balance), then the client can resend its
                            request without introducing inconsistency into the system. However, if the client's
                            request was not idempotent, such as when withdrawing money from a bant
                            account, inconsistencies might arise.5 A well-designed distributed system makes
                            sure that the same remote procedure calls are executed exactly once regardless of
                            server failures.
                                  High availability is closely related to fault tolerance. In a fault-tolerant sys-
                            tem, the failure of a component causes no down time; a backup component immedi-

<!-- pág. 872 -->

                                                                                          18.2 Distributed File Systems 819

 ately takes the place of the failed component and users will not be aware that a
 failure occurred. In a high-availability system, the failure of a component causes
 minimal down time. In such systems, often the backup components are used during
  normal execution for better performance.6


Consistency
Consistency is another concern for the designers of distributed systems. Many dis-
tributed systems implement client caching to avoid the overhead of multiple RPCs.
In such cases, clients will keep a local copy of a file and flush it to the server from
:ime to time. Because there are multiple copies of the same file, files can become
inconsistent. To avoid inconsistencies, each client must invalidate its copy of the file
against the copy on the server. The client checks the timestamp of the copy of the
file on the server, ff it has been updated since the client last copied the file, then the
client must download the latest version. If the file has not been updated since the
client copied it, then the client can work on its cached copy. Invalidation guarantees
that each client will have the same view of the file, but it can lead to inefficiency if it
results in the overwriting of work performed by the client. To reduce file access
times, sometimes clients will also cache information about files, such as creation or
modification dates and location.7
      Servers can guarantee consistency by issuing locks to clients, giving them
exclusive access to a file. When another client needs to access the file, that client
must wait for the client that owns the lock to release it. The server still has ultimate
control over the file and can revoke the lock if necessary. In fact, most servers lease
locks and automatically revoke them when the leases expire. If a user still requires a
lock, the user must renew the lease before it expires. In some cases, a server may
even delegate complete control over the file to the client for a brief period of time.
In this situation, other clients must request file access from that client instead of
from the server, thereby reducing the load on the server.8
      Designing a distributed file system involves trade-offs. One means of imple-
menting fault tolerance is replication. But replication requires more components
and introduces the problem of consistency. To ensure consistency, systems can
employ client invalidation and file locks. But these increase complexity and, in
some cases, restrict scalability; and these mechanisms can reduce performance.



Self Review
1. Why is fault tolerance difficult to implement in stateful systems?
2. What problem is raised by client caching?
Ans: 1) In stateful systems, if the server crashes, it must reconstruct the state information of
each client when it restarts. The state information after the server restarts must be consistent
with the state information before the crash. 2) Client caching may cause file inconsistency
because multiple copies of a file may be distributed to multiple clients, enabling them to mod-
ify the same file at the same time.

<!-- pág. 873 -->

820 Distributed Systems and Web Services

                            18.2.2 Network File System (NFS)
                            Sun Microsystem's Network File System (NFS), the current de facto standard for
                            network file sharing, is supported natively in most varieties of UNIX and with client
                            and server software available for other common platforms. NFS was originally
                            designed around TCP/IP, so it has been easily adapted to link file systems across the
                            Internet and other wide area networks.9
                                  The original version of NFS was released by Sun in 1984 and licensed free to
                            the industry. NFS was revised in 1985 to version 2, which became integrated into
                            various operating systems. In 1989 NFS-2 became the first version of NFS to be
                            standardized by the Internet Engineering Task Force (IETF), becoming an Internet
                            protocol.10 NFS was revised again with the release of version 3 in 1995.11
                                  Figure 18.1 illustrates how NFS works. Before an NFS client can access a
                            remote file, it must use the mount protocol—a mechanism that translates a file path
                            name to a file handle—to mount the directory that holds the remote file. A file han-
                            dle identifies a remote file by its type, location and access permissions. Mounting
                            involves mapping a remote file directory to a client's local directory. To mount the
                            file system, the NFS client makes an RPC (the mount request, which contains the
                            file path of the remote file to be mounted) to the client stub. Upon receiving the
                            mount request, the server skeleton passes the call to the NFS server. The NFS
                            server looks up its local file system and exports the local file directory that satisfies
                            the client request, which means the server makes the local directory of files avail-
                            able to the remote client. The server skeleton then returns a file handle of the
                            exported local file directory, which allows the client to access the exported file




                            Figure 18.1 I NFS architecture.

<!-- pág. 874 -->

                                                                                   18.2 Distributed File Systems 821

directory remotely. The remote client uses this file handle in all subsequent requests
to files in the exported file directory.
       NFS-2 and NFS-3 assume a stateless server implementation, which makes
fault tolerance easier to implement. If a stateless server crashes, the client can sim-
ply retry until the server responds. The NFS-2 and NFS-3 permission checks simply
rely on the authentication information from RPC, which determines whether the
client can access certain information and functions. NFS-2 uses UDP as its transfer
protocol, since UDP performs well over local area networks. TCP becomes the pro-
tocol of choice on error-prone, high-latency and wide-area networks. Both NFS-2
and NFS-3 support TCP; NFS-3 optimizes its use by allowing transfers of large
streams of data. Neither version 2 nor version 3 defines a caching policy to guaran-
tee the consistency of the server and client copies of the file.12
       Although NFS-2 and NFS-3 are structurally similar, NFS-3 introduces several
key differences. First, it supports larger files—file sizes can be stored in 64 bits,
while NFS-2 supports only 32-bit file sizes. Second, NFS-3 supports safe asynchro-
nous writes, which allow a server to continue executing before a write has been
completed. Finally, NFS-3 removes the 8KB limit defined by NFS-2 for any single
request or reply.13 This limit was chosen as a reasonable upper bound for the size of
UDP packets being transferred over local area Ethernet.
       Following the release of NFS-3, Sun enhanced NFS with a service called Web-
NFS, which allows NFS clients to access WebNFS-enabled servers with a minimum
of protocol overhead. WebNFS is specifically designed to take advantage of NFS-3's
use of TCP to support efficient file operations over the Internet.
       Many features provided by WebNFS have been integrated into version 4 of
NFS, which entered development in 1999 as an IETF proposal. NFS version 4 main-
tains most of the features of prior versions of NFS and provides efficient operation
over wide area networks, strong security implementation, stronger interoperability
and client caching.14
       Like its predecessors, NFS-4 uses RPCs to communicate between client and
server. NFS-4 offers a new feature, allowing multiple related RPCs to be packaged
together into one request. This limits network traffic and increases performance.
Also, NFS-4 is stateful, which allows faster access to files. With earlier versions of
NFS, the client used the mount protocol to receive the file handle. In NFS-4, the cli-
ent obtains the file handle without the mount protocol. The client gets a file handle
referring to the root of the file system on the server, then traverses the file system to
locate the requested file. By removing the mount protocol, the client does not need
to mount the different file systems of a server separately.15
       NFS-4 extends the client-caching scheme through delegation, whereby the
server temporarily transfers control of a file to a client. When the server grants a
read delegation, no other clients can write to that particular file but they can read
from it. When the server grants a write delegation, then no other clients can read
from or write to that particular file. If another client requests write access to a file
with the read or write delegation, or the client requests read access to the file with

<!-- pág. 875 -->

822 Distributed Systems and Web Services

                             write delegation, the server will revoke the delegation and request that the original
                             client flush the file to disk.16
                                   As discussed earlier, the only security provided by previous versions of NFS
                             was weak authentication from RPC. The developers of NFS-4 were able to take
                             advantage of new RPC security which also supports several cryptographic algo-
                             rithms which are used when NFS-4 sets up communication sessions and encrypts
                             each RPC. 17

                            Self Review
                            1. Does NFS-2 require stateful server implementation? What is the benefit of such a design?
                            2. When an NFS-4 client owns the read delegation of a file, can other clients read or write to
                               that file?
                            Ans: 1) No, NFS-2 servers must be stateless. With a stateless server, it is easy to implement
                            fault tolerance. 2) Other clients can read from, but not write to, the file.


                             18.2.3 Andrew File System (AFS)
                            Development of the Andrew File System (AFS), a scalable distributed file system,
                            began in 1983 at Carnegie Mellon University. The goal was to provide a distributed
                            file system that would grow to support a large user community while being secure.
                            The designers hoped to exploit advances in workstation processing capabilities to
                            facilitate scalability, efficiency and security. AFS is a global file system that appears
                            as a branch of a traditional UNIX file system at each workstation, ft is based on the
                            client-server model and relies on RPCs for communication. Andrew went through
                            three major revisions: AFS-1, AFS-2 and AFS-3. 18 - 19
                                   The entity that governs distributed file access in AFS is called Vice (Fig. 18.2).
                            Vice processes run on distributed file servers and interact with a user-level process
                            called Venus at each client. Venus interacts with the kernel's virtual file system




                            Figure 18.2 | AFS structure.

<!-- pág. 876 -->

                                                                                  18.2 Distributed File Systems 823

(VFS), which provides the abstraction of a common file system at each client and is
responsible for all distributed file operations. AFS obtains scalability from its cach-
ing method. The local nonvolatile storage (disk) at each workstation serves prima-
rily as a cache to the distributed file system. The data stored in nonvolatile storage is
not lost when a machine loses power. When a user process tries to open a file, it
makes a request to the VFS which consequently checks to see if the file is in the
cache. If it is, the VFS simply accesses the file. If not, the VFS communicates
through Venus to Vice, which retrieves the file from the correct server.20
       In AFS-1 and AFS-2, the cache was updated only at the file level—block
updates were not possible. This guaranteed that users working locally on a file
would not have to wait long for network access once the file was open. AFS-3 was
also upgraded to support block-level caching, which allows large files to be manipu-
lated by clients with small caches.
       In AFS-1, each time the VFS tried to open a cached file it would have Venus
contact the server to make sure that the file was still valid. This generated many net-
work calls, even when files had not been modified. In AFS-2 and AFS-3, the server
becomes responsible for ensuring each client has the most up-to-date copy of its
riles. Each server keeps track of the files that clients cached. Each time a client
closes a file, Venus flushes it to Vice, so the server always keeps the most up-to-date
copy of the files. When a file is flushed to Vice, the server performs a callback to cli-
ents that have that file cached. When a client receives a callback, it knows that its
cached version is no longer valid and requests the newest version from the server.
       In AFS-1 the server had one process listening on a dedicated port for connec-
tion requests. Upon connection, this process would fork another process to handle
the Vice functions for the duration of the client's session. Because processes on dif-
ferent machines cannot share main memory, all shared data had to be written to the
server's local file system. Furthermore, servers suffered performance problems due
to the time associated with the context switches that were required to service differ-
ent clients. In AFS-2 and AFS-3 there is one dedicated process that services all cli-
ent requests. This process spawns a separate thread for each client and allows all
state information to be loaded into virtual memory. Because the state information
tends to be small for each client, it can generally be held in main memory. This elim-
inates context switches and allows interthread communication through shared
memory. The RPC mechanism is incorporated into the thread package to further
 improve performance. 21
       The overall AFS structure also changed with each revision. In AFS-1 different
subtrees were divided among different servers, which were known as the custodi-
ans. Each server also had a directory that would allow Vice to direct requests for
different subtrees to different servers. Venus located resources based on pathname.
 This had several drawbacks—resolving an entire path could generate multiple calls
to Vice and could span multiple custodians. AFS-2 introduced volumes to manage
subtrees. Volumes are primarily of administrative value, allowing replication and
 isolation of certain subtrees, and are transparent to users. Generally each user is

<!-- pág. 877 -->

824 Distributed Systems and Web Services

                             assigned a volume. Making the idea of volumes concrete also allowed the imple-
                             mentation of file identifiers (fids) in Venus. A fid specifies a volume, an index within
                             a volume and an identifier to guarantee object uniqueness within a volume. The
                             AFS-2 implementation of Venus resolved filenames in this manner, which simpli-
                             fied file lookups and allowed the renaming of directories. Each server had a direc-
                             tory to allow it to find volumes on any other server. AFS-3 was designed to be a
                             large distributed file system. In fact, one continuous AFS-3-based namespace
                             spanned multiple geographically distant universities in the United States. Obvi-
                             ously, there cannot be centralized administration of such a file system as each uni-
                             versity typically has its own managerial requirements. Therefore, AFS-3 introduced
                             cells, which preserve namespace continuity while allowing different systems admin-
                             istrators to oversee each cell.22, 23
                                    The security of AFS is much stronger than that of earlier versions of NFS, par-
                             tially due to the underlying RPC structure. Because AFS is designed to grow to ser-
                             vice many computers, its designers decided that it would not be safe to trust the
                             network or any client. Therefore, every RPC is encrypted and must be authenti-
                             cated. In AFS-1 and AFS-2 the permissions of a given user are related to the per-
                             missions of each group to which the user belongs. In AFS-3 permissions must be
                             specified individually. Upon system login, users must specify a password. Vice sends
                             the encrypted password to an authentication server, which responds with tokene.
                             Secure RPCs use these tokens to provide secure communication. File access is gov-
                             erned by access control lists (ACLs). Section 19.4.3, Access Control Mechanisms,
                             discusses ACL in detail. Each user is allowed to perform certain operations on cer-
                             tain files. Authentication is guaranteed by matching the credentials on each token to
                             the permitted operations in the ACL. 24


                             18.2.4 Coda File System
                             AFS is scalable, indeed able to service thousands of computers, but it has one large
                             drawback—it is not fault tolerant. The crash of one server or disruption of network
                             service can render hundreds of computers inoperable. To deal with this, the design-
                             ers of AFS began research on Coda in 1987.25
                                    Coda is derived from AFS-2. As in AFS-2, Coda uses local nonvolatile storage
                             (e.g., disks) as file caches, and Vice uses callbacks to keep clients up to date. Vol-
                             umes are the basic division in the file system and Coda performs file lookups in the
                             same way as AFS-2. The goal of fault tolerance led to the addition and modification
                             of several of AFS's features, including the idea of a volume.26
                                    In Coda, volumes are logical pieces of the file system and are replicated phys-
                             ically across multiple file servers. Servers that hold the same volume are known as a
                             volume storage group (VSG). Although the multiple servers are transparent to
                             users, the Venus process on each client periodically probes the VSGs of each of its
                             volumes. The members of the VSG with which the client can connect and communi-
                             cate are known collectively as the client's available volume storage group (AVSG)
                             (Fig. 18.3). Coda uses AVSGs to implement fault tolerance. 27

<!-- pág. 878 -->

                                                                                    18.2      Distributed   File   Systems   825




Figure   18.3   |   Coda volume structure.

       When a client process tries to read a file, its request is directed to the local
VFS. If the file is in cache, then the read continues as in AFS-2. Otherwise, Venus
contacts a member of the AVSG known as the preferred server (PS). Venus down-
loads a copy of the file from the PS and downloads file version information from
each member in the AVSG. If the versions on each server agree, then the client is
allowed to use the file. If the versions from different servers do not agree, then the
calling process aborts and the outdated copies are updated. After the members of
the AVSG have been updated, the requesting client downloads a copy of the file.
Note that if the PS or any member of the AVSG crashes, the client can still operate,
 whereas in AFS-2 the client would be stuck.28
       Upon closing a file, Coda clients write a copy of the file to each member of the
  AVSG The write occurs in two steps using the Coda Optimistic Protocol. The first
step, COP1, writes the file as we have discussed. The second step, COP2 writes an
update set, which specifies the members of the AVSG that have successfully per-
formed the COP1, to each of the members of the AVSG. If any of the members are
not in the update set, it is assumed that they have not updated (even if they have
and their reply was lost) and this is noted to remind the system to update them the
next time communication is established. To decrease write delays, COP2 messages
 are performed asynchronously and are appended on future COPf messages. If
 other clients have a copy of the file in cache, then servers will have to perform
callbacks.29
       These operations will provide a consistent view of a file within an AVSG.
When a file is opened, it will be the same as the last copy that was written to Coda.
 However, Coda's replication scheme is optimistic, which means it assumes that files
  in different AVSGs are consistent and it allows clients to access and modify such
 files. This guarantees that files will always be available, but it might lead to inconsis-
 tencies and the loss of work.

<!-- pág. 879 -->

826 Distributed Systems and Web Services

                                   We now discuss Coda's replication scheme and potential consistency issues.
                             Consider a VSG and two clients whose AVSGs are mutually exclusive (Fig. 18.4). It
                             is possible for each client to download, modify and upload the same copy of a file to
                             its AVSG. Now the view of that file within the VSG will not be consistent.
                                    Coda provides some mechanisms to fix inconsistencies. If the file in conflict is
                             a directory, the Coda servers deal with the problem. Each member of the VSG
                             locks the volume that holds the document and one is designated the leader. Logs of
                             the transactions of each server are sent to the leader, which combines the logs and
                             redistributes them. Based on the logs, each server updates its view of the directory.
                             Finally, the volumes are unlocked.
                                   When Coda clients are connected to Coda, they enter a stage called the
                             hoarding stage, where they prepare for a possible disconnection from the system by
                             caching any requested files. When the client becomes disconnected, it enters the
                             emulation stage, during which all file read requests are serviced from the cache. The
                             files could be stale, but the system is still operable. If the user tries to access a file
                             that is not in cache, the system reports an error. Writes during the emulation stage
                             occur in two steps. First, the file is updated on disk. Second, the client modifkation
                             log (CML) is updated to reflect file changes. Venus modifies the CML so that when
                             a log entry is undone by a later entry, the earlier log entry is removed. The CML
                             also facilitates updates during the reintegration stage. Reintegration occurs imme-
                             diately after the client reconnects to the system when Venus asynchronously
                             updates the server using the CML. 30
                                   A client may become disconnected for several reasons: All of the servers in a
                             VSG could crash, a network connection could be faulty or the user could intention-
                             ally disconnect from the network. Coda handles each of these cases in the same
                             way, and the transition between connected and disconnected states is transparent.




                            Figure 18.4 | File consistency issues in mutually exclusive AVSGs.

<!-- pág. 880 -->

                                                                                     18.2      Distributed   File   Systems   827

This makes Coda particularly attractive for the growing number of mobile comput-
ers, and it is one of the primary reasons that Coda is still undergoing improvement.

Self Review
1. In Coda, if client A and client B belong to the same AVSG, does it imply that they belong
   to the same VSG? If client A and client B belong to the same VSG, does it imply that they
   belong to the same AVSG?
2. What is the problem with Coda's replication scheme?
Ans: 1) If client A and client B belong to the same AVSG, then they belong to the same
VSG. If client A and client B belong to the same VSG, then they may not belong to the same
AVSG. 2) Coda's replication scheme provides a consistent view of a file within an AVSG but
does not guarantee consistency within the VSG. Coda's replication scheme assumes that files
in different AVSGs are consistent and allows clients to access and modify such files within
different AVSGs, which causes inconsistency within the VSG.



18.2.5 Sprite File System
In Chapter 17, we overviewed the Sprite operating system. This section focus on the
Sprite file system. A primary goal for the Sprite file system was transparency.
Sprite's developers attained a better level of transparency than that offered by NFS,
AFS or Coda. A second goal was to implement complete consistency.31
      The Sprite file system has the perceived form of a UNIX file system. Unlike
NTS or Coda, however, it gives every client the exact same view of the hierarchy.
The Sprite file system also goes one step further in UNIX file system emulation by
allowing transparent remote access to I/O devices (which are represented as files in
UNIX). Although hidden from the user, the Sprite file system is divided into
domains. Each domain represents a piece of the global file hierarchy and is stored
at one server (Fig. 18.5). Except for the domain at the top of the global file hierar-
chy, the root of one domain is the deepest child of another. 32




 Figure 18.5 | Sprite file system domains.

<!-- pág. 881 -->

828 Distributed Systems and Web Services

                                   The kernel of each client keeps a private copy of a prefix table, which stores
                             domain information to aid in file lookups (Fig. 18.5). Each entry in the table repre-
                             sents a separate domain and consists of the absolute path to the root directory
                             within the domain, the server that houses the domain and a token that identifies the
                             domain. To look up a file, a client takes an absolute pathname and locates the long-
                             est matching prefix within the prefix table. If no such prefix can be found, the client
                             broadcasts a request to every server. The server that houses the domain that
                             matches the path responds with information to populate the client's prefix table,
                             and the client continues. The client then removes the matched prefix from the name
                             and sends what is left to the indicated server along with the domain identification
                             token. The server resolves the name within the specified domain and returns a
                             token pointing to the requested file. If the resolution cannot be completed because
                             the path spans multiple domains, the server returns the pathname of the new
                             domain and the client repeats the process. Sprite processes that access files keep the
                             server address and token identifying the domain of the working directory as part of
                             their state. Processes that access files via relative paths provide this state informa-
                             tion in addition to the relative path to allow servers to resolve the entire path. 33
                                   In Sprite, both the client and the server keep a cache in main memory. To
                             open a file, the client first checks its cache. If the file is not in the client's cache, the
                             client then makes a request to its backing store (which is generally a server). If the
                             server is unable to satisfy the request from its cache, it reads the data in from disk
                             (Fig. 18.6, step a). The server then stores the data in its cache and passes the data t<
                             the client. The client retains a copy of the data in its cache as well (Fig. 18.6, step b).
                             When a client writes a block, it writes into its cache. Sprite flushes updated pages to
                             the server every 30 seconds though the cache management algorithm may choose to
                             flush the page sooner. The page will then remain in the server's cache for 30 seconds
                             before it is flushed to disk (Fig. 18.6, step c).
                                   The lazy write-back strategy was chosen to trade an increase in performance
                             for a decrease in fault tolerance. As in UNIX systems, modified pages in a cache will
                             be lost during a crash if they have not been flushed to the server.34
                                   Sprite's complete consistency is achieved by its caching protocols. The clients
                             may have inconsistent versions of a file if two or more clients have a copy of the file
                             in cache and at least one client is modifying its copy. This can be divided into two
                             cases: sequential write-sharing and concurrent write-sharing. Sequential write-shar-
                             ing occurs when one client modifies a file then another client tries to read or write
                             its own cached copy of the file. To guarantee the highest level of consistency, before
                             a client opens a file it contacts the server and requests the version of that file. If the
                             file on the server is newer than the cached version, the client removes the file from
                             cache and downloads the version from the server. To ensure that delayed write-
                             backs do not hinder this algorithm, the server keeps track of the last client that
                             writes a file. On receiving a read request, the server forces the last client that modi-
                             fies the file to flush all modified pages to disk immediately, before servicing the
                             request. Concurrent write-sharing occurs when two clients modify cached copies of

<!-- pág. 882 -->

                                                                                    18.2 Distributed File Systems 829




Figure 18.6 | Reading and writing in the Sprite file system.

the same file at the same time. To ensure consistency, Sprite disables caching of that
file for all clients. Reads and writes are sent directly to the server, and the state of
the file therefore appears the same to all clients.
       Note that although each client will have a consistent view of the file, there could
be synchronization issues associated with this algorithm. Sprite provides locking sys-
tem calls for applications that cause the inconsistency. This solution also hinders file
system performance. The developers of Sprite justified their implementation by
observing that concurrent write-sharing is rare.35
       Cache (in main memory) and virtual memory contend for the same system
resources in Sprite—physical memory. Whereas devoting a large portion of physical
memory to the virtual memory system increases processing efficiency, devoting a
large portion to cache increases network and file system efficiency. Furthermore,
some applications rely heavily on virtual memory while others rely on the file sys-
tem. Sprite allows its cache size to vary dynamically to deal with these issues. Physi-
cal memory pages are divided into two sets, a set for cache and a set for virtual
memory. The replacement algorithm for each set uses the age of the pages as a
guideline for removal when new pages must be swapped in. The set that has the
older page loses that page to the set that is swapping in a new page. For example,
consider the situation where 16 pages of physical memory are devoted to cache, 16
pages are devoted to virtual memory and one of the virtual memory's pages is the

<!-- pág. 883 -->

830 Distributed Systems and Web Services

                             oldest of all 32 pages. If a process tries to bring a page into cache, the oldest virtual
                             memory page is removed and the cache is then allocated 17 total pages.
                                   This introduces a subtle point of inefficiency. What happens if a page is in both
                             virtual memory and cache? Clearly the system is wasting space. To avoid this, vir-
                             tual memory writes directly to the server when updating files.
                                   We have seen that Sprite is more concerned with performance than with fault
                             tolerance. This point is strengthened when considering how Sprite deals with server
                             crashes. Sprite does not use replication servers. Instead, in the hope that crashes
                             would be infrequent, Sprite's designers implemented a server that would recover
                             quickly from crashes. To do this they placed the burden of state control on the cli-
                             ents, using a log-structured file system with checkpointing on the server (as dis-
                             cussed in Section 13.10.2). The motivation for log-based file system was to improve
                             I/O performance. When clients realize that a server has crashed, they wait until it
                             reboots and then send it information about its files that they have cached. The
                             server uses this information to rebuild its state.36

                             Self Review
                             1. How is complete consistency achieved in sequential write-sharing?
                             2. What problem might result from placing the burden of state control on the clients? Pro-
                                pose a solution to this problem.
                            Ans: 1) Sequential write-sharing occurs when one client modifies a file and then another ch-
                            ent tries to read or write its own cached copy of the file. Before a client opens a file, it con-
                            tacts the server and requests the version of that file. If the file on the server is newer than the
                            cached version, the client removes the file from cache and downloads the version from the
                            server. To ensure complete consistency, the server keeps track of the last client that writes a
                            file. On receiving a read request, the server forces the last client that modifies the file to flush
                            all modified pages to disk immediately, before servicing the request. 2) All of the clients will
                            bombard the server with information when it reboots, possibly swamping the network.
                            Sprite's developers built a negative acknowledgement into their implementation.This allows
                            the server to tell the client that it is busy now, but has not crashed and to come back later.




                             18.3          Multicomputer         Systems
                             As discussed in Chapter 15, multiprocessing is the use of multiple processors to exe-
                             cute separate portions of a computation in parallel. Several classes of machines are
                             generally referred to as multiprocessors, but the most popular are machines that
                             have similar or identical processors and that share a common memory. In contrast,
                             multicomputer systems do not share a common memory or bus (although they may
                             share a virtual memory). Each processing unit has access to its own resources. These
                             independent units are connected in a network to operate cooperatively to form a
                             multicomputer system. Multicomputer systems can be either homogenous or heter-
                             ogeneous. A homogeneous multicomputer system consists of computers that have
                             the same hardware, run the same operating systems and communicate across the
                             same network architectures. A heterogeneous multicomputer system consists of

<!-- pág. 884 -->

                                                                                             18.4   Clustering   831

computers that may have different hardware, run different operating systems and
communicate across different network architectures.37
      Modern supercomputers are massively parallel processing (MPP) machines
capable of hundreds of gigaflops or even teraflops. A flop is a floating point opera-
tion per second.38 Currently under construction at Los Alamos is the supercom-
puter Q which will top 100 teraflops. It will be used by scientists to simulate the
effects of aging on America's nuclear arsenal, using three-dimensional models of
explosions.39 Los Alamos scientists are also working on a low-end supercomputer
called Green Destiny built from off-the-shelf components. Green Destiny provides
160 gigaflops of computing power using 100Base-T Ethernet and 240 667-mega-
hertz Transmeta Corp. processors.40 Green Destiny is a multicomputer system.
      Another method of implementing a multicomputer system is with grid com-
puting which uses middleware that can run like an application on a general-purpose
computer. Distributed.net pioneered academic distributed computing over the
Internet by having users download an application which performed operations on
their own computers. 41 Today there is also SETI@Home, which uses volunteers'
computers to process data collected by the Search for Extraterrestrial Intelligence
project. Intel, United Devices, and the American Cancer Society have created a
screensaver software that performs calculations to aid in pharmaceutical research. 42
  Companies such as United Devices are developing software and hardware pack-
ages to create enterprise computer grids which will allow organizations to leverage
unused processor cycles on their networks to handle computer-intensive tasks. We
discuss such grid computing in Section 18.6, Grid Computing.
      Distributed processing makes large computations feasible. However, this
power comes at the cost of simplicity. Just as in uniprocessing environments, distrib-
uted processing must take into account synchronization, mutual exclusion and
deadlock. Networking and the lack of shared memory make managing such issues
more complex.


Self Review
1. Distinguish multiprocessing and multicomputer systems.
2. What makes distributed processing difficult to implement?
Ans: 1) With multiprocessing, processors share a common memory. Multicomputer systems
do not share a common memory—each processing unit has access to its own resources. 2) Dis-
tributed processing must take into account synchronization, mutual exclusion and deadlock.
Networking and the lack of shared memory make managing such issues more complex.




18.4        Clustering
Recall that in a distributed system, several computers handle user requests simulta-
neously. Each computer processes user requests independently. However, the dis-
tributed system must handle communication delays introduced by its underlying
networks. Multiprocessing fixes the communication delays by allocating many pro-

<!-- pág. 885 -->

832 Distributed Systems and Web Services

                             cessors for one computer, making the communications among processes easier and
                             faster. Yet, multiprocessing has its own disadvantages: high cost/performance ratio,
                             limited scalability and not all types of applications running on a system benefit from
                             multiprocessing.43
                                   Clustering—interconnecting nodes (single-processor computers or multiproces-
                             sor computers) within a high-speed LAN to function as a single parallel computer— is
                             architecturally intermediate between distributed computing and multiprocessing. The
                             set of nodes that forms the single parallel machine is called a cluster. Clustering
                             enables multiple computers to work together to solve large and complex problems.44

                            Self Review
                             1. What is clustering?
                             2. Why would clustering be employed?
                            Ans: 1) Clustering interconnects nodes within a high-speed LAN to function as a single
                            parallel computer. 2) Clustering takes advantage of multiprocessing and distributed systems
                            while eliminating the communication delays associated with fully distributed systems, provid-
                            ing a powerful computer that is capable of solving large and complex problems.


                             18.4.1   Clustering     Types
                            There are three major types of clusters. In a high-performance cluster, all of the
                            nodes in the cluster are used to perform work. In a high-availability cluster, some of
                            the nodes perform work while others serve as backups. If working nodes or their
                            components fail, the backup nodes start running and take over the jobs that were
                            being executed on the failed nodes immediately without interrupting service. In a
                            load-balancing cluster, a particular node works as a load balancer to distribute the
                            load (such as thousands of requests from the clients) to a set of nodes so that all
                            hardware is efficiently utilized.45
                                  High-performance clusters are used for solving large-scale computations that
                            can be divided into smaller problems to be solved in parallel. High-availability clus-
                            ters are used for mission-critical applications in which failure must be avoided.
                            Load-balancing clusters benefit organizations that handle large volumes of user
                            requests. For example, high-performance clusters are useful for analyzing images
                            from Magnetic Resource Imaging (MRI) scanners, while high-availability clusters
                            are crucial in aircraft control systems and load-balancing clusters are usually used in
                            e-business applications with high user volumes.

                            Self Review
                            1. Does a high-availability cluster require that its nodes be working all the time?
                            2. Argue why a cluster for a particular type of application should have the attributes of all
                               three types of clusters. Consider a search engine being used for an application where lives
                               could be at stake, such as locating organs for transplant.
                            Ans: 1) No. High-availability clusters require that only some of their nodes be working
                            while others act as backups. 2) The cluster should be high performance, because billions of

<!-- pág. 886 -->

                                                                                                 18.4 Clustering 833
Web pages would have to be searched in a fraction of a second. It should be high availability
to ensure that it is always ready to operate when needed, especially in an emergency. It
should be load balancing to spread the load in peak periods, ensuring that individual requests
are not delayed.


18.4.2 Clustering Benefits
There are several benefits associated with clustering. It economically interconnects
relatively inexpensive components. This reduces the cost for building a clustered sys-
tem compared to a single parallel computer with the same capability.46 High perfor-
mance is another advantage of clustering. Each node in the clustering system shares
the workload. Communications among nodes in the cluster are faster than those in
unclustered distributed computing systems due to the high-speed LAN between
nodes.47 Clustering can also provide replication of resources across the nodes, so that
the failure of any one computer will not affect the availability of the system's
resources. If a service on one node is down, other nodes that provide the same service
in the cluster can still function and take over the tasks performed by the failed com-
ponent.48 Clustering inherits the scalability of distributed systems. A cluster is able to
add or remove nodes (or the components of nodes) to adjust its capabilities without
affecting the existing nodes in the cluster. Clustering provides better scalability than
multiprocessing. For example, the HP 9000 Superdome can have up to 64 processors,
while the HP XC clusters can scale up to 512 processors.49'50 Clustering achieves reli-
ability and fault tolerance by providing backups for the services and resources. When
failure occurs in one running service, the cluster immediately switches the process to
the backup service without affecting the performance and capacity of the system, pro-
viding uninterrupted service.51

Self Review
1. Why is communication among nodes in a cluster faster than among nodes in an unclus-
   tered distributed computing system?
2. How does clustering implement fault tolerance?
Ans: 1) The reason is that a high-speed local area network is generally faster than the wide
area networks used in distributed systems. 2) Clustering provides backups for services and
resources.


18.4.3 Clustering Examples
In this section, we consider how clustering is implemented in Linux and Windows.
Many Linux clustering solutions are available, the best known being Beowulf, a
nigh-performance cluster.52 In 1994, the NASA Earth and Space Sciences (ESS)
project built the first Beowulf cluster to provide parallel computing to address
large-scale problems involved in ESS applications. Figure 18.7 shows a typical
Beowulf cluster. A Beowulf cluster may contain up to several hundred nodes. Theo-
retically, all nodes have Linux installed as their operating system and they are inter-
connected with high-speed Ethernet (often with a bandwidth of 100 Mbps). Each

<!-- pág. 887 -->

834 Distributed Systems and Web Services




                            Figure 18.7 | Typical Beowulf cluster.

                             Beowulf cluster has a head node (also called a master node) that acts as a server to
                             distribute the work load, control access to the cluster and handle the shared
                             resources. All other nodes in the cluster are often called slave nodes. The head node
                            usually has a monitor and keyboard, while slave nodes do not. All slave nodes
                            should be configured with the same processor, memory and disk space so that all
                            nodes can complete the same job at approximately the same time. Usually, all the
                            nodes in the cluster are connected within a single room to form a supercomputer. 53
                                   Windows Server 2003 can be used to build both high-availability clusters and
                            load-balancing clusters. A high-availability cluster built with Windows Server 2003
                            can have at most eight nodes. All its nodes may share a storage device (Fig. 18.8) or
                            each node may have a local storage, in which case the backup node must keep the
                            exact same data (Fig. 18.9). Unlike the Beowulf cluster, the nodes in the high-avail-
                            ability Windows cluster can be connected either in a LAN or a WAN. In the case of
                            shared storage, only one node is running at a time and that node has the control of
                            the shared storage. When the running node fails, a backup node takes over control
                            of the shared storage. However, if the shared storage breaks down, the entire clus-




                           Figure 18.8 | High-availability cluster with shared storage.

<!-- pág. 888 -->

                                                                                          18.4   Clustering   835




Figure 18.9 | High-availability cluster with local storage.

ter cannot keep running. When each node has its own storage, more than half of the
cluster nodes must be active at all times so that when one or more nodes fail, other
nodes can continue work effectively. For example, if the cluster has eight nodes, at
least five of them must be active and ready to function.54
       A load-balancing cluster built with Windows Server 2003 can have at most 32
nodes (Fig. 18.10). The cluster does not require sharing storage, because each node
can do its job independently. If one node fails, the remaining nodes in the cluster
are still capable of handling user requests. Scalability is achieved with the load-bal-
ancing cluster, because it is easy to add or remove a node from the cluster. Usually
the nodes in the load-balancing cluster are interconnected with high-speed Ether-
net.55


Self Review
1. List three characteristics that make Beowulf clusters high-performance.
2. What problem does the high-availability cluster with shared storage have?




Figure 18.10 | Load-balancing cluster with 32 nodes.

<!-- pág. 889 -->

836 Distributed Systems and Web Services

                            Ans: 1) All nodes in the Beowulf cluster are interconnected with high-speed Ethernet
                            (often with a bandwidth of 100 Mbps). All nodes can complete the same job approximately at
                            the same time. All nodes work together in parallel to improve performance. 2) All nodes
                            depend on the shared storage. If the shared storage fails, the entire cluster fails.




                             18.5 Peer-to-Peer Distributed Computing
                             In a peer-to-peer (P2P) application, each peer—a single computer in the P2P sys-
                             tem—performs both client and server functions. Such applications distribute pro-
                             cessing responsibilities and information to many computers, thus reclaiming
                             otherwise wasted computing power and storage space and eliminating many central
                             points of failure. In the next several subsections we introduce the fundamental con-
                             cepts of peer-to-peer applications.



                             18.5.1 Client/Server and Peer-to-Peer Applications
                             Many network applications operate on the principle that computers should be seg-
                             regated by function. Some computers, such as servers, offer common stores of pro-
                             grams and data. Other computers, such as clients, access the data provided by the
                             servers. Using a search engine from a Web browser is an example of a client/server
                             application. Clients send queries to servers, which access various databases and
                             respond with the requested information.
                                  P2P applications are different from client/server applications because all com-
                             puters in the network act as both clients and servers. Each peer has the ability to
                             discover and communicate with other peers and may share resources (such as large
                             multimedia files) with others. P2P applications are similar to the telephone sys-
                             tem—a single user can both send and receive information.56


                            Self Review
                             1. How do client/server applications work?
                             2. List the advantages of peer-to-peer applications over client/server applications.
                            Ans: 1) In a client/server application, the client sends requests to the server, and the server
                            processes the client request, often accessing one or more databases, and sends the response
                            back to the client. 2) It is easier to set up the network for a peer-to-peer application, and no
                            network administrator is required. In a peer-to-peer application, if one peer fails, others can
                            still function well. In a client/sever application, if the server fails, the entire application fails.



                             18.5.2 Centralized vs. Decentralized P2P Applications
                             P2P applications can be implemented in two forms: centralized and decentralized.57
                             A centralized P2P application uses a central server system that connects to each
                             peer. Centralized P2P applications are similar to the client/server relationship. In a

<!-- pág. 890 -->

                                                                             18.5 Peer-to-Peer Distributed Computing 837




Figure   18.11   |   Centralized   P2P   instant-messenging   application.




centralized instant messenging application (Fig. 18.11), when peer 1 wants to talk to
peer 3, peer 1 must get the address of peer 3 from the server first. Then peer 1 com-
 municates with peer 3 directly. One major weakness of this centralized system is the
dependency on the server. If one or more central servers fail, the entire network
could fail. The server's capabilities limit the application's overall performance. For
 instance, Web sites can fail when malicious users overload the Web server(s) with an
excessive number of requests. However, centralized architectures also have advan-
tages, such as simplifying management tasks (e.g., monitoring user access by provid-
ing single points of network control).
       A pure P2P application, also called a decentralized P2P application, does not
have a server and therefore does not suffer from the same deficiencies as applica-
tions that depend on servers. In a pure P2P instant messenger application
(Fig. 18.12), when peer 1 wants to send a message to peer 3, peer 1 no longer needs
to communicate with the server. Instead, peer1 discovers peer3 via distributed
search mechanisms and sends messages to peer3 directly. If a peer in a well-
designed, pure P2P system fails, all other peers continue to function, so such sys-
tems are particularly fault tolerant.
       Peer-to-peer applications have disadvantages as well. Anyone with the appro-
priate software can join the network of peers and often remain anonymous, so
determining who is on the network at any moment is difficult. Also, the lack of a
server hinders the protection of copyright and intellectual-property rights. Real-
time searches can be slow and increase network traffic, as queries propagate
throughout the network. 58 Figure 18.13 lists some common peer-to-peer applica-
tions.

<!-- pág. 891 -->

838 Distributed Systems and Web Services




                             Figure 18.12 | Pure P2P instant-messenging application.

                              Distributed
                              Application    Description
                              Gnutella       A P2P technology used to share documents on the Internet. Gnutella
                                             does not use any servers. There is no authentication, and peers search for
                                             files via a distributed search mechanism.59 (Section 18.5.3, Peer Discovery
                                             and Searching, overviews this mechanism.)
                              KaZaA          A file sharing application that is a hybrid between Gnutella and central-
                                             ized applications. A server authenticates all users. Certain peers serve as
                                             search hubs, which catalog the files of peers connected to them.
                                             Searches are distributed to each search hub, which then responds with
                                             results that allow direct connections for file transfers.60
                              Groove         A P2P system that allows users to communicate, collaborate and share
                                             documents on the Internet and intranet. Groove provides secure commu-
                                             nication because users are authenticated and private data is not shared
                                             with third parties.61
                              Freenet        Decentralized P2P technology that allows users to share documents on
                                             the Internet without fear of censorship. Freenet does not have a central
                                             server to govern access. Instead, access to Freenet is anonymous. Docu-
                                             ments stored in Freenet are encrypted to improve protection.62
                              Instant        P2P application that enables users to send short text messages and files
                              messenging     to one another. Most instant messengers use servers that authenticate all
                                             users and route messages between peers.

                             Figure 18.13 | Common P2P applications.

                                  Pure peer-to-peer applications are completely decentralized. Some file shar-
                             ing applications are not pure peer-to-peer, because they use servers to authenticate
                             users and index each peer's shared files. However, peers connect directly to one

<!-- pág. 892 -->

                                                                          18.5 Peer-to-Peer Distributed Computing 839
another to transfer files. In such a system, centralization improves search perfor-
mance but makes the network dependent on a server. Performing file transfers
between peers decreases the load on the server.

Self Review
1. What are the advantages of centralized P2P applications?
2. What is a benefit of a decentralized P2P application over a centralized one?
Ans: 1) Centralized P2P applications simplify management tasks, such as monitoring user
access by providing single points of network control. 2) Centralized P2P applications rely on
a server for certain operations. If the server fails, those operations will be unavailable.


18.5.3 Peer Discovery and Searching
Peer discovery is the act of finding peers in a P2P application. Pure P2P applications
often suffer slow peer discovery and information searching due to the lack of a
server. There is no general solution to peer discovery. Gnutella presents one
approach for circumventing these problems. Gnutella is a pure peer-to-peer tech-
nology that enables distributed information storage and retrieval. Users can search
for and download files from any peer on the network. Users first join a Gnutella
network by specifying the network address of a known Gnutella peer. Without
knowing at least one peer on the network, a user cannot join the network. Each
user's Gnutella software functions as a server and uses the HTTP protocol to search
for and transfer files.63
      To perform a search, a peer sends search criteria to the peers connected to it.
Those peers then propagate the search throughout the network of peers. If a partic-
ular peer can satisfy the search, that peer passes this information back to the origi-
nator. The originator then connects directly to the target peer and downloads the
information. The peer that made the original query can identify itself only when it
connects directly to the peer with the requested file to begin file transfer.
      In the Gnutella network, a peer forwards a search request to all of its directly
connected peers in parallel. For example, if P1 receives a request from the user, P1
forwards the search request to all its directly connected peers first. These peers then
work in parallel; each one tries to fulfill the search request and also forwards the
request to its directly connected peers.
      In the Freenet P2P application, each peer forwards a search request to a single
directly-connected peer at a time. For example, if P1 receives a request from the
user, P1 forwards the search request to P2 which is one of its directly connected
peers. If P 2 cannot answer the request, it forwards the request to one of its directly
connected peers. If all the nodes that P2 can reach cannot answer the request, P1
then forwards the search request to another one of its directly connected peers.64
      Searches conducted in both Gnutella and Freenet are called distributed
searches. Distributed searches make networks more robust by removing single
points of failure, such as servers. Not only can peers find information in this way, but
peers can search for other peers via distributed searches as well.

<!-- pág. 893 -->

840 Distributed Systems and Web Services

                              Self Review
                              1. What are some of the problems with distributed searches?
                              2. Compare Gnutella's distributed search mechanism to Freenets.
                              Ans: 1) Distributed searches are costly, possibly generating enormous amounts of network
                              traffic. If poorly implemented P2P systems proliferate, this could have serious ramifications
                              on the performance of the entire Internet. Distributed searches do not guarantee to find the
                              requested files. 2) Searches in Gnutella will reach close peers before reaching any more dis-
                              tant peers. In Freenet, a search can reach a distant peer before all close peers have been
                              searched.



                               18.5.4 JXTA
                               Sun Microsystems, Inc., created Project JXTA (short for Juxtapose) in response to
                               the growing popularity of peer-to-peer applications. Project JXTA strives to create
                               a standard, low-level, platform and language-independent protocol that promotes
                               interoperability among peer-to-peer applications. The current JXTA implementa-
                               tion is written in Java, but developers can implement JXTA in any programming
                               language. JXTA provides a foundation on which developers can build any type of
                               P2P application.
                                     JXTA attempts to solve the following problems of peer-to-peer applications:65
                                     1. Security/authentication —Large peer-to-peer network applications, such as
                                        AOL Instant Messenger (AIM) and MSN Instant Messenger, use servers
                                        to bootstrap users onto the network. 66 This bootstrapping ensures that the
                                        same person uses a particular online identity.
                                    2. Peer discovery—Without a server, it is complex to locate other peers on the
                                       network.
                                    3. Network incompatibility—Currently, each popular peer-to-peer applica-
                                       tion has a set of proprietary protocols that are incompatible with other
                                       peer-to-peer networks due to the lack of standards. For example, users on
                                       the AIM platform cannot communicate with MSN Instant Messenger users.
                                    4. Platform incompatibility—Software developers must rewrite the low-level
                                       core aspects of their peer-to-peer applications for each platform they wish
                                       to support. Wireless phones and other mobile devices usually have a lim-
                                       ited selection of P2P applications, if any.
                                    JXTA attempts to solve these problems by standardizing the low-level proto-
                              cols that govern peer-to-peer applications. All JXTA-based P2P applications use
                              identical low-level protocols, hence they are compatible with one another.
                                    Networks built with the JXTA protocols consist of three basic types of enti-
                              ties—peers or peer groups, advertisements and pipes. A peer is any entity that uses
                              JXTA protocols (Fig. 18.14) to communicate with other peers. Each peer need sup-
                              port only some of the protocols, so devices with low processing power and memory
                              can still participate in JXTA networks (albeit with limited functionality). Peer

<!-- pág. 894 -->

                                                                           18.5 Peer-to-Peer Distributed Computing 841

 Protocol                  Function
 Peer discovery            Peers use this protocol to find other entities in the JXTA net-
                           work by searching for advertisements.
 Peer resolver             Peers that help a search process (e.g., send and process
                           requests) implement this protocol.
  Peer information         Peers obtain information about other peers via this protocol.
 Peer membership           Peers use this protocol to learn about the requirements of
                           groups, how to apply for membership, how to modify their
                           membership and how to quit a group. Authentication and
                           security are implemented through this protocol.
  Pipe binding             Peers can connect pipes to one another, via advertisements,
                           through this protocol.
  Endpoint routing         Peer routers implement this protocol to provide other routing
                           services to other peers (e.g., tunneling through a firewall).

Figure 18.14 | JXTA low-level protocols.67


groups are logical constructs that represent sets of peers. JXTA specifies only two
rules regarding peer groups:
      1. peers can join or leave groups, and
      2. the group administrator, if the group has one, controls access to the group.
 Advertisements are XML documents formatted according to JXTA specifications
that are used by a peer to advertise itself and notify others of its existence. Pipes are
virtual communication channels that connect two or more peers for sending and
receiving messages among peers. At the simplest level, pipes are one-way communi-
cation channels. Two peers communicate by configuring two pipes that "flow" in
 opposite directions. When a source peer needs to send a message to a destination
peer, a pipe is dynamically bound to the two peers. Once the pipe is set up, the
source peer can send messages to the destination peer via the pipe.
      Examples of P2P applications that uses JXTA are: VistaPortal
 (www.vistaportal.com/), Momentum by InView Software (www.inviewsoft-
  ware.com/news/20030305_momentuml.htm) and ifreestyle by Digital Dream
(www.digitaldream.jp/en/). 6 8



Self Review
1. How do AOL Instant Messenger and MSN Instant Messenger bootstrap users onto the
   network?
2. How do peers communicate in networks built with the JXTA protocol?
Ans: 1) Both AOL Instant Messenger and MSN Instant Messenger use central servers to
bootstrap users onto the network. 2) Peers use one-way communication channels called pipes
to exchange messages.

<!-- pág. 895 -->

842 Distributed Systems and Web Services

                             18.6 Grid Computing
                             A few decades ago, the number of computers was relatively small, their computing
                             power was modest and they were expensive and heavily utilized. With the advent of
                             the microprocessor, there are now hundreds of millions of inexpensive, relatively
                             powerful computers in homes and businesses. However, a vast amount of comput-
                             ing power is wasted (e.g., personal computers at home sit idle while people are at
                             work, and work computers sit idle while people are at home). Grid computing links
                             potentially vast numbers of computational resources (such as computers, storage
                             devices and scientific instruments) that are distributed over a network to solve com-
                             plex, massive, computation-intensive problems.
                                       As in other distributed systems, the resources in grid computing are distrib-
                             uted, and users can access them transparently. While clustering typically is localized
                             or centralized, grid computing emphasizes public collaboration. Individuals and
                             research institutes participating in grid computing coordinate resources that are not
                             subject to centralized control. High performance, the goal of grid computing. is
                             achieved by using spare computer power at little or no cost. Grid computing offers
                             better scalability than clusters. For example, the SETI@home project, which is dis-
                             cussed later, runs on half-a-million PCs while an HP XC cluster runs on up to 512
                             nodes. Grid computing requires sophisticated software to manage distributed com-
                             puting tasks on such a massive scale.69-70-71
                                       To enable interoperability of heterogeneous distributed resources, a grid-com-
                             puting system is often divided into five layers. The application layer, which is the
                             highest level, contains applications that use the lower layers to access distributed
                             resources. The collective layer is responsible for coordinating distributed resources,
                             such as scheduling a task to analyze data received from a scientific device. The
                             resources layer enables applications to request and share a resource. The connectiv-
                             ity layer carries out reliable and secure network communications between
                             resources. The fabric layer accesses physical resources, such as disks.72
                                       The SETI@home (Search for Extraterrestrial Intelligence at home) project
                             ( s e t i a t h o m e . s s l . b e r k e l e y . e d u / ) is a popular grid-computing implementation
                             SETI@home enables individuals to participate in a scientific effort seeking intelli-
                             gent life elsewhere in the universe. Computers belonging to participants, when not
                             in use, download data representing signals from outer space from the SETI@home
                             server, analyze the data and return the results to the SETI@home server.73, 74
                                       The Globus Alliance (www.globus.org/), based at Argonne National Labo-
                             ratory, the University of Southern California's Information Sciences Institute, the
                             University of Chicago, the University of Edinburgh and the Swedish Center for
                             Parallel Computers, researches grid-computing resource management and develops
                             software (called the Globus Toolkit) to implement grid computing.75 United
                             Devices (www.ud.com) provides grid-computing solutions for businesses.76

                            Self Review
                             1. What makes grid computing a promising trend?

<!-- pág. 896 -->

                                                                                 18.7 Java Distributed Computing 843
2. Why is the grid-computing system divided into several layers?
Ans: 1) Grid computing helps coordinate distributed resources and allows access to poten-
tially massive amounts of computing resources, enabling complex problems to be solved that
usually cannot be approached without enormous computing powers. 2) Distributed resources
are typically heterogeneous, so the layered architecture enables interoperability and modu-
larity.


18.7 Java Distributed Computing
Java is used widely to implement distributed systems. We discussed developing dis-
tributed systems using Java's RMI in Section 17.3.3, and CORBA in Section 17.3.4.
Sun provides an article about CORBA and Java at java.sun.com/j2ee/corba/.
The following subsections introduce several additional Java technologies that
enable developers to build distributed systems and to share and manage distributed
resources.

18.7.1 Java Servlets and JavaServer Pages (JSP)
Java provides a number of built-in networking capabilities that make it easy to
develop Internet-based and Web-based applications. This section focuses on both
sides of a client-server relationship which is the foundation for the highest-level
views of networking in Java, namely servlets and JavaServer Pages (JSP). A servlet
extends the functionality of a server, most frequently a Web server. Using special
Syntax, JSP allows Web-page programmers to create pages that use encapsulated
Java functionality and even to write scriptlets (Java code embedded in a JSP) of
actual Java code directly in the page. 77
      A common implementation of the request-response model is between Web
browsers and Web servers that interact via the HTTP protocol. When a user
accesses a Web site by means of a browser (the client application), a request is sent
to the appropriate Web server (the server application). The server normally
responds to the client by sending the appropriate HTML Web page. Servlets
enhance the functionality of Web servers to provide capabilities such as secure
access to Web sites, interacting with databases on behalf of a client, dynamically
generating custom documents to be displayed by browsers and maintaining unique
session information for each client.
      In some ways, JSPs look like standard HTML or XML documents. In fact,
JSPs normally include HTML or XML markup. Such markup is known as fixed-
template data or fixed-template text. JSPs are generally used when most of the con-
tent sent to the client is static text and markup, and only a small portion of the con-
tent is generated dynamically with Java code. Servlets are commonly used when a
small portion of the content sent to the client is static text or markup. In fact, some
servlets do not produce content. Rather, they perform a task on behalf of the client
(such as a database query), then invoke other servlets or JSPs to provide a
response. Note that in most cases servlet and JSP technologies are interchangeable.
The server that executes a servlet is referred to as the servlet container or servlet

<!-- pág. 897 -->

844 Distributed Systems and Web Services

                               engine. JSPs are translated into servlets by the servlet container, which then com-
                               piles and executes them. 78
                                     Many developers believe that servlets are appropriate for database-intensive
                               applications that communicate with so-called thin clients—applications that require
                               minimal client-side support. With these applications, the server is responsible for
                               database access and clients connect to the server using HTTP. Thus, the presenta-
                               tion-logic code for generating dynamic content can be written once and reside on
                               the server for access by clients, to allow programmers to create efficient thin clients.
                                     Sun Microsystems, through the Java Community Process, is responsible for the
                               development of the servlet and JavaServer Pages specifications. The reference imple-
                               mentations of these standards are under development by the Apache Software Foun-
                               dation (www.apache.org) as part of the Jakarta Project ( j a k a r t a . a p a c h e . o r g ) . 7 9
                               As stated on the Jakarta Project's home page, "The goal of the Jakarta Project is to
                               provide commercial-quality server solutions based on the Java platform that arc
                               developed in an open and cooperative fashion." The servlet and JSP part of the
                               Jakarta Project is called Tomcat—this is the official reference implementation of the
                               JSP and servlet standards. The most recent version can be downloaded from the
                               Apache Software Foundation's Web site.
                                     Servlets and JavaServer Pages have become so popular that they are now sup-
                               ported by most major Web servers and application servers, including the Sun ONE
                               Application Server, Microsoft's Internet Information Services (IIS), the Apache
                               HTTP Server, BEA's WebLogic application server, IBM's WebSphere application
                               server, the World Wide Web Consortium's Jigsaw Web server and many more.

                              Servlet Life Cycle
                              Architecturally, all servlets implement a common interface, which enables the serv-
                              let container to interact with any servlet, regardless of its functionality. A servlet's
                              life cycle begins when the servlet container loads the servlet into memory—usually
                              in response to the first request that the servlet receives. Before the servlet can han-
                              dle that request, the servlet container initializes the servlet. Then, the servlet can
                              respond to its first request. Typically, each new request results in a new thread of
                              execution (created by the servlet container). The servlet container can also termi-
                              nate the servlet to release its resources.80

                               JavaServer Pages (JSP)
                              JavaServer Pages is an extension of servlet technology. JSPs simplify the delivery of
                              dynamic Web content. Web-application programmers can create dynamic content
                              by reusing predefined components and by interacting with components using
                              server-side Java code. JSP programmers can reuse Java objects and create custom
                              tag libraries that encapsulate complex, dynamic functionality. These libraries enable
                              Web-page designers who are not familiar with Java to enhance Web pages with
                              powerful dynamic content and processing capabilities.
                                    There are four key components to JSPs: directives, actions, scriptlets and tag
                              libraries. Directives are messages to the JSP container that enable the programmer

<!-- pág. 898 -->

                                                                                  18.7 Java Distributed Computing 845

to specify page settings, to include content from other resources and to specify cus-
tom tag libraries for use in a JSP. Actions encapsulate functionality in predefined
tags that programmers can embed in a JSP. Actions often are performed based on
the information sent to the server as part of a particular client request. They also
can create Java objects for use in JSP scriptlets. Scriptlets, or scripting elements,
enable programmers to insert Java code that interacts with components in a JSP
(and possibly other Web-application components) to process requests. The tag-
extension mechanism enables programmers to create custom tags. Such tags enable
programmers to manipulate JSP content.81
      When a JSP-enabled server receives the first request for a JSP, the JSP con-
tainer translates that JSP into a Java servlet that handles the current request and
future requests to the JSP. If the new servlet compiles properly, the JSP container
invokes the servlet to process the request. The JSP may respond directly to the
request or may invoke other Web-application components to assist in processing
the request. Overall, a JSP's request/response mechanism and life cycle are identi-
cal to that of a servlet.


Self Review
1. Suppose a request for a Web page requires the server to generate its content from a data-
   base. Which technology discussed in the previous section is most appropriate to accom-
   plish this?
2. Which JSP component enables programmers to insert Java code into JSP?
Ans: 1) Servlets should be used, because JSP is used when a small portion of the content is
generated dynamically with Java code. 2) Scriptlets.



18.7.2 Jini
Many network devices, such as printers and Web servers, provide services to net-
work clients. Jini—a framework for building reliable and fault-tolerant distributed
systems with existing Java technologies—extends this idea of providing services
beyond industry computer-based networks and into home-based networks. For
example, when you arrive home, your car could use a wireless network to notify
your home's lighting service to turn on the lights over the walkway. Each service
mentioned here has a well-defined interface. The network-printing service provides
an interface that enables applications to print documents. A Web server provides an
HTTP interface that enables Web browsers to download documents. Your home's
lighting service provides an interface that enables other devices on the network to
turn the lights on and off.
      To use a Jini service, a Jini client must be able to discover that a service exists
and must know the interface for interacting with the service. For example, your car
must be able to discover that your home provides a lighting service and must know
the service's interface to interact with it. However, the car need not know the
implementation of the underlying lighting service.

<!-- pág. 899 -->

846 Distributed Systems and Web Services

                                   The Jini lookup service is the heart of the Jini architecture (Fig. 18.15). A
                            lookup service maintains information about available Jini services and enables cli-
                            ents to discover and use them. The process of finding the lookup services and
                            obtaining references to them is called discovery. A service provider discovers and
                            registers the service interface with one or more lookup services to make itself avail-
                            able to clients. Clients discover the lookup services and request a service they
                            require. The lookup services then send a copy of the service interface to the client.
                            Upon obtaining the service interface, the client communicates with the service pro-
                            vider via RMI, as discussed in Section 17.3.3, using the service interface.82
                                   Recall that Jini services register with lookup services to make the Jini ser-
                            vice's functionality available to other members in the network. If all goes well,
                            other members use the service, and the service stays up and running perpetually. In
                            reality, however, services fail for many reasons—network outages can make a ser-
                            vice unreachable, a physical device associated with a service (e.g., a printer) might
                            need repairs or the service itself could encounter an unrecoverable error. In these
                            and many other situations, a service could become unavailable, and that service
                            might not be able to unregister itself from lookup services to prevent other clients
                            from attempting to use it.
                                   One goal of Jini technology is to make Jini communities "self-healing" and
                            able to recover from these common problems. Therefore, when a Jini service regis-
                            ters with a lookup service, the registration is not permanent. The registration is
                            leased for a specific amount of time, after which the lookup service revokes the reg-
                            istration (a service provider can also renew the lease anytime before it expires).83
                            This prevents problematic services from disrupting the entire Jini network. If a Jini




                            Figure 1 8 . l 5 | Jini architecture.

<!-- pág. 900 -->

                                                                                         18.7 Java Distributed Computing 847

  service fails, the Jini service's lease eventually expires and lookup services will no
  longer provide the failed Jini service to clients. The leasing strategy that Jini
   employs is strict—if a Jini service provider does not renew the lease, the lookup ser-
  vice terminates the registration when the lease expires and the service becomes
   unavailable to clients.

Self Review
1. What information must a Jini client know in order to use a Jini service?
2. What is the function of the Jini lookup service?
Ans: 1) The Jini client must know the service interface to use a Jini service. 2) It acts as a reg-
istry for Jini services so that a Jini client can find and use the Jini services that are available.




18.7.3      JavaSpaces
JavaSpaces is a Jini service that implements a simple, high-level architecture for
building distributed systems. Objects that take part in distributed systems must be
able to communicate with one another and share information. The JavaSpaces ser-
vice provides distributed, shared storage (and shared memory) for Java objects and
enables Java objects to communicate, share objects and coordinate tasks using the
storage. Any Java-compatible client can put shared objects into the storage.
      A JavaSpaces service provides three fundamental operations—write, take and
read, which allow the communications between objects stored in JavaSpaces. The
write operation adds an object into the JavaSpaces service. When clients want to
remove an object, they perform a take operation. The take operation removes from
the JavaSpaces service an object that satisfies the client's search criteria. The read
operation is similar to the take operation, but it does not remove the matching
object from the JavaSpaces service so that other clients can still find it. Clients can
perform read operations concurrently, but only one client can perform the take
operation to remove the object from JavaSpaces.84
      JavaSpaces eases the design and development of distributed systems that
share Java objects between the service providers and the clients. A JavaSpaces ser-
vice has six major properties: 85
      1. A JavaSpaces service is a Jini service.
      2. Multiple processes can access a JavaSpaces service concurrently, which
         helps synchronize actions between distributed applications.
      3. An object stored in a JavaSpaces service will remain in the service until its
         lease expires or until a program removes the object from the JavaSpaces
         service.
      4. A JavaSpaces service locates objects by comparing them to a template. The
         template specifies the search criteria against which the JavaSpaces service
         compares each object in the JavaSpaces service. When one or more entries
         match the template, the JavaSpaces service returns a single matching object.

<!-- pág. 901 -->

848 Distributed Systems and Web Services
                                  5. JavaSpaces services ensure that operations execute atomically.
                                  6. Objects in a JavaSpaces service are shared. Both service providers and cli-
                                     ents can read and take objects from the JavaSpaces service.
                                  Now we demonstrate how to build a distributed image-processing system with
                            the JavaSpaces service (Fig. 18.16). Image processing can be a time-consuming task,
                            especially for large images. However, we can improve performance by using Jav-
                            aSpaces services to build a distributed image-processing system for applying filters
                            to images (e.g., blur, sharpen, etc.). The client first partitions a large image into
                            smaller pieces and writes them into a JavaSpaces service. Multiple image processors
                            (distributed among the system) run in parallel to take the smaller images from the
                            storage and process them by applying appropriate filters, then write the processed
                            images back into the JavaSpaces service. The client takes the processed subimages
                            from the JavaSpaces service and builds the complete, processed image.

                            Self Review
                            1. (T/F) After a service provider adds an object to a JavaSpaces service, the object will
                               always be there if no one removes it.
                            2. How might JavaSpaces be used to implement a chat system?
                            Al*9-- 1) False. Even though the client does not execute a take operation, the object will not
                            remain in the JavaSpaces service permanently. Each object stored in a JavaSpaces service has




                            Figure 18.16 | Distributed image-processing application using JavaSpaces.

<!-- pág. 902 -->

                                                                                   18.7 Java Distributed Computing 849

a lease; when its lease expires, the object is removed. 2) JavaSpaces can be used to build a
chat system in which the message sender writes messages to JavaSpaces and the message
receiver reads or takes the message from JavaSpaces. The sender can send messages to a par-
ticular recipient or to a group of recipients.



18.7.4      Java Management Extensions (JMX)
A crucial function in any distributed system is network management. Businesses
increasingly need networks that provide services which are customized to customer
demands, consistently available and easily updated. As more organizations add net-
works and expand existing networks to increase productivity, network management
becomes more difficult. The proper functionality of printers, network routers and
other devices—many of which play an integral role in the productivity of a firm—is
important. As more devices are networked and as networks grow larger, more
problems can occur. The demand for managing distributed applications increases
when business applications move into distributed environments. 86
      Existing tools for managing networked devices often use both standard and
proprietary protocols and management tools. The diversity of such proprietary pro-
tocols and tools makes managing a diverse network difficult. Many network man-
agement schemes are inflexible and nonautomated. This usually means that
significant amounts of time and resources are spent trying to fix and operate large
networks. New technologies are required that will help shift the burden of routine
tasks to the network management software itself and leave special issues to the net-
work manager.
      Recent technological advances have provided network management develop-
ers with the tools necessary to develop smart agents that can assume various
responsibilities. These tools allow agents to incorporate themselves into frame-
works in which numerous agents interact with each other and provide a dynamic
and extensible network management solution.
      Java Management Extensions (JMX), developed by Sun and other companies
in the network management industry, defines a component framework that enables
developers to build automated, intelligent and dynamic network management solu-
tions. JMX defines a three-level management architecture —the instrumentation
level, the agent level and the manager level (Fig. 18.17). The instrumentation level
makes any Java-based object manageable so that the management application can
access and operate these objects. The agent level provides services for exposing the
managed resources. The manager level gives management applications access to
resources created in the instrumentation level and operates these resources via the
JMX agents.87



Self Review
1. What are the problems with many existing network-management schemes?
2. What are the three levels in JMX architecture? Briefly describe the function of each.

<!-- pág. 903 -->

850 Distributed Systems and Web Services



                                Manager level




                                Agent level




                                Instrumentation level




                             Figure 18.17 | JMX's three-level management architecture.

                             Ans: 1) Many existing network-management schemes are inflexible and nonautomated,
                             because various networked devices may be managed using diverse protocols and tools and
                             require large amounts of time to fix and operate in a large network. 2) The three levels are:
                             the instrumentation level, the agent level and the manager level. The instrumentation level
                             makes any Java-based object manageable. The agent level provides services for exposing the
                             managed resources. The manager level gives management applications access to resources
                             and operates these resources via the JMX agents.



                             18.8 Web Services
                             Over the past several decades, computing has evolved at an unprecedented pace.
                             This progress impacts organizations in significant ways, forcing information-tech-
                             nology (IT) managers and developers to accept new computing paradigms. Innova-
                             tions in programming and hardware have led to more powerful and useful
                             technologies, including object-oriented programming, distributed computing, Inter-
                             net protocols and XML (Extensible Markup Language). At the same time, organi-
                             zations have learned to leverage the power of their networks and the Internet to
                             gain competitive advantages.
                                   Web services technology, which represents the next stage in distributed com-
                             puting, will profoundly affect organizations in the future. Web services encompass a
                             set of related standards that can enable any two computer applications to communi-
                             cate and exchange data via the Internet. Many factors—including software vendors'
                             widespread support for underlying standards —indicate that Web services will radi-
                             cally change IT architectures and partner relationships. Companies are already
                             implementing Web services to facilitate a wide variety of business processes, such as
                             application integration and business-to-business transactions.88

<!-- pág. 904 -->

                                                                                         18.8 Web Services 851

      For a distributed system to function correctly, application components execut-
ing on different computers throughout a network must be able to communicate. In
Section 17.3, we discussed technologies such as DCOM and CORBA that enable
communication among distributed components. Unfortunately, DCOM and
CORBA cannot intercommunicate easily. Their components often communicate
via a COM/CORBA bridge. If DCOM's and CORBA's underlying protocols
change, programmers must modify the bridge to reflect the changes. Such problems
have impeded distributed computing's ability to facilitate business-process integra-
tion and automation.
      Web services improve distributed computing capabilities by addressing the
issue of limited interoperability.89 Web services operate using open (i.e., nonpropri-
etary) standards, which means that Web services can, theoretically, enable any two
software components to communicate—regardless of the technologies used to cre-
ate the components or the platforms on which the components reside. Also, Web-
services-based applications are often easier to debug, because Web services use a
text-based communications protocol, rather than the (albeit faster) binary commu-
nications protocols employed by DCOM and CORBA. Organizations are imple-
menting Web services to improve communication between DCOM and CORBA
components and to create standards-based distributed computing systems. Thus,
Web services will help organizations achieve the goals of distributed computing and
do so more economically.90
      The industry's experience with interoperability problems led to the develop-
ment of open standards for Web services technologies, in an effort to enable cross-
platform communication. The primary standard used in Web services is Extensible
Markup Language (XML), a language for marking up data so that information can
be exchanged between applications and platforms. Microsoft and DevelopMentor
developed the Simple Object Access Protocol (SOAP) as a messaging protocol for
transporting information and instructions between Web services, using XML as a
foundation for the protocol. Two other Web services specifications—Web Services
Description Language (WSDL) and Universal Description, Discovery and Integra-
tion (UDDI) —are also based on XML. WSDL provides a standard method of
describing Web services and their specific capabilities; UDDI defines XML-based
rules for building directories in which companies advertise themselves and their
Web services.91
      Open standards enable businesses (running different platforms) to communi-
cate and transfer data without designing costly platform-specific software. Web ser-
vices improve collaborative software development by allowing developers to create
 applications by combining code written in any language on any platform. Also, Web
services promote modular programming. Each specific function in an application
can be exposed as a separate Web service. Individuals or businesses can create their
own unique applications by mixing and matching Web services that provide the
functionality they need. Modularization is less error prone and promotes software
reuse.

<!-- pág. 905 -->

852 Distributed Systems and Web Services

                                   A Web service can be as trivial as multiplying two numbers together or as
                             complex as the functions carried out by an entire customer relationship manage-
                             ment (CRM) software system. For example, tracking the location and status of a
                             FedEx package is a Web service ( f e d e x . c o m / u s / t r a c k i n g ) .
                                   Some e-commerce Web sites allow independent developers to harness the
                             power of their sites' technologies by exposing certain functions as Web services. For
                             example, online retailer Amazon. com allows developers to build online stores that
                             search its product databases and display detailed product information via Ama-
                             zon.com Web Services (www.amazon.com/gp/aws/landing.html). The Google
                             search engine also can be integrated with other functionality through the Google
                             Web APIs (www.google.com/apis), which connect to Google's indices of Web sites
                             using Web services. Amazon. com and Google provide access to their sites' features
                             through SOAP and other standard protocols in exchange for increased exposure.

                            Self Review
                             1. How are Web services more portable than DCOM?
                             2. Can a client application written in Java access a Web service written in C#? Why?
                            Ans: 1) Web services provide interoperability, platform independence and language inde-
                            pendence. 2) Yes, a client application written in Java can access a Web service written in C#,
                            because Web services technologies use open standards such as XML, SOAP, WSDL and
                            UDDI.




                             18.8.1 Microsoft's .NET Platform
                             Microsoft introduced the term Web services during the June 2000 launch of its
                             .NET initiative. Today, Microsoft is one of the dominant companies in the Web ser-
                             vices market. The .NET initiative includes the Visual Studio .NET integrated devel-
                             opment environment which enables programmers to develop Web services in a
                             variety of languages, including C++, C# and Visual Basic .NET However, .NET
                             technologies are available only for Windows 2000 and XP. 92
                                   .NET Web services, which are central to the .NET initiative, extend the con-
                             cept of software reuse to the Internet by allowing developers to reuse software
                             components that reside on other machines or platforms. Employing Web services as
                             reusable building blocks, programmers can concentrate on their specialties without
                             having to implement every component of an application. For example, a company
                             developing an e-commerce application can subscribe to Web services that process
                             payments and authenticate users. This enables programmers to focus on other,
                             more unique aspects of the e-commerce application.
                                   In .NET, a Web service is an application stored on one machine that can be
                             accessed by another machine over a network. In its simplest form, a Web service
                             created in .NET is a class, or a logical grouping of methods and data that simplifies
                             program organization. Methods are defined within a class to perform tasks and
                             return information when their tasks are complete. .NET Web service classes contain

<!-- pág. 906 -->

                                                                                          18.8 Web Services 853
certain methods (called Web service methods) that are specified as part of the Web
service. These methods can be invoked remotely using RPC.

Self Review
1. Can .NET technologies be used on Linux?
2. How have .NET Web services extended the concept of software reuse to the Internet?
Ans: 1) No. .NET technologies are available only for Windows 2000 and XP. 2) .NET Web
services allow developers to reuse software components that reside on other machines or
platforms.



18.8.2 Sun Microsystems and the Sun ONE Platform
Sun Microsystems' Web services strategy is based on the Sun Open Net Environ-
ment (Sun ONE), which consists of three components—a vision, an architecture
and a conceptual model for developing standards-based software.93
      The Sun ONE vision incorporates a model for software development, in
which critical business information and applications are available at any time to any
type of device, including cell phones and PDAs. Sun ONE's goal is to help develop-
ers create networks of distributed applications or Web services that are highly reli-
able and promote the reuse of components and services.94
      The Sun ONE architecture is designed to be scalable to ensure reliable access
to services. Scalability is crucial; as new technologies and new components are
 added to systems, more demands are placed on system resources, potentially
degrading service.95
      The Sun ONE platform is comprised of three products: the Solaris™ Operat-
 ing Environment, the Infrastructure Software and the Sun ONE Studio. The Infra-
structure Software includes the Sun ONE Directory Server and the Sun ONE
Portal Server, which offer user authentication and personalization. Other Infra-
structure Software capabilities include scheduling management, billing and commu-
nication. Sun ONE allows programmers to deploy Web services using third-party
products. By integrating disparate products, programmers can develop Web ser-
vices infrastructures that best suit their companies' requirements. Sun ONE incor-
porates support for open standards, including XML, SOAP, UDDI and WSDL, to
help ensure high levels of interoperability and system integration. 96
      Sun ONE promotes the notion that a company's Data, Applications, Reports
and Transactions, which compose the conceptual DART model, can be published as
services online.97 Using the DART model, companies can organize business appli-
cations and processes that involve data, applications, reports and transactions, so
 that programmers can map business elements to corresponding services.

Self Review
1. How is Sun ONE more portable than .NET?
2. What does infrastructure software do in Sun ONE?

<!-- pág. 907 -->

854 Distributed Systems and Web Services

                                    Ans: 1) .NET is available only on Windows, while Sun ONE is available for many plat-
                                    forms. 2) Infrastructure software offers user authentication and personalization. Infrastruc-
                                    ture software is also capable of scheduling management, billing and communication.




www.faqs.org/ftp/rfc/pdf/rfcl094.txt.pdf                          www.jxta.org
PDF version of the Network File System version 2 protocol         Official Web site for Project JXTA; contains the newest down-
specification.                                                    loads of the source code and opportunities to participate in
www.connectathon.org/nfsv3.pdf                                    developing JXTA.
PDF version of the Network File System version 3 protocol         www.openp2p.com
specification.                                                    This O'Reilly Network online resource provides articles and
www.ietf.org/rfc/rfc2054.txt                                      links related to peer-to-peer technologies.
Text version of the WebNFS client specification.                  java.sun.com/j2ee/corba/
www.ietf.org/rfc/rfc3010.txt                                      Discusses CORBA technology and the Java platform.
Text version of the Network File System version 4 protocol        java.sun.com/j2ee
specification.                                                    Provides reference material for all Java 2 Enterprise Edition
www.ietf.org/rfc/rfc2203.txt                                      technologies, including servlets and JavaServer Pages.
Text version of the RPCSEC_GSS protocol specification.            jakarta.apache.org
www.cs.berkeley.edu/projects/sprite/                              The Apache Jakarta Project site provides resources for servlets
retrospective.html                                                and JavaServer Pages and the reference implementation of
Brief retrospective on the Sprite Network Operating System.       these technologies.
www.es.jamstec.go.jp/esc/eng/index.html                           www.webservices.org
Earth simulator home page.                                        The Web Services Community Portal contains the latest news
www.distributed.net/pressroom/presskit.php                        regarding Web services and Web services vendors. There is also
Provides news and articles for distributed system projects.       a collection of articles and papers relating to Web services
library.thinkquest.org/C007645/english/1-                         technologies.
parallel.htm                                                      www.microsoft.com/net
Compares distributed computing and parallel computing and         Microsoft's .NET site provides .NET resources, including
introduces clustering.                                            product information, news, events and downloads.
www.linux-mag.com/2000-10/clustering_01.html                      www.sun.com/sunone
Discusses Linux clustering in detail.                             Sun Microsystems' Sun ONE initiative site explains the Open
www.jini.org                                                      Net Environment and provides news about the products and
The Jini technology site; provides links for downloading the      its users.
Jini technology implementation.                                   www.xmethods.com
wwws.sun.com/software/jini/specs/js2_0.pdf                        Lists free, publicly available Web services and provides links
Provides the JavaSpaces service specification.                    for tutorials and implementations of Web services.
java.sun.com/products/HavaManagement/wp/
Contains Java Management Extensions (JMX) White Paper.


Summary
Networked file systems allow clients to access files stored       mation of the client requests so that subsequent access to
on remote computers. Distributed file systems, which are          the file is easier. In a stateless system, the client must spec-
the focus of this chapter, are special examples of networked      ify which file to access in each request.
file systems that allow transparent access to remote files.              Distributed file systems provide the illusion of trans-
       A distributed file server can be either stateful or        parency. Complete file location transparency means that
stateless. In a stateful system, the server keeps state infor-    the user is unaware of the physical location of a file within a

<!-- pág. 908 -->

                                                                                                            Summary         855
distributed file system; the user just sees a global file sys-     it is returned to the client. When a client writes a block, it
tem. Many distributed systems implement client caching to          writes into its cache. Sprite flushes updated pages to the
avoid the overhead of multiple RPCs. Clients keep a local          server every 30 seconds.
copy of a file and flush it to the server from time to time.              Clustering involves interconnecting nodes (single-
Because there are multiple copies of the same file, files can      processor computers or multiprocessor computers) within
become inconsistent. Distributed file systems are designed         a high-speed LAN to function as a single parallel computer.
to share information among large groups of computers. To           The set of nodes that forms the single parallel machine is
reach this goal new computers should be able to be added           called a cluster. Clustering enables multiple computers to
to the system easily. Distributed file systems should be scal-     work together to solve large and complex problems such as
able. There are two primary security concerns in distributed       weather prediction.
file systems: ensuring secure communications and guaran-                  There are three major types of clusters: high-perfor-
teeing correct file access permissions.                            mance clusters, high-availability clusters and load-balanc-
       NFS (Network File System) versions 2 and version 3          ing clusters. In a high-performance cluster, all the nodes in
assume a stateless server implementation, which makes              the cluster work to improve performance. In a high-avail-
fault tolerance easier to implement than with a stateful           ability cluster, only some of the nodes in the cluster are
server. With stateless servers, if the server crashes, the cli-    working while others act as backups. If working nodes or
ent can simply retry until the server responds. NFS-4 is           their components fail, the backup nodes immediately start
stateful. The stateful server allows faster access to files.       running and take over the jobs that were being executed on
However, if the server crashes, all the state information of       the failed nodes, without interrupting service. In a load-bal-
the client is lost, so the client needs to rebuild its state on    ancing cluster, a particular node works as a load balancer to
the server before retrying.                                        distribute the load to a set of nodes so that all hardware is
       Client-side caching is essential to efficient distributed   efficiently utilized.
file system operation. NFS-4 extends the client-caching                   P2P (peer-to-peer) applications are different from cli-
scheme through delegation, which allows the server to tem-         ent/server applications. Instead of segregating computers
porarily transfer the control of a file to a client. When the      by function, all computers act as both clients and servers.
server grants a read delegation of a particular file to the cli-   Each peer has the ability to discover and communicate with
ent, then no other client can write to that file. When the         other peers. Peers may share resources (such as large multi-
server grants a write delegation of a particular file to the       media files) with others. P2P applications can be imple-
client, then no other client can read or write to that file. If    mented in two forms: centralized and decentralized. A
another client requests a file that has been delegated, the        centralized P2P application uses a server that connects to
server will revoke the delegation and request that the origi-      each peer. Centralized P2P applications exemplify the cli-
nal client flush the file to disk.                                 ent/server relationship. A pure P2P application, also called
       AFS (Andrew File System) is a global file system that       a decentralized P2P application, does not have a server and
appears as a branch of a traditional UNIX file system at           therefore does not suffer from the same deficiencies as
each workstation. AFS is completely location transparent           applications that depend on servers.
and provides a high degree of availability, which means the               Distributed searches make networks more robust by
files are always available regardless of the user's location.      removing single points of failure, such as servers. Not only
AFS is based on the client-server model and relies on RPCs         can peers find information in this way, but they can search
for communication.                                                 for other peers via distributed searches.
      The Sprite file system has the perceived form of a                  Grid computing links computational resources that
UNIX file system, and every client has the exact same view         are distributed over the wide area network (such as com-
of the hierarchy. It goes a step further in UNIX file system       puters, data storages and scientific devices) to solve com-
emulation by allowing transparent remote access to I/O             plex problems. Resources in grid computing are
devices (which are represented as files in UNIX). In Sprite,       distributed, and users can access these resources transpar-
both the client and the server keep a cache. To open a file,       ently without knowing where they are located. Grid com-
the client first checks its cache, then makes a request to its     puting emphasizes public collaboration—individuals and
backing store (which is generally a server). If the server is      research institutes coordinate resources that are not subject
unable to satisfy the request from its cache, it reads the         to a centralized control to deliver qualities of service. Grid
data from disk. Both caches retain a copy of the data when         computing has the same advantage as clustering—high per-

<!-- pág. 909 -->

856 Distributed Systems and Web Services

formance, achieved by cost-effectively using spare com-           based networks and into home-based networks. The Jav-
puter power and collaborating resources. However, grid            aSpaces service provides distributed, shared storage (and
computing requires advanced software to manage distrib-           shared memory) for Java objects and enables Java objects
uted computing tasks efficiently and reliably.                    to communicate, share objects and coordinate tasks using
      A Java servlet extends the functionality of a server,       the storage. Any Java-compatible client can put shared
most frequently a Web server. Using special syntax, JSP           objects into the storage.
allows Web-page programmers to create pages that use                    Java Management Extensions (JMX) defines a com-
encapsulated Java functionality and even to write scriptlets      ponent framework that enables developers to build auto-
(Java code embedded in a JSP) of actual Java code directly        mated, intelligent and dynamic network-management
in the page.                                                      solutions.
       JSPs are generally used when most of the content                  Web services is an emerging area of distributed com-
sent to the client is static text and markup and only a small     puting. Web services encompass a set of related standards
portion of the content is generated dynamically with Java         that can enable any two computer applications to commu-
code. Servlets are commonly used when a small portion of          nicate and exchange data via the Internet. Web services can
the content sent to the client is static text or markup. In       enable any two software components to communicate —
fact, some servlets do not produce content. Rather, they          regardless of the technologies used to create the compo-
perform a task on behalf of the client (such as a database        nents or the platforms on which the components reside.
query), then invoke other servlets or JSPs to provide a                  Web services improve collaborative software devel-
response.                                                         opment by allowing developers to create applications by
       Project JXTA strives to create a standard, low-level       combining code written in any language on any platform.
platform and language-independent protocol that pro-              Also, Web services promote modular programming. Each
motes interoperability among peer-to-peer applications.           specific function in an application can be exposed as a sepa-
JXTA provides a foundation on which developers can build          rate Web service. With separate Web service components,
any type of P2P application.                                      individuals or businesses can create their own unique appli-
       Jini—a framework for building reliable and fault-tol-      cations by mixing and matching Web services that provide
erant distributed systems with existing Java technologies—        the functionality they need. Such modularization is less
extends this idea of providing services beyond computer-          error prone and promotes software reuse


Key Terms
advertisement (in JXTA)—XML document formatted accord-            Beowulf cluster—Linux clustering solution, which is a high-
    ing to JXTA specifications that is used by a peer to adver-       performance cluster. A Beowulf cluster may contain sev-
    tise itself and notify others of its existence.                  eral nodes or several hundred. Theoretically, all nodes
agent level (in JMX)—JMX level that provides services for            have Linux installed as their operating system and are
    exposing the managed resources.                                  interconnected with high-speed Ethernet. Usually, all the
                                                                     nodes in the cluster are connected within a single room to
Andrew File System (AFS)—Scalable distributed file system            form a supercomputer.
   that would grow to support a large community while
   being secure. AFS is a global file system that appears as a    callback (in AFS)—Sent by the server to notify the client that
   branch of a traditional UNIX file system at each worksta-           the cached file is modified.
   tion. AFS is completely location transparent and provides      cell (in AFS-3)—Unit in AFS-3, which preserves namespace
   a high degree of availability.                                      continuity while allowing different systems administrators
Apache Software Foundation—Provides open-source soft-                  to oversee each cell.
   ware, such as Tomcat, the official reference implementa-
                                                                  centralized P2P application—Uses a server that connects to
   tion of JSP and servlet specifications.
                                                                       each peer.
application layer (in grid computing) — Contains applications
    that use lower-level layers to access the distributed         client caching—Clients keep local copies of files and flush
    resources.                                                         them to the server after having modified the files.

available volume storage group (AVSG) (in Coda)—Members           client modification log (CML) (in Coda)—Log which is
     of the VSG with which the client can communicate.                 updated to reflect file changes on disk.

<!-- pág. 910 -->

                                                                                                                Key     Terms      857

cluster—Set of nodes that forms what appears to be a single         Extensible Markup Language (XML)—Language for marking
    parallel machine.                                                   up data so that information can be exchanged between
clustering—Interconnection of nodes within a high-speed                 applications and platforms.
     LAN so that they function as a single parallel computer.       fabric layer (in grid computing)—Layer that accesses physical
Coda Optimistic Protocol—Protocol used by Coda clients to                resources, such as disks.
   write a copy of the file to each of the members of the           file handle—Identifies a file on the file server with file type,
   AVSG, which provides a consistent view of a file within an            location and access permissions.
   AVSG.
                                                                    file identifiers (fids) (in AFS)—Entity that specifies a volume,
collective layer (in grid computing)—Layer responsible for                an index within a volume and an identifier to guarantee
     coordinating distributed resources, such as scheduling a             object uniqueness within a volume.
     task to analyze data received from a scientific device.
                                                                    grid computing—Links computational resources that are dis-
concurrent write-sharing—Occurs when two clients modify                  tributed over the wide area network (such as computers,
    cached copies of the same file.                                      data storages and scientific devices) to solve complex
connectivity layer (in grid computing)—Layer that carries out            problems.
    reliable and secure transactions between distributed            head node (in a Beowulf cluster)—Node, also called master
    resources.                                                          node, that acts as a server to distribute the workload, con-
decentralized peer-to-peer application—Also called a pure               trol access to the cluster and handle the shared resources.
    peer-to-peer application. It does not have a server and         high-availability cluster—Cluster in which only some of the
    therefore does not suffer from the same deficiencies as              nodes are working while other nodes act as backups. The
    applications that depend on servers.                                 goal of a high-availability cluster is to stay up all the time.
delegation (in NFS)—Allows the server to temporarily trans-         high-performance cluster—Cluster in which all the nodes work
    fer the control of a file to a client. When the server grants       to achieve maximum performance.
    a read delegation of a particular file, then no other clients
    can write to that file, but they can read it. When the server   hoarding stage (in Coda) —Stage that clients enter when they
    grants a write delegation of a particular file to the client,       are connected to Coda. In this stage, clients prepare for a
    then no other clients can read or write that file.                  possible disconnection from the system by caching any
                                                                        requested file.
discovery (in Jini)—Process of finding the lookup services and
     obtaining references to them.                                  idempotent request—A requested operation that if performed
                                                                        several times will return the same result, so it is accept-
distributed file system—Special examples of networked file
                                                                        able to perform the same operation twice.
     systems that allow transparent access to remote files.
                                                                    instrumentation level (in JMX)—Makes any Java-based object
distributed search—Searching technology used in peer-to-peer
                                                                         manageable so that the management application can
     applications to make networks more robust by removing
                                                                         access and operate these objects.
     single points of failure, such as servers. In a distributed
     search, if a peer cannot answer the client's request, the      invalidate—To invalidate a file, the client checks the time
     peer forwards the request to its directly connected peers           stamp of the copy of the file on the server. If this copy has
     and the search is distributed to the entire peer-to-peer            been updated since the client last copied the file, then the
     network.                                                            client must download the latest version. If the server copy
                                                                         has not been updated since the client copied it, then the
domain (in Sprite file system)—Unit that represents a portion
                                                                         client can work on its cached copy.
   of the global file hierarchy and is stored at one server.
emulation stage—When a Coda client becomes disconnected,            Jakarta project—Provides commercial-quality server solutions
   it is said to enter the emulation stage. During this stage all       based on the Java platform that are developed in an open
   file read requests are satisfied from cache. Write requests          and cooperative fashion.
   during the emulation stage occur in two steps. First, the        Java Community Process—Open organization that focus on
   file is updated on disk. Second, a log called the client mod-        developing Java technology specifications, including serv-
   ification log (CML) is updated to reflect file changes.              let and JavaServer Pages.
export local file—Performed by an NFS server to make the            Java Management Extensions (JMX)—Developed by Sun and
    local directory of files available to the remote client via         network management industry leaders, which defines a
    the mount protocol.                                                 component framework that enables developers to build

<!-- pág. 911 -->

858 Distributed Systems and Web Services
    automated, intelligent and dynamic network management                and server software available for other common plat-
    solutions.                                                           forms.
JavaServer Pages (JSP)—Allows Weh-page programmers to                network file system—System that allows clients to access files
    create pages that use encapsulated Java functionality and            on remote computers. Network file systems do not pro-
    even to write scriptlets of actual Java code directly in the         vide location transparency as distributed file systems do.
    page.                                                            nonvolatile storage—The contents of nonvolatile storage are
JavaSpaces—Jini service that implements a simple, high-level             not lost when the machine loses power or is powered off.
    architecture for building distributed systems. The Java-         peer—Single computer in a peer-to-peer system.
    Spaces service provides distributed, shared storage (and
                                                                     peer discovery—Finding peers in a peer-to-peer application.
    shared memory) for Java objects and enables Java objects
    to communicate, share objects and coordinate tasks using         peer group—Logical construct that represents a set of peers. A
    the storage.                                                         peer group is one of the basic types of entities in a net-
                                                                         work built with the JXTA protocols.
Jini—Framework for building reliable and fault-tolerant dis-
    tributed systems with existing Java technologies. Jini           peer-to-peer (P2P) application—Distributes processing respon-
    extends the idea of providing services beyond industry-              sibilities and information to many computers, thus reclaim-
    based computer networks and into home-based networks.                ing otherwise wasted computing power and storage space
                                                                          and eliminating central points of failure. In a peer-to-peer
JXTA—Project created at Sun Microsystems, Inc., which cre-
                                                                         system, each peer performs both client and server func-
   ates a standard, low-level, platform and language-inde-
                                                                         tions.
   pendent protocol that promotes interoperability among
   peer-to-peer applications.                                        pipe (in JXTA)—Virtual communication channel that con-
                                                                         nects two or more peers for sending and receiving mes-
lease—Agreement between the client and server for control-
                                                                         sages among peers.
     ling file locks.
                                                                     preferred server (PS) (in Coda)—Member of the AVSG that
load-balancing cluster—Cluster in which one particular node
                                                                          provides copies of files for Venus.
     works as a load balancer to distribute the load to a set of
     nodes, so that all hardware is efficiently utilized.            prefix table (in Sprite)—Table that stores domain information
                                                                          to aid in file lookups. Each entry in the table represents a
load balancer—Node in a load-balancing cluster that distrib-
                                                                          separate domain and consists of the absolute path to the
    utes the workload (such as thousands of requests from the
                                                                          root directory within the domain, the server which houses
    clients) to a set of nodes so that all hardware is efficiently
                                                                          the domain and a token that identifies the domain.
    utilized.
                                                                     pure peer-to-peer application—Also called a decentralized
lookup service—Heart of the Jini architecture, which main-
                                                                         peer-to-peer application. It does not have a server and
    tains information about available Jini services and enables
                                                                         therefore does not suffer from the same deficiencies as
    clients to discover and use them.
                                                                         applications that depend on servers.
manager level (in JMX)—Level that gives a management
                                                                     read operation (in JavaSpaces)—Operation that is similar to
   application access to managed resources (created in the
                                                                         the take operation, but does not remove the object from
   instrumentation level) and operates these resources via
                                                                         the JavaSpaces service so that other clients can still find it.
   the JMX agents.
                                                                     reintegration stage (in Coda)—Stage right after the client
master node (in a Beowulf cluster)—Node also known as the
                                                                          reconnects to the system during which Venus asynchro-
    head node, that acts as a server to distribute the workload,
                                                                          nously updates the server using the CML.
    control the access to the cluster and handle the shared
    resources.                                                       resources layer (in grid computing)—Layer that enables appli-
                                                                         cations to query and share a resource.
multicomputer system—System in which processors do not
    share a common memory or bus. Each processor has                 safe asynchronous write (in NFS-3)—Allows a server to return
    access to its own resources. These independent processors             before a write has been completed.
    are connected in a network to operate cooperatively to           scriptlet—Java code embedded in a JSP.
    form a multicomputer system.                                     sequential write-sharing—Occurs when one client modifies a
Network File System (NFS) — Current de facto standard for                file, then another client tries to read or write its own
    network file sharing, natively supported in most varieties           cached copy of the file. Sequential write-sharing intro-
    of UNIX (and many other operating systems) with client               duces cache inconsistency.

<!-- pág. 912 -->

                                                                                                                  Exercises        859
servlet—Enhances the functionality ofWeb servers to provide                 which companies advertise themselves and their Web ser-
    capabilities such as secure access to Web sites, interacting            vices.
    with databases on behalf of a client, dynamically generat-       update set (in Coda) — Specifies, to each member of the AVSG,
    ing custom documents to be displayed by browsers and                 the members of the AVSG that have successfully per-
    maintaining unique session information for each client.              formed the write.
servlet container—Server that executes a servlet. Also known         Venus (in AFS) —User-level process that interacts with the
     as servlet engine.                                                  Vice processes run on distributed file servers to govern
Simple Object Access Protocol (SOAP)—Messaging protocol                  distributed file access.
    for transporting information and instructions between            virtual file system (VFS)—Provides the abstraction of a com-
    Web services, using XML as a foundation for the protocol.             mon file system at each client and is responsible for all dis-
slave node (in a Beowulf cluster)—Beowulf cluster node that               tributed file operations.
     is not a head node.                                             Vice (in AFS)—Entity that governs distributed file access in
Sprite—Distributed operating system whose goal is transpar-              AFS.
    ency and complete consistency.                                   volume (in AFS-2) —Introduced in AFS-2 to manage subtrees.
stateful server—Keeps state information of the client                    Volumes are primarily of administrative value, allowing
     requests—such as the file name, a pointer to the file and           replication and isolation of certain subtrees, and are
     the current position in the file—so that the subsequent             therefore transparent to users.
     access to the file is easier and faster.                        volume storage group (VSG) (in Coda)—Volumes are logical
stateless server—The server does not keep state information              pieces of the file system and are replicated physically
     of the client requests, so the client must specify which file       across multiple file servers. Servers that hold the same
     to access in each request.                                          volume are known as a volume storage group (VSG).
Sun Open Net Environment (Sun ONE)—Consists of three                 WebNFS-Allows NFS clients to access WebNFS-enabled
    components—a vision, an architecture and a conceptual               servers with a minimum of protocol overhead. Marketed
    model for developing standards-based software.                      as the file system for the Web, WebNFS is designed to
take operation (in JavaSpaces)—Removes from the Jav-                    improve NFS functionality and performance over wide
    aSpaces service an object that matches the given criteria.          area Internet and intranets.
    Take operations, together with write and read operations,        Web service—Technology that encompasses a set of related
    allow distributed applications to dynamically exchange              standards that can enable any two computer applications
    objects within JavaSpaces services.                                 to communicate and exchange data via the Internet.
thin client—Application that requires minimal client-side sup-       Web Services Description Language (WSDL)—Provides a
     port.                                                              standard method of describing Web services and their spe-
Tomcat—Official reference implementation of the JSP and                 cific capabilities.
   servlet standards.                                                Web service methods (in .NET)—Methods contained in a
Universal Description, Discovery and Integration (UDDI)—                .NET Web service class.
    Defines XML-based rules for building directories in              write operation (in JavaSpaces) — Operation that adds an
                                                                          object into the JavaSpaces service.



Exercises
18.1 Explain the benefits and drawbacks of client caching in         18.5 Is NFS-4 more secure than NFS-2 and NFS-3? How?
distributed file systems.                                            18.6 In AFS-1, each time the VFS tried to open a cached file
18.2 What are the primary concerns of implementing distrib-          it would have Venus contact the server to make sure that the
uted file systems?                                                   file was still valid. What is the problem with this approach?
                                                                     How do AFS-2 and AFS-3 solve this problem?
18.3 A file server can be either stateful or stateless. What are
the advantages and disadvantages of each implementation?             18.7    Explain how Coda provides fault tolerance.
18.4 How can distributed file systems ensure cache consis-           18.8 Describe the three stages Coda clients go through when
tency?                                                               reading and writing to a file on the Coda server.

<!-- pág. 913 -->

860 Distributed Systems and Web Services

18.9    How does Sprite handle server crashes?                                    18.14 Given the peer network as shown in Fig. 18.18, apply
                                                                                  the distributed search mechanism used in Freenet to find the
18.10 Describe the differences between high-performance
                                                                                  requested resource, which is on P7. Assume the search starts at
clusters, high-availability clusters and load-balance clusters.
                                                                                  P1.
Give examples of each of these cluster types in use.
                                                                                  18.15 Describe the three basic types of entities of JXTA.
18.11 List the essential elements for building a Beowulf cluster.
                                                                                  18.16 Explain why the Jini lookup service is the heart of the
18.12 Compare centralized and pure peer-to-peer applica-                          Jini architecture.
tions. What are the advantages and disadvantages of each                          18.17 When a service provider registers a service with a Jini
approach?                                                                         lookup service, is the registration permanent? What is the ben-
18.13 Given the peer network of Fig. 18.18, apply the distrib-                    efit of this design?
uted search mechanism used in Gnutella to find the requested                      18.18 What problems do DCOM and CORBA have? How can
resource which is on P 7 . Assume the search starts at P1.                        Web services solve this problem?

Suggested Projects
18.19 Research transparency in distributed file systems. What                     18.21 Prepare a research paper for Web services. How is is
research is currently being done in that field?                                   used?
18.20 Research client caching in distributed file systems. What
research is currently being done in that field?




Distributed file systems play an important role in distributed                    JMX.129 Web services is an emerging area of distributed com-
systems.98, 99 Examples of distributed file systems are NFS,136, 101,             puting. Web services encompass a set of related standards that
102, 103, 104, 105
                   AFS,106, 107 Coda 108 and Sprite.109, 110, 111, 112 Cluster-   can enable any two computer applications to communicate and
ing enables multiple computers to work together to solve large                    exchange data via the Internet. Web services can enable any two
and complex problems.113, 114 The most popular clustering tech-                   software components to communicate—regardless of the tech-
nologies are Beowulf and Windows Server 2003 clusters.115, 116                    nologies used to create the components or the platforms on
The peer-to-peer distributed computing model is another archi-                    which the components reside.130, 131, 132, 133
tecture for building distributed systems.117, 118, 119 Peer-to-peer                      Web services is one of the most recent distributed systems
applications use a distributed search to find a peer in the net-                  architectures.134, 135 Distributed systems exist in many forms—
work.120, 121 Sun provides several technologies for developing                    distributed object-based systems, distributed file systems, dis-
distributed computing systems with servlets and JavaServer                        tributed document-based systems and distributed coordination-
Pages (JSP),122, 123, 124, 125 including Jini,126, 127 JavaSpaces128 and          based systems. Tanenbaum and Steen discuss each of these types




Figure 18.18 | P2P system with seven peers.

<!-- pág. 914 -->

                                                                                                                                           Works Cited 861
of distributed systems.136 Both centralized and decentralized                enables the creation of a large-scale infrastructure used to share
P2P applications have scalability limitations. Grid computing                computing power and data resources.137, 138


Works Cited
 1. Tanenbaum, A., and R. Renesse, "Distributed Operating Sys-                19. Morris, J. H., et al., "Andrew: A Distributed Personal Computing
    tems," ACM Computing Surveys, Vol. 17, No. 4, December 1985,                  Environment," Communications of the ACM, Vol. 29, No. 3,
    pp. 419-470.                                                                  March 1986, pp. 186-187.
 2. Levy, E., and A. Silberschatz, "Distributed File Systems: Con-           20. Satyanarayanan, M., "Scalable, Secure and Highly Available Dis-
    cepts and Examples," ACM Computing Surveys, Vol. 22, No. 4,                  tributed File Access," IEEE Computer, May 1990, p. 10.
    December 1990, pp. 321-374.                                              21. Satyanarayanan, M., "Scalable, Secure and Highly Available Dis-
 3. Howard, J. H., et al, "Scale and Performance in a Distributed File           tributed File Access," IEEE Computer, May 1990, pp. 11-12.
    System", ACM Transactions on Computer Systems, Vol. 6, No. 1,            22. Morris, J. H., et al., "Andrew: A Distributed Personal Computing
    February 1988, pp. 51-81.                                                    Environment," Communications of the ACM, Vol. 29, No. 3,
 4. Andrade, H., "Distributed File Systems", <www.cs.umd.edu/                    March 1986, p. 193.
    ~hcma/818g/>.                                                            23. Satyanarayanan, M., "Scalable, Secure and Highly Available Dis-
 5. Tanenbaum, A., and R. Renesse, "Distributed Operating Sys-                   tributed File Access," IEEE Computer, May 1990, p. 12.
    tems," ACM Computing Surveys, Vol. 17, No. 4, December 1985,             24. Satyanarayanan, M., "Scalable, Secure and Highly Available Dis-
    pp. 429-430.                                                                 tributed File Access," IEEE Computer, May 1990, pp. 13-15.
 6. "Difference Between Fault Tolerance and High-Availability,"              25. Coda credits, < w w w . m i t . e d u / a f s / s i p b / p r o j e c t / c o d a / s r c /
    <aix.caspur.it/ibm/web/pssp-3.5/planv2/                                      coda/CREDITS>.
    am0s0mst38.html>.
                                                                             26. Satyanarayanan, M., "Scalable, Secure and Highly Available Dis-
 7. Froese, K. W., and R. B. Bunt, "The Effect of Client Caching on              tributed File Access," IEEE Computer, May 1990, p. 15.
    File Server Workloads," Proceedings of the Twenty-Ninth Hawaii
                                                                             27. Satyanarayanan, M., "The Evolution of Coda," ACM Transac-
    International Conference on System Sciences, Wailea, HI, January
                                                                                 tions on Computer Systems, Vol. 20, No. 2, May 2002, p. 89.
    1996, pp. 15-159.
                                                                             28. Satyanarayanan, M., "The Evolution of Coda," ACM Transac-
 8. Tanenbaum, A., and R. Renesse, "Distributed Operating Sys-
                                                                                 tions on Computer Systems,Vol. 20, No. 2, May 2002, pp. 89-90.
    tems," ACM Computing Surveys, Vol. 17, No. 4, December 1985,
    pp. 427-429.                                                             29. Satyanarayanan, M., "The Evolution of Coda," ACM Transac-
                                                                                 tions on Computer Systems, Vol. 20, No. 2, May 2002, pp. 90-91.
 9. Sandberg, R., "The Sun Network Filesystem: Design, Implemen-
    tation and Experience", Proceedings of The USENIX Confer-                30. Satyanarayanan, M., "The Evolution of Coda," ACM Transac-
    ence, 1986, pp. 300-314, <www.cs.ucf.edu/~eurip/cop6614/                     tions on Computer Systems, Vol. 20,No. 2,May 2002,pp. 94-95.
    sandbergnfs.pdf>.                                                        31. Ousterhout, J., "A Brief Retrospective on the Sprite Network
                                                                                 Operating         System,"  <www.cs.berkeley.edu/projects/
10. Nowicki, B., "NFS: Network File System Protocol Specification,"
                                                                                 sprite/retrospective,html>.
    March 1989, < w w w . i e t f . o r g / r f c / r f c l 0 9 4 . t x t > .
11. Callaghan, B., "NFS Version 3 Protocol Specification,"                    32.   Ousterhout, X, et al., "The Sprite Network Operating System,"
    <www. i e t f . o r g / r f c / r f cl813. txt>, June 1995.                     IEEE Computer, February 1988, p. 28.
12. Network File Systems: Version 2 Protocol Specification,                   33.   Ousterhout, J., et al., "The Sprite Network Operating System,"
                                                                                    IEEE Computer, February 1988, pp. 28-30.
    <docs.freebsd.org/44doc/psd/27.nfsrfc/paper.pdf>.
13. Callaghan, B., "WebNFS Client Specification," October 1996,               34.   Ousterhout, J., et al, "The Sprite Network Operating System,"
    <www.ietf.org/rfc/rfc2054.txt>.                                                 IEEE Computer, February 1988, pp. 30-31.
14. Shepler, S., "RFC 2624-NFS Version 4 Design Considerations,"              35.   Nelson, M., "Caching in the Sprite Network File System," ACM
                                                                                    Transactions on Computer Surveys, Vol. 6, No. 1, February 1988,
    June 1999, <www.faqs.org/rfcs/rfc2624.html >.
                                                                                    pp. 134-154.
15. Pawlowski, B., et al., "The NFS Version 4 Protocol,"
    <www.netapp.com/tech_library/3085.html>.                                  36.   Baker, M., and J. Ousterhout, "Availability in the Sprite Distrib-
                                                                                    uted File System," Proceedings of the 4th workshop on ACM
16. Shepler, S., et al., "NFS Version 4 Protocol," December, 2000,                  SIGOPS European workshop, September 1990, pp. 1-4.
    <www.ietf.org/rfc/rfc3010.txt>.
                                                                              37.   McGregor, J. D., and A. M. Riehl, "The Future of High Perfor-
17. Eisler, M., "NFS Version 4 Security," December 1998,
                                                                                    mance Super Computers in Science and Engineering," Commu-
    <www.ietf.org/proceedings/98dec/slides/nfsv4-eisier-
                                                                                    nications of the ACM, Vol. 32, No. 9, September 1989, p. 1092.
    98dec.pdf >.
                                                                              38.   Earth Simulator Performance, <www.es.jamstec.go.jp/esc/
18. Satyanarayanan, M., "Scalable, Secure and Highly Available Dis-
                                                                                    eng/ES/performance.html.
    tributed File Access," IEEE Computer, May 1990, p. 9.

<!-- pág. 915 -->

862 Distributed Systems and Web Services
39-   Lyman, J., "The Supercomputing Speed Barrier," Newsfactor                                 60. "Technical: How KaZaA Works," <www.christian-gerner.de/
      Special Report, September 13, 2002, <www.techextreme.com/                                     forum/topic-1-279-279.html>.
      perl/story/19391.html>.                                                                   61. Milojicic, D.; V. Kalogeraki; R. Lukose; K. Nagaraja; J. Pruyne; B.
40. Johnson, G., "At Los Alamos, Two Visions of Supercomputing,"                                    Richard; S. Rollins; and Z. Xu, "Peer-to-Peer Computing", March
    New York Times, June 25, 2002, <www.nytimes.com/2002/06/                                        2002,<www.hpl.hp.com/techreports/2002/HPI_-2002-57.pdf>.
    25/science/physical/                                                                        62. "The Free Network Project," < f r e e n e t . s o u r c e f o r g e . n e t / > .
      25C0MP.html?pagewanted=print&position=bottom>.
                                                                                                63. Oram, A., "Gnutella and Freenet Represent True Technological
41. McNett, D., "Press Information,"                       <www.distributed.net/                    Innovation," <www.oreillynet.com/pub/a/network/2000/05
    pressroom/presskit.html>.                                                                       12/magazine/gnutella.html ?page=l>.
42. Press Release: "Intel and Scientific Community Announce Can-                                64. Oram, A., "Gnutella and Freenet Represent True Technological
    cer Research Program," April 3, 2001, <www.intel.com/press-                                     Innovation," <         w         w     w         .o    r     e                          i   l
    room/archive/releases/20010403corp.htm>.                                                        12/magazi ne/gnutel1a.html?page=l>.
43. Parallel    Processing,      <library.thinkquest.org/C007645/                               65. Gong, L., "Project JXTA: A Technology Overview."
    english/1-parallel.htm?tqskipl=l&tqtime=1020>.                                                  <www.jxta.org/project/www/docs/jxtaview_01nov02.pdf>.
44. Alternatives and forms of DC; < l i b r a r y . t h i n k q u e s t . o r g /
                                                                                                66. AOL Instant Messenger™, <www.aim.com/index.adp>.
    C007645/english/0-alternatives.htm?tqskipl=l&tqtime=
    0818>.                                                                                      67. Gong, L., "Project JXTA: A Technology Overview"
                                                                                                    <www.jxta.org/project/www/docs/jxtaview_01nov02.pdf>.
45. "Linux Clustering in Depth", Linux Magazine, <www.linux-
    mag.com/2000-10/clustering_01.html>.                                                        68. See, S., "Project JXTA Technology Overview," <cos-
                                                                                                    mos.kaist.ac.kr/~hckim/p2p/busan/jxta-overview.pdf>.
46.    'Distributed Computing: Power Grid", <www.zdnet.com.au/
      printfriendly?AT=2000048620-20269390-2>.                                                  69. "Grid Computing," < s e a r c h c i o . t e c h t a r g e t . c o m / s D e f i n i -
                                                                                                    tion/0,,sidl9_gci773157,00.html>.
47. "Unraveling the Mysteries of Clustering", <www.networkcom-
    puting.com/shared/printArticle.jhtml?article=/1119/                                         70. Foster, I., "Internet Computing and the Emerging Grid."
    1119f2full.html>.                                                                               <www.nature.com/nature/webmatters/grid/grid.html>.
48. The UNIX Operating System: A Robust, Standardized Founda-                                   71. "Grid Computing,"                <www.nr.no/dart/projects/emerging/
    tion for Cluster Architectures, <www.unix.org/whitepapers/                                      grid.html >.
    cluster.html>.                                                                              72. Casanova, H., "Distributed Computing Research Issues in Grid
49. HP 9000 Superdome Overview and Features, <www.hp.com/                                           Computing," ACM SIGACT News, Vol. 33, No. 3, Sept. 2002. p.
    productsl/servers/scalableservers/superdome/>.                                                  54.
50. HP High Performance XC Clusters, <www.hp.com/techserv-                                      73. "Learn about SETI@home," < s e t i a t h o m e . s s l . b e r k e l e y . e d u /
    ers/clusters/5982-0212EN_lo.pdf>.                                                               learnmore.html>.
51. Understanding Clustering, <otn.oracle.com/oramag/oracle/                                    74. Hipschman, R., "How SETI@home                             Works,"       <setiath-
    03-jul/o43devejb.html>.                                                                         ome.ssl.berkeley.edu/about_seti/
                                                                                                    about_seti_at_home_l.html>.
52. Jan    Lindheim, C,  "Building  a  Beowulf    System",
    <www.cacr.caltech.edu/research/beowulf/tutorial/                                            75. "About the            Globus      Alliance,"       <www.globus.org/about/
    beosoft/>.                                                                                      default.asp>.
53. "What's     a     Beowulf?"                      <www.phy.duke.edu/brahma/                  76. "Overview—The Solution: Grid Computing," <www.ud.com/
    beowulf_book/node9.html>.                                                                       solutions/>.
54. "Windows Server 2003 Clustering,"                          <www.microsoft.com/              77. Deitel, H. M. and P. J. Deitel, Java How To Program, 5th Edition
    windowsserver2003/docs/BDMTDM.doc>.                                                             Upper Saddle River, NJ: Prentice Hall, 2003.
55. "Windows Server 2003 Clustering,"                          <www.microsoft.com/              78. "Introduction to JavaServer Pages™," Sun Microsystems, 2002,
    windowsserver2003/docs/BDMTDM.doc>.                                                             <developer.java.sun.com/developer/onlineTraining/web-
56. Harold, E., JAVA Network Programming, Sebastopol, CA:                                           casts/pdf/webcamp/dchen/dchen6.pdf>.
    O'Relly & Associates, Inc., 1997, pp. 26-27.                                                79. "The Apache Jakarta Project," <jakarta.apache.org>.
57. "Peer-to-Peer File Sharing," < b a n n e r s . n o t i c i a s d o t . c o m / t e r -      80. "The J2EE™ Tutorial—Servlet Life Cycle," <java.sun.com/
    mometro/boletines/docs/musica-video/varios/2002/                                                j2ee/tutorial/l_3-fcs/doc/Servlets4.html>.
    musica_P2PWhitePaper.pdf>.                                                                  81. McPherson, S., "JavaServer Pages: A Developer's Perspective."
58. "P2P Search Engines," < n t r g . c s . t c d . i e / u n d e r g r a d / 4 b a 2 . 0 2 -       April 2000, <developer. Java, sun.com/developer/technica-
    03/p8.html>.                                                                                    lArticles/Programming/jsp/>.
59. "GNUtella,"                  <ntrg.cs.ted.ie/undergrad/4ba2.02-03/                          82. "Jini™ Architecture Specification," <wwws.sun.com/software
    p5.html>.                                                                                       jini/specs/jinil.2html/jini-spec.html>.

<!-- pág. 916 -->

                                                                                                                                             Works Cited 863
83. "Jini™ Technology Core Platform Specification, LE-Distributed                103. Network File Systems: Version 2 Protocol Specification,
    Leasing," <www.jini.org/nonav/standards/davis/doc/specs/                          <docs.freebsd.org/44doc/psd/27.nfsrfc/paper.pdf>.
    html/lease-spec.html >.                                                      104. Callaghan, B., "WebNFS Client Specification," October 1996,
84. "JavaSpaces Service Specification," <wwws.sun.com/software/                       <www.ietf.org/rfc/rfc2054.txt>.
    jini/specs/js2_0.pdf>.                                                       105. Shepler, S., "RFC 2624—NFS Version 4 Design Considerations,"
                                                                                      June 1999,<www.faqs.org/rfcs/rfc2624.html>.
85. Freeman, E., and S. Hupfer, "Make room for JavaSpaces, Part 1,"
    <www.javaworld.com/javaworld/jw-ll-1999/jw-ll-                               106. Satyanarayanan, M., "Scalable, Secure and Highly Available Dis-
     j i ni ol ogy_p. html >.                                                         tributed File Access," IEEE Computer, May 1990, p. 9.
                                                                                 107. Morris, J. H., et al., "Andrew: A Distributed Personal Computing
86. Kreger, H., "Java Management Extensions for Application Man-
                                                                                      Environment," Communications of the ACM, Vol. 29, No. 3,
    agement,"          <www.research.ibm.com/journal/sj/401/
                                                                                      March 1986, pp. 186-187.
    kreger.html>.
                                                                                 108. Satyanarayanan, M., "The Evolution of Coda," ACM Transac-
87. "Java Management Extensions White Paper," <java.sun.com/                          tions on Computer Systems, Vol. 20, No. 2, May 2002, p. 89.
    products/JavaManagement/wp/>.
                                                                                 109. Ousterhout, J., "A Brief Retrospective on the Sprite Network
88. Deitel, H. M.; P. J. Deitel; B. DuWaldt; and L. K. Trees, Web Ser-                Operating         System,"  <www.cs.berkeley.edu/projects/
    vices A Technical Introduction, Upper Saddle River, NJ: Prentice                  sprite/retrospective.html>.
    Hall, 2003, p. 2.                                                            n o . Ousterhout, J., et al., "The Sprite Network Operating System,"
89. Snell, J, "Web Services Interoperability,"         <www.xml.com/pub/               IEEE Computer, February 1988, p. 28.
    a/2002/01/30/soap.html>.                                                     i n . Nelson, M., "Caching in the Sprite Network File System," ACM
                                                                                       Transactions on Computer Surveys, Vol. 6, No. 1, February 1988,
90. Deitel, H. M.; P. J. Deitel; B. DuWaldt; and L. K. Trees, Web Ser-
                                                                                       pp. 134-154.
    vices A Technical Introduction, Upper Saddle River, NJ: Prentice
    Hall, 2003, pp. 4-5.                                                         112. Baker, M., and J. Ousterhout, "Availability in the Sprite Distrib-
                                                                                      uted File System," Proceedings of the 4th workshop on ACM
91. Deitel, H. M.; P. J. Deitel; J. Gadzik; K. Lomeli; S. Santry; and S.
                                                                                      SIGOPS European workshop, September 1990, pp. 1-4.
    Zhang, Java Web Services for Experienced Programmers, Upper
    Saddle River, NJ: Prentice Hall, 2003, p. 7.                                 113. Ousterhout, J., et al., "The Sprite Network Operating System,"
                                                                                      IEEE Computer, February 1988, pp. 30-31.
92. Combs, B., "Windows NT/2000," <www.interex.org/pubcon-
                                                                                 114. Nelson, M., "Caching in the Sprite Network File System," ACM
    tent/enterprise/nov01/nt1101.jsp>.
                                                                                      Transactions on Computer Surveys, Vol. 6, No. 1, February 1988,
93. Sun Open Net Environment (Sun ONE), <wwws.sun.com/soft-                           pp. 134-154.
    ware/sunone/>.
                                                                                 115. "What's     a     Beowulf?"                     <www.phy.duke.edu/brahma/
94. "Sun ONE Overview: Vision,"                <wwws.sun.com/software/                beowulf_book/node9.html>.
    sunone/overview/vision/>.
                                                                                 116. "Windows Server 2003 Clustering," <www.microsoft.com/
95. "Sun ONE Overview: Architecture," <wwws.sun.com/soft-                             windowsserver2003/docs/BDMTDM.doc>.
    ware/sunone/overview/architecture/index.html>.
                                                                                 117. "Peer-to-Peer File Sharing," < b a n n e r s . n o t i c i a s d o t . c o m / t e r -
96. Adhikari, R., "Sun Extends Web Services Strategy," Application                    mometro/boletines/docs/musica-video/varios/2002/
    Development Trends, Dec. 2001, p. 12.                                             musi ca_P2PWhi tePaper.pdf>.
97. "Sun ONE Overview: DART Model," <wwws.sun.com/soft-
                                                                                 118. "P2P Search Engines," < n t r g . c s . t c d . i e / u n d e r g r a d / 4 b a 2 . 0 2 -
    ware/sunone/overview/dart/index.html>.
                                                                                      03/p8.html>.
98. Tanenbaum, A., and R. Renesse, "Distributed Operating Sys-
                                                                                 119. "Technical: How KaZaA Works," <www.christian-gerner.de/
    tems," ACM Computing Surveys, Vol. 17, No. 4, December 1985,
                                                                                      forum/topic-1-279-279.html>.
    pp. 419-470.
99. Levy, E., and A. Silberschatz, "Distributed File Systems: Con-               120. Oram, A., "Gnutella and Freenet Represent True Technological
     cepts and Examples," ACM Computing Surveys, Vol. 22, No. 4,                      Innovation," <www.oreillynet.com/pub/a/network/2000/05/
     December 1990, pp. 321-374.                                                      12/magazine/gnutella.html?page=l>.
100. Sandberg, R., "The Sun Network Filesystem: Design, Implemen-                121. Milojicic, D; V Kalogeraki; R. Lukose; K. Nagaraja; J. Pruyne; B.
     tation and Experience", Proceedings of The JJSENIX Confer-                       Richard; S. Rollins and Z. Xu, "Peer-to-Peer Computing", March
     ence, 1986, pp. 300-314, <www.cs.ucf.edu/~eurip/cop6614/                         2002,<www.hpl.hp.com/techreports/2002/HPL-2002-57.pdf>.
     sandbergnfs.pdf>.                                                           122. Deitel, H. M. and P. J. Deitel, Java How To Program, 5th Edition,
101. Nowicki, B., "NFS: Network File System Protocol Specification,"                  Upper Saddle River, NJ: Prentice Hall, 2003.
     March 1989, < w w w . i e t f . o r g / r f c / r f c l 0 9 4 . t x t > .   123. "Introduction to JavaServer Pages™," Sun Microsystems, 2002,
102. Callaghan, B., "NFS Version 3 Protocol Specification,"                           <developer.Java.sun.com/developer/onlineTraining/web-
     < w w w . i e t f . o r g / r f c / r f c l 8 1 3 . t x t > , June 1995.         casts/pdf/webcamp/dchen/dchen6.pdf>.

<!-- pág. 917 -->

864 Distributed Systems and Web Services
124- "The J2EE™ Tutorial—Servlet Life Cycle," <java.sun.com/         132. Sun Open Net Environment (Sun ONE), <wwws.sun.com/soft-
     j2ee/tutorial/l_3-fcs/doc/Servlets4.html>.                           ware/sunone/>.
125. McPherson, S., "JavaServer Pages: A Developer's Perspective,"   133. "Sun ONE Overview: DART Model," <wwws.sun.com/soft-
     April 2000, <developer.Java.sun.com/developer/technica-              ware/sunone/overview/dart/index.html>.
     lArticles/Programming/jsp/>.                                    134. Deitel, H. M., P. J. Deitel, B. DuWaldt and L. K. Trees, Web Ser-
126. "Jini™ Architecture Specification," <wwws.sun.com/software/          vices A Technical Introduction, Upper Saddle River, NJ: Prentice-
     jini/specs/jini1.2html/jini-spec.html>.                              Hall, 2003, pp. 4-5.
127. "Jini™ Technology Core Platform Specification, LE-Distributed   135. Deitel, H. M., P. J. Deitel, J. Gadzik, K. Lomeli, S. Santry and S
     Leasing,"         <www.jini.org/nonav/standards/davis/doc/           Zhang, Java Web Services for Experienced Programmers, Upper
     specs/html/lease-spec.html>.                                         Saddle River, NJ: Prentice Hall, 2003, p. 7.
128. "JavaSpaces Service Specification," <wwws.sun.com/software/     136. Tanenbaum, A. S., and M. van Steen, Distributed Systems Princi-
     jini/specs/js2_0.pdf>.                                               ples and Paradigms, Upper Saddle River, NJ: Prentice Hall, 2002
129. "Java Management Extensions White Paper," <java.sun.com/        137. Foster, I. and C. Kesselman, The Grid: Blueprint for a New Com-
     products/JavaManagement/wp/>.                                        puting Infrastructure, San Fransisco, CA: Morgan Kaufmann.
                                                                          1999.
130. Snell, X, "Web Services Interoperability," <www.xml.com/pub/    138. Bester, E; I. Foster; C. Kesselman; J. Tedesco; and S. Tuecke.
     a/2002/01/30/soap.html>.                                             "GASS: A Data Movement and Access Service for Wide Area
131. Combs, B., "Windows NT/2000," <www.interex.org/pubcon-               Computing Systems," In Proceeding of the Sixth Workshop on I/
     tent/enterprise/nov01/nt1101.jsp>.                                   O in Parallel and Distributed Systems, 1999, pp. 78-88.

