class CreateOrder < ActiveRecord::Migration[7.0]
  def change
    create_table :order, id: :uuid do |t|
      t.string :user_id
      t.integer :total_ammount
      t.string :state
      t.timestamps
    end

    add_index :order, :id, unique: true
  end
end
