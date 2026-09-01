# Chapter 13 - File and Database Systems

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 637–691 (numeración del PDF)

<!-- pág. 637 -->

Chapter                13


File and Database Systems
 Objectives
 After reading this chapter, you should understand:
 • the need for file systems.
 • files, directories and the operations that can be performed on them.
 • organizing and managing a storage device's data and free space.
 • controlling access to data in a file system.
 • backup, recovery and file system integrity mechanisms.
 • database systems and models.

<!-- pág. 638 -->

                                       Chapter Outling
                        13.1                        13.6.4 Indexed Noncontiguous File
                Introduction                                    Allocation


                        13.2                                      13.7
              Data Hierarchy                         Free Space Management

                        13.3                                    13.8
                     Files                              File Access Control
                                                 Operating Systems Thinking: Security
                        13.4                          13.8.1 Access Control Matrix
              File Systems                        13.8.2 Access Control by User Classes
        Operating Systems Thinking:
           Encryption and Decryption                              13.9
              13.4.1 Directories                     Data Access Techniques
               13.4.2     Metadata
               13.4.3 Mounting                                13.10
                                                     Data Integrity Protection
                    13.5                              13.10.1 Backup and Recovery
             File Organization                    Operating Systems Thinking: Backup
                                                              and Recovery

                        13.6                         13.10.2 Data Integrity and Log-
                                                         Structured File Systems
               File Allocation
        13.6.1 Contiguous File Allocation
                                                     Operating Systems Thinking:
                                                     Murphy's Law and Robust Systems
      13.6.2 Linked-List Noncontiguous File
                   Allocation
       13.6.3 Tabular Noncontiguous File
                                                              13.11
                  Allocation                       File Servers and Distributed
         Mini Case Study: MS-DOS                               Systems




584

<!-- pág. 639 -->

               13.12                                 13.12.3 Relational Database Model
          Database Systems                         13.12.4 Operating Systems and Database
13.12.1    Advantages of Database Systems                          Systems

          13.12.2 Data Access




   Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited



                                                                                         585

<!-- pág. 640 -->

586   File and Database Systems


                             13.1 Introduction
                             Most computer users are familiar with the concept of file as a named collection of
                             data that is manipulated as a unit. Files typically reside on secondary storage
                             devices such as disks, CDs or tapes, though they can exist exclusively in volatile
                             main memory. In this chapter, we discuss how systems organize and access file data
                             so that it can be retrieved quickly from high-latency secondary storage devices. We
                             also discuss how operating systems can create an interface that facilitates naviga-
                             tion of a user's files. Because secondary storage often contains files storing sensitive
                             information for several users, we discuss how systems control access to file data.
                             Many systems use files to store important information such as inventories, payrolls
                             and account balances; we discuss how file systems can protect such data from cor-
                             ruption or total loss from disasters such as power and disk failures. Finally, we dis-
                             cuss how systems that manage large amounts of shared data can benefit from
                             databases as an alternative to files.


                             13.2 Data Hierarchy
                             Information is stored in computers according to a data hierarchy. The lowest level
                             of the data hierarchy is composed of bits. Bits are grouped together in bit patterns
                             to represent all data items of interest in computer systems. There are 2" possible bit
                             patterns for a string of n bits.
                                    The next level in the data hierarchy is fixed-length patterns of bits such as
                             bytes, characters and words. When referring to storage, a byte is typically 8 bits. A
                             word is the number of bits a processor can operate on at once. Thus, a word is 4
                             bytes on a 32-bit processor and 8 bytes on a 64-bit processor.
                                    Characters map bytes (or groups of bytes) to symbols such as letters, numbers,
                             punctuation and new lines. Many systems use 8-bit characters and thus can have 2 s . or
                             256, possible characters in their character sets. The three most popular character sets
                             in use today are ASCII (American Standard Code for Information Interchange).
                             EBCDIC (Extended Binary-Coded Decimal Interchange Code) and Unicode®.
                                    ASCII stores characters as 8-bit bytes and thus can have 256 possible charac-
                             ters in its character set. Due to ASCII's small character size, it does not support
                             international character sets. EBCDIC is often used for representing data in main-
                             frame computer systems, particularly systems developed by IBM; it also stores
                             characters as 8-bit bytes.1
                                    Unicode is an internationally recognized standard that is popular in Internet
                             and multilingual applications. Its goal is to use a unique number to represent every
                             character in all the world's languages.2 Unicode provides 8-, 16- and 32-bit repre-
                             sentations of its character set. To simplify conversion from ASCII to Unicode char-
                             acters, the 8-bit representation of Unicode, called UTF-8 (Unicode character set
                             Translation Format-8 bit), corresponds directly to the ASCII character set. HTML
                             files are typically encoded using UTF-8. UTF-16 and UTF-32 each provide larger
                             character sets, enabling applications to store information containing characters

<!-- pág. 641 -->

                                                                                                     13.3 Files 587
from multiple alphabets, such as Greek, Cyrillic, Chinese and a great many others.
However, they require larger files to store the same number of characters when
compared to UTF-8. For example, the 12-character string "Hello, world"
requires 12 bytes of storage using 8-bit characters, 24 bytes using 16-bit characters
and 48 bytes using 32-bit characters.
      A field is a group of characters (e.g., a person's name, street address or tele-
phone number). A record is a group of fields. A student record may contain, for
example, separate fields for identification number, name, address, telephone number,
cumulative grade point average, major field of study, expected date of graduation and
so on. A file is a group of related records. For example, a student file might contain
one record for each student in a university; a payroll file might contain one record for
every employee in a company. The highest level of the data hierarchy is a file system
or database. File systems are collections of files, and databases are collections of data
(database systems are discussed in Section 13.12, Database Systems).
      The term volume is a unit of data storage that may hold multiple files. A phys-
ical volume is limited to one storage device; a logical volume —such as one that
might be used in a virtual machine —could be draped across many devices. Exam-
ples of volumes include CDs, DVDs, tapes and hard disks.

Self Review
1. What are the trade-offs of large character sets?
2. How many possible character can be stored using a 16-bit, 32-bit and 64-bit character set?
   Why do you suppose that 64-bit character sets are not implemented?
Ans: 1) Large character sets such as Unicode enable users to store and transmit data in
multiple languages. However, large character sets require a large number of bits to represent
each character, which increases the size of data they store. 2) A 16-bit character set can repre-
sent 216, or 65,536, possible characters; a 32-bit character set can represent 232, or over 4 bil-
lion characters; a 64-bit character set can represent 264, or over 16 quintillion characters. As
yet, 64-bit character sets have not been implemented, because they consume a significant
amount of space per character to provide a range of characters far beyond what users are
likely to need well into future.


13.3 Files
A file is a named collection of data that may be manipulated as a unit by operations
such as
      • open —Prepare a file to be referenced.
      • close —Prevent further reference to a file until it is reopened.
      • create — Create a new file.
      • destroy —Remove a file.
      • copy—Copy the contents of one file to another.
      • rename—Change the name of a file.
      • list—Print or display the contents of a file.

<!-- pág. 642 -->

588 File and Database Systems

                                 Individual data items within the file may be manipulated by operations like
                                  • read—Copy data from a file to a process's memory.
                                  • write —Copy data from a process's memory to a file.
                                  • update—Modify an existing data item in a file.
                                  • insert—Add anew data item to a file.
                                  • delete —Remove a data item from a file.
                                 Files may be characterized by attributes such as
                                  • size —the amount of data stored in the file.
                                  • location—the location of the file (in a storage device or in the system's log-
                                    ical file organization).
                                  • accessibility—restrictions placed on access to file data.
                                  • type—how the file data is used. For example, an executable file contains
                                    machine instructions for a process. A data file may specify the application
                                    that is used to access its data.
                                  • volatility—the frequency with which additions and deletions are made to a
                                    file.
                                  • activity—the percentage of a file's records accessed during a given period
                                    of time.
                                 Files can consist of one or more records. A physical record (or physical block)
                           is the unit of information actually read from or written to a storage device. A logical
                           record (or logical block) is a collection of data treated as a unit by software. When
                           each physical record contains exactly one logical record, the file is said to consist of
                           unblocked records. When each physical record may contain several logical records,
                           the file is said to consist of blocked records. In a file with fixed-length records, all
                           records are the same length; the block size is ordinarily an integral multiple of the
                           record size. In a file with variable-length records, records may vary in size up to the
                           block size.




                           Sel Review
                           1. Compare physical records to logical records.
                           2. Why do you suppose variable-length records incur more storage overhead than fixed-
                              length records?
                           Ans: 1) A physical record corresponds to the unit of information read from or written to a
                           storage device. A logical record corresponds to a collection of data treated as a unit by soft-
                           ware. 2) The system needs to determine the length of each record. Two common ways to do
                           this are to end each record with an end-of-record marker, or to precede each record with a
                           length field—each of these takes space. A system that processes fixed-length records need
                           have the length recorded only once.

<!-- pág. 643 -->

                                                                                                    13.4 File Systems 589

13.4 File Systems
A file system organizes files and manages access to data. 3 File systems are responsi-
ble for:
      • File management—providing the mechanisms for files to be stored, refer-
        enced, shared, and secured.
      • Auxiliary storage management —allocating space for files on secondary or
        tertiary storage devices.
      • File integrity mechanisms —ensuring that the information stored in a file is
        uncorrupted. When file integrity is assured, files contain only the informa-
        tion that they are intended to have.
      • Access methods—how the stored data can be accessed.
  The file system is concerned primarily with managing secondary storage space, par-
ticularly disk storage, but it can access file data stored on other media (e.g., main
memory).
       File systems enable users to create, modify, and delete files; they should also
 be able to structure files in a manner most appropriate for each application and ini-
tiate data transfer between files. Users should also be able to share each other's files
in a carefully controlled manner to build upon each other's work. The mechanism
tor sharing files should provide various types of controlled access such as read
access, write access, execute access or various combinations of these.
       File systems should exhibit device independence —users should be able to refer
to their files by symbolic names rather than having to use physical device names. Sym-
 bolic names are logical, user-friendly names, such as myDi r e c t o r y : m y F i l e . t x t .
Physical device names specify where a file can be found on a device, e.g., disk 2,
 blocks 782-791. Symbolic names allow file systems to give users a logical view of their
data by assigning meaningful names to files and file operations. A physical view is
concerned with the layout of file data on its storage device and the device-specific
  operations that manipulate the data. The user should not have to be concerned with
the particular devices on which data is stored, the form the data takes on those
devices or the physical means of transferring data to and from them.
       Designing a file system requires knowledge of the user community, including
the number of users, the average number and size of files per user, the average
duration of user sessions, the nature of applications to be run on the system, and the
like. These factors must be carefully considered to determine the most appropriate
file organizations and directory structures.
       To prevent either accidental loss or malicious destruction of information, file
systems should also provide backup capabilities that facilitate the creation of
redundant copies of data and recovery capabilities that enable users to restore any
lost or damaged data. In sensitive environments in which information must be kept
secure and private, such as in electronic funds transfer systems, criminal records sys-
tems, medical records systems, and so on, the file system may also provide encryp-

<!-- pág. 644 -->

590 File and Database Systems

                               tion and decryption capabilities. This makes information useful only to its intended
                               audience—those who possess the decryption keys (encryption and decryption are
                               discussed in Section 19.2, Cryptography; see the Operating Systems Thinking fea-
                               ture, Encryption and Decryption).

                               Self Review
                               1. (T/F) File systems manage data only on secondary storage.
                               2. In what ways is file system management similar to virtual memory management?
                               Ans: 1) False. File systems manage files, which represent named collections of data that can
                               be stored on any medium, including main memory. 2) File system management entails allo-
                               cating storage, hiding the physical view of storage from applications and controlling access to
                               storage.


                               13.4.1 Directories
                               Consider a large-scale timesharing system supporting a large community of users.
                               Each user may have several accounts; each account may have many files. Some files
                               may be small, such as e-mail messages. Other files may be large, such as a master list
                               of parts in an inventory control application.
                                     It is common for user accounts to contain hundreds and even thousands of files.
                               With a user community of several thousand users, a system's disks might easily con-
                               tain millions of files. These files need to be accessed quickly to limit response times.
                                     To organize and quickly locate files, file systems use directories, which are file-
                               containing the names and locations of other files in the file system. Unlike other files,
                               a directory does not store user data. Figure 13.1 lists several common directory fields.




                Operating Systems Thinking
    Encryption and Decryption
    Years ago information processed       especially the Internet. Transmis-         on a wide scale years ago. As pro-
    by a computer was largely con-        sion media are insecure and vul-           cessor power continues to dra-
    fined to one local computer sys-      nerable, so to protect that                matically increase, more systems
    tem and access to it could be         information, operating systems             will incorporate encryption and
    tightly controlled. Operating sys-    software often provides capabili-          decryption into more applica-
    tems running on today's high-         ties for encryption and decryp-            tions, especially applications that
    powered computer systems pass         tion. Both of these operations can         involve vulnerable network trans-
    massive amounts of information        be so processor intensive, that it         mission.
    between computers on networks.        was impractical to employ them

<!-- pág. 645 -->

                                                                                                   13.4 File Systems 591

 Directory Field       Description
 Name                  Character string representing the file's name.
 Location              Physical block or logical location of the file in the file system (i.e.,
                       a pathname).
 Size                  Number of bytes consumed by the file.
 Type                  Description of the file's purpose (e.g., data file or directory file).
 Access time           Time the file was last accessed.
 Modified time         Time the file was last modified.
 Creation time         Time the file was created.

Figure 13.1 | Directory file contents example. 4, 5, 6


Single-Level File System
The simplest file system organization is a single-level (or flat) directory structure. In
this implementation, the file system stores all of its files using one directory.7 In a
single-level file system, no two files can have the same name. Because most environ-
ments contain a large number of files, many of which use the same name, single-
level file systems are rarely implemented.

Hierarchically Structured File System
A more appropriate file system for most environments may be organized as follows
(Fig. 13.2). A root indicates where on the storage device the root directory begins.
Directories are files that can point to other directories and files. In Fig. 13.2, the
root directory points to the various user directories. A user directory contains an
entry for each of that user's files; each entry points to the location of the corre-
sponding file on the storage device.
       File names need be unique only within a given user directory. In such hierar-
chically structured file systems, each directory may contain several subdirectories
but no more than one parent directory. The name of a file is usually formed as the
pathname from the root directory to the file. For example, in a two-level file system
 with users SMITH, JONES and DOE, in which JONES has files PAYROLL and
INVOICES, the pathname for file PAYROLL might be formed as
ROOT:JONES:PAYROLL. In this example, ROOT indicates the root directory,
  and the use of a colon (:) delimits different pieces of the pathname.
       Hierarchical file systems are implemented by most general-purpose file sys-
tems, but the name of the root directory and the type of delimiter can vary between
file systems. A Windows file system's root directory is specified by a letter followed
 by a colon (e.g., C:), and a UNIX-based file systems uses a slash (/). Windows sys-
tems use a backslash (e.g., C : \ J o n e s \ P a y r o l l ) as a delimiter and UNIX-based sys-
tems use a slash (e.g., / j o n e s / p a y r o l l ) . Various Linux and Windows XP file
systems are considered in depth in the case studies (see Section 20.7.3, Second
Extended File System (ext2fs), and Section 21.8.2, NTFS).

<!-- pág. 646 -->

592   File and Database Systems




                             Figure 13.2 | Two-level hierarchical file system.

                             Relative Pathnames
                             Many file systems support the notion of a working directory to simplify navigation
                             using pathnames. The working directory (represented by the directory entry " . " in
                             Windows and UNIX-based file systems) enables users to specify a pathname that
                             does not begin at the root directory. For example, suppose the current working
                             directory has been set to /home/hmd/ in the file system in Fig. 13.3. The relative
                             path to /home/hmd/os/chapter13 would be o s / c h a p t e r l 3 . 8 This feature reduces
                             the size of the pathname when accessing files. When a file system encounters a rela-
                             tive pathname, it forms the absolute path (i.e., the path beginning at the root) by
                             concatenating the working directory and the relative path. The file system then
                             traverses the directory structure to locate the requested file.
                                    The file system typically maintains a reference to the working directory's par-
                             ent directory, the directory one level higher in the file system hierarchy. For exam-
                             ple, in Fig. 13.3, home is the parent directory for the hmd, pjd and drc directories. In
                             Windows and UNIX-based systems,".." is a reference to the parent directory.9

                             Links
                             A link is a directory entry that references a data file or directory that is typically
                             located in a different directory.10 Users often employ links to simplify file system

<!-- pág. 647 -->

                                                                                             13.4 File Systems 593




Figure 13.3 | Example hierarchical file system contents.


