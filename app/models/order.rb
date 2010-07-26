class Order < ActiveRecord::Base
  belongs_to :contact

  has_one :invoice

  has_many :facebook_comments
end