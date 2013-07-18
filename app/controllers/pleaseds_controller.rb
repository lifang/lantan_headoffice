#encoding: utf-8
class PleasedsController < ApplicationController  #满意度控制器
  layout "service_manages"
  before_filter :sign?
  
  def index   
    @current_time = (params[:search_time].nil? || params[:search_time].empty?) ? Time.now.months_ago(1).strftime("%Y-%m") : params[:search_time]
    @pleased_time = []    #当前年份所有已过的月份
    current_month = Time.now.strftime("%m").to_i
    for m in (1..(current_month-1))
      @pleased_time << DateTime.now.months_ago(m).strftime("%Y-%m")
    end
    if cookies[:admin_id]
      @provinces = City.where("parent_id = 0")
      unless params[:search_province].nil? || params[:search_province].to_i == 0
        @cities = City.where("parent_id = #{params[:search_province].to_i}")
      end
      if params[:search_time].nil? || params[:search_city].nil? || params[:search_city].to_i == 0
        @blank_msg = "请选择需要查询的城市!"
      else
        city_condition = "city_id = #{params[:search_city]}"
        current_month_condition = params[:search_time].nil? ? "1 = 1" : "current_month = #{params[:search_time].split("-").join.to_i}"
        @chart_image = ChartImage.where(city_condition).where(current_month_condition).first
      end
    elsif cookies[:manage_id]
      @stores = Store.find_by_sql(["select s.* from lantan_db.chains c left join lantan_db.store_chains_relations scr
                                   on c.id = scr.chain_id left join lantan_db.stores s 
                                   on scr.store_id = s.id where c.staff_id = ?", cookies[:manage_id]])
      if params[:search_time].nil? || params[:search_store_name].nil? || params[:search_store_name].to_i == 0
        @blank_msg = "请选择需要查询的门店名!"
      else
        current_month_condition = params[:search_time]
        store_condition = "store_id = #{params[:search_store_name].to_i}"
        @chart_image = SChartImage.where(store_condition).where("date_format(current_day,'%Y-%m') = '#{current_month_condition}'").first
      end
    end
  end

  def search_cities #搜索城市
    @cities = City.where("parent_id = #{params[:pid].to_i}")
  end
end