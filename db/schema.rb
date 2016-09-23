# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160920184959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "dblink"

  create_table "agreement", id: false, force: :cascade do |t|
    t.integer "id",          default: "nextval('agreement_id_seq'::regclass)", null: false
    t.text    "description"
  end

  create_table "agreement", id: false, force: :cascade do |t|
    t.integer "id",          default: "nextval('agreement_id_seq'::regclass)", null: false
    t.text    "description"
  end

  create_table "amazon_sales", force: :cascade do |t|
    t.text    "sku_id",       null: false
    t.text    "description"
    t.integer "sales_volume"
    t.time    "sale_date"
  end

  create_table "benetton_products_temp", id: false, force: :cascade do |t|
    t.integer "id",          default: "nextval('benetton_products_temp_id_seq'::regclass)", null: false
    t.integer "channel_id"
    t.text    "channel_sku"
  end

  create_table "bigbasket_sales", force: :cascade do |t|
    t.text    "sku_id",                 null: false
    t.text    "brand",                  null: false
    t.text    "description"
    t.text    "manufacturer"
    t.text    "new_department"
    t.text    "department"
    t.text    "new_top_level_category"
    t.text    "bottom_category"
    t.text    "top_level_category"
    t.time    "sale_date"
    t.text    "city",                   null: false
    t.integer "sale_qty"
    t.integer "sale_value"
  end

  create_table "brand_catg_assoc", force: :cascade do |t|
    t.integer  "brand_id",          default: "nextval('brand_catg_assoc_brand_id_seq'::regclass)",   null: false
    t.integer  "created_by",        default: "nextval('brand_catg_assoc_created_by_seq'::regclass)", null: false
    t.datetime "created_timestamp"
    t.text     "category_id"
  end

  create_table "brand_detail", force: :cascade do |t|
    t.text     "brand_name"
    t.integer  "created_by",        default: "nextval('brand_detail_created_by_seq'::regclass)", null: false
    t.datetime "created_timestamp"
  end

  add_index "brand_detail", ["brand_name"], name: "brand_name_uk", unique: true, using: :btree

  create_table "brand_sale", force: :cascade do |t|
    t.text     "brand",                      null: false
    t.decimal  "sales_qty",    default: 0.0
    t.decimal  "sales_value",  default: 0.0
    t.integer  "channel_code"
    t.text     "city"
    t.integer  "group_id"
    t.datetime "sale_date"
    t.datetime "update_time"
    t.integer  "updated_by"
  end

  add_index "brand_sale", ["group_id"], name: "fki_group_detail.id", using: :btree

  create_table "brands", force: :cascade do |t|
    t.string "name", limit: 200
  end

  create_table "cat_app_assoc", id: false, force: :cascade do |t|
    t.integer  "assoc_id",               default: "nextval('cat_app_assoc_assoc_id_seq'::regclass)",   null: false
    t.integer  "cat_grp_id",             default: "nextval('cat_app_assoc_cat_grp_id_seq'::regclass)", null: false
    t.text     "app_cat_id",                                                                           null: false
    t.text     "app_cat_name"
    t.datetime "created_timestamp"
    t.datetime "last_updated_timestamp"
  end

  create_table "cat_grp_url", id: false, force: :cascade do |t|
    t.integer  "id",                     default: "nextval('cat_grp_url_id_seq'::regclass)",         null: false
    t.integer  "channel_id",             default: "nextval('cat_grp_url_channel_id_seq'::regclass)", null: false
    t.text     "url_key"
    t.text     "type"
    t.text     "ref_id"
    t.text     "ref_name"
    t.text     "app_cat_id"
    t.text     "app_cat_name"
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "region_id",              default: "nextval('cat_grp_url_region_id_seq'::regclass)",  null: false
    t.integer  "seller_id",              default: "nextval('cat_grp_url_seller_id_seq'::regclass)",  null: false
    t.jsonb    "other_detail"
    t.datetime "created_timestamp"
    t.datetime "last_updated_timestamp"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name",      limit: 300
    t.string "full_name", limit: 400
  end

  create_table "category_channel_detail", primary_key: "name", force: :cascade do |t|
    t.jsonb "channel_field_json", null: false
  end

  add_index "category_channel_detail", ["channel_field_json"], name: "channel_field_json_index", using: :gin

  create_table "category_channel_export_mapping", force: :cascade do |t|
    t.integer "channel_id"
    t.jsonb   "category_list"
    t.jsonb   "mapping_json"
  end

  create_table "category_detail", force: :cascade do |t|
    t.jsonb    "category_field_json", null: false
    t.integer  "groupid"
    t.datetime "creation_time"
    t.datetime "updation_time"
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  add_index "category_detail", ["category_field_json"], name: "category_field_json_index", using: :gin

  create_table "category_grp_keywords", primary_key: "keyword_id", force: :cascade do |t|
    t.text     "keyword_name"
    t.integer  "channel_id"
    t.integer  "group_id"
    t.integer  "user_id"
    t.text     "category_id"
    t.datetime "last_updated_timestamp"
    t.datetime "created_timestamp"
  end

  create_table "category_history", force: :cascade do |t|
    t.jsonb "category_json", null: false
    t.time  "timestamp",     null: false
  end

  add_index "category_history", ["category_json"], name: "category_json_index", using: :gin

  create_table "category_sale", force: :cascade do |t|
    t.text     "category_name",                           null: false
    t.datetime "sale_date",                               null: false
    t.integer  "channel_code",                            null: false
    t.integer  "group_id",                                null: false
    t.decimal  "sale_percentage", precision: 7, scale: 5
  end

  create_table "category_wise_channel_mapping", force: :cascade do |t|
    t.string "category",     limit: 150, null: false
    t.jsonb  "channel_list"
    t.jsonb  "mapping_json"
  end

  create_table "channel_city_mapping", force: :cascade do |t|
    t.integer "channel_id"
    t.integer "city_id"
  end

  create_table "channel_detail", force: :cascade do |t|
    t.string  "channel_name",             limit: 200, null: false
    t.string  "channel_data_field",       limit: 150
    t.text    "channel_unique_key"
    t.integer "channel_code"
    t.boolean "has_product_id"
    t.boolean "has_city"
    t.text    "icon"
    t.string  "business_model",           limit: 30
    t.text    "business_model_full_name"
    t.boolean "has_ids"
  end

  add_index "channel_detail", ["channel_name"], name: "channel_unique", unique: true, using: :btree

  create_table "channel_export_mapping_detail", primary_key: "channel_name", force: :cascade do |t|
    t.jsonb "channel_mapping_json", null: false
  end

  add_index "channel_export_mapping_detail", ["channel_mapping_json"], name: "channel_mapping_json_index", using: :gin

  create_table "channel_import_mapping_detail", primary_key: "channel_name", force: :cascade do |t|
    t.jsonb "import_mapping_json", null: false
  end

  add_index "channel_import_mapping_detail", ["import_mapping_json"], name: "import_mapping_json_index", using: :gin

  create_table "channel_product_mapping", force: :cascade do |t|
    t.integer  "channel_id"
    t.integer  "product_id",    limit: 8
    t.string   "channel_sku",   limit: 50
    t.integer  "status_id",                default: 4
    t.datetime "creation_time",            default: "now()"
    t.integer  "created_by",               default: -1
    t.datetime "updation_time",            default: "now()"
    t.integer  "updated_by",               default: -1
  end

  add_index "channel_product_mapping", ["channel_id", "channel_sku"], name: "index_app.channel_product_mapping_on_channel_id_and_channel_sku", unique: true, using: :btree

  create_table "channel_promotions", id: false, force: :cascade do |t|
    t.integer  "id",                                default: "nextval('channel_promotions_id_seq'::regclass)",         null: false
    t.integer  "channel_id",                        default: "nextval('channel_promotions_channel_id_seq'::regclass)", null: false
    t.string   "banner_text",           limit: 150,                                                                    null: false
    t.datetime "start_date",                                                                                           null: false
    t.datetime "end_date"
    t.integer  "group_id",                          default: "nextval('channel_promotions_group_id_seq'::regclass)",   null: false
    t.jsonb    "banner_detail"
    t.integer  "created_by",                        default: "nextval('channel_promotions_created_by_seq'::regclass)", null: false
    t.datetime "created_timestamp"
    t.datetime "last_update_timestamp"
    t.integer  "updated_by"
  end

  create_table "channel_promotions_temp", id: false, force: :cascade do |t|
    t.integer  "id",                                default: "nextval('channel_promotions_temp_id_seq'::regclass)",         null: false
    t.integer  "channel_id",                        default: "nextval('channel_promotions_temp_channel_id_seq'::regclass)", null: false
    t.string   "banner_text",           limit: 150,                                                                         null: false
    t.datetime "start_date",                                                                                                null: false
    t.datetime "end_date"
    t.integer  "group_id",                          default: "nextval('channel_promotions_temp_group_id_seq'::regclass)",   null: false
    t.jsonb    "banner_detail"
    t.integer  "created_by",                        default: "nextval('channel_promotions_temp_created_by_seq'::regclass)", null: false
    t.date     "created_timestamp"
    t.datetime "last_update_timestamp"
    t.integer  "updated_by"
  end

  create_table "channel_promotions_temp_n", id: false, force: :cascade do |t|
    t.integer  "id",                                default: "nextval('channel_promotions_temp_n_id_seq'::regclass)",         null: false
    t.integer  "channel_id",                        default: "nextval('channel_promotions_temp_n_channel_id_seq'::regclass)", null: false
    t.string   "banner_text",           limit: 150,                                                                           null: false
    t.datetime "start_date",                                                                                                  null: false
    t.datetime "end_date"
    t.integer  "group_id",                          default: "nextval('channel_promotions_temp_n_group_id_seq'::regclass)",   null: false
    t.jsonb    "banner_detail"
    t.integer  "created_by",                        default: "nextval('channel_promotions_temp_n_created_by_seq'::regclass)", null: false
    t.date     "created_timestamp"
    t.datetime "last_update_timestamp"
    t.integer  "updated_by"
  end

  create_table "channel_region_assoc", id: false, force: :cascade do |t|
    t.integer  "channel_id"
    t.integer  "city_id"
    t.jsonb    "detail"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_timestamp"
    t.datetime "last_updated_timestamp"
    t.integer  "id",                     default: "nextval('channel_region_assoc_id_seq1'::regclass)", null: false
  end

  create_table "channel_seller_mapping", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "channel_id"
    t.integer  "seller_id"
    t.boolean  "is_authorized"
    t.integer  "updated_by",    default: -1
    t.datetime "updation_time", default: "now()"
  end

  create_table "channelfieldtype", id: false, force: :cascade do |t|
    t.string "channel_data_field", limit: 150
  end

  create_table "channels", force: :cascade do |t|
    t.string  "name",             limit: 200
    t.string  "business_model",   limit: 200
    t.boolean "active",                       default: true
    t.boolean "has_multiple_sku",             default: false
  end

  create_table "cities_detail", force: :cascade do |t|
    t.string "name", limit: 40
  end

  create_table "city", force: :cascade do |t|
    t.string "name", limit: 100
  end

  create_table "crawled_product_sellers", force: :cascade do |t|
    t.boolean "is_new_seller"
    t.float   "rating"
    t.float   "price",          default: 0.0
    t.float   "shipping_price", default: 0.0
    t.boolean "is_buy_box"
    t.boolean "is_min_box"
    t.boolean "is_max_box"
    t.integer "seller_id"
    t.integer "crawler_log_id"
    t.integer "product_id"
    t.text    "seller_name"
    t.date    "crawl_date",     default: "now()"
    t.integer "channel_id"
    t.boolean "is_active"
    t.text    "channel_sku"
    t.text    "city"
  end

  add_index "crawled_product_sellers", ["crawl_date", "is_active"], name: "IX_crawlDate_isActive", using: :btree

  create_table "crawled_products", force: :cascade do |t|
    t.integer  "product_id",       limit: 8
    t.integer  "channel_id"
    t.float    "mrp",                          default: 0.0
    t.float    "selling_price",                default: 0.0
    t.string   "status",           limit: 100
    t.date     "crawl_date",                   default: "now()"
    t.string   "city",             limit: 100
    t.string   "area"
    t.string   "zone",             limit: 100
    t.string   "state",            limit: 100
    t.integer  "crawler_log_id"
    t.jsonb    "product_ext_json"
    t.datetime "creation_time",                default: "now()"
    t.boolean  "is_active"
    t.string   "channel_sku",      limit: 50
  end

  add_index "crawled_products", ["crawl_date", "is_active", "status"], name: "IX_products_crawlDate_isActive", using: :btree
  add_index "crawled_products", ["crawl_date"], name: "IX_crawl_date", using: :btree

  create_table "crawled_promotions", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "city_id"
    t.string   "area",           limit: 200
    t.string   "zone",           limit: 100
    t.string   "offer",          limit: 100
    t.integer  "channel_id"
    t.string   "channel_sku",    limit: 50
    t.string   "stock_status",   limit: 50
    t.string   "offer_status",   limit: 50
    t.datetime "creation_time"
    t.date     "crawl_date"
    t.integer  "crawler_log_id"
    t.boolean  "is_active"
    t.string   "offer_title"
  end

  create_table "crawler_best_seller", id: false, force: :cascade do |t|
    t.string   "id",                 limit: 150,                                                               null: false
    t.integer  "channel_id",                     default: "nextval('best_seller_channel_id_seq'::regclass)",   null: false
    t.text     "search_key"
    t.string   "ref_id",             limit: 150
    t.datetime "discontinue"
    t.datetime "created_timestamp"
    t.jsonb    "best_seller_detail"
    t.string   "created_by",         limit: 50
    t.integer  "srno",                           default: "nextval('crawler_best_seller_srno_seq'::regclass)", null: false
  end

  create_table "crawler_best_seller_history", id: false, force: :cascade do |t|
    t.string   "id",                 limit: 150,                                                                     null: false
    t.integer  "channel_id",                     default: "nextval('best_seller_history_channel_id_seq'::regclass)", null: false
    t.text     "search_key"
    t.string   "ref_id",             limit: 150
    t.jsonb    "best_seller_detail"
    t.datetime "discontinue"
    t.datetime "created_timestamp"
  end

  create_table "crawler_category", id: false, force: :cascade do |t|
    t.integer  "seq_id",                        default: "nextval('crawler_category_seq_id_seq'::regclass)", null: false
    t.integer  "channel_id",                                                                                 null: false
    t.text     "search_key"
    t.string   "ref_id",            limit: 150
    t.jsonb    "detail"
    t.datetime "discontinue"
    t.datetime "created_timestamp"
    t.string   "created_by",        limit: 50
  end

  create_table "crawler_category_history", id: false, force: :cascade do |t|
    t.string   "category_id",       limit: 150,                                                                  null: false
    t.integer  "channel_id",                    default: "nextval('category_history_channel_id_seq'::regclass)", null: false
    t.text     "search_key"
    t.string   "ref_id",            limit: 150
    t.jsonb    "detail"
    t.datetime "discontinue"
    t.datetime "created_timestamp"
  end

  create_table "crawler_channel_url_pattern", id: false, force: :cascade do |t|
    t.string   "url_type",               limit: 20,                                                                      null: false
    t.text     "url",                                                                                                    null: false
    t.jsonb    "data_xpath"
    t.datetime "created_timestamp"
    t.datetime "last_updated_timestamp"
    t.string   "created_by",             limit: 100
    t.string   "last_updated_by",        limit: 100
    t.integer  "channel_id",                         default: "nextval('channel_url_pattern_channel_id_seq'::regclass)", null: false
  end

