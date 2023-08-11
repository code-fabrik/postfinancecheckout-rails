require "test_helper"

class PostfinancecheckoutTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Postfinancecheckout::VERSION
  end

  test "it is configurable" do
    Postfinancecheckout.configure do |config|
      config.on_success = 1234
    end

    assert_equal(Postfinancecheckout.config.on_success, 1234)
  end
end
