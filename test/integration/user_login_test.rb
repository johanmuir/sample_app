require "test_helper"

class UserLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "Login error message is displayed only once" do
    get login_path
    
    assert_template 'sessions/new'
    
    post login_path, params: {session:{email: "hello@hello.com", password: "foo"}}
    
    assert_not is_logged_in?
    
    assert_template 'sessions/new'
    
    assert_equal "Email and/or Password not found", flash[:danger]
    
    get root_path
    
    assert flash.empty? 
  end
  
  test "Valid user login" do
    get login_path
    
    assert_template 'sessions/new'
    
    post login_path, params: {session:{email: @user.email, password: 'password' }}
    
    assert is_logged_in?
    
    assert_redirected_to @user
    
    follow_redirect!
    
    assert_template 'users/show'
    
    assert_select "a[href=?]", login_path, count: 0
  
    assert_select "a[href=?]", user_path(@user)
    
    assert_select "a[href=?]", logout_path
    
    delete logout_path
    
    assert_not is_logged_in?
    
    assert_redirected_to root_url
    delete logout_path
    
    follow_redirect!
    
    assert_select "a[href=?]", login_path
  
    assert_select "a[href=?]", user_path(@user), count: 0
    
    assert_select "a[href=?]", logout_path, count: 0
  end
  
  test "login with remember me" do
    log_in_as(@user, remember_me: '1')
    assert_not cookies[:remember_token].blank?
  end
  
  test "login without remember me" do
    log_in_as(@user, remember_me: '0')
    assert cookies[:remember_token].blank?
  end
end