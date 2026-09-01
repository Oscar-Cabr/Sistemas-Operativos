# Cover / Title / Copyright

> Fuente: Operating Systems Internals and Design Principles (William Stallings) — páginas 1–7 (numeración del PDF)

<!-- pág. 2 -->

            oPEraTING sysTEMs




A01_STAL4290_09_GE_FM.indd 1    5/9/17 4:40 PM

<!-- pág. 3 -->

                               This page intentionally left blank




A01_STAL4290_09_GE_FM.indd 1                                        5/19/17 9:06 PM

<!-- pág. 4 -->

            oPEraTING sysTEMs
            Internals and Design
            Principles
            NINTH EDITIoN
            GloBal EDITIoN




            William Stallings




A01_STAL4290_09_GE_FM.indd 3       5/9/17 4:40 PM

<!-- pág. 5 -->

            Senior Vice President Courseware Portfolio                            Senior Manufacturing Controller, Global Editions: Trudy
                  Management: Marcia J. Horton                                          Kimber
            Director, Portfolio Management: Engineering, Computer                 Media Production Manager, Global Editions: Vikram
                  Science & Global Editions: Julian Partridge                           Kumar
            Higher Ed Portfolio Management: Tracy Johnson                         Inventory Manager: Ann Lam
                  (Dunkelberger)                                                  Marketing Manager: Demetrius Hall
            Acquisitions Editor, Global Editions: Sourabh Maheshwari              Product Marketing Manager: Yvonne Vannatta
            Portfolio Management Assistant: Kristy Alaura                         Marketing Assistant: Jon Bryant
            Managing Content Producer: Scott Disanno                              Cover Designer: Lumina Datamatics
            Content Producer: Robert Engelhardt                                   Cover Art: Shai_Halud/Shutterstock
            Project Editor, Global Editions: K.K. Neelakantan                     Full-Service Project Management: Bhanuprakash Sherla,
            Web Developer: Steve Wright                                                 SPi Global
            Rights and Permissions Manager: Ben Ferrini
            Manufacturing Buyer, Higher Ed, Lake Side
                  Communications Inc (LSC): Maura Zaldivar-Garcia

            Credits and acknowledgments borrowed from other sources and reproduced, with permission, in this textbook appear on
            page CL-1.

            Many of the designations by manufacturers and seller to distinguish their products are claimed as trademarks. Where those
            designations appear in this book, and the publisher was aware of a trademark claim, the designations have been printed in
            initial caps or all caps.

            Pearson Education Limited
            Edinburgh Gate
            Harlow
            Essex CM20 2JE
            England

            and Associated Companies throughout the world

            Visit us on the World Wide Web at:
            www.pearsonglobaleditions.com

            © Pearson Education Limited 2018

            The right of William Stallings to be identified as the author of this work has been asserted by him in accordance with the
            Copyright, Designs and Patents Act 1988.

            Authorized adaptation from the United States edition, entitled Operating Systems: Internals and Design Principles, 9th Edition,
            ISBN 978-0-13-467095-9, by William Stallings published by Pearson Education © 2018.

            All rights reserved. No part of this publication may be reproduced, stored in a retrieval system, or transmitted in any form or
            by any means, electronic, mechanical, photocopying, recording or otherwise, without either the prior written permission of
            the publisher or a license permitting restricted copying in the United Kingdom issued by the Copyright Licensing Agency
            Ltd, Saffron House, 6–10 Kirby Street, London EC1N 8TS.

            All trademarks used herein are the property of their respective owners. The use of any trademark in this text does not vest in
            the author or publisher any trademark ownership rights in such trademarks, nor does the use of such trademarks imply any
            affiliation with or endorsement of this book by such owners.

            British Library Cataloguing-in-Publication Data
            A catalogue record for this book is available from the British Library

            10 9 8 7 6 5 4 3 2 1

            ISBN 10: 1-292-21429-5
            ISBN 13: 978-1-292-21429-0

            Typeset by SPi Global

            Printed and bound in Malaysia.




A01_STAL4290_09_GE_FM.indd 4                                                                                                                  5/9/17 4:40 PM

<!-- pág. 6 -->

                               For Tricia




A01_STAL4290_09_GE_FM.indd 5                5/9/17 4:40 PM

<!-- pág. 7 -->

                               This page intentionally left blank




A01_STAL4290_09_GE_FM.indd 1                                        5/19/17 9:06 PM

