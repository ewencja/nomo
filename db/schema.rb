ActiveRecord::Schema.define(version: 20161206141838) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "names", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "gender"
    t.string   "soundex"
    t.string   "metaphone"
    t.string   "double_metaphone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "origins", force: :cascade do |t|
    t.string   "origin",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "names_origins", id: false do |t|
    t.belongs_to "name", index: true
    t.belongs_to "origin", index: true
  end

end
