//
//  NSObject+GBObject.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GBModelController;
@class GBServiceProvider;
@class GBDatabaseProvider;

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
/** Defines a category with common functionality for all application's objects.
 */
@interface NSObject (GBObject)

///---------------------------------------------------------------------------------------
/// @name Initialization & disposal
///---------------------------------------------------------------------------------------

/** Removes all observations and otherwise cleans up the object.

 Default implementation doesn't do anything but subclasses can override it to perform
 clean up prior than finalization takes place. Of course the message needs to be sent
 manually.
 */
- (void) invalidate;

///---------------------------------------------------------------------------------------
/// @name Various helpers
///---------------------------------------------------------------------------------------

/** Returns a string representation of the object suitable for log messages.

 This is primarily used for subclasses of objects where default description isn't proper
 and overriding is not recommended (@c NSManagedObject subclasses for example).
 */
- (NSString*) logDescription;

///---------------------------------------------------------------------------------------
/// @name NSError creation support
///---------------------------------------------------------------------------------------

/** Constructs @c NSError object for application's domain with the given data.

 This is a helper method that simplifies @c NSError creation. It uses default application's
 domain and allows the client to pass in localized description and failure reason through
 parameters instead of bloating the code with dictionaries.

 @param code Error code - should come from the global errors enumeration.
 @param description Localized error description.
 @param reason Localized error reason or @c nil if not used.
 @return Returns initialized error.
 */
- (NSError*) errorWithCode:(NSInteger)code
			   description:(NSString*)description
			 failureReason:(NSString*)reason;

/** Constructs @c NSError object for application's domain with the given data.

 This is a helper method that simplifies @c NSError creation. It uses default application's
 domain and allows the client to pass in localized description and optional failure reason
 through parameters instead of bloating the code with dictionaries.

 Optionally, the client can pass an array of detailed errors which are added to the
 error's user info dictionary under @c NSDetailedErrorsKey key. If @c nil is passed,
 detailed errors is not used.

 @param code Error code - should come from the global errors enumeration.
 @param description Localized error description.
 @param reason Localized error reason or @c nil if not used.
 @param details @c NSArray containing the list of errors in case multiple errors occur.
 @return Returns initialized error.
 */
- (NSError*) errorWithCode:(NSInteger)code
			   description:(NSString*)description
			 failureReason:(NSString*)reason
				   details:(NSArray*)details;

/** Constructs @c NSError object for application's domain with the given data.

 This is a helper method that simplifies details errors creation. It uses default
 application's domain and allows the client to pass in localized description and optional
 failure reason through parameters instead of bloating the code with dictionaries.

 The main difference with this method and @c errorWithCode:description:failureReason:details:()
 is that this method result varies regarding the given details array as follows:

 - If details array is @c nil, the method simply creates a new error by sending the receiver
	@c errorWithCode:description:failureReason:(), passing it the given code, descrition
	and reason.
 - If details array contains only one object, the given object is returned.
 - If details array contains more than one object, a new error is created by sending the
	receiver @c errorWithCode:description:failureReason:details:(), passing it all of the
	parameters which results in an error with detailed errors key.

 @param code Error code - should come from the global errors enumeration.
 @param description Localized error description.
 @param reason Localized error reason or @c nil if not used.
 @param details @c NSArray containing the list of errors in case multiple errors occur.
 @return Returns initialized error.
 */
- (NSError*) detailedErrorWithCode:(NSInteger)code
					   description:(NSString*)description
					 failureReason:(NSString*)reason
						   details:(NSArray*)details;

///---------------------------------------------------------------------------------------
/// @name ServiceProvider application objects
///---------------------------------------------------------------------------------------

/** Returns the application's @c ModelController. */
@property (readonly) GBModelController* modelController;

/** Returns the application's @c ServiceProvider. */
@property (readonly) GBServiceProvider* serviceProvider;

/** Returns the application's @c DatabaseProvider. */
@property (readonly) GBDatabaseProvider* databaseProvider;

///---------------------------------------------------------------------------------------
/// @name ServiceProvider foundation & AppKit objects
///---------------------------------------------------------------------------------------

/** Returns the @c NSNotificationCenter assigned to @c ServiceProvider. */
@property (readonly) NSNotificationCenter* notificationCenter;

/** Returns the @c NSFileManager assigned to @c ServiceProvider. */
@property (readonly) NSFileManager* fileManager;

/** Returns the @c NSWorkspace assigned to @c ServiceProvider. */
@property (readonly) NSWorkspace* workspace;

/** Returns the standard @c NSUserDefaults object. */
@property (readonly) NSUserDefaults* userDefaults;

@end

#pragma mark -

/** Application-wide error codes. */
enum GBErrorCodes
{
	kGBErrorDatabaseCommitBeforeSave = 1,
	kGBErrorDatabaseObjectCreation,
	kGBErrorDatabaseFetchMissingEntity,
};
