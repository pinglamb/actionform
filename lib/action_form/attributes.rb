module ActionForm
  module Attributes
    extend ActiveSupport::Concern

    included do
      class_attribute :_attributes_data, instance_writer: false, instance_reader: false
      self._attributes_data ||= []
    end

    class_methods do
      def inherited(base)
        super
        base._attributes_data = _attributes_data.dup
      end

      def attributes(*names)
        names.each do |name|
          attribute(name)
        end
      end

      def attribute(name, options = {})
        _attributes_data << name
        if options[:virtual]
          attr_accessor name
        else
          class_eval <<-EORUBY
            def #{name}
              object.#{name}
            end

            def #{name}=(value)
              object.#{name} = value
            end
          EORUBY
        end
      end

      def _attributes
        _attributes_data
      end
    end
  end
end
