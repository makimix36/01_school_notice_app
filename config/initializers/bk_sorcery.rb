
Rails.application.config.sorcery.submodules = []

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.stretches = 1 if Rails.env.test?
  end


  config.user_class = "User"
end
