# Changelog

## master

- CHANGED: Deprecated Dnsimple::Client.base_uri= in favor of Dnsimple::Client.site=.

- CHANGED: Normalized exception handling. No more RuntimeError.
  In case of request error, the client raises RequestError, RecordExists or RecodNotFound
  depending on the called method.

- CHANGED: Use Accept header to determine the request type instead of the .json suffix in the URL.

- CHANGED: Renamed commands to the ObjectAction scheme (e.g. CreateDomain became DomainCreate).

- FIXED: Cucumber was trying to execute steps on dnsimple.com main website instead of given site.

- REMOVED: Removed DomainError, UserNotFound, CertificateNotFound, CertificateExists error classes.
  See Error and RequestError.

- REMOVED: Removed DNSimple::Command base class.
