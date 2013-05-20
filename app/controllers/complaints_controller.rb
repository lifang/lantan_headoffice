#encoding: utf-8
class ComplaintsController < ApplicationController   #投诉控制器
  layout "service_manages"
  before_filter :sign?
  
  def index
     all_complaints_sql = (params[:search_time].nil? || params[:search_time].empty?) ?
       ["date_format(created_at, '%Y-%m') = ? ", Time.now.months_ago(1).strftime("%Y-%m")] :
       ["date_format(created_at, '%Y-%m') = ? ", params[:search_time]]
     has_processed_complaints_sql = (params[:search_time].nil? || params[:search_time].empty?) ?
       ["status = 1 and date_format(created_at, '%Y-%m') = ? ", Time.now.months_ago(1).strftime("%Y-%m")] :
       ["status = 1 and date_format(created_at, '%Y-%m') = ? ",  params[:search_time]]
     timely_sql = (params[:search_time].nil? || params[:search_time].empty?) ?
       ["status = 1 and date_format(created_at, '%Y-%m') = ? and timestampdiff(hour,created_at,process_at)<= ? ", Time.now.months_ago(1).strftime("%Y-%m"), Complaint::TIMELY_HOURS] :
       ["status = 1 and date_format(created_at, '%Y-%m') = ? and timestampdiff(hour,created_at,process_at)<= ?  ", params[:search_time], Complaint::TIMELY_HOURS]
    @current_time = (params[:search_time].nil? || params[:search_time].empty?) ? Time.now.months_ago(1).strftime("%Y-%m") : params[:search_time]
    @complaints_time = []    #当前年份所有已过的月份
     current_month = Time.now.strftime("%m").to_i
     for m in (1..(current_month-1))
       @complaints_time << DateTime.now.months_ago(m).strftime("%Y-%m")
     end
     complaints = Complaint.where(all_complaints_sql)
     @complaints = complaints.paginate(:page => params[:page] ||= 1, :per_page => 10) #投诉数据
     has_processed_complaints = Complaint.where (has_processed_complaints_sql) #已解决的投诉
     timely_complaints = Complaint.where(timely_sql) #及时解决的投诉
     if complaints.blank?
       @processed_rate = 0    #解决率
       @timely_rate = 0  #及时率
     else
       @processed_rate = (has_processed_complaints.count().to_f * 100)/complaints.count
       @timely_rate = (timely_complaints.count().to_f * 100)/complaints.count
     end
  end

  def show_order_detail
    @order = Order.find_by_id(params[:oid].to_i)
    @front_staff = Staff.find_by_id(@order.front_staff_id)
    @cons_staff1 = Staff.find_by_id(@order.cons_staff_id_1)
    @cons_staff2 = Staff.find_by_id(@order.cons_staff_id_2)
    respond_to do |format|
      format.js
    end
  end

end