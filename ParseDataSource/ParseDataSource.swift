//
//  ParseDataSource.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/23/17.
//  Copyright © 2017 4f Tech. All rights reserved.
//

import Foundation
import DataSource
import PromiseKit
import Parse

public class ParseDataSource: DataSource {
  public required init() {
    
  }
  
  public func query<T>(forRequest request: FetchRequest? = nil, ofObjectType objectType: T.Type) -> PFQuery<PFObject> where T:ParseDataModel {
    let query = objectType.query()!
    
    if let request = request {
      for (key, object) in request.conditions {
        if let conditionObject = object as? [String:Any] {
          for (condition, object) in conditionObject {
            if let condition = FetchQueryCondition(rawValue: condition) {
              switch condition {
              case .exists:
                if object as! Bool {
                  query.whereKeyExists(key)
                } else {
                  query.whereKeyDoesNotExist(key)
                }
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
                let modifiers = conditionObject[FetchQueryOption.regexOption.rawValue] as? String
                query.whereKey(key, matchesRegex: object as! String, modifiers: modifiers)
              case .nearCoordinates:
                let coordinates = object as! CLLocationCoordinate2D
                let distance = conditionObject[FetchQueryOption.distanceOption.rawValue] as? Double
                query.whereKey(key, nearGeoPoint: PFGeoPoint(latitude: coordinates.latitude, longitude: coordinates.longitude), withinMiles: distance ?? 5)
              case .withinGeoBox:
                let geoBox = object as! GeoBox
                query.whereKey(
                  key,
                  withinGeoBoxFromSouthwest: PFGeoPoint(latitude: geoBox.sw.latitude, longitude: geoBox.sw.longitude),
                  toNortheast: PFGeoPoint(latitude: geoBox.ne.latitude, longitude: geoBox.ne.longitude)
                )
              }
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
  
  open func promise<T>(forQuery query: PFQuery<PFObject>) -> Promise<[T]> {
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
  
  open func fetch<T>(request: FetchRequest) -> Promise<[T]> {
    let query = self.query(forRequest: request, ofObjectType: T.self as! ParseDataModel.Type)
    
    return promise(forQuery: query)
  }

  open func fetch<T, U>(request: FetchRequest, forParentObject parentObject: U) -> Promise<[T]> {
    let query = self.query(forRequest: request, ofObjectType: T.self as! ParseDataModel.Type)
    
    if let parentObject = parentObject as? PFObject {
      query.whereKey(parentObject.parseClassName.lowercased(), equalTo: parentObject)
    }
    
    return promise(forQuery: query)
  }

  
  open func getById<T>(id: String) -> Promise<T> {
    let query = self.query(ofObjectType: T.self as! ParseDataModel.Type)

    return Promise<T> { (fulfill: @escaping (T) -> Void, reject) in
      query.getObjectInBackground(withId: id) { (result, error) in
        if let result = result as? T {
          fulfill(result)
        } else if let error = error {
          reject(error)
        } else {
          reject(NSError(domain: PFParseErrorDomain, code: PFErrorCode.errorInternalServer.rawValue, userInfo: nil))
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
  
  open func save<T, U>(item: T, forParentObject parentObject: U) -> Promise<T> {
    if let parseObject = item as? PFObject, let parentObject = parentObject as? PFObject {
      parseObject[parentObject.parseClassName.lowercased()] = parentObject
    }
    
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

  open func delete<T>(item: T) -> Promise<Void> {
    return Promise { fulfill, reject in
      (item as! ParseDataModel).deleteInBackground() { (success, error) in
        if let error = error {
          reject(error)
        } else {
          fulfill(())
        }
      }
    }
  }
}

