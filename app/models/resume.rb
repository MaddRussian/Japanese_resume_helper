class Resume < ApplicationRecord
  belongs_to :user
  has_many :educations, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_one_attached :uploaded_file
end
