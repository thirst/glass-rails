require "yaml"
module Glass
  class ApiKeys
    class APIKeyConfigurationError < StandardError; end;
    class YAMLDoesNotHaveTheRightKeysForExtraction < StandardError; end;
    attr_accessor :client_id, :client_secret, :google_api_keys, :yaml_config, :yaml_file_contents, :keys
    def initialize
      self.google_api_keys = {}
      preload_yaml_file_keys
      load_google_keys_from_whereever
      load_keys
      return self.keys
    end
    def self.generate!
      keys_instance = self.new
      keys_instance.keys
      ::Glass.client_secret = keys_instance.keys.client_secret
      ::Glass.client_id = keys_instance.keys.client_id
      ::Glass._api_keys = keys_instance.keys
    end
  private
    def yaml_file_path
      "#{Dir.pwd}/config/google-api-keys.yml"
    end
    def load_keys
      google_api_keys_are_empty? ? (raise APIKeyConfigurationError) : set_client_keys
    end
    def yaml_config_hash
      return self.yaml_file_contents if self.yaml_file_contents
      self.yaml_file_contents = {}
      self.yaml_file_contents = ::YAML.load(File.read(yaml_file_path)) if File.exists?(yaml_file_path)
      self.yaml_file_contents
    end
    def preload_yaml_file_keys
      self.yaml_config = {}
      if yaml_config_hash.has_key?(::Rails.env)
        self.yaml_config = yaml_config_hash[::Rails.env] 
      end
    end

    def load_google_keys_from_whereever 
      [:client_id, :client_secret].each do |key|
        google_api_keys[key] = ::Glass.send(key) 
        unless google_api_keys[key]
          load_yaml_as_auxiliary_method(key)
        end
      end
    end

    def load_yaml_as_auxiliary_method(key)
      if yaml_config.has_key?(key.to_s)
        google_api_keys[key] = yaml_config[key.to_s] 
      else
        raise YAMLDoesNotHaveTheRightKeysForExtraction
      end
    end
    def set_client_keys
      keys_struct = Struct.new(:client_id, :client_secret)
      self.keys = keys_struct.new(google_api_keys[:client_id], google_api_keys[:client_secret])
    end
    def google_api_keys_are_empty?
      google_api_keys[:client_id].nil? or google_api_keys[:client_secret].nil?
    end
  end
end
