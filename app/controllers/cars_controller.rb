#encoding: utf-8
require "toPinyin"
class CarsController < ApplicationController   #车型控制器
  layout "base_datas"
  def index
    @capitals = Capital.all
    brands = CarBrand.all
    @car_brands = brands.group_by { |c| c.capital_id } if brands
  end

  def new_brand #添加汽车品牌
    brand_name = params[:brand_name]
    capital_name =  brand_name.pinyin[0][0].upcase
    cb = CarBrand.where("name = '#{params[:brand_name]}'")
    if cb.blank?
      capital = Capital.find_or_create_by_name(capital_name)
      CarBrand.create(:name => params[:brand_name], :capital_id => capital.id)
      flash[:notice] = "创建成功!"
    else
      flash[:notice] = "创建失败或该品牌已存在!"
    end
    redirect_to cars_path
  end

  def del_brand #删除汽车品牌
    brand = CarBrand.find(params[:id].to_i);
    if brand.destroy
      render :text => 1
    else
      render :text => 0
    end
  end

  def check_model #查看所有型号
    @car_brand = CarBrand.find(params[:id].to_i)   
    @car_models = CarModel.where("car_brand_id = #{params[:id].to_i}")
  end

  def update_model #修改型号名字
    model = CarModel.find(params[:id].to_i)
    if CarModel.where("car_brand_id = #{params[:id].to_i} and name = '#{params[:name]}'").blank?
      if model.update_attribute("name", params[:name])
      render :text => 1
      end
    else
      render :text => 0
    end
  end

  def del_model #删除型号
    model = CarModel.find(params[:mid].to_i)
    if model.destroy
      render :text => 1
    else
      render :text => 0
    end
  end
  
  def new_model #添加型号
    name = params[:model_name]
    id = params[:brand_id].to_i
    if !CarModel.where("name = '#{name}'").blank?
      render :text => 0
    else
      CarModel.create(:name => name, :car_brand_id => id)
      render :text => 1
    end
  end
  
end