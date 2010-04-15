//
//  BHLogger.h
//  BHLogger
//
//  Created by Eric Baur on 6/13/06.
//  Copyright 2006 Eric Shore Baur. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BHLogger.h"

#define BHLoggerError	1
#define BHLoggerWarning	2
#define BHLoggerNormal	4
#define BHLoggerInfo	8
#define BHLoggerVerbose	16
#define BHLoggerDebug	32
#define BHLoggerEntry	64
#define BHLoggerExit	128

#define BHLoggerProduction		BHLoggerError | BHLoggerWarning | BHLoggerNormal
#define BHLoggerStandard		BHLoggerProduction | BHLoggerInfo
#define BHLoggerExtended		BHLoggerStandard | BHLoggerEntry | BHLoggerExit
#define BHLoggerAll				0xFFFF	// Include all future flags as well...

#define BHLoggerErrorString		@"ERROR"
#define BHLoggerWarningString	@"WARNING"
#define BHLoggerDebugString		@"DEBUG"
#define BHLoggerVerboseString	@"VERBOSE"
#define BHLoggerInfoString		@"INFO"
#define BHLoggerNormalString	@"NORMAL"
#define BHLoggerEntryString		@"ENTRY"
#define BHLoggerExitString		@"EXIT"

#define BHLoggerErrorColor		[NSColor redColor]
#define BHLoggerWarningColor	[NSColor orangeColor]
#define BHLoggerDebugColor		[NSColor lightGrayColor]
#define BHLoggerVerboseColor	[NSColor grayColor]
#define BHLoggerInfoColor		[NSColor darkGrayColor]
#define BHLoggerNormalColor		[NSColor blackColor]
#define BHLoggerEntryColor		[NSColor blueColor]
#define BHLoggerExitColor		[NSColor purpleColor]

#define LOGA(level,string,...)	[BHLogger log:[NSString stringWithFormat:string,##__VA_ARGS__] forObject:self method:_cmd filename:__FILE__ lineNumber:__LINE__ as:level];
#define LOGB(level,string)		[BHLogger log:string forObject:self method:_cmd filename:__FILE__ lineNumber:__LINE__ as:level];

#define ERROR(string,...)	LOGA(BHLoggerError,string,##__VA_ARGS__);
#define WARNING(string,...)	LOGA(BHLoggerWarning,string,##__VA_ARGS__);
#define DEBUG(string,...)	LOGA(BHLoggerDebug,string,##__VA_ARGS__);
#define VERBOSE(string,...)	LOGA(BHLoggerVerbose,string,##__VA_ARGS__);
#define INFO(string,...)	LOGA(BHLoggerInfo,string,##__VA_ARGS__);
#define NORMAL(string,...)	LOGA(BHLoggerNormal,string,##__VA_ARGS__);
#define ENTRY				LOGB(BHLoggerEntry,nil);
#define EXIT				LOGB(BHLoggerExit,nil);
#define RETURN(string,...)	LOGA(BHLoggerExit,string,##__VA_ARGS__];

// This needs to be called so that logging is initialized, otherwise it only works with original macros above!
// Note that desired level is ignored if log viewer is detected - logging is changed to full in such case.
// This is good so that in case a user has problems, we can ship her the viewer and it will automatically
// log the whole thing without forcing her to manually change log mask (probably by using terminal since
// this isn't likely to be implemented as a user preference).
#define logInit(fmt,...) NORMAL(fmt,##__VA_ARGS__);

// Optimized macros that only send message if corresponding level is active. Note that in
// case log viewer is detected all messages are sent, without regard to desired logging level.

// Logs an error message.
#define logError(fmt,...) if (BHIsLevelActive(BHLoggerError)) ERROR(fmt,##__VA_ARGS__)

// Logs a warning message.
#define logWarn(fmt,...) if (BHIsLevelActive(BHLoggerWarning)) WARNING(fmt,##__VA_ARGS__)

// Logs normal message. This can be used for user actions for example.
#define logNormal(fmt,...) if (BHIsLevelActive(BHLoggerNormal)) NORMAL(fmt,##__VA_ARGS__)

// Logs info message. This can be used to log messages that help understand how user 
// actions are divided into steps.
#define logInfo(fmt,...) if (BHIsLevelActive(BHLoggerInfo)) INFO(fmt,##__VA_ARGS__)

// Logs verbose message. This helps in further refining info level steps, especially
// larger ones.
#define logVerbose(fmt,...) if (BHIsLevelActive(BHLoggerVerbose)) VERBOSE(fmt,##__VA_ARGS__)

// Logs debug message. This can be used for logging really low level stuff that can help
// track bugs or provide really extensive information of how an application is running.
// Object initialization or disposal is a good candidate for these.
#define logDebug(fmt,...) if (BHIsLevelActive(BHLoggerDebug)) DEBUG(fmt,##__VA_ARGS__)

// Logs method entry point.
#define logEntry if (BHIsLevelActive(BHLoggerEntry)) ENTRY

// Logs method exit point.
#define logExit if (BHIsLevelActive(BHLoggerExit)) EXIT

// Logs method exit point with a message. This is essentially the same as logExit,
// except it allows passing it custom message.
#define logReturn(fmt,...) if (BHIsLevelActive(BHLoggerExit) RETURN(fmt,##__VA_ARGS__)

// Helper macros for higher level logging.
#define LOG_ERROR(prefix,error) logError(@"%@%@ #%d: %@", prefix, [error domain], [error code], [error localizedDescription]);
#define logNSError(error,message,...) if (BHIsLevelActive(BHLoggerError)) { \
	ERROR(message,##__VA_ARGS__); \
	NSError* err = error; \
	while (err) { \
		LOG_ERROR(@"", err); \
		NSDictionary* info = [err userInfo]; \
		if (info) { \
			for (NSError* detail in [info valueForKey:NSDetailedErrorsKey]) { \
				LOG_ERROR(@"- ", detail); \
			} \
			err = [info valueForKey:NSUnderlyingErrorKey]; \
			continue; \
		} \
		break; \
	} \
}
	
@protocol BHLogging

- (oneway void)logDetails:(NSDictionary *)detailsDict;

@end
