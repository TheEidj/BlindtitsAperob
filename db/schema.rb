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

ActiveRecord::Schema[8.0].define(version: 2025_10_19_161716) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "game_session_playlists", force: :cascade do |t|
    t.bigint "game_session_id", null: false
    t.bigint "playlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_session_id"], name: "index_game_session_playlists_on_game_session_id"
    t.index ["playlist_id"], name: "index_game_session_playlists_on_playlist_id"
  end

  create_table "game_session_teams", force: :cascade do |t|
    t.bigint "game_session_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_session_id"], name: "index_game_session_teams_on_game_session_id"
    t.index ["team_id"], name: "index_game_session_teams_on_team_id"
  end

  create_table "game_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "name"
    t.integer "nbTrack"
    t.boolean "played"
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "deezer_id"
    t.boolean "collaborative"
    t.bigint "creator"
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "game_session_id", null: false
    t.bigint "team_id", null: false
    t.bigint "track_id", null: false
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_session_id"], name: "index_scores_on_game_session_id"
    t.index ["team_id"], name: "index_scores_on_team_id"
    t.index ["track_id"], name: "index_scores_on_track_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.bigint "playlist_id"
    t.text "name"
    t.text "artist"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_tracks_on_playlist_id"
  end

  create_table "user_playlists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "playlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_user_playlists_on_playlist_id"
    t.index ["user_id"], name: "index_user_playlists_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "deezer_id"
  end

  add_foreign_key "game_session_playlists", "game_sessions"
  add_foreign_key "game_session_playlists", "playlists"
  add_foreign_key "game_session_teams", "game_sessions"
  add_foreign_key "game_session_teams", "teams"
  add_foreign_key "scores", "game_sessions"
  add_foreign_key "scores", "teams"
  add_foreign_key "scores", "tracks"
  add_foreign_key "tracks", "playlists"
  add_foreign_key "user_playlists", "playlists"
  add_foreign_key "user_playlists", "users"
end