navigation and to share files. For example, suppose that a user's working directory is
  /home/drc/ and the user shares another user's files located in the /home/hmd/os/
directory. By creating a link to /home/hmd/os/ in the user's working directory, the
user can access the shared files simply using the relative pathname o s / .
       A soft link (also called a symbolic link in UNIX-based systems, a "shortcut"
 on Windows systems and "alias" on MacOS systems) is a directory entry containing
the pathname for another file. The file system locates the target of the soft link by
traversing the directory structure using the specified pathname. 11
       A hard link is a directory entry that specifies the location of the file (typically
a block number) on the storage device. The file system locates a hard link's file data
by directly accessing the physical block it references.12
       Figure 13.4 illustrates the difference between soft links and hard links. Files
foo and bar are located at block numbers 467 and 843, respectively. The directory
entry foo_hard is a hard link because it specifies the same block number (467) as
foo's directory entry. The directory entry f oo_sof t is a soft link because it specifies
the pathname for f oo (in this case, . /f oo).
       Recall from Section 12.9 that disk reorganization and defragmentation can be
used to improve disk performance. During such operations, the physical location of
a file can change, requiring the file system to update the file's location in its direc-
tory entry. Because a hard link specifies a physical location of a file, the hard link
references invalid data when the physical location of the corresponding file
changes. To address this issue, a file system can store in a file a pointer to each of its
hard links. When the file's physical location changes, the file system can use these
pointers to find hard links that require updating.

<!-- pág. 648 -->

594 File and Database Systems




                           Figure 13.4 | Links in a file system.
                                 Because soft links store the logical location of the file in the file system, which
                           does not change during defragmentation or disk reorganization, they do not require
                           updating when file data is moved. However, if a user moves a file to a different direc-
                           tory or renames the file, any soft links to that file are no longer valid. This behavior
                           can be useful in some cases. For example, a user may wish to replace a program file
                           with a new version of the program with the same name. In this case, the file that was
                           originally linked can be moved, renamed or replaced, but the soft link will continue to
                           reference a valid file (the new version of the program). Traditionally, file systems do
                           not update soft links when a file is moved to a different directory.
                                 When a user destroys a link to a file, the file system must determine whether
                           to destroy the corresponding file as well. For this purpose, file systems typically
                           maintain a count of the number of hard links to a file. When the count reaches zero,
                           the file system contains no references to the file data, so the file can be safely
                           removed. Because soft links do not reference the physical location of file data, they
                           are not considered when determining whether a file should be destroyed.

                           Self Review
                           1. Why are single-level file systems inappropriate for most systems?
                           2. Describe the difference between hard links and soft links.
                           Ans: 1) The reason is that most systems require that the file system support multiple files of
                           the same name, a feature that single-level file systems do not provide. 2) Hard links are direc-
                           tory entries that specify the location of a file on its storage device; soft links specify a file's
                           pathname. Hard links reference the same data even if the file name changes. Soft links locate
                           a file according to its logical location in the file system. Thus, the data referenced by a soft
                           link's pathname can change when a new file is assigned that pathname.


                           13.4.2 Metadata
                           Most file systems store data other than user data and directories, such as the loca-
                           tions of a storage device's free blocks (to ensure that new file data does not over-

<!-- pág. 649 -->

                                                                                           13.4 File Systems 595
write blocks that are being used) and the time at which a file was last modified (for
accounting purposes). This information, called metadata, protects the integrity of
the file system and cannot be modified directly by users.
       Before a file system can access data, its storage device is typically formatted.
Formatting is a system-dependent operation, but typically entails inspecting the stor-
age device for any unusable sectors, erasing any data on the device and creating the
file system's root directory. Many file systems also create a superblock to store infor-
mation that protects the integrity of the file system. A superblock might contain:
     • a file system identifier that uniquely identifies the type of file system
     • the number of blocks in the file system
     • the location of the storage device's free blocks
     • the location of the root directory
     • the date and time at which the file system was last modified
     • information indicating whether the file system needs to be checked (e.g.,
       due to a system failure that prevented buffered data from being written to
       secondary storage). 13 ' 14 ' 15
If the superblock is corrupted or destroyed, the file system might be unable to
access file data. Subtle errors in superblock data (such as the location of the storage
device's free blocks) could cause the file system to overwrite existing file data. To
reduce the risk of lost data, most file systems distribute redundant copies of the
superblock throughout the storage device. Thus, the file system can use redundant
copies of the superblock to determine whether the primary superblock is damaged
and, if so, replace it.

File Descriptors
When a file is opened, the operating system first locates information about the file
by traversing the directory structure. To avoid further (possibly lengthy) traversals,
the system maintains a table in main memory that keeps track of open files. In many
systems, the file open operation returns a file descriptor, a non-negative integer that
indexes into the open-file table. From this point on, access to the file is directed
through the file descriptor.
      The open-file table often contains file control blocks. These specify the informa-
tion that the system needs to manage a file, sometimes called file attributes. They are
highly system-dependent structures. A typical file control block might include a file's
     • symbolic name
     • location in secondary storage
     • organization structure (e.g., sequential, direct access, and so on)
     • device type (e.g., hard disk, CD-ROM)
     • access control data (such as which users can access the file and the type of
       access that is permitted)

<!-- pág. 650 -->

596 File and Database Systems

                                  • type (data file, object program, C source program, and so on)
                                  • disposition (permanent vs. temporary)
                                  • creation date and time
                                  • date and time last modified
                                  • access activity counts (number of reads, for example).
                                Ordinarily, file control blocks are maintained on secondary storage. They are
                           brought to main memory when a file is opened to improve the efficiency of file
                           operations.

                           Self Review
                           1. Why should the file system maintain redundant copies of critical metadata such as super-
                              blocks?
                           2. Why do file systems prevent users from accessing metadata directly?
                           ANS: 1) Because metadata such as superblocks store information that identify the file sys-
                           tem and provide the location of its files and free space, file system data could be lost if the
                           superblock is damaged. Maintaining multiple copies of the superblock data enables the sys-
                           tem to recover if the superblock is damaged, which reduces the risk of data loss. 2) If access
                           were not tightly controlled, accidental misuse of file system metadata could lead to inconsis-
                           tencies and loss of data.



                           13.4.3      Mounting
                           Users often require access to information that is not part of the native file system (i.e..
                           the file system that is permanently mounted on a particular system and whose root is
                           referenced by the root directory). For example, many users store data on a second
                           hard disk, DVD or another workstation in a network in computers. For this reason,
                           operating systems provide the ability to mount multiple file systems. Mounting com-
                           bines multiple file systems into one namespace—a set of files that can be identified by
                           a single file system. The unified namespace allows users to access data from different
                           locations as if all files were located inside the native file system.16
                                  The mount command assigns a directory, called the mount point, in the native
                           file system to the root of the mounted file system. Early Windows file systems pro-
                           vided a flat mounting structure; each mounted file system was assigned a letter and
                           was located at the same level of the directory structure. Typically for example, the
                           file system containing the operating system was mounted at C: and the next file sys-
                           tem at D:.
                                  UNIX-compatible file systems (such as the UNIX File System, the Fast File
                           System and the Second Extended File System), and versions of Microsoft's NTFS
                           5.0 and greater, feature mount points that can be located anywhere in the file sys-
                           tem. The contents of the native file system's directory at the mount point are tem-
                           porarily hidden while another file system is mounted at that directory.17-18
                                  In UNIX systems, some file systems are mounted at one of the directories
                           located in /mnt/. Consider in Fig. 13.5. The mount command places the root of file

<!-- pág. 651 -->

                                                                                                  13.4 File Systems 597




Figure 13.5 | Mounting a file system.
system B over the directory /mnt/newfs/ of file system A. After the mount opera-
tion, files from file system B can be accessed from /mnt/newf s/ in file system A.
For example, one can access the file system B's / u s r / b i n / directory from file sys-
tem As / m n t / n e w f s / u s r / b i n / directory. When a file system is mounted, the con-
tents of the directory at the mount point are unavailable to users until the file
system is unmounted.
      File systems manage mounted directories with mount tables. These contain
information about mount point pathnames and the device that stores each mounted
file system. When the native file system encounters a mount point, it uses the mount
table to determine the device and type of file system that is mounted at that direc-
tory. Most operating systems support multiple file systems for removable storage,
such as Universal Disk Format (UDF) for DVDs and the ISO 9660 file system for
CDs. Once the operating system has determined the device's file system type, it uses
the appropriate file system to access the file on the specified device. The unmount
command allows the user to disconnect mounted file systems. This call updates the
mount table and enables users to access any files that were hidden by the mounted
system.19
      Users can create soft links to files in mounted file systems. When the file sys-
tem encounters the soft link, it uses the specified pathname to traverse the directory

<!-- pág. 652 -->

598 File and Database Systems
                           structure. When the file system encounters a mount point, it begins the directory
                           traversal from the root of the file system mounted at the mount point. A hard link,
                           however, specifies a block number that is associated with the device that stores the
                           link. In general, users cannot create hard links between two file systems, because
                           they are often associated with different storage devices.

                           Self Review
                            1. (T/F) The mounted file system and the native file system must be of the same type.
                            2. Can a file system create a hard link to a file in a mounted file system?
                           Ans: 1) False. A primary advantage to mounting file systems is that they enable multiple
                           heterogeneous file systems to be accessed via a single file system interface. 2) No, hard links
                           reference device-specific block numbers corresponding to the file system on which they are
                           stored, so they cannot be used to specify physical locations in other file systems.



                            13.5 File Organization
                            File organization refers to the manner in which the records of a file are arranged on
                            secondary storage.20 Several file organization schemes have been implemented:
                                  • Sequential—Records are placed in physical order. The "next" record is the
                                    one that physically follows the previous record. This organization is natural
                                    for files stored on magnetic tape, an inherently sequential medium. Disk
                                    files may also be sequentially organized, but for various reasons discussed
                                    later in this chapter, records in a sequential disk file are not necessarily
                                    stored contiguously.
                                  • Direct—Records are directly (randomly) accessed by their physical
                                    addresses on a direct access storage device (DASD). The application user
                                    places the records on DASD in any order appropriate for a particular
                                    application.21
                                  • Indexed sequential—Records on disk are arranged in logical sequence
                                    according to a key contained in each record. The system maintains an index
                                    containing the physical addresses of certain principal records. Indexed
                                    sequential records may be accessed sequentially in key order, or they may
                                    be accessed directly, by a search through the system-created index.
                                  • Partitioned—This is essentially a file of sequential subfiles. Each sequential
                                    subfile is called a member. The starting address of each member is stored in
                                    the file's directory. Partitioned files have been used to store program librar-
                                    ies or macro libraries.



                           Self Review
                           1. Which file organization technique is most appropriate for tape storage? Why?
                           2. For which media is direct file organization most appropriate?

<!-- pág. 653 -->

                                                                                                     13.6 File Allocation 599
Ans: 1) Sequential file organization is most appropriate for tape storage because it is a
sequential access medium. 2) Direct file organization is most appropriate for random access
devices, such as main memory and moving-head disks.



13.6 File Allocation
The problem of allocating and freeing space on secondary storage is somewhat like
that experienced in main memory allocation under variable-partition multipro-
gramming. As files are allocated and freed, it is common for the space on secondary
storage to become increasingly fragmented, with files being spread throughout
widely dispersed blocks; this can cause performance problems. 22 As discussed in
Section 12.9, the system can perform defragmentation, but doing so while the file
system is in use can lead to poor response times.
      Because processes often access portions of a file sequentially, this leads us to
try to store all the data in a file contiguously to improve performance. For example,
users searching a file for information often use file scan options to locate the next
record or the previous record. These scans should result in minimal seek activity
when possible.
      Spatial locality tells us that once a process has referred to a data item on a
page, it is likely to reference additional data items on that page; it is also likely to
reference data items on pages contiguous to that page in the user's virtual address
space. Therefore it is desirable to store nonresident, logically contiguous pages of a
user's virtual memory space as physically contiguous pages on secondary storage,
especially if several pages are stored per physical block.
      Because files often grow or shrink over time, and because users rarely know in
advance how large their files will be, contiguous storage allocation systems have
generally been replaced by more dynamic noncontiguous storage allocation sys-
tems. As we will see, these systems attempt to allocate parts of files contiguously to
exploit locality, but enable files to change in size with minimal overhead.

Self Review
1. Compare the problem of fragmentation in file systems to that in virtual memory systems.
2. Why is it beneficial to allocate storage in blocks of a system's page size or a multiple of the
   page size?
Ans: 1) In both systems, fragmentation can lead to wasted storage if no data is small
enough to fit in the storage "holes." Unlike main memory, which provides essentially uniform
access time for each of its addresses, secondary storage devices such as disks can exhibit high
access times if data is fragmented, because the storage device is likely to perform many seek
operations to access file data. 2) This enables the system to exploit spatial locality by using a
single I/O operation to load into memory several pages that are likely to be referenced in the
near future.

13.6.1 Contiguous File Allocation
File systems that employ contiguous allocation place file data at contiguous
addresses on the storage device. The user specifies the amount of space needed to

<!-- pág. 654 -->

600 File and Database Systems

                            store the file in advance. If the desired amount of contiguous space is not available,
                            the file cannot be created.
                                   An advantage of contiguous allocation is that successive logical records typi-
                            cally are physically adjacent to one another. This speeds access compared to systems
                            in which successive logical records are dispersed throughout secondary storage,
                            requiring additional seek operations. Locating file data is straightforward, because
                            the directories need store only the address of the start of the file and the file's length.
                                   A disadvantage to contiguous allocation schemes is that they exhibit the same
                            types of external fragmentation problems inherent in memory allocation for vari-
                            able-partition multiprogramming systems (see Section 9.9). Also, contiguous alloca-
                            tion can result in poor performance as files grow and shrink over time. If a file
                            grows beyond the size originally specified and there are no adjacent free blocks, the
                            file must be transferred to a new area of adequate size, leading to additional I/O
                            operations. To provide for anticipated expansion, users might overestimate their
                            storage needs, leading to inefficient storage allocation. Contiguous allocation is par-
                            ticularly useful for write-once CDs and DVDs, which do not allow files to grow or
                            shrink over time.

                           Self Review
                            1. Explain the benefits of using a contiguous file allocation scheme.
                            2. Explain the disadvantages of using a contiguous file allocation scheme.
                           Ans: 1) Locating file data is straightforward. Also, files can be accessed quickly, because the
                           storage device does not need to perform lengthy seeks after it locates the first block.
                           2) Contiguous allocation schemes can lead to significant external fragmentation and poor
                           performance when a file grows too large to be stored contiguously at its current location and
                           must be moved.

                            13.6.2 Linked-List Noncontiguous File Allocation
                            Most file systems implemented on rewritable secondary storage media use noncon-
                            tiguous allocation. One approach to noncontiguous file allocation is to implement a
                            sector-based linked list. In this scheme, each directory entry points to the first sector
                            of a file on a moving-head storage device such as a hard disk. The data portion of a
                            sector stores the contents of the file; the pointer portion stores a pointer to the file's
                            next sector. Because files often occupy multiple sectors, a disk's read/write head
                            must sequentially access each file sector until it finds the requested record.
                                  Noncontiguous allocation solves some of the problems inherent in contiguous
                            allocation schemes, but it has its own drawbacks. Because a file's records may be
                            dispersed throughout the disk, direct and sequential access to logical records can
                            involve many additional seeks besides the first seek to the file. Pointers in the list
                            structure also reduce the amount of space available for file data in each sector.
                                  One scheme used to manage secondary storage more efficiently and reduce file-
                            traversal overhead is called block allocation. In this scheme, instead of allocating indi-
                            vidual sectors, blocks (often called extents) of contiguous sectors are allocated. The
                            system tries to allocate new blocks to a file by choosing free blocks as close as possible

<!-- pág. 655 -->

                                                                                          13.6 File Allocation 601

to existing file data blocks, preferably on the same cylinder. Each access to the file
involves determining the appropriate block and sector within the block.
      In block chaining, each entry in a directory points to the first block of a file
(Fig. 13.6). The blocks comprising a file each contain two portions: a data block and
a pointer to the next block. The smallest unit of allocation is a fixed-size block that
ordinarily consists of many sectors. Locating a particular record requires searching
the block chain until the appropriate block is found, then searching that block until
the appropriate record is found. The chain must be searched from the beginning,
and if the blocks are dispersed throughout the disk (which is normal), the search
process can be slow, as block-to-block seeks occur. Insertion and deletion are per-
formed simply by modifying the pointer in the previous block. Some systems use
doubly linked lists to facilitate searching; the blocks are threaded both forward and
backward so that a search may proceed in either direction.
      Block size can significantly impact file system performance. If blocks are split
