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
  public override static var primaryKey: String? {
    return "id"
  }

  public override static func fetch<T>(request: FetchRequest<T>) -> Promise<[T]> where T: ObjectMapperDataModel, T: Mappable {
    return Promise { fulfill, reject in
      Alamofire.request("").responseArray { (response: DataResponse<[T]>) in
        if let error = response.error {
          reject(error)
        } else {
          fulfill(response.result.value ?? [])
        }
      }
    }
  }
  
  public override static func save<T>(item: T) -> Promise<T> where T: ObjectMapperDataModel {
    return Promise { fulfill, reject in

    }
  }
  
  public override static func delete<T>(item: T) -> Promise<Bool> where T: ObjectMapperDataModel {
    return Promise { fulfill, reject in

    }
  }    
}

