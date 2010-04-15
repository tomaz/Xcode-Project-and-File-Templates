//
//  GBDatabaseProvider.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "NSObject+DDExtensions.h"
#import "GBServiceProvider.h"
#import "GBDatabaseProvider.h"

@interface GBDatabaseProvider ()

- (BOOL) delegateRespondsTo:(SEL)selector;
@property (retain) NSString* storeType;
@property (retain) NSString* storePath;

@end

#pragma mark -

@implementation GBDatabaseProvider

#pragma mark Initialization & disposal

- (id) initWithGBServiceProvider:(GBServiceProvider*)provider
{
	logDebug(@"Initializing with service provider...");
	NSParameterAssert(provider != nil);

	NSString* type = nil;
	NSString* path = [provider.applicationSupportFolder stringByAppendingPathComponent:provider.applicationName];
#ifdef BUILD_DEBUG
	type = NSXMLStoreType;
	path = [path stringByAppendingPathExtension:@"xml"];
#else
	type = NSSQLiteStoreType;
	path = [path stringByAppendingPathExtension:@"data"];
#endif

	return [self initWithStoreType:type path:path];
}

- (id) initWithStoreType:(NSString*)type path:(NSString*)path
{
	logDebug(@"Initializing with store type %@, path %@...", type, path);
	NSParameterAssert(type != nil);
	NSParameterAssert(path != nil);
	self = [super init];
	if (self)
	{
		self.storeType = type;
		self.storePath = path;
	}
	return self;
}

- (id) initWithInMemoryStoreType
{
	logDebug(@"Initializing with in-memory store type...");
	self = [super init];
	if (self)
	{
		self.storeType = NSInMemoryStoreType;
		self.storePath = nil;
	}
	return self;
}

- (void) invalidate
{
	logDebug(@"Invalidating...");
	self.storeType = nil;
	self.storePath = nil;
	sortIndexSortDescriptor = nil;
}

#pragma mark Core Data handling

- (NSManagedObject*) createObjectForEntityName:(NSString*)name
{
	return [self createObjectForEntityName:name values:nil];
}

- (NSManagedObject*) createObjectForEntityName:(NSString*)name values:(NSDictionary*)values
{
	if (!self.serviceProvider.debuggingOptions.canAddObjectsToDatabase)
	{
		logWarn(@"Adding objects to database is prevented by debugging options!");
		return nil;
	}

	// Create the object and return if this fails.
	logVerbose(@"Creating new %@ managed object...", name);
	NSManagedObject* result = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
	if (!result)
	{
		logError(@"Failed creating new @c managed object!", name);
		if ([self delegateRespondsTo:@selector(databaseProvider:objectCreationFailedForEntityName:withError:)])
		{
			NSString* description = NSLocalizedString(@"Failed creating new database object!",
													  @"Error description for database object creation");
			NSString* reason = NSLocalizedString(@"Couldn't create an instance of %@ entity.",
												 @"Error reason for database object creation");
			NSError* error = [self errorWithCode:kGBErrorDatabaseObjectCreation description:description failureReason:reason];
			[[self.delegate dd_invokeOnMainThread] databaseProvider:self objectCreationFailedForEntityName:name withError:error];
		}
		return nil;
	}

	// Fill in the values if provided.
	if (values)
	{
		logDebug(@"Filling in %u values...", [values count]);
		for (NSString* key in [values allKeys])
		{
			[result setValue:[values objectForKey:key] forKey:key];
		}
	}

	return result;
}

- (BOOL) deleteObject:(NSManagedObject*)object
{
	if (!self.serviceProvider.debuggingOptions.canRemoveObjectsFromDatabase)
	{
		logWarn(@"Deleting objects from database is prevented by debugging options!");
		return NO;
	}
	logVerbose(@"Deleting managed object...");
	[self.managedObjectContext deleteObject:object];
	return YES;
}

- (NSArray*) objectsForEntityName:(NSString*)name
						predicate:(NSPredicate*)predicate
			 sortedWithDescriptor:(NSSortDescriptor*)descriptor
{
	NSArray* descriptors = descriptor ? [NSArray arrayWithObject:descriptor] : nil;
	return [self objectsForEntityName:name predicate:predicate sortedWithDescriptors:descriptors];
}

- (NSArray*) objectsForEntityName:(NSString*)name
						predicate:(NSPredicate*)predicate
			sortedWithDescriptors:(NSArray*)descriptors
{
	logVerbose(@"Fetching objects for entity %@...", name);
	NSError* error = nil;

	// If given entity doesn't exist exit, notify delegate and exit.
	NSEntityDescription *entity = [[self.managedObjectModel entitiesByName] objectForKey:name];
	if (!entity)
	{
		logError(@"Failed fetching objects for entity %@ because entity doesn't exist in model!", name);
		if ([self delegateRespondsTo:@selector(databaseProvider:fetchFailedForEntityName:withError:)])
		{
			NSString* description = NSLocalizedString(@"Failed reading database objects!",
													  @"Error description for fetching missing entity");
			NSString* reason = NSLocalizedString(@"Entity %@ doesn't exist in database model.",
												 @"Error reason for fetching missing entity.");
			error = [self errorWithCode:kGBErrorDatabaseFetchMissingEntity
							description:description
						  failureReason:[NSString stringWithFormat:reason, name]];
			if ([self delegateRespondsTo:@selector(databaseProvider:fetchFailedForEntityName:withError:)])
				[[self.delegate dd_invokeOnMainThread] databaseProvider:self fetchFailedForEntityName:name withError:error];
		}
		return nil;
	}

	// Fetch the objects from the context.
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	[request setPredicate:predicate];
	[request setSortDescriptors:descriptors];
	NSArray* result = [self.managedObjectContext executeFetchRequest:request error:&error];
	[request release];

	// If there was an error, notify delegate and exit.
	if (error)
	{
		logError(@"Failed fetching objects for entity %@, error was %@!", name, [error localizedDescription]);
		if ([self delegateRespondsTo:@selector(databaseProvider:fetchFailedForEntityName:withError:)])
			[[self.delegate dd_invokeOnMainThread] databaseProvider:self fetchFailedForEntityName:name withError:error];
		return nil;
	}

	return result;
}