between files (e.g., a file that requires 2.5 blocks occupies three blocks on disk),
large block sizes can result in a considerable amount of internal fragmentation.
Large block sizes, however, reduce the number of I/O operations required to access
file data. Small block sizes may cause file data to be spread across multiple blocks,
which tend to be dispersed throughout the disk. This could lead to poor perfor-
mance. In practice, block sizes typically range from one to eight kilobytes.23-24>25




Figure 13.6 | Noncontiguous file allocation using a linked list.

<!-- pág. 656 -->

602   File and Database Systems

                             Self Review
                             1. What is the primary disadvantage of linked-list noncontiguous file allocation?
                             2. What are the trade-offs between choosing a large block size and a small block size?
                             A n s : 1) In the worst case, the file system must access each of the file's blocks (when using a
                             singly linked list) or half of the file's blocks (when using a doubly linked list) to locate file
                             data, which could lead to long access times. As we discuss in the next sections, several popu-
                             lar file allocation techniques place a lower limit on access times, which tends to improve per-
                             formance. 2) A large block size generally reduces the number of I/O operations required to
                             retrieve a particular record, at the cost of wasted storage due to internal fragmentation. A
                             small block size reduces the amount of internal fragmentation but if file data is scattered
                             throughout a device such as a hard disk, it can lead to poor access times.

                             13.6.3 Tabular Noncontiguous File Allocation
                             Tabular noncontiguous file allocation stores pointers to file blocks contiguously in
                             tables to reduce the number of lengthy seeks required to access a particular record
                             (Fig. 13.7). Directory entries indicate the first block of a file. For example, the first
                             block of file C in Fig. 13.7 is 2. The current block number is used as an index into the
                             block allocation table to determine the location of the next block. Therefore, the
                             value of file C's next block number is stored in location 2 in the block allocation
                             table. In this case, file C's next block is 5. The block allocation table's entry for a
                             file's last block stores the value null.
                                     Because the pointers that locate file data are stored in a central location, the
                             table can be cached so that the chain of blocks that compose a file can be traversed
                             quickly, which improves access times. Locating the last record of a file may require
                             the file system to follow many pointers in the block allocation table. To reduce
                             access times, the block allocation table should be stored contiguously on disk and
                             cached in main memory. When a file system contains a small number of blocks, this
                             can be accomplished relatively easily. For example, a 1.44MB floppy disk using 1KB
                             blocks contains 1,440 blocks, which can be addressed using an 11-bit number. The
                             size of the corresponding block allocation table is the size of each block address
                             multiplied by the number of blocks—in this case, approximately 2,000 bytes.
                                     For file systems that contain a greater number of blocks, the size of each file
                             allocation table entry, and thus the size of the table, is greater. For example, a
                             200GB disk using 4KB blocks contains 50,000,000 blocks, which can be addressed
                             using a 26-bit number. In this case, the block allocation table consumes over
                             160MB. In the preceding example, the file allocation table was stored in only two
                             blocks; however, in this case the file allocation table is spread across tens of thou-
                             sands of blocks, which could lead to fragmentation. If file data is dispersed across
                             the storage device, the file's table entries will be spread throughout the block table.
                             Thus, the system might need to load into memory several blocks of the block alloca-
                             tion table, which could lead to poor access times. Also, if the block allocation table
                             is cached, it can consume significant memory.
                                     A popular implementation of tabular noncontiguous file allocation is
                             Microsoft's FAT file system. Microsoft first incorporated a file allocation table

<!-- pág. 657 -->

                                                                                       13.6 File Allocation 603




Figure 13.7 | Tabular noncontiguous file allocation.

(FAT) into its release of MS-DOS 1.0 (see the Mini Case Study, MS-DOS). 26 The
FAT stores information about each block, including whether the block is currently
allocated and the number of the next block in the file. The first version of the FAT
file system, called FAT12, allocated 12 bits per entry in the FAT. This meant that a
disk managed by FAT12 could contain no more than 2 12 (4,096) blocks. This was
sufficient for small disks containing few files, but FAT12 resulted in significant

<!-- pág. 658 -->

604 File and Database Systems
                                wasted memory for larger disks. For example, to address an entire 64MB disk, the
                                file system required a minimum block size of 8KB. In this case, small files could
                                incur significant internal fragmentation. As disks grew larger, Microsoft created
                                FAT16 and FAT32, which increased the number of addressable blocks and enabled
                                the file system to access large disks using small block sizes.27-28
                                     When Microsoft introduced FAT in the early 1980s, disk drives were small.
                                allowing the FATs to be small and efficient. FAT continues to be effective for low-
                                capacity storage media such as floppy disks.29


                                Self Review
                                1. How is tabular file allocation more efficient than linked-list file allocation?
                                2. What was the primary limitation of FAT12? How did later versions of FAT solve this
                                   problem? Why is FAT no longer appropriate to manage today's hard disks?



                 Mini Case Study
   MS-DOS
    Microsoft MS-DOS was based on         For the remainder of the year,            run their first line of personal
    a disk operating system written by    Paterson improved the operating           computers. 40 They attempted to
    Tim Paterson for Seattle Comput-      system, which was released as 86-         license the popular CP/M from
    ing Products (SCP) in 1980.30 At      DOS.33                                    Digital Research, but CP/M creator
    the time, SCP needed an operat-              Several important goals            Gary Kildall refused to sign IBM's
    ing system for their memory           guided the design of 86-DOS.              highly restrictive nondisclosure
    board for the new Intel 16-bit        First, it had to be compatible with       agreements. 41 In the meantime,
    8086 processor.31 Digital             programs written for CP/M to              IBM worked with Microsoft to
    Research's (CP/M) Control Pro-        exploit its large application base,       produce software for the new
    gram for Microcomputers was the       requiring 86-DOS to have a similar        IBM PCs.42 Microsoft had been
    major microcomputer operating         application programming inter-            licensing 86-DOS from SCP for sev-
    system at the time, but an            face (API).34, 35, 36 To make 86-DOS      eral months for development pur-
    updated version for the 8086 pro-     more efficient than CP/M, Pater-          poses and was asked by IBM to
    cessor was not ready when SCP's       son wrote it in assembly language         purchase all rights to DOS. 43, 44, 45
    memory boards went on sale.32         and incorporated the File Alloca-         SCP accepted the offer and 86-
    Paterson was asked to write a         tion Table (FAT) disk management          DOS, renamed MS-DOS, became
    new operating system, which was       system, based on Microsoft's              the de facto operating system for
    named QDOS (Quick and Dirty           Stand-Alone Disk BASIC system             the IBM Personal Computer and
    Operating System). As the name        (see Section 13.6.3, Tabular Non-         compatible microcomputers. 46
    implies, it was completed in just a   contiguous File Allocation). 37, 38, 39
    few months but had not been                 In 1981, IBM solicited ven-
    thoroughly tested and debugged.       dors for an operating system to

<!-- pág. 659 -->

                                                                                                   13.6 File Allocation 605

Ans: 1) Block allocation tables can store the locations of the file system's data contiguously,
reducing the number seeks required to locate a particular record. 2) FAT12 could not address
more than 4,096 blocks, which necessitated large block sizes to address large disks, leading to
internal fragmentation. FAT16 and FAT32 addressed this issue by increasing the number of
blocks the file allocation table could reference by allowing more bits per entry. This increased
the size of the file allocation table, which led to increased file access times and wasted mem-
ory in file system caches.


13.6.4 Indexed Noncontiguous File Allocation
Another popular noncontiguous allocation strategy is to use index blocks to point to
data in a file. Each file has one or more index blocks. An index block contains a list of
pointers that point to file data blocks. A file's directory entry points to its index block.
To locate a record, the file system traverses the directory structure to determine the
location of the file's index block on disk. It then loads the index block into memory
and uses the pointers to determine the physical location of a particular block. Often,
large files will consume more blocks than the number of pointers that a single index
block can store. Most index block implementations reserve the last few entries to
store pointers to more index blocks, a technique called chaining (Fig. 13.8).
       The primary advantage of index block chaining over simple linked-list imple-
mentations is that searching may take place in the index blocks themselves. They may
be kept close together in secondary storage to minimize seeking. To speed file tra-
versal, index blocks are typically cached in main memory. Once the appropriate
record is located via the index blocks, the data block containing that record is read
into main memory. Index block chaining is analogous to storing a separate block allo-
cation table for each file, which can be more efficient than systemwide block alloca-
tion tables, because references to each file's blocks are stored contiguously in each of
its index blocks. File systems typically place index blocks near the data blocks they
reference, so the data blocks can be accessed quickly after their index block is loaded.
       Index blocks are called inodes (i.e., index nodes) in UNIX-based operating
systems.47 A file's inode stores the file's attributes, such as the its owner, size, time of
creation and the time of last modification. It also stores the addresses of some of the
file's data blocks and pointers to continuation index blocks called indirect blocks.
Inode structures support up to three levels of indirect blocks (Fig. 13.9). The first
indirect block points to data blocks; these data blocks are singly indirect. The sec-
ond indirect block contains pointers that reference only other indirect blocks. These
indirect blocks point to data blocks that are doubly indirect. The third indirect
block points only to other indirect blocks that point only to more indirect blocks
that point to data blocks; these data blocks are triply indirect. The power of this
hierarchical structure is that it places a relatively low limit on the maximum number
of pointers that must be followed to locate file data—it enables inodes to locate any
data block by following at most four pointers (the inode and up to three levels of
indirect blocks).
        Inodes are investigated in detail in the Linux case study in Section 20.7.3, Sec-
ond Extended File System (ext2fs). Another file system that uses index blocks is

<!-- pág. 660 -->

606 File and Database Systems




                           Figure 13.8 | Index block chaining.


                           Microsoft's NTFS, which is discussed in the Windows XP case study in
                           Section 21.8.2, NTFS. Indexed noncontiguous allocation yields good performance
                           with low overhead for many environments and has been implemented in many gen-
                           eral-purpose computer systems.

<!-- pág. 661 -->

                                                                                            13.6   File   Allocation   607




Figure 13.9 | Inode structure.


Self Review
1. How does placing index blocks near the data they reference improve access time?
2. Compare indexed noncontiguous file allocation to tabular noncontiguous file allocation
   when files are, on average, small (e.g., less than or equal to one block).

<!-- pág. 662 -->

608 File and Database Systems

                           Ans: 1) When the file system reads an index block, the disk arm will be near the data it ref-
                           erences, reducing or even eliminating seeks. 2) In tabular noncontiguous file allocation, a
                           small file will consume one data block and one entry in the block allocation table. In indexed
                           noncontiguous file allocation, a small file requires a block for the index block and one data
                           block, which results in substantial storage overhead. Further, several small files can be
                           located by loading a single block of the file allocation table into memory. A file system usinsg
                           indexed file allocation must access a different index block for each file that it references,
                           which can slow access time due to many seeks.



                            13.7 Free Space Management
                            As files grow and shrink, file systems maintain a record of the location of blocks
                            that are available to store new data (i.e., free blocks). A file system may use a free-
                           list to keep track of free space (Fig. 13.10). The free list is a linked list of blocks con-
                            taining the locations of free blocks. The last entry of a free list block stores a pointer
                            to the next free list block; the last entry of the last free list block stores a null
                           pointer to indicate that there are no further free list blocks. When the system needs
                           to allocate a new block to a file, it finds the address of a free block in the free list.
                           writes the new data to a free block and removes that block's entry from the free list.
                                  The file system typically allocates blocks from the beginning of the free list
                           and appends freed blocks to the end of the list. Pointers to the head and tail of the
                           free list can be stored in the file system's superblock. A free block can be located by
                           following a single pointer; likewise, adding a block to the free list requires the sys-
                           tem to follow one pointer. Therefore, this technique requires little overhead to per-
                           form free list maintenance operations. As files are created and deleted, however,
                           the storage device's free space can become fragmented, and adjacent entries in the
                           free list will point to noncontiguous blocks. As a result, sequential file data will be
                           allocated noncontiguous blocks, which generally increases file access time. Alterna-




                           Figure 13.10 | Free space management using a free list.

<!-- pág. 663 -->

                                                                                             13.7 Free Space Management 609

tively, the file system can attempt to allocate contiguous blocks by searching or sort-
ing the free list, both of which incur significant overhead. 48
      Another common method of free space management is the bitmap
 (Fig. 13.11). A bitmap contains one bit for each block in the file system, where the
 ith bit corresponds to the ith block in the file system. In one implementation, a bit in
the bitmap is 1 when the corresponding block is in use and 0 when it is not. 49 The
bitmap generally spans multiple blocks. Thus, if each block stores 32 bits, the 15th
bit of the third bitmap corresponds to block 79. One of the primary advantages to
bitmaps over free lists is that the file system can quickly determine if contiguous
blocks are available at certain locations on secondary storage. For example, if a user
 appends data to a file that ends at block 60, the file system can directly access the
61st entry of the bitmap to determine if the block is free. A disadvantage to bitmaps
is that the file system may need to search the entire bitmap to find a free block,
resulting in execution overhead. In many cases this overhead is trivial, because pro-
cessor speeds are so much faster than I/O speeds in today's systems.

Self Review
1. Compare free lists to free space bitmaps in terms of time required to find the next free
   block, reclaim a free block and allocate a contiguous group of blocks.
2. Which free space management technique mentioned in this section results in lowest stor-
   age overhead?
Ans: 1) Free lists are more efficient for allocating one free block, because the file system
need only follow the pointer to the head of the free list. Bitmaps require an exhaustive search
until a free block is found. Given a particular block, file systems can use bitmaps to deter-
mine if there are contiguous free blocks by directly inspecting their entries. To find contigu-
 ous blocks in a free list, the file system must search or sort the free list, requiring significant
execution time on average. 2) Often a bitmap is smaller than a free list, because a bitmaprep-




Figure 13.11 | Free space management using a bitmap.

<!-- pág. 664 -->

610 File and Database Systems

                                 resents each block using a single bit, but a free list uses a block number, which can be as large
                                 as 32 or 64 bits. A file system's bitmap size is constant, while the free list's size depends on the
                                 number of free blocks in the system. Thus, when a file system contains few free blocks, a free
                                 list consumes less space than a bitmap.

                                 13.8 File Access Control
                                 Files are often used to store sensitive data such as credit card numbers, passwords,
                                 social security numbers and more, so file systems should include mechanisms to
                                 control user access to data (see the Operating Systems Thinking feature, Security).
                                 In the sections that follow, we discuss common techniques for implementing file
                                 access control.

                                 13.8.1 Access Control Matrix
                                One way to control access to tiles is to create a two-dimensional access control
                                matrix (Fig. 13.12) listing all the users and all the files in the system. The entry aij is
                                1 if user i is allowed access to file j; otherwise aij - 0. For example, in Fig. 13.12, user
                                5 can access all ten files and user 4 can access only file 1. In an installation with a
                                large number of users and a large number of files, this matrix would be quite large.
                                Further, allowing one user access to another user's files is the exception rather than
                                the rule, so the matrix would be extremely sparse. To make such a matrix concept
                                useful, it would be necessary to use codes to indicate various kinds of access such as
                                read-only, write-only, execute-only, read/write, and so on. This could substantially
                                increase the size of the matrix.



                Operating Systems Thinking
    Security
    Computer security has always            and were kept in secure rooms;                easy to "crack" w i t h today's high-
    been an important concern, espe-        there was no networking. Today's              powered computers, so much
    cially for people responsible for       systems, especially hand-held                 more sophisticated schemes have
    business-critical and mission-criti-    computers, laptops and even                   been developed. We discuss secu-
    cal systems. But the nature of the      desktop machines can easily be                rity issues throughout the book
    security problems changes w i t h       stolen. Now, virtually all systems            and devote all of Chapter 19 to
    advances in technology, so oper-        are capable of being networked,               this crucial topic. The case study
    ating systems designers must            which creates numerous chal-                  chapters on Linux and Windows
    always be evaluating new tech-          lenges as proprietary information             XP discuss security considerations
    nology trends and their suscepti-       is transmitted over insecure trans-           and capabilities in those popular
    bility to attack. Early computer        mission media. Early encryption/              operating systems.
    systems often weighed many tons         decryption schemes have become

<!-- pág. 665 -->

                                                                                                13.8 File Access Control 611




Figure 13.12 | Access control matrix.


Self Review
1. Why is file access control necessary?
2. Why are access control matrices inappropriate for most systems?
Ans: 1) Any user can reference any pathname in a file system. File systems control access to
files to protect personal and sensitive information from users that do not have proper autho-
rization. 2) Access control matrices are generally large and sparsely populated, leading to
wasted storage and inefficient access times when enforcing access control policies.



