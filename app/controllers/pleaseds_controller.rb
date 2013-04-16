#encoding: utf-8
class PleasedsController < ApplicationController  #满意度控制器
  layout "service_manages"
  before_filter :sign?
  
  def index
    @current_time = (params[:search_time].nil? || params[:search_time].empty?) ? Time.now.strftime("%Y-%m") : params[:search_time]
    @pleased_time = []    #当前年份所有已过的月份
    current_month = Time.now.strftime("%m").to_i
    for m in (0..(current_month-1))
      @pleased_time << DateTime.now.months_ago(m).strftime("%Y-%m")
    end
    @provinces = City.where("parent_id = 0")
    if !params[:search_province].nil? && params[:search_province].to_i != 0
      @cities = City.where("parent_id = #{params[:search_province].to_i}")
    end
    city_condition = params[:search_city].nil? ? '1=1' : "city_id = #{params[:search_city]}"
    current_month_condition = (params[:search_time].nil? || params[:search_time].empty?) ? Time.now.strftime("%Y%m") : params[:search_time].delete("-")
    @chart_image = ChartImage.where(city_condition).where("current_month = #{current_month_condition}").first
  end

  def search_cities #搜索城市
    @cities = City.where("parent_id = #{params[:pid].to_i}")
  end
end