class CreateFacebookFriends < ActiveRecord::Migration
  #Erzeuge die Tabelle mit den Facebook Freundverbindungen
  def self.up
    create_table :facebook_friends, :id => false do |t|
      t.string :uid
      t.string :friendof
    end

    add_index(:facebook_friends, [:uid, :friendof], :unique => true)
  end

  def self.down
    drop_table :facebook_friends
  end
end
