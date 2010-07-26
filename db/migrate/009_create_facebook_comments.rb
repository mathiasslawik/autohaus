class CreateFacebookComments < ActiveRecord::Migration
  #Erzeuge die Tabelle mit den Facebook Kommentaren
  def self.up
    create_table :facebook_comments do |t|
      t.integer :order_id, :null => false
      t.string :text
      t.string :uid
      t.datetime :created_at
      t.string :post_id
    end

    add_index(:facebook_comments, :order_id)
    add_index(:facebook_comments, :uid)

    add_index(:facebook_comments, :post_id, :unique => true)

    add_foreign_key(:facebook_comments, :orders)
  end

  def self.down
    drop_table :facebook_comments
  end
end