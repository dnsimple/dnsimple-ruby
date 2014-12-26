require 'dnsimple/client/certificates_main'

module Dnsimple
  class Client
    class CertificatesService < ClientService
      include CertificatesMain
    end
  end
end
