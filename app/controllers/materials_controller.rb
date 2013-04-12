#encoding: utf-8
class MaterialsController < ApplicationController   #库存控制器
  layout"logistics_manages", :except => "m_list"
  before_filter :sign?
  
  def index
    @tab = params[:tab]
    status = (params[:status].nil? || params[:status].empty? || params[:status].to_i == 999) ? "1 = 1" : "material_orders.status = #{params[:status].to_i}"
    started_time = (params[:started_time].nil? || params[:started_time].empty?) ? "1 = 1" : "material_orders.created_at >= '#{params[:started_time]}'"
    ended_time = (params[:ended_time].nil? || params[:ended_time].empty?) ? "1 = 1" : "material_orders.created_at <= '#{params[:ended_time]}'"
    @materials = Material.where("status = #{Material::STATUS[:NORMAL]}")
    .paginate(:page => params[:page] ||= 1,:per_page => 10) if @tab.nil? || @tab.eql?("materials_tab")

    @mat_out_orders = MatOutOrder.joins(:material).paginate(:page => params[:page] ||= 1, :per_page => 10) if @tab.nil? || @tab.eql?("mat_out_tab")
    @mat_in_orders = MatInOrder.joins(:material).paginate(:page => params[:page] ||= 1, :per_page => 10) if @tab.nil? || @tab.eql?("mat_in_tab")
    @mat_orders = MaterialOrder.joins(:mat_order_items => :material).is_headoffice_not_canceled.where(status).where(started_time).where(ended_time).uniq.paginate(:page => params[:page] ||= 1, :per_page => 10) if @tab.nil? || @tab.eql?("mat_orders_tab")
    respond_to do |format|
      format.html
      format.js
    end
  end

  def m_list #库存清单
     @materials = Material.where("status = #{Material::STATUS[:NORMAL]}")
  end

  def show_material_beizhu #显示库存备注
    material = Material.find(params[:m_id].to_i)
    @beizhu = material.remark
    @id = material.id
    @action_name = "material"
    respond_to do |format|
      format.js
    end
  end

  def material_update #更新库存备注
    material = Material.find(params[:beizhu_id].to_i)
    material.update_attribute("remark", params[:beizhu_content])
    respond_to do |format|
      format.js
    end
  end

  def material_check #库存核实
    material = Material.find(params[:m_id].to_i)
    if material.storage == params[:storage].to_i
      render :json => 0
    else
      material.update_attribute("storage", params[:storage].to_i)
      render :json => 1
    end
  end
  
  def show_material_order_beizhu #显示门店订货备注
    mo = MaterialOrder.find(params[:mo_id].to_i)
    @beizhu = mo.remark
    @id = mo.id
    @action_name = "material_order"
    respond_to do |format|
     format.js
    end
  end

  def material_order_update #更新门店订货备注
    mo = MaterialOrder.find(params[:beizhu_id].to_i)
    mo.update_attribute("remark", params[:beizhu_content])
    respond_to do |format|
      format.js
    end
  end

  def mat_order_detail #订单详情
    @mo = MaterialOrder.find(params[:mo_id].to_i)
    @total_money = 0
    @mo.mat_order_items.each do |moi|
      @total_money += moi.price * moi.material_num
    end
    respond_to do |format|
      format.js
    end
  end

  def deliver_good #发货
    mo = MaterialOrder.find(params[:m_o_id].to_i)
    arrive_time = params[:arrive_time]
    logistic_code = params[:logistic_code]
    carrier = params[:carrier]
    if mo.update_attributes(:carrier => carrier, :arrival_at => arrive_time, :logistics_code => logistic_code, :m_status => 1)
     render :json => 1
    else
      render :json => 0
    end
  end

  def urge_payment #催款
    mo = MaterialOrder.find(params[:mo_id].to_i)
    store_id = mo.store_id
    if !store_id.nil?
      Notice.create(:types => Notice::TYPES[:URGE_PAYMENT], :content => "请尽快上缴拖欠的货款",
        :status => Notice::STATUS[:NOMAL], :store_id => store_id)
      render :json => 1
    else
      render :json => 0
    end
  end
  
  def ruku #入库
    m_name = params[:m_name]
    m_type = params[:m_type].to_i
    m_code = params[:m_code]
    m_num = params[:m_num].to_i
    m_price = params[:m_price]
    m = Material.where("name = '#{m_name}'").where("types = #{m_type}")
    if !m.blank?
      material = m[0]
      total_num = material.storage + m_num
      MatInOrder.create(:material_id => material.id, :material_num => m_num,
        :price => m_price, :staff_id => cookies[:user_id].to_i)
      material.update_attribute("storage", total_num)
    else
      material = Material.create(:name => m_name, :code => m_code, :price => m_price, :types => m_type,
        :status => Material::STATUS[:NORMAL], :storage => m_num)
      MatInOrder.create(:material_id => material.id, :material_num => m_num,
        :price => m_price, :staff_id => cookies[:user_id].to_i)
    end
    respond_to do |format|
      format.js
    end
  end
end