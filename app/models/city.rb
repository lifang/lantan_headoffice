class City < ActiveRecord::Base
  has_many :stores
  IS_PROVINCE = 0;  #是否为省份
end
