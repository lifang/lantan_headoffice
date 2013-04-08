# encoding: utf-8
module UserRoleHelper

  #是否客服
  def is_staff?
    #    session_role cookies[:user_id] unless session[:user_roles]
    #    roles.include? Constant::STAFF
    session_role cookies[:user_id] unless cookies[:user_roles]
    roles = cookies[:user_roles].split(",")
    roles.include? Constant::STAFF
  end

  #是否仓库管理员
  def is_manager?
    session_role cookies[:user_id] unless cookies[:user_roles]
    roles = cookies[:user_roles].split(",")
    roles.include? Constant::STORE_MANAGER
  end

  #是否老板
  def is_boss?
    session_role cookies[:user_id] unless cookies[:user_roles]
    roles = cookies[:user_roles].split(",")
    roles.include? Constant::BOSS
  end

  #是否系统管理员
  def is_admin?
    session_role cookies[:user_id] unless cookies[:user_roles]
    roles = cookies[:user_roles].split(",")
    roles.include? Constant::SYS_ADMIN
  end

  #罗列当前用户的所有权限
  def session_role(user_id)
    user = Staff.find user_id
    roles = user.roles
    user_roles = []
    model_role = {}
    roles.each do |role|
      user_roles << role.id
      model_roles = role.role_model_relations
      model_roles.each do |m|
        model_name = m.model_name
        if model_role[model_name.to_sym]
          model_role[model_name.to_sym] = model_role[model_name.to_sym].to_i|m.num.to_i
        else
          model_role[model_name.to_sym] = m.num.to_i
        end
      end if model_roles
    end if roles
    #    session[:model_role] = model_role
    cookies[:model_role] = {:value => model_role.to_a.join(","), :path => "/", :secure  => true}
    #    session[:user_roles] = user_roles
    cookies[:user_roles] = {:value => user_roles.join(","), :path => "/", :secure  => true}
  end

  #判断功能按钮的权限
  def permission?(*role)
    model = role[0]
    function = role[1]
    i = Constant::ROLES[model][function]
    #    session_role cookies[:user_id] unless session[:model_role]
    role_flag = nil
    if cookies[:user_id]
      session_role(cookies[:user_id]) unless cookies[:model_role]
      if cookies[:model_role]
        model_roles = cookies[:model_role].split(",")
        for j in (0..model_roles.length)
          if model_roles[j].to_s == model.to_s
            role_flag = model_roles[j+1]
            break
          end
        end
      end
    end
    role_flag.to_i&i[1] == i[1]
    #    session[:model_role][model]&i[1]==i[1]
  end

  #判断菜单的权限
  def permissions_on_menus?(menu)
    user_roles = []
    if current_user
      current_user.roles.each do |role|
        user_roles << role.menus.map(&:controller)
      end
    end
    user_roles.flatten.uniq.include?(menu.to_s)
  end

end
