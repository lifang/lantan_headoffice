#encoding: utf-8
class SMaterial < ActiveRecord::Base
  set_table_name :"lantan_db_all.materials"
  set_primary_key "id"
  has_many :mat_order_items
end