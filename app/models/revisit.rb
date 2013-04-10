#encoding: utf-8
class Revisit < ActiveRecord::Base
  set_table_name :"lantan_db_all.revisits"
  set_primary_key "id"
  belongs_to :customer
  has_many :revisit_order_relations
  belongs_to :complaint

  TYPES = {:SHOPPING => 0, :COMPLAINT => 1, :OTHER => 2} #回访类别
  TYPES_NAME = {0 => "消费回访", 1 => "投诉回访", 2 => "其他"}

end
