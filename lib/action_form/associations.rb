module ActionForm
  module Associations
    extend ActiveSupport::Concern

    included do
      class_attribute :_associations_data, instance_writer: false, instance_reader: false

      delegate :association, to: :object
    end

    class_methods do
      def inherited(base)
        super
        base.nested_attributes_options = nested_attributes_options.dup
      end

      def has_one(association_name, options = {})
        accepts_nested_attributes_for association_name, :one_to_one, options
      end

      def has_many(association_name, options = {})
        accepts_nested_attributes_for association_name, :collection, options
      end

      def accepts_nested_attributes_for(association_name, type, options)
        options = { allow_destroy: false, update_only: false }.merge(options)
        options.assert_valid_keys(:allow_destroy, :reject_if, :limit, :update_only)
        options[:reject_if] = ActiveRecord::NestedAttributes::ClassMethods::REJECT_ALL_BLANK_PROC if options[:reject_if] == :all_blank

        if reflection = _reflect_on_association(association_name)
          reflection.autosave = true
          define_autosave_validation_callbacks(reflection)

          nested_attributes_options = self.nested_attributes_options.dup
          nested_attributes_options[association_name.to_sym] = options
          self.nested_attributes_options = nested_attributes_options

          delegate association_name, to: :object
          generate_association_writer(association_name, type)
        else
          raise ArgumentError, "No association found for name `#{association_name}'. Has it been defined yet?"
        end
      end

      def reflect_on_association(*args)
        model_class.reflect_on_association(*args)
      end

      def _reflect_on_association(*args)
        model_class._reflect_on_association(*args)
      end

      def define_autosave_validation_callbacks(*args, &block)
        model_class.send(:define_autosave_validation_callbacks, *args, &block)
      end

      def generate_association_writer(association_name, type)
        class_eval <<-EORUBY, __FILE__, __LINE__ + 1
          if method_defined?(:#{association_name}_attributes=)
            remove_method(:#{association_name}_attributes=)
          end
          def #{association_name}_attributes=(attributes)
            assign_nested_attributes_for_#{type}_association(:#{association_name}, attributes)
          end
        EORUBY
      end

      def _associations
        nested_attributes_options.keys
      end
    end
  end
end
