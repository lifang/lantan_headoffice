#encoding: utf-8
class LoginsController < ApplicationController #登录控制器

  def index   #登陆
    Sync.output_zip
    render :index, :layout => false
  end

  def create #登陆验证
    staff = Staff.find_by_username(params[:username])
    if staff.nil? #or !@staff.has_password?(params[:password])
      flash[:notice] = "用户名或密码错误!"
      redirect_to '/'
    else
      if staff.roles.blank?
        flash[:notice] = "对不起，您没有权限!"
        redirect_to "/"
      else
        cookies[:user_id] = {:value => staff.id, :path => "/", :secure => false}
        cookies[:user_name] = {:value => staff.name, :path => "/", :secure => false}
        redirect_to backstages_path
      end
    end
  end

  def logout  #登出
    cookies.delete(:user_id)
    cookies.delete(:user_name)
    redirect_to root_path
  end
end