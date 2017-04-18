require 'test_helper'
require 'application_system_test_case'

class ParseTest < ApplicationSystemTestCase
  def test_parse_with_valid_ruby_code_with_parser_gem
    visit root_path

    fill_in 'ruby_code', with: "puts 'Hello, world!'"
    uncheck 'ripper_24'
    click_on 'Parse'

    pre = page.find('pre')
    assert_equal pre.text, <<~END.chomp
      s(:send, nil, :puts, s(:str, "Hello, world!"))
    END
  end

  def test_parse_with_invalid_ruby_code_with_parser_gem
    visit root_path

    fill_in 'ruby_code', with: '))(('
    uncheck 'ripper_24'
    click_on 'Parse'

    within('.alert.alert-danger') do
      assert page.text.include?('Parser::SyntaxError')
      assert page.text.include?('unexpected token')
    end
  end
end
