//
//  Chat.swift
//  QuickChat
//
//  Created by yash bobade on 21/05/25.
//

import Foundation

struct Chat: Identifiable {
    var id: String              // chat document ID
    var otherUserName: String  // name of the person you're chatting with
    var otherUserImageUrl: String // URL for their profile image
    var lastMessage: String
    var timestamp: Date
}
