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


#   pleaseds_time_sql = params[:search_time].nil? ?
#      "date_format(created_at, '%Y-%m') = '#{Time.now.strftime("%Y-%m")}'" :
#      "date_format(created_at, '%Y-%m') = '#{params[:search_time]}'"
#    all_orders = []
#    pleased_orders = []
#   if params[:search_province].nil? || params[:search_province].to_i == 0 #如果不限制省份城市，则选所有的店面数据
#     all_orders = Order.where("status = #{Order::STATUS[:FINISHED]}").where(pleaseds_time_sql)
#     pleased_orders = Order.where("status = #{Order::STATUS[:FINISHED]}").where(pleaseds_time_sql).where("is_pleased != #{Order::IS_PLEASED[:BAD]}")
#   else
#     if params[:search_city].to_i == 0 #如果限制省份，不限制城市...
#       cities = City.where("parent = #{params[:search_province].to_i}")
#       cities.each do |city|
#         city.stores.each do |store|
#           Order.where("status = #{Order::STATUS[:FINISHED]}").where(pleaseds_time_sql).where("store_id = #{store.id}").each do |order|
#             all_orders << order
#           end
#           Order.where("status = #{Order::STATUS[:FINISHED]}").where(pleaseds_time_sql).where("is_pleased != #{Order::IS_PLEASED[:BAD]}").where("store_id = #{store.id}").each do |p_order|
#             pleased_orders << p_order
#           end
#         end if !city.stores.blank?
#       end if !cities.blank?
#     elsif params[:search_city].to_i != 0 如果限制城市...
#       city = City.find( params[:search_city].to_i)
#       city.stores.each do |store|
#         Order.where("status = #{Order::STATUS[:FINISHED]}").where(pleaseds_time_sql).where("store_id = #{store.id}").each do |order|
#           all_orders << order
#         end
#         Order.where("status = #{Order::STATUS[:FINISHED]}").where(pleaseds_time_sql).where("is_pleased != #{Order::IS_PLEASED[:BAD]}").where("store_id = #{store.id}").each do |p_order|
#           pleased_orders << p_order
#         end
#       end
#     end
#   end
#    all_orders_hash = all_orders.group_by { |o|o.store_id  }
#    pleased_orders_hash = pleased_orders.group_by { |o|o.store_id  }  
  end

  def search_cities #搜索城市
    @cities = City.where("parent_id = #{params[:pid].to_i}")
  end
end