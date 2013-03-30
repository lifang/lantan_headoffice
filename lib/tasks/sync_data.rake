#encoding: utf-8
desc "filter the right staff for stations"
namespace :daily do
  task(:sync_data => :environment) do
    Store.all.each {|store| Sync.output_zip(store.id)}
  end
end