//
//  DataSource.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/22/17.
//  Copyright © 2017 Oinkist. All rights reserved.
//

import Foundation
import PromiseKit

public protocol DataSource {
  associatedtype T
  
  static var primaryKey: String? { get }
  
  static func fetch(request: FetchRequest<Self>) -> Promise<[T]>
  static func getById(id: String) -> Promise<T?>
  static func save(item: T) -> Promise<T>
  static func delete(item: T) -> Promise<Bool>
}

public extension DataSource {
  static var primaryKey: String? { return nil }
  
  @discardableResult
  static func getById(id: String) -> Promise<T?> {
    if let primaryKey = primaryKey {
      let request = FetchRequest<Self>().whereKey(primaryKey, equalTo: id)
      
      return Promise { fulfill, reject in
        self.fetch(request: request).then { results in
          fulfill(results.first)
        }.catch { error in
          reject(error)
        }
      }
    }
    
    return Promise(value: nil)
  }
}

public protocol BaseDataModel {
  associatedtype T: DataSource
  
  var id: String? { get set }
  
  init()
  
  static func fetchRequest(sortDescriptor: NSSortDescriptor?, offset: Int, limit: Int) -> FetchRequest<T>
  static func getById(id: String) -> Promise<T.T?>
  
  func save() -> Promise<T.T>
  func delete() -> Promise<Bool>
}

public extension BaseDataModel {
  public static func fetchRequest(sortDescriptor: NSSortDescriptor? = nil, offset: Int = 0, limit: Int = 0) -> FetchRequest<T> {
    return FetchRequest<T>()
  }
  
  @discardableResult
  public static func getById(id: String) -> Promise<T.T?> {
    return T.getById(id: id)
  }
  
  @discardableResult
  public func save() -> Promise<T.T> {
    return T.save(item: self as! T.T)
  }
  
  @discardableResult
  public func delete() -> Promise<Bool> {
    return T.delete(item: self as! T.T)
  }
  
}


public class FetchRequest<T: DataSource> {
  public let offset: Int
  public let limit: Int
  
  var fetchConditions: FetchConditions = FetchConditions()
  
  public var sortDescriptors: [NSSortDescriptor] = []
  public var conditions: [String:Any] {
    return fetchConditions.conditions
  }
  
  public init(sortDescriptor: NSSortDescriptor? = nil, offset: Int = 0, limit: Int = 0) {
    if let sortDescriptor = sortDescriptor {
      self.sortDescriptors = [sortDescriptor]
    }
    
    self.offset = offset
    self.limit = limit
  }
  
  // MARK: - Public Fetching Methods
  
  public func fetch() -> Promise<[T.T]> {
    return T.fetch(request: self)
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
  public func whereKey(_ key: String, equalTo object: Any) -> FetchRequest<T> {
    self.fetchConditions.whereKey(key, equalTo: object)
    return self
  }
  
  public func whereKey(_ key: String, greaterThan object: Any) -> FetchRequest<T> {
    self.fetchConditions.whereKey(key, greaterThan: object)
    return self
  }

  public func whereKey(_ key: String, greaterThanOrEqualTo object: Any) -> FetchRequest<T> {
    self.fetchConditions.whereKey(key, greaterThanOrEqualTo: object)
    return self
  }
  
  public func whereKey(_ key: String, lessThan object: Any) -> FetchRequest<T> {
    self.fetchConditions.whereKey(key, lessThan: object)
    return self
  }

  public func whereKey(_ key: String, lessThanOrEqualTo object: Any) -> FetchRequest<T> {
    self.fetchConditions.whereKey(key, lessThanOrEqualTo: object)
    return self
  }

  public func whereKey(_ key: String, notEqualTo object: Any) -> FetchRequest<T> {
    self.fetchConditions.whereKey(key, notEqualTo: object)
    return self
  }

  public func whereKey(_ key: String, containedIn object: [Any]) -> FetchRequest<T> {
    self.fetchConditions.whereKey(key, containedIn: object)
    return self
  }

  public func whereKey(_ key: String, notContainedIn object: [Any]) -> FetchRequest<T> {
    self.fetchConditions.whereKey(key, notContainedIn: object)
    return self
  }

  public func whereKey(_ key: String, containsAllObjectsInArray object: [Any]) -> FetchRequest<T> {
    self.fetchConditions.whereKey(key, containsAllObjectsInArray: object)
    return self
  }
}




//
//open class RealmDataModel: NSObject, BaseDataModel {
//  public typealias T = RealmDataSource<RealmDataModel>
//  
//  public var id: String? = nil
//  
//  override required public init() {
//    super.init()
//  }
//
//}
//
//public final class RealmDataSource<T: RealmDataModel>: DataSource {
//  public static func getAll() -> [T] {
//    return []
//  }
//  
//  public static func getById(id: String) -> T {
//    NSLog("RealmDataSource")
//    return T()
//  }
//  
//  public static func insert(item: T) {
//  }
//  
//  public static func update(item: T) {
//  }
//  
//  public static func delete(item: T) {
//    
//  }
//  
//  public static func clean() {
//
//  }
//}
