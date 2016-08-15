class Post < ApplicationRecord
  has_many :comments

  validates :slug, presence: true, uniqueness: true

  def publish
    self.published_at = Time.zone.now
  end

  def published?
    published_at.present?
  end
end
