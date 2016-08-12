require 'spec_helper'

describe ActionForm::Attributes do
  it 'supports defining form attribute' do
    form_class = Class.new(ActionForm::Base) do
      attribute :name
    end
    form_object = form_class.new(User.new)
    expect(form_object).to respond_to(:name=)
    expect(form_object).to respond_to(:name)
  end

  it 'supports defining multiple attributes' do
    form_class = Class.new(ActionForm::Base) do
      attributes :name, :email
      attributes :phone
    end
    form_object = form_class.new(User.new)
    %i(name email phone).each do |field|
      expect(form_object).to respond_to(:"#{field}=")
      expect(form_object).to respond_to(:"#{field}")
    end
  end

  it 'supports defining virtual attribute that underlying model does not have' do
    expect(User.new).not_to respond_to(:foo)

    form_class = Class.new(ActionForm::Base) do
      attribute :foo, virtual: true
    end
    form_object = form_class.new(User.new)
    form_object.foo = 'bar'
    expect(form_object.foo).to eq('bar')
  end

  it 'reads the value of attribute from underlying object' do
    user = User.new
    user.name = 'John Doe'
    user_form = UserForm.new(user)
    expect(user_form.name).to eq('John Doe')
  end

  it 'sets the value of attribute to the underlying object' do
    user = User.new
    user_form = UserForm.new(user)
    expect(user.name).to be_nil
    user_form.name = 'John Doe'
    expect(user.name).to eq('John Doe')
  end
end
