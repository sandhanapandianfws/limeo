class Exam < ApplicationRecord
  validates :title, :subject, :total_marks, :start_time, :duration, presence: true

  # Callback to calculate end_time based on duration
  before_save :calculate_end_time

  private

  def calculate_end_time
    self.end_time = start_time + duration.minutes if start_time && duration
  end
end
