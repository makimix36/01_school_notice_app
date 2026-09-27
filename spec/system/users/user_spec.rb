require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  it '正しいタイトルが表示されていること' do
    visit '/users/new'
    expect(page).to have_title("ユーザー登録"), 'ユーザー登録ページのタイトルに「ユーザー登録」が含まれていません。'
  end

  context '入力情報正常系' do
    it 'ユーザーが新規作成できること' do
      visit '/users/new'
      expect {
        fill_in 'ニックネーム（アプリ内での表示に使います）', with: 'らんてっく'
        fill_in 'メールアドレス（必須）', with: 'example@example.com'
        fill_in 'パスワード（必須）', with: '12345678'
        fill_in 'パスワード確認（必須）', with: '12345678'
        click_button '送信する'
        Capybara.assert_current_path("/login", ignore_query: true)
      }.to change { User.count }.by(1)
      expect(page).to have_content('ユーザー登録が完了しました'), 'フラッシュメッセージ「ユーザー登録が完了しました」が表示されていません'
    end
  end

  context '入力情報異常系' do
    it 'ユーザーが新規作成できない' do
      visit '/users/new'
      expect {
        fill_in 'メールアドレス', with: 'example@example.com'
        click_button '送信する'
      }.to change { User.count }.by(0)

      expect(page).to have_content('パスワードは3文字以上で入力してください'), 'エラーメッセージ「パスワードは3文字以上で入力してください」が表示されていません'
      expect(page).to have_content('パスワード確認を入力してください'), 'エラーメッセージ「パスワード確認を入力してください」が表示されていません'
    end
  end
end
