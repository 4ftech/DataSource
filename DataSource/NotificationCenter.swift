//
//  NotificationCenter.swift
//  CollectionLoader
//
//  Created by Nick Kuyakanon on 2/17/17.
//  Copyright © 2017 Oinkist. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa

public enum CRUDType: String {
  case Create = "create", Update = "update", Delete = "delete"
}

public enum CRUDUserInfoKeys: String {
  case NotificationType = "notificationType", Object = "object", ObjectIndex = "index"
}

public extension NotificationCenter {
  func crudNotificationName(_ objectClassName: String) -> String {
    return "com.oinkist.CollectionLoader.CRUDNotification.\(objectClassName)"
  }
  
  func postCRUDNotification<T: BaseDataModel>(_ notificationType: CRUDType, crudObject: T, senderObject: AnyObject? = nil) {
    let name = crudNotificationName(String(describing: type(of: crudObject)))
    NSLog("Posted for: \(name)")
    let userInfo: [String:Any] = [
      CRUDUserInfoKeys.NotificationType.rawValue: notificationType.rawValue,
      CRUDUserInfoKeys.Object.rawValue: crudObject
    ]
    
    post(name: Notification.Name(rawValue: name), object: senderObject, userInfo: userInfo)
  }
  
  func registerForCRUDNotification(_ objectClassName: String, senderObject: AnyObject? = nil) -> Observable<Notification> {
    let name = crudNotificationName(objectClassName)
    NSLog("Registering for: \(name)")
    return rx.notification(Notification.Name(rawValue: name), object: senderObject)
  }
  
}

public extension Notification {
  var crudObject: Any {
    return userInfo![CRUDUserInfoKeys.Object.rawValue]!
  }
  
  var crudObjectIndex: Int? {
    return userInfo![CRUDUserInfoKeys.ObjectIndex.rawValue] as? Int
  }
  
  
  var crudNotificationType: CRUDType {
    return CRUDType(rawValue: userInfo![CRUDUserInfoKeys.NotificationType.rawValue] as! String)!
  }
}
