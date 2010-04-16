//
//  GBDatabaseTestingBase.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import <GHUnit/GHUnit.h>
#import "GBTestObjectsRegistry.h"

@class GBDatabaseTester;

// Automatically injects in-memory store and provides "raw" creation methods suited for
// testing Core Data layer objects. All higher objects testing should instead use
// ModelController creation methods!
@interface GBDatabaseTestingBase : GHTestCase
{
	GBTestObjectsRegistry* registry;
	GBDatabaseTester* databaseTester;
}

- (void) injectInMemoryDatabaseProvider;
- (void) restoreOriginalDatabaseProvider;

@end
