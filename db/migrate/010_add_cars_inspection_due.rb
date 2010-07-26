class AddCarsInspectionDue < ActiveRecord::Migration
  def self.up
    add_column :cars, :inspection_due, :boolean, :default => 0
  end

  def self.down
    remove_column :cars, :inspection_due
  end
end