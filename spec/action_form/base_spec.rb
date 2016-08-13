require 'spec_helper'

describe ActionForm::Base do
  describe '#save' do
    it 'calls #save of underlying object' do
      user = double('user')
      user_form = UserForm.new(user)
      expect(user).to receive(:save)
      user_form.save
    end

    it 'validates the form object' do
      user_form = UserFormWithValidations.new(User.new)
      expect(user_form.save).to eq(false)
      expect(user_form.errors.details[:name]).to eq([{error: :blank}])
    end
  end
end
