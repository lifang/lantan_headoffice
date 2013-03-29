#encoding: utf-8
class OrderPayType < ActiveRecord::Base
  set_table_name :"lantan_db.order_pay_types"
  set_primary_key "id"
 belongs_to :order
end
