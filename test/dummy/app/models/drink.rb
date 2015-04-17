class Drink < ActiveRecord::Base
  acts_as_markable [:favorite], by: :admin
end
