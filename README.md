# Postfinance Checkout

Rails integration for Postfinance Checkout. Postfinance Checkout is an all-in-one solution for integrating payment methods into a webshop and for accepting in-person-payments using a banking terminal.

More information on Postfinance Checkout is available from [the website](https://www.postfinance.ch/en/support/products/onlineshop-pos/questions-about-checkout-solutions.html).

## Preparation

You need to have a Postfinance Checkout account. It is okay to leave it in test mode in the beginning.

If you have no account yet, create one at [checkout.postfinance.ch](https://checkout.postfinance.ch).

### Credentials and service account

To get the necessary credentials for communicating with the API, you need to create an Application User.

Open your account on [checkout.postfinance.ch](https://checkout.postfinance.ch)
to get the following credentials:

* Space ID: open your space and note the ID in the URL. An URL of `https://checkout.postfinance.ch/s/40949/space/dashboard`
  means your space ID is 40949. Write it down for later.

Create a new "Application User", enter an arbitrary name and copy the following credentials:

* App User ID: the user ID. Write it down for later.
* App User Key: the user key. Write it down for later.

Then, create a new "Role" with any name where you add at the following permissions:

* Payment Processing

Assign the new role to the applicatin user, as a "Space Role".

### Webhooks

Add the following webhook on the Postfinance Checkout website (Space > Settings > General):

* Webhook URL: `https://example.com/postfinancecheckout/webhook`
* Webhook listeners
  * Name: anything
  * Entity: Transaction
  * Entity States: Fulfill, Failed, Decline, Voided

## Architecture

To initiate a payment, create a `Postfinancecheckout::Transaction` where you state the name and address of
the customer and the line items of the order. This will provide you with a payment URL, where you can
redirect the user to select their payment method. After the payment, they are redirected to your application.

Since many of the payment methods only confirm or deny a transaction after a certain amount of time, it is
necessary to listen to any changes in the transaction status. This is done using webhooks that are automatically
analyzed by the gem. You only need to provide two callbacks that define the action to take on a successful and
on an unsuccessful payment.

## Usage

In order to match transactions at their creation and in the callbacks later on, it is necessary for your
payment model to include a unique identification. Usually, this is done by adding an attribute named
`transaction_id` or similar to the model:

```bash
rails generate migration AddTransactionIdToOrders transaction_id:string
```

In your application, you can create a transaction the following way. Make sure you store
the generated transaction ID in the newly created attribute. The order number is purely
for your own reference and must be unique:

```ruby
transaction = Postfinancecheckout::Transaction.new(
  amount: 34.5,
  order_number: '1234',
  email: 'test@example.com',
  address: {
    first_name: 'Testbenutzer',
    last_name: 'Muster',
    street: 'Hauptstrasse 123',
    post_code: 3019,
    city: 'Chäs und Brot',
    state: 'BE',
    country_code: 'CH'
  }
)
transaction.save

@order.update(transaction_id: transaction.id)
```

Once you have saved the transaction, generate the payment URL and redirect the user:

```ruby
redirect_to transaction.payment_url
```

To handle the callbacks when a transaction is successful or failed, create the file `config/initializers/postfinancecheckout.rb`
and add the following content. Substitute the three variables at the top with your own values.

The callbacks will provide the id of the transaction you created and can be used to find
the original order record. You can also send any necessary emails.

```ruby
Postfinancecheckout.configure do |config|
  config.space_id = 12345
  config.app_user_id = 56789
  config.app_user_key = "my_secret_key"

  config.on_success = -> (transaction_id) do
    order = Order.find_by(transaction_id: transaction_id)
    order.update(status: :paid)

    PaymentSuccessMailer.deliver_later(order)
  end

  config.on_failure = -> (transaction_id) do
    order = Order.find_by(transaction_id: transaction_id)
    order.update(status: :failed)

    PaymentFailedMailer.deliver_later(order)
  end
end
```

Finally, to receive the webhooks, add the following line to `config/routes.rb`:

```ruby
mount Postfinancecheckout::Engine, at: "/postfinancecheckout"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "postfinancecheckout-rails", require: 'postfinancecheckout'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install postfinancecheckout-rails
```

## Development

Build the gem:

```bash
rake build
```

Push it to rubygems.org:

```bash
rake release
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
