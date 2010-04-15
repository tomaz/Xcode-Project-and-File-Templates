//
//  GBKVOObserver.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBKVOObserver.h"

@implementation GBKVOObserver

+ (id) observerForObject:(id)anObject keyPath:(NSString*)aKeyPath
{
	return [[self alloc] initWithObject:anObject keyPath:aKeyPath];
}

- (id) initWithObject:(id)anObject keyPath:(NSString*)aKeyPath
{
	self = [super init];
	if (self)
	{
		observedObject = anObject;
		observedKeyPath = [aKeyPath copy];
		[observedObject addObserver:self forKeyPath:observedKeyPath options:0 context:nil];
	}
	return self;
}

- (void) invalidate
{
	[observedObject removeObserver:self forKeyPath:observedKeyPath];
	observedObject = nil;
	observedKeyPath = nil;
}

- (void) observeValueForKeyPath:(NSString*)keyPath
					   ofObject:(id)object
						 change:(NSDictionary*)change
						context:(void*)context
{
	self.wasRaised = YES;
}

@synthesize wasRaised;

@end
