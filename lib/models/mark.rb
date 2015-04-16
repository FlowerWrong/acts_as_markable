module ActsAsMarkable
  class Mark < ActiveRecord::Base
    belongs_to :markable, :polymorphic => true
    belongs_to :marker, :polymorphic => true
  end
end