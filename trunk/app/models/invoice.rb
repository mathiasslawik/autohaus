class Invoice < ActiveRecord::Base
  belongs_to :order
end