//
//  GBViewController.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBViewController.h"

@implementation GBViewController DECLARE_DYNAMIC_LOGGING_CLASS

#pragma mark Initialization & disposal

- (void) invalidate
{
	logDebug(@"Invalidating...");
	self.activeViewController = nil;
	self.firstKeyView = nil;
	self.lastKeyView = nil;
}

#pragma mark View hierarchy support

- (void) controllerWillBecomeActive
{
}

- (void) controllerDidResignActive
{
}

- (void) changeContentViewAndActivate:(GBViewController*)controller
{
	logVerbose(@"Changing content view to %@...", [controller className]);

	if (controller) [controller.view setFrame:[self.view bounds]];

	while ([[self.view subviews] count] > 0)
		[[[self.view subviews] objectAtIndex:0] removeFromSuperview];
	if (controller) [self.view addSubview:controller.view];

	self.activeViewController = controller;
}

#pragma mark Properties

- (void) setActiveViewController:(GBViewController*)value
{
	if (value != activeViewController)
	{
		[activeViewController controllerDidResignActive];
		activeViewController = value;
		[activeViewController controllerWillBecomeActive];
	}
}

- (GBWindowController*) parentWindowController
{
	return (GBWindowController*)self.windowController;
}

@synthesize activeViewController;
@synthesize firstKeyView;
@synthesize lastKeyView;

@end
