#encoding: utf-8
class Api::MaterialsController < ApplicationController   #库存控制器api
  def search_material
    str = params[:name].strip.length > 0 ? "name like '%#{params[:name]}%' and types=#{params[:types]} " : "types=#{params[:types]}"
    materials = Material.normal.all(:conditions => str)
    render :json => materials
  end
end
