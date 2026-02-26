require "test_helper"

class ShiftHandoversControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shift_handovers_index_url
    assert_response :success
  end

  test "should get new" do
    get shift_handovers_new_url
    assert_response :success
  end

  test "should get show" do
    get shift_handovers_show_url
    assert_response :success
  end
end
