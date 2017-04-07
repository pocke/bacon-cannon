class RootController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def parse
    code = params.require(:code)
    ast = ParseRequester.new(code).request
    render json: {ast: PP.pp(ast, StringIO.new).string}
  end
end
