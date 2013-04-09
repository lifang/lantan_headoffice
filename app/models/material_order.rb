#encoding: utf-8
class MaterialOrder < ActiveRecord::Base
  set_table_name :"lantan_db_all.material_orders"
  set_primary_key "id"
  has_many :mat_order_items
  has_many :mat_out_orders
  has_many  :mat_in_orders
  has_many  :m_order_types
  belongs_to :supplier
  belongs_to :store
  scope :is_headoffice_not_canceled, where(:supplier_id => 0, :status =>[1,2])

  STATUS = {0 => "未付款", 1 => "已付款", 4 => "已取消"}
  M_STATUS = {0 => "未发货", 1 => "已发货", 2 => "已收货", 3 => "已入库"}
  PAY_TYPES = {:CHARGE => 1,:LICENSE=>2, :CASH => 3, :STORE_CARD => 4 }
  PAY_TYPE_NAME = {1 => "订货付费",2=>"授权码", 3 => "现金", 4 => "门店账户扣款"}
  def self.make_order
    status = 0

    status
  end

  def self.material_order_code store_id
    store = store_id.to_s
    if store_id < 10
      store =   "00" + store_id.to_s
    elsif store_id < 100
      store =    "0" + store_id.to_s
    end
    store + Time.now.strftime("%Y%m%d%H%M%S")
  end
end
