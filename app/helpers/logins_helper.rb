module LoginsHelper
  def get_menus(user_id)  #获取菜单
    staff = Staff.find(user_id)
    roles = staff.roles
    menus = []
    roles.each do |role|
      role.menus.each do |m|
        menus << m
      end if !role.menus.blank?
    end if !roles.blank?
    @menus = menus.uniq
  end
end
