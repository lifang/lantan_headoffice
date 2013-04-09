#encoding: utf-8
class SProdMatRelation < ActiveRecord::Base
  set_table_name :"lantan_db_all.prod_mat_relations"
  set_primary_key "id"
  belongs_to :s_material, :foreign_key => :material_id
  belongs_to :s_product
end
