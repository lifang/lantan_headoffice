#encoding: utf-8
class SvCardsController < ApplicationController   #优惠卡控制器
  require 'fileutils'
  layout "market_manages"
  before_filter :sign?
  
  def index #优惠卡主页
    @sv_cards = SvCard.order("created_at desc").paginate(:page => params[:page] ||= 1,:per_page => 10)
  end
  
  def select_discount_card #新建时选择打折卡
    @product_types = Product::PRODUCT_TYPES
  end

 
  def create          #创建优惠卡
    sv_card = SvCard.new
    card_type = params[:card_type].to_i
    card_name = params[:card_name].strip
    card_description = params[:card_description]
    img = params[:card_url]      #获取上传的图片
    if SvCard.where(["types= ? and name = ?", card_type, card_name]).blank?
      if card_type == 1                                       #如果是储值卡
        started_money = params[:started_money].to_f
        ended_money = params[:ended_money].to_f
        sv_card.update_attributes(:name => card_name, :types => card_type, :price => started_money, :description => card_description)
        if sv_card.save
          SvcardProdRelation.create(:sv_card_id => sv_card.id, :base_price => started_money, :more_price => ended_money)
        end
      elsif card_type == 0                                        #如果是打折卡
        discount = params[:discount_value]
        price = params[:discount_price].to_f
        sv_card.update_attributes(:name => card_name, :types => card_type,:discount => discount, :price => price, :description => card_description)
        sv_card.save
      end
      begin
        url = SvCard.upload_img(img, sv_card.id, Constant::SVCARD_PICS, Constant::STORE_ID, Constant::SVCARD_PICSIZE)
        sv_card.update_attribute("img_url", url)
        flash[:notice] = "创建成功!"
      rescue
        flash[:notice] = "图片上传失败!"
      end
    else
      flash[:notice] = "创建失败，已有同名的优惠卡!"
    end
    redirect_to sv_cards_path
  end

  def update    #更新优惠卡
    sc = SvCard.find(params[:edit_card_id].to_i)
    name = params[:edit_card_name].strip
    type = sc.types
    description = params[:edit_card_description]
    img = params[:edit_card_url]
    if SvCard.where(["id != ? and types = ? and name = ?", sc.id, type, name]).blank?
      if type == 1
        started_money = params[:edit_started_money].to_f
        ended_money = params[:edit_ended_money].to_f
        if sc.update_attributes(:name => name, :price => started_money, :description => description)
          SvcardProdRelation.destroy_all("sv_card_id = #{sc.id}")
          SvcardProdRelation.create(:sv_card_id => sc.id, :base_price => started_money, :more_price => ended_money)
          if !img.nil?
            begin
              new_url = SvCard.upload_img(img, sc.id, Constant::SVCARD_PICS, Constant::STORE_ID, Constant::SVCARD_PICSIZE)
              sc.update_attribute("img_url", new_url)
            rescue
              flash[:notice] ="图片更新失败！"
            end
          end
          flash[:notice] = "更新成功!"
        end
      elsif type == 0
        discount = params[:edit_discount_value]
        price = params[:edit_discount_price]
        if sc.update_attributes(:name => name,:description => description, :discount => discount, :price => price)
          if !img.nil?
            begin
              new_url = SvCard.upload_img(img, sc.id, Constant::SVCARD_PICS, Constant::STORE_ID, Constant::SVCARD_PICSIZE)
              sc.update_attribute("img_url", new_url)
            rescue
              flash[:notice] ="图片更新失败！"
            end
          end
          flash[:notice] = "更新成功!"
        end
      end
    else 
      flash[:notice] = "更新失败,已有同名的优惠卡!"
    end
    redirect_to request.referer
  end

  def edit_card   #编辑优惠卡
    @card = SvCard.find(params[:c_id].to_i)
    @card_products = @card.svcard_prod_relations
  end

  def sell_situation  #销售情况
    @card_type = params[:card_type] ||= "2"
    @started_time = params[:started_time]
    @ended_time = params[:ended_time]
    started_time_sql =  (@started_time.nil? || @started_time.empty?) ? "1 = 1" : "date_format(c_svc_relations.created_at,'%Y-%m-%d') >= '#{@started_time}'"
    ended_time_sql = (@ended_time.nil? || @ended_time.empty?) ? "1 = 1" : "date_format(c_svc_relations.created_at,'%Y-%m-%d') <= '#{@ended_time}'"
    sv_card_type_sql = @card_type.eql?("2") ? "1 = 1" : "sv_cards.types = #{@card_type}"
    re = CSvcRelation.includes(:sv_card).where(started_time_sql).where(ended_time_sql).where(sv_card_type_sql).order("c_svc_relations.created_at asc")
    re_total_money = CSvcRelation.includes(:sv_card).where(started_time_sql).where(ended_time_sql).where(sv_card_type_sql).sum(:total_price)
    @total_money = re_total_money
    @count = re.length
    @relations = re.paginate(:page => params[:page] ||= 1,:per_page => 10)
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
    order_started_time_sql = (params[:started_time].nil? ||  params[:started_time].empty?) ? "" : " and date_format(o.created_at, '%Y-%m-%d') >= '#{params[:started_time]}'"
    order_ended_time_sql = (params[:ended_time].nil? || params[:ended_time].empty?) ? "" : " and date_format(o.created_at, '%Y-%m-%d') <= '#{params[:ended_time]}'"
    srr_started_sql = (params[:started_time].nil? ||  params[:started_time].empty?) ? " 1 = 1 " : " date_format(created_at, '%Y-%m-%d') >= '#{params[:started_time]}'"
    srr_ended_sql = (params[:ended_time].nil? ||  params[:ended_time].empty?) ? " 1 = 1" : " date_format(created_at, '%Y-%m-%d') <= '#{params[:ended_time]}'"
    #获取时间段内所有使用了储值卡的已完成的订单数量，并且根据门店分组
    @orders = Order.paginate_by_sql(["select o.store_id, count(o.id) id_count, sum(opt.price) t_price, s.name from lantan_db.orders o
      inner join lantan_db.order_pay_types opt on opt.order_id = o.id left join lantan_db.stores s on s.id = o.store_id
      where opt.pay_type = ? #{order_started_time_sql} #{order_ended_time_sql} group by o.store_id",
        OrderPayType::PAY_TYPES[:SV_CARD]], :page => params[:page] ||= 1,:per_page => 10)

    in_money_hash = SvcReturnRecord.where(srr_started_sql).where(srr_ended_sql).
      where("types = #{SvcReturnRecord::TYPES[:IN]}").group("store_id").sum(:price)
    #获取时间段内储值卡返还记录中门店已支出的钱
    out_money_hash = SvcReturnRecord.where(srr_started_sql).where(srr_ended_sql).
      where("types = #{SvcReturnRecord::TYPES[:OUT]}").group("store_id").sum(:price)
    @form_detail = []
    @orders.each do |o|
      #门店id 使用次数 收入金额 支出金额
      in_money =  (in_money_hash and in_money_hash[o.store_id]) ? in_money_hash[o.store_id].to_s : "0"
      out_money =  (out_money_hash and out_money_hash[o.store_id]) ? out_money_hash[o.store_id].to_s : "0"
      @form_detail << [o.name, o.id_count, o.t_price, in_money, out_money]
    end
    #获取所有用户的储值卡
    cs = CSvcRelation.find(:first, :select => "sum(total_price) t_price, sum(left_price) l_price",
      :joins => "inner join sv_cards on sv_cards.id = c_svc_relations.sv_card_id",
      :conditions => ["sv_cards.types = #{SvCard::FAVOR[:value]}"])
    @total_money = cs.t_price #储值卡总计
    @left_money = cs.l_price  #储值卡余额
    @started_time = params[:started_time]
    @ended_time = params[:ended_time]
  end

  def use_collect   #使用情况汇总
    started_sql = (params[:started_time].nil? ||  params[:started_time].empty?) ? "1 = 1" : "date_format(created_at, '%Y-%m-%d') >= '#{params[:started_time]}'"
    ended_sql = (params[:ended_time].nil? ||  params[:ended_time].empty?) ? "1 = 1" : "date_format(created_at, '%Y-%m-%d') <= '#{params[:ended_time]}'"
    s = SvcardUseRecord.where(started_sql).where(ended_sql).where("types = #{SvcardUseRecord::TYPES[:OUT]}")
    ss = s.group_by {|e| e.created_at.beginning_of_month}
    total_money = 0
    form_collect = []
    ss.each do |key, value|
      value.each do |v|
        total_money += v.use_price
      end
      form_collect << key.to_s + "," + total_money.to_s
      total_money = 0
    end
    @form_collect = form_collect.paginate(:page => params[:page] ||= 1,:per_page => 10)
  end
end