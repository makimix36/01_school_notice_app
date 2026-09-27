module SystemHelper
  def login_as(user)
    visit root_path
    within('header') do
      click_link "ログイン"
    end
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    Capybara.assert_current_path("/notifications", ignore_query: true)
  end
end

RSpec.configure do |config|
  config.include SystemHelper
end
