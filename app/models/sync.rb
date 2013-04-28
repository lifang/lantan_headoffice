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
  SYNC_TYPE = {:BUILD =>0 , :SETIN => 1}  #生成数据  0  本地数据导入 1

  #接收文件文件并存到本地
  def self.accept_file(img_url)
    path="#{Rails.root}/public/"
    dirs=["bam_syncs/","#{Time.now.strftime("%Y-%m").to_s}/","#{Time.now.strftime("%Y-%m-%d").to_s}/"]
    dirs.each_with_index {|dir,index| Dir.mkdir path+dirs[0..index].join   unless File.directory? path+dirs[0..index].join }
    filename = img_url.original_filename
    File.open(path+dirs.join+filename, "wb")  {|f|  f.write(img_url.read) }
  end


  def self.get_dir_list(path)
    #获取目录列表
    list = Dir.entries(path)
    list.delete('.')
    list.delete('..')
    return list
  end

  def self.search_dir_list(path)
    #获取目录列表
    list = Dir.entries(path)
    list.delete('.')
    list.delete('..')
    list=list.inject(Array.new) {|arr,file| arr << (path+"/"+file) }
    return list
  end

  #当初次更新的时候选择目录下的所有为念
  @@files =[]
  def self.get_all_list(path)
    #获取目录列表
    list = Dir.entries(path)
    list.delete('.')
    list.delete('..')
    list.each {|file| File.file?(path+"/"+file) ? @@files << (path+"/"+file) : get_all_list(path+"/"+file) }
    return @@files
  end

  def self.new_dir(dirs)
    file_path = Constant::LOCAL_DIR
    dirs.each_with_index {|dir,index| Dir.mkdir file_path+dirs[0..index].join   unless File.directory? file_path+dirs[0..index].join }
  end
  
  def self.output_zip()
    file_path = Constant::LOCAL_DIR+"bam_syncs"
    Dir.mkdir Constant::LOG_DIR  unless File.directory?  Constant::LOG_DIR
    flog = File.open(Constant::LOG_DIR+Time.now.strftime("%Y-%m").to_s+".log","a+")
    file_list = File.new(Constant::LOG_DIR+Time.now.strftime("%Y-%m").to_s+"_list.log","r+")
    files = file_list.read
    file_list.close
    if files.split("bam_syncs").length == 2
      file_paths =  files.split("bam_syncs")[1].split("/")
      paths =[]
      file_p = file_paths[2]
      unless File.directory? file_path +"/"+ file_p.to_datetime.strftime("%Y-%m").to_s+"/"+file_p
        new_file = get_dir_list(file_path+"/"+file_p.to_datetime.strftime("%Y-%m").to_s).sort.select { |item| item > file_p }
        file_p = new_file.blank? ? file_p : new_file[0]
      end
      while(File.directory? file_path +"/"+ file_p.to_datetime.strftime("%Y-%m").to_s+"/"+file_p)
        paths << search_dir_list(file_path+"/"+file_p.to_datetime.strftime("%Y-%m").to_s+"/"+file_p)
        file_p = file_p.to_datetime.tomorrow.strftime("%Y-%m-%d").to_s
        unless File.directory? file_path +"/"+ file_p.to_datetime.strftime("%Y-%m").to_s+"/"+file_p
          new_file = get_dir_list(file_path+"/"+file_p.to_datetime.strftime("%Y-%m").to_s).sort.select { |item| item > file_p }
          if new_file.blank?
            dirs = get_dir_list(file_path).sort.select { |item| item > file_p.to_datetime.strftime("%Y-%m").to_s}
            unless dirs.blank?
              dirs.each do |dir|
                new_dirs = get_dir_list(file_path+"/"+dir).sort
                unless new_dirs.blank?
                  file_p =  new_dirs[0]
                  break
                end
              end
            end
          else
            file_p = new_file[0]
          end
        end
      end
      paths = paths.flatten.sort.select { |item| item > files}
    else
      paths =  get_all_list(file_path)
    end
    p paths
    unless paths.blank?
      paths.each do |path|
        if  File.extname(path) == '.zip'
          begin
            file_list = File.new(Constant::LOG_DIR+Time.now.strftime("%Y-%m").to_s+"_list.log","r+")
            Zip::ZipFile.open(path){ |zipFile|
              zipFile.each do |file|
                begin
                  if file.name.split(".").reverse[0] =="log"
                    contents = zipFile.read(file).split("\n\n|::|")
                    titles =contents.delete_at(0).split(";||;")
                    total_con = []
                    cap = eval("As"+file.name.split(".")[0].split("_").inject(String.new){|str,name| str + name.capitalize})
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
                rescue
                  flog.write("当前目录#{file.name}中更新失败---#{Time.now}\r\n")
                end
              end
            }
            file_list.write("#{path}")
            file_list.close
          rescue
            flog.write("当前目录#{Time.now.strftime("%Y-%m-%d")}中文件#{path}更新失败---#{Time.now}\r\n")
          end
        end
      end
    else
      flog.write("当前目录#{Time.now.strftime("%Y-%m-%d")}暂无文件---#{Time.now}\r\n")
    end
    flog.close
  end


  def self.out_data(time)
    path = Constant::LOCAL_DIR
    Dir.mkdir Constant::LOG_DIR  unless File.directory?  Constant::LOG_DIR
    sync = SSync.where("types = #{Sync::SYNC_TYPE[:BUILD]}").order("sync_at desc").first
    base_sql = sync.nil? ? "updated_at <= '#{time}'" : "updated_at > '#{sync.sync_at}' and updated_at <= '#{time}'"
    path="#{Rails.root}/public/"
    dirs=["syncs_datas/","#{time.strftime("%Y-%m").to_s}/","#{time.strftime("%Y-%m-%d").to_s}/","#{time.strftime("%H")}/"]
    dirs.each_with_index {|dir,index| Dir.mkdir path+dirs[0..index].join   unless File.directory? path+dirs[0..index].join }
    models=['product.rb', 'image_url.rb', 'sale.rb', 'capital.rb', 'car_brand.rb', 'car_model.rb', 'material_order.rb', 'customer.rb', 'as_car_num.rb', 'as_customer_num_relation.rb', 'as_reservation.rb', 'as_res_prod_relation.rb']
    models.each do |model|
      model_name =model.split(".")[0]
      unless model_name==""
        cap = eval(model_name.split("_").inject(String.new){|str,name| str + name.capitalize})
        attrs = cap.where(base_sql)
        unless attrs.blank?
          arr = model_name.split("_")
          arr.delete("as")
          model_name = arr.join("_")
          file = File.open("#{path+dirs.join+model_name}.log","w+")
          file.write("#{cap.column_names.join(";||;")}\n\n|::|")
          file.write("#{attrs.inject(String.new) {|str,attr|
            str+attr.attributes.values.join(";||;").gsub(";||;true;||;",";||;1;||;").gsub(";||;false;||;",";||;0;||;")+"\n\n|::|"}}")
          file.close
        end
      end
    end
    generate_zip(path+dirs.join, time, dirs.join)
  end

  def self.generate_zip(file_path, time, dirs)
    flog = File.open(Constant::LOG_DIR+"generate_zip_"+time.strftime("%Y-%m").to_s+".log","a+")
    get_dir_list(file_path).each {|path|  File.delete(file_path+path) if path =~ /.zip/ }
    filename ="shared.zip"
    is_finished = false
    Zip::ZipFile.open(file_path+filename, Zip::ZipFile::CREATE) { |zf|
      get_dir_list(file_path).each {|path| zf.file.open(path, "w") { |os| os.write "#{File.open(file_path+path).read}" } }
      is_finished = true
    }
    File.chmod(0644, file_path+filename)
    if is_finished
      SSync.create(:sync_at => time.strftime("%Y-%m-%d %H"), :zip_name => dirs+filename, :types => Sync::SYNC_TYPE[:BUILD])
      flog.write("数据压缩成功---#{time.strftime("%Y-%m-%d %H")}\r\n")
    else
      flog.write("数据压缩失败---#{time.strftime("%Y-%m-%d %H")}\r\n")
    end
  end
  
end