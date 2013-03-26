module ApplicationHelper
   include LoginsHelper
  def is_hover(controller_name)
    request.url.include?(controller_name) ? "hover" : ""
  end
end
