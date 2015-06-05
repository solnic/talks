# Sample 06

require 'rom'
require 'rom/commands'
require 'ostruct'

ROM.setup(:sql, 'postgres://localhost/rom')

class CreateUser < ROM::Commands::Create[:sql]
  relation :users
  result :one
  register_as :create
end

rom = ROM.finalize.env

rom.gateways[:default].dataset(:users).delete
rom.gateways[:default].dataset(:users).insert(name: 'Jane', email: 'jane@doe.org')

create_user = rom.command(:users).create

puts create_user.call(name: 'Jane', email: 'jane@doe.org').inspect
# {:id=>5, :name=>"Jane", :email=>"jane@doe.org"}
