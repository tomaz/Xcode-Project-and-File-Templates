//
//  LogEntry.h
//  BHLogging
//
//  Created by Eric Baur on 11/19/06.
//  Copyright 2006 Eric Shore Baur. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BHLogging.h"

@interface LogEntry : NSManagedObject {

}

- (NSString *)logLevelString;
- (NSColor *)color;

@end
