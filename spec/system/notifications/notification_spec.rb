require 'rails_helper'

RSpec.describe 'お知らせ', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  let(:notification) { create(:notification, user: user, title: '自分のお知らせ') }
  let(:another_notification) { create(:notification, user: another_user, title: '他人のお知らせ') }

  describe 'お知らせのCRUD' do
    describe 'お知らせの一覧' do
      context 'ログインしていない場合' do
        it 'トップページにリダイレクトされること' do
          visit '/notifications'
          Capybara.assert_current_path("/", ignore_query: true)
          expect(current_path).to eq('/'), 'トップページにリダイレクトされていません'
        end
      end

      context 'ログインしている場合' do
        it 'ロゴをクリックするとお知らせ一覧が表示されること' do
          login_as(user)
          click_on('学校お知らせ整理アプリ　スクポケ')
          expect(page).to have_current_path(notifications_path)
        end

        it '正しいタイトルが表示されていること' do
          login_as(user)
          click_on('学校お知らせ整理アプリ　スクポケ')
          expect(page).to have_title("お知らせ一覧 | スクポケ - 学校お知らせ整理アプリ"), 'お知らせ一覧ページのタイトルに「お知らせ一覧 | スクポケ - 学校お知らせ整理アプリ」が含まれていません。'
        end

        context 'お知らせが一件もない場合' do
          it '何もない旨のメッセージが表示されること' do
            login_as(user)
            click_on('学校お知らせ整理アプリ　スクポケ')
            expect(page).to have_content('お知らせがありません'), 'お知らせが一件もない場合、「お知らせがありません」というメッセージが表示されていません'
          end
        end

        context 'お知らせがある場合（ファイルありの場合）' do
          let(:notification) { create(:notification, :with_file, :important, :submission, :document, :yearly, user: user) }
          it 'ファイルが表示されること' do
            notification
            login_as(user)
            click_on('学校お知らせ整理アプリ　スクポケ')
            expect(page).to have_content notification.title
            expect(page).to have_content notification.body
            expect(page).to have_content notification.deadline
            expect(page).to have_content notification.period_type_i18n
            expect(page).to have_content('重要'), '重要フラグが表示されていません'
            expect(page).to have_content('提出あり'), '提出フラグが表示されていません'
            expect(page).to have_content('書類あり'), '書類フラグが表示されていません'
            expect(page).to have_link '拡大'
          end
        end
        context 'お知らせがある場合（ファイルなしの場合）' do
          let(:notification) { create(:notification, user: user) }
          it 'ファイル表記がないこと' do
            notification
            login_as(user)
            click_on('学校お知らせ整理アプリ　スクポケ')
            expect(page).to have_content notification.title
            expect(page).to have_content notification.body
            expect(page).to have_content notification.deadline
            expect(page).to have_no_content('指定なし'), '期間フラグが正しく表示されていません'
            expect(page).to have_no_content('重要'), '重要フラグが正しく表示されていません'
            expect(page).to have_no_content('提出あり'), '提出フラグが正しく表示されていません'
            expect(page).to have_no_content('書類あり'), '書類フラグが正しく表示されていません'
            expect(page).to have_no_link '拡大'
          end
        end
      end
    end

    describe 'お知らせの詳細' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit notification_path(notification)
          expect(current_path).to eq root_path
          expect(page).to have_content '学校からのお知らせを'
        end
      end

      context 'ログインしている場合' do
        before { login_as(user) }
        context 'お知らせがある場合（ファイルありの場合）' do
          let(:notification) { create(:notification, :with_file, :important, :submission, :document, :yearly, user: user) }
          it 'ファイルが表示されること' do
            notification
            click_on('学校お知らせ整理アプリ　スクポケ')
            click_link('詳細を見る', href: "/notifications/#{notification.id}")
            expect(page).to have_current_path("/notifications/#{notification.id}")
            expect(page).to have_content notification.deadline
            expect(page).to have_content notification.period_type_i18n
            expect(page).to have_content('重要'), '重要フラグが表示されていません'
            expect(page).to have_content('提出あり'), '提出フラグが表示されていません'
            expect(page).to have_content('書類あり'), '書類フラグが表示されていません'
            expect(page).to have_link 'プリントを見る'
          end
        end
        context 'お知らせがある場合（ファイルなしの場合）' do
          let(:notification) { create(:notification, user: user) }
          it 'ファイル表記がないこと' do
            notification
            click_on('学校お知らせ整理アプリ　スクポケ')
            click_link('詳細を見る', href: "/notifications/#{notification.id}")
            expect(page).to have_current_path("/notifications/#{notification.id}")
            expect(page).to have_content notification.deadline
            expect(page).to have_no_content('指定なし'), '期間フラグが正しく表示されていません'
            expect(page).to have_no_content('重要'), '重要フラグが正しく表示されていません'
            expect(page).to have_no_content('提出あり'), '提出フラグが正しく表示されていません'
            expect(page).to have_no_content('書類あり'), '書類フラグが正しく表示されていません'
            expect(page).to have_no_link 'プリントを見る'
          end
        end
        context 'タイトルの確認' do
          it '正しいタイトルが表示されていること' do
            click_on('学校お知らせ整理アプリ　スクポケ')
            click_link('詳細を見る', href: "/notifications/#{notification.id}")
            expect(page).to have_title("スクポケ - 学校お知らせ整理アプリ"), 'お知らせ詳細ページのタイトルが「スクポケ - 学校お知らせ整理アプリ」になっていません'
          end
        end
      end
    end

    describe 'お知らせの作成' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit '/notifications/new'
          Capybara.assert_current_path("/", ignore_query: true)
          expect(current_path).to eq('/'), 'ログインしていない場合、お知らせ作成画面にアクセスした際に、トップページにリダイレクトされていません'
        end
      end

      context 'ログインしている場合' do
        before do
          login_as(user)
          click_on('お知らせ作成')
        end

        it '正しいタイトルが表示されていること' do
          expect(page).to have_title("お知らせ作成 | スクポケ - 学校お知らせ整理アプリ"), 'お知らせ新規作成ページのタイトルに「お知らせ作成 | スクポケ - 学校お知らせ整理アプリ」が含まれていません。'
        end
        it 'お知らせが作成できること' do
          fill_in 'タイトル（空欄の場合no titleとなります）', with: 'テストタイトル'
          fill_in 'お知らせ内容', with: 'テスト本文'
          file_path = Rails.root.join('spec', 'fixtures', 'test_image.png')
          click_button '登録する'
          Capybara.assert_current_path("/notifications", ignore_query: true)
          expect(current_path).to eq('/notifications'), 'お知らせ一覧画面に遷移していません'
          expect(page).to have_content('お知らせを作成しました'), 'フラッシュメッセージ「お知らせを作成しました」が表示されていません'
          expect(page).to have_content('テストタイトル'), '作成したお知らせのタイトルが表示されていません'
          expect(page).to have_content('テスト本文'), '作成したお知らせの本文が表示されていません'
        end

        it 'お知らせの作成に失敗すること' do
          fill_in 'タイトル', with: 'テストタイトル'
          click_button '登録する'
          expect(page).to have_content('ファイルまたは内容のいずれかを入力してください'), 'エラーメッセージ「ファイルまたは内容のいずれかを入力してください」が表示されていません'
        end

        # OSやブラウザによって.txtファイルの選択可否が異なるため、
        # どちらのエラーメッセージが表示されてもOKとする
        it 'ファイル形式違いでお知らせ作成に失敗すること' do
          fill_in 'タイトル（空欄の場合no titleとなります）', with: 'テストタイトル'
          file_path = Rails.root.join('spec', 'fixtures', 'test_text.txt')
          click_button '登録する'
          expect(page).to have_content(/PDF、JPG、JPEG、PNG、GIF形式のみアップロード可能です|ファイルまたは内容のいずれかを入力してください/), 'ファイル違いの登録制御ができていません'
        end
      end
    end

    describe 'お知らせの編集' do
      before { notification }
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit edit_notification_path(notification)
          expect(current_path).to eq('/'), 'トップページにリダイレクトされていません'
        end
      end
      context 'ログインしている場合' do
        context '自分のお知らせ' do
          before do
            login_as(user)
            click_link('詳細を見る', href: "/notifications/#{notification.id}")
            click_link('編集する', href: "/notifications/#{notification.id}/edit")
          end
          it 'お知らせが更新できること' do
            fill_in 'タイトル（空欄の場合no titleとなります）', with: '編集後テストタイトル'
            fill_in 'お知らせ内容', with: '編集後テスト本文'
            click_button '登録する'
            Capybara.assert_current_path("/notifications/#{notification.id}", ignore_query: true)
            expect(current_path).to eq notification_path(notification)
            expect(page).to have_content('更新しました'), 'フラッシュメッセージ「更新しました」が表示されていません'
            expect(page).to have_content('編集後テストタイトル'), '更新後のタイトルが表示されていません'
            expect(page).to have_content('編集後テスト本文'), '更新後の本文が表示されていません'
          end

          it 'お知らせの編集に失敗すること' do
            fill_in 'タイトル（空欄の場合no titleとなります）', with: '編集後テストタイトル'
            fill_in 'お知らせ内容', with: ''
            click_button '登録する'
            expect(page).to have_content('ファイルまたは内容のいずれかを入力してください'), 'エラーメッセージ「ファイルまたは内容のいずれかを入力してください」が表示されていません'
          end
        end
      end
    end

    describe 'お知らせ一覧' do
    let(:notification) { create(:notification, user: user, title: '自分のお知らせ') }
    let(:another_notification) { create(:notification, user: another_user, title: '他人のお知らせ') }

      before do
        notification
        another_notification
      end

      context '他人のお知らせ' do
        it '一覧に表示されないこと' do
          login_as(user)
          visit notifications_path
          expect(page).not_to have_content(another_notification.title), '他人のお知らせのタイトルが一覧に表示されています'
        end
      end
    end

    describe 'お知らせ詳細' do
      context '他人のお知らせ' do
        it '詳細ページへアクセスできず、一覧画面にリダイレクトされること' do
          login_as(user)
          visit notification_path(another_notification)
          expect(current_path).to eq notifications_path
        end
      end
    end

    describe 'お知らせ編集' do
      context '他人のお知らせ' do
        it '編集ページへアクセスできず、一覧画面にリダイレクトされること' do
          login_as(user)
          visit edit_notification_path(another_notification)
          expect(current_path).to eq notifications_path
        end
      end
    end

    describe 'お知らせの削除' do
      before { notification }
      context '自分のお知らせ' do
        it 'お知らせが削除できること' do
          login_as(user)
          visit '/notifications'
          page.accept_confirm { find("#button-delete-#{notification.id}").click }
          expect(current_path).to eq('/notifications'), 'お知らせ削除後に、お知らせの一覧ページに遷移していません'
          expect(page).to have_content('削除しました'), 'フラッシュメッセージ「削除しました」が表示されていません'
        end
      end
    end
  end
end
