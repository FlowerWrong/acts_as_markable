= ActsAsMarkable

This project rocks and uses MIT-LICENSE.

#### install

```ruby
gem 'acts_as_markable', github: 'FlowerWrong/acts_as_markable', branch: 'master'
bundle install
rails generate acts_as_markable:migration
rake db:migrate
```

#### Usage

```ruby
# model
class User < ActiveRecord::Base
  acts_as_marker
end

class Food < ActiveRecord::Base
  acts_as_markable [:favorite]  # array
end

pizza = Food.create(name: 'pizza')
user = User.create(name: 'yangkang')
food = Food.create(name: 'mian')

# mark
user.set_mark :favorite, pizza
# or
food.mark_as :favorite, [user]  # array

# unmark
user.remove_mark :favorite, [pizza, food]
# or
food.unmark :favorite, by: user

# marks
foods = Food.marked_as :favorite, by: user

# whos marked the food
food_whos = User.marked :favorite, by: food
```