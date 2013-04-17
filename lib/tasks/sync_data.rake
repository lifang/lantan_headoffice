#encoding: utf-8
desc "filter the right staff for stations"
namespace :daily do
  task(:sync_data => :environment) do
    Sync.output_zip
  end

  #定时生成总部新增加的产品，活动，车型成一个zip文件
  task(:sync_generate_zip => :environment) do
    Sync.out_data(Time.now)
  end

  task(:sync_right_zip => :environment) do
    syncs = SSync.where("sync_at = null and (sync_status = #{Sync::SYNC_STAT[:ERROR]} or sync_status = null)")
    syncs.each do |sync|
      day = (Time.now - sync.created_at).strftime("%d")
      Sync.out_data(day)
    end
  end
end

namespace :monthly do
  task(:image_chart => :environment) do
    ChartImage.gchart 
  end
end