require "yaml"
module Glass
  class ApiKeys
    class APIKeyConfigurationError < StandardError; end;
    attr_accessor :client_id, :client_secret, :google_api_keys
    def initialize
      self.google_api_keys = load_yaml_file
      load_keys
      self
    end
    private
    def load_keys
      if google_api_keys["client_id"].nil? or google_api_keys["client_secret"].nil?
        raise APIKeyConfigurationError
      else
        set_client_keys
      end
    end
    def load_yaml_file
      ::YAML.load(File.read("#{::Rails.root}/config/google-api-keys.yml"))[::Rails.env]
    end
    def set_client_keys
      self.client_id = google_api_keys["client_id"]
      self.client_secret = google_api_keys["client_secret"]
    end
  end
end