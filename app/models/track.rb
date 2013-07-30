class Track < ActiveRecord::Base
  attr_accessible :title, :track_file
  has_attached_file :track_file,
                    url: ':s3_domain_url',
                    path: 'assets/:class/:id/:filename',
                    storage: :s3,
                    s3_credentials: File.join(Rails.root, 'config', 'aws.yml')

  belongs_to :user
  validates_attachment :track_file, presence: true,
    content_type: { content_type: 'audio/mpeg'  }

end
