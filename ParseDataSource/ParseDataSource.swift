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

open class ParseDataModel: PFObject, BaseDataModel {
  public typealias DataSourceType = ParseDataSource
  
  public override required init() {
    super.init()
  }


}

public class ParseDataSource: DataSource {
  public static func query<T>(forRequest request: FetchRequest, ofObjectType objectType: T.Type) -> PFQuery<PFObject> where T:ParseDataModel {
    let query = objectType.query()!
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
    
    if let limit = request.limit {
      query.limit = limit
    }
    
    if let offset = request.offset {
      query.skip = offset
    }
    
    query.order(by: request.sortDescriptors)
    
    return query
  }
  
  open override class func fetch<T>(request: FetchRequest) -> Promise<[T]> where T:ParseDataModel {
    let query = self.query(forRequest: request, ofObjectType: T.self)
    
    return Promise<[T]> { (fulfill: @escaping ([T]) -> Void, reject) in
      query.findObjectsInBackground() { (results, error) in
        if let error = error {
          reject(error)
        } else {
          fulfill(results?.map { $0 as! T } ?? [])
        }
      }
    }
  }
  
  open override class func getById<T>(id: String) -> Promise<T?> where T:ParseDataModel {
    let query = T.query()!

    return Promise<T?> { (fulfill: @escaping (T?) -> Void, reject) in
      query.getObjectInBackground(withId: id) { (result, error) in
        if let error = error {
          reject(error)
        } else {
          fulfill(result as? T)
        }
      }
    }
  }

  open override class func save<T>(item: T) -> Promise<T> where T: ParseDataModel {
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

  open override class func delete<T>(item: T) -> Promise<Bool> where T: ParseDataModel {
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

