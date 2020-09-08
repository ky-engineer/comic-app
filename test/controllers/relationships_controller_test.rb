require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest


  #before_action :login_userに対するテスト


  test "should redirect create when not logged in" do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to new_session_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one_two))
    end
    assert_redirected_to new_session_path
  end


end
