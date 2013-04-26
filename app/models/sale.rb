#encoding: utf-8
class Sale < ActiveRecord::Base
  require 'mini_magick'
  has_many :sale_prod_relations, :dependent => :destroy
  belongs_to :store
  has_many :orders
  STATUS={:UN_RELEASE =>0,:RELEASE =>1,:DESTROY =>2} #0 未发布 1 发布 2 删除
  STATUS_NAME={0=>"未发布",1=>"已发布"}
  DISC_TYPES = {:FEE=>1,:DIS=>0} #1 优惠金额  0 优惠折扣
  DISC_TIME = {:DAY=>1,:MOUTH=>2,:YEAR=>3,:WEEK=>4,:TIME=>0} #1 每日 2 每月 3 每年 4 每周 0 时间段
  IS_SUBSIDY = {:NO => 0, :YES => 1}#是否总店补贴 0不是 1是

  #生成code
  def self.set_code(length,model_n,code_name)
    chars = (1..9).to_a + ("a".."z").to_a + ("A".."Z").to_a
    code=(1..length).inject(Array.new) {|codes| codes << chars[rand(chars.length)]}.join("")
    codes=eval(model_n.capitalize).all.map(&:"#{code_name}")
    if codes.index(code)
      set_code(length)
    else
      return code
    end
  end

  #上传图片并缩放不同比例 目前为50,100,200和原图
  #img_url 上传文件的路径 sale_id所属对象的id
  #pic_types存放文件的文件夹名称 store_id 门店编号
  def self.upload_img(img_url,sale_id,pic_types,store_id,pics_size,img_code=nil)
    path = Constant::LOCAL_DIR
    dirs=["/#{pic_types}","/#{store_id}","/#{sale_id}"]
    dirs.each_with_index {|dir,index| Dir.mkdir path+dirs[0..index].join   unless File.directory? path+dirs[0..index].join }
    file=img_url.original_filename
    filename="#{dirs.join}/#{img_code}img#{sale_id}."+ file.split(".").reverse[0]
    File.open(path+filename, "wb")  {|f|  f.write(img_url.read) }
    img = MiniMagick::Image.open path+filename,"rb"
    pics_size.each do |size|
      new_file="#{dirs.join}/#{img_code}img#{sale_id}_#{size}."+ file.split(".").reverse[0]
      resize = size > img["width"] ? img["width"] : size
      height = img["height"].to_f/img["width"].to_f > 5/6 ?  250 : resize
      img.run_command("convert #{path+filename}  -resize #{resize}x#{height} #{path+new_file}")
    end
    return filename
  end
end
