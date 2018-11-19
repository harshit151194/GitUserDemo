//
//  GitUserCell.swift
//  GitHubUsers
//
//  Created by Darshan on 18/11/18.
//  Copyright © 2018 Harshit. All rights reserved.
//

import UIKit
import Kingfisher

class GitUserCell: UITableViewCell {

    @IBOutlet weak var imgVProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(_ userDetail: UserDetails) {
        lblName.text = userDetail.login
        lblLocation.text = userDetail.location
        
        print(userDetail.avatar_url ?? "")
        imgVProfile.kf.setImage(with: URL(string: userDetail.avatar_url ?? ""), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        
    
        
    }

}
