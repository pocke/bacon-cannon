require 'test_helper'
require 'application_system_test_case'

class ParseTest < ApplicationSystemTestCase
  test 'test_parse_with_valid_ruby_code' do
    visit root_path
    sleep 3
  end
end
