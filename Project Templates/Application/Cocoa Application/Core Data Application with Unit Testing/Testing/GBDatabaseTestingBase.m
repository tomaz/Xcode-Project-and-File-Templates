//
//  GBDatabaseTestingBase.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBDatabaseTestingBase.h"

@implementation GBDatabaseTestingBase

#pragma mark Setup & tear down

- (void) setUp
{
	registry = [[GBTestObjectsRegistry alloc] init];
	[self injectInMemoryDatabaseProvider];
}

- (void) tearDown
{
	[self restoreOriginalDatabaseProvider];
	[registry invalidate], registry = nil;
}

#pragma mark Database handling

- (void) injectInMemoryDatabaseProvider
{
	logNormal(@"Injecting in-memory database provider...");
	[GBModelController sharedGBModelController].databaseProvider = [[GBDatabaseProvider alloc] initWithInMemoryStoreType];
}

- (void) restoreOriginalDatabaseProvider
{
	logNormal(@"Restoring original database provider...");
	[GBModelController sharedGBModelController].databaseProvider = nil;
}

@end
