//
//  DetailViewController.swift
//  GitHubUsers
//
//  Created by Darshan on 18/11/18.
//  Copyright © 2018 Harshit. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var detailUrl: String = ""
    var repoList = RepositoryLists()
    var arrList: [RepositoryDetails] = []
    var loginName = String()
    
    @IBOutlet weak var repoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repoTable.estimatedRowHeight = 1000
        repoTable.rowHeight = UITableView.automaticDimension
        
        repoList.getRepo(repoUrl: detailUrl) { (repo) in
            self.arrList = repo
            self.repoTable.reloadData()
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
}

// MARK :- UITableView Delegate & DataSource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoTableCell
        cell.selectionStyle = .none
        cell.setUpCell(arrList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
