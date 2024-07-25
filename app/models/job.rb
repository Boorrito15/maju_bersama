class Job < ApplicationRecord
  belongs_to :employer
  has_many :job_applications, dependent: :destroy

  validates :title, :description, :location, :requirements, presence: true

  # Other validations and methods
end
