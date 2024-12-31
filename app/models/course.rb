class Course < ApplicationRecord
  belongs_to :categories, class_name: 'Category', foreign_key: :primarycategory_id
  belongs_to :categories, class_name: 'Category', foreign_key: :primarysubcategory_id
  belongs_to :users, class_name: 'User', foreign_key: :author_id
  belongs_to :users, class_name: 'User', foreign_key: :createdby_id
  belongs_to :users, class_name: 'User', foreign_key: :updatedby_id

  enum instruction_level: { simple: 0, medium: 1, advance: 2 }

  validates :title, presence: true
end
