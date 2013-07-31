class SChartImage < ActiveRecord::Base
   set_table_name :"lantan_db.chart_images"
   set_primary_key "id"

   TYPES = {:SATIFY =>0,:COMPLAINT =>1,:MECHINE_LEVEL =>2,:FRONT_LEVEL =>3,:STAFF_LEVEL =>4}
    # 0 满意度 1 投诉统计 2 技师平均水平 3 前台平均水平 4 员工绩效
end