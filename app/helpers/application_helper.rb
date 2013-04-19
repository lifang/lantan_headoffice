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
  
  
end
