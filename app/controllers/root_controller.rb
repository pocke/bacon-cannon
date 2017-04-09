class RootController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def parse
    code = params[:code] || ''
    parsers = params.require(:parsers)

    asts = RequestManager.request(code, parsers)

    render json: asts.map(&:to_screen_data)
  rescue => e
    Rails.logger.error e
    render json: {error_class: e.class.to_s, error_message: e.message}, status: 500
  end
end
