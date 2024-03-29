require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'edit with invalid information' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "",
                                            email: "foo@invalid",
                                            password: "foo",
                                            password_confirmation: "bar"}}
    assert_template 'users/edit'
    assert_select 'div.alert', text: "The form contains 4 errors."
  end

  test 'successful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Coolio'

    patch user_path(@user), params: {user: {name: name,
                                            email: @user.email,
                                            password: "",
                                            password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert name == @user.name
  end

  test 'successful edit with forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert session[:fowarding_url].nil?
    name = 'Coolio'

    patch user_path(@user), params: {user: {name: name,
                                            email: @user.email,
                                            password: "",
                                            password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert name == @user.name
  end
  # test "the truth" do
  #   assert true
  # end
end
