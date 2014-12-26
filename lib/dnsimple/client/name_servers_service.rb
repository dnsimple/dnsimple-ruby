require 'dnsimple/client/name_servers_main'

module Dnsimple
  class Client
    class NameServersService < ClientService
      include NameServersMain
    end
  end
end
