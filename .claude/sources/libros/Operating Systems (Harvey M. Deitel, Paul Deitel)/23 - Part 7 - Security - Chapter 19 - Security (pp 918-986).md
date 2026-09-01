# Part 7 - Security / Chapter 19 - Security

> Fuente: Operating Systems (Harvey M. Deitel, Paul Deitel) — páginas 918–986 (numeración del PDF)

<!-- pág. 918 -->

     Security
  'Is it weakness of intellect, birdie?' I cried,
'Or a rather tough worm in your little inside?'
             - W . S. Gilbert-




Part 7

<!-- pág. 919 -->

Computers are vulnerable to attacks that can com-
promise data, corrupt files and crash systems—
operating system security is at the core of secure
computing systems. The next chapter discusses key
security topics, including cryptography (secret key
and public key), authentication (biometrics, smart
cards, Kerberos, single sign-on), access control,
security attacks (cryptanalysis, viruses, worms,
denial-of-service attacks), attack prevention (fire-
walls, intrusion detection systems, antivirus soft-
ware), key agreement protocols, digital signatures,
Public Key Infrastructure (PKI), certificates, certif-
icate authorities, secure communication protocols
(Secure Sockets Layer, Virtual Private Networks,
wireless security), steganography and proprietary
vs. open-source security. We include a case study
on OpenBSD, arguably the world's most secure
operating system.




      We have forty million reasons for failure, but not a single excuse.
                          — Rudyard Kipling—

<!-- pág. 920 -->

You can't trust code that you did not totally create yourself. (Especially code from compa-
nies that employ people like me.
      —Ken Thompson—
      1983 Turing Award Lecture
      Association for Computing Machinery, Inc.

We have forty million reasons for failure, but not a single excuse.
      —Rudyard Kipling—


There is no such thing as privacy on a computer. The view here is that if you don't want
something read, don't put it on the system.
      —Thomas Mandel—
      quoted in Time, April 6,1987

'Is it weakness of intellect, birdie?' I cried,
'Or a rather tough worm, in your little inside?'
      - W . S. Gilbert-

<!-- pág. 921 -->

Chapter 19

Security
 Objectives
 After reading this chapter, you should understand:
 • public-key/private-key    cryptography.
 • the role of authentication in providing secure systems.
 • access control models, policies and mechanisms.
 • security threats, such as viruses, worms, exploits and denial-of-service attacks.
 • security and authentication protocols, such as SSL and Kerberos.
 • digital signatures, digital certificates and certificate authorities.
 • Virtual Private Networks and IPSec.

<!-- pág. 922 -->

                                Chapter Outline
                      19.1                                           19.5
                 Introduction                             Security Attacks
      Operating Systems Thinking: Ethical                 19.5.1      Cryptanalysis
                 Systems Design                        19.5.2 Viruses and Worms
                                                 19.5.3 Denial-of-Service (DoS) Attacks
                    19.2                              19.5.4 Software Exploitation
                Cryptography                           19.5.5 System Penetration
         19.2.1 Secret-Key Cryptography
         19.2.2 Public-Key Cryptography                       19.6
      Biographical Note: Rivest, Shamir and
                                                 Attack Prevention and Security
                    Adleman
                                                                Solutions
                                                              19.6.1 Firewalls
                                                  19.6.2 Intrusion Detection Systems
                      19.3                                          (IDSs)
               Authentication                          19.6.3      Antivirus Software
           19.3.1 Basic Authentication                19.6.4 Security Patches
       19.3.2 Biometrics and Smart Cards            Mini Case Study: OpenBSD
                19.3.3    Kerberos                  Mini Case Study: Macintosh
             19.3.4 Single Sign-On                   19.6.5 Secure File Systems
                                                     19.6.6     Orange Book Security


                     19.4                                     19.7
               Access Control                        Secure Communication
       19.4.1 Access Rights and Protection
                    Domains                                  19.8
  19.4.2    Access Control Models and Policies      Key Agreement Protocols
       19.4.3 Access Control Mechanisms                19.8.1 Key Management




870

<!-- pág. 923 -->

      19.8.2 Digital Signatures                                    19.11
                                                             Steganography
                 19.9
  Public-Key Infrastructure,                                       19.12
  Certificates and Certificate                      Proprietary and Open-Source
            Authorities                                       Security

                 19.10                                             19.13
     Secure Communication                             Case Study: UNIX Systems
           Protocols                                          Security
  19.10.1   Secure Sockets Layer (SSL)
19.10.2 Virtual Private Networks (VPNs)
        and IP Security (IPSec)
      19.10.3 Wireless Security




   Web Resources | Summary | Key Terms | Exercises | Recommended Reading | Works Cited



                                                                                         871

<!-- pág. 924 -->

872    Security

                                   19. 1 Introduction
                                   As the personal computing and e-business movements expand, individuals and
                                   organizations are storing highly confidential information on their computers and
                                   transmitting sensitive information over the Internet. Consumers are submitting
                                   credit card numbers to e-commerce sites, and businesses are exposing proprietary
                                   data on the Web. At the same time, organizations are experiencing increasing num-
                                   bers of security breaches. Both individuals and companies are vulnerable to data
                                   theft and attacks that can compromise data, corrupt files and crash systems. The
                                   computing industry has been responding to these needs, as organizations work to
                                   improve Internet and network security. For example, the "trustworthy computing"
                                   initiative put forth by Microsoft Chairman Bill Gates is an effort to focus the com-
                                   pany's priorities on providing reliable, available and secure applications (see the
                                   Operating Systems Thinking feature, Ethical Systems Design). 1
                                          Computer security addresses the issue of preventing unauthorized access to
                                   resources and information maintained by computers. Computer systems must pro-
                                   vide mechanisms to manage security threats originating both from outside the com-
                                   puter (via a network connection) and from within the computer (via malicious users
                                   and software). Computer security commonly encompasses guaranteeing the privacy




                   Operating Systems Thinking
      Ethical Systems Design
      We have entrusted our lives to          uations. Should we build systems     our professional responsibilities to
      computers in a manner that              that could fail? What is an          build dependable systems. Can we
      demands ethical behavior on the         "acceptable" level of failure?       continue to build systems that are
      part of operating systems design-       Who is responsible when com-         so easily attacked and compro-
      ers.2 People w h o work w i t h com-    puter systems fail? Should we        mised, and employ those systems
      puters and communication                build systems so complex that we     in situations where people's
      devices are often privy to confi-       cannot be certain they will per-     health and lives are at stake? It is
      dential information they would          form properly? 3 Operating sys-      software, not computer hard-
      not ordinarily see. Computer sys-       tems designers need to be            ware, which has been most vul-
      tems control heart pacemakers,          concerned with these and other       nerable to attack. Operating
      monitor air traffic and process         important ethical issues.            systems designers must conscien-
      confidential financial, medical               With viruses and worms         tiously deal with the same kinds
      and criminal records. People w h o      attacking our computer systems in    of ethical dilemmas as those faced
      design computer systems must            record numbers, we must think        by other professional people such
      realize that these systems are          seriously about just how vulnera-    as doctors, attorneys, scientists
      used and relied upon in critical sit-   ble our systems are, and about       and engineers.

<!-- pág. 925 -->

                                                                                               19.2 Cryptography 873

  and integrity of sensitive data, restricting the use of computer resources and provid-
 ing protection against malicious attempts to incapacitate the system. Protection
encompasses mechanisms that shield resources such as hardware and operating sys-
 tem services from attack. Security is quickly becoming one of the richest and most
challenging topics in computing; operating system security is at the core of a secure
computing system.
      This chapter also explores the fundamentals of Internet security, including the
 implementation of secure electronic transactions and secure networks. We discuss
how to achieve network security using current technologies—including cryptogra-
phy, Public Key Infrastructure (PKI), digital signatures, Secure Sockets Layer
(SSL) and Virtual Private Networks (VPNs). We also examine authentication and
authorization solutions, firewalls and intrusion detection systems. At the end of the
chapter, we discuss UNIX security. Linux operating systems security and Windows
XP operating systems security are discussed in Section 20.13 and Section 21.13,
respectively.

Self Review
1. Why are security and protection important even for computers that do not contain sensi-
   tive data?
2. What is the difference between security and protection?
Ans: 1) All computers, regardless of the data they manage, are susceptible to security
breaches that may crash the system, spread viruses or commit identity theft. 2) Security
addresses the issue of preventing unauthorized access to resources and information main-
tained by computers. Protection refers to the mechanisms that shield resources such as hard-
ware and operating system services from attack.



19.2 Cryptography
An important goal of computing is to make massive amounts of data easily avail-
able. Electronic data transmission, especially over public wires, is inherently inse-
cure. A solution to this problem is to make data unreadable to any unauthorized
user, through encryption. Many security mechanisms rely on encryption to protect
sensitive data such as passwords.
      Cryptography focuses on encoding and decoding data so that it can be inter-
preted only by the intended recipients. Data is transformed by the use of a cipher,
or cryptosystem—a mathematical algorithm for encrypting messages. A key, repre-
sented by a string of characters, is input to the cipher. The algorithm transforms the
unencrypted data, or plaintext, into encrypted data, or ciphertext, using the keys as
input—different keys result in different ciphertext. The aim is to render the data
incomprehensible to any unintended receivers (i.e., those who do not possess the
decryption key). Only the intended receivers should have the key to decrypt the
ciphertext into plaintext.
      First employed by the ancient Egyptians, cryptographic ciphers have been
used throughout history to conceal and protect valuable information. Ancient cryp-

<!-- pág. 926 -->

874   Security
                 tographers encrypted messages by hand, usually with a method based on the alpha-
                 betic letters of the message. The ancients' two primary types of ciphers were
                 substitution ciphers and transposition ciphers. In a substitution cipher, every occur-
                 rence of a given letter is replaced by a different letter. For example, if every "a"
                 were replaced by a "b," every "b" by a "c," and so on, the word "security" would
                 encrypt to "tfdvsjuz." The first prominent substitution cipher was credited to Julius
                 Caesar and is referred to today as the Caesar cipher. Using the Caesar cipher, every
                 instance of a letter is replaced by the letter in the alphabet three places to the right.
                 For example, the word "security" would encrypt to "vhfxulwb."4
                        In a transposition cipher, the ordering of the letters is shifted. For example, if
                 every other letter, starting with "s," in the word "security" creates the first word in
                 the ciphertext and the remaining letters create the second word, the word "secu-
                 rity" encrypts to "scrt euiy." An encrypted message becomes increasingly robust
                 (i.e., difficult to decipher) when its cipher combines substitution and transposition
                 ciphers. For example, using the substitution cipher in combination with the transpo-
                 sition cipher, the word "security" encrypts to "tdsu fvjz."5
                        The greatest weakness of many early ciphers was their reliance on the sender
                 and receiver remembering the encryption algorithm and maintaining its secrecy.
                 Such algorithms are called restricted algorithms. Restricted algorithms are not fea-
                 sible to implement for a large group of people. Imagine if the security of U.S. gov-
                 ernment communications relied on every employee keeping a secret—the
                 encryption algorithm could easily be compromised.
                        Modern cryptosystems rely on algorithms that operate on the individual bits
                 or blocks (a group of bits) of data, rather than letters of the alphabet. Encryption
                 and decryption keys are binary strings with a given key length. For example, 128-bit
                 encryption systems have a key length of 128 bits. Longer keys have stronger encryp-
                 tion; it takes more time and computing power to "break" the encryption. Longer
                 keys also require more processing time to encrypt and decrypt data, reducing sys-
                 tern performance. The growth of computer networking has made the security/per-
                 formance trade-off more challenging.
                        Until January 2000, the U.S. government placed restrictions on the strength of
                 cryptosystems that could be exported from the United States by limiting the key
                 length of exported encryption algorithms. Today, the regulations are less stringent.
                 Any cryptography product may be exported, as long as the end user is not a foreign
                 government or a member of a country with embargo restrictions.6

                 Self Review
                 1. Consider a cipher that randomly reorders the letters of each word in a message. Why is
                    such a cipher inappropriate for encryption?
                 2. What is the primary weakness of restricted algorithms?
                 Ans: 1) The receiver would be unable to decipher the ciphertext because it would have no
                 way of knowing how the letters were reordered. 2) The sender and receiver must remember
                 the encryption algorithm and maintain its secrecy; thus, restricted algorithms are not feasible
                 to implement for a large group of people.

<!-- pág. 927 -->

                                                                                        19.2 Cryptography 875

19.2.1 Secret-Key Cryptography
Symmetric cryptography, also known as secret-key cryptography, uses the same
secret key to encrypt and decrypt a message (Fig. 19.1). In this case, the sender
encrypts a message using the secret key, then sends the encrypted message to the
intended recipient, who decrypts the message using the same secret key. A limita-
tion of secret-key cryptography is that before two parties can communicate
securely, they must find a secure way to exchange the secret key.
      A solution is to have the key delivered by a courier or other mail service.
While this approach may be feasible when two parties communicate, it does not
scale well to large networks. Moreover, secret-key encryption cannot be considered
completely secure, because message privacy and integrity can be compromised if
the key is intercepted as it is passed between the sender and the receiver. Also,
because both parties in the transaction use the same key to encrypt and decrypt a
message, one cannot determine which party created a message. This enables a third
party, posing as one of the two authorized parties, to create a message after captur-
ing the key. Finally, to maintain private communications, a sender needs a different
secret key for each receiver. Consequently, secure computing in large organizations
would necessitate maintaining large numbers of secret keys for each user, requiring
significant data storage.
      An alternative approach to the key-exchange problem is to create a central
authority, called a key distribution center (KDC), which shares a different secret
key with every user in the network. The key distribution center generates a session
key to be used for a transaction (Fig. 19.2), then delivers the session key to the
sender and receiver, encrypted with the secret key they each share with the key dis-
tribution center.
      For example, suppose a merchant and a customer wish to conduct a secure
transaction. They each share unique secret keys with the key distribution center.
The KDC generates a session key for the merchant and customer to use in the




Figure 19.1 | Encrypting and decrypting a message using a secret key.

<!-- pág. 928 -->

876 Security




               Figure 19.2 | Distributing a session key with a key distribution center.

               transaction, then sends the session key for the transaction to the merchant,
               encrypted using the secret key the merchant already shares with the center. The
               KDC sends the same session key for the transaction to the customer, encrypted
               using the secret key the customer already shares with the KDC. Once the merchant
               and the customer obtain the session key for the transaction, they can communicate
               with each other, encrypting their messages using the shared session key.
                      A key distribution center reduces the number of courier deliveries of secret
               keys to each user in the network. In addition, it gives users a new secret key for
               each communication with other users in the network, which greatly increases the
               level of security of the network. However, if the security of the key distribution cen-
               ter is compromised, then the security of the entire network is also compromised.
                      One commonly used symmetric encryption algorithm is the Data Encryption
               Standard (DES). Horst Feistel of IBM created the Lucifer algorithm, which was
               chosen as the DES by the U.S. government and the National Security Agency
               (NSA) in the 1970s.7 DES has a key length of 56 bits and encrypts data in 64-bit
               blocks. This type of encryption is known as a block cipher, because it creates groups
               of bits from a message, then applies an encryption algorithm to the block as a
               whole. This technique reduces the amount of computer processing power and time
               required to encrypt data.
                      For many years, DES was the encryption standard set by the U.S. government
               and the American National Standards Institute (ANSI). However, due to advances
               in technology and computing speed, DES is no longer considered secure—in the
               late 1990s, specialized DES cracker machines were built that recovered DES keys
               after a period of several hours.8 Consequently, the standard for symmetric encryp-
               tion was replaced by Triple DES, or 3DES, a variant of DES that is essentially three
               DES systems in series, each with a different secret key that operates on a block.

<!-- pág. 929 -->

                                                                                                 19.2 Cryptography 877

  Though 3DES is more secure, the three passes through the DES algorithm increase
  encryption overhead, leading to reduced performance.
       In October 2000, the U.S. government selected a more secure standard for
  symmetric encryption to replace DES, called the Advanced Encryption Standard
  (AES). The National Institute of Standards and Technology (NIST)- which sets
 the cryptographic standards for the U.S. government—chose Rijndael as the
encryption method for AES. Rijndael is a block cipher developed by Dr. Joan Dae-
men and Dr. Vincent Rijmen of Belgium. Rijndael can be used with key sizes and
block sizes of 128, 192 or 256 bits. Rijndael was chosen as the AES over four other
finalists due to its high level of security, performance, efficiency, and flexibility and
 its low memory requirement for computing systems.9

Self Review
1. Discuss the advantages and disadvantages of secret-key cryptography.
2. What limits the strength of most encryption algorithms?
Ans: 1) An advantage is that encryption and decryption via secret-key cryptography are
straightforward because both parties share the same key, making secret-key encryption
highly efficient. Disadvantages are that it does not provide authentication and it requires a
secure way to transmit the secret key so that a third party does not intercept it. 2) The pri-
mary limitation to most encryption algorithms is the amount of computational power
required to implement them.

19.2.2 Public-Key Cryptography
In 1976, Whitfield Diffie and Martin Hellman, researchers at Stanford University,
developed public-key cryptography to solve the problem of securely exchanging
symmetric keys. Public-key cryptography is asymmetric in that it employs two
inversely related keys: a public key and a private key. The private key is kept secret
by its owner and the public key is freely distributed. If the public key encrypts a
message, only the corresponding private key can decrypt it (Fig. 19.3) and vice




Figure 19.7 | Encrypting and decrypting a messageusing public-key cryptography.

<!-- pág. 930 -->

878   Security

                 versa. Each party in a transaction possesses both a public key and a private key. To
                 transmit a message securely, the sender uses the receiver's public key to encrypt the
                 message. The receiver then decrypts the message, using his or her unique private
                 key. Assuming that the private key has been kept secret, the message cannot be
                 read by anyone other than the intended receiver. Thus the system ensures the pri-
                 vacy of the message.
                          Secure public-key algorithms depend on a private key that is computationally
                 infeasible to deduce from the public key within a reasonable amount of time. Such
                 algorithms are called "one-way" or "trap-door" functions, because the message
                 requires little computation to encrypt using the public key, but takes significant
                 computing power and time to decrypt without knowledge of the private key Mod-
                 erately secure encryption requires years for a single computer to decrypt. [Note:
                 D i s t r i b u t e d . n e t ' s RC5 competition offers a cash award to decrypt a message
                 encrypted by a one-way function. The competition attracts thousands of users that
                 work in parallel to discover the key Recently, over 300,000 participants devoted
                 computer power to crack a message encrypted using a 64-bit key. The key was
                 found in August of 2002 after 1,757 days of computation, equivalent to 46,000 2GHz
                 processors working in parallel. 10 The most powerful computer at the time was the
                 Earth Simulator, which contained 5,120 500MHz processors.]
                          The security of the system relies on the secrecy of the private keys. Therefore,
                 if a third party obtains the private key used in decryption, the security of the entire
                 system is compromised. If system integrity is compromised, the user can simply
                 change the key, rather than change the entire encryption or decryption algorithm.
                          Both the public key or the private key can be used to encrypt or decrypt a
                 message. For example, if a customer uses a merchant's public key to encrypt a mes-
                 sage, only the merchant can decrypt the message, using the merchant's private key.
                 Thus, the merchant's identity can be authenticated, because only the merchant
                 knows the private key. However, the merchant cannot validate the customer's iden-
                 tity, because the encryption key the customer used is publicly available.
                          If the decryption key is the sender's public key and the encryption key is the
                 sender's private key, the sender of the message can be authenticated. For example,
                 suppose a customer sends a merchant a message encrypted using the customer's
                 private key. The merchant decrypts the message using the customer's public key.
                 Because the customer encrypted the message using his or her private key, the mer-
                 chant can be confident of the customer's identity. This process authenticates the
                 sender but does not ensure confidentiality, as any third party could decrypt the mes-
                 sage with the sender's public key. The problem of proving ownership of a public key
                 is discussed in Section 19.9, Public-Key Infrastructure, Certificates and Certificate
                 Authorities.
                          These two methods of public-key encryption can be combined to authenticate
                 both participants in a communication (Fig. 19.4). Suppose a merchant wishes to
                 send a message securely to a customer so that only the customer can read it. and
                 also to provide proof to the customer that the merchant sent the message. First, the

<!-- pág. 931 -->

                                                                                         19.2   Cryptography   879




Figure 19.4 | Authentication with a public-key algorithm.

merchant encrypts the message using the customer's public key. This step guaran-
tees that only the customer can read the message. Then the merchant encrypts the
result using the merchant's private key, which proves the identity of the merchant.
The customer decrypts the message in reverse order. First, the customer uses the
merchant's public key. Because only the merchant could have encrypted the mes-
sage with the inversely related private key, this step authenticates the merchant.
 Then the customer uses the customer's private key to decrypt the next level of
encryption. This step ensures that the content of the message remained private in
 the transmission, because only the customer has the key to decrypt the message.
       The most commonly used public-key algorithm is RSA, an encryption system
developed in 1977 by MIT professors Ron Rivest, Adi Shamir and Leonard Adle-
 man (see the Biographical Note, Rivest, Shamir and Adleman). 11 Their encryption
 products are built into hundreds of millions of copies of the most popular Internet
 applications, including Web browsers, commerce servers and e-mail systems. Most
 secure e-commerce transactions and communications on the Internet use RSA
 products.
       Pretty Good Privacy (PGP), a public-key encryption system that encrypts e-
 mail messages and files, was designed in 1991 by Phillip Zimmermann. 12 PGP can
 also provide digital signatures (see Section 19.8.2, Digital Signatures) that confirm
 the identity of an author of an e-mail or public posting.
       PGP is based on a "web of trust"; each client in a network can vouch for
   another client's identity to prove ownership of a public key. The "web of trust" is
  used to authenticate each client. If users know the identity of a public key holder,

<!-- pág. 932 -->

