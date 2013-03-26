#encoding: utf-8
class MaterialsController < ApplicationController   #库存控制器
  layout"logistics_manage"
  def index
    @tab = params[:tab]
    @materials = Material.where("status = #{Material::STATUS[:NORMAL]}")
    .paginate(:page => params[:page] ||= 1,:per_page => 1) if @tab.nil? || @tab.eql?("materials_tab")
    @mat_out_orders = MatOutOrder.all.paginate(:page => params[:page] ||= 1, :per_page => 1) if @tab.nil? || @tab.eql?("mat_out_tab")
    @mat_in_orders = MatInOrder.all.paginate(:page => params[:page] ||= 1, :per_page => 1) if @tab.nil? || @tab.eql?("mat_in_tab")
    @mat_orders = MaterialOrder.all.paginate(:page => params[:page] ||= 1, :per_page => 1) if @tab.nil? || @tab.eql?("mat_orders_tab")
    respond_to do |format|
      format.html
      format.js
    end
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

  def show

  end

  def edit

  end

  def update

  end
  
end