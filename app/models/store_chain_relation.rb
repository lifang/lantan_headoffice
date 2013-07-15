#encoding: utf-8
class StoreChainRelation < ActiveRecord::Base
  set_table_name :"lantan_db.store_chains_relations"
  set_primary_key "id"
  belongs_to :chain
  belongs_to :store
  
end