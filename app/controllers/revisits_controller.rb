#encoding: utf-8
class RevisitsController < ApplicationController  #回访控制器
  layout "service_manages"
  before_filter :sign?
  
  def index
    search_time = (params[:search_time].nil? || params[:search_time].empty?) ?
                  Time.now.months_ago(1).strftime("%Y-%m") : params[:search_time]
    if cookies[:user_id]
      revisits_sql = "select r.*, cus.name cus_name, cus.mobilephone cus_phone, o.code order_code,o.id order_id, s.name store_name
                      from lantan_db.revisits r
                      inner join lantan_db.customers cus on r.customer_id = cus.id
                      inner join lantan_db.revisit_order_relations ror on r.id = ror.revisit_id
                      inner join lantan_db.orders o on ror.order_id = o.id
                      inner join lantan_db.stores s on o.store_id = s.id
                      where date_format(r.created_at, '%Y-%m') = ?", search_time
    elsif cookies[:manage_id]
      revisits_sql = "select r.*, cus.name cus_name, cus.mobilephone cus_phone, o.code order_code,o.id order_id, s.name store_name
                      from lantan_db.revisits r
                      inner join lantan_db.customers cus on r.customer_id = cus.id
                      inner join lantan_db.revisit_order_relations ror on r.id = ror.revisit_id
                      inner join lantan_db.orders o on ror.order_id = o.id
                      inner join lantan_db.stores s on o.store_id = s.id
                      inner join lantan_db.store_chains_relations scr on s.id = scr.store_id
                      inner join lantan_db.chains c on scr.chain_id = c.id where c.staff_id = ?
                      and date_format(r.created_at, '%Y-%m') = ?", cookies[:manage_id], search_time
    end
    @current_time = search_time
    @revisit_time = []    #当前年份所有已过的月份
    current_month = Time.now.strftime("%m").to_i
    for m in (1..(current_month-1))
      @revisit_time << DateTime.now.months_ago(m).strftime("%Y-%m")
    end
    @revisits = Revisit.paginate_by_sql(revisits_sql, :page => params[:page] ||= 1, :per_page => 10) #回访数据
  end
end