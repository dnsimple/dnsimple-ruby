require 'dnsimple/client/users_main'

module Dnsimple
  class Client
    class UsersService < ClientService
      include UsersMain
   end
  end
end
