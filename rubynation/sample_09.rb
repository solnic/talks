# Sample 09

require 'rom'
require 'rom/commands'
require 'virtus'

ROM.setup(:sql, 'postgres://localhost/rom')
ROM.finalize

module ActiveRecord
  class Base
    def self.inherited(klass)
      super
      klass.class_eval do
        extend(ClassMethods)
        class << self
          attr_reader :relation
        end
        setup!
      end
    end

    module ClassMethods
      def where(*args)
        relation.where(*args)
      end

      def setup!
        set_relation
        set_interface
      end

      def set_interface
        relation.exposed_relations << :where
      end

      def set_relation
        @relation = env.relation(table_name) >> mapper
      end

      def table_name
        Inflecto.tableize(name).to_sym
      end

      def env
        ROM.env
      end
    end
  end
end

class User < ActiveRecord::Base
end

user = User.where(name: 'Jane').first

puts user.inspect
# {:id=>1, :name=>"Jane", :email=>"jane@doe.org"}
