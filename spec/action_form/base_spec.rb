require 'spec_helper'

describe ActionForm::Base do
  describe '#save' do
    it 'calls #save of underlying object' do
      user = double('user')
      user_form = UserForm.new(user)
      expect(user).to receive(:save)
      user_form.save
    end
  end
end
