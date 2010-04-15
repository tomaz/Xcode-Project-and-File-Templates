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

- (id) init
{
	logDebug(@"Initializing...");
	self = [super initWithWindowNibName:@"ReplaceWithWindowNibName!"];
	return self;
}

- (void) invalidate
{
	logDebug(@"Invalidating...");
	[super invalidate];
}

@end
