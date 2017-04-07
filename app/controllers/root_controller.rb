class RootController < ApplicationController
  def index
    ast = params[:ast]
    @ast = JSON.parse(ast) if ast
    @code = params[:code]
  end

  def parse
    code = params.require(:code)
    ast = ParseRequester.new(code).request
    redirect_to root_path(ast: ast.to_json, code: code)
  end
end
