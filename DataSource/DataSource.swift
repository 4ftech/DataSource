//
//  DataSource.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/22/17.
//  Copyright © 2017 Oinkist. All rights reserved.
//

import Foundation
import PromiseKit

//public protocol DataSource {
//  static var primaryKey: String? { get }
//  
//  static func fetch<T>(request: FetchRequest<Self>) -> Promise<[T]>
//  static func getById<T: BaseDataModel>(id: String) -> Promise<T?>
//  static func save<T: BaseDataModel>(item: T) -> Promise<T>
//  static func delete<T: BaseDataModel>(item: T) -> Promise<Bool>
//}
//
//public extension DataSource {
//  static var primaryKey: String? { return nil }
//  
//  @discardableResult
//  static func getById<T: BaseDataModel>(id: String) -> Promise<T?> {
//    if let primaryKey = primaryKey {
//      let request = FetchRequest<Self>().whereKey(primaryKey, equalTo: id)
//      
//      return Promise { fulfill, reject in
//        self.fetch(request: request).then { results in
//          fulfill(results.first)
//        }.catch { error in
//          reject(error)
//        }
//      }
//    }
//    
//    return Promise(value: nil)
//  }
//}


open class DataSource {
  open class var primaryKey: String? { return nil }
  
  open class func fetch<T: DataSource, U: BaseDataModel>(request: FetchRequest<T, U>) -> Promise<[U]> {
    NSLog("WHY?")
    return Promise { _, _ in }
  }
  
  open class func save<T: BaseDataModel>(item: T) -> Promise<T> {
    return Promise { _, _ in }
  }
  
  open class func delete<T: BaseDataModel>(item: T) -> Promise<Bool> {
    return Promise { _, _ in }
  }

  
  @discardableResult
  open class func getById<T: BaseDataModel>(id: String) -> Promise<T?> {
    if let primaryKey = primaryKey {
      let request = FetchRequest<DataSource, T>().whereKey(primaryKey, equalTo: id)
      
      return Promise<T?> { fulfill, reject in
        self.fetch(request: request).then { (results: [T]) in
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
  associatedtype DataSourceType: DataSource
  
  var id: String? { get set }
  
  init()
  
  static func fetchRequest<U: BaseDataModel>(sortDescriptor: NSSortDescriptor?, offset: Int, limit: Int) -> FetchRequest<U.DataSourceType, U>
  static func getById<T: BaseDataModel>(id: String) -> Promise<T?>
  
  func save<T: BaseDataModel>() -> Promise<T>
  func delete() -> Promise<Bool>
}

public extension BaseDataModel {
  public static func fetchRequest<U: BaseDataModel>(sortDescriptor: NSSortDescriptor? = nil, offset: Int = 0, limit: Int = 0) -> FetchRequest<U.DataSourceType, U> {
    return FetchRequest<U.DataSourceType, U>()
  }
  
  @discardableResult
  public static func getById<T: BaseDataModel>(id: String) -> Promise<T?> {
    return DataSourceType.getById(id: id)
  }
  
  @discardableResult
  public func save<T: BaseDataModel>() -> Promise<T> {
    return DataSourceType.save(item: self as! T)
  }
  
  @discardableResult
  public func delete() -> Promise<Bool> {
    return DataSourceType.delete(item: self)
  }
  
}


public class FetchRequest<T, U> where T:DataSource, U: BaseDataModel {
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
  
  public func fetch() -> Promise<[U]> {
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
  public func whereKey(_ key: String, equalTo object: Any) -> FetchRequest<T, U> {
    self.fetchConditions.whereKey(key, equalTo: object)
    return self
  }
  
  public func whereKey(_ key: String, greaterThan object: Any) -> FetchRequest<T, U> {
    self.fetchConditions.whereKey(key, greaterThan: object)
    return self
  }

  public func whereKey(_ key: String, greaterThanOrEqualTo object: Any) -> FetchRequest<T, U> {
    self.fetchConditions.whereKey(key, greaterThanOrEqualTo: object)
    return self
  }
  
  public func whereKey(_ key: String, lessThan object: Any) -> FetchRequest<T, U> {
    self.fetchConditions.whereKey(key, lessThan: object)
    return self
  }

  public func whereKey(_ key: String, lessThanOrEqualTo object: Any) -> FetchRequest<T, U> {
    self.fetchConditions.whereKey(key, lessThanOrEqualTo: object)
    return self
  }

  public func whereKey(_ key: String, notEqualTo object: Any) -> FetchRequest<T, U> {
    self.fetchConditions.whereKey(key, notEqualTo: object)
    return self
  }

  public func whereKey(_ key: String, containedIn object: [Any]) -> FetchRequest<T, U> {
    self.fetchConditions.whereKey(key, containedIn: object)
    return self
  }

  public func whereKey(_ key: String, notContainedIn object: [Any]) -> FetchRequest<T, U> {
    self.fetchConditions.whereKey(key, notContainedIn: object)
    return self
  }

  public func whereKey(_ key: String, containsAllObjectsInArray object: [Any]) -> FetchRequest<T, U> {
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
