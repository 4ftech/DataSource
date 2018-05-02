//
//  ObjectMapperDataSourceProtocol.swift
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

public protocol ObjectMapperDataSourceProtocol: DataSource {
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
  
  func update(parameters: inout Parameters, key: String, condition: FetchQueryCondition, value: Any, allConditions: [String:Any])
  
  func parameters(forFetchRequest request: FetchRequest) -> Parameters
  func fullURL(forPath path: String) -> String
  func alamofireRequest(forURLPath path: String, method: HTTPMethod, encoding: ParameterEncoding?, parameters: Parameters?, headers: HTTPHeaders?) -> DataRequest
  func dataRequestPromise(forURLPath path: String, method: HTTPMethod, encoding: ParameterEncoding?, parameters: Parameters?, headers: HTTPHeaders?) -> Promise<DataRequest>
  
  func fetchArray<T>(path: String, withParameters parameters: Parameters?, headers: HTTPHeaders?, keyPath: String?) -> Promise<[T]> where T:ObjectMapperDataModel
  func fetchObject<T>(path: String, withParameters parameters: Parameters?, headers: HTTPHeaders?, keyPath: String?) -> Promise<T> where T:ObjectMapperDataModel
  func saveMapped<T, U>(item: T, forParentObject parentObject: U?) -> Promise<T> where T:ObjectMapperDataModel, U:ObjectMapperDataModel
}