- (BOOL) save
{
	// If database was not initialized, we don't have to save anything!
	if (!managedObjectContext) return YES;

	logVerbose(@"Saving database...");
	NSError* error = nil;
	if (![self.managedObjectContext commitEditing])
	{
		NSString* description = NSLocalizedString(@"Failed saving application data because it is invalid!",
												  @"Error description for commit editing before saving");
		NSString* reason = NSLocalizedString(@"One or more of the application files may have been corrupted. "
											 @"Please contact support to assist with this error.",
											 @"Error reason for commit editing before saving");
		error = [self errorWithCode:kGBErrorDatabaseCommitBeforeSave
						description:description
					  failureReason:reason];
		if ([self delegateRespondsTo:@selector(databaseProvider:saveFailedWithError:)])
			[[self.delegate dd_invokeOnMainThread] databaseProvider:self saveFailedWithError:error];
		return NO;
	}

	if (![self.managedObjectContext save:&error])
	{
		if ([self delegateRespondsTo:@selector(databaseProvider:saveFailedWithError:)])
			[[self.delegate dd_invokeOnMainThread] databaseProvider:self saveFailedWithError:error];
		return NO;
	}
	return YES;
}

- (NSSortDescriptor*) sortIndexSortDescriptor
{
	if (sortIndexSortDescriptor) return sortIndexSortDescriptor;
	sortIndexSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES];
	return sortIndexSortDescriptor;
}

#pragma mark Core Data stack handling

- (NSManagedObjectContext*) managedObjectContext
{
	if (managedObjectContext || initializationFailed) return managedObjectContext;
	logDebug(@"Initializing managed object context...");

	// Get or initialize persistent store coordinator. If this fails, prevent any further
	// initialization. Note that we don't have to notify the delegate, since it was already
	// notified while creating the coordinator.
	NSPersistentStoreCoordinator* psc = self.persistentStoreCoordinator;
	if (!psc) return nil;

	managedObjectContext = [[NSManagedObjectContext alloc] init];
	[managedObjectContext setPersistentStoreCoordinator:psc];
	return managedObjectContext;
}

- (NSManagedObjectModel*) managedObjectModel
{
	if (managedObjectModel || initializationFailed) return managedObjectModel;
	logDebug(@"Initializing managed object model...");
	managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
	if (!managedObjectModel)
	{
		logError(@"Failed initializing managed object model...");
		initializationFailed = YES;
		if ([self delegateRespondsTo:@selector(databaseProviderModelInitFailed:)])
			[[self.delegate dd_invokeOnMainThread] databaseProviderModelInitFailed:self];
	}
	return managedObjectModel;
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator
{
	if (persistentStoreCoordinator || initializationFailed) return persistentStoreCoordinator;
	logDebug(@"Initializing persistent store coordinator...");

	// Get or initialize managed object model. If this fails, exit - we don't have to
	// notify the client since it was already notified about invalid model.
	NSManagedObjectModel* mom = self.managedObjectModel;
	if (!mom) return nil;

	// Create the folder if given. If this fails, notify the delegate and exit.
	NSError* error = nil;
	if (self.storePath)
	{
		NSString* path = [self.storePath stringByDeletingLastPathComponent];
		if (![self.fileManager fileExistsAtPath:path isDirectory:NULL])
		{
			logDebug(@"Creating store folder at %@...", path);
			if (![self.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
			{
				logNSError(error, @"Failed creating store path at %@!", path);
				initializationFailed = YES;
				if ([self delegateRespondsTo:@selector(databaseProvider:storeFolderInitFailedWithError:)])
					[[self.delegate dd_invokeOnMainThread] databaseProvider:self storeFolderInitFailedWithError:error];
				return nil;
			}
		}
	}

	// Initialize the store coordinator. If this fails, notify the delegate and exit.
	NSURL* url = self.storePath ? [NSURL fileURLWithPath:self.storePath] : nil;
	NSMutableDictionary* options = [NSMutableDictionary dictionary];
	[options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
	if (![persistentStoreCoordinator addPersistentStoreWithType:self.storeType configuration:nil URL:url options:options error:&error])
	{
		logNSError(error, @"Failed creating persistent store coordinator!");
		initializationFailed = YES;
		persistentStoreCoordinator = nil;
		if ([self delegateRespondsTo:@selector(databaseProvider:storeInitFailedWithError:)])
			[[self.delegate dd_invokeOnMainThread] databaseProvider:self storeInitFailedWithError:error];
	}
	return persistentStoreCoordinator;
}

#pragma mark Helper methods

- (BOOL) delegateRespondsTo:(SEL)selector
{
	return (self.delegate && [self.delegate respondsToSelector:selector]);
}

#pragma mark Properties

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;
@synthesize storeType;
@synthesize storePath;
@synthesize delegate;

@end
