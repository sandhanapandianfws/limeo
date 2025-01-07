class CourseIndexerJob < ApplicationJob
  queue_as :default

  def perform(course_id)
    course = Course.find(course_id)
    course.__elasticsearch__.index_document
  end
end
