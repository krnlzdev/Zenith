require "minitest/autorun"

require_relative '../lib/user'
require_relative '../lib/database_manager'

class TestUser < Minitest::Test

  def setup
    DatabaseManager::DB.execute("drop table if exists users")
    DatabaseManager.setup_database
  end

  def test_user_and_authenticate_works
    user = User.create_user("user123", "password123")

    assert_instance_of User, user, "User not created"

    refute_equal "password123", user.password_digest, "Password isn't hashed"

    assert_equal "user123", user.username
  end
end