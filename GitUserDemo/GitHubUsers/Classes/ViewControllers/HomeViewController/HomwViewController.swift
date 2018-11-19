//
//  HomwViewController.swift
//  GitHubUsers
//
//  Created by Darshan on 18/11/18.
//  Copyright © 2018 Harshit. All rights reserved.
//

import UIKit

class HomwViewController: UIViewController {

    @IBOutlet weak var tblGitUser: UITableView!
    
    var userListVM = UserListVM()
    var arrList: [UserDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userListVM.getUsersList { [weak self] (userdetails) in
            
            self?.arrList = userdetails
            self?.tblGitUser.reloadData()
        }
        // Do any additional setup after loading the view.
    }
}

// MARK :- UITableView Delegate & DataSource
extension HomwViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GitUserCell", for: indexPath) as! GitUserCell
        cell.selectionStyle = .none
        cell.setUpCell(arrList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = arrList[indexPath.row]
        let detailView = DetailViewController.instance() as! DetailViewController
        detailView.detailUrl = user.url
        self.navigationController?.pushViewController(detailView, animated: true)
        
    }
}

