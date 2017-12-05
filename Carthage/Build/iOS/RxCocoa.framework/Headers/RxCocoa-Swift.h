// Generated by Apple Swift version 4.0.2 effective-3.2.2 (swiftlang-900.0.69.2 clang-900.0.38)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_attribute(external_source_symbol)
# define SWIFT_STRINGIFY(str) #str
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name) _Pragma(SWIFT_STRINGIFY(clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in=module_name, generated_declaration))), apply_to=any(function, enum, objc_interface, objc_category, objc_protocol))))
# define SWIFT_MODULE_NAMESPACE_POP _Pragma("clang attribute pop")
#else
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name)
# define SWIFT_MODULE_NAMESPACE_POP
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import ObjectiveC;
@import UIKit;
@import Foundation;
#endif

#import <RxCocoa/RxCocoa.h>

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

SWIFT_MODULE_NAMESPACE_PUSH("RxCocoa")

SWIFT_CLASS("_TtC7RxCocoa8RxTarget")
@interface RxTarget : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (void)dispose;
@end

@class UIBarButtonItem;

SWIFT_CLASS("_TtC7RxCocoa19BarButtonItemTarget")
@interface BarButtonItemTarget : RxTarget
@property (nonatomic, weak) UIBarButtonItem * _Nullable barButtonItem;
@property (nonatomic, copy) void (^ _Null_unspecified callback)(void);
- (nonnull instancetype)initWithBarButtonItem:(UIBarButtonItem * _Nonnull)barButtonItem callback:(void (^ _Nonnull)(void))callback OBJC_DESIGNATED_INITIALIZER;
- (void)dispose;
- (void)action:(id _Nonnull)sender;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class UICollectionView;
@class UICollectionViewCell;

SWIFT_CLASS("_TtC7RxCocoa30CollectionViewDataSourceNotSet")
@interface CollectionViewDataSourceNotSet : NSObject <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIControl;

SWIFT_CLASS("_TtC7RxCocoa13ControlTarget")
@interface ControlTarget : RxTarget
@property (nonatomic, readonly) SEL _Nonnull selector;
@property (nonatomic, weak) UIControl * _Nullable control;
@property (nonatomic, readonly) UIControlEvents controlEvents;
@property (nonatomic, copy) void (^ _Nullable callback)(UIControl * _Nonnull);
- (nonnull instancetype)initWithControl:(UIControl * _Nonnull)control controlEvents:(UIControlEvents)controlEvents callback:(void (^ _Nonnull)(UIControl * _Nonnull))callback OBJC_DESIGNATED_INITIALIZER;
- (void)eventHandler:(UIControl * _Null_unspecified)sender;
- (void)dispose;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// Base class for <code>DelegateProxyType</code> protocol.
/// This implementation is not thread safe and can be used only from one thread (Main thread).
SWIFT_CLASS("_TtC7RxCocoa13DelegateProxy")
@interface DelegateProxy : _RXDelegateProxy
/// Parent object associated with delegate proxy.
@property (nonatomic, readonly, weak) id _Nullable parentObject;
/// Initializes new instance.
/// \param parentObject Optional parent object that owns <code>DelegateProxy</code> as associated object.
///
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
- (void)_sentMessage:(SEL _Nonnull)selector withArguments:(NSArray * _Nonnull)arguments;
- (void)_methodInvoked:(SEL _Nonnull)selector withArguments:(NSArray * _Nonnull)arguments;
/// Returns tag used to identify associated object.
///
/// returns:
/// Associated object tag.
+ (void const * _Nonnull)delegateAssociatedObjectTag SWIFT_WARN_UNUSED_RESULT;
/// Initializes new instance of delegate proxy.
///
/// returns:
/// Initialized instance of <code>self</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// Returns assigned proxy for object.
/// \param object Object that can have assigned delegate proxy.
///
///
/// returns:
/// Assigned delegate proxy or <code>nil</code> if no delegate proxy is assigned.
+ (id _Nullable)assignedProxyFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// Assigns proxy to object.
/// \param object Object that can have assigned delegate proxy.
///
/// \param proxy Delegate proxy object to assign to <code>object</code>.
///
+ (void)assignProxy:(id _Nonnull)proxy toObject:(id _Nonnull)object;
/// Sets reference of normal delegate that receives all forwarded messages
/// through <code>self</code>.
/// \param forwardToDelegate Reference of delegate that receives all messages through <code>self</code>.
///
/// \param retainDelegate Should <code>self</code> retain <code>forwardToDelegate</code>.
///
- (void)setForwardToDelegate:(id _Nullable)delegate retainDelegate:(BOOL)retainDelegate;
/// Returns reference of normal delegate that receives all forwarded messages
/// through <code>self</code>.
///
/// returns:
/// Value of reference if set or nil.
- (id _Nullable)forwardToDelegate SWIFT_WARN_UNUSED_RESULT;
- (BOOL)respondsToSelector:(SEL _Null_unspecified)aSelector SWIFT_WARN_UNUSED_RESULT;
- (void)reset;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class RxTextStorageDelegateProxy;

