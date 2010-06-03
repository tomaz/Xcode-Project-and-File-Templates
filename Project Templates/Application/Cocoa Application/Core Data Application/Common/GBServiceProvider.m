//
//  GBServiceProvider.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBServiceProvider.h"

@implementation GBServiceProvider DECLARE_DYNAMIC_LOGGING_CLASS

#pragma mark Initialization & disposal

- (id) init
{
	logDebug(@"Initializing...");
	self = [super init];
	if (self)
	{
		[self restoreDefaultServices];
	}
	return self;
}

- (void) invalidate
{
	logDebug(@"Invalidating...");
	[self restoreDefaultServices];
}

- (void) restoreDefaultServices
{
	logDebug(@"Restoring default services...");

	NSDictionary* info = [[NSBundle mainBundle] infoDictionary];
	applicationName = [info objectForKey:@"CFBundleName"];
	if (!applicationName) applicationName = [info objectForKey:@"CFBundleExecutable"];

	self.notificationCenter = [NSNotificationCenter defaultCenter];
	self.fileManager = [NSFileManager defaultManager];
	self.workspace = [NSWorkspace sharedWorkspace];
	self.debuggingOptions = nil;
}

#pragma mark Application wide functionality

- (NSDictionary*) debuggingOptions
{
	if (debuggingOptions) return debuggingOptions;
	NSString* path = self.applicationSupportFolder;
	NSString* filename = nil;
#ifdef BUILD_DEBUG
	filename = @"DebuggingOptionsDebug.plist";
#else
	filename = @"DebuggingOptionsRelease.plist";
#endif
	path = [path stringByAppendingPathComponent:filename];
	if ([self.fileManager fileExistsAtPath:path])
	{
		NSURL* url = [NSURL fileURLWithPath:path];
		debuggingOptions = [NSDictionary dictionaryWithContentsOfURL:url];
	}
	else
	{
		debuggingOptions = [NSDictionary dictionary];
	}
	return [debuggingOptions retain];
}

- (NSString*) applicationSupportFolder
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
	return [basePath stringByAppendingPathComponent:self.applicationName];
}

- (BOOL) createApplicationSupportFolder:(NSError**)error
{
	NSString* path = self.applicationSupportFolder;
	if ([self.fileManager fileExistsAtPath:path isDirectory:NULL]) return YES;
	logVerbose(@"Creating application support folder...");
	return [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
}

#pragma mark Properties

@synthesize debuggingOptions;
@synthesize applicationName;
@synthesize notificationCenter;
@synthesize fileManager;
@synthesize workspace;

@end
