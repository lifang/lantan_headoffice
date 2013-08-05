#encoding: utf-8
class StaffsController < ApplicationController
  before_filter :sign?
   
  def new
    @staff = Staff.new
    @action_name = "新建"
  end

  def create
    params[:staff][:username] = params[:staff][:name]
    params[:staff][:password] = params[:staff][:phone]
    @staff = Staff.new(params[:staff])
    @staff.encrypt_password
    photo = params[:staff][:photo]
    encrypt_name = random_file_name(photo.original_filename) if photo
    @staff.photo = encrypt_name +"_#{Constant::STAFF_PICSIZE.first}."+photo.original_filename.split(".").reverse[0] unless photo.nil?
    @staff.staff_role_relations.new(:role_id => Constant::STAFF)
    if @staff.save   #save staff info and picture
      @staff.operate_picture(photo,encrypt_name +"."+photo.original_filename.split(".").reverse[0], "create") unless photo.nil?
      flash[:notice] = "创建员工成功!"
    else
      flash[:notice] = "创建员工失败!  #{@staff.errors.messages.values.flatten.join("<br/>")}"
    end
    redirect_to "/authorities/set_staff"
  end

end