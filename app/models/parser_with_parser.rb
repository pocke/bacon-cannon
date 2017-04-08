%w[18 19 20 21 22 23 24].each do |v|
  require "parser/ruby#{v}"
end

module ParserWithParser
  def request(code, parser_name)
    ruby_version = parser_name[/(\d+)$/, 1]
  end
end
