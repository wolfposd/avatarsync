//
//  FileLog.h
//  FeedbackBeaconContext
//
//  Created by Wolf Posdorfer on 29.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//



#define LOGLEVEL_DEBUG 3
#define LOGLEVEL_CASUAL 2
#define LOGLEVEL_ERROR 1

#import <Foundation/Foundation.h>

@interface FileLog : NSObject

/**
 *  Writes the String to the File Log
 *
 *  @param string any string
 */
//+(void) log:(NSString*) string;


+(void) printLogToConsole;

+(NSString*) getFilePath;

+(void) clear;

+(void) log:(NSString*) string level:(int) loglevel;

+(int) getCurrentLogLevel;

+(NSString*) loglevelasString;


@end
