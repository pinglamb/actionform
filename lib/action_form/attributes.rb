module ActionForm
  module Attributes
    extend ActiveSupport::Concern

    class_methods do
      def attributes(*names)
        names.each do |name|
          attribute(name)
        end
      end

      def attribute(name)
        class_eval <<-EORUBY, __FILE__, __LINE__ + 1
          def #{name}
            object.name
          end

          def #{name}=(value)
            object.name = value
          end
        EORUBY
      end
    end
  end
end
