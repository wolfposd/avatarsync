//
//  Crypto.h
//  AvatarSync
//
//  Created by Wolf Posdorfer on 25.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Crypto : NSObject

+ (NSString*)md5HexDigest:(NSString*)input;

@end
