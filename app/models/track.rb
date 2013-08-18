class Track < ActiveRecord::Base
  attr_accessible :title, :track_file, :description
  has_attached_file :track_file,
                    url: ':s3_domain_url',
                    path: "assets/#{Rails.env}/:class/:id/:filename",
                    storage: :s3,
                    s3_credentials: File.join(Rails.root, 'config', 'aws.yml')

  has_many :comments, dependent: :destroy
  belongs_to :user
  default_scope order: 'created_at DESC'
  validates :user_id, presence: true
  validates :description, length: { maximum: 3000 }
  validates_attachment :track_file, presence: true,
    content_type: { content_type: /(video|audio)\/ogg/i }

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

end
