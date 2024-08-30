require "test_helper"

class RateLimitableTest < ActionController::TestCase
  class TestController < ActionController::Base
    include RateLimitable

    def index
      render plain: 'OK'
    end
  end

  tests TestController

  setup do
    @routes = ActionDispatch::Routing::RouteSet.new.tap do |r|
      r.draw { get 'index' => 'rate_limitable_test/test#index' }
    end
  end

  test "allows requests within rate limit" do
    50.times do
      get :index
      assert_response :success
    end
  end

  test "blocks requests exceeding rate limit" do
    51.times { get :index }
    assert_response :too_many_requests
  end

  test "resets rate limit after an hour" do
    50.times { get :index }
    assert_response :success

    travel 1.hour + 1.second

    get :index
    assert_response :success
  end
end
