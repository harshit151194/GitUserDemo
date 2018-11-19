//
//  UserListVM.swift
//  GitHubUsers
//
//  Created by Darshan on 18/11/18.
//  Copyright © 2018 Harshit. All rights reserved.
//

import Foundation

class UserListVM: NSObject {
    
    
    func getUsersList(callback: @escaping (([UserDetails]) -> ())) {
        
        GitService.shared.requestWith(method: .get, parameters: nil, retryCount: 1, showHud: true) { (success, response, error) in
            
            guard success, error == nil else {
                return
            }
            
            do {
             let userData = try JSONDecoder().decode(UserList.self, from: response!)
                
                print(userData.userDetails)

                callback(userData.userDetails)
//                print(userData[0].login)
//                print(userData[0].avatarUrl)
                
                userData.userDetails
            
            }catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
}
