//
//  Utils.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 3/2/17.
//  Copyright © 2017 4f Tech. All rights reserved.
//

import Foundation

public class Utils {
  public class func performOnMainThread(_ fn: @escaping () -> Void) {
    DispatchQueue.main.async(execute: {
      fn()
    })
  }
}
