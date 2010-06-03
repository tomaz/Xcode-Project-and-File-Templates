//
//  GBViewController.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "XSViewController.h"
#import "GBWindowController.h"

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
/** Implements basic, application-wide view controller functionality.
 */
@interface GBViewController : XSViewController <GBDynamicLogger>
{
	GBViewController* activeViewController;
	NSView* firstKeyView;
	NSView* lastKeyView;
}

///---------------------------------------------------------------------------------------
/// @name View hierarchy support
///---------------------------------------------------------------------------------------

/** Sent just prior the view controller will become active controller for parent view or
 window controller.
 */
- (void) controllerWillBecomeActive;

/** Sent after the view controller did resign active status for parent view or window
 controller.
 */
- (void) controllerDidResignActive;

/** Changes this controller's content view to the given controller one and assigns the
 given controller as active view controller.

 @param controller @c GBViewController to make active.
 */
- (void) changeContentViewAndActivate:(GBViewController*)controller;

/** Indicates active view controller.

 Note that it's entirely upon subclass to define what is the notion of active view controller
 for it. In most circumstances, this is used for view controllers that handle multiple
 subviews switching in and out where only one view is active at the time. This value is
 not used otherwise, except for notifying about various events.
 */
@property (assign) GBViewController* activeViewController;

/** Returns parent @c WindowControllerBase instance.

 This is just a helper that converts @c XSWindowController to @c WindowControllerBase.
 */
@property (readonly) GBWindowController* parentWindowController;

///---------------------------------------------------------------------------------------
/// @name Tab order support
///---------------------------------------------------------------------------------------

/** Specifies the first key view of the assigned view.

 @see lastKeyView
 */
@property (retain) IBOutlet NSView* firstKeyView;

/** Specifies the last key view of the assigned view.

 @see firstKeyView
 */
@property (retain) IBOutlet NSView* lastKeyView;

@end
