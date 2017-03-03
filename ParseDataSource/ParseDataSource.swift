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
  public static var sharedDataSource: DataSource = ParseDataSource()

  open var name: String? {
    get {
      return self["name"] as? String
    }
    set {
      self["name"] = newValue
    }
  }
  
  public override required init() {
    super.init()
  }
  
  open class var includeKeys: [String:ParseDataModel.Type] {
    return [:]
  }

  open override class func query() -> PFQuery<PFObject>? {
    let q = super.query()
    includeKeysInQuery(q)
    return q
  }
  
  class func includeKeysInQuery(_ query: PFQuery<PFObject>?) {
    includeKeysInQuery(query, withPrefix: nil)
  }
  
  class func includeKeysInQuery(_ query: PFQuery<PFObject>?, withPrefix prefix: String?) {
    for (key, type) in includeKeys {
      var k: String = key
      if let p: String = prefix {
        k = "\(p).\(key)"
      }
      
      query?.includeKey(k)
      type.includeKeysInQuery(query, withPrefix: k)
    }
  }
}

public class ParseDataSource: DataSource {
  public required init() {
    
  }
  
  public func query<T>(forRequest request: FetchRequest? = nil, ofObjectType objectType: T.Type) -> PFQuery<PFObject> where T:ParseDataModel {
    let query = objectType.query()!
    
    if let request = request {
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
            case .regex:
              query.whereKey(key, matchesRegex: object as! String, modifiers: conditionObject[.regexOptions] as? String)
            case .regexOptions: break
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
    }
    
    return query
  }
  
  open func fetch<T>(request: FetchRequest) -> Promise<[T]> {
    let query = self.query(forRequest: request, ofObjectType: T.self as! ParseDataModel.Type)
    
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
  
  open func getById<T>(id: String) -> Promise<T?> {
    let query = self.query(ofObjectType: T.self as! ParseDataModel.Type)

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

  open func save<T>(item: T) -> Promise<T> {
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

  open func delete<T>(item: T) -> Promise<Bool> {
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

