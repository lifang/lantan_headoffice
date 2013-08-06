#encoding: utf-8
class SalesController < ApplicationController   #活动控制器
  require 'fileutils'
  layout "market_manages"
  before_filter :sign?
  
  def index #活动列表
    @sales = Sale.where("status != #{Sale::STATUS[:DESTROY]}").order("created_at desc").
      paginate(:page => params[:page] ||= 1,:per_page => 10)
  end

  def new #创建活动
    @products = Product.where("status = #{Product::STATUS[:NOMAL]}")
    @page = params[:page]
  end

  def search_product #查询产品
    p_id = (params[:type].to_i == 99999) ? "1 = 1" : ["types = ? ", params[:type].to_i]
    p_name = (params[:name].nil? || params[:name].empty?) ? "1 = 1" : ["name like ? ", "%#{params[:name].strip}%"]
    @products = Product.where("status = #{Product::STATUS[:NOMAL]}").where(p_id).where(p_name)
  end

  def edit_search_product #编辑活动时查询产品
    p_id = (params[:type].to_i == 99999) ? "1 = 1" : ["types = ? ", params[:type].to_i]
    p_name = (params[:name].nil? || params[:name].empty?) ? "1 = 1" : ["name like ? ", "%#{params[:name].strip}%"]
    @products = Product.where("status = #{Product::STATUS[:NOMAL]}").where(p_id).where(p_name)
  end

  def create  #创建活动
    sale_name = params[:sale_name]
    disc_types = params[:sale_disc_types].to_i
    if disc_types == 0
      disc = params[:disc_discount].to_f
    else
      disc = params[:disc_money].to_i
    end
    img = params[:sale_img]
    selected_product_count = params[:selected_product_count].to_a
    selected_product_id = params[:selected_product_id].to_a
    sale_disc_time_types = params[:sale_disc_time_types].to_i  #年月日周。。。
    started_time = params[:started_time] ||= ""
    ended_time = params[:ended_time] ||= ""
    sale_everycar_times = params[:sale_everycar_times].to_i
    sale_car_num = params[:sale_car_num].to_i
    sale_is_subsidy = params[:sale_is_subsidy].to_i
    sale_subsidy_money = params[:sale_subsidy_money] ||= ""
    sale_introduction = params[:sale_introduction]
    sale_code = Sale.set_code(8,"sale","code")
     s = Sale.new(:name => sale_name, :started_at => started_time, :ended_at => ended_time,
      :introduction => sale_introduction, :disc_types => disc_types, :status => Sale::STATUS[:UN_RELEASE], :discount => disc,
      :disc_time_types => sale_disc_time_types, :car_num => sale_car_num, :everycar_times => sale_everycar_times,
     :is_subsidy => sale_is_subsidy, :sub_content => sale_subsidy_money, :code => sale_code)
    selected_product_id.each_with_index do |item, index|
          s.sale_prod_relations.new(:product_id => item.to_i, :prod_num => selected_product_count[index])
       end
    Sale.transaction do
        if s.save
          if !img.nil?
            url = Sale.upload_img(img, s.id, Constant::SALE_PICS, Constant::STORE_ID, Constant::SALE_PICSIZE)
            s.update_attribute("img_url", url)
          end
          flash[:notice] = "活动创建成功!"
          redirect_to sales_path
        else
          flash[:notice] = "活动创建失败!"
          page = (params[:page].nil? || params[:page]=="") ? 1 : params[:page].to_i
          redirect_to "/sales?page=#{page}"
        end        
    end
  end

  def update #更新活动
    sale = Sale.find(params[:edit_sale_id].to_i)
    sale_name = params[:edit_sale_name]
    disc_types = params[:edit_sale_disc_types].to_i
    if disc_types == 0
      disc = params[:edit_disc_discount].to_f
    else
      disc = params[:edit_disc_money].to_f
    end
    img = params[:edit_sale_img]
    selected_product_count = params[:edit_selected_product_count].to_a
    selected_product_id = params[:edit_selected_product_id].to_a
    sale_disc_time_types = params[:edit_sale_disc_time_types].to_i  #年月日周。。。
    started_time = params[:edit_started_time] ||= ""
    ended_time = params[:edit_ended_time] ||= ""
    sale_everycar_times = params[:edit_sale_everycar_times].to_i
    sale_car_num = params[:edit_sale_car_num].to_i
    sale_is_subsidy = params[:edit_sale_is_subsidy].to_i
    sale_subsidy_money = params[:edit_sale_subsidy_money] ||= ""
    sale_introduction = params[:edit_sale_introduction]   
    if sale.update_attributes(:name => sale_name, :started_at => started_time, :ended_at => ended_time,
        :introduction => sale_introduction, :disc_types => disc_types, :discount => disc,
        :disc_time_types => sale_disc_time_types, :car_num => sale_car_num, :everycar_times => sale_everycar_times,
        :is_subsidy => sale_is_subsidy, :sub_content => sale_subsidy_money)
      SaleProdRelation.destroy_all("sale_id = #{sale.id}")
      selected_product_id.each_with_index do |item, index|
        SaleProdRelation.create(:product_id => item.to_i, :prod_num => selected_product_count[index].strip, :sale_id => sale.id)
      end
      if !img.nil?
        new_url = Sale.upload_img(img, sale.id, Constant::SALE_PICS, Constant::STORE_ID, Constant::SALE_PICSIZE)
        sale.update_attribute("img_url", new_url)
      end
      flash[:notice] = "活动修改成功!"
    else
      flash[:notice] = "活动修改失败!"
    end
    page = (params[:edit_sale_page].nil? || params[:edit_sale_page] == "") ? 1 : params[:edit_sale_page].to_i
    redirect_to "/sales?page=#{page}"
  end

  def edit #修改活动
    @sale = Sale.find(params[:id].to_i)
    @sale_products = @sale.sale_prod_relations
    @products = Product.where("status = #{Product::STATUS[:NOMAL]}")
    @page = params[:page]
  end
  
  def destroy  #删除活动按钮
    sale = Sale.find(params[:id].to_i)
    if !sale.nil?
        if sale.update_attribute("status", Sale::STATUS[:DESTROY])
          flash[:notice] = "删除成功!"
        end
    else
      flash[:notice] = "删除失败!"
    end
    #page = (params[:page].nil? || params[:page]=="") ? 1 : params[:page].to_i
    redirect_to sales_path
  end

  def rel_sale  #发布活动按钮
    sale = Sale.find(params[:id].to_i)
    if !sale.nil?   
       if sale.update_attribute("status", Sale::STATUS[:RELEASE])
        flash[:notice] = "发布成功!"
       end
    else
      flash[:notice] = "发布失败!"
    end
    page = (params[:page].nil? || params[:page]=="") ? 1 : params[:page].to_i
    redirect_to "/sales?page=#{page}"
  end

end