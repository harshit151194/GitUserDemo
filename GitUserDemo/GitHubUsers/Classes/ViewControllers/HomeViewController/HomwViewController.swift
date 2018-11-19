//
//  HomwViewController.swift
//  GitHubUsers
//
//  Created by Darshan on 18/11/18.
//  Copyright © 2018 Harshit. All rights reserved.
//

import UIKit

class HomwViewController: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblGitUser: UITableView!
    
    var userListVM = UserListVM()
    var arrList: [UserDetails] = []
    var fullList: [UserDetails] = []
    var expandRow : Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userListVM.getUsersList { [weak self] (userdetails) in
            self?.arrList = userdetails
            self?.fullList = userdetails
            self?.tblGitUser.reloadData()
        }
    }
    
    @objc func buttonTapped(sender : UIButton){
        
        if expandRow == sender.tag {
            expandRow = nil
        }else{
          expandRow = sender.tag
        }
        
        tblGitUser.reloadData()
    }
    
}

// MARK :- UITableView Delegate & DataSource
extension HomwViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    //=============================
    //MARK :- Tableview Delegate
    //=============================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GitUserCell", for: indexPath) as! GitUserCell
        cell.selectionStyle = .none
        cell.setUpCell(arrList[indexPath.row])
        cell.btnArrow.tag = indexPath.row
        cell.btnArrow.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
        
        if expandRow != nil && expandRow == indexPath.row  {
           cell.btnArrow.setImage(UIImage.init(named: "up-arrow"), for: .normal)
        }else{
            cell.btnArrow.setImage(UIImage.init(named: "down-arrow"), for: .normal)
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = arrList[indexPath.row]
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailVC") as? DetailViewController
        vc?.detailUrl = user.repos_url
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandRow != nil && expandRow == indexPath.row  {
            return 164
        }else{
            return 90
        }
    }
    
    //=============================
    //MARK :- TextField Delegate
    //=============================
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: textField.text!) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            arrList = self.fullList.filter({ (user) -> Bool in
                if user.login.lowercased().range(of:updatedText.lowercased()) != nil {
                    print("exists")
                    return true
                }
                return false
            })
            
            if arrList.count == 0{
                 arrList = fullList
            }
            self.tblGitUser.reloadData()
        }else
        {
            arrList = fullList
            self.tblGitUser.reloadData()
        }
        
       return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

