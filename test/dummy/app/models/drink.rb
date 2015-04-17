class Drink < ActiveRecord::Base
  acts_as_markable [:favorite], by: :user
end
