require 'rails_helper'

RSpec.describe '共通系', type: :system do
  context 'ログイン前' do
    before do
      visit root_path
    end
    describe 'ヘッダー' do
      it 'ヘッダーが正しく表示されていること' do
        expect(page).to have_content('ログイン'), 'ヘッダーに「ログイン」というテキストが表示されていません'
      end
    end

    describe 'フッター' do
      it 'フッターが正しく表示されていること' do
        expect(page).to have_content('ScPoke. All rights reserved'), '「ScPoke. All rights reserved」というテキストが表示されていません'
      end
    end

    describe 'タイトル' do
     it 'タイトルが正しく表示されていること' do
        expect(page).to have_title("スクポケ - 学校お知らせ整理アプリ"), 'トップページのタイトルに「スクポケ - 学校お知らせ整理アプリ」が含まれていません。'
      end
    end
  end

  context 'ログイン後' do
    let(:user) { create(:user) }
    before do
      login_as(user)
    end
    describe 'ヘッダー' do
      it 'ヘッダーが正しく表示されていること', js: true do
        within('header') do
          expect(page).to have_content("こんにちは、#{user.nickname}さん"), 'ヘッダーにユーザー名を含む挨拶が表示されていません'
          expect(page).to have_content('お知らせ作成'), 'ヘッダーに「お知らせ作成」というテキストが表示されていません'
          expect(page).to have_content('ログアウト'), 'ヘッダーに「ログアウト」が表示されていません'
        end
      end
    end
    describe 'タイトル' do
     it 'タイトルが正しく表示されていること' do
        expect(page).to have_title("スクポケ - 学校お知らせ整理アプリ"), 'トップページのタイトルに「スクポケ - 学校お知らせ整理アプリ」が含まれていません。'
      end
    end
  end
end
