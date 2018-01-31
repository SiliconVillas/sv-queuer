//
//  ProjectsViewModel.swift
//  SV Queuer
//
//  Created by fallik on 31/01/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import Foundation
import UIKit

class ProjectsViewModel: NSObject {
    var delegate:ProjectsDelegate?
    var projects: Array<Dictionary<String, AnyObject?>> = []
    
    func getProjects(){
        let request = Api.getProjectsRequest()
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let jsonData = data, let projects = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Array<Dictionary<String, AnyObject?>>{
                    self.projects = projects
                }
                self.delegate?.didLoadProjects(data: data, response: response, optError: optError)
            }
        }).resume()
    }
    
    func addProject(projectName: String){
        let request = Api.addProjectRequest(projectName: projectName)
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                self.delegate?.didAddProject(data: data, response: response, optError: optError)
            }
        }).resume()
    }
    
    func deleteProject(projectId: Int){
        let request = Api.deleteProjectRequest(projectId: projectId)
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                self.delegate?.didDeleteProject(data: data, response: response, optError: optError)
            }
        }).resume()
    }
}
