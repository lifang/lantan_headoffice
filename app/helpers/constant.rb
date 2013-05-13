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
      :out_record => ["出库记录", 4],
      :in_record => ["入库记录", 8]
    },
    #服务管理
    :service_manage => {
      :revisit_check => ["回访查询", 1],
      :satisfied => ["满意度", 2]
    },
    #营销管理
    :market_manage => {
      :sell_situation => ["销售情况", 1],
      :use_detail => ["使用情况详细", 2],
      :use_collect => ["使用情况汇总", 4],
      :sale_list => ["活动列表", 8],
      :create_sale => ["发布活动", 16]
    },
    #基础数据
    :base_datas => {
      :news => ["新闻", 1],
      :add_news => ["发布新闻", 2],
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
      :role_role_set => ["角色设定",8192]

    }
  }

  #上传图片的比例
  PIC_SIZE=[50,100,148,300,700]
 
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

  SERVER_PATH = "http://bam.gankao.co/"
  FRONT_PATH = "http://official.gankao.co/"

  #施工现场文件目录
  VIDEO_DIR ="work_videos"

  LOCAL_DIR = "#{Rails.root}/public/"
  LOG_DIR = LOCAL_DIR + "logs/"

  PCARD_PICS = "pcard_pics"
  SALE_PICS = "saleimg"
  SVCARD_PICS = "cardimg"
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

  PICITURE_SIZE =1024  #按kb计算
end
