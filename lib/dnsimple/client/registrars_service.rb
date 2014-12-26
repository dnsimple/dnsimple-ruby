require 'dnsimple/client/registrars_main'

module Dnsimple
  class Client
    class RegistrarsService < ClientService
      include RegistrarsMain
    end
  end
end
