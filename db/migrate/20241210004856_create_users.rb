class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :full_name
      t.string :password
      t.string :email_verification_code
      t.boolean :email_verified
      t.date :expiry_date
      t.boolean :email_link_used
      t.date :created_date
      t.string :created_by
      t.date :updated_on
      t.string :updated_by

      t.timestamps
    end
  end
end