@interface NSTextStorage (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxTextStorageDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
@end


/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa31RxCollectionViewDataSourceProxy")
@interface RxCollectionViewDataSourceProxy : DelegateProxy <UICollectionViewDataSource>
/// Typed parent object.
@property (nonatomic, readonly, weak) UICollectionView * _Nullable collectionView;
/// Initializes <code>RxCollectionViewDataSourceProxy</code>
/// \param parentObject Parent object for delegate proxy.
///
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
/// Required delegate method implementation.
- (NSInteger)collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
/// Required delegate method implementation.
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void const * _Nonnull)delegateAssociatedObjectTag SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
- (void)setForwardToDelegate:(id _Nullable)forwardToDelegate retainDelegate:(BOOL)retainDelegate;
@end

@class UIScrollView;

/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa25RxScrollViewDelegateProxy")
@interface RxScrollViewDelegateProxy : DelegateProxy <UIScrollViewDelegate>
/// Typed parent object.
@property (nonatomic, readonly, weak) UIScrollView * _Nullable scrollView;
/// Initializes <code>RxScrollViewDelegateProxy</code>
/// \param parentObject Parent object for delegate proxy.
///
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
/// For more information take a look at <code>DelegateProxyType</code>.
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
@end


/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa29RxCollectionViewDelegateProxy")
@interface RxCollectionViewDelegateProxy : RxScrollViewDelegateProxy <UICollectionViewDelegateFlowLayout>
/// Typed parent object.
@property (nonatomic, readonly, weak) UICollectionView * _Nullable collectionView;
/// Initializes <code>RxCollectionViewDelegateProxy</code>
/// \param parentObject Parent object for delegate proxy.
///
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
@end


/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa35RxNavigationControllerDelegateProxy")
@interface RxNavigationControllerDelegateProxy : DelegateProxy <UINavigationControllerDelegate>
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
@end


@interface RxNavigationControllerDelegateProxy (SWIFT_EXTENSION(RxCocoa)) <UIImagePickerControllerDelegate>
@end

@class UIPickerView;

/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa27RxPickerViewDataSourceProxy")
@interface RxPickerViewDataSourceProxy : DelegateProxy <UIPickerViewDataSource>
/// Typed parent object.
@property (nonatomic, readonly, weak) UIPickerView * _Nullable pickerView;
/// Initializes <code>RxPickerViewDataSourceProxy</code>
/// \param parentObject Parent object for delegate proxy.
///
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
/// Required delegate method implementation.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView * _Nonnull)pickerView SWIFT_WARN_UNUSED_RESULT;
/// Required delegate method implementation.
- (NSInteger)pickerView:(UIPickerView * _Nonnull)pickerView numberOfRowsInComponent:(NSInteger)component SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void const * _Nonnull)delegateAssociatedObjectTag SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
- (void)setForwardToDelegate:(id _Nullable)forwardToDelegate retainDelegate:(BOOL)retainDelegate;
@end


SWIFT_CLASS("_TtC7RxCocoa25RxPickerViewDelegateProxy")
@interface RxPickerViewDelegateProxy : DelegateProxy <UIPickerViewDelegate>
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
@end



/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa24RxSearchBarDelegateProxy")
@interface RxSearchBarDelegateProxy : DelegateProxy <UISearchBarDelegate>
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
@end


/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa31RxSearchControllerDelegateProxy") SWIFT_AVAILABILITY(ios,introduced=8.0)
@interface RxSearchControllerDelegateProxy : DelegateProxy <UISearchControllerDelegate>
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
@end


/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa31RxTabBarControllerDelegateProxy")
@interface RxTabBarControllerDelegateProxy : DelegateProxy <UITabBarControllerDelegate>
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
@end


/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa21RxTabBarDelegateProxy")
@interface RxTabBarDelegateProxy : DelegateProxy <UITabBarDelegate>
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
@end

@class UITableView;
@class UITableViewCell;

