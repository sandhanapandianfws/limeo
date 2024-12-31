class Category < ApplicationRecord
  self.inheritance_column = nil # Disables STI behavior for this model

  enum type: { category: 0, subcategory: 1 }

  # Self-referential association
  belongs_to :parent_category, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_category_id', dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :type, presence: true
end
