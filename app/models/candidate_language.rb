class CandidateLanguage < ApplicationRecord
  belongs_to :candidate
  belongs_to :language

  validates :candidate_id, uniqueness: { scope: :language_id }
end
