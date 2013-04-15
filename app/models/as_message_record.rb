#encoding: utf-8
class AsMessageRecord < ActiveRecord::Base
  set_table_name :"lantan_db_all.message_records"
  set_primary_key "id"
end
