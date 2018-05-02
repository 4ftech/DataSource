//
//  BaseDataModel.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 4/7/18.
//  Copyright © 2018 Oinkist. All rights reserved.
//

import Foundation

import PromiseKit

public protocol BaseDataModel: Hashable {
  static var sharedDataSource: DataSource { get }

  var objectId: String? { get set }
  var createdAt: Date? { get }
  var updatedAt: Date? { get }

  var name: String? { get set }

  //  static func fetchRequest(sortDescriptor: NSSortDescriptor?, offset: Int?, limit: Int?) -> FetchRequest
  //  static func getById<T:BaseDataModel>(id: String) -> Promise<T>
  //  static func getAll<T:BaseDataModel>(filters: [Filter]?) -> Promise<[T]>
  

  //  var isNew: Bool { get }
  
  //  func save<T:BaseDataModel>() -> Promise<T>
  //  func save<T:BaseDataModel, U:BaseDataModel>(forParentObject: U) -> Promise<T>
  //  func delete() -> Promise<Void>
  //  func fetch<T: BaseDataModel>() -> Promise<T>
  
  init()
}

public extension BaseDataModel {
  public var isNew: Bool {
    return objectId == nil
  }

  public static func fetchRequest(sortDescriptor: NSSortDescriptor? = nil, offset: Int? = nil, limit: Int? = nil) -> FetchRequest {
    return FetchRequest(sortDescriptor: sortDescriptor, offset: offset, limit: limit)
  }

  @discardableResult
  public static func getById<T:BaseDataModel>(id: String) -> Promise<T> {
    return sharedDataSource.getById(id: id)
  }

  public static func getAll<T:BaseDataModel>(filters: [Filter]? = nil) -> Promise<[T]> {
    return sharedDataSource.fetch(request: fetchRequest().apply(filters: filters))
  }

  @discardableResult
  public func save<T:BaseDataModel>() -> Promise<T> {
    return type(of: self).sharedDataSource.save(item: self as! T)
  }

  @discardableResult
  public func save<T:BaseDataModel, U:BaseDataModel>(forParentObject parentObject: U) -> Promise<T> {
    return type(of: self).sharedDataSource.save(item: self as! T, forParentObject: parentObject)
  }

  @discardableResult
  public func delete() -> Promise<Void> {
    return type(of: self).sharedDataSource.delete(item: self)
  }

  @discardableResult
  public func fetch<T:BaseDataModel>() -> Promise<T> {
    if let id = self.objectId {
      return type(of: self).sharedDataSource.getById(id: id)
    } else {
      return Promise(value: self as! T)
    }
  }

  public var hashValue: Int {
    return objectId?.hashValue ?? name?.hashValue ?? 0
  }

}
