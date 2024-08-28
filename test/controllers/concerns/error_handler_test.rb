require "test_helper"

class ErrorHandlerTest < ActionDispatch::IntegrationTest
  class TestController < ApplicationController
    include ErrorHandler

    def not_found
      raise ActiveRecord::RecordNotFound
    end

    def invalid_record
      payload = Payload.new
      payload.errors.add(:base, "Test error")
      raise ActiveRecord::RecordInvalid.new(payload)
    end

    def not_unique
      raise ActiveRecord::RecordNotUnique.new("Test error")
    end
  end

  setup do
    Rails.application.routes.draw do
      get "test/not_found" => "error_handler_test/test#not_found"
      get "test/invalid_record" => "error_handler_test/test#invalid_record"
      get "test/not_unique" => "error_handler_test/test#not_unique"
    end
  end

  teardown do
    Rails.application.reload_routes!
  end

  test "handles ActiveRecord::RecordNotFound" do
    get "/test/not_found"
    assert_response :not_found
    assert_equal({ "error" => "Resource not found" }, JSON.parse(@response.body))
  end

  test "handles ActiveRecord::RecordInvalid" do
    get "/test/invalid_record"
    assert_response :unprocessable_entity
    assert_includes JSON.parse(@response.body)["error"], "Test error"
  end

  test "handles ActiveRecord::RecordNotUnique" do
    get "/test/not_unique"
    assert_response :conflict
    assert_equal({ "error" => "Resource already exists" }, JSON.parse(@response.body))
  end
end
