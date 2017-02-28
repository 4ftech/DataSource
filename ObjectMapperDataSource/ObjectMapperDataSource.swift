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
  open static var defaultHeaders: HTTPHeaders? = nil
  open static var defaultParameters: Parameters? = nil
  
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
  
  // MARK: - Generating requests
  open class func alamofireRequest(forURLPath path: String, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding, headers: HTTPHeaders? = nil) -> DataRequest {
    // Combine parameters
    var allParameters: Parameters = defaultParameters ?? [:]
    if let parameters = parameters {
      allParameters.append(with: parameters)
    }
    
    // Combine headers
    var allHeaders: HTTPHeaders = defaultHeaders ?? [:]
    if let headers = headers {
      allHeaders.append(with: headers)
    }
    
    return Alamofire.request(
      fullURL(forPath: path),
      method: method,
      parameters: allParameters,
      encoding: encoding,
      headers: allHeaders
    ).validate()
  }
  
  open class func dataRequestPromise(forURLPath path: String, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding, headers: HTTPHeaders? = nil) -> Promise<DataRequest> {
    // Returns a promise, to make it easier for a subclass of this to fetch OAuth headers first
    return Promise<DataRequest> { fulfill, reject in
      fulfill(alamofireRequest(forURLPath: path, method: method, parameters: parameters, encoding: encoding, headers: headers))
    }
  }
  
  // MARK: - GET Array
  open class func fetch<T>(path: String, withParameters parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = nil) -> Promise<[T]> where T:ObjectMapperDataModel {
    return Promise<[T]> { (fulfill: @escaping ([T]) -> Void, reject) in
      dataRequestPromise(forURLPath: path, method: fetchMethod, parameters: parameters, encoding: fetchEncoding, headers: headers).then { request in
        request.responseArray(keyPath: keyPath) { (response: DataResponse<[T]>) in
          switch response.result {
          case .success(let value):
            fulfill(value)
          case .failure(let error):
            reject(error)
          }
        }
      }.catch { error in
        reject(error)
      }
    }
  }
  
  open override class func fetch<T>(request: FetchRequest) -> Promise<[T]> where T:ObjectMapperDataModel {
    return fetch(path: T.pathForList, withParameters: parameters(forFetchRequest: request), keyPath: T.listKeyPath)
  }
  
  // MARK: GET Single
  open class func fetch<T>(path: String, withParameters parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = nil) -> Promise<T?> where T:ObjectMapperDataModel {
    return dataRequestPromise(forURLPath: path, method: fetchMethod, parameters: parameters, encoding: fetchEncoding, headers: headers).then { request in
      return Promise<T?> { (fulfill: @escaping (T?) -> Void, reject) in
        request.responseObject(keyPath: keyPath) { (response: DataResponse<T>) in
          switch response.result {
          case .success(let value):
            fulfill(value)
          case .failure(let error):
            reject(error)
          }
        }
      }
    }
    
    
//    return Promise<T?> { (fulfill: @escaping (T?) -> Void, reject) in
//      dataRequestPromise(forURLPath: path, method: fetchMethod, parameters: parameters, encoding: fetchEncoding, headers: headers).then { request in
//        request.responseObject(keyPath: keyPath) { (response: DataResponse<T>) in
//          switch response.result {
//          case .success(let value):
//            fulfill(value)
//          case .failure(let error):
//            reject(error)
//          }
//        }
//      }.catch { error in
//        reject(error)
//      }
//    }
  }
  
  open override class func getById<T>(id: String) -> Promise<T?> where T:ObjectMapperDataModel {
    return fetch(path: T.urlPath(forId: id), keyPath: T.keyPath)
  }
  
  // MARK: - PUT/POST
  open override class func save<T>(item: T) -> Promise<T> where T:ObjectMapperDataModel  {
    let method: HTTPMethod = item.isNew ? insertMethod : updateMethod
    let encoding: ParameterEncoding = item.isNew ? insertEncoding : updateEncoding
    
    return dataRequestPromise(forURLPath: item.pathForObject, method: method, parameters: item.toJSON(), encoding: encoding).then { request in
      return Promise<T> { fulfill, reject in
        request.responseObject { (response: DataResponse<T>) in
          switch response.result {
          case .success(let value):
            fulfill(value)
          case .failure(let error):
            reject(error)
          }
        }
      }
    }
  }
  
  // MARK: DELETE
  open override class func delete<T>(item: T) -> Promise<Bool> where T:ObjectMapperDataModel  {
    // Only try to delete if have an ID
    if let _ = item.objectId {
      return dataRequestPromise(forURLPath: item.pathForObject, method: deleteMethod, encoding: deleteEncoding).then { request in
        return Promise<Bool> { fulfill, reject in
          request.responseJSON { response in
            switch response.result {
            case .success:
              fulfill(true)
            case .failure(let error):
              reject(error)
            }
          }
        }
      }
    } else {
      // No object ID, means it already didn't exist so call this a success
      return Promise<Bool>(value: true)
    }
  }
  
  
}

