//
//  UserManager.swift
//  TteoPpoKki4U
//
//  Created by Dongik Song on 6/7/24.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth

class UserManager {
    
    private var blockedUsers: [BlockedUser] = []
    
    let ref = Database.database().reference()
    
    func updateProfile(uid: String, nickName: String, profile: UIImage, completion: @escaping ((Result<(),Error>) -> Void)) {
        
        let storageRef = Storage.storage().reference(forURL: "gs://tteoppokki4u.appspot.com")
        let storageProfileRef = storageRef.child(db_user_profile).child(uid)
        guard let imageData = profile.jpegData(compressionQuality: 0.3) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageProfileRef.putData(imageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageProfileRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url else { return }
                let values = [db_nickName: nickName, db_profileImageUrl: downloadURL.absoluteString]
                self.ref.child(db_user_users).child(uid).updateChildValues(values) { error, reference in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(()))
                }
            }
        }
        
    }
    
    func setAgreeProfile(uid: String, isAgree: Bool, completion: @escaping ((Result<(),Error>) -> Void)) {
        let values = [db_isAgree: isAgree]
        self.ref.child(db_user_users).child(uid).updateChildValues(values) { error, reference in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func fetchUserData(uid: String, completion: @escaping((Error)?, DataSnapshot?) -> Void) {
        ref.child(db_user_users).child(uid).getData(completion: completion)
    }
    
    func writeReview(userDict: [String: Any], completion: (((Error)?) -> Void)?) {
        reviewCollection.addDocument(data: userDict, completion: completion)
    }
    
    func getMyReview(uid: String, completion: @escaping(QuerySnapshot?, (Error)?) -> Void) {
        reviewCollection.whereField(db_uid, isEqualTo: uid).order(by: db_createdAt, descending: true).getDocuments(completion: completion)
    }
    
    func getSpecificReview(uid: String, storeAddress: String, title: String, completion: @escaping(QuerySnapshot?, (Error)?) -> Void) {
        reviewCollection.whereField(db_uid, isEqualTo: uid).whereField(db_storeAddress, isEqualTo: storeAddress).whereField(db_title , isEqualTo: title).getDocuments(completion: completion)
    }
    func blockUser(user: User) {
        let blockedUser = BlockedUser(uid: user.uid)
        blockedUsers.append(blockedUser)
        print(blockedUsers)
    }
    
    func unblockUser(user: User) {
        blockedUsers.removeAll { $0.uid == user.uid }
    }
    
    func isUserBlocked(user: Sender) -> Bool {
        return blockedUsers.contains { blockedUser in
            blockedUser.uid == user.senderId
        }
    }
    
}
