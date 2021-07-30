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

ActiveRecord::Schema.define(version: 2021_07_30_145138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.integer "author_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "parent_comment_id"
    t.string "slug"
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["parent_comment_id"], name: "index_comments_on_parent_comment_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["slug"], name: "index_comments_on_slug", unique: true
  end

  create_table "post_subs", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "sub_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id", "sub_id"], name: "index_post_subs_on_post_id_and_sub_id", unique: true
    t.index ["post_id"], name: "index_post_subs_on_post_id"
    t.index ["sub_id"], name: "index_post_subs_on_sub_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "url"
    t.text "content"
    t.integer "author_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["title"], name: "index_posts_on_title", unique: true
  end

  create_table "subs", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.integer "moderator_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["moderator_id"], name: "index_subs_on_moderator_id"
    t.index ["slug"], name: "index_subs_on_slug", unique: true
    t.index ["title"], name: "index_subs_on_title", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.string "session_token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.integer "value", null: false
    t.string "votable_type"
    t.bigint "votable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.index ["user_id", "votable_type", "votable_id"], name: "index_votes_on_user_id_and_votable_type_and_votable_id", unique: true
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
  end

end
