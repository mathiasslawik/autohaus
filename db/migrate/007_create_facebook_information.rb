class CreateFacebookInformation < ActiveRecord::Migration
  #Erzeuge die Tabelle mit den Facebook-Informationen
  def self.up
    create_table :facebook_informations, :id => false do |t|
      t.string :uid, :null => false
      t.date :birthday
      t.string :hometown_location_city
      t.string :music
      t.string :pic
      t.string :quotes
      t.string :tv
      t.string :affiliations_work_name
      t.string :email
      t.timestamps
    end

    add_index :facebook_informations, :uid, :unique => true
  end

  def self.down
    drop_table :facebook_informations
  end
end
