require "glass/api_keys"
require "google/api_client"
module Glass
  class Client
    attr_accessor :access_token,          :google_client,           :mirror_api, 
                  :google_account,         :refresh_token,          :content,
                  :mirror_content_type,   :timeline_item,           :has_expired_token
    ## opts expects a hash with a key of access_token with 
    ## the user's access token and a user


    ### Glass::Client.new({google_account: some_google_account})
    def initialize(opts)
      self.google_client = ::Google::APIClient.new
      self.mirror_api = google_client.discovered_api("mirror", "v1")
      self.google_account = opts[:google_account]

      ### this isn't functional yet but this is an idea for 
      ### an api for those who wish to opt out of passing in a
      ### google account, by passing in a hash of options
      ###
      ### the tricky aspect of this is how to handle the update
      ### of the token information if the token is expired.

      self.access_token = opts[:access_token] || google_account.try(:token) 
      self.refresh_token = opts[:refresh_token] || google_account.try(:refresh_token)
      self.has_expired_token = opts[:has_expired_token] || google_account.has_expired_token?

      
      setup_with_our_access_tokens
      setup_with_user_access_token
    end
    def set_timeline_item(timeline_object)
      self.timeline_item = timeline_object
    end
    def mirror_content
      mirror_api.timeline.insert.request_schema.new(mirror_content_hash)
    end
    def mirror_content_hash
      self.content = timeline_item.template.to_s
      mirror_hash = {}
      mirror_hash[self.timeline_item.type] = self.content
      mirror_hash.merge!(self.timeline_item.menu_items_hash)
      mirror_hash["speakableText"] = self.timeline_item.speakableText if self.timeline_item.speakableText
      mirror_hash
    end
    ##options hash requires either a key 'text' or key 'html'
    # with the corresponding value
    def insert(options={})
      inserting_content = { api_method: mirror_api.timeline.insert, 
                            body_object: mirror_content }.merge(options)
      puts inserting_content
      google_client.execute(inserting_content)
    end
    def delete(options={})
      deleting_content = { api_method: mirror_api.timeline.delete,
                           parameters: options }
      google_client.execute(deleting_content)
    end
    private
    def setup_with_our_access_tokens
      api_keys = Glass::ApiKeys.new
      ["client_id", "client_secret"].each do |meth| 
        google_client.authorization.send("#{meth}=", api_keys.send(meth)) 
      end
    end
    def setup_with_user_access_token
      google_client.authorization.update_token!(access_token: access_token, 
                                                refresh_token: refresh_token)
      update_token_if_necessary
    end

    def update_token_if_necessary
      if self.has_expired_token
        google_account.update_google_tokens(convert_user_data(google_client.authorization.fetch_access_token!))
      end
    end

    def to_google_time(time)
      Time.now.to_i + time
    end
    def convert_user_data(google_data_hash)
      ea_data_hash = {}
      ea_data_hash["token"] = google_data_hash["access_token"]
      ea_data_hash["expires_at"] = to_google_time(google_data_hash["expires_in"])
      ea_data_hash["id_token"] = google_data_hash["id_token"]
      ea_data_hash
    end
  end
end