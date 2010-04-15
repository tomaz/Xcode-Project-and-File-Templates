//
//  BHLog_Viewer_AppDelegate.m
//  BHLog Viewer
//
//  Created by Eric Baur on 11/17/06.
//  Copyright Eric Shore Baur 2006 . All rights reserved.
//

#import "BHLog_Viewer_AppDelegate.h"

#define BH_USE_XML_PERSISTENT_STORE 0

static NSConnection *connection;

@interface BHLog_Viewer_AppDelegate ()

- (void) appendFilterPredicateString:(NSString*)format toString:(NSMutableString*)string;

@end


@implementation BHLog_Viewer_AppDelegate

+ (void)initialize
{
	NSLog( @"BHLog Viewer initialize" );
	
}

- (void)awakeFromNib
{
	NSSortDescriptor *sortDescriptor;
	
	sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"entrytime" ascending:YES] autorelease];
	[logEntriesArrayController setSortDescriptors:[NSArray arrayWithObject:sortDescriptor] ];
	
	sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"dateentered" ascending:YES] autorelease];
	[applicationsArrayController setSortDescriptors:[NSArray arrayWithObject:sortDescriptor] ];
	
	sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
	[classesArrayController setSortDescriptors:[NSArray arrayWithObject:sortDescriptor] ];
}

- (id)init
{
	NSLog( @"BHLog_Viewer_AppDelegate init" );
	self = [super init];
	if (self) {	
		//NSConnection *connection;
		connection = [NSConnection defaultConnection];
		[connection setRootObject:self];

		if (![connection registerName:@"BHLogger"]) {
			NSLog( @"registered name 'BHLogger' taken." );
		} else {
			NSLog( @"vended object with name: BHLogger" );
		}
		
		logLevels = [[NSMutableArray alloc] init];
		appObjects = [[NSMutableDictionary alloc] init];
			
		[self setFilterPredicate:nil];		
	}
	return self;
}

- (oneway void)logDetails:(NSDictionary *)detailsDict
{
	NSManagedObject *newLogEntry = [NSEntityDescription
		insertNewObjectForEntityForName:@"LogEntry"
		inManagedObjectContext:[self managedObjectContext]
	];
	
	[newLogEntry setValue:[detailsDict valueForKey:@"entrytime"]	forKey:@"entrytime"];
	[newLogEntry setValue:[detailsDict valueForKey:@"information"]	forKey:@"information"];
	[newLogEntry setValue:[detailsDict valueForKey:@"thread"]		forKey:@"thread"];
	[newLogEntry setValue:[detailsDict valueForKey:@"level"]		forKey:@"logLevel"];
	[newLogEntry setValue:[detailsDict valueForKey:@"filename"]		forKey:@"filename"];
	[newLogEntry setValue:[detailsDict valueForKey:@"lineNumber"]	forKey:@"lineNumber"];
	[newLogEntry setValue:[detailsDict valueForKey:@"method"]		forKey:@"method"];

	NSString *guid = [detailsDict valueForKey:@"guid"];
	
	NSManagedObject *appObject = [appObjects objectForKey:guid];
	if (!appObject) {
		appObject = [NSEntityDescription
			insertNewObjectForEntityForName:@"LogApplication"
			inManagedObjectContext:[self managedObjectContext]
		];
		[appObjects setValue:appObject forKey:guid];
		
		[appObject setValue:guid									forKey:@"guid"];
		[appObject setValue:[NSDate date]							forKey:@"dateentered"];
		[appObject setValue:[detailsDict valueForKey:@"processid"]	forKey:@"processid"];
		[appObject setValue:[detailsDict valueForKey:@"name"]		forKey:@"name"];
		[appObject setValue:[detailsDict valueForKey:@"hostname"]	forKey:@"hostname"];
		[appObject setValue:[detailsDict valueForKey:@"osversion"]	forKey:@"osversion"];
	}
	[newLogEntry setValue:appObject forKey:@"application"];
	
	//look up LogClass
	NSManagedObject *classObject;
	NSError *error;
	
	NSFetchRequest *fetchRequest = [[self managedObjectModel]
		fetchRequestFromTemplateWithName:@"classesByName"
		substitutionVariables:[NSDictionary dictionaryWithObject:[detailsDict valueForKey:@"classname"] forKey:@"NAME"]
	];

	NSArray *tempArray = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	if (!tempArray) {
		NSLog( @"error executing fetch request: %@", [fetchRequest description] );
		[[NSApplication sharedApplication] presentError:error];
	}

    if ([tempArray count]) {
		if ( [tempArray count] > 1 )
			NSLog( @"more than one match, using first one" );
		classObject = [tempArray objectAtIndex:0];
    } else {
		classObject = [NSEntityDescription
			insertNewObjectForEntityForName:@"LogClass"
			inManagedObjectContext:[self managedObjectContext]
		];
		[classObject setValue:[detailsDict valueForKey:@"classname"] forKey:@"name"];
		[classObject setValue:[NSNumber numberWithBool:YES] forKey:@"shouldDisplay"];
	}
	[newLogEntry setValue:classObject forKey:@"logClass"];
	
	[self refreshLog:self];
}

