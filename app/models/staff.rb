#encoding: utf-8
class Staff < ActiveRecord::Base
  has_many :staff_role_relations, :dependent=>:destroy
  has_many :roles, :through => :staff_role_relations, :foreign_key => "role_id"
  has_many :salary_details
  has_many :work_records
  has_many :salaries
  has_many :station_staff_relations
  has_many :train_staff_relations
  has_many :violation_rwards
  has_many :staff_gr_records
  has_many :month_scores
  has_many :mat_in_orders
  belongs_to :store
  #门店员工职务
  S_COMPANY = {:BOSS=>0,:CHIC=>2,:FRONT=>3,:TECHNICIAN=>1} #0 老板 2 店长 3接待 1 技师
  N_COMPANY = {0=>"老板",2=>"店长",3=>"接待",1=>"技师"}
  #总部员工职务

  STATUS = {:normal => 0, :delete => 1}   #0正常 1已删除

  scope :normal, where(:status => STATUS[:normal])

  S_HEAD = {:BOSS=>0,:MANAGER=>2,:NORMAL=>1} #0老板 2 部门经理 1员工
  N_HEAD = {0=>"老板", 2=>"部门经理",1=>"员工"}

  attr_accessor :password
  validates:password, :allow_nil => true, :length=>{:within=>6..20} #:confirmation=>true


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
