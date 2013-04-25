#encoding: utf-8
class StoresController < ApplicationController  #门店控制器
  layout "operate_manages"
  before_filter :sign?
  
  def index  
    sql = "select s.*, c.name c_name, cp.name cp_name from lantan_db_all.stores s
          left join cities c on c.id = s.city_id
          left join cities cp on cp.id = c.parent_id where s.status != #{Store::STATUS[:DELETED]}"
    params_sql = ""
    sql_params = [""]
     unless (params[:store_name].nil? || params[:store_name].empty?)
       params_sql += " and s.name like ? "
       sql_params << "%#{params[:store_name].strip}%"
     end
     unless (params[:select_province].to_i == 0)
       params_sql += " and cp.id = ?"
       sql_params << params[:select_province].to_i
     end
     unless (params[:select_city].to_i == 0)
       params_sql += " and c.id = ?"
       sql_params << params[:select_city].to_i
       @cities = City.where("parent_id = #{params[:select_province].to_i}")
     end
     sql_params[0] = sql + params_sql
     @stores = Store.paginate_by_sql(sql_params, :page => params[:page] ||= 1, :per_page => 10)
    @provinces = City.find(:all, :conditions => ["parent_id = ?", City::IS_PROVINCE])
  end

  def show  #门店详情
    @store = Store.find_by_sql("select s.*, c.name c_name, p.name p_name from lantan_db_all.stores s
                                left join cities c on c.id = s.city_id
                                left join cities p on c.parent_id = p.id
                                where s.id = #{params[:store_id]}")[0]

  end

  def new #新建
    @store = Store.new
    @provinces = City.find(:all, :conditions => ["parent_id = ?", City::IS_PROVINCE])
  end

  def create    #创建门店
    store = Store.find(:all, :conditions => ["city_id = ? and name = ? ", params[:new_store_select_city].strip.to_i, params[:new_store_name].strip])
    if store.blank?
      current_store = Store.new(:name => params[:new_store_name].strip, :address => params[:new_store_address].strip, :phone => params[:new_store_phone].strip,
        :contact => params[:new_store_contact].strip, :status => params[:new_store_status].to_i,:opened_at => params[:new_store_open_time].strip,
        :city_id => params[:new_store_select_city].to_i)
      if current_store.save
        flash[:msg] = "创建成功!"
      end
    else
      flash[:msg] = "创建失败，该城市已存在同名的店面!"
    end
    redirect_to stores_path
  end

  def update  #更新门店
    @store = Store.find_by_id(params[:id])
      if @store.update_attributes(:city_id => params[:edit_store_select_city].to_i, :name => params[:edit_store_name].strip,
        :contact => params[:edit_store_contact].strip, :phone => params[:edit_store_phone].strip, :address => params[:edit_store_address].strip,
        :opened_at => params[:edit_store_open_time].strip, :status => params[:edit_store_status].to_i)
        flash[:msg] = "更新成功!"
        redirect_to stores_path
    end
  end

  def edit #编辑门店
    @store = Store.find(params[:store_id].to_i)
    @provinces = City.find(:all, :conditions => ["parent_id = ?", City::IS_PROVINCE])
    @cities = City.where(:parent_id => @provinces.map(&:id))
  end
  
   def destroy  #删除门店
    @store = Store.find_by_id(params[:id].to_i)
    if !@store.nil?
      if @store.update_attribute("status", Store::STATUS[:DELETED])
        flash[:notice] = "删除成功!"
      else
        falsh[:notice] = "删除失败!"
      end
    end
    redirect_to stores_path
  end
  
   def province_change     #搜索店面的省份下拉菜单
    if params[:province_id].to_i != 0
      @cities = City.find(:all, :conditions => ["parent_id = ?",params[:province_id].to_i])
    else
      @cities = nil
    end
  end
  
   def new_store_select_province #新建门店的省份下拉菜单
    if params[:province_id].to_i != 0
      @cities = City.find(:all, :conditions => ["parent_id = ?",params[:province_id].to_i])
    else
      @cities = nil
    end
  end

   def edit_store_select_province #编辑门店的省份下拉菜单
      if params[:province_id].to_i != 0
      @cities = City.find(:all, :conditions => ["parent_id = ?",params[:province_id].to_i])
    else
      @cities = nil
    end
   end
end
