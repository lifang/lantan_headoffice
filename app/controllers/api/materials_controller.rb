#encoding: utf-8
class Api::MaterialsController < ApplicationController   #库存控制器api
  def search_material
    sql = ["select m.* from lantan_db.categories c inner join lantan_db.materials m on c.id=m.category_id
            where m.status = ?", Material::STATUS[:NORMAL]]
    unless params[:name].nil? || params[:name].strip == ""
      sql[0] += " and m.name like ? "
      sql << "%#{params[:name].strip.gsub(/[%_]/){|x| '\\' + x}}%"
    end
    unless params[:types].nil? || params[:types].strip == ""
      sql[0] += " and c.id = ?"
      sql << "#{params[:types].to_i}"
    end
    materials = Material.find_by_sql(sql)
    render :json => materials
  end

  def save_mat_info
    material_order_data = JSON.parse(params[:material_order])
    material_order_id = material_order_data['id']
    MaterialOrder.transaction do
      material_order = MaterialOrder.new(material_order_data)
      material_order.id = material_order_id
      material_order.save
      material_order_item = JSON.parse(params[:mat_items_code]) if params[:mat_items_code]
      material_order_item.values.each do |mo|
        material = Material.find_by_code mo["m_code"]

        mat_order_item =  MatOrderItem.create(mo.except("m_code"))
        if mat_order_item and material
          mat_order_item.material_id = material.id
          mat_order_item.material_order_id = material_order.id
          mat_order_item.save
        end
      end if material_order_item
    end
    render :text => '1'
  end

  def update_status
    MaterialOrder.transaction do
      mat_order = MaterialOrder.find_by_code params[:mo_code]
      mat_order.update_attributes(:status => params[:mo_status], :price => params[:mo_price]) if mat_order
      mat_order.update_attribute(:sale_id, params[:sale_id]) unless params[:sale_id].blank?
      if params[:mat_order_types]
        JSON.parse(params[:mat_order_types]).each do |m_order_type|
          mot = MOrderType.find_by_material_order_id_and_pay_types(m_order_type['material_order_id'], m_order_type['pay_types'])
          unless mot
            mot =  MOrderType.new(m_order_type.except('id'))
            mot.save
          end
        end
      end
      render :text => "1"
    end
  end
end
