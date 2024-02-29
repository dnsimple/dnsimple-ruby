# Changelog

This project uses [Semantic Versioning 2.0.0](http://semver.org/).

## main

## 8.9.0

- NEW: Added `Dnsimple::Client::Registrar#restore_domain` to restore a domain. (dnsimple/dnsimple-ruby#379)
- NEW: Added `Dnsimple::Client::Registrar#get_domain_restore` to retrieve the details of an existing dommain restore. (dnsimple/dnsimple-ruby#379)

## 8.8.0

- NEW: Added `Dnsimple::Client::DnsAnalytics#query` to query and pull data from the DNS Analytics API endpoint(dnsimple/dnsimple-ruby#375)

## 8.7.1

ENHANCEMENTS:

- NEW: Added `#secondary`, `#last_transferred_at`, `#active` to `Dnsimple::Struct::Zone` (dnsimple/dnsimple-ruby)

## 8.7.0

FEATURES:

- NEW: Added `Dnsimple::Client::Billing#charges` to retrieve the list of billing charges for an account. (dnsimple/dnsimple-ruby#365)

## 8.6.0

FEATURES:

- NEW: Added `Dnsimple::Client::Registrar#get_domain_transfer_lock` to retrieves the transfer lock status of a registered domain. (dnsimple/dnsimple-ruby#356)
- NEW: Added `Dnsimple::Client::Registrar#enable_domain_transfer_lock` to enable the transfer lock for a registered domain. (dnsimple/dnsimple-ruby#356)
- NEW: Added `Dnsimple::Client::Registrar#disable_domain_transfer_lock` to disable the transfer lock for a registered domain. (dnsimple/dnsimple-ruby#356)

## 8.5.0

FEATURES:

- NEW: Added `Dnsimple::Client::Registrar#check_registrant_change` to retrieves the requirements of a registrant change. (dnsimple/dnsimple-ruby#355)
- NEW: Added `Dnsimple::Client::Registrar#get_registrant_change` to retrieves the details of an existing registrant change. (dnsimple/dnsimple-ruby#355)
- NEW: Added `Dnsimple::Client::Registrar#create_registrant_change` to start registrant change. (dnsimple/dnsimple-ruby#355)
- NEW: Added `Dnsimple::Client::Registrar#list_registrant_changes` to lists the registrant changes for a domain. (dnsimple/dnsimple-ruby#355)
- NEW: Added `Dnsimple::Client::Registrar#delete_registrant_change` to cancel an ongoing registrant change from the account. (dnsimple/dnsimple-ruby#355)

## 8.4.0

FEATURES:

- NEW: Added `Dnsimple::Client::Zones#activate_dns` to activate DNS services (resolution) for a zone. (dnsimple/dnsimple-ruby#354)
- NEW: Added `Dnsimple::Client::Zones#deactivate_dns` to deactivate DNS services (resolution) for a zone. (dnsimple/dnsimple-ruby#354)

## 8.3.1

- FIXED: Our release process had failed to push correctly `8.2.0` and `8.3.0` to RubyGems resulting in empty gem releases. This releases fixes the issue and contains the same changes of `8.2.0` and `8.3.0`.

## 8.3.0

- CHANGED: Wrap 400 errors on the OAuth endpoint in `Dnsimple::OAuthInvalidRequestError` (dnsimple/dnsimple-ruby#336)

## 8.2.0

- NEW: Added getDomainRenewal and getDomainRegistration endpoints (dnsimple/dnsimple-ruby#332)
- NEW: Documented the new `signature_algorithm` parameter for the Lets Encrypt certificate purchase endpoint (dnsimple/dnsimple-ruby#331)

## 8.1.0

- CHANGED: Fixed and updated documentation for domain endpoints (dnsimple/dnsimple-ruby#300)
- CHANGED: Expose all information available in error responses (dnsimple/dnsimple-ruby#298)

## 8.0.0

- CHANGED: Minimum Ruby version is now 2.7
- REMOVED: `registrar.getDomainPremiumPrice` in favour of `registrar.getDomainPrices`
- CHANGED: Deprecate Certificate's `contact_id` (dnsimple/dnsimple-ruby#276)
- FIXED: Remove stale reference to Client::DomainServicesService (dnsimple/dnsimple-ruby#267)

## 7.1.1

- CHANGED: Bumped up dependencies

## 7.1.0

- CHANGED: Updated DNSSEC-related structs and entrypoints to support DS record key-data interface. (dnsimple/dnsimple-ruby#252)

## 7.0.0

- CHANGED: Minimum Ruby version is now 2.6
- CHANGED: Deprecates `registrar.getDomainPremiumPrice` in favour of `registrar.getDomainPrices`

## 6.0.0

- NEW: Added `registrar.get_domain_prices` to retrieve whether a domain is premium and the prices to register, transfer, and renew. (dnsimple/dnsimple-ruby#230)
- REMOVED: `domain.reset_domain_token` endpoint no longer exists and the client method is removed. (dnsimple/dnsimple-ruby#231)
- REMOVED: The deprecated `Domain.expires_on` is removed. (dnsimple/dnsimple-ruby#232)
- REMOVED: The deprecated `Certificate.expires_on` is removed. (dnsimple/dnsimple-ruby#232)

## 5.2.0

- CHANGED: `Certificate#expires_on` (date only) is deprecated in favor of `Certificate#expires_at` (timestamp). (dnsimple/dnsimple-ruby#190)

## 5.1.0

- CHANGED: `Domain#expires_on` (date only) is deprecated in favor of `Domain#expires_at` (timestamp). (dnsimple/dnsimple-ruby#186)

## 5.0.0

- CHANGED: Minimum Ruby version is now 2.4
- CHANGED: User-agent format has been changed to prepend custom token before default token.
- NEW: Added `registrar.get_domain_transfer` to retrieve a domain transfer. (dnsimple/dnsimple-ruby#180)
- NEW: Added `registrar.cancel_domain_transfer` to cancel an in progress domain transfer. (dnsimple/dnsimple-ruby#180)
- NEW: Added `DomainTransfer#status_description` attribute to identify the failure reason of a transfer. (dnsimple/dnsimple-ruby#180).

## 4.6.0

- NEW: Added WHOIS privacy renewal (GH-171)

## 4.5.0

- NEW: Added zone distribution and zone record distribution (GH-160)

- CHANGED: Bump minimum Ruby requirement to 2.1
- CHANGED: Introduce Dnsimple::Struct::VanityNameServer (GH-144)
- CHANGED: Fix name inconsistency of the Collaborator module (GH-154)

- REMOVED: Removed extra alias (GH-168). You should use `dnsimple.foo.list_foo` instead of `dnsimple.foo.list`. Same for create/update. The change ensures consistency across the various clients. We prefer fully qualified methods.

## 4.4.0

- NEW: Added Let's Encrypt certificate methods (GH-159)

- REMOVED: Removed premium_price attribute from registrar order responses (GH-163). Please do not rely on that attribute, as it returned an incorrect value. The attribute is going to be removed, and the API now returns a null value.

## 4.3.0

- NEW: Added `certificates.all_certificates` (dnsimple/dnsimple-ruby#155)

- CHANGED: Updated registrar URLs (dnsimple/dnsimple-ruby#153)

## 4.2.0

- NEW: Added DNSSEC support support (dnsimple/dnsimple-ruby#152)

## 4.1.0

- NEW: Added domain premium price support (dnsimple/dnsimple-ruby#143)

- CHANGED: Updated registration, transfer, renewal response payload (dnsimple/dnsimple-developer#111, dnsimple/dnsimple-ruby#140).
- CHANGED: Normalize unique string identifiers to SID (dnsimple/dnsimple-ruby#141)

## 4.0.0

- NEW: Added domain collaborators support (GH-137).
- NEW: Added regions support for zone records (GH-135, GH-139).
- NEW: Added domain services support (GH-122).
- NEW: Added domain templates support (GH-125).
- NEW: Added zone file support (GH-124).
- NEW: Added certificate support (GH-123).
- NEW: Added domain delegation support (GH-120).
- NEW: Added domain push support (GH-127).
- NEW: Added vanity name server support (GH-121).

- CHANGED: Record struct renamed to ZoneRecord (GH-117).
- CHANGED: Updated Tld payload (GH-133, GH-129).
- CHANGED: Renamed registrar `auth_info` into `auth_code` (GH-136).

## 3.1.0

- NEW: Added accounts support (GH-113).
- NEW: Added sorting and filtering support (GH-112).
- NEW: Added template record support (GH-104).

- CHANGED: Pagination params must be passed as top level options. Previously they were passed inside `:query` options (GH-116).
- CHANGED: Authentication credentials presence is no longer validated on the client as it was causing an error getting the access token (GH-74 and GH-102).
- CHANGED: Setting a custom user-agent no longer overrides the original user-agent (GH-105).
- CHANGED: Updated client to use Contact#email (GH-108).

- REMOVED: Removed support for wildcard accounts (GH-107).

## 3.0.0

### stable

- FIXED: The client was using the wrong key to store the ContactsService which could cause conflicts with the DomainsService.

- FIXED: `renewDomain` used a wrong path (GH-96).

- NEW: Added registrar delegation support (GH-98).

- NEW: Added template support (GH-99).

- NEW: Added service support (GH-101).

- CHANGED: Error detection is now smarter. If the error is deserializable and contains a message, the message is attached to the exception (GH-94, GH-95, GH-100).

### beta2

- FIXED: `state` and `redirect_uri` are not properly passed in the request to exchang the code for an access token (GH-89, GH-90).

- FIXED: Request body is not properly serialized to JSON, and the "Content-Type" header was omissed (GH-91).

### beta1

- CHANGED: Minimum Ruby version >= 2

- CHANGED: Renamed `api_endpoint` to `base_url` to match the other clients.

The client has been completely redesigned to support the [API v2](https://developer.dnsimple.com/v2). Overall, the client behaves like the previous version, however it has been rewritten to leverage the API v2 features specifically.

Internal changes were made to match conventions adopted in other clients, such as the Go one and the Elixir one.

## 2.1.1

- FIXED: Paths may mistakenly be generated use \ on windows.

## 2.1.0

- NEW: Add the ability to set headers and pass extra connection params in each API method (GH-64)

## 2.0.0

### 2.0.0.alpha

2.0 is a complete client redesign.

- NEW: Add support changing name servers (GH-52). Thanks @rosscooperman

- NEW: Add support for all DNSimple API methods.

- CHANGED: Drop 1.8.7, 1.9.2 support. Required Ruby >= 1.9.3.

- CHANGED: This package no longer provides a CLI. The CLI has been extracted to [dnsimple-ruby-cli](https://github.com/dnsimple/dnsimple-ruby-cli)

- CHANGED: Renamed the Gem from "dnsimple-ruby" to "dnsimple" (GH-23).

- CHANGED: Renamed the namespace from DNSimple to Dnsimple.

- REMOVED: The library no longer provides built-in support for loading the credentials from a config file.

### 2.0

- FIXED: Fixed a bug where API token environment variables were not properly detected (GH-59, GH-62). Thanks @oguzbilgic and @rupurt.

## Release 1.7.1

- FIXED: Updated Certificate to match the serialized attributes (GH-53).

## Release 1.7.0

- NEW: Add support for Domain-based authentication (GH-40, GH-46). Thanks @dwradcliffe and @samsonasu.

## Release 1.6.0

- NEW: Add support for 2FA (GH-44)

## Release 1.5.5

- NEW: Add notice about the CLI moving to a new location

## Release 1.5.4

- NEW: Added domain#expires_on attribute (GH-34). Thanks @alkema

- NEW: Add various missing domain attributes (GH-38). Thanks @nickhammond

- NEW: Added support for auto-renewal (GH-36). Thanks @mzuneska

- CHANGED: User.me now uses the correct patch for API v1.

## Release 1.5.3

- FIXED: In some cases the client crashed with NoMethodError VERSION (GH-35).

## Release 1.5.2

- NEW: Provide a meaningful user-agent.

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
