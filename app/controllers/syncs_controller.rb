#encoding: utf-8
require 'json'
class SyncsController < ActionController::Base
  before_filter :sign?,:except=>["upload_file", "is_generate_zip","upload_image"]
  
  def upload_file
    begin
      Sync.accept_file(params[:upload])
      render :text=>"success"
    rescue
      render :text=>"fail"
    end
  end


  def is_generate_zip
    time_cond = params[:time].nil? ? '1=1' : "sync_at > '#{params[:time]}'"
    types_cond = "types = #{Sync::SYNC_TYPE[:BUILD]}"
    syncs = SSync.where(time_cond).where(types_cond).order("sync_at asc")
    if syncs.length > 0
      render :json => syncs
    else
      render :text => "uncomplete"
    end
  end


  def upload_image
    filename = Time.now.to_i.to_s + params[:imgFile].original_filename
    time = Time.now.strftime("%Y%m%d")
    date =Time.now.strftime("%Y%m")
    dir = "#{File.expand_path(Rails.root)}/public/upload_images"
    Dir.mkdir(dir) unless File.directory?(dir)
    Dir.mkdir("#{dir}/#{date}") unless File.directory?("#{dir}/#{date}")
    Dir.mkdir("#{dir}/#{date}/#{time}") unless File.directory?("#{dir}/#{date}/#{time}")
    img_size=params[:imgFile].size*100.0/1024/100
    if img_size <= Constant::PIC_SIZE
      File.open("#{dir}/#{date}/#{time}/#{filename}", "wb") do |f|
        f.write(params[:imgFile].read)
      end
      render :json => {:error=>0, :url=>"/upload_images/#{date}/#{time}/#{filename}", :message=>"upload_image success"}.to_json
    else
      render :json => {:error=>1, :message=>"图片大小不能超过1MB"}.to_json
    end
  end
end