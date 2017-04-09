module ParseRequester
  API_URLS = {
    'ripper_24' => ENV.fetch('RIPPER24_URL'){'https://ripper-api-for-ruby24.herokuapp.com/'},
    'ripper_23' => ENV.fetch('RIPPER23_URL'){'https://ripper-api-for-ruby23.herokuapp.com/'},
    'ripper_22' => ENV.fetch('RIPPER22_URL'){'https://ripper-api-for-ruby22.herokuapp.com/'},
    'ripper_21' => ENV.fetch('RIPPER21_URL'){'https://ripper-api-for-ruby21.herokuapp.com/'},
    'ripper_20' => ENV.fetch('RIPPER20_URL'){'https://ripper-api-for-ruby20.herokuapp.com/'},
    'ripper_19' => ENV.fetch('RIPPER19_URL'){'https://ripper-api-for-ruby19.herokuapp.com/'},
  }.freeze

  def self.request(code, parser_name)
    url = API_URLS[parser_name]
    conn = Faraday.new(url: url) do |f|
      f.adapter Faraday.default_adapter
      f.response :raise_error
    end

    resp = conn.post '/' do |req|
      req.body = code
    end

    parsed = JSON.parse(resp.body)
    RequestManager::ASTResponse.new(
      parsed['body'],
      parsed['meta'],
      parser_name,
    )
  end
end
