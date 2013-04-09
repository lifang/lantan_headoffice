#encoding: utf-8
class SProdMatRelation < ActiveRecord::Base
  belongs_to :s_material, :foreign_key => :material_id
  belongs_to :s_product
end
