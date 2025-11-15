require_relative 'database_manager'

class Task
    attr_accessor :id, :subject, :user_id, :description, :completed

    def initialize(:id, :subject, :user_id, :description, :completed)
        @id = id
        @subject = subject
        @user_id = user_id
        @description = description
        @completed = completed == 1
    end 

    def self.create_task(subject, user_id, description, completed)
        new_task = self.new(subject, user_id, description, completed)
        DatabaseManager::DB.execute(
            "insert into tasks (text, user_id, description, completed) values (?, ?, ?, ?)", 
            [@subject, @user_id, @description, @completed ? 1 : 0]
        )
    end
    
    def display_task
        status = @completed ? "Completed" : "Pending"
        puts "Subject: #{@subject} - Completed: #{status}\nDescription: #{@description}"
    end 

    def self.get_tasks_by_user(user_id)
        tasks_db = DatabaseManager::DB.execute(
            "select * from tasks where user_id = ?", user_id
        )
        tasks = tasks_db.map do |task_data|
            Task.new(task_data.id, 
                    task_data.subject,
                    task_data.user_id, 
                    task_data.description,
                    task_data.completed)
        end
        return tasks
    end

    def mark_completed
    DatabaseManager::DB.execute(
      "UPDATE tasks SET completed = 1 WHERE id = ?", self.id
    )
    @completed = true
  end
  
end