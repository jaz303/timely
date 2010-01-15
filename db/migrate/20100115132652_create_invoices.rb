class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.references :agreement, :null => false
      t.references :client, :null => false
      t.string :reference, :null => false
      t.string :remote_id, :null => true
      t.string :description, :null => false
      t.integer :amount, :null => false
      t.string :tax_rate, :null => false
      t.date :dated_on, :null => false
      t.date :due_on, :null => false
      t.integer :payment_days, :null => false
      t.string :status, :null => false, :default => 'unpaid'
      t.timestamps
    end
    add_index :invoices, :agreement_id
    add_index :invoices, :reference, :unique => true
    add_index :invoices, :remote_id, :unique => true
  end

  def self.down
    drop_table :invoices
  end
end
