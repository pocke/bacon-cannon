class PermlinksController < ApplicationController
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
        ParseResult.create!(
          permlink: link,
          ast: ast['ast'],
          parser: ast['parser'],
        )
      end
    end

    render :nothing
  end
end
