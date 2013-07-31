#encoding: utf-8
class CarModel < ActiveRecord::Base
  belongs_to :car_brand
  has_many :car_nums
end
