#encoding: utf-8
class Sync < ActiveRecord::Base
  require 'rubygems'
  require 'net/http'
  require "uri"
  require 'openssl'
  require 'net/http/post/multipart'
  require 'zip/zip'
  require 'zip/zipfilesystem'

  SYNC_STAT = {:COMPLETE =>1,:ERROR =>0}  #生成/压缩/上传更新文件 完成1 报错0
  HAS_DATA = {:YES =>1,:NO =>0}  #1 有更新数据 0  没有更新数据

  #接收文件文件并存到本地
  def self.accept_file(img_url)
    path="#{Rails.root}/public/"
    dirs=["syncs/","#{Time.now.strftime("%Y-%m").to_s}/","#{Time.now.strftime("%Y-%m-%d").to_s}/"]
    dirs.each_with_index {|dir,index| Dir.mkdir path+dirs[0..index].join   unless File.directory? path+dirs[0..index].join }
    filename = img_url.original_filename
    File.open(path+dirs.join+filename, "wb")  {|f|  f.write(img_url.read) }
  end

  #发送上传请求
  def self.send_file(store_id,file_url,filename)
    query={:store_id=>store_id}
    url = URI.parse Constant::HEAD_OFFICE
    File.open(file_url) do |file|
      req = Net::HTTP::Post::Multipart.new url.path,query.merge!("upload" => UploadIO.new(file, "application/zip", "#{filename}"))
      http = Net::HTTP.new(url.host, url.port)
      if  http.request(req).body == "success"

      end
    end
  end

  def self.get_dir_list(path)
    #获取目录列表
    list = Dir.entries(path)
    list.delete('.')
    list.delete('..')
    return list
  end

  def self.new_dir(dirs)
    file_path = Constant::LOCAL_DIR
    dirs.each_with_index {|dir,index| Dir.mkdir file_path+dirs[0..index].join   unless File.directory? file_path+dirs[0..index].join }
  end
  def self.output_zip(day=1)
    file_path = Constant::LOCAL_DIR
    Dir.mkdir Constant::LOG_DIR  unless File.directory?  Constant::LOG_DIR
    flog = File.open(Constant::LOG_DIR+Time.now.strftime("%Y-%m").to_s+".log","a+")
    dirs=["syncs/","#{Time.now.ago(day.day).strftime("%Y-%m").to_s}/","#{Time.now.ago(day.day).strftime("%Y-%m-%d").to_s}/"]
    Sync.new_dir(dirs)
    paths =get_dir_list(file_path+dirs.join)
    unless paths.blank?
      paths.each do |path|
        if  File.extname(file_path+dirs.join+path) == '.zip'
          begin
            Zip::ZipFile.open(file_path+dirs.join+path){ |zipFile|
              zipFile.each do |file|
                if file.name.split(".").reverse[0] =="log"
                  contents = zipFile.read(file).split("\n\n|::|")
                  titles =contents.delete_at(0).split(";||;")
                  total_con = []
                  cap = eval(file.name.split(".")[0].split("_").inject(String.new){|str,name| str + name.capitalize})
                  contents.each do |content|
                    hash ={}
                    cons = content.split(";||;")
                    titles.each_with_index {|title,index| hash[title] = cons[index].nil? ? cons[index] : cons[index].force_encoding("UTF-8")}
                    object = cap.new(hash)
                    object.id = hash["id"]
                    total_con << object
                  end
                  cap.import total_con,:timestamps=>false,:on_duplicate_key_update=>titles
                end
              end
            }
          rescue
            flog.write("当前目录#{Time.now.ago(day.day).strftime("%Y-%m-%d")}中文件#{path}更新失败---#{Time.now}\r\n")
          end
        end
      end
    else
      flog.write("当前目录#{Time.now.ago(day.day).strftime("%Y-%m-%d")}暂无文件---#{Time.now}\r\n")
    end
    flog.close
  end


  def self.out_data(day=1)
    path = Constant::LOCAL_DIR
    Dir.mkdir Constant::LOG_DIR  unless File.directory?  Constant::LOG_DIR
    sync =SSync.find_by_created_at(Time.now.strftime("%Y-%m-%d"))
    sync =SSync.create(:created_at=>Time.now.strftime("%Y-%m-%d")) if sync.nil?
    path="#{Rails.root}/public/"
    dirs=["syncs_datas/","#{Time.now.strftime("%Y-%m").to_s}/","#{Time.now.strftime("%Y-%m-%d").to_s}/"]
    dirs.each_with_index {|dir,index| Dir.mkdir path+dirs[0..index].join   unless File.directory? path+dirs[0..index].join }
    models=['s_product.rb', 's_sale.rb', 's_car_model.rb']
    models.each do |model|
      model_name =model.split(".")[0]
      unless model_name==""
        cap = eval(model_name.split("_").inject(String.new){|str,name| str + name.capitalize})
        attrs = cap.where("TO_DAYS(NOW())-TO_DAYS(created_at)=#{day}")
        unless attrs.blank?
          name_arr = model_name.split('_')
          name_arr.delete_at(0)
          file = File.open("#{path+dirs.join+name_arr.join('_')}.log","w+")
          file.write("#{cap.column_names.join(";||;")}\n\n|::|")
          file.write("#{attrs.inject(String.new) {|str,attr|
            str+attr.attributes.values.join(";||;").gsub(";||;true;||;",";||;1;||;").gsub(";||;false;||;",";||;0;||;")+"\n\n|::|"}}")
          file.close
        end
      end
    end
    generate_zip(path+dirs.join, sync)
  end

  def self.generate_zip(file_path, sync)
    flog = File.open(Constant::LOG_DIR+Time.now.strftime("%Y-%m").to_s+".log","a+")
    get_dir_list(file_path).each {|path|  File.delete(file_path+path) if path =~ /.zip/ }
    filename ="#{Time.now.strftime("%Y%m%d")}.zip"
    is_update = false
    Zip::ZipFile.open(file_path+filename, Zip::ZipFile::CREATE) { |zf|
      is_update = true
      get_dir_list(file_path).each {|path| zf.file.open(path, "w") { |os| os.write "#{File.open(file_path+path).read}" } }
    }
    if is_update
      sync.update_attributes({:sync_status=>Sync::SYNC_STAT[:COMPLETE], :zip_name=>filename,
          :sync_at => Time.now.strftime("%Y%m%d")})
      flog.write("数据压缩成功---#{Time.now}\r\n")
    else
      flog.write("数据压缩失败---#{Time.now}\r\n")
    end
    #send_file(store_id,file_path+filename,filename)
  end
  
end