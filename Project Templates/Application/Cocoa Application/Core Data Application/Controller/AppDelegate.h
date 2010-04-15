//
//  AppDelegate.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
/** The main application delegate.

 Application delegate is the principal class where the application comes to live and
 the one that binds together the whole user interface with the underlying model.
 */
@interface AppDelegate : NSObject
{
	MainWindowController* mainWindowController;
}

///---------------------------------------------------------------------------------------
/// @name User actions
///---------------------------------------------------------------------------------------

/** Received when the user selects save item from the main menu.￼

 @param sender The object that sent the message.
 */
- (IBAction) saveAction:(id)sender;

@end
