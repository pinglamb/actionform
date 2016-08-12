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
        attr_accessor name
      end
    end
  end
end
