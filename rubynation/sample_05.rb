# Sample 01

require 'rom'
require 'rom/commands'
require 'ostruct'

ROM.setup(:sql, 'postgres://localhost/rom')

class Users < ROM::Relation[:sql]
  def by_name(name)
    where(name: name)
  end
end

rom = ROM.finalize.env

rom.gateways[:default].dataset(:users).delete
rom.gateways[:default].dataset(:users).insert(name: 'Jane', email: 'jane@doe.org')

users = rom.relation(:users)

puts users.by_name('Jane').call.inspect
# #<ROM::Relation::Loaded:0x007fc01bba25b0
#    @source=#<Users dataset=#<Sequel::Postgres::Dataset:
#      "SELECT * FROM \"users\" WHERE (\"name\" = 'Jane')">>,
#    @collection=[{:id=>1, :name=>"Jane", :email=>"jane@doe.org"}]>
