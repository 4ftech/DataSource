//
//  FetchConditions.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/23/17.
//  Copyright © 2017 4f Tech. All rights reserved.
//

import Foundation
import CoreLocation


public class GeoBox: NSObject {
  public var ne: CLLocationCoordinate2D!
  public var sw: CLLocationCoordinate2D!
  
  public init(ne: CLLocationCoordinate2D, sw: CLLocationCoordinate2D) {
    super.init()
    
    self.ne = ne
    self.sw = sw
  }
}


public enum FetchQueryCondition: String {
  case exists, notEqualTo, lessThan, lessThanOrEqualTo, greaterThan, greaterThanOrEqualTo, containedIn, notContainedIn, containsAll, regex, nearCoordinates, withinGeoBox
}

public enum FetchQueryOption: String {
  case regexOption, distanceOption
}

public class FetchConditions {
  var conditions: [String:Any] = [:]
  
  public init() {
    
  }
  
  public func whereKeyExists(_ key: String) {
    self.whereKey(key, condition: .exists, object: true)
  }

  public func whereKeyDoesNotExist(_ key: String) {
    self.whereKey(key, condition: .exists, object: false)
  }

  public func whereKey(_ key: String, equalTo object: Any) {
    self.conditions[key] = object
  }
  
  public func whereKey(_ key: String, greaterThan object: Any) {
    self.whereKey(key, condition: .greaterThan, object: object)
  }
  
  public func whereKey(_ key: String, greaterThanOrEqualTo object: Any) {
    self.whereKey(key, condition: .greaterThanOrEqualTo, object: object)
  }
  
  public func whereKey(_ key: String, lessThan object: Any) {
    self.whereKey(key, condition: .lessThan, object: object)
  }
  
  public func whereKey(_ key: String, lessThanOrEqualTo object: Any) {
    self.whereKey(key, condition: .lessThanOrEqualTo, object: object)
  }
  
  public func whereKey(_ key: String, notEqualTo object: Any) {
    self.whereKey(key, condition: .notEqualTo, object: object)
  }
  
  public func whereKey(_ key: String, containedIn object: [Any]) {
    self.whereKey(key, condition: .containedIn, object: object)
  }
  
  public func whereKey(_ key: String, notContainedIn object: [Any]) {
    self.whereKey(key, condition: .notContainedIn, object: object)
  }
  
  public func whereKey(_ key: String, containsAllObjectsInArray object: [Any]) {
    self.whereKey(key, condition: .containsAll, object: object)
  }
  
  public func whereKey(_ key: String, matchesRegex regex: String, modifiers: Any? = nil) {
    self.whereKey(key, condition: .regex, object: regex)
    
    if let modifiers = modifiers {
      self.whereKey(key, option: .regexOption, object: modifiers)
    }
  }
  
  public func whereKey(_ key: String, nearCoordinates coordinates: CLLocationCoordinate2D, distance: Double? = nil) {
    self.whereKey(key, condition: .nearCoordinates, object: coordinates)
    
    if let distance = distance {
      self.whereKey(key, option: .distanceOption, object: distance)
    }
  }
  
  public func whereKey(_ key: String, withinGeoBox geoBox: GeoBox) {
    self.whereKey(key, condition: .withinGeoBox, object: geoBox)
  }
  
  // MARK: Internal
  private func whereKey(_ key: String, condition: FetchQueryCondition, object: Any) {
    var conditionObject: [String:Any] = [:]
    
    if let existingConditions = conditions[key] as? [String:Any] {
      conditionObject = existingConditions
    }
    
    conditionObject[condition.rawValue] = object
    
    self.conditions[key] = conditionObject
  }
  
  private func whereKey(_ key: String, option: FetchQueryOption, object: Any) {
    var conditionObject: [String:Any] = [:]
    
    if let existingConditions = conditions[key] as? [String:Any] {
      conditionObject = existingConditions
    }
    
    conditionObject[option.rawValue] = object
    
    self.conditions[key] = conditionObject
  }
}
