# == Schema Information
#
# Table name: boards
#
#    t.bigint "user_id", null: false
#    t.string "title", null: false
#    t.text "body"
#    t.date "deadline"
#    t.integer "period_type", default: 0, null: false
#    t.boolean "is_important", default: false, null: false
#    t.boolean "is_submission", default: false, null: false
#    t.boolean "is_document", default: false, null: false
#    t.datetime "created_at", null: false
#    t.datetime "updated_at", null: false
#    t.index ["user_id"], name: "index_notifications_on_user_id"

FactoryBot.define do
  factory :notification do
    association :user
    title { "テスト通知タイトル" }
    body { "テスト通知の本文です" }
    deadline { Date.current + 7.days }
    period_type { :unspecified }
    is_important { false }
    is_submission { false }
    is_document { false }

    trait :important do
      is_important { true }
    end

    trait :submission do
      is_submission { true }
    end

    trait :document do
      is_document { true }
    end

    trait :yearly do
      period_type { :yearly }
    end

    trait :monthly do
      period_type { :monthly }
    end

    trait :with_file do
      file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_image.png')) }
    end
  end
end
