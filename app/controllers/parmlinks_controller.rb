class ParmlinksController < ApplicationController
  protect_from_forgery with: :null_session

  def show
    @parmlink = Parmlink.find_by!(uuid: params.require(:id))
    render template: 'root/index'
  end

  def create
    code = params.require(:code)
    asts = params.require(:asts)

    link = ActiveRecord::Base.transaction do
      Parmlink.create!(
        uuid: SecureRandom.uuid,
        code: code,
      ).tap do |link|
        asts.each do |ast|
          if ast['error_class']
            ParseResultError.create!(
              parmlink: link,
              error_class: ast['error_class'],
              error_message: ast['error_message'],
              parser: ast['parser'],
            )
          else
            meta = ast['meta'].permit('RUBY_VERSION', 'Parser::VERSION')
            ParseResult.create!(
              parmlink: link,
              ast: ast['ast'],
              parser: ast['parser'],
              meta: meta,
            )
          end
        end
      end
    end

    render json: link.slice(:uuid)
  rescue => e
    Rails.logger.error e
    render json: {error_class: e.class.to_s, error_message: e.message}, status: 500
  end
end
