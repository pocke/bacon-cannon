ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end

Capybara::Webkit.configure do |config|
  # Raise JavaScript errors as exceptions
  config.raise_javascript_errors = true
  config.allow_url("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css")
end
