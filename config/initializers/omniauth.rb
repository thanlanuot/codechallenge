Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, Rails.application.secrets.instagram_client_id, Rails.application.secrets.instagram_client_secret, scope: 'public_content'
end

OmniAuth.config.on_failure = SessionsController.action(:oauth_failure)