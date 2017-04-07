class ParseRequester
  URL = 'https://ripper-api-for-ruby24.herokuapp.com'

  def initialize(code)
    @code = code
  end

  def request
    conn = Faraday.new(url: URL) do |f|
      f.adapter Faraday.default_adapter
      f.response :raise_error
    end

    resp = conn.post '/' do |req|
      req.body = @code
    end

    JSON.parse(resp.body)['body']
  end
end
