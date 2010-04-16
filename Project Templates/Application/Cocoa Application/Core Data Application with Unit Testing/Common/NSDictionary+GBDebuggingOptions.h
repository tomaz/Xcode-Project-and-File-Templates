//
//  NSDictionary+GBDebuggingOptions.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSDictionary (GBDebuggingOptions)

- (BOOL) canAddObjectsToDatabase;
- (BOOL) canRemoveObjectsFromDatabase;

@end

@interface NSMutableDictionary (GBDebuggingOptions)

- (void) setCanAddObjectsToDatabase:(BOOL)value;
- (void) setCanRemoveObjectsFromDatabase:(BOOL)value;

@end
