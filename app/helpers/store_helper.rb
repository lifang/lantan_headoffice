module StoreHelper
  def store_name(id)
    name = Store.find(id).name
    name
  end
end
