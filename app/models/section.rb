class Section < ApplicationRecord
  belongs_to :course

  belongs_to :createdby, class_name: 'User', foreign_key: :createdby_id
  belongs_to :updatedby, class_name: 'User', foreign_key: :updatedby_id

  has_many :lectures, dependent: :destroy


  validates :title, presence: true
  validates :section_order, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
