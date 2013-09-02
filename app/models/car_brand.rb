#encoding: utf-8
class CarBrand < ActiveRecord::Base
  set_table_name :"lantan_db.car_brands"
  set_primary_key "id"
  belongs_to :capital
  has_many :car_models, :dependent => :destroy
end
