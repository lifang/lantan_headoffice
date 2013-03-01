#encoding: utf-8
class StoresController < ApplicationController
  def show
   @store = Store.find(params[:store_id])
  end

  def new
    @store = Store.new
    @provinces = City.find(:all, :conditions => ["parent_id = ?", City::IS_PROVINCE])
  end
  def create    #创建门店
    store = Store.find(:all, :conditions => ["city_id = ? and name = ? ", params[:new_store_select_city].strip, params[:new_store_name].strip])
    if store.blank?
      current_store = Store.new(:name => params[:new_store_name].strip, :address => params[:new_store_address].strip, :phone => params[:new_store_phone].strip,
        :contact => params[:new_store_contact].strip, :status => params[:new_store_status],:opened_at => params[:new_store_open_time].strip,
        :city_id => params[:new_store_select_city])
      if current_store.save
        flash[:msg] = "创建成功!"
      end
    else
      flash[:msg] = "创建失败，该城市已存在同名的店面!"
    end
    redirect_to operate_manages_path
  end

  def update  #更新门店
    @store = Store.find(params[:id])
      if @store.update_attributes(:id => params[:id], :city_id => params[:new_store_select_city], :name => params[:new_store_name].strip,
        :contact => params[:new_store_contact].strip, :phone => params[:new_store_phone].strip, :address => params[:new_store_address].strip,
        :opened_at => params[:new_store_open_time].strip, :status => [:new_store_status])
        flash[:msg] = "更新成功!"
        redirect_to operate_manages_path
    end
  end
  def edit #编辑门店
    @store = Store.find(params[:store_id])
    @provinces = City.find(:all, :conditions => ["parent_id = ?", City::IS_PROVINCE])
    @cities = City.find(:all, :conditions => ["parent_id = ?", City.find(@store.city.parent_id)])
  end
   def destroy
    @store = Store.find_by_id(params[:id])
    if !@store.nil?
      if @store.delete
        flash[:msg] = "删除成功!"
      else
        falsh[:mag] = "删除失败!"
      end
    end
    redirect_to operate_manages_path
  end
end
