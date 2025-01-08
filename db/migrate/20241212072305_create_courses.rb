class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.boolean :ispaid_course
      t.boolean :ispracticetest_course
      t.string :imagethumbnail
      t.string :imagelarge
      t.integer :no_of_subscribers
      t.decimal :rating
      t.integer :no_of_reviews
      t.integer :no_of_published_lectures
      t.blob :description
      t.references :primarycategory, foreign_key: { to_table: :categories }
      t.references :primarysubcategory, foreign_key: { to_table: :categories }
      t.references :author, foreign_key: { to_table: :users }
      t.boolean :is_course_completion
      t.references :createdby, foreign_key: { to_table: :users }
      t.references :updatedby, foreign_key: { to_table: :users }
      t.integer :instruction_level
      t.date :published_time
      t.string :contentinfo

      t.timestamps
    end


  end
end
