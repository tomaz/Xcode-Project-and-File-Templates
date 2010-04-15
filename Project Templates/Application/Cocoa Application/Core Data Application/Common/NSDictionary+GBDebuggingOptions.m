//
//  NSDictionary+GBDebuggingOptions.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "NSDictionary+GBDebuggingOptions.h"

@implementation NSDictionary (DebuggingOptions)

- (BOOL) isEnabled:(NSString*)key
{
	return ![[self objectForKey:key] boolValue];
}

- (BOOL) canAddObjectsToDatabase
{
	return [self isEnabled:@"PreventAddingObjectsToDatabase"];
}

- (BOOL) canRemoveObjectsFromDatabase
{
	return [self isEnabled:@"PreventRemovingObjectsFromDatabase"];
}

@end

#pragma mark -

@implementation NSMutableDictionary (DebuggingOptions)

- (void) setEnabled:(BOOL)value forKey:(NSString*)key
{
	[self setObject:[NSNumber numberWithBool:!value] forKey:key];
}

- (void) setCanAddObjectsToDatabase:(BOOL)value
{
	[self setEnabled:value forKey:@"PreventAddingObjectsToDatabase"];
}

- (void) setCanRemoveObjectsFromDatabase:(BOOL)value
{
	[self setEnabled:value forKey:@"PreventRemovingObjectsFromDatabase"];
}

@end
