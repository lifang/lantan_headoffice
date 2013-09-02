#encoding: utf-8
class CarModel < ActiveRecord::Base
  set_table_name :"lantan_db.car_models"
  set_primary_key "id"
  belongs_to :car_brand
  has_many :car_nums
end
