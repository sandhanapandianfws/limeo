class CreateCourseSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :course_subscriptions do |t|
      t.references :course, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :course_subscriptions, [:course_id, :user_id], unique: true
  end
end
