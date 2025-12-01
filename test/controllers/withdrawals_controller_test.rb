require "test_helper"

class WithdrawalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get withdrawals_index_url
    assert_response :success
  end

  test "should get new" do
    get withdrawals_new_url
    assert_response :success
  end

  test "should get create" do
    get withdrawals_create_url
    assert_response :success
  end

  test "should get show" do
    get withdrawals_show_url
    assert_response :success
  end
end
