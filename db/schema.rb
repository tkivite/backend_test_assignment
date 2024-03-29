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

ActiveRecord::Schema.define(version: 2022_01_22_205747) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.citext "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "cars", force: :cascade do |t|
    t.string "model"
    t.bigint "brand_id", null: false
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id", "model"], name: "index_cars_on_brand_id_and_model", unique: true
    t.index ["brand_id"], name: "index_cars_on_brand_id"
  end

  create_table "user_car_recomendations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "car_id"
    t.decimal "rank_score", precision: 5, scale: 4
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_preferred_brands", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_user_preferred_brands_on_brand_id"
    t.index ["user_id"], name: "index_user_preferred_brands_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.int8range "preferred_price_range"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "cars", "brands"
  add_foreign_key "user_preferred_brands", "brands"
  add_foreign_key "user_preferred_brands", "users"
end
