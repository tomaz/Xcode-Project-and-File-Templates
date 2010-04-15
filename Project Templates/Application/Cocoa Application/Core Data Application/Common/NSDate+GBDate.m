//
//  NSDate+GBDate.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (C) ___YEAR___, ___ORGANIZATIONNAME___. All rights reserved.
//

#import "NSDate+GBDate.h"

@implementation NSDate (GBDate)

- (NSString*) dateStringWithStyle:(NSDateFormatterStyle)style
{
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:style];
    return [formatter stringFromDate:self];
}

- (NSString*) timeStringWithStyle:(NSDateFormatterStyle)style
{
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeStyle:style];
    return [formatter stringFromDate:self];
}

- (NSString*) dateStringWithProjectStyle
{
	return [self dateStringWithStyle:NSDateFormatterMediumStyle];
}

- (NSString*) timeStringWithProjectStyle
{
	return [self timeStringWithStyle:NSDateFormatterShortStyle];
}

- (NSString*) dateTimeStringWithProjectStyle
{
	return [NSString stringWithFormat:@"%@ %@", [self dateStringWithProjectStyle], [self timeStringWithProjectStyle]];
}

@end
