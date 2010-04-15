//
//  GBDatabaseTester.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GBDatabaseTester : NSObject

- (void) injectInMemoryDatabaseProvider;
- (void) restoreOriginalDatabaseProvider;

@end
