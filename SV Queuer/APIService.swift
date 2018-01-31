//
//  APIService.swift
//  SV Queuer
//
//  Created by Melania Dello Spedale La Paglia on 31/01/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func getProjects( complete: @escaping ( _ success: Bool, _ projects: Array<Dictionary<String, AnyObject?>>, _ error: APIError? )->() )-> Error?
}

class APIService: APIServiceProtocol {
    func getProjects( complete: @escaping ( _ success: Bool, _ projects: Array<Dictionary<String, AnyObject?>>, _ error: APIError? )->() ) -> Error? {
        var errorCall : Error?
        DispatchQueue.global().async {
            let request = HttpRequest.makeRequest(url: Constants.PROJECTS_URL , httpMethod: HttpRequest.HttpMethod.GET, httpBody: nil)
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
                DispatchQueue.main.async{
                    if let er = optError {
                        errorCall = er
                    }
                    if let jsonData = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Array<Dictionary<String, AnyObject?>>

                        complete( true, dataDictionary!, nil )
                    }
                }
            }).resume()
        }
        return errorCall
    }
}
