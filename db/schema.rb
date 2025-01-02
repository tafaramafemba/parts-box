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

ActiveRecord::Schema[7.2].define(version: 2025_01_01_201017) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "author"
    t.date "published_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published"
    t.integer "likes_count", default: 0
  end

  create_table "car_makes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "car_models", force: :cascade do |t|
    t.string "name"
    t.integer "car_make_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_make_id"], name: "index_car_models_on_car_make_id"
  end

  create_table "car_parts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "tools"
    t.decimal "labor_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_carts_on_product_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.integer "buyer_id", null: false
    t.integer "seller_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read"
    t.string "default"
    t.string "false"
  end

  create_table "comment_likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "comment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_likes_on_comment_id"
    t.index ["user_id"], name: "index_comment_likes_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "blog_post_id", null: false
    t.string "user_name"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_comment_id"
    t.index ["blog_post_id"], name: "index_comments_on_blog_post_id"
    t.index ["parent_comment_id"], name: "index_comments_on_parent_comment_id"
  end

  create_table "delivery_slots", force: :cascade do |t|
    t.time "time"
    t.integer "cutoff"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "blog_post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_post_id"], name: "index_likes_on_blog_post_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "chat_id", null: false
    t.integer "sender_id", null: false
    t.text "body", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.decimal "shipping_fee", precision: 10, scale: 2, null: false
    t.decimal "platform_fee", precision: 10, scale: 2, null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_session_id"
    t.string "paypal_payment_id"
    t.integer "shipping_address_id", null: false
    t.datetime "delivery_slot"
    t.index ["shipping_address_id"], name: "index_orders_on_shipping_address_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.string "barter_terms"
    t.string "image"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location", default: "Canada"
    t.string "make"
    t.string "model"
    t.string "year"
    t.string "manufacturer_part_number"
    t.string "condition", default: "used"
    t.json "additional_images", default: []
    t.integer "stock_quantity"
    t.string "shipping_fee_type", default: "flat_rate"
    t.decimal "flat_rate_shipping_fee", default: "0.0"
    t.decimal "weight"
    t.string "dimensions"
    t.text "shipping_address"
    t.boolean "listing_status", default: true
    t.string "category", default: "Uncategorized", null: false
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "replies", force: :cascade do |t|
    t.text "content"
    t.string "user_name"
    t.integer "comment_id", null: false
    t.integer "blog_post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_post_id"], name: "index_replies_on_blog_post_id"
    t.index ["comment_id"], name: "index_replies_on_comment_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "seller_applications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "id_document"
    t.string "address"
    t.string "business_name"
    t.string "business_registration_number"
    t.string "business_registration_document"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_seller_applications_on_user_id"
  end

  create_table "seller_informations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "id_document"
    t.string "address"
    t.string "business_name"
    t.string "business_registration_number"
    t.string "business_registration_document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.index ["user_id"], name: "index_seller_informations_on_user_id"
  end

  create_table "shipping_addresses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shipping_addresses_on_user_id"
  end

  create_table "trade_requests", force: :cascade do |t|
    t.text "message"
    t.decimal "cash_top_up", precision: 10, scale: 2
    t.integer "product_id", null: false
    t.integer "sender_id", null: false
    t.integer "recipient_id", null: false
    t.json "images", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read"
    t.string "default"
    t.string "false"
    t.string "name"
    t.string "make"
    t.string "model"
    t.integer "year"
    t.string "manufacturer_part_number"
    t.string "condition", default: "used"
    t.string "location", default: "Canada"
    t.index ["product_id"], name: "index_trade_requests_on_product_id"
    t.index ["recipient_id"], name: "index_trade_requests_on_recipient_id"
    t.index ["sender_id"], name: "index_trade_requests_on_sender_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "buyer_id", null: false
    t.integer "seller_id", null: false
    t.integer "product_id", null: false
    t.integer "trade_item_id", null: false
    t.decimal "cash_top_up"
    t.decimal "platform_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_transactions_on_buyer_id"
    t.index ["product_id"], name: "index_transactions_on_product_id"
    t.index ["seller_id"], name: "index_transactions_on_seller_id"
    t.index ["trade_item_id"], name: "index_transactions_on_trade_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "seller_status", default: "not_applied"
    t.string "stripe_account_id"
    t.string "paypal_email"
    t.string "paypal_merchant_id"
    t.string "paypal_access_token"
    t.string "paypal_refresh_token"
    t.string "first_name"
    t.string "last_name"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "phone_number"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "car_models", "car_makes"
  add_foreign_key "comment_likes", "comments"
  add_foreign_key "comment_likes", "users"
  add_foreign_key "comments", "blog_posts"
  add_foreign_key "likes", "blog_posts"
  add_foreign_key "likes", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "shipping_addresses"
  add_foreign_key "products", "users"
  add_foreign_key "replies", "blog_posts"
  add_foreign_key "replies", "comments"
  add_foreign_key "reviews", "users"
  add_foreign_key "seller_applications", "users"
  add_foreign_key "seller_informations", "users"
  add_foreign_key "shipping_addresses", "users"
  add_foreign_key "trade_requests", "products"
  add_foreign_key "trade_requests", "users", column: "recipient_id"
  add_foreign_key "trade_requests", "users", column: "sender_id"
  add_foreign_key "transactions", "buyers"
  add_foreign_key "transactions", "products"
  add_foreign_key "transactions", "sellers"
  add_foreign_key "transactions", "trade_items"
end
