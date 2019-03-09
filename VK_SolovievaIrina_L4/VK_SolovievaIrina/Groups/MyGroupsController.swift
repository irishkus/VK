//
//  MyGroupsController.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 25.12.2018.
//  Copyright © 2018 Ирина. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class MyGroupsController: UITableViewController, UISearchBarDelegate {
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        // Проверяем идентификатор, чтобы убедится, что это нужный переход
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            let allGroupsController = segue.source as! AllGroupsController
            // Получаем индекс выделенной ячейки
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                // Получаем группу по индексу
                var searchGroup = SearchGroup()
                if allGroupsController.searchActive {
                    guard let filteredGroup = allGroupsController.filteredGroup?[indexPath.row] else { preconditionFailure("Groups is empty ") }
                    searchGroup = filteredGroup
                } else {
                    guard let searchGroups = allGroupsController.searchGroups?[indexPath.row] else { preconditionFailure("Groups is empty ") }
                    searchGroup = searchGroups
                }
                print(searchGroup)
                let group = Group()
               // guard let searchGroups = searchGroup else { preconditionFailure("Groups is empty ") }
                group.id = searchGroup.id
                group.name = searchGroup.name
                group.photo = searchGroup.photo
                print(group)
                RealmProvider.save(items: [group])
//                do {
//                    let realm = try Realm()
//                    realm.beginWrite()
//                    realm.add(group, update: true)
//                    try realm.commitWrite()
//                } catch {
//                    print(error)
//                }
            }
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var myGroups: [String] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredGroup: Results<Group>?
    var searchActive : Bool = false
    var groupsService = GroupsService()
    var notificationToken: NotificationToken?
    
    var groups: Results<Group>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsService.sendRequest() { [weak self] groups in
            if let self = self {
                RealmProvider.save(items: groups)
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
                for group in groups {
                    self.myGroups.append(group.name)
                }
                self.myGroups.sort()
            }
        }
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: config)
            groups = realm.objects(Group.self)
        } catch {
            print(error)
        }
        guard let groups = groups else {return}
        notificationToken = groups.observe { [weak self] changes in
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
            guard let groups = groups else { preconditionFailure("Groups is empty ") }
            filteredGroup = groups.filter("name CONTAINS[cd] %@", searchText)
            searchActive = true
            tableView.reloadData()}
        else {
            searchActive = false
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchActive = false
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredGroup?.count ?? 0
        } else {
            return groups?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupCell
        var nameAvatar = String()
        if searchActive {
            guard let filteredGroup = filteredGroup else { preconditionFailure("Filter groups is empty ")  }
            cell.groupName.text = filteredGroup[indexPath.row].name
            nameAvatar = filteredGroup[indexPath.row].photo
        } else { cell.groupName.text = groups?[indexPath.row].name ?? ""
            nameAvatar = groups?[indexPath.row].photo ?? ""
        }
        cell.fotoGroup.backgroundColor = UIColor.clear
        cell.fotoGroup.layer.shadowColor = UIColor.black.cgColor
        cell.fotoGroup.layer.shadowOffset = cell.shadowOffset
        cell.fotoGroup.layer.shadowOpacity = cell.shadowOpacity
        cell.fotoGroup.layer.shadowRadius = cell.shadowRadius
        cell.fotoGroup.layer.masksToBounds = false
        
        // add subview
        let borderView = UIView(frame: cell.fotoGroup.bounds)
        borderView.frame = cell.fotoGroup.bounds
        borderView.layer.cornerRadius = 25
        
        borderView.layer.masksToBounds = true
        cell.fotoGroup.addSubview(borderView)
        
        // add subcontent
        let photo = UIImageView()
        photo.kf.setImage(with: URL(string: nameAvatar))
        photo.frame = borderView.bounds
        borderView.addSubview(photo)
        
        return cell
    }
}
