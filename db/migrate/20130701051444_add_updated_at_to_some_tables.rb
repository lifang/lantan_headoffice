class AddUpdatedAtToSomeTables < ActiveRecord::Migration
  def change
    add_column :capitals, :updated_at, :datetime
    add_column :car_brands, :updated_at, :datetime
    add_column :car_models, :updated_at, :datetime
    
    add_index :capitals, :updated_at
    add_index :car_brands, :updated_at
    add_index :car_models, :updated_at
    
  end
end
