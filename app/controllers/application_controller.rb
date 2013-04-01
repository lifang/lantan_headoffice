class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
#  before_filter do |controller|
#    if cookies[:user_id].nil?
#      redirect_to root_path
#      return
#    end unless controller_name == "logins" && (action_name == "create" || action_name == "index")
#  end

end
