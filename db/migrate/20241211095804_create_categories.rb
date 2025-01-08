class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :title
      t.string :icon
      t.integer :type
      t.integer :parent_category_id

      t.timestamps
    end
  end
end
