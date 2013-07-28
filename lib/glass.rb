require "rails/all"
require 'active_support/core_ext/numeric/time'
require 'active_support/dependencies'
require 'glass/rails/version'

module Glass
  
  mattr_accessor :application_name
  application_name = (defined?(::Rails) && ::Rails.application) ? ::Rails.application.class.name.split('::').first : "SomeGlassApp"
  @@application_name = application_name

  mattr_accessor :application_version
  @@application_version = "0.0.1"
  
  mattr_accessor :glass_template_path
  @@glass_template_path = "app/views/glass" 


  ## devise trick
  def self.setup
    yield self
  end

end