#encoding: utf-8
class BackstagesController < ApplicationController #后台管理控制器
  before_filter :sign?
  layout :false
  def index #后台管理系统主页面
    @urge_goods_msg = Notice.count("id",
      :conditions => ["status = #{Notice::STATUS[:NOMAL]} and types = #{Notice::TYPES[:URGE_GOODS]}"])
  end
  
end