880 Security
                               through personal contact or another secure method, they validate the key by sign-
                               ing it with their own key. The web of trust grows as more users validate the keys of
                               others. To learn more about PGP and to download a free copy of the software, visit
                               the MIT Distribution Center for PGP at w e b . m i t . e d u / n e t w o r k / p g p . h t m l .


                               Self Review
                               1. How does secret-key cryptography differ from public-key cryptography?
                               2. For which types of communication is PGP appropriate?
                               Ans: 1) Secret-key cryptography uses the same secret key to encrypt and decrypt a mes-
                               sage. Public-key cryptography employs two inversely related keys: a public key and a private
                               key. The private key is kept secret by its owner, while the public key is freely distributed-if
                               the public key encrypts a message, only the corresponding private key can decrypt it.
                               2) PGP's security increases as the number of users in the Web of trust increases. Thus, PGP is
                               appropriate for communication among a group of users (e.g., e-mail or public forums).



                               19.3      Authentication
                               Identifying users and the actions they are allowed to perform is vital to maintaining
                               a secure computing system. A user can be identified by:




               Biographical Note
   Rivest, Shamir and Adleman
   Ronald Rivest, Adi Shamir and         tation. They enlisted Adleman to                 Together they w o n the 2002
   Leonard Adleman are the inven-        test out their ideas; he disproved          Turing Award for their develop-
   tors of the RSA cryptography          over 40 of their designs until they         ment of the RSA code. 17
   algorithm. This algorithm is used     finally found the mechanism that                   The RSA Security company
   in over one billion copies of         they published as "A Method for             uses the RSA algorithm in security
   secure software applications. 13      Obtaining Digital Signatures and            software including authentication
         Rivest, Shamir and Adleman      Public-Key Cryptosystems" in                mechanisms, smart cards, digital
   met in the 1970s while working as     Communications of the ACM in                certificates and software develop-
   assistant professors in Math at       1978.14 Rivest, Shamir and Adle-            ment kits (SDKs) to facilitate the
   MIT. When Whitfield Diffie and        man obtained a patent for their             development of secure applica-
   Martin Hellman published their        algorithm and started the RSA               tions. RSA Security dominates the
   new theory of public-key cryptog-     Data Security company (now                  field of authentication software,
   raphy in 1977, Rivest and Shamir      named RSA Security) in 1982.15, 16          controlling over 65 percent of the
   tried to find a practical implemen-                                               market. 18

<!-- pág. 933 -->

                                                                                                 19.3 Authentication 881
      • a unique characteristic of the person (e.g., fingerprints, voiceprints, retina
        scans and signatures).
      • ownership of an item (e.g., badges, identification cards, keys and smart
        cards).
      • user knowledge (e.g., passwords, personal identification numbers (PINs)
        and lock combinations).
In the sections that follow, we discuss common authentication methods.

Self Review
1. Of the three identification methods mentioned in this section, which one is least likely to
   be compromised by eavesdroppers?
2. How might security be compromised in a system that requires only ownership of an item
   or only user knowledge for authentication?
Ans: 1) A unique characteristic of a person. 2) Under authentication by ownership of an
item, the item may be stolen. Users tend to write down information such as passwords and
PINs, so security could be compromised if an unauthorized user finds such a record.


19.3.1 Basic Authentication
The most common authentication scheme is simple password protection.19 The user
chooses a password, memorizes it and then enters it into the system to gain admis-
sion to a resource or system. Most systems suppress the display of a password on
the screen by replacing password text with masking characters (which display
"dummy" characters —often asterisks—for password characters entered) or by hid-
ing password input.
      Password protection introduces several weaknesses to a secure system.20
Users tend to choose passwords that are easy to remember, such as the name of a
spouse or pet. Someone who has obtained personal information about the user
might try to log in several times using passwords that are characteristic of the user;
several repeated attempts might result in a security breach. Some early systems lim-
ited users to short passwords; these systems were easily compromised by simply
attempting all possible passwords—a technique known as brute-force cracking.
      Most systems today require longer passwords that include both alphabetic
and numeric characters to thwart such penetration attempts. Some systems even
prohibit use of dictionary words as password values. However, long passwords do
not necessarily improve the security of a system; if passwords are difficult to
remember, users will be more inclined to make a note of them, making it easier for
an intruder to obtain a password.
      Penetration of an operating system's defenses need not necessarily result in a
significant security compromise. For example, suppose an intruder manages to gain
access to a system's master list of passwords. If the password file were stored in
plaintext, such penetration would enable the intruder to access any information on
the system by assuming the identity of any user. To reduce the effectiveness of a sto-
len password file, many operating systems encrypt the password file or store only

<!-- pág. 934 -->

882   Security

                 hash values for each password. In this case, a copy of the password file is of little use
                 unless the intruder can decrypt the passwords. To further thwart attempts at obtain-
                 ing passwords, several systems employ password salting, which is a technique that
                 inserts characters at various positions in the password before encryption (Fig. 19.5).
                 Note how, in Fig. 19.5, a small amount of salting can significantly alter ciphertext.
                 even when using a weak cipher such as a substitution cipher (base 64 encoding).
                 Salting can prevent intruders from obtaining an encryption key based on patterns
                 produced by common passwords after encryption.
                        Users are encouraged to change their passwords often; even if an intruder
                 obtains a password, it may be changed before any real damage can be done. Some
                 systems require that users choose new passwords on a regular basis. Unfortunately,
                 some users will reuse two or three passwords cyclically, reducing overall security. In
                 response, several authentication systems prohibit repeated use of a user's most
                 recent password choices.
                        A simple defense against brute-force cracking and repeated password trials is to
                 limit the number of login attempts that may be initiated in any period of time from a
                 single terminal or workstation (or from a single account). Certainly, people make typ-
                 ing errors when attempting to log in, but it is unreasonable for someone who knows
                 the correct password to require tens, hundreds or thousands of tries. Therefore, a sys-
                 tem might allow three or four tries, then disconnect the terminal for several seconds
                 or minutes. After a waiting period, the terminal may be reconnected.

                 Self Review
                 1. (T/F) Longer and more complicated passwords guarantee higher security.
                 2. How does salting improve password security?
                 Ans: 1) False. Longer and more complicated passwords usually result in the user writing
                 down the password, enabling intruders to steal it. 2) Salting can prevent intruders from deter-
                 mining an encryption key based on patterns produced by common passwords after encryption.


                 19.3.2 Biometrics and Smart Cards
                 An innovation in security, once limited to the movies but becoming increasingly com-
                 mon in today's secure systems, is biometrics. Biometrics uses unique personal infor-
                 mation—such as fingerprints, eyeball iris scans or face scans—to identify a user. The
                 number of passwords an average user must remember has increased due to the prolif-

                   Plaintext               Ciphertext
                   password                 cGFzc3dvcmQ=
                   psasaswlortd             cHNhc2Fzd2xvcnRk
                   newpassword              bmV3cCFzc3dvcmQ=
                   nsewaplatssewodrd        bnM d2FwbGFOc3N1d29kcmQ=

                 Figure 19.5 | Salting passwords (Base 64 encoding).

<!-- pág. 935 -->

                                                                                          19.3   Authentication   883

eration of sensitive data transmitted over unsecure channels. [Note: People in the
security community prefer unsecure to insecure.] As a result, passwords have become
an increasing burden to secure computing. This trend can be detrimental to security,
as users record passwords on paper or employ the same password for several
accounts. Consequently biometrics has become an attractive alternative to passwords,
and the cost of biometric devices has dropped significantly.
      Fingerprint-scanning, face-scanning and iris-scanning devices are replacing
the use of passwords to log into systems, check e-mail or access secure information
over a network. Each user's fingerprint, face scan or iris scan is stored in a secure
database. Each time a user logs in, his or her scan is compared with the database. If
a match is made, the login is successful. Two companies that specialize in biometric
devices are IriScan (www.iriscan.com) and Keytronic (www.keytronic.com). For
additional resources, see the Web Resources section at the end of the chapter.
      Although passwords are currently the predominant means of authentication
in computer systems and e-commerce, several platforms have embraced biometrics.
In 2000, Microsoft announced its Biometric Application Programming Interface
(BAPI), which is included in its Windows 2000 and Windows XP operating systems
to simplify the integration of biometrics into personal and corporate systems.21
      Keyware Inc. (www. keyware.com) has implemented a wireless biometrics sys-
tem that stores user voiceprints on a central server. Keyware also created layered
biometric verification (LBV), which uses multiple physical measurements—face,
finger and voice prints—simultaneously. The LBV feature enables a wireless bio-
metrics system to combine biometrics with other authentication methods, such as
personal identification numbers (PIN) and PKI (Public Key Infrastructure; see
Section 19.9, Public-Key Infrastructure, Certificates and Certificate Authorities). 22
      Identix, Inc. (www.identix.com) also provides biometrics authentication
technology for wireless transactions. The Identix fingerprint-scanning device is
embedded in handheld devices. The Identix service offers transaction management
and content protection services. Transaction management services prove that trans-
actions took place, and content protection services control access to electronic doc-
uments, including limiting a user's ability to download or copy documents. 23
      A smart card, often designed to resemble a credit card, is typically used to
perform authentication and store data. The most popular smart cards are memory
cards and microprocessor cards. Memory cards can store and transfer data. Micro-
processor cards contain computer components, managed by an operating system,
that provide security and storage. Smart cards are also characterized by their inter-
face to reading devices. One is a contact interface, whereby smart cards are inserted
into a reading device, requiring physical contact between the device and the card
for data transfer. Alternatively, a contactless interface allows data to be transferred
without physical contact between the reader and the card, often accomplished with
an embedded wireless device in the card.24
      Smart cards can store private keys, digital certificates and other information
necessary for implementing PKI. They may also store credit card numbers, personal

<!-- pág. 936 -->

884 Security
               contact information, and the like. Each smart card can be used in combination with
               a PIN. This feature provides two levels of security by requiring the user to possess a
               smart card and know the corresponding PIN to access information stored on the
               card. To further strengthen security, some microprocessor cards will delete or cor-
               rupt stored data in the event of malicious tampering with the card. Smart-card PKI
               allows users to access information from multiple devices using the same smart card.
                      Two-factor authentication employs two means to authenticate the user, such
               as biometrics or a smart card used in combination with a password. Though this sys-
               tem could potentially be compromised, using two methods of authentication typi-
               cally provides better security than passwords alone.

               Self Review
               1. Why is it difficult for an unauthorized user to gain access in a system that uses biometrics
                  for security?
               2. Explain one disadvantage to storing unencrypted user information on a smart card.
               Ans: 1) It is difficult to replicate another user's physical features. 2) If the smart card is sto-
               len, another individual could access that user's potentially sensitive information.



               19.3.3 Kerberos
               Internal computer attacks (i.e., attacks that originate from a valid user) are com-
               mon and can be extremely damaging. For example, disgruntled employees with net-
               work access can disable an organization's network or steal valuable proprietary
               information. It is estimated that 70-90 percent of attacks on corporate networks are
               internal.25 A centralized, secure authentication system can facilitate a fast response
               to such security attacks. Kerberos, a freely available, open-source protocol devel-
               oped at MIT, can provide protection against internal security attacks. It employs
               secret-key cryptography to authenticate users in a network and to maintain the
               integrity and privacy of network communications.26'27
                     Authentication in Kerberos is handled by an authentication server and a sec-
               ondary Ticket Granting Service (TGS). This system is similar to the key distribution
               centers described in Section 19.2.1, Secret-Key Cryptography. The authentication
               server authenticates a client's identity to the TGS; the TGS authenticates the cli-
               ent's rights to access specific network services.
                     Each client in the network shares a secret key with the Kerberos system. This
               secret key may be stored by multiple TGSs in the Kerberos system. The Kerberos
               system works as follows:28
                     1. The client begins by submitting a username and password to the Kerberos
                        authentication server.
                     2. The authentication server maintains a database of all clients in the net-
                        work. If the username and password are valid, the authentication server
                        returns a Ticket-Granting Ticket (TGT) encrypted with the client's secret
                        key. Because the secret key is known only by the authentication server and

<!-- pág. 937 -->

                                                                                                   19.3   Authentication   885

         the client, only the client can decrypt the TGT, thus authenticating the cli-
         ent's identity.
      3. The client sends the decrypted TGT to the Ticket Granting Service to
         request a service ticket. The service ticket authorizes the client's access to
         specific network services. Service tickets are assigned an expiration time
         and can be renewed or revoked by the TGS. If the TGT is valid, the TGS
         issues a service ticket encrypted with the client's session key.
      4. The client then decrypts the service ticket, which it then presents to gain
         access to networked resources.

Self Review
1. In Kerberos authentication, why must the connection between clients and the authentica-
   tion server be secure?
2. Why is it appropriate for tickets to expire?
Ans: 1) If the connection is not secure, eavesdroppers could steal user names and passwords
to gain access to secure resources. 2) It is appropriate for tickets to expire because it forces
users to reauthenticate often. For example, if an authorized user leaves a terminal while logged
in, the ticket can expire before an unauthorized user can cause significant damage.


19.3.4 Single Sign-On
Single sign-on systems simplify the authentication process by allowing the user to
log in once, using a single password. Users authenticated via a single sign-on system
can then access multiple applications across multiple computers. Sign-on passwords
should be closely guarded, because if a password becomes available to attackers, all
applications protected by that password can be accessed and attacked.
      Workstation login scripts are the simplest form of single sign-on. Users log in
at their workstations, then choose applications from a menu. The workstation login
script sends the user's password to the application servers to authenticate the user
for future access to those applications. Many workstation login scripts do not pro-
vide a sufficient level of security, because user passwords are often stored on the cli-
ent computer in plaintext. Even if the script uses simple password encryption, that
algorithm must be present on the system, meaning that any intruder that gains
access to the computer will be able to compromise the encryption.
      Authentication server scripts authenticate users via a central server. The cen-
tral server controls connections between the user and the applications the user
wishes to access. Authentication server scripts are more secure than workstation
login scripts because passwords are maintained on the server, which is generally
more secure than the client computer. However, if the security of the server is com-
promised, the security of the entire system is also compromised.
      The most advanced single sign-on systems employ token-based authentica-
tion. Once a user is authenticated, a unique token is issued to enable the user to
access specific applications. The login that creates the token is secured by encryp-
tion or a single password. For example, Kerberos uses token-based authentication,

<!-- pág. 938 -->

886 Security
               in which the service ticket acts as the token. A key problem with token authentica-
               tion is that applications must be modified to accept tokens, rather than traditional
               login passwords.29
                     Currently, the three leaders in development of single sign-on technology are
               the Liberty Alliance Project ( w w w . p r o j e c t l i b e r t y . o r g ) , Microsoft and Novell.
               The Liberty Alliance Project is a consortium of technology and security organiza-
               tions working to create an open single sign-on solution. Microsoft's .NET Passport
               and Novell's SecureLogin are also viable solutions, though they are proprietary. To
               protect the privacy of information submitted to single sign-on and other applica-
               tions, the Platform for Privacy Preferences (P3P) allows users to control the per-
               sonal information that sites collect.30, 31

               Self Review
               1. Of the three single sign-on services, which is the most secure?
               2. In what way are workstation login scripts more secure than authentication server scripts?
               Ans: 1) Token-based authentication is the most secure. However, it is also the most compli-
               cated scheme. 2) Workstation login scripts are more secure in that the security for all of the
               other users in the system is not compromised if the security of a workstation login script is
               compromised.



               19.4     Access       Control
               As a resource manager, the operating system must carefully guard against uninten-
               tional and malicious use of computer resources. Consequently, today's operating
               systems are designed to protect operating system services and sensitive information
               from users and/or software that have gained access to computer resources. Access
               rights protect system resources and services from potentially dangerous users by
               restricting or limiting the actions that can be performed on the resource. These
               rights are typically managed by access control lists or capability lists.


               19.4.1 Access Rights and Protection Domains
               The key to operating system security is to control access to internal data and
               resources. Access rights define how various subjects can access various objects. Sub-
               jects may be users, processes, programs or other entities. Objects are resources such
               as hardware, software and data; they may be physical objects that correspond to
               disks, processors or main memory. They may also be abstract objects that corre-
               spond to data structures, processes or services. Subjects can also be objects of the
               system; one subject may have rights to access another. Subjects are active entities,
               objects are passive. As a system runs, its population of subjects and objects tends to
               change. The manner in which a subject can access an object is called a privilege and
               can include reading, writing and printing.
                     Objects must be protected from subjects. If a process were allowed to access
               every resource on a system, a user could maliciously (or inadvertently) compromise

<!-- pág. 939 -->

                                                                                                   19.4 Access Control 887

system security or cause other programs to crash. To prevent such events from
occurring, each subject must obtain authorization to access objects within a system.
      A protection domain is a collection of access rights. Each access right in a pro-
tection domain is represented as an ordered pair with fields for the object name and
its corresponding privileges. A protection domain is unique to a subject. For example,
if a user can read and write the file example.txt, the corresponding ordered pair for
this user's access right can be represented by <example.txt, { read, write}>. 3 2
      The most common access rights are read, write and execute. Some subjects
may also grant access rights to other subjects. In most computing systems, the
administrator possesses all access rights and is responsible for managing other
users' rights.
      Access rights may be copied, transferred or propagated from one domain to
another. Copying an access right simply entails granting a right of one user to
another user. When an access right is transferred from subject A to subject B, sub-
ject A's access right is revoked upon completion of the transfer. Propagating an
access right is similar to copying an access right; however, in addition to sharing the
original access right, both subjects can also copy the right to other subjects.
      When a subject no longer needs access to an object, access rights can be
revoked. Several issues arise—should revocation be immediate or delayed? Should
revocation apply to all objects or a select few? Should revocation apply to specific
subjects or an entire domain? Should revocation be permanent or temporary? Each
implementation of access rights management addresses revocation differently; we
discuss several implementations in Section 19.4.3.33

Self Review
1. (T/F) The term subject always refers to users in a system.
2. Explain the difference between copying access rights and propagating access rights.
Ans: 1) False. The term subject can refer to users, processes, programs and other entities.
2) If subject A copies a right to subject B, subject B will not be able to grant that right to
other subjects. However, if subject A propagates a right to subject B, subject B will be able to
grant that right to other subjects.


19.4.2 Access Control Models and Policies
Access control can be divided into three conceptual levels: models, policies and
mechanisms. A security model defines a system's subjects, objects and privileges. A
security policy, which is typically specified by the user and/or system administrator,
defines which privileges to objects are assigned to subjects. The security mechanism
is the method by which the system implements the security policy. In many systems,
the policy changes over time as the system's set of resources and users change, but
the security model and mechanisms that implement access control do not require
modification, so the security policy is separated from the mechanism and model.
      A popular security model organizes users into classes, as discussed in
Section 13.8.2, Access Control by User Classes. A drawback is that access rights are

<!-- pág. 940 -->

888 Security

               stored in each file and specify a single owner and group, so at most one group can
               access a particular file. Further, the system might need to modify group permissions
               for several files when assigning new access rights to a group of users—an error-
               prone and time-consuming process.
                     In the role-based access control (RBAC) model, users are assigned roles, each
               typically representing a set of tasks assigned to a member of an organization. Each
               role is assigned a set of privileges, which define the objects that users in each role
               can access.34 Users can belong to multiple roles; administrators need only modify
               permissions for a single role to change access rights for a group of users. The appeal
               of RBAC is that it assigns meaningful relationships between subjects and objects
               that are not limited by classes such as owners and groups.
                     For example, consider an academic computer system with the following roles:
               faculty members create and grade assignments, students submit completed assign-
               ments and staff members post grades to student transcripts. Under the RBAC
               model, this system consists of three roles (students, faculty and staff), two objects
               (assignments and grades) and three permissions (read, modify and create). In this
               example, faculty have permission to create, read and modify both assignments and
               grades; students have permission to read and modify copies of coursework and read
               grades; staff have permission to read and modify grades.
                     Although security policies vary to meet the needs of users in a system, most
               policies incorporate the principle of least privilege —a subject is granted access only
               to the objects it requires to perform its tasks. Policies can also implement discre-
               tionary or mandatory access control depending on the security needs of the envi-
               ronment. Most UNIX-based systems follow the discretionary access control (DAC)
               model, whereby the creator of an object controls the permissions for that object.
               On the contrary, mandatory access control (MAC) policies predefine a central per-
               mission scheme by which all subjects and objects are controlled. MAC is found in
               many high-security installations, such as classified government systems.35


               Self Review
               1. Why are access control policies and mechanisms typically separated?
               2. How might MAC be more secure than DAC?
               Ans: 1) Policies often change without requiring modification to their underlying implemen-
               tation; changing policies requires less work if the security policy is separated from the secu-
               rity mechanism. 2) MAC prevents users from accidentally or intentionally assigning
               permissions that might compromise system security (e.g., the owner of a file assigning public
               access to sensitive information).



               19.4.3 Access Control Mechanisms
               In this section we discuss various techniques that an operating system can employ
               to manage access rights. Access control matrices match subjects and objects to the
               appropriate access rights. The concept behind the model is simple; however, most

<!-- pág. 941 -->

                                                                                              19.4 Access Control 889
systems contain many subjects and objects, resulting in a large matrix that is an inef-
ficient means for access control. Access control lists and capability lists are derived
from the principle of least privilege and are often more efficient and flexible meth-
ods of managing access rights. Section 20.13.2, Access Control Methods, and
Section 21.13.2, Authorization, discuss how Linux and Windows XP, respectively,
use access control methods to secure their systems.

Access Control Matrices
One way to manage access rights is in an access control matrix. The various subjects
are listed in the rows, and the objects to which they require access are listed in the
columns. Each cell in the matrix specifies the actions that a subject (defined by the
row) can perform on an object (defined by the column). Access rights in an access
control matrix are granted on the basis of least privilege, so if an access right is not
explicitly described in the matrix, the user has no access rights to the object.36
         Because an access control matrix places all permission information in a cen-
tral location, the matrix should be one of the most closely guarded entities in an
operating system. If the matrix is compromised, any resources that were protected
by the access rights defined in the matrix are susceptible to attack as well.
         The access control matrix in Fig. 19.6 represents the access rights for the users
(Alice, Bob, Chris, David and Guest) to the objects ( F i l e A, F i l e B and
Pri n t e r ) . The privileges that a user can obtain for an object are read, w r i t e and
p r i n t . The read and w r i t e access rights apply only to files on the system, in this
case, F i l e A and F i l e B. In some environments, not every user has access to the
printer—a user must explicitly have the p r i n t privilege to send content to the
printer. Any access right that is followed by an asterisk (*) can be copied from one
user to another. In this access control matrix, Alice has all access rights as well as
the ability to assign these rights to other users. Davi d cannot access Fi 1 e A because
there is no entry in the corresponding cell in the matrix. The Guest account con-
tains no access rights by default. A Guest can access resources only when the right
is explicitly granted by another user. Although generating and interpreting an
access control matrix is straightforward, the matrix can become large and sparsely
populated.




Figure 19.6 I Access control matrix for a small group of subjects and objects.

<!-- pág. 942 -->

