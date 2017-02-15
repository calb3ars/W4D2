# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :string           not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Cat < ActiveRecord::Base
  COLORS = %w(black tabby calico orange white grey hairless spotted brown)
  has_many :cat_rental_requests, dependent: :destroy

  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: { in: COLORS,
    message: "%{value} is not a valid color" }
  validates :sex, inclusion: { in: %w(M F),
    message: "%{value} is not a valid sex"}

  def age
    #approximate age
    (Time.now.year - birth_date.year)
  end
end
