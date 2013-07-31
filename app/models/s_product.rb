#encoding: utf-8
class SProduct < ActiveRecord::Base
  set_table_name :"lantan_db.products"
  set_primary_key "id"
  has_many :order_prod_relations
end
