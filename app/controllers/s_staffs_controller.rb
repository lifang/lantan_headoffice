class SStaffsController < ApplicationController #连锁店管理员控制器
  def index
    if cookies[:manage_id].nil?
      staff = SStaff.find_by_id(cookies[:manage_id])
      if staff.nil?
        render :index, :layout => false
      else
        chain = Chain.find_by_staff_id(staff.id)
        if chain.nil?
          render :index, :layout => false
        else
          redirect_to backstages_path
        end
      end
    else
      render :index, :layout => false
    end
  end

  def create
    staff = SStaff.find_by_username(params[:manager_name].strip)
    @manager_name = params[:manager_name]
    if staff and staff.has_password?(params[:manager_password])
      chain = Chain.find_by_staff_id(staff.id)
      if chain.nil?
       flash.now[:notice] = "您没有可供查看的连锁店!"
       render :action => :index, :layout => false
      else
        cookies[:manage_id] = staff.id
        cookies[:manage_name] = staff.name
        cookies.delete(:user_id) if cookies[:user_id]
        cookies.delete(:user_name) if cookies[:user_name]
        cookies.delete(:user_roles) if cookies[:user_roles]
        cookies.delete(:model_role) if cookies[:model_role]
        redirect_to backstages_path
      end
    else
      flash.now[:notice] = "用户名或密码错误!"
      render :action => :index, :layout => false
    end
  end
  
  def logout
    cookies.delete(:manage_id)
    cookies.delete(:manage_name)
    redirect_to s_staffs_path
  end
end