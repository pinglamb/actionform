class Comment < ApplicationRecord
  belongs_to :post, inverse_of: :comments
end
