class Idea < ActiveRecord::Base

  belongs_to :user
  has_many :liked_items, dependent: :destroy

  validates_presence_of :description, :price, :recipient

  default_scope { order('created_at DESC') }

end