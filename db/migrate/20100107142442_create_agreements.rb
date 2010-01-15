class CreateAgreements < ActiveRecord::Migration
  def self.up
    create_table :agreements do |t|
      t.references :client, :null => false
      t.references :product, :null => false
      t.string :description, :null => false
      t.date :start_date, :null => false
      t.date :next_period_starts_on, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :agreements
  end
end
