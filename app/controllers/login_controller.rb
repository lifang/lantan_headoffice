#encoding: utf-8
class LoginController < ApplicationController #登录控制器

  def index
    
  end

  def create
    @staff = Staff.find_by_username(params[:username])
    if @staff.nil? #or !@staff.has_password?(params[:password])
      flash[:error] = "用户名或密码错误!"
      redirect_to '/'
    else
      cookies[:user_id] = {:value => @staff.id, :path => "/", :secure => false}
      cookies[:user_name] = {:value => @staff.name, :path => "/", :secure => false}
      redirect_to "/backstage"
    end
  end
end