class CreateSections < ActiveRecord::Migration[6.1]
  def change
    create_table :sections do |t|
      t.string :title
      t.references :course, null: false, foreign_key: true
      t.integer :section_order
      t.string :description
      t.bigint :createdby_id
      t.bigint :updatedby_id

      t.timestamps
    end


    # Add foreign key constraints for createdby and updatedby
    add_foreign_key :sections, :users, column: :createdby_id
    add_foreign_key :sections, :users, column: :updatedby_id
  end
end
