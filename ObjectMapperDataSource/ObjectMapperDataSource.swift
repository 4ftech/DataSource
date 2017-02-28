//
//  ObjectMapperDataSource.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/23/17.
//  Copyright © 2017 Oinkist. All rights reserved.
//

import Foundation
import DataSource
import PromiseKit

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

public protocol ObjectMapperDataModel: BaseDataModel, Mappable {
  static var urlPath: String { get set }
  static var urlPathForList: String { get }
  static func urlPath(forId: String) -> String
  var pathForObject: String { get }
  
  static var keyPath: String? { get set }
  static var listKeyPath: String? { get set }
  
  var isNew: Bool { get }
}

public extension ObjectMapperDataModel {
  public static var pathForList: String {
    return urlPath
  }
  
  public static func urlPath(forId id: String) -> String {
    return "\(urlPath)/\(id)"
  }
  
  public var pathForObject: String {
    if let id = objectId {
      return type(of: self).urlPath(forId: id)
    } else {
      return type(of: self).urlPath
    }
  }
  
  
  public var isNew: Bool {
    return objectId == nil
  }
}

open class ObjectMapperDataSource: DataSource {
  open static var baseURL: String = ""
  
  open static var fetchMethod: HTTPMethod = .get
  open static var fetchEncoding: ParameterEncoding = URLEncoding.default
  
  open static var updateMethod: HTTPMethod = .put
  open static var updateEncoding: ParameterEncoding = JSONEncoding.default
  
  open static var insertMethod: HTTPMethod = .post
  open static var insertEncoding: ParameterEncoding = JSONEncoding.default
  
  open static var deleteMethod: HTTPMethod = .delete
  open static var deleteEncoding: ParameterEncoding = URLEncoding.default
  
  open class func parameters(forFetchRequest request: FetchRequest) -> Parameters {
    var parameters: Parameters = [:]
    
    for (key, object) in request.conditions {
      if let conditionObject = object as? [FetchQueryCondition:Any] {
        // Not sure these should apply in a default API case
        for (condition, _) in conditionObject {
          switch condition {
          case .notEqualTo: break
          case .greaterThan: break
          case .greaterThanOrEqualTo: break
          case .lessThan: break
          case .lessThanOrEqualTo: break
          case .containedIn: break
          case .containsAll: break
          case .notContainedIn: break
          }
        }
      } else {
        parameters[key] = object
      }
    }
    
    if let limit = request.limit {
      parameters["limit"] = limit
    }
    
    if let offset = request.offset {
      parameters["offset"] = offset
    }
    
    return parameters
  }
  
  open class func fullURL(forPath path: String) -> String {
    return "\(baseURL)/\(path)"
  }
  
  // MARK: - GET
  open class func alamofireFetchRequest(forURL url: String, withParameters parameters: Parameters? = nil) -> DataRequest {
    return Alamofire.request(
      fullURL(forPath: url),
      method: fetchMethod,
      parameters: parameters,
      encoding: fetchEncoding).validate()
  }

  // MARK: Array
  open class func fetch<T>(url: String, withParameters parameters: Parameters? = nil, keyPath: String? = nil) -> Promise<[T]> where T:ObjectMapperDataModel {
    return Promise<[T]> { (fulfill: @escaping ([T]) -> Void, reject) in
      alamofireFetchRequest(forURL: url, withParameters: parameters)
        .responseArray(keyPath: keyPath) { (response: DataResponse<[T]>) in
          switch response.result {
          case .success(let value):
            fulfill(value)
          case .failure(let error):
            reject(error)
          }
        }
    }
  }
  
  open override class func fetch<T>(request: FetchRequest) -> Promise<[T]> where T:ObjectMapperDataModel {
    return fetch(url: T.pathForList, withParameters: parameters(forFetchRequest: request), keyPath: T.listKeyPath)
  }
  
  // MARK: Single
  open class func fetch<T>(url: String, withParameters parameters: Parameters? = nil, keyPath: String? = nil) -> Promise<T?> where T:ObjectMapperDataModel {
    return Promise<T?> { (fulfill: @escaping (T?) -> Void, reject) in
      alamofireFetchRequest(forURL: url, withParameters: parameters)
        .responseObject(keyPath: keyPath) { (response: DataResponse<T>) in
          switch response.result {
          case .success(let value):
            fulfill(value)
          case .failure(let error):
            reject(error)
          }
        }
      
    }
  }
  
  open override class func getById<T>(id: String) -> Promise<T?> where T:ObjectMapperDataModel {
    return fetch(url: T.urlPath(forId: id), keyPath: T.keyPath)
  }
  
  // MARK: - PUT/POST
  open override class func save<T>(item: T) -> Promise<T> where T:ObjectMapperDataModel  {
    let method: HTTPMethod = item.isNew ? insertMethod : updateMethod
    let encoding: ParameterEncoding = item.isNew ? insertEncoding : updateEncoding
    
    return Promise { fulfill, reject in
      Alamofire.request(
        fullURL(forPath: item.pathForObject),
        method: method,
        parameters: item.toJSON(),
        encoding: encoding)
      .validate()
      .responseObject { (response: DataResponse<T>) in
        switch response.result {
        case .success(let value):
          fulfill(value)
        case .failure(let error):
          reject(error)
        }
      }
    }
  }
  
  // MARK: DELETE
  open override class func delete<T>(item: T) -> Promise<Bool> where T:ObjectMapperDataModel  {
    return Promise { fulfill, reject in
      if let _ = item.objectId {
        // Only try to delete if have an ID
        Alamofire.request(
          fullURL(forPath: item.pathForObject),
          method: deleteMethod)
        .validate()
        .responseJSON { response in
          switch response.result {
          case .success:
            fulfill(true)
          case .failure(let error):
            reject(error)
          }
        }
      } else {
        // No object ID, means it already didn't exist so call this a success
        fulfill(true)
      }
    }
  }
  
  
}

