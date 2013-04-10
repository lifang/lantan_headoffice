#encoding: utf-8
class MatOrderItem < ActiveRecord::Base
#  set_table_name :"lantan_db_all.mat_order_items"
#  set_primary_key "id"
  belongs_to :material
  belongs_to :material_order
end
