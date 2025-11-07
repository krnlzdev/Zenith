require 'bundler/setup'

require_relative '../lib/database_manager'
require_relative '../lib/menu'

DatabaseManager.setup_database

menu = Menu.new
menu.run