890 Security

               Access Control Lists
               An access control list stores the same data as an access control matrix, but it main-
               tains a record of only those entries that specify an access right. The access control
               list for a system can be based on the rows of a matrix (the subjects) or the columns
               (the objects). For each object in an operating system, an access control list contains
               entries for each subject and the privileges associated with that subject for the
               object. When a subject attempts to access an object, the system searches the access
               control list for that object to find any privileges for the subject.37
                      A drawback to this method is the inefficiency with which the operating system
               determines user privileges for a particular object. The access control list for each
               object contains an entry for every subject with privileges for that object —a poten-
               tially large list. Each time an object is accessed, the system must search the list of
               subjects to find the proper privileges. It is difficult to determine which access rights
               belong to a certain protection domain when using access control lists; the access list
               for every object in the system must be searched for entries regarding that particular
               subject.
                      The access control list in Fig. 19.7 represents the set of access rights that were
               established in the access control matrix of Fig. 19.6. The implementation is smaller
               because empty entries in the matrix are not present. If an object does not contain
               an entry for a particular user, that user has no privileges for the object.

               Capability Lists
               A capability is a pointer or token that grants privileges to a subject that possesses it. It
               is analogous to a ticket used to gain access to a sporting event. Capabilities ordinarily
               are not modified, but they can be reproduced. Recall that a protection domain defines
               the set of privileges between subjects and objects. Alternatively, one can define the
               protection domain as the set of capabilities belonging to a subject.38
                     A capability is often implemented as a unique object identifier. Capabilities
               are granted to a subject, which presents the token for all subsequent accesses to the


                  1    File A:
                  2       <Alice, {read*, write*}>
                  3       <Bob, {read*, wn'te}>
                  4       <Chris, {read}>
                  5    File B:
                  6       <Alice, {read*, write*}>
                  7       <Bob, {read*, write}>
                  8       <David, {read}>
                  9    Printer:
                 10       <Alice, { p r i n t * } >
                 11       <Bob, {print}>
                 12       <Chris, { p r i n t } >

               Figure 19.7 I Access control list derived from the access control matrix.

<!-- pág. 943 -->

                                                                                                   19.4 Access Control 891
object. Capabilities are created by carefully guarded operating system routines. A
subject that possesses a capability may perform certain operations, including creat-
ing copies of the capability or passing it as a parameter.
      Upon creation of an object, a capability for that object is created. This original
capability includes full privileges for the new object. The subject that creates the
object may pass copies of the capability to other subjects. Likewise, a subject receiv-
ing a capability may use it to access the object, or the subject may create additional
copies and pass them to other subjects. When one subject passes a capability to
another, it may reduce the associated privileges. Thus, as a capability propagates
through the system, its privilege set can either remain the same or decrease in size.
      Users must be prevented from creating capabilities arbitrarily. This can be
accomplished by storing capabilities in segments that user processes cannot access.
      The identifier in a capability may be implemented as a pointer to the desired
object, or it may be a unique bit sequence (i.e., a token). Pointers simplify access to
the address at which the object is stored, but all such pointers in the system must be
updated if the object is moved, which can degrade performance. When using
tokens, capabilities do not rely on the object's location in memory. However,
because a token does not specify the location of its corresponding object, tokens
require that the object's address be determined when the capability is first used. A
hashing mechanism implements token-based capabilities efficiently; high-speed
caches often reduce the overhead of repeated references to the same object.
      Systems that employ capabilities can suffer from the "lost object" problem. If
the last remaining capability for an object is destroyed, the associated object can no
longer be accessed. To prevent this problem, many operating systems ensure that
the system always maintains at least one capability for each object.
      Controlling the propagation of capabilities is a difficult problem. Systems gen-
erally do not allow direct manipulation of capabilities by users; instead capability
manipulation is performed by the operating system on behalf of the users. Keeping
track of capabilities is an important task that becomes difficult in multiuser systems
containing a large numbers of capabilities. Many systems employ a directory struc-
ture to manage their capabilities.39



Self Review
1. In what type of environment are access control lists more appropriate than access control
   matrices?
2. Discuss the advantages and disadvantages of token-based and pointer-based capabilities.
Ans: 1) Access control lists are more appropriate than access control matrices when the
matrices are sparse. In this case, access control lists require much less space than access con-
trol matrices. 2) Pointers simplify access to the address at which the object is stored, but all
such pointers in the system must be updated if the object is moved, which can degrade per-
formance. When using tokens, capabilities are independent of the object's location in mem-
ory. However, because a token does not specify the location of its corresponding object,
tokens require that an object's address be determined when the capability is first used.

<!-- pág. 944 -->

892   Security

                 19.5 Security Attacks
                 Recent cyber attacks on e-businesses have made the front pages of newspapers
                 worldwide. Denial-of-service attacks (DoS), viruses and worms have cost companies
                 billions of dollars and caused countless hours of frustration. Many of these attacks
                 allow the perpetrator to penetrate a network or system, which can lead to data theft,
                 data corruption and other attacks. In this section we discuss several types of attacks
                 against computer systems. Section 19.6, Attack Prevention and Security Solutions,
                 discusses possible solutions to protect a computer's information and integrity.


                 19.5.1 Cryptanalysis
                 A cryptanalytic attack attempts to decrypt ciphertext without possessing the
                 decryption key. The most common form of cryptanalytic attacks are those in which
                 the encryption algorithm is analyzed to find relations between bits of the encryption
                 key and bits of the ciphertext. The goal of such an attack is to determine the key
                 from the ciphertext.
                       Weak statistical trends between ciphertext and keys can be exploited to gain
                 knowledge about the key. Proper key management and key expiration dates can
                 reduce susceptibility to cryptanalytic attacks. The longer an encryption key is used,
                 the more ciphertext an attacker can use to derive the key. If a key is covertly recov-
                 ered by an attacker, it can be used to decrypt every message that uses the key.

                 Self Review
                 1. How do key expiration dates reduce the effectiveness of cryptanalytic attacks?
                 Ans: 1) The longer an encryption key is used, the more ciphertext an attacker can use to
                 derive the key. Key expiration addresses this concern by limiting hour long each key is in use.



                 19.5.2 Viruses and Worms
                 A virus is executable code—often sent as an attachment to an e-mail message or
                 hidden in files such as audio clips, video clips and games—that attaches to or over-
                 writes other files to replicate itself. Viruses can corrupt files, control applications or
                 even erase a hard drive. Today, viruses can be spread across a network simply by
                 sharing "infected" files embedded in e-mail attachments, documents or programs.
                       A worm is executable code that spreads by infecting files over a network.
                 Worms rarely require any user action to propagate, nor do they need to be attached
                 to another program or file to spread. Once a virus or worm is released, it can spread
                 rapidly, often infecting millions of computers worldwide within minutes or hours.
                       Viruses can be classified as follows:
                       1. boot sector virus—infects the boot sector of the computer's hard disk,
                          allowing it to load with the operating system and potentially control the
                          system.

<!-- pág. 945 -->

                                                                                         19.2 Security Attacks 893

     2. transient virus—attaches itself to a particular computer program. The virus
        is activated when the program is run and deactivated when the program is
        terminated.
     3. resident virus—once loaded into the memory of a computer, it operates
        until the computer is powered down.
     4. logic bomb—executes its code, or payload, when a given condition is met.
        An example of a logic bomb is a time bomb, which is activated when the
        clock on the computer matches a certain time or date.
      A Trojan horse is a malicious program that hides within a trusted program or
simulates a legitimate program or feature, while actually causing damage to the
computer or network when the program is executed. The name Trojan horse origi-
nates from the story of the Trojan War in Greek legend. [Note: In this story, Greek
warriors hid inside a wooden horse, which the Trojans took within the walls of the
city of Troy. When night fell and the Trojans were asleep, the Greek warriors came
out of the horse and opened the gates to the city, letting the Greek army enter and
destroy the city of Troy] Trojan horse programs can be particularly difficult to
detect, because they appear to be legitimate and operational applications.
      Back-door programs are resident viruses that allow the sender complete,
undetected access to the victim's computer resources. These types of viruses are
especially threatening to the victim, as they can be programmed to log every key-
stroke (capturing all passwords, credit card numbers, etc.).


Widespread Viruses
Two viruses that attracted significant media attention are Melissa, which struck in
March 1999, and the ILOVEYOU virus that hit in May 2000. Each caused billions
of dollars of damage. The Melissa virus spread in Microsoft Word documents sent
via e-mail. When the document was opened, the virus was triggered, at which point
it accessed a user's Microsoft Outlook address book (i.e., a list of e-mail addresses)
on that computer and sent the infected Word attachment by e-mail to a maximum
of 50 people in the user's address book. Each time another user opened the attach-
ment, the virus would send up to 50 additional messages. Once resident in a system,
the virus also infected any files saved using Microsoft Word.
       The ILOVEYOU virus was sent as an attachment to an e-mail posing as a love
letter. The message in the e-mail said "Kindly check the attached love letter corning
from me." Once opened, the virus accessed the Microsoft Outlook address book and
sent messages to each address listed, enabling the virus to spread rapidly worldwide.
The virus corrupted many types of files, including operating system files. Many net-
works were disabled for days due to the massive number of e-mails generated.
       This virus exposed e-mail security inadequacies, such as a lack of software to
scan file attachments for security threats before they are opened. It also taught
users to be more aware of suspicious e-mails, even those from someone with whom
they are familiar.

<!-- pág. 946 -->

894   Security

                 Sapphire/Slammer Worm: Analysis and Implications
                 Worms spread by exploiting weaknesses in communications channels established
                 by software, either by applications or by the operating system. Once a weakness is
                 discovered, a worm can produce network traffic sufficient to disable a single com-
                 puter or a network of computers. Further, a worm can be designed to execute code
                 on the computer it infects, potentially allowing the worm's creator to obtain or
                 destroy sensitive information.
                       Worm attacks that have received media attention include Nimda, Code Red
                 and Sapphire, also called Slammer. Slammer, which infected most vulnerable com-
                 puters within 10 minutes of its release on January 25, 2003, doubled the number of
                 computers it infected every 8.5 seconds. [Note: Vulnerable computers were those
                 running Microsoft SQLServer 2000 to which a security patch, released by Microsoft
                 in July 2002, was not applied.] The infection rate was two orders of magnitude faster
                 than its notable predecessor, the Code Red worm. The latter, a 4KB worm, instanti-
                 ated multiple threads to create TCP connections to infect new hosts. On the con-
                 trary, Slammer operated over UDP and its payload was contained in a single 404-
                 byte UDP packet. The connectionless UDP protocol, coupled with a random-scan-
                 ning algorithm to generate target IP addresses, made the Slammer worm particu-
                 larly virulent. A random-scanning algorithm uses pseudorandom numbers to
                 generate a broad distribution of IP addresses as targets to infect.
                       The Slammer worm caused system and network outages due to network satu-
                 ration by its UDP packets. Interestingly, the worm included no malicious payload
                 and attacked a vulnerability in an application of relatively limited worldwide use.
                 The Slammer worm also contained what appeared to be a logic error in its random-
                 scanning algorithm that significantly limited the number of IP addresses the worm
                 could reach. 40
                       Antivirus software can protect against viruses and some worms. Most antivi-
                 rus software is reactive, meaning that it can attack known viruses, rather than pro-
                 tecting against unknown or future viruses. We discuss antivirus software in
                 Section 19.6.3.

                 Self Review
                 1. How do worms differ from other viruses?
                 2. What weaknesses in computer systems did the Melissa and ILOVEYOU viruses expose?
                 Ans: 1) Worms typically spread via network connections and do not require user interaction
                 to spread. 2) The viruses exposed insufficient file-scanning antivirus software for e-mail applica-
                 tions and demonstrated that users did not treat suspicious e-mails with appropriate care.




                 19.5.3 Denial.of.Service (DoS) Attacks
                 A denial-of-service (Dos) attack prevents a system from servicing legitimate
                 requests. In many DoS attacks, unauthorized traffic saturates a network's resources,

<!-- pág. 947 -->

                                                                                                 19.5   Security   Attacks   895
  restricting access for legitimate users. Typically, the attack is performed by flooding
servers with data packets. Denial-of-service attacks usually require a network of
computers to work simultaneously, although some skillful attacks can be achieved
 with a single machine. Denial-of-service attacks can cause networked computers to
crash or disconnect, disrupting service on a Web site or even disabling critical sys-
tems such as telecommunications or flight-control centers.
       Another type of denial-of-service attack targets a network's routing tables.
Recall that routing tables provide a view of the network topology and are used by a
router to determine where to send data. This type of attack is accomplished by modi-
fying the routing tables, thus maliciously redirecting network activity. For example,
the routing tables can be changed to send all incoming data to one address in the net-
work. A similar attack, called a DNS (domain name system) attack, can modify the
address to which network traffic for a particular Web site is sent. Such attacks can be
used to redirect users of a particular Web site to another, potentially malicious, Web
site. These attacks are particularly dangerous if the illegitimate Web site poses as the
real one, leading users to disclose sensitive information to the attacker.
       In a distributed denial-of-service attack, packet flooding comes from multiple
computers at once. Such attacks are typically initiated by an individual who has
infected several computers with a virus to gain unauthorized access to them to carry
out the attack. Distributed denial-of-service attacks can be difficult to stop, because it
 is not easy to determine which requests on a network are from legitimate users and
which are part of the attack. It is also particularly difficult to identify the perpetrator of
such attacks, because they are not carried out directly from the attacker's computer.
       In February 2000, distributed denial-of-service attacks shut down a number of
high-traffic Web sites, including Yahoo!, eBay, CNN Interactive and Amazon. In this
case, a single user utilized a network of computers to flood the Web sites with traffic
that overwhelmed the sites' computers. Although denial-of-service attacks merely
shut off access to a Web site and do not affect the victim's data, they can be
extremely costly. For example, when eBay's Web site went down for a 24-hour
period on August 6,1999, its stock value declined dramatically.41
       Who is responsible for viruses and denial-of-service attacks? Most often the
responsible parties are referred to as hackers, but really that is a misnomer. In the
computer field, hacker refers to an experienced programmer, often one who programs
as much for personal enjoyment as for the functionality of the application. The true
term for such people is cracker, which is someone who uses a computer maliciously
(and often illegally) to break into another system or cause another system to fail.


Self Review
1. How are DNS attacks harmful?
2.. Why is it difficult to detect and stop distributed denial-of-service attacks?
Ans: 1) Users unaware of malicious activity could submit sensitive information to a cracker.
Legitimate Web sites may lose revenue because users are redirected to alternate sites. 2) It
may be difficult to distinguish between legitimate and malicious users.

<!-- pág. 948 -->

896   Security

                 19.5.4 Software Exploitation
                 Another problem plaguing e-businesses is software exploitation by crackers. Every
                 program on a networked machine should be checked for vulnerabilities. However,
                 with millions of software products available and vulnerabilities discovered daily,
                 this becomes an overwhelming task. One common vulnerability exploitation
                 method is a buffer overflow, in which a program receives input that is larger than its
                 allocated space.
                        A buffer overflow occurs when an application sends more data to a buffer
                 than it can hold. A buffer overflow attack can push the additional data into adjacent
                 buffers, corrupting or overwriting existing data. A well-designed buffer overflow
                 attack can replace executable code in an application's stack to alter its behavior.
                 Buffer overflow attacks may contain malicious code that will then be able to exe-
                 cute with the same access rights as the application it attacked. Depending on the
                 user and application, the attacker may gain access to the entire system. BugTraq
                 (www.securityfocus.com) was created in 1993 to list vulnerabilities, how to
                 exploit them and how to repair them.

                 Self Review
                 1. Why are buffer overflow attacks dangerous?
                 2. How can buffer overflow attacks be prevented?
                 Ans: 1) Buffer overflow attacks may modify an application's stack so that an attacker can
                 execute code to gain access to the entire system. 2) An application can rigidly enforce buffer
                 limits when accepting input. Also, the system can implement stack segments that are not exe-
                 cutable.


                 19.5.5 System Penetration
                 The result of many security attacks is system or network penetration. According to
                 a study by the Computer Security Institute (www.gocsi.com), 40 percent of the
                 respondents reported that an outsider had successfully penetrated their systems.42
                 After an attacker exploits an operating system or the software running on the com-
                 puter, the system is vulnerable to a number of attacks—ranging from data theft and
                 manipulation to a system crash. A system penetration is a successful breach of com-
                 puter security by an unauthorized external user.43 Every system penetration is
                 potentially dangerous, although a quick response can usually thwart an intruder's
                 attack before any significant damage is done. Many attacks, such as data theft and
                 Web defacing, rely on a successful system penetration as a foundation.
                       Web defacing is a popular form of attack wherein the crackers illegally obtain
                 access to modify an organization's Web site and change the contents. Web defacing
                 has attracted significant media attention. A notable case occurred in 1996, when
                 Swedish crackers changed the Central Intelligence Agency Web site to read "Cen-
                 tral Stupidity Agency." The vandals placed obscenities, political messages, notes to
                 system administrators and links to adult-content sites on the page. Many other pop-
                 ular and large Web sites have been defaced. Defacing Web sites has become over-

<!-- pág. 949 -->

                                                                     19.6 Attack Prevention and Security Solutions 897

whelmingly popular among crackers today, causing archives of attacked sites (with
records of more than 15,000 vandalized sites) to close because of the volume of sites
that were vandalized daily.44
      System penetration often occurs as a result of a Trojan horse, back-door pro-
gram or an exploited bug in software or the operating system. Allowing external
users to access applications via the Web provides another channel for an attacker to
penetrate a system.45 Vulnerabilities in common Web server applications, such as
Microsoft Internet Information Services (IIS) and Apache HTTP Server, give
 attackers a well-known route to penetrating a system if administrators fail to apply
necessary patches. System penetration can also occur on personal computers
through software connected to the Internet, such as Web browsers.
      The CERT®/CC (Computer Emergency Response Team Coordination Center;
www.cert.org) at Carnegie Mellon University's Software Engineering Institute is a
federally funded research and development center. CERT/CC responds to reports of
viruses and denial-of-service attacks and provides information on network security,
 including how to determine if a system has been compromised. The site provides
detailed incident reports of viruses and denial of service attacks, including descrip-
tions of the incidents, their impact and solutions. The site also reports the vulnerabili-
ties in popular operating systems and software packages. The CERT Security
Improvement Modules are excellent tutorials on network security. These modules
describe the issues and technologies used to solve network security problems.

Self Review
1. List several techniques crackers use to penetrate systems.
2. Compare Web defacing to a DNS attack.
Ans: 1) Crackers can issue a Trojan horse back-door program, place an exploited bug in
software or the operating system or access applications via an organization's Web site. 2) Web
defacing occurs when crackers illegally obtain access to modify an organization's Web site
and change its contents. DNS attacks modify the address to which network traffic for a partic-
ular Web site is sent, which can redirect users of a particular Web site to another.


19.6 Attack Prevention and Security Solutions
The previous section detailed several common attacks against computer security,
 Though the number of threats to computer security may seem overwhelming, in
practice, common sense and diligence can prevent a large number of attacks. To fur-
ther bolster security, additional hardware and software that specializes in thwarting
a variety of attacks can be installed on computers and in networks. This section
describes several common security solutions.

19.6.1 Firewall
A firewall protects a local area network (LAN) from intruders outside the network.
A firewall polices inbound and outbound traffic for the LAN. Firewalls can prohibit
all data transmission that is not expressly allowed, or allow all data transmission that

<!-- pág. 950 -->

898 Security

               is not expressly prohibited. The choice between these two models can be determined
               by the network security administrator; the former provides a high level of security,
               but might prevent legitimate data transfer. The latter leaves the system more suscepti-
               ble to attack, but generally does not restrict legitimate network transfer. Each LAN
               can be connected to the Internet through a gateway, which typically includes a fire-
               wall. For years, the most significant security threats originated from employees inside
               the firewall. Now that businesses rely heavily on access to the Internet, an increasing
               number of security threats originate outside the firewall—from the hundreds of mil-
               lions of people connected to the company network via the Internet. 46
                      There are two primary types of firewalls. A packet-filtering firewall examines all
               data sent from outside the LAN and rejects data packets based on predefined rules,
               such as reject packets that have local network addresses or reject packets from cer-
               tain addresses or ports. For example, suppose that a hacker from outside the network
               obtains the address of a computer inside the network and attempts to pass a harmful
               data packet through the firewall by sending a packet indicating that it was sent from
               the computer inside the network. In this case, a packet-filtering firewall will reject the
               data packet because the return address of the inbound packet has clearly been modi-
               fied. A limitation of packet-filtering firewalls is that they consider only the source of
               data packets; they do not examine the attached data. As a result, malicious viruses
               can be installed on an authorized user's computer, allowing an attacker access to the
               network without that user's knowledge. The goal of an application-level gateway is to
               protect the network against the data contained in packets. If the message contains a
               virus, the gateway can block it from being sent to the intended receiver.
                      Installing a firewall is one of the most effective and easiest ways to add security
               to a small network.47 Often, small companies or home users who are connected to the
               Internet through permanent connections, such as cable modems, do not employ
               strong security measures. As a result, their computers are prime targets for crackers
               to exploit for denial-of-service attacks or information theft. However, it is important
               for all computers connected to the Internet to contain some degree of security for
               their systems. Many popular network products, such as routers, provide firewall capa-
               bilities and certain operating systems, such as Windows XP, provide software firewalls.
               In fact, the Windows XP Internet Connection Firewall (ICF) is enabled by default.
               Section 21.13.3, Internet Connection Firewall, discusses how Windows XP imple-
               ments its firewall. Numerous other firewall software products are available; several
               are listed in the Web Resources section at the end of the chapter.
                      Air gap technology is a network security solution that complements the fire-
               wall. It secures private data from external traffic accessing the internal network.
               The air gap separates the internal network from the external network, and the orga-
               nization decides which information will be made available to external users. Whale
               Communications created the e-Gap System, which is composed of two computer
               servers and a memory bank. The memory bank does not run an operating system:
               therefore hackers cannot take advantage of common operating system weaknesses
               to access network information.

<!-- pág. 951 -->

                                                                      19.6 Attack Prevention and Security Solutions 899

      Air gap technology does not allow outside users to view the network's struc-
 ture, which prevents hackers from searching the network for weaknesses. The e-
Gap Web Shuttle feature allows safe external access by restricting the system's
 "back office," where an organization's most sensitive information and IT-based
business processes are controlled. Users who wish to access a network hide behind
 the air gap, where the authentication server is located. Authorized users gain access
 through a single sign-on capability, allowing them to use one login password to
access authorized areas of the network.
      The e-Gap Secure File Shuttle feature moves files in and out of the network.
Each file is inspected behind the air gap. If the file is deemed safe, it is carried by the
File Shuttle into the network. 48
      Air gap technology is used by e-commerce organizations to allow their clients
and partners to access information with transparent security, thus reducing the cost
of inventory management. Military, aerospace and government industries, which
store highly sensitive information, employ air gap technology.

Self Review
1. Is a home user more likely to use a firewall to prohibit all data flow not expressly allowed
   or to allow all data that is not expressly prohibited?
2. Discuss the difference between packet-filtering firewalls and application gateways.
Ans: 1) A home user would be more likely to allow all data that is not expressly prohibited,
because the user will most likely want to access a large (and evolving) set of Web sites,
 located at different IP addresses. 2) A packet-filtering firewall examines all data sent from
 outside the LAN and rejects data packets based on predefined rules, such as reject packets
that have local network addresses or reject packets from certain addresses or ports. An appli-
cation-level gateway protects the network against the data contained in packets. If the mes-
sage contains a virus, the gateway can block it from being sent to the intended receiver.


