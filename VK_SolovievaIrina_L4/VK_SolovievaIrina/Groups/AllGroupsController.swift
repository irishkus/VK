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
    var filteredGroup: Results<SearchGroup>?
    var searchActive : Bool = false
    var searchGroups: Results<SearchGroup>?
    var searchGroupsService = SearchGroupsService()
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchGroupsService.sendRequest(searchText: "a") { [weak self] searchGroups in
            if let self = self {
                RealmProvider.save(items: searchGroups)
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
                for group in searchGroups {
                    self.allGroups.append(group.name)
                }
                self.allGroups.sort()
            }
        }
        searchGroups = RealmProvider.get(SearchGroup.self)
        guard let searchGroups = searchGroups else {return}
        notificationToken = searchGroups.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(_):
                self.tableView.reloadData()
            case .update(_, _, _, _):
                self.tableView.reloadData()
                
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
           // let oldSearchGroup = RealmProvider.get(SearchGroup.self)
            do {
            let realm = try Realm()
            realm.beginWrite()
            // удаляю старые данные чтобы не захламлять таблицу
            realm.deleteAll()
            try realm.commitWrite()
            }  catch {
                print(error)
            }
            searchGroupsService.sendRequest(searchText: searchText) { [weak self] searchGroups in
                if let self = self {
                    RealmProvider.save(items: searchGroups)
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                    }
                }
            }
            searchGroups = RealmProvider.get(SearchGroup.self)
            guard let searchGroups = searchGroups else { preconditionFailure("Search groups is empty ")  }
            filteredGroup = searchGroups.filter("name CONTAINS[cd] %@", searchText)
            //   filteredGroup = searchGroups
            searchActive = true
        }
        else {
            searchActive = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
      //  let oldSearchGroup = RealmProvider.get(SearchGroup.self)
     //   searchGroups = RealmProvider.get(SearchGroup.self)
     //   print(searchGroups)
//        do {
//            let realm = try Realm()
//            realm.beginWrite()
//            // удаляю старые данные чтобы не захламлять таблицу
//            realm.delete(oldSearchGroup!)
//           // realm.deleteAll()
//            try realm.commitWrite()
//        }  catch {
//            print(error)
//        }
//        searchGroupsService.sendRequest(searchText: "а") { [weak self] searchGroups in
//            if let self = self {
//                RealmProvider.save(items: searchGroups)
//                print("+++++")
//                print(searchGroups)
////                DispatchQueue.main.async {
////                    self.tableView?.reloadData()
////                }
//                for group in searchGroups {
//                    self.allGroups.append(group.name)
//                }
//                self.allGroups.sort()
//
//            }
//        }
//        //print
//        searchGroups = RealmProvider.get(SearchGroup.self)
//        print("======")
//        print (searchGroups)
        searchActive = false
        tableView.reloadData()
    }  
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchGroups?.count ?? 0
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
        if searchActive {
            return filteredGroup?.count ?? 0
        } else {
            return allGroups.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupCell", for: indexPath) as! AllGroupsCell
        var nameAvatar = String()
        if searchActive {
            guard let filteredGroup = filteredGroup else { preconditionFailure("Filter groups is empty ")  }
            cell.allGroupName.text = filteredGroup[indexPath.row].name
            nameAvatar = filteredGroup[indexPath.row].photo
        } else { cell.allGroupName.text = searchGroups?[indexPath.row].name ?? ""
            nameAvatar = searchGroups?[indexPath.row].photo ?? ""
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

