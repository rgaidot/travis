require 'travis'
require 'devise_oauth2_authenticatable'
require 'devise/orm/active_record'

Devise::OAUTH2_CONFIG = Travis.config['oauth2'] || {}
Devise.oauth2_uid_field = 'login'

Devise.setup do |config|
  config.http_authenticatable = true
end
