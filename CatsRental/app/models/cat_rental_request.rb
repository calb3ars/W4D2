# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING")
#  created_at :datetime
#  updated_at :datetime
#

class CatRentalRequest < ActiveRecord::Base
  STATUS = %w(PENDING APPROVED DENIED)
  belongs_to :cat

  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: STATUS,
    message: "%{value} is not a valid status" }
  validate :overlapping_approved_requests

  #private
  def overlapping_requests
    CatRentalRequest.where.not(id: self.id).where(cat_id: self.cat_id).where(<<-SQL, self.end_date, self.start_date)
      NOT(start_date > ?) AND NOT(? > end_date)
    SQL
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def approve!
    overlapping_requests.each do |request|
      request.denied!
    end
      self.status = "APPROVED"
      self.save
  end

  def denied!
    self.status = "DENIED"
    self.save
  end
end
