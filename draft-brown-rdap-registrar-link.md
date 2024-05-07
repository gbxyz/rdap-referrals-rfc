%%%
title = "Providing efficient referrals to registrar RDAP records"
abbrev = "RDAP Registrar Links"
ipr = "trust200902"
area = "Internet"
workgroup = "Registration Protocols Extensions (regext)"
consensus = true

[seriesInfo]
name = "Internet-Draft"
value = "draft-brown-rdap-registrar-link"
stream = "IETF"
status = "standard"

[[author]]
fullname="Gavin Brown"
organization = "ICANN"
  [author.address]
  email = "gavin.brown@icann.org"
  uri = "https://icann.org"
  [author.address.postal]
  street = "12025 Waterfront Drive, Suite 300"
  city = "Los Angeles"
  region = "CA"
  code = "90292"
  country = "US"
%%%

.# Abstract

This document outlines how an RDAP server can efficiently refer RDAP clients to
the sponsoring registrar's RDAP record for a domain name or other resource using
the HTTP `Link` header field.

{mainmatter}

# Introduction

In the Registry-Registrar-Registrant model that prevails in the domain name
provisioning ecosystem, and particularly within "thin" top-level domains (where
the registry only provides the minimal set of public registration data), users
of the Registration Data Access Policy ([@!STD95]) are often equally if not more
interested in the RDAP record provided by the sponsoring registrar of a domain
name (or other resource) than that of the registry.

While RDAP supports redirection of RDAP requests using HTTP redirections (which
use a `3xx` HTTP status and the `Location` header field) see ([@!RFC9110,
Section 15.4 of RFC 9110]), it is not possible for RDAP servers to know _a
priori_ whether a client requesting an RDAP record is doing so in order to
determine the URL of the sponsoring registrar's RDAP record, or its own, so it
can only respond by providing the full RDAP record, which the client must then
parse in order to extract the relevant URL from the `links` property of the
record.

This results in the wasteful expenditure of time, compute resources and
bandwidth on the part of both the client and server.

This document describes how an RDAP server can use the `Link` HTTP header field
in responses to `HEAD` and `GET` requests to provide RDAP clients with the URL
of the registrar's RDAP record, without the need for a signalling mechanism for
the client to tell the server that it is only interested in retrieving the URL
of the sponsoring registrar's RDAP record.

# HTTP `Link` Header Field

Example:

```
Link: <https://rdap.example.com/domain/example.org>;
        rel="related";
        type="application/rdap+json";
        title="URL of Sponsoring Registrar's RDAP Record"
```

# RDAP Conformance

Servers which implement this specification **MUST** include the string
"`registrar_link_header`" in the `rdapConformance` array in all RDAP responses.

# IANA Considerations

IANA is requested to register the following value in the RDAP Extensions
Registry:

**Extension identifier:**
: `registrar_link_header`

**Registry operator:**
: any

**Published specification:**
: this document

**Contact:**
: IETF <<iesg@ietf.org>>

**Intended usage:**
: this extension indicates that the server provides the URL of the registrar's
RDAP record in a `Link` header in responses to RDAP queries.

{backmatter}
