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
  public static var primaryKey: String? {
    return "objectId"
  }
  
  public static func fetch<T>(request: FetchRequest) -> Promise<[T]> {
    let query = (T.self as! PFObject.Type).query()!
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
    
    query.limit = request.limit
    query.skip = request.offset
    query.order(by: request.sortDescriptors)
    return Promise<[T]> { (fulfill: @escaping ([T]) -> Void, reject) in
      query.findObjectsInBackground() { (results, error) in
        if let error = error {
          reject(error)
        } else {
          var tArray: [T] = []
          if let results: [PFObject] = results {
            for result in results {
              tArray.append(result as! T)
            }
          }
          fulfill(tArray)
        }
      }
    }
  }

  public static func save<T>(item: T) -> Promise<T> {
    return Promise { fulfill, reject in
      (item as! ParseDataModel).saveInBackground() { (success, error) in
        if let error = error {
          reject(error)
        } else {
          fulfill(item)
        }
      }
    }
  }

  public static func delete<T>(item: T) -> Promise<Bool> {
    return Promise { fulfill, reject in
      (item as! ParseDataModel).deleteInBackground() { (success, error) in
        if let error = error {
          reject(error)
        } else {
          fulfill(success)
        }
      }
    }
  }
}

