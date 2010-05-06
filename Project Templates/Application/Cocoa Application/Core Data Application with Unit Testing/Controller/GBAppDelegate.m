//
//  GBAppDelegate.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GBDatabaseProvider.h"
#import "GBModelController.h"
#import "GBMainWindowController.h"
#import "GBAppDelegate.h"

@interface GBAppDelegate ()

- (void) terminateWithAlertMessage:(NSString*)message info:(NSString*)info;
@property (readonly) GBMainWindowController* mainWindowController;

@end

#pragma mark -

@implementation GBAppDelegate

#pragma mark Initialization & disposal

+ (void) initialize
{
	NSString* path = [[NSBundle mainBundle] pathForResource:@"FactoryDefaults" ofType:@"plist"];
	if (path)
	{
		NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfFile:path];
		[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
	}
}

- (void) invalidate
{
	logDebug(@"Invalidating...");
}

#pragma mark User actions

- (IBAction) saveAction:(id)sender
{
	logNormal(@"Saving...");
	[self.databaseProvider save];
}

#pragma mark NSApplication delegate callbacks

- (void) applicationDidFinishLaunching:(NSNotification*)notification
{
	logInit(@"Initializing logging system...");
	logNormal(@"Application did finish launching...");
	self.databaseProvider.delegate = self;
	[self.mainWindowController showWindow:self];
}

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication*)sender
{
	logInfo(@"Saving before teminating...");
	if (![self.databaseProvider save]) return NSTerminateCancel;
	return NSTerminateNow;
}

- (void) applicationWillTerminate:(NSNotification*)notification
{
	logNormal(@"Terminating...");
	[self invalidate];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
	return YES;
}

#pragma mark User interface handling

- (GBMainWindowController*) mainWindowController
{
	if (mainWindowController) return mainWindowController;
	logInfo(@"Initializing main window controller...");
	mainWindowController = [[GBMainWindowController alloc] init];
	return mainWindowController;
}

#pragma mark Database provider delegate

- (void) databaseProvider:(GBDatabaseProvider*)provider
objectCreationFailedForEntityName:(NSString*)name
				withError:(NSError*)error
{
	logNSError(error, @"Database entity %@ creation failed!", name);
	[NSApp presentError:error];
}

- (void) databaseProvider:(GBDatabaseProvider*)provider
 fetchFailedForEntityName:(NSString*)name
				withError:(NSError*)error
{
	logNSError(error, @"Fetch for entity %@ failed!", name);
	[NSApp presentError:error];
}

- (void) databaseProvider:(GBDatabaseProvider*)provider saveFailedWithError:(NSError*)error
{
	logNSError(error, @"Database save failed!");
	[NSApp presentError:error];
}

- (void) databaseProvider:(GBDatabaseProvider*)provider storeInitFailedWithError:(NSError*)error
{
	logNSError(error, @"Database store initialization failed, terminating!");
	NSString* message = NSLocalizedString(@"Unable to load the application data. Application will quit.",
										  @"Load database error message text");
	NSString* info = NSLocalizedString(@"The data is either corrupt or was created by a newer version of Startupizer. "
									   @"Please contact support to assist with this error.\n\nError: %@",
									   @"Load database error info text");
	NSString* infoText = [NSString stringWithFormat:info, [error localizedDescription]];
	[self terminateWithAlertMessage:message info:infoText];
}

- (void) databaseProvider:(GBDatabaseProvider*)provider storeFolderInitFailedWithError:(NSError*)error
{
	logNSError(error, @"Application support folder creation failed, terminating!");
	NSString* message = NSLocalizedString(@"Unable to create application support folder. Application will quit.",
										  @"Create support folder error message text");
	NSString* info = NSLocalizedString(@"The disk may be full or you don't have permissions to create folder at path %@. "
									   @"Please contact support to assist with this error.\n\nError: %@",
									   @"Create support folder error info text");
	NSString* infoText = [NSString stringWithFormat:info, self.serviceProvider.applicationSupportFolder, [error localizedDescription]];
	[self terminateWithAlertMessage:message info:infoText];
}

- (void) databaseProviderModelInitFailed:(GBDatabaseProvider*)provider
{
	logError(@"Managed object model initialization failed, terminating!");
	NSString* message = NSLocalizedString(@"Could not find a model to generate data from. Application will quit.",
										  @"No model error message text");
	NSString* info = NSLocalizedString(@"The application or one of it's files may be corrupt. "
									   @"Please contact support to assist with this error.",
									   @"No model error info text");
	[self terminateWithAlertMessage:message info:info];
}

- (void) terminateWithAlertMessage:(NSString*)message info:(NSString*)info
{
	NSAlert* alert = [[NSAlert alloc] init];
	[alert setAlertStyle:NSCriticalAlertStyle];
	[alert setMessageText:message];
	if (info) [alert setInformativeText:info];
	[alert addButtonWithTitle:NSLocalizedString(@"Sigh... Understood", @"Terminate alert acknowledge button title")];
	[alert runModal];
	[alert release], alert = nil;
	exit(1);
}

@end
