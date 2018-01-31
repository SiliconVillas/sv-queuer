
import Foundation
import UIKit


protocol ProjectTableViewDelegate: class {
    func didSelectGoToMainMenu(datasource: ProjectTableView)
}

class ProjectTableView: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: ProjectTableViewDelegate?
    
    private var projectsProperty: [Project]?
    var projects: [Project]? {
        get {
            return projectsProperty
        }
        set(newValue){
            projectsProperty = newValue
        }
    }
    private var selProjProperty: Project?
    var selProj:Project? {
        get {
            return selProjProperty
        }
        set(newValue){
            selProjProperty = newValue
        }
    }

  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "project")
        cell?.textLabel?.text = (projects![indexPath.row]).name!
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = projects?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selProj = projects![indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
          delegate?.didSelectGoToMainMenu(datasource: self)

    }
    

}

