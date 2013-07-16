#encoding: utf-8
class SStaff < ActiveRecord::Base
   set_table_name :"lantan_db.staffs"
   set_primary_key "id"
   has_many :s_staff_role_relations
  attr_accessor :password

  STATUS = {:normal => 0, :afl => 1, :vacation => 2, :resigned => 3, :deleted => 4}
  VALID_STATUS = [STATUS[:normal], STATUS[:afl], STATUS[:vacation]]
  STATUS_NAME = {0 => "在职", 1 => "请假", 2 => "休假", 3 => "离职", 4 => "删除"}

  STAFF_MENUS_AND_ROLES = {           #创建门店时创建的管理员将获取前台的所有权限
    :customers => 32767,
    :materials => 2147483647,
    :staffs => 65535,
    :datas => 524287,
    :stations => 3,
    :sales => 4194303,
    :base_datas => 16383
  }
  def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end

  def encrypt_password
    self.encrypted_password=encrypt(password)
  end
  
  private
  def encrypt(string)
    self.salt = make_salt if new_record?  #确定salt的值
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.new.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end