19.6.2 Intrusion Detection Systems (IDSs)
Intrusion detection systems (IDSs) monitor networks and application log files,
which record information about system behavior, such as the time at which operat-
ing system services are requested and the name of the process that requests them.
IDSs examine log files to alert system administrators of suspicious application and/
or system behavior, ff an application exhibits erratic or malicious behavior, an IDS
can halt the execution of that process.49
       Host-based intrusion detection systems monitor system and application log
files, which is especially useful for detecting Trojan horses. Network-based intrusion
detection software monitors traffic on a network for any unusual patterns that
might indicate DoS attacks or access to a network by an unauthorized user. System
administrators can then check their log files to determine if there was an intrusion
and, if so, track the offender. Intrusion detection products are commercially avail-
able from companies such as Cisco (www.cisco.com/warp/public/cc/pd/sqsw/
sqidsz), Hewlett-Packard (www.hp.com/security/home.html) and Symantec

<!-- pág. 952 -->

900   Security
                 (www.symantec.com). There is also an open-source network intrusion detection
                 system from Snort (www.snort.org).
                        Intrusion detection via static analysis attempts to detect when applications
                 have been corrupted by a hacker. The static analysis technique assumes that hack-
                 ers attempt to attack a system using system calls. Under this assumption, the first
                 step in detecting intrusions is to build a model of an application's expected behavior
                 (i.e., a pattern of system calls the application typically generates). The application's
                 pattern of system calls is then monitored as it runs; an attack can be detected if this
                 pattern differs from the static model. 50
                        The OCTAVESM (Operationally Critical Threat, Asset and Vulnerability
                 Evaluation) method, developed at the Software Engineering Institute at Carnegie
                 Mellon University, evaluates a system's security threats. There are three phases in
                 OCTAVE: building threat profiles, identifying vulnerabilities, and developing secu-
                 rity solutions and plans. In the first stage, the organization identifies its important
                 information and assets, then evaluates the levels of security required to protect
                 them. In the second phase, the system is examined for weaknesses that could com-
                 promise the valuable data. The third phase is to develop a security strategy as
                 advised by an analysis team of three to five security experts assigned by OCTAVE.
                 This approach is one of the first of its kind, in which the owners of computer sys-
                 tems not only obtain professional analysis, but also participate in prioritizing the
                 protection of crucial information.51

                 Self Review
                 1. Name a major drawback to IDSs.
                 2. Explain the difference between host-based and network-based IDSs.
                 Ans: 1) IDSs cannot detect intrusion with perfect accuracy. Thus, an IDS may prevent an
                 authorized user from performing a legitimate operation and may enable an intrusion to go
                 undetected. 2) Host-based IDSs monitor the current system's log files. Network-based IDSs
                 monitor packets that travel over a network.


                 19.6.3 Antivirus Software
                 As discussed in Section 19.5.2, viruses and worms have become a menace to busi-
                 nesses and home users alike and have cost businesses billions of dollars.52 The num-
                 ber of reported viruses has increased steadily since the mid-1990s.53 In response,
                 antivirus software has been developed and modified to meet the increasing number
                 and variety of virus attacks on computer systems. Antivirus software attempts to
                 protect a computer from a virus and/or identify and remove viruses on that com-
                 puter. There are a variety of techniques antivirus software may use to detect and
                 remove viruses from a system; however, none can offer complete protection.
                       Signature-scanning virus detection relies on knowledge about the structure of
                 the computer virus's code. For example, many antivirus programs maintain a list of
                 known viruses and their code. All viruses contain a region called the virus signature
                 that does not change as the virus spreads. In practice, most known virus lists main-

<!-- pág. 953 -->

                                                                   19.6 Attack Prevention and Security Solutions 901

tain a list of virus signatures. In this case, virus detection software scans the com-
puter, comparing file data to virus code.
       A weakness of known virus lists is that they could become prohibitively large as
viruses proliferate. The virus list must be updated regularly to successfully identify
emerging viruses. Perhaps the most serious weakness of known virus lists is that they
can recognize only viruses that have been previously identified by the list provider.
Thus, known virus lists generally do not protect against new and unidentified viruses.
       A known virus list can be particularly ineffective against variants and poly-
morphic viruses. A variant is a virus whose code has been modified from its original
form, yet still retains its malicious payload. A polymorphic virus changes its code
(e.g., via encryption, substitution, insertion, and the like) as it spreads, to evade
known virus lists (Fig. 19.8).
       Although virus signatures improve a virus scanner's ability to detect viruses
and their variants, they introduce the possibility of false positive and false negative
virus detection. False positive virus alerts incorrectly indicate that a virus is resident
in a file, whereas false negatives incorrectly determine that an infected file is clean.
These incorrect results become more frequent as the size of a virus signature




Figure 19.8 | Polymorphic virus.

<!-- pág. 954 -->

902   Security

                 becomes smaller. The problem of preventing false positive and false negative read-
                 ings when scanning for viruses is a challenging one, as it has been demonstrated that
                 virus signatures as small as two bytes can be created. 54, 55
                         An alternative to signature scans is heuristic scanning. Viruses are character-
                 ized by replication, residence in memory and/or destructive code. Heuristic scans
                 can prevent the spread of viruses by detecting and suspending any program exhibit-
                 ing this behavior. The primary strength of heuristic scanning is that it can detect
                 viruses that have not yet been identified. Similar to signature scanning, however,
                 heuristic scanning is also susceptible to false reporting. Most antivirus software
                 employs a combination of signature and heuristic scanning.
                         All viruses (with the exception of worms) must modify a file to infect a com-
                 puter. Consequently, another antivirus technique is to monitor changes to files by
                 checking file consistency. Most consistency checks are implemented as checksums of
                 protected files. In a system that experiences a high volume of file I/O, maintaining a
                 record of file consistency is not a viable option if users expect fast response times.
                 Consequently, many antivirus programs ensure file consistency for a limited set of
                 files (typically the operating system files). However, file consistency scans cannot pro-
                 tect against viruses resident on the computer before antivirus software installation.
                 Some operating systems, such as Windows XP, perform consistency checks on vital
                 system files and replace them if they are altered, to protect system integrity.56
                         In addition to scanning techniques, antivirus software can be characterized by
                 its program behavior. For example, real-time scanners are resident in memory and
                 actively prevent viruses, whereas other antivirus software must be loaded manually
                 and serves only to identify viruses. Some antivirus software programs prompt the
                 user for action when a virus is detected, whereas others remove viruses without
                 user interaction. 57

                 Self Review
                 1. Does signature scanning or heuristic scanning provide better protection against new ..
                    unidentified viruses?
                 2. Describe several weaknesses of known virus lists.
                 Ans: 1) Heuristic scanning provides better protection against new and unidentified viruses
                 because it can detect new virus behavior even when its signature is not available. 2) A weak-
                 ness of known virus lists is that they could become prohibitively large as viruses proliferate.
                 The virus list must be updated regularly to successfully identify emerging viruses. Perhaps the
                 most serious weakness of known virus lists is that they can recognize only viruses that have
                 been previously identified by the list provider. Thus, known virus lists generally do not pro-
                 tect against new and unidentified viruses.



                 19.6.4 Security Patches
                 Operating systems and other software often contain security flaws that are not dis-
                 covered until after many users have installed them. To address security flaws in a
                 timely manner, the software developers must:

<!-- pág. 955 -->

                                                                      19.6 Attack Prevention and Security Solutions 903

      • discover previously unknown flaws,
      • quickly release patches for the flaws and
      • establish strong lines of communication with users.
      To reduce the damage caused by security flaws, developers should address
security flaws that have been exploited and actively search and fix those that have
not. A code release that addresses a security flaw is often called a security patch.
      Often, simply releasing a patch for a security flaw is insufficient to improve
security. For example, the Slammer worm (Section 19.5.2, Viruses and Worms)
exploited a security flaw for which a patch had been released six months earlier.
Thus software developers should address security flaws by notifying their users
quickly and providing software that facilitates the process of applying security
patches.
      OpenBSD is a BSD UNIX project whose primary goal is to create the most
secure (UNIX-compatible) operating system (see the Mini Case Study, OpenBSD).
The project includes an audit team that continuously searches for security flaws, a
lull-disclosure policy that describes each security flaw in a public forum and a team
that releases security patches quickly. Users must subscribe to a mailing list or visit
a Web page to learn of new security flaws and download patches. 58 Both the Open-
BSD and Apple MacOS X operating systems close all ports and disable all network
services by default to improve security (see the Mini Case Study, Macintosh).
      Microsoft's Trustworthy Computing Initiative has resulted in a steady stream
of security patches, called hotfixes, for the Windows line of operating systems.
Microsoft offers free software called Automatic Updates that executes in the back-
ground of a Windows system to periodically determine if new hotfixes are available.
If the Automatic Updates determines that a "critical update" such as a security
patch is available, it will display a dialog to prompt the user to download and install
the hotfix.59 This software also enables critical updates to be installed without user
interaction, which can improve system security.


Self Review
1. Why is it important to establish strong lines of communication between software develop-
   ers and users when releasing security patches?
2. Why is it insufficient to address security flaws only after they are exploited?
Ans: 1) Software developers should address security flaws by notifying their users quickly
and providing software that facilitates the process of applying security patches, so that users
can protect themselves against known security flaws. 2) Some exploit actions of security flaws
not detected by developers and could compromise system security and go undetected for
days, months or even years.


19.6.5 Secure File Systems
Access to system resources, including data stored in a file system, can be regulated by
the operating system's access control policy. However, such mechanisms do not nec-

<!-- pág. 956 -->

904     Security

                                    essarily prevent access to data stored on the hard drive when it is accessed by a differ-
                                    ent operating system. Consequently, several of today's operating systems support
                                    secure file systems that protect sensitive data regardless of how the data is accessed.
                                    Windows XP employs the New Technology File System (NTFS), which protects files
                                    via access control and encryption (see Section 21.8, File Systems Management).
                                           The Encrypting File System (EFS) uses cryptography to protect files and fold-
                                    ers in an NTFS file system. EFS uses secret-key and public-key encryption to secure
                                    files.60 Each user is assigned a key pair and certificate that are used to ensure that
                                    only the user who encrypted the files can access them. File data is lost if the key is
                                    lost. EFS is often implemented in multiuser or mobile systems to ensure that pro-
                                    tected files would not be accessible to somebody using a stolen or lost machine.




                     Mini Case Study
      OpenBSD
      Theo de Raadt, an original mem-          Any found bugs are posted imme-         (to prevent network attacks). 74, 75
      ber of the NetBSD project, left          diately to the OpenBSD project          It is interesting to note that Win-
      NetBSD in 1995 to start the Open-        site and are generally fixed in less    dows Server 2003 follows the
      BSD project using the open-source        thanaday.68,69,70,71                    same philosophy—a complete
      NetBSD source code as a base.61, 62             OpenBSD includes several         reversal from Microsoft's policy in
      OpenBSD is considered by many            security features, such as built-in     Windows 2000—to enhance secu-
      to be the most secure OS                 support for OpenSSH and OpenSSL         rity in environments managed by
      available. 63, 64, 65 It has been more   (open-source implementations of         inexperienced administrators. 76
      than four years (as of the time this     the SSH and SSL security proto-                To maintain its secure core,
      book was published) since Open-          cols).72 OpenBSD was also the first     OpenBSD provides a limited set of
      BSD has been cracked while run-          operating system to implement           applications, though the Open-
      ning with default settings. 66, 67       IPsec, the IP Security protocol         BSD team claims it can run pro-
            OpenBSD's extraordinary            widely used in Virtual Private Net-     grams written for any of the
      level of security has been               works (VPNs), discussed in              major UNIX-based systems.77
      achieved primarily by the core           Section 19.10.2. It also includes the   There is no GUI, making this sys-
      team's code-auditing process.            network authentication protocol         tem an unlikely option for most
      Every source file in the system has      Kerberos version five. 73               desktop users but suitable for
      been analyzed several times by                 The OpenBSD group                 servers, which must be secure and
      various developers on the core           (www.openbsd.org) ensures that          generally have little direct inter-
      project team—an ongoing pro-             its operating system is secure          action with users.78
      cess. These audits check for bugs        upon installation by shipping
      such as classic security holes like      OpenBSD w i t h only minimal ser-
      buffer overflow opportunities.           vices enabled and all ports closed

<!-- pág. 957 -->

                                                                  19.6 Attack Prevention and Security Solutions 905

       Encryption can be applied to individual files or entire folders; in the latter case,
every file inside the folder is encrypted. Applying encryption at the folder level often
achieves a higher level of security by preventing programs from creating temporary
tiles in plaintext. File encryption in Linux is discussed in Section 20.7, File Systems.




                 Mini Case Study
 Machintosh
  In the late 1970s, Apple Computer         all of which worked using a              multiprogramming was added in
  was working on t w o new comput-          mouse. The Lisa and Macintosh            System 4 and virtual memory was
  ers: the Lisa, a high-end personal        systems were the first personal          introduced in System 7 which was
  computer, and the Macintosh, a            computers on the market to               released in 1990.89 In 1997, after
  more affordable personal                  include a mouse. 83 The Lisa             numerous bug fixes and applica-
  computer. 79, 80, 81 In 1979, Apple       debuted in 1983, but it cost ten         tion upgrades, version 7.6 was
  cofounder Steve Jobs (now CEO of          thousand dollars and was not suc-        released and the operating sys-
  Apple) visited Xerox's Palo Alto          cessful; Apple discontinued the          tem was renamed Mac OS. 9 0 ' 9 1
  Research Center (PARC).82 During          model t w o years later.84 The Mac-            Mac OS was completely
  his visit, Jobs saw a demo of the         intosh was announced in 1984             rebuilt in 2001 for Mac OS X, w i t h
  Alto—a personal computer that             with a famous commercial based           the new Darwin kernel incorpo-
  used a graphical user interface           on George Orwell's "1984," 8 5           rating the Mach 3 microkernel
  (GUI) and a computer mouse. The           which debuted during the Super           and BSD UNIX.92 Darwin is a com-
  Alto, developed at PARC in the            Bowl. The Macintosh, which was           plete UNIX environment including
  1970s, was designed for personal          more space efficient and afford-         the X11 windows system as an
  use, however it was too large and         able than the Lisa (it sold for          option. 9 3 Apple also made Darwin
  expensive to be practical, there-         $2,495), became extraordinarily          an open-source project to make it
  fore it was never sold.                   successful.86, 87                        more robust and stable. 94 Mac OS
         Inspired by the Alto, Jobs               The first Macintosh operat-        X has followed OpenBSD's (dis-
  incorporated GUIs and the com-            ing system was System 1.                 cussed in the OpenBSD mini case
  puter mouse into both the Apple           Although it had GUI capabilities,        study) lead, improving security by
  Lisa and Macintosh operating sys-         it was a fairly rudimentary operat-      shipping w i t h all ports closed and
  tems. The Apple GUIs included             ing system—it had no virtual             all network services disabled. 95
  some features similar to those of         memory, did not support multi-           Apple also made Mac OS X com-
  the Alto, plus many original fea-         programming and had a single-            patible w i t h the Windows file for-
  tures including drag-and-drop             level file system.88 These features      mats and Windows Exchange mail
  file-icon movement, pull-down             were updated in later versions; a        servers, making it easy for Mac OS
  menus and windows that redraw             hierarchical file structure was          X users to integrate into a busi-
  automatically when uncovered—             implemented in System 3, basic           ness environment. 96

<!-- pág. 958 -->

906   Security

                 Self Review
                 1. When are access control mechanisms insufficient to protect file data?
                 2. What is the primary risk of implementing an encrypted file system?
                 Ans: 1) Access control mechanisms are insufficient to protect file data when the storage
                 device is removed from the computer, because it can be accessed by a system that bypasses the
                 existing access control mechanisms. 2) File data is unrecoverable if the encryption key is lost.


                 19.6.6 Orange Book Security
                 To evaluate the security features of operating systems, the U.S. Department of
                 Defense (DoD) published a document entitled "Department of Defense Trusted
                 Computer System Evaluation Criteria," also called the Orange Book, in December
                 1985.97' 98 This document is still used to define levies of security in operating sys-
                 tems. The Orange Book, originally designed for evaluating military systems, classi-
                 ties systems into four levels of security protection —A, B, C and D. The lowest level
                 of security is D and the highest is A. The requirements for each level follow.99, 100
                        • Level D: Any system that does not meet all the requirements in any other
                          levels. Systems categorized as level D are generally unsecure.
                        • Level C:This level contains two sublevels. Level C1 requires the operating
                          system to separate users and data, which means individuals or groups must
                          log in a username or group name and password to use the system. Private
                          information belonging to an individual or a group is secured to prevent
                          other individuals and groups from reading or modifying it. Early versions
                          of UNIX belong to this level. Level C2 supports only individual login with
                          password, which means users cannot log in with a group name. Authorized
                          individuals can access only certain files and programs. Both C1 and C2
                          allow individuals to control the access to their files and private information,
                          which means they require only discretionary access control. Most operating
                          systems, such as Windows NT, modern UNIX systems and IBM OS/400101
                          fall into this category.
                        • Level B: In this level, mandatory access control is required, which means
                          the operating system requires a predefined central permission scheme to
                          determine the permissions assigned to subjects. The creator of an object
                          does not control the permissions for that object. This level contains three
                          sublevels. In addition to the requirements of C2, Bl requires the operating
                          system to contain a predefined central permission scheme and apply sensi-
                          tivity labels (e.g., "Confidential") on subjects and objects. The access con-
                          trol mechanism must use these sensitivity labels to determine permissions.
                          Operating systems that satisfy Bl requirements include HP-UX BLS 102 ,
                          SEVMS 103 and CS/SX104. B2 requires the communication line between the
                          user and the operating system for authentication to be secure, in addition
                          to the requirements from Bl. Operating systems that satisfy B2 require-
                          ments include Multics105 and VSLAN 106 . B3 requires all the features
                          present in B2, in addition to implementing protection domains, providing

<!-- pág. 959 -->

                                                                                          19.7 Secure Communication 907
         secure recovery mechanisms (recovery without compromising protection
         after a system failure) and monitoring all access to subjects and objects for
         analysis. The XTS-300 operating system107 satisfies B3 requirements.
      • Level A: This level contains two sublevels. A1 requires all the features pro-
        vided by B3, and it requires that the operating system's security is formally
        verified. An example of an operating system that satisfies the Af require-
        ments is the Boeing MLS LAN 108 . The requirements for A2 are reserved
        for future use.

Self Review
1. Does a system that belongs to category C2 need to satisfy the requirements for level B?
2. How does C2 differ from C1?
Ans: 1) No. Level B is higher than level C2, hence level B has more features and require-
ments. 2) C1 supports both individual and group logins while C2 supports only individual login.



19.7 Secure Communication
E-business has profited from the rapidly rising number of consumers that own com-
puters with Internet connections. However, as the number of online transactions
increases, so does the volume of sensitive data transmitted over the Internet. Appli-
cations that process transactions require secure connections through which sensi-
tive data can be transmitted. Several methods for providing secure transactions
have been developed in recent years. In the sections that follow, we describe some
 of these techniques.
      There are five fundamental requirements for a successful, secure transaction:
      • privacy
      • integrity
      • authentication
      • authorization
      • nonrepudiation
 The privacy issue is: How do you ensure that the information you transmit over the
Internet has not been captured or passed to a third party without your knowledge?
 The integrity issue is: How do you ensure that the information you send or receive
has not been compromised or altered? The authentication issue is: How do the
sender and receiver of a message verify their identities to each other? The authori-
zation issue is: How do you manage access to protected resources on the basis of
user credentials, which consists of user's identity (e.g., username) and proof of iden-
tify (e.g., password)? The nonrepudiation issue is: How do you legally prove that a
message was sent or received? Network security must also address the issue of
availability: How do we ensure that the network, and the computer systems to
which it connects, will operate continuously? In the sections that follow, we discuss

<!-- pág. 960 -->

908 Security
               several implementations of secure communication that derive from encryption
               techniques discussed in Section 19.2.

               Self Review
               1. For which of the five fundamental requirements for a successful, secure transaction would
                  encryption be useful?
               2. Which of the five fundamental requirements deal with user login?
               Ans: 1) Encryption is useful for all five of the fundamental requirements for a successful,
               secure transaction. 2) Authorization and authentication.


               19.8 Key Agreement Protocols
               Although public-key algorithms offer flexible and reliable security, they are not effi-
               cient for sending large amounts of data. Therefore, public-key algorithms should
               not be considered replacements for secret-key algorithms. Instead, public-key algo-
               rithms are most often employed to exchange secret keys securely. The process by
               which two parties can exchange keys over an unsecure medium is called a key
               agreement protocol.
                     The most common key agreement protocol is a digital envelope (Fig. 19.9).
               The message is encrypted using a secret key (Step 1), and the secret key is then
               encrypted using public-key encryption (Step 2). The sender attaches the encrypted
               secret key to the encrypted message and sends the receiver the entire package, or
               envelope. The sender could also digitally sign the envelope before sending it to
               prove the sender's identity to the receiver (covered in Section 19.8.2, Digital Signa-
               tures). To decrypt the envelope, the receiver first decrypts the secret key using the
               receiver's private key. Then, the receiver uses the secret key to decrypt the actual
               message. Because only the receiver can decrypt the encrypted secret key, the sender
               can be sure that only the intended receiver can read the message.

               Self Review
               1. Why are public-key algorithms employed to exchange secret keys?
               2. In the digital envelope protocol, why is it inappropriate to encrypt the entire message
                  using public-key encryption?
               Ans: 1) Public-key algorithms are efficient for sending small amounts of data, and they pre-
               vent attackers from obtaining the secret key while it is transmitted. 2) Public-key encryption is
               not efficient for sending large amounts of data because it requires significant processing power.


               19.8.1 Key Management
               Maintaining the secrecy of private keys is essential to the maintenance of crypto-
               graphic system security. Most security breaches result from poor key management
               (e.g., the mishandling of private keys, resulting in key theft) rather than cryptana-
               lytic attacks.109

<!-- pág. 961 -->

                                                                                         19.8 Key Agreement Protocols 909




Figure 19.9 | Creating a digital envelope.


      An important aspect of key management is key generation —the process by
which keys are created. A malicious third party could try to decrypt a message by
using every possible decryption key. Key-generation algorithms are sometimes
unintentionally constructed to choose from only a small subset of possible keys. If
the subset is too small, then the encrypted data is more susceptible to brute-force
attacks. Therefore, it is important to use a key-generation program that can gener-
ate a large number of keys as randomly as possible. Key security is improved when
key length is large enough that brute-force cracking is computationally infeasible.

Self Review
1. Why is it important to use a long key length?
2. Why are most security breaches due to poor key management rather than cryptanalytic
   attack?
