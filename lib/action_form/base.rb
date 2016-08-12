require 'action_form/attributes'

module ActionForm
  class Base
    include ActionForm::Attributes

    attr_reader :object

    def initialize(object)
      @object = object
    end

    def save
      object.save
    end
  end
end
