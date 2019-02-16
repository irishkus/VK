//
//  MyGroupsController.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 25.12.2018.
//  Copyright © 2018 Ирина. All rights reserved.
//

import UIKit
import Kingfisher

class MyGroupsController: UITableViewController, UISearchBarDelegate {

    @IBAction func addGroup(segue: UIStoryboardSegue) {
        // Проверяем идентификатор, чтобы убедится, что это нужный переход
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            let allGroupsController = segue.source as! AllGroupsController

            // Получаем индекс выделенной ячейки
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                // Получаем группу по индексу
                let group = allGroupsController.allGroups[indexPath.row]
                let groupFoto = allGroupsController.allGroupsFoto[group]
                // Добавляем группу в список моих групп
                if !myGroups.contains(group) {
                    myGroups.append(group)
                    // Обновляем таблицу
                    myGroupsFoto[group] = groupFoto
                    tableView.reloadData()
                }
            }
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    var myGroups: [String] = []
    var myGroupsFoto = ["Котики": "red", "Собачки": "green", "Кролики": "orange"]
    let searchController = UISearchController(searchResultsController: nil)
    var filteredGroup = [Group]()
    var searchActive : Bool = false
    var groups = [Group]()
    var groupsService = GroupsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsService.sendRequest() { [weak self] groups in
            if let self = self {
                self.groups = groups
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
                for group in groups {
                    self.myGroups.append(group.name)
                }
                self.myGroups.sort()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredGroup = []
        if searchText != "" {
            for group in groups {
                let tmp: NSString = group.name as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                if range.location != NSNotFound {
                    filteredGroup.append(group)
                    }
            }
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredGroup.count
        } else {
            return groups.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupCell
        var nameAvatar = String()
        if searchActive {
            cell.groupName.text = filteredGroup[indexPath.row].name
            nameAvatar = filteredGroup[indexPath.row].photo
        } else { cell.groupName.text = groups[indexPath.row].name
            nameAvatar = groups[indexPath.row].photo
        }
        //        let group = myGroups[indexPath.row]
        //        cell.groupName.text = group
        
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
            //cell.fotoGroup.image = UIImage(named: nameAvatar)
        
        return cell
    }
}
