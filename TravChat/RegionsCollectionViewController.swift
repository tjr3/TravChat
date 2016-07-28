//
//  RegionsCollectionViewController.swift
//  TravChat
//
//  Created by Tyler on 6/29/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RegionsCollectionViewController: UICollectionViewController, PerformRegionSegueDelegate, UICollectionViewDelegateFlowLayout {
    
    let imageDictionary = ["Africa": UIImage(named: "Africa")!, "Asia": UIImage(named: "Asia")!, "Australia": UIImage(named: "Australia")!, "Europe": UIImage(named: "Europe")!, "North America": UIImage(named: "NorthAmerica")!, "South America": UIImage(named: "SouthAmerica")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }
        
    func configureView() {
        
        if let navBarFont = UIFont(name: "PingFangHK-Thin", size: 28.0) {
            let navBarAttributesDictionary: [NSObject: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSFontAttributeName: navBarFont
            ]
            
            guard let altributeDict = navBarAttributesDictionary as? [String: AnyObject] else { return }
            navigationController?.navigationBar.titleTextAttributes = altributeDict
            
            self.parentViewController?.tabBarItem.image = UIImage(named: "Grid")?.imageWithRenderingMode(.Automatic)
            self.parentViewController?.tabBarItem.selectedImage = UIImage(named: "Grid")?.imageWithRenderingMode(.AlwaysOriginal)
        }
    }

    
    // MARK: - Dynamic cell size -
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(self.view.frame.width, 8)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.width/2 - 10, self.view.frame.width/2 - 10)
    }

    
    // MARK: - Navigation
    
    func performRegionSegue(sender: RegionsCollectionViewCell) {
        self.performSegueWithIdentifier("toRegionChatSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toRegionChatSegue" {
            if let destinationVC = segue.destinationViewController as? ConversationThreadViewController, let cell = sender as? RegionsCollectionViewCell, indexPath = collectionView?.indexPathForCell(cell) {
                print(indexPath.item)
                guard let region = Region(rawValue: indexPath.item) else {
                    print("Could not get region or image for indexPath --> \(#function)")
                    return
                }
                
                destinationVC.conversationRegion = region
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return ThreadController.sharedController.regionsArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("regionCell", forIndexPath: indexPath) as? RegionsCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let region = Region(rawValue: indexPath.item), let image = region.image else {
            print("Could not convert to desired cell type")
            return UICollectionViewCell()
        }
        
        if indexPath.row == 2 {
            cell.updateWithButtonImage(image, name: region.name, fontSize: 27)
        } else {
            cell.updateWithButtonImage(image, name: region.name, fontSize: 30)
        }

        print("Current Region's Image = \(region.image) @ index: \(indexPath.row)")
        print("Current Region's Name = \(region.name) @ index: \(indexPath.row)")
        
        cell.regionSegueDelegate = self
        
        
        return cell
    }
}