13.8.2 Access Control by User Classes
A technique that requires considerably less space than the uses of an access control
matrix is the control of access to various user classes. A common file access classifi-
cation scheme is
      • Owner—Normally, this is the user who created the file. The owner has
        unrestricted access to the file and typically can change file permissions.
      • Specified user—The owner specifies that another individual may use the file.
      • Group (or project) —Users are often members of a group working on a
        particular project. In this case the various members of the group may all be
        granted access to each other's project-related files.
      • Public—Most systems allow a file to be designated as public so that it may be
        accessed by any member of the system's user community. By default, public
        access rights typically allow users to read or execute a file, but not to write it.

<!-- pág. 666 -->

612   File and Database Systems

                                    This access control data can be stored as part of the file control block and
                              often consumes an insignificant amount of space. Security is an important issue in
                              operating system design and is covered in greater detail in Chapter 19, Security.

                             Self Review
                              1. How do user classes reduce the storage overhead incurred by access control information?
                              2. Describe the advantages and disadvantages of storing access control data as part of the
                                 file control block.
                             Ans: 1) User classes enable the file owner to grant permissions to a group of users using one
                             entry. 2) The advantage is that there is essentially no overhead if the user is granted access to
                             a file, because the file system needs to read the file control block before opening the file any-
                             way. However, if access is denied, the file system will have wastefully performed several
                             lengthy seeks to access the file control block for a file that the user cannot open.



                              13.9 Data Access Techniques
                              In many systems, several processes may be requesting file data from various files
                              spread across the storage device, leading to many seeks. Instead of instantly
                              responding to immediate user I/O demands, the operating system may use several
                              techniques to improve performance.
                                    Today's operating systems generally provide many access methods. These are
                              sometimes grouped as queued access methods and basic access methods. The
                              queued methods provide more powerful capabilities than the basic methods.
                                     Queued access methods are used when the sequence in which records are to be
                              processed can be anticipated, such as in sequential and indexed sequential accessing.
                              The queued methods perform anticipatory buffering and scheduling of I/O opera-
                              tions. Such methods attempt to have the next record available for processing as soon
                              as the previous record has been processed. More than one record at a time is main-
                              tained in main memory; this allows processing and I/O operations to be overlapped,
                              improving performance.
                                    The basic access methods are normally used when the sequence in which
                              records are to be processed cannot be anticipated, particularly with direct access-
                              ing. Also there are many situations, such as database applications, in which user
                              applications want to control record accesses without incurring the overhead of
                              anticipatory buffering. In the basic methods, the access method reads and writes
                              physical blocks; blocking and deblocking (if appropriate to the application) is per-
                              formed by the user application.
                                    Memory-mapped files map file data to a process's virtual address space
                              instead of using a file system cache.50 Because references to memory-mapped files
                              occur in a process's virtual address space, the virtual memory manager can make
                              page-replacement decisions based on each process's reference pattern. Memory-
                              mapped files also simplify application programming, because developers can access
                              file data using pointers instead of specifying read, write and seek operations.

<!-- pág. 667 -->

                                                                                       13.10 Data Integrity Protection 613

       When a process issues a write request, the data is typically buffered in main
memory (to improve I/O performance) and its corresponding page is marked as
dirty. When a memory-mapped file's modified page is replaced, the page is written
to its corresponding file on secondary storage. When the file is closed, the system
flushes all dirty pages to secondary storage. To reduce the risk of data loss due to a
system failure, dirty memory-mapped pages are flushed typically to secondary stor-
age periodically.51

Self Review
1. Compare and contrast queued access methods and basic access methods.
2. How do memory-mapped files simplify application programming?
Ans: 1) Queued access methods perform anticipatory buffering, which attempts to load
into memory a block that is likely to be used in the near future. Basic access methods do not
attempt to schedule or buffer I/O operations, which is more appropriate when the system
cannot predict future requests or when the file system must reduce the risk of losing data dur-
ing a system failure. 2) Memory-mapped files enable programmers to access file data using
pointers instead of file operations such as read, write and seek.




13.10 Data Integrity Protection
Computer systems often store critical information, such as inventories, financial
records and/or personal information. System crashes, natural disasters and mali-
cious programs can destroy this information. The results of such events can be cata-
strophic.52 Operating systems and data storage systems should be fault tolerant in
that they account for the possibility of disasters and provide techniques to recover
from them.

13.10.1 Backup and Recovery
Most systems implement backup techniques to store redundant copies of informa-
tion and recovery techniques that enable the system to restore data after a system
failure. Backup and recovery strategies can also protect systems against user-gener-
ated events, such as an unintentional deletion of important data (see the Operating
Systems Thinking feature, Backup and Recovery).
      Physical safeguards are the lowest level of data protection. Physical obstacles
such as locks and alarm systems can prevent unauthorized access to computers that
store sensitive data. Because main memory typically is volatile (i.e., it loses its con-
tents when the power is shut off), power outages can result in the loss of data not
yet transferred to secondary storage. An uninterruptable power supply (UPS) can
be used to protect data from being lost due to a power outage. 53
      Natural disasters such as fires and earthquakes can destroy all data at a site.
Thus, some organizations maintain a backup site, geographically removed from the
primary site to protect data in case of a site failure.54 Although these precautions

<!-- pág. 668 -->

 614 File and Database Systems
                            are important, they do not protect data from operating system crashes or disk-head
                            malfunctions.
                                  Performing periodic backups is the most common technique used to prevent
                            data loss. Physical backups duplicate a storage device's data at the bit level. In some
                            cases, the system copies only allocated blocks of data. Physical backups are simple
                            to implement, but they store no information about the logical structure of the file
                            system. The file system's data may be stored in different formats, depending on the
                            system architecture, so physical backups cannot easily be restored on computers
                            using different architectures. Also, because a physical backup does not read the file
                            system's logical structure, it cannot distinguish among the files it contains. Thus,
                            physical backups must record and restore the entire file system to ensure that all
                            data has been duplicated, even if most of a file system's data has not been modified
                            since the last physical backup. 55
                                  A logical backup stores file system data and its logical structure. Thus, logical
                            backups inspect the directory structure to determine which files need to be backed
                            up, then write these files to a backup device (e.g., a tape, CD or DVD) in a common,
                            often compressed, archival format. For example, the tape archive (tar) format is
                            commonly used to store, transport and back up multiple files on UNIX-based sys-
                            tems (see       www.gnu.org/software/tar/tar.html).Because        logical backups store
                            data in a common format using a directory structure, they permit operating systems
                            with different native file formats to read and restore the backup data, so file data
                            can be restored on multiple heterogeneous systems. Logical backups also enable
                            the user to restore a single file from the backup (e.g., an accidentally deleted file),




            Operating Systems Thinking
Backup and Recovery
Have you ever lost several hours       Should users be responsible for       of each change to the system?
work because of a system failure?      performing (potentially time-con-     Answering these questions
HMD was working on a massive           suming) backups or should these       requires the system administrator
project w i t h hundreds of software   be done automatically by the sys-     to balance the overhead of per-
engineers when lightning struck        tem? Backups consume significant      forming frequent backups w i t h
our building and we lost all of the    resources. How often should           the risk of lost work due to infre-
system updates for the last week.      backups be done? How much data        quent backups. Incorporating
Fortunately, each of us had back-      should be backed up each time?        backup and recovery features into
ups of our own work, but it still      Should backups be done as full        operating systems is crucial.
took us several days to recover—a      system bit images or should they
painful and costly experience.         be done w i t h incremental logging

<!-- pág. 669 -->

                                                                                        13.10 Data Integrity Protection 615

which is typically faster than restoring the entire file system. However, because log-
ical backups can read only data exposed by the file system, they may omit informa-
tion such as hidden files and metadata that are copied by a physical backup when
copying each bit on the file system's storage device. Saving files in a common format
can be inefficient due to the overhead incurred when translating between the native
file format and the archival format.56
      Incremental backups are logical backups that store only file system data that
has changed since the previous backup. The system can record which files have been
modified and write them to the backup file periodically. Because incremental back-
ups require less time and fewer resources than backing up an entire file system, they
can be performed more often, reducing the risk of lost data due to disasters.

Self Review
1. Compare and contrast logical backups and physical backups.
2. Why are physical safeguards insufficient for preventing loss of data in the event of a disas-
   ter?
Ans: 1) Logical backups are readable by file systems with different file formats, support
 incremental backups and enable fine-grained recovery, such as restoring a single file. Physical
backups are typically easier to create, because the file system structure does not need to be
traversed. However, physical backups do not support incremental or partial backups and are
typically incompatible with different systems. 2) Physical safeguards prevent access to data
but do not prevent loss of data due to natural disasters, such as fires and earthquakes, or to
hardware and power failures. In fact, there is no way to guarantee absolute security of files.


13.10.2 Data Integrity and Log-Structured File Systems
None of the techniques discussed so far address the possibility that significant activ-
ity may occur between the time of the last backup and the time at which a failure
occurs (see the Operating Systems Thinking feature, Murphy's Law and Robust
Systems). Further, backups often require a lengthy restoration process, during
which time the system is not operational.
      In systems that cannot tolerate data loss or downtime, RAID and transaction-
based file systems are appropriate. In Section 12.10, Redundant Arrays of Indepen-
dent Disks (RAID), we discussed how RAID levels 1-5 improve a system's mean-
time-to-failure and can restore data in the event of a single disk failure. We also dis-
cussed how mirroring and hot swappable disks enable RAID systems to continue to
 operate when disks fail, providing high availability.

Logging and Shadow Paging
If a system failure occurs during a write operation, the file system data may be left
in an inconsistent state. For example, an electronic transfer of funds might require a
banking system to withdraw money from one account and deposit it in another. If
the system fails between withdrawing and depositing the funds, it could lose the
money. Transaction-based logging reduces the risk of data loss by using atomic
transactions, which perform a group of operations in their entirety, or not at all. If

<!-- pág. 670 -->

616 File and Database Systems
                                an error occurs that prevents a transaction from completing, it is rolled back by
                                returning the system to the state before the transaction began. 57
                                       Atomic transactions can be implemented by recording the result of each oper-
                                ation in a log file instead of modifying existing data. Once the transaction has com-
                                pleted, it is committed by recording a special value in the log. At some time in the
                                future, the log is transferred to permanent storage. If the system fails before the
                                transaction completes, any operations recorded after the previous committed trans-
                                action are ignored. When the system recovers, it reads the log file and compares it
                                to the data in the file system to determine the state of the file system at the last conm-
                                mit point.
                                      To enable the system to undo any number of operations, in many systems the
                                log file is not deleted after its operations are written to permanent storage. Because
                                logs can become large, reprocessing transactions to find the state of the system at
                                the last commit point can be time consuming. To reduce the time spent reprocessing
                                transactions in the log, most transaction-based systems maintain checkpoints that
                                point to the last transaction that has been transferred to permanent storage. If the
                                system crashes, it need only examine transactions after the checkpoint.
                                       Shadow paging implements atomic transactions by writing modified data to a
                                free block instead of the original block. Once the transaction commits, the file sys-
                                tem updates its metadata to point to the new block and releases the old block, or
                                shadow page, as free space. If the transaction fails, the file system rolls back the
                                transaction by releasing the new blocks as free space.58




                Operating Systems Thinking
    Murphy's Law and Robust Systems
    Most everyone is familiar w i t h      inopportune t i m e " is appended       prevent such problems?" "If cer-
    one form or another of Murphy's        to the law. Operating system            tain problems cannot be pre-
    Law, named for U.S. Air Force          designers are well advised to keep      vented, how should the operating
    Capt. Edward Murphy w h o cursed       Murphy's Law in mind. They need         system deal with them?" A robust
    one of his error-prone technicians     to constantly ask questions like,       system deals w i t h a wide range of
    by saying, "If there is any way to     "What can go wrong?" "What is           inputs and unexpected situations
    do it wrong, he'll find it."           the likelihood of such problems?"       in a manner that allows the sys-
    Today's most common variant is         "What are the consequences of           tem to keep operating.
    "If something can go wrong, it         such problems?" "How can the
    w i l l . " Often, "and at the most    operating system be designed to

<!-- pág. 671 -->

                                                                                  13.10 Data Integrity Protection 617

Log-Structured File Systems (LFS)
Transaction logging and shadow paging prevent file system data from entering an
inconsistent state but do not necessarily guarantee that the file system itself will be
in a consistent state. For example, moving a file from one directory to another
requires the file system to delete the file's original directory entry and create an
entry in its new directory. A system failure (e.g., due to a power failure) that occurs
between deleting the original directory entry and creating the new one can result in
loss of file data. To address this limitation, a log-structured file system (LFS), also
called a journaling file system, performs file system operations as logged transac-
tions.59 Examples of log-structured file systems include Microsoft's NTFS Journal-
ing File System and the Red Hat's ext3 file system for Linux.60-61
       In an LFS, the entire disk serves as a log file to record transactions. New data
is written sequentially in the log file's free space. For example, in Fig. 13.13, the LFS
receives a request to create files f oo and bar in a new directory. The file system per-
forms the requested operation first by writing f oo's data to the log, then by writing
foo's metadata (e.g., an inode), which enables the file system to locate foo's data.
Similarly, the LFS writes bar's data and corresponding file metadata. Finally, the
file system writes the new directory entry to the log. Note that if the file system
writes a file's metadata before writing file data to the log, the system could fail
before the file's data is written. This could leave the file system in an inconsistent
state, because metadata will reference invalid data blocks (i.e., those that were not
written before the system failed).
      Because modified directories and metadata are always written to the end of
the log, an LFS might need to read the entire log to locate a particular file, leading
to poor read performance. To reduce this problem, an LFS caches locations of file
system metadata and occasionally writes inode maps or superblocks, which indicate
the location of other metadata (Fig. 13.13). This enables the operating system to
locate and cache file metadata quickly when the system boots. Subsequently, file
data can be accessed quickly by determining its location from the file system's
caches. As the size of the file system cache increases, its performance improves at
the cost of reducing the amount of memory available to user processes.62
      To reduce overhead, some file systems store only metadata in the log. In this
case, the file system modifies metadata first by writing an entry to the log, then by
updating the entry in the file system. The operation commits only after the meta-
data has been updated both in the log and in the file system. This ensures file system
integrity with relatively low overhead but does not ensure file integrity in the event
of a system failure.63
      Because data is written sequentially in an LFS, each write request is per-
formed sequentially, which can substantially reduce write times. By comparison,
noncontiguous file allocation implementations might require the file system to
traverse the directory structure, which may be distributed throughout the disk,
leading to long access times.

<!-- pág. 672 -->

618 File and Database Systems




                            Figure 13.13 | Log-structured file system.

                                   When the log fills, an LFS must determine how to recover free space for incom-
                            ing data. An LFS can inspect the content of the log periodically to determine which
                            blocks can be freed because the log contains a modified copy of their data. The LFS
                            can thread new data through these blocks, which are likely to be highly fragmented.
                            Unfortunately, threading can reduce read and write performance to levels lower than
                            those in conventional file systems, because the disk might need to perform many
                            seeks to access data. To address this issue, an LFS can create contiguous free space in
                            the log by copying data to a contiguous region at the end of the log. While performing
                            this I/O-intensive operation, however, users will experience poor response times.64

<!-- pág. 673 -->

                                                                          13.11 File-Servers and Distributed Systems 619



1. Explain how data stored by a RAID level 1 array, which offers a high level of redundancy,
   could enter an inconsistent state.
2. Explain the difference between logging and shadow paging.
Ans: 1) If a power failure occurs while data in a mirrored pair is being written, the array
may contain incomplete copies of file data or file system metadata on both disks. 2) Logging
keeps track of when a transaction was started, and when it completed. If the transaction fails,
it rolls back to the last commit point. Shadow paging involves allocating new data blocks to
write the new data, then freeing the old data blocks when the transaction is complete.


13.11 File Servers and Distributed Systems
One approach to handling nonlocal file references in a computer network is to
route all such requests to a file server, i.e., a computer system dedicated to resolving
intercomputer file references.65, 66, 67, 68, 69 This approach centralizes control of these
references, but the file server could become a bottleneck, because all client comput-
ers would send all requests to the server. A better approach is to let the separate
computers communicate directly with one another; this is the approach taken by
Sun Microsystem's Network File System (NFS). In an NFS network, each computer
maintains a file system that can act as a server and/or a client.
      Through the 1970s, file systems generally stored and managed the files of a
single computer system. On multiuser timesharing systems the files of all users were
under the control of a centralized file system. Today, the trend is toward distributed
file systems in computer networks.70, 71, 72, 73 A real complication is that such net-
works often connect a wide variety of computer systems with different operating
systems and file systems.
      A distributed file system enables users to perform operations on remote files in
