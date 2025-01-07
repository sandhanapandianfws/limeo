class Category < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  self.inheritance_column = nil # Disables STI behavior for this model

  enum type: { category: 0, subcategory: 1 }

  # Self-referential association
  belongs_to :parent_category, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_category_id', dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :type, presence: true

  settings do
    mappings dynamic: false do
      indexes :title, type: :text
      indexes :type, type: :text
      indexes :created_at, type: :date
    end
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: %w[title type]
          }
        }
      }
    )
  end
end
