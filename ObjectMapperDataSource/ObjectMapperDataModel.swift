//
//  ObjectMapperDataModel.swift
//  ObjectMapperDataSource
//
//  Created by Nick Kuyakanon on 4/7/18.
//  Copyright © 2018 Oinkist. All rights reserved.
//

import Foundation
import PromiseKit

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

open class ObjectMapperDataModel: NSObject, Mappable {
  public static var _sharedDataSource: ObjectMapperDataSource!
  open class var sharedDataSource: ObjectMapperDataSource {
    return _sharedDataSource
  }
  
  public var objectId: String?
  public var name: String?
  public var createdAt: Date?
  public var updatedAt: Date?
  
  open class var urlPath: String { return "" }
  
  open class var objectKeyPath: String? { return nil }
  open class var listKeyPath: String? { return nil }
  
  open class var urlPathForList: String {
    return urlPath
  }
  
  open class func urlPath(forId id: String) -> String {
    return "\(urlPath)/\(id)"
  }
  
  open var pathForObject: String {
    if let id = objectId {
      return type(of: self).urlPath(forId: id)
    } else {
      return type(of: self).urlPathForList
    }
  }
  
  public required override init() {
    super.init()
  }
  
  public required init?(map: Map) {
    
  }
  
  open func mapping(map: Map) {
    
  }
  
  public override func isEqual(_ object: Any?) -> Bool {
    if let object = object as? ObjectMapperDataModel, let id = self.objectId, let objectId = object.objectId {
      return id == objectId && type(of: self).urlPath == type(of: object).urlPath
    } else {
      return self === object as? ObjectMapperDataModel
    }
  }
  
  public override var hash: Int {
    if let objectId = self.objectId {
      return objectId.hash ^ type(of: self).urlPath.hash
    } else {
      return super.hash
    }
  }
  
  public func detailRouteRequest(path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) -> DataRequest {
    let dataSource = type(of: self).sharedDataSource as! ObjectMapperDataSource
    return dataSource.alamofireRequest(forURLPath: dataSource.pathByAppending(path: path, toURL: self.pathForObject), method: method, encoding: encoding, parameters: parameters, headers: headers)
  }
  
  public func detailRouteRequestPromise(path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) -> Promise<DataRequest> {
    let dataSource = type(of: self).sharedDataSource as! ObjectMapperDataSource
    return dataSource.dataRequestPromise(forURLPath: dataSource.pathByAppending(path: path, toURL: self.pathForObject), method: method, encoding: encoding, parameters: parameters, headers: headers)
  }
  
  public func detailRouteObjectPromise<T>(path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = T.objectKeyPath) -> Promise<T> where T:ObjectMapperDataModel {
    let dataSource = type(of: self).sharedDataSource as! ObjectMapperDataSource
    return dataSource.objectRequestPromise(forURLPath: dataSource.pathByAppending(path: path, toURL: self.pathForObject), method: method, encoding: encoding, parameters: parameters, headers: headers, keyPath: keyPath)
  }
  
  public func detailRouteArrayPromise<T>(path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = T.listKeyPath) -> Promise<[T]> where T:ObjectMapperDataModel {
    let dataSource = type(of: self).sharedDataSource as! ObjectMapperDataSource
    return dataSource.arrayRequestPromise(forURLPath: dataSource.pathByAppending(path: path, toURL: self.pathForObject), method: method, encoding: encoding, parameters: parameters, headers: headers, keyPath: keyPath)
  }
  
  public var isNew: Bool {
    return objectId == nil
  }

  public static func fetchRequest(sortDescriptor: NSSortDescriptor? = nil, offset: Int? = nil, limit: Int? = nil) -> FetchRequest {
    return FetchRequest(sortDescriptor: sortDescriptor, offset: offset, limit: limit)
  }

  @discardableResult
  public static func getById<T:ObjectMapperDataModel>(id: String) -> Promise<T> {
    return sharedDataSource.getById(id: id)
  }

  public static func getAll<T:ObjectMapperDataModel>(filters: [Filter]? = nil) -> Promise<[T]> {
    return sharedDataSource.fetch(request: fetchRequest().apply(filters: filters))
  }

  @discardableResult
  open func save<T:ObjectMapperDataModel>() -> Promise<T> {
    return type(of: self).sharedDataSource.save(item: self as! T)
  }

  @discardableResult
  open func save<T:ObjectMapperDataModel, U:ObjectMapperDataModel>(forParentObject parentObject: U) -> Promise<T> {
    return type(of: self).sharedDataSource.save(item: self as! T, forParentObject: parentObject)
  }

  @discardableResult
  public func delete() -> Promise<Void> {
    return type(of: self).sharedDataSource.delete(item: self)
  }

  @discardableResult
  public func fetch<T:ObjectMapperDataModel>() -> Promise<T> {
    if let id = self.objectId {
      return type(of: self).sharedDataSource.getById(id: id)
    } else {
      return Promise.value(self as! T)
    }
  }
}

