class PostForm < ActionForm::Base
  attributes :title, :content
  attribute :publish, virtual: true

  def publish=(val)
    object.publish
  end
end
