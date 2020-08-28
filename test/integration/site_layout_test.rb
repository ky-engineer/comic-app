require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "links of root-page" do
    get root_path
    assert_select "a[href = ?]", new_user_path
    assert_select "a[href = ?]", new_session_path
  end

end
