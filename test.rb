require 'postfinancecheckout-ruby-sdk'

space_id = 37069
app_user_id = 74616
app_user_key = "dI1pVzvUgFHE5tchR+K/6n3FboS4CpwWInK2WxzNIYA="

PostFinanceCheckout.configure do |config|
  config.user_id = app_user_id
  config.authentication_key = app_user_key
end

# TransactionService
transaction_service = PostFinanceCheckout::TransactionService.new
# TransactionPaymentPageService
transaction_payment_page_service = PostFinanceCheckout::TransactionPaymentPageService.new

transaction = PostFinanceCheckout::TransactionCreate.new({
    billingAddress: PostFinanceCheckout::AddressCreate.new({
        city: "City",
        country: "US",
        emailAddress: "billing@address.com",
        familyName: "Family",
        givenName: "Given",
        postCode: "98100",
        postalState: "WA",
        street: "Street"
    }),
    currency: 'EUR',
    customerEmailAddress: "test@example.com",
    customerPresence: PostFinanceCheckout::CustomersPresence::VIRTUAL_PRESENT,
    failedUrl: "http://localhost/failure",
    invoiceMerchantReference: "order-1",
    language: "en_US",
    lineItems: [
        PostFinanceCheckout::LineItemCreate.new({
            amountIncludingTax: 5.60,
            name: "Test Product",
            quantity: 1,
            shippingRequired: false,
            sku: "test-product",
            taxes: [
                PostFinanceCheckout::TaxCreate.new({
                    rate: 8,
                    title: "VAT"
                })
            ],
            type: PostFinanceCheckout::LineItemType::SHIPPING,
            uniqueId: "unique-id-product-1",
        }),
    ],
    merchantReference: "order-1",
    shippingAddress: PostFinanceCheckout::AddressCreate.new({
        city: "City",
        country: "US",
        emailAddress: "shipping@address.com",
        familyName: "Family",
        givenName: "Given",
        postCode: "98100",
        postalState: "WA",
        street: "Street"
    }),
    shippingMethod: "Test Shipping",
    successUrl: "http://localhost/success"
})

transaction = transaction_service.create(space_id, transaction)
payment_page_url = transaction_payment_page_service.payment_page_url(space_id, transaction.id)
puts payment_page_url


puts "Enter 'entityId':"
entity_id = gets.chomp
transaction = transaction_service.read(space_id, entity_id)
puts transaction.inspect
