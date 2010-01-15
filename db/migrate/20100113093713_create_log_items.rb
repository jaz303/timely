class CreateLogItems < ActiveRecord::Migration
  def self.up
    create_table :log_items do |t|
      t.integer :agreement_id, :null => true
      t.string :action, :null => true
      t.string :message, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :log_items
  end
end
