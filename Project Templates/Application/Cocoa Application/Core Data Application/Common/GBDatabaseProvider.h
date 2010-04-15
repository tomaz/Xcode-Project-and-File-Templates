//
//  GBDatabaseProvider.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GBServiceProvider;

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
/** This class provides common database related services to the application.

 This is very generic and therefore reusable class.
 */
@interface GBDatabaseProvider : NSObject
{
	BOOL initializationFailed;
	NSSortDescriptor* sortIndexSortDescriptor;
	NSPersistentStoreCoordinator* persistentStoreCoordinator;
	NSManagedObjectContext* managedObjectContext;
	NSManagedObjectModel* managedObjectModel;
	NSString* storeType;
	NSString* storePath;
	id delegate;
}

///---------------------------------------------------------------------------------------
/// @name Initialization & disposal
///---------------------------------------------------------------------------------------

/** Initializes database provider.

 This is the designated initializer. It determines the store type regarding to whether
 this is debug or release build - it uses XML store type for debug and SQLite for release.
 The filename is prepared using @c GBServiceProvider::applicationName() with extension
 regarding to the store type - @c .xml for XML store type and @c .data for any other.
 Then it sends @c initWithStoreType:path:() to the receiver.

 @param provider @c GBServiceProvider to get common data from.
 @return Returns initialized object or @c nil if initialization fails.
 @exception NSException Thrown if the given provider is @c nil.
 */
- (id) initWithGBServiceProvider:(GBServiceProvider*)provider;

/** Initializes database provider.

 Using this initializer given the client full control over database parameters. Note that
 this initializer is not suitable for creating in-memory database providers, use
 @c initWithInMemoryStoreType() for these cases!

 @param provider @c GBServiceProvider to get common data from.
 @param type The desired type of the store.
 @param filename Full path to the database filename.
 @return Returns initialized object or @c nil if initialization fails.
 @exception NSException Thrown if any of the given parameters is @c nil.
 */
- (id) initWithStoreType:(id)type path:(NSString*)path;

/** Initializes database provider with in-memory data store.

 @return Returns initialized object or @c nil if initialization fails.
 */
- (id) initWithInMemoryStoreType;

///---------------------------------------------------------------------------------------
/// @name Core Data handling
///---------------------------------------------------------------------------------------

/** Creates a new object for the entity with the given name.

 If creation fails, error is reported to the delegate if it implements
 @c GBDatabaseProviderDelegate::databaseProvider:objectCreationFailedForEntityName:()
 method, passing in the given entity name.

 Note that sending this message is equal to sending @c createObjectForEntityName:values:()
 and passing @c nil for values parameter.

 @param name The name of the entity for which to create a new object.
 @return Returns the created object or @c nil if creation failed.
 @exception NSException Thrown if the given name is @c nil.
 */
- (NSManagedObject*) createObjectForEntityName:(NSString*)name;

/** Creates a new object for the entity with the given name and optionally initializes
 default values to the given dictionary.

 The given dictionary keys must match the attribute names defined in the model and the
 values must match attribute types!

 If creation fails, error is reported to the delegate if it implements
 @c GBDatabaseProviderDelegate::databaseProvider:objectCreationFailedForEntityName:()
 method, passing in the given entity name.

 @param name The name of the entity for which to create a new object.
 @param values @c NSDictionary containing key value pairs to set in the managed object.
 @return Returns the created object or @c nil if creation failed.
 @exception NSException Thrown if the given name is @c nil.
 */
- (NSManagedObject*) createObjectForEntityName:(NSString*)name values:(NSDictionary*)values;

/** Deletes the given object from managed object context.

 @param object @c NSManagedObject to delete.
 @return Returns @c YES if object was deleted, @ NO if debugging options prevent deletion.
 */
- (BOOL) deleteObject:(NSManagedObject*)object;

/** Returns objects in the entity with the given name, filtered by the predicate and
 sorted with the given descriptor.

 If fetching fails, error is reported to the delegate if it implements
 @c GBDatabaseProviderDelegate::databaseProvider:fetchFailedForEntityName:withError:()
 method, passing in the given entity name and the error describing the reason for
 failure. The result is @c nil in such case.

 Note that internally this simply wraps the given descriptor into an array and sends the
 receiver objectsForEntityName:predicate:sortedWithDescriptors:().

 @param name The name of the entity to return objects from.
 @param predicate @c NSPredicate with which to filter the objects.
 @param descriptor Tje @c NSSortDescriptor to use for sorting.
 @return An array of @c NSManagedObjects matching the given parameters.
 */
- (NSArray*) objectsForEntityName:(NSString*)name
						predicate:(NSPredicate*)predicate
			 sortedWithDescriptor:(NSSortDescriptor*)descriptor;

/** Returns objects in the entity with the given name, filtered by the predicate and
 sorted with the given descriptors.

 If fetching fails, error is reported to the delegate if it implements
 @c GBDatabaseProviderDelegate::databaseProvider:fetchFailedForEntityName:withError:()
 method, passing in the given entity name and the error describing the reason for
 failure. The result is @c nil in such case.

 @param name The name of the entity to return objects from.
 @param predicate @c NSPredicate with which to filter the objects.
 @param descriptors An array of @c NSSortDescriptor.
 @return An array of @c NSManagedObjects matching the given parameters.
 */
