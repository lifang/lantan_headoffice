#encoding: utf-8
class Menu < ActiveRecord::Base
 has_many :role_menu_relations, :dependent => :destroy
 has_many :roles, :through => :role_menu_relations
end
