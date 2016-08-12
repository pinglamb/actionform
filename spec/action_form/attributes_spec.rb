require 'spec_helper'

describe ActionForm::Attributes do
  it 'supports defining form attribute' do
    form_class = Class.new(ActionForm::Base) do
      attribute :name
    end
    form_object = form_class.new
    expect(form_object).to respond_to(:name=)
    expect(form_object).to respond_to(:name)
  end

  it 'supports defining multiple attributes' do
    form_class = Class.new(ActionForm::Base) do
      attributes :name, :email
      attributes :phone
    end
    form_object = form_class.new
    %i(name email phone).each do |field|
      expect(form_object).to respond_to(:"#{field}=")
      expect(form_object).to respond_to(:"#{field}")
    end
  end
end
