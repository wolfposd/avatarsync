//
// AvatarSync
// Copyright (C) 2014-2015  Wolf Posdorfer
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
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
