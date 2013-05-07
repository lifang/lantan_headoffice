#encoding: utf-8
module ApplicationHelper
  include UserRoleHelper
  def is_hover(controller_name)
    request.url.include?(controller_name) ? "hover" : ""
  end
  
  def current_user
    @current_user ||= Staff.find cookies[:user_id] if cookies[:user_id]
  end

  def sign?
    deny_access unless signed_in?
  end

  def deny_access
    redirect_to "/logins"
  end

  def signed_in?
    return cookies[:user_id] != nil
  end
  
  def material_status status, type
    str = ""
    if type == 0
      if status == 0
        str = "未付款"
      elsif status == 1
        str = "已付款"
      elsif status == 4
        str = "已取消"
      end
    elsif type == 1
      if status == 0
        str = "未发货"
      elsif status == 1
        str = "已发货"
      elsif status == 2
        str = "已收货"
      elsif status == 3
        str = "已入库"
      end
    end
    str
  end
  
end
