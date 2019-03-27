//
//  AllGroupsController.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 25.12.2018.
//  Copyright © 2018 Ирина. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Kingfisher


class AllGroupsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    var allGroups: [String] = []
    var filteredGroups = [SearchGroup]()
    var searchActiveAll : Bool = false
    var searchGroups = [SearchGroup]()
    var searchGroupsService = SearchGroupsService()
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchGroupsService.sendRequest(searchText: "a") { [weak self] searchGroups in
            if let self = self {
              self.searchGroups = searchGroups
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
                for group in searchGroups {
                    self.allGroups.append(group.name)
                }
                self.allGroups.sort()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredGroups = []
            searchGroupsService.sendRequest(searchText: searchText) { [weak self] searchGroups in
                if let self = self {
                    self.filteredGroups = searchGroups
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                    }

                }
            }
            searchActiveAll = true
        }
        else {
            searchActiveAll = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchActiveAll = false
        tableView.reloadData()
    }  
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchGroups.count
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchActiveAll {
            return filteredGroups.count
        } else {
            return allGroups.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupCell", for: indexPath) as! AllGroupsCell
        var nameAvatar = String()
        if searchActiveAll {
            cell.allGroupName.text = filteredGroups[indexPath.row].name
            nameAvatar = filteredGroups[indexPath.row].photo
        } else { cell.allGroupName.text = searchGroups[indexPath.row].name
            nameAvatar = searchGroups[indexPath.row].photo
        }
        cell.allGroupFoto.backgroundColor = UIColor.clear
        cell.allGroupFoto.layer.shadowColor = UIColor.black.cgColor
        cell.allGroupFoto.layer.shadowOffset = cell.shadowOffset
        cell.allGroupFoto.layer.shadowOpacity = cell.shadowOpacity
        cell.allGroupFoto.layer.shadowRadius = cell.shadowRadius
        cell.allGroupFoto.layer.masksToBounds = false
        
        // add subview
        let borderView = UIView(frame: cell.allGroupFoto.bounds)
        borderView.frame = cell.allGroupFoto.bounds
        borderView.layer.cornerRadius = 25
        borderView.layer.masksToBounds = true
        cell.allGroupFoto.addSubview(borderView)
        
        // add subcontent
        let photo = UIImageView()
        photo.kf.setImage(with: URL(string: nameAvatar))
        photo.frame = borderView.bounds
        borderView.addSubview(photo)
        
        return cell
    }
}

