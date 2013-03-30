#encoding: utf-8
class SyncsController < ActionController::Base
  
  def upload_file
    Sync.accept_file(params[:upload],params[:sync_time])
    render :text=>"success"
  end

end