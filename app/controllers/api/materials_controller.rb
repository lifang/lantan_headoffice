#encoding: utf-8
class Api::MaterialsController < ApplicationController   #库存控制器api
  def search_material
    str = params[:name].strip.length > 0 ? "name like '%#{params[:name]}%' and types=#{params[:types]} " : "types=#{params[:types]}"
    materials = Material.normal.all(:conditions => str)
    render :json => materials
  end

  def save_mat_info
    material_order_data = JSON.parse(params[:material_order])
    material_order_id = material_order_data['id']
    material_order = MaterialOrder.new(material_order_data)
    material_order.id = material_order_id
    material_order.save
    material_order_item = JSON.parse(params[:mat_items_code]) if params[:mat_items_code]
    material_order_item.values.each do |mo|
      material = Material.find_by_code mo["m_code"]

      mat_order_item =  MatOrderItem.create(mo.except("m_code"))
      if mat_order_item
        mat_order_item.material_id = material.id
        mat_order_item.material_order_id = material_order.id
        mat_order_item.save
      end
    end if material_order_item
    
    render :text => '1'
  end

  def update_status
    mat_order = MaterialOrder.find_by_code params[:mo_code]
    mat_order.update_attributes(:status => params[:mo_status], :price => params[:mo_price]) if mat_order
    mat_order.update_attribute(:sale_id, params[:sale_id]) unless params[:sale_id].blank?
    if params[:mat_order_types]
      JSON.parse(params[:mat_order_types]).each do |m_order_type|
       mot =  MOrderType.new(m_order_type.except('id'))
       mot.save
      end
    end
    render :text => "1"
  end
end
