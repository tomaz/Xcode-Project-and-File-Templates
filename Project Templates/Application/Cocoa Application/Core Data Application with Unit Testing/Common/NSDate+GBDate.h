//
//  NSDate+GBDate.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
/** Defines a category with common date handling functionality for the whole application.
 */
@interface NSDate (GBDate)

///---------------------------------------------------------------------------------------
/// @name Date and time formatting
///---------------------------------------------------------------------------------------

/** Converts the receiver to string date representation using the given style.

 @param style The desired date style.
 @return Returns string representation.
 @see timeStringWithStyle:
 */
- (NSString*) dateStringWithStyle:(NSDateFormatterStyle)style;

/** Converts the receiver to string time representation using the given style.

 @param style The desired time style.
 @return Returns string representation.
 @see dateStringWithStyle:
 */
- (NSString*) timeStringWithStyle:(NSDateFormatterStyle)style;

/** Converts the receiver to common application-wide formatted date.

 @return Returns string representation.
 @see timeStringWithProjectStyle
 @see dateTimeStringWithProjectStyle
 */
- (NSString*) dateStringWithProjectStyle;

/** Converts the receiver to common application-wide formatted time.

 @return Returns string representation.
 @see dateStringWithProjectStyle
 @see dateTimeStringWithProjectStyle
 */
- (NSString*) timeStringWithProjectStyle;

/** Converts the receiver to common application-wide formatted date and time.

 @return Returns string representation.
 @see dateStringWithProjectStyle
 @see timeStringWithProjectStyle
 */
- (NSString*) dateTimeStringWithProjectStyle;

@end
