#encoding: utf-8
class SCPcardRelation < ActiveRecord::Base     #门店的客户与套餐卡关系表
  set_table_name :"lantan_db.c_pcard_relations"
  set_primary_key "id"
  belongs_to :customer
  has_many :orders
end
