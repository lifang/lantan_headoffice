#encoding: utf-8
class Material < ActiveRecord::Base
  has_many :prod_mat_relations
  has_many :mat_order_items
  has_many :mat_out_orders
  has_many  :mat_in_orders
  has_many :prod_mat_relations

  STATUS = {:NORMAL => 0, :DELETE => 1}
  TYPES_NAMES = {0 => "清洁用品", 1 => "美容用品", 2 => "装饰产品", 3 => "配件产品", 4 => "电子产品",
    5 =>"其他产品",6 => "辅助工具", 7 => "劳动保护"}
  TYPES = { :CLEAN_PROD =>0, :BEAUTY_PROD =>1,:DECORATE_PROD =>2, :ACCESSORY_PROD =>3, :ELEC_PROD =>4,
    :OTHER_PROD => 5, :ASSISTANT_TOOL => 6, :LABOR_PROTECT => 7}

  scope :normal, where(:status => STATUS[:NORMAL])
  after_save :strip_material_name

  private

  def strip_material_name
    name = self.name.strip
    self.update_column(:name,name)
  end
end
