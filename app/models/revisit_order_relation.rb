#encoding: utf-8
class RevisitOrderRelation < ActiveRecord::Base
  set_table_name :"lantan_db_all.revisit_order_relations"
  belongs_to :order
  belongs_to :revisit
end
