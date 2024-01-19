require "test_helper"

class EpisodesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get episode_url
    assert_response :success
  end

  test "should get index" do
    get episodes_index_url
    assert_response :success
  end

  test "should get search" do
    get episodes_search_url
    assert_response :success
  end
end
