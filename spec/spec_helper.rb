if $LOADED_FEATURES.grep(/spec\/spec_helper\.rb/).any?
  begin
    raise "foo"
  rescue => e
    puts <<-MSG
  ===================================================
  It looks like spec_helper.rb has been loaded
  multiple times. Normalize the require to:

    require "spec/spec_helper"

  Things like File.join and File.expand_path will
  cause it to be loaded multiple times.

  Loaded this time from:

    #{e.backtrace.join("\n    ")}
  ===================================================
    MSG
  end
end

require 'rubygems'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'rspec'

# ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
RSpec.configure do |config|
  # ## Mock FrameworkRSpec.configure do |config|
  # config.include FactoryGirl::Syntax::Methods
  
  # #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # # instead of true.
  # config.use_transactional_fixtures = true

  # # If true, the base class of anonymous controllers will be inferred
  # # automatically. This will be the default behavior in future versions of
  # # rspec-rails.
  # config.infer_base_class_for_anonymous_controllers = false
end