a computer network in much the same manner as on local files.74, 75, 76, 77, 78 NFS pro-
vides distributed file system capabilities for networks of heterogeneous computer sys-
tems; it is so widely used that it has become an international standard.79 File servers
and distributed file systems are discussed in Section 18.2, Distributed File Systems.

Self Review
1. Why is a single file server impractical for environments such as large organizations?
2. What is the primary advantage to having each client in a distributed file system also be a
   server?
Ans: 1) If the file server fails, the whole file system becomes unavailable. A central file
server can also become a bottleneck. 2) This removes the bottleneck of central file servers
and can enable the file system to be operational even if one or more clients fail.



13.12 Database Systems
A database is a centrally controlled, integrated collection of data; a database system
involves the data, the hardware on which the data resides and the software that

<!-- pág. 674 -->

620   File   and Database Systems

                               controls access to data (called a database management system or DBMS). Data-
                               bases are commonly implemented on Web servers and in online transaction-pro-
                               cessing environments, where multiple processes require quick access to a large
                               store of shared data.

                               13.12.1 Advantages of Database Systems
                               In conventional file systems, multiple applications often store the same information
                               at different pathnames and in different formats (e.g., a text file stored as a Postscript
                               and as a PDF file). To eliminate this redundancy, database systems organize data
                               according to its content instead of by pathname. For example, a Web site may con-
                               tain separate applications to charge orders to customer credit cards, send bills to
                               those customers and print labels for packages to be delivered to customers. All of
                               these applications must access customer information such as name, address, phone
                               number, and the like. However, each application must format the information dif-
                               ferently to perform its task (e.g., send credit card information or print a label). A
                               database would store only one copy of each customer's information and enable
                               each application to access the information and format it as required. To enable this
                               access to shared data, databases incorporate a querying mechanism that allows
                               applications to specify which information to retrieve.
                                     Database systems use standardized data organization techniques (e.g., hierar-
                               chical, relational, object oriented), the structure of which cannot be altered by
                               applications. Database systems are susceptible to attack due to centralized control
                               and location of data, so they are designed with elaborate security mechanisms.80, 81

                               Self Review
                               1. How do database systems reduce redundant data typically stored by traditional file sys-
                                  tems?
                               2. Why is security extremely important in database systems?
                               Ans: 1) Database systems address data according to its content so that no two records con-
                               tain the same information. For example, a database might store a single copy of customer
                               information and enable multiple applications to access that information using queries.
                               2) Databases provide centralized control to large stores of data, which may contain sensitive
                               information. If a malicious user gains unauthorized access to a database, that user may be
                               able to access all data stored by the system. This is more serious than in traditional file sys-
                               tems, because access rights are typically stored for each file, so a user that obtains unautho-
                               rized access to a file system may not be able to access all of its files.


                               13.12.2 Data Access
                               Database systems exhibit data independence, because a database's organizational
                               structure and access techniques are hidden from applications. Unlike a hierarchi-
                               cally structured file system, which requires all applications to access data using
                               pathnames, a data-independent system enables multiple applications to access the
                               same data using different logical views. Consider the customer information stored
                               by the Web site in the preceding section. In this case, a credit card transaction pro-

<!-- pág. 675 -->

                                                                                            13.12 Database Systems 621

cessing application may view customer information as a list of credit card number
and expiration dates; the application that performs billing may view customer infor-
mation as names, addresses and dollar amounts. Data independence makes it possi-
ble for the system to modify its storage structure and data access strategy in
response to the installation's changing requirements without needing to modify
functioning applications.
      Database languages facilitate data independence by providing a standard way
to access information. A database language consists of a data definition language
(DDL), a data manipulation language (DML) and a query language. A DDL speci-
fies how data items are organized and related and a DML is used to modify data. A
query language allows users to create queries, which search the database for data
that meets certain criteria. Database languages can be executed directly from a
command line or through programs written using higher-level host languages, such
as C++ or Java. The Structured Query Language (SQL), which consists of a DDL,
DML and a query language, is a popular query language that enables users to find
data items that have certain properties, create tables, specify integrity constraints,
manage consistency and enforce security.82, 83, 84
      A distributed database is a database that is spread throughout the computer
systems of a network. Distributed databases facilitate efficient data access across
many sets of data that reside on different computers. 85 In such systems each data
item is typically stored at the location at which it is most frequently used, while
remaining accessible to other network users. Distributed systems provide the con-
trol and efficiency of local processing with the advantages of information accessibil-
ity over a geographically dispersed organization. They can be costly to implement
and operate, however, and they can suffer from increased vulnerability to security
attacks and breaches.

Self Review
1. How do databases facilitate access to data for application developers?
2. Explain the difference between a DDL and a DML.
Ans: 1) Database languages facilitate data independence, so programmers can access data
according to a logical view that is most appropriate for their applications. 2) A DDL defines
the organization of and relationships between data elements. A DML is used to modify data.


13.12.3 Relational Database Model
Databases are based on models that describe how data and their relationships are
viewed. The relational model developed by Codd is a logical structure rather than a
physical one; the principles of relational database management can be considered
without concerning oneself with the physical implementation of the underlying data
structures.86, 87, 88, 89, 90
      A relational database is composed of relations (tables). Figure 13.14 illus-
trates a relation that might be used in a personnel system. The name of the relation
is EMPLOYEE and its primary purpose is to organize the various attributes of each

<!-- pág. 676 -->

622   File and Database Systems




                             Figure 13.14 | Relation in a relational database.


                             employee. Any particular element (row) of the relation is called a tuple. This rela-
                             tion is a set of six tuples. In this example, the first attribute (column) in each tuple.
                             the employee number, is used as the primary key for referencing data in the rela-
                             tion. The tuples of the relation are uniquely identifiable by primary key.
                                   Each attribute of the relation belongs to a single domain. Tuples must be
                             unique within a relation, but particular attribute values may be duplicated between
                             tuples. For example, three different tuples in the example contain department num-
                             ber 413. The number of attributes in a relation is the degree of the relation. Rela-
                             tions of degree 2 are binary relations, relations of degree 3 are ternary relations, and
                             relations of degree n are n-ary relations.
                                   Users of a database are often interested in different data items and different
                             relationships among them. Most users will want only certain subsets of the table
                             rows and columns. Many users will wish to combine smaller tables into larger ones
                             to produce more complex relations. Codd called the subset operation projection
                             and the combination operation join.
                                   Using the relation of Fig. 13.14 we might, for example, use the projection
                             operation to create a new relation called DEPARTMENT-LOCATOR whose pur-
                             pose is to show where departments are located (Fig. 13.15).
                                   The Structured Query Language (SQL) operates on relational databases. The
                             SQL query in Fig. 13.16 generates the table in Fig. 13.15. Line 1 begins with "--",
                             the SQL delimiter for a comment. The SELECT clause (line 2) specifies the columns.
                             Department and Location, of the new table.The keyword DISTINCT indicates that
                             the table should contain only unique entries. The FROM clause (line 3) indicates that

<!-- pág. 677 -->

                                                                                            13.12 Database Systems 623

 Relation:   DEPARTMENT-LOCATOR

 Department                             Location
 413                                    NEW JERSEY
 611                                    ORLANDO
 642                                    LOS ANGELES

Figure 13.15 | Relation formed by projection.


   1    -- SQL query to generate the table in Fig, 13,15
   2    SELECT DISTINCT Department, Location
   3    FROM EMPLOYEE
   4    ORDER BY Department ASC
   5

Figure 13.16 | SQL query.

the columns will be projected from the EMPLOYEE table (Fig. 13.14). On line 4, an
ORDER BY clause indicates the column (in this case, Department) that is used to sort
the query result and ASC indicates that the sort will be in ascending order.
     The relational model has several advantages.
       1. The tabular representation used in implementations the relational model is
          easy to implement in a physical database system.
       2. It is relatively easy to convert virtually any other type of database structure
          into the relational model. Thus the model may be viewed as a universal
          form of representation.
       3. The projection and join operations are easy to implement and make the
          creation of new relations required for particular applications easy to per-
          form.
       4. Access control to sensitive data is straightforward to implement. The sensi-
          tive data is merely placed in separate relations, and access to these relations
          is controlled by some sort of authority or access scheme.

Self Review
1. What is the difference between the join and projection operations in relational databases?
2. (T/F) In a relation, each attribute value must be unique among tuples.
Ans: 1) The join operation forms a relation from more than one relation; the projection
operation forms a relation from a subset of a relation's attributes. 2) False. Multiple tuples
may have the same attribute value.

13.12.4 Operating Systems and Database Systems
Stonebraker discusses various operating system services that support database man-
agement systems, namely buffer pool management, the file system, scheduling, pro-
cess management, interprocess communication, consistency control and paged virtual

<!-- pág. 678 -->

624 File and Database Systems

                                      memory.91 He observes that because most of these features are not specifically opti-
                                      mized to DBMS environments, DBMS designers have tended to bypass operating
                                      system services in favor of supplying their own. He concludes that efficient, minimal
                                      operating systems are the most desirable for supporting the kinds of database man-
                                      agement systems that supply their own optimized services. Database support is
                                      becoming more common in today's systems. For example, Microsoft intends to use a
                                      database to store all user data in the next version of the Windows operating system.92


                                     Self Review
                                      1. Why should operating systems generally avoid direct support for database systems?
                                      2. Why might more operating systems directly support database systems in the future?
                                     Ans: 1) Each database system may have different needs, which are difficult for the operating
                                     system to predict. These database systems generally exhibit higher performance when supply-
                                     ing their own optimized services. 2) If an operating system uses a single database as the primary
                                     way to store user information, it should certainly provide optimized services for that database.




Web      Resources
www.linux-tutorial.info/cgi-bin/dis-                                www.osta.org/specs/pdf/udf201.pdf
play.pi795&0&0&0&3                                                  Contains the 2.01 revision of the Universal Disk Format
Contains a tutorial describing file systems in Linux.               (UDF) file system, which is commonly used to organize data
www.redhat.com/docs/manuals/linux/RHL-8.0-Manual/                   on DVDs.
admin-primer/sl-storage-basics,html                                 storageconference.org/
Overviews file system concepts.                                     Contains articles and presentations from the annual coopera-
www.itworld.com/nl/db_mgr/                                          tive IEEE-NASA Storage Conference, highlighting techniques
Contains articles about data management strategies.                 and technologies that manage mass storage devices.
www.winnetmag.com/articles/index.cfm?articleid=3455                 www.sqlcourse.com/
Includes information about the Windows NT file system.              Provides an interactive tutorial, teaching the basics of SQL.




Summary
Information is stored in computers according to a data hierar-              A field is a group of characters. A record is a group of
chy. The lowest level of the data hierarchy is composed of bits.    fields. A file is a group of related records. The highest level of
Bits are grouped together in bit patterns to represent all data     the data hierarchy is a file system or database. A volume is a
items of interest in computer systems. The next level in the        unit of data storage that may hold multiple files.
data hierarchy is fixed-length patterns of bits such as bytes,              A file is a named collection of data that may be manip-
characters and words. A byte is typically 8 bits. A word is the     ulated as a unit by operations such as open, close, create,
number of bits a processor can operate on at once. Characters       destroy, copy, rename and list. Individual data items within a
map bytes (or groups of bytes) to symbols such as letters, num-     file may be manipulated by operations like read, write,
bers, punctuation and new lines. The three most popular char-       update, insert and delete. File characteristics include loca-
acter sets in use today are ASCII (American Standard Code           tion, accessibility, type, volatility and activity. Files can con-
for Information Interchange), EBCDIC (Extended Binary-              sist of one or more records.
Coded Decimal Interchange Code) and Unicode.

<!-- pág. 679 -->

                                                                                                                    Summary            625
        A file system organizes files and manages access to data.      or renames the file, any soft links to that file are no longer
File systems are responsible for file management, auxiliary            valid.
storage management, file integrity mechanisms and access                      Metadata is information that protects the integrity of the
methods. A file system primarily is concerned with managing            file system and cannot be modified directly by users. Many file
secondary storage space, particularly disk storage.                    systems store in a superblock critical information that protects
        File systems should exhibit device independence—users          the integrity of the file system, such as the file system identifier
should be able to refer to their files by symbolic names rather        and the location of the storage device's free blocks. To reduce
than having to use physical device names. File systems should          the risk of date loss, most file systems distribute redundant
also provide backup and recovery capabilities to prevent either        copies of the superblock throughout the storage device.
accidental loss or malicious destruction of information. The file             The file open operation returns a file descriptor which is a
system may also provide encryption and decryption capabilities         non-negative integer index into the open-file table. From this
to make information useful only to its intended audience.              point on, access to the file is directed through the file descriptor.
        File systems use directories, which are files containing       To enable fast access to file-specific information such as permis-
the names and locations of other files in the file system, to          sions, the open-file table often contains file control blocks, also
 organize and quickly locate files. A directory entry stores           called file attributes, which are highly system-dependent struc-
information such as a file name, location, size, type arid             tures that might include the file's symbolic name, location in sec-
accessed, modified and creation times. The simplest file system        ondary storage, access control data and so on.
 organization is the single-level (or flat) system, which stores all          The mount operation combines multiple file systems into
of its files using one directory. In single-level file systems, no     one namespace so that they can be referenced from a single root
two files can have the same name and the file system must per-         directory. The mount command assigns a directory, called the
form a linear search of the directory contents to locate each          mount point, in the native file system to the root of the mounted
file, which can lead to poor performance.                              file system. File systems manage mounted directories with
        In a hierarchical file system, a root is used to indicate      mount tables, which contain information about the location of
 where on the storage device the root directory begins. The root       mount points and the devices to which they point. When the
directory points to the various directories, each of which con-        native file system encounters a mount point, it uses the mount
tains an entry for each of its files. File names need be unique        table to determine the device and type of the mounted file sys-
only within a given user directory. The name of a file is usually      tem. Users can create soft links to files in mounted file systems
formed as the pathname from the root directory to the file.            but cannot create hard links between file systems.
        Many file systems support the notion of a working direc-              File organization refers to the manner in which the
tory to simplify navigation using pathnames. The working               records of a file are arranged on secondary storage. File orga-
directory enables users to specify a pathname that does not            nization schemes include sequential, direct, indexed nonse-
begin at the root directory (i.e., a relative path). When a file       quential and partitioned.
system encounters a relative pathname, it forms the absolute                  The problem of allocating and freeing space on secondary
path (i.e., the path beginning at the root) by concatenating the       storage is somewhat like that experienced in primary storage
working directory and the relative path.                               allocation under variable-partition multiprogramming. Because
        A link, which is a directory entry that references a data      files tend to grow or shrink over time, and because users rarely
file or directory located in a different directory, facilitates data   know in advance how large their files will be, contiguous storage
sharing and can make it easier for users to access files located       allocation systems have generally been replaced by more
throughout a file system's directory structure. A soft link is a       dynamic noncontiguous storage allocation systems.
directory entry containing the pathname for another file. A                   File systems that employ contiguous allocation place file
hard link is a directory entry that specifies the location of the      data at contiguous addresses on the storage device. One
file (typically a block number) on the storage device. Because         advantage of contiguous allocation is that successive logical
a hard link specifies a physical location of a file, it references     records typically are physically adjacent to one another. Con-
invalid data when the physical location of its corresponding file      tiguous allocation schemes exhibit the same types of external
changes. Because soft links store the logical location of the file     fragmentation problems inherent in memory allocation for
in the file system, they do not require updating when file data        variable-partition multiprogramming systems. Contiguous
is moved. However, if a user moves a file to different directory       allocation may result in poor performance if files grow and

<!-- pág. 680 -->

626    File and Database Systems

shrink over time. If a file grows beyond the size originally spec-            The primary advantage of index block chaining over
ified and no contiguous free blocks are available, it must be         simple linked-list implementations is that searching may take
transferred to a new area of adequate size, leading to addi-          place in the index blocks themselves. File systems typically
tional I/O operations.                                                place index blocks near the data blocks they reference, so the
        Using a sector-based linked-list noncontiguous file allo-     data blocks can be accessed quickly after their index block is
cation scheme, a directory entry points to the first sector of a      loaded. Index blocks are called inodes (i.e., index nodes) in
file. The data portion of a sector stores the contents of the file;   UNIX-based operating systems.
the pointer portion points to the file's next sector. Sectors                 Some systems use a free list—a linked list of blocks con-
belonging to a common file form a linked list.                        taining the locations of free blocks—to manage the storage
        When performing block allocation, the system allocates        device's free space. The file system typically allocates blocks
