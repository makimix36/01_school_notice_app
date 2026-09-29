# == Schema Information
#
#  table "notifications"
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


require 'rails_helper'

RSpec.describe Notification, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      notification = build(:notification)
      expect(notification).to be_valid
    end
  end

  context 'タイトルが255文字以下の場合' do
    it '有効であること' do
      notification = build(:notification, title: 'a' * 255)
      expect(notification).to be_valid
    end
  end

  context 'タイトルが256文字以上の場合' do
    it '無効であること' do
      notification = build(:notification, title: 'a' * 256)
      expect(notification).to be_invalid
      expect(notification.errors[:title]).to include('は255文字以内で入力してください')
    end
  end

  context '本文が65535文字以内の場合' do
    it '有効であること' do
      notification = build(:notification, body: 'a' * 65535)
      expect(notification).to be_valid
    end
  end

  context '本文が65536文字以上の場合' do
    it '無効であること' do
      notification = build(:notification, body: 'a' * 65536)
      expect(notification).to be_invalid
      expect(notification.errors[:body]).to include('は65535文字以内で入力してください')
    end
  end

  context 'period_type が unspecified の場合' do
    it '有効であること' do
      notification = build(:notification, period_type: :unspecified)
      expect(notification).to be_valid
    end
  end

  context 'period_type が yearly の場合' do
    it '有効であること' do
      notification = build(:notification, :yearly)
      expect(notification).to be_valid
      expect(notification.period_type).to eq('yearly')
    end
  end

  context 'period_type が monthly の場合' do
    it '有効であること' do
      notification = build(:notification, :monthly)
      expect(notification).to be_valid
      expect(notification.period_type).to eq('monthly')
    end
  end

  context 'period_type が 定義以外の値の場合' do
    it '不正な値の場合エラーになること' do
    expect {
      build(:notification, period_type: :invalid_type)
    }.to raise_error(ArgumentError)
    end
  end

  context 'fileとbodyがどちらも存在する場合' do
    it '有効であること' do
      notification = build(:notification, body: '本文あり')
      notification.file.attach(fixture_file_upload('spec/fixtures/files/test_image.png'))
      expect(notification).to be_valid
    end
  end

  context 'fileのみ存在する場合' do
    it '有効であること' do
      notification = build(:notification, body: nil)
      notification.file.attach(fixture_file_upload('spec/fixtures/files/test_image.png'))
      expect(notification).to be_valid
    end
  end

  context 'bodyのみ存在する場合' do
    it '有効であること' do
      notification = build(:notification, body: '本文あり')
      expect(notification).to be_valid
    end
  end

  context 'fileとbodyがどちらも存在しない場合' do
    it '無効であること' do
      notification = build(:notification, body: nil)
      expect(notification).to be_invalid
      expect(notification.errors[:base]).to include('ファイルまたは内容のいずれかを入力してください')
    end
  end

context 'file形式が違う場合' do
    it 'ファイル形式エラーのメッセージが出ること' do
      notification = build(:notification, body: nil)
      
      # 確実にテキストファイルを添付する（OSの制限は受けない）
      notification.file.attach(fixture_file_upload('spec/fixtures/files/test_text.txt'))
      
      # バリデーションを実行する（これをしないとエラーメッセージが生成されない）
      notification.valid?

      # titleではなく、fileカラム（または設定したカラム）に対するエラーを検証する
      expect(notification.errors[:file].join).to include("PDF、JPG、JPEG、PNG、GIF形式のみアップロード可能です")
    end
  end

  context 'is_important が true の場合' do
    it '有効であること' do
      notification = build(:notification, is_important: true)
      expect(notification).to be_valid
    end
  end

  context 'is_important が false の場合' do
    it '有効であること' do
      notification = build(:notification, is_important: false)
      expect(notification).to be_valid
    end
  end

  context 'is_important のデフォルト値' do
    it 'false であること' do
      notification = build(:notification)
      expect(notification.is_important).to eq(false)
    end
  end

  context 'is_submission が true の場合' do
    it '有効であること' do
      notification = build(:notification, is_submission: true)
      expect(notification).to be_valid
    end
  end

  context 'is_submission が false の場合' do
    it '有効であること' do
      notification = build(:notification, is_submission: false)
      expect(notification).to be_valid
    end
  end

  context 'is_submission のデフォルト値' do
    it 'false であること' do
      notification = build(:notification)
      expect(notification.is_submission).to eq(false)
    end
  end

  context 'is_document が true の場合' do
    it '有効であること' do
      notification = build(:notification, is_document: true)
      expect(notification).to be_valid
    end
  end

  context 'is_document が false の場合' do
    it '有効であること' do
      notification = build(:notification, is_document: false)
      expect(notification).to be_valid
    end
  end

  context 'is_document のデフォルト値' do
    it 'false であること' do
      notification = build(:notification)
      expect(notification.is_document).to eq(false)
    end
  end
end
