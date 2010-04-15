//
//  NSObject+GBObject.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBModelController.h"
#import "GBServiceProvider.h"
#import "GBDatabaseProvider.h"
#import "NSObject+GBObject.h"

@implementation NSObject (GBObject)

#pragma mark Initialization & disposal

- (void) invalidate
{
}

#pragma mark Various helpers

- (NSString*) logDescription
{
	return [self description];
}

#pragma mark Common application objects

- (GBModelController*) modelController
{
	return [GBModelController sharedGBModelController];
}

- (GBServiceProvider*) serviceProvider
{
	return [self.modelController serviceProvider];
}

- (GBDatabaseProvider*) databaseProvider
{
	return [self.modelController databaseProvider];
}

#pragma mark ServiceProvider foundation & AppKit objects

- (NSNotificationCenter*) notificationCenter
{
	return [self.serviceProvider notificationCenter];
}

- (NSFileManager*) fileManager
{
	return [self.serviceProvider fileManager];
}

- (NSWorkspace*) workspace
{
	return [self.serviceProvider workspace];
}

- (NSUserDefaults*) userDefaults
{
	return [NSUserDefaults standardUserDefaults];
}

#pragma mark NSError helpers

- (NSError*) errorWithCode:(NSInteger)code
			   description:(NSString*)description
			 failureReason:(NSString*)reason
{
	return [self errorWithCode:code description:description failureReason:reason details:nil];
}

- (NSError*) errorWithCode:(NSInteger)code
			   description:(NSString*)description
			 failureReason:(NSString*)reason
				   details:(NSArray*)details
{
	NSMutableDictionary* info = [NSMutableDictionary dictionary];
	[info setObject:description forKey:NSLocalizedDescriptionKey];
	if (reason) [info setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
	if (details) [info setObject:details forKey:NSDetailedErrorsKey];
	return [NSError errorWithDomain:@"___PROJECTNAME___" code:code userInfo:info];
}

- (NSError*) detailedErrorWithCode:(NSInteger)code
					   description:(NSString*)description
					 failureReason:(NSString*)reason
						   details:(NSArray*)details
{
	if (details == nil || [details count] == 0)
	{
		return [self errorWithCode:code description:description failureReason:reason];
	}
	if ([details count] == 1)
	{
		return [details objectAtIndex:0];
	}
	return [self errorWithCode:code description:description failureReason:reason details:details];
}

@end
