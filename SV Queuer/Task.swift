
import Foundation

class Task {
    var id : Int?
    var name : String?
    var created_at : String?
    var updated_at : String?
    var project_id : Int?
    var points: Int?

    init(id: Int, name: String, created_at: String, updated_at: String, project_id: Int, points: Int){
        self.id = id
        self.name = name
        self.created_at = created_at
        self.updated_at = updated_at
        self.project_id = project_id
        self.points = points
    }
}

