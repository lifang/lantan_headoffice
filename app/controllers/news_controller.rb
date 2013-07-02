#encoding: utf-8
class NewsController < ApplicationController  #新闻控制器
  layout "base_datas"
  before_filter :sign?
  
  def index   #新闻列表
    @news = New.where("status >= ? and status <= ? ", New::STATUS[:NORMAL], New::STATUS[:UNRELEASED]).order("created_at desc")
    .paginate(:page => params[:page] ||= 1,:per_page => 10)
  end
  
  def destroy #删除新闻
    new = New.find(params[:n_id].to_i)
    if !new.nil?
      if new.update_attribute("status", New::STATUS[:DELETED])
        render :text => 1
     else
       render :text => 0
      end
    else
      render :text => 0
    end
  end

  def release #发布新闻
    new = New.find(params[:n_id].to_i)
    if !new.nil?
       if new.update_attribute("status", New::STATUS[:NORMAL])
        render :text => 1
       else
       render :text => 0
       end
    else
      render :text => 0
    end
  end

  def detail  #查看更新新闻细节
    @new = New.find(params[:n_id].to_i)
  end

  def update_new  #更新新闻
    id = params[:edit_new_id].to_i
    title = params[:edit_new_title]
    content = params[:edit_new_content]
    new = New.find(id)
    if !new.nil?
      if new.update_attributes(:title => title, :content => content)
        flash[:notice] = "更新成功!"
        redirect_to request.referer
      end
    end
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
