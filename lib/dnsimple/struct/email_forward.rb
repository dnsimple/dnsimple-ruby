module Dnsimple
  module Struct

    class EmailForward < Base
      attr_accessor :id
      attr_accessor :domain_id
      attr_accessor :from
      attr_accessor :to
      attr_accessor :created_at
      attr_accessor :updated_at
    end

  end
end
