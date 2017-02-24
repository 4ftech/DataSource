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
import AlamofireObjectMapper
import ObjectMapper


open class ObjectMapperDataModel: BaseDataModel {
  public typealias DataSourceType = ObjectMapperDataSource
  
  open var id: String?
  
  required public init() {
    
  }
}


public class ObjectMapperDataSource: DataSource {
  public override static var primaryKey: String? {
    return "id"
  }

  public override static func fetch<T: ObjectMapperDataSource, U>(request: FetchRequest<T, U>) -> Promise<[U]> where U: ObjectMapperDataModel, U: Mappable {
    return Promise { fulfill, reject in
      fulfill([U()])
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

