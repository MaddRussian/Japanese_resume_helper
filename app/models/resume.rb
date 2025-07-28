class Resume < ApplicationRecord
  belongs_to :user
  has_many :educations, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :certifications, dependent: :destroy
  has_one_attached :photo
  has_one_attached :rirekisho_pdf
  has_one_attached :shokumu_keirekisho_pdf

  accepts_nested_attributes_for :educations, allow_destroy: true
  accepts_nested_attributes_for :experiences, allow_destroy: true
  accepts_nested_attributes_for :skills, allow_destroy: true
  accepts_nested_attributes_for :certifications, allow_destroy: true

  validates :title, presence: true
  validates :summary, presence: true
  validate :acceptable_photo

  private

  def acceptable_photo
    return unless photo.attached?

    unless photo.blob.byte_size <= 5.megabyte
      errors.add(:photo, 'is too large (max 5MB)')
    end

    acceptable_types = ['image/jpeg', 'image/png', 'image/jpg']
    unless acceptable_types.include?(photo.content_type)
      errors.add(:photo, 'must be a JPEG or PNG')
    end
  end
end
