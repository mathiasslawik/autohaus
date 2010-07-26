class GenerateFacebookAccounts < ActiveRecord::Migration
  def self.up
    create_table :facebook_accounts, :id => false do |t|
      t.integer :contact_id
      t.string :uid
      t.string :token
    end

    add_index :facebook_accounts, :contact_id, :unique => true

    add_index :facebook_accounts, :uid

    add_foreign_key(:facebook_accounts, :contacts)
  end

  def self.down
    drop_table :facebook_accounts
  end
end