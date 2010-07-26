class Contact < ActiveRecord::Base
  has_many :cars, :dependent => :destroy
  has_many :orders
  has_many :invoices, :through => :orders

  has_one :facebook_account

  def facebook_account_status
    if self.facebook_account == nil
      "Nein"
    else
      if self.facebook_account.uid == nil
        "Offen"
      else
        "Ja"
      end
    end
  end

  def friends
    unless facebook_account.nil?
      #reject, da der Kontakt mit einem Facebook-Account von Ihm selbst befreundet
      #sein könnte
      Contact.find(facebook_account.friends.collect{|friend| friend.contact_id}).reject{|e| e.id == id}
    end
  end
end