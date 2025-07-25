class Resume < ApplicationRecord
  belongs_to :user
  has_many :educations, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_one_attached :uploaded_file

  accepts_nested_attributes_for :educations, allow_destroy: true
  accepts_nested_attributes_for :experiences, allow_destroy: true
  accepts_nested_attributes_for :skills, allow_destroy: true
end
