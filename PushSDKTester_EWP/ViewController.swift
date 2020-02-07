//
//  ViewController.swift
//  PushSDKTester_EWP
//
//  Created by  sparrow on 2019/11/08.
//  Copyright © 2019  sparrow. All rights reserved.
//

import UIKit
import PushSDK_EWP

class ViewController: UIViewController, UITextFieldDelegate {
    
    var id: String?
    var ip: String?
    var port: Int?
    var chunkIdx: Int?
    var count: Int?
    var msgType: PushSDK_EWP.MessageType?
    var msgId: String?
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var ipTextField: UITextField!
    
    @IBOutlet weak var portTextField: UITextField!
    
    @IBOutlet weak var chunkIndexTextField: UITextField!
    
    @IBOutlet weak var countTextField: UITextField!
    
    @IBOutlet weak var messageIdTextField: UITextField!
    
    @IBOutlet weak var msgTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var logTextView: UITextView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var pushsdk : PushSDK_EWP?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        pushsdk = PushSDK_EWP()
        pushsdk?.pushapiSetLogEnabled(on: true)

        titleLabel.text = Constants.appTitle
        idTextField.text = Constants.defaultID
        ipTextField.text = Constants.ip
        portTextField.text = Constants.port
        messageIdTextField.text = Constants.messageId
        
