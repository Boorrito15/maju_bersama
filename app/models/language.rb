class Language < ApplicationRecord
  has_many :candidate_languages, dependent: :destroy
  has_many :candidates, through: :candidate_languages

  validates :name, presence: true, uniqueness: true
end
