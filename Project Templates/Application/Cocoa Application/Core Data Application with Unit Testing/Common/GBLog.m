//
//  GBLog.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBLog.h"

@implementation DDLog (GBLogExtensions) DECLARE_DYNAMIC_LOGGING_CLASS

+ (void) updateLoggingLevelsOfAllClassesWithValue:(NSInteger)value
{
	NSArray* classes = [DDLog registeredClasses];
	[self updateLoggingLevelsForClasses:classes levelValue:value];
}

+ (void) updateLoggingLevelsForClasses:(NSArray*)classes levelValue:(NSInteger)level
{
	// Note that we need to set this class first, otherwise we'll not log anything until
	// we "arrive" in the queue...
	if ([classes containsObject:[self class]]) [self setLogLevel:level forClass:[self class]];
	logDebug(@"Changing logging level of %u classes to %d...", [classes count], level);
	for (Class class in classes)
	{
		[self setLogLevel:level forClass:class];
	}
	logDebug(@"Finished changing logging levels.");
}

@end

#pragma mark -

static NSString* GBLogLevel(DDLogMessage *msg) {
	switch (msg->logFlag)
	{
		case LOG_FLAG_FATAL:	return @"FATAL";
		case LOG_FLAG_ERROR:	return @"ERROR";
		case LOG_FLAG_WARN:		return @"WARN";
		case LOG_FLAG_NORMAL:	return @"NORMAL";
		case LOG_FLAG_INFO:		return @"INFO";
		case LOG_FLAG_VERBOSE:	return @"VERBOSE";
		case LOG_FLAG_DEBUG:	return @"DEBUG";
	}
	return @"UNKNOWN";
}

#define GBLogFile(msg) [msg fileName]
#define GBLogFileExt(msg) [msg fileNameExt]
#define GBLogMessage(msg) msg->logMsg
#define GBLogFunction(msg) msg->function
#define GBLogSource(msg) msg->object ? [msg->object className] : GBLogFile(msg)
#define GBLogLine(msg) msg->lineNumber

@implementation GBSimpleLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
	return [NSString stringWithFormat:@"-%@- %@ %@",
			GBLogSource(logMessage),
			GBLogLevel(logMessage),
			GBLogMessage(logMessage)];
}

@end

@implementation GBFullLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
	return [NSString stringWithFormat:@"%@ %@  [%@ %s] @ %@:%i",
			GBLogLevel(logMessage),
			GBLogMessage(logMessage),
			GBLogSource(logMessage),
			GBLogFunction(logMessage),
			GBLogFileExt(logMessage),
			GBLogLine(logMessage)];
}

@end
