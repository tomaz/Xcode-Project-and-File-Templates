//
//  LogEntry.m
//  BHLogging
//
//  Created by Eric Baur on 11/19/06.
//  Copyright 2006 Eric Shore Baur. All rights reserved.
//

#import "LogEntry.h"


@implementation LogEntry

#pragma mark -
#pragma mark Standard Accessor methods

- (NSString *)logLevelString
{
	int level = [[self valueForKey:@"logLevel"] intValue];
	NSString *tempString;
	switch (level) {
		case BHLoggerError:
			tempString = BHLoggerErrorString;
			break;
		case BHLoggerWarning:
			tempString = BHLoggerWarningString;
			break;
		case BHLoggerDebug:
			tempString = BHLoggerDebugString;
			break;
		case BHLoggerVerbose:
			tempString = BHLoggerVerboseString;
			break;
		case BHLoggerInfo:
			tempString = BHLoggerInfoString;
			break;
		case BHLoggerNormal:
			tempString = BHLoggerNormalString;
			break;
		case BHLoggerEntry:
			tempString = BHLoggerEntryString;
			break;
		case BHLoggerExit:
			tempString = BHLoggerExitString;
			break;
		default:
			tempString = @"n/a";
	}
	return tempString;
	
	/* return 	[[[NSAttributedString alloc] initWithString:tempString attributes:[NSDictionary
		dictionaryWithObject:[self color] forKey:NSForegroundColorAttributeName]
	] autorelease]; */
}

- (NSString *)fileLocation
{
	NSString *filePath = [self valueForKey:@"filename"];
	NSArray *pathArray = [filePath pathComponents];
	
	return [NSString stringWithFormat:@"%@:%@",
		[pathArray objectAtIndex:[pathArray count]-1],
		[self valueForKey:@"lineNumber"]
	];
}

#pragma mark -
#pragma mark Special Accessor methods

- (NSColor *)color
{
	int level = [[self valueForKey:@"logLevel"] intValue];
	switch (level) {
		case BHLoggerError:		return BHLoggerErrorColor;		break;
		case BHLoggerWarning:	return BHLoggerWarningColor;	break;
		case BHLoggerDebug:		return BHLoggerDebugColor;		break;
		case BHLoggerVerbose:	return BHLoggerVerboseColor;	break;
		case BHLoggerInfo:		return BHLoggerInfoColor;		break;
		case BHLoggerNormal:	return BHLoggerNormalColor;	break;
		case BHLoggerEntry:		return BHLoggerEntryColor;		break;
		case BHLoggerExit:		return BHLoggerExitColor;		break;
		default:				return [NSColor blackColor];
	}
	return [NSColor blackColor];
}

@end
