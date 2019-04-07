//
//  BaseObjectMapperDataSource.swift
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

open class BaseObjectMapperDataSource: ObjectMapperDataSourceProtocol {
  open var baseURL: String {
    assert(false, "You must override baseURL in your ObjectMapperDataSource subclass")
    return ""
  }
  
  open var limitKey: String { return "limit" }
  open var offsetKey: String { return "offset" }
  open var requireTrailingSlash: Bool { return false }
  
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
  
  open func update(parameters: inout Parameters, key: String, condition: FetchQueryCondition, value: Any, allConditions: [String:Any]) {
    switch condition {
    case .exists: break
    case .notEqualTo: break
    case .greaterThan: break
    case .greaterThanOrEqualTo: break
    case .lessThan: break
    case .lessThanOrEqualTo: break
    case .containedIn: break
    case .containsAll: break
    case .notContainedIn: break
    case .regex:
      parameters[key] = value
    case .nearCoordinates: break
    case .withinGeoBox: break
    }
  }
  
  open func addEqualCondition(parameters: inout Parameters, key: String, value: Any) {
    parameters[key] = value
  }
  
  open func parameters(forFetchRequest request: FetchRequest) -> Parameters {
    var parameters: Parameters = [:]
    
    for (key, object) in request.conditions {
      if let conditionObject = object as? [String:Any] {
        // Not sure these should apply in a default API case
        for (condition, value) in conditionObject {
          if let condition = FetchQueryCondition(rawValue: condition) {
            update(parameters: &parameters, key: key, condition: condition, value: value, allConditions: conditionObject)
          } else if let _ = FetchQueryOption(rawValue: condition) {
            // Do nothing
          } else {
            // This should be the case of equalTo a JSON object (i.e. [String:Any])
            // conditionObject is [String:Any]
            // condition is String
            // value is Any
            
            var parameterValue: [String:Any] = (parameters[key] ?? [:]) as! [String:Any]
            parameterValue[condition] = value
            
            addEqualCondition(parameters: &parameters, key: key, value: parameterValue)
          }
        }
      } else {
        addEqualCondition(parameters: &parameters, key: key, value: object)
      }
    }
    
    if let limit = request.limit {
      parameters[self.limitKey] = limit
    }
    
    if let offset = request.offset, offset > 0 {
      parameters[self.offsetKey] = offset
    }
    
    return parameters
  }
  
  open func fullURL(forPath path: String) -> String {
    return self.pathByAppending(path: path, toURL: self.baseURL)
  }
  
  func pathByAppending(path: String, toURL url: String) -> String {
    // Don't want base URL to end with a slash
    var url: String = url
    let lastIndex: String.Index = url.index(before: url.endIndex)
    if url[lastIndex] == "/" {
      url.remove(at: lastIndex)
    }
    
    // Don't want path to start with a slash
    var path: String = path
    if path[path.startIndex] == "/" {
      path.remove(at: path.startIndex)
    }
    
    // See if there needs to be a trailing slash
    let pathLastIndex: String.Index = path.index(before: path.endIndex)
    if path[pathLastIndex] != "/" && requireTrailingSlash && !path.contains("?") {
      path = "\(path)/"
    }
    
    return "\(url)/\(path)"
  }
  
  open func defaultEncoding(forMethod method: HTTPMethod) -> ParameterEncoding {
    switch method {
    case .put, .post, .patch:
      return JSONEncoding.default
    default:
      return URLEncoding.default
    }
  }
  
  public func retry<T>(times: Int, cooldown: TimeInterval, body: @escaping () -> Promise<T>) -> Promise<T> {
    var retryCounter = 0
    func attempt() -> Promise<T> {
      return body().recover(policy: CatchPolicy.allErrorsExceptCancellation) { error -> Promise<T> in
        retryCounter += 1
        
        guard retryCounter <= times else {
          throw error
        }
        
        return after(seconds: cooldown).then(attempt)
      }
    }
    
    return attempt()
  }
  
  // MARK: - Generating requests
  open func alamofireRequest(forURLPath path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) -> DataRequest {
    // Combine parameters
    var allParameters: Parameters = defaultParameters ?? [:]
    if let parameters = parameters {
      allParameters.append(with: parameters)
    }
    
    // Combine headers
    var allHeaders: HTTPHeaders = defaultHeaders ?? [:]
    if let headers = headers {
      for header in headers {
        allHeaders.add(header)
      }
    }
    
    let encoding = encoding ?? defaultEncoding(forMethod: method)
    
    NSLog("alamofireRequest for: \(fullURL(forPath: path))")
    NSLog("allParameters: \(allParameters)")
    NSLog("allHeaders: \(allHeaders)")
    
    return AF.request(
      fullURL(forPath: path),
      method: method,
      parameters: allParameters,
      encoding: encoding,
      headers: allHeaders
    ).validate()
  }
  
  open func dataRequestPromise(forURLPath path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) -> Promise<DataRequest> {
    
    // Returns a promise, to make it easier for a subclass of this to fetch OAuth headers first
    return Promise<DataRequest>.value(alamofireRequest(forURLPath: path, method: method, encoding: encoding, parameters: parameters, headers: headers))
  }
  
  open func objectRequestPromise<T>(forURLPath path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = T.objectKeyPath) -> Promise<T> where T:ObjectMapperDataModel {
    
    return dataRequestPromise(forURLPath: path, method: method, encoding: encoding, parameters: parameters, headers: headers).then { request in
      return Promise<T> { seal in
        request.responseObject(keyPath: keyPath) { (response: DataResponse<T>) in
          switch response.result {
          case .success(let value):
            seal.fulfill(value)
          case .failure(let error):
            if let error = self.error(fromResponse: response) {
              seal.reject(error)
            } else {
              seal.reject(error)
            }
          }
        }
      }
    }
  }
  
