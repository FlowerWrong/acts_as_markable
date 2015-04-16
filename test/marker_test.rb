require 'test_helper'

class MarkerTest < ActiveSupport::TestCase
  # marker set_mark
  test 'user should mark pizza as favorite' do
    pizza = Food.create(name: 'mian')
    user = User.create(name: 'yangkang')
    user.set_mark :favorite, pizza
    assert_equal 1, ActsAsMarkable::Mark.all.count
    assert_equal true, pizza.marked_as?(:favorite, by: user)
  end

  # marker remove_mark
  test 'user should remove_mark for pizza and food' do
    pizza = Food.create(name: 'pizza')
    user = User.create(name: 'yangkang')
    user.set_mark :favorite, pizza
    assert_equal 1, ActsAsMarkable::Mark.all.count
    assert_equal true, pizza.marked_as?(:favorite, by: user)

    food = Food.create(name: 'food')
    food.mark_as :favorite, [user]
    assert_equal 2, ActsAsMarkable::Mark.all.count
    assert_equal true, food.marked_as?(:favorite, by: user)

    user.remove_mark :favorite, [pizza, food]
    assert_equal 0, ActsAsMarkable::Mark.all.count
    assert_equal false, pizza.marked_as?(:favorite, by: user)
  end

  test 'should get all user marked favorite by food' do
    pizza = Food.create(name: 'pizza')
    user = User.create(name: 'yangkang')
    user2 = User.create(name: 'chenhan')
    user.set_mark :favorite, pizza
    assert_equal 1, ActsAsMarkable::Mark.all.count
    assert_equal true, pizza.marked_as?(:favorite, by: user)

    food = Food.create(name: 'food')
    food.mark_as :favorite, [user, user2]
    assert_equal 3, ActsAsMarkable::Mark.all.count
    assert_equal true, food.marked_as?(:favorite, by: user)
    assert_equal true, food.marked_as?(:favorite, by: user2)

    food_whos = User.marked :favorite, by: food
    assert_equal 2, food_whos.count
    pizza_whos = User.marked :favorite, by: pizza
    assert_equal 1, pizza_whos.count
  end
end