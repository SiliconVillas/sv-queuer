//
//  ProjectsDelegate.swift
//  SV Queuer
//
//  Created by fallik on 31/01/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import Foundation
import UIKit
protocol ProjectsDelegate{
    func didLoadProjects(data: Data?, response: URLResponse?, optError: Error?)
    func didAddProject(data: Data?, response: URLResponse?, optError: Error?)
    func didDeleteProject(data: Data?, response: URLResponse?, optError: Error?)
}
