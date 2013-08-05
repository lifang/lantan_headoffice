#encoding: utf-8
class NewsController < ApplicationController  #新闻控制器
  layout "base_datas"
  before_filter :sign?
  
  def index   #新闻列表
    @news = New.where("status >= ? and status <= ? ", New::STATUS[:NORMAL], New::STATUS[:UNRELEASED]).order("created_at desc")
    .paginate(:page => params[:page] ||= 1,:per_page => 10)
  end
  
  def destroy #删除新闻
    new = New.find(params[:id].to_i)
    page = params[:page].nil? ? 1 : params[:page].to_i
    if !new.nil?
      if new.update_attribute("status", New::STATUS[:DELETED])
       flash[:notice] = "删除成功!";
     else
       flash[:notice] = "删除失败!";
      end
    else
       flash[:notice] = "操作失败!";
    end
    redirect_to "/news?page=#{page}"
  end

  def release #发布新闻
    new = New.find(params[:id].to_i)
    page = params[:page].nil? ? 1 : params[:page].to_i
    if !new.nil?
       if new.update_attribute("status", New::STATUS[:NORMAL])
        flash[:notice] = "发布成功!";
       else
       flash[:notice] = "发布失败!";
       end
    else
      flash[:notice] = "发布失败!";
    end
    redirect_to "/news?page=#{page}"
  end

  def edit  #编辑
   @new = New.find_by_id(params[:id].to_i)
   @page = params[:page].to_i
  end

  def update  #更新新闻
    id = params[:edit_new_id].to_i
    title = params[:edit_new_title]
    content = params[:edit_new_content]
    page = params[:edit_new_page].nil? ? 1 : params[:edit_new_page].to_i
    new = New.find(id)
    if !new.nil?
      if new.update_attributes(:title => title, :content => content)
        flash[:notice] = "修改成功!"
      else
        flash[:notice] = "修改失败!"
      end
    else
      flash[:notice] = "修改失败!"
    end
    redirect_to "/news?page=#{page}"
  end

  def create
    title = params[:create_new_title]
    content = params[:create_new_content]
    if New.create(:title => title, :content => content, :status => New::STATUS[:UNRELEASED])
      flash[:notice] = "创建成功!"
    else
      flash[:notice] = "创建失败!"
    end
      redirect_to "/news"
  end

end
