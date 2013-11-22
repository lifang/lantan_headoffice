#encoding: utf-8
class Category < ActiveRecord::Base
   set_table_name :"lantan_db.categories"
  set_primary_key "id"
   has_many :products
   has_many :materials
  TYPES = {:material => 0, :good => 1, :service => 2}     #0物料 1商品中的产品 2商品中的服务
  DEFAULT_CATEGORIES = {0 => ["清洗耗材", "劳动保护", "检测耗材", "其他耗材"],
             1 => ["电子产品", "清洁用品", "配件产品", "辅助工具", "装饰产品", "其他产品"],
             2 => ["清洗服务", "安装服务", "钣喷服务", "美容服务", "维修服务", "其他服务"]}
end
