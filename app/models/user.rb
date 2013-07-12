class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :password, :password_confirmation, :photo, :user_name
  has_secure_password
  has_attached_file :photo,
      :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
      :url => "/system/:attachment/:id/:style/:filename",
      :default_url => "/facebook_missing.jpg"

  validates_attachment_size :photo, :less_than => 2.megabytes, :styles=> { small: "150x150>"}
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  validates_uniqueness_of :user_name
  validates_presence_of :last_name, :first_name, :user_name

  has_many :quotes, :dependent => :destroy

  def as_json(options = {})
    super(:except => [:password, :password_digest] )
  end

end
