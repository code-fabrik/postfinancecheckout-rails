# Postfinance Checkout
Short description and motivation.

## Usage

Add a `transaction_id` field to your orders model:

```bash
rails generate migration AddTransactionIdToOrders transaction_id:string
```

Configure the gem:

```ruby
Postfinancecheckout.configure do |config|
  config.space_id = 12345
  config.app_user_id = 56789
  config.app_user_key = "my_secret_key"

  config.on_success = -> (transaction_id)
    order = Order.find_by(transaction_id: transaction_id)
    order.update(status: :paid)

    PaymentSuccessMailer.deliver_later(order)
  end

  config.on_failure = -> do (transaction_id)
    order = Order.find_by(transaction_id: transaction_id)
    order.update(status: :failed)

    PaymentFailedMailer.deliver_later(order)
  end
end
```

Create a transaction:

```ruby
transaction = Postfinancecheckout::Transaction.new(
  amount: 3,
  identifier: @order.id,
  address: {
    first_name: 'bla',
    last_name: 'foo'
  },
  line_item: line_item
)
transaction.save

@order.update(transaction_id: transaction.id)

redirect_to transaction.payment_url
```

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

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
