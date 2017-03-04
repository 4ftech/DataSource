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

open class ObjectMapperDataModel: BaseDataModel, Mappable {
  static var _sharedDataSource: ObjectMapperDataSource!
  open class var sharedDataSource: DataSource {
    return _sharedDataSource
  }
  
  public var objectId: String?
  public var name: String?
  public var updatedAt: Date?
  
  open class var urlPath: String { return "" }
  
  open class var keyPath: String? { return nil }
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
      return type(of: self).urlPath
    }
  }
  
  public var isNew: Bool {
    return objectId == nil
  }
  
  public required init() {
    NSLog("Initializing ObjectMapperDataSource")
  }
  
  public required init?(map: Map) {
    
  }
  
  open func mapping(map: Map) {
    
  }
  
  public static func ==(lhs: ObjectMapperDataModel, rhs: ObjectMapperDataModel) -> Bool {
    if let lhsId = lhs.objectId, let rhsId = rhs.objectId {
      return lhsId == rhsId
    } else {
      return lhs == rhs
    }
  }
}

public protocol ObjectMapperDataSource: DataSource {
  var defaultHeaders: HTTPHeaders? { get }
  var defaultParameters: Parameters? { get }
  
  var baseURL: String { get }
  
  var fetchMethod: HTTPMethod { get }
  var fetchEncoding: ParameterEncoding { get }
  
  var updateMethod: HTTPMethod { get }
  var updateEncoding: ParameterEncoding { get }
  
  var insertMethod: HTTPMethod { get }
  var insertEncoding: ParameterEncoding { get }
  
  var deleteMethod: HTTPMethod { get }
  var deleteEncoding: ParameterEncoding { get }
  
  func update(parameters: inout Parameters, key: String, condition: FetchQueryCondition, value: Any)
  
  func parameters(forFetchRequest request: FetchRequest) -> Parameters
  func fullURL(forPath path: String) -> String
  func alamofireRequest(forURLPath path: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?) -> DataRequest
  func dataRequestPromise(forURLPath path: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?) -> Promise<DataRequest>
  
  func fetchArray<T>(path: String, withParameters parameters: Parameters?, headers: HTTPHeaders?, keyPath: String?) -> Promise<[T]> where T:ObjectMapperDataModel
  func fetchOne<T>(path: String, withParameters parameters: Parameters?, headers: HTTPHeaders?, keyPath: String?) -> Promise<T?> where T:ObjectMapperDataModel
  func saveMapped<T>(item: T) -> Promise<T> where T:ObjectMapperDataModel
}

open class EmptyObjectMapperDataSource: ObjectMapperDataSource {
  open var baseURL: String { return "" }
  
  open var defaultHeaders: HTTPHeaders? { return nil }
  open var defaultParameters: Parameters? { return nil }
  
  open var fetchMethod: HTTPMethod { return .get }
  open var fetchEncoding: ParameterEncoding { return URLEncoding.default }
  
  open var updateMethod: HTTPMethod { return .put }
  open var updateEncoding: ParameterEncoding { return JSONEncoding.default }
  
  open var insertMethod: HTTPMethod { return .post }
  open var insertEncoding: ParameterEncoding { return JSONEncoding.default }
  
  open var deleteMethod: HTTPMethod { return .delete }
  open var deleteEncoding: ParameterEncoding { return URLEncoding.default }
  
  open func update(parameters: inout Parameters, key: String, condition: FetchQueryCondition, value: Any) {
    switch condition {
    case .notEqualTo: break
    case .greaterThan: break
    case .greaterThanOrEqualTo: break
    case .lessThan: break
    case .lessThanOrEqualTo: break
    case .containedIn: break
    case .containsAll: break
    case .notContainedIn: break
    case .regex: break
    case .regexOptions: break
    }
  }
  
  open func parameters(forFetchRequest request: FetchRequest) -> Parameters {
    var parameters: Parameters = [:]
    
    for (key, object) in request.conditions {
      if let conditionObject = object as? [FetchQueryCondition:Any] {
        // Not sure these should apply in a default API case
        for (condition, value) in conditionObject {
          update(parameters: &parameters, key: key, condition: condition, value: value)
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
  
  open func fullURL(forPath path: String) -> String {
    return "\(baseURL)/\(path)"
  }
  
  // MARK: - Generating requests
  open func alamofireRequest(forURLPath path: String, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding, headers: HTTPHeaders? = nil) -> DataRequest {
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
  
  open func dataRequestPromise(forURLPath path: String, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding, headers: HTTPHeaders? = nil) -> Promise<DataRequest> {
    // Returns a promise, to make it easier for a subclass of this to fetch OAuth headers first
    return Promise<DataRequest>(value: alamofireRequest(forURLPath: path, method: method, parameters: parameters, encoding: encoding, headers: headers))
  }
  
  
  
  // MARK: - GET Array
  open func fetchArray<T>(path: String, withParameters parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = nil) -> Promise<[T]> where T:ObjectMapperDataModel {
    return dataRequestPromise(forURLPath: path, method: fetchMethod, parameters: parameters, encoding: fetchEncoding, headers: headers).then { request in
      return Promise<[T]> { fulfill, reject in
        request
          .responseJSON { response in
            switch response.result {
            case .success(let value):
            NSLog("V: \(value)")
            case .failure(let error):
            NSLog("E: \(error)")
            }
          }
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
    
  }
  
  // MARK: GET Single
  open func fetchOne<T>(path: String, withParameters parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = nil) -> Promise<T?> where T:ObjectMapperDataModel {
    
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
    
  }
  
  // MARK: - PUT/POST
  open func saveMapped<T>(item: T) -> Promise<T> where T:ObjectMapperDataModel, T:Mappable {
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
  open func delete<T>(item: T) -> Promise<Bool> {
    let item = item as! ObjectMapperDataModel
    
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
  
  public required init() {
    
  }
  
  public func fetch<T>(request: FetchRequest) -> Promise<[T]> {
    return Promise<[T]> { _,_ in }
  }
  
  public func getById<T>(id: String) -> Promise<T?> {
    return Promise<T?> { _,_ in }
  }
  
  public func save<T>(item: T) -> Promise<T> {
    return Promise<T> { _,_ in }
  }
}


open class BaseObjectMapperDataSource: EmptyObjectMapperDataSource {
  open override func fetch<T>(request: FetchRequest) -> Promise<[T]> where T:ObjectMapperDataModel {
    return fetchArray(path: T.urlPathForList, withParameters: parameters(forFetchRequest: request), keyPath: T.listKeyPath)
  }
  
  open override func getById<T>(id: String) -> Promise<T?> where T:ObjectMapperDataModel {
    return fetchOne(path: T.urlPath(forId: id), keyPath: T.keyPath)
  }
  
  open override func save<T>(item: T) -> Promise<T> where T:ObjectMapperDataModel {
    return saveMapped(item: item)
  }
}
