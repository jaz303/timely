class AddActiveFlagToClients < ActiveRecord::Migration
  def self.up
    add_column :clients, :active, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :clients, :active
  end
end
