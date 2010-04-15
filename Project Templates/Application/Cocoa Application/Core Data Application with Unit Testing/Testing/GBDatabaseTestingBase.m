//
//  GBDatabaseTestingBase.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBDatabaseTester.h"
#import "GBDatabaseTestingBase.h"

@implementation GBDatabaseTestingBase

#pragma mark Setup & tear down

- (void) setUp
{
	registry = [[GBTestObjectsRegistry alloc] init];
	databaseTester = [[GBDatabaseTester alloc] init];
	[databaseTester injectInMemoryDatabaseProvider];
}

- (void) tearDown
{
	[databaseTester restoreOriginalDatabaseProvider];
	[databaseTester invalidate], databaseTester = nil;
	[registry invalidate], registry = nil;
}

@end
