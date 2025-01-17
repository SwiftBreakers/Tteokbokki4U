//
//  Constants.swift
//  TteoPpoKki4U
//
//  Created by Dongik Song on 6/8/24.
//

import Foundation
import FirebaseFirestore

let reviewCollection = Firestore.firestore().collection("UserReview")

let db_uid = "uid"
let db_storeAddress = "storeAddress" // 표준 신 주소
let db_title = "title"
let db_nickName = "nickName"
let db_email = "email"
let db_isBlock = "isBlock"
let db_profileImageUrl = "profileImageUrl"
let db_user_profile = "profile"
let db_user_users = "users"
let db_storeName = "storeName"
let db_content = "content"
let db_rating = "rating"
let db_imageURL = "imageURL"
let db_isActive = "isActive"
let db_createdAt = "createdAt"
let db_updatedAt = "updatedAt"
let db_reportCount = "reportCount"
let db_isAgree = "isAgree"

let scrappedCollection = Firestore.firestore().collection("Scrapped")
let db_shopName = "shopName"
let db_shopAddress = "shopAddress"

//0613 moremirim 임의 추가 변경 가능
let bookmarkedCollection = Firestore.firestore().collection("Bookmarked")

let reportCollection = Firestore.firestore().collection("report")
let db_isRelated = "isRelated"
let db_isCommercial = "isCommercial"
let db_isPrivacy = "isPrivacy"
let db_isIllegal = "isIllegal"
let db_isSpam = "isSpam"
let db_isSexual = "isSexual"
let db_isEtc = "isEtc"
let db_reportedUID = "reportedUID"

let channelCollection = Firestore.firestore().collection("channels")
let db_channelName = "name"
let db_channel = "channel"
let db_thread = "thread"
let db_senderId = "senderId"
let db_messageContent = "content"

let threadCollection = Firestore.firestore().collection("thread")
let chatReportCollection = Firestore.firestore().collection("chatReport")

let db_chatReportCount = "chatReportCount"
let blockCollection = Firestore.firestore().collection("UserBlock")
let db_myUid = "myUid"
let db_blockSenderNames = "blockSenderNames"
let db_url = "url"

let noticeCollection = Firestore.firestore().collection("notice")
let db_date = "date"
let db_detail = "detail"

let recommendCollection = Firestore.firestore().collection("recommendMain")
let db_description = "description"
