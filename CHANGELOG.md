# Changelog

This project uses [Semantic Versioning 2.0.0](http://semver.org/).

## main

## 11.1.0 - 2025-09-25

### Added

- Added `Dnsimple::Client::ZonesRecords#batch_change_zone_records` to make changes to zone records in a batch. (#434)

## 11.0.0 - 2025-08-20

### Removed

- Removed `from` and `to` fields in `EmailForward`
- Removed `DomainCollaborators`

## 10.0.0 - 2025-05-02

### Changed

- Minimum Ruby version is now 3.2

## 9.0.1 - 2024-12-12

### Added

- Added `alias_email` and `destination_email` to `EmailForward`

### Deprecated

- Deprecated `from` and `to` fields in `EmailForward`
- `DomainCollaborators` have been deprecated and will be removed in the next major version. Please use our Domain Access Control feature.

## 9.0.0 - 2024-03-12

### Changed

- Minimum Ruby version is now 3.1

## 8.9.0 - 2024-02-29

### Added

- Added `Dnsimple::Client::Registrar#restore_domain` to restore a domain. (#379)
- Added `Dnsimple::Client::Registrar#get_domain_restore` to retrieve the details of an existing dommain restore. (#379)

## 8.8.0 - 2024-02-06

### Added

- Added `Dnsimple::Client::DnsAnalytics#query` to query and pull data from the DNS Analytics API endpoint(#375)

## 8.7.1 - 2023-11-22

### Added

- Added `#secondary`, `#last_transferred_at`, `#active` to `Dnsimple::Struct::Zone`

## 8.7.0 - 2023-11-03

### Added

- Added `Dnsimple::Client::Billing#charges` to retrieve the list of billing charges for an account. (#365)

## 8.6.0 - 2023-09-08

### Added

- Added `Dnsimple::Client::Registrar#get_domain_transfer_lock` to retrieves the transfer lock status of a registered domain. (#356)
- Added `Dnsimple::Client::Registrar#enable_domain_transfer_lock` to enable the transfer lock for a registered domain. (#356)
- Added `Dnsimple::Client::Registrar#disable_domain_transfer_lock` to disable the transfer lock for a registered domain. (#356)

## 8.5.0 - 2023-08-24

### Added

- Added `Dnsimple::Client::Registrar#check_registrant_change` to retrieves the requirements of a registrant change. (#355)
- Added `Dnsimple::Client::Registrar#get_registrant_change` to retrieves the details of an existing registrant change. (#355)
- Added `Dnsimple::Client::Registrar#create_registrant_change` to start registrant change. (#355)
- Added `Dnsimple::Client::Registrar#list_registrant_changes` to lists the registrant changes for a domain. (#355)
- Added `Dnsimple::Client::Registrar#delete_registrant_change` to cancel an ongoing registrant change from the account. (#355)

## 8.4.0 - 2023-08-10

### Added

- Added `Dnsimple::Client::Zones#activate_dns` to activate DNS services (resolution) for a zone. (#354)
- Added `Dnsimple::Client::Zones#deactivate_dns` to deactivate DNS services (resolution) for a zone. (#354)

## 8.3.1 - 2023-03-10

### Fixed

- Our release process had failed to push correctly `8.2.0` and `8.3.0` to RubyGems resulting in empty gem releases. This releases fixes the issue and contains the same changes of `8.2.0` and `8.3.0`.

## 8.3.0 - 2023-03-09

### Changed

- Wrap 400 errors on the OAuth endpoint in `Dnsimple::OAuthInvalidRequestError` (#336)

## 8.2.0 - 2023-03-02

### Added

- Added getDomainRenewal and getDomainRegistration endpoints (#332)
- Documented the new `signature_algorithm` parameter for the Lets Encrypt certificate purchase endpoint (#331)

## 8.1.0 - 2022-09-19

### Changed

- Fixed and updated documentation for domain endpoints (#300)
- Expose all information available in error responses (#298)

## 8.0.0 - 2022-08-10

### Changed

- Minimum Ruby version is now 2.7
- Deprecate Certificate's `contact_id` (#276)

### Removed

- `registrar.getDomainPremiumPrice` in favour of `registrar.getDomainPrices`

### Fixed

- Remove stale reference to Client::DomainServicesService (#267)

## 7.1.1 - 2022-01-20

### Changed

- Bumped up dependencies

## 7.1.0 - 2021-10-19

### Changed

- Updated DNSSEC-related structs and entrypoints to support DS record key-data interface. (#252)

## 7.0.0 - 2021-06-16

### Changed

- Minimum Ruby version is now 2.6

### Deprecated

- Deprecates `registrar.getDomainPremiumPrice` in favour of `registrar.getDomainPrices`

## 6.0.0 - 2021-04-20

### Added

- Added `registrar.get_domain_prices` to retrieve whether a domain is premium and the prices to register, transfer, and renew. (#230)

### Removed

- `domain.reset_domain_token` endpoint no longer exists and the client method is removed. (#231)
- The deprecated `Domain.expires_on` is removed. (#232)
- The deprecated `Certificate.expires_on` is removed. (#232)

## 5.2.0 - 2020-06-22

### Deprecated

- `Certificate#expires_on` (date only) is deprecated in favor of `Certificate#expires_at` (timestamp). (#190)

## 5.1.0 - 2020-06-10

### Deprecated

- `Domain#expires_on` (date only) is deprecated in favor of `Domain#expires_at` (timestamp). (#186)

## 5.0.0 - 2020-05-21

### Added

- Added `registrar.get_domain_transfer` to retrieve a domain transfer. (#180)
- Added `registrar.cancel_domain_transfer` to cancel an in progress domain transfer. (#180)
- Added `DomainTransfer#status_description` attribute to identify the failure reason of a transfer. (#180).

### Changed

- Minimum Ruby version is now 2.4
- User-agent format has been changed to prepend custom token before default token.

## 4.6.0 - 2019-02-01

### Added

- Added WHOIS privacy renewal (#171)

## 4.5.0 - 2018-10-16

### Added

- Added zone distribution and zone record distribution (#160)

### Changed

- Bump minimum Ruby requirement to 2.1
- Introduce Dnsimple::Struct::VanityNameServer (#144)
- Fix name inconsistency of the Collaborator module (#154)

### Removed

- Removed extra alias (#168). You should use `dnsimple.foo.list_foo` instead of `dnsimple.foo.list`. Same for create/update. The change ensures consistency across the various clients. We prefer fully qualified methods.

## 4.4.0 - 2018-01-23

### Added

- Added Let's Encrypt certificate methods (#159)

### Removed

- Removed premium_price attribute from registrar order responses (#163). Please do not rely on that attribute, as it returned an incorrect value. The attribute is going to be removed, and the API now returns a null value.

## 4.3.0 - 2017-06-20

### Added

- Added `certificates.all_certificates` (#155)

### Changed

- Updated registrar URLs (#153)

## 4.2.0 - 2017-03-07

### Added

- Added DNSSEC support support (#152)

## 4.1.0 - 2016-12-12

### Added

- Added domain premium price support (#143)

### Changed

- Updated registration, transfer, renewal response payload (dnsimple/dnsimple-developer#111, #140).
- Normalize unique string identifiers to SID (#141)

## 4.0.0 - 2016-11-25

### Added

- Added domain collaborators support (#137).
- Added regions support for zone records (#135, #139).
- Added domain services support (#122).
- Added domain templates support (#125).
- Added zone file support (#124).
- Added certificate support (#123).
- Added domain delegation support (#120).
- Added domain push support (#127).
- Added vanity name server support (#121).

### Changed

- Record struct renamed to ZoneRecord (#117).
- Updated Tld payload (#133, #129).
- Renamed registrar `auth_info` into `auth_code` (#136).

## 3.1.0 - 2016-06-21

### Added

- Added accounts support (#113).
- Added sorting and filtering support (#112).
- Added template record support (#104).

### Changed

- Pagination params must be passed as top level options. Previously they were passed inside `:query` options (#116).
- Authentication credentials presence is no longer validated on the client as it was causing an error getting the access token (#74 and #102).
- Setting a custom user-agent no longer overrides the original user-agent (#105).
- Updated client to use Contact#email (#108).

### Removed

- Removed support for wildcard accounts (#107).

## 3.0.0 - 2016-04-19

### Added

- Added registrar delegation support (#98).
- Added template support (#99).
- Added service support (#101).

### Changed

- Minimum Ruby version >= 2
- Renamed `api_endpoint` to `base_url` to match the other clients.
- Error detection is now smarter. If the error is deserializable and contains a message, the message is attached to the exception (#94, #95, #100).

### Fixed

- The client was using the wrong key to store the ContactsService which could cause conflicts with the DomainsService.
- `renewDomain` used a wrong path (#96).
- `state` and `redirect_uri` are not properly passed in the request to exchang the code for an access token (#89, #90).
- Request body is not properly serialized to JSON, and the "Content-Type" header was omissed (#91).

The client has been completely redesigned to support the [API v2](https://developer.dnsimple.com/v2). Overall, the client behaves like the previous version, however it has been rewritten to leverage the API v2 features specifically.

Internal changes were made to match conventions adopted in other clients, such as the Go one and the Elixir one.

## 2.1.1 - 2015-11-30

### Fixed

- Paths may mistakenly be generated use \ on windows.

## 2.1.0 - 2015-09-04

### Added

- Add the ability to set headers and pass extra connection params in each API method (#64)

## 2.0.0 - 2015-06-25

### Added

- Add support changing name servers (#52). Thanks @rosscooperman
- Add support for all DNSimple API methods.

### Changed

- Drop 1.8.7, 1.9.2 support. Required Ruby >= 1.9.3.
- This package no longer provides a CLI. The CLI has been extracted to [dnsimple-ruby-cli](https://github.com/dnsimple/dnsimple-ruby-cli)
- Renamed the Gem from "dnsimple-ruby" to "dnsimple" (#23).
- Renamed the namespace from DNSimple to Dnsimple.

### Removed

- The library no longer provides built-in support for loading the credentials from a config file.

### Fixed

- Fixed a bug where API token environment variables were not properly detected (#59, #62). Thanks @oguzbilgic and @rupurt.

## 1.7.1 - 2014-12-13

### Fixed

- Updated Certificate to match the serialized attributes (#53).

## 1.7.0 - 2014-09-29

### Added

- Add support for Domain-based authentication (#40, #46). Thanks @dwradcliffe and @samsonasu.

## 1.6.0 - 2014-09-20

### Added

- Add support for 2FA (#44)

## 1.5.5 - 2014-09-05

### Added

- Add notice about the CLI moving to a new location

## 1.5.4 - 2014-07-01

### Added

- Added domain#expires_on attribute (#34). Thanks @alkema
- Add various missing domain attributes (#38). Thanks @nickhammond
- Added support for auto-renewal (#36). Thanks @mzuneska

### Changed

- User.me now uses the correct patch for API v1.

## 1.5.3 - 2014-01-26

### Fixed

- In some cases the client crashed with NoMethodError VERSION (#35).

## 1.5.2 - 2014-01-15

### Added

- Provide a meaningful user-agent.

## 1.5.1 - 2014-01-14

### Fixed

- Invalid base URI.

## 1.5.0 - 2014-01-14

### Changed

- Added support for versioned API (#33)

## 1.4.0 - 2013-04-18

### Changed

- Normalized exception handling. No more RuntimeError. In case of request error, the client raises RequestError, RecordExists or RecodNotFound depending on the called method.
- Use Accept header to determine the request type instead of the .json suffix in the URL.
- Renamed commands to the ObjectAction scheme (e.g. CreateDomain became DomainCreate).
- Removed DomainError, UserNotFound, CertificateNotFound, CertificateExists error classes. See Error and RequestError.
- Removed DNSimple::Command base class.

### Fixed

- Cucumber was trying to execute steps on dnsimple.com main website instead of given site.
- We're no longer accepting route format. Use the correct header.
