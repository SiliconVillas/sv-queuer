
import Foundation

class Project {
    var id : Int?
    var name : String?
    var created_at : String?
    var updated_at : String?
    var tasks: [Task] = []

    init(id: Int, name: String, created_at: String, updated_at: String, tasks: [Task]){
        self.id = id
        self.name = name
        self.created_at = created_at
        self.updated_at = updated_at
        self.tasks = tasks
    }
}

