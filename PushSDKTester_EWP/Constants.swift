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
        static let authKey = "AAAApN-Gwy4:APA91bEBZdIhl3pdO4xPzIM3aVAiCh-Nbex9mjIVAkXwExChcKedgKEFjqyGTzGePWFsrP_w582nhUEa_zUgezB0XY71kFF046l8cXnrclq1qMCiGo4EFBlhRUm8sPCmOT1THaCaP21_"
    
        static let defaultID = "16170020"
        static let ip = "211.169.61.10"
        static let port = "7101"
        static let messageId = "1190515140037014858666"
    
        static let appTitle = "재난"
    #else
        static let appid = "iotisys.pushsdk.iostester"
        static let authKey = "AAAApN-Gwy4:APA91bEBZdIhl3pdO4xPzIM3aVAiCh-Nbex9mjIVAkXwExChcKedgKEFjqyGTzGePWFsrP_w582nhUEa_zUgezB0XY71kFF046l8cXnrclq1qMCiGo4EFBlhRUm8sPCmOT1THaCaP21_"
    
        static let defaultID = "16170020"
        static let ip = "211.169.61.10"
        static let port = "7101"
        static let messageId = "1190515140037014858666"
    
    static let appTitle = "오피스"
    #endif
}
