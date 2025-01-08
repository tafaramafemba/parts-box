require "test_helper"

class Admin::CouriersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_couriers_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_couriers_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_couriers_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_couriers_edit_url
    assert_response :success
  end
end
