class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name, :null => false
      t.string :remote_id, :null => false
      t.timestamps
    end
    add_index :clients, :remote_id, :unique => true
  end

  def self.down
    drop_table :clients
  end
end
