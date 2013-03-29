module CSvcRelationHelper
  def current_relation_customer(id)
    Customer.find_by_id(id)
  end
  def current_relation_card(id)
    SvCard.find(id)
  end
end
