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


open class ObjectMapperDataModel: NSObject, BaseDataModel {
  public typealias DataSourceType = ObjectMapperDataSource
  
  open var objectId: String?
  
  override required public init() {
    super.init()
  }
}


public class ObjectMapperDataSource: DataSource {
  public static var primaryKey: String? {
    return "id"
  }

  public static func fetch<T>(request: FetchRequest) -> Promise<[T]> {
    return Promise<[T]> { (fulfill: @escaping ([T]) -> Void, reject) in

    }
  }
  
  public static func save<T>(item: T) -> Promise<T> {
    return Promise { fulfill, reject in

    }
  }
  
  public static func delete<T>(item: T) -> Promise<Bool> {
    return Promise { fulfill, reject in

    }
  }    
}

