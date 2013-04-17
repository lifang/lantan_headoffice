#encoding: utf-8
class SyncsController < ActionController::Base
  before_filter :sign?,:except=>["upload_file", "is_generate_zip"]
  
  def upload_file
    Sync.accept_file(params[:upload])
    render :text=>"success"
  end

  def is_generate_zip
    #sync = SSync.find_by_sync_at(Time.now.strftime("%Y%m%d"))
    sync = SSync.where("sync_at >= '#{Time.now.strftime("%Y-%m-%d")}' and sync_at <= '#{Time.now.strftime("%Y-%m-%d")} 23:59:59'").first
    if !sync.nil?
      render :text => "complete"
    else
      render :text => "uncomplete"
    end
  end

end