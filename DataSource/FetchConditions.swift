//
//  FetchConditions.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/23/17.
//  Copyright © 2017 4f Tech. All rights reserved.
//

import Foundation
import CoreLocation

public enum FetchQueryCondition: String {
  case notEqualTo, lessThan, lessThanOrEqualTo, greaterThan, greaterThanOrEqualTo, containedIn, notContainedIn, containsAll, regex, nearCoordinates
}

public enum FetchQueryOption: String {
  case regexOption
}

public class FetchConditions {
  var conditions: [String:Any] = [:]
  
  public init() {
    
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
  
  public func whereKey(_ key: String, matchesRegex regex: String, modifiers: String? = nil) {
    self.whereKey(key, condition: .regex, object: regex)
    
    if let modifiers = modifiers {
      self.whereKey(key, option: .regexOption, object: modifiers)
    }
  }
  
  public func whereKey(_ key: String, nearCoordinates coordinates: CLLocationCoordinate2D) {
    self.whereKey(key, condition: .nearCoordinates, object: coordinates)
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
