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
    var fotoDelegate: [String] = []
    
    // передаем только ownerId, для работы с пользователем можем добавить запрос по уникальному ключу, для получения этого пользователя, но это не обязательно
    public var ownerId: Int = 0
    
    // Запрос и токен для отображения данных
    private var photos: Results<Photo>?
    private var notificationToken: NotificationToken?
    
    //Сервисы не изменяются, нигде кроме контроллера не используются, соответственно смело их объявляем как private let
    private let photosService = FotoService()
    private let friendsServiсe = FriendsService()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhoto()
        bindObserver()
    }
    
    private func fetchPhoto() {
        
        //from database
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: config)
            //  guard let user = self.owner else {return}
            photos = realm.objects(Photo.self).filter("ANY owner.id == %@", ownerId)
            print(photos!.count)
            print(ownerId)
            
            //or from server
            photosService.sendRequest(id: ownerId) { photos in
                //запрашиваем юзера из базы данных и прикрепляем к нему загруженные фото
                guard let user = realm.object(ofType: User.self, forPrimaryKey: self.ownerId) else { return }
                // поставил здесь try? - но по уму нужно вынести как отдельный метод в наш RealmProvider
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
                print("=====1")
                print(dels)
                print("=====2")
                print(ins)
                print("=====3")
                print(mods)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("=====4")
        print(photos!.count)
        return photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCell", for: indexPath) as! FotoCollectionCell
        //  cell.superview?.bringSubviewToFront(cell)
        //    self.tabBarController?.tabBar.isHidden = true
        //  self.navigationController?.isNavigationBarHidden = true
        
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
        //fotoDelegate[indexPath.row]
        cell.allFoto.kf.setImage(with: URL(string: photo?.url ?? ""))
        //  self.navigationController?.navigationItem.backBarButtonItem?.title = "Закрыть"
        //  self.navigationItem.title = "\(indexPath.row+1) из \(fotoDelegate.count)"
        reloadInputViews()
        
        return cell
        
    }
    
    var interactiveAnimator: UIViewPropertyAnimator!
    
    @objc func onSwipe(_ recognizer: UIPanGestureRecognizer) {
        guard let selectedIndexPath = self.collectionView.indexPathForItem(at: recognizer.location(in: self.collectionView)) else {
            return
        }
        print(selectedIndexPath.row)
        switch recognizer.state {
        case .began:
            
            // self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            interactiveAnimator?.startAnimation()
            print("start")
            interactiveAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                         curve: .linear,
                                                         animations: {
                                                            let scale = CATransform3DScale(CATransform3DIdentity, 0.7, 0.7, 0)
                                                            self.collectionView.cellForItem(at: selectedIndexPath)!.transform = CATransform3DGetAffineTransform(scale)
            })
            
            interactiveAnimator.pauseAnimation()
        case .changed:
            print("change")
            
            let translation = recognizer.translation(in: self.collectionView)
            interactiveAnimator.fractionComplete = translation.y/100
            print(translation)
        //   self.collectionView.updateInteractiveMovementTargetPosition(recognizer.location(in: recognizer.view!))
        case .ended:
            print("end")
            //     self.collectionView.endInteractiveMovement()
            interactiveAnimator.stopAnimation(true)
            
            interactiveAnimator.addAnimations {
                self.collectionView.transform = .identity
            }
            self.collectionView.reloadData()
            self.collectionView.reloadData()
            
        default: return //self.collectionView.cancelInteractiveMovement()
        }
    }
    
    //    override func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
    //
    //    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
}
