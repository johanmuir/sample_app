require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "no user added on invalid form data" do
    get signup_path
    
    assert_no_difference 'User.count' do
      post users_path, params: {user:{name: " ", email: " ", password: "foo", password_confirmation: "bar"}}
    end
    
    assert_template 'users/new'
  end
  
  test "valid user signup" do
    get signup_path
    
    assert_difference 'User.count' do
      post users_path, params: {user:{name: "Test User", email: "test_email@test.com", password: "asdf1234", password_confirmation: "asdf1234"}}
    end
    
    follow_redirect!
    assert_template 'static_pages/home'
  end
  
  test "valid signup information with account activation" do
    get signup_path
    
    assert_difference 'User.count', 1 do
      post users_path, params: {user:{name: "Example User", email: "user@example.com", password: "asdf1234", password_confirmation: "asdf1234"}}
    end
    
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    
    assert_not user.activated?
    
    log_in_as(user)
    assert_not is_logged_in?
    
    get edit_account_activation_path("invalid_token", email: user.email)
    assert_not is_logged_in?
    
    get edit_account_activation_path(user.activation_token, email: "invalid@email.com")
    assert_not is_logged_in?
    
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    
    follow_redirect!
    
    assert_template "users/show"
    assert is_logged_in?
  end
end
