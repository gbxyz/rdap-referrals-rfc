# Providing efficient referrals to registrar RDAP records

This document outlines how an RDAP server can use the HTTP `Link` header field
to efficiently refer RDAP clients to the sponsoring registrar's RDAP record for
a domain name or other resource.

## Generating the draft

Run `make`. You will need [mmark](https://mmark.miek.nl) and
[xml2rfc](https://pypi.org/project/xml2rfc/).

# Copyright Notice

Copyright (c) 2024 IETF Trust and the persons identified as the document
authors. All rights reserved.

This document is subject to BCP 78 and the IETF Trust's Legal Provisions
Relating to IETF Documents (<https://trustee.ietf.org/license-info>) in effect
on the date of publication of this document. Please review these documents
carefully, as they describe your rights and restrictions with respect to this
document. Code Components extracted from this document must include Revised BSD
License text as described in Section 4.e of the Trust Legal Provisions and are
provided without warranty as described in the Revised BSD License.
