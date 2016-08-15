class Comment < ApplicationRecord
  belongs_to :post, required: false
end
