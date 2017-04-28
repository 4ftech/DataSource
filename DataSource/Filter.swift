//
//  Filter.swift
//  DataSource
//
//  Created by Nick Kuyakanon on 4/19/17.
//  Copyright © 2017 4f Tech. All rights reserved.
//

import Foundation
import PromiseKit

public enum FilterType: String {
  case select, date, dateRange, slider
}

public enum SelectType: String {
  case one, multiple
}

open class Filter: NSObject, NSCopying {
  public var title: String
  public var key: String
  public var type: FilterType
  
  init(title: String, key: String, type: FilterType) {
    self.title = title
    self.key = key
    self.type = type
  }
  
  func apply(to request: FetchRequest) {
    assert(false, "You must override apply in your Filter subclass")
  }
  
  public func copy(with zone: NSZone? = nil) -> Any {
    assert(false, "You must override copy in your Filter subclass")
  }
}


//////////
open class DateFilter: Filter {
  public var selectedDate: Date?
  
  init(title: String, key: String) {
    super.init(title: title, key: key, type: .date)
  }
  
  override func apply(to request: FetchRequest) {
    if let date = selectedDate {
      request.whereKey(key, equalTo: date)
    }
  }
  
  public override func copy(with zone: NSZone?) -> Any {
    let filter = DateFilter(title: self.title, key: self.key)
    filter.selectedDate = self.selectedDate
    return filter
  }
}

open class DateRangeFilter: Filter {
  public var startDate: Date?
  public var endDate: Date?
  
  init(title: String, key: String) {
    super.init(title: title, key: key, type: .dateRange)
  }
  
  func clearFilter() {
    startDate = nil
    endDate = nil
  }
  
  override func apply(to request: FetchRequest) {
    if let date = startDate {
      request.whereKey(key, greaterThanOrEqualTo: date)
    }
    
    if let date = endDate {
      request.whereKey(key, lessThanOrEqualTo: date)
    }
  }
  
  public override func copy(with zone: NSZone?) -> Any {
    let filter = DateRangeFilter(title: self.title, key: self.key)
    filter.startDate = self.startDate
    filter.endDate = self.endDate
    return filter
  }
}


//////////
open class SelectFilter<T>: Filter where T: Equatable {
  public var filterOptions: [SelectFilterOption<T>] = []
  public var selectedValues: [SelectFilterOption<T>] = []
  public var optionsLoaded = false
  public var selectType: SelectType = .one
  
  init(title: String, key: String, selectType: SelectType, filterOptions: [SelectFilterOption<T>]? = nil) {
    super.init(title: title, key: key, type: .select)
    
    self.selectType = selectType
    
    if let filterOptions = filterOptions {
      self.filterOptions = filterOptions
      self.optionsLoaded = true
    }
  }
  
  override func apply(to request: FetchRequest) {
    switch selectType {
    case .one:
      if let selectedValue = selectedValues.first {
        request.whereKey(key, equalTo: selectedValue.value)
      }
    case .multiple:
      if selectedValues.count > 0 {
        request.whereKey(key, containedIn: selectedValues)
      }
    }
  }
  
  public override func copy(with zone: NSZone?) -> Any {
    let filter = SelectFilter(title: self.title, key: self.key, selectType: self.selectType, filterOptions: self.filterOptions)
    filter.selectedValues = self.selectedValues
    return filter
  }
  
  public func select(value: SelectFilterOption<T>) {
    if filterOptions.contains(value) {
      switch selectType {
      case .one:
        selectedValues = [value]
      case .multiple:
        if !selectedValues.contains(value) {
          selectedValues.append(value)
        }
      }
    }
  }
  
  public func deselect(value: SelectFilterOption<T>) {
    if let index = selectedValues.index(of: value) {
      selectedValues.remove(at: index)
    }
  }
  
  public func clearFilter() {
    selectedValues = []
  }
  
  public func loadOptions() -> Promise<[SelectFilterOption<T>]> {
    return Promise(value: filterOptions)
  }
}

open class SelectFilterOption<T>: NSObject where T:Equatable {
  public var value: T!
  public var name: String!
  
  open override var description: String {
    return name
  }
  
  init(value: T, name: String) {
    super.init()
    
    self.value = value
    self.name = name
  }
  
  open override func isEqual(_ object: Any?) -> Bool {
    if let otherOption = object as? SelectFilterOption {
      return self.value == otherOption.value
    }
    
    return false
  }
  
  static func == (lhs: SelectFilterOption, rhs: SelectFilterOption) -> Bool {
    return lhs.isEqual(rhs)
  }
  
}

//////////////////
open class DataSourceSelectFilter<T>: SelectFilter<String> where T:BaseDataModel {
  override public func loadOptions() -> Promise<[SelectFilterOption<String>]> {
    return T.getAll().then { (rows: [T]) in
      for row in rows {
        // Prefer value: objectId, name: name -- but this also sets both value and name
        // of the option to objectId or name if only 1 exists
        let value = row.objectId ?? row.name
        let name = row.name ?? row.objectId
        
        if let value = value, let name = name {
          self.filterOptions.append(SelectFilterOption(value: value, name: name))
        }
      }

      self.optionsLoaded = true
      
      return Promise(value: self.filterOptions)
    }.catch { error in
      NSLog("\(error)")
    }
  }
}
