//
//  CloudKitManager.swift
//  TravChat
//
//  Created by Tyler on 7/5/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

private let CreatorUserRecordIDKey = "creatorUserRecordID"
private let LastModifiedUserRecordIDKey = "creatorUserRecordID"
private let CreationDateKey = "creationDate"
private let ModificationDateKey = "modificationDate"

class CloudKitManager {
    
    let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
    let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
    
    init() {
        
    }
    
    // MARK: - User Info Discovery
    
    func fetchLoggedInUserRecord(completion: ((record: CKRecord?, error: NSError? ) -> Void)?) {
        
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (recordID, error) in
            
            if let error = error,
                let completion = completion {
                completion(record: nil, error: error)
            }
            
            if let recordID = recordID,
                let completion = completion {
                
                self.fetchRecordWithID(recordID, completion: { (record, error) in
                    completion(record: record, error: error)
                })
            }
        }
    }
    
    func fetchUsernameFromRecordID(recordID: CKRecordID, completion: ((givenName: String?, familyName: String?) -> Void)?) {
        
        let operation = CKDiscoverUserInfosOperation(emailAddresses: nil, userRecordIDs: [recordID])
        
        operation.discoverUserInfosCompletionBlock = { (emailsToUserInfos, userRecordIDsToUserInfos, operationError) -> Void in
            
            if let userRecordIDsToUserInfos = userRecordIDsToUserInfos,
                let userInfo = userRecordIDsToUserInfos[recordID],
                let completion = completion {
                
                completion(givenName: userInfo.displayContact?.givenName, familyName: userInfo.displayContact?.familyName)
            } else if let completion = completion {
                completion(givenName: nil, familyName: nil)
            }
        }
        
        CKContainer.defaultContainer().addOperation(operation)
    }
    
    func fetchAllDiscoverableUsers(completion: ((userInfoRecords: [CKDiscoveredUserInfo]?) -> Void)?) {
        
        let operation = CKDiscoverAllContactsOperation()
        
        operation.discoverAllContactsCompletionBlock = { (discoveredUserInfos, error) -> Void in
            
            if let completion = completion {
                completion(userInfoRecords:  discoveredUserInfos)
            }
        }
        
        CKContainer.defaultContainer().addOperation(operation)
    }
    
    // MARK: - Fetch Records
    
    func fetchRecordWithID(recordID: CKRecordID, completion: ((record: CKRecord?, error: NSError?) -> Void)?) {
        
        publicDatabase.fetchRecordWithID(recordID) { (record, error) in
            
            if let completion = completion {

