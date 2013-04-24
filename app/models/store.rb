#encoding: utf-8
class Store < ActiveRecord::Base
  set_table_name :"lantan_db_all.stores"
  set_primary_key "id"
  belongs_to :city
  STATUS = {
    :CLOSED => 0,       #0该门店已关闭，1正常营业，2装修中, 3已删除
    :OPENED => 1,
    :DECORATED => 2,
    :DELETED => 3
  }
end
