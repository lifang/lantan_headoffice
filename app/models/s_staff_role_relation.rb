#encoding: utf-8
class SStaffRoleRelation < ActiveRecord::Base
  set_table_name :"lantan_db.staff_role_relations"
  set_primary_key "id"
  belongs_to :s_staff
  belongs_to :s_role
end