//
//  DataSource.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/22/17.
//  Copyright © 2017 4f Tech. All rights reserved.
//

import Foundation
import PromiseKit


public protocol DataSource {
  init()
  func fetch<T>(request: FetchRequest) -> Promise<[T]>
  func save<T>(item: T) -> Promise<T>
  func delete<T>(item: T) -> Promise<Bool>
  func getById<T>(id: String) -> Promise<T>
}


public protocol BaseDataModel: class, Equatable, Hashable {
  static var sharedDataSource: DataSource { get }
  static var filters: [Filter] { get }
  
  var objectId: String? { get set }
  var createdAt: Date? { get }
  var updatedAt: Date? { get }
  
  var name: String? { get set }
  
  init()
  
  static func fetchRequest(sortDescriptor: NSSortDescriptor?, offset: Int?, limit: Int?) -> FetchRequest
  static func getById<T:BaseDataModel>(id: String) -> Promise<T>
  static func getAll<T:BaseDataModel>(filters: [Filter]?) -> Promise<[T]>
  
  func save<T:BaseDataModel>() -> Promise<T>
  func delete() -> Promise<Bool>
}

public extension BaseDataModel {
  public static func fetchRequest(sortDescriptor: NSSortDescriptor? = nil, offset: Int? = nil, limit: Int? = nil) -> FetchRequest {
    return FetchRequest(sortDescriptor: sortDescriptor, offset: offset, limit: limit)
  }
  
  @discardableResult
  public static func getById<T:BaseDataModel>(id: String) -> Promise<T> {
    return sharedDataSource.getById(id: id)
  }
  
  public static func getAll<T:BaseDataModel>(filters: [Filter]? = nil) -> Promise<[T]> {
    return fetchRequest().fetch(filters: filters)
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
