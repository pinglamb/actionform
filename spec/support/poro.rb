class User
  attr_accessor :name, :email, :phone

  def save
    # Do nothing
  end
end

class UserForm < ActionForm::Base
  attributes :name, :email, :phone
end
