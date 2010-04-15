//
//  LogClass.m
//  BHLogging
//
//  Created by Eric Baur on 2/14/08.
//  Copyright 2008 Eric Shore Baur. All rights reserved.
//

#import "LogClass.h"

@implementation LogClass

- (NSDictionary *)displayDictionary
{
	return [NSDictionary dictionary];
}

@dynamic displayBitmask;

@dynamic displaysDebug;
@dynamic displaysEntry;
@dynamic displaysError;
@dynamic displaysExit;
@dynamic displaysInfo;
@dynamic displaysWarning;

- (BOOL)displaysDebug 
{
    BOOL tmpValue;
    
    [self willAccessValueForKey:@"displaysDebug"];
    tmpValue = ( [[self displayBitmask] intValue] & BHLoggerError );
    [self didAccessValueForKey:@"displaysDebug"];
    
    return tmpValue;
}

- (void)setDisplaysDebug:(BOOL)value 
{
    [self willChangeValueForKey:@"displaysDebug"];
    [self setDisplayBitmask:[NSNumber numberWithInt:( [[self displayBitmask] intValue] | BHLoggerDebug )] ];
    [self didChangeValueForKey:@"displaysDebug"];
}

- (BOOL)displaysEntry 
{
    BOOL tmpValue;
    
    [self willAccessValueForKey:@"displaysEntry"];
    tmpValue = ( [[self displayBitmask] intValue] & BHLoggerEntry );
    [self didAccessValueForKey:@"displaysEntry"];
    
    return tmpValue;
}

- (void)setDisplaysEntry:(BOOL)value 
{
    [self willChangeValueForKey:@"displaysEntry"];
    [self setDisplayBitmask:[NSNumber numberWithInt:( [[self displayBitmask] intValue] | BHLoggerEntry )] ];
    [self didChangeValueForKey:@"displaysEntry"];
}


- (BOOL)displaysError 
{
    BOOL tmpValue;
    
    [self willAccessValueForKey:@"displaysError"];
    tmpValue = ( [[self displayBitmask] intValue] & BHLoggerError );
    [self didAccessValueForKey:@"displaysError"];
    
    return tmpValue;
}

- (void)setDisplaysError:(BOOL)value 
{
    [self willChangeValueForKey:@"displaysError"];
    [self setDisplayBitmask:[NSNumber numberWithInt:( [[self displayBitmask] intValue] | BHLoggerError )] ];
    [self didChangeValueForKey:@"displaysError"];
}

- (BOOL)displaysExit 
{
    BOOL tmpValue;
    
    [self willAccessValueForKey:@"displaysExit"];
    tmpValue = ( [[self displayBitmask] intValue] & BHLoggerExit );
    [self didAccessValueForKey:@"displaysExit"];
    
    return tmpValue;
}

- (void)setDisplaysExit:(BOOL)value 
{
    [self willChangeValueForKey:@"displaysExit"];
    [self setDisplayBitmask:[NSNumber numberWithInt:( [[self displayBitmask] intValue] | BHLoggerExit )] ];
    [self didChangeValueForKey:@"displaysExit"];
}

- (BOOL)displaysVerbose 
{
    BOOL tmpValue;
    
    [self willAccessValueForKey:@"displaysVerbose"];
    tmpValue = ( [[self displayBitmask] intValue] & BHLoggerVerbose );
    [self didAccessValueForKey:@"displaysVerbose"];
    
    return tmpValue;
}

- (void)setDisplaysVerbose:(BOOL)value 
{
    [self willChangeValueForKey:@"displaysVerbose"];
    [self setDisplayBitmask:[NSNumber numberWithInt:( [[self displayBitmask] intValue] | BHLoggerVerbose )] ];
    [self didChangeValueForKey:@"displaysVerbose"];
}

- (BOOL)displaysInfo 
{
    BOOL tmpValue;
    
    [self willAccessValueForKey:@"displaysInfo"];
    tmpValue = ( [[self displayBitmask] intValue] & BHLoggerInfo );
    [self didAccessValueForKey:@"displaysInfo"];
    
    return tmpValue;
}

- (void)setDisplaysInfo:(BOOL)value 
{
    [self willChangeValueForKey:@"displaysInfo"];
    [self setDisplayBitmask:[NSNumber numberWithInt:( [[self displayBitmask] intValue] | BHLoggerInfo )] ];
    [self didChangeValueForKey:@"displaysInfo"];
}

- (BOOL)displaysNormal 
{
    BOOL tmpValue;
    
    [self willAccessValueForKey:@"displaysNormal"];
    tmpValue = ( [[self displayBitmask] intValue] & BHLoggerNormal );
    [self didAccessValueForKey:@"displaysNormal"];
    
    return tmpValue;
}

- (void)setDisplaysNormal:(BOOL)value 
{
    [self willChangeValueForKey:@"displaysNormal"];
    [self setDisplayBitmask:[NSNumber numberWithInt:( [[self displayBitmask] intValue] | BHLoggerNormal )] ];
    [self didChangeValueForKey:@"displaysNormal"];
}

- (BOOL)displaysWarning 
{
    BOOL tmpValue;
    
    [self willAccessValueForKey:@"displaysWarning"];
    tmpValue = ( [[self displayBitmask] intValue] & BHLoggerWarning );
    [self didAccessValueForKey:@"displaysWarning"];
    
    return tmpValue;
}

- (void)setDisplaysWarning:(BOOL)value 
{
    [self willChangeValueForKey:@"displaysWarning"];
    [self setDisplayBitmask:[NSNumber numberWithInt:( [[self displayBitmask] intValue] | BHLoggerWarning )] ];
    [self didChangeValueForKey:@"displaysWarning"];
}


@end
