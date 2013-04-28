#encoding: utf-8
class MaterialOrder < ActiveRecord::Base
  has_many :mat_order_items
#  has_many :mat_out_orders
#  has_many :mat_in_orders
  has_many :m_order_types
  has_many :materials, :through => :mat_order_items
  belongs_to :supplier
  belongs_to :store
  scope :is_headoffice_not_canceled, where(:supplier_id => 0, :status =>[0,1])

  STATUS = {0 => "未付款", 1 => "已付款", 4 => "已取消"}
  M_STATUS = {0 => "未发货", 1 => "已发货", 2 => "已收货", 3 => "已入库"}
  PAY_TYPES = {:CHARGE => 1, :SAV_CARD => 2, :CASH => 3, :STORE_CARD => 4, :SALE_CARD => 5}
  PAY_TYPE_NAME = {1 => "支付宝",2 => "储值卡", 3 => "现金", 4 => "门店账户扣款", 5 => "活动优惠"}
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

   def svc_use_price
    MOrderType.find_by_material_order_id_and_pay_types(self.id, PAY_TYPES[:SAV_CARD]).try(:price)
  end

  def sale_price
    if self.sale_id
      sale = Sale.find self.sale_id
      sale.sub_content
    end
  end
end
