require 'io/console'
require_relative 'user'
require_relative 'task'

class Menu
    attr_accessor :current_user

    def initialize
        @current_user = nil
    end

    def run 
        loop do
            display_banner

            if @current_user
                task_menu
            else
                main_menu
            end
        end
    end

    def main_menu
        puts "\nWelcome on Zenith Task Manager"

        options = [
            '1. Login',
            '2. Register',
            '3. Exit'
        ]

        choice = get_user_choice(options)

        case choice
        when '1' then login
        when '2' then register
        when '3'
            puts "Exiting... Goodbye!"
            exit
        else
            puts "Invalid choice. Please try again."
        end
    end

    def task_menu
        puts "\nHello, #{@current_user.username}, here are your options:"

        display_task 
        options = [
            '1. Add Task',
            '2. Mark Task as Completed',
            '3. Logout'
        ]

        choice = get_user_choice(options)

        case choice
        when '1' then create_task
        when '2' then mark_completed
        when '3' then logout 
            else
            puts "Invalid choice. Please try again."
        end
    end

    def login
        puts "\n--- Login ---"
        print "Username: "
        username = gets.chomp
        print "Password: "
        password = ask_password

        user = User.authenticate(username, password)

        if user
            @current_user = user
            puts "Login successful! Welcome back, #{username}."
        else
            puts "Invalid username or password. Please try again."
        end
    end

    def register
        puts "\n--- Register ---"
        print "Choose a Username: "
        username = gets.chomp
        print "Choose a Password: "
        password = ask_password

        user = User.create_user(username, password)

        if user
            @current_user = user
            puts "Registration successful! Welcome, #{username}."
        else
            puts "Registration failed. Username may already be taken."
        end
    end

    def logout 
        puts "Logging out #{@current_user.username}..."
        @current_user = nil
    end

    def display_task
        tasks = @current_user.tasks

        if tasks.empty?
            puts "\nYou have no tasks."
        else
            puts "\nYour Tasks:"
            tasks.each_with_index do |task, index|
                status = task.completed ? "Completed" : "Pending"
                puts "#{index + 1}. #{task.subject} - #{status}\n   Description: #{task.description}"
                puts "------------------------------"
            end
            puts "---End of Tasks---"
            puts
            puts
            
        end
    end

        def create_task
            puts "\n--- Create New Task ---"
            print "Task Subject: "
            subject = gets.chomp
            print "Task Description: "
            description = gets.chomp

            if subject.strip.empty? || description.strip.empty?
                puts "Subject and Description cannot be empty."
                return
            end

            Task.create_task(subject, @current_user.id, description)
            puts "Task '#{subject}' created successfully."
        end

        def mark_completed
            tasks_available = @current_user.tasks.reject { |task| task.completed }
            if tasks_available.empty?
                puts "\nNo pending tasks to mark as completed."
                return
            end

            puts "\n--- Mark Task as Completed ---"
            tasks_available.each_with_index do |task, index|
                puts "#{index + 1}. #{task.subject}"
            end
            print "Select a task number to mark as completed: "
            choice = gets.chomp.to_i
            if choice.between?(1, tasks_available.length)
                task_to_mark = tasks_available[choice - 1]
                task_to_mark.mark_completed
                puts "Task '#{task_to_mark.subject}' marked as completed."
            else
                puts "Invalid choice. Please try again."
            end
        end

        def get_user_choice(options)
            options.each { |option| puts option }
            print "Your choice: "
            gets.chomp
        end

        def ask_password
            password = STDIN.noecho(&:gets).chomp
            puts
            return password
        end

        def display_banner
            puts "=============================="
            puts "     Zenith Task Manager      "
            puts "        by emilejroy          "
            puts "        version 1.0.0         "
            puts "=============================="
        end
end