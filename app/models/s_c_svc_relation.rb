#encoding: utf-8
class SCSvcRelation < ActiveRecord::Base    #门店的客户与优惠卡关系表
  set_table_name :"lantan_db.c_svc_relations"
  set_primary_key "id"
  has_many :orders
  belongs_to :customer
  IS_BILLING ={:YES => 1, :NO => 0}#是否已开发票 1已开 0没开
end