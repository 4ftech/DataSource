//
//  ObjectMapperDataModel.swift
//  ObjectMapperDataSource
//
//  Created by Nick Kuyakanon on 4/7/18.
//  Copyright © 2018 Oinkist. All rights reserved.
//

import Foundation
import DataSource
import PromiseKit

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

open class ObjectMapperDataModel: NSObject, BaseDataModel, Mappable {
  public static var _sharedDataSource: ObjectMapperDataSource!
  open class var sharedDataSource: DataSource {
    return _sharedDataSource
  }
  
  open var objectId: String?
  open var name: String?
  open var createdAt: Date?
  open var updatedAt: Date?
  
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
  
  open override func isEqual(_ object: Any?) -> Bool {
    if let object = object as? ObjectMapperDataModel, let id = self.objectId, let objectId = object.objectId {
      return id == objectId && type(of: self).urlPath == type(of: object).urlPath
    } else {
      return self === object as? ObjectMapperDataModel
    }
  }
  
  open override var hash: Int {
    if let objectId = self.objectId {
      return objectId.hash ^ type(of: self).urlPath.hash
    } else {
      return super.hash
    }
  }
  
  open func detailRouteRequest(path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) -> DataRequest {
    let dataSource = type(of: self).sharedDataSource as! ObjectMapperDataSource
    return dataSource.alamofireRequest(forURLPath: dataSource.pathByAppending(path: path, toURL: self.pathForObject), method: method, encoding: encoding, parameters: parameters, headers: headers)
  }
  
  open func detailRouteRequestPromise(path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) -> Promise<DataRequest> {
    let dataSource = type(of: self).sharedDataSource as! ObjectMapperDataSource
    return dataSource.dataRequestPromise(forURLPath: dataSource.pathByAppending(path: path, toURL: self.pathForObject), method: method, encoding: encoding, parameters: parameters, headers: headers)
  }
  
  open func detailRouteObjectPromise<T>(path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = T.objectKeyPath) -> Promise<T> where T:ObjectMapperDataModel {
    let dataSource = type(of: self).sharedDataSource as! ObjectMapperDataSource
    return dataSource.objectRequestPromise(forURLPath: dataSource.pathByAppending(path: path, toURL: self.pathForObject), method: method, encoding: encoding, parameters: parameters, headers: headers, keyPath: keyPath)
  }
  
  open func detailRouteArrayPromise<T>(path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = T.listKeyPath) -> Promise<[T]> where T:ObjectMapperDataModel {
    let dataSource = type(of: self).sharedDataSource as! ObjectMapperDataSource
    return dataSource.arrayRequestPromise(forURLPath: dataSource.pathByAppending(path: path, toURL: self.pathForObject), method: method, encoding: encoding, parameters: parameters, headers: headers, keyPath: keyPath)
  }  
}

