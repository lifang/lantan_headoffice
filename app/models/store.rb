#encoding: utf-8
class Store < ActiveRecord::Base
  has_many :stations
  has_many :reservations
  has_many :products
  has_many :sales
  has_many :work_orders
  has_many :svc_return_records
  has_many :goal_sales
  has_many :message_records
  has_many :notices
  has_many :package_cards
  has_many :staffs
  belongs_to :city
  STATUS = {
    :CLOSED => 0,       #0该门店已关闭，1正常营业，2装修中...
    :OPENED => 1,
    :DECORATED => 2
  }
end
