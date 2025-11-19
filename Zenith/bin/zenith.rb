require 'bundler/setup'

require_relative '../lib/database_manager'
require_relative '../lib/menu'
require_relative '../lib/user'
require_relative '../lib/task'

DatabaseManager.setup_database

menu = Menu.new
menu.run