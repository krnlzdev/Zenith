require 'sqlite3'
require 'bcrypt'

module DatabaseManager

  # Openning the database
  DB = SQLite3::Database.new 'task_manager.db'

  DB.results_as_hash = true

  def self.setup_database
    puts "Database setup"
    # Creating the table 'users'
    DB.execute <<-SQL
    create table if not exists users (
        id integer primary key autoincrement,
        username varchar(30) not null,
        password_digest text not null
    );
    SQL

    #Creating the table 'tasks'
    DB.execute <<-SQL
    create table if not exists tasks (
        id integer primary key autoincrement,
        subject text not null,
        user_id integer not null,
        description text not null,
        completed boolean not null,
        foreign key (user_id) references users(id)
    );
    SQL

    puts "Database ready"
  end
end