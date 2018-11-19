//
//  RepositoryLists.swift
//  GitHubUsers
//
//  Created by mac on 19/11/18.
//  Copyright © 2018 Harshit. All rights reserved.
//

import Foundation

class RepositoryLists: NSObject {
    
    
    func getRepo(repoUrl: String , callback: @escaping (([RepositoryDetails]) -> ())) {
        
        GitService.shared.requestWith(method: .get, parameters: nil, getParam: repoUrl, retryCount: 1, showHud: true) { (success, response, error) in
            
            guard success, error == nil else {
                return
            }
            do {
                let userData = try JSONDecoder().decode([RepositoryDetails].self, from: response!)
                print(userData)
                callback(userData)
            }catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
}
