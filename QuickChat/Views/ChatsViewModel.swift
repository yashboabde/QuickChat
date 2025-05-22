//
//  ChatsViewModel.swift
//  QuickChat
//
//  Created by yash bobade on 21/05/25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ChatsViewModel: ObservableObject {
    @Published var chats: [Chat] = []

    private var db = Firestore.firestore()
    
    func fetchChats() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        db.collection("chats")
            .whereField("members", arrayContains: currentUserID)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else { return }

                var tempChats: [Chat] = []
                let group = DispatchGroup()
                
                for doc in documents {
                    let data = doc.data()
                    let chatId = doc.documentID
                    let members = data["members"] as? [String] ?? []
                    let lastMessage = data["lastMessage"] as? String ?? ""
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    
                    guard let otherUserID = members.first(where: { $0 != currentUserID }) else { continue }
                    
                    group.enter()
                    
                    self?.db.collection("users").document(otherUserID).getDocument { userDoc, error in
                        if let userData = userDoc?.data() {
                            let name = userData["name"] as? String ?? "Unknown"
                            let imageUrl = userData["profileImageUrl"] as? String ?? ""
                            
                            let chat = Chat(
                                id: chatId,
                                otherUserName: name,
                                otherUserImageUrl: imageUrl,
                                lastMessage: lastMessage,
                                timestamp: timestamp
                            )
                            tempChats.append(chat)
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self?.chats = tempChats.sorted(by: { $0.timestamp > $1.timestamp })
                }
            }
    }
}

