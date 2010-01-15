class AddUnpaidFlagToAgreements < ActiveRecord::Migration
  def self.up
    add_column :agreements, :unpaid, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :agreements, :unpaid
  end
end
