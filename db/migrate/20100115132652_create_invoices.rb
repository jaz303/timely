class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.references :agreement, :null => false
      t.string :reference, :null => false
      t.string :description, :null => false
      t.integer :amount, :null => false
      t.float :tax_rate, :null => false
      t.date :due_on, :null => false
      t.boolean :remote_invoice_created, :null => false, :default => false
      t.string :status, :null => false, :default => 'unpaid'
      t.timestamps
    end
    add_index :invoices, :agreement_id
  end

  def self.down
    drop_table :invoices
  end
end