Ans: 1) If the total number of decryption keys is small, malicious third parties could gener-
ate all possible decryption keys quickly to break the encryption. 2) When long key lengths
are used, it is easier to take advantage of poor key management to steal private keys than it is
to use a brute-force method such as a cryptanalytic attack.

<!-- pág. 962 -->

910   Security

                 19.8.2 Digital Signatures
                 Digital signatures, the electronic equivalents of written signatures, were developed
                 to address the absence of authentication and integrity in public-key cryptography.
                 A digital signature authenticates the sender's identity and is difficult to forge.
                        To create a digital signature, a sender first applies a hash function to the origi-
                 nal plaintext message. Hash functions for secure applications are also typically
                 designed such that it is computationally infeasible to compute a message from its
                 hash value or to generate two messages with the same hash value. A secure hash
                 algorithm is designed so that the probability that two different messages will pro-
                 duce the same message digest is statistically insignificant.
                        In digital signatures, the hash value uniquely identifies a message. If a mali-
                 cious party changes the message, the hash value also changes, thus enabling the
                 recipient to detect that the message has been altered. Two widely used hashing
                 functions are the Secure Hash Algorithm (SHA-1), developed by National Institute
                 of Standards and Technology (NIST), and the MD5 Message Digest Algorithm.
                 developed by Professor Ronald L. Rivest at MIT. Using SHA-f, the phrase "Buy
                 100 shares of company X" would produce the hash value D8A9 B6 9F 72 65 OB D5
                 6D OC 47 00 95 OD FD 31 96 OA FD B5. The hash value is called the message digest.
                        Next, the sender uses the sender's private key to encrypt the message digest.
                 This step creates a digital signature and validates the sender's identity, because only
                 the owner of that private key could encrypt the message. A message that includes the
                 digital signature, hash function and the encrypted message is sent to the receiver. The
                 receiver uses the sender's public key to decipher the digital signature (this establishes
                 the message's authenticity) and reveal the message digest. The receiver then uses his
                 or her own private key to decipher the original message. Finally, the receiver applies
                 the hash function to the original message. If the hash value of the original message
                 matches the message digest included in the signature, the message integrity is con-
                 firmed—the message has not been altered in transmission.
                        Digital signatures are significantly more secure than handwritten signatures. A
                 digital signature is based upon the contents of the document, so a digital signature
                 (contrary to a handwritten signature) is different for each document signed.
                        Digital signatures do not provide proof that a message has been sent. Con-
                 sider the following situation: A contractor sends a company a digitally signed con-
                 tract, which the contractor later would like to revoke. The contractor could do so by
                 releasing the private key, then claiming that the digitally signed contract was gener-
                 ated by an intruder who stole the contractor's private key. Time stamping, which
                 binds a time and date to a digital document, can help solve the problem of nonrepu-
                 diation. For example, suppose the company and the contractor are negotiating a
                 contract. The company requires the contractor to sign the contract digitally and
                 then have the document digitally time stamped by a third party, called a time-
                 stamping agency or a digital notary service.
                        The contractor sends the digitally signed contract to the time-stamping agency.
                 The privacy of the message is maintained, because the time-stamping agency sees

<!-- pág. 963 -->

                                            19.9 Public-Key Infrastructure, Certificates and Certificate Authorities 911

only the encrypted, digitally signed message. The agency affixes the time and date of
receipt to the encrypted, signed message and digitally signs the entire package with
the time-stamping agency's private key. The time-stamp cannot be altered by anyone
except the time-stamping agency, because no one else possesses the agency's private
key. Unless the contractor reports that the private key was compromised before the
document was time stamped, the contractor cannot legally prove that the document
was signed by an unauthorized third party. The sender could also require the receiver
to sign the message digitally and time stamp it as proof of receipt. To learn more
about time-stamping, visit www.authentidate.com.
      The U.S. government's digital authentication standard is called the Digital Sig-
nature Algorithm (DSA). Legislation passed in June of 2000 allows digital signa-
tures to be as legally binding as handwritten signatures, which has facilitated many
e-business transactions. For the latest news about U.S. government legislation in
information security, visit www.itaa.org/infosec.

Self Review
1. If digital signatures do not create a message digest, can a malicious third party modify a
   message's ciphertext?
2. When interpreting messages that are digitally signed, what is the difference between
   authenticating a message and verifying its integrity?
Ans: 1) Although it is possible to modify the ciphertext, it is unlikely that the third party
will be able to modify the message in any meaningful way without knowledge of the encryp-
tion key. 2) To authenticate a message, the receiver uses the sender's public key to decipher
the digital signature. To verify a message's integrity, the receiver checks the hash value of the
 original message with the message digest included in the signature.


19.9 Public-Key Infrastructure, Certificates and Certificate
Authorities
A limitation of public-key cryptography is that multiple users might share the same
set of keys, making it difficult to establish each party's identity. For example, sup-
pose a customer wishes to place an order with an online merchant. How does the
customer know that the Web site being viewed was created by that merchant and
not by a third party masquerading as a merchant to steal credit card information?
Public Key Infrastructure (PKI) provides a solution to such a problem by integrat-
ing public-key cryptography with digital certificates and certificate authorities to
authenticate parties in a transaction.
      A digital certificate is a digital document that identifies a user and is issued by
a certificate authority (CA). A digital certificate includes the name of the subject
(the company or individual being certified), the subject's public key, a serial number
(which uniquely identifies the certificate), an expiration date, the signature of the
trusted certificate authority and any other relevant information. A CA can be a
financial institution or any other trusted third party, such as VeriSign. Once issued,
the CA makes the digital certificates publicly available in certificate repositories.

<!-- pág. 964 -->

912 Security
                      The CA signs the certificate by encrypting either the subject's public key or a
               hash value of the public key using the CA's own private key, so that a recipient can
               verify the certificate. The CA must verify every subject's public key. Thus, users
               must trust the public key of a CA. Usually, each CA is part of a certificate authority
               hierarchy. This hierarchy can be viewed as a tree structure in which each node relies
               on its parent for authentication information. The root of the certificate authority
               hierarchy is the Internet Policy Registration Authority (IPRA). The IPRA signs
               certificates using the root key, which signs certificates exclusively for policy creation
               authorities —organizations that set policies for obtaining digital certificates. In turn,
               policy creation authorities sign digital certificates for CAs. CAs then sign digital
               certificates for individuals and organizations.
                      The CA is responsible for authentication, so it must check user information
               carefully before issuing a digital certificate. In one case, human error caused Veri-
               sign to issue two digital certificates to an imposter posing as a Microsoft
               employee. 110 Such an error can be significant; for example, the inappropriately
               issued certificates can cause users to download malicious code unknowingly onto
               their machines. VeriSign, Inc., is a leading certificate authority (www.veri-
               si gn. com); other digital certificate vendors are listed in the Web Resources section
               at the end of the chapter.
                      Digital certificates are created with an expiration date to force users to refresh
               key pairs periodically. If a private key is compromised before its expiration date,
               the digital certificate can be cancelled, and the user can obtain a new key pair and
               digital certificate. Cancelled and revoked certificates are placed on a certificate
               revocation list (CRL), which is maintained by the certificate authority that issued
               the certificates.
                      CRLs are analogous to the paper lists of revoked credit card numbers formerly
               used at the points of sale in retail stores.111 This can substantially lengthen the process
               of determining the validity of a certificate. An alternative to CRLs is the Online Cer-
               tificate Status Protocol (OCSP), which validates certificates in real time.112
                      Many still consider e-commerce unsecure. However, transactions using PKI
               and digital certificates can be more secure than exchanging private information
               over public, unencrypted media such as voice phone lines, paying through the mail,
               or handing a credit card to a sales clerk. In contrast, the key algorithms used in most
               secure online transactions are nearly impossible to compromise. By some estimates,
               the key algorithms used in public-key cryptography are so secure that even millions
               of today's computers working in parallel could not break the codes after a century
               of dedicated computation. However, as computing power increases, key algorithms
               considered strong today could be easily compromised in the future.


               Self Review
               1. Describe how CAs ensure the security of their certificates.
               2. Why are electronic transactions secured by PKI and digital certificates often more secure
                  than those conducted over the phone or in person?

<!-- pág. 965 -->

                                                                                19.10 Secure Communication Protocols 913

Ans: 1) Each CA is part of a certificate authority hierarchy. This hierarchy can be viewed as
a tree structure in which each node relies on its parent for authentication information. Its
root is the Internet Policy Registration Authority (IPRA), which signs certificates for policy
creation authorities. Policy creation authorities sign digital certificates for CAs. CAs then sign
digital certificates for individuals and organizations. 2) The reason is that it is computation-
ally infeasible to compromise the key algorithms used in most secure online transactions. By
some estimates, the key algorithms used in public-key cryptography are so secure that even
millions of today's computers working in parallel could not break the codes after a century of
dedicated computation. By comparison, it is far easier to tap a phone line or write down an
individual's credit card number during an in-person transaction.


19.10 Secure Communication Protocols
Secure communication protocols have been developed for several layers of the tra-
ditional TCP/IP stack. In this section we discuss Secure Sockets Layer (SSL) and
Internet Protocol Security (IPSec). We also discuss the protocols that are com-
monly used to implement secure wireless communication.

19.10.1 Secure Sockets Layer (SSL)
The Secure Sockets Layer (SSL) protocol, developed by Netscape Communica-
tions, is a nonproprietary protocol that secures communication between two com-
puters on the Internet and the Web. 113 Many e-businesses use SSL for secure online
transactions. Support for SSL is included in many Web browsers, such as Mozilla (a
stand-alone browser that has been integrated into Netscape Navigator), Microsoft's
Internet Explorer and other software products. It operates between the Internet's
TCP/IP communications protocol and the application software.114
       During typical Internet communication, a process sends and receives mes-
sages via a socket. Although TCP guarantees that messages are delivered, it does
not determine whether packets have been maliciously altered during transmission.
For example, an attacker can change a packet's source and destination addresses
without being detected, so fraudulent packets can be disguised as valid ones.115
       SSL implements public-key cryptography using the RSA algorithm and digital
certificates to authenticate the server in a transaction and to protect private infor-
mation as it passes over the Internet. SSL transactions do not require client authen-
tication; many servers consider a valid credit card number to be sufficient for
authentication in secure purchases. To begin, a client sends a message to a server to
open a socket. The server responds and sends its digital certificate to the client for
authentication. Using public-key cryptography to communicate securely, the client
and server negotiate session keys to continue the transaction. Session keys are
secret keys that are used for the duration of that transaction. Once the keys are
established, the communication is secured and authenticated using the session keys
and digital certificates.
      Before sending a message over TCP/IP, the SSL protocol breaks the informa-
tion into blocks, each of which is compressed and encrypted. When the receiver
obtains the data through TCP/IP, SSL decrypts the packets, then decompresses and

<!-- pág. 966 -->

914 Security

               assembles the data. SSL is used primarily to secure point-to-point connections —
               interactions between exactly two computers. 116 SSL can authenticate the server, the
               client, both or neither. However, in most e-business SSL sessions, only the server is
               authenticated.
                     The Transport Layer Security (TLS) protocol, designed by the Internet Engi-
               neering Task Force (IETF), is the successor to SSL. Conceptually, SSL and TLS are
               nearly identical—they authenticate using symmetric keys and encrypt data with pri-
               vate keys. The difference between the two protocols is in the implementation of the
               algorithm and structure of TLS packets.117
                     Although SSL protects information as it is passed over the Internet, it does
               not protect private information, such as credit card numbers, once the information
               is stored on the merchant's server. Credit card information may be decrypted and
               stored in plaintext on the merchant's server until the order is placed. If the server's
               security is breached, an unauthorized party can access the information.

               Self Review
               1. Why do many transactions via SSL authenticate only the server?
               2. Why is information compressed before encryption under SSL?
               Ans: 1) The reason is that many servers consider a valid credit card number to be sufficient
               for authentication in secure purchases. 2) One reason is that compressed data consumes less
               space, thus requiring less time to transmit over the Internet. Another reason is that compres-
               sion makes it more difficult for an attacker to interpret the unencrypted message, which pro-
               vides greater protection against a cryptanalytic attack.


               19.10.2 Virtual Private Network (VPMs) and IP Security (IPSec)
               Most home or office networks are private—computers in the network are con-
               nected via communication lines not intended for public use. Organizations can also
               use the existing infrastructure of the Internet to create Virtual Private Networks
               (VPNs), which provide secure communication channels over public connections.
               Because VPNs use the existing Internet infrastructure, they are more economical
               than wide-area private networks. 118 Encryption enables VPNs to provide the same
               services and security as private networks.
                      A VPN is created by establishing a secure communication channel, called a tun-
               nel, through which data passes over the Internet. Internet Protocol Security (IPSec)
               is commonly used to implement a secure tunnel by providing data privacy, integrity
               and authentication.119 IPSec, developed by the IETF, uses public-key and symmetric-
               key cryptography to ensure data integrity, authentication and confidentiality.
                     The technology builds upon the Internet Protocol (IP) standard, whose pri-
               mary security weakness is that IP packets can be intercepted, modified and retrans-
               mitted without detection. Unauthorized users can access the network by using a
               number of well-known techniques, such as IP spoofing—whereby an attacker simu-
               lates the IP address of an authorized user or host to obtain unauthorized access to
               resources. Unlike the SSL protocol, which enables secure, point-to-point connec-

<!-- pág. 967 -->

                                                                           19.10 Secure Communication Protocols 915

tions between two applications, IPSec secures connections among all users of the
network on which it is implemented.
      The Diffie-Hellman and RSA algorithms are commonly used for key exchange
in the IPSec protocol, and DES or 3DES are used for secret-key encryption, depend-
ing on the system and its encryption needs. [Note: The Diffie-Hellman encryption
algorithm is a public-key algorithm.]120 IPSec encrypts packet data, called a payload,
then places it in an unencrypted IP packet to establish the tunnel. The receiver dis-
cards the IP packet header, then decrypts the payload to access the packet's con-
tent.121
      VPN security relies on three concepts—user authentication, data encryption
and controlled access to the tunnel. 122 To address these three security issues, IPSec
is composed of three components. The authentication header (AH) attaches infor-
mation (such as a checksum) to each packet to verify the identity of the sender and
prove that data was not modified in transit. The encapsulating security payload
(ESP) encrypts the data using symmetric keys to protect it from eavesdroppers
while the IP packet is transmitted across public communication lines. IPSec uses the
Internet Key Exchange (IKE) protocol to perform key management, which allows
secure key exchange.
      VPNs are becoming increasingly popular in businesses, but remain difficult to
manage. The network layer (i.e., IP) is typically managed by the operating system or
hardware, not user applications. So, it can be difficult to establish a VPN because
network users must install the proper software or hardware to support IPSec. For
more information about IPSec, visit the IPSec Developers Forum at www.ip-
sec.com and the IETF's IPSec Working Group at w w w . i e t f . o r g / h t m l . c h a r -
ters/ipsec-charter.html.

Self Review
1. Why do companies often choose VPNs over private WANs?
2. Why must the encrypted IP packet be sent inside an unencrypted IP packet?
Ans: 1) Because VPNs use the existing infrastructure of the Internet, VPNs are much more
economical than WANs. 2) Existing routers must be able to forward the packet. If the entire
IP packet were encrypted, routers could not determine its destination.


19.10.3    Wireless    Security
As wireless devices become increasingly popular, transactions such as stock trading
and online banking are commonly transmitted wirelessly. Unlike wired transmis-
sions, which require a third party to physically tap into a network, wireless transmis-
sions enable virtually anyone to access transmitted data. Because wireless devices
exhibit limited bandwidth and processing power, high latency and unstable connec-
tions, establishing secure wireless communication can be challenging.123
      The IEEE 802.11 standard, which defines specifications for wireless LANs,
uses the Wired Equivalent Privacy (WEP) protocol to protect wireless communica-
tion. WEP provides security by encrypting transmitted data and preventing unau-

<!-- pág. 968 -->

916 Security

               thorized access to the wireless network. To transmit a message, WEP first appends a
               checksum to the message to enable the receiver to verify message integrity. It then
               applies the RC4 encryption algorithm, which takes two arguments —a 40-bit secret
               key (shared between the sender and the receiver) and a random 24-bit value (called
               the initialization value) —and returns a keystream (a string of bytes). Finally, WEP
               encodes the message by XORing the keystream and the plain text. Each WEP
               packet contains the encrypted message and the unencrypted initialization value.
               Upon receiving a packet, the receiver extracts the initialization value. The receiver
               then uses the initialization value and the shared secret key to generate the key-
               stream. Finally, it decodes the message by XORing the keystream and the
               encrypted message. To determine whether the contents of the packet have been
               modified, the receiver can calculate the checksum and compare it with the check-
               sum appended to the message.124
                     The security provided by the WEP protocol is inadequate for many environ-
               ments. For one, the 24-bit initialization value is small, causing WEP to use the same
               keystream to encode different messages, which can allow a third party to recover
               plaintext relatively easily. WEP also exhibits poor key management —the secret key
               can be cracked by brute-force attacks within hours using a personal computer. Most
               WEP-enabled wireless networks share a single secret key between every client on
               the network, and the secret key is often used for months and even years. Finally, the
               checksum computation uses simple arithmetic, enabling attackers to change both
               the message body and the checksum with relative ease.125, 126
                     To address these issues, the IEEE and the Wi-Fi Alliance (www.weca.net/
               OpenSection/index.asp) developed a specification called Wi-Fi Protected Access
               (WPA) in 2003. WPA is expected to replace WEP by providing improved data
               encryption and by enabling user authentication, a feature not supported by WEP
               WPA also introduces dynamic key encryption, which generates a unique encryption
               key for each client. Authentication is achieved via an authentication server that
               stores user credentials.127
                     Both WEP and WAP are designed for communication using the 802.11 wire-
               less standard. Other wireless technologies —such as Cellular Digital Packet Data
               (CDPD) for cell phones, PDAs and pagers, Third Generation Global System for
               Mobile Communications (3GSM) for 3GSM-enabled cell phones, PDAs and pag-
               ers, and Time Division Multiple Access (TDMA) for TDMA cell phones —define
               their own (often proprietary) wireless communication and security protocols.128


               Self Review
               1. What properties of wireless devices introduce challenges when implementing secure wire-
                  less communication?
               2. How does WPA address the poor key management in WEP?
               Ans: 1) Limited bandwidth, limited processing power, high latency and unstable connec-
               tions. 2) WPA introduces dynamic key encryption, which generates a unique encryption key
               for each client.

<!-- pág. 969 -->

                                                                                                  19.11 Steganography 917

19.11 Steganography
Steganography is the practice of hiding information within other information,
derived from Greek roots meaning "covered writing." Like cryptography, steganog-
raphy has been used since ancient times. Steganography can be used to hide a piece
of information, such as a message or image, within another image, message or other
form of multimedia.
      Consider a simple textual example: Suppose a stock broker's client wishes to
perform a transaction via communication over an unsecure channel. The client
might send the message "BURIED UNDER YARD." If the client and broker
agreed in advance that the message is contained in the first letters of each word, the
stock broker extracts the message, "BUY."
      An increasingly popular application of steganography is digital watermarks for
intellectual property protection. Digital steganography exploits unused portions of
files encoded using particular formats, such as in images or on removable disks. The
insignificant space stores the hidden message, while the digital file maintains its
intended semantics.129 A digital watermark can be either visible or invisible. It is usu-
ally a company logo, copyright notification or other mark or message that indicates
the owner of the document. The owner of a document could show the hidden water-
mark in a court of law, for example, to prove that the watermarked item was stolen.
      Digital watermarking could have a substantial impact on e-commerce. Con-
sider the music industry. Music and motion picture distributors are concerned that
MP3 (compressed audio) and MPEG-4 (compressed video) technologies facilitate
the illegal distribution of copyrighted material. Consequently, many publishers are
hesitant to publish content online, as digital content is easy to copy. Also, because
CD- and DVD-ROMs store digital information, users are able to copy multimedia
files and share them via the Web. Using digital watermarks, music publishers can
make indistinguishable changes to a part of a song at a frequency that is not audible
to humans, to show that the song was, in fact, copied.
      Blue Spike's Giovanni™ digital watermarking software uses cryptographic
keys to generate and embed steganographic digital watermarks into digital music
and images (www.bluespike.com). The watermarks are placed randomly and are
undetectable without knowledge of the embedding scheme; thus, they are difficult
to identify and remove.


Self Review
1. Compare and contrast steganography and cryptography.
2. In grayscale bitmap images, each pixel can be represented by a number between 0 and
   255. The number represents a certain shade of gray between 0 (black) and 255 (white).
   Describe a possible steganography scheme, and explain why it works.
Ans: 1) Steganography and cryptography are similar because they both involve sending a
message privately. However, with steganography, third parties are unaware that a secret mes-
sage has been sent, though the message is typically in plaintext. With cryptography, third par-
ties are aware that a secret message is sent, but they cannot decipher the message easily. 2) A

<!-- pág. 970 -->

918 Security
               secret message can be encoded by replacing each of the least significant bits of the picture
               with one bit of the message. This would not affect the picture much, because each pixel would
               become at most one shade lighter or darker. In fact, it would be undetectable by most third
               parties that the picture contained a hidden message.



               19.12 Proprietary and Open-Source Security
               When comparing the merits of open-source and proprietary software, security is an
               important concern. Supporters of open-source security claim that proprietary solu-
               tions rely on security through obscurity. Proprietary solutions assume that because
               attackers cannot analyze the source code for security flaws, fewer security attacks
               are possible.
                      Supporters of open-source security claim that proprietary security applica-
               tions limit the number of collaborative users that can search for security flaws and
               contribute to the overall security of the application. If the public cannot review the
               software's source code, certain bugs that are overlooked by developers can be
               exploited. Developers of proprietary software argue that their software has been
               suitably tested by their security experts.
                      Open-source security supporters also warn that proprietary security develop-
               ers are reluctant to publicly disclose security flaws, even when accompanied by
               appropriate patches, for fear that public disclosure would damage the company's
               reputation. This may discourage vendors from releasing security patches, thereby
               reducing their product's security.
                      A primary advantage to open-source applications is interoperability—open-
               source software tends to implement standards and protocols that many other devel-
               opers can easily include in their products. Because users can modify the source,
               they can customize the level of security in their applications. Thus, an administrator
               can customize the operating system to include the most secure access control policy
               file system, communication protocol and shell. By contrast, users of proprietary
               software often are limited to the features provided by the vendor, or must pay addi-
               tional fees to integrate other features.
                      Another advantage to open-source security is that the application source code
               is available for extensive testing and debugging by the community at large. For exam-
               ple, the Apache Web server is an open-source application that survived four and half
               years without a serious vulnerability—an almost unrivaled feat in the field of com-
               puter security.130-131 Open-source solutions can provide code that is provably secure
               before deployment. Proprietary solutions rely on an impressive security track record
               or recommendations from a small panel of experts to vouch for their security.
                     The primary limitation of security in open-source applications is that open-
               source software is often distributed without standard default security settings,
               which can increase the likelihood that security will be compromised due to human
               error, such as inexperience or negligence. For example, several Linux distributions
               enable many network services by default, exposing the computer to external
               attacks. Such services require significant customization and modification to prevent

