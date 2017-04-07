class RootController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def parse
    code = params.require(:code)
    asts = RequestManager.request(code, RequestManager::Parsers.keys)
    render json: asts
  end
end
