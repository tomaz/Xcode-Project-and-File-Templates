//
//  GBModelController.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBObjects.h"
#import "GBServiceProvider.h"
#import "GBDatabaseProvider.h"

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
/** Provides access to the application's model.

 This class combines all lower-level model objects and provides entry point for higher
 level objects to either access or modify the model.
 */
@interface GBModelController : NSObject
{
	GBServiceProvider* serviceProvider;
	GBDatabaseProvider* databaseProvider;
}

///---------------------------------------------------------------------------------------
/// @name Initialization & disposal
///---------------------------------------------------------------------------------------

/** Returns the one and only instance of the @c GBModelController.

 The instance is created when the message is sent for the first time. At that time the
 underlying model default model is created as well.

 @return Returns the singleron instance.
 */
+ (GBModelController*) sharedGBModelController;

///---------------------------------------------------------------------------------------
/// @name Model access
///---------------------------------------------------------------------------------------

/** Returns the application's @c GBServiceProvider.

 This value is initialized to default value, but can be changed at any time. This may be
 especially interesting for providing mockups in unit testing.
 */
@property (retain) GBServiceProvider* serviceProvider;

/** Returns the application's @c GBDatabaseProvider.

 This value is initialized to default value, but can be changed at any time. This may be
 especially interesting for providing mockups in unit testing.
 */
@property (retain) GBDatabaseProvider* databaseProvider;

@end
