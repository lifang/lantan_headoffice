#encoding: utf-8
class BackstagesController < ApplicationController #后台管理控制器
  def index #后台管理系统主页面
    @menus = get_menus(cookies[:user_id])
  end
end
