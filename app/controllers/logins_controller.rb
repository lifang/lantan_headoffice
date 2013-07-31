#encoding: utf-8
class LoginsController < ApplicationController #登录控制器

  def index   #登陆
    if cookies[:admin_id]
      staff = Staff.find_by_id(cookies[:admin_id])
      if staff.nil?
        render :index, :layout => false
      else
        session_role(cookies[:admin_id])
        if has_authority?
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
    @user_name = params[:username]
   if staff.nil? or !staff.has_password?(params[:password])
      flash.now[:notice] = "用户名或密码错误!"
      render :action => :index, :layout => false
   elsif staff.status
     flash.now[:notice] = "用户已删除!"
     render :action => :index, :layout => false
   else
      cookies[:admin_id]={:value =>staff.id, :path => "/", :secure  => false}
      cookies[:admin_name]={:value =>staff.name, :path => "/", :secure  => false}
      session_role(cookies[:admin_id])
      if has_authority?
        cookies.delete(:manage_id) if cookies[:manage_id]
        cookies.delete(:manage_name) if cookies[:manage_name]
        redirect_to backstages_path
      else
        cookies.delete(:admin_id)
        cookies.delete(:admin_name)
        cookies.delete(:user_roles)
        cookies.delete(:model_role)
        flash.now[:notice] = "抱歉，您没有访问权限"
        render :action => :index, :layout => false
      end    
    end
  end

  def logout  #登出
    cookies.delete(:admin_id)
    cookies.delete(:admin_name)
    cookies.delete(:user_roles)
    cookies.delete(:model_role)
    redirect_to root_path
  end
end