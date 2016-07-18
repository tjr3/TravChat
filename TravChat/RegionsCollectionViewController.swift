//
//  RegionsCollectionViewController.swift
//  TravChat
//
//  Created by Tyler on 6/29/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RegionsCollectionViewController: UICollectionViewController, PerformRegionSegueDelegate {
    
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
            guard let attributeDict = navBarAttributesDictionary as? [String: AnyObject] else { return }
            navigationController?.navigationBar.titleTextAttributes = attributeDict
        }
    }
    
    // MARK: - Navigation
    
    func performRegionSegue(sender: RegionsCollectionViewCell) {
        self.performSegueWithIdentifier("toRegionChatSegue", sender: sender)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
        } // TODO: Fix Me

        print("Current Region's Image = \(region.image) @ index: \(indexPath.row)")
        print("Current Region's Name = \(region.name) @ index: \(indexPath.row)")
        
        cell.regionSegueDelegate = self
        
        cell.updateWithButtonImage(image, name: region.name)
        
        return cell
    }
}
