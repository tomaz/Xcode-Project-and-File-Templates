//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR», «ORGANIZATIONNAME». All rights reserved.
//

«OPTIONALHEADERIMPORTLINE»
@implementation «FILEBASENAMEASIDENTIFIER»

#pragma mark Initialization & disposal

- (id) initWithWindowController:(GBWindowController*)parent
{
	logDebug(@"Initializing...");
	self = [super initWithNibName:@"ReplaceWithViewNibName!" bundle:nil windowController:parent];
	return self;
}

- (void) invalidate
{
	logDebug(@"Invalidating...");
	[super invalidate];
}

@end