/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa26RxTableViewDataSourceProxy")
@interface RxTableViewDataSourceProxy : DelegateProxy <UITableViewDataSource>
/// Typed parent object.
@property (nonatomic, readonly, weak) UITableView * _Nullable tableView;
/// Initializes <code>RxTableViewDataSourceProxy</code>
/// \param parentObject Parent object for delegate proxy.
///
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
/// Required delegate method implementation.
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
/// Required delegate method implementation.
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void const * _Nonnull)delegateAssociatedObjectTag SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
- (void)setForwardToDelegate:(id _Nullable)forwardToDelegate retainDelegate:(BOOL)retainDelegate;
@end


/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa24RxTableViewDelegateProxy")
@interface RxTableViewDelegateProxy : RxScrollViewDelegateProxy <UITableViewDelegate>
/// Typed parent object.
@property (nonatomic, readonly, weak) UITableView * _Nullable tableView;
/// Initializes <code>RxTableViewDelegateProxy</code>
/// \param parentObject Parent object for delegate proxy.
///
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
@end



SWIFT_CLASS("_TtC7RxCocoa26RxTextStorageDelegateProxy")
@interface RxTextStorageDelegateProxy : DelegateProxy <NSTextStorageDelegate>
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
@end

@class UITextView;

/// For more information take a look at <code>DelegateProxyType</code>.
SWIFT_CLASS("_TtC7RxCocoa23RxTextViewDelegateProxy")
@interface RxTextViewDelegateProxy : RxScrollViewDelegateProxy <UITextViewDelegate>
/// Typed parent object.
@property (nonatomic, readonly, weak) UITextView * _Nullable textView;
/// Initializes <code>RxTextViewDelegateProxy</code>
/// \param parentObject Parent object for delegate proxy.
///
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
/// For more information take a look at <code>DelegateProxyType</code>.
- (BOOL)textView:(UITextView * _Nonnull)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString * _Nonnull)text SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC7RxCocoa22RxWebViewDelegateProxy")
@interface RxWebViewDelegateProxy : DelegateProxy <UIWebViewDelegate>
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nonnull)createProxyForObject:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (void)setCurrentDelegate:(id _Nullable)delegate toObject:(id _Nonnull)object;
/// For more information take a look at <code>DelegateProxyType</code>.
+ (id _Nullable)currentDelegateFor:(id _Nonnull)object SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithParentObject:(id _Nonnull)parentObject OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC7RxCocoa25TableViewDataSourceNotSet")
@interface TableViewDataSourceNotSet : NSObject <UITableViewDataSource>
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface UICollectionView (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxScrollViewDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
/// Factory method that enables subclasses to implement their own <code>rx.dataSource</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>dataSource</code>.
- (RxCollectionViewDataSourceProxy * _Nonnull)createRxDataSourceProxy SWIFT_WARN_UNUSED_RESULT;
@end


@interface UINavigationController (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxNavigationControllerDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
@end


@interface UIPickerView (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxPickerViewDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
/// Factory method that enables subclasses to implement their own <code>rx.dataSource</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>dataSource</code>.
- (RxPickerViewDataSourceProxy * _Nonnull)createRxDataSourceProxy SWIFT_WARN_UNUSED_RESULT;
@end


@interface UIScrollView (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxScrollViewDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
@end


@interface UISearchBar (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxSearchBarDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
@end


@interface UISearchController (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxSearchControllerDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
@end


@interface UITabBar (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxTabBarDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
@end


@interface UITabBarController (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxTabBarControllerDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
@end


@interface UITableView (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxScrollViewDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
/// Factory method that enables subclasses to implement their own <code>rx.dataSource</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>dataSource</code>.
- (RxTableViewDataSourceProxy * _Nonnull)createRxDataSourceProxy SWIFT_WARN_UNUSED_RESULT;
@end


@interface UITextView (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxScrollViewDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
@end


@interface UIWebView (SWIFT_EXTENSION(RxCocoa))
/// Factory method that enables subclasses to implement their own <code>delegate</code>.
///
/// returns:
/// Instance of delegate proxy that wraps <code>delegate</code>.
- (RxWebViewDelegateProxy * _Nonnull)createRxDelegateProxy SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC7RxCocoa40_RxCollectionViewReactiveArrayDataSource")
@interface _RxCollectionViewReactiveArrayDataSource : NSObject <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView * _Nonnull)in SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)_collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC7RxCocoa35_RxTableViewReactiveArrayDataSource")
@interface _RxTableViewReactiveArrayDataSource : NSObject <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)_tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

SWIFT_MODULE_NAMESPACE_POP
#pragma clang diagnostic pop
