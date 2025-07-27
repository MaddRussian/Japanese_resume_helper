class Certification < ApplicationRecord
  belongs_to :resume

  validates :name, presence: true
  validates :completion_date, presence: true
end
