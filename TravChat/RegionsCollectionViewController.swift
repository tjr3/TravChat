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
        
       print("\(UserInformation.currentUser)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        if let navBarFont = UIFont(name: "PingFangHK-Medium", size: 28.0) {
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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
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
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}
