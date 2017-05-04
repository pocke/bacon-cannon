class PermlinksController < ApplicationController
  protect_from_forgery with: :null_session

  def show
    @permlink = Permlink.find_by!(uuid: params.require(:id))
    render template: 'root/index'
  end

  def create
    code = params.require(:code)
    asts = params.require(:asts)

    ActiveRecord::Base.transaction do
      link = Permlink.create!(
        uuid: SecureRandom.uuid,
        code: code,
      )

      asts.each do |ast|
        if ast['error_class']
          ParseResultError.create!(
            permlink: link,
            error_class: ast['error_class'],
            error_message: ast['error_message'],
            parser: ast['parser'],
          )
        else
          meta = ast['meta'].permit('RUBY_VERSION', 'Parser::VERSION')
          ParseResult.create!(
            permlink: link,
            ast: ast['ast'],
            parser: ast['parser'],
            meta: meta,
          )
        end
      end
    end

    render :nothing
  end
end
