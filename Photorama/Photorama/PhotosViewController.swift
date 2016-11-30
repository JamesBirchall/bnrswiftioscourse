//
//  PhotosViewController.swift
//  Photorama
//
//  Created by James Birchall on 14/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    //@IBOutlet var imageView: UIImageView!   // we unwrap explicitly because it will be connected by time it is to be used by this classes methods - if crashes then we need to know
    var store: PhotoStore!
    //var tempPhotoStore: [Photo]?
    let photoDataSource = PhotoDataSource()
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource // where we will get photo's objects from
        collectionView.delegate = self
        
        // swipe gestures for GOLD Challenge
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(pageUp))
        swipeUp.direction = .up
        collectionView.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(pageDown))
        swipeDown.direction = .down
        collectionView.addGestureRecognizer(swipeDown)
        
        
        store.fetchRecentPhotos(completion: {
            (photosResult) -> Void in
            OperationQueue.main.addOperation {
                switch photosResult {
                case .success(let photos):
                    print("Succesfully found \(photos.count) recent photos.")
                    self.photoDataSource.photos = photos
                case .failure(let error):
                    self.photoDataSource.photos.removeAll()
                    print("Error fetching recent photos: \(error)")
                }
                
                // self.collectionView.reloadData()    // this vs reload sections?
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        })
        
        
    }
    
    // MARK - UICollectionViewDelegate Methods
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // this cell is about to be displayed in collectionView
        
        let photo = photoDataSource.photos[indexPath.row]
        
        // download image data - asynch
        
        store.fetchImageForPhoto(photo: photo, completion: {
            [unowned self]
            (result) -> Void in
            
            OperationQueue.main.addOperation {
                // index path may have changed between request started and finished, so find
                // the most recent indexPath
                
                if let photoIndex = self.photoDataSource.photos.index(of: photo) {
                let photoIndexPath = IndexPath(row: photoIndex, section: 0)
                    // only update cell if still visible
                    if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                        cell.updateWithImage(image: photo.image)
                    }
                } else {
                    print("Could not get photo index")
                }
            }
        })
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let showPhotoSegueIdenfitier = "ShowPhoto"
        
        if segue.identifier == showPhotoSegueIdenfitier {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                
                destinationVC.photo = photo
                destinationVC.store = store
            }
        }
    }
    
    // MARK: - Silver Challenge - 4 across images always in potrait and landscape
    
    func updateCellWithSize(size: CGSize) {
        
        // we want the cells to not overlap on the screen either so make approproate spacing between
        print("Update Cell for new window Size \(size)")
        let cellSize = CGSize(width: (size.width / 4), height: (size.width / 4))
        collectionViewFlowLayout.itemSize = cellSize
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        //collectionViewFlowLayout.minimumLineSpacing = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateCellWithSize(size: CGSize(width: view.bounds.width, height: view.bounds.height))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // if this view is showing resize
        if navigationController?.topViewController == self {
            updateCellWithSize(size: size)
        }
    }
    
    // MARK: - Gold Challenge - Scroll to items and Animations
    
    func pageUp() {
        
        //collectionView.reloadData()
        
        collectionView.setNeedsLayout()
        let indexPaths = collectionView.indexPathsForVisibleItems   // array of all visible items
        for index in indexPaths {
            print("Row: \(index.row)")
        }
        
        var lastPath = IndexPath(row: 0, section: 0)    // starting from nothing
        // find the last shown item
        for index in indexPaths {
            if index.row > lastPath.row {
                lastPath = index
            }
        }
        
        // set last path to one item beyond its view
        if lastPath.row < photoDataSource.photos.count {
            //lastPath = IndexPath(row: lastPath.row, section: lastPath.section)
        } else {
            lastPath = IndexPath(row: photoDataSource.photos.count - 1, section: lastPath.section)
        }

        print("Last Path Number: \(lastPath.row), Photo Count = \(photoDataSource.photos.count - 1)")
        
        if lastPath.row <= (photoDataSource.photos.count - 1) {
            print("Page Up started...")
            self.collectionView.scrollToItem(at: lastPath, at: .top, animated: false)
            UIView.transition(with: self.collectionView, duration: 0.5, options: [.transitionCurlUp, .curveEaseIn], animations: { self.view.layoutIfNeeded() }, completion: nil )
            print("Page Up completed...")
        }
    }
    
    func pageDown() {
        
        print("Page Down...initiated")
        
        collectionView.setNeedsLayout()
        let indexPaths = collectionView.indexPathsForVisibleItems   // array of all visible items
        for index in indexPaths {
            print("Row: \(index.row)")
        }
        
        var firstPath = IndexPath(row: photoDataSource.photos.count, section: 0)
        
        print("indexPaths count \(indexPaths.count)")
        for index in indexPaths {
            //print("Index.row = \(index.row)")
            if index.row < firstPath.row {
                firstPath = index
            }
        }
        
        print("First Path Number: \(firstPath.row)")
        
        if firstPath.row == 0 {
            firstPath.row = 1
        }
        
        if firstPath.row > 0 {
            print("Page Down Started...")
            firstPath = IndexPath(row: firstPath.row-1, section: firstPath.section)

            self.collectionView.scrollToItem(at: firstPath, at: .bottom, animated: false)
            UIView.transition(with: self.collectionView, duration: 0.5, options: [.transitionCurlDown, .curveEaseIn], animations: { self.view.layoutIfNeeded() }, completion: nil )
            print("Page Down Completed...")
        }
    }
}
