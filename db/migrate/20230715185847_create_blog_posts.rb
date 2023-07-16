class CreateBlogPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :product, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.string :category
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock_quantity, null: false
      t.boolean :avaible, default: true
      t.timestamps
    end

    add_index :product, :id, unique: true
  end
end
