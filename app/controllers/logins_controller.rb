#encoding: utf-8
class LoginsController < ApplicationController #登录控制器

  include UserRoleHelper
  
  def index   #登陆
    if cookies[:user_id]
      staff = Staff.find_by_id(cookies[:user_id])
      if staff.nil?
        render :index, :layout => false
      else
        session_role(cookies[:user_id])
        if is_admin? or is_boss? or is_manager? or is_staff?
          redirect_to backstages_path
        else
          render :index, :layout => false
        end
      end
    else
      render :index, :layout => false
    end
  end

  def create #登陆验证
    staff = Staff.find_by_username(params[:username])
    if staff and staff.has_password?(params[:password])
      cookies[:user_id]={:value =>staff.id, :path => "/", :secure  => false}
      cookies[:user_name]={:value =>staff.name, :path => "/", :secure  => false}
      session_role(cookies[:user_id])
      if is_admin? or is_boss? or is_manager? or is_staff?
        redirect_to backstages_path
      else
        cookies.delete(:user_id)
        cookies.delete(:user_name)
        cookies.delete(:user_roles)
        cookies.delete(:model_role)
        flash[:notice] = "抱歉，您没有访问权限"
        redirect_to "/"
      end
    else
      flash[:notice] = "用户名或密码错误!"
      redirect_to '/'
    end
  end

  def logout  #登出
    cookies.delete(:user_id)
    cookies.delete(:user_name)
    redirect_to root_path
  end
end