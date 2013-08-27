require "rails/all"
require 'active_support/core_ext/numeric/time'
require 'active_support/dependencies'
require 'glass/rails/version'

module Glass
  DEVELOPMENT_PROXY_URL = "https://mirrornotifications.appspot.com/forward?url="

  mattr_accessor :dev_callback_url
  @@dev_callback_url = ''

  mattr_accessor :application_name
  application_name = (defined?(::Rails) && ::Rails.application) ? ::Rails.application.class.name.split('::').first : "SomeGlassApp"
  @@application_name = application_name

  mattr_accessor :application_version
  @@application_version = "0.0.1"
  
  mattr_accessor :glass_template_path
  @@glass_template_path = "app/views/glass" 

  mattr_accessor :_api_keys
  @@_api_keys = nil

  mattr_accessor :client_id

  mattr_accessor :client_secret
  
  ## devise trick
  def self.setup
    yield self
    require "glass/api_keys"
    Glass::ApiKeys.generate!
  end
end

