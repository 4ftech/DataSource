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
//  static func fetch<T>(request: FetchRequest) -> Promise<[T]>
//  static func getById<T>(id: String) -> Promise<T?>
//  static func save<T>(item: T) -> Promise<T>
//  static func delete<T>(item: T) -> Promise<Bool>
//}
//
//public extension DataSource {
//  static var primaryKey: String? { return nil }
//  
//  @discardableResult
//  static func getById<T>(id: String) -> Promise<T?> {
//    if let primaryKey = primaryKey {
//      let request = FetchRequest().whereKey(primaryKey, equalTo: id)
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


public protocol DataSource {
  init()
  func fetch<T>(request: FetchRequest) -> Promise<[T]>
  func save<T>(item: T) -> Promise<T>
  func delete<T>(item: T) -> Promise<Bool>
  func getById<T>(id: String) -> Promise<T?>
}


public protocol BaseDataModel: class, Equatable, Hashable {
  static var sharedDataSource: DataSource { get }
  
  var objectId: String? { get set }
  var updatedAt: Date? { get }
  
  var name: String? { get set }

  init()
  
  static func fetchRequest(sortDescriptor: NSSortDescriptor?, offset: Int?, limit: Int?) -> FetchRequest
  static func getById<T:BaseDataModel>(id: String) -> Promise<T?>
  static func getAll<T:BaseDataModel>() -> Promise<[T]>
  
  func save<T:BaseDataModel>() -> Promise<T>
  func delete() -> Promise<Bool>
}

public extension BaseDataModel {
  public static func fetchRequest(sortDescriptor: NSSortDescriptor? = nil, offset: Int? = nil, limit: Int? = nil) -> FetchRequest {
    return FetchRequest(sortDescriptor: sortDescriptor, offset: offset, limit: limit)
  }
  
  @discardableResult
  public static func getById<T:BaseDataModel>(id: String) -> Promise<T?> {
    return sharedDataSource.getById(id: id)
  }
  
  public static func getAll<T:BaseDataModel>() -> Promise<[T]> {
    return fetchRequest().fetch()
  }
  
  @discardableResult
  public func save<T:BaseDataModel>() -> Promise<T> {
    return type(of: self).sharedDataSource.save(item: self as! T)
  }
  
  @discardableResult
  public func delete() -> Promise<Bool> {
    return type(of: self).sharedDataSource.delete(item: self)
  }
 
  
  public var hashValue: Int {
    return objectId?.hashValue ?? name?.hashValue ?? 0
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
