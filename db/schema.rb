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

ActiveRecord::Schema[7.2].define(version: 2025_11_11_185356) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "item_batches", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.string "lot_code"
    t.date "expires_on"
    t.decimal "unit_cost", precision: 10, scale: 2
    t.integer "quantity_on_hand"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_batches_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.string "unit"
    t.integer "min_stock"
    t.decimal "sale_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "provider_id", null: false
    t.index ["provider_id"], name: "index_items_on_provider_id"
  end

  create_table "patient_infos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "health_insurance"
    t.string "policy_number"
    t.date "birthdate"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_patient_infos_on_user_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "contact_name"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.string "cuit"
    t.boolean "status"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_providers_on_created_by_id"
    t.index ["updated_by_id"], name: "index_providers_on_updated_by_id"
  end

  create_table "stock_movements", force: :cascade do |t|
    t.bigint "withdrawal_line_id", null: false
    t.bigint "item_batch_id", null: false
    t.integer "quantity"
    t.decimal "unit_value", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_batch_id"], name: "index_stock_movements_on_item_batch_id"
    t.index ["withdrawal_line_id"], name: "index_stock_movements_on_withdrawal_line_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "address"
    t.string "document_id"
    t.boolean "status"
    t.integer "role"
    t.boolean "login_enabled", default: true, null: false
    t.string "reimbursement"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "withdrawal_lines", force: :cascade do |t|
    t.bigint "withdrawal_id", null: false
    t.bigint "item_id", null: false
    t.integer "quantity"
    t.decimal "sale_unit_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_withdrawal_lines_on_item_id"
    t.index ["withdrawal_id"], name: "index_withdrawal_lines_on_withdrawal_id"
  end

  create_table "withdrawals", force: :cascade do |t|
    t.string "kind", null: false
    t.string "reimbursement", null: false
    t.bigint "patient_id"
    t.bigint "internal_user_id"
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0"
    t.datetime "occurred_at", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["internal_user_id"], name: "index_withdrawals_on_internal_user_id"
    t.index ["patient_id"], name: "index_withdrawals_on_patient_id"
  end

  add_foreign_key "item_batches", "items"
  add_foreign_key "items", "providers"
  add_foreign_key "patient_infos", "users"
  add_foreign_key "providers", "users", column: "created_by_id"
  add_foreign_key "providers", "users", column: "updated_by_id"
  add_foreign_key "stock_movements", "item_batches"
  add_foreign_key "stock_movements", "withdrawal_lines"
  add_foreign_key "withdrawal_lines", "items"
  add_foreign_key "withdrawal_lines", "withdrawals"
  add_foreign_key "withdrawals", "users", column: "internal_user_id"
  add_foreign_key "withdrawals", "users", column: "patient_id"
end
