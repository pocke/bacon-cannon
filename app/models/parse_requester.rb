module ParseRequester
  def self.request(code, url)
    conn = Faraday.new(url: url) do |f|
      f.adapter Faraday.default_adapter
      f.response :raise_error
    end

    resp = conn.post '/' do |req|
      req.body = code
    end

    JSON.parse(resp.body)['body']
  end
end