# Could not dump table "crawler_channels" because of following StandardError
#   Unknown type 'time with time zone' for column 'from_date'

  create_table "crawler_deal", id: false, force: :cascade do |t|
    t.integer  "id",                                  default: "nextval('crawler_deal_id_seq'::regclass)", null: false
    t.integer  "channel_id",                                                                               null: false
    t.string   "url",                     limit: 500,                                                      null: false
    t.string   "deal_type",               limit: 50
    t.string   "deal_status",             limit: 50
    t.string   "channel_deal_id",         limit: 50
    t.jsonb    "deal_detail"
    t.jsonb    "deal_items",                                                                                            array: true
    t.datetime "created_timestamp"
    t.text     "search_key"
    t.string   "created_by",              limit: 50
    t.string   "par_product_channel_sku", limit: 100
  end

  create_table "crawler_delisted_product", id: false, force: :cascade do |t|
    t.integer  "serial_number",                 default: "nextval('crawler_delisted_product_serial_number_seq'::regclass)", null: false
    t.jsonb    "product_detail"
    t.datetime "created_timestamp"
    t.string   "created_by",        limit: 100
    t.integer  "channel_id",                                                                                                null: false
  end

  create_table "crawler_group_request", force: :cascade do |t|
    t.text     "request_type"
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_timestamp"
    t.datetime "updated_timestamp"
    t.text     "status"
  end

  create_table "crawler_log", force: :cascade do |t|
    t.integer  "channel_id"
    t.string   "type",                  limit: 50
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "total_crawled_records"
    t.integer  "successful_records"
    t.integer  "failed_records"
    t.string   "mode",                  limit: 100
  end

  create_table "crawler_logs", id: false, force: :cascade do |t|
    t.integer  "srno",         default: "nextval('crawler_logs_srno_seq'::regclass)", null: false
    t.text     "crawler_name"
    t.integer  "channel_id"
    t.integer  "group_id"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "crawler_new_release", id: false, force: :cascade do |t|
    t.string   "id",                limit: 150,                                                               null: false
    t.integer  "channel_id",                    default: "nextval('new_release_channel_id_seq'::regclass)",   null: false
    t.text     "search_key"
    t.string   "ref_id",            limit: 150
    t.datetime "discontinue"
    t.datetime "created_timestamp"
    t.jsonb    "release_detail"
    t.string   "created_by",        limit: 50
    t.integer  "srno",                          default: "nextval('crawler_new_release_srno_seq'::regclass)", null: false
  end

  create_table "crawler_new_release_history", id: false, force: :cascade do |t|
    t.string   "id",                limit: 150,                                                                     null: false
    t.integer  "channel_id",                    default: "nextval('new_release_history_channel_id_seq'::regclass)", null: false
    t.text     "search_key"
    t.string   "ref_id",            limit: 150
    t.jsonb    "release_detail"
    t.datetime "discontinue"
    t.datetime "created_timestamp"
  end

  create_table "crawler_product", id: false, force: :cascade do |t|
    t.string   "pid",               limit: 50,                                                                        null: false
    t.jsonb    "product_detail"
    t.datetime "created_timestamp"
    t.string   "created_by",        limit: 100
    t.text     "search_key"
    t.integer  "channel_id",                    default: "nextval('product_channel_id_seq'::regclass)",               null: false
    t.integer  "srno",                          default: "nextval('"crawler_product_sequenceNumber_seq"'::regclass)", null: false
  end

  create_table "crawler_product_09092016", id: false, force: :cascade do |t|
    t.string   "pid",               limit: 50,                                                                        null: false
    t.jsonb    "product_detail"
    t.datetime "created_timestamp"
    t.string   "created_by",        limit: 100
    t.text     "search_key"
    t.integer  "channel_id",                    default: "nextval('product_channel_id_seq'::regclass)",               null: false
    t.integer  "srno",                          default: "nextval('"crawler_product_sequenceNumber_seq"'::regclass)", null: false
  end

  create_table "crawler_product_history", id: false, force: :cascade do |t|
    t.string   "pid",               limit: 20
    t.jsonb    "product_detail"
    t.integer  "channel_id",                   default: "nextval('product_history_channel_id_seq'::regclass)", null: false
    t.datetime "created_timestamp"
  end

  create_table "crawler_product_offer_detail", id: false, force: :cascade do |t|
    t.integer  "id",                default: "nextval('crawler_product_offer_detail_id_seq'::regclass)", null: false
    t.text     "productname"
    t.text     "productimage"
    t.text     "brand"
    t.text     "pimcategoryname"
    t.text     "city"
    t.text     "area"
    t.text     "zone"
    t.text     "sellername"
    t.text     "offerlink"
    t.text     "offertext"
    t.text     "pimcategoryid"
    t.text     "producturl"
    t.text     "producttype"
    t.datetime "created_timestamp"
    t.text     "productid"
    t.integer  "channelid"
    t.integer  "group_id"
    t.text     "offer_title"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "pim_sku_id"
    t.text     "offer_mismatch"
    t.text     "offer"
    t.text     "pim_offer"
    t.text     "stock_status"
    t.text     "status"
    t.float    "productmrp"
    t.float    "sellingprice"
  end

  create_table "crawler_product_reviews", primary_key: "review_id", force: :cascade do |t|
    t.integer  "channel_id"
    t.text     "product_id"
    t.integer  "total_count"
    t.float    "total_rating"
    t.float    "rating_by_customer"
    t.text     "title"
    t.text     "customer_name"
    t.text     "review_text"
    t.date     "review_date"
    t.jsonb    "others"
    t.text     "created_by"
    t.datetime "last_updated_timestamp"
    t.datetime "created_timestamp"
    t.text     "channel_review_id"
    t.text     "sentiment"
    t.jsonb    "aspect_sentiments"
    t.float    "sentiment_score"
  end

  create_table "crawler_promotions", id: false, force: :cascade do |t|
    t.integer  "promo_id",               default: "nextval('promotions_promo_id_seq'::regclass)",   null: false
    t.integer  "channel_id",             default: "nextval('promotions_channel_id_seq'::regclass)", null: false
    t.datetime "from_date"
    t.datetime "thru_date"
    t.jsonb    "promo_detail"
    t.datetime "created_timestamp"
    t.datetime "last_updated_timestamp"
    t.text     "search_key"
  end

  create_table "crawler_review_prcosessed_data", id: false, force: :cascade do |t|
    t.integer  "seq_id",            default: "nextval('crawler_review_prcosessed_data_seq_id_seq'::regclass)", null: false
    t.text     "pim_sku_id"
    t.text     "channel_sku"
    t.integer  "channel_id"
    t.integer  "group_id"
    t.integer  "total_reviews"
    t.integer  "positive_reviews"
    t.integer  "negative_reviews"
    t.text     "product_name"
    t.text     "category_id"
    t.text     "category_name"
    t.text     "brand"
    t.text     "product_type"
    t.datetime "created_timestamp"
  end

  create_table "crawler_search_results", id: false, force: :cascade do |t|
    t.string   "searchkeyword",     limit: 200
    t.integer  "channel_id"
    t.datetime "created_timestamp"
    t.jsonb    "result_json"
    t.integer  "srno",                          default: "nextval('"crawler_search_results_sequenceNumber_seq"'::regclass)", null: false
  end

  create_table "crawler_seller_dep", id: false, force: :cascade do |t|
    t.integer  "id",                                 default: "nextval('seller_dep_id_seq'::regclass)",         null: false
    t.integer  "channel_id",                         default: "nextval('seller_dep_channel_id_seq'::regclass)", null: false
    t.text     "seller_name"
    t.text     "access_link"
    t.string   "ref_id",                 limit: 150
    t.datetime "discontinue"
    t.datetime "created_timestamp"
    t.datetime "last_updated_timestamp"
    t.text     "search_key"
    t.text     "store_name"
  end

  create_table "dashboard_detail", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.text     "type"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_timestamp"
    t.datetime "discontinue_on"
  end

  create_table "data_visulization_detail", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.string   "type"
    t.text     "thumbnail_img"
    t.float    "price"
    t.datetime "created_timestamp"
    t.text     "api"
    t.text     "method_name"
    t.text     "template"
    t.boolean  "has_city"
    t.boolean  "default_view"
  end

  create_table "deleted_product", force: :cascade do |t|
    t.jsonb    "product_json", null: false
    t.integer  "delete_by"
    t.datetime "delete_time"
  end

  add_index "deleted_product", ["product_json"], name: "deleted_product_product_json_index", using: :gin

  create_table "group_brand_mapping", force: :cascade do |t|
    t.integer "group_id"
    t.integer "brand_id"
  end

  create_table "group_category", force: :cascade do |t|
    t.integer "group_id",    null: false
    t.string  "category_id", null: false
  end

  create_table "group_channel", force: :cascade do |t|
    t.integer  "group_id",               default: "nextval('group_channel_group_id_seq'::regclass)",   null: false
    t.integer  "channel_id",             default: "nextval('group_channel_channel_id_seq'::regclass)", null: false
    t.boolean  "enabled"
    t.datetime "last_updated_timestamp"
    t.datetime "created_timestamp"
  end

  create_table "group_channel_mapping", force: :cascade do |t|
    t.integer "group_id"
    t.integer "channel_id"
  end

  add_index "group_channel_mapping", ["group_id", "channel_id"], name: "IX_group_channel_unique", unique: true, using: :btree

  create_table "group_detail", force: :cascade do |t|
    t.string   "name",               limit: 50,              null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.jsonb    "header_json"
    t.jsonb    "associated_channel"
    t.string   "email"
    t.string   "user_id"
    t.string   "secret_key"
    t.text     "authorize_urls",                default: [],              array: true
    t.integer  "count",                         default: 0,  null: false
  end

  create_table "group_email_info", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.jsonb   "email"
  end

  create_table "group_product_mapping", force: :cascade do |t|
    t.integer "group_id"
    t.integer "my_product_id",          limit: 8
    t.integer "competitor_product_id",  limit: 8
    t.boolean "is_competitor"
    t.integer "valid_channel_products",           default: [], array: true
    t.string  "custom_sku"
  end

  add_index "group_product_mapping", ["group_id", "my_product_id", "competitor_product_id"], name: "group_products_relationship", unique: true, using: :btree

  create_table "group_seller_list", force: :cascade do |t|
    t.integer  "seller_id"
    t.integer  "group_id"
    t.datetime "created_timestamp"
    t.datetime "updated_timestamp"
    t.boolean  "authorised"
  end

  create_table "group_visulization", force: :cascade do |t|
    t.integer "group_id"
    t.integer "chart_id"
    t.integer "sequence"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",               limit: 200
    t.datetime "start_date",                     default: "now()"
    t.datetime "end_date",                       default: "(now() + '30 days'::interval)"
    t.boolean  "agreement_accepted"
    t.string   "notify_to_email",    limit: 500
  end

  create_table "image_detail", force: :cascade do |t|
    t.jsonb    "image_json",    null: false
    t.integer  "group_id",      null: false
    t.jsonb    "sku_ids_json"
    t.datetime "creation_time"
    t.datetime "updation_time"
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  add_index "image_detail", ["image_json"], name: "image_json_index", using: :gin

  create_table "keywords_insights", id: false, force: :cascade do |t|
    t.integer  "srno",              default: "nextval('keywords_insights_srno_seq'::regclass)", null: false
    t.integer  "group_id"
    t.integer  "channel_id"
    t.text     "search_keyword"
    t.integer  "weightage"
    t.datetime "created_timestamp"
  end

  create_table "label_detail", force: :cascade do |t|
    t.text     "label_name"
    t.integer  "user_id",           default: "nextval('label_detail_user_id_seq'::regclass)",  null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_timestamp"
    t.integer  "group_id",          default: "nextval('label_detail_group_id_seq'::regclass)", null: false
  end

  create_table "label_prod_assoc", force: :cascade do |t|
    t.integer  "label_id",          default: "nextval('label_prod_assoc_label_id_seq'::regclass)",    null: false
    t.integer  "user_id",           default: "nextval('label_prod_assoc_user_id_seq'::regclass)",     null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_timestamp"
    t.integer  "product_pid",       default: "nextval('label_prod_assoc_product_pid_seq'::regclass)", null: false
    t.integer  "group_id",          default: "nextval('label_prod_assoc_group_id_seq'::regclass)",    null: false
  end

  create_table "latest_operation", force: :cascade do |t|
    t.string   "action",      null: false
    t.integer  "group_id",    null: false
    t.integer  "user_id",     null: false
    t.datetime "action_time"
    t.integer  "product_id"
  end

  create_table "localbanya_sales", force: :cascade do |t|
    t.integer "product_id",  null: false
    t.text    "weight_code"
    t.text    "brand",       null: false
    t.text    "description"
    t.text    "size"
    t.integer "revenue"
    t.time    "sale_date"
  end

  create_table "peppertap_sale", force: :cascade do |t|
    t.text    "product_name"
    t.integer "qty"
    t.time    "sale_date"
    t.text    "ean",          null: false
  end

  create_table "ppimage_detailpp", id: false, force: :cascade do |t|
    t.integer "id",         default: "nextval('ppimage_detailpp_id_seq'::regclass)", null: false
    t.jsonb   "image_json",                                                          null: false
    t.integer "group_id",                                                            null: false
    t.jsonb   "sku_id",                                                              null: false
  end

  create_table "product_aspects_info", id: false, force: :cascade do |t|
    t.text "productid"
    t.text "posaspects"
    t.text "negaspects"
  end

  create_table "product_channel_assoc", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "group_id"
    t.integer  "channel_id"
    t.text     "channel_sku"
    t.float    "channel_price"
    t.jsonb    "other_detail"
    t.integer  "created_by"
    t.datetime "created_timestamp"
    t.datetime "discontinue"
    t.text     "assoc_type"
  end

  add_index "product_channel_assoc", ["assoc_type"], name: "prod_chk_assoc_type", using: :btree
  add_index "product_channel_assoc", ["channel_id"], name: "prod_chk_indx_chnl_id", using: :btree
  add_index "product_channel_assoc", ["channel_sku"], name: "prod_chk_chnl_sku", using: :btree
  add_index "product_channel_assoc", ["group_id"], name: "prod_chk_grp_id", using: :btree
  add_index "product_channel_assoc", ["product_id"], name: "prod_chk_prod_id", using: :btree

  create_table "product_detail", force: :cascade do |t|
    t.jsonb    "product_json",              null: false
    t.integer  "group_id",                  null: false
    t.datetime "creation_time"
    t.datetime "updation_time"
    t.jsonb    "city_wise_mrp"
    t.string   "inserting_mode", limit: 50
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  add_index "product_detail", ["group_id"], name: "prod_grp_id", using: :btree
  add_index "product_detail", ["id"], name: "product_id", using: :btree
  add_index "product_detail", ["product_json"], name: "product_json_index", using: :gin

  create_table "product_detail_temp", force: :cascade do |t|
    t.jsonb    "product_json",              null: false
    t.integer  "group_id",                  null: false
    t.datetime "creation_time"
    t.datetime "updation_time"
    t.jsonb    "city_wise_mrp"
    t.string   "inserting_mode", limit: 50
  end

  add_index "product_detail_temp", ["product_json"], name: "product_json_index_temp", using: :gin

  create_table "product_history", id: false, force: :cascade do |t|
    t.integer  "id",            default: "nextval('product_history_id_seq'::regclass)", null: false
    t.jsonb    "product_json",                                                          null: false
    t.integer  "group_id",                                                              null: false
    t.datetime "updation_time"
  end

  add_index "product_history", ["product_json"], name: "deleted_product_json_index", using: :gin

  create_table "product_price_history", force: :cascade do |t|
    t.integer  "product_id",         null: false
    t.float    "last_selling_price"
    t.datetime "price_change_date"
    t.integer  "group_id"
    t.float    "last_mrp_price"
    t.integer  "changes_by"
  end

