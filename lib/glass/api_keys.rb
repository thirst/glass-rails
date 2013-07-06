module Glass
  class ApiKeys
    class APIKeyConfigurationError < StandardError; end;
    attr_accessor :client_id, :client_secret
    def initialize
      load_keys
      self
    end
    private
    def load_keys
      raise APIKeyConfigurationError if ENV['GOOGLE_CLIENT_ID'].nil?
      raise APIKeyConfigurationError if ENV['GOOGLE_CLIENT_SECRET'].nil?
      set_client_keys
    end
    def set_client_keys
      self.client_id = ENV['GOOGLE_CLIENT_ID']
      self.client_secret = ENV['GOOGLE_CLIENT_SECRET']
    end
  end
end
