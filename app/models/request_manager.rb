module RequestManager
  Parsers = %w[
    ripper_24
    ripper_23
    ripper_22
    ripper_21
    ripper_20
    ripper_19

    parser_24
    parser_23
    parser_22
    parser_21
    parser_20
    parser_19
    parser_18
  ].freeze

  # @param code [String] A Ruby code
  # @param targets [Array<String>] parser names
  # @return [Array<String>]
  def self.request(code, targets)
    targets &= Parsers
    targets
      .map{|name| command(code, name)}
      .map(&:start)
      .map(&:get)
  end

  def self.command(code, parser_name)
    klass = parser_name.start_with?('ripper_') ? ParseRequester : ParserWithParser

    # magic :(
    ::ParseResult
    ::ParseResultError

    Expeditor::Command.new(timeout: 10) do
      klass.request(code, parser_name)
    end.set_fallback do |e|
      Rails.logger.warn e
      ParseResultError.new(error_class: e.class.to_s, error_message: e.message, parser: parser_name)
    end
  end
end
