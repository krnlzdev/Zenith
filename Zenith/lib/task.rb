require_relative 'database_manager'

class Task
    attr_accessor :id, :subject, :user_id, :description, :completed
    def initialize(props)
        @id = props['id']
        @subject = props['subject']
        @user_id = props['user_id']
        @description = props['description']
        @completed = props['completed'] == 1 
    end  

   
    def self.create_task(subject, user_id, description) 

        DatabaseManager::DB.execute(
            "INSERT INTO tasks (subject, user_id, description, completed) VALUES (?, ?, ?, 0)", 
            subject, 
            user_id, 
            description
        )
    end
    def self.get_tasks_by_user(user_id)
        tasks_db = DatabaseManager::DB.execute(
            "SELECT * FROM tasks WHERE user_id = ?", user_id
        )
        tasks_db.map { |task_data| Task.new(task_data) }
    end
end