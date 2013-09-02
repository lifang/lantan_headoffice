#encoding: utf-8
class Capital < ActiveRecord::Base
  set_table_name :"lantan_db.capitals"
  set_primary_key "id"
  has_many :car_brands
end
