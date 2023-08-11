module Postfinancecheckout
  class WebhooksController < ApplicationController
    def create
      transaction_id = params[:entityId]

      transaction = Postfinancecheckout::Transaction.find(id: transaction_id)
      if transaction.state == 'FULFILL'
        Postfinancecheckout::Configuration.on_success.call(transaction_id)
      else
        Postfinancecheckout::Configuration.on_failure.call(transaction_id)
      end
    end
  end
end
