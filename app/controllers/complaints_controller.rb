#encoding: utf-8
class ComplaintsController < ApplicationController   #投诉控制器
  layout "service_manages"
  before_filter :sign?
  
  def index
    search_time = (params[:search_time].nil? || params[:search_time].empty?) ? Time.now.months_ago(1).strftime("%Y-%m") : params[:search_time]
    has_processed_complaints = [] #已解决的投诉
    timely_complaints = [] #及时解决的投诉
    if cookies[:admin_id]
       all_complaints_sql = ["date_format(created_at, '%Y-%m') = ? ", search_time]      
       complaints = Complaint.where(all_complaints_sql)   #全部投诉       
    elsif cookies[:manage_id]
       all_complaints_sql = ["select c.* from lantan_db.complaints c left join lantan_db.stores s on c.store_id = s.id
                              left join lantan_db.store_chains_relations scr on s.id = scr.store_id
                              left join lantan_db.chains ca on scr.chain_id = ca.id
                              where ca.staff_id = ? and date_format(c.created_at, '%Y-%m') = ?", cookies[:manage_id], search_time]
       complaints = Complaint.find_by_sql(all_complaints_sql)
    end
    complaints.each do |c|
         if c.status && c.created_at.strftime("%Y-%m") == search_time
           has_processed_complaints << c
           if (c.process_at.to_i-c.created_at.to_i) <= Complaint::TIMELY_HOURS*3600
             timely_complaints << c
           end
         end
       end
     if complaints.blank?
       @processed_rate = 0    #解决率
       @timely_rate = 0  #及时率
     else
       @processed_rate = (has_processed_complaints.count().to_f * 100)/complaints.count
       @timely_rate = (timely_complaints.count().to_f * 100)/complaints.count
     end
    @current_time = search_time
    @complaints_time = []    #当前年份所有已过的月份
     current_month = Time.now.strftime("%m").to_i
     for m in (1..(current_month-1))
       @complaints_time << DateTime.now.months_ago(m).strftime("%Y-%m")
     end    
     @complaints = complaints.paginate(:page => params[:page] ||= 1, :per_page => 10) #投诉数据    
  end
String
  def show_order_detail
    @order = Order.find_by_id(params[:oid].to_i)
    @front_staff = SStaff.find_by_id(@order.front_staff_id)
    @cons_staff1 = SStaff.find_by_id(@order.cons_staff_id_1)
    @cons_staff2 = SStaff.find_by_id(@order.cons_staff_id_2)
    respond_to do |format|
      format.js
    end
  end

end