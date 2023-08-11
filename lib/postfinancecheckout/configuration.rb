module Postfinancecheckout
  class Configuration
    attr_accessor :on_success
    attr_accessor :on_failure

    attr_accessor :space_id
    attr_accessor :app_user_id
    attr_accessor :app_user_key

    def def initialize
      @on_success = -> {}
      @on_failure = -> {}
    end
  end
end
