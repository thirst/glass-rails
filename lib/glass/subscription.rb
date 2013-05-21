module Glass
  class Subscription
    DEFAULT_COLLECTION = :timeline
    DEFAULT_OPERATIONS = %w(UPDATE INSERT DELETE)#['UPDATE', 'INSERT', 'DELETE']

    attr_accessor :google_account, :client, :google_client, :mirror_api

    def initialize(opts)
      self.google_account = opts[:google_account]
      self.client = Glass::Client.new google_account: google_account
      self.google_client = client.google_client
      self.mirror_api = client.mirror_api
    end

    ## Insert a subscription
    ## optional parameters:
    ##  collection can be :timeline or :locations
    ##  operation is an array of operations subscribed to. Valid values are 'UPDATE', 'INSERT', 'DELETE'
    def insert(opts={})
      subscription = mirror_api.subscriptions.insert.request_schema.new(
        collection:   opts[:collection] || DEFAULT_COLLECTION,
        userToken:    user_token,
        verifyToken:  verification_secret,
        callbackUrl:  opts[:callback_url] || callback_url,
        operation:    opts[:operations] || DEFAULT_OPERATIONS)
      result = google_client.execute(api_method: mirror_api.subscriptions.insert,
                                     body_object: subscription)
      result
    end

    ## Must be HTTPS
    def callback_url
      Rails.application.routes.url_helpers.glass_notifications_callback_url(protocol: 'https')
    end

    ## Token string used to identify user in the callback
    def user_token
      google_account.id.to_s
    end

    ## Secret string used to verify that the callback is by Google
    def verification_secret
      google_account.verification_secret
    end
  end
end