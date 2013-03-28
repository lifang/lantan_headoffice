#encoding: utf-8
desc "filter the right staff for stations"
namespace :daily do
  task(:sync_data => :environment) do
    Sync.output_zip
  end
end