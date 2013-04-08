#encoding: utf-8
class Api::MaterialsController < ApplicationController   #库存控制器api
  def search_material
    if params[:code]
     materials = Material.normal.find_by_code(params[:code])
    else
      str = params[:name].strip.length > 0 ? "name like '%#{params[:name]}%' and types=#{params[:types]} " : "types=#{params[:types]}"
      materials = Material.normal.all(:conditions => str)
    end
    render :json => materials
  end
end
