require 'test_helper'

class ViewControllerTest < ActionDispatch::IntegrationTest
  test "should get all" do
    get view_all_url
    assert_response :success
  end

  test "should get eastbay" do
    get view_eastbay_url
    assert_response :success
  end

  test "should get fifelake" do
    get view_fifelake_url
    assert_response :success
  end

  test "should get interlochen" do
    get view_interlochen_url
    assert_response :success
  end

  test "should get kingsley" do
    get view_kingsley_url
    assert_response :success
  end

  test "should get peninsula" do
    get view_peninsula_url
    assert_response :success
  end

  test "should get traversecity" do
    get view_traversecity_url
    assert_response :success
  end

end
