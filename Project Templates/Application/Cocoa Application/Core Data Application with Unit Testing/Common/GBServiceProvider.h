//
//  GBServiceProvider.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
/** As the name implies, this class provides services to the whole application.

 The main drive behind this class is to provide one entry point for different
 services. This greatly reduces application coupling to various foundation and AppKit
 level objects, especially to ones implemented as singletons (@c NSNotificationCenter,
 @c NSFileManager, @c NSWorkspace etc.). Additionally it allows simple substitutions of
 it's services. This is convenient for unit tests which can swap individual services by
 face or mock objects as it sees fit. To return to factory default setup, send
 @c restoreDefaultServices() message.

 Note that this class provides services to all layers of the application - model, view
 and controller. This breaks a bit the boundary of where this object really belongs,
 however this makes the implementation much simpler and represents no real disadvantage.
 */
@interface GBServiceProvider : NSObject
{
	NSDictionary* debuggingOptions;
	NSString* applicationName;
	NSNotificationCenter* notificationCenter;
	NSFileManager* fileManager;
	NSWorkspace* workspace;
}

///---------------------------------------------------------------------------------------
/// @name Initialization & disposal
///---------------------------------------------------------------------------------------

/** Restores default services.

 Sending this message resets all services the class provides to default ones. This
 message is sent when the object is initialized. It is not necessary to send it otherwise
 in production code, however it might be handy while coding unit tests.
 */
- (void) restoreDefaultServices;

///---------------------------------------------------------------------------------------
/// @name Application specific services
///---------------------------------------------------------------------------------------

/** Returns debugging options dictionary.

 Debugging options dictionary contains data read from debugging options plist file from
 the location returned from @c applicationSupportFolder(). This file can be used during
 development and debugging to change various parameters of the application such as
 preventing system items removal, execution etc. The file is also useful for testing
 application. The name of the file depends on the build type:

 - @c DebuggingOptionsDebug.plist for debug builds and
 - @c DebuggingOptionsRelease.plist for release builds.

 If the file doesn't exist or application support folder doesn't exist, an empty
 dictionary is created and returned. The dictionary is created and read from debugging
 options file when the message is sent for the first time. To simplify debugging options
 handling in the application, see @c NSDictionary(DebuggingOptions) and
 @c NSMutableDictionary(DebuggingOptions) categories.

 @warning @b Important: Due to the fact how @c NSDictionary handles non-existing values,
	it is important to design all options so that non-existent option would cause the
	application to handle corresponding actions normally. For boolean options this means
	that their positive value would switch on their corresponding debug mode.

 @warning @b Note: Note that the dictionary data is read from debugging options file on
	the first usage (or as long as the value is @c nil), so altering options file while
	application is running will not alter the dictionary returned from this property!
	This should not present any obstacle, but bear in mind.
 */
@property (retain) NSDictionary* debuggingOptions;

/** Returns the application name.

 This value is read from main bundle's info.plist @c BundleName value by default, however
 it's possible to change it from outside the class if needed.

 @see applicationSupportFolder
 */
@property (retain) NSString* applicationName;

/** Returns the application wide support folder.

 Note that this only returns the path to the application support folder, it doesn't
 create it! To do, so send @c createApplicationSupportFolder:() message to the receiver.
 Also note that this value depends on applicationName() value and cannot be changed
 from outside the class!

 @see applicationName
 @see createApplicationSupportFolder:
 */
@property (readonly) NSString* applicationSupportFolder;

/** Creates the application support folder.

 If creation is succesful, @c YES is returned, otherwise @c NO is returned and the error
 description is passed through the error parameter.

 @param error If creation fails, error is returned here.
 @return Returns @c YES if creation is succesful, @c NO otherwise.
 */
- (BOOL) createApplicationSupportFolder:(NSError**)error;

///---------------------------------------------------------------------------------------
/// @name Foundation & AppKit services
///---------------------------------------------------------------------------------------

/** The application's @c NSNotificationCenter. */
@property (retain) NSNotificationCenter* notificationCenter;

/** The application's @c NSFileManager. */
@property (retain) NSFileManager* fileManager;

/** the application's @c NSWorkspace. */
@property (retain) NSWorkspace* workspace;

@end
