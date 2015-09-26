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

#import <Foundation/Foundation.h>

/**
 *  useful Base64 Additions
 */
@interface NSString (NSStringAdditions)

/**
 *  Encodes a base64 String
 *
 *  @param data Data to be encoded
 *
 *  @return encoded String
 */
+ (NSString *) base64StringFromData: (NSData *)data;


/**
 *  Encodes a base64 String
 *
 *  @param data   Data to be encoded
 *  @param length length of data
 *
 *  @return encoded String
 */
+ (NSString *) base64StringFromData: (NSData *)data length: (int)length;

/**
 *  Decodes from a base64encoded String
 *
 *  @param string String in base64 encoded Format
 *
 *  @return decoded NSData
 */
+ (NSData *) base64DataFromString: (NSString *)string;


/**
 *  Encodes the String to base64
 *
 *  @return encoded String
 */
- (NSString*) base64String;

/**
 *  Decodes the String from base64
 *
 *  @return decoded String
 */
-(NSString*) unbase64String;


-(NSInteger) countOccurencesOfString:(NSString*) needle;

@end

