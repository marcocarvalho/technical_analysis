class CreateCompany < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :symbol, :null => false
      t.string :name, :null => false

      t.timestamps
    end

    add_index :companies, [:symbol]
  end
end
