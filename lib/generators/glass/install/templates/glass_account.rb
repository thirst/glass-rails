class GlassAccount < ActiveRecord::Base
  belongs_to :<%= user_model.underscore.singularize %>
  attr_accessible :email, :expires_at, :name, :refresh_token, :token
  def token_expiry
    Time.at(self.expires_at)
  end
  def token_has_expired?
    token_expiry < Time.now
  end
  def update_google_tokens(google_auth_hash)
    [:token, :refresh_token, :expires_at].each do |attribute|
      self.send("#{attribute}=", google_auth_hash[attribute.to_s])
    end
    self.save
  end
end