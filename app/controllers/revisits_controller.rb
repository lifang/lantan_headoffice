#encoding: utf-8
class RevisitsController < ApplicationController  #回访控制器
  layout "service_manages"
  before_filter :sign?
  
  def index
    revisits_sql = "select r.*, sto.name store_name, cu.name cus_name, cu.mobilephone cus_mobilephone, o.code order_code, o.id oid
                    from lantan_db_all.revisits r left join lantan_db_all.complaints com on r.complaint_id = com.id
                    left join lantan_db_all.customers cu on r.customer_id = cu.id
                    left join lantan_db_all.orders o on com.order_id = o.id
                    left join lantan_db_all.stores sto on o.store_id = sto.id"
    params[:search_time].nil? ?
     revisits_sql += " where date_format(r.created_at, '%Y-%m') = '#{Time.now.strftime("%Y-%m")}'" :
     revisits_sql += " where date_format(r.created_at, '%Y-%m') = '#{params[:search_time]}'"
    @current_time = (params[:search_time].nil? || params[:search_time].empty?) ? Time.now.strftime("%Y-%m") : params[:search_time]
    @revisit_time = []    #当前年份所有已过的月份
    current_month = Time.now.strftime("%m").to_i
    for m in (0..(current_month-1))
      @revisit_time << DateTime.now.months_ago(m).strftime("%Y-%m")
    end
    @revisits = Revisit.paginate_by_sql(revisits_sql, :page => params[:page] ||= 1, :per_page => 10) #回访数据
  end
end