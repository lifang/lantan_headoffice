#encoding: utf-8
class SalesController < ApplicationController   #活动控制器
  layout "market_manages"
  def index #活动列表
    @sales = Sale.where("status >= #{Sale::STATUS[:UN_RELEASE]} and status <= #{Sale::STATUS[:RELEASE]}").
      paginate(:page => params[:page] ||= 1,:per_page => 6)
  end

  def release #发布活动
      @products = Product.where("status = #{Product::IS_VALIDATE[:YES]}")       #选取所有status=1的数据
  end

  def search_product #查询产品
    p_id = (params[:type].to_i == 99999) ? "1 = 1" : "types = #{params[:type]}"
    p_name = (params[:name].nil? || params[:name].empty?) ? "1 = 1" : "name like '%#{params[:name]}%'"
    @products = Product.where("status = #{Product::IS_VALIDATE[:YES]}").where(p_id).where(p_name)
  end

  def create  #发布活动
    s = Sale.new
    sale_name = params[:sale_name]
    disc_types = params[:sale_disc_types].to_i
    if disc_types == 0
      disc = params[:disc_discount].to_f
    else
      disc = params[:disc_money].to_i
    end
    selected_product_count = params[:selected_product_count].to_a
    selected_product_id = params[:selected_product_id].to_a
    sale_disc_time_types = params[:sale_disc_time_types].to_i
    started_time = params[:started_time] ||= ""
    ended_time = params[:ended_time] ||= ""
    sale_everycar_times = params[:sale_everycar_times].to_i
    sale_car_num = params[:sale_car_num].to_i
    sale_img = params[:sale_img]
    sale_is_subsidy = params[:sale_is_subsidy].to_i
    sale_subsidy_money = params[:sale_subsidy_money] ||= ""
    sale_introduction = params[:sale_introduction]
    s.update_attributes(:name => sale_name, :started_at => started_time, :ended_at => ended_time,
      :introduction => sale_introduction, :disc_types => disc_types, :status => Sale::STATUS[:UN_RELEASE], :discount => disc,
      :disc_time_types => sale_disc_time_types, :car_num => sale_car_num, :everycar_times => sale_everycar_times,
      :is_subsidy => sale_is_subsidy, :sub_content => sale_subsidy_money)
    if s.save
      selected_product_id.each_with_index do |item, index|
        SaleProdRelation.create(:sale_id => s.id, :product_id => item.to_i, :prodnum => selected_product_count[index])
      end
      redirect_to sales_path
    end
  end
  def del_sale  #删除活动按钮
    sale = Sale.find(params[:id].to_i)
    if !sale.nil?
      if sale.status == 2
        render :text => 0
      else
        sale.update_attribute("status", Sale::STATUS[:DESTROY])
        render :text => 1
      end
    else
      render :text => 0
    end
  end
  def rel_sale  #发布活动按钮
     sale = Sale.find(params[:id].to_i)
     if !sale.nil?
       if sale.status != 0
         render :text => 0
       else
          sale.update_attribute("status", Sale::STATUS[:RELEASE])
          render :text => 1
       end
     else
       render :text => 0
     end
  end
end