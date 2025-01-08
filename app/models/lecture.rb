class Lecture < ApplicationRecord
  belongs_to :section

  # Enum for content type
  enum content_type: { video: 0, pdf: 1, html: 2 }

  # Validations
  validates :title, presence: true
  validates :content_type, presence: true
  validates :content_url, presence: true

  # Audit associations
  belongs_to :created_by, class_name: 'User', foreign_key: :createdby_id, optional: true
  belongs_to :updated_by, class_name: 'User', foreign_key: :updatedby_id, optional: true
end
