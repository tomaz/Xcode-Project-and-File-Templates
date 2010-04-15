//
//  GBNotificationObserverNiceMock.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBNotificationObserverNiceMock.h"

@implementation GBNotificationObserverNiceMock

+ (id) mock
{
	return [[[self alloc] init] autorelease];
}

- (void) invalidate
{
	[expectedName release], expectedName = nil;
	[notification release], notification = nil;
}

- (void) expectNotificationName:(NSString*)name
{
	logDebug(@"Expecting %@...", name);
	expectedName = [name retain];
	posted = NO;
}

- (void) handleNotification:(NSNotification*)n
{
	logNormal(@"Posted %@", n.name);
	if ([expectedName isEqualToString:n.name])
	{
		notification = [n retain];
		posted = YES;
	}
}

- (void) verify
{
	if (!posted)
	{
		[NSException raise:NSInternalInconsistencyException format:@"%@: expected notification was not observed: %@",
		 [self className], expectedName];
	}
}

@synthesize notification;

@end
