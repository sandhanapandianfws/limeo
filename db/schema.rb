# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_01_07_214823) do

  create_table "articles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "icon"
    t.integer "type"
    t.integer "parent_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "commenter"
    t.text "body"
    t.bigint "article_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_comments_on_article_id"
  end

  create_table "course_subscriptions", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id", "user_id"], name: "index_course_subscriptions_on_course_id_and_user_id", unique: true
    t.index ["course_id"], name: "index_course_subscriptions_on_course_id"
    t.index ["user_id"], name: "index_course_subscriptions_on_user_id"
  end

  create_table "courses", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.boolean "ispaid_course"
    t.boolean "ispracticetest_course"
    t.string "imagethumbnail"
    t.string "imagelarge"
    t.integer "no_of_subscribers"
    t.decimal "rating", precision: 10
    t.integer "no_of_reviews"
    t.integer "no_of_published_lectures"
    t.binary "description"
    t.bigint "primarycategory_id"
    t.bigint "primarysubcategory_id"
    t.bigint "author_id"
    t.boolean "is_course_completion"
    t.bigint "createdby_id"
    t.bigint "updatedby_id"
    t.integer "instruction_level"
    t.date "published_time"
    t.string "contentinfo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_courses_on_author_id"
    t.index ["createdby_id"], name: "index_courses_on_createdby_id"
    t.index ["primarycategory_id"], name: "index_courses_on_primarycategory_id"
    t.index ["primarysubcategory_id"], name: "index_courses_on_primarysubcategory_id"
    t.index ["updatedby_id"], name: "index_courses_on_updatedby_id"
  end

  create_table "exams", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "subject"
    t.integer "total_marks"
    t.datetime "start_time"
    t.integer "duration"
    t.datetime "end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lectures", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.integer "content_type"
    t.string "content_url"
    t.bigint "section_id", null: false
    t.integer "createdby_id"
    t.integer "updatedby_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["section_id"], name: "index_lectures_on_section_id"
  end

  create_table "sections", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.bigint "course_id", null: false
    t.integer "section_order"
    t.string "description"
    t.bigint "createdby_id"
    t.bigint "updatedby_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_sections_on_course_id"
    t.index ["createdby_id"], name: "fk_rails_6ac983f094"
    t.index ["updatedby_id"], name: "fk_rails_6c87b506dd"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email"
    t.string "full_name"
    t.string "email_verification_code"
    t.boolean "email_verified"
    t.datetime "expiry_date"
    t.boolean "email_link_used"
    t.date "created_date"
    t.string "created_by"
    t.date "updated_on"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.integer "usertype"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "comments", "articles"
  add_foreign_key "course_subscriptions", "courses"
  add_foreign_key "course_subscriptions", "users"
  add_foreign_key "courses", "categories", column: "primarycategory_id"
  add_foreign_key "courses", "categories", column: "primarysubcategory_id"
  add_foreign_key "courses", "users", column: "author_id"
  add_foreign_key "courses", "users", column: "createdby_id"
  add_foreign_key "courses", "users", column: "updatedby_id"
  add_foreign_key "lectures", "sections"
  add_foreign_key "sections", "courses"
  add_foreign_key "sections", "users", column: "createdby_id"
  add_foreign_key "sections", "users", column: "updatedby_id"
end
