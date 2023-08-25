# Postfinance Checkout
Short description and motivation.

## Usage

Add a `transaction_id` field to your orders model:

```bash
rails generate migration AddTransactionIdToOrders transaction_id:string
```

Configure the gem and set the callbacks:

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

Create a transaction and store the transaction ID:

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

## Webhooks

Add the following webhook on the Postfinance Checkout website (Space > Settings > General):

* Webhook URL: `https://example.com/postfinancecheckout/webhook`
* Webhook listeners
  * Name: anything
  * Entity: Transaction
  * Entity States: Fulfill, Failed, Decline, Voided

## Credentials

Open your account on [checkout.postfinance.ch](https://checkout.postfinance.ch)
to get the following credentials:

* Space ID: open your space and note the ID in the URL. An URL of `https://checkout.postfinance.ch/s/40949/space/dashboard`
  means your space ID is 40949.

Create a new "Application User", enter an arbitrary name and copy the following credentials:

* App User ID: the user ID
* App User Key: the user key

Then, create a new "Role" with any name where you add at the following permissions:

* Payment Processing

Assign the new role to the applicatin user, as a "Space Role".

## Installation

Add this line to your application's Gemfile:

```ruby
gem "postfinancecheckout-rails"
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
