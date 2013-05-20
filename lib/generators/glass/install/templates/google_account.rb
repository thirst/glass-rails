class GoogleAccount < ActiveRecord::Base
  belongs_to :<%= user_model.underscore.singularize %>
  attr_accessible :email, :expires_at, :name, :refresh_token, :token
  after_create :subscribe_to_google_notifications
  def token_expiry
    Time.at(self.expires_at)
  end
  def has_expired_token?
    token_expiry < Time.now
  end
  def update_google_tokens(google_auth_hash)
    [:token, :id_token, :expires_at].each do |attribute|
      self.send("#{attribute}=", google_auth_hash[attribute.to_s])
    end
    self.save
  end

  # Secret token to verify Google's subscription callbacks
  def verification_secret
    "google_account"
  end

  def subscribe_to_google_notifications
    subscription = Glass::Subscription.new google_account: self
    subscription.insert
  end
end