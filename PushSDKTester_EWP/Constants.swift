//
//  Constanst.swift
//  PushSDKTester_EWP
//
//  Created by  sparrow on 2019/12/28.
//  Copyright © 2019  sparrow. All rights reserved.
//

import Foundation

public class Constants {
    #if DISASTER
        static let appid = "iotisys.pushsdk.iostester-disaster"
        static let authKey = "AIzaSyAxqkccCWq_mX8jbJqj0iDSbnKULY5oJnI"
    
        static let defaultID = "16170020"
        static let ip = "211.169.61.10"
        static let port = "7101"
        static let messageId = "1190515140037014858666"
    
        static let appTitle = "재난"
    #else
        static let appid = "iotisys.pushsdk.iostester"
        static let authKey = "AIzaSyAxqkccCWq_mX8jbJqj0iDSbnKULY5oJnI"
    
        static let defaultID = "16170020"
        static let ip = "211.169.61.10"
        static let port = "7101"
        static let messageId = "1190515140037014858666"
    
    static let appTitle = "오피스"
    #endif
}
