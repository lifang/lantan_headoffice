#encoding: utf-8
class SvcReturnRecord < ActiveRecord::Base
  set_table_name :"lantan_db_all.svc_return_records"
  set_primary_key "id"
  belongs_to :store

  TYPES = {:IN => 0, :OUT => 1} #客户消费为支出=1   门店订货为收入=0

  def self.store_return_count store_id
    price = self.first(:conditions => "store_id=#{store_id}",:order => "created_at desc").total_price
    price
  end
end
