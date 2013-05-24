require "glass/api_keys"
require 'active_support/core_ext/hash/indifferent_access'
require "google/api_client"
module Glass
  class Client
    attr_accessor :access_token,          :google_client,           :mirror_api, 
                  :google_account,        :refresh_token,           :content,
                  :mirror_content_type,   :timeline_item,           :has_expired_token




    def self.create(timeline_item, opts={})
      client = new(opts.merge({google_account: timeline_item.google_account}))
      client.set_timeline_item(timeline_item)
      client
    end


    def initialize(opts)
      self.google_client = ::Google::APIClient.new
      self.mirror_api = google_client.discovered_api("mirror", "v1")
      self.google_account = opts[:google_account]

      ### this isn't functional yet but this is an idea for 
      ### an api for those who wish to opt out of passing in a
      ### google account, by passing in a hash of options
      ###
      ###
      ### the tricky aspect of this is how to handle the update
      ### of the token information if the token is expired.

      self.access_token = opts[:access_token] || google_account.try(:token) 
      self.refresh_token = opts[:refresh_token] || google_account.try(:refresh_token)
      self.has_expired_token = opts[:has_expired_token] || google_account.has_expired_token?

      setup_with_our_access_tokens
      setup_with_user_access_token
      self
    end

    def get_timeline_item(id)
      response_hash(self.google_client.execute(get_timeline_item_parameters(id)).response)
    end
    def get_timeline_item_parameters(id)
      { api_method: self.mirror_api.timeline.get,
        parameters: {
          "id" => id
        }
      }
    end

    def set_timeline_item(timeline_object)
      self.timeline_item = timeline_object
      self
    end

    def json_content(options)
      mirror_api.timeline.insert.request_schema.new(self.timeline_item.to_json.merge(options))
    end

    ## optional parameter is merged into the content hash 
    ## before sending. good for specifying more application
    ## specific stuff like speakableText parameters. 

    def insert(options={})
      body_object = options[:content] || json_content(options)
      inserting_content = { api_method: mirror_api.timeline.insert, 
                            body_object: body_object }
      google_client.execute(inserting_content)
    end

    def delete(options={})
      deleting_content = { api_method: mirror_api.timeline.delete,
                           parameters: options }
      google_client.execute(deleting_content)
    end


    def response_hash(google_response)
      JSON.parse(google_response.body).with_indifferent_access
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