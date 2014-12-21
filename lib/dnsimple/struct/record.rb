module Dnsimple
  module Struct

    class Record < Base
      attr_accessor :id
      attr_accessor :domain_id
      attr_accessor :name
      attr_accessor :type
      attr_accessor :content
      attr_accessor :ttl
      attr_accessor :priority
      attr_accessor :created_at
      attr_accessor :updated_at

      alias :prio :priority
      alias :prio= :priority=
      alias :record_type :type
      alias :record_type= :type=
    end

  end
end
