# Changelog

## Release 1.5.1

- FIXED: Invalid base URI.

## Release 1.5.0

- CHANGED: Added support for versioned API (GH-33)

## Release 1.4.0

- CHANGED: Normalized exception handling. No more RuntimeError.
  In case of request error, the client raises RequestError, RecordExists or RecodNotFound
  depending on the called method.

- CHANGED: Use Accept header to determine the request type instead of the .json suffix in the URL.

- CHANGED: Renamed commands to the ObjectAction scheme (e.g. CreateDomain became DomainCreate).

- CHANGED: Removed DomainError, UserNotFound, CertificateNotFound, CertificateExists error classes.
  See Error and RequestError.

- CHANGED: Removed DNSimple::Command base class.

- FIXED: Cucumber was trying to execute steps on dnsimple.com main website instead of given site.

- FIXED: We're no longer accepting route format. Use the correct header.
