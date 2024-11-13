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

ActiveRecord::Schema[7.0].define(version: 2024_11_13_035000) do
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

  add_foreign_key "locations", "address_barangays", column: "address_barangays_id"
  add_foreign_key "locations", "address_cities", column: "address_cities_id"
  add_foreign_key "locations", "address_provinces", column: "address_provinces_id"
  add_foreign_key "locations", "address_regions", column: "address_regions_id"
  add_foreign_key "locations", "users"
end
