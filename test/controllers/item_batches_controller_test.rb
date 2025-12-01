require "test_helper"

class ItemBatchesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get item_batches_create_url
    assert_response :success
  end

  test "should get destroy" do
    get item_batches_destroy_url
    assert_response :success
  end
end
