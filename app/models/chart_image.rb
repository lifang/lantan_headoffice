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
  
  def self.gchart()
    sql="select count(*) total_num,s.name,s.id s_id,t.id,o.is_pleased from lantan_db_all.orders o inner join lantan_db_all.stores s on o.store_id=s.id inner join lantan_db_all.cities t on t.id=s.city_id
    where date_format(o.created_at,'%Y-%m')=date_format(DATE_SUB(curdate(), INTERVAL 1 MONTH),'%Y-%m') and o.status=#{Order::STATUS[:BEEN_PAYMENT]} group by t.id,s.id,o.is_pleased"
    begin   
      datas = Order.find_by_sql(sql)
      stores_data =datas.inject(Hash.new){|hash,data| hash[data.s_id].nil? ? hash[data.s_id]={data.is_pleased=>data} : hash[data.s_id][data.is_pleased]=data;hash }
      city_complaints = datas.inject(Hash.new) {|panel,city|
        satify_v = stores_data[city.s_id].select{|k,v| k != Order::IS_PLEASED[:BAD]}=={} ? 0 : stores_data[city.s_id].select{|k,v|
        k != Order::IS_PLEASED[:BAD]}.values.inject(0){|num,level| num+level.total_num}*100/stores_data[city.s_id].values.inject(0){|num,level| num+level.total_num};
        panel[city.id].nil? ?  panel[city.id]={city.name =>satify_v} : panel[city.id][city.name]=satify_v; panel}
      city_complaints.each do |panel,coplaint|
        unless coplaint.keys.blank?
          size =(0..10).inject(Array.new){|arr,int| arr << (coplaint.values.max%10==0 ? coplaint.values.max/10 : coplaint.values.max/10+1)*int} #生成图表的y的坐标
          GoogleChart::BarChart.new('1000x300', "#{Time.now.months_ago(1).strftime('%Y-%m')}各门店满意度柱状图", :vertical, false) do |bc|
            bc.data "Trend 2", coplaint.values, 'ff0000'
            bc.width_spacing_options :bar_width => 15, :bar_spacing => (1000-(15*coplaint.keys.length))/coplaint.keys.length,
              :group_spacing =>(1000-(15*coplaint.keys.length))/coplaint.keys.length
            bc.max_value size.max
            bc.axis :x, :labels => coplaint.keys
            bc.axis :y, :labels =>size
            bc.grid :x_step => 3.333, :y_step => 10, :length_segment => 1, :length_blank => 3
            img_url = write_img(URI.escape(URI.unescape(bc.to_url)),panel,Time.now.months_ago(1).strftime('%Y-%m'))
            ChartImage.create({:city_id =>panel,:created_at => Time.now, :image_url => img_url, :current_month => Time.now.months_ago(1).strftime('%Y%m').to_i})
          end
        end
      end
    rescue
    end
  end

  def self.write_img(url,types,file)  #上传图片
    file_path,file_name = Constant::LOCAL_DIR,"#{Time.now.strftime("%Y%m%d").to_s}.jpg"
    dirs=["chart_images/","#{file}/","#{types}/"]
    Sync.new_dir(dirs)
    file_url =file_path + dirs.join + file_name
    open(url) do |fin|
      File.open(file_url, "wb+") do |fout|
        while buf = fin.read(1024) do
          fout.write buf
        end
      end
    end
    return "/chart_images/#{file}/#{types}/#{file_name}"
    puts "Chart #{file_name} success generated"
  end
end