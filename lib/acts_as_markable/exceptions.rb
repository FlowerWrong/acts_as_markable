##
# Author:: FuSheng Yang (mailto:sysuyangkang@gmail.com)
# Copyright:: Copyright (c) 2015 thecampus.cc
# License:: Distributes under the same terms as Ruby
# ActsAsMarkable
module ActsAsMarkable  #:nodoc:
  class WrongMarkableType < Exception
    def initialize(markable_name)
      super "Wrong markable type: ['#{Markable.markables.join("', '")}'] expected, '#{markable_name}' provided."
    end
  end

  class NotAllowedMarker < Exception
    def initialize(marker, markable, mark)
      super "Marker '#{marker.class.name}' is not allowed to mark '#{markable.class.name}' with mark '#{mark}'. Allowed markers: '#{markable.class.__markable_marks[mark][:allowed_markers].join("', '")}'"
    end
  end

  class WrongMarkerType < Exception
    def initialize(marker_name)
      super "Wrong marker type: ['#{Markable.markers.join("', '")}'] expected, '#{marker_name}' provided."
    end
  end

  class WrongMark < Exception
    def initialize(marker, markable, mark)
      super "Wrong mark '#{mark}' for '#{markable.class.name}'. Available marks: '#{markable.class.__markable_marks.keys.join("', '")}'"
    end
  end
end