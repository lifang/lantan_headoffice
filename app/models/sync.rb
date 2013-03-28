#encoding: utf-8
class Sync < ActiveRecord::Base
  require 'rubygems'
  require 'net/http'
  require "uri"
  require 'openssl'
  require 'net/http/post/multipart'
  require 'zip/zip'
  require 'zip/zipfilesystem'

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


  def self.input_zip(file_path)
    get_dir_list(file_path).each {|path|  File.delete(file_path+path) if path =~ /.zip/ }
    filename ="#{Time.now.strftime("%Y%m%d")}.zip"
    Zip::ZipFile.open(file_path+filename, Zip::ZipFile::CREATE) { |zf|
      get_dir_list(file_path).each {|path| zf.file.open(path, "w") { |os| os.write "#{File.open(file_path+path).read}" } }
    }
    #send_file(store_id,file_path+filename,filename)
  end

  def self.output_zip(day=1)
    file_path = Constant::LOCAL_DIR
    dirs=["syncs/","#{Time.now.ago(day.day).strftime("%Y-%m").to_s}/","#{Time.now.ago(day.day).strftime("%Y-%m-%d").to_s}/"]
    paths =get_dir_list(file_path+dirs.join)
    paths.each do |path|
      if  File.extname(file_path+dirs.join+path) == '.zip'
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
              cap.import total_con
            end
          end
        }
      end
    end
  end


  def self.out_data
    models=['product.rb', 'new.rb', 'car_model.rb']
    path="#{Rails.root}/public/"
    dirs=["syncs_datas/","#{Time.now.strftime("%Y-%m").to_s}/","#{Time.now.strftime("%Y-%m-%d").to_s}/"]
    dirs.each_with_index {|dir,index| Dir.mkdir path+dirs[0..index].join   unless File.directory? path+dirs[0..index].join }
    models.each do |model|
      model_name =model.split(".")[0]
      unless model_name==""
        cap = eval(model_name.split("_").inject(String.new){|str,name| str + name.capitalize})
        attrs = cap.where("TO_DAYS(NOW())-TO_DAYS(created_at)=1")
        unless attrs.blank?
          file = File.open("#{path+dirs.join+model_name}.log","w+")
          file.write("#{cap.column_names.join(";||;")}\r\n|::|")
          file.write("#{attrs.inject(String.new) {|str,attr| 
            str+attr.attributes.values.join(";||;").gsub(";||;true;||;",";||;1;||;").gsub(";||;false;||;",";||;0;||;")+"\r\n|::|"}}")
          file.close
        end
      end
    end
    input_zip(path+dirs.join)
  end
end