#encoding: utf-8
class ChartImage < ActiveRecord::Base
  #  set_table_name :"lantan_db_all.chart_images"
  #  set_primary_key "id"

  require 'rubygems'
  require 'google_chart'
  require 'net/https'
  require 'uri'
  require 'open-uri'
  TYPES = {:SATIFY =>0,:COMPLAINT =>1,:MECHINE_LEVEL =>2,:FRONT_LEVEL =>3,:STAFF_LEVEL =>4}
  # 0 满意度 1 投诉统计 2 技师平均水平 3 前台平均水平 4 员工绩效

  def self.city_complaint
    return AsComplaint.find_by_sql("select count(c.id) total_num,s.name,s.id s_id,t.id from lantan_db_all.complaints c inner join lantan_db_all.stores s on c.store_id=s.id
          inner join lantan_db_all.cities t on t.id=s.city_id where date_format(c.created_at,'%Y-%m')=date_format(DATE_SUB(curdate(), INTERVAL 1 MONTH),'%Y-%m') group by t.id,s.id")
  end
  
  def self.gchart()  
    city_complaints = ChartImage.city_complaint.inject(Hash.new) {|panel,city| panel[city.id].nil? ?
        panel[city.id]={city.name=>city.total_num} : panel[city.id][city.name]=city.total_num; panel}
    city_complaints.each do |panel,coplaint|
      unless coplaint.keys.blank?
        size =(0..10).inject(Array.new){|arr,int| arr << (coplaint.values.max%10==0 ? coplaint.values.max/10 : coplaint.values.max/10+1)*int} #生成图表的y的坐标
        GoogleChart::BarChart.new('1000x300', "#{Time.now.months_ago(1).strftime('%Y-%m')}投诉情况分类表", :vertical, false) do |bc|
          bc.data "Trend 2", coplaint.values, 'ff0000'
          bc.width_spacing_options :bar_width => 15, :bar_spacing => (1000-(15*coplaint.keys.length))/coplaint.keys.length,
            :group_spacing =>(1000-(15*coplaint.keys.length))/coplaint.keys.length
          bc.max_value size.max
          bc.axis :x, :labels => coplaint.keys
          bc.axis :y, :labels =>size
          bc.grid :x_step => 3.333, :y_step => 10, :length_segment => 1, :length_blank => 3
          img_url = write_img(URI.escape(URI.unescape(bc.to_url)),panel)
          ChartImage.create({:city_id=>panel,:created_at => Time.now, :image_url => img_url, :current_month => Time.now.months_ago(1)})
        end
      end
    end
  end

  def self.write_img(url,types)  #上传图片
    file_path,file_name = Constant::LOCAL_DIR,"#{Time.now.strftime("%Y%m%d").to_s}.jpg"
    dirs=["chart_images/","#{types}/"]
    Sync.new_dir(dirs)
    file_url =file_path + dirs.join + file_name
    open(url) do |fin|
      File.open(file_url, "wb+") do |fout|
        while buf = fin.read(1024) do
          fout.write buf
        end
      end
    end
    return "/chart_images/#{types}/#{file_name}"
    puts "Chart #{file_name} success generated"
  end
end