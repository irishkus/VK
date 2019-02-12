//
//  MyFriends.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 22.12.2018.
//  Copyright © 2018 Ирина. All rights reserved.
//

import UIKit
import Kingfisher

class MyFriendsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchFriends: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    var searchActive : Bool = false
    private var shadowLayer: CAShapeLayer!
    var filteredFriends: [String] = []
    var users = [User]()
    var friendsService = FriendsService()
    var allLastName = [String]()
    var ownerId: Int = 0
    var characters: [String] =  []
    var myFriendsCharacter = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //   self.navigationController?.navigationBar.barStyle = .default
        friendsService.sendRequest() { [weak self] users in
            if let self = self {
                self.users = users
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
                for user in users {
                    guard let character = user.lastName.first else { preconditionFailure("Bad lastName") }
                    self.allLastName.append(user.lastName)
                    if !self.characters.contains(String(character)) {
                        self.characters.append(String(character))
                    }
                }
                self.characters.sort()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredFriends = allLastName.filter({(text) -> Bool in
                let tmp: NSString = text as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            searchActive = true
            tableView.reloadData()
        }
        else {
            searchActive = false
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchActive = false
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if searchActive {
            return 1
        } else {
            return characters.count
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchActive {
            myFriendsCharacter = filteredFriends//.filter{$0[$0.startIndex] == Character(characters[section]) }
            
        } else {
            myFriendsCharacter = allLastName.filter {$0.first == Character(characters[section]) }
        }
        
        return myFriendsCharacter.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if searchActive {
            return 0
        } else {return CGFloat(28)}
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! MyFriendsCell
        if searchActive {
            myFriendsCharacter = filteredFriends
            
        } else {
            myFriendsCharacter = allLastName.filter {$0.first == Character(characters[indexPath.section]) }
        }
        let friend = myFriendsCharacter[indexPath.row]
        var indexUser: Int = 0
        for index in 0...users.count-1 {
            if users[index].lastName == friend {
                indexUser = index
            }
        }
        let user = users[indexUser]
        cell.friendName.text = user.firstName + " " + user.lastName
        cell.layer.backgroundColor = UIColor.clear.cgColor
        let nameAvatar = user.photo
        // add subcontent
        let photo = UIImageView()
        photo.kf.setImage(with: URL(string: nameAvatar))
        photo.frame = cell.containerView.bounds
        cell.containerView.addSubview(photo)
        return cell
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchActive {
            return nil
        } else {
            return characters
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = tableView.backgroundColor
        headerView.alpha = 0.5
        let label = UILabel(frame: CGRect(x: 20, y: 8, width: 150, height: 20))
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17.0)
        label.text = characters[section]
        headerView.addSubview(label)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let heightCell = cell.frame.height
        let widhtCell = cell.frame.width
        cell.alpha = 0
        cell.frame.size.height = 0
        cell.frame.size.width = 0
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1
            cell.frame.size.height = heightCell
            cell.frame.size.width = widhtCell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allFotoFriend" {
            let fotoFriendsController : FotoFriendCollectionController = segue.destination as! FotoFriendCollectionController
            let myFriendsController = segue.source as! MyFriendsController
            //  Получаем индекс выделенной ячейки
            if let indexPath = myFriendsController.tableView.indexPathForSelectedRow {
                if searchActive {
                    myFriendsCharacter = filteredFriends
                }
                else {
                    myFriendsCharacter = allLastName.filter {$0.first == Character(characters[indexPath.section]) }}
                // Получаем друга по индексу
                let friend = myFriendsController.myFriendsCharacter[indexPath.row]
                var indexUser: Int = 0
                for index in 0...users.count-1 {
                    if users[index].lastName == friend {
                        indexUser = index
                    }
                }
                ownerId = myFriendsController.users[indexUser].id
                fotoFriendsController.ownerId = ownerId
                print(ownerId)
            }
        }
    }
}




