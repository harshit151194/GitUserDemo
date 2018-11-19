//
//  RepoTableCell.swift
//  GitHubUsers
//
//  Created by mac on 19/11/18.
//  Copyright © 2018 Harshit. All rights reserved.
//

import UIKit

class RepoTableCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setUpCell(_ userDetail: RepositoryDetails) {
         name.attributedText = boldString(boldStr: "Name: ", normalTxt: userDetail.name)
        lblDescription.attributedText = boldString(boldStr: "Description: ", normalTxt: userDetail.description)
        
    }
    
    
    func boldString(boldStr: String, normalTxt:String?) -> NSAttributedString {
        let boldText  = boldStr
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        let normalString = NSMutableAttributedString(string:normalTxt ?? "" )
        attributedString.append(normalString)
        return attributedString
    }
    
    
}
