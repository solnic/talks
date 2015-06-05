# Sample 01

require 'rom'
require 'rom/commands'
require 'ostruct'

dataset = [
  { name: 'Jane', email: 'jane@doe.org' },
  { name: 'John', email: 'john@doe.org' }
]

class Users < ROM::Relation
  forward :select, :<<

  def by_name(name)
    select { |user| user[:name] == name }
  end

  def count
    dataset.size
  end
end

users = Users.new(dataset)

puts users.by_name('Jane').inspect
# #<Users dataset=[{:name=>"Jane", :email=>"jane@doe.org"}]>

class UserMapper < ROM::Mapper
  model OpenStruct

  attribute :name
  attribute :email
end

mapper = UserMapper.build

puts mapper.call(dataset).inspect
# #<OpenStruct name="Jane", email="jane@doe.org">, #<OpenStruct name="John", email="john@doe.org">]

puts users.count

class CreateUser < ROM::Commands::Create
  def execute(tuples)
    tuples.each { |tuple| relation << tuple }
  end
end

users = Users.new([])

create_user = CreateUser.build(users)

create_user.call([{ name: 'Jane', email: 'jane@doe.org' }])

puts users.inspect
# #<Users dataset=[{:name=>"Jane", :email=>"jane@doe.org"}]>
