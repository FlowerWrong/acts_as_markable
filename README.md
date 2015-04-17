= ActsAsMarkable

This project rocks and uses MIT-LICENSE. And no `method_missing` and `dynamic method`.

#### Note

If you are using `rails < 4`, see [markable](https://github.com/chrome/markable) by chrome.

#### Install

```ruby
gem 'acts_as_markable', github: 'FlowerWrong/acts_as_markable', branch: 'master'
bundle install
rails generate acts_as_markable:migration
rake db:migrate
```

#### Basic Usage

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
user.set_mark :favorite, [pizza, food]  # array
# or
food.mark_as :favorite, [user]  # array

# unmark
user.remove_mark :favorite, [pizza, food]
# or
food.unmark :favorite, by: user  # by can be an array

# marks
foods = Food.marked_as :favorite, by: user  # by can not be an array

# whos marked the food
food_whos = User.marked :favorite, by: food  # by can not be an array

# marked_as?
food.marked_as? :favorite, by: user  # by can not be an array
```

#### User follower

```ruby
class User < ActiveRecord::Base
  acts_as_marker
  acts_as_markable :following, by: :user
end
```

#### User Friend

```ruby
class User < ActiveRecord::Base
  acts_as_marker
  markable_as :friendly, by: :user
end
```