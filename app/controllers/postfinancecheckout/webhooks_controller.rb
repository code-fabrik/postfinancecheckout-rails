module Postfinancecheckout
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      transaction_id = params[:entityId]

      transaction = Postfinancecheckout::Transaction.find(transaction_id)
      if transaction.status == 'FULFILL'
        Postfinancecheckout.config.on_success.call(transaction_id)
      elsif transaction.status == 'FAILED' || transaction.status == 'VOIDED' || transaction.status == 'DECLINE'
        Postfinancecheckout.config.on_failure.call(transaction_id)
      end

      head :ok
    end
  end
end
