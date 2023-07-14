class CreateEmailconfirmation < ActiveRecord::Migration[7.0]
  def change
    create_table :user_accounts_email_tokens, id: :uuid do |t|
      t.string :user_id
      t.timestamp :creted_at
      t.timestamp :valid_for
    end

    add_index :user_accounts_email_tokens, :id, unique: true
  end
end