  open func arrayRequestPromise<T>(forURLPath path: String, method: HTTPMethod, encoding: ParameterEncoding? = nil, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = T.listKeyPath) -> Promise<[T]> where T:ObjectMapperDataModel {
    
    return dataRequestPromise(forURLPath: path, method: method, encoding: encoding, parameters: parameters, headers: headers).then { request in
      return Promise<[T]> { seal in
        request
          //          .responseJSON { response in
          //            switch response.result {
          //            case .success(let value):
          //              NSLog("V: \(value)")
          //            case .failure(let error):
          //              NSLog("E: \(error)")
          //            }
          //          }
          
          .responseArray(keyPath: keyPath) { (response: DataResponse<[T]>) in
            switch response.result {
            case .success(let value):
              seal.fulfill(value)
            case .failure(let error):
              if let error = self.error(fromResponse: response) {
                seal.reject(error)
              } else {
                seal.reject(error)
              }
            }
        }
      }
    }
  }
  
  // MARK: - GET Array
  open func fetchArray<T>(path: String, withParameters parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = T.listKeyPath) -> Promise<[T]> where T:ObjectMapperDataModel {
    return arrayRequestPromise(forURLPath: path, method: fetchMethod, encoding: fetchEncoding, parameters: parameters, headers: headers, keyPath: keyPath)
  }
  
  open func fetchArray<T>(path: String, fetchRequest: FetchRequest, keyPath: String? = T.listKeyPath) -> Promise<[T]> where T:ObjectMapperDataModel {
    return fetchArray(path: path, withParameters: parameters(forFetchRequest: fetchRequest), keyPath: keyPath)
  }
  
  // MARK: GET Single
  open func fetchObject<T>(path: String, withParameters parameters: Parameters? = nil, headers: HTTPHeaders? = nil, keyPath: String? = T.objectKeyPath) -> Promise<T> where T:ObjectMapperDataModel {
    return objectRequestPromise(forURLPath: path, method: fetchMethod, encoding: fetchEncoding, parameters: parameters, headers: headers, keyPath: keyPath)
  }
  
  open func fetchObject<T>(path: String, fetchRequest: FetchRequest, keyPath: String? = T.objectKeyPath) -> Promise<T> where T:ObjectMapperDataModel {
    return fetchObject(path: path, withParameters: parameters(forFetchRequest: fetchRequest), keyPath: keyPath)
  }
  
  // MARK: - PUT/POST
  open func dataRequestPromiseToSave<T, U>(item: T, forParentObject parentObject: U? = nil) -> Promise<DataRequest> where T:ObjectMapperDataModel, U:ObjectMapperDataModel {
    let method: HTTPMethod = item.isNew ? insertMethod : updateMethod
    let encoding: ParameterEncoding = item.isNew ? insertEncoding : updateEncoding
    
    var path: String = item.pathForObject
    if let parentObject = parentObject, item.isNew {
      path = "\(parentObject.pathForObject)\(path)"
    }
    
    return Promise<[String:Any]>() { seal in
      // To create JSON in background
      DispatchQueue.global(qos: .background).async {
        seal.fulfill(item.toJSON())
      }
      }.then { (json: [String:Any]) -> Promise<DataRequest> in
        return self.dataRequestPromise(forURLPath: path, method: method, encoding: encoding, parameters: json)
    }
  }
  
  open func saveMapped<T, U>(item: T, forParentObject parentObject: U? = nil) -> Promise<T> where T:ObjectMapperDataModel, U:ObjectMapperDataModel {
    return self.dataRequestPromiseToSave(item: item, forParentObject: parentObject).then { request in
      return Promise<T> { seal in
        request.responseObject { (response: DataResponse<T>) in
          switch response.result {
          case .success(let value):
            seal.fulfill(value)
          case .failure(let error):
            if let error = self.error(fromResponse: response) {
              seal.reject(error)
            } else {
              seal.reject(error)
            }
          }
        }
      }
    }
  }
  
  // MARK: - DataSource Protocol
  public required init() {
    NSLog("Initializing \(type(of: self))")
  }
  
  open func delete<T>(item: T) -> Promise<Void> {
    let item = item as! ObjectMapperDataModel
    
    // Only try to delete if have an ID
    if let _ = item.objectId {
      return dataRequestPromise(forURLPath: item.pathForObject, method: deleteMethod, encoding: deleteEncoding).then { request in
        return Promise<Void> { seal in
          request.responseJSON { response in
            switch response.result {
            case .success:
              seal.fulfill(())
            case .failure(let error):
              if let error = self.error(fromResponse: response) {
                seal.reject(error)
              } else {
                seal.reject(error)
              }
            }
          }
        }
      }
    } else {
      // No object ID, means it already didn't exist so call this a success
      return Promise<Void>()
    }
  }
  
  
  public func fetch<T>(request: FetchRequest) -> Promise<[T]> {
    return Promise<[T]> { seal in }
  }
  
  public func fetch<T, U>(request: FetchRequest, forParentObject parentObject: U) -> Promise<[T]> {
    return Promise<[T]> { seal in }
  }
  
  public func getById<T>(id: String) -> Promise<T> {
    return Promise<T> { seal in }
  }
  
  public func save<T>(item: T) -> Promise<T> {
    return Promise<T> { seal in }
  }
  
  public func save<T, U>(item: T, forParentObject parentObject: U) -> Promise<T> {
    return Promise<T> { seal in }
  }
  
  // MARK: - Errors
  open func error(code: Int?, data: Data?) -> Error? {
    return nil
  }
  
  open func error<T>(fromResponse response: DataResponse<T>) -> Error? {
    return self.error(code: response.response?.statusCode, data: response.data)
  }
}
