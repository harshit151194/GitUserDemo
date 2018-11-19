//
//  File.swift
//  GitHubUsers
//
//  Created by Darshan on 18/11/18.
//  Copyright © 2018 Harshit. All rights reserved.
//

import Foundation

class UserList: Decodable {
    
    let userDetails: [UserDetails]!
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
    
    required public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userDetails = try values.decode([UserDetails].self, forKey: .items)
        print(userDetails[0].login)
        print(userDetails[0].avatar_url)
    }
}

class UserDetails: Decodable {
    
    let login: String!
    let avatar_url: String!
    let url: String!
    let location: String = "Pune"
    
    enum DataKeys: String, CodingKey {
        case login
        case url
        case avatar_url
    }
}