<!-- pág. 971 -->

                                                                         19.13 Case Study: UNIX Systems Security   919

skilled attackers from compromising the system. Proprietary systems, on the other
hand, typically are installed with an appropriate security configuration by default.
Unlike most UNIX-based distributions, the open-source OpenBSD operating sys-
tem claims to install fully secured against external attacks by default. As any user
will soon realize, however, significant configuration is required to enable all but the
most basic of communication services.
      It is important to note that proprietary systems can be as secure as open-
source systems, despite opposition from the open-source community. Though each
method offers relative merits and pitfalls, both require attention to security and
timely releases of patches to fix any security flaws that are discovered.

Self Review
1. Why might a software development company be reluctant to admit security flaws?
2. How do open-source cryptography software solutions address the fact that the technique
   they use to generate keys is made public?
Ans: 1) Acknowledgement of security flaws can damage a company's reputation. 2) Such
software must use a large set of decryption keys to prevent malicious third party brute-force
attacks that attempt to compromise security by generating all possible decryption keys.


19.13 Case Study: INUX Systems Security
UNIX systems are designed to encourage user interaction, which can make them
more difficult to secure.132, 133, 134, 135, 136, 137, 138 UNIX systems are intended to be
open systems; their specifications and source code are widely available.
      The UNIX password file is encrypted. When a user enters a password, it is
encrypted and compared to the encrypted password file. Thus, passwords are unre-
coverable even by the system administrator. UNIX systems use salting when
encrypting passwords.139 The salting is a two-character string randomly selected via
a function of the time and the process ID. Twelve bits of the salting then modify the
encryption algorithm. Thus, users who choose the same password (by coincidence
or intentionally) will have different encrypted passwords (with high likelihood).
Some installations modify the password program to prevent users from choosing
weak passwords.
      The password file must be readable by any user because it contains other crucial
information (i.e., usernames, user IDs, and the like) that is required by many UNIX
tools. For example, because directories employ user IDs to record file ownership, Is
(the tool that lists directory contents and file ownership) needs to read the password
file to determine usernames from user IDs. If crackers obtain the password file, they
could potentially break the password encryption. To address this issue, UNIX pro-
tects the password file from crackers by storing information other than the encrypted
passwords in the normal password file and storing the encrypted passwords in a
shadow password file that can be accessed only by users with root privileges.140
      With the UNIX setuid permission feature, a program may be executed by one
user using the privileges of another user. This powerful feature has security flaws,

<!-- pág. 972 -->

920   Security

                 particularly when the resulting privilege is that of the "superuser" (who has access
                 to all files in a UNIX system).141-142 For example, if a regular user is able to execute
                 a shell belonging to the superuser, and for which the setuid bit has been set, then the
                 regular user essentially becomes the superuser. 143 Clearly, setuid should be
                 employed carefully. Users, including those with superuser privileges, should period-
                 ically examine their directories to confirm the presence of setuid files and detect any
                 that should not be setuid.
                        A relatively simple means of compromising security in UNIX systems (and
                 other operating systems) is to install a program that prints out the login prompt,
                 copies what the user then types, fakes an invalid login and lets the user try again.
                 The user has unwittingly given away his or her password! One defense is that if you
                 are confident you typed the password correctly the first time, you should log into a
                 different terminal and choose a new password immediately.144
                        UNIX systems include the crypt command, which allows a user to enter a key
                 and plaintext; ciphertext is output. The transformation can be reversed trivially with
                 the same key. One problem with this is that users tend to use the same key repeat-
                 edly; once the key is discovered, all other files encrypted with this key can be read.
                 Users sometimes forget to delete their plaintext files after producing encrypted ver-
                 sions. This makes discovering the key much easier.
                        Often, too many people are given superuser privileges. Restricting superuser
                 privileges can reduce the risk of attackers gaining control of a system due to errors
                 made by inexperienced users. UNIX systems provide a substitute user identity (su)
                 command to enable users to execute shells with a different user's credentials. All su
                 activity should be logged; this command lets any user who types a correct password of
                 another user assume that user's identity, possibly even acquiring superuser privileges.
                        A popular Trojan horse technique is to install a fake su program, which
                 obtains the user's password, e-mails it to the attacker and restores the regular su
                 program. 145 Never allow others to have write permission for your files, especially
                 for your directories; if you do, you're inviting someone to install a Trojan horse.
                        UNIX systems contain a feature called password aging, in which the adminis-
                 trator determines how long passwords are valid; when a password expires, the user
                 receives a message and is asked to enter a new password. 146 - 147 There are several
                 problems with this feature:
                      1. Users often supply easy-to-crack passwords.
                      2. The system often prevents a user from resetting to the old (or any other)
                         password for a week, so the user can not strengthen a weak password.
                      3. Users often switch between only two passwords.
                      Passwords should be changed frequently. A user can keep track of all login
                 dates and times to determine whether an unauthorized user has logged in (which
                 means that his or her password has been learned). Logs of unsuccessful login
                 attempts often store passwords, because users sometimes accidentally type their
                 password when they mean to type their username.

<!-- pág. 973 -->

                                                                                                         Web Resources 921
      Some systems disable accounts after a small number of unsuccessful login
attempts. This is a defense against the intruder who tries all possible passwords. An
intruder who has penetrated the system can use this feature to disable the account
or accounts of users, including the system administrator, who might attempt to
detect the intrusion. 148
       The attacker who temporarily gains superuser privileges can install a trap-
door program with undocumented features. For example, someone with access to
source code could rewrite the login program to accept a particular login name and
grant this user superuser privileges without even typing a password.149
       It is possible for individual users to "grab" the system, thus preventing other
users from gaining access. A user could accomplish this by spawning thousands of
processes, each of which opens hundreds of files, thus filling all the slots in the open-
file table. 150 Installations can guard against this by setting reasonable limits on the
number of processes a parent can spawn and the number of files that a process can
open at once, but this in turn could hinder legitimate users who need the additional
resources.


Self Review
1. Why should the setuid feature be used with caution?
2. Discuss how UNIX systems protect against unauthorized logins and how attackers can
   circumvent and exploit these mechanisms.