blocks of contiguous sectors (sometimes called extents). In           from the beginning of the free list and appends freed blocks to
block chaining, entries in the user directory point to the first      the end of the list. This technique requires little overhead to per-
block of each file. The blocks comprising a file each contain         form free list maintenance operations, but files are allocated in
two portions: a data block and a pointer to the next block.           noncontiguous blocks, which increases file access time.
When locating a record, the chain must be searched from the                   A bitmap contains one bit for each block in memory
beginning, and if the blocks are dispersed throughout the stor-       where the rth bit corresponds to the rth block on the storage
age device (which is normal), the search process can be slow as       device. A primary advantage of bitmaps over free lists is that the
block-to-block seeks occur. Insertion and deletion are done by        file system can quickly determine if contiguous blocks are avail-
modifying the pointer in the previous block.                          able at certain locations on secondary storage. A disadvantage is
       Large block sizes can result in a considerable amount of       that the file system may need to search the entire bitmap to find
internal fragmentation. Small block sizes may cause file data to      a free block, resulting in substantial execution overhead.
be spread across multiple blocks dispersed throughout the                     In a two-dimensional access control matrix, the entry aij
storage device, leading to poor performance as the storage            is 1 if user i is allowed access to file j; otherwise aij = 0. In an
device performs many seeks to access all the records of a file.       installation with a large number of users and a large number of
       Tabular noncontiguous file allocation uses tables storing      files, this matrix generally would be large and sparse. A tech-
pointers to file blocks to reduce the number of lengthy seeks         nique that requires considerably less space is to control access
required to access a particular record. Directory entries indi-       to various user classes. User classes can include the file owner,
cate the first block of a file. The current block number is used      a specified user, group, project or public. This access control
as an index into the block allocation table to determine the          data can be stored as part of the file control block and often
location of the next block. If the current block is the file's last   consumes an insignificant amount of space.
block, then its block allocation table entry is null. Because the             Today's operating systems generally provide many
pointers that locate file data are stored in a central location,      access methods, such as queued and basic access methods.
the table can be cached so that the chain of blocks that com-         Queued access methods are used when the sequence in which
pose a file can be traversed quickly, which improves access           records are to be processed can be anticipated, such as in
times. However, to locate the last record of a file, the file sys-    sequential and indexed sequential accessing. The queued
tem might need to follow many pointers in the block allocation        methods perform anticipatory buffering and scheduling of I/O
table, which could take significant time. When a storage device       operations. The basic access methods are normally used when
contains many blocks, the block allocation table can become           the sequence in which records are to be processed cannot be
large and fragmented, reducing file system performance. A             anticipated, particularly with direct accessing.
popular implementation of tabular noncontiguous file alloca-                  Memory-mapped files map file data to a process's virtual
tion is Microsoft's FAT file system.                                  address space instead of using a file system cache. Because refer-
       In indexed noncontiguous file allocation, each file has an     ences to memory-mapped files occur in a process's virtual
index block or several index blocks. The index blocks contain a       address space, the virtual memory manager can make page-
list of pointers that point to file data blocks. A file's directory   replacement decisions based on each process's reference pattern.
entry points to its index block, which may reserve the last few               Most file systems implement backup techniques to store
entries to store pointers to more index blocks, a technique           redundant copies of information, and recovery techniques that
called chaining.                                                      enable the system to restore data after a system failure. Physi-

<!-- pág. 681 -->

                                                                                                                 Summary           627
cal safeguards such as locks and fire alarms are the lowest level             Because data is written sequentially, each LFS write
 of data protection. Performing periodic backups is the most          requires only a single seek while there is still space on disk.
common technique used to ensure the continued availability of         When the log fills, the file system's fragmented free space from
data. Physical backups duplicate a storage device's data at the       reclaiming invalid blocks can reduce read and write perfor-
bit level. A logical backup stores file system data and its logical   mance to levels lower than those in conventional file systems.
structure. Thus, logical backups inspect the directory structure      To address this issue, an LFS can create contiguous free space
to determine which files need to be backed up, then write these       in the log by copying valid data to a contiguous region at the
files to a backup device in a common, often compressed, archi-        end of the log.
val format. Incremental backups are logical backups that store                One approach to handling nonlocal file references in a
only file system data that has changed since the previous             computer network is to route all such requests to a file server,
backup.                                                               i.e., a computer system dedicated to resolving intercomputer
        In systems that cannot tolerate loss of data or downtime,     file references. This approach centralizes control of these refer-
RAID and transaction logging are appropriate. If a system             ences, but the file server could easily become a bottleneck,
failure occurs during a write operation, file data may be left in     because all client computers send all requests to the server. A
an inconsistent state. Transaction-based file systems reduce          better approach is to let the separate computers communicate
data loss using atomic transactions, which perform a group of         directly with one another.
operations in their entirety or not at all. If an error occurs that           A database is a centrally controlled collection of data
prevents a transaction from completing, it is rolled back by          stored in a standardized format; a database system involves
returning the system to the state before the transaction began.       the data, the hardware on which the data resides and the soft-
        Atomic transactions can be implemented by recording           ware that controls access to data (called a database manage-
the result of each operation in a log file instead of modifying       ment system or DBMS). Databases reduce data redundancy
existing data. Once the transaction has completed, it is com-         and prevent data from being in an inconsistent state. Redun-
mitted by recording a sentinel value in the log. To reduce the        dancy is reduced by combining data from separate files. Data-
time spent reprocessing transactions in the log, most transac-        bases also facilitate data sharing.
tion-based systems maintain checkpoints that point to the last                An important aspect of database systems is data inde-
transaction that has been transferred to permanent storage. If        pendence; i.e., applications need not be concerned with how
the system crashes, it need only examine transactions after the       data is physically stored or accessed. From the system's stand-
checkpoint. Shadow paging implements atomic transactions by           point, data independence makes it possible for the storage
writing modified data to a free block instead of the original         structure and accessing strategy to be modified in response to
block.                                                                the installation's changing requirements, but without the need
        Log-structured file systems (LFS), also called journaling     to modify functioning applications.
file systems, perform all file system operations as logged trans-             Database languages allow database independence by
actions to ensure that they do not leave the system in an incon-      providing a standard way to access information. A database
sistent state. In LFS, the entire disk serves as a log file. New      language consists of a data definition language (DDL), a data
data is written sequentially in the log file's free space. Because    manipulation language (DML) and a query language. A DDL
modified directories and metadata are always written to the           specifies how data are organized and related and the DML
end of the log, an LFS might need to read the entire log to           enables data to be modified. A query language is a part of the
locate a particular file, leading to poor read performance. To        DML that allows users to create queries that search the data-
reduce this problem, an LFS caches locations of file system           base for data that meets certain criteria. The Structured Query
metadata and occasionally writes inode maps or superblocks            Language (SQL) is currently one of the most popular database
that indicate the location of other metadata, enabling the            languages.
operating system to locate and cache file metadata quickly                     A distributed database, a database that is spread
when the system boots. Some file systems attempt to reduce            throughout the computer systems of a network, facilitates effi-
the cost of log-structured file systems by using a log only to        cient data access across many sets of data that reside on differ-
store metadata. This ensures file system integrity with rela-         ent computers.
tively low overhead but does not ensure file integrity in the                 Databases are based on models that describe how data
event of a system failure.                                            and their relationships are viewed. The relational model is a

<!-- pág. 682 -->

628   File    and Database Systems

logical structure rather than a physical one; the principles of    duce more complex relations. The relational database model is
relational database management are independent of the physi-       relatively easy to implement.
cal implementation of data structures. A relational database is           Various operating system services support database man-
composed of relations that indicate the various attributes of an   agement systems, namely buffer pool management, the file sys-
entity. Any particular element of a relation is called a tuple     tem,     scheduling,    process     management,      interprocess
(row). Each attribute (column) of the relation belongs to a sin-   communication, consistency control and paged virtual memory.
gle domain. The number of attributes in a relation is the          Most of these features are not specifically optimized to DBMS
degree of the relation. A projection operation forms a subset      environments, so DBMS designers have tended to bypass oper-
of the attributes; a join operation combines relations to pro-     ating system services in favor of supplying their own.




Key Terms
absolute path—Path beginning at the root directory.                    system to more easily allocate contiguous blocks but can
access control matrix—Two-dimensional listing of all the users         require substantial execution time to locate a free block.
     and their access to privileges to files in the system.        bit pattern—Lowest level of the data hierarchy. A bit pattern is
accessibility (file)—File property that places restrictions on          a group of bits that represent virtually all data items of
    which users can access file data.                                   interest in computer systems.

access method—Technique a file system uses to access file          block allocation—Technique that enables the file system to
    data. See also queued access methods and basic access              manage secondary storage more efficiently and reduce file
    methods.                                                           traversal overhead by allocating extents (blocks of contig-
                                                                       uous sectors) to files.
activity (file)—Percentage of a file's records accessed during a
                                                                   blocked record—Record that may contain several logical
     given period of time.
                                                                       records for each physical record.
anticipatory buffering—Technique that allows processing and
                                                                   byte—Second-lowest level in the data hierarchy. A byte is typ-
     I/O operations to be overlapped by buffering more than
                                                                       ically 8 bits.
     one record at a time in main memory.
                                                                   character—In the data hierarchy, a fixed-length pattern of bits,
ASCII (American Standard Code for Information Inter-
                                                                       typically 8,16 or 32 bits.
   change) — Character set, popular in personal computers
   and in data communication systems, that stores characters       character set—Collection of characters. Popular character sets
   as 8-bit bytes.                                                     include ASCII, EBCDIC and Unicode.
                                                                   chaining—Indexed noncontiguous allocation technique that
atomic transaction—Group of operations that have no effect
                                                                       reserves the last few entries of an index block to store
    on the state of the system unless they complete in their
                                                                       pointers to more index blocks, which in turn point to data
    entirety.
                                                                       blocks. Chaining enables index blocks to reference large
auxiliary storage management—Component of file systems                 files by storing references to its data across several blocks.
     concerned with allocating space for files on secondary
                                                                   checkpoint—Marker indicating which transactions in a log
     storage devices.
                                                                       have been transferred to permanent storage. The system
backup—Creation of redundant copies of information.                    need only reapply the transactions from the latest check-
basic access method—File access method in which the operat-            point to determine the state of the file system, which is
     ing system responds immediately to user I/O demands. It           faster than reapplying all transactions starting at the
     is used when the sequence in which records are to be pro-         beginning of the log.
     cessed cannot be anticipated, particularly with direct        close (file) —Operation that prevents further reference to a file
     accessing.                                                         until it is reopened.
binary relation—Relation (in a relational database) of degree 2.   committed transaction—Transaction that has completed suc-
bitmap—Free space management technique that maintains                 cessfully.
    one bit for each block in memory, where the ith bit corre-     copy (file)—Operation that creates another version of a file
    sponds to the /th block in memory. Bitmaps enable a file           with a new name.

<!-- pág. 683 -->

                                                                                                             Key      Terms      629

create (file) — Operation that builds a new file.                  distributed file system—File system that is spread throughout
data definition language (DDL)—Type of language that speci-             the computer systems of a network.
    fies the organization of data in a database.                   domain—Set of possible values for attributes in a relational
data manipulation language (DML)—Type of language that                database system.
    enables data modification.                                     EBCDIC (Extended Binary-Coded Decimal Interchange
data-dependent application—Application that relies on a par-          Code)—Eight-bit character set for representing data in
    ticular file system's organization and access techniques.         mainframe computer systems, particularly systems devel-
                                                                      oped by IBM.
data hierarchy—Classification that groups different numbers
    of bits to extract meaningful data. Bit patterns, bytes and    encryption—Technique that transforms data to prevent it from
    words contain small numbers of bits that are interpreted           being interpreted by unauthorized users.
    by hardware and low-level software. Fields, records and        execute access—Permission that enables a user to execute a
    files may contain large numbers of bits that are inter-            file.
    preted by operating systems and user applications.             extent—Block of contiguous sectors.
