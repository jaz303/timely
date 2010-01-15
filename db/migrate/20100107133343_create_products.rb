class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :code, :null => false
      t.string :name, :null => false
      t.integer :amount, :null => false
      t.string :tax_rate, :null => false
      t.string :interval, :null => false
      t.timestamps
    end
    add_index :products, :code, :unique => true
  end

  def self.down
    drop_table :products
  end
end
