require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: "example@email.com", name: "Example Name", password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "  "
    
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "   "
    
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "b" * 244 + "example.com"
    
    assert_not @user.valid?
  end
  
  test "email with valid format" do
    email_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
first.last@foo.jp alice+bob@baz.cn]
    
    email_addresses.each do |address|
      @user.email = address
      
      assert @user.valid?, "address: #{address.inspect} should be valid"
    end
  end
  
  test "email with invalid format" do
    email_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
                           
    email_addresses.each do |address|
      @user.email = address
      
      assert_not @user.valid?, "addresss: #{address.inspect} is not a valid email address"
    end
  end
  
  test "email addresses should be unique" do
    dup_user = @user.dup
    
    dup_user.email = @user.email
    
    @user.save
    
    assert_not dup_user.valid?
  end
  
  test "email address with mixed case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    
    @user.email = mixed_case_email
    
    @user.save
    
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "user not created with blank password" do
    @user.password = @user.password_confirmation = " " * 6
    
    assert_not @user.valid?
  end
  
  test "user not created with password having less than 6 characters" do
    @user.password = @user.password_confirmation = "a" * 5
    
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  #   assert true
  # end
end
