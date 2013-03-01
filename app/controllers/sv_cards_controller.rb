#encoding: utf-8
class SvCardsController < ApplicationController   #优惠卡控制器
  layout "market_manages"
  def index
    @sv_cards = SvCard.all.paginate(:page => params[:page] ||= 1,:per_page => 6,:order => "created_at asc")
  end

end