class PostForm < ActionForm::Base
  attributes :title, :content, :slug
  attribute :publish, virtual: true

  validates :title, presence: true
  validates :content, presence: true

  def publish=(val)
    object.publish
  end
end
