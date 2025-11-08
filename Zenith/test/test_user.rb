require "minitest/autorun"

require_relative '../lib/user'
require_relative '../lib/database_manager'

class TestUser < Minitest::Test

  #Setup the database before each test
  def setup
    DatabaseManager::DB.execute("drop table if exists users")
    DatabaseManager.setup_database
  end

  #Test user creation and authentication
  def test_user_and_authenticate_works
    user = User.create_user("user123", "password123")

    assert_instance_of User, user, "User not created"

    refute_equal "password123", user.password_digest, "Password isn't hashed"

    assert_equal "user123", user.username
  end

  #test authentication with wrong password
  def test_user_authenticate_wrong_password

    User.create_user("user", "right_pwd")
    
    assert_nil User.authenticate("user", "wrong_pwd"), "Authentication should fail with wrong password"
  
  end

  #test authentication with correct password
  def test_user_authenticate_correct_password
    User.create_user("user", "right_pwd")

    user = User.authenticate("user", "right_pwd")

    assert_instance_of User, user, "Authentication should succeed with correct password"

  end

  #test creating a user with an existing username
  def test_create_existing_user_returns_nil
    User.create_user("existing_user", "pwd1")

    user2 = User.create_user("existing_user", "pwd2")

    assert_nil user2, "Creating a user with an existing username should return nil"
  end
  

end