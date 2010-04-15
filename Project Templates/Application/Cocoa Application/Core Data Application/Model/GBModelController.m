//
//  GBModelController.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "SynthesizeSingleton.h"
#import "GBModelController.h"

@implementation GBModelController

#pragma mark Initialization & disposal

SYNTHESIZE_SINGLETON_FOR_CLASS(GBModelController);

- (id) init
{
	logDebug(@"Initializing...");
	self = [super init];
	return self;
}

#pragma mark Main model objects

- (GBServiceProvider*) serviceProvider
{
	if (serviceProvider) return serviceProvider;
	logDebug(@"Initializing service provider...");
	serviceProvider = [[GBServiceProvider alloc] init];
	return serviceProvider;
}

- (GBDatabaseProvider*) databaseProvider
{
	if (databaseProvider) return databaseProvider;
	logDebug(@"Initializing database provider...");
	databaseProvider = [[GBDatabaseProvider alloc] initWithGBServiceProvider:self.serviceProvider];
	return databaseProvider;
}

#pragma mark Properties

@synthesize serviceProvider;
@synthesize databaseProvider;

@end
