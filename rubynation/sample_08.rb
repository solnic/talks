# Sample 07

require 'rom'
require 'rom/commands'
require 'ostruct'

ROM.setup(:sql, 'postgres://localhost/rom')

class Users < ROM::Relation[:sql]
  def with_tasks
    left_join(:tasks, user_id: :id)
      .select(:users__id, :users__name, :tasks__title)
  end
end

class UserMapper < ROM::Mapper
  relation :users
  register_as :user_with_tasks

  wrap :tasks do
    attribute :title
  end
end

rom = ROM.finalize.env

rom.gateways[:default].dataset(:users).delete
id = rom.gateways[:default].dataset(:users).insert(name: 'Jane', email: 'jane@doe.org')
rom.gateways[:default].dataset(:tasks).insert(user_id: id, title: 'Task One')

users = rom.relation(:users)

user_with_tasks = users.with_tasks.map_with(:user_with_tasks)

puts user_with_tasks.to_a.inspect
# [{:id=>1, :name=>"Jane", :tasks=>{:title=>"Task One"}}]
