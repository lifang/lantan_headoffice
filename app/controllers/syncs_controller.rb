#encoding: utf-8
require 'json'
class SyncsController < ActionController::Base
  #  before_filter :sign?,:except=>["upload_file", "is_generate_zip"]
  
  def upload_file
    Sync.accept_file(params[:upload])
    render :text=>"success"
  end


  def is_generate_zip
    time_cond = params[:time].nil? ? '1=1' : "sync_at >= '#{params[:time]}'"
    syncs = SSync.where(time_cond)
    if syncs.length > 0
      render :json => syncs
    else
      render :text => "uncomplete"
    end
  end

end