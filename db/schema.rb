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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130701051444) do

  create_table "c_pcard_relations", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "package_card_id"
    t.datetime "ended_at"
    t.boolean  "status"
    t.text     "content"
    t.datetime "created_at"
  end

  add_index "c_pcard_relations", ["customer_id"], :name => "index_c_pcard_relations_on_customer_id"
  add_index "c_pcard_relations", ["package_card_id"], :name => "index_c_pcard_relations_on_package_card_id"
  add_index "c_pcard_relations", ["status"], :name => "index_c_pcard_relations_on_status"

  create_table "c_svc_relations", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "sv_card_id"
    t.float    "total_price"
    t.float    "left_price"
    t.string   "id_card"
    t.boolean  "is_billing"
    t.datetime "created_at"
    t.string   "verify_code"
  end

  add_index "c_svc_relations", ["customer_id"], :name => "index_c_svc_relations_on_customer_id"
  add_index "c_svc_relations", ["sv_card_id"], :name => "index_c_svc_relations_on_sv_card_id"

  create_table "capitals", :force => true do |t|
    t.string "name"
  end

  create_table "car_brands", :force => true do |t|
    t.string  "name"
    t.integer "capital_id"
  end

  add_index "car_brands", ["capital_id"], :name => "index_car_brands_on_capital_id"
  add_index "car_brands", ["name"], :name => "index_car_brands_on_name"

  create_table "car_models", :force => true do |t|
    t.string   "name"
    t.integer  "car_brand_id"
    t.datetime "created_at"
  end

  add_index "car_models", ["car_brand_id"], :name => "index_car_models_on_car_brand_id"
  add_index "car_models", ["created_at"], :name => "index_car_models_on_created_at"
  add_index "car_models", ["name"], :name => "index_car_models_on_name"

  create_table "car_nums", :force => true do |t|
    t.string  "num"
    t.integer "car_model_id"
  end

  add_index "car_nums", ["car_model_id"], :name => "index_car_nums_on_car_model_id"
  add_index "car_nums", ["num"], :name => "index_car_nums_on_num"

  create_table "chart_images", :force => true do |t|
    t.integer  "city_id"
    t.integer  "current_month"
    t.string   "image_url"
    t.datetime "created_at"
  end

  add_index "chart_images", ["city_id"], :name => "index_chart_images_on_city_id"
  add_index "chart_images", ["current_month"], :name => "index_chart_images_on_current_month"
  add_index "chart_images", ["image_url"], :name => "index_chart_images_on_image_url"

  create_table "cities", :force => true do |t|
    t.integer "order_index"
    t.string  "name"
    t.integer "parent_id"
  end

  add_index "cities", ["order_index"], :name => "index_cities_on_order_index"
  add_index "cities", ["parent_id"], :name => "index_cities_on_parent_id"

  create_table "customer_num_relations", :force => true do |t|
    t.integer "customer_id"
    t.integer "car_num_id"
  end

  add_index "customer_num_relations", ["car_num_id"], :name => "index_customer_num_relations_on_car_num_id"
  add_index "customer_num_relations", ["customer_id"], :name => "index_customer_num_relations_on_customer_id"

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "mobilephone"
    t.string   "other_way"
    t.boolean  "sex"
    t.datetime "birthday"
    t.string   "address"
    t.boolean  "is_vip",      :default => false
    t.string   "mark"
    t.boolean  "status",      :default => false
    t.integer  "types"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["birthday"], :name => "index_customers_on_birthday"
  add_index "customers", ["is_vip"], :name => "index_customers_on_is_vip"
  add_index "customers", ["mobilephone"], :name => "index_customers_on_mobilephone"
  add_index "customers", ["name"], :name => "index_customers_on_name"
  add_index "customers", ["status"], :name => "index_customers_on_status"
  add_index "customers", ["types"], :name => "index_customers_on_types"

  create_table "image_urls", :force => true do |t|
    t.integer "product_id"
    t.string  "img_url"
  end

  add_index "image_urls", ["product_id"], :name => "index_image_urls_on_product_id"

  create_table "mat_in_orders", :force => true do |t|
    t.integer  "material_order_id"
    t.integer  "material_id"
    t.integer  "material_num"
    t.float    "price"
    t.integer  "staff_id"
    t.datetime "created_at"
  end

  add_index "mat_in_orders", ["created_at"], :name => "index_mat_in_orders_on_created_at"
  add_index "mat_in_orders", ["material_id"], :name => "index_mat_in_orders_on_material_id"
  add_index "mat_in_orders", ["material_order_id"], :name => "index_mat_in_orders_on_material_order_id"
  add_index "mat_in_orders", ["staff_id"], :name => "index_mat_in_orders_on_staff_id"

  create_table "mat_order_items", :force => true do |t|
    t.integer "material_order_id"
    t.integer "material_id"
    t.integer "material_num"
    t.float   "price"
  end

  add_index "mat_order_items", ["material_id"], :name => "index_mat_order_items_on_material_id"
  add_index "mat_order_items", ["material_order_id"], :name => "index_mat_order_items_on_material_order_id"

  create_table "mat_out_orders", :force => true do |t|
    t.integer  "material_id"
    t.integer  "staff_id"
    t.integer  "material_num"
    t.float    "price"
    t.integer  "material_order_id"
    t.datetime "created_at"
  end

  add_index "mat_out_orders", ["created_at"], :name => "index_mat_out_orders_on_created_at"
  add_index "mat_out_orders", ["material_id"], :name => "index_mat_out_orders_on_material_id"
  add_index "mat_out_orders", ["material_order_id"], :name => "index_mat_out_orders_on_material_order_id"
  add_index "mat_out_orders", ["staff_id"], :name => "index_mat_out_orders_on_staff_id"

  create_table "material_orders", :force => true do |t|
    t.string   "code"
    t.integer  "supplier_id"
    t.integer  "supplier_type"
    t.integer  "status"
    t.integer  "staff_id"
    t.float    "price"
    t.datetime "arrival_at"
    t.string   "logistics_code"
    t.string   "carrier"
    t.integer  "store_id"
    t.string   "remark"
    t.integer  "sale_id"
    t.integer  "m_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "material_orders", ["code"], :name => "index_material_orders_on_code"
  add_index "material_orders", ["m_status"], :name => "index_material_orders_on_m_status"
  add_index "material_orders", ["sale_id"], :name => "index_material_orders_on_sale_id"
  add_index "material_orders", ["staff_id"], :name => "index_material_orders_on_staff_id"
  add_index "material_orders", ["status"], :name => "index_material_orders_on_status"
  add_index "material_orders", ["store_id"], :name => "index_material_orders_on_store_id"
  add_index "material_orders", ["supplier_id"], :name => "index_material_orders_on_supplier_id"
  add_index "material_orders", ["supplier_type"], :name => "index_material_orders_on_supplier_type"

  create_table "materials", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.float    "price"
    t.integer  "storage"
    t.integer  "types"
    t.boolean  "status"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remark"
    t.integer  "check_num"
  end

  add_index "materials", ["name"], :name => "index_materials_on_name"
  add_index "materials", ["status"], :name => "index_materials_on_status"
  add_index "materials", ["store_id"], :name => "index_materials_on_store_id"
  add_index "materials", ["types"], :name => "index_materials_on_types"

  create_table "menus", :force => true do |t|
    t.string   "controller"
    t.string   "name"
    t.datetime "created_at"
  end

  add_index "menus", ["controller"], :name => "index_menus_on_controller"
  add_index "menus", ["created_at"], :name => "index_menus_on_created_at"

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "status",     :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["created_at"], :name => "index_news_on_created_at"
  add_index "news", ["status"], :name => "index_news_on_status"

  create_table "pcard_prod_relations", :force => true do |t|
    t.integer "product_id"
    t.integer "product_num"
    t.integer "package_card_id"
  end

  add_index "pcard_prod_relations", ["package_card_id"], :name => "index_pcard_prod_relations_on_package_card_id"
  add_index "pcard_prod_relations", ["product_id"], :name => "index_pcard_prod_relations_on_product_id"

  create_table "prod_mat_relations", :force => true do |t|
    t.integer "product_id"
    t.integer "material_num"
    t.integer "material_id"
  end

  add_index "prod_mat_relations", ["material_id"], :name => "index_prod_mat_relations_on_material_id"
  add_index "prod_mat_relations", ["product_id"], :name => "index_prod_mat_relations_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.float    "base_price"
    t.float    "sale_price"
    t.string   "description"
    t.integer  "types"
    t.string   "service_code"
    t.boolean  "status"
    t.text     "introduction"
    t.boolean  "is_service"
    t.integer  "staff_level"
    t.integer  "staff_level_1"
    t.string   "img_url"
    t.integer  "cost_time"
    t.integer  "store_id"
    t.string   "standard"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["is_service"], :name => "index_products_on_is_service"
  add_index "products", ["name"], :name => "index_products_on_name"
  add_index "products", ["status"], :name => "index_products_on_status"
  add_index "products", ["store_id"], :name => "index_products_on_store_id"
  add_index "products", ["types"], :name => "index_products_on_types"

  create_table "res_prod_relations", :force => true do |t|
    t.integer "product_id"
    t.integer "reservation_id"
  end

  add_index "res_prod_relations", ["product_id"], :name => "index_res_prod_relations_on_product_id"
  add_index "res_prod_relations", ["reservation_id"], :name => "index_res_prod_relations_on_reservation_id"

  create_table "reservations", :force => true do |t|
    t.integer  "car_num_id"
    t.datetime "res_time"
    t.boolean  "status"
    t.integer  "store_id"
    t.datetime "created_at"
  end

  add_index "reservations", ["car_num_id"], :name => "index_reservations_on_car_num_id"
  add_index "reservations", ["created_at"], :name => "index_reservations_on_created_at"
  add_index "reservations", ["status"], :name => "index_reservations_on_status"
  add_index "reservations", ["store_id"], :name => "index_reservations_on_store_id"

  create_table "role_menu_relations", :force => true do |t|
    t.integer  "role_id"
    t.integer  "menu_id"
    t.datetime "created_at"
  end

  add_index "role_menu_relations", ["created_at"], :name => "index_role_menu_relations_on_created_at"
  add_index "role_menu_relations", ["menu_id"], :name => "index_role_menu_relations_on_menu_id"
  add_index "role_menu_relations", ["role_id"], :name => "index_role_menu_relations_on_role_id"

  create_table "role_model_relations", :force => true do |t|
    t.integer  "role_id"
    t.string   "model_name"
    t.integer  "num"
    t.datetime "created_at"
  end

  add_index "role_model_relations", ["created_at"], :name => "index_role_model_relations_on_created_at"
  add_index "role_model_relations", ["role_id"], :name => "index_role_model_relations_on_role_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
  end

  add_index "roles", ["created_at"], :name => "index_roles_on_created_at"

  create_table "sale_prod_relations", :force => true do |t|
    t.integer "sale_id"
    t.integer "product_id"
    t.integer "prod_num"
  end

  add_index "sale_prod_relations", ["product_id"], :name => "index_sale_prod_relations_on_product_id"
  add_index "sale_prod_relations", ["sale_id"], :name => "index_sale_prod_relations_on_sale_id"

  create_table "sales", :force => true do |t|
    t.string   "name"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.text     "introduction"
    t.integer  "disc_types"
    t.integer  "status"
    t.float    "discount"
    t.integer  "store_id"
    t.integer  "disc_time_types"
    t.integer  "car_num"
    t.integer  "everycar_times"
    t.string   "img_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.string   "code"
    t.boolean  "is_subsidy"
    t.string   "sub_content"
  end

  add_index "sales", ["created_at"], :name => "index_sales_on_created_at"
  add_index "sales", ["status"], :name => "index_sales_on_status"
  add_index "sales", ["store_id"], :name => "index_sales_on_store_id"

  create_table "staff_role_relations", :force => true do |t|
    t.integer  "role_id"
    t.integer  "staff_id"
    t.datetime "created_at"
  end

  add_index "staff_role_relations", ["created_at"], :name => "index_staff_role_relations_on_created_at"
  add_index "staff_role_relations", ["role_id"], :name => "index_staff_role_relations_on_role_id"
  add_index "staff_role_relations", ["staff_id"], :name => "index_staff_role_relations_on_staff_id"

  create_table "staffs", :force => true do |t|
    t.string   "name"
    t.integer  "type_of_w"
    t.integer  "position"
    t.boolean  "sex"
    t.integer  "level"
    t.datetime "birthday"
    t.string   "id_card"
    t.string   "hometown"
    t.integer  "education"
    t.string   "nation"
    t.integer  "political"
    t.string   "phone"
    t.string   "address"
    t.string   "photo"
    t.float    "base_salary"
    t.integer  "deduct_at"
    t.integer  "deduct_end"
    t.float    "deduct_percent"
    t.boolean  "status",             :default => false
    t.integer  "store_id"
    t.string   "encrypted_password"
    t.string   "username"
    t.string   "salt"
    t.boolean  "is_score_ge_salary", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "staffs", ["created_at"], :name => "index_staffs_on_created_at"
  add_index "staffs", ["level"], :name => "index_staffs_on_level"
  add_index "staffs", ["name"], :name => "index_staffs_on_name"
  add_index "staffs", ["position"], :name => "index_staffs_on_position"
  add_index "staffs", ["status"], :name => "index_staffs_on_status"
  add_index "staffs", ["store_id"], :name => "index_staffs_on_store_id"
  add_index "staffs", ["type_of_w"], :name => "index_staffs_on_type_of_w"
  add_index "staffs", ["username"], :name => "index_staffs_on_username"

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "contact"
    t.string   "email"
    t.string   "position"
    t.string   "introduction"
    t.string   "img_url"
    t.datetime "opened_at"
    t.float    "account"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
  end

  add_index "stores", ["city_id"], :name => "index_stores_on_city_id"
  add_index "stores", ["created_at"], :name => "index_stores_on_created_at"

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.string   "contact"
    t.integer  "store_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suppliers", ["created_at"], :name => "index_suppliers_on_created_at"

  create_table "sv_cards", :force => true do |t|
    t.string   "name"
    t.string   "img_url"
    t.integer  "types"
    t.float    "price",       :limit => 11
    t.float    "discount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "sv_cards", ["types"], :name => "index_sv_cards_on_types"

  create_table "svcard_prod_relations", :force => true do |t|
    t.integer "product_id"
    t.integer "product_num"
    t.integer "sv_card_id"
    t.float   "base_price"
    t.float   "more_price"
  end

  add_index "svcard_prod_relations", ["product_id"], :name => "index_svcard_prod_relations_on_product_id"
  add_index "svcard_prod_relations", ["sv_card_id"], :name => "index_svcard_prod_relations_on_sv_card_id"

  create_table "svcard_use_records", :force => true do |t|
    t.integer  "c_svc_relation_id"
    t.integer  "types"
    t.float    "use_price"
    t.float    "left_price"
    t.datetime "created_at"
  end

  add_index "svcard_use_records", ["c_svc_relation_id"], :name => "index_svcard_use_records_on_c_svc_relation_id"
  add_index "svcard_use_records", ["types"], :name => "index_svcard_use_records_on_types"

  create_table "syncs", :force => true do |t|
    t.datetime "sync_at"
    t.string   "zip_name"
    t.boolean  "sync_status"
    t.datetime "created_at"
  end

end
