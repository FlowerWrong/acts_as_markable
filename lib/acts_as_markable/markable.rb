module ActsAsMarkable
  module Markable
    extend ActiveSupport::Concern
 
    included do
      # 类方法
      def self.marked_as(mark, options = {})
        # self = Food(id: integer, name: string, created_at: datetime, updated_at: datetime)
        by = options[:by]
        if by.present?
          result = self.joins(:markable_marks).where({
            :marks => {
              :mark => mark.to_s,
              :marker_id => by.id,
              :marker_type => by.class.name
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
      # args = [ :hated, :favorite ]
      def acts_as_markable(*args)
        options = args.extract_options!  # {}
        marks   = args.flatten  # [:hated, :favorite]
        by      = options[:by]  # markable_as :friendly, :by => :user

        ActsAsMarkable.set_models

        class_eval do
          class << self
            attr_accessor :__markable_marks
          end
        end

        marks = Array.wrap(marks).map!(&:to_sym)

        markers = by.present? ? Array.wrap(by) : :all

        self.__markable_marks ||= {}
        marks.each do |mark|
          self.__markable_marks[mark] = {
            :allowed_markers => markers
          }
        end

        include ActsAsMarkable::Markable::LocalInstanceMethods

        class_eval do
          has_many :markable_marks,
                   :class_name => 'ActsAsMarkable::Mark',
                   :as => :markable,
                   :dependent => :delete_all
        end
        ActsAsMarkable.add_markable(self)
      end
    end

    # 实例方法
    module LocalInstanceMethods
      # food.mark_as :favorite, [user1, user2]
      def mark_as(mark, markers)
        Array.wrap(markers).each do |marker|
          # Markable.can_mark_or_raise?(marker, self, mark)
          params = {
            :markable_id => self.id,
            :markable_type => self.class.name,
            :marker_id => marker.id,
            :marker_type => marker.class.name,
            :mark => mark.to_s
          }
          # 保存数据记录
          # models/mark.rb
          ActsAsMarkable::Mark.create(params) unless ActsAsMarkable::Mark.exists?(params)
        end
      end

      # food.marked_as? :favorite, :by => user1
      def marked_as?(mark, options = {})
        by = options[:by]
        params = {
          :markable_id => self.id,
          :markable_type => self.class.name,
          :mark => mark.to_s
        }
        if by.present?
          # Markable.can_mark_or_raise?(by, self, mark)
          params[:marker_id] = by.id
          params[:marker_type] = by.class.name
        end
        ActsAsMarkable::Mark.exists?(params)
      end

      # food.unmark :favorite, :by => user1
      def unmark(mark, options = {})
        by = options[:by]
        if by.present?
          # ActsAsMarkable.can_mark_or_raise?(by, self, mark)
          Array.wrap(by).each do |marker|
            ActsAsMarkable::Mark.delete_all({
              :markable_id => self.id,
              :markable_type => self.class.name,
              :marker_id => marker.id,
              :marker_type => marker.class.name,
              :mark => mark.to_s
            })
          end
        else
          ActsAsMarkable::Mark.delete_all({
            :markable_id => self.id,
            :markable_type => self.class.name,
            :mark => mark.to_s
          })
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ActsAsMarkable::Markable