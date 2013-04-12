#encoding: utf-8
class ComplaintsController < ApplicationController   #投诉控制器
  layout "service_manages"
  before_filter :sign?
  
  def index
     all_complaints_sql = (params[:search_time].nil? || params[:search_time].empty?) ?
       "date_format(created_at, '%Y-%m') = '#{Time.now.strftime("%Y-%m")}'" :
       "date_format(created_at, '%Y-%m') = '#{params[:search_time]}'"
     has_processed_complaints_sql = (params[:search_time].nil? || params[:search_time].empty?) ?
       "status = 1 and date_format(created_at, '%Y-%m') = '#{Time.now.strftime("%Y-%m")}'" :
       "status = 1 and date_format(created_at, '%Y-%m') = '#{params[:search_time]}'"
     timely_sql = (params[:search_time].nil? || params[:search_time].empty?) ?
       "status = 1 and date_format(created_at, '%Y-%m') = '#{Time.now.strftime("%Y-%m")}' and TO_DAYS(process_at)-TO_DAYS(created_at)<=#{Complaint::TIMELY_DAY} " :
       "status = 1 and date_format(created_at, '%Y-%m') = '#{params[:search_time]}' and TO_DAYS(process_at)-TO_DAYS(created_at)<=#{Complaint::TIMELY_DAY} "
    @current_time = (params[:search_time].nil? || params[:search_time].empty?) ? Time.now.strftime("%Y-%m") : params[:search_time]
    @complaints_time = []    #当前年份所有已过的月份
     current_month = Time.now.strftime("%m").to_i
     for m in (0..(current_month-1))
       @complaints_time << DateTime.now.months_ago(m).strftime("%Y-%m")
     end
     complaints = Complaint.where(all_complaints_sql)
     @complaints = complaints.paginate(:page => params[:page] ||= 1, :per_page => 10) #投诉数据
     has_processed_complaints = Complaint.where (has_processed_complaints_sql) #已解决的投诉
     timely_complaints = Complaint.where(timely_sql) #及时解决的投诉
     if complaints.blank?
       @processed_rate = 0    #解决率
       @timely_rate = 0
     else
       @processed_rate = ((has_processed_complaints.count() * 100)/complaints.count)*0.01
       @timely_rate = ((timely_complaints.count() * 100)/complaints.count)*0.01
     end
  end

  def show_order_detail
    @order = Order.find_by_id(params[:oid].to_i)

    @front_staff = Staff.find_by_id(@order.front_staff_id) if @order.front_staff_id
    @cons_staff1 = Staff.find_by_id(@order.cons_staff_id_1) if @order.cons_staff_id_1
    @cons_staff2 = Staff.find_by_id(@order.cons_staff_id_2) if @order.cons_staff_id_2
    p @front_staff
    p @cons_staff1
    p @cons_staff2
    respond_to do |format|
      format.js
    end
  end
end