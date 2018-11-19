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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK :- UITableView Delegate & DataSource
//extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "GitUserCell", for: indexPath) as! GitUserCell
//        cell.selectionStyle = .none
//        cell.setUpCell(arrList[indexPath.row])
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        //let user = arrList[indexPath.row]
//
//
//    }
//}
