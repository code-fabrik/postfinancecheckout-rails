require "postfinancecheckout/version"
require "postfinancecheckout/engine"

module Postfinancecheckout
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
