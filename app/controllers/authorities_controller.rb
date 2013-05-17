#encoding: utf-8
class AuthoritiesController < ApplicationController     #权限控制器
  before_filter :sign?
  layout "base_datas"
  
  def index
      @roles = Role.all
  end

  def add_role #添加角色
    name = params[:role_name].strip
    if Role.where(["name = ?", name]).blank?
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
    if role.nil? || !Role.where(["name = ? ", params[:r_name].strip]).blank?
      render :text => 0
    else
      if role.update_attribute("name", params[:r_name].strip)
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
    if params[:role_id]
    role_id = params[:role_id]
      role = Role.find role_id
      if params[:menu_checks] #处理角色-菜单设置
        menus = Menu.where(:id => params[:menu_checks])
        role.menus = menus
      end
      if params[:model_nums] #处理角色-功能模块设置
        params[:model_nums].each do |controller, num|
          role_model_relation = RoleModelRelation.where(:role_id => role_id, :model_name => controller)
          if role_model_relation.empty?
            RoleModelRelation.create(:num => num.map(&:to_i).sum, :role_id => role_id, :model_name => controller)
          else
            role_model_relation.first.update_attributes(:num => num.map(&:to_i).sum)
          end
        end
        deleted_menus = RoleModelRelation.where(:role_id => role_id).map(&:model_name) - params[:model_nums].keys
        RoleModelRelation.delete_all(:role_id => role_id, :model_name => deleted_menus) unless deleted_menus.empty?
      end
    end
    flash[:notice] = "设置成功!"
    redirect_to authorities_path
  end

  def set_staff #用户设定页面
    staff_sql = (params[:staff_name].nil? || params[:staff_name].empty?) ? "1 = 1" : ["name like ?", "%#{params[:staff_name].strip}%"]
    @staff = Staff.where("status = #{Staff::STATUS[:normal]}").where(staff_sql).paginate(:page => params[:page] ||= 1,:per_page => 10)
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
