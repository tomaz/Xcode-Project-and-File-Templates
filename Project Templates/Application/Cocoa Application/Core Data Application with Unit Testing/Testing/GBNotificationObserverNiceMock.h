//
//  GBNotificationObserverNiceMock.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Allows testing specific notifications without caring if any other notification is posted.
@interface GBNotificationObserverNiceMock : NSObject <GBDynamicLogger>
{
	NSString* expectedName;
	NSNotification* notification;
	BOOL posted;
}

+ (id) mock;
- (void) expectNotificationName:(NSString*)name;
- (void) verify;
@property (readonly) NSNotification* notification;

@end