- (NSArray*) objectsForEntityName:(NSString*)name
						predicate:(NSPredicate*)predicate
			sortedWithDescriptors:(NSArray*)descriptors;

/** Attempts to save the core data objects to persistent store.￼

 The method first commits editing which validates the changes and then saves the database.
 If any of the steps fails, error describing the reason is reported to the delegate.
 See @c GBDatabaseProviderDelegate::databaseProvider:saveFailedWithError:()

 @return Returns @c YES if data was succesfully saved, @c NO otherwise.
 */
- (BOOL) save;

/** Returns @c NSSortDescriptor used for sorting by sort index.

 This simplifies commonly used sorting in many applications. It assumes the objects
 have @c sortIndex attribute. Note that the object is created when the message is sent
 for the first time and is cached from then on.

 @return Returns the sort descriptor for @c sortIndex attribute.
 */
- (NSSortDescriptor*) sortIndexSortDescriptor;

///---------------------------------------------------------------------------------------
/// @name Core Data stack objects
///---------------------------------------------------------------------------------------

/** Returns core data managed object context.

 If managed object context is not yet created, it is automatically initialized. If
 initialization fails, error describing the reason of failure is logged, user is
 presented with the alert and application terminates.

 Note that initializing the context will also initialize or fetch default login groups.

 Also note that this value cannot be substituted. In fact, default implementation is
 sufficient for all cases, even for unit testing. The only Core Data related property
 that should be substituted for unit testing it @c persistentStoreCoordinator().
 */
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

/** Returns core data managed object model.

 If managed object model is not yet created, it is automatically initialized. If
 initialization fails, delegate is notified about it and any further Core Data
 initialization is prevented.
 */
@property (nonatomic, retain) NSManagedObjectModel* managedObjectModel;

/** Returns core data @c NSPersistentStoreCoordinator.

 If persistent store coordinator is not yet created, it is automatically initialized. If
 initialization fails, the delegate is notified about the error and any further Core Data
 initialization if prevented.
 */
@property (nonatomic, retain) NSPersistentStoreCoordinator* persistentStoreCoordinator;

///---------------------------------------------------------------------------------------
/// @name Notifications handling
///---------------------------------------------------------------------------------------

/** The delegate that gets informed about various states database provider detects.

 The database must conform to @c GBDatabaseProviderDelegate protocol.
 */
@property (assign) id delegate;

@end

#pragma mark -

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
/** @c GBDatabaseProviderDelegate formal protocol declares methods database providers
 delegate must implement in order to be notified about creation errors.
 */
@protocol GBDatabaseProviderDelegate

@optional

/** Notifies the delegate that creation of new managed object failed.

 This method is optional. If not implemented, delegate is not notified about the failure.

 @param provider @c GBDatabaseProvider that encountered error.
 @param name Entity name which object creation failed.
 @param error @c NSError describing the reason.
 */
- (void) databaseProvider:(GBDatabaseProvider*)provider
objectCreationFailedForEntityName:(NSString*)name
				withError:(NSError*)error;

/** Notifies the delegate that fetch request failed.

 This method is optional. If not implemented, delegate is not notified about the failure.

 @param provider @c GBDatabaseProvider that encountered error.
 @param name Entity name which fetch failed.
 @param error @c NSError describing the reason.
 */
- (void) databaseProvider:(GBDatabaseProvider*)provider
 fetchFailedForEntityName:(NSString*)name
				withError:(NSError*)error;

/** Notifies the delegate that save failed.

 This method is optional. If not implemented, delegate is not notified about the failure.

 @param provider @c GBDatabaseProvider that enountered error.
 @param error @c NSError describing the reason.
 */
- (void) databaseProvider:(GBDatabaseProvider*)provider
	  saveFailedWithError:(NSError*)error;

/** Notifies the delegate that managed object model initialization failed.

 This happens if no managed object model is found in the application. This means that
 the model file is missing from the application main bundle. Note that in such case any
 further Core Data initialization is cancelled, so the delegate can simply present the
 user with an alert. In most cases it is also valid to quit the application since it
 can't do any real job.

 This method is optional. If not implemented, delegate is not notified about the failure.

 @param provider @c GBDatabaseProvider that encountered error.
 */
- (void) databaseProviderModelInitFailed:(GBDatabaseProvider*)provider;

/** Notifies the delegate that persistent store coordinator initialization failed.

 This can happen with various reasons, but the most common is that the database was
 saved with newer version of the application or is corrupt. The delegate should present
 the error to the user. In most cases it is also valid to quit the application since it
 can't do any real job.

 This method is optional. If not implemented, delegate is not notified about the failure.

 @param provider @c GBDatabaseProvider that encountered error.
 @param error The error description.
 */
- (void) databaseProvider:(GBDatabaseProvider*)provider
 storeInitFailedWithError:(NSError*)error;

/** Notifies the delegate that store folder creation failed.

 This happens just prior than creating persistent store coordinator. In case of error,
 coordinator is not initialized! The delegate should present the error to the user. In
 most cases it is also valid to quit the application since it can't do any real job.

 This method is optional. If not implemented, delegate is not notified about the failure.

 @param provider @c GBDatabaseProvider that encountered error.
 @param error The error description.
 */
- (void) databaseProvider:(GBDatabaseProvider*)provider
storeFolderInitFailedWithError:(NSError*)error;

@end