# Could not dump table "product_price_limit" because of following StandardError
#   Unknown type 'time with time zone' for column 'creation_time'

  create_table "product_reviews_processed", id: false, force: :cascade do |t|
    t.text    "product_id"
    t.float   "average"
    t.date    "created_timestamp"
    t.decimal "total_count"
    t.decimal "positive_count"
    t.decimal "negative_count"
  end

  create_table "product_sale", force: :cascade do |t|
    t.text     "sku_id",                     null: false
    t.decimal  "sales_qty",    default: 0.0
    t.decimal  "sales_value",  default: 0.0
    t.integer  "channel_code"
    t.text     "city"
    t.integer  "group_id"
    t.datetime "sale_date"
    t.text     "product_name"
    t.text     "brand_name"
    t.datetime "update_time"
    t.integer  "updated_by"
  end

  create_table "products", force: :cascade do |t|
    t.string   "sku_id",        limit: 50,  default: "(date_part('epoch'::text, now()) * (100000)::double precision)"
    t.string   "name",          limit: 500
    t.integer  "brand_id",                  default: -1
    t.integer  "category_id",               default: -1
    t.float    "price",                     default: 0.0
    t.datetime "creation_time",             default: "now()"
    t.integer  "created_by",                default: -1
    t.datetime "updation_time",             default: "now()"
    t.integer  "updated_by",                default: -1
    t.text     "image_url"
    t.text     "description"
    t.float    "selling_price",             default: 0.0
    t.boolean  "is_complete",               default: false
  end

  create_table "products_alert", primary_key: "alert_id", force: :cascade do |t|
    t.integer  "product_id",                                   null: false
    t.float    "price",                      default: 0.0
    t.text     "alert_status",               default: "UP"
    t.datetime "alert_create_time",          default: "now()"
    t.integer  "group_id",                                     null: false
    t.time     "alert_generate_timestamp"
    t.text     "alert_generate_text"
    t.text     "alert_generate_description"
    t.text     "alert_generate",             default: "false"
    t.integer  "channel_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.integer  "channel_id"
    t.string   "channel_sku",   limit: 50
    t.integer  "product_id"
    t.string   "offer",         limit: 100
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "group_id"
    t.integer  "city_id"
    t.string   "type",          limit: 50
    t.integer  "created_by"
    t.datetime "creation_time"
    t.integer  "updated_by"
    t.datetime "updation_time"
  end

  create_table "region", id: false, force: :cascade do |t|
    t.text     "city",                                                                   null: false
    t.datetime "created_timestamp"
    t.datetime "last_updated_timestamp"
    t.text     "area"
    t.text     "loc_id"
    t.integer  "pincode"
    t.text     "country"
    t.text     "zone"
    t.decimal  "lon"
    t.decimal  "lat"
    t.text     "comp_address"
    t.text     "state"
    t.integer  "id",                     default: "nextval('region_id_seq1'::regclass)", null: false
  end

  create_table "result", id: false, force: :cascade do |t|
    t.float "?column?"
  end

  create_table "review_action_status", id: false, force: :cascade do |t|
    t.integer  "seq_id",                 default: "nextval('review_action_status_seq_id_seq'::regclass)", null: false
    t.integer  "group_id"
    t.integer  "user_id"
    t.text     "user_action"
    t.integer  "review_id"
    t.datetime "created_timestamp"
    t.datetime "last_updated_timestamp"
  end

  create_table "review_chart_product_map", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.integer "pim_sku"
  end

  create_table "role", force: :cascade do |t|
    t.string "name", limit: 50, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 50
  end

  create_table "sellers", force: :cascade do |t|
    t.string   "name",          limit: 200
    t.integer  "created_by",                default: -1
    t.datetime "creation_time",             default: "now()"
  end

  create_table "status", force: :cascade do |t|
    t.string "name", limit: 50
  end

  create_table "tags", force: :cascade do |t|
    t.text     "tag_name",      null: false
    t.integer  "group_id"
    t.datetime "creation_time"
    t.datetime "updation_time"
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  create_table "test", id: false, force: :cascade do |t|
    t.integer "id",   default: "nextval('test_id_seq'::regclass)", null: false
    t.jsonb   "name"
  end

  create_table "useless_product_id", id: false, force: :cascade do |t|
    t.integer "id"
  end

  create_table "user_detail", force: :cascade do |t|
    t.jsonb    "user_json",     null: false
    t.datetime "updation_time"
    t.datetime "creation_time"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.text     "auth_mode"
  end

  add_index "user_detail", ["user_json"], name: "user_detail_user_json_idx", using: :gin

  create_table "user_notifications", primary_key: "srno", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.text     "notification_type"
    t.text     "title"
    t.text     "notification_text"
    t.text     "icon_image"
    t.text     "status"
    t.text     "redirect_url"
    t.datetime "created_timestamp"
    t.datetime "read_timestamp"
    t.integer  "operation_by"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "group_id",                                    null: false
    t.string   "firstname",     limit: 100
    t.string   "lastname",      limit: 100
    t.string   "username",      limit: 200,                   null: false
    t.string   "password",      limit: 200
    t.string   "auth_mode",     limit: 100
    t.datetime "creation_time",             default: "now()"
    t.integer  "role_id",                                     null: false
    t.integer  "status_id",                 default: 2,       null: false
    t.integer  "created_by"
    t.datetime "updation_time",             default: "now()"
    t.integer  "updated_by",                default: -1
    t.string   "salt",          limit: 50
    t.string   "email",         limit: 50
    t.jsonb    "menu_json"
  end

  add_index "users", ["username"], name: "users_username_key", unique: true, using: :btree

  create_table "video_detail", force: :cascade do |t|
    t.jsonb    "video_json",    null: false
    t.integer  "group_id",      null: false
    t.jsonb    "sku_ids_json"
    t.datetime "creation_time"
    t.datetime "updation_time"
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  add_index "video_detail", ["video_json"], name: "video_json_index", using: :gin

  add_foreign_key "brand_catg_assoc", "user_detail", column: "created_by", name: "brand_catg_uid_fk"
  add_foreign_key "brand_detail", "user_detail", column: "created_by", name: "brand_uid_fk"
  add_foreign_key "brand_sale", "group_detail", column: "group_id", name: "group_detail.id"
  add_foreign_key "category_grp_keywords", "category_detail", column: "category_id", name: "cgk_cat_fk"
  add_foreign_key "category_grp_keywords", "channel_detail", column: "channel_id", name: "cgk_chnl_fk"
  add_foreign_key "category_grp_keywords", "group_detail", column: "group_id", name: "cgk_grp_fk"
  add_foreign_key "category_grp_keywords", "user_detail", column: "user_id", name: "cgk_usr_fk"
  add_foreign_key "category_sale", "group_detail", column: "group_id", name: "category_sale.group_detail.id"
  add_foreign_key "channel_city_mapping", "channels", name: "channel_city_channel_id_fkey"
  add_foreign_key "channel_city_mapping", "city", name: "channel_city_city_id_fkey"
  add_foreign_key "channel_product_mapping", "channels", name: "channel_product_mapping_channel_id_fkey"
  add_foreign_key "channel_product_mapping", "products", name: "channel_product_mapping_product_id_fkey"
  add_foreign_key "channel_product_mapping", "status", name: "channel_product_mapping_status_id_fkey"
  add_foreign_key "channel_product_mapping", "users", column: "created_by", name: "channel_product_mapping_created_by_fkey"
  add_foreign_key "channel_product_mapping", "users", column: "updated_by", name: "channel_product_mapping_updated_by_fkey"
  add_foreign_key "channel_promotions", "channel_detail", column: "channel_id", name: "promo_fk"
  add_foreign_key "channel_promotions_temp", "channel_detail", column: "channel_id", name: "promo_tmp_fk"
  add_foreign_key "channel_promotions_temp_n", "channel_detail", column: "channel_id", name: "promo_tmpn_fk"
  add_foreign_key "channel_seller_mapping", "channels", name: "channel_seller_mapping_channel_id_fkey"
  add_foreign_key "channel_seller_mapping", "groups", name: "channel_seller_mapping_group_id_fkey"
  add_foreign_key "channel_seller_mapping", "sellers", name: "channel_seller_mapping_seller_id_fkey"
  add_foreign_key "channel_seller_mapping", "users", column: "updated_by", name: "channel_seller_mapping_updated_by_fkey"
  add_foreign_key "crawled_product_sellers", "crawler_log", name: "crawled_product_sellers_crawler_log_id_fkey"
  add_foreign_key "crawled_product_sellers", "products", name: "crawled_product_sellers_product_id_fkey"
  add_foreign_key "crawled_product_sellers", "sellers", name: "crawled_product_sellers_seller_id_fkey"
  add_foreign_key "crawled_products", "channels", name: "crawled_products_channel_id_fkey"
  add_foreign_key "crawled_products", "crawler_log", name: "crawled_products_crawler_log_id_fkey"
  add_foreign_key "crawled_products", "products", name: "crawled_products_product_id_fkey"
  add_foreign_key "crawled_promotions", "channels", name: "crawled_promotions_channel_id_fkey"
  add_foreign_key "crawled_promotions", "crawler_log", name: "crawled_promotions_crawler_log_id_fkey"
  add_foreign_key "crawled_promotions", "products", name: "crawled_promotions_product_id_fkey"
  add_foreign_key "dashboard_detail", "group_detail", column: "group_id", name: "dashboard_grp_id"
  add_foreign_key "dashboard_detail", "user_detail", column: "user_id", name: "dashboard_usr_id"
  add_foreign_key "group_brand_mapping", "brands", name: "group_brand_mapping_brand_id_fkey"
  add_foreign_key "group_brand_mapping", "groups", name: "group_brand_mapping_group_id_fkey"
  add_foreign_key "group_channel", "channel_detail", column: "channel_id", name: "grp_chnl_cid_fk"
  add_foreign_key "group_channel", "group_detail", column: "group_id", name: "grp_chnl_gp_fk"
  add_foreign_key "group_channel_mapping", "channels", name: "group_channel_mapping_channel_id_fkey"
  add_foreign_key "group_channel_mapping", "groups", name: "group_channel_mapping_group_id_fkey"
  add_foreign_key "group_product_mapping", "groups", name: "group_product_mapping_group_id_fkey"
  add_foreign_key "group_product_mapping", "products", column: "competitor_product_id", name: "group_product_mapping_competitor_product_id_fkey"
  add_foreign_key "group_product_mapping", "products", column: "my_product_id", name: "group_product_mapping_my_product_id_fkey"
  add_foreign_key "label_detail", "user_detail", column: "user_id", name: "label_usr_id"
  add_foreign_key "label_prod_assoc", "label_detail", column: "label_id", name: "label_id_fk"
  add_foreign_key "label_prod_assoc", "product_detail", column: "product_pid", name: "label_prod_pid_fk"
  add_foreign_key "label_prod_assoc", "user_detail", column: "user_id", name: "lable_uid_fk"
  add_foreign_key "product_channel_assoc", "channel_detail", column: "channel_id", name: "prod_chnl_id"
  add_foreign_key "product_channel_assoc", "group_detail", column: "group_id", name: "prod_chnl_grp_id"
  add_foreign_key "product_channel_assoc", "product_detail", column: "product_id", name: "prod_chnl_prodid"
  add_foreign_key "product_channel_assoc", "user_detail", column: "created_by", name: "prod_chnl_usrid"
  add_foreign_key "product_price_limit", "channels", name: "product_price_limit_channel_id_fkey"
  add_foreign_key "product_price_limit", "groups", name: "product_price_limit_group_id_fkey"
  add_foreign_key "product_price_limit", "products", name: "product_price_limit_product_id_fkey"
  add_foreign_key "product_price_limit", "users", column: "created_by", name: "product_price_limit_created_by_fkey"
  add_foreign_key "product_sale", "group_detail", column: "group_id", name: "product_sale.group_id"
  add_foreign_key "products", "users", column: "created_by", name: "products_created_by_fkey"
  add_foreign_key "products", "users", column: "updated_by", name: "products_updated_by_fkey"
  add_foreign_key "promotions", "channels", name: "promotions_channel_id_fkey"
  add_foreign_key "promotions", "city", name: "promotions_city_id_fkey"
  add_foreign_key "promotions", "groups", name: "promotions_group_id_fkey"
  add_foreign_key "promotions", "products", name: "promotions_product_id_fkey"
  add_foreign_key "promotions", "users", column: "created_by", name: "promotions_created_by_fkey"
  add_foreign_key "promotions", "users", column: "updated_by", name: "promotions_updated_by_fkey"
  add_foreign_key "sellers", "users", column: "created_by", name: "sellers_created_by_fkey"
  add_foreign_key "tags", "group_detail", column: "group_id", name: "group_id"
  add_foreign_key "user_notifications", "group_detail", column: "group_id", name: "notification_group_forign_key"
  add_foreign_key "user_notifications", "user_detail", column: "user_id", name: "notification_forign_key"
  add_foreign_key "users", "groups", name: "users_group_id_fkey"
  add_foreign_key "users", "roles", name: "users_role_id_fkey"
  add_foreign_key "users", "status", name: "users_status_id_fkey"
  add_foreign_key "users", "users", column: "created_by", name: "users_created_by_fkey"
  add_foreign_key "users", "users", column: "updated_by", name: "users_updated_by_fkey"
end
