//
//  ParseDataModel.swift
//  ParseDataSource
//
//  Created by Nick Kuyakanon on 4/13/18.
//  Copyright © 2018 Oinkist. All rights reserved.
//

import Foundation
import DataSource
import PromiseKit
import Parse


open class ParseDataModel: PFObject, BaseDataModel {
  public static var sharedDataSource: DataSource = ParseDataSource()
  
  open var name: String? {
    get {
      return self["name"] as? String
    }
    set {
      self["name"] = newValue
    }
  }
  
  public override required init() {
    super.init()
  }
  
  open class var includeKeys: [String:ParseDataModel.Type] {
    return [:]
  }
  
  open override class func query() -> PFQuery<PFObject>? {
    let q = super.query()
    includeKeysInQuery(q)
    return q
  }
  
  class func includeKeysInQuery(_ query: PFQuery<PFObject>?) {
    includeKeysInQuery(query, withPrefix: nil)
  }
  
  class func includeKeysInQuery(_ query: PFQuery<PFObject>?, withPrefix prefix: String?) {
    for (key, type) in includeKeys {
      var k: String = key
      if let p: String = prefix {
        k = "\(p).\(key)"
      }
      
      query?.includeKey(k)
      type.includeKeysInQuery(query, withPrefix: k)
    }
  }
}
