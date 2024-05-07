VERSION="00"

all: build

build:
	@mmark draft-brown-rdap-registrar-link.md > draft-brown-rdap-registrar-link-$(VERSION).xml 
	@xml2rfc --html draft-brown-rdap-registrar-link-$(VERSION).xml
