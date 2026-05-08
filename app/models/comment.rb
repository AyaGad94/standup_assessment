class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  after_create_commit -> { broadcast_append_to [commentable, :comments], target: "comments" }
end