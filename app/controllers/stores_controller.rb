#encoding: utf-8
class StoresController < ApplicationController  #门店控制器
  require 'uri'
  require 'net/http'
  layout "operate_manages"
  before_filter :sign?
  
  def index
     @div_name = params[:div_name]
     if cookies[:admin_id]
     store_sql = "select s.*, c.name c_name, cp.name cp_name from lantan_db.stores s
          left join lantan_db.cities c on c.id = s.city_id
          left join lantan_db.cities cp on cp.id = c.parent_id
          where s.status != #{Store::STATUS[:DELETED]}"
    chain_sql = "select c.*, s.name s_name, s.status s_status from lantan_db.chains c
          left join lantan_db.store_chains_relations scr on c.id = scr.chain_id
          left join lantan_db.stores s on scr.store_id = s.id
          where c.status = ?", Chain::STATUS[:NORMAL]
     elsif cookies[:manage_id]
       store_sql = "select s.*, c.name c_name, cp.name cp_name from lantan_db.chains ca
                    left join lantan_db.store_chains_relations scr on ca.id = scr.chain_id
                    left join lantan_db.stores s on scr.store_id = s.id
                    left join lantan_db.cities c on c.id = s.city_id
                    left join lantan_db.cities cp on c.parent_id = cp.id
                    where ca.staff_id = #{cookies[:manage_id]} and s.status != #{Store::STATUS[:DELETED]}"
      chain_sql = "select c.*, s.name s_name, s.status s_status from lantan_db.chains c
                  left join lantan_db.store_chains_relations scr on c.id = scr.chain_id
                  left join lantan_db.stores s on scr.store_id = s.id
                  where c.status = ? and c.staff_id = ?", Chain::STATUS[:NORMAL], cookies[:manage_id]
     end
    store_params_sql = ""
    store_sql_params = [""]
     unless (params[:store_name].nil? || params[:store_name].empty?)
       store_params_sql += " and s.name like ? "
       store_sql_params << "%#{params[:store_name].strip}%"
     end
     unless (params[:select_province].nil? || params[:select_province].to_i == 0)
       store_params_sql += " and cp.id = ?"
       store_sql_params << params[:select_province].to_i
       @cities = City.where("parent_id = #{params[:select_province].to_i}")
     end
     unless (params[:select_city].nil? || params[:select_city].to_i == 0)
       store_params_sql += " and c.id = ?"
       store_sql_params << params[:select_city].to_i
     end
     store_params_sql += " order by s.created_at desc"
     store_sql_params[0] = store_sql + store_params_sql
     chain_sql[0] += " order by c.created_at desc"
    @stores = Store.paginate_by_sql(store_sql_params, :page => params[:page] ||= 1, :per_page => 10) if @div_name.nil? || @div_name.eql?("stores_div")
    @provinces = City.find(:all, :conditions => ["parent_id = ?", City::IS_PROVINCE]) if @div_name.nil?
    @chains = Chain.paginate_by_sql(chain_sql, :page => params[:page] ||= 1, :per_page => 10) if @div_name.nil? || @div_name.eql?("chains_div")
    @group_chains = @chains.group_by { |c| c.name  } if @chains
    respond_to do |f|
      f.html
      f.js
    end
  end

  def show  #门店详情
    @store = Store.find_by_sql("select s.*, c.name c_name, p.name p_name from lantan_db.stores s
                                left join lantan_db.cities c on c.id = s.city_id
                                left join lantan_db.cities p on c.parent_id = p.id
                                where s.id = #{params[:store_id].to_i}")[0]
  end

  def new #新建
    @store = Store.new
    @provinces = City.find(:all, :conditions => ["parent_id = ?", City::IS_PROVINCE])
  end 

  def create    #创建门店
    store = Store.find(:all, :conditions => ["city_id = ? and name = ? and status != ?",
        params[:new_store_select_city].strip.to_i, params[:new_store_name].strip, Store::STATUS[:DELETED]])
    if store.blank?
      current_store = Store.new(:name => params[:new_store_name].strip, :address => params[:new_store_address].strip, :phone => params[:new_store_phone].strip,
        :contact => params[:new_store_contact].strip, :status => params[:new_store_status].to_i,:opened_at => params[:new_store_open_time].strip,
        :city_id => params[:new_store_select_city].to_i, :position => params[:new_store_location_x].strip+","+params[:new_store_location_y].strip)
      if current_store.save
        begin
          new_store_img = params[:new_store_img]
          new_store_url = Store.upload_img(new_store_img, current_store.id, Constant::STORE_PICS, Constant::STORE_PICSIZE)
          current_store.update_attribute("img_url", new_store_url)
        rescue
          flash[:notice] = "图片上传失败!"
        end
        staff = SStaff.new(:username => params[:new_store_staff_name].strip, :name => SStaff::STORE_ADMIN,
                           :password => params[:new_store_staff_password],:store_id => current_store.id,
                           :status => SStaff::STATUS[:normal], :phone => params[:new_store_staff_name].strip)
        staff.encrypt_password
        if staff.save
          role = SRole.create(:name => SRole::ADMIN, :store_id => current_store.id, :role_type => SRole::ROLE_TYPE[:STORE_MANAGER])
          SStaffRoleRelation.create(:role_id => role.id, :staff_id => staff.id)
          menus = SMenu.all
          menus.each do |m|
            SRoleMenuRelation.create(:role_id => role.id, :menu_id => m.id)
            SRoleModelRelation.create(:role_id => role.id, :num => SStaff::STAFF_MENUS_AND_ROLES[m.controller.to_sym],
                                      :model_name => m.controller)
          end
          flash[:notice] = "创建成功!"
        end
      end
    else
      flash[:notice] = "创建失败，该城市已存在同名的店面!"
    end
    select_province = params[:s_store_province]
    select_city = params[:s_store_city]
    store_name = params[:s_store_name]
    page = params[:s_store_page]
    redirect_to "/stores?select_province="+select_province+"&select_city="+select_city+"&store_name="+store_name+"&page="+page
  end

  def new_chain #新建连锁店
    @provinces = City.find(:all, :conditions => ["parent_id = ?", City::IS_PROVINCE])
  end

  def create_chain    #创建连锁店
    status = 0
    SStaff.transaction do
      staff = SStaff.new(:username => params[:staff_name],:name => SStaff::CHAIN_ADMIN, :status => SStaff::STATUS[:normal],
                         :password => params[:staff_password], :phone => params[:staff_name])
      staff.encrypt_password
      if staff.save
        chain = Chain.new(:name => params[:chain_name], :status => Chain::STATUS[:NORMAL], :staff_id => staff.id)
        if chain.save
          if !params[:selected_stores].blank?
            params[:selected_stores].each do |ss|
              StoreChainRelation.create(:chain_id => chain.id, :store_id => ss.to_i)
            end
          end
          status = 1
        else
          status = 0
        end
      end
    end
    @status = status
  end

  def del_chain     #删除连锁店
    chain = Chain.find_by_id(params[:chain_id].to_i)
    if chain.nil?
      render :json => {:status => 0}
    else
      if chain.update_attribute("status", Chain::STATUS[:DELETED])
        staff = SStaff.find_by_id(chain.staff_id) if chain.staff_id
        staff.update_attribute("status", SStaff::STATUS[:deleted]) if staff
        render :json => {:status => 1}
      else
        render :json => {:status => 0}
      end
    end
  end

  def edit_chain    #编辑连锁店
    @chain = Chain.find_by_id(params[:chain_id].to_i)
    @chain_stores = StoreChainRelation.find_by_sql(["select scr.*, s.id s_id, s.name s_name from lantan_db.store_chains_relations scr
                           left join lantan_db.stores s on scr.store_id = s.id where scr.chain_id = ?", params[:chain_id].to_i])
    @provinces = City.find(:all, :conditions => ["parent_id = ?", City::IS_PROVINCE])
  end

  def update_chain   #更新连锁店
    chain = Chain.find_by_id(params[:chain_id].to_i)
    if !chain.nil?
      if chain.update_attribute("name", params[:chain_name].strip)
        StoreChainRelation.delete_all(:chain_id => params[:chain_id].to_i)
        if !params[:edit_selected_stores].blank?
        params[:edit_selected_stores].each do |a|
          StoreChainRelation.create(:chain_id => params[:chain_id].to_i, :store_id => a.to_i)
        end
        end
        @status = 1
      else
        @status = 0
      end
    else
      @status = 0
    end
  end
  def update  #更新门店
    store = Store.find_by_id(params[:id])
    if Store.where(["id != ? and city_id = ? and name = ? and status != ?", store.id, params[:edit_store_select_city].to_i,
                  params[:edit_store_name].strip, Store::STATUS[:DELETED]]).blank?
      if store.update_attributes(:city_id => params[:edit_store_select_city].to_i, :name => params[:edit_store_name].strip,
          :contact => params[:edit_store_contact].strip, :phone => params[:edit_store_phone].strip, :address => params[:edit_store_address].strip,
          :opened_at => params[:edit_store_open_time].strip, :status => params[:edit_store_status].to_i, :position =>
            params[:edit_store_location_x]+","+params[:edit_store_location_y])
        if !params[:edit_store_img].nil?
          begin
            new_store_url = Store.upload_img(params[:edit_store_img], store.id, Constant::STORE_PICS, Constant::STORE_PICSIZE)
            store.update_attribute("img_url", new_store_url)
          rescue
            flash[:notice] = "图片更新失败"
          end
        end
        flash[:notice] = "更新成功!"
      else
        flash[:notice] = "更新失败!"
      end
    else
      flash[:notice] = "更新失败，该城市下已有同名的门店!"
    end
    select_province = params[:s_store_province]
    select_city = params[:s_store_city]
    store_name = params[:s_store_name]
    page = params[:s_store_page]
    redirect_to "/stores?select_province="+select_province+"&select_city="+select_city+"&store_name="+store_name+"&page="+page
  end

  def edit #编辑门店
    @store = Store.find_by_id(params[:store_id].to_i)
    @provinces = City.find(:all, :conditions => ["parent_id = ?", City::IS_PROVINCE])
    @store_city = City.find_by_id(@store.city_id) if @store.city_id
    @store_province = City.find_by_id(@store_city.parent_id) if @store_city
    @cities = City.where(:parent_id => @store_city.parent_id) if @store_city && @store_city.parent_id != 0
  end
  
   def destroy  #删除门店
    store = Store.find_by_id(params[:id].to_i)
    status = 0
    if !store.nil?
      if store.update_attribute("status", Store::STATUS[:DELETED])
        staff = SStaff.find_by_store_id(store.id)
        staff.update_attribute("status", SStaff::STATUS[:deleted]) if staff
        StoreChainRelation.delete_all(:store_id => store.id)
        status = 1
      else
        status = 0
      end
    end
    @status = status
    @province = params[:store_province]
    @city = params[:store_city]
    @name = params[:store_name]
    @store_page = params[:store_page]
    @chain_page = params[:chain_page]
  end
  
   

    def s_staff_validate  #验证管理员是否唯一
      staff = SStaff.where(["username = ? and status != ?", params[:staff_name].strip, SStaff::STATUS[:deleted]]).first
      if staff
        render :json => {:status => 0}
      else
        render :json => {:status => 1}
      end
    end

   def new_store_select_province #新建门店的省份下拉菜单
    if params[:province_id].to_i != 0
      @cities = City.find(:all, :conditions => ["parent_id = ?",params[:province_id].to_i])
    else
      @cities = nil
    end
  end

   def new_chain_select_province  #新建连锁店时的省份下拉菜单
     @type = params[:type]
     if params[:pid].to_i != 0
       @cities = City.find(:all, :conditions => ["parent_id = ?",params[:pid].to_i])
     else
       @cities = nil
     end
   end

   def new_chain_search_stores  #新建连锁店时的查询门店
     @type = params[:type]
     @stores_ids = params[:stores] if params[:stores]
     a = [""]
     b = ""
     sql = "select s.id s_id, s.name s_name from lantan_db.stores s left join lantan_db.cities c on s.city_id = c.id
            left join lantan_db.cities cp on c.parent_id = cp.id where s.status != ?"
     a << Store::STATUS[:DELETED]
     unless params[:province].to_i == 0
       b += " and cp.id = ?"
       a << params[:province].to_i
     end
     unless params[:city].to_i == 0
       b += " and c.id = ?"
       a << params[:city].to_i
     end
     unless params[:name].nil? || params[:name] == "" || params[:name].empty?
       b += " and s.name like ?"
       a << "%#{params[:name]}%"
     end
     c = sql + b
     a[0] = c
     @stores = Store.find_by_sql(a)
   end

   def chain_validate     #新建或编辑连锁店和管理员重名验证
     status = 0
     if params[:type].eql?("new")
       chains = Chain.where(["name = ? and status != ?", params[:name], Chain::STATUS[:DELETED]])
       staffs = SStaff.where(["username = ? and status != ? ", params[:staff_name], SStaff::STATUS[:deleted]])
       if chains.blank? && staffs.blank?
         status = 1
       elsif !chains.blank?
         status = 0
       elsif !staffs.blank?
         status = 2
       end
     elsif params[:type].eql?("edit")
       id = params[:id].to_i
       chain = Chain.where(["id != ? and name = ? and status != ? ", id, params[:name], Chain::STATUS[:DELETED]])
       if chain.blank?
         status = 1
       else
         status = 0
       end
     end
     render :json => {:status => status}
   end

   def province_change     #搜索店面的省份下拉菜单
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
