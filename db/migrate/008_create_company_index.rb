class CreateCompanyIndex < ActiveRecord::Migration
  def change
    create_table :symbols do |t|
      t.string :symbol, :null => false
      t.references :company, :null => false
    end

    add_column :companies, :cvm_id, :integer
    remove_index :companies, :symbol
    remove_column :companies, :symbol
    add_index :symbols, :company_id
    add_index :companies, :cvm_id, :unique => true
  end
end
