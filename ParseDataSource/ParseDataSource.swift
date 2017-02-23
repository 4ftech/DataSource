//
//  ParseDataSource.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/23/17.
//  Copyright © 2017 Oinkist. All rights reserved.
//

import Foundation
import DataSource
import PromiseKit
import Parse

open class ParseDataModel<Subclass>: PFObject, BaseDataModel where Subclass: PFObject, Subclass: PFSubclassing {
  public typealias T = ParseDataSource<Subclass>
  
  public var id: String? {
    get {
      return self.objectId
    }
    set {
      self.objectId = newValue
    }
  }
  
  override required public init() {
    super.init()
  }
}

public final class ParseDataSource<T>: DataSource where T: PFObject, T: PFSubclassing {    
  public static var primaryKey: String? {
    return "objectId"
  }
  
  public static func fetch(request: FetchRequest<ParseDataSource<T>>) -> Promise<[T]> {
    let query = T.query()!
    for (key, object) in request.conditions {
      if let conditionObject = object as? [FetchQueryCondition:Any] {
        for (condition, object) in conditionObject {
          switch condition {
          case .notEqualTo:
            query.whereKey(key, notEqualTo: object)
          case .greaterThan:
            query.whereKey(key, greaterThan: object)
          case .greaterThanOrEqualTo:
            query.whereKey(key, greaterThanOrEqualTo: object)
          case .lessThan:
            query.whereKey(key, lessThan: object)
          case .lessThanOrEqualTo:
            query.whereKey(key, lessThanOrEqualTo: object)
          case .containedIn:
            query.whereKey(key, containedIn: object as! [Any])
          case .containsAll:
            query.whereKey(key, containsAllObjectsIn: object as! [Any])
          case .notContainedIn:
            query.whereKey(key, notContainedIn: object as! [Any])
          }
        }
      } else {
        query.whereKey(key, equalTo: object)
      }
    }
    
    return Promise { fulfill, reject in
      query.findObjectsInBackground() { (results, error) in
        if let error = error {
          reject(error)
        } else {
          fulfill(results as? [T] ?? [])
        }
      }
    }
  }

  public static func save(item: T) -> Promise<T> {
    return Promise { fulfill, reject in
      item.saveInBackground() { (success, error) in
        if let error = error {
          reject(error)
        } else {
          fulfill(item)
        }
      }
    }
  }

  public static func delete(item: T) -> Promise<Bool> {
    return Promise { fulfill, reject in
      item.deleteInBackground() { (success, error) in
        if let error = error {
          reject(error)
        } else {
          fulfill(success)
        }
      }
    }
  }
}

