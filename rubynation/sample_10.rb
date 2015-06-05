# Sample 10

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
          attr_reader :relation, :mapper
        end
        setup!
      end
    end

    module ClassMethods
      def where(*args)
        relation.where(*args)
      end

      def setup!
        set_mapper
        set_relation
        set_interface
        set_attributes
      end

      def set_interface
        relation.exposed_relations << :where << :columns
      end

      def set_attributes
        mod = Module.new { include Virtus.module }
        relation.columns.each { |column| mod.attribute(column) }
        include(mod)
      end

      def set_relation
        @relation = env.relation(table_name) >> mapper
      end

      def set_mapper
        @mapper = -> users { users.map { |user| new(user) } }
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
#<User:0x007fd57493f200 @id=12, @name="Jane", @email="jane@doe.org">
