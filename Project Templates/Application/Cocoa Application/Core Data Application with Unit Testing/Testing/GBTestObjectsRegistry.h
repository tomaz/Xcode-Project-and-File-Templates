//
//  GBTestObjectsRegistry.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OCMock/OCMock.h>
#import "DBObjects.h"
#import "GBKVOObserver.h"
#import "GBNotificationObserverNiceMock.h"
#import "GBModelController.h"
#import "GBServiceProvider.h"
#import "GBDatabaseProvider.h"

// Helps auto releasing/invalidating test objects. To use it, initialize in setup and
// send invalidate at teardown, then use creation methods to create objects. All objects
// that need to be invalidated will be so when the registry receives invalidate message.
@interface GBTestObjectsRegistry : NSObject <GBDynamicLogger>
{
	NSMutableArray* autoInvalidateObjects;
	NSMutableArray* notificationsObserverObjects;
}

- (void) registerAutoInvalidateObject:(id)object;
- (void) registerNotificationObserverObject:(id)object forCenter:(NSNotificationCenter*)center;
- (void) injectDebuggingOptions:(NSDictionary*)options;

- (GBKVOObserver*) createKVOObserverForObject:(id)anObject keyPath:(NSString*)aKeyPath;
- (id) createNotificationObserverMockAndExpect:(NSString*)name;
- (id) createNotificationObserverNiceMockAndExpect:(NSString*)name;
- (id) createNotificationCenterMockAndSubstituteRealOne;
- (id) createWorkspaceMockAndSubstituteRealOne;
- (NSError*) createDefaultError;

@end
