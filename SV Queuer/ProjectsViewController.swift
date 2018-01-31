import UIKit

class ProjectsViewController: UIViewController, ProjectsDelegate{
    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel: ProjectsViewModel = {
        return ProjectsViewModel()
    }()
    
    var selProj: Dictionary<String, AnyObject?>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptProjCreate))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action:#selector(logout))
        
        title = "Projects"
        self.setDelegates()
        self.view.makeToastActivity(.center)
        self.viewModel.getProjects()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = AppSettings.PROJECTS_NAVBAR_COLOR
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDelegates(){
        viewModel.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func promptProjCreate() {
        let vc = UIAlertController(title: "Project name", message: nil, preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
            self.view.makeToastActivity(.center)
            self.viewModel.addProject(projectName: vc.textFields![0].text!)
        }))
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
        }))
        vc.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    @objc func logout() {
        UserDefaults.standard.removeObject(forKey: "apiKey")
        performSegue(withIdentifier: "logout", sender: self)
    }
    
}

extension ProjectsViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier {
            case "viewproject":
                if let vC = segue.destination as? ProjectViewController {
                    vC.project = selProj;
                }
                break
            default:
                break
            }
        }
    }
}

extension ProjectsViewController{
    func didLoadProjects(data: Data?, response: URLResponse?, optError: Error?){
        self.view.hideToastActivity()
        if let error = optError {
            let message = error.localizedDescription + "\nMaybe check your internet?"
            self.view.makeToast(message, duration: 3.0, position: .center)
        }
        if self.viewModel.projects.count > 0{
            self.selProj = nil
            self.tableView.reloadData()
        } else {
            let message = "No data found"
            self.view.makeToast(message, duration: 3.0, position: .center)
        }
        self.tableView.reloadData()
    }
    
    func didAddProject(data: Data?, response: URLResponse?, optError: Error?) {
        self.view.hideToastActivity()
        if let error = optError {
            let message = error.localizedDescription + "\nMaybe check your internet?"
            self.view.makeToast(message, duration: 3.0, position: .center)
        }
        self.viewModel.getProjects()
    }
    
    func didDeleteProject(data: Data?, response: URLResponse?, optError: Error?) {
        self.view.hideToastActivity()
        var message = ""
        if let error = optError {
            message = error.localizedDescription + "\nMaybe check your internet?"
        } else {
            self.viewModel.getProjects()
            message =  "The project has been deleted."
        }
        self.view.makeToast(message, duration: 3.0, position: .center)
    }
}

extension ProjectsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "project")
        cell?.textLabel?.text = (self.viewModel.projects[indexPath.row])["name"]! as? String
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selProj = self.viewModel.projects[indexPath.row];
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "viewproject", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let selectedProject = self.viewModel.projects[indexPath.row];
            let selectedProjectId : Int = selectedProject["id"] as! Int
            self.view.makeToastActivity(.center)
            self.viewModel.deleteProject(projectId: selectedProjectId)
        }
    }
}
