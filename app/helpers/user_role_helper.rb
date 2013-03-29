# encoding: utf-8
module UserRoleHelper
  #获取当前用户的所有权限
  def staff_role(staff_id)
    current_staff = Staff.find(staff_id)
    roles = current_staff.roles
    staff_roles = []
    model_role = {}
    roles.each do |role|
      staff_roles << role.id
      role.role_model_relations.each do |m|
        model_name = m.model_name #返回模型名称
        if model_role[model_name.to_sym]
          model_role[model_name.to_sym] = model_role[model_name.to_sym].to_i
        end
      end
    end
  end
end