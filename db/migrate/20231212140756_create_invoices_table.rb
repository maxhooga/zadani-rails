class CreateInvoicesTable < ActiveRecord::Migration[7.0]
  def change
    create_table "invoices", force: :cascade do |t|
      t.bigint "subscription_id"
      t.string "number"
      t.datetime "issued_on", precision: nil
      t.datetime "due_on", precision: nil
      t.string "means_of_payment", default: "cash"
      t.float "total"
      t.datetime "created_at", precision: nil, null: false
      t.datetime "updated_at", precision: nil, null: false
      t.datetime "paid_at", precision: nil
      t.datetime "submitted_at", precision: nil
      t.datetime "deleted_at", precision: nil
      t.string "state", default: "draft"
    end

    create_table "invoice_lines", force: :cascade do |t|
      t.bigint "invoice_id", null: false
      t.string "description"
      t.string "unit_type"
      t.decimal "quantity", default: "1.0"
      t.decimal "price", default: "0.0"
      t.datetime "deleted_at", precision: nil
    end

    create_table "invoice_parties", force: :cascade do |t|
      t.string "name"
      t.string "company_number"
      t.string "street"
      t.string "city"
      t.string "type"
      t.string "postcode"
      t.string "country_code"
      t.bigint "invoice_id"
      t.datetime "deleted_at", precision: nil
    end

    create_table "subscriptions", force: :cascade do |t|
      t.string "email"
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
    end
  end
end
