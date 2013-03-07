#encoding: utf-8
class SvCardsController < ApplicationController   #优惠卡控制器
  layout "market_manages"
  def index #优惠卡主页
    @sv_cards = SvCard.all.paginate(:page => params[:page] ||= 1,:per_page => 6,:order => "created_at asc")
  end

  def select_discount_card #新建时选择打折卡
    @product_types = Product::PRODUCT_TYPES
    @products = Product.all
  end
  def select_storeage_card #新建时选择储值卡
    
  end
  def search_products_all #选择项目时的全部
    @products = Product.all
  end
  def search_products_part #选择项目时的部分
    product_type = "types = #{params[:product_type].to_i}"
    product_name = (params[:product_name].nil? || params[:product_name] == "") ? "1=1" : "name like '%#{params[:product_name]}%'"
    @products = Product.where(product_type).where(product_name)
  end
  def sell_situation  #优惠卡销售情况
    
  end
  def create
    sv_card = SvCard.new
    card_type = params[:card_type]
    card_name = params[:card_name]
    card_description = params[:card_description]
    img = params[:card_url]
    if card_type == 1
      started_money = params[:started_money]
      ended_money = params[:ended_money]
      total_money = started_money + ended_money
      sv_card.update_attributes(:name => card_name, :types => card_type, :price => total_money)
      if sv_card.save
        img_name = "#{Time.now}#{card_name}.#{img.original_filename.split('.').reverse[0]}"
        FileUtils.mkdir_p "public/cardimg/#{card_name}"
        File.new(Rails.root.join("public", "cardimg", "#{card_name}", img_name), "a+")
        File.open(Rails.root.join("public", "cardimg", "#{card_name}", ima_name), "wb") do |file|
          file.write(img.read)
        end
        sv_card.img_url = "public/cardimg/#{card_name}/#{img_name}"
      end
    elsif card_type == 0
      
    end
  end
end