//
//  GBWindowController.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBViewController.h"
#import "GBWindowController.h"

@implementation GBWindowController

#pragma mark Initialization & disposal

- (void) invalidate
{
	self.activeViewController = nil;
}

#pragma mark View hierarhcy handling

- (void) changeContentViewAndActivate:(GBViewController*)controller
{
	logVerbose(@"Changing content view to %@...", [controller className]);

	NSView* parentView = self.window.contentView;
	if (controller) [controller.view setFrame:[parentView bounds]];

	while ([[parentView subviews] count] > 0)
		[[[parentView subviews] objectAtIndex:0] removeFromSuperview];
	if (controller) [parentView addSubview:controller.view];

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

@synthesize activeViewController;

@end
