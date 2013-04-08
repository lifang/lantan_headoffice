module ApplicationHelper
  include LoginsHelper
  def is_hover(controller_name)
    request.url.include?(controller_name) ? "hover" : ""
  end
  
  def current_user
    if cookies[:user_id]
      user = Staff.find cookies[:user_id]
    end
    user
  end
end
