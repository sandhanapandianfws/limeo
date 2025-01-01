class CreateLectures < ActiveRecord::Migration[6.1]
  def change
    create_table :lectures do |t|
      t.string :title
      t.integer :content_type
      t.string :content_url
      t.references :section, null: false, foreign_key: true
      t.integer :createdby_id
      t.integer :updatedby_id

      t.timestamps
    end
  end
end
