//
//  GBDatabaseTester.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBDatabaseProvider.h"
#import "GBModelController.h"
#import "GBDatabaseTester.h"

@implementation GBDatabaseTester

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
