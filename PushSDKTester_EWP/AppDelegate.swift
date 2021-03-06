//
//  AppDelegate.swift
//  PushSDKTester_EWP
//
//  Created by  sparrow on 2019/11/08.
//  Copyright © 2019  sparrow. All rights reserved.
//

import UIKit
import Firebase

//import PushSDK_EWP


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let gcmMessageIDKey = "gcm.message_id"
    var fcmToken : String?

//    var pushsdk : PushSDK_EWP?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if DISASTER
            let filePath = Bundle.main.path(forResource: "GoogleService-Info-dis", ofType: "plist")!
            let options = FirebaseOptions(contentsOfFile: filePath)
            FirebaseApp.configure(options: options!)
        #else
            let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
            let options = FirebaseOptions(contentsOfFile: filePath)
            FirebaseApp.configure(options: options!)
        #endif
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        #if DISASTER
            print("DISASTER APPS")
        #endif

        // [END register_for_notifications]

// SDK 초기화
//        pushsdk = PushSDK_EWP()
//        //_ = pushsdk?.pushapiCreate(appId: "iotisys.pushsdk.iostester", deviceId: "4")
//        _ = pushsdk?.pushapiCreate(appId: "iotisys.pushsdk.iostester", deviceId: "4", serverIP: "1.2.3.4", serverPort: 1234)

        return true
    }
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("APNs token retrieved: \(deviceToken)")

      // With swizzling disabled you must set the APNs token here.
      // Messaging.messaging().apnsToken = deviceToken
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)
    
    print(userInfo)
    
    print(userInfo["msgId"] as Any)
    print(userInfo["msgType"] as Any)
    
    let data : [String:Int] = [userInfo["msgId"] as! String: Int(userInfo["msgType"] as! String)!]
    
    NotificationCenter.default.post(name: Notification.Name("PushMessageReceive"), object: nil, userInfo: data)


    // Change this to your preferred presentation option
    //completionHandler([])
    completionHandler([.alert, .badge, .sound])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)
    
    print(userInfo["msgId"] as Any)
    print(userInfo["msgType"] as Any)
    
    let data : [String:Int] = [userInfo["msgId"] as! String: Int(userInfo["msgType"] as! String)!]
    
    NotificationCenter.default.post(name: Notification.Name("PushMessageReceive"), object: nil, userInfo: data)
    
    completionHandler()
  }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
    
    let dataDict:[String: String] = ["token": fcmToken]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    
// fcmToken 으로 pushapiReqRegistration을 수행한다.
//    _ = pushsdk?.pushapiReqRegistraton(regId: fcmToken, callback: { (error) in
//        print(error)
//    })
    self.fcmToken = fcmToken
    
  }
  // [END refresh_token]
  // [START ios_10_data_message]
  // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
  // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    print("Received data message: \(remoteMessage.appData)")
  }
  // [END ios_10_data_message]
}

/*
 curl -X POST --header "Authorization:key=AAAApN-Gwy4:APA91bEBZdIhl3pdO4xPzIM3aVAiCh-Nbex9mjIVAkXwExChcKedgKEFjqyGTzGePWFsrP_w582nhUEa_zUgezB0XY71kFF046l8cXnrclq1qMCiGo4EFBlhRUm8sPCmOT1THaCaP21_" --header "Content-Type:application/json" https://fcm.googleapis.com/fcm/send -d '{
     "notification": {
         "title": "HELLO",
         "body": "WORLD"
     },
     "data": {
         "msgType": "0",
         "msgId":"1190515132700800709930"
 
     },
     "to": "cQCLyG-ZOL0:APA91bEqu3mWebW9_0N3UUi9ULcwbQkrojufemaSezffueB6Ao2Zy3Z-z82BZjhWxZMKgr9h_i1kBDDJIZAXn85wi4Mb9FJQV9g6hh-xOxpxba9YDsCQbcfcde0zNFpa-pCrwUn0YlZ3"
 }'
 
 curl -X POST --header "Authorization:key=AAAApN-Gwy4:APA91bEBZdIhl3pdO4xPzIM3aVAiCh-Nbex9mjIVAkXwExChcKedgKEFjqyGTzGePWFsrP_w582nhUEa_zUgezB0XY71kFF046l8cXnrclq1qMCiGo4EFBlhRUm8sPCmOT1THaCaP21_" --header "Content-Type:application/json" https://fcm.googleapis.com/fcm/send -d '{
     "notification": {
         "title": "HELLO",
         "body": "WORLD"
     },
     "data": {
         "msgType": "0",
         "msgId":"1190515132700800709930"
 
     },
     "to": "euLeiuKKvLI:APA91bG494MqDUDJbKMrjmyc-oPM_sC7WhM4PJuRyUef5L0RA4oKDb1ixYAciAh38nkozsDEDcHE35kVhWq9t4I2FdcJqFR8QTMHW_N9SwmoMC1LBU8G0lTTKrV9cAlZYKrlpS6YX2MX"
 }'
 */
