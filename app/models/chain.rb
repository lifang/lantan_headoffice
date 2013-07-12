class Chain < ActiveRecord::Base
  set_table_name :"lantan_db.chains"
  set_primary_key "id"
  has_many :store_chain_relations
  STATUS = {
    :DELETED => 0,    #已关闭
    :NORMAL => 1,     #正常
    :DECORATED => 2   #筹划中
  }
  S_STATUS = {
    0 => "已关闭",
    1 => "正常运营",
    2 => "筹划中"
  }
  def has_narmal_stores?
    flag = true
    if self.status != STATUS[:NORMAL]
      flag = false
#    else
#      all_stores = StoreChainRelation.find_by_sql(["select scr.* , stores.status status from lantan_db.store_chains_relations scr left join
#                                      lantan_db.stores on scr.store_id = stores.id where scr.chain_id = ?#", self.id])
#      all_stores.each do |as|
#
#      end
#      flag = false
    end
    return flag
  end
end