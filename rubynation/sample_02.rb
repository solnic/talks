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

  def exposed_relations
    [:by_name]
  end
end

class UserMapper < ROM::Mapper
  model OpenStruct

  attribute :name
  attribute :email
end

class CreateUser < ROM::Commands::Create
  def execute(tuples)
    tuples.each { |tuple| relation << tuple }
  end
end

mapper = UserMapper.build
users = Users.new(dataset).to_lazy

mapped_users = users.by_name('Jane') >> mapper

puts mapped_users.call.to_a.inspect
# [#<OpenStruct name="Jane", email="jane@doe.org">]

users = Users.new([])
create_user = CreateUser.new(users)

create_mapped_users = create_user
  .with([{ name: 'Jade', email: 'jade@doe.org' }]) >> mapper

puts create_mapped_users.call.inspect
# [#<OpenStruct name="Jade", email="jade@doe.org">]
