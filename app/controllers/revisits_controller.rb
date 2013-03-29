#encoding: utf-8
class RevisitsController < ApplicationController  #回访控制器
  layout "service_manages"
  def index
    revisit_sql = params[:search_time].nil? ?
       "date_format(created_at, '%Y-%m') = '#{Time.now.strftime("%Y-%m")}'" :
       "date_format(created_at, '%Y-%m') = '#{params[:search_time]}'"
    @current_time = (params[:search_time].nil? || params[:search_time].empty?) ? Time.now.strftime("%Y-%m") : params[:search_time]
    @revisit_time = []    #当前年份所有已过的月份
    current_month = Time.now.strftime("%m").to_i
    for m in (0..(current_month-1))
      @revisit_time << DateTime.now.months_ago(m).strftime("%Y-%m")
    end
    @revisits = Revisit.where(revisit_sql).paginate(:page => params[:page] ||= 1, :per_page => 1) #回访数据
  end
end