require "test_helper"

class InternalUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get internal_users_index_url
    assert_response :success
  end

  test "should get edit" do
    get internal_users_edit_url
    assert_response :success
  end

  test "should get update" do
    get internal_users_update_url
    assert_response :success
  end
end
