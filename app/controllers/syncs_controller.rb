#encoding: utf-8
class SyncsController < ActionController::Base
  #  before_filter :sign?,:except=>["upload_file", "is_generate_zip"]
  
  def upload_file
    Sync.accept_file(params[:upload])
    render :text=>"success"
  end


  def is_generate_zip
    sync = SSync.order("sync_at desc").first
    if !sync.nil?
      render :text => sync.zip_name
    else
      render :text => "uncomplete"
    end
  end

end