#encoding: utf-8
class SalesController < ApplicationController   #活动控制器
   require 'fileutils'
   require 'mini_magick'
  layout "market_manages"
  def index #活动列表
    @sales = Sale.where("status >= #{Sale::STATUS[:UN_RELEASE]} and status <= #{Sale::STATUS[:RELEASE]}").
      paginate(:page => params[:page] ||= 1,:per_page => 10)
  end

  def release #发布活动
      @products = Product.where("status = #{Product::STATUS[:NOMAL]}")
  end

  def search_product #查询产品
    p_id = (params[:type].to_i == 99999) ? "1 = 1" : "types = #{params[:type]}"
    p_name = (params[:name].nil? || params[:name].empty?) ? "1 = 1" : "name like '%#{params[:name]}%'"
    @products = Product.where("status = #{Product::STATUS[:NOMAL]}").where(p_id).where(p_name)
  end

  def edit_search_product #编辑活动时查询产品
    p_id = (params[:type].to_i == 99999) ? "1 = 1" : "types = #{params[:type]}"
    p_name = (params[:name].nil? || params[:name].empty?) ? "1 = 1" : "name like '%#{params[:name]}%'"
    @products = Product.where("status = #{Product::STATUS[:NOMAL]}").where(p_id).where(p_name)
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
    img = params[:sale_img]
    img_name = "sale#{Time.now.strftime('%Y%m%d%H%m%s')+(0...5).map{('a'...'z').to_a[rand(26)]}.join}.#{img.original_filename.split('.').reverse[0]}"
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
    sale_code = Sale.set_code(8)
    s.update_attributes(:name => sale_name, :started_at => started_time, :ended_at => ended_time,
      :introduction => sale_introduction, :disc_types => disc_types, :status => Sale::STATUS[:UN_RELEASE], :discount => disc,
      :disc_time_types => sale_disc_time_types, :car_num => sale_car_num, :everycar_times => sale_everycar_times,
      :is_subsidy => sale_is_subsidy, :sub_content => sale_subsidy_money, :img_url => "/saleimg/#{img_name}", :code => sale_code)
    if s.save
      FileUtils.mkdir_p "public/saleimg" if !FileTest.directory?("public/saleimg")
      File.new(Rails.root.join("public", "saleimg", img_name), "a+")
      File.open(Rails.root.join("public", "saleimg", img_name), "wb") do |file|
        file.write(img.read)
      end
      selected_product_id.each_with_index do |item, index|
        SaleProdRelation.create(:sale_id => s.id, :product_id => item.to_i, :prod_num => selected_product_count[index])
      end    
    end
    flash[:notice] = "活动创建成功!"
    redirect_to sales_path
  end

  def update #更新活动
    sale = Sale.find(params[:edit_sale_id].to_i)
    sale_name = params[:edit_sale_name]
    disc_types = params[:edit_sale_disc_types].to_i
    if disc_types == 0
      disc = params[:disc_discount].to_f
    else
      disc = params[:disc_money].to_i
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
    SaleProdRelation.destroy_all("sale_id = #{sale.id}")
    if img.nil?
      if sale.update_attributes(:name => sale_name, :started_at => started_time, :ended_at => ended_time,
          :introduction => sale_introduction, :disc_types => disc_types, :discount => disc,
          :disc_time_types => sale_disc_time_types, :car_num => sale_car_num, :everycar_times => sale_everycar_times,
          :is_subsidy => sale_is_subsidy, :sub_content => sale_subsidy_money)
        selected_product_id.each_with_index do |item, index|
          SaleProdRelation.create(:sale_id => sale.id, :product_id => item.to_i, :prod_num => selected_product_count[index])
        end
      end
    else
      img_name = "sale#{Time.now.strftime('%Y%m%d%H%m%s')+(0...5).map{('a'...'z').to_a[rand(26)]}.join}.#{img.original_filename.split('.').reverse[0]}"
      old_img = sale.img_url   
      if sale.update_attributes(:name => sale_name, :started_at => started_time, :ended_at => ended_time,
          :introduction => sale_introduction, :disc_types => disc_types, :discount => disc,
          :disc_time_types => sale_disc_time_types, :car_num => sale_car_num, :everycar_times => sale_everycar_times,
          :is_subsidy => sale_is_subsidy, :sub_content => sale_subsidy_money,:img_url => "/saleimg/#{img_name}")
        selected_product_id.each_with_index do |item, index|
          SaleProdRelation.create(:sale_id => sale.id, :product_id => item.to_i, :prod_num => selected_product_count[index])
        end
        FileUtils.rm_rf "public/#{old_img}" if FileTest.file?("public/#{old_img}")
        File.new(Rails.root.join("public", "saleimg", img_name), "a+")
        File.open(Rails.root.join("public", "saleimg", img_name), "wb") do |file|
        file.write(img.read)
      end
      end
    end
     flash[:notice] = "活动修改成功!"
    redirect_to sales_path
  end

  def edit #修改活动
    @sale = Sale.find(params[:s_id].to_i)
    @sale_products = @sale.sale_prod_relations
    @products = Product.where("status = #{Product::STATUS[:NOMAL]}")
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