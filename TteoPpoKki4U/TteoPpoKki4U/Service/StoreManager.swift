//
//  StoreManager.swift
//  TteoPpoKki4U
//
//  Created by Dongik Song on 6/9/24.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class StoreManager {
    
    func requestStore(storeName: String, storeAddress: String, completion: @escaping(QuerySnapshot?, (Error)?) -> Void) {
        reviewCollection.whereField(db_storeAddress, isEqualTo: storeAddress).whereField(db_storeName, isEqualTo: storeName).whereField(db_isActive, isEqualTo: true).order(by: db_createdAt, descending: true).getDocuments(completion: completion)
    }
    
    func requestScrap(uid: String, completion: @escaping(QuerySnapshot?, (any Error)?) -> Void) {
        scrappedCollection.whereField(db_uid, isEqualTo: uid).getDocuments(completion: completion)
    }

    func deleteScrap(uid: String, shopAddress: String, completion: @escaping(QuerySnapshot?, (any Error)?) -> Void) {
        scrappedCollection.whereField(db_uid, isEqualTo: uid).whereField(db_shopAddress, isEqualTo: shopAddress).getDocuments(completion: completion)
    }
    
    func requestBookmark(uid: String, completion: @escaping(QuerySnapshot?, (any Error)?) -> Void) {
        bookmarkedCollection.whereField(db_uid, isEqualTo: uid).getDocuments(completion: completion)
    }
    
    func deleteBookmark(uid: String, title: String, completion: @escaping(QuerySnapshot?, (any Error)?) -> Void) {
        bookmarkedCollection.whereField(db_uid, isEqualTo: uid).whereField(db_title, isEqualTo: title).getDocuments(completion: completion)
    }
}
