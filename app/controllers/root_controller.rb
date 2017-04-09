class RootController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def parse
    code = params.require(:code)
    parsers = params.require(:parsers)

    asts = RequestManager.request(code, parsers)

    render json: asts.map(&:to_screen_data)
  end
end
