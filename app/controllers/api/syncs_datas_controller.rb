#encoding: utf-8
class Api::SyncsDatasController < ApplicationController

  #门店的数据打包成zip同步到总部
  def syncs_db_to_all
    path="#{Rails.root}/public/"
    dirs=["syncs_data","/#{Time.now.strftime("%Y-%m").to_s}","/#{Time.now.strftime("%Y-%m-%d").to_s}"]
    dirs.each_with_index {|dir,index| Dir.mkdir path+dirs[0..index].join unless File.directory? path+dirs[0..index].join }
    filename = params[:url].original_filename
    path = path + dirs.join("")
    if filename.include? "zip"
      hour_dir = Time.now.hour >= 10 ? "/#{Time.now.hour}" : "/0#{Time.now.hour}"
      path = path + hour_dir
      Dir.mkdir path unless File.directory? path
    end
    File.open(path + "/"+filename, "wb")  {|f|  f.write(params[:url].read) }
    render :text=>"success"
  end

  #门店同步图片到总部
  def syncs_pics
    path="#{Rails.root}/public"
    realy_dir = ""
    header_params = params[:url].headers.split(";")
    header_params.each do |p|
      if p.include? "path="
        realy_dir = p.split("path=")[1]
        break
      end
    end
    dirs = realy_dir.gsub("%2F", "/").gsub("\"", "").split("/") unless realy_dir.empty?
    dirs.delete("")
    dirs.each_with_index { |dir,index|
      Dir.mkdir path+"/"+dirs[0..index].join("/") unless File.directory? path+"/"+dirs[0..index].join("/")
    } unless dirs.blank?
    filename = params[:url].original_filename
    path = path + "/" + dirs.join("/") unless dirs.blank?
    File.open(path+"/"+filename, "wb")  {|f|  f.write(params[:url].read) }
    render :text=>"success"
  end

  #门店向总部请求数据包记录
  def return_sync_all_to_db
    target_id = params[:id]
    if target_id.nil? or target_id.to_i == 0
      jv_sync = JvSync.find(:all,
        :conditions => [" types in(#{JvSync::TYPES[:LANTAN_STORE]}, #{JvSync::TYPES[:LANTAN_DB_ALL]})"])
    else
      jv_sync = JvSync.find(:all, 
        :conditions => [" types in(#{JvSync::TYPES[:LANTAN_STORE]}, #{JvSync::TYPES[:LANTAN_DB_ALL]}) and target_id > ?",
          target_id.to_i])
    end
    render :json => jv_sync.to_json
  end
  
end
