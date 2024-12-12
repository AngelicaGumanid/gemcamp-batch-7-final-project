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

ActiveRecord::Schema[7.0].define(version: 2024_12_12_024052) do
  create_table "address_barangays", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "city_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_address_barangays_on_city_id"
  end

  create_table "address_cities", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "province_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["province_id"], name: "index_address_cities_on_province_id"
  end

  create_table "address_provinces", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "region_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_address_provinces_on_region_id"
  end

  create_table "address_regions", charset: "utf8mb4", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.integer "minimum_tickets"
    t.string "state"
    t.integer "batch_count"
    t.datetime "online_at"
    t.datetime "offline_at"
    t.datetime "start_at"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.datetime "deleted_at"
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_items_on_category_id"
  end

  create_table "locations", charset: "utf8mb4", force: :cascade do |t|
    t.integer "genre", default: 0, null: false
    t.string "name"
    t.string "street_address"
    t.string "phone_number"
    t.text "remark"
    t.boolean "is_default", default: false
    t.bigint "user_id", null: false
    t.bigint "address_regions_id", null: false
    t.bigint "address_provinces_id", null: false
    t.bigint "address_cities_id", null: false
    t.bigint "address_barangays_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_barangays_id"], name: "index_locations_on_address_barangays_id"
    t.index ["address_cities_id"], name: "index_locations_on_address_cities_id"
    t.index ["address_provinces_id"], name: "index_locations_on_address_provinces_id"
    t.index ["address_regions_id"], name: "index_locations_on_address_regions_id"
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "news_tickers", charset: "utf8mb4", force: :cascade do |t|
    t.text "content", null: false
    t.integer "status", default: 0
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["admin_id"], name: "index_news_tickers_on_admin_id"
  end

  create_table "offers", charset: "utf8mb4", force: :cascade do |t|
    t.string "image"
    t.string "name"
    t.integer "status"
    t.decimal "amount", precision: 10
    t.decimal "coin", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "offer_id"
    t.string "serial_number", null: false
    t.string "state", default: "pending", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.integer "coin"
    t.text "remarks"
    t.integer "genre", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_orders_on_offer_id"
    t.index ["serial_number"], name: "index_orders_on_serial_number", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "tickets", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "user_id", null: false
    t.string "serial_number"
    t.string "state", default: "pending", null: false
    t.integer "coins", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "batch_count"
    t.index ["item_id"], name: "index_tickets_on_item_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "genre", default: 0
    t.string "username"
    t.string "phone"
    t.integer "coins", default: 0
    t.decimal "total_deposit", precision: 15, scale: 2, default: "0.0"
    t.integer "children_members", default: 0
    t.string "image"
    t.integer "parent_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "winners", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "ticket_id", null: false
    t.bigint "user_id", null: false
    t.bigint "location_id", null: false
    t.integer "item_batch_count"
    t.string "state"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "paid_at"
    t.bigint "admin_id", null: false
    t.string "picture"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_winners_on_admin_id"
    t.index ["item_id"], name: "index_winners_on_item_id"
    t.index ["location_id"], name: "index_winners_on_location_id"
    t.index ["ticket_id"], name: "index_winners_on_ticket_id"
    t.index ["user_id"], name: "index_winners_on_user_id"
  end

  add_foreign_key "items", "categories"
  add_foreign_key "locations", "address_barangays", column: "address_barangays_id"
  add_foreign_key "locations", "address_cities", column: "address_cities_id"
  add_foreign_key "locations", "address_provinces", column: "address_provinces_id"
  add_foreign_key "locations", "address_regions", column: "address_regions_id"
  add_foreign_key "locations", "users"
  add_foreign_key "news_tickers", "users", column: "admin_id"
  add_foreign_key "orders", "offers"
  add_foreign_key "orders", "users"
  add_foreign_key "tickets", "items"
  add_foreign_key "tickets", "users"
  add_foreign_key "winners", "items"
  add_foreign_key "winners", "locations"
  add_foreign_key "winners", "tickets"
  add_foreign_key "winners", "users"
  add_foreign_key "winners", "users", column: "admin_id"
end
