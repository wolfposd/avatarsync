//
//  NSString+Base64.h
//  testprojectcommand
//
//  Created by Wolf Posdorfer on 14.11.12.
//  Copyright (c) 2012 Wolf Posdorfer. All rights reserved.
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

@end

