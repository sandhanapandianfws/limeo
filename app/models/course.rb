class Course < ApplicationRecord
  belongs_to :primary_category, class_name: 'Category', foreign_key: :primarycategory_id
  belongs_to :primary_subcategory, class_name: 'Category', foreign_key: :primarysubcategory_id
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  belongs_to :created_by, class_name: 'User', foreign_key: :createdby_id
  belongs_to :updated_by, class_name: 'User', foreign_key: :updatedby_id
  has_many :sections, dependent: :destroy

  has_many :course_subscriptions, dependent: :destroy
  has_many :users, through: :course_subscriptions

  enum instruction_level: { simple: 0, medium: 1, advance: 2 }

  validates :title, presence: true
end
