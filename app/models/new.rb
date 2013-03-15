#encoding: utf-8
class New < ActiveRecord::Base
  STATUS = {:NORMAL => 0, :UNRELEASED => 1, :DELETED => 2} #新闻状态 0正常 1未发布 2已删除
end
