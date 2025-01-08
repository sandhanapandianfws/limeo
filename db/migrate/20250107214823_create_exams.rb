class CreateExams < ActiveRecord::Migration[6.1]
  def change
    create_table :exams do |t|
      t.string :title
      t.string :subject
      t.integer :total_marks
      t.datetime :start_time
      t.integer :duration
      t.datetime :end_time

      t.timestamps
    end
  end
end
