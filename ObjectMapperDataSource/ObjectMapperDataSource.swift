//
//  ObjectMapperDataSource.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/23/17.
//  Copyright © 2017 4f Tech. All rights reserved.
//

import Foundation
import DataSource
import PromiseKit

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

open class ObjectMapperDataSource: BaseObjectMapperDataSource {
  open override func fetch<T>(request: FetchRequest) -> Promise<[T]> where T:ObjectMapperDataModel {
    return fetchArray(path: T.urlPathForList, fetchRequest: request)
  }
  
  open override func fetch<T, U>(request: FetchRequest, forParentObject parentObject: U) -> Promise<[T]> where T:ObjectMapperDataModel, U:ObjectMapperDataModel {
    return fetchArray(path: "\(parentObject.pathForObject)\(T.urlPathForList)", fetchRequest: request)
  }
  
  open override func getById<T>(id: String) -> Promise<T> where T:ObjectMapperDataModel {
    return fetchObject(path: T.urlPath(forId: id))
  }
  
  open override func save<T>(item: T) -> Promise<T> where T:ObjectMapperDataModel {
    return saveMapped(item: item)
  }
  
  open override func save<T, U>(item: T, forParentObject parentObject: U) -> Promise<T> where T:ObjectMapperDataModel, U:ObjectMapperDataModel {
    return saveMapped(item: item, forParentObject: parentObject)
  }
}
