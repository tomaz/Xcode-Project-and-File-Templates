//
//  LogClass.h
//  BHLogging
//
//  Created by Eric Baur on 2/14/08.
//  Copyright 2008 Eric Shore Baur. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <BHLogger/BHLogging.h>

@interface LogClass : NSManagedObject
{

}

- (NSDictionary *)displayDictionary;

@property (retain) NSNumber * displayBitmask;

@property BOOL displaysDebug;
@property BOOL displaysEntry;
@property BOOL displaysError;
@property BOOL displaysExit;
@property BOOL displaysVerbose;
@property BOOL displaysInfo;
@property BOOL displaysNormal;
@property BOOL displaysWarning;

@end
/*
@interface LogClass (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber *)primitiveDisplaysDebug;
- (void)setPrimitiveDisplaysDebug:(NSNumber *)value;

- (NSNumber *)primitiveDisplaysEntry;
- (void)setPrimitiveDisplaysEntry:(NSNumber *)value;

- (NSNumber *)primitiveDisplaysError;
- (void)setPrimitiveDisplaysError:(NSNumber *)value;

- (NSNumber *)primitiveDisplaysExit;
- (void)setPrimitiveDisplaysExit:(NSNumber *)value;

- (NSNumber *)primitiveDisplaysInfo;
- (void)setPrimitiveDisplaysInfo:(NSNumber *)value;

- (NSNumber *)primitiveDisplaysWarning;
- (void)setPrimitiveDisplaysWarning:(NSNumber *)value;

@end
*/