# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_16_000510) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "order", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "user_id"
    t.integer "total_ammount"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_order_on_id", unique: true
  end

  create_table "order_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "order_id"
    t.string "product_id"
    t.integer "quantity"
    t.decimal "price_per_unit", precision: 10, scale: 2, null: false
    t.decimal "subtotal", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_order_items_on_id", unique: true
  end

  create_table "product", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "category"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "stock_quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_product_on_id", unique: true
  end

  create_table "user_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "user_name"
    t.string "password"
    t.string "email"
    t.boolean "email_confirmed", default: false
    t.text "roles", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_user_accounts_on_id", unique: true
  end

  create_table "user_accounts_email_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "user_id"
    t.datetime "creted_at", precision: nil
    t.datetime "valid_for", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_user_accounts_email_tokens_on_id", unique: true
  end

end
