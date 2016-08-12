class User
  attr_accessor :name, :email, :phone
end

class UserForm < ActionForm::Base
  attributes :name, :email, :phone
end
