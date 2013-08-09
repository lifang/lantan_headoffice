#encoding: utf-8
module Constant
  #权限
  ROLES = {
    #运营管理
    :operate_manage => {
      :check_store => ["查询门店", 1],
      :new_store => ["新建门店", 2],
      :edit_store => ["编辑门店",4],
      :del_store => ["删除门店", 8],
      :new_chain => ["新建连锁店", 16],
      :del_chain => ["删除连锁店", 32],
      :edit_chain => ["编辑连锁店", 64]
    },
    #物流管理
    :logistics_manage => {
      :print_list => ["打印库存清单", 1],
      :storage => ["入库", 2],
      :check_storage => ["库存核实", 4],
      :storage_beizhu => ["库存备注", 8],
      :out_record => ["出库记录", 16],
      :in_record => ["入库记录", 32],
      :mat_orders => ["门店订货记录", 64],
      :send_goods => ["发货", 128],
      :urge_money => ["催款", 256],
      :mat_order_beizhu => ["门店订货记录备注", 512]
    },
    #服务管理
    :service_manage => {
      :revisit_check => ["回访查询", 1],
      :satisfied => ["满意度", 2]
    },
    #营销管理
    :market_manage => {
      :new_svcard => ["新建优惠卡", 1],
      :edit_svcard => ["编辑优惠卡", 2],
      :del_svcard => ["删除优惠卡", 4],
      :sell_situation => ["销售情况", 8],
      :make_billing => ["开具发票", 16],
      :new_sale => ["新建活动", 32],
      :edit_sale => ["编辑活动", 64],
      :release_sale => ["发布活动", 128],
      :del_sale => ["删除活动", 256],
      :new_good => ["添加产品", 512],
      :del_good => ["删除产品", 1024],
      :edit_good => ["编辑产品", 2048],
      :new_serv => ["添加服务", 4096],
      :del_serv => ["删除服务", 8192],
      :edit_serv => ["编辑服务", 16384]
    },
    #基础数据
    :base_datas => {
      :news => ["新闻", 1],
      :add_news => ["创建新闻", 2],
      :edit_news => ["修改新闻", 4],
      :del_news => ["删除新闻", 8],
      :add_brand => ["添加汽车品牌", 16],
      :del_brand => ["删除汽车品牌", 32],
      :roles => ["权限",64],
      :role_conf => ["权限配置",128],
      :role_set => ["用户设定",512],
      :add_role => ["添加角色",1024],
      :edit_role => ["编辑角色",2048],
      :del_role => ["删除角色",4096],
      :role_role_set => ["角色设定",8192],
      :release_news => ["发布新闻", 16384]
    }
  }

 
  #角色
  SYS_ADMIN = "1"  #系统管理员
  BOSS = "2" #老板
  STORE_MANAGER = "3" #仓库管理员
  STAFF = "4" #客服

  #活动code码生成文件路径
  CODE_PATH="#{Rails.root}/public/code_file.txt"
  #总店id
  STORE_ID = 1
  PER_PAGE = 10
  #催货提醒
  URGE_GOODS_CONTENT = "门店订货提醒，请关注下"

  SERVER_PATH = "http://116.255.135.175:3004"
  #STORE_IMAGE_PATH = "http://192.168.2.27:3001/"    存放门店图片的路径
  FRONT_PATH = "http://116.255.135.175:3006"     #门店前台地址

  #施工现场文件目录
  VIDEO_DIR ="work_videos" 
  LOCAL_DIR = "#{Rails.root}/public/"
  LOG_DIR = LOCAL_DIR + "logs/"

  PCARD_PICS = "pcard_pics"
  SALE_PICS = "saleimg"
  SVCARD_PICS = "cardimg"
  STORE_PICS = "storeimg"
  #产品和活动的类别  图片名称分别为 product_pics 和service_pics
  PRODUCT = "PRODUCT"
  SERVICE = "SERVICE"
  SALE = "SALE"
  SV_CARD = "SV_CARD"

  #上传图片的比例
  #上传图片的比例
  SALE_PICSIZE =[300,230,663,50]
  P_PICSIZE = [50,154,246,300,356]
  C_PICSIZE = [148,154]
  SVCARD_PICSIZE = [148,154,50]
  STAFF_PICSIZE = [100]
  STORE_PICSIZE = [1000,50]
  PICITURE_SIZE =1024  #按kb计算
end
