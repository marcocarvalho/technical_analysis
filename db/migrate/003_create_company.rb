class CreateCompany < ActiveRecord::Migration
  def change
    create_table :company do |t|
      t.string :symbol, :null => false
      t.string :name, :null => false

      t.timestamps
    end

    add_index :company, [:symbol]
  end
end
