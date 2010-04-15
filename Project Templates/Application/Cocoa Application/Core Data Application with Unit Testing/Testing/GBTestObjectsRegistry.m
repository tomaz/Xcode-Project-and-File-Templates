//
//  GBTestObjectsRegistry.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBTestObjectsRegistry.h"

@implementation GBTestObjectsRegistry

#pragma mark Initialization & disposal

- (void) invalidate
{
	if (autoInvalidateObjects)
	{
		for (id object in autoInvalidateObjects)
		{
			[object invalidate];
		}
		[autoInvalidateObjects removeAllObjects], autoInvalidateObjects = nil;
	}
	if (notificationsObserverObjects)
	{
		for (NSDictionary* data in notificationsObserverObjects)
		{
			id object = [data objectForKey:@"GBObject"];
			id center = [data objectForKey:@"GBCenter"];
			[center removeObserver:object];
		}
		[notificationsObserverObjects removeAllObjects], notificationsObserverObjects = nil;
	}
	[[[GBModelController sharedGBModelController] serviceProvider] restoreDefaultServices];
}

#pragma mark Injection and automation

- (void) registerAutoInvalidateObject:(id)object
{
	if (!autoInvalidateObjects) autoInvalidateObjects = [[NSMutableArray alloc] init];
	[autoInvalidateObjects addObject:object];
}

- (void) registerNotificationObserverObject:(id)object forCenter:(NSNotificationCenter*)center
{
	if (!notificationsObserverObjects) notificationsObserverObjects = [[NSMutableArray alloc] init];
	[notificationsObserverObjects addObject:[NSDictionary dictionaryWithObjectsAndKeys:object, @"GBObject", center, @"GBCenter", nil]];
}

- (void) injectDebuggingOptions:(NSDictionary*)options
{
	[[[GBModelController sharedGBModelController] serviceProvider] setDebuggingOptions:options];
}

#pragma mark Foundation & AppKit objects creation

- (GBKVOObserver*) createKVOObserverForObject:(id)anObject keyPath:(NSString*)aKeyPath
{
	GBKVOObserver* result = [GBKVOObserver observerForObject:anObject keyPath:aKeyPath];
	[self registerAutoInvalidateObject:result];
	return result;
}

- (id) createNotificationObserverMockAndExpect:(NSString*)name
{
	id result = [OCMockObject observerMock];
	if (name)
	{
		NSNotificationCenter* center = [[[GBModelController sharedGBModelController] serviceProvider] notificationCenter];
		[center addMockObserver:result name:name object:nil];
		[[result expect] notificationWithName:name object:[OCMArg any]];
		[self registerNotificationObserverObject:result forCenter:center];
	}
	return result;
}

- (id) createNotificationObserverNiceMockAndExpect:(NSString*)name
{
	if (name)
	{
		id result = [GBNotificationObserverNiceMock mock];
		[result expectNotificationName:name];
		[[[[GBModelController sharedGBModelController] serviceProvider] notificationCenter] addMockObserver:result name:name object:nil];
		return result;
	}
	return [OCMockObject observerMock];
}

- (id) createNotificationCenterMockAndSubstituteRealOne
{
	id result = [OCMockObject mockForClass:[NSNotificationCenter class]];
	[[[GBModelController sharedGBModelController] serviceProvider] setNotificationCenter:result];
	return result;
}

- (id) createWorkspaceMockAndSubstituteRealOne
{
	id result = [OCMockObject partialMockForObject:[[[GBModelController sharedGBModelController] serviceProvider] workspace]];
	[[[GBModelController sharedGBModelController] serviceProvider] setWorkspace:result];
	return result;
}

#pragma mark Error creation

- (NSError*) createDefaultError
{
	return [NSError errorWithDomain:@"Testing" code:0 userInfo:nil];
}

@end
