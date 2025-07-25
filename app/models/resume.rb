class Resume < ApplicationRecord
  belongs_to :user
  has_one_attached :uploaded_file
end
