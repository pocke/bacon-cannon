%w[18 19 20 21 22 23 24].each do |v|
  require "parser/ruby#{v}"
end

module ParserWithParser
  def self.request(code, parser_name)
    ruby_version = parser_name[/(\d+)$/, 1]
    klass = Parser.const_get(:"Ruby#{ruby_version}")
    klass.parse(code)
  end
end
