require 'test_helper'

class ParticipationControllerTest < ActionDispatch::IntegrationTest
  test "should get submit" do
    get participation_submit_url
    assert_response :success
  end

end
