module CSvcRelationHelper
  def current_relation_customer(id)
    Customer.find(id)
  end
  def current_relation_card(id)
    SvCard.find(id)
  end
end
