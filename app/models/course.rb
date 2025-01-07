class Course < ApplicationRecord
  include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  after_commit -> { CourseIndexerJob.perform_later(id) }

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

  settings do
    mappings dynamic: false do
      indexes :title, type: :text
      indexes :ispaid_course, type: :boolean
      indexes :ispracticetest_course, type: :boolean
      indexes :imagethumbnail, type: :text
      indexes :imagelarge, type: :text
      indexes :no_of_subscribers, type: :integer
      indexes :rating, type: :float
      indexes :no_of_reviews, type: :integer
      indexes :no_of_published_lectures, type: :integer
      indexes :description, type: :text
      indexes :primary_category, type: :object do
        indexes :id, type: :integer
        indexes :title, type: :text
        indexes :type, type: :text
      end
      indexes :primary_subcategory, type: :object do
        indexes :id, type: :integer
        indexes :title, type: :text
        indexes :type, type: :text
      end
      indexes :author_id, type: :integer
      indexes :is_course_completion, type: :boolean
      indexes :instruction_level, type: :integer
      indexes :published_time, type: :date
      indexes :contentinfo, type: :text
      indexes :created_at, type: :date
      indexes :updated_at, type: :date
    end
  end

  # Serialize the Elasticsearch document
  def as_indexed_json(options = {})
    # puts "Test - ", category_data(primarycategory_id)
    temp_primary_category = category_data(primarycategory_id)
    temp_primary_sub_category = category_data(primarysubcategory_id)
    self.as_json(
      only: %i[title ispaid_course ispracticetest_course imagethumbnail imagelarge no_of_subscribers rating no_of_reviews no_of_published_lectures description author_id is_course_completion instruction_level published_time contentinfo created_at updated_at]
    ).merge(primary_category: temp_primary_category,
            primary_subcategory: temp_primary_sub_category
    )
  end

  # Helper method to fetch primary category data
  def category_data(category_id)
    category = Category.find(category_id)
    category&.as_json(only: %i[id title type]) || {}
  end
  # Define a custom Elasticsearch search method
  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: %w[title description contentinfo]
          }
        }
      }
    )
  end
end