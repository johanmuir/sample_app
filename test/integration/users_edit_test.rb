require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "unsuccessful user edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "", email: "foobar", password: "foo", password_confirmation: "barfoo"}}
    
    assert_template 'users/edit'
    assert_select 'div.alert', "The form contains 4 errors."
  end
  
  test "successful user edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    test_name = "Foo Bar"
    test_email = "foobar@foobar.com"
    
    patch user_path(@user), params: {user: {name: test_name, email: test_email, password: "", password_confirmation: ""}}
    
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    
    assert_equal test_name, @user.name
    assert_equal test_email, @user.email
  end
  
  test "successful user edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)

    test_name = "Foo Bar"
    test_email = "foobar@foobar.com"
    
    patch user_path(@user), params: {user: {name: test_name, email: test_email, password: "", password_confirmation: ""}}
    
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    
    assert_equal test_name, @user.name
    assert_equal test_email, @user.email
  end
  
  test "should redirect to login page when editing as a wrong user" do
    log_in_as(@other_user)
    
    get edit_user_path(@user)
    
    assert flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect to login page when updating as a wrong user" do
    log_in_as(@other_user)
    
    patch user_path(@user), params: {user: {name: @user.name, email: @user.email}}
    
    assert flash.empty?
    assert_redirected_to login_url
  end
  
end
