class PostForm < ActionForm::Base
  attributes :title, :content, :slug
  attribute :publish, virtual: true

  has_many :comments, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :content, presence: true

  def publish=(val)
    object.publish
  end
end
