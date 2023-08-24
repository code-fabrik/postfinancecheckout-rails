require 'dry-configurable'
require "postfinancecheckout/version"
require "postfinancecheckout/engine"
require "postfinancecheckout/transaction"

module Postfinancecheckout
  extend Dry::Configurable

  setting :on_success
  setting :on_failure

  setting :space_id
  setting :app_user_id
  setting :app_user_key
end
