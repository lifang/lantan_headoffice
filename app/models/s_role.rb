#encoding: utf-8
class SRole < ActiveRecord::Base
  set_table_name :"lantan_db.roles"
  set_primary_key "id"
  has_many :s_staff_role_relations

ADMIN = "门店管理员"        #门店管理员的角色名
ROLE_TYPE = {
    :NORMAL => 1,   #门店员工,
    :STORE_MANAGER => 0 #门店管理员
  }
end





