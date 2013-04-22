class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :type, :null => false
      t.date :deliberated_at, :null => false
      t.date :ex_at,          :null => true
      t.date :credit_at,      :null => true
      t.float :factor,        :null => false
      t.string :obs,          :null => true

      t.timestamps
    end

    create_table :companies_movements do |t|
      t.references :movement
      t.references :company
    end

    add_index :companies_movements, [:movement_id, :company_id]
  end
end

# {:type=>:desdobramento, :deliberated_at=>"2007-08-30", :ex_at=>"2007-08-31", :factor=>2, :credit_at=>"2007-09-06", :obs=>""}