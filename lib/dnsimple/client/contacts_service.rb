require 'dnsimple/client/contacts_main'

module Dnsimple
  class Client
    class ContactsService < ClientService
      include ContactsMain
    end
  end
end
