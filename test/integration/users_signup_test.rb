require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid submisson" do
    get signup_path
    assert_select 'form[action="/signup"]' 
    assert_no_difference 'User.count' do
      post users_path, params: {user: {name: "minh",
                                        email: "foo@invalid",
                                        password: "foo",
                                        password_confirmation: "bar"}
      }
    end
    assert_template "users/new"
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
    
  end

  test "valid signup submission" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: {user: {name: "Min",
                                        email: "foo@invalid.com",
                                        password: "foobar",
                                        password_confirmation: "foobar"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    
    get edit_account_activation_path(id: "invalid token", email: user.email)
    assert_not is_logged_in?
    
    get edit_account_activation_path(id: user.activation_token, email: "invalid")
    assert_not is_logged_in?
    
    get edit_account_activation_path(id: user.activation_token, email: user.email)
    assert is_logged_in?
    follow_redirect!
    assert_template "users/show"
    assert_select "div.alert"
    #assert is_logged_in?
  end
end
