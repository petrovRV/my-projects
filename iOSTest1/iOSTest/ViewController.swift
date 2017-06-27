//
//  ViewController.swift
//  iOSTest
//
//  Created by Yulminator on 6/14/17.
//  Copyright © 2017 YuraPetrov. All rights reserved.
//

import UIKit

class PlacesData {
    static var array = [Object]()
    private init() {}
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if PlacesData.array.count == 0 {
            updatePlaces()
        }
    }
    
    func updatePlaces() {
        Object.Places { (results:[Object]?) in
            if let objectData = results {
                
                PlacesData.array = objectData
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func btnShowMap(_ sender: Any) {
        for place in PlacesData.array {
            if place.selected {
                self.performSegue(withIdentifier: "ShowMap", sender: self)
            }
        }
        
        let alert = UIAlertController(title: "Oops!", message: "Please choose place", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UIViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        
        PlacesData.array[indexPath.row].selected = !PlacesData.array[indexPath.row].selected
        cell.imgCkeck.image = PlacesData.array[indexPath.row].selected ? UIImage(named: "check_ic_green") : UIImage(named: "check_ic_grey")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlacesData.array.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.lblTitle.text = PlacesData.array[indexPath.row].title
        cell.lblDescription.text = PlacesData.array[indexPath.row].description
        cell.imgPlace.image = PlacesData.array[indexPath.row].image
        cell.imgCkeck.image = PlacesData.array[indexPath.row].selected ? UIImage(named: "check_ic_green") : UIImage(named: "check_ic_grey")
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/4
    }
}
