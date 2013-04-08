#encoding: utf-8
class Api::SyncsDatasController < ApplicationController

  #门店的数据打包成zip同步到总部
  def syncs_db_to_all
    path="#{Rails.root}/public/"
    dirs=["syncs_data","/#{Time.now.strftime("%Y-%m").to_s}","/#{Time.now.strftime("%Y-%m-%d").to_s}"]
    dirs.each_with_index {|dir,index| Dir.mkdir path+dirs[0..index].join unless File.directory? path+dirs[0..index].join }
    filename = params[:url].original_filename
    File.open(path+dirs.join("")+"/"+filename, "wb")  {|f|  f.write(params[:url].read) }
    render :text=>"success"
  end

  def syncs_pics
    path="#{Rails.root}/public/"
    filename = params[:url].original_filename
    File.open(path+filename, "wb")  {|f|  f.write(params[:url].read) }
    render :text=>"success"
  end
  
end
