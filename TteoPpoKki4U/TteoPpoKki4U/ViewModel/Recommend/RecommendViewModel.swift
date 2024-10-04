//
//  RecommendViewController.swift
//  TteoPpoKki4U
//
//  Created by Dongik Song on 5/28/24.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

public class CardViewModel: ObservableObject {
    
    @Published var cards: [CardShell] = []
    @Published var card = [Card]()
    private var db: Firestore!
    private var storage: Storage!
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isBookmarked: Bool = false
    private var bookmarkStatus: [String: Bool] = [:]
    
    
    public var numberOfCards: Int {
        return cards.count
    }
    
    public init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        storage = Storage.storage()
    }
    
    public func fetchData() async {
        
        do {
            let querySnapshot = try await recommendCollection.getDocuments()
            cards.removeAll()
            for document in querySnapshot.documents {
                let data = document.data()
                let title = data["title"] as? String ?? "No Title"
                let description = data["description"] as? String ?? "No Description"
                let imageURLString = data["imageURL"] as? String ?? ""
                
                let order = data["order"] as? Int ?? 0
                // gs:// URL을 HTTP(S) URL로 변환
                let imageURL = try await self.convertGSURLToHTTPURL(gsURL: imageURLString)
                
                
                await self.fetchBookmarkStatus(title: title)
                
                let card = CardShell(title: title, description: description, imageURL: imageURL, order: order)
                
                DispatchQueue.main.async {
                    self.cards.append(card)
                    self.cards.sort(by: { $0.order < $1.order })
                }
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    func convertGSURLToHTTPURL(gsURL: String) async throws -> String {
        guard gsURL.starts(with: "gs://") else { return gsURL }
        
        let reference = storage.reference(forURL: gsURL)
        let url = try await reference.downloadURL()
        return url.absoluteString
    }
    
    func card(at index: Int) -> CardShell {
        return cards[index]
    }
    
    func fetchBookmarkStatus(title: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = bookmarkedCollection
            .whereField(db_uid, isEqualTo: uid)
            .whereField(db_title, isEqualTo: title)
        
        do {
            let querySnapshot = try await query.getDocuments()
            let isBookmarked = !querySnapshot.documents.isEmpty
            DispatchQueue.main.async {
                self.isBookmarked = isBookmarked
            }
        } catch {
            print("Error getting documents: \(error)")
            DispatchQueue.main.async {
                self.isBookmarked = false
            }
        }
    }
    func createBookmarkItem(title: String, imageURL: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        bookmarkedCollection.addDocument(data: [db_title: title, db_imageURL: imageURL, db_uid: uid]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                self.isBookmarked = true
            }
        }
    }
    func deleteBookmarkItem(title: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        bookmarkedCollection
            .whereField(db_uid, isEqualTo: uid)
            .whereField(db_title, isEqualTo: title)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        bookmarkedCollection.document(document.documentID).delete() { error in
                            if let error = error {
                                print("Error removing document: \(error)")
                            } else {
                                self.isBookmarked = false
                            }
                        }
                    }
                }
            }
    }
    
    func getSpecificRecommendation(title: String) async {
        do {
            let querySnapshot = try await recommendCollection.whereField(db_title, isEqualTo: title).getDocuments()
            
            self.card.removeAll()
            
            for document in querySnapshot.documents {
                let data = document.data()
                let title = data["title"] as? String ?? "No Title"
                let description = data["description"] as? String ?? "No Description"
                let imageURLString = data["imageURL"] as? String ?? ""
                let longDescription1 = data["longDescription1"] as? String ?? "No LongDescription1"
                let longDescription2 = data["longDescription2"] as? String ?? "No LongDescription2"
                let shopAddress = data["shopAddress"] as? String ?? "No ShopAddress"
                let queryName = data["queryName"] as? String ?? "No queryName"
                let collectionImageURL1String = data["collectionImageURL1"] as? String ?? ""
                let collectionImageURL2String = data["collectionImageURL2"] as? String ?? ""
                let collectionImageURL3String = data["collectionImageURL3"] as? String ?? ""
                let collectionImageURL4String = data["collectionImageURL4"] as? String ?? ""
                let order = data["order"] as? Int ?? 0

                await self.fetchBookmarkStatus(title: title)
                
                let card = Card(
                    title: title,
                    description: description,
                    longDescription1: longDescription1,
                    longDescription2: longDescription2,
                    imageURL: imageURLString, // URL을 그대로 사용
                    shopAddress: shopAddress,
                    queryName: queryName,
                    collectionImageURL1: collectionImageURL1String, // URL을 그대로 사용
                    collectionImageURL2: collectionImageURL2String, // URL을 그대로 사용
                    collectionImageURL3: collectionImageURL3String, // URL을 그대로 사용
                    collectionImageURL4: collectionImageURL4String, // URL을 그대로 사용
                    order: order
                )
                
                DispatchQueue.main.async {
                    self.card.append(card)
                }
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
}
