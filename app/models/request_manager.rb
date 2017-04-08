module RequestManager
  Parsers = {
    'ripper_24' => ENV.fetch('RIPPER24_URL'){'https://ripper-api-for-ruby24.herokuapp.com/'},
    'ripper_23' => ENV.fetch('RIPPER23_URL'){'https://ripper-api-for-ruby23.herokuapp.com/'},
    'ripper_22' => ENV.fetch('RIPPER22_URL'){'https://ripper-api-for-ruby22.herokuapp.com/'},
    'ripper_21' => ENV.fetch('RIPPER21_URL'){'https://ripper-api-for-ruby21.herokuapp.com/'},
    'ripper_20' => ENV.fetch('RIPPER20_URL'){'https://ripper-api-for-ruby20.herokuapp.com/'},
    'ripper_19' => ENV.fetch('RIPPER19_URL'){'https://ripper-api-for-ruby19.herokuapp.com/'},

    'parser_18' => nil,
    'parser_19' => nil,
    'parser_20' => nil,
    'parser_21' => nil,
    'parser_22' => nil,
    'parser_23' => nil,
    'parser_24' => nil,
  }.freeze

  # @param code [String] A Ruby code
  # @param targets [Array<String>] parser names
  # @return [Array<String>]
  def self.request(code, targets)
    ParseRequester # XXX: Hack for autoload
    targets &= Parsers.keys
    targets
      .map{|name| command(code, name)}
      .map(&:start)
      .map(&:get)
      .map{|ast| PP.pp(resp, StringIO.new).string }
  end

  def command(code, parser_name)
    Expeditor::Command.new do
      if parser_name.start_with?('ripper_')
        url = Parsers[parser_name]
        resp = ParseRequester.request(code, url)
      else # parser
        ParserWithParser.request(code, parser_name)
      end
    end.set_fallback do |e|
      Rails.logger.warn e
      nil
    end
  end
end
