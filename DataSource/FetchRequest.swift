//
//  FetchRequest.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/28/17.
//  Copyright © 2017 Oinkist. All rights reserved.
//

import Foundation
import PromiseKit

public class FetchRequest {
  public var offset: Int?
  public var limit: Int?
  
  var fetchConditions: FetchConditions = FetchConditions()
  
  public var sortDescriptors: [NSSortDescriptor] = []
  public var conditions: [String:Any] {
    return fetchConditions.conditions
  }
  
  public init(sortDescriptor: NSSortDescriptor? = nil, offset: Int? = nil, limit: Int? = nil) {
    if let sortDescriptor = sortDescriptor {
      self.sortDescriptors = [sortDescriptor]
    }
    
    self.offset = offset
    self.limit = limit
  }
  
  // MARK: - Public Fetching Methods
  
  public func fetch<T: BaseDataModel>() -> Promise<[T]> {
    return T.DataSourceType.fetch(request: self)
  }
  
  
  // MARK: - Sorting
  public func orderByAscending(_ key: String) {
    sortBy(key: key, ascending: true)
  }
  
  public func addAscendingOrder(_ key: String) {
    addSort(key: key, ascending: true)
  }
  
  public func orderByDescending(_ key: String) {
    sortBy(key: key, ascending: false)
  }
  
  public func addDescendingOrder(_ key: String) {
    addSort(key: key, ascending: false)
  }
  
  
  func sortBy(key: String, ascending: Bool) {
    sortDescriptors = []
    addSort(key: key, ascending: ascending)
  }
  
  func addSort(key: String, ascending: Bool) {
    sortDescriptors.append(NSSortDescriptor(key: key, ascending: ascending))
  }
  
  
  // MARK: - Conditions
  @discardableResult
  public func whereKey(_ key: String, equalTo object: Any) -> FetchRequest {
    self.fetchConditions.whereKey(key, equalTo: object)
    return self
  }
  
  @discardableResult
  public func whereKey(_ key: String, greaterThan object: Any) -> FetchRequest {
    self.fetchConditions.whereKey(key, greaterThan: object)
    return self
  }
  
  @discardableResult
  public func whereKey(_ key: String, greaterThanOrEqualTo object: Any) -> FetchRequest {
    self.fetchConditions.whereKey(key, greaterThanOrEqualTo: object)
    return self
  }
  
  @discardableResult
  public func whereKey(_ key: String, lessThan object: Any) -> FetchRequest {
    self.fetchConditions.whereKey(key, lessThan: object)
    return self
  }
  
  @discardableResult
  public func whereKey(_ key: String, lessThanOrEqualTo object: Any) -> FetchRequest {
    self.fetchConditions.whereKey(key, lessThanOrEqualTo: object)
    return self
  }
  
  @discardableResult
  public func whereKey(_ key: String, notEqualTo object: Any) -> FetchRequest {
    self.fetchConditions.whereKey(key, notEqualTo: object)
    return self
  }
  
  @discardableResult
  public func whereKey(_ key: String, containedIn object: [Any]) -> FetchRequest {
    self.fetchConditions.whereKey(key, containedIn: object)
    return self
  }
  
  @discardableResult
  public func whereKey(_ key: String, notContainedIn object: [Any]) -> FetchRequest {
    self.fetchConditions.whereKey(key, notContainedIn: object)
    return self
  }
  
  @discardableResult
  public func whereKey(_ key: String, containsAllObjectsInArray object: [Any]) -> FetchRequest {
    self.fetchConditions.whereKey(key, containsAllObjectsInArray: object)
    return self
  }
  
  @discardableResult
  public func whereKey(_ key: String, matchesRegex regex: String, modifiers: String? = nil) -> FetchRequest {
    self.fetchConditions.whereKey(key, matchesRegex: regex, modifiers: modifiers)
    return self
  }
}


