require 'postfinancecheckout-ruby-sdk'

module Postfinancecheckout
  class Transaction
    attr_reader :id

    def initialize(amount: 0, email: '', address: {}, order_number: '', id: nil)
      @amount = amount
      @email = email
      @address = address
      @order_number = order_number
      @id = id

      PostFinanceCheckout.configure do |config|
        config.user_id = app_user_id
        config.authentication_key = app_user_key
      end
    end

    def save
      ensure_not_id!
      tx = transaction_service.create(space_id, transaction_object)
      @id = tx.id
      self
    end

    def self.create(amount: 0, email: '', address: {}, order_number: '')
      transaction = self.new(amount: amount, email: email, address: address, order_number: order_number)
      transaction.save
      transaction
    end

    def self.find(transaction_id)
      transaction = self.new(amount: nil, email: nil, address: {}, order_number: nil, id: transaction_id)
      transaction
    end

    def payment_url
      ensure_id!
      transaction_payment_page_service.payment_page_url(space_id, @id)
    end

    def status
      ensure_id!
      transaction = transaction_service.read(space_id, @id)
      transaction.state
    end

    private

    def space_id
      Postfinancecheckout.config.space_id
    end

    def app_user_id
      Postfinancecheckout.config.app_user_id
    end

    def app_user_key
      Postfinancecheckout.config.app_user_key
    end

    def ensure_id!
      raise StandardError, "Transaction must be saved" if @id.nil?
    end

    def ensure_not_id!
      raise StandardError, "Transaction already saved" if @id
    end

    def address_object
      PostFinanceCheckout::AddressCreate.new({
        emailAddress: @email,
        givenName: @address[:first_name],
        familyName: @address[:last_name],
        street: @address[:street],
        postCode: @address[:post_code],
        city: @address[:city],
        postalState: @address[:state],
        country: @address[:country_code],
      })
    end

    def line_item_object
      PostFinanceCheckout::LineItemCreate.new({
        amountIncludingTax: @amount,
        name: "Bestellung #{@order_number}",
        quantity: 1,
        shippingRequired: true,
        #sku: "test-product",
        #taxes: [
        #    PostFinanceCheckout::TaxCreate.new({
        #        rate: 8,
        #        title: "VAT"
        #    })
        #],
        type: PostFinanceCheckout::LineItemType::PRODUCT,
        #uniqueId: "unique-id-product-1",
      })
    end

    def transaction_object
      PostFinanceCheckout::TransactionCreate.new({
        billingAddress: address_object,
        currency: 'CHF',
        customerEmailAddress: @email,
        customerPresence: PostFinanceCheckout::CustomersPresence::VIRTUAL_PRESENT,
        failedUrl: "http://localhost/failure",
        invoiceMerchantReference: "Bestellung-#{@order_number}",
        language: "de_CH",
        lineItems: [
          line_item_object
        ],
        merchantReference: "order-#{@order_number}",
        shippingAddress: address_object,
        #shippingMethod: "Test Shipping",
        successUrl: "http://localhost/success"
      })
    end

    def transaction_service
      @transaction_service ||= PostFinanceCheckout::TransactionService.new
    end

    def transaction_payment_page_service
      @transaction_payment_page_service ||= PostFinanceCheckout::TransactionPaymentPageService.new
    end
  end
end
