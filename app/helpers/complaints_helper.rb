module ComplaintsHelper
  def find_staff (staff_id)
    s = Staff.find(staff_id) 
    name = s.name
    name
  end
end
