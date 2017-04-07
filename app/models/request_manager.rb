module RequestManager
  Parsers = {
    'ripper_19' => ENV.fetch('RIPPER19_URL'){'https://ripper-api-for-ruby19.herokuapp.com/'},
    'ripper_20' => ENV.fetch('RIPPER20_URL'){'https://ripper-api-for-ruby20.herokuapp.com/'},
    'ripper_21' => ENV.fetch('RIPPER21_URL'){'https://ripper-api-for-ruby21.herokuapp.com/'},
    'ripper_22' => ENV.fetch('RIPPER22_URL'){'https://ripper-api-for-ruby22.herokuapp.com/'},
    'ripper_23' => ENV.fetch('RIPPER23_URL'){'https://ripper-api-for-ruby23.herokuapp.com/'},
    'ripper_24' => ENV.fetch('RIPPER24_URL'){'https://ripper-api-for-ruby24.herokuapp.com/'},
  }.freeze

  # @param code [String] A Ruby code
  # @param targets [Array<String>] parser names
  # @return [Array<String>]
  def self.request(code, targets)
    targets &= Parsers.keys
    targets
      .map{|key| Parsers[key]}
      .map do |url|
      resp = ParseRequester.request(code, url)
      PP.pp(resp, StringIO.new).string
    end
  end
end
