#encoding: utf-8
class OrderProdRelation < ActiveRecord::Base
  set_table_name :"lantan_db.order_prod_relations"
  set_primary_key "id"
  belongs_to :order
  belongs_to :s_product
end
