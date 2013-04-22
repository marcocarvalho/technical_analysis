class CreateCompany < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :symbol, :null => false
      t.string :name, :null => true

      t.timestamps
    end

    add_index :companies, [:symbol]
  end
end
