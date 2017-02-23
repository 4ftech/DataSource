//
//  FetchConditions.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/23/17.
//  Copyright © 2017 Oinkist. All rights reserved.
//

import Foundation

public enum FetchQueryCondition {
  case notEqualTo, lessThan, lessThanOrEqualTo, greaterThan, greaterThanOrEqualTo, containedIn, notContainedIn, containsAll
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
  
  
  // MARK: Internal
  private func whereKey(_ key: String, condition: FetchQueryCondition, object: Any) {
    var conditionObject: [FetchQueryCondition:Any] = [:]
    
    if let existingConditions = conditions[key] as? [FetchQueryCondition:Any] {
      conditionObject = existingConditions
    }
    
    conditionObject[condition] = object
    
    self.conditions[key] = conditionObject
  }
}