Ans: 1) When a user executes the program, the user's individual ID or group ID or both are
changed to that of the program's owner only while the program executes. If a regular user is
able to execute a shell belonging to the superuser, and for which the setuid bit has been set,
then the regular user essentially becomes the superuser. 2) To protect against unauthorized
logins, UNIX systems use password aging to force users to change passwords frequently,
track user logins and disable accounts after a small number of unsuccessful login attempts.
Attackers can obtain user passwords using Trojan horses, exploiting the su command and set-
uid feature and disabling an account (e.g., the system administrator's account) to prevent that
user from responding to an intrusion.




Web Resources
www.nsa.gov/selinux/index.html                                      people.freebsd.org/~jkb/howto.html
Lists documents and resources for Security-Enhanced Linux.          Discusses how to improve FreeBSD system security.
www.microsoft.com/windowsxp/security                                www.deter.com/unix
Provides links for maintaining security in Windows XP systems.      Lists links for UNIX-related security papers.
www.sun.com/software/solaris/trustedsolaris/                        www.alw.nih.gov/Security/Docs/network-
index.html
                                                                    security.html
Provides information about the trusted Solaris operating envi-      Provides an architectural overview of UNIX network security.
ronment.
                                                                    www.newsfactor.com/perl/story/7907.html
www.computerworld.com/securitytopics/security/
                                                                    Compares Linux and Windows security.
story/0,10801,69976,00.html
Discusses two security flaws in Windows NT and 2000 and how         itmanagement.earthweb.com/secu/article.php/641211
they were fixed.                                                    Discusses the future of operating systems security.

<!-- pág. 974 -->

922     Security
www-106.ibm.com/developerworks/security/library/l-                 www.ieee-security.org/cipher.html
sec/index.html?dwzone=security                                     Cipher is an electronic newsletter on security and privacy frorm
Provides links to Linux security issues and how to address         the Institute of Electrical and Electronics Engineers (IEEE)
these issues.                                                      You can view current and past issues online.
www.securemac.com/                                                 www.scmagazine.com
Provides security news for Apple systems.                          SC Magazine has news, product reviews and a conference
                                                                   schedule for security events.
www.linuxjournal.com/article.php?sid=1204
Describes how to create a Linux firewall using the TIS Firewall    www.cdt.org/crypto
Toolkit.                                                           Visit the Center for Democracy and Technology for U.S. cryp-
                                                                   tography legislation and policy news.
www.rsasecurity.com
Homepage of RSA security.                                          csrc.nist.gov/encryption/aes
                                                                   The official site for the AES includes press releases and a dis-
www.informit.cotn/isapi/guide~security/seq_id~13/                  cussion forum.
guide/content.asp
Discusses operating system security overview, operating sys-       www.pkiforum.org/
tem security weakness.                                             The PKI Forum promotes the use of the Public Key Infrastruc-
                                                                   ture.
www.ftponline.com/wss/
                                                                   www.Verisign.com
Homepage of the Windows Server System magazine, which
                                                                   VeriSign creates digital IDs for individuals, small businesses
contains various security articles.
                                                                   and large corporations. Check out its Web site for product
www.networkcomputing.com/1202/1202fldl.html                        information, news and downloads.
Provides a tutorial on wireless security.                          www.thawte.com
www.cnn.com/SPECIALS/2003/wireless/interactive/                    Thawte Digital Certificate Services offers SSL, developer and
wi reless101/index.html                                            personal certificates.
Provides a list of wireless security technologies for computers,   www.belsign.be/
PDAs, cell phones and other wireless devices.                      Belsign is the European authority for digital certificates.
www.securitysearch.com                                             www.interhack.net/pubs/fwfaq
This is a comprehensive resource for computer security, with       This site provides an extensive list of FAQs on firewalls.
thousands of links to products, security companies, tools and
                                                                   www.indentix.com
more. The site also offers a free weekly newsletter with infor-
                                                                   Identix specializes in fingerprinting systems for law enforce-
mation about vulnerabilities.
                                                                   ment, access control and network security. Using its fingerprint
www.w3.org/Security/Overview.html                                  scanners, you can log on to your system, encrypt and decrypt
The W3C Security Resources site has FAQs, information about        files and lock applications.
W3C security and e-commerce initiatives and links to other         www.keytronic.com
security-related Web sites.                                        Key Tronic manufactures keyboards with fingerprint recogni-
www.rsasecurity.com/rsalabs/faq                                    tion systems.
This site is an excellent set of FAQs about cryptography from      www.ietf.org/html.charters/ipsec-charter.html
RSA Laboratories, one of the leading makers of public-key          The IPSec Working Group of the Internet Engineering Task
cryptosystems.                                                     Force (IETF) is a resource for technical information related to
www.authentidate.com                                               the IPSec protocol.
Authentidate provides timestamping to verify the security of a     www.vpnc.org
file.                                                              The Virtual Private Network Consortium has VPN standards,
www.itaa.org/infosec                                               white papers, definitions and archives. VPNC also offers com-
The Information Technology Association of America (ITAA)           patibility testing with current VPN standards.
InfoSec site has information about the latest U.S. government      www.outguess.org
legislation related to information security.                       Outguess is a freely available steganographic tool.
www.securitystats.com                                              www.weca.net/OpenSection/index.asp
This computer security site provides statistics on viruses, Web    Wi-Fi alliance provides information about Wi-Fi and resources
defacements and security spending.                                 for setting up and securing a Wi-Fi network.

<!-- pág. 975 -->

                                                                                                         Summary         923

Summary
Computer security addresses the issue of preventing unau-                Single sign-on systems simplify the authentication
thorized access to resources and information maintained by        process by allowing the user to log in once using a single
computers. Computer security commonly encompasses                 password. Users authenticated via a single sign-on system
guaranteeing the privacy and integrity of sensitive data,         can then access multiple applications across multiple com-
restricting the use of computer resources and providing           puters. It is important to secure single sign-on passwords,
resilience against malicious attempts to incapacitate the         because if a password becomes available to hackers, all
system. Protection entails mechanisms that shield resources       applications protected by that password can be accessed
such as hardware and operating system services from               and attacked. Single sign-on systems are available in forms
attack.                                                           of workstation login scripts, authentication server scripts
       Cryptography focuses on encoding and decoding data         and token-based authentication.
so that it can be interpreted only by the intended recipients.           The key to operating system security is to control
Data is transformed by means of a cipher or cryptosystem.         access to system resources. The most common access rights
Modern cryptosystems rely on algorithms that operate on           are read, write and execute. Techniques that an operating
the individual bits or blocks (a group of bits) of data, rather   system employ to manage access rights include the access
than letters of the alphabet. Encryption and decryption           control matrices, access control lists and capability lists.
keys are binary strings of a given length.                               There are several types of security attacks against
       Symmetric cryptography, also known as secret-key           computer systems, including cryptanalytic attacks, viruses
cryptography, uses the same secret key to encrypt and             and worms (such as the ILOVEYOU virus and Sapphire/
decrypt a message. The sender encrypts a message using the        Slammer worm), denial-of-service attacks (such as a
secret key, then sends the encrypted message to the               domain name system (DNS) attack), software exploitation
intended recipient, who decrypts the message using the            (such as buffer overflow) and system penetration (such as
same secret key. A limitation of secret-key cryptography is       Web defacing).
that before two parties can communicate securely, they                   Several common security solutions include firewalls
must find a secure way to exchange the secret key.                (including packet-filtering firewall and application-level
       Public-key cryptography solves the problem of              gateways), intrusion detection systems (including host-
securely exchanging symmetric keys. Public-key cryptogra-         based intrusion detection and network-based intrusion
phy is asymmetric in that it employs two inversely related        detection), antivirus software using signature scanning and
keys: a public key and a private key. The private key is kept     heuristic scanning, security patches (such as hotfixes) and
secret by its owner, while the public key is freely distrib-      secure file systems (such as the Encrypting File System).
uted. If the public key encrypts a message, only the corre-              The five fundamental requirements for a successful,
sponding private key can decrypt it.                              secure transaction are privacy, integrity, authentication,
       The most common authentication scheme is simple            authorization and nonrepudiation. The privacy issue deals
password protection. The user chooses a password, memo-           with ensuring that the information transmitted over the
rizes it and presents it to the system to gain admission to a     Internet has not been viewed by a third party. The integrity
resource or system. Password protection introduces several        issue deals with ensuring that the information sent or
weaknesses to a secure system. Users tend to choose pass-         received has not been altered. The authentication issue
words that are easy to remember, such as the name of a            deals with verifying the identities of the sender and
spouse or pet. Someone who has obtained personal infor-           receiver. The authorization issue deals with managing
mation about the user might try to log in several times           access to protected resources on the basis of user creden-
using passwords that are characteristic of the user; several      tials. The nonrepudiation issue deals with ensuring that the
repeated attempts might result in a security breach.              network will operate continuously.
       Biometrics uses unique personal information—such                  Public-key algorithms are most often employed to
as fingerprints, eyeball iris scans or face scans—to identify a   exchange secret keys securely. The process by which two
user. A smart card is often designed to resemble a credit         parties can exchange keys over an unsecure medium is
card and can serve many different functions, from authenti-       called a key agreement protocol. Common key agreement
cation to data storage. The most popular smart cards are          protocols are the digital envelopes and digital signatures
memory cards and microprocessor cards.                            (using the SHA-1 and MD5 hash algorithms).

<!-- pág. 976 -->

924     Security
      A limitation of public-key cryptography is that multi-       wireless communication by encrypting transmitted data
ple users might share the same set of keys, making it diffi-       and preventing unauthorized access to the wireless net-
cult to establish each party's identity. Public Key                work. WEP has several drawbacks, which make it to be too
Infrastructure (PKI) provides a solution by integrating            weak for many environments. Wi-Fi Protected Access
public-key cryptography with digital certificates and certifi-     (WPA) addresses these issues by providing improved data
cate authorities to authenticate parties in a transaction.         encryption and by enabling user authentication, a feature
      The Secure Sockets Layer (SSL) protocol is a non-            not supported by WEP.
proprietary protocol that secures communication between                   A primary advantage to open-source security appli-
two computers on the Internet. SSL implements public-key           cations is interoperability—open-source applications tend
cryptography using the RSA algorithm and digital certifi-          to implement standards and protocols that many develop-
cates to authenticate the server in a transaction and to pro-      ers include in their products. Another advantage to open-
tect private information as it passes over the Internet. SSL       source security is that an application's source code is avail-
transactions do not require client authentication; many            able for extensive testing and debugging by the community
servers consider a valid credit card number to be sufficient       at large. The primary weaknesses of proprietary security
for authentication in secure purchases.                            are nondisclosure and the fact that the number of collabo-
       Virtual Private Networks (VPNs) provide secure              rative users that can search for security flaws and contrib-
communications over public connections. Encryption                 ute to the overall security of the application is limited.
enables VPNs to provide the same services and security as          Proprietary systems, however, can be equally as secure as
private networks. A VPN is created by establishing a secure        open-source systems.
communication channel over the Internet. IPSec (Internet                 The UNIX password file is stored in encrypted form.
Protocol Security), which uses public-key and symmetric-           When a user enters a password, it is encrypted and com-
key cryptography to ensure data integrity, authentication          pared to the password file. Thus, passwords are unrecover-
and confidentiality, is commonly used to implement a               able even by the system administrator.
secure tunnel.                                                           With the UNIX setuid permission feature, a program
      Wireless devices have limited bandwidth and process-         may be executed by one user using the privileges of
ing power, high latency and unstable connections, so estab-        another user. This powerful feature has security flaws, par-
lishing secure wireless communication can be challenging.          ticularly when the resulting privilege is that of the "supe-
The Wired Equivalent Privacy (WEP) protocol protects               ruser" (who has access to all files in a UNIX system).


Key Terms
3 D E S - S e e Triple DES.                                            they may be physical objects that correspond to disks
Advanced Encryption Standard (AES)—Standard for sym-                   processors or main memory or abstract objects that corre-
   metric encryption that uses Rijndael as the encryption              spond to data structures, processes or services. Subjects
   method. AES has replaced the Data Encryption Standard               are also considered to be objects of the system; one sub-
   (DES) because AES provides enhanced security.                       ject may have rights to access another.
access control list—List that stores one entry for each access     air gap technology—Network security solution that comple-
    right granted to a subject for an object. An access control         ments a firewall. It secures private data from external
    list consumes less space than an access control matrix.             users accessing the internal network.
access control matrix—Matrix that lists system's subjects in the   antivirus software—Program that attempts to identify, remove
    rows and the objects to which they require access in the            and otherwise protect a system from viruses.
    columns. Each cell in the matrix specifies the actions that
    a subject (defined by the row) can perform on an object        application-level gateway—Hardware or software that pro-
    (defined by the column). Access control matrices typically         tects the network against the data contained in packets. If
    are not implemented because they are sparsely populated.           the message contains a virus, the gateway can block it
                                                                       from being sent to the intended receiver.
access right—Defines how various subjects can access various
    objects. Subjects may be users, processes, programs or         authentication (secure transaction) —One of the five funda-
    other entities. Objects are information-holding entities;          mental requirements for a successful, secure transaction

<!-- pág. 977 -->

                                                                                                                  Key     Terms      925

    Authentication deals with how the sender and receiver of           cipher—Mathematical algorithm for encrypting messages.
    a message verify their identities to each other.                       Also called cryptosystem.
authentication header (AH) (IPSec)—Information that veri-              ciphertext—Encrypted data.
    fies the identity of a packet's sender and proves that a           cracker—Malicious individual that is usually interested in
    packet's data was not modified in transit.                             breaking into a system to disable services or steal data.
authentication server scripts—Single sign-on implementation            credential—Combination of user identity (e.g., username) and
    that authenticates users via a central server, which estab-            proof of identify (e.g., password).
    lishes connections between the user and the applications           cryptanalytic attack—Technique that attempts to decrypt
    the user wishes to access.                                             ciphertext without possession of the decryption key. The
authorization (secure transaction) —One of the five fundamen-              most common such attacks are those in which the encryp-
    tal requirements for a successful, secure transaction.                 tion algorithm is analyzed to find relations between bits of
    Authorization deals with how to manage access to pro-                  the encryption key and bits of the ciphertext.
    tected resources on the basis of user credentials.                 cryptography—Study of encoding and decoding data so that it
back-door program—Resident virus that allows an attacker                   can be interpreted only by the intended recipients.
    complete, undetected access to the victim's computer               cryptosystem—Mathematical algorithm for encrypting mes-
    resources.                                                             sages. Also called a cipher.
biometrics—Technique that uses an individual's physical char-          Data Encryption Standard (DES)—Symmetric encryption
    acteristics, such as fingerprints, eyeball iris scans or face          algorithm that use a 56-bit key and encrypts data in 64-bit
    scans, to identify the user.                                           blocks. For many years, DES was the encryption standard
block cipher—Encryption technique that divides a message                   set by the U.S. government and the American National
    into fixed-size groups of bits to which an encryption algo-            Standards Institute (ANSI). However, due to advances in
    rithm is applied.                                                      computing power, DES is no longer considered secure—
                                                                           in the late 1990s, specialized DES cracker machines were
boot sector virus—Virus that infects the boot sector of the                built that recovered DES keys after a period of several
    computer's hard disk, allowing it to load with the operat-             hours.
    ing system and take control of the system.
                                                                       denial-of-service (DoS) attack—Attack that prevents a system
brute-force cracking—Technique to compromise a system sim-                 from properly servicing legitimate requests. In many DoS
    ply by attempting all possible passwords or by using every             attacks, unauthorized traffic saturates a network's
    possible decryption key to decrypt a message.                          resources, restricting access for legitimate users. Typically,
buffer overflow—Attack that sends input that is larger than                the attack is performed by flooding servers with data
     the space allocated for it. If the input is properly coded            packets.
     and the system's stack is executable, buffer overflows can        digital certificate—Digital document that identifies a user or
     enable an attacker to execute malicious code.                          organization and is issued by a certificate authority. A dig-
capability (access control mechanism)—Token that grants a                   ital certificate includes the name of the subject (the orga-
    subject privileges for an object. It is analogous to a ticket           nization or individual being certified), the subject's public
    the bearer may use to gain access to a sporting event.                  key, a serial number (to uniquely identify the certificate),
                                                                            an expiration date, the signature of the trusted certificate
certificate authority (CA)—Financial institution or other                   authority and any other relevant information.
     trusted third party, such as VeriSign, that issues digital cer-
     tificates.                                                        digital envelope—Technique that protects message privacy by
                                                                            sending a package including a message encrypted using a
certificate authority hierarchy—Chain of certificate authori-               secret key and the secret key encrypted using public-key
     ties, beginning with the root certificate authority, that              encryption.
     authenticates certificates and CAs.
                                                                       digital notary service—See time-stamping agency.
certificate repositories—Locations where digital certificates
                                                                       digital signature—Electronic equivalent of awritten signature.
     are stored.
                                                                            To create a digital signature, a sender first applies a hash
certificate revocation list (CRL)—List of cancelled and                     function to the original plaintext message. Next, the
     revoked certificates. A certificate is cancelled/revoked if a          sender uses the sender's private key to encrypt the mes-
     private key is compromised before its expiration date.                 sage digest (the hash value). This step creates a digital sig-

<!-- pág. 978 -->

926      Security

      nature and validates the sender's identity, because only      Internet Protocol Security (IPSec)—Transport-layer security
      the owner of that private key could encrypt the message.           protocol that provides data privacy, integrity and authen-
                                                                         tication.
Digital Signature Algorithm (DSA)—U.S. government's digi-
     tal authentication standard.                                   intrusion detection system (IDS)—Application that monitors
                                                                         networks and application log files, which record informa-
digital watermark—Popular application of steganography that
                                                                         tion about system behavior, such as the time at which
     hides information in unused (or rarely used) portions of a
                                                                         operating services are requested and the name of the pro-
     file.
                                                                         cess that requests it.
discretionary access control (DAC)—Access control model in          IP spoofing—Attack in which an attacker simulates the IP
     which the creator of an object controls the permissions for        address of an authorized user or host to obtain unautho-
     that object.                                                       rized access to resources.
distributed denial-of-service attack—Attack that prevents a         Kerberos—Freely available, open-source authentication and
     system from servicing requests properly by initiating              access control protocol developed at MIT that provides
     packet flooding from separate computers sending traffic            protection against internal security attacks. It employs
     in concert.                                                        secret-key cryptography to authenticate users in a net-
DNS (domain name system) attack—Attack that modifies the                work and to maintain the integrity and privacy of network
   address to which network traffic for a particular Web site is        communications.
   sent. Such attacks can be used to redirect users of a particu-   key—Input to a cipher to encrypt data; keys are represented
   lar Web site to another, potentially malicious Web site.            by a string of digits.
encapsulating security payload (ESP) (IPSec)—Message data           key agreement protocol—Rules that govern key exchange
    encrypted using symmetric-key ciphers to protect the data           between two parties over an unsecure medium.
    from eavesdroppers while the IP packet is transmitted           key distribution center (KDC)—Central authority that shares
    across public communication lines.                                  a different secret key with every user in the network.
Encrypting File System (EFS)—NTFS feature that uses cryp-           key generation—Creation of encryption keys.
    tography to protect files and folders in Windows XP Pro-
                                                                    layered biometric verification (LBV)—Authentication tech-
    fessional and Windows 2000. EFS uses secret-key and
                                                                         nique that uses multiple measurements of human features
    public-key encryption to secure files. Each user is assigned
                                                                         (such as face, finger and voice prints) to verify a user's
    a key pair and certificate that are used to ensure that only
                                                                         identity.
    the user that encrypted the files can access them.
                                                                    log file—Records information about system behavior, such as
firewall—Software or hardware that protects a local area net-            the time at which operating services are requested and the
     work from packets sent by malicious users from an exter-            name of the process that requests them.
     nal network.
                                                                    logic bomb—Virus that executes its code when a specified con-
hacker—Experienced programmer who often program as                       dition is met.
    much for personal enjoyment as for the functionality of
                                                                    Lucifer algorithm—Encryption algorithm created by Horst
    the application. This term is often used when the term
                                                                        Feistel of IBM, which was chosen as the DES by the
    cracker is more appropriate.
                                                                        United States government and the National Security
heuristic scanning—Antivirus technique that detects viruses             Agency (NSA) in the 1970s.
    by their program behavior.
                                                                    Macintosh—Apple Computer's PC line that introduced the
host-based intrusion detection—IDS that monitors system and            GUI and mouse to mainstream computer users.
     application log files.                                         Mac OS—Line of operating systems for Apple Macintosh
integrity (secure transaction) —One of the five fundamental            computers first introduced in 1997.
     requirements for a successful, secure transaction. Integ-      mandatory access control (MAC)—Access control model in
     rity deals with how to ensure that the information you            which policies predefine a central permission scheme by
     send or receive has not been compromised or altered.              which all subjects and objects are controlled.
Internet Key Exchange (IKE) (IPSec)—Key-exchange proto-             MD5 Message Digest Algorithm—Hash algorithm developed
     col used in IPSec to perform key management, which                by Professor Ronald L. Rivest at MIT that is widely used
     allows secure key exchange.                                       to implement digital signatures.

<!-- pág. 979 -->

                                                                                                           Key Terms 927
message digest—Hash value produced by algorithms such as         polymorphic virus—Virus that attempts to evade known virus
    SHA-1 and MD5 when applied to a message.                         lists by modifying its code (e.g., via encryption, substitu-
                                                                     tion, insertion, and the like) as it spreads.
message integrity—Property indicating whether message has
    been altered in transmission.                                Pretty Good Privacy (PGP)—Public-key encryption system
National Institute of Standards and Technology (NIST)—               primarily used to encrypt e-mail messages and files,
                                                                      designed in 1991 by Phillip Zimmermann.
    Organization that sets cryptographic (and other) stan-
    dards for the U.S. government.                               privacy (secure transaction)—One of the five fundamental
network-based intrusion detection—IDS that monitors traffic           requirements for a successful, secure transaction. Privacy
                                                                      deals with how to ensure that the information transmitted
    on a network for any unusual patterns that might indicate
                                                                      over the Internet has not been captured or passed to a
    DoS attacks or attempted entry into a network by an
                                                                      third party without user knowledge.
    unauthorized user.
                                                                 private key—Key in public-key cryptography that should be
nonrepudiation—Issue that deals with how to prove that a
                                                                      known only by its owner. If its corresponding public key
    message was sent or received.
                                                                      encrypts a message, only the private key should be able to
Online Certificate Status Protocol (OCSP)-Protocol that val-          decrypt it.
    idates certificates in real time.
                                                                 privilege (access right)—The manner in which a subject can
OpenBSD—BSD UNIX system whose primary goal is security.               access an object.
Operationally Critical Threat, Asset and Vulnerability Evalua-   protection—Mechanism that prevents unauthorized use of
   tion (OCTAVE) method—Technique for evaluating secu-               resources such as hardware and operating system services.
   rity threats of a system developed at the Software
   Engineering Institute at Carnegie Mellon University.          protection domain—Collection of access rights. Each access
                                                                     right in a protection domain is represented as an ordered
Orange Book—Document published by U.S. Department of                 pair with fields for the object name and applicable privi-
   Defence (DoD) to establish guidelines for evaluating the          leges.
   security features of operating systems.
                                                                 public key—Key in public cryptography that is available to all
packet-filtering firewall—Hardware or software that examines         users that wish to communicate with its owner. If the pub-
    all data sent from outside its LAN and rejects data pack-        lic key encrypts a message, only the corresponding private
    ets based on predefined rules, such as reject packets that       key can decrypt it.
    have local network addresses or reject packets from cer-
    tain addresses or ports.                                     public-key cryptography—Asymmetric cryptography tech-
                                                                     nique that employs two inversely related keys: a public
password aging—Technique that attempts to improve security           key and a private key. To transmit a message securely, the
    by requiring users to change their passwords periodically.       sender uses the receiver's public key to encrypt the mes-
password protection—Authentication technique that relies on          sage. The receiver then decrypts the message using his or
    a user's presenting a username and corresponding pass-           her unique private key.
    word to gain access to a resource or system.                 Public Key Infrastructure (PKI)—Technique that integrates
password salting—Technique that inserts characters at various        public-key cryptography with digital certificates and cer-
    positions in the password before encryption to reduce vul-       tificate authorities to authenticate parties in a transaction.
    nerability to brute-force attacks.                           resident virus—Virus that, once loaded into memory, executes
payload—Code inside a logic bomb that is executed when a              until the computer is powered down.
    specified condition is met.                                  restricted algorithm—Algorithm that provides security by
plaintext—Unencrypted data.                                           relying on the sender and receiver to use the same encryp-
                                                                      tion algorithm and maintain its secrecy.
Platform for Privacy Preferences (P3P)—Protects the privacy
     of information submitted to single sign-on and other        random-scanning algorithm—Algorithm that uses pseudoran-
     applications by allowing users to control the personal          dom numbers to generate a broad distribution of IP
     information that sites collect.                                 addresses.
policy creation authority—Organization that sets policies for    real-time scanner—Software that resides in memory and
     obtaining digital certificates.                                  actively prevents viruses.

<!-- pág. 980 -->

928 Security

root key—Used by the Internet Policy Registration Authority          smart card—Credit card size data store that serves many func-
   (IPRA) to sign certificates exclusively for policy creation           tions, including authentication and data storage.
   authorities.                                                      steganography—Technique that hides information within
Rijndael—Block cipher developed by Dr. Joan Daemen and                    other information, derived from Latin roots meaning
   Dr. Vincent Rijmen of Belgium. The algorithm can be                    "covered writing."
   implemented on a variety of processors.                           substitution cipher—Encryption technique whereby every
role (RBAC) — Represents a set of tasks assigned to a member             occurrence of a given letter is replaced by a different let-
    of an organization. Each role is assigned a set of privileges,       ter. For example, if every "a" were replaced by a "b,'
    which define the objects that users in each role can access.         every "b" by a "c," and so on the word "security" would
role-based access control (RBAC)—Access control model in                 encrypt to "tfdvsjuz."
    which users are assigned roles.                                  static analysis—Intrusion detection method which attempts to
                                                                           detect when applications have been corrupted by a hacker.
RSA—Popular public-key algorithm, which was developed in
  1977 by MIT professors Ron Rivest, Adi Shamir and                  system penetration—Successful breach of computer security
  Leonard Adleman.                                                        by an unauthorized external user.
secret-key cryptography—Technique that performs encryption           symmetric cryptography—See secret-key cryptography.
    and decryption using the same secret key to encrypt and          Ticket Granting Service (TGS) (Kerberos) —Server that
    decrypt a message. The sender encrypts a message using               authenticates client's rights to access specific network ser-
    the secret key, then sends the encrypted message to the              vices.
    intended recipient, who decrypts the message using the           Ticket-Granting Ticket (TGT) (Kerberos)—Ticket returned
    same secret key. Also called symmetric cryptography.                 by Kerberos's authentication server. It is encrypted with
Secure Hash Algorithm (SHA-1)—Popular hash function used                 the client's secret key that is shared with the authentica-
   to create digital signatures; developed by NIST                       tion server. The client sends the decrypted TGT to the
Secure Sockets Layer (SSL)—Nonproprietary protocol devel-                Ticket Granting Service to request a service ticket.
   oped by Netscape Communications that secures commu-               time bomb—Virus that is activated when the clock on the com-
   nication between two computers on the Internet.                       puter matches a certain time or date.
Security mechanism—Method by which the system implements             timestamping (nonrepudiation)—Technique that binds a time
   its security policy. In many systems, the policy changes over         and date to a digital document, which helps solve the
   time, but the mechanism remains unchanged.                            problem of nonrepudiation.
Security model—Entity that defines a system's subjects, objects      time-stamping agency—Organization that digitally time
   and privileges.                                                       stamps a document that has been digitally signed.
Security patch—Code that addresses a security flaw.                  token (in token-based authentication)—Unique identifier for
                                                                         authentication.
Security policy—Rules that govern access to system resources.
                                                                     token-based authentication—Authentication technique that
Service ticket (Kerberos)—Ticket that authorizes the client's
                                                                         issues a token unique to each session, enabling users to
   access to specific network services.
                                                                         access specific applications.
Session key—Secret key that is used for the duration of a trans-
                                                                     transient virus—Virus that attaches itself to a particular com-
    action (e.g., a customer's buying merchandise from an
                                                                         puter program. The virus is activated when the program is
    online store).
                                                                         run and deactivated when the program is terminated.
Shadow password file (UNIX)—Protects the password file
                                                                     transposition cipher—Encryption technique whereby the
   from crackers by storing information other than the
                                                                         ordering of the letters is shifted. For example, if every
   encrypted passwords in the normal password file and stor-
                                                                         other letter, starting with "s," in the word "security" cre-
   ing the encrypted passwords in the shadow password file
                                                                         ates the first word in the ciphertext and the remaining let-
   that can be accessed only by users with root privileges.
                                                                         ters create the second word in the ciphertext, the word
Signature-scanning virus detection—Antivirus technique that              "security" would encrypt to "scrt euiy."
    relies on knowledge of virus code.
                                                                     Triple DES—Variant of DES that can be thought of as three
Single sign-on— Simplifies the authentication process by allow-           DES systems in series, each with a different secret key
    ing the user to log in once, using a single password.                that operates on a block. Also called 3DES.

<!-- pág. 981 -->

                                                                                                               Exercises       929
Trojan horse—Malicious program that hides within a trusted          virus signature—Segment of code that does not vary between
    program or simulates the identity of a legitimate program            virus generations.
    or feature, while actually causing damage to the computer       Web defacing—Attack that maliciously modifies an organiza-
    or network when the program is executed.                           tion's Web site.
two-factor authentication—Authentication technique that             Wi-Fi Protected Access (WPA)—Wireless security protocol
    employs two means to authenticate the user, such as bio-            intended to replace WEP by providing improved data
    metrics or a smart card used in combination with a pass-            encryption and by enabling user authentication.
    word.
                                                                    Wired Equivalent Privacy (WEP)—Wireless security protocol
variant—Virus whose code has been modified from its original            that encrypts transmitted data and prevents unauthorized
     form, yet still retains its malicious payload.                     access to the wireless network.
Virtual Private Network (VPN)—Technique that securely               workstation login scripts—Simple form of single sign-on in
    connects remote users to a private network using public             which users log in at their workstations, then choose
    communication lines. VPNs are often implemented using               applications from a menu.
    IPSec.
                                                                    worm—Executable code that spreads and infects files over a
virus—Executable code (often sent as an attachment to an e-            network. Worms rarely require any user action to propa-
    mail message or hidden in files such as audio clips, video         gate, nor do they need to be attached to another program
    clips and games) that attaches to or overwrites other files        or file to spread.
    to replicate itself, often harming the system on which it
    resides.



Exercises
19.1 Why is a precise statement of security requirements crit-      security? Why are capabilities particularly useful in achieving
ical to the determination of whether a given system is secure?      small protection domains?
                                                                    19.6 How does a capabilities list differ from an access control
19.2 Sharing and protection are conflicting goals. Give three
                                                                    list?
significant examples of sharing supported by operating sys-
tems. For each, explain what protection mechanisms are neces-       19.7 Why is an understanding of cryptography important to
sary to control the sharing.                                        operating systems designers? List several areas within operat-
                                                                    ing systems in which the use of cryptography would greatly
19.3 Give several reasons why simple password protection is         improve security. Why might a designer choose not to include
the most common authentication scheme in use today. Discuss         encryption in all facets of the operating system?
the weaknesses inherent in password protection schemes.
                                                                    19.8 Why is it desirable to incorporate certain operating sys-
19.4 An operating systems security expert has proposed the          tems security functions directly into hardware? Why is it useful
following economical way to implement a reasonable level of         to microprogram certain security functions?
security: Simply tell everyone who works at an installation that
the operating system contains the latest and greatest in secu-      19.9 Give brief definitions of each of the following terms.
rity mechanisms. Do not actually build the mechanisms, the                a. cryptography
expert says, just tell everyone that the mechanisms are in place.         b. Data Encryption Standard (DES)
Who might such a scheme deter from attempting a security
                                                                          c. privacy problem
violation? Who would not likely be deterred? Discuss the
advantages and disadvantages of the scheme. In what types of              d. integrity problem
installations might this scheme be useful? Suggest a simple               e. problem of nonrepudiation
modification to the scheme that would make it far more effec-
                                                                          f. plaintext
tive, yet still far more economical than a comprehensive secu-
rity program.                                                             g. ciphertext
                                                                          h. unsecure channel
19.5 What is the principle of least privilege? Give several rea-
sons why it makes sense. Why is it necessary to keep protec-              i. eavesdropper
tion domains small to effect the least-privilege approach to              j . cryptanalysis

<!-- pág. 982 -->

930     Security
19.10 Give brief definitions of each of the following terms.           19.14 Explain how cryptography is useful in each of the fol-
      a. public-key system                                             lowing.
      b. public key                                                          a. protecting a system's master list of passwords
      c. private key                                                         b. protecting stored files
      d. digital signature                                                   c. protecting vulnerable transmissions in computer net-
                                                                                works
19.11 Why are denial-of-service attacks of such great concern
to operating systems designers? List a few types of denial-of-         19.15 The UNIX systems administrator cannot determine the
service attacks. Why is it difficult to detect a distributed denial-   password of a user who has lost his or her password. Why?
of-service attack on a server?                                         How can that user regain access to the computer?

19.12 What is a log file? What information might an operating          19.16 How could a UNIX system user seize control of a sys-
system deposit in a log file? How does a log act as a deterrent        tem, thus locking out all other users? What defense may be
to those who would commit a security violation?                        employed against this technique?

19.13 Explain how public-key cryptography systems provide              19.17 Why do antivirus software companies and high-security
an effective means of implementing digital signatures.                 installations hire convicted hackers?


Suggested Projects
19.18 At the moment, it appears that our computing systems                   f. You may access the system only through conven-
are easy targets for penetration. Enumerate the kinds of weak-                  tional mechanisms available to nonprivileged users.
nesses that are prevalent in today's systems. Suggest how to                 g. Your attacks must be software and/or firmware ori-
correct these weaknesses.                                                       ented.
19.19 Design a penetration study for a large computer system
                                                                       19.20 Prepare a research paper on the RSA algorithm. What
with which you are familiar. Adhere to the following:
                                                                       mathematical principles aid the RSA algorithm in being diffi-
      a. Perform the study only with the full cooperation of           cult to crack?
         the computer center administrators and personnel.
                                                                       19.21 Prepare a research paper on how antivirus software pro-
      b. Arrange to have ready access to all available system
                                                                       vides security while being minimally invasive.
         documentation and software source listings.
      c. Agree that any flaws you discover will not be made            19.22 Prepare a research paper on the implementation of PGP
         public until they have been corrected.                        Explain why the name "Pretty Good Privacy" is appropriate.

      d. Prepare a detailed report summarizing your findings           19.23 Prepare a research paper on the most costly viruses and
         and suggesting how to correct the flaws.                      worms. How did these worms or viruses spread? What flaws
                                                                       did they exploit?
      e. Your primary goals are to achieve
                                                                       19.24 Prepare a research paper on how IP spoofing is per-
          i.    total system penetration                               formed.
          ii.   denial of access to legitimate system users            19.25 Discuss the ethical and legal issues surrounding the
          iii. the crashing of the system.                             practice of hacking.


Suggested Simulation
19.26 Create an application to encode and decode secret mes-           sage. To decode, just reassemble the message using the least
sages within bitmap pictures. When encoding, modify the least          significant bit of each byte.
significant bit in each byte to store information about the mes-



Recommended Reading
Computer security has been researched extensively in aca-              are constantly evolving. Although the problems of cryptogra-
demic and commercial environments. Most topics in the field            phy and access control are well characterized, techniques that

<!-- pág. 983 -->

                                                                                                                                           Works Cited 931

address security threats (such as software exploitation and net-                               and publications have emerged since the 1990s. Commercial
work attacks) must continually evolve as new hardware, soft-                                   trade journals include Information Security, SC (Secure Com-
ware and protocols with different vulnerabilities emerge.                                      puting) Magazine and Access Control and Security Systems.
       A survey of cryptography and the related problem of                                     Academic security journals include the Journal of Computer
computability is provided in Jorg Rothe's "Some Facets of Com-                                 Security and the ACM Transactions on Information and System
plexity Theory and Cryptography: A Five-Lecture Tutorial."151                                  Security (TISSEC). Dieter Gollmann provides a thorough dis-
The problem of access control is actively discussed in the litera-                             cussion of computer security theory.153 The bibliography for
ture; a survey of access control can be found in Sandhu and                                    this chapter is located on our Web site at www.deitel.com/
Samarati's "Access Control: Principles and Practice."152                                       books/os3e/Bibliography.pdf.
      Due to the importance of security to e-business and the
Internet revolution, a large number of security trade journals




Works Cited
 1. Gates, B., "Bill Gates: Trustworthy Computing," January 17,2002,                           16. Krieger, D., and W. E. Miles, "Innerview: Leonard Adleman,"
    <www.wired.com/news/business/0,1367,49826,00.html>.                                            Networker, Vol. 7, No. 1, September 1996, <www.usc.edu/isd/
 2. McFarland, M., "Ethical Issues of Computer Use," Syllabus for                                  publications/networker/96-97/Sep_Oct_96/innerview-
    course Mc690, Boston College, Chestnut Hill, MA, Spring 1989.                                  adleman .html>.
 3. Parnas, D. L., "Software Aspects of Strategic Defense Systems,"                            17. ACM, "ACM: A. M. Turing Award," April 14,                 2003,
    Communications of the ACM, Vol. 28, No. 12, December 1985,                                     <www.acm.org/announcements/turing_2002.html>.
    pp. 1326-1335.                                                                             18. RSA Security Inc., "The Authentication Scorecard," 2003,
 4. "Cryptography—Caesar Cipher," < h t t p : / / w w w . t r i n c o l l . e d u /                <www.rsasecurity.com/products/authentication/whitepa-
    depts/cpsc/cryptography/caesar.html>.                                                          pers/ASC_WP_0403.pdf>.
 5. "Methods of Transposition," < h t t p : / / h o m e . e c n . a b . c a / ~ j s a -        19. Lamport, L., "Password Authentication with Insecure Communi-
    vard/crypto/pp0102.htm>.                                                                       cation," Communications of the ACM, Vol. 24, No. 11, November
 6. RSA Laboratories, "RSA Laboratories' Frequently Asked Ques-                                    1981, pp. 770-772.
    tions About Today's Cryptography," Version 4.1, 2000, RSA                                  20. National Infrastructure Protection Center, "Password Protection
    Security Inc., <www.rsasecurity.com/rsalabs/faq>.                                              101," May 9, 2002, <www.nipc.gov/publications/nipcpub/
 7. Cherowitzo, B., "Math 5410 Data Encryption Standard (DES),"                                    password.htm>.
    February 6, 2002, <www-math.cudenver.edu/~wcherowi/                                        21. Deckmyn, D., "Companies Push New Approaches to Authentica-
    courses/m5410/m5410des.html>.                                                                  tion," Computerworld, May 15,2000, p. 6.
 8. Dworkin, M., "Advanced Encryption Standard (AES) Fact                                      22. Keyware, "Keyware Launches Its New Biometric and Central-
    Sheet," March 5, 2001, < c s r c . n i s t . g o v / C r y p t o T o o l k i t / a e s /       ized Authentication Products," January 2001, <hwww.key-
    round2/aesfact.html>.                                                                          ware.com/press/press.asp?pid=44&menu=4>.
 9. Rijmen, V., "The Rijndael Page," May 20, 2003,
                                                                                               23. Vijayan, X, "Biometrics Meet Wireless Internet," Computer-
    <www.esat.kuleuven.ac.be/~rijmen/rijndael>-
                                                                                                   world, July 17,2000, p. 14.
ro. McNett, D., "RC5-64 HAS BEEN SOLVED!" September 27,
                                                                                               24. Smart Card Forum, "What's So Smart About Smart Cards?" 2003,
    2002,                 <www.distributed.net/pressroom/news-
                                                                                                   <www.gemplus.com/basics/download/smartcardforum.pdf>.
    20020926.html>.
11. RSA Laboratories, "RSA-Based Cryptographic Schemes," 2003,                                 25. Gaudin, S., "The Enemy Within," Network World, May 8, 2000,
    <www.rsasecurity.com/rsalabs/rsa_algorithm>.                                                   pp. 122-126.
12. Ytteborg, S. S., "Overview of PGP," <www.pgpi.org/doc/                                     26. Needham, R. M. and M. D. Schroeder, "Using Encryption for
    overview>.                                                                                     Authentication in Large Networks of Computers," Communica-
                                                                                                   tions of the ACM, Vol. 21, No. 12, December 1978, pp.993- 999.
13. RSA Security Inc., "RSA Security at a Glance," 2003,
    <www.rsasecurity.com/company/corporate.html>.                                              27. Steiner, X; C. Neuman and X Schiller, "Kerberos: An authentica-
14. Rivest, R. L.; A. Shamir and L. Adleman, "A Method for Obtain-                                 tion service for open network systems," In Proceedings of the
    ing Digital Signatures and Public-Key Cryptosystems," Commu-                                   Winter 1988 USENIX, February 1988, pp. 191-202.
    nications of the ACM, Vol. 21, No. 2, February 1978, pp. 120-126.                          28. Steiner, X; C. Neuman and J. Schiller, "Kerberos: An authentica-
15. Bass, T. A., "Gene Genie," Wired, August 1995, <www.thomas-                                    tion service for open network systems," In Proceedings of the
    bass.com/work12.htm>.                                                                          Winter 1988 USENIX, February 1988, pp. 191-202.

<!-- pág. 984 -->

932 Security
29. Trickey, F., "Secure Single Sign-On: Fantasy or Reality," Com-                                    50. Wagner, D., and D. Dean, "Intrusion Detection via Static Analy-
    puter Security Institute, 1997.                                                                       sis," IEEE Symposium on Security and Privacy, May 2001.
30. Musthaler, L., "The Holy Grail of Single Sign-On," Network                                        51. Alberts, C, and A. Dorofee, "OCTAVE Information Security
    World, January 28,2002, p. 47.                                                                        Risk Evaluation," January 30, 2001, <www.cert.org/octave/
31. Press Release, "Novell Takes the Market Leader in Single Sign-                                        methodintro.html>.
    On and Makes It Better," <www.noven.com/news/press/                                               52. Delio, M, "Find the Cost of (Virus) Freedom," Wired News, Jan-
    archive/20O3/09/pr03059.html>.                                                                        uary    14,    2002,   <www.wired.com/news/infostructure/
32. "Protection and Security," < h t t p : / / c s . n m u . e d u / ~ r a n d y /                        0,1377,49681,00.html>.
    C1asses/CS426/protection_and_security.html>.                                                      53. Bridwell, L. M., and P. Tippett, "ICSA Labs Seventh Annual
33. Lampson, B., "Protection," ACM Operating Systems Review 8,                                            Computer Virus Prevalence Survey 2001," ICSA Labs, 2001.
    January 1,1974, pp. 18-24.                                                                        54. Helenius, M., "A System to Support the Analysis of Antivirus
34. Sandhu, R., and E. Coyne, "Role-Based Access Control Models,"                                         Products' Virus Detection Capabilities," Academic dissertation.
    IEEE Computer, February 1996, p. 39.                                                                  Dept. of Computer and Information Sciences, University of Tam-
35. Sandhu, R., and E. Coyne, "Role-Based Access Control Models,"                                         pere, Finland, May 2002.
    IEEE Computer, February 1996, p. 40.                                                              55. Solomon, A., and T. Kay, Dr. Solomon's PC Anti-virus Book.
36. "Handbook of Information Security Management: Access Con-                                             Butterworth-Heinemann, 1994, pp. 12-18.
    trol," <www.cccure.org/Documents/HISM/094-099.html>.                                              56. University of Reading, "A Guide to Microsoft Windows XP."
37. Chander, A.; D Dean; and J. C. Mitchell, "A State-Transition                                          October 24, 2003, <www.rdg.ac.uk/ITS/info/training/
    Model of Trust Management and Access Control," IEEE Com-                                              notes/windows/guide/>.
    puter, in Proceedings of the 14th Computer Security Foundations                                   57. Helenius, M., "A System to Support the Analysis of Antivirus
    Workshop (CSFW), June 2001, pp. 27-43.                                                                Products' Virus Detection Capabilities," Academic dissertation.
38. Lampson, B., "Protection," Proceedings of the Fifth Princeton                                         Dept. of Computer and Information Sciences, University of Tam-
    Symposium on Information Sciences and Systems, 1971, pp. 437-                                         pere, Finland, May 2002.
    443.                                                                                              58. OpenBSD Team, "OpenBSD Security," September 17, 2003.
39. Linden, T A., "Operating System Structures to Support Security                                        <www.openbsd.org/security.html>.
    and Reliable Software," ACM Computing Surveys (CSUR), Vol.                                        59. Microsoft Corporation, "Top 10 Reasons to Get Windows XP for
    8, No. 6, December 1976.                                                                              Home PC Security," April 16, 2003, <www.microsoft.com/Win-
40. Moore, D., et al., "The Spread of the Sapphire/Slammer Worm,"                                         dowsXP/security/top10.asp>.
    CAIDA, February 3, 2003, <www.caida.org/outreach/papers/                                          60. Microsoft Corporation, "What's New in Security for Windov>>
    2003/sapphire/>.                                                                                      XP Professional and Windows XP Home Edition," July 2001.
41. "Securing B2B," Global Technology Business, July 2000, pp. 50-51.                                     <www.microsoft.com/wi ndowsxp/pro/techinfo/planning/
42. Computer Security Institute, "Cyber Crime Bleeds U.S. Corpora-                                        security/whatsnew/WindowsXPSecurity.doc>.
    tions, Survey Shows; Financial Losses from Attacks Climb for                                      61. Security Electronics Magazine, "OpenBSD: Secure by Default."
    Third Year in a Row," April 7, 2002, <www.gocsi.com/press/                                            January 2002, <www.semweb.com/jan02/itsecurityjan.htm>.
    20020407.html>.
                                                                                                      62. Howard, X, "Daemon News: The BSD Family Tree," April 2001.
43. Connolly, P., "IT Outlook Appears Gloomy," InfoWorld, Novem-                                          <www.daemonnews.org/200104/bsd_family.html>.
    ber 16, 2001, < w w w . i n f o w o r l d . c o m / a r t i c l e s / t c / x m l / 0 1 / l l /
                                                                                                      63. Security Electronics Magazine, "OpenBSD: Secure by Default."
    19/011119tcstate.xrrfl>.
                                                                                                          January 2002, <www.semweb.com/jan02/itsecurityjan.htm>.
44. Bridis, T, "U.S. Archive of Hacker Attacks to Close Because It Is
                                                                                                      64. Jorm, D, "An Overview of OpenBSD Security," August 8, 2000.
    Too Busy," The Wall Street Journal, May 24,2001, p. BIO.
                                                                                                          <www.onlamp.com/pub/a/bsd/2000/08/08/OpenBSD.html>.
45. Andress, M., "Securing the Back End," InfoWorld, April 5, 2002,
                                                                                                      65. Howard, J., "Daemon News: The BSD Family Tree," April 2001.
    <www.infoworld.com/articles/ne/xml/02/04/08/
                                                                                                          <www.daemonnews.org/200104/bsd_fami1y.html>.
    020408neappdetective.xml>.
46. Marshland, R., "Hidden Cost of Technology," Financial Times,                                      66. Howard, X, "Daemon News: The BSD Family Tree," April 2001.
    June 2,2000, p. 5.                                                                                    <www.daemonnews.org/200104/bsd_family.html>.
47. Spangler, T, "Home Is Where the Hack Is," Inter@ctive Week,                                       67. Security Electronics Magazine, "OpenBSD: Secure by Default."
    April 10,2000, pp. 28-34.                                                                             January 2002, <www.semweb.com/jan02/itsecurityjan.htrn>.
48. Whale Communications, "Air Gap Architecture," 2003,                                               68. OpenBSD Team, "OpenBSD Security," September 17, 2003.
    <www.whalecommunications.com/site/Whale/Corporate/                                                    <www.openbsd.org/security.html>.
    Whale.asp?pi=264>.                                                                                69. Security Electronics Magazine, "OpenBSD: Secure by Default."
49. Azim, O., and P. Kolwalkar, "Network Intrusion Monitoring,"                                           January 2002, <www.semweb.com/jan02/itsecurityjan.htm>.
    Business Security Advisor, March/April 2001, pp. 16-19,                                           70. Jorm, D., "An Overview of OpenBSD Security," August 8, 2000.
    <advisor.com/doc/07390>.                                                                              <www.onlamp.com/pub/a/bsd/2000/08/08/OpenBSD.html>.

<!-- pág. 985 -->

                                                                                                                                    Works Cited 933
71. Howard, X, "Daemon News: The BSD Family Tree," April 2001,                      95. Apple Computer, Inc., "Apple —Mac OS X—Features —Secu-
    < w w w . d a e m o n n e w s . o r g / 2 0 0 1 0 4 / b s d _ f amily.html >.       rity," 2003,<www.apple.com/macosx/features/security/>.
72. OpenBSD Team, "Cryptography in OpenBSD," September 25,                          96. Apple Computer, Inc., "Apple—Mac OS X—Features—Win-
    2003, <www.openbsd.org/crypto.html>.                                                dows," 2003,<www.apple.com/macosx/features/windows/>.
73. OpenBSD Team, "OpenBSD Security," September 17, 2003,                           97. Dynamoo, "Orange Book FAQ," June 2002, <www.dynamoo.com/
    <www.openbsd.org/security.html>.                                                    orange/faq.htm>.
74. Howard, X, "Daemon News: The BSD Family Tree," April 2001,                      98. The Jargon Dictionary, "Orange Book," < i n f o . a s t r i a n . n e t /
    <www.daemonnews.org/200104/bsd_family.html>.                                        jargon/terms/o/Orange_Book.html>.
75. OpenBSD Team, "OpenBSD Security," September 17, 2003,                           99. Dynamoo,  "Orange    Book   Summary,"                   March      2003,
    <www.openbsd.org/security.html>.                                                    <www.dynamoo.com/orange/summary.htm>.
76. Mullen, T, "Windows Server 2003 - Secure by Default," April 27,                 100. Dynamoo,  "Orange   Book—Full      Text,"                June     2002,
    2003, <www.securityfocus.com/columnists/157>.                                        <www.dynamoo.com/orange/fulltext.htm>.
77. OpenBSD Team, "OpenBSD," September 27, 2003, <www.open¬                         101. "EPL Entry CSC-EPL-95/006.D," January 2000, <www.radium.
    bsd.org>.                                                                            ncsc.mil/tpep/epl/entries/CSC-EPL-95-006-D.html>.
78. Security Electronics Magazine, "OpenBSD: Secure by Default,"                    102. "EPL Entry CSC-EPL-93/008.A," July 1998, <www.radium.
    January 2002, <www.semweb.com/jan02/itsecurityjan.htm>.                              ncsc.mil/tpep/epl/entries/CSC-EPL-93-008-A.html>.
79. Sanford, G., "Lisa/Lisa 2/Mac XL," <www.apple-history.com/                      103. "EPL Entry CSC-EPL-93/003.A," July 1998, <www.radium.
    noframes/body.php?page=gal1ery&model=lisa>.                                          ncsc.mil/tpep/epl/entries/CSC-EPL-93-0O3-A.html>.
80. Sanford, G., "Macintosh 128k," <www.apple-history.com/nof-                      104. "EPL Entry CSC-EPL-93/006.A," July 1998, <www.radium.
    rames/body.php?page=gal1ery&model=128k>.                                             ncsc.mil/tpep/epl/entries/CSC-EPL-93-006-A.html>.
81. Trotot, X, "Mac™ OS History," < p e r s o . c l u b - i n t e r n e t . f r /   105. Corbato, F. J., and V. A. Vyssotsky, "Introduction and Overview
    jctrotot/Perso/History.html>.                                                        of the Multics System," <www.multicians.org/fjccl.html >.
82. Horn, B., "On Xerox, Apple, and Progress," <www.apple-his¬                      106. "EPL Entry CSC-EPL-90/001.A," July 1998, <www.radium.
    tory.com/noframes/body.php?page=gui_hornl>.                                          ncsc.mil/tpep/epl/entries/CSC-EPL-90-001-A.html>.
83. Horn, B., "On Xerox, Apple, and Progress," <www.apple-his¬                      107. "EPL Entry CSC-EPL-92/003.E," June 2000, <www.radium,
    tory.com/noframes/body.php?page=gui _hornl>.                                         ncsc.mil/tpep/epl/entries/CSC-EPL-92-003-E.html>.
84. Sanford, G, "Lisa/Lisa 2/Mac XL," <www.apple-history.com/                       108. "EPL Entry CSC-EPL-94/006," July 1998,                  <www.radium.
    noframes/body.php?page=gal1ery&model=lisa>.                                          ncsc.mil/tpep/epl/entries/CSC-EPL-94-006.html>.
85. Apple Computer, "1984 Commercial," <www.apple-his-                              109. RSA Laboratories, "4.1.3.14 How Are Certifying Authorities
    tory.com/noframes/body.php?page=gal1ery&model=1984>.                                 Susceptible to Attack?" April 16, 2003, <www.rsasecurity.com/
86. Sanford, G., "Macintosh 128k," <www.apple-history.com/nof-                           rsalabs/faq/4-1-3-14.html>.
    rames/body.php?page=gal1ery&model=128k>.                                        n o . Hulme, G., "VeriSign Gave Microsoft Certificates to Imposter,"
87. Sanford, G, "Company History: 1985-1993," <www.apple-his¬                             Information Week, March 3,2001.
    tory.com/noframes/body.php?page=hi story&section=h4>.                           i n . Ellison, C, and B. Schneier, "Ten Risks of PKI: What You're Not
88. University of Utah, "Mac OS History," September 23, 2003,                             Being Told about Public Key Infrastructure," Computer Security
    <www.macos.Utah.edu/Documentation/MacOSXClasses/                                      Journal, 2000.
    macosxone/maci ntosh.html>.                                                     112. "X.509 Internet Public Key Infrastructure Online Certificate Sta-
89. University of Utah, "Mac OS History," September 23, 2003,                            tus Protocol-OCSP," RFC 2560, June 1999, <www.ietf.org/
    <www.macos.Utah.edu/Documentation/MacOSXClasses/                                     rfc/rfc2560.txt>.
    macosxone/macintosh.html>.                                                      113. Abbot, S., "The Debate for Secure E-Commerce," Performance
90. Trotot, X, "Mac™ OS History," < p e r s o . c l u b - i n t e r n e t . f r /        Computing, February 1999, pp. 37-42.
    jctrotot/Perso/History.html>.                                                   114. Wilson, T, "E-Biz Bucks Lost Under the SSL Train," Internet
91. University of Utah, "Mac OS History," September 23, 2003,                            Week, May 24,1999, pp. 1,3.
    <www.macos.Utah.edu/Documentation/MacOSXClasses/                                115. Gilbert, H., "Introduction to TCP/IP," February 2, 1995,
    macosxone/macintosh.html>.                                                           <www.yale.edu/pclt/COMM/TCPIP.HTM>.
92. Apple Computer, Inc., "The Evolution of Darwin," 2003,                          116. RSA Laboratories, "Security Protocols Overview,"                  1999,
    <developer.apple.com/darwin/history.html>.                                           <www.rsasecurity.com/standards/protocols>.
93. Apple Computer, Inc., "Apple—Mac OS X—Features—UNIX,"                           117. "The TLS Protocol Version 1.0," RFC 2246, January 1999,
    2003, <www.apple.com/macosx/features/unix/>.                                         <www.ietf.org/rfc/rfc2246.txt>.
94. Apple Computer, Inc., "Apple—Mac OS X—Features —Dar-                            118. Cisco Systems, Inc., "VPN Solutions," 2003, <www.cisco.com/
    win," 2003,<www.apple.com/macosx/features/darwin/>.                                  warp/public/44/solutions/network/vpn.shtml>.

<!-- pág. 986 -->

934     Security

119. Burnett, S., and S. Paine, RSA Security's Official Guide to Cryp-    136. Filipski, A., and J. Hanko, "Making UNIX Secure," Byte, April
     tography, Berkeley: Osborne McGraw-Hill, 2001, p. 210.                    1986, pp. 113-128.
120. RSA Laboratories, "3.6.1 What Is Diffie-Hellman?" April 16,          137. Coffin, S., UNIX: The Complete Reference, Berkeley, CA:
     2003, <www.rsasecurity.com/rsalabs/faq/3-6-1.html>.                       Osborne McGraw-Hill, 1988.
121. Naik, D., Internet Standards and Protocols, Microsoft Press, 1998,   138. Hecht, M. S.; A. Johri; R. Aditham; and T. J. Wei, "Experience
     pp. 79-80.                                                                Adding C2 Security Features to UNIX," USENIX Conference
                                                                               Proceedings, San Francisco, June 20-24,1988, pp. 133-146.
122. Grayson, M., "End the PDA Security Dilemma," Communica-
     tion News, February 2001, pp. 38-40.                                 139. Filipski, A., and J. Hanko, "Making UNIX Secure," Byte, April
                                                                               1986, pp. 113-128.
123. Fratto, M., "Tutorial: Wireless Security," January 22, 2001,
     <www.networkcomputing.com/1202/1202fldl.html>.                       140. Linux Password & Shadow File Formats, <www.tldp.org/LDP/
                                                                               lame/LAME/linux-admin-made-easy/shadow-file-for-
124. Westoby, K., "Security Issues Surrounding Wired Equivalent Pri-
                                                                               mats.html>.
     vacy," March 26, 2002, <www.cas.monaster.ca/~wmfarmer/SE-
     4C03-02/projects/student_work/westobkj.html>.                        141. Coffin, S., UNIX: The Complete Reference, Berkeley, CA:
                                                                               Osborne McGraw-Hill, 1988.
125. Borisov, R; I. Goldberg; and D. Wagner, "Security of the WEP
                                                                          142. Kramer, S. M., "Retaining SUID Programs in a Secure UNIX."
     algorithm,"         <www.isaac.cs.berkeley.edu/isaac/wep-
                                                                               USENIX Conference Proceedings, San Francisco, June 20-24.
     faq.html>.
                                                                               1988, pp. 107-118.
126. Geier, X, "802.11 WEP: Concepts and Vulnerability," June 20,
                                                                          143. Farrow, R., "Security Issues and Strategies for Users," UNIX
     2002,        <www.wi-fiplanet.com/tutorials/article.php/
                                                                               World, April 1986, pp. 65-71.
     1368661>.
                                                                          144. Filipski, A., and J. Hanko, "Making UNIX Secure," Byte, April
127. Geier, J., "WPA Plugs Holes in WEP," March 31, 2003,
                                                                               1986, pp. 113-128.
     <www.nwfusion.com/research/2003/0331wpa.html>.
                                                                          145. Farrow, R., "Security Issues and Strategies for Users," UNIX
128. CNN Wireless Society, "Special Report: Wireless 101," 2003,               World, April 1986, pp. 65-71.
     <www.cnn.com/SPECIALS/2003/wireless/interactive/
                                                                          146. Grampp, F. T., and R. H. Morris, "UNIX Operating System Secu-
     wi reless101/index. htmlx
                                                                               rity," AT&T Bell Laboratories Technical Journal, Vol. 63, No. 8.
129. Katzenbeisser, S., and F. Petitcolas, Information Hiding: Tech-           October 1984. pp. 1649-1672.
     niques for Steganography and Digital Watermarking, Norwood:
                                                                          147. Coffin. S., UNIX: The Complete Reference, Berkeley, CA:
     Artech House, Inc., 2000, pp. 1-2.
                                                                               Osborne McGraw-Hill, 1988.
130. Evers, J., "Worm Exploits Apache," InfoWorld, July 1, 2002,
                                                                          148. Bauer, D. S., and M. E. Koblentz, " N I D X - A Real-Time Intru-
     <www.infoworld.com/articles/hn/xml/02/07/01/
                                                                               sion Detection Expert System," USENIX Conference Proceed-
     020701hnapache.xml>.
                                                                               ings, San Francisco, June 20-24,1988, pp. 261-274.
131. Lasser, X, "Irresponsible Disclosure," SecurityFocus Online, June    149. Farrow, R., "Security Issues and Strategies for Users," UNIX
     26,2002, <online.securityfocus.com/columnists/91>.                        World, April 1986. pp. 65-71.
132. Grampp, F. X, and R. H. Morris, "UNIX Operating System Secu-         150. Filipski, A., and J. Hanko, "Making UNIX Secure," Byte, April
     rity," AT&T Bell Laboratories Technical Journal, Vol. 63, No. 8,          1986, pp. 113-128.
     October 1984, pp. 1649-1672.
                                                                          151. Rothe, J, "Some Facets of Complexity Theory and Cryptogra-
133. Wood, P., and S. Kochan, UNIX System Security, Hasbrouck                  phy: A Five-Lecture Tutorial," ACM Computing Surveys
     Heights, NJ: Hayden Book Co., 1985.                                       (CSUR),Vol 24, No. 4, December 2002.
134. Farrow, R., "Security Issues and Strategies for Users," UNIX         152. Sandhu, R. S., and P. Samarati, "Access Control: Principles and
     World, April 1986, pp. 65-71.                                             Practice," IEEE Communications, Vol. 32, No. 9,1994, pp. 40-48.
135. Farrow, R., "Security for Superusers, or How to Break the UNIX       153. Gollmann, D.. Computer Security, Hoboken, NJ: John Wiley &
     System," UNIX World, May 1986, pp. 65-70.                                 Sons Ltd. 1999.

