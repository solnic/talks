# Sample 07

require 'rom'
require 'rom/commands'
require 'ostruct'

ROM.setup(:sql, 'postgres://localhost/rom')

class UserMapper < ROM::Mapper
  relation :users
  register_as :entity

  model OpenStruct
end

rom = ROM.finalize.env

rom.gateways[:default].dataset(:users).delete
rom.gateways[:default].dataset(:users).insert(name: 'Jane', email: 'jane@doe.org')

user_entities = rom.relation(:users).map_with(:entity)

puts user_entities.to_a.inspect
# [#<OpenStruct id=6, name="Jane", email="jane@doe.org"]
