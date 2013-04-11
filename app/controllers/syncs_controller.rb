#encoding: utf-8
class SyncsController < ActionController::Base
  before_filter :sign?
  
  def upload_file
    Sync.accept_file(params[:upload])
    render :text=>"success"
  end

  def is_generate_zip
    sync = SSync.find_by_created_at(Time.now.strftime("%Y%m%d"))
    if !sync.nil? && sync.sync_status
      render :text => "complete"
    else
      render :text => "uncomplete"
    end
  end

end