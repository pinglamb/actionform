class User
  include ActiveModel::Model

  attr_accessor :name, :email, :phone

  def save
    # Do nothing
    true
  end
end

class UserForm < ActionForm::Base
  attributes :name, :email, :phone
end

class UserFormWithValidations < ActionForm::Base
  attributes :name, :email, :phone
  validates :name, presence: true
end
