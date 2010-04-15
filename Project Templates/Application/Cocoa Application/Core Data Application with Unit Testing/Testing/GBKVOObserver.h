//
//  GBKVOObserver.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Must send invalidate to remove observer!
@interface GBKVOObserver : NSObject
{
	id observedObject;
	NSString* observedKeyPath;
	BOOL wasRaised;
}

+ (id) observerForObject:(id)anObject keyPath:(NSString*)aKeyPath;
- (id) initWithObject:(id)anObject keyPath:(NSString*)aKeyPath;
@property (assign) BOOL wasRaised;

@end
