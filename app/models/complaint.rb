#encoding: utf-8
class Complaint < ActiveRecord::Base
  set_table_name :"lantan_db.complaints"
  set_primary_key "id"
  has_many :revisits
  belongs_to :order
  belongs_to :customer

  #投诉类型
  TYPES = {:CONSTRUCTION => 0, :SERVICE => 1, :PRODUCTION => 2, :INSTALLATION => 3, :ACCIDENT => 4, :OTHERS => 5, :INVALID => 6}
  TYPES_NAMES = {0 => "施工质量", 1 => "服务质量", 2 => "产品质量", 3 => "门店设施", 4 => "意外事件", 5 => "其他", 6 => "无效投诉"}


  STATUS = {:UNTREATED => 0, :PROCESSED => 1} #0 投诉未处理  1 投诉已处理
  IS_VIOLATION = {:YES => 1, :NO => 0} #是否加入考核， 1是 0否
  TIMELY_HOURS = 2 #XX小时之内解决算及时
end
