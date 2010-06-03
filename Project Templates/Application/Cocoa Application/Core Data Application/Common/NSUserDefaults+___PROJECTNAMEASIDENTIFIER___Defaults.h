//
//  NSUserDefaults+___PROJECTNAMEASIDENTIFIER___Defaults.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
/** Implements simple accessors for ___PROJECTNAMEASIDENTIFIER___ user defaults.
 */
@interface NSUserDefaults (___PROJECTNAMEASIDENTIFIER___Defaults)

///---------------------------------------------------------------------------------------
/// @name User preferences options
///---------------------------------------------------------------------------------------

/** Specifies whether we should use verbose log messages format or not. Verbose format
 includes method name and line number. Note that changing this value doesn't update
 the actual format, only the user defaults setting! */
@property (assign) BOOL loggingUseVerboseLogMessageFormat;

/** Specifies the common logging level for all loggers. Note that changing this value
 doesn't update the actual logging levels of the classes, only user default setting! */
@property (assign) NSInteger loggingDefaultClassesLoggingLevel;

@end
