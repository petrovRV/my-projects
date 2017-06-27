//
//  ViewController.swift
//  iOSTestForSiteDevel
//
//  Created by Yulminator on 6/21/17.
//  Copyright © 2017 YuraPetrov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUsers()
    }
    
    func updateUsers() {
        UsersJson.get { (results:[UsersJson]?) in
            if let usersData = results {
                Users.array = usersData
                
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        }
    }
}

// MARK: - UITablwViewDataSource, UITAbleViewDelgate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Users.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("UserTableViewCell", owner: self, options: nil)?.first as! UserTableViewCell
        
        cell.title.text = Users.array[indexPath.row].title
        cell.descipt.text = Users.array[indexPath.row].description
        cell.img.image = Users.array[indexPath.row].avatar
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedItem.id = indexPath.row
        self.performSegue(withIdentifier: "goWebView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return table.frame.height / 12
    }
}

