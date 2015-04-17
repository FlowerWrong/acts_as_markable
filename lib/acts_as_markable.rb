require 'models/mark'
require 'acts_as_markable/markable'
require 'acts_as_markable/marker'
require 'acts_as_markable/exceptions'

##
# Author:: FuSheng Yang (mailto:sysuyangkang@gmail.com)
# Copyright:: Copyright (c) 2015 thecampus.cc
# License:: Distributes under the same terms as Ruby
# ActsAsMarkable
module ActsAsMarkable
  # cattr/mattr_accessor provide getter/setter methods at the class or module level
  # see http://stackoverflow.com/questions/185573/what-is-mattr-accessor-in-a-rails-module
  mattr_accessor :markers, :markables, :models
  @@markers   = []
  @@markables = []
  @@models    = []

  protected

  def self.set_models
    # ActiveRecord::Base.connection.tables.collect{ |t| t.classify rescue nil }.compact => ["SchemaMigration", "User", "Food", "Mark"]
    # => ["SchemaMigration", "User", "Food", "Mark"]
    @@models = @@models.presence || ActiveRecord::Base.connection.tables.collect{ |t| t.classify rescue nil }.compact
  end

  def self.add_markable(markable)
    # markable => eg Food
    @@markables.push markable.name.to_sym unless @@markables.include? markable.name.to_sym
  end

  def self.add_marker(marker)
    # marker => User
    # marker.name.to_sym => :User
    @@markers.push marker.name.to_sym unless @@markers.include? marker.name.to_sym
  end

  def self.can_mark_or_raise?(markers, markables, mark)
    Array.wrap(markers).all? do |marker_object|
      Array.wrap(markables).all? do |markable|
        self.can_mark_object?(marker_object, markable, mark)
      end
    end
  end

  def self.can_mark_object?(marker_object, markable_object, mark)
    marker_name = marker_object.class.name.to_sym
    markable_name = markable_object.class.name.to_sym
    raise ActsAsMarkable::WrongMarkerType.new(marker_name) unless @@markers.include?(marker_name)
    raise ActsAsMarkable::WrongMarkableType.new(markable_name) unless @@markables.include?(markable_name)
    raise ActsAsMarkable::WrongMark.new(marker_object, markable_object, mark) unless markable_object.class.__markable_marks.include?(mark)
    raise ActsAsMarkable::NotAllowedMarker.new(marker_object, markable_object, mark) unless (markable_object.class.__markable_marks[mark][:allowed_markers] == :all ||
                                                                                             markable_object.class.__markable_marks[mark][:allowed_markers].include?(marker_name.to_s.downcase.to_sym))
    true
  end
end