        textFieldAssign()
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushMessageReceive(_:)), name: NSNotification.Name("PushMessageReceive"), object: nil)
    }
    
    @objc func pushMessageReceive(_ notification: Notification) {
        if let data = notification.userInfo as? [String:Int] {
            for (msgId, msgType) in data {
                
                if msgType == 0 {
                    msgTypeSegmentedControl.selectedSegmentIndex = 0
                    self.msgType = PushSDK_EWP.MessageType.messageTypeCommon
                } else {
                    msgTypeSegmentedControl.selectedSegmentIndex = 1
                    self.msgType = PushSDK_EWP.MessageType.messageTypeNotice
                }
                
                self.msgId = msgId
                messageIdTextField.text = msgId
                self.appendLogTextView("msgtype=\(String(describing: self.msgType))")
                self.appendLogTextView("msgId=\(msgId)")
            }
            self.messageInfoClick(self)
        }
    }
    
    fileprivate func textFieldAssign() {
        id = idTextField.text
        ip = ipTextField.text
        port = Int(portTextField.text ?? "0")
        chunkIdx = Int(chunkIndexTextField.text ?? "0")
        count = Int(countTextField.text ?? "0")
        msgId = messageIdTextField.text
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
        textFieldAssign()
    }
    
    fileprivate func appendLogTextView(_ log: String) {
        let log = log + "\n"
        print(log)
        logTextView.text = logTextView.text.appending(log)
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        if msgTypeSegmentedControl.selectedSegmentIndex == 0 {
            msgType = PushSDK_EWP.MessageType.messageTypeCommon
        } else {
            msgType = PushSDK_EWP.MessageType.messageTypeNotice
        }
    }
    
    @IBAction func createClick(_ sender: Any) {
        let res = pushsdk?.pushapiCreate(
            appId: Constants.appid,
            deviceId: id ?? "",
            serverIP: ip ?? "",
            serverPort: port ?? 0)
        
        appendLogTextView("pushapiCreate : \(String(describing: res))")
    }
    
    @IBAction func registrationClick(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let fcmToken = appDelegate.fcmToken {
            let res = pushsdk?.pushapiReqRegistraton(
                authKey: Constants.authKey,
                regId: fcmToken,
                callback: { (error) in
                    DispatchQueue.main.async {
                        self.appendLogTextView("pushapiReqRegistraton errorcode : \(error)")
                    }
            })
            appendLogTextView("pushapiReqRegistraton res : \(String(describing: res))")
            appendLogTextView("fcmToken : \(fcmToken)")
        } else {
            appendLogTextView("pushapiReqRegistraton fcmToken nil)")
        }
    }
    
    @IBAction func messageInfoClick(_ sender: Any) {
        let res = pushsdk?.pushapiReqPushMessageInfo(
            msgType: msgType ?? PushSDK_EWP.MessageType.messageTypeCommon,
            msgId: msgId!,
            callback: { (error, msgtype, msgInfo) in
                DispatchQueue.main.async {
                    let msg = msgInfo
                    
                    self.appendLogTextView("error=\(error)")
                    self.appendLogTextView("msgtype=\(msgtype)")
                    self.appendLogTextView("id=\(msg.id)")
                    self.appendLogTextView("labelCode=\(msg.labelCode)")
                    self.appendLogTextView("readStatus=\(msg.readStatus)")
                    self.appendLogTextView("date=\(msg.date)")
                    self.appendLogTextView("title=\(msg.title)")
                    self.appendLogTextView("content=\(msg.content)")
                }
        })
        self.appendLogTextView("pushapiReqPushMessageInfo res \(String(describing: res))")
    }
    
    @IBAction func countClick(_ sender: Any) {
        let res = pushsdk?.pushapiReqMessageCount(
            callback: { (error, commonCount, noticeCount) in
                DispatchQueue.main.async {
                    self.appendLogTextView("pushapiReqMessageCount error \(error)")
                    self.appendLogTextView("pushapiReqMessageCount commonCount \(commonCount)")
                    self.appendLogTextView("pushapiReqMessageCount noticeCount \(noticeCount)")
                }
        })
        self.appendLogTextView("pushapiReqMessageCount res \(String(describing: res))")
    }
    
    @IBAction func listClick(_ sender: Any) {
        let res = pushsdk?.pushapiReqMessageList(
            msgType: msgType ?? PushSDK_EWP.MessageType.messageTypeCommon,
            chunkIndex: chunkIdx ?? 0,
            count: count ?? 0,
            callback: { (error, msgType, chunkIndex, count, msgArray) in
                DispatchQueue.main.async {
                    self.appendLogTextView("error=\(error)")
                    self.appendLogTextView("msgType=\(msgType)")
                    self.appendLogTextView("chunkIndex=\(chunkIndex)")
                    self.appendLogTextView("count=\(count)")
                    for msg in msgArray {
                        self.appendLogTextView("id=\(msg.id)")
                        self.appendLogTextView("labelCode=\(msg.labelCode)")
                        self.appendLogTextView("readStatus=\(msg.readStatus)")
                        self.appendLogTextView("date=\(msg.date)")
                        self.appendLogTextView("title=\(msg.title)")
                        self.appendLogTextView("content=\(msg.content)")
                    }
                }
        })
        self.appendLogTextView("pushapiReqMessageList res \(String(describing: res))")
    }
    
    @IBAction func readClick(_ sender: Any) {
        let res = pushsdk?.pushapiReqMessageRead(
            msgType: msgType ?? PushSDK_EWP.MessageType.messageTypeCommon,
            msgId: msgId!,
            callback: { (error, msgType, msgId) in
                DispatchQueue.main.async {
                    self.appendLogTextView("error=\(error)")
                    self.appendLogTextView("msgType=\(msgType)")
                    self.appendLogTextView("msgId=\(msgId)")
                }
        })
        self.appendLogTextView("pushapiReqMessageRead res \(String(describing: res))")
    }
    
    @IBAction func noticeDeleteClick(_ sender: Any) {
        let res = pushsdk?.pushapiReqNoticeDelete(
            msgId: msgId!,
            callback: { (error, msgId) in
                DispatchQueue.main.async {
                    self.appendLogTextView("error=\(error)")
                    self.appendLogTextView("msgId=\(msgId)")
                }
        })
        self.appendLogTextView("pushapiReqNoticeDelete res \(String(describing: res))")
    }
    
    @IBAction func versionClick(_ sender: Any) {
        let res = pushsdk?.pushapiVersion()
        appendLogTextView("pushapiVersion=\(String(describing: res))")
    }
    
    @IBAction func clearLogButtonClick(_ sender: Any) {
        logTextView.text = ""
    }
}

