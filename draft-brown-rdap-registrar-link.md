%%%
title = "Efficient RDAP Registrar Referrals"
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

This document outlines how RDAP servers can provide the HTTP `Link` header
fields in RDAP responses to allow RDAP clients to efficiently determine the URL
of the sponsoring registrar's RDAP record for a domain name or other resource.

{mainmatter}

# Introduction

In the Registry-Registrar-Registrant model ("RRR model") that prevails in the
domain name provisioning ecosystem, and particularly within "thin" top-level
domains (where the registry only provides the minimal set of public registration
data), users of the Registration Data Access Protocol (RDAP, described in
[@!RFC7480], [@!RFC7481], [@!RFC9082], [@!RFC9083] and others) are often equally
if not more interested in the RDAP record provided by the sponsoring registrar
of a domain name (or other resource) than that provided by the registry.

While RDAP supports redirection of RDAP requests using HTTP redirections (which
use a `3xx` HTTP status and the `Location` header field, see Section 15.4 of
[@!RFC9110]), it is not possible for RDAP servers to know _a priori_ whether a
client requesting an RDAP record is doing so because it wants to retrieve the
sponsoring registrar's RDAP record, or its own, so it can only respond by
providing the full RDAP response. The client must then parse that response in
order to extract the relevant URL from the `links` property of the object.

This results in the wasteful expenditure of time, compute resources and
bandwidth on the part of both the client and server.

This document describes how an RDAP server can use the `Link` HTTP header field
in responses to `HEAD` and `GET` requests to provide RDAP clients with the URL
of the registrar's RDAP record, without the need for a signalling mechanism for
the client to tell the server that it is only interested in retrieving the URL
of the sponsoring registrar's RDAP record.

# HTTP `Link` Header Field

`Link` header fields, described in Section 3 of [@!RFC8288],
provide a means for describing a relationship between two resources, generally
between the requested resource and some other resource. The `Link` header field
is semantically equivalent to the `<link>` element in HTML, and multiple `Link`
headers may be present in the header of an HTTP response.

`Link` header fields may contain most of the parameters that are also present in
Link objects in RDAP responses (See Section 4.2 of [@!RFC9083]). So for example,
an RDAP link object which has the following JSON representation:

```json
{
  "value" : "https://example.com/context_uri",
  "rel" : "self",
  "href" : "https://example.com/target_uri",
  "hreflang" : [ "en", "ch" ],
  "title" : "title",
  "media" : "screen",
  "type" : "application/json"
}
```

may be represented as follows:

```
Link: <https://example.com/target_uri>;
  rel="self";
  hreflang="en,ch";
  title="title";
  media="screen";
  type="application/json"
```

## Registrar RDAP `Link` Header

Following on from the above, the following RDAP link object (which represents
the RDAP URL of the sponsoring registrar of a resource):

```json
{
  "value": "https://rdap.example.com/domain/example.com",
  "title": "URL of Sponsoring Registrar's RDAP Record",
  "rel": "related",
  "href": "https://rdap.example.com/domain/example.com",
  "type": "application/rdap+json"
}
```

may be represented as follows:

```
Link: <https://rdap.example.com/domain/example.com>;
  title="URL of Sponsoring Registrar's RDAP Record";
  rel="related";
  type="application/rdap+json"
```

# RDAP Responses

In response to `GET` and `HEAD` RDAP requests, RDAP servers which implement this
specification **MUST** include a `Link` header field representing the registrar
RDAP URL for the object in question. This field **MUST NOT** be included if the
RDAP record does not include a corresponding link object. If present, the values
of the link properties **MUST** be the same in both places.

## RDAP `HEAD` requests

The HTTP `HEAD` method can be used for obtaining metadata about a resource
without transferring that resource (see Section 4.3.2 of [@!RFC7231]).

An RDAP client which only wishes to retrieve the registrar's RDAP record can
issue a `HEAD` request for an RDAP resource and check the response for the
presence of an appropriate `Link` header field. If the link is absent, it may
then fall back to performing a `GET` request.

An RDAP client interested in both records can use the traditional method of
performing a `GET` request and extracting the link object from the response.
However, to improve performance, RDAP clients **MAY** inspect the header of a
response, extract the link header, and issue a request for the registrar record
in parallel while the request to the registry is still in flight. As an example,
the cURL library provides the
[CURLOPT_HEADERFUNCTION](https://curl.se/libcurl/c/CURLOPT_HEADERFUNCTION.html)
configuration option to provide a callback that is invoked as soon as it has
received header data.

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
