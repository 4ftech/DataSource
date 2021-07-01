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
  
  public var isApplied: Bool { return false }
  public var filterDescription: String? { return nil }
  
  init(title: String, key: String, type: FilterType) {
    self.title = title
    self.key = key
    self.type = type
  }
  
  public func clearFilter() {
    assert(false, "You must override clearFilter in your Filter subclass")
  }
  
  public func apply(to request: FetchRequest) {
    assert(false, "You must override apply in your Filter subclass")
  }
  
  public func copy(with zone: NSZone? = nil) -> Any {
    assert(false, "You must override copy in your Filter subclass")
    return Filter(title: self.title, key: self.key, type: self.type)
  }
}


//////////
open class DateFilter: Filter {
  public var selectedDate: Date?
  
  override public var isApplied: Bool {
    return selectedDate != nil
  }
  
  init(title: String, key: String) {
    super.init(title: title, key: key, type: .date)
  }
  
  public override func clearFilter() {
    selectedDate = nil
  }
  
  public override func apply(to request: FetchRequest) {
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
  
  override public var isApplied: Bool {
    return startDate != nil || endDate != nil
  }
  
  init(title: String, key: String) {
    super.init(title: title, key: key, type: .dateRange)
  }
  
  public override func clearFilter() {
    startDate = nil
    endDate = nil
  }
  
  public override func apply(to request: FetchRequest) {
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
open class SelectFilter: Filter {
  public var filterOptions: [SelectFilterOption] = []
  public var selectedValues: [SelectFilterOption] = []
  public var optionsLoaded = false
  public var selectType: SelectType = .one
  
  open override var isApplied: Bool {
    return selectedValues.count > 0
  }
  
  open override var filterDescription: String? {
    return selectedValues.map { $0.name }.joined(separator: ", ")
  }
  
  public init(title: String, key: String, selectType: SelectType, filterOptions: [SelectFilterOption]? = nil) {
    super.init(title: title, key: key, type: .select)
    
    self.selectType = selectType
    
    if let filterOptions = filterOptions {
      self.filterOptions = filterOptions
      self.optionsLoaded = true
    }
  }
  
  open override func apply(to request: FetchRequest) {
    switch selectType {
    case .one:
      if let selectedValue = selectedValues.first {
        request.whereKey(key, equalTo: selectedValue.value!)
      }
    case .multiple:
      if selectedValues.count > 0 {
        request.whereKey(key, containedIn: selectedValues.map { $0.value! })
      }
    }
  }
  
  public override func copy(with zone: NSZone?) -> Any {
    let filter = SelectFilter(title: self.title, key: self.key, selectType: self.selectType, filterOptions: self.filterOptions)
    filter.selectedValues = self.selectedValues
    return filter
  }
  
  open func select(value: SelectFilterOption) {
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
  
  open func deselect(value: SelectFilterOption) {
    if let index = selectedValues.firstIndex(of: value) {
      selectedValues.remove(at: index)
    }
  }
  
  open override func clearFilter() {
    selectedValues = []
  }
  
  open func loadOptions() -> Promise<[SelectFilterOption]> {
    return Promise.value(filterOptions)
  }
}

open class SelectFilterOption: NSObject {
  public var value: Any!
  public var name: String!
  
  open override var description: String {
    return name
  }
  
  public init(value: Any, name: String) {
    super.init()
    
    self.value = value
    self.name = name
  }
  
  open override func isEqual(_ object: Any?) -> Bool {
    if let value = value as? String, let otherValue = (object as? SelectFilterOption)?.value as? String {
      return value == otherValue
    } else if let value = value as? Int, let otherValue = (object as? SelectFilterOption)?.value as? Int {
      return value == otherValue
    } else if let value = value as? NSObject, let otherValue = (object as? SelectFilterOption)?.value as? NSObject {
      return value.isEqual(otherValue)
    } else {
      fatalError("Need to handle SelectFilterOption equality type")
    }
  }
  
  static func == (lhs: SelectFilterOption, rhs: SelectFilterOption) -> Bool {
    return lhs.isEqual(rhs)
  }
  
}

//////////////////
open class DataSourceSelectFilter<T>: SelectFilter where T:ObjectMapperDataModel {
  override open func loadOptions() -> Promise<[SelectFilterOption]> {
    return T.getAll().then { (rows: [T]) -> Promise<[SelectFilterOption]> in
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

      return Promise.value(self.filterOptions)
    }
  }
}
