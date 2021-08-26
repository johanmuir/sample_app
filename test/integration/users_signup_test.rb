require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
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
    assert_template 'users/show'
    
    assert is_logged_in?
    
    assert_equal "Welcome to the Sample App!", flash[:success]
  end
end
