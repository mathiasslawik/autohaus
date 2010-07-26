class CreateFacebookCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.string :name, :null => false
      t.string :condition
      t.string :text
      t.boolean :active, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end