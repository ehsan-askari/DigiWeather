//
//  SearchViewController.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/25/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    fileprivate var searchResults: [Location] = [Location](){
        didSet{
            if(searchBar.text?.isEmpty)!{
                searchResults = [Location]()
            }
            searchResultsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        
        searchResultsTableView.tableFooterView = UIView()
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if(!searchText.isEmpty){
            BaseModule.shared.network.searchAutoComplete(view: self.view, query: searchText) { (locations, error, msg) in
                if !error{
                    if let l = locations{
                        self.searchResults = l
                    }
                }
            }
        }else{
            self.searchResults = [Location]()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsTableViewCell", for: indexPath)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = searchResults[indexPath.row].name
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = searchResults[indexPath.row]
        
        let objects = BaseModule.shared.realm.objects(LocationRealm.self).filter(NSPredicate(format: "name = '\(selectedLocation.name)' AND latitude = '\(selectedLocation.latitude)' AND longitude = '\(selectedLocation.longitude)' "))
        
        if(objects.count == 0){
            let locationRealm = LocationRealm()
            locationRealm.id = locationRealm.generateUUID()
            locationRealm.name = selectedLocation.name
            locationRealm.latitude = selectedLocation.latitude
            locationRealm.longitude = selectedLocation.longitude
            try! BaseModule.shared.realm.write {
                BaseModule.shared.realm.add(locationRealm)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        self.searchBarCancelButtonClicked(searchBar)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if(searchResults.count > 0){
            self.view.endEditing(true)
        }
    }
    
}
