module Wallaby
  class Map
    # To map model class to mode class so that we know how to handle a model
    class ModeMapper
      def initialize(mode_classes)
        @mode_classes = mode_classes
      end

      def map
        return {} if @mode_classes.blank?
        @mode_classes.each_with_object({}) do |mode_class, map|
          mode_class.model_finder.new.all.each do |model_class|
            map[model_class] = mode_class
          end
        end
      end
    end
  end
end
