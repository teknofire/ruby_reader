Rails.application.config.middleware.use OmniAuth::Builder do
  require "openid/fetchers"
  require 'openid/store/filesystem' 

  OpenID.fetcher.ca_file = "/etc/ssl/certs/ca-bundle.trust.crt"  
  provider :open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id', :store => OpenID::Store::Filesystem.new("./tmp")
end