- (IBAction)refreshLog:(id)sender
{
	[logEntriesArrayController rearrangeObjects];	
	[logEntriesArrayController setSelectionIndex:[[logEntriesArrayController arrangedObjects] count] - 1 ];
}

- (IBAction)removeAllData:(id)sender
{
	NSAlert* alert = [[NSAlert alloc] init];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert setMessageText:@"Are you sure you want to delete sessions and classes from database?"];
	[alert setInformativeText:@"Deleted records cannot be restored! Instead of deleting everything, you may choose to keep last session and classes."];
	[alert addButtonWithTitle:@"Delete everything"];
	[alert addButtonWithTitle:@"Keep last session"];
	[alert addButtonWithTitle:@"Cancel"];
	switch ([alert runModal]) 
	{
		case NSAlertFirstButtonReturn:
			[classesArrayController removeObjects:[classesArrayController arrangedObjects]];
			[applicationsArrayController removeObjects:[applicationsArrayController arrangedObjects]];
			break;
		case NSAlertSecondButtonReturn:
			while ([[applicationsArrayController arrangedObjects] count] > 1)
			{
				[applicationsArrayController removeObjectAtArrangedObjectIndex:0];
			}
			break;
	}
	[alert release];
}

- (NSPredicate *)filterPredicate
{
	return filterPredicate;
}

- (void)setFilterPredicate:(NSPredicate *)newFilterPredicate
{
	[self willChangeValueForKey:@"filterPredicate"];
	[filterPredicate release];
	if ( newFilterPredicate ) {
		filterPredicate = [newFilterPredicate retain];
	} else {
		filterPredicate = [[NSPredicate predicateWithFormat:@"logClass.shouldDisplay == 1"] retain];
	}
	[self didChangeValueForKey:@"filterPredicate"];
}

- (IBAction)checkAllClasses:(id)sender
{
	NSEnumerator *en = [[classesArrayController arrangedObjects] objectEnumerator];
	NSManagedObject *tempObject;
	while ( tempObject=[en nextObject] ) {
		[tempObject setValue:[NSNumber numberWithBool:YES] forKey:@"shouldDisplay"];
	}
	[self refreshLog:self];
}

- (IBAction)uncheckAllClasses:(id)sender
{
	NSEnumerator *en = [[classesArrayController arrangedObjects] objectEnumerator];
	NSManagedObject *tempObject;
	while ( tempObject=[en nextObject] ) {
		[tempObject setValue:[NSNumber numberWithBool:NO] forKey:@"shouldDisplay"];
	}
	[self refreshLog:self];
}

- (IBAction)updateFilterPredicate:(id)sender
{
	NSMutableString* filter = [NSMutableString string];
	
	if ([filterErrorsButton state] == NSOnState)
		[self appendFilterPredicateString:[NSString stringWithFormat:@"logLevel == %u", BHLoggerError] toString:filter];
	if ([filterWarningsButton state] == NSOnState)
		[self appendFilterPredicateString:[NSString stringWithFormat:@"logLevel == %u", BHLoggerWarning] toString:filter];
	if ([filterNormalButton state] == NSOnState)
		[self appendFilterPredicateString:[NSString stringWithFormat:@"logLevel == %u", BHLoggerNormal] toString:filter];
	if ([filterInfoButton state] == NSOnState)
		[self appendFilterPredicateString:[NSString stringWithFormat:@"logLevel == %u", BHLoggerInfo] toString:filter];
	if ([filterVerboseButton state] == NSOnState)
		[self appendFilterPredicateString:[NSString stringWithFormat:@"logLevel == %u", BHLoggerVerbose] toString:filter];
	if ([filterDebugButton state] == NSOnState)
		[self appendFilterPredicateString:[NSString stringWithFormat:@"logLevel == %u", BHLoggerDebug] toString:filter];
	if ([filterEntryButton state] == NSOnState)
		[self appendFilterPredicateString:[NSString stringWithFormat:@"logLevel == %u", BHLoggerEntry] toString:filter];
	if ([filterExitButton state] == NSOnState)
		[self appendFilterPredicateString:[NSString stringWithFormat:@"logLevel == %u", BHLoggerExit] toString:filter];
	
	if ([filter length] > 0)
	{
		[filter insertString:@"(" atIndex:0];
		[filter appendString:@") and "];
	}
	
	[filter appendString:@"logClass.shouldDisplay==1"];
	[self setFilterPredicate:[NSPredicate predicateWithFormat:filter]];
}

