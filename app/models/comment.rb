class Comment < ActiveRecord::Base
  attr_accessible :content, :track_id
  belongs_to :user
  belongs_to :track

  default_scope order: 'created_at DESC'

  validates :content, presence: true, length: { maximum: 2000 }
  validates :user_id, presence: true
end
