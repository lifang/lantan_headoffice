#encoding: utf-8
class AuthoritiesController < ApplicationController     #权限控制器
  layout "base_datas"
  def index
      @roles = Role.all
  end

  def add_role #添加角色
    name = params[:role_name]
    if Role.where("name = '#{name}'").blank?
      if Role.create(:name => name)
        flash[:notice] = "创建成功!"
        redirect_to authorities_path
      end
    else
      flash[:notice] = "创建失败，该角色已存在!"
      redirect_to authorities_path
    end
  end

  def del_role #删除角色
    role = Role.find(params[:r_id].to_i)
    if role.nil?
      render :text => 0
    else
      if role.destroy
        render :text => 1
      else
        render :text => 0
      end
    end
  end

  def update_role #更新角色
    role = Role.find(params[:r_id].to_i)
    if role.nil? || !Role.where("name = '#{params[:r_name]}'").blank?
      render :text => 0
    else
      if role.update_attribute("name", "#{params[:r_name]}")
        render :text => 1
      else
        render :text => 0
      end
    end
  end

  def set_auth #设置权限
    @role = Role.find(params[:r_id].to_i)
    @menus = Menu.all
    menu = @role.menus
    @menu_checked = []
    @rmr = {}
    rmr = @role.role_model_relations
    if !rmr.blank?
      rmr.each do |r|
        @rmr[r.model_name.to_sym] = r.num
      end
    end
    if !menu.blank?
      menu.each do |m|
        @menu_checked << m.id
      end
    end
  end

  def set_auth_commit #设置权限提交
    role_id = params[:role_id].to_i
    RoleMenuRelation.destroy_all("role_id = #{role_id}")
    params[:menu].each do |m| 
      RoleMenuRelation.create(:role_id => role_id, :menu_id => m.to_i)
    end unless params[:menu].blank?
    Constant::ROLES.each do |key, value|
      num = 0
      if !params[key].nil? && !params[key].blank?       
        params[key].each do |m|
          num += m.to_i
        end
        RoleModelRelation.create(:role_id => role_id, :num => num, :model_name => key)
        num = 0
      end
    end
    flash[:notice] = "设置成功!"
    redirect_to authorities_path
  end

  def set_staff #用户设定页面
    staff_sql = (params[:staff_name].nil? || params[:staff_name].empty?) ? "1 = 1" : "name like %#{params[:staff_name]}%"
    @staff = Staff.where("status = #{Staff::STATUS[:normal]}").where(staff_sql).  paginate(:page => params[:page] ||= 1,:per_page => 10)
  end

  def set_staff_role#设定用户角色
    @staff = Staff.find(params[:s_id].to_i)
    @roles = Role.all
  end

  def set_staff_role_commit #设定用户角色权限提交
    sid = (params[:staff_id].to_i)
    StaffRoleRelation.destroy_all("staff_id = #{sid}")
    if !params[:staff_roles].nil? && !params[:staff_roles].blank?
      params[:staff_roles].each do |sr|
        StaffRoleRelation.create(:staff_id => sid, :role_id => sr.to_i)
      end
    end
    flash[:notice] = "设置成功"
    redirect_to "/authorities/set_staff"
  end
end
