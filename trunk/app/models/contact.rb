class Contact < ActiveRecord::Base
  has_many :cars, :dependent => :destroy
  has_many :orders
  has_many :invoices, :through => :orders
end