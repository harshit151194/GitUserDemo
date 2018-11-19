//
//  Repository.swift
//  GitHubUsers
//
//  Created by mac on 19/11/18.
//  Copyright © 2018 Harshit. All rights reserved.
//

import Foundation

class Repository: Decodable {
    
    let RepositoryDetail: [RepositoryDetails]!
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
    
    required public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        RepositoryDetail = try values.decode([RepositoryDetails].self, forKey: .items)
    }
}

class RepositoryDetails: Decodable {
    
    let name: String!
    let description: String!
    
    enum DataKeys: String, CodingKey {
        case name
        case description
    }
}
