import UIKit

class ProjectViewController: UIViewController, ProjectTableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    let dataSource = ProjectTableView()
    let viewModel = ProjectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Projects"
        dataSource.delegate = self
        tableView.dataSource = dataSource

        self.initVM()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ProjectViewController.promptProjCreate))
    }
    
    func initVM() {
        
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.dataSource.projects = self?.viewModel.projects
                self?.tableView.reloadData()
            }
        }
        
    self.viewModel.initFetch()
        
    }
   
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func didSelectGoToMainMenu(datasource: ProjectTableView) {
       performSegue(withIdentifier: "viewproject", sender: self)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func promptProjCreate() {
        let vc = UIAlertController(title: "Project name", message: nil, preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
            
            let request = HttpRequest.makeRequest(url: Constants.PROJECTS_URL, httpMethod: HttpRequest.HttpMethod.POST, httpBody: ["project" : ["name": vc.textFields![0].text as AnyObject, "color": -13508189 as AnyObject]])
            
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
                DispatchQueue.main.async{
                    if let error = optError {
                        let alertController = HttpRequest.getAlertConnection(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?")
                        self.present(alertController, animated: true, completion: nil)
                    }
//                    self.fillTable()
                }
            }).resume()
        }))
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
        }))
        vc.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        present(vc, animated: true, completion: nil)
    }



    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    
}
