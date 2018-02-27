//
//  ListViewController.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/25/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {
    
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var locationTableViewHeight: NSLayoutConstraint!
    
    fileprivate var locations: [LocationRealm] = [LocationRealm](){
        didSet{
            locationTableViewHeight.constant = CGFloat(locations.count * 44)
            locationTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.setFAIcon(icon: .FAPlusCircle, iconSize: 25, forState: .normal)
        
        locationTableView.dataSource = self
        locationTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locations = Array(BaseModule.shared.realm.objects(LocationRealm.self))
        locations.insert(LocationRealm(value: ["name": "Your current location"]), at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = locations[indexPath.row].name.components(separatedBy: ",")[0]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row > 0){
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if(locations[indexPath.row].id == BaseModule.shared.getLocationIdToDisplay()){
                BaseModule.shared.setLocationIdToDisplay(displayId: "")
            }
            
            try! BaseModule.shared.realm.write {
                BaseModule.shared.realm.delete(locations[indexPath.row])
            }
            
            locations.remove(at: indexPath.row)
        }
    }
    
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BaseModule.shared.setLocationIdToDisplay(displayId: locations[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
}
