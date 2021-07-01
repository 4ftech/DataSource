//
//  NotificationCenter.swift
//  CollectionLoader
//
//  Created by Nick Kuyakanon on 2/17/17.
//  Copyright © 2017 4f Tech. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa

import ObjectMapperDataSource

public enum CRUDType: String {
  case create = "create", update = "update", delete = "delete"
}

public enum CRUDUserInfoKeys: String {
  case notificationType = "notificationType", object = "object", objectIndex = "index"
}

public extension NotificationCenter {
  static func crudNotificationName(_ objectClassName: String) -> NSNotification.Name {
    return Notification.Name(rawValue: "co.bukapp.DataSource.CRUDNotification.\(objectClassName)")
  }

  static func UINotificationName(_ objectClassName: String) -> NSNotification.Name {
    return Notification.Name(rawValue: "co.bukapp.DataSource.UINotification.\(objectClassName)")
  }

  
  func postCRUDNotification(_ notificationType: CRUDType, objectClassName: String, senderObject: AnyObject? = nil) {
    let name = NotificationCenter.crudNotificationName(objectClassName)
    NSLog("Posted for: \(name)")
    let userInfo: [String:Any] = [
      CRUDUserInfoKeys.notificationType.rawValue: notificationType.rawValue,
    ]
    
    post(name: name, object: senderObject, userInfo: userInfo)
  }
  
  func postCRUDNotification<T: ObjectMapperDataModel>(_ notificationType: CRUDType, crudObject: T, objectClassName: String? = nil, senderObject: AnyObject? = nil) {
    let name = NotificationCenter.crudNotificationName(objectClassName ?? String(describing: type(of: crudObject)))
    NSLog("Posted for: \(name)")
    let userInfo: [String:Any] = [
      CRUDUserInfoKeys.notificationType.rawValue: notificationType.rawValue,
      CRUDUserInfoKeys.object.rawValue: crudObject
    ]
    
    post(name: name, object: senderObject, userInfo: userInfo)
  }
  
  func registerForCRUDNotification(_ objectClassName: String, senderObject: AnyObject? = nil) -> Observable<Notification> {
    let name = NotificationCenter.crudNotificationName(objectClassName)
    //    NSLog("Registering for: \(name)")
    return rx.notification(name, object: senderObject)
  }
  
}

public extension Notification {
  var crudObject: Any? {
    return userInfo![CRUDUserInfoKeys.object.rawValue]
  }
  
  var crudObjectIndex: Int? {
    return userInfo![CRUDUserInfoKeys.objectIndex.rawValue] as? Int
  }
  
  
  var crudNotificationType: CRUDType {
    return CRUDType(rawValue: userInfo![CRUDUserInfoKeys.notificationType.rawValue] as! String)!
  }
}
