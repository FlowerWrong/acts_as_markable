class Food < ActiveRecord::Base
  acts_as_markable [:favorite]
end
