require 'active_model/attribute_assignment'

require 'action_form/attributes'

module ActionForm
  class Base
    include ActiveModel::AttributeAssignment
    include ActionForm::Attributes

    attr_reader :object

    delegate :model_name, :to_key, :to_model, :persisted?, to: :object

    def initialize(object)
      @object = object
    end

    def assign_attributes(attrs)
      if attrs.respond_to?(:permit)
        attrs = attrs.permit(self.class._attributes)
      end

      super(attrs)
    end

    def save
      object.save
    end
  end
end
