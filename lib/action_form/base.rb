require 'active_model/attribute_assignment'
require 'active_record/nested_attributes'

require 'action_form/attributes'
require 'action_form/associations'

module ActionForm
  class Base
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations
    include ActiveRecord::NestedAttributes
    include ActionForm::Attributes
    include ActionForm::Associations

    attr_reader :object

    delegate :model_name, :to_key, :to_model, :persisted?, to: :object
    delegate :errors, to: :object

    def initialize(object)
      @object = object
    end

    def submit(attrs)
      unless attrs.nil?
        if attrs.respond_to?(:permit)
          permitted_params = self.class._attributes.dup
          nested_attributes_options.each do |association_name, option|
            permitted_nested_params = %i(id)
            associated_form = "#{association_name.to_s.singularize.camelize}Form".constantize
            permitted_nested_params.concat(associated_form._attributes)
            if option[:allow_destroy]
              permitted_nested_params << :_destroy
            end
            permitted_params << { :"#{association_name}_attributes" => permitted_nested_params }
          end
          attrs = attrs.permit(permitted_params)
        end

        assign_attributes(attrs)
      end
    end

    def valid?(context = nil)
      super
      begin
        current_context = object.validation_context
        object.send(:validation_context=, context)
        object.send(:run_validations!)
      ensure
        object.send(:validation_context=, current_context)
      end
      errors.empty?
    end

    def save
      if valid?
        object.save
      else
        false
      end
    end

    class << self
      def model_class
        @model_class ||= name.sub(/Form$/, '').to_s.camelize.constantize
      end
    end
  end
end
