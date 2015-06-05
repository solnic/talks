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

jane_tasks = users.by_name('Jane') >> tasks.for_users

puts jane_tasks.to_a.inspect
# [{:user=>"Jane", :title=>"Task One"}]
