require 'bcrypt'
require_relative 'database_manager'

class User
  include BCrypt

  attr_accessor :id, :username, :password_digest

  # Constructor for a user
  def initialize(props)
    @id = props['id']
    @username = props['username']
    @password_digest = props['password_digest']
  end

  # Getter for password (https://github.com/bcrypt-ruby/bcrypt-ruby?tab=readme-ov-file)
  def password
    @password ||= Password.new(password_digest)
  end

  # Setter for password (https://github.com/bcrypt-ruby/bcrypt-ruby?tab=readme-ov-file)
  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password.to_s
  end

  # Login method
  def self.authenticate(username, password)
    # Searching the username in the database
    user_db = DatabaseManager::DB.get_first_row(
      "select * from users where username = ?", username
    )
    # If the username doesn't exist, nil is returned
    return nil unless user_db

    user = User.new(user_db)

    # Compare the password, if right one -> user is returned, else -> nil is returned
    if user.password == password
      return user
    else
      return nil
    end
  end

  # Register method
  def self.create_user(username, password)

    # Create a new user with the username and the password is hashed by calling the Setter
    new_user = self.new('username' => username)
    new_user.password = password

    # Save in database
    DatabaseManager::DB.execute(
      "insert into users (username, password_digest) values (?, ?)", [new_user.username, new_user.password_digest]
    )

    return self.authenticate(username, password)
  end
end
