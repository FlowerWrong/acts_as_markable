module ActsAsMarkable
  module Marker
    extend ActiveSupport::Concern
 
    included do
      # 类方法
      def self.marked(mark, options = {})
        # self = User
        by = options[:by]
        if by.present?
          result = self.joins(:marker_marks).where({
            :marks => {
              :mark => mark.to_s,
              :markable_id => by.id,
              :markable_type => by.class.name
            }
          })
        else
          result = self.joins(:markable_marks).where(:marks => { :mark => mark.to_s }).group("#{self.table_name}.id")
        end
        result
      end
    end

    # 类方法
    module ClassMethods
      def acts_as_marker(options = {})
        ActsAsMarkable.set_models
        class_eval do
          class << self
            attr_accessor :marker_name
          end
        end
        self.marker_name = self.name.downcase.to_sym
        # self => User(id: integer, name: string, created_at: datetime, updated_at: datetime)
        ActsAsMarkable.add_marker self

        class_eval do
          has_many :marker_marks, class_name: 'ActsAsMarkable::Mark',
                                  as: :marker,
                                  dependent: :delete_all
        end

        include ActsAsMarkable::Marker::LocalInstanceMethods
      end
    end

    # 实例方法
    module LocalInstanceMethods
      # user.set_mark :favorite, [pizza, food]
      def set_mark(mark, markables)
        Array.wrap(markables).each do |markable|
          # mark, eg: favorite
          ActsAsMarkable.can_mark_or_raise? self, markable, mark
          markable.mark_as mark, self
        end
      end

      # user.remove_mark :favorite, [food1, food2]
      def remove_mark(mark, markables)
        ActsAsMarkable.can_mark_or_raise? self, markables, mark
        Array.wrap(markables).each do |markable|
          markable.unmark mark, :by => self
        end
      end      
    end
  end
end

ActiveRecord::Base.send :include, ActsAsMarkable::Marker