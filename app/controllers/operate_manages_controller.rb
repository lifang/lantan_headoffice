#encoding: utf-8
class OperateManagesController < ApplicationController   #运营管理控制器
  before_filter :sign?
  
  def index
    if params[:select_province].to_i == 0 && params[:select_city].to_i == 0 && params[:store_name] == "" #如果都不选
      @stores = Store.all.paginate(:page => params[:page] ||= 1,:per_page => 10,:order => "created_at desc")
    elsif params[:select_province].to_i != 0 && params[:select_city].to_i == 0 && params[:store_name] == ""  #如果只选省
      stores = []
      cities = City.find(:all, :conditions => ["parent_id = ?", params[:select_province]])
      cities.each do |city|
        st = Store.find(:all, :conditions => ["city_id = ?", city.id])
        st.each do |s|
          stores << s
        end
      end
      @stores = stores.paginate(:page => params[:page] ||= 1,:per_page => 10,:order => "created_at desc")
    elsif params[:select_province].to_i != 0 && params[:select_city].to_i != 0 && params[:store_name] == "" #如果选省市，不输入店名
      @cities = City.find(:all, :conditions => ["parent_id = ?", params[:select_province]])
      @stores = Store.find(:all, :conditions => ["city_id = ?", params[:select_city]]).paginate(:page => params[:page] ||= 1,
        :per_page => 10,:order => "created_at desc")
    elsif params[:select_province].to_i != 0 && params[:select_city].to_i != 0 && params[:store_name] != "" #如果都选
      @cities = City.find(:all, :conditions => ["parent_id = ?", params[:select_province]])
      @stores = Store.find(:all, :conditions => ["city_id = ? and name like ?", params[:select_city], "%#{params[:store_name]}%"]).
        paginate(:page => params[:page] ||= 1,
        :per_page => 10,:order => "created_at desc")
    elsif params[:select_province].to_i != 0 && params[:select_city].to_i == 0 && params[:store_name] != "" #如果只选省并且输入店名
      stores = []
      cities = City.find(:all, :conditions => ["parent_id = ?", params[:select_province]])
      cities.each do |city|
        st = Store.find(:all, :conditions => ["city_id = ? and name like ?", city.id, "%#{params[:store_name]}%"])
        st.each do |s|
          stores << s
        end
      end
      @stores = stores.paginate(:page => params[:page] ||= 1,:per_page => 10,:order => "created_at desc")
    elsif params[:select_province].to_i == 0 && params[:select_city].to_i == 0 && params[:store_name] != "" #如果只输入店名
      @stores = Store.find(:all, :conditions => ["name like ?", "%#{params[:store_name]}%"]).paginate(:page => params[:page] ||= 1,
        :per_page => 10,:order => "created_at desc")
    end
    @provinces = City.find(:all, :conditions => ["parent_id = ?", City::IS_PROVINCE])
  end

  def province_change     #搜索店面的省份下拉菜单
    if params[:province_id].to_i != 0
      @cities = City.find(:all, :conditions => ["parent_id = ?",params[:province_id]])
    else
      @cities = nil
    end
  end

  def new_store_select_province #新建门店的省份下拉菜单
    if params[:province_id].to_i != 0
      @cities = City.find(:all, :conditions => ["parent_id = ?",params[:province_id]])
    else
      @cities = nil
    end
  end
end
