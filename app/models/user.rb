class User < ActiveRecord::Base
  validates_presence_of :username, :password
  validates_uniqueness_of :username

  has_secure_password validations: false

  has_many :ideas
  has_many :liked_items
end