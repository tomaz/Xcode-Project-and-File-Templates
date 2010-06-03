//
//  NSUserDefaults+___PROJECTNAMEASIDENTIFIER___Defaults.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "NSUserDefaults+___PROJECTNAMEASIDENTIFIER___Defaults.h"

@implementation NSUserDefaults (___PROJECTNAMEASIDENTIFIER___Defaults)

#pragma mark User preferences settings

- (NSInteger) loggingDefaultClassesLoggingLevel
{
	NSString* value = [self stringForKey:@"LoggingDefaultClassesLoggingLevel"];
	if ([value isEqualToString:@"fatal"]) return LOG_LEVEL_FATAL;
	if ([value isEqualToString:@"error"]) return LOG_LEVEL_ERROR;
	if ([value isEqualToString:@"warn"]) return LOG_LEVEL_WARN;
	if ([value isEqualToString:@"normal"]) return LOG_LEVEL_NORMAL;
	if ([value isEqualToString:@"info"]) return LOG_LEVEL_INFO;
	if ([value isEqualToString:@"verbose"]) return LOG_LEVEL_VERBOSE;
	if ([value isEqualToString:@"debug"]) return LOG_LEVEL_DEBUG;
	return LOG_LEVEL_INFO;
}
- (void) setLoggingDefaultClassesLoggingLevel:(NSInteger)value
{
	NSString* defaultsValue = nil;
	switch (value) 
	{
		case LOG_LEVEL_FATAL:	defaultsValue = @"fatal"; break;
		case LOG_LEVEL_ERROR:	defaultsValue = @"error"; break;
		case LOG_LEVEL_WARN:	defaultsValue = @"warn"; break;
		case LOG_LEVEL_NORMAL:	defaultsValue = @"normal"; break;
		case LOG_LEVEL_INFO:	defaultsValue = @"info"; break;
		case LOG_LEVEL_VERBOSE:	defaultsValue = @"verbose"; break;
		case LOG_LEVEL_DEBUG:	defaultsValue = @"debug"; break;
		default:				defaultsValue = @"info"; break;
	}
	[self setObject:defaultsValue forKey:@"LoggingDefaultClassesLoggingLevel"];
}

- (BOOL) loggingUseVerboseLogMessageFormat
{
	return [self boolForKey:@"LoggingUseVerboseLogMessageFormat"];
}
- (void) loggingUseVerboseLogMessageFormat:(BOOL)value
{
	[self setBool:value forKey:@"LoggingUseVerboseLogMessageFormat"];
}

@end
