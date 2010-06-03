//
//  GBWindowController.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "XSWindowController.h"

@class GBViewController;

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
/** Implements basic, application-wide window controller functionality.
 */
@interface GBWindowController : XSWindowController <GBDynamicLogger>
{
	GBViewController* activeViewController;
}

///---------------------------------------------------------------------------------------
/// @name View hierarchy handling
///---------------------------------------------------------------------------------------

/** Changes this controller's content view to the given controller one and assigns the
 given controller as active view controller.

 @param controller @c GBViewController to make active.
 */
- (void) changeContentViewAndActivate:(GBViewController*)controller;

/** Indicates active view controller.

 Note that it's entirely upon subclass to define what is the notion of active view controller
 for it. In most circumstances, this is used for window controllers that handle multiple
 views switching in and out where only one view is active at the time. This value is not
 used otherwise, except for notifying about various events.
 */
@property (assign) GBViewController* activeViewController;

@end
