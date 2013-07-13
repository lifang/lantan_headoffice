class SStaff < ActiveRecord::Base
   set_table_name :"lantan_db.staffs"
   set_primary_key "id"
   has_many :s_staff_role_relations
  attr_accessor :password
  
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