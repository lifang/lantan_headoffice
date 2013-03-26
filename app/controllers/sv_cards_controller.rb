#encoding: utf-8
class SvCardsController < ApplicationController   #优惠卡控制器
  require 'fileutils'
  require 'mini_magick'
  layout "market_manages"
  def index #优惠卡主页
    @sv_cards = SvCard.all.paginate(:page => params[:page] ||= 1,:per_page => 6,:order => "created_at asc")
  end

  def select_discount_card #新建时选择打折卡
    @product_types = Product::PRODUCT_TYPES
    @products = Product.all
  end


  def search_products_all #选择项目时的全部
    @products = Product.all
  end
  def edit_search_products_all  #编辑时选择项目全部
      @products = Product.all
  end
  def search_products_part #选择项目时的部分
    product_type = "types = #{params[:product_type].to_i}"
    product_name = (params[:product_name].nil? || params[:product_name] == "") ? "1=1" : "name like '%#{params[:product_name]}%'"
    @products = Product.where(product_type).where(product_name)
  end
  def edit_search_products_part #编辑时选择项目时的部分
    product_type = "types = #{params[:product_type].to_i}"
    product_name = (params[:product_name].nil? || params[:product_name] == "") ? "1=1" : "name like '%#{params[:product_name]}%'"
    @products = Product.where(product_type).where(product_name)
  end
  def create          #创建优惠卡
    sv_card = SvCard.new
    card_type = params[:card_type].to_i
    card_name = params[:card_name]
    card_description = params[:card_description]
    img = params[:card_url]      #获取上传的图片
    img_name = "#{card_name}.#{img.original_filename.split('.').reverse[0]}"    #拼凑成xxx.jpg/png...
    if card_type == 1                                       #如果是储值卡
      started_money = params[:started_money].to_i
      ended_money = params[:ended_money].to_i
      total_money = started_money + ended_money
      sv_card.update_attributes(:name => card_name, :types => card_type, :price => total_money, :description => card_description,
        :img_url => "/cardimg/#{img_name}")
      if sv_card.save
         FileUtils.mkdir_p "public/cardimg" if !FileTest.directory?("public/cardimg")
        File.new(Rails.root.join("public", "cardimg", img_name), "a+")
        File.open(Rails.root.join("public", "cardimg",img_name), "wb") do |file|
          file.write(img.read) 
        end
      end
    elsif card_type == 0                                        #如果是打折卡
      discount = params[:discount_value]
      product_count = params[:product_count].to_a
      product_id = params[:product_hidden_id].to_a
      sv_card.update_attributes(:name => card_name, :types => card_type,:discount => discount, :description => card_description,
        :img_url => "/cardimg/#{img_name}")
      if sv_card.save
        FileUtils.mkdir_p "public/cardimg" if !FileTest.directory?("public/cardimg")
        File.new(Rails.root.join("public", "cardimg", img_name), "a+")
        File.open(Rails.root.join("public", "cardimg", img_name), "wb") do |file|
          file.write(img.read)
        end
        product_id.each_with_index do |item,index|  
          p = Product.find(item.to_i)
          SvcardProdRelation.create(:product_id => item.to_i, :product_num => product_count[index].to_i, :sv_card_id => sv_card.id, :base_price => p.base_price, :more_price => p.sale_price)
        end
      end    
    end
    flash[:notice] = "创建成功!"
     redirect_to sv_cards_path
  end

  def update    #更新优惠卡
    sc = SvCard.find(params[:edit_card_id].to_i)
    old_img = sc.img_url
    name = params[:edit_card_name]
    type = sc.types
    description = params[:edit_card_description]
    img = params[:edit_card_url]
    if !img.nil?
      img_name = "#{name}.#{img.original_filename.split('.').reverse[0]}"    #拼凑成xxx.jpg/png...
    end
    if type == 1
      started_money = params[:edit_started_money].to_i
      ended_money = params[:edit_ended_money].to_i
      total_money = started_money + ended_money
      if !img.nil?
         FileUtils.rm_rf "public/#{old_img}" if FileTest.file?("public/#{old_img}")
        if sc.update_attributes(:name => name, :price => total_money, :description => description, :img_url => "cardimg/#{img_name}")
          File.new(Rails.root.join("public", "cardimg", img_name), "a+")
          File.open(Rails.root.join("public", "cardimg", img_name), "wb") do |file|
            file.write(img.read)
          end        
        end
      else
        sc.update_attributes(:name => name, :price => total_money, :description => description)
      end
    elsif type == 0
      discount = params[:edit_discount_value]
      product_count = params[:edit_product_count].to_a
      product_id = params[:edit_product_hidden_id].to_a
      SvcardProdRelation.destroy_all("sv_card_id= #{params[:edit_card_id].to_i}")
      if !img.nil?
         FileUtils.rm_rf "public/#{old_img}" if FileTest.file?("public/#{old_img}")
        if sc.update_attributes(:name => name,:description => description, :discount => discount, :img_url => "cardimg/#{img_name}")
          File.new(Rails.root.join("public", "cardimg", img_name), "a+")
          File.open(Rails.root.join("public", "cardimg", img_name), "wb") do |file|
            file.write(img.read)
          end
          product_id.each_with_index do |item,index|
            p = Product.find(item.to_i)
            SvcardProdRelation.create(:product_id => item.to_i, :product_num => product_count[index].to_i, :sv_card_id => sc.id, :base_price => p.base_price, :more_price => p.sale_price)
          end
        end        
        else
          if sc.update_attributes(:name => name,:description => description, :discount => discount)
            product_id.each_with_index do |item,index|
              p = Product.find(item.to_i)
              SvcardProdRelation.create(:product_id => item.to_i, :product_num => product_count[index].to_i, :sv_card_id => sc.id, :base_price => p.base_price, :more_price => p.sale_price)
            end
          end
        end
    end
    flash[:notice] = "创建成功!"
    redirect_to sv_cards_path
  end

  def edit_card   #编辑优惠卡
    @card = SvCard.find(params[:c_id].to_i)
    @product_types = Product::PRODUCT_TYPES
    @products = Product.all
    @card_products = @card.svcard_prod_relations
  end

  def sell_situation  #销售情况
    @card_type = params[:card_type] ||= "2"
    @started_time = params[:started_time]
    @ended_time = params[:ended_time]

    started_time_sql =  (@started_time.nil? || @started_time.empty?) ? "1 = 1" : "c_svc_relations.created_at >= '#{@started_time}'"
    ended_time_sql = (@ended_time.nil? || @ended_time.empty?) ? "1 = 1" : "c_svc_relations.created_at <= '#{@ended_time}'"
    sv_card_type_sql = @card_type.eql?("2") ? "1 = 1" : "sv_cards.types = #{@card_type}"

    re = CSvcRelation.includes(:sv_card).where(started_time_sql).where(ended_time_sql).where(sv_card_type_sql).order("c_svc_relations.created_at asc")

    re_total_money = CSvcRelation.includes(:sv_card).where(started_time_sql).where(ended_time_sql).where(sv_card_type_sql).sum(:total_price)

    @total_money = re_total_money
    @count = re.length

    @relations = re.paginate(:page => params[:page] ||= 1,:per_page => 6)   
  end

  def make_billing  #开具发票
    relation = CSvcRelation.find(params[:id].to_i)
    if !relation.is_billing
      relation.update_attribute("is_billing", 1)
      render :text => 1
    else
      render :text => 0
    end
  end

  def use_detail  #使用详情
    order_started_time_sql = (params[:started_time].nil? ||  params[:started_time].empty?) ? "1 = 1" : "orders.created_at >= '#{params[:started_time]}'"
    order_ended_time_sql = (params[:ended_time].nil? || params[:ended_time].empty?) ? "1 = 1" : "orders.created_at <= '#{params[:ended_time]}'"
    srr_started_sql = (params[:started_time].nil? ||  params[:started_time].empty?) ? "1 = 1" : "created_at >= '#{params[:started_time]}'"
    srr_ended_sql = (params[:ended_time].nil? ||  params[:ended_time].empty?) ? "1 = 1" : "created_at <= '#{params[:ended_time]}'"
    #获取时间段内所有使用了储值卡的已完成的订单数量，并且根据门店分组
    orders = Order.includes(:c_svc_relation => :sv_card).
      where("orders.status = #{Order::STATUS[:FINISHED]}").
      where(order_started_time_sql).where(order_ended_time_sql).
      where("orders.c_svc_relation_id is not null").
      where("sv_cards.types = #{SvCard::FAVOR[:value]}").group("orders.store_id").count
    #获取时间段内储值卡返还记录中客户消费收入的钱
    in_money_hash = SvcReturnRecord.where(srr_started_sql).where(srr_ended_sql).where("types = #{SvcReturnRecord::TYPES[:in]}").group("store_id").sum(:price)
     #获取时间段内储值卡返还记录中门店已支出的钱
    out_money_hash = SvcReturnRecord.where(srr_started_sql).where(srr_ended_sql).where("types = #{SvcReturnRecord::TYPES[:out]}").group("store_id").sum(:price)
    form_detail = []
    orders.each do |key, value|
      #门店id 使用次数 收入金额 支出金额
        form_detail << key.to_s+","+value.to_s+","+in_money_hash[key].to_s+","+out_money_hash[key].to_s
    end
     @form_detail = form_detail.paginate(:page => params[:page] ||= 1,:per_page => 6)
    #获取所有用户的储值卡
    cs = CSvcRelation.includes(:sv_card).where("sv_cards.types = #{SvCard::FAVOR[:value]}")
    @total_money = cs.sum(:total_price) #储值卡总计
    @left_money = cs.sum(:left_price)  #储值卡余额
    @started_time = params[:started_time]
    @ended_time = params[:ended_time]
  end

  def use_collect   #使用情况汇总
    started_sql = (params[:started_time].nil? ||  params[:started_time].empty?) ? "1 = 1" : "created_at >= '#{params[:started_time]}'"
    ended_sql = (params[:ended_time].nil? ||  params[:ended_time].empty?) ? "1 = 1" : "created_at <= '#{params[:ended_time]}'"
    s = SvcReturnRecord.where(started_sql).where(ended_sql).where("types = #{SvcReturnRecord::TYPES[:out]}")
    ss = s.group_by {|e| e.created_at.beginning_of_month}
    total_money = 0
    form_collect = []
    ss.each do |key, value|
      value.each do |v|
        total_money += v.price
      end
    form_collect << key.to_s + "," + total_money.to_s
    total_money = 0
    end
    @form_collect = form_collect.paginate(:page => params[:page] ||= 1,:per_page => 6)
  end
end