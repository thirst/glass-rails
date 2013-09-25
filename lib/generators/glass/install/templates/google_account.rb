class GoogleAccount < ActiveRecord::Base
  belongs_to :<%= user_model.underscore.singularize %>
  before_create :generate_verification_secret
  after_create :subscribe_to_google_notifications
  
  def token_expiry
    Time.at(self.expires_at)
  end
  def has_expired_token?
    token_expiry < Time.now
  end
  def update_google_tokens(google_auth_hash)
    self.token = google_auth_hash["token"]
    self.id_token = google_auth_hash["id_token"]
    self.expires_at = google_auth_hash["expires_at"]
    self.refresh_token = google_auth_hash["refresh_token"] if google_auth_hash["refresh_token"].present?
    self.save
  end

  def subscribe_to_google_notifications
    subscription = Glass::Subscription.new google_account: self
    subscription.insert
  end
  def update_location(location)

  end
  def list
    Glass::Client.new(google_account: self).list
  end
  def cached_list
    Glass::Client.new(google_account: self).cached_list
  end
  private
  def generate_verification_secret
    self.verification_secret = SecureRandom.urlsafe_base64
  end
end
