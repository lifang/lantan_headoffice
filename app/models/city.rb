class City < ActiveRecord::Base
  set_table_name :"lantan_db.cities"
  set_primary_key "id"
  has_many :stores
  IS_PROVINCE = 0;  #是否为省份
end