- (void) appendFilterPredicateString:(NSString*)format toString:(NSMutableString*)string
{
	if ([string length] > 0) [string appendString:@" or "];
	[string appendString:format];
}

#pragma mark -
#pragma mark Default methods

/**
    Returns the support folder for the application, used to store the Core Data
    store file.  This code uses a folder named "BHLog_Viewer" for
    the content, either in the NSApplicationSupportDirectory location or (if the
    former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportFolder {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"BHLog Viewer"];
}


/**
    Creates, retains, and returns the managed object model for the application 
    by merging all of the models found in the application bundle and all of the 
    framework bundles.
 */
 
- (NSManagedObjectModel *)managedObjectModel {

    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    NSMutableSet *allBundles = [[NSMutableSet alloc] init];
    [allBundles addObject: [NSBundle mainBundle]];
    [allBundles addObjectsFromArray: [NSBundle allFrameworks]];
    
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles: [allBundles allObjects]] retain];
    [allBundles release];
    
    return managedObjectModel;
}


/**
    Returns the persistent store coordinator for the application.  This 
    implementation will create and return a coordinator, having added the 
    store for the application to it.  (The folder for the store is created, 
    if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {

    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }

    NSFileManager *fileManager;
    NSString *applicationSupportFolder = nil;
    NSURL *url;
    NSError *error;
    
    fileManager = [NSFileManager defaultManager];
    applicationSupportFolder = [self applicationSupportFolder];
    if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
		[fileManager createDirectoryAtPath:applicationSupportFolder 
			   withIntermediateDirectories:YES 
								attributes:nil 
									 error:nil];
    }
    
	NSString* storeFile;
	NSString* storeType;
#if BH_USE_XML_PERSISTENT_STORE
	storeFile = @"BHLog Viewer.xml";
	storeType = NSXMLStoreType;
#else
	storeFile = @"Sessions.bhlogdata";
	storeType = NSSQLiteStoreType;
#endif
    url = [NSURL fileURLWithPath: [applicationSupportFolder stringByAppendingPathComponent: storeFile]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil URL:url options:nil error:&error]){
        [[NSApplication sharedApplication] presentError:error];
    }    

    return persistentStoreCoordinator;
}


/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
 
- (NSManagedObjectContext *) managedObjectContext {

    if (managedObjectContext != nil) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}


/**
    Returns the NSUndoManager for the application.  In this case, the manager
    returned is that of the managed object context for the application.
 */
 
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}


/**
    Performs the save action for the application, which is to send the save:
    message to the application's managed object context.  Any encountered errors
    are presented to the user.
 */
 
- (IBAction) saveAction:(id)sender {

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}


/**
    Implementation of the applicationShouldTerminate: method, used here to
    handle the saving of changes in the application managed object context
    before the application terminates.
 */
 
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    NSError *error;
    int reply = NSTerminateNow;
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext commitEditing]) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
				
                // This error handling simply presents error information in a panel with an 
                // "Ok" button, which does not include any attempt at error recovery (meaning, 
                // attempting to fix the error.)  As a result, this implementation will 
                // present the information to the user and then follow up with a panel asking 
                // if the user wishes to "Quit Anyway", without saving the changes.

                // Typically, this process should be altered to include application-specific 
                // recovery steps.  

                BOOL errorResult = [[NSApplication sharedApplication] presentError:error];
				
                if (errorResult == YES) {
                    reply = NSTerminateCancel;
                } 

                else {
					
                    int alertReturn = NSRunAlertPanel(nil, @"Could not save changes while quitting. Quit anyway?" , @"Quit anyway", @"Cancel", nil);
                    if (alertReturn == NSAlertAlternateReturn) {
                        reply = NSTerminateCancel;	
                    }
                }
            }
        } 
        
        else {
            reply = NSTerminateCancel;
        }
    }
    
    return reply;
}


/**
    Implementation of dealloc, to release the retained variables.
 */
 
- (void) dealloc {

    [managedObjectContext release], managedObjectContext = nil;
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    [managedObjectModel release], managedObjectModel = nil;
    [super dealloc];
}


@end
