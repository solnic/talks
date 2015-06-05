# Sample 01

require 'rom'
require 'rom/commands'
require 'ostruct'

class Users < ROM::Relation
  forward :select

  def by_name(name)
    select { |user| user[:name] == name }
  end

  def exposed_relations
    [:by_name]
  end
end

class Tasks < ROM::Relation
  forward :select

  def for_users(users)
    user_names = users.map { |user| user[:name] }
    select { |task| user_names.include?(task[:user]) }
  end

  def exposed_relations
    [:for_users]
  end
end

class UserMapper < ROM::Mapper
  model OpenStruct

  attribute :name
  attribute :email

  combine :tasks, on: { name: :user } do
    model OpenStruct

    attribute :user
    attribute :title
  end
end

user_dataset = [
  { name: 'Jane', email: 'jane@doe.org' },
  { name: 'John', email: 'john@doe.org' }
]

task_dataset = [
  { user: 'Jane', title: 'Task One' },
  { user: 'John', email: 'Task Two' }
]

users = Users.new(user_dataset).to_lazy
tasks = Tasks.new(task_dataset).to_lazy

mapper = UserMapper.build

jane_with_tasks = (users
  .by_name('Jane')
  .combine(tasks.for_users) >> mapper).one

puts jane_with_tasks.inspect
# #<OpenStruct name="Jane", email="jane@doe.org", tasks=[#<OpenStruct user="Jane", title="Task One">]>
