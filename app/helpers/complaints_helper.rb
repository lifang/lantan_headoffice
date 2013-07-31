module ComplaintsHelper
  def find_staff (staff_id)
    s = SStaff.find_by_id(staff_id)
  end
end
