#encoding: utf-8
module Constant
  #权限
  ROLES = {
    #运营管理
    :operate_manage => {
      :check_store => ["查询门店", 1],
      :new_store => ["新建门店", 2],
      :edit_store => ["编辑门店",4],
      :del_store => ["删除门店", 8]
    },
    #物流管理
    :logistics_manage => {
      :print_list => ["打印库存清单", 1],
      :storage => ["入库", 2],
      :storage_list => ["库存列表", 4],
      :out_record => ["出库记录", 8],
      :in_record => ["入库记录", 16]
    },
    #服务管理
    :service_manage => {
      :revisit_check => ["回访查询", 1],
      :satisfied => ["满意度", 2],
      :complaint => ["投诉情况", 4]
    },
    #营销管理
    :market_manage => {
      :sv_card => ["优惠卡", 1],
      :sell_situation => ["销售情况", 2],
      :use_detail => ["使用情况详细", 4],
      :use_collect => ["使用情况汇总", 8],
      :sale_list => ["活动列表", 16],
      :create_sale => ["发布活动", 32]
    },
    #基础数据
    :base_datas => {
      :cars => ["车型", 1],
      :approval => ["审批", 2],
      :news => ["新闻", 4],
      :authority => ["权限", 8]
    }
  }

  #上传图片的比例
  PIC_SIZE=[50,100,148,300,700]
 
  #角色
  SYS_ADMIN = "1"  #系统管理员
  BOSS = "2" #老板
  MANAGER = "3" #店长
  STAFF = "4" #员工

  #活动code码生成文件路径
  CODE_PATH="#{Rails.root}/public/code_file.txt"
  #总店id
  STORE_ID = 1
  PER_PAGE = 20
  #催货提醒
  URGE_GOODS_CONTENT = "门店订货提醒，请关注下"

  SERVER_PATH = "http://localhost:3000"
  FRONT_PATH = "http://localhost:3001"

  #  施工现场文件目录
  VIDEO_DIR ="work_videos"

  LOCAL_DIR = "#{Rails.root}/public/"
  LOG_DIR = LOCAL_DIR + "logs/"
end
