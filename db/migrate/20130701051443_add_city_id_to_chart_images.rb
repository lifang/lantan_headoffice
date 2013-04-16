class AddCityIdToChartImages < ActiveRecord::Migration
  def change
    rename_column :chart_images, :store_id,:city_id
  end
end
