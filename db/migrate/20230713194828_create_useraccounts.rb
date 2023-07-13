class CreateUseraccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_accounts, id: :uuid do |t|
      t.string :user_name
      t.string :password
      t.string :email, unique: true
      t.boolean :email_confirmed, default: false
      t.text :roles, array: true, default: []
    end

    add_index :user_accounts, :id, unique: true
  end
end
