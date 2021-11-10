//
//  RealmModel.swift
//  Assignment2
//
//  Created by 신상원 on 2021/11/09.
//

import Foundation
import RealmSwift

class UserMemo: Object {
    
    //@Persisted var memoPin: Bool
    @Persisted var memoTitle: String?
    @Persisted var memoDate: Date?
    @Persisted var memoContent: String?
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(memoTitle: String?, memoDate: Date?, memoContent: String?) {
        self.init()
        //self.memoPin = memoPin
        self.memoTitle = memoTitle
        self.memoDate = memoDate
        self.memoContent = memoContent
    }
    
}

class UserPinMemo: Object {
    
    //@Persisted var memoPin: Bool
    @Persisted var memoTitle: String?
    @Persisted var memoDate: Date?
    @Persisted var memoContent: String?
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(memoTitle: String?, memoDate: Date?, memoContent: String?) {
        self.init()
        //self.memoPin = memoPin
        self.memoTitle = memoTitle
        self.memoDate = memoDate
        self.memoContent = memoContent
    }
    
}
