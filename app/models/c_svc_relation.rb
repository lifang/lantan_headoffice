#encoding: utf-8
class CSvcRelation < ActiveRecord::Base
 has_many :svcard_use_records
 belongs_to :sv_card
 has_many :orders
 belongs_to :customer
 IS_BILLING ={:YES => 1, :NO => 0}#是否已开发票 1已开 0没开
end
