require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Test User", email: "test@null.com", password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "       "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.name = "something"
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[ron@swanson.com tomhaverford@tomsbistro.com bobby@newport.com]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. 
    			   chocolate@whole_milk.com vanilla@ice+cream.com baby@got..back]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid? "#{address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be downcased before save" do
    @user.email = "THisIsAllWack@WiggitywACK.CoM"
    @user.save
    assert_equal(@user.reload.email, "thisisallwack@wiggitywack.com")
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "passwrod should have a minimum lenght of 6" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
