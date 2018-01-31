
import Foundation

class ProjectViewModel {
    
    private var projectsProperty: [Project]?
    var projects: [Project]? {
        get {
            return projectsProperty
        }
        set(newValue){
            projectsProperty = newValue
        }
    }
    let apiService: APIServiceProtocol
    
    

    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    

    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    var isLoading: Bool = false {
        didSet {
           self.reloadTableViewClosure!()
        }
    }
    
    func initFetch() {
        self.isLoading = true
        let result = apiService.getProjects { [weak self] (success, projects, error) in

         self?.createProjectsFromDictionary(projects: projects)
         self?.isLoading = false
        }
        if let r = result {
            self.alertMessage = r.localizedDescription
        }

    }
    
    func createProjectsFromDictionary(projects: Array<Dictionary<String, AnyObject?>>){
        var _projects : [Project] = []
        for proj in projects {
            let projTasks = proj["tasks"]
            var tasks : [Task] = []
            for projTask in (projTasks as? Array<Dictionary<String, AnyObject?>>)! {
                let task = Task(id: projTask["id"] as! Int, name: projTask["name"] as! String, created_at: projTask["created_at"] as! String, updated_at: projTask["updated_at"] as! String, project_id: projTask["project_id"] as! Int, points: projTask["points"] as! Int)
                tasks.append(task)
            }
            let project = Project(id: proj["id"] as! Int, name: proj["name"] as! String, created_at: proj["created_at"] as! String, updated_at: proj["updated_at"] as! String, tasks: tasks)
             _projects.append(project)
        }
        self.projects = _projects
    }
    

}




