//
//  FotoFriendCollectionController.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 22.12.2018.
//  Copyright © 2018 Ирина. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FotoFriendCollectionController: UICollectionViewController {
   // var fotoDelegate: [String] = []

    public var ownerId: Int = 0
    
    private var photos: Results<Photo>?
    private var notificationToken: NotificationToken?
    private let photosService = FotoService()
    private let friendsServiсe = FriendsService()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhoto()
        bindObserver()
    }
    
    private func fetchPhoto() {
        print(ownerId)
        //from database
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: config)
            //  guard let user = self.owner else {return}
            photos = realm.objects(Photo.self).filter("ANY owner.id == %@", ownerId)
            //or from server
            photosService.sendRequest(id: ownerId) { photos in
                //запрашиваем юзера из базы данных и прикрепляем к нему загруженные фото
                guard let user = realm.object(ofType: User.self, forPrimaryKey: self.ownerId) else { return }
                // нужно вынести как отдельный метод в RealmProvider
                try? realm.write {
                    //сохраняем наши фото, если вдруг что передаем обновление по уникальному ключу
                    realm.add(photos, update: true)
                    //прикрепляем эти же фото к нашему пользователю
                    user.photos.append(objectsIn: photos)
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func bindObserver() {
        guard let photo = photos else { return }
        
        notificationToken = photo.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(_):
                self.collectionView.reloadData()
                print("initial")
            case .update(_, let dels, let ins, let mods):
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: ins.map({ IndexPath(row: $0, section: 0) }))
                    self.collectionView.deleteItems(at: dels.map({ IndexPath(row: $0, section: 0)}))
                    self.collectionView.reloadItems(at: mods.map({ IndexPath(row: $0, section: 0) }))
                    self.collectionView.reloadData()
                }, completion: nil)
                print(mods)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCell", for: indexPath) as! FotoCollectionCell       
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
                        collectionView.backgroundColor = .white
                        //   collectionView.isScrollEnabled = false
        })
        let photo = photos?[indexPath.row]
        cell.allFoto.kf.setImage(with: URL(string: photo?.url ?? ""))
        //  self.navigationController?.navigationItem.backBarButtonItem?.title = "Закрыть"
        //  self.navigationItem.title = "\(indexPath.row+1) из \(fotoDelegate.count)"
        reloadInputViews()
        
        return cell
        
    }
    
}
