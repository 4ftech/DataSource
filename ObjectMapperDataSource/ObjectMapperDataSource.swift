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


open class ObjectMapperDataModel: NSObject, BaseDataModel, Mappable {
  public typealias DataSourceType = ObjectMapperDataSource
  
  open var objectId: String?
  
  override required public init() {
    super.init()
  }
  
  public required init?(map: Map) {
    
  }
  
  public func mapping(map: Map) {
    
  }
}

public class ObjectMapperDataSource: DataSource {
  public override static var primaryKey: String? {
    return "id"
  }

  public override static func fetch<T>(request: FetchRequest) -> Promise<[T]> where T:ObjectMapperDataModel {
    return Promise<[T]> { (fulfill: @escaping ([T]) -> Void, reject) in
      Alamofire.request("").responseArray { (response: DataResponse<[T]>) in
        fulfill(response.result.value ?? [])
      }
    }
  }
  
  public override static func save<T>(item: T) -> Promise<T> where T:ObjectMapperDataModel  {
    return Promise { fulfill, reject in

    }
  }
  
  public override static func delete<T>(item: T) -> Promise<Bool> where T:ObjectMapperDataModel  {
    return Promise { fulfill, reject in

    }
  }    
}

