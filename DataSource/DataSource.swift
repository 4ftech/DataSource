//
//  DataSource.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 2/22/17.
//  Copyright © 2017 4f Tech. All rights reserved.
//

import Foundation
import PromiseKit


public protocol DataSource {
  init()
  func fetch<T>(request: FetchRequest) -> Promise<[T]>
  func fetch<T, U>(request: FetchRequest, forParentObject: U) -> Promise<[T]>
  func save<T>(item: T) -> Promise<T>
  func save<T, U>(item: T, forParentObject: U) -> Promise<T>
  func delete<T>(item: T) -> Promise<Void>
  func getById<T>(id: String) -> Promise<T>
}

