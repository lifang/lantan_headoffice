#encoding: utf-8
class Complaint < ActiveRecord::Base
  has_many :revisits
  belongs_to :order
  belongs_to :customer

  #投诉类型
  TYPES = { :WASH => 1, :WAXING=> 2, :DIRT => 3, :INNER_WASH => 4, :INNER_WAXING => 5, :POLISH => 6, :SILVER => 7, :GLASS => 8,
    :ACCIDENT => 9, :TECHNICIAN => 10, :SERVICE => 11,:ADVISER => 12, :REST => 13, :BAD => 14, :PART => 15, :TIMEOUT => 16,
    :LONG_WAIT => 16, :INVALID => 17}
         
  TYPES_NAMES = {1 => "精洗施工质量", 2 => "打蜡施工质量", 3 => "去污施工质量", 4 => "内饰清洗施工质量", 5 => "内饰护理施工质量",
    6 => "抛光施工质量", 7 => "镀晶施工质量", 8 => "玻璃清洗护理施工质量", 9 => "施工事故（施工过程中导致车辆受损）",
    10 => "美容技师服务态度不好", 11 => "服务顾问服务态度不好",
    12 => "服务顾问着装或言辞不得体",13 => "休息厅自取茶水或报纸杂志等不完备", 14 => "休息厅环境差",
    15 => "展厅体验不完整", 16 => "施工等待时间过长", 17 => "无效投诉"}


  STATUS = {:UNTREATED => 0, :PROCESSED => 1} #0 投诉未处理  1 投诉已处理
  IS_VIOLATION = {:YES => 1, :NO => 0} #是否加入考核， 1是 0否
  TIMELY_DAY = 2 #及时解决的标准
end
