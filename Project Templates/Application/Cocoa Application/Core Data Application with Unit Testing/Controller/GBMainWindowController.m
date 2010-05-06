//
//  GBMainWindowController.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBMainWindowController.h"

@implementation GBMainWindowController

#pragma mark Initialization & disposal

- (id) init
{
	logDebug(@"Initializing...");
	self = [super initWithWindowNibName:@"MainWindow"];
	return self;
}

- (void) invalidate
{
	logDebug(@"Invalidating...");
	[super invalidate];
}

@end
