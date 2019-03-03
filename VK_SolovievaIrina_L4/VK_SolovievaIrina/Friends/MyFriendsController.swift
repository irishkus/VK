//
//  MyFriends.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 22.12.2018.
//  Copyright © 2018 Ирина. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class MyFriendsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchFriends: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchActive : Bool = false
    var ownerId: Int = 0
    var friendsService = FriendsService()
    var arrayFilteredFriends: [String] = []
    var arrayAllLastName = [String]()
    var arrayCharacters: [String] =  []
    var arrayMyFriendsCharacter = [""]
    var users: Results<User>?
    var notificationToken: NotificationToken?
    var owner: User?
    var photosService = FotoService()
    
    private var shadowLayer: CAShapeLayer!
    private var indexUser: Int = 0
    
//    var owner = LinkingObjects(fromType: User.self, property: "allPhotosFriend")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndSort()
        users = RealmProvider.get(User.self)
        notificationToken = users?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(_):
                self.tableView.reloadData()
            case .update(_, let dels, let ins, let mods):
                print(dels)
                print(ins)
                print(mods)
                self.tableView.reloadData()

            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    private func fetchAndSort() {
        // Вынес разбивку в отдельную функцию
        guard let usersGet = RealmProvider.get(User.self) else {return}
        users = usersGet
        for user in usersGet {
            if user.lastName != "" {
                guard let character = user.lastName.first else { preconditionFailure("Bad lastName") }
                self.arrayAllLastName.append(user.lastName)
                if !self.arrayCharacters.contains(String(character)) {
                    self.arrayCharacters.append(String(character))
                }
            }
        }
        self.arrayCharacters.sort()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchActive {
            return 1
        } else {
            return arrayCharacters.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //определяю количество строк в секции
        if searchActive {
            arrayMyFriendsCharacter = arrayFilteredFriends
        } else {
            //ищу всех друзей чья фамилия начинается на нужную букву
            arrayMyFriendsCharacter = arrayAllLastName.filter {$0.first == Character(arrayCharacters[section]) }
        }
        return arrayMyFriendsCharacter.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if searchActive {
            return 0
        } else {return CGFloat(28)}
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! MyFriendsCell
        if searchActive {
            arrayMyFriendsCharacter = arrayFilteredFriends
            
        } else {
            arrayMyFriendsCharacter = arrayAllLastName.filter {$0.first == Character(arrayCharacters[indexPath.section]) }
        }
        let friend = arrayMyFriendsCharacter[indexPath.row]
        //определяю индекс текущего друга
      //  print(users)
        guard let friends = users else { preconditionFailure("Friends is empty ") }
        for index in 0...friends.count-1 {
            if friends[index].lastName == friend {
                indexUser = index
            }
        }
        let user = friends[indexUser]
        //заполняю имя друга
        cell.friendName.text = user.firstName + " " + user.lastName
        cell.layer.backgroundColor = UIColor.clear.cgColor
        let nameAvatar = user.photo
        //заполняю фото друга
        let photo = UIImageView()
        photo.kf.setImage(with: URL(string: nameAvatar))
        photo.frame = cell.containerView.bounds
        cell.containerView.addSubview(photo)
        return cell
        
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //задаю размер и стиль текста в заголовках ячеек
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = tableView.backgroundColor
        headerView.alpha = 0.5
        let label = UILabel(frame: CGRect(x: 20, y: 8, width: 150, height: 20))
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17.0)
        label.text = arrayCharacters[section]
        headerView.addSubview(label)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //делаю анимацию появления новых ячеек
        let heightCell = cell.frame.height
        let widhtCell = cell.frame.width
        cell.alpha = 0
        cell.frame.size.height = 0
        cell.frame.size.width = 0
        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
            cell.frame.size.height = heightCell
            cell.frame.size.width = widhtCell
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        //опеределяю заголовки у секций таблицы
        if searchActive {
            return nil
        } else {
            return arrayCharacters
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            //фильтрую всех друзей и нахожу тех кто удовлетворяет строке поиска без учета регистра
            arrayFilteredFriends = arrayAllLastName.filter({(text) -> Bool in
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //очищаю строку поиска и обновляю таблицу
        searchBar.text = ""
        searchActive = false
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allFotoFriend" {
            let fotoFriendsController : FotoFriendCollectionController = segue.destination as! FotoFriendCollectionController
            let myFriendsController = segue.source as! MyFriendsController
            //  Получаю индекс выделенной ячейки
            if let indexPath = myFriendsController.tableView.indexPathForSelectedRow {
                if searchActive {
                    arrayMyFriendsCharacter = arrayFilteredFriends
                }
                else {
                    arrayMyFriendsCharacter = arrayAllLastName.filter {$0.first == Character(arrayCharacters[indexPath.section]) }}
                // Получаю друга по индексу
                let friend = myFriendsController.arrayMyFriendsCharacter[indexPath.row]
                var indexUser: Int = 0
                guard let friends = users else { preconditionFailure("Friends is empty ") }
                for index in 0...friends.count-1 {
                    if friends[index].lastName == friend {
                        indexUser = index
                    }
                }
                //передаю ID друга в следующий контроллер
                ownerId = myFriendsController.users?[indexUser].id ?? 0
                fotoFriendsController.ownerId = ownerId
                fotoFriendsController.users = users
                owner = myFriendsController.users?[indexUser]
                fotoFriendsController.owner = owner
                photosService.sendRequest(id: ownerId) { [weak self] photos in
                    
                    if let self = self {
                        self.friendsService.sendRequest(photos: photos) { [weak self] users in
                            if let self = self {
                                for user in users {
                                    if user.id == self.ownerId {
                                        RealmProvider.save(items: [user])
                                        //self.collectionView?.reloadData()
                                    }
                                }
                                //   print ("========")
                                // print(self.owner)
                                //    RealmProvider.save(items: [self.owner!])
                                //  self.collectionView?.reloadData()
                            }
                        }
                    }
                }
             //   myFriendsController.users![indexUser].allPhotosFriend.
              //  fotoFriendsController.owner = myFriendsController.users![indexUser].allPhotosFriend
              //  owner = LinkingObjects(fromType: myFriendsController.users![indexUser], property: "allPhotosFriend")
             //   fotoFriendsController.owner = owner
            }
        }
    }
}