data independence—Property of applications that do not rely        FAT file system—An implementation of tabular noncontigu-
    on a particular file organization technique or access tech-       ous file allocation developed by Microsoft.
    nique.
                                                                   field—In the data hierarchy, a group of characters (e.g., a per-
database—Centrally controlled collection of data that is stored         son's name, street address or telephone number).
    in a standardized format and can be searched based on
    logical relations between data. Databases organize data        file—Named collection of data that may be manipulated as a
    according to content as opposed to pathname, which                  unit by operations such as open, close, create, destroy,
    tends to reduce or eliminate redundant information.                 copy, rename and list. Individual data items within a file
                                                                        may be manipulated by operations like read, write,
database language—Language that provides for organizing,                update, insert and delete. File characteristics include loca-
    modifying and querying of structured data.                          tion, accessibility, type, volatility and activity. Files can
database management system (DBMS) —Software that con-                   consist of one or more records.
    trols database organization and operations.                    file allocation table (FAT)—Table storing pointers to file data
database system—A particular set of data, the storage devices           blocks in Microsoft's FAT file system.
    on which it resides and the software that controls its stor-   file attribute—See file control block.
    age and retrieval (called a database management system
    or DBMS).                                                      file control block—Metadata containing information the sys-
                                                                        tem needs to manage a file, such as access control infor-
decryption—Technique that reverses data encryption so that              mation.
    data can be read in its original form.
                                                                   file descriptor—Non-negative integer that indexes into an
degree—Number of attributes in a relation in a relational
                                                                        opened-file table. A process references a file descriptor
    database.
                                                                        instead of a pathname to access file data without incurring
delete (file) —Operation that removes a data item from a file.          the overhead of a directory structure traversal.
destroy (file) —Operation that removes a file from the file sys-   file integrity mechanism—Mechanism that ensures that the
     tem.                                                                information in a file is uncorrupted. When file integrity is
device independence—Property of files that can be referenced             assured, files contain only the information they are
    by an application using a symbolic name instead of a                 intended to have.
    name indicating the device on which it resides.                file management—Component of a file system concerned with
direct file organization—File organization technique in which           providing the mechanisms for files to be stored, refer-
     a record is directly (randomly) accessed by its physical           enced, shared and secured.
     address on a direct access storage device (DASD).             file organization—Manner in which the records of a file are
directory—File storing references to other files. Directory             arranged on secondary storage (e.g., sequential, direct,
     entries often include a file's name, type, and size.               indexed sequential and partitioned).
distributed database—Database that is spread throughout the        file server—System dedicated to provide remote processes
     computer systems of a network.                                     access to its files.

<!-- pág. 684 -->

630 File and Database Systems

file system — Component of an operating system that organizes        list (file) —Operation that prints or displays a file's contents.
      files and manages access to data. File systems are con-        location (file)—Address of a file on a storage device or in the
      cerned with organizing files logically (using pathnames)            system's logical file organization.
      and physically (using metadata). They also manage their
      storage device's free space, enforce security policies,        log-structured file system (LFS)—File system that performs all
      maintain data integrity and so on.                                  file operations as transactions to ensure that file system
                                                                          data and metadata is always in a consistent state. An LFS
file system identifier—Value that uniquely identifies the file            generally exhibits good write performance because data is
      system a storage device is using.                                   also appended to the end of a systemwide log file. To
flat directory structure—File system organization containing              improve read performance, an LFS typically distributes
     only one directory.                                                  metadata throughout the log and employs large caches to
format a storage device—To prepare a device for a file system             store that metadata so that the locations of file data can be
    by performing operations such as inspecting its contents              found quickly.
    and writing storage management metadata.                         logical backup—Backup technique that stores file data and the
free list—Linked list of blocks that contain the addresses of             file system's directory structure, often in a common, com-
     free blocks.                                                         pressed format.

group (file access control) —Set of users with the same file         logical block—See logical record.
    access rights (e.g., members of a group that is working on       logical record—Collection of data treated as a unit by soft-
    a particular project).                                                ware.
hard link—Directory entry specifying the location of a file on       logical view—View of files that hides the devices that store
    its storage device.                                                   them, their format and the system's physical access tech-
hierarchically structured file system—File system organization            niques.
     in which each directory can contain multiple subdirecto-        member—Sequential subfile of a partitioned file.
     ries but exactly one parent.                                    memory-mapped file—File whose data is mapped to a pro-
incremental backup—Backup technique that copies only data               cess's virtual address space, enabling a process to refer-
     in file system that has changed since the last backup.             ence file data as it would other data. Memory-mapped
index block—Block that contains a list of pointers to file data         files are useful for programs that frequently access file
    blocks.                                                             data.

indexed sequential file organization—File organization that          metadata—Data that a file system uses to manage files and
    arranges records in a logical sequence according to a key            that is inaccessible to users directly. Inodes and super-
    contained in each record.                                            blocks are examples of metadata.

indirect block—Index block containing pointers to data blocks        mount operation—Operation that combines disparate file sys-
     in inode-based file systems.                                       terns into a single namespace so they can be accessed by a
                                                                        single root directory.
inode—Index block in a UNIX-based system that contains the
    file control block and pointers to singly, doubly and triply     mount point—User-specified directory within the native file
    indirect blocks of pointers to file data.                           system hierarchy where the mount command places the
                                                                        root of a mounted file system.
inode map—Block of metadata written to the log of a log-
    structured file system that indicates the location of the file   mount tables—Tables that store the locations of mount points
    system's inodes. Inode maps improve LFS performance                 and their corresponding devices.
    by reducing the time required to determine file locations        MS-DOS—Popular operating system for the first IBM Per-
    in the LFS.                                                         sonal Computer and compatible microcomputers.
insert (file) —Operation that adds a new data item to a file.        n-ary relation—Relation of degree n.
join (database) —Operation that combines relations.                  namespace—Set of files that can be identified by a file system.
journaling file system—See log-structured file system (LFS).         Network File System (NFS)—File system implemented by Sun
link—Directory entry that references an existing file. Hard              Microsystems in which each computer maintains a virtual
    links reference the location of the file on its storage              file system that can act as a server and/or a client.
    device; soft links store the file's pathname.                    owner (file access control)—User who created the file.

<!-- pág. 685 -->

                                                                                                                   Key      Terms      631

open (file) —Operation that prepares a file to be referenced.         rename (file) —Operation that changes a file's name.
parent directory—In hierarchically structured file systems, the       roll back a transaction—To return the system to the state that
    directory that points to the current directory.                        existed before the transaction was processed.
partitioned file—File composed of sequential subfiles.                root—Beginning of a file system's organizational structure.
pathname—String identifying a file or directory by its logical        root directory—Directory that points to the various user direc-
    name, separating directories using a delimiter (e.g.,"/" or            tories.
    " \ " ) . An absolute pathname specifies the location of a file
                                                                      sequential file organization—File organization technique in
    or directory starting at the root directory; a relative path-
                                                                          which records are placed in sequential physical order. The
    name specifies the location of a file or directory beginning
                                                                          "next" record is the one that physically follows the previ-
    at the current working directory.
                                                                          ous record.
physical backup—Copy of each bit of the storage device; no
                                                                      shadow page—Block of data whose modified contents are
    attempt is made to interpret the contents of its file system.
                                                                          written to a new block. Shadow pages are one way to
physical block—See physical record.                                       implement transactions.
physical device name—Name given to a file that is specific to a       shadow paging—Transaction implementation that writes mod-
    particular device.                                                    ified blocks to a new block. The copy of the block that is
physical record—Unit of information actually read from or                 unmodified is released as free space when the transaction
    written to disk.                                                      has been committed.
physical view—View of file data concerned with the particular         single-level directory structure—See flat directory structure.
    devices on which data is stored, the form the data takes on       size (file)—Amount of information stored in a file.
    those devices, and the physical means of transferring data
    to and from those devices.                                        soft link—File that specifies the pathname corresponding to
                                                                           the file to which it is linked.
primary key—In a relational database, a combination of
    attributes whose value uniquely identifies a tuple.               specified user (file access control)—Identity of an individual
                                                                           user (other than the owner) that may use a file.
projection (database)—Operation that creates a subset of
                                                                      Structured Query Language (SQL)—Database language that
    attributes.
                                                                          allows users to find data items that have certain proper-
public (file access control)—File that may be accessed by any             ties, and also to create tables, specify integrity constraints,
    member of the system's user community.                                manage consistency and enforce security.
queued access method—File access method that does not
                                                                      superblock—Block containing information critical to the
    immediately service user I/O demands. This can improve
                                                                          integrity of the file system (e.g., the location of the file sys-
    performance when the sequence in which records are to
                                                                          tem's free block list or bitmap, the file system identifier
    be processed can be anticipated and requests can be
                                                                          and the location of the file system root).
    ordered to minimize access times.
                                                                      symbolic name—Device-independent name (e.g., a path-
query language—Language that allows users to search a data-
                                                                         name).
    base for data that meets certain criteria.
                                                                      ternary relations—Relation of degree 3.
read access—Permission to access a file for reading.
record—In the data hierarchy, a group of fields (e.g., to store       tuple—Particular element of a relation.
    several related fields containing information about a stu-        type (file)—Description of a file's purpose (e.g., an executable
    dent or a customer).                                                  program, data or directory).
recovery—Restoration of the system's data after a failure.            unblocked record—Record containing exactly one logical
read (file) — Operation that inputs a data item from a file to a          record for each physical record.
    process.                                                          Unicode—Character set that supports international languages
relation—A set of tuples in the relational model.                         and is popular in Internet and multilingual applications.
relational model—A model of data proposed by Codd that is             update (file) —Operation that modifies an existing data item in
     the basis for most modern database systems.                          a file.
relative path—Path that specifies the location of a file relative     user classes—Classification scheme that specifies individual
     to the current working directory.                                    users or groups of users that can access a file.

<!-- pág. 686 -->

632 File and Database Systems

user directory—Directory that contains an entry for each of a       word—Number of bits a system's processor(s) can process at
     user's files; each entry points to where the corresponding         once. In the data hierarchy, words are one level above
     file is stored on its storage device.                              bytes.
                                                                    working directory—Directory that contains files that a user
volatility (file)—Frequency with which additions and deletions          can access directly.
     are made to a file.                                            write (file) —Operation that outputs a data item from a process
                                                                         to a file.
volume—Unit of storage that may hold multiple files.                write access—Permission to access a file for writing.




Exercises
I3-I A virtual memory system has page size p and its corre-         Suppose a file system allows complex arrangements of pointers
sponding file system has block size b and fixed-length record       and interdirectory references. What measures might the file
size r. Discuss the various relationships among p, b, and r that    system designer take to ensure the reliability and integrity of
make sense. Explain why each of these possible relationships is     such a system?
reasonable.
                                                                    13.9 Some file systems support a large number of access
13.2 Give a comprehensive enumeration of reasons why                classes while others support only a few. Discuss the relative
records may not necessarily be stored contiguously in a             merits of each approach. Which is better for highly secure
sequential disk file.                                               environments? Why?
13.3 Suppose a distributed system has a central file server         13.10 Compare the allocation space for files on secondary
containing large numbers of sequential files for hundreds of        storage to real storage allocation under variable-partition mul-
users. Give several reasons why such a system may not be            tiprogramming.
organized to perform compaction (dynamically or otherwise)          13.11 In what circumstances is compaction of secondary stor-
on a regular basis.                                                 age useful? What dangers are inherent in compaction? How
13.4 Give several reasons why it may not be useful to store         can these be avoided?
logically contiguous pages from a process's virtual memory          13.12 What are the motivations for structuring file systems
space in physically contiguous areas on secondary storage.          hierarchically?
13.5 A certain file system uses "systemwide" names; i.e., once      13.13 One problem with indexed sequential file organization is
one member of the user community uses a name, that name             that additions to a file may need to be placed in overflow areas.
may not be assigned to new files. Most large file systems, how-     How might this affect performance? What can be done to
ever, require only that names be unique with respect to a given     improve performance in these circumstances?
user—two different users may choose the same file name with-
out conflict. Discuss the relative merits of these two schemes,     13.14 Pathnames in a hierarchical file system can become
considering both implementation and application issues.             lengthy. Given that the vast majority of file references are made
                                                                    to a user's own files, what convention might the file system sup-
13.6 Some systems implement file sharing by allowing several        port to minimize the need for using lengthy pathnames?
users to read a single copy of a file simultaneously. Others pro-
vide a copy of the shared file to each user. Discuss the relative   13.15 Some file systems store information in exactly the for-
merits of each approach.                                            mat created by the user. Others attempt to optimize by com-
                                                                    pressing the data. Describe how you would implement a
13.7 Indexed sequential files are popular with application          compression/decompression mechanism. Such a mechanism
designers. Experience has shown, however, that direct access        necessarily trades execution time overhead against the
to indexed sequential files can be slow. Why is this so? In what    reduced storage requirements for files. In what circumstances
circumstances is it better to access such files sequentially? In    is this trade-off acceptable?
what circumstances should the application designer use direct
files rather than indexed sequential files?                         13.16 Suppose that a major development in primary storage
                                                                    technology made it possible to produce a storage so large, so fast
13.8 When a computer system failure occurs, it is important         and so inexpensive that all the programs and data at an installa-
to be able to reconstruct the file system quickly and accurately.   tion could be stored in a single "chip." How would the design of

<!-- pág. 687 -->

                                                                                                                 Exercises        633
a file system for such a single-level storage differ from that for   completed transaction applies to the appropriate customer's
today's conventional hierarchical storage systems?                   account. Also, any transactions only partially completed at the
                                                                     time of a system failure must not apply.
13.17 You have been asked to perform a security audit on a
computer system. The system administrator suspects that the          13.24 Why is it useful to reorganize indexed sequential files
pointer structure in the file system has been compromised,           periodically?
thus allowing certain unauthorized users to access critical sys-           What criteria might a file system use to determine when
tem information. Describe how you would attempt to deter-            reorganization is needed?
mine who is responsible for the security breach and how it was       13.25 Distinguish between queued access methods and basic
possible for them to modify the pointers.                            access methods.
13.18 In most computer installations, only a small portion of
                                                                     13.26 How might redundancy of programs and data be useful
file backups are ever used to reconstruct a file. Thus there is a
                                                                     in the construction of highly reliable systems? Database sys-
trade-off to be considered in performing backups. Do the con-
                                                                     tems can greatly reduce the amount of redundancy involved in
sequences of not having a file backup available when needed
                                                                     storing data. Does this imply that database systems may in fact
justify the effort of performing the backups? What factors
                                                                     be less reliable than nondatabase systems? Explain your
point to the need for performing backups as opposed to not
                                                                     answer.
performing them? What factors affect the frequency with
which backups should be performed?                                   13.27 Many of the storage schemes we discussed for placing
                                                                     information on disk include the extensive use of pointers. If a
13.19 Sequential access from sequential files is much faster
than sequential access from indexed sequential files. Why then       pointer is destroyed, either accidentally or maliciously, an
do many applications designers implement systems in which            entire data structure may be lost. Comment on the use of such
indexed sequential files are to be accessed sequentially?            data structures in the design of highly reliable systems. Indi-
                                                                     cate how pointer-based schemes can be made less susceptible
13.20 In a university environment how might the user access          to damage by the loss of a pointer.
classes "owner," "group," "specified user," and "public" be
used to control access to files? Consider the use of the com-        13.28 Discuss the problems involved in enabling a distributed
puter system for administrative as well as academic computing.       file system of homogeneous computers to treat remote file
Consider also its use in support of grant research as well as in     accesses the same as local file accesses (at least from the user's
academic courses.                                                    perspective).
13.21 File systems provide access to native files as well as to      13.29 Discuss the notion of transparency in distributed file sys-
files from other mounted file systems. What types of files might     tems of heterogeneous computers. How does a distributed file
best be stored in the native file system? in other mounted file      system resolve differences between various computer architec-
systems? What problems are unique to the management of               tures and operating systems to enable all systems on a network
mounted file systems?                                                to perform remote file accesses regardless of system differences?
13.22 What type and frequency of backup would be most                13.30 Figure 13.9 shows an inode data structure. Suppose a file
appropriate in each of the following systems?                        system that uses this structure has filled up the blocks stem-
      a. a batch-processing payroll system that runs weekly          ming from the doubly indirect pointers. How many disk
                                                                     accesses will it take to write one more byte to the file? Assume
      b. an automated teller machine (ATM) banking system
                                                                     that the inode and free block bitmap are both completely in
      c. a hospital patient billing system                           memory, but there is no buffer cache. Also assume that blocks
      d. an airline reservation system in which customers            do not have to be initialized.
         make reservations for flights as much as one year in
         advance                                                     13.31 A file system can keep track of free blocks by using
                                                                     either a free block bitmap or a free block list. The system has a
      e. a distributed program development system used by a          total of t blocks of size b, u of which are used, and each block
         group of 100 programmers
                                                                     number is stored using s bits.
13.23 Most banks today use online teller transaction systems.
                                                                           a. Express size (in bits) of this device's free block bit-
Each transaction is immediately applied to customer accounts
                                                                              map using the given variables.
to keep balances correct and current. Errors are intolerable,
but because of computer failures and power failures, these sys-            b. Express the size (in bits) of this system's free block
tems do "go down" occasionally. Describe how you would                        list in terms of the given variables. Ignore the space
implement a backup/recovery capability to ensure that each                    consumed by pointers to free list continuation blocks.

<!-- pág. 688 -->

634 File and Database Systems

13.32 Suppose a system uses 1KB blocks and 16-bit (2-byte)                          block uses all 1,024 bytes to store pointers to data
addresses. What is the largest possible file size for this file sys-                blocks.
tem for the following inode organizations?                                      c. The inode contains 12 direct pointers to data blocks,
      a. The inode contains 12 pointers directly to data                           one indirect data block, and one doubly indirect data
         blocks.                                                                   block.
      b. The inode contains 12 pointers directly to data blocks           13-33 Why is it useful to store fixed-length directory entries?
         and one indirect block. Assume the indirect data                 What limitation does this impose on file names?

Suggested Projects
13.34 Prepare a research paper on the upcoming WinFS file                 13.36 Research how operating systems such as Windows and
system and compare it to the NTFS file system. What problems              Linux provide file system encryption and decryption capabili-
in the NTFS file system does WinFS address?                               ties.
13.35 Prepare a research paper on the implementation and
application of distributed databases.

Suggested Simulations
13.37 Design a file system. What would you put in each of the             choice. Then implement the following functions: create, open,
modes (files and directories should have different informa-               close, read, write, cd (change directory), and Is (to list the files
tion)? What would you need for metadata? After you design it,             in a directory). If you have more time, figure out how to save
implement a simulated file system in the language of your                 your file system to a file and be able to load it later.




Recommended Reading
File system research continues to produce file system imple-              terns are discussed in detail by Rosenblum et al.95 Wang et al.
mentations that adapt to changing user demands. Golden et al.             introduce the notion of user-level custom file systems as a tech-
provide a summary of many common file system functions.93                 nique to improve the performance of I/O-bound Internet serv-
For information regarding the NT File System, see Custer"s                ers.96 The bibliography for this chapter is located on our Web
Inside the Windows NT File System?4 Log-structured file sys-              site at www.deitel.com/books/os3e/Bibliography.pdf.




Works Cited
 1. Searle, S., "Brief History of Character Codes in North America,        6. Linux kernel source code, version 2.6.0-test2, msdos_fs.h, line-
    Europe, and East Asia," modified March 13, 2002, <tron-                   151—162,                <lxr.linux. no/source/include/linux
    web.super-nova.co.jp/characcodehist.html>.                                msdos_fs.h?v=2.6.0-test2>.
 2. "The Unicode® Standard: A Technical Introduction," March 4,            7. Golden. D.. and M. Pechura, "The Structure of Microcomputer
    2003, <www.unicode.org/standard/principles.html>.                         File Systems," Communications of the ACM, Vol. 29, No. 3.
 3. Golden, D., and M. Pechura, "The Structure of Microcomputer               March 1986, p. 224.
    File Systems," Communications of the ACM, Vol. 29, No. 3,              8. Peterson, J. L.; J. S. Quarterman; and A. Silberschatz, "4.2BSD
    March 1986, pp. 222-230.                                                  and 4.3BSD as Examples of the UNIX System," ACM Compar-
 4. Linux kernel source code, version 2.6.0-test2, ext2_fs.h, lines           ing Surveys, Vol. 17, No.4, December 1985, p. 395.
    506-511,            <lxr.linux.no/source/include/linux/                9. Appleton. R.. "A Non-Technical Look Inside the EXT2 File Sys-
    ext2_fs.h?v=2.6.0-test2>.                                                 tem," Kernel Korner, August 1997.
 5. Linux kernel source code, version 2.6.0-test2, iso_fs.h, lines 144-   10. Peterson, J. L.; J. S. Quarterman; and A. Silberschatz, "4.2BSD
    156,                  <lxr.linux.no/source/include/linux/                 and 4.3BSD as Examples of the UNIX System," ACM Comput-
    iso_fs.h?v=2.6.0-test2>.                                                  ing Surveys, Vol. 17, No.4, December 1985, p. 395.

<!-- pág. 689 -->

                                                                                                                       Works Cited 635

11. Peterson, J. L.; J. S. Quarterman; and A. Silberschatz, "4.2BSD        30. Paterson, X, "A Short History of MS-DOS" June 1983.
    and 4.3BSD as Examples of the UNIX System," ACM Comput-                    <www.patersontech.com/Dos/Byte/History.html>.
    ing Surveys, Vol. 17, No.4, December 1985, p. 395.                     31. Rojas, R., "Encyclopedia of Computers and Computer H i s t o r y -
12. Peterson, J. L.; J. S. Quarterman; and A. Silberschatz, "4.2BSD            DOS," April        2001,   <www.patersontech.com/Dos/Ency-
    and 4.3BSD as Examples of the UNIX System," ACM Comput-                    clo.htm>.
    ing Surveys, Vol. 17, No.4, December 1985, p. 395.
                                                                           32. Hunter, D., "Tim Patterson: The Roots of DOS," March 1983,
13. Linux kernel source code, version 2.6.0-test2, ext2_fs_sb.h, lines         <www.patersontech.com/Dos/Softalk/Softalk.html>.
    25-55,                <lxr.linux.no/source/include/linux/
                                                                           33. Hunter, D., "Tim Patterson: The Roots of DOS," March 1983,
    ext2_fs_sb.h?v=2.6.0-test2>.
                                                                               <www.patersontech.com/Dos/Softalk/Softalk.html>.
14. Linux kernel source code, version 2.6.0-test2, iso_fs_sb.h, lines 7-
    32,                   <lxr.linux.no/source/include/linux/              34. Paterson, T, "An Inside Look at MS-DOS," June               1983,
    iso_fs_sb.h?v=2.6.0-test2>.                                                <www.patersontech.com/Dos/Byte/InsideDos.htm>.
15. Linux kernel source code, version 2.6.0-test2, msdos_fs_sb.h,          35. Rojas, R., "Encyclopedia of Computers and Computer History —
    lines    38-63,     <lxr.linux.no/source/include/linux/                    DOS,"      April   2001,    <www.patersontech.com/Dos/Ency-
    msdos_fs_sb.h?v=2.6.0-test2>.                                              clo.htm>.
16. Thompson, K., "UNIX Implementation," UNIX Time-Sharing                 36. Rojas, R., "Encyclopedia of Computers and Computer History-
    System: UNIX Programmer's Manual, 7th ed., Vol. 2b, January                DOS,"      April   2001,   <www.patersontech.com/Dos/Ency-
    1979, p. 9.                                                                clo.htm>.
17. Levy, E., and A. Silberschatz, "Distributed File Systems: Con-         37. Hunter, D., "Tim Patterson: The Roots of DOS," March 1983,
    cepts and Examples," ACM Computing Surveys, Vol. 22, No. 4,                <www.patersontech.com/Dos/Softalk/Softalk.html>.
    December 1990, p. 329.
                                                                           38. Paterson, T, "An Inside Look at MS-DOS," June               1983,
18. "Volume Mount Points," MSDN Library, February 2003,                        <www.patersontech.com/Dos/Byte/InsideDos.htm>.
    <msdn.microsoft.com/library/default.asp?url=/library/
                                                                           39. Rojas. R., "Encyclopedia of Computers and Computer History —
    en-us/fileio/base/volume_mount_points.asp>.
                                                                               DOS,"      April   2001,    <www.patersontech.com/Dos/Ency-
19. Thompson, K., "UNIX Implementation," UNIX Time-Sharing                     clo.htm>.
    System: UNIX Programmer's Manual, 7th ed., Vol. 2b, January
    1979, p. 9.                                                            40. The   Online    Software Museum,     "CP/M:              History,"
                                                                               <museum.sysun.com/museum/cpmhist.html>.
20. Larson, P., and A. Kajla, "File Organization: Implementation of a
    Method Guaranteeing Retrieval in One Access," Communica-               41. The   Online    Software Museum,     "CP/M:              History,"
    tions of the ACM, Vol. 27, No. 7, July 1984, pp. 670-677.                  <museum.sysun.com/museum/cpmhist.html>.
21. Enbody, R. J., and H. C. Du, "Dynamic Hashing Schemes," ACM            42. Rojas, R., "Encyclopedia of Computers and Computer History-
    Computing Surveys, Vol. 20, No. 2, June 1988, pp. 85-113.                  DOS,"      April   2001,   <www.patersontech.com/Dos/Ency-
22. Koch, P. D. L„ "Disk File Allocation Based on the Buddy Sys-               clo.htm>.
    tem," ACM Transactions on Computer Systems, Vol. 5, No. 4.             43. Hunter, D„ "Tim Patterson: The Roots of DOS," March 1983.
    November 1987, pp. 352-370.                                                <www.patersontech.com/Dos/Softalk/Softalk.html>.
23. McKusick, M.: W. Joy; S. Leffler; and R. Fabry, "A Fast File Sys-      44. Rojas, R., "Encyclopedia of Computers and Computer H i s t o r y -
    tem for UNIX," ACM Transactions on Computer Systems, Vol. 2,               DOS,"      April   2001,   <www.patersontech.com/Dos/Ency-
    No. 3, August 1984, pp. 183-184.                                           clo.htm>.
24. "Description of FAT32 File System," Microsoft Knowledge Base,          45. The   Online    Software Museum,      "CP/M:             History,"
    February         21,      2002,     <support.microsoft.com/                <museum.sysun.com/museum/cpmhist.html >.
    default.aspx?scid=kb;[LN];Q154997>.
                                                                           46. Rojas, R., "Encyclopedia of Computers and Computer History-
25. Card, R; T. Ts'o, and S. Tweedie, "Design and Implementation of            DOS,"      April   2001,   <www.patersontech.com/Dos/Ency-
    the Second Extended Filesystem," September 20, 2001,                       clo.htm>.
    <e2fsprogs.sourceforge.net/ext2intro.html>.
                                                                           47. McKusick, M.; W. Joy; S. Leffler; and R. Fabry, "A Fast File Sys-
26. Kozierok, C, "DOS (MS-DOS, PC-DOS, etc.)," PCGuide, April
                                                                               tem for UNIX," ACM Transactions on Computer Systems, Vol. 2,
    17,2001, <www.pcguide.com/ref/hdd/file/osDOS-c.html>.
                                                                               No. 3, August 1984, p. 183.
27. Kozierok, C, "Virtual FAT (VFAT)," PCGuide, April 17, 2001,
    <www.pcguide.com/ref/hdd/file/fileVFAT-c.htmlx                         48. Hecht, M., and J. Gabbe, "Shadowed Management of Free Disk
                                                                               Pages with a Linked List," ACM Transactions on Database Sys-
28. Kozierok, C, "DOS (MS-DOS, PC-DOS, etc.)," PCGuide, April
                                                                               tems, Vol. 8, No. 4, December 1983, p. 505.
    17,2001,<www.pcguide.com/ref/hdd/file/osDOS-c.html>.
                                                                           49. Hecht, M., and J. Gabbe, "Shadowed Management of Free Disk
29. "FAT32," MSDN Library, <msdn.microsoft.com/library/
                                                                               Pages with a Linked List," ACM Transactions on Database Sys-
    default.asp?u rl=/library/en-us/fileio/
                                                                               tems, Vol. 8, No. 4, December 1983, p. 503.
    storage_29v6. asp>.

<!-- pág. 690 -->

636    File and Database Systems

50. Betourne, C, et al., "Process Management and Resource Sharing      65. Birrell, A. D., and R. M. Needham, "A Universal File Server."
    in the Multiaccess System ESOPE," Communications of the                 IEEE Transactions on Software Engineering, Vol. SE-6, No. 5.
    ACM, Vol. 13, No. 12, December 1970, p. 730.                            September 1980, pp. 450-453.
51. Green, P., "Multics Virtual Memory—Tutorial and Reflections,"      66. Mitchell, J. G., and J. Dion, "A Comparison of Two Network-
    <    f   t   p     :   /    /  f  t  p    .    s  tr     a    t    u   sBased              m Proceedings
                                                                                     c Servers,"
                                                                                . File    o         /    p         b Eighth
                                                                                                              u of the  /   v Symposium
                                                                                                                                o    s   on
                                                                                                                                          /  m   u   l
    1999.                                                                   Operating Systems Principles, Vol. 15, No. 5, December 1981, pp.
52. Choy, M.; H. Leong; and M. Wong, "Disaster Recovery Tech-               45^16.
    niques tor Database Systems," Communications of the ACM, Vol.      67. Christodoulakis, S., and C. Faloutsos, "Design and Performance
    43, No. 11, November 2000, p. 273.                                      Considerations for an Optical Disk-Based, Multimedia Object
53. Chen, P.; W. Ng; S. Chandra; C. Aycock; G. Rajamani; and D.             Server," Computer, Vol 19, No. 12, December 1986, pp. 45-56.
    Lowell, "The Rio File Cache: Surviving Operating System            68. Merita, S., "Serving a LAN," LAN Magazine, October 1988, pp.
    Crashes," Proceedings of the Seventh International Conference on       93-98.
    Architectural Support for Programming Languages and Operat-        69. Fridrich, M., and W. Older, "The Felix File Server," Proceedings
    ing Systems, 1996, p. 74.                                              of the Eighth Symposium on Operating System Principles, Vol. 15.
54. Choy, M.; H. Leong; and M. Wong, "Disaster Recovery Tech-              No. 5, December 1981, pp. 37-44.
    niques for Database Systems," Communications of the ACM, Vol.      70. Wah, B. W., "File Placement on Distributed Computer Systems."
    43, No. 11, November 2000, p. 273.                                     Computer,Vol 17, No. 1, January 1984, pp. 23-32.
55. Hutchinson, N; S. Manley; M. Federwisch; G. Harris; D. Hitz; S.    71. Mullender, S., and A. Tanenbaum, "A Distributed File Service
    Kleiman; and S. O'Malley, "Logical vs. Physical File System            Based on Optimistic Concurrency Control," Proceedings of the
    Backup," Proceedings of the Third Symposium on Operating Sys-          10th Symposium on Operating Systems Principles, ACM, Vol. 19.
    tem Design and Implementation, 1999, pp. 244-245.                      No. 5, December 1985, pp. 51-62.
56. Hutchinson, N; S. Manley; M. Federwisch; G. Harris; D. Hitz; S.    72. Morris, J. H.; M. Satyanarayanan; M. H. Conner; J. H. Howard:
    Kleiman; and S. O'Malley, "Logical vs. Physical File System            D. S. H. Rosenthal; and F. D. Smith, "Andrew: A Distributed Per-
    Backup," Proceedings of the Third Symposium on Operating Sys-          sonal Computing Environment," Communications of the ACM.
    tem Design and Implementation, 1999, pp. 240,242-243.                  Vol. 29, No. 3, March 1986, pp. 184-201.
57. Tanenbaum, A., and R. Renesse, "Distributed Operating Sys-         73. Nelson, M. N; B. B. Welch; and J. K. Ousterhout, "Caching in the
    tems," Computing Surveys, Vol. 17, No.4, December 1985, p. 441.        Sprite Network File System," ACM Transactions on Computer
58. Brown, M.; K. Rolling; and E. Taft, "The Alpine File System,"          Systems, Vol. 6, No. 1, February 1988, pp. 134-154.
    ACM Transactions on Computer Systems, Vol. 3, No. 4, Novem-        74. Walsh, D.; R. Lyon; and G. Sager, "Overview of the Sun Network
    ber 1985, pp. 267-270.                                                 File System," USENIX Winter Conference, Dallas, 1985, pp. 117-
59. Ousterhout, J. K., and M. Rosenblum, "The Design and Imple-            124.
    mentation of a Log-Structured File System," ACM Transactions       75. Sandberg, R., et al. "Design and Implementation of the Sun Net-
    on Computer Systems, Vol. 10, No. 1, February 1992.                    work File System," Proceedings of the USENIX 1985 Summer
60. "What's New in File and Print Services," June 16, 2003,                Conference, June 1985, pp. 119-130.
    <www.microsoft.com/windowsserver2003/evaluation/over-              76. Sandberg, R., The Sun Network File System: Design, Implementa-
    view/technologies/fileandprint.mspx>.                                  tion and Experience, Mountain View, CA: Sun Microsystems.
61. Johnson, M. K., "Whitepaper: Red Hat's New Journaling File             Inc., 1987.
    System: ext3," 2001, <www.redhat.com/support/wpapers/              77. Lazarus, J., Sun 386i Overview, Mountain View; CA, Sun Micro-
    redhat/ext3/>.                                                         systems, Inc., 1988.
62. Ousterhout, J. K., and M. Rosenblum, "The Design and Imple-        78. Schnaidt, P., "NFS Now," LAN Magazine, October 1988, pp. 62-
    mentation of a Log-Structured File System," ACM Transactions           69.
    on Computer Systems, Vol. 10, No. 1, February 1992.                79. Shepler, S.; B. Callaghan; D. Robinson; R. Thurlow; C. Beame:
63. Piernas J; T Cortes; and J. M. Garcia, "DualFS: A New Journal-         M. Eisler; and D. Noveck, "Network File System (NFS) version 4
    ing File System without Meta-Data Duplication," Proceedings of         Protocol." RFC 3530, April 2003, <www.ietf.org/rfc,
    the 16th International Conference on Supercomputing, 2002, p.          rfc3530.txt>.
    137.                                                               80. Date, C. J, An Introduction Database Systems, Reading, MA:
64. Matthews, J. N; D. Roselli; A. M. Costello; R. Y. Wang; and T E.       Addison-Wesley, 1981.
    Anderson, "Improving the Performance of Log-Structured File        81. Silberschatz, A.; H. Korth; and S. Sudarshan, Database System
    Systems with Adaptive Methods," Proceedings of the Sixteenth           Concepts, 4th ed., New York: McGraw-Hill, 2002, pp. 3-5.
    ACM Symposium on Operating Systems Principles, 1997, pp.           82. Silberschatz, A.; H. Korth; and S. Sudarshan, Database System
    238-251.                                                               Concepts, 4th ed., New York: McGraw-Hill, 2002, pp. 135-182.

<!-- pág. 691 -->

                                                                                                                 Works Cited 637
. 83. Chen, P., "The Entity-Relationship Model—Toward a Unified        90. Relational Technology, INGRES Overview, Alameda, CA: Rela-
      View of Data.," ACM Transactions on Database Systems, Vol. 1,        tional Technology, 1988.
      No. 1,1976, pp. 9-36.                                            91. Stonebraker, M., "Operating System Support for Database Man-
 84. Markowitz, V. M, and A. Shoshani, "Representing Extended              agement," Communications of the ACM, Vol. 24, No. 7, July 1981,
     Entity-Relationship Structures in Relational Databases: A Mod-        pp. 412-418.
     ular Approach," ACM Transactions on Database Systems,Vol. 17,     92. Ibelshauser, O., "The WinFS File System for Windows Longhorn:
     No. 3,1992. pp. 423-464.                                              Faster and Smarter," Tom's Hardware Guide, June 17, 2003,
 85. Winston, A., "A Distributed Database Primer," UNIX World,             <www.tomshardware.com/storage/20030617/>.
     April 1988, pp. 54-63.                                            93. Golden, D., and M. Pechura, "The Structure of Microcomputer
                                                                           File Systems," Communications of the ACM, Vol. 29, No. 3,
 86. Codd, E. E, "A Relational Model for Large Shared Data Banks,"
                                                                           March 1986, pp. 222-230.
     Communications of the ACM, June 1970.
                                                                       94. Custer, Helen, Inside the Windows NT File System, Redmond,
 87. Codd, E. E, "Further Normalization of the Data Base Relational
                                                                           WA: Microsoft Press, 1994.
     Model," Courant Computer Science Symposia, Vol. 6, Data Base
     Systems, Englewood Cliffs, NJ.: Prentice Hall, 1972.              95. Rosenblum, M., and J. K. Ousterhout, "The Design and Imple-
                                                                           mentation of a Log-Structured File System," ACM Transactions
 88. Blaha, M. R.; W. J. Premerlani; and J. E. Rumbaugh, "Relational       on Computer Systems (TOCS), Vol. 10, No. 1, February 1992.
     Database Design Using an Object-Oriented Methodology,"
                                                                       96. Wang, Jun; Rui Min; Zhuying Wu; and Yiming Hu, "Boosting I/O
     Communications of the ACM, Vol. 13, No. 4, April 1988, pp. 414-
                                                                           Performance of Internet Servers with User-Level Custom File
     427.
                                                                           Systems," ACM SIGMETRICS Performance Evaluation Review,
 89. Codd, E. E, "Fatal Flaws in SQL," Datamation, Vol. 34, No. 16,        Vol. 29, No. 2, September 2001, pp. 26-31.
     August 15,1988, pp. 45-48.

