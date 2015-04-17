require 'test_helper'

class MarkableTest < ActiveSupport::TestCase

  # markable mark_as
  test 'food should like by user' do
    food = Food.create(name: 'mian')
    user1 = User.create(name: 'yangkang')
    user2 = User.create(name: 'chenhan')
    food.mark_as :favorite, [user1, user2]
    assert_equal 2, User.all.count
    assert_equal 1, Food.all.count
    assert_equal 2, ActsAsMarkable::Mark.all.count
  end

  # markable marked_as?
  test 'food marked_as? favorite by user' do
    food = Food.create(name: 'mian')
    user = User.create(name: 'yangkang')
    food.mark_as :favorite, [user]
    assert_equal 1, ActsAsMarkable::Mark.all.count
    assert_equal true, food.marked_as?(:favorite, by: user)
  end

  # markable unmark
  test 'food should unmark by user' do
    food = Food.create(name: 'mian')
    user = User.create(name: 'yangkang')
    food.mark_as :favorite, [user]
    assert_equal 1, ActsAsMarkable::Mark.all.count
    assert_equal true, food.marked_as?(:favorite, by: user)

    food.unmark :favorite, by: user
    assert_equal 0, ActsAsMarkable::Mark.all.count
    assert_equal false, food.marked_as?(:favorite, by: user)
  end

  test 'should get all food marked_as favorite by user' do
    pizza = Food.create(name: 'pizza')
    user = User.create(name: 'yangkang')
    user.set_mark :favorite, pizza
    assert_equal 1, ActsAsMarkable::Mark.all.count
    assert_equal true, pizza.marked_as?(:favorite, by: user)

    food = Food.create(name: 'food')
    food.mark_as :favorite, [user]
    assert_equal 2, ActsAsMarkable::Mark.all.count
    assert_equal true, food.marked_as?(:favorite, by: user)

    foods = Food.marked_as :favorite, by: user
    assert_equal 2, foods.count
  end

  test "a food's markable_marks[:favorite] should not be nil" do
    assert_not_nil Food.__markable_marks[:favorite]
    assert_nil Food.__markable_marks[:hated]
  end

  test "a food's markable_marks[:favorite][:allowed_markers] should be :all" do
    assert_equal :all, Food.__markable_marks[:favorite][:allowed_markers]
  end

  test "a drink's markable_marks[:favorite][:allowed_markers] should be [:user]" do
    assert_equal [:user], Drink.__markable_marks[:favorite][:allowed_markers]
  end

  test 'a user can not mark the food as hite' do
    food = Food.create(name: 'mian')
    user = User.create(name: 'yangkang')
    food.mark_as :favorite, [user]
    assert_equal 1, ActsAsMarkable::Mark.all.count
    assert_raise(ActsAsMarkable::WrongMark) {
      food.mark_as :hite, [user]
    }
  end

  # need to solve
  test "markables can't be marked by not allowed markers" do
    marker = Admin.create :name => 'marker'
    markable = Drink.create :name => 'markable'

    assert_raise(ActsAsMarkable::NotAllowedMarker) {
      marker.set_mark :favorite, markable
    }
    assert_raise(ActsAsMarkable::NotAllowedMarker) {
      markable.mark_as :favorite, marker
    }
  end
end