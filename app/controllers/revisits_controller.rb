#encoding: utf-8
class RevisitsController < ApplicationController  #回访控制器
  layout "service_manages"
  before_filter :sign?
  
  def index
    revisits_sql = "select r.*, cus.name cus_name, cus.mobilephone cus_phone, o.code order_code,o.id order_id, s.name store_name
                    from lantan_db_all.revisits r
                    inner join lantan_db_all.customers cus on r.customer_id = cus.id
                    inner join lantan_db_all.revisit_order_relations ror on r.id = ror.revisit_id
                    inner join lantan_db_all.orders o on ror.order_id = o.id
                    inner join lantan_db_all.stores s on o.store_id = s.id"
    params[:search_time].nil? ?
     revisits_sql += " where date_format(r.created_at, '%Y-%m') = '#{Time.now.months_ago(1).strftime("%Y-%m")}'" :
     revisits_sql += " where date_format(r.created_at, '%Y-%m') = '#{params[:search_time]}'"
    @current_time = (params[:search_time].nil? || params[:search_time].empty?) ? Time.now.months_ago(1).strftime("%Y-%m") : params[:search_time]
    @revisit_time = []    #当前年份所有已过的月份
    current_month = Time.now.strftime("%m").to_i
    for m in (1..(current_month-1))
      @revisit_time << DateTime.now.months_ago(m).strftime("%Y-%m")
    end
    @revisits = Revisit.paginate_by_sql(revisits_sql, :page => params[:page] ||= 1, :per_page => 10) #回访数据
